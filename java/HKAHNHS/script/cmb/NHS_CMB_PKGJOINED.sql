create or replace FUNCTION NHS_CMB_PKGJOINED 
 ( v_slpno IN VARCHAR2) 
 RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
    Select rk.PkgCode 
      from Reg r, RegPkgLink rk 
     where r.SlpNo=v_slpno and r.RegID=rk.RegID;
  RETURN OUTCUR;
end;
/
