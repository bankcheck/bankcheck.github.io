CREATE OR REPLACE FUNCTION NHS_RPT_RPTSNEXPIRY
(
  v_EndDate VARCHAR2,
   v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
  sub varchar2(100);
BEGIN
select Param1 into sub from sysparam where parcde='SN2EXPSCH';

   OPEN outcur FOR
   'Select A.ARCCODE, A.ARCNAME, C.CPSCODE, C.CPSDESC, AH.ACHSDATE, AH.ACHEDATE
                from Arcode A, Conpceset C, Arccpshist AH
                Where A.ArcCode = AH.ArcCode
                and AH.CPSID=C.CPSID
                and A.stecode= '''||v_SteCode||'''
                and ( AH.ACHEDATE - (to_date('''||v_EndDate||''',''dd/mm/yyyy'') + 1) ) In('
                 ||sub||')
                order by A.ARCCODE, AH.ACHEDATE';
RETURN OUTCUR;
END NHS_RPT_RPTSNEXPIRY;
/
