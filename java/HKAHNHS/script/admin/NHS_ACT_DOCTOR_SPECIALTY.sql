create or replace
FUNCTION "NHS_ACT_DOCTOR_SPECIALTY"
(V_ACTION     IN VARCHAR2,
 V_USERID     in varchar2,
 V_DOCCODE     in varchar2,
 V_TABLE      IN DOCTOR_SPECIALTY_TAB,
 O_ERRMSG     OUT VARCHAR2)

RETURN NUMBER AS
 O_ERRCODE    number;
 v_noOfRec NUMBER;

BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  for I in 1..V_TABLE.COUNT LOOP
    select COUNT(1) into V_NOOFREC from DOCSPCLINK where DSLID = V_TABLE(I).DSLID;    
       if V_NOOFREC = 0 then
         INSERT INTO DOCSPCLINK
          (
            DSLID,
            DOCCODE,
            SPCCODE,
            ISOFFICIAL
          ) values (
            SEQ_docspclink.NEXTVAL,
            V_DOCCODE,
            V_TABLE(I).SPCCODE,
            V_TABLE(I).ISOFFICIAL_NB            
          );
      ELSE
        update docspclink set
          SPCCODE = V_TABLE(I).SPCCODE,
          ISOFFICIAL =  V_TABLE(I).ISOFFICIAL_NB
          where DSLID = V_TABLE(I).DSLID;
      END IF;
  END LOOP;
  null;

  return O_ERRCODE;
END NHS_ACT_DOCTOR_SPECIALTY;
/