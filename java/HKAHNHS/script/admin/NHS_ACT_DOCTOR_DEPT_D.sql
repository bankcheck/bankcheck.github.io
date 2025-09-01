create or replace
FUNCTION "NHS_ACT_DOCTOR_DEPT_D"
(V_ACTION     IN VARCHAR2,
 V_USERID     in varchar2,
 V_DDLID     in varchar2,
 O_ERRMSG     OUT VARCHAR2)

RETURN NUMBER AS
 O_ERRCODE    number;
 v_noOfRec NUMBER;
BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';
  select COUNT(1) into V_NOOFREC from DOCDPTLINK where DDLID = V_DDLID;
   IF v_noOfRec > 0 THEN
  		delete DOCDPTLINK where DDLID = V_DDLID;
    END IF;
  null;

  return O_ERRCODE;
END NHS_ACT_DOCTOR_DEPT_D;
/