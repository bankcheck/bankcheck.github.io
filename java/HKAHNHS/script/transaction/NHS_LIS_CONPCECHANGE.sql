CREATE OR REPLACE FUNCTION "NHS_LIS_CONPCECHANGE" (
	i_SlpNo         IN VARCHAR2,
	i_PatientType   IN VARCHAR2,
	i_OldAcmcode    IN VARCHAR2,
	i_NewCPSID      IN VARCHAR2,
	i_NewAcmcode    IN VARCHAR2,
	i_TransactionID IN VARCHAR2,
	i_ChangeACM     IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	V_OUTCUR types.CURSOR_TYPE;
	V_CHANGEACM BOOLEAN;
	CPS_OUTCUR TYPES.CURSOR_TYPE;
	T_CONPCECHG NEWCONPCECHANGE_TAB := NEWCONPCECHANGE_TAB();
	r_ConPceChg2 Sys.NewConPceChange_Rec;
	R_CONPCECHG NEWCONPCECHANGE_OBJ := NEWCONPCECHANGE_OBJ(0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, NULL, NULL);
	O_OUTCUR  TYPES.CURSOR_TYPE;
	v_Count NUMBER;
BEGIN
	V_OUTCUR := NHS_GET_CONPCECHANGE(I_SLPNO, I_TRANSACTIONID);

	IF I_CHANGEACM = 'Y' THEN
		V_ChangeACM := TRUE;
	ELSE
		V_ChangeACM := FALSE;
	END IF;

	CPS_OUTCUR := NHS_UTL_FILLNEWCPS(I_SLPNO, I_PATIENTTYPE, I_OLDACMCODE, V_OUTCUR, I_NEWCPSID, I_NEWACMCODE, V_CHANGEACM);

	IF CPS_OUTCUR IS NOT NULL THEN
		v_Count := 1;
		LOOP
			FETCH CPS_OUTCUR INTO r_ConPceChg2;
			EXIT WHEN CPS_OUTCUR%NOTFOUND ;

			r_ConPceChg.StnID        := r_ConPceChg2.StnID;
			r_ConPceChg.StnSEQ       := r_ConPceChg2.StnSEQ;
			r_ConPceChg.PkgCode      := r_ConPceChg2.PkgCode;
			r_ConPceChg.ItmCode      := r_ConPceChg2.ItmCode;
			r_ConPceChg.StnDESC      := r_ConPceChg2.StnDESC;
			r_ConPceChg.StnBAMT      := r_ConPceChg2.StnBAMT;
			r_ConPceChg.StnDISC      := r_ConPceChg2.StnDISC;
			r_ConPceChg.StnCPSFlag   := r_ConPceChg2.StnCPSFlag;
			r_ConPceChg.NewCPSFlag   := r_ConPceChg2.NewCPSFlag;
			r_ConPceChg.NewBAmt      := r_ConPceChg2.NewBAmt;
			r_ConPceChg.NewDisc      := r_ConPceChg2.NewDisc;
			r_ConPceChg.Unit         := r_ConPceChg2.Unit;
			r_ConPceChg.ItmType      := r_ConPceChg2.ItmType;
			r_ConPceChg.FirstSTNBAmt := r_ConPceChg2.FirstSTNBAmt;
			r_ConPceChg.OldBAMT      := r_ConPceChg2.OldBAMT;
			r_ConPceChg.OldDisc      := r_ConPceChg2.OldDisc;
			r_ConPceChg.NewAcmCode   := r_ConPceChg2.NewAcmCode;
			r_ConPceChg.NewOAMT      := r_ConPceChg2.NewOAMT;
			R_CONPCECHG.NEWGLCCODE   := R_CONPCECHG2.NEWGLCCODE;
			R_CONPCECHG.GLCCODE      := R_CONPCECHG2.GLCCODE;

			t_ConPceChg.EXTEND(1);
			T_CONPCECHG(V_COUNT) := R_CONPCECHG;
			v_Count := v_Count + 1;
		END LOOP;
	END IF;

	OPEN o_OUTCUR FOR
		SELECT StnID, StnSeq, PkgCode, ItmCode, Stndesc,
							StnBAmt, StnDisc, StnCPSFlag, newCPSFlag, newBAmt,
							newDisc, Unit, ItmType, firstStnBAmt, oldBAmt,
							oldDisc, newAcmCode, newOAmt, newGlcCode, Glccode
		FROM TABLE(T_CONPCECHG);
	RETURN o_OUTCUR;

EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN NULL;
END NHS_LIS_CONPCECHANGE;
/
