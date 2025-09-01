create or replace
FUNCTION "NHS_LIS_SUBDISEASE" --RETURN Types.CURSOR_type
(--V_SDSCODE SDISEASE.SDSCODE%TYPE,
 V_SDSNEW  SDISEASE.SDSNEW%TYPE)
  RETURN Types.cursor_type
AS
  OUTCUR types.CURSOR_TYPE;
  STRSQL VARCHAR2(2000);
BEGIN
  
 	STRSQL := ' SELECT
  '''',
    A.sdscode,
    A.sdsdesc,
    DECODE(A.SDSNEW,''-1'',''Y'',''N''),
    A.SDSTABNUM,
    A.SDSROWNUM,
    A.sckcode,
    a.sdsabb,
    DECODE(a.ispaired,''-1'',''Y'',''N''),
    B0.SCKDESC
   from SDISEASE a, SICK B0
   WHERE A.SCKCODE = B0.SCKCODE ';
   if V_SDSNEW is not null then
      STRSQL := STRSQL || 'and (a.SDSNEW = '||V_SDSNEW||') ';
  end if;
      STRSQL := STRSQL || ' ORDER BY A.SDSCODE';
  OPEN OUTCUR FOR STRSQL;
	RETURN OUTCUR;
END NHS_LIS_SUBDISEASE;
/
