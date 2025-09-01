create or replace
FUNCTION "NHS_RPT_DAYCASEADMLABEL" (
	v_PATNO VARCHAR2
)
	return types.cursor_type
as
	outcur types.cursor_type;
	v_Docname VARCHAR2(100);
	v_regdateinhr VARCHAR2(100);
	v_regdatehhmm VARCHAR2(100);
	v_doccode VARCHAR2(10);
	v_regdate VARCHAR2(40);
	v_regid VARCHAR(10);
begin
	Select Regid_C Into V_Regid From Patient Where Patno = V_Patno;

	SELECT to_char(REGDATE,'dd/mm/yyyy'), DOCCODE
	INTO   v_regdate, v_doccode
	FROM   reg where regid = v_regid;

	SELECT
		D.Docfname||' '||D.Docgname,To_Char(T1.Regdate,'dd/mm/yyyy HH24:MI'), TO_CHAR(T1.Regdate,'HH24:MI')
		INTO v_docname, v_regdateinhr, v_regdatehhmm
	FROM
		(SELECT bkgid AS bkid, Doccode, Regdate
		FROM Reg
		WHERE Regid =(Select Regid_C From Patient Where Patno = v_PATNO)) T1, Doctor D
	WHERE d.doccode=t1.doccode;

	Open Outcur For
   select
		 p.stecode, p.patno, p.patfname||' '||p.patgname AS patname,
		 P.Patcname, To_Char(P.Patbdate,'dd/mm/yyyy'),
		 P.Patsex, v_Docname AS Docname,
		 v_regdateinhr AS Regdate
	    From Patient P
	    Where p.patno= v_PATNO;

	return outcur;
end NHS_RPT_DAYCASEADMLABEL;
/
