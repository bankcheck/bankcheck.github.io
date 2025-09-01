CREATE OR REPLACE FUNCTION "NHS_LIS_SUBREASON_SEARCH" (
  v_srsncode IN VARCHAR2,
  v_srsndesc IN VARchAR2,
  v_rsncode  IN VARchAR2
  )
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
  sqlbuf VARCHAR2(200);
BEGIN
  sqlbuf:='select A.srsncode,A.srsndesc,A.rsncode,B.rsndesc from sreason A,reason B where A.rsncode = B.rsncode and A.SRSNNEW=-1 ';
  if v_srsncode is not null  then
   sqlbuf:=sqlbuf||' and lower(A.srsncode) like '''||lower(v_srsncode)||'%''';
  end if;
  if v_srsndesc is not null  then
     sqlbuf:=sqlbuf||' and lower(A.srsndesc) like '''||lower(v_srsndesc)||'%''';
  end if;
  if v_rsncode is not null  then
     sqlbuf:=sqlbuf||' and lower(A.rsncode) like '''||lower(v_rsncode)||'%''';
  end if;
  sqlbuf:=sqlbuf||' ORDER BY A.srsncode';
  dbms_output.put_line('sqlbuf>>>>>'||sqlbuf);
  OPEN outcur FOR sqlbuf;
  RETURN OUTCUR;
end NHS_LIS_SUBREASON_SEARCH;
/
