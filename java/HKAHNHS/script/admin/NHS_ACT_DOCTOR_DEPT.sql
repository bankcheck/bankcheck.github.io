create or replace
FUNCTION "NHS_ACT_DOCTOR_DEPT"
(V_ACTION     IN VARCHAR2,
 V_USERID     in varchar2,
 V_DOCCODE     in varchar2,
 V_TABLE      IN DOCTOR_DEPT_TAB,
 O_ERRMSG     OUT VARCHAR2)

RETURN NUMBER AS
 O_ERRCODE    number;
 v_noOfRec NUMBER;

BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  for I in 1..V_TABLE.COUNT LOOP
      select COUNT(1) into V_NOOFREC from  DOCDPTLINK where DDLID = V_TABLE(I).DDLID;
       if V_NOOFREC = 0 then
          INSERT INTO DOCDPTLINK
        (
          DDLID,
          DOCCODE,
          DPTCODE
        ) values (
          SEQ_DOCDPTLINK.NEXTVAL,
          V_DOCCODE,
          V_TABLE(I).DPTCODE
        );
      ELSE
        update DOCDPTLINK set
        DPTCODE = V_TABLE(I).DPTCODE
        where DDLID = V_TABLE(I).DDLID;
       END IF;
  END LOOP;
  null;

  return O_ERRCODE;
END NHS_ACT_DOCTOR_DEPT;
/