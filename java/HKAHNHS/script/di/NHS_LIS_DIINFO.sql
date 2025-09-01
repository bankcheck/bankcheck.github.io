create or replace FUNCTION NHS_LIS_DIINFO 
(
  v_ACTION IN VARCHAR2,
  v_KEY IN VARCHAR2
)

  RETURN Types.cursor_type
AS 
  OUTCUR types.cursor_type;
  v_LOC1 VARCHAR2(1);
  v_LOC2 VARCHAR2(1);
  v_LOC3 VARCHAR2(1);
  v_LOC4 VARCHAR2(1);
  v_LOC5 VARCHAR2(1);
  v_LOC6 VARCHAR2(1);
  SQLSTR VARCHAR2(1000);
  
BEGIN

    IF (v_ACTION = 'DILOC') THEN
        v_LOC1 := 'R';
        v_LOC2 := 'X';
        v_LOC3 := 'P';
        v_LOC4 := 'I';
        v_LOC5 := 'D';
        v_LOC6 := 'O';

        IF(v_KEY = '3') THEN
        SQLSTR := ' SELECT STSKEY,STSDESC 
                    FROM STATUS 
                    WHERE STSCAT =''DILOC''
                    AND STSKEY IN ('''||v_LOC1||''','''||v_LOC2||''','''||v_LOC3||''')';
        ELSIF(v_KEY = '5') THEN
        SQLSTR := ' SELECT STSKEY,STSDESC 
                    FROM STATUS 
                    WHERE STSCAT =''DILOC''
                    AND STSKEY IN ('''||v_LOC2||''','''||v_LOC3||''','''||v_LOC4||''','''||v_LOC5||''','''||v_LOC6||''')';
        END IF;     
    ELSIF(v_ACTION = 'DIUSER') THEN
        SQLSTR := ' SELECT USRID
                    FROM PUSR
                    WHERE USRDI = -1
                    ORDER BY USRID';
    ELSIF(v_ACTION = 'DIDOC') THEN 
        SQLSTR := ' SELECT DISTINCT E.DOCCODE, D.DOCFNAME || '' '' || D.DOCGNAME AS DOCNAME 
                    FROM EXDOCTOR E, DOCTOR D
                    WHERE E.DOCCODE = D.DOCCODE 
                    AND D.DOCSTS <> 0 
                    AND E.EDREXAM = -1
                    ORDER BY DOCNAME';
    
    END IF;

  OPEN OUTCUR FOR SQLSTR;

  RETURN OUTCUR;
  
END NHS_LIS_DIINFO;