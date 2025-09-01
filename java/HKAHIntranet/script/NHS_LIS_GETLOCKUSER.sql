create or replace
FUNCTION NHS_LIS_GETLOCKUSER (
V_sLockType IN VARCHAR2,
V_sLockKey IN VARCHAR2
)
RETURN TYPES.CURSOR_TYPE AS 
li_count NUMBER;
ls_lockUser VARCHAR2(10);
OUTCUR TYPES.CURSOR_TYPE;
o_errcode NUMBER := 0; 
o_errmsg VARCHAR2(1000); 
BEGIN
  SELECT usrID
  INTO ls_lockUser
  FROM rlock@iweb  
  WHERE rlkType = V_sLockType
  and rlkKey = V_sLockKey;
  
  o_errcode := 1;
  o_errmsg := ls_lockUser;

  OPEN OUTCUR FOR
  SELECT o_errcode,o_errmsg FROM DUAL;
  
  RETURN OUTCUR;
  EXCEPTION
  WHEN OTHERS THEN
    o_errcode := 0;
    o_errmsg := 'NO LOCK RECORD FOUND';
    OPEN OUTCUR FOR
    SELECT o_errcode,o_errmsg FROM DUAL;
    RETURN OUTCUR;
    dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM); 
END NHS_LIS_GETLOCKUSER;