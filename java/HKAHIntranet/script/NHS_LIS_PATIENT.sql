create or replace
FUNCTION "NHS_LIS_PATIENT"
(
  v_PATNO    IN VARCHAR2,
  v_PATIDNO  IN VARCHAR2,
  v_PATHTEL  IN VARCHAR2,
  v_PATBDATE IN VARCHAR2,
  v_PATSEX   IN VARCHAR2,
  v_PATFNAME IN VARCHAR2,
  v_PATGNAME IN VARCHAR2,
  v_PATMNAME IN VARCHAR2,
  v_SCR      IN VARCHAR2,
  v_ORDBY    IN VARCHAR2
)
  RETURN Types.cursor_type
AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(2000);
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
        P.USRID,
        P.PATKNAME,
        P.PATKHTEL,
        P.PATKPTEL,
        P.PATKRELA,
        P.PATKOTEL,
        P.PATKMTEL,
        P.PATKADD
    FROM PATIENT@IWEB P LEFT JOIN LOCATION@IWEB L
    ON P.LOCCODE= L.LOCCODE  where ROWNUM < 100';
    IF v_PATNO is not null THEN
        sqlstr:=sqlstr||' AND P.PATNO='''||v_PATNO||'''';
    END IF;
    IF v_PATIDNO is not null THEN
        CASE v_SCR
           WHEN 'Cross' THEN
              sqlstr:=sqlstr||' AND P.PATIDNO like ''%'||v_PATIDNO||'%''';
           WHEN  'Wildcard' THEN
               sqlstr:=sqlstr||' AND P.PATIDNO like ''%'||v_PATIDNO||'%''';
           WHEN  'Soundex'  THEN
              sqlstr:=sqlstr||' AND P.PATIDNO='''||v_PATIDNO||'''';
           ELSE
              sqlstr:=sqlstr||' AND P.PATIDNO='''||v_PATIDNO||'''';
        END CASE;
     END IF;
    IF v_PATHTEL is not null THEN
        sqlstr:=sqlstr||' AND P.PATHTEL='''||v_PATHTEL||'''';
    END IF;
    IF v_PATBDATE is not null THEN
        sqlstr:=sqlstr||' AND to_char(P.PATBDATE,''dd/mm/yyyy'')='''||to_char(to_date(v_PATBDATE,'dd/mm/yyyy'),'dd/mm/yyyy')||'''';
    END IF;
    IF v_PATSEX is not null and v_PATSEX<>'-' THEN
        sqlstr:=sqlstr||' AND P.PATSEX='''||v_PATSEX||'''';
    END IF;
    IF v_PATFNAME is not null THEN
          CASE v_SCR
           WHEN 'Cross' THEN
              sqlstr:=sqlstr||' AND P.PATFNAME='''||v_PATFNAME||'''';
           WHEN  'Wildcard' THEN
              sqlstr:=sqlstr||' AND P.PATFNAME  like ''%'||v_PATFNAME||'%''';
           WHEN  'Soundex'  THEN
              sqlstr:=sqlstr||' AND P.PATFNAME='''||v_PATFNAME||'''';
           ELSE
              sqlstr:=sqlstr||' AND P.PATFNAME='''||v_PATFNAME||'''';
          END CASE;

    END IF;
     IF v_PATGNAME is not null THEn
         CASE v_SCR
           WHEN 'Cross' THEN
              sqlstr:=sqlstr||' AND P.PATGNAME='''||v_PATGNAME||'''';
           WHEN  'Wildcard' THEN
              sqlstr:=sqlstr||' AND P.PATGNAME  like ''%'||v_PATGNAME||'%''';
           WHEN  'Soundex'  THEN
              sqlstr:=sqlstr||' AND P.PATGNAME='''||v_PATGNAME||'''';
           ELSE
              sqlstr:=sqlstr||' AND P.PATGNAME='''||v_PATGNAME||'''';
          END CASE;
    END IF;
    IF v_PATMNAME is not null  THEN
         CASE v_SCR
           WHEN 'Cross' THEN
              sqlstr:=sqlstr||' AND P.PATMNAME='''||v_PATMNAME||'''';
           WHEN  'Wildcard' THEN
              sqlstr:=sqlstr||' AND P.PATMNAME  like ''%'||v_PATMNAME||'%''';
           WHEN  'Soundex'  THEN
              sqlstr:=sqlstr||' AND P.PATMNAME='''||v_PATMNAME||'''';
           ELSE
              sqlstr:=sqlstr||' AND P.PATMNAME='''||v_PATMNAME||'''';
          END CASE;
    END IF;


    IF v_ORDBY='Patient Name' THEN
        sqlstr:=sqlstr||' order by P.PATFNAME,P.PATGNAME';
    ELSE
       sqlstr:=sqlstr||' order by P.PATNO';
    END IF;

  OPEN OUTCUR FOR sqlstr;
  RETURN OUTCUR;
END NHS_LIS_PATIENT;