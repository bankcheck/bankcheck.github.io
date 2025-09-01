CREATE OR REPLACE FUNCTION "NHS_ACT_DHBIRTHLOGHIST"(V_ACTION    IN VARCHAR2,
                                                    V_BB_PATNO  IN VARCHAR2,
                                                    V_STATUS    IN VARCHAR2,
                                                    V_EDIT_BY   IN VARCHAR2,
                                                    V_REMARK    IN VARCHAR2,
                                                    V_IS_MANUAL IN VARCHAR2,
                                                    O_ERRMSG    OUT VARCHAR2)

 RETURN NUMBER AS
  O_ERRCODE NUMBER;

BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  IF V_ACTION = 'ADD' THEN
    INSERT INTO DHBIRTHHISTORY
    VALUES
      (SEQ_DHHISTORY.NEXTVAL,
       V_BB_PATNO,
       V_STATUS,
       V_EDIT_BY,
       SYSDATE,
       V_REMARK,
       V_IS_MANUAL);
  
  END IF;
  RETURN O_ERRCODE;
END NHS_ACT_DHBIRTHLOGHIST;
/
