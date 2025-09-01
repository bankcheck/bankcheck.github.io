-- TelLog \ movePkgToPkgtx
CREATE OR REPLACE FUNCTION NHS_UTL_MovePkgToPkgtx (
	i_LogId           IN VARCHAR2,
	i_MovePkgCode     IN VARCHAR2,
	i_SlpNo           IN VARCHAR2,
	i_Unit            IN NUMBER,
	i_AcmCode         IN VARCHAR2,
	i_TransactionDate IN DATE,
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

	SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
BEGIN
	IF i_MovePkgCode IS NOT NULL AND i_doCharge IS NOT NULL THEN
		LOOP
			FETCH i_doCharge INTO r_doCharge;
			EXIT WHEN i_doCharge%NOTFOUND OR o_errcode < 0;

			IF r_doCharge.StnDiFlag = -1 THEN
				v_flagToDi := TRUE;
			ELSE
				v_flagToDi := FALSE;
			END IF;

			o_errcode := NHS_UTL_AddPackageEntry(i_SlpNo, i_MovePkgCode, r_doCharge.ItmCode,
				r_doCharge.StnOAmt / i_Unit, r_doCharge.StnBAmt, r_doCharge.DocCode,
				r_doCharge.StnRlvl, i_AcmCode, NULL, i_TransactionDate,
				r_doCharge.StnDesc, SLIPTX_STATUS_NORMAL, NULL, NULL,
				v_flagToDi, r_doCharge.StnCpsFlag,
				i_Unit, i_StnDesc1, i_IRefNo, i_DeptCode, r_doCharge.GlcCode, true, i_UserID);
		END LOOP;

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
END NHS_UTL_MovePkgToPkgtx;
/
