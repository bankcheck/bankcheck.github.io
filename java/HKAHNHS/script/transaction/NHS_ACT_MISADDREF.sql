CREATE OR REPLACE FUNCTION "NHS_ACT_MISADDREF"(V_ACTION    IN VARCHAR2,
                                               V_TABNAME   IN VARCHAR2,
                                               V_TABID     IN VARCHAR2,
                                               V_MARPAYEE  IN VARCHAR2,
                                               V_MARADD1   IN VARCHAR2,
                                               V_MARADD2   IN VARCHAR2,
                                               V_MARADD3   IN VARCHAR2,
                                               V_MARREASON IN VARCHAR2,
                                               V_COUNTRY   IN VARCHAR2,
                                               O_ERRMSG    OUT VARCHAR2)

 RETURN NUMBER AS
  O_ERRCODE NUMBER;

BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  IF V_ACTION = 'ADD' THEN
    INSERT INTO MISADDREF
    VALUES
      (SEQ_MISADDREF.NEXTVAL,
       V_TABNAME,
       V_TABID,
       V_MARPAYEE,
       V_MARADD1,
       V_MARADD2,
       V_MARADD3,
       V_MARREASON,
       V_COUNTRY);
  
  END IF;
  RETURN O_ERRCODE;
END NHS_ACT_MISADDREF;
/
