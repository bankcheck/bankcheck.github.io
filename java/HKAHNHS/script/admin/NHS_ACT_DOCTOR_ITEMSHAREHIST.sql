create or replace
FUNCTION "NHS_ACT_DOCTOR_ITEMSHAREHIST"
(V_ACTION     IN VARCHAR2,
 V_USERID     in varchar2,
 V_DOCCODE     in varchar2,
 V_SITECODE     in varchar2,
 V_TABLE      IN DOCTOR_ITEMSHAREHIST_TAB,
 O_ERRMSG     OUT VARCHAR2)

RETURN NUMBER AS
 O_ERRCODE    number;
 v_noOfRec NUMBER;

BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  for I in 1..V_TABLE.COUNT LOOP
    select COUNT(1) into V_NOOFREC from DOCITMPCTHIST where DIPHID = V_TABLE(I).DIPHID;
     if V_NOOFREC = 0 then
       INSERT INTO DOCITMPCTHIST
        (
          DIPHID,
          DOCCODE,
		  CONSTARTDATE,
		  CONENDDATE,          
          SLPTYPE,
          PCYID,
          DSCCODE,
          ITMCODE,
          DIPPCT,
          DIPFIX,
          STECODE
        ) values (
          SEQ_DOCITMPCTHIST.NEXTVAL,
          V_DOCCODE,
          TO_DATE(V_TABLE(I).CONSTARTDATE, 'DD/MM/YYYY'),
          TO_DATE(V_TABLE(I).CONENDDATE, 'DD/MM/YYYY'),          
          V_TABLE(I).SLPTYPE,
          V_TABLE(I).PCYID,
          V_TABLE(I).DSCCODE,
          V_TABLE(I).ITMCODE,
          V_TABLE(I).DIPPCT,
          V_TABLE(I).DIPFIX,
          V_SITECODE
        );
    ELSE
      update DOCITMPCTHIST set
        CONSTARTDATE = TO_DATE(V_TABLE(I).CONSTARTDATE, 'DD/MM/YYYY'),
        CONENDDATE =  TO_DATE(V_TABLE(I).CONENDDATE, 'DD/MM/YYYY'),      
        SLPTYPE = V_TABLE(I).SLPTYPE,
        PCYID   = V_TABLE(I).PCYID,
        DSCCODE = V_TABLE(I).DSCCODE,
        ITMCODE = V_TABLE(I).ITMCODE,
        DIPPCT = V_TABLE(I).DIPPCT,
        DIPFIX = V_TABLE(I).DIPFIX
        where DIPHID = V_TABLE(I).DIPHID;
    END IF;
  END LOOP;
  null;

  return O_ERRCODE;
END NHS_ACT_DOCTOR_ITEMSHAREHIST;
/