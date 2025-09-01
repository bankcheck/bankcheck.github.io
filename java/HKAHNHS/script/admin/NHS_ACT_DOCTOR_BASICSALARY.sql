create or replace
FUNCTION "NHS_ACT_DOCTOR_BASICSALARY"
(V_ACTION     IN VARCHAR2,
 V_USERID     in varchar2,
 V_DOCCODE     in varchar2,
 V_TABLE      IN DOCTOR_BASICSALARY_TAB,
 O_ERRMSG     OUT VARCHAR2)

RETURN NUMBER AS
 O_ERRCODE    number;
 v_noOfRec NUMBER;

BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  for I in 1..V_TABLE.COUNT LOOP
  select COUNT(1) into V_NOOFREC from DOCBASSAL where DbsID = V_TABLE(I).dbsID;
  if V_NOOFREC = 0 then
     INSERT INTO DOCBASSAL
      (
        DBSID,
        DOCCODE,
        DBSAMT,
        DBSSDATE,
        DBSEDATE
      ) values (
        SEQ_DOCBASSAL.NEXTVAL,
        V_DOCCODE,
        V_TABLE(I).DBSAMT,
        TO_DATE(V_TABLE(I).DBSSDATE,  'DD/MM/YYYY'),
        TO_DATE(V_TABLE(I).DBSEDATE,  'DD/MM/YYYY')
      );
    ELSE
      update DOCBASSAL set
        dbsamt = V_TABLE(I).dbsamt,
        dbssdate =  TO_DATE(V_TABLE(I).dbssdate,  'DD/MM/YYYY'),
        dbsedate = TO_DATE(V_TABLE(I).dbsedate,  'DD/MM/YYYY')
        where DBSID = V_TABLE(I).DBSID;
     END IF;
  END LOOP;
  null;

  return O_ERRCODE;
END NHS_ACT_DOCTOR_BASICSALARY;
/