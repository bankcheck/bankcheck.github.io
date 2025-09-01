create or replace
FUNCTION NHS_RPT_PrintOBCert_TWAH (
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
  select param1 into v_dayCount from sysparam where parcde='addedxedoc';

		OPEN outcur FOR
		    SELECT S.PatNo,
		           NVL(S.SlpfName, P.PatfName) || ', ' || NVL(S.SlpgName, P.PatgName),
		           P.PatCName,
		           TO_CHAR(P.PatBdate, 'DD/MM/YYYY'),
		           P.PatIDNO,
		           TO_CHAR(S.EDC, 'DD/MM/YYYY'),
		           TO_CHAR(S.IssueDt, 'DD/MM/YYYY'),
		           TO_CHAR(S.EDC+v_dayCount, 'DD/MM/YYYY'),
                BPB.Doccode,
                bpb.husdoctype,
                bpb.patdoctype,
                dr.docfname,
                dr.docgname,
                dr.docptel,
                dr.docotel,
                dr.hkmclicno,
                TO_CHAR(bpb.antchkdt1, 'DD/MM/YYYY'),  
                TO_CHAR(bpb.antchkdt2, 'DD/MM/YYYY'),
                TO_CHAR(bpb.antchkdt3, 'DD/MM/YYYY'),
                TO_CHAR(bpb.antchkdt4, 'DD/MM/YYYY'),
                TO_CHAR(bpb.antchkdt5, 'DD/MM/YYYY'),
                TO_CHAR(bpb.antchkdt6, 'DD/MM/YYYY'),
                TO_CHAR(bpb.antchkdt7, 'DD/MM/YYYY'),
                TO_CHAR(bpb.antchkdt8, 'DD/MM/YYYY'),
                TO_CHAR(bpb.antchkdt9, 'DD/MM/YYYY'),
                TO_CHAR(bpb.antchkdt10, 'DD/MM/YYYY'),
                NVL(S.SlpfName, P.PatfName) as patfname,
                NVL(S.SlpgName, P.PatgName) as patgname
		      FROM SLIP S, PATIENT P, BEDPREBOK BPB,Doctor DR
		     WHERE S.PATNO = P.PATNO(+)
		       AND S.BPBNO = BPB.BPBNO(+)
            and  BPB.doccode = dr.doccode
		       AND S.SLPNO = i_SlpNo;
	ELSE
		RETURN NULL;
	END IF;

	RETURN outcur;
END NHS_RPT_PrintOBCert_TWAH;
/
