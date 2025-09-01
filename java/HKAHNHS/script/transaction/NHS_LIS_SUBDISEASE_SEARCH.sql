CREATE OR REPLACE FUNCTION "NHS_LIS_SUBDISEASE_SEARCH" (
  v_sdscode IN VARCHAR2,
  v_sdsdesc IN VARchAR2,
  v_sckcode  IN VARchAR2
  )
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
  sqlbuf VARCHAR2(200);
BEGIN
  sqlbuf:='select A.sdscode,A.sdsdesc,A.sckcode,B.sckdesc from sdisease A,SICK B where A.sckcode = B.sckcode and A.SDSNEW=-1 ';
  if v_sdscode is not null  then
   sqlbuf:=sqlbuf||' and lower(A.sdscode) like '''||lower(v_sdscode)||'%''';
  end if;
  if v_sdsdesc is not null  then
     sqlbuf:=sqlbuf||' and lower(A.sdsdesc) like '''||lower(v_sdsdesc)||'%''';
  end if;
  if v_sckcode is not null  then
     sqlbuf:=sqlbuf||' and lower(A.sckcode) like '''||lower(v_sckcode)||'%''';
  end if;
  sqlbuf:=sqlbuf||' ORDER BY A.SDSCODE';
  dbms_output.put_line('sqlbuf>>>>>'||sqlbuf);
  OPEN outcur FOR sqlbuf;
  RETURN OUTCUR;
end NHS_LIS_SUBDISEASE_SEARCH;
/
