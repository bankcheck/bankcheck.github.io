create or replace FUNCTION "NHS_ACT_UPDATEOBBK" (
	v_action   IN VARCHAR2,
	v_SlpNo    IN VARCHAR2,
	v_newBpbNo IN VARCHAR2,
	v_newEDC   IN VARCHAR2,
	v_UserID   IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode     NUMBER;
	v_Count	      NUMBER;
	v_isNewEDC    BOOLEAN;
	v_isNewBpb    BOOLEAN;
	v_isUpdateEDC BOOLEAN;
	v_isUpdateBpb BOOLEAN;
	v_oldEDC      VARCHAR2(10);
	v_oldBpbNo    VARCHAR2(10);
BEGIN
	o_errcode := -1;
	v_isNewEDC := FALSE;
	v_isNewBpb := FALSE;
	v_isUpdateBpb := TRUE;
	v_isUpdateEDC := TRUE;

	-- verify SlipNo
	SELECT COUNT(1) INTO v_Count FROM Slip WHERE SlpNo = v_SlpNo;
	IF v_Count = 0 THEN
		o_errcode := -1;
		o_errmsg := 'Invalid Slip.';
		RETURN o_errcode;
	END IF;

	SELECT TO_CHAR(EDC, 'dd/mm/yyyy'), BpbNo INTO v_oldEDC, v_oldBpbNo
	FROM Slip WHERE SlpNo = v_SlpNo;
	IF v_oldEDC IS NULL THEN
		v_isNewEDC := TRUE;
	END IF;
	IF v_oldBpbNo IS NULL THEN
		v_isNewBpb := TRUE;
	END IF;
	IF v_oldBpbNo = v_newBpbNo THEN
		v_isUpdateBpb := FALSE;
	END IF;
	IF v_oldEDC = v_newEDC THEN
		v_isUpdateEDC := FALSE;
	END IF;

	-- verIFy BpbNo
	SELECT COUNT(1) INTO v_Count FROM Slip WHERE BpbNo = v_newBpbNo;
	IF v_Count > 0  and v_isNewBpb = true THEN
		o_errcode := -1;
		o_errmsg := 'Booking# already linked, please type another booking#.';
		RETURN o_errcode;
	END IF;

	IF v_isUpdateBpb THEN
		IF v_isNewBpb THEN
			UPDATE Slip SET bpbNo = v_newBpbNo, DepIssueDt = SYSDATE, BpbNoUserId = v_UserID, BpbEditDate = SYSDATE WHERE SlpNo = v_SlpNo;

			UPDATE BedPreBok SET slpno = v_SlpNo, edituser = v_UserID, editdate = SYSDATE WHERE bpbno = v_newBpbNo;
		ELSE
			UPDATE Slip SET bpbNo = v_newBpbNo, BpbNoUserId = v_UserID, BpbEditDate = SYSDATE WHERE SlpNo = v_SlpNo;

			IF v_oldBpbNo IS NOT NULL AND v_newBpbNo IS NOT NULL THEN
				UPDATE BedPreBok SET slpno = null, edituser = v_UserID, editdate= SYSDATE WHERE bpbno = v_oldBpbNo;
				UPDATE BedPreBok SET slpno = v_SlpNo, edituser = v_UserID, editdate= SYSDATE WHERE bpbno = v_newBpbNo;
			ELSIF v_oldBpbNo IS NULL AND v_newBpbNo IS NOT NULL THEN
				UPDATE BedPreBok SET slpno = v_SlpNo, edituser = v_UserID, editdate = SYSDATE WHERE bpbno = v_newBpbNo;
			ELSIF v_oldBpbNo IS NOT NULL AND v_newBpbNo IS NULL THEN
				UPDATE BedPreBok SET slpno = null, edituser = v_UserID, editdate = SYSDATE WHERE bpbno = v_oldBpbNo;
			END IF;
		END IF;
	END IF;

	IF v_isUpdateEDC THEN
		IF v_isNewEDC THEN
			UPDATE Slip SET EDC = TO_DATE(v_newEDC, 'dd/mm/yyyy'), IssueDt = SYSDATE, EDCEditDate = SYSDATE, EDCUserId = v_UserID WHERE SlpNo = v_SlpNo;
		ELSE
			UPDATE Slip SET EDC = TO_DATE(v_newEDC, 'dd/mm/yyyy'), EDCEditDate = SYSDATE, EDCUserId = v_UserID WHERE SlpNo = v_SlpNo;
		END IF;
	END IF;

	o_errcode := 0;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN -999;
END NHS_ACT_UPDATEOBBK;
/


