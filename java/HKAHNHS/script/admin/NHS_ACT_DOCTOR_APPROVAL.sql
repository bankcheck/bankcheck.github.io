create or replace
FUNCTION "NHS_ACT_DOCTOR_APPROVAL"
(V_ACTION     IN VARCHAR2,
 V_USERID     in varchar2,
 V_DOCCODE     in varchar2,
 V_TABLE      IN DOCTOR_APPROVAL_TAB,
 O_ERRMSG     OUT VARCHAR2)

RETURN NUMBER AS
 O_ERRCODE    number;
  v_noOfRec NUMBER;

BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  for I in 1..V_TABLE.COUNT LOOP
    select COUNT(1) into V_NOOFREC from DOCAPVLINK where DALID = V_TABLE(I).DALID;
    if V_NOOFREC = 0 then
     INSERT INTO DOCAPVLINK
      (
        DALID,
        DOCCODE,
        CMTNAME,
        ACTNO,
        APVDATE
      ) values (
        SEQ_DOCAPVLINK.NEXTVAL,
        V_DOCCODE,
        V_TABLE(I).CMTNAME,
        V_TABLE(I).ACTNO,
        TO_DATE(V_TABLE(I).APVDATE,  'DD/MM/YYYY')
      );
    ELSE
        update DOCAPVLINK set
          CMTNAME = V_TABLE(I).CMTNAME,
          ACTNO   = V_TABLE(I).ACTNO,
          APVDATE =  TO_DATE(V_TABLE(I).APVDATE,  'DD/MM/YYYY')
          where DALID = V_TABLE(I).DALID;      
      end if;
    end LOOP;
  null;

  return O_ERRCODE;
END NHS_ACT_DOCTOR_APPROVAL;
/