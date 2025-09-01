create or replace
FUNCTION "NHS_ACT_EBIRTHEDIT"(V_ACTION  IN VARCHAR2,
                                                     V_BBPATNO IN VARCHAR2,
                                                     V_USER    IN VARCHAR2,
                                                     O_ERRMSG  OUT VARCHAR2)

 RETURN NUMBER AS
  O_ERRCODE NUMBER;

BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  INSERT INTO EBIRTHHISTORY
  VALUES
    (SEQ_EBIRTHHISTORY.NEXTVAL,
     V_BBPATNO,
     'Edit',
     V_USER,
     SYSDATE,
     NULL,
     NULL);
  RETURN O_ERRCODE;
END NHS_ACT_EBIRTHEDIT;
/