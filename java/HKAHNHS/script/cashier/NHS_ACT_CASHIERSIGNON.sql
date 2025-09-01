CREATE OR REPLACE FUNCTION NHS_ACT_CASHIERSIGNON(
	i_ACTION       IN VARCHAR2,
	i_UserID       IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_Closed       IN VARCHAR2,
	i_Resignon     IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_NOOFREC NUMBER;
	v_CSHCODE VARCHAR2(3);
	v_CSHMAC VARCHAR2(20);
	v_CSHSTS VARCHAR2(1);
	v_CSHODATE DATE;
	v_FillStartTime DATE;
	v_RemoveEndTime VARCHAR2(1);
	v_ComputerName VARCHAR2(20);
	o_errcode NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg  := 'OK';

	-- trim computer name if too big
	IF LENGTH(i_ComputerName) > 20 THEN
		v_ComputerName := SUBSTR(i_ComputerName, 1, 20);
	ELSE
		v_ComputerName := i_ComputerName;
	END IF;

	SELECT COUNT(1) INTO v_NOOFREC FROM Cashier WHERE UsrID = i_UserID;
	IF v_NOOFREC = 0 THEN
		o_errcode := -1;
		o_errmsg := 'You aren''t a cashier!';
		RETURN o_errcode;
	END IF;

	SELECT CshCode, CshMac, CshSts, CshOdate INTO v_CSHCODE, v_CSHMAC, v_CSHSTS, v_CSHODATE FROM Cashier WHERE UsrID = i_UserID;

	IF v_CSHSTS = 'N' THEN
		-- CASHIER_STS_NORMAL
		IF v_CSHMAC != v_ComputerName THEN
			-- Current cashier is logged on another machine
			o_errcode := -1;
			o_errmsg := 'The current user is not logged on as cashier. <font color=red>Reason: the same user was signed on as cashier on another machine (' || v_CSHMAC || ')</font>';
			RETURN o_errcode;
		END IF;
	ELSE
		IF v_CSHSTS = 'O' OR i_Resignon = 'Y' THEN
			-- CASHIER_STS_OFF or Resignon
			IF v_CSHODATE IS NULL THEN
				v_FillStartTime := SYSDATE;
			END IF;
			v_RemoveEndTime := 'Y';
		END IF;

		BEGIN
			IF i_Closed = 'N' THEN
				UPDATE CASHIER
				SET    CshSts  = 'N'	-- CASHIER_STS_NORMAL
				WHERE  CSHCODE = v_CSHCODE;
			END IF;

			UPDATE CASHIER
			SET    CshMac  = v_ComputerName
			WHERE  CSHCODE = v_CSHCODE;

			IF v_CSHSTS = 'C' THEN
				-- CASHIER_STS_CLOSE
				UPDATE CASHIER
				SET CshAdv     = 0,
					CshPayIn   = 0,
					CshPayOut  = 0,
					CshRec     = 0,
					CshChq     = 0,
					CshEps     = 0,
					CshCard    = 0,
					CshOther   = 0,
					CshCRCnt   = 0,
					CshRCnt    = 0,
					CshVCnt    = 0,
					CshATP     = 0,
					CshATPOut  = 0,
					CshChqOut  = 0,
					CshCardOut = 0,
					CshCupOut  = 0,
					CshCupIn   = 0,
					CshOctOut  = 0,
					CshOctIn   = 0,
					CshQROut   = 0,
					CshQRIn    = 0
				WHERE CSHCODE  = v_CSHCODE;

				IF i_Closed = 'Y' THEN
					UPDATE Cashier
					SET CshOdate = null,
						CshFdate = null
					WHERE  CshCode = v_CSHCODE;
				END IF;
			END IF;
		END;
	END IF;

	BEGIN
		IF v_FillStartTime IS NOT NULL THEN
			UPDATE Cashier
			SET    CshOdate = v_FillStartTime
			WHERE  CshCode = v_CSHCODE;
		END IF;

		IF v_RemoveEndTime = 'Y' THEN
			UPDATE Cashier
			SET    CshFdate = NULL
			WHERE  CshCode = v_CSHCODE;
		END IF;
	END;

	IF i_Closed = 'Y' THEN
		o_errmsg := '';
	ELSE
		-- store CshCode for return
		o_errmsg := v_CSHCODE;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := 'Fail to signon as cashier.<br><font color=red>Error Code:' || SQLCODE || '</font>';

	RETURN -999;
END NHS_ACT_CASHIERSIGNON;
/
