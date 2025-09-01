create or replace
FUNCTION "NHS_LIS_PATALERT"(v_patno IN VARCHAR2,
                                              v_showhis IN VARCHAR2,
                                              v_usrid IN VARCHAR2)
  RETURN Types.cursor_type AS
  outcur types.cursor_type;
  sqlstr VARCHAR2(2000);
BEGIN

    sqlstr:='SELECT
           '''',
           A.ALTCODE,
           A.ALTDESC,
           p.usrid_a,
           to_char(p.paldate,''dd/mm/yyyy''),
           p.usrid_c,
           to_char(p.palcdate,''dd/mm/yyyy''),
           a.altid,
           p.palid

      FROM PATALTLINK@IWEB P, ALERT@IWEB A
     WHERE P.ALTID = A.ALTID
       AND P.ALTID IN (SELECT DISTINCT R.ALTID
                         FROM USRROLE@IWEB U, ROLALTLINK@IWEB R
                        WHERE U.ROLID = R.ROLID
                          AND U.USRID = '''||v_usrid||''')
       AND P.PATNO = '''||v_patno||'''';
       if v_showhis='0' then
       sqlstr:=sqlstr||' AND P.USRID_C IS NULL';
       end if;
       --sqlstr:=sqlstr||' ORDER  BY A.ALTCODE';
       dbms_output.put_line(sqlstr);
  OPEN outcur FOR sqlstr;
  RETURN OUTCUR;
END NHS_LIS_PATALERT;