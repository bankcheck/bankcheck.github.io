CREATE OR REPLACE FUNCTION NHS_RPT_PRINTOBCERT (
	i_SlpNo VARCHAR2
)
	RETURN Types.cursor_type
AS
	v_Count NUMBER;
	v_PatNo Slip.PatNo%TYPE;
	outcur types.cursor_type;
	v_dayCount number;
BEGIN
	SELECT COUNT(1) INTO v_Count FROM Slip WHERE SlpNo = i_SlpNo;
	IF v_Count > 0 THEN
		SELECT PatNo INTO v_PatNo FROM Slip WHERE SlpNo = i_SlpNo;
		SELECT param1 INTO v_dayCount from SysParam WHERE parcde = 'addedxedoc';

		OPEN outcur FOR
			SELECT
				S.PatNo,
				NVL(S.SlpfName, P.PatfName) || ', ' || NVL(S.SlpgName, P.PatgName),
				P.PatCName,
				TO_CHAR(P.PatBdate, 'DD/MM/YYYY'),
				P.PatIDNO,
				TO_CHAR(S.EDC, 'DD/MM/YYYY'),
				TO_CHAR(S.IssueDt, 'DD/MM/YYYY'),
				TO_CHAR(S.EDC + v_dayCount, 'DD/MM/YYYY'),
				'50'
			FROM  SLIP S, PATIENT P, BEDPREBOK BPB
			WHERE S.PATNO = P.PATNO(+)
			AND   S.BPBNO = BPB.BPBNO(+)
			AND   S.SLPNO = i_SlpNo;
	ELSE
		RETURN NULL;
	END IF;

	RETURN outcur;
END NHS_RPT_PRINTOBCERT;
/
