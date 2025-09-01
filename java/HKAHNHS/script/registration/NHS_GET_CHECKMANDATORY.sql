create or replace
FUNCTION NHS_GET_CHECKMANDATORY(
v_paramType in varchar2)
 RETURN Types.cursor_type
 AS
  v_param varchar2(100);
  sqlbuf varchar2(200);
  outcur types.cursor_type;
  cursor1 types.cursor_type; 
  sqlbuf1 varchar2(200);  
  v_trueFalse varchar2(1) := 'N';
  v_result1 varchar2(1);
begin
  sqlbuf1:='SELECT PARAM1 from sysparam where trim(parcde)=trim(''' ||v_paramType||''')' ;
  open cursor1 for sqlbuf1;
  LOOP
    FETCH cursor1 INTO v_result1;
    EXIT WHEN cursor1%NOTFOUND;
    IF v_result1 = 'Y' THEN
      v_trueFalse := 'Y';
    END IF;
  END LOOP;
  CLOSE cursor1;
  
  IF v_trueFalse = 'Y' THEN
    sqlbuf:='SELECT ''Y'' FROM dual';
  ELSE
    sqlbuf:='SELECT ''N'' FROM dual';  
  END IF;
  
  open outcur for sqlbuf;  
  RETURN outcur;
END NHS_GET_CHECKMANDATORY  ;
/