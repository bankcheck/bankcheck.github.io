CREATE OR REPLACE FUNCTION "NHS_ACT_REG_CANCEL" (
	v_action    IN VARCHAR2,
	v_regid     IN VARCHAR2,
	v_slpno     IN VARCHAR2,
	v_bedcode   IN VARCHAR2,
	v_UsrID     IN VARCHAR2,
	o_errmsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	v_noOfRec_reg NUMBER;
	v_noOfRec_opn NUMBER;
	v_BkgID NUMBER;
	SCH_CONFIRM VARCHAR(1) := 'F';
	SCH_NORMAL VARCHAR2(1) := 'N';
BEGIN
	v_noOfRec := -1;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_noOfRec_reg FROM REG WHERE regid = TO_NUMBER(v_regid) AND regsts = 'N';
	SELECT COUNT(1) INTO v_noOfRec_opn FROM OPD_PROGRESS_NOTE@CIS WHERE REGID = TO_NUMBER(v_regid);

	IF v_noOfRec_reg = 0 THEN
		ROLLBACK;
		v_noOfRec := -1;
		o_errmsg := 'Fail to cancel registration due to already cancelled.';
	ELSIF v_noOfRec_opn > 0 THEN
		ROLLBACK;
		v_noOfRec := -1;
		o_errmsg := 'Fail to cancel registration due to consulation already started.';
	ELSE
		UPDATE REG
		SET    regsts = 'C'
		WHERE  regid = TO_NUMBER(v_regid);

		UPDATE REG_EXTRA
		SET    MODIFY_DATE = SYSDATE, MODIFY_USER = v_UsrID
		WHERE  regid = TO_NUMBER(v_regid);

		UPDATE Slip SET slpsts = 'R' WHERE slpno = v_slpno;
		IF v_bedcode IS NOT NULL THEN
			UPDATE bed set bedsts = 'F', bedddate = SYSDATE
			WHERE  bedcode = v_bedcode;
		END IF;

		SELECT BkgID INTO v_BkgID FROM REG WHERE regid = TO_NUMBER(v_regid) AND regsts = 'C';
		SELECT count(1) INTO v_noOfRec FROM BOOKING WHERE BKGID = v_BkgID AND BkgSts = SCH_CONFIRM;
		IF v_noOfRec > 0 THEN
			UPDATE BOOKING SET BkgSts = SCH_NORMAL WHERE BKGID = v_BkgID AND BkgSts = SCH_CONFIRM;
			v_noOfRec := NHS_ACT_BOOKING_CANCEL(v_action, v_BkgID, v_UsrID, o_errmsg);
			IF v_noOfRec < 0 THEN
				ROLLBACK;
				RETURN v_noOfRec;
			END IF;
		END IF;

		v_noOfRec := 0;
	END IF;

	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	v_noOfRec := -1;
	o_errmsg := 'Fail to cancel registration due to ' || SQLERRM;
	ROLLBACK;
	RETURN v_noOfRec;
END NHS_ACT_REG_CANCEL;
/
