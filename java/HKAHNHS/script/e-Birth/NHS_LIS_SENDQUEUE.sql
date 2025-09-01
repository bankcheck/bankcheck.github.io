create or replace
FUNCTION "NHS_LIS_SENDQUEUE"(
  I_FLAG IN VARCHAR2)
RETURN TYPES.CURSOR_TYPE AS
  CHKBOXVAL VARCHAR2(5);
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN

  IF I_FLAG = 'Y' THEN
    CHKBOXVAL := 'true';
  ELSE
    CHKBOXVAL := 'false';
  END IF;

  OPEN OUTCUR FOR
    SELECT '',
           '',
           MO_PATNO,
           MO_FNAME || ' ' || MO_GNAME,
           BB_PATNO,
           BB_FNAME || ' ' || BB_GNAME,
           '' || CHKBOXVAL || '',
           TO_CHAR(BB_DOB, 'DD/MM/YYYY'),
           CONFIRMBY,
           TO_CHAR(COMFIRMDATE,'DD/MM/YYYY HH24:MI:SS'),
           '' || I_FLAG || ''
      FROM EBIRTHDTL
     WHERE RECSTATUS = 'C'
       AND FORCE_SEND IS NULL;
  RETURN OUTCUR;
END NHS_LIS_SENDQUEUE;
/
