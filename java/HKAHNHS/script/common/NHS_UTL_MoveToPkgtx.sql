-- TelLog \ moveToPkgtx
CREATE OR REPLACE FUNCTION NHS_UTL_MoveToPkgtx (
	i_LogId           IN VARCHAR2,
	i_MovePkgCode     IN VARCHAR2,
	i_SlpNo           IN VARCHAR2,
	i_ItmCode         IN VARCHAR2,
	i_StnOAmt         IN NUMBER,
	i_StnBAmt         IN NUMBER,
	i_Unit            IN NUMBER,
	i_DocCode         IN VARCHAR2,
	i_StnRlvl         IN NUMBER,
	i_AcmCode         IN VARCHAR2,
	i_TransactionDate IN DATE,
	i_ItmName         IN VARCHAR2,
	i_flagToDi        IN BOOLEAN,
	i_StnCpsFlag      IN VARCHAR2,
	i_StnDesc1        IN VARCHAR2,
	i_IRefNo          IN VARCHAR2,
	i_DeptCode        IN VARCHAR2,
	i_UserID          IN VARCHAR2,
	o_errmsg          OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := -1;
	v_GlcCode CreditChg.GlcCode%TYPE;
	v_SlpType Slip.SlpType%TYPE;
	v_Count NUMBER;

	SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
BEGIN
	IF i_MovePkgCode IS NOT NULL THEN

		SELECT COUNT(1) INTO v_Count FROM Slip WHERE SlpNo = i_SlpNo;
		IF v_Count > 0 THEN
			SELECT SlpType INTO v_SlpType FROM Slip WHERE SlpNo = i_SlpNo;
		END IF;

		v_GlcCode := NHS_UTL_LookupGLCode(TO_CHAR(i_TransactionDate, 'DD/MM/YYYY'), i_ItmCode, NULL, v_SlpType, NULL, NULL, NULL, i_AcmCode, i_DeptCode);

		o_errcode := NHS_UTL_AddPackageEntry(i_SlpNo, i_MovePkgCode, i_ItmCode, i_StnOAmt / i_Unit, i_StnBAmt, i_DocCode,
			i_StnRlvl, i_AcmCode, NULL, i_TransactionDate, i_ItmName, SLIPTX_STATUS_NORMAL, NULL, NULL,
			i_flagToDi, i_StnCpsFlag, i_Unit, i_StnDesc1, i_IRefNo, i_DeptCode, v_GlcCode, true, i_UserID);

		IF o_errcode >= 0 THEN
			NHS_UTL_DeleteTelLog(i_LogId, i_UserID);
		END IF;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN -999;
END NHS_UTL_MoveToPkgtx;
/
