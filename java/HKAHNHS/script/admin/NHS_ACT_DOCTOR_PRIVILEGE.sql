create or replace
FUNCTION "NHS_ACT_DOCTOR_PRIVILEGE"
(V_ACTION     IN VARCHAR2,
 V_USERID     in varchar2,
 V_DOCCODE     in varchar2,
 V_TABLE      IN DOCTOR_PRIVILEGE_TAB,
 O_ERRMSG     OUT VARCHAR2)

RETURN NUMBER AS
 O_ERRCODE    number;
 v_noOfRec NUMBER;
BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  for I in 1..V_TABLE.COUNT LOOP
    select COUNT(1) into V_NOOFREC from DOCPRILINK where DPLID = V_TABLE(I).DPLID;
    if V_NOOFREC = 0 then
     INSERT INTO DOCPRILINK
      (
        DPLID,
        DOCCODE,
        PRICODE,
        DPLSDATE,
        DPLTDATE
      ) values (
        SEQ_DOCPRILINK.NEXTVAL,
        V_DOCCODE,
        V_TABLE(I).PRICODE,
        TO_DATE(V_TABLE(I).DPLSDATE,  'DD/MM/YYYY'),
        TO_DATE(V_TABLE(I).DPLTDATE,  'DD/MM/YYYY')
      );
    ELSE
      update DOCPRILINK set
        PRICODE = V_TABLE(I).PRICODE,
        DPLSDATE =  TO_DATE(V_TABLE(I).DPLSDATE,  'DD/MM/YYYY'),
        DPLTDATE = TO_DATE(V_TABLE(I).DPLTDATE,  'DD/MM/YYYY')
        where DPLID = V_TABLE(I).DPLID;
      END IF;
  END LOOP;
  null;

  return O_ERRCODE;
END NHS_ACT_DOCTOR_PRIVILEGE;
/