create or replace
FUNCTION                "NHS_RPT_REMINDERLETTER_HKAH_AD" (V_slpList IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE
AS
  OUTCUR TYPES.CURSOR_TYPE;
  strslp Varchar2(3000);
  strsql Varchar2(10000);
BEGIN
    strslp := V_slpList;
    strsql:='
	select slpno,amt
  from ('||V_slpList||' )';
        
  OPEN OUTCUR FOR STRSQL;
  RETURN OUTCUR; 
END NHS_RPT_REMINDERLETTER_HKAH_AD;
/
