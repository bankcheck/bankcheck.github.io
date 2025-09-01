CREATE OR REPLACE FUNCTION "NHS_UTL_MOVESLIPTOPACKAGE" (
	v_SlpNo   IN VARCHAR2,
	v_StnID   IN VARCHAR2,
	v_BedCode IN VARCHAR2,
	v_MovePkg IN VARCHAR2,
	v_UsrID   IN VARCHAR2
)
	RETURN NUMBER
AS
	o_ErrCode NUMBER;
	v_ErrMsg VARCHAR2(100);
	v_noOfRec NUMBER;
	v_FlagToDi BOOLEAN;
	rs_slptx sliptx%ROWTYPE;
BEGIN
	o_ErrCode := 0;

	SELECT COUNT(1) INTO v_noOfRec FROM SlipTx WHERE SlpNo = v_SlpNo AND StnID = TO_NUMBER(v_StnID);
	IF v_noOfRec > 0 THEN
		SELECT * INTO rs_slptx FROM SlipTx WHERE SlpNo = v_SlpNo AND StnID = TO_NUMBER(v_StnID);
		IF rs_slptx.stndiflag IS NOT NULL THEN
			v_FlagToDi := TRUE;
		ELSE
			v_FlagToDi := FALSE;
		END IF;

		o_ErrCode := NHS_UTL_AddPackageEntry(
			rs_slptx.slpno,
			v_MovePkg,
			rs_slptx.itmcode,
			rs_slptx.stnoamt,
			rs_slptx.stnbamt,
			rs_slptx.doccode,
			rs_slptx.stnrlvl,
			rs_slptx.acmcode,
			rs_slptx.stntdate,
			rs_slptx.stntdate,
			rs_slptx.stndesc,
			rs_slptx.stnsts,
			v_BedCode,
			rs_slptx.StnID,
			v_FlagToDi,
			rs_slptx.stncpsflag,
			rs_slptx.unit,
			rs_slptx.stndesc1,
			rs_slptx.irefno,
			NULL,
			rs_slptx.GlcCode,
			TRUE,
			v_UsrID);

		IF o_ErrCode < 0 THEN
			return o_ErrCode;
		END IF;

		o_ErrCode := NHS_ACT_REVERSEENTRY(
			'ADD',
			v_SlpNo,
			v_StnID,
			TO_CHAR(SYSDATE, 'dd/mm/yyyy HH24:MI:SS'),
			TO_CHAR(rs_slptx.stntdate, 'dd/mm/yyyy'),
			'1',
			v_UsrID,
			v_ErrMsg);

		IF o_ErrCode < 0 THEN
			return o_ErrCode;
		END IF;
	END IF;

	RETURN o_ErrCode;
EXCEPTION
WHEN OTHERS THEN
	o_ErrCode := -1;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN o_ErrCode;
end NHS_UTL_MOVESLIPTOPACKAGE;
/
