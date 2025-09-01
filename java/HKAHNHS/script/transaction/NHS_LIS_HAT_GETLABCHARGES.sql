create or replace
FUNCTION "NHS_LIS_HAT_GETLABCHARGES"
(
  v_strLabNum in varchar2,
  v_DocCode in varchar2
)
RETURN TYPES.CURSOR_TYPE AS
--RETURN VARCHAR2 AS
OUTCUR TYPES.CURSOR_TYPE;
v_actDocCode DOCTOR.DOCCODE%type;
sqlbuf varchar2(500);
BEGIN
  BEGIN
    SELECT DISTINCT DOCCODE
    INTO v_actDocCode
    FROM HAT_GETLABCHARGES
    WHERE LAB_NUM = V_STRLABNUM;
  EXCEPTION
  WHEN OTHERS THEN  
    v_actDocCode := NULL;
  END;
   
  IF UPPER(V_ACTDOCCODE) = UPPER(V_DOCCODE) THEN
    SQLBUF := 'SELECT H.PATNO,H.LAB_NUM,H.TEST_NUM,H.AMOUNT,H.STAT,H.IREFNO,H.DOCCODE,(';
    sqlbuf := sqlbuf||' SELECT
              DOCCODE
              FROM DOCTOR d, SPEC s
              WHERE d.DocCode=h.DOCCODE
              AND d.SpcCode=s.SpcCode)';
    SQLBUF := SQLBUF||' from HAT_GETLABCHARGES H';
    SQLBUF := SQLBUF||' WHERE LAB_NUM =''' || V_STRLABNUM || '''';            
  ELSE
    SQLBUF := 'SELECT H.PATNO,H.LAB_NUM,H.TEST_NUM,H.AMOUNT,H.STAT,H.IREFNO,H.DOCCODE,(';
    sqlbuf := sqlbuf||' SELECT
              DOCCODE
              FROM DOCTOR d, SPEC s
              WHERE d.DocCode=h.DOCCODE
              AND d.SpcCode=s.SpcCode
              AND docsts=-1)';
    SQLBUF := SQLBUF||' from HAT_GETLABCHARGES H';
    SQLBUF := SQLBUF||' WHERE LAB_NUM =''' || V_STRLABNUM || '''';              
  END IF;
  OPEN OUTCUR FOR	SQLBUF;
  RETURN OUTCUR;
--RETURN SQLBUF;
END NHS_LIS_HAT_GETLABCHARGES;
/