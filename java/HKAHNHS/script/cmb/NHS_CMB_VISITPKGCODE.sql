CREATE OR REPLACE FUNCTION NHS_CMB_VISITPKGCODE(
 v_slpno IN VARCHAR2
)RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
      Select p.Pkgname,r.PkgCode from Patient a,package p, REGPKGLINK r
                     where a.patno = v_slpno
                     and p.pkgtype <> 'P'
                     and a.REGID_C = r.RegID
                     and r.pkgcode = p.pkgcode ;
      RETURN OUTCUR;
end NHS_CMB_VISITPKGCODE;
/


