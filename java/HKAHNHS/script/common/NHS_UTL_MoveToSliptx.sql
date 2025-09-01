-- TelLog \ moveToSliptx
CREATE OR REPLACE FUNCTION NHS_UTL_MoveToSliptx (
	i_LogId IN VARCHAR2,
	i_DeptCode        IN VARCHAR2,
	i_SlpNo           IN VARCHAR2,
	i_ItmCode         IN VARCHAR2,
	i_ItmType         IN VARCHAR2,
	i_StnOAmt         IN NUMBER,
	i_StnBAmt         IN NUMBER,
	i_Unit            IN NUMBER,
	i_DocCode         IN VARCHAR2,
	i_ItmRLvl         IN NUMBER,
	i_AcmCode         IN VARCHAR2,
	i_StnDisc         IN NUMBER,
	i_TransactionDate IN DATE,
	i_ItmName         IN VARCHAR2,
	i_BedCode         IN VARCHAR2,
	i_flagToDi        IN BOOLEAN,
	i_StnCpsFlag      IN VARCHAR2,
	i_SlpCpsid        IN NUMBER,
	i_StnDesc1        IN VARCHAR2,
	i_IRefNo          IN VARCHAR2,
	i_UserID          IN VARCHAR2,
	i_SiteCode        IN VARCHAR2,
	o_errmsg          OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := -1;
	v_captureDate DATE := SYSDATE;
	v_count NUMBER := 0;

	SLIPTX_TYPE_DEBIT VARCHAR2(1) := 'D';
BEGIN
	UPDATE TelLog SET Status = 'D' WHERE Logid = i_LogId AND Status = 'N';

	IF SQL%ROWCOUNT = 0 THEN
		ROLLBACK;
		RETURN o_errcode;
	END IF;

	SELECT COUNT(1) INTO v_count FROM SLIPTX WHERE SLPNO = i_SLPNO AND ITMCODE = i_ItmCode AND IREFNO = i_IRefNo AND STNSTS IN ('N', 'A') AND STNCDATE > SYSDATE - (1 / 1440);
	IF v_count > 0 THEN
		ROLLBACK;
		RETURN o_errcode;
	END IF;

	o_errcode := NHS_UTL_ADDENTRY(
		i_SLPNO, i_ItmCode, i_ItmType, SLIPTX_TYPE_DEBIT, i_StnOAmt / i_Unit, i_StnBAmt,
		i_DocCode, i_ItmRLvl, i_AcmCode, i_StnDisc, NULL, v_captureDate, i_TransactionDate,
		i_ItmName, NULL, NULL, NULL, NULL, i_BedCode, NULL, i_flagToDi, i_StnCpsFlag,
		i_SlpCpsid, i_Unit, i_StnDesc1, i_IRefNo, i_DeptCode, i_UserID);

	IF o_errcode >= 0 THEN
		NHS_UTL_UPDATESLIP(i_SLPNO);

		NHS_UTL_DeleteTelLog(i_LogId, i_UserID);
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN -999;
END NHS_UTL_MoveToSliptx;
/
