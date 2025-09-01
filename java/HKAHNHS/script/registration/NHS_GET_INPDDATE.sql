CREATE OR REPLACE FUNCTION "NHS_GET_INPDDATE" (
	v_patno    IN VARCHAR2,
	v_isCurReg IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	REG_STS_NORMAL VARCHAR2(1) := 'N';
BEGIN
	IF v_isCurReg = 'Y' THEN
		OPEN outcur FOR
			SELECT /*+ ORDERED USED_NL(P,R,I) INDEX(P IDX_PATIENT_10, R IDX_REG_101 , I IDX_INPAT_202) */ I.InpDDate
			FROM   Patient P, Reg R, Inpat I
			WHERE  P.PatNo = v_patno
			AND    R.regtype = 'I'
			AND    R.REGSTS = REG_STS_NORMAL
			AND    I.InpDDate IS NULL
			AND    P.RegID_C = R.RegID
			AND    R.InpID = I.InpID;
	ELSE
		OPEN outcur FOR
			SELECT /*+ ORDERED USED_NL(r,i) INDEX(r IDX_REG_101 , i IDX_INPAT_202) */ r.patno
			FROM   Reg R, Inpat I
			WHERE  R.PatNo = v_patno
			AND    R.regtype = 'I'
			AND    R.REGSTS = REG_STS_NORMAL
			AND    R.InpID IS NOT NULL
			AND    I.InpDDate IS NULL
			AND    R.InpID = I.InpID;
	END IF;

	RETURN OUTCUR;
END NHS_GET_INPDDATE;
/
