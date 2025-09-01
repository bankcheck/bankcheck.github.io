CREATE OR REPLACE FUNCTION "NHS_ACT_RECORDUNLOCK" (
	i_action       IN VARCHAR2,
	i_LockType     IN VARCHAR2,
	i_LockKey      IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_UsrID        IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN  NUMBER
AS
	o_errcode NUMBER;
	v_rlkid NUMBER;
	v_ComputerName RLock.RlkMac%Type;
	v_record NUMBER;
begin
	o_errmsg := 'OK';
	o_errcode := 0;

	-- trim computer name if too big
	IF LENGTH(i_ComputerName) > 20 THEN
		v_ComputerName := SUBSTR(i_ComputerName, 1, 20);
	ELSE
		v_ComputerName := i_ComputerName;
	END IF;

	SELECT COUNT(1) INTO v_record
	FROM  RLock
	WHERE UPPER(RlkType) = UPPER(i_LockType)
	AND   UPPER(RlkKey)  = UPPER(i_LockKey)
	AND   RlkMac         = v_ComputerName
	AND   UsrID          = i_UsrID;

	IF v_record = 1 THEN
		DELETE FROM RLock
		WHERE UPPER(RlkType) = UPPER(i_LockType)
		AND   UPPER(RlkKey)  = UPPER(i_LockKey)
		AND   RlkMac         = v_ComputerName
		AND   UsrID          = i_UsrID;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
	o_errmsg := i_LockType || ' is unlocked by someone. The lock key is ' || i_LockKey || '. (' || SQLERRM || ')';

	RETURN -999;
end NHS_ACT_RECORDUNLOCK;
/
