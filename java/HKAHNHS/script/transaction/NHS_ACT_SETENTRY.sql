CREATE OR REPLACE FUNCTION "NHS_ACT_SETENTRY" (
	v_action  IN VARCHAR2,
	v_StnID   IN VARCHAR2,
	v_StnSts  IN VARCHAR2,
	v_stndesc IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	SLIPTX_STATUS_CANCEL VARCHAR2(1) := 'C';
	SLIPTX_STATUS_TRANSFER VARCHAR2(1) := 'T';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_noOfRec FROM sliptx WHERE StnID = to_number(v_StnID);
	IF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			IF v_StnSts = SLIPTX_STATUS_CANCEL THEN
				UPDATE SlipTx SET StnSts = v_StnSts, StnDesc = v_StnDesc, StnDIFlag = '' WHERE StnID = TO_NUMBER(v_StnID);
			ELSIF v_StnSts = SLIPTX_STATUS_TRANSFER THEN
				UPDATE SlipTx SET StnSts = v_StnSts, StnDesc = v_StnDesc, StnADoc='', StnAScm = '' WHERE StnID = to_number(v_StnID);
			ELSE
				o_errcode := -1;
				o_errmsg := 'Record not exists.';
			END IF;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record not exists.';
		END IF;
	END IF;

	RETURN o_errcode;
end NHS_ACT_SETENTRY;
/
