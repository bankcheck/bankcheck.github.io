create or replace
FUNCTION "HAT_LST_PATIENT_TEST2"
(
  v_PATNO    IN VARCHAR2,
  v_PATIDNO  IN VARCHAR2,
  v_PATHTEL  IN VARCHAR2,
  v_PATPAGER IN VARCHAR2,
  v_PATBDATE IN VARCHAR2,
  v_PATSEX   IN VARCHAR2,
  v_PATEMAIL IN VARCHAR2,
  v_PATFNAME IN VARCHAR2,
  v_PATGNAME IN VARCHAR2,
  v_PATMNAME IN VARCHAR2,
  v_ORDBY    IN VARCHAR2
)
  RETURN Types.cursor_type
AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(2000);
  tempstr VARCHAR2(2000);
BEGIN

  sqlstr:='SELECT
        P.PATNO,
        P.PATFNAME,
        P.PATGNAME,
        P.PATMNAME,
        P.PATSEX,
        to_char(P.PATBDATE,''dd/mm/yyyy''),
        P.PATHTEL,
        P.PATIDNO,
        P.PATVCNT,
        to_char(P.LASTUPD, ''dd/mm/yyyy''),
        P.PATCNAME,
        P.TITDESC,
        P.PATMSTS,
        P.RACDESC,
        P.MOTHCODE,
        P.PATSEX,
        P.EDULEVEL,
        P.RELIGIOUS,
        to_char(P.DEATH,''dd/mm/yyyy''),
        P.OCCUPATION,
        P.PATMOTHER,
        P.PATNB,
        P.PATSTS,
        P.PATITP,
        P.PATSTAFF,
        P.PATEMAIL,
        P.PATOTEL,
        P.PATPAGER,
        P.PATFAXNO,
        P.PATADD1,
        P.PATADD2,
        P.PATADD3,
        P.LOCCODE,
        L.DSTCODE,
        P.COUCODE,
        P.PATRMK,
        to_char(P.LASTUPD, ''dd/mm/yyyy hh24:mi:ss''),
        P.STECODE,
        P.PATKNAME,
        P.PATKHTEL,
        P.PATKPTEL,
        P.PATKRELA,
        P.PATKOTEL,
        P.PATKMTEL,
        P.PATKADD
    FROM PATIENT@IWEB P LEFT JOIN LOCATION@IWEB L
    ON P.LOCCODE= L.LOCCODE  where ROWNUM < 100';   
     
    IF v_PATIDNO is not null THEN
        tempstr:=tempstr||'(P.PATIDNO='''||v_PATIDNO||''')';
    END IF;   
    IF v_PATBDATE is not null and v_PATFNAME is not null THEN
        IF tempstr is not null then
        tempstr:=tempstr||'OR';
        END IF;
        tempstr:=tempstr||' (P.PATBDATE=to_date('''||v_PATBDATE||''',''dd/mm/yyyy'') ';
        tempstr:=tempstr||' AND UPPER(P.PATFNAME)='''||v_PATFNAME||'''';
        tempstr:=tempstr||' ) ';
    END IF;
    IF v_PATBDATE is not null and v_PATGNAME is not null THEN
        IF tempstr is not null then
        tempstr:=tempstr||' OR';
        END IF;
        tempstr:=tempstr||' (P.PATBDATE=to_date('''||v_PATBDATE||''',''dd/mm/yyyy'') ';
        tempstr:=tempstr||' AND UPPER(P.PATGNAME)='''||v_PATGNAME||'''';
        tempstr:=tempstr||' )  ';
    END IF;
    IF v_PATGNAME is not null and v_PATFNAME is not null THEN
        IF tempstr is not null then
        tempstr:=tempstr||' OR';
        END IF;
        tempstr:=tempstr||'(UPPER(P.PATFNAME)='''||v_PATFNAME||'''';        
        tempstr:=tempstr||' AND UPPER(P.PATGNAME)='''||v_PATGNAME||'''';
        tempstr:=tempstr||' ) ';
    END IF;
    IF v_PATBDATE is not null and v_PATHTEL is not null THEN
        IF tempstr is not null then
        tempstr:=tempstr||' OR';
        END IF;
        tempstr:=tempstr||' (P.PATBDATE=to_date('''||v_PATBDATE||''',''dd/mm/yyyy'') ';
        tempstr:=tempstr||' AND P.PATHTEL= '''||v_PATHTEL||'''';
        tempstr:=tempstr||' )  ';
    END IF;
    IF v_PATPAGER is not null THEN
        IF tempstr is not null then
        tempstr:=tempstr||' OR';
        END IF;
        tempstr:=tempstr||'(P.PATPAGER= '''||v_PATPAGER||'''';
        tempstr:=tempstr||' )  ';
    END IF;
    IF v_PATEMAIL is not null THEN
        IF tempstr is not null then
        tempstr:=tempstr||' OR';
        END IF;
        tempstr:=tempstr||'(P.PATEMAIL  like ''%'||v_PATEMAIL||'%''';
        tempstr:=tempstr||' ) ';
    END IF;

    IF tempstr is not null THEN
    sqlstr:=sqlstr||' AND (';
    sqlstr:=sqlstr||TEMPSTR;
    sqlstr:=sqlstr||') ';
    END IF;
    
  OPEN OUTCUR FOR sqlstr;
  RETURN OUTCUR;
END HAT_LST_PATIENT_TEST2;