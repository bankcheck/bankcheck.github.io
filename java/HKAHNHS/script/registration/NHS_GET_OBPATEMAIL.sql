create or replace
function "NHS_GET_OBPATEMAIL" (
	V_SLPNO IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	
BEGIN
	OPEN OUTCUR FOR
		select REG.REGID, REG.SLPNO, REG.PATNO,PAT.PATFNAME	|| ' ' || PAT.PATGNAME, WA.WRDCODE, WA.WRDNAME, BED.BEDCODE, AC.ACMNAME, D.DOCFNAME	|| ' ' || D.DOCGNAME
    FROM  Reg reg, Inpat inp, Patient pat, Package pck, Bed bed, Room rom , WARD WA, ACM AC, DOCTOR D
		WHERE reg.patno = pat.patno
		AND   inp.bedcode = bed.bedcode(+)
		and   REG.PKGCODE = PCK.PKGCODE
    and   reg.doccode = d.doccode
		and   BED.ROMCODE = ROM.ROMCODE(+)    
    and   REG.INPID = INP.INPID (+)    
    and   ROM.WRDCODE=WA.WRDCODE (+)
    and   ROM.ACMCODE=AC.ACMCODE (+)
    and   REG.SLPNO = V_SLPNO;
	return OUTCUR;
END NHS_GET_OBPATEMAIL;
/