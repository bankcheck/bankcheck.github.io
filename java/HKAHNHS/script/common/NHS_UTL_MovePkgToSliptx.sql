-- TelLog \ movePkgToSliptx
CREATE OR REPLACE FUNCTION NHS_UTL_MovePkgToSliptx (
	i_LogId           IN VARCHAR2,
	i_SlpNo           IN VARCHAR2,
	i_Unit            IN NUMBER,
	i_AcmCode         IN VARCHAR2,
	i_TransactionDate IN DATE,
	i_BedCode         IN VARCHAR2,
	i_SlpCpsid        IN VARCHAR2,
	i_StnDesc1        IN VARCHAR2,
	i_IRefNo          IN VARCHAR2,
	i_DeptCode        IN VARCHAR2,
	i_doCharge        IN TYPES.CURSOR_TYPE,
	i_UserID          IN VARCHAR2,
	o_errmsg          OUT VARCHAR2
)
	RETURN NUMBER
AS
	r_doCharge Sys.LookupCharge_Rec;
	o_errcode NUMBER := 0;
	v_flagToDi BOOLEAN;
	v_captureDate DATE := SYSDATE;

	SLIPTX_TYPE_DEBIT VARCHAR2(1) := 'D';
BEGIN
	IF i_doCharge IS NOT NULL THEN
		LOOP
			FETCH i_doCharge INTO r_doCharge;
			EXIT WHEN i_doCharge%NOTFOUND OR o_errcode < 0;

			IF r_doCharge.StnDiFlag = -1 THEN
				v_flagToDi := TRUE;
			ELSE
				v_flagToDi := FALSE;
			END IF;

			o_errcode := NHS_UTL_ADDENTRY(
				i_SlpNo, r_doCharge.ItmCode, r_doCharge.ItmType, SLIPTX_TYPE_DEBIT,
				r_doCharge.StnOAmt / i_Unit, r_doCharge.StnBAmt, r_doCharge.DocCode,
				r_doCharge.StnRlvl, i_AcmCode, r_doCharge.StnDisc, r_doCharge.PkgCode,
				v_captureDate, i_TransactionDate, r_doCharge.StnDesc,
				NULL, NULL, NULL, NULL, i_BedCode, NULL, v_flagToDi, r_doCharge.StnCpsFlag,
				i_SlpCpsid, i_Unit, i_StnDesc1, i_IRefNo, i_DeptCode, i_UserID);
		END LOOP;

		IF o_errcode >= 0 THEN
			NHS_UTL_UPDATESLIP(i_SlpNo);

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
END NHS_UTL_MovePkgToSliptx;
/
