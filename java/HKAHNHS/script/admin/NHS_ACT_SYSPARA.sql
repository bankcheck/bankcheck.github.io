CREATE OR REPLACE FUNCTION NHS_ACT_SYSPARA(V_ACTION   IN VARCHAR2,
                                           V_PARCDE   IN VARCHAR2,
                                           V_PARAM1   IN VARCHAR2,
                                           V_PARAM2   IN VARCHAR2,
                                           V_ISNEEDP2 IN VARCHAR2,
                                           O_ERRMSG   OUT VARCHAR2)
  RETURN NUMBER AS
  O_ERRCODE NUMBER;
BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';
  IF V_ACTION = 'MOD' THEN
    IF V_ISNEEDP2 = 'N' THEN
      UPDATE SYSPARAM SET PARAM1 = V_PARAM1 WHERE PARCDE = V_PARCDE;
    ELSE
      UPDATE SYSPARAM
         SET PARAM1 = V_PARAM1, PARAM2 = V_PARAM2
       WHERE PARCDE = V_PARCDE;
    END IF;
  END IF;
  RETURN O_ERRCODE;
END NHS_ACT_SYSPARA;
/
