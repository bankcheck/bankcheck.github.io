CREATE OR REPLACE FUNCTION "NHS_ACT_RECORDLOCK" (
	i_action       IN VARCHAR2,
	i_LockType     IN VARCHAR2,
	i_LockKey      IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_UsrID        IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_record NUMBER;
	v_lockUsrID RLock.UsrID%Type;
	v_lockUsrName Usr.UsrName%Type;
	v_lockmac RLock.RlkMac%Type;
	v_ComputerName RLock.RlkMac%Type;
begin
	o_errmsg := 'OK';
	o_errcode := 0;

	-- trim computer name if too big
	IF LENGTH(i_ComputerName) > 20 THEN
		v_ComputerName := SUBSTR(i_ComputerName, 1, 20);
	ELSE
		v_ComputerName := i_ComputerName;
	END IF;

	SELECT COUNT(1) INTO v_record FROM RLock WHERE RlkType = i_LockType AND RlkKey = i_LockKey;

	IF v_record = 0 THEN
		INSERT into RLock(
			RlkID,
			UsrID,
			RlkType,
			RlkKey,
			RlkDate,
			RlkMac,
			SteCode
		) VALUES (
			SEQ_RLOCK.NEXTVAL,
			i_UsrID,
			i_LockType,
			i_LockKey,
			SYSDATE,
			v_ComputerName,
			GET_CURRENT_STECODE
		);
	ELSE
		SELECT UsrID, RlkMac INTO v_lockUsrID, v_lockmac FROM RLock WHERE RlkType = i_LockType AND RlkKey = i_LockKey;

		IF i_UsrID != v_lockUsrID THEN
			SELECT COUNT(1) INTO v_record FROM Usr WHERE UsrID = v_lockUsrID;
			-- diff user lock
			IF v_record = 1 THEN
				SELECT UsrName INTO v_lockUsrName FROM Usr WHERE UsrID = v_lockUsrID;
				o_errmsg := i_LockType || ' is locked by ' || v_lockUsrName || ' in pc [' || v_lockmac || ']. The lock key is ' || i_LockKey || '.';
			ELSE
				o_errmsg := i_LockType || ' is locked by ' || v_lockUsrID || ' in pc [' || v_lockmac || ']. The lock key is ' || i_LockKey || '.';
			END IF;
			o_errcode := -1;
		ELSIF v_ComputerName != v_lockmac THEN
			-- same user but different machine lock
			o_errmsg := i_LockType || ' is locked by same user but different machine [' || v_lockmac || ']. The lock key is ' || i_LockKey || '.';
			o_errcode := -1;
		ELSIF v_ComputerName = v_lockmac THEN
			-- same user and machine lock
			o_errmsg := i_LockType || ' is locked by same user. The lock key is ' || i_LockKey || '.';
		END IF;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
	o_errmsg := i_LockType || ' is locked by someone. The lock key is ' || i_LockKey || '. (' || SQLERRM || ')';

	RETURN -999;
end NHS_ACT_RECORDLOCK;
/
