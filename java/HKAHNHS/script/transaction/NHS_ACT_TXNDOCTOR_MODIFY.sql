CREATE OR REPLACE 
FUNCTION "NHS_ACT_TXNDOCTOR_MODIFY"
(
	v_action	IN VARCHAR2,
	v_SlpNo   	IN slip.SlpNo%TYPE,
	v_PatNo   	IN reg.PatNo%TYPE,
	v_DocCode 	IN slip.DocCode%TYPE,
	v_UsrID		IN VARCHAR2,
	o_errmsg  	OUT VARCHAR2
)
  	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_expirydate VARCHAR2(50);
	DOCTOR_STATUS_ACTIVE NUMBER := -1;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_noOfRec FROM Doctor WHERE DocCode = v_DocCode;
	IF v_noOfRec = 0 THEN
		o_errcode := -1;
		o_errmsg := 'Invalid Doctor.';
		RETURN o_errcode;
	END IF;

	SELECT COUNT(1) INTO v_noOfRec FROM Doctor WHERE DocCode = v_DocCode AND DocSts = DOCTOR_STATUS_ACTIVE;
	IF v_noOfRec = 0 THEN
		SELECT TO_CHAR(DOCTDATE, 'DD/MM/YYYY') INTO v_expirydate
		FROM Doctor
		WHERE UPPER(DocCode) = UPPER(v_DocCode);
		
		
		o_errcode := -1;
		o_errmsg := 'Inactive Doctor.<br/>Admission Expiry Date: '||v_expirydate;
		RETURN o_errcode;
	END IF;

	IF v_SlpNo IS NOT NULL then
		UPDATE Slip SET DocCode = v_DocCode WHERE SlpNo = v_SlpNo;
	END IF;

	IF v_PatNo IS NOT NULL then
		UPDATE Reg 
		SET DocCode = v_DocCode 
		WHERE SlpNo = v_SlpNo 
		AND PatNo = v_PatNo;
		
		UPDATE REG_EXTRA
		SET MODIFY_DATE = SYSDATE,
			MODIFY_USER = v_UsrID
		WHERE REGID = (
						SELECT REGID
						FROM REG 
						WHERE SlpNo = v_SlpNo 
						AND PatNo = v_PatNo
					);
	END IF;

	RETURN o_errcode;
END "NHS_ACT_TXNDOCTOR_MODIFY";
/
