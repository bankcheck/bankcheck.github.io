CREATE OR REPLACE FUNCTION "NHS_ACT_DAYENDUSER"(V_ACTION  IN VARCHAR2,
                                            V_STECODE IN VARCHAR2,
                                            V_USRID   IN VARCHAR2,
                                            V_PWD     IN VARCHAR2,
                                            V_CPTPWD  IN VARCHAR2,
                                            O_ERRMSG  OUT VARCHAR2)
  RETURN NUMBER AS
  O_ERRCODE NUMBER;
  LASTUSR   VARCHAR2(50);
  NEWUSR    VARCHAR2(50);
BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';

  IF V_ACTION = 'MOD' THEN
    UPDATE DAYEND
       SET PASSWD = V_CPTPWD
     WHERE SITECODE = V_STECODE
       AND USRID = V_USRID;
  ELSIF V_ACTION = 'ADD' THEN
    SELECT SITECODE || '$' || USRID
      INTO LASTUSR
      FROM DAYEND
     WHERE SITECODE = V_STECODE;
    NEWUSR := V_STECODE || '$' || V_USRID;
    EXECUTE IMMEDIATE 'DROP USER ' || LASTUSR || ' CASCADE';
    EXECUTE IMMEDIATE 'CREATE USER ' || NEWUSR || ' IDENTIFIED BY t_' ||
                      V_PWD;
    EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE, PBA TO ' || NEWUSR;
    UPDATE DAYEND
       SET USRID = V_USRID, PASSWD = V_CPTPWD
     WHERE SITECODE = V_STECODE;
  END IF;
  RETURN O_ERRCODE;
END NHS_ACT_DAYENDUSER;
/
/*
begin
  -- Call the function
  :result := nhs_act_dayenduser(v_action => :v_action,
                                v_stecode => :v_stecode,
                                v_usrid => :v_usrid,
                                v_pwd => :v_pwd,
                                v_cptpwd => :v_cptpwd,
                                o_errmsg => :o_errmsg);
end;
*/