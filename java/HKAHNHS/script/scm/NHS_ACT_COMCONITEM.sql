CREATE OR REPLACE FUNCTION "NHS_ACT_COMCONITEM"(V_ACTION     IN VARCHAR2,
                                                V_CID        IN VARCHAR2,
                                                V_PCYID      IN VARCHAR2,
                                                V_ITMCODE    IN VARCHAR2,
                                                V_ITCTYPE    IN VARCHAR2,
                                                V_APPCONTR   IN VARCHAR2,
                                                V_STECODE    IN VARCHAR2,
                                                V_EFF_DT_FRM IN VARCHAR2,
                                                V_EFF_DT_TO  IN VARCHAR2,
                                                O_ERRMSG     OUT VARCHAR2)
  RETURN NUMBER AS
  O_ERRCODE NUMBER;
  V_NOOFREC NUMBER;
BEGIN
  O_ERRCODE := 0;
  O_ERRMSG  := 'OK';
  SELECT COUNT(1) INTO V_NOOFREC FROM CMCITM WHERE CID = V_CID;

  IF V_ACTION = 'ADD' THEN
    IF V_NOOFREC = 0 THEN
      INSERT INTO CMCITM
      VALUES
        (SEQ_CMCITM.NEXTVAL,
         V_PCYID,
         V_ITMCODE,
         V_ITCTYPE,
         V_APPCONTR,
         V_STECODE,
         TO_DATE(V_EFF_DT_FRM, 'DD/MM/YYYY'),
         TO_DATE(V_EFF_DT_TO, 'DD/MM/YYYY'));
    
    END IF;
  ELSIF V_ACTION = 'MOD' THEN
    IF V_NOOFREC > 0 THEN
      UPDATE CMCITM
         SET ITMCODE  = V_ITMCODE,
             ITCTYPE  = V_ITCTYPE,
             APPCONTR = V_APPCONTR,
             STECODE  = V_STECODE
       WHERE CID = V_CID;
    
    ELSE
      O_ERRCODE := -1;
      O_ERRMSG  := 'Fail to update due to record not exist.';
    END IF;
  ELSIF V_ACTION = 'DEL' THEN
    IF V_NOOFREC > 0 THEN
      DELETE CMCITM WHERE CID = V_CID;
    ELSE
      O_ERRCODE := -1;
      O_ERRMSG  := 'Fail to delete due to record not exist.';
    END IF;
  END IF;
  RETURN O_ERRCODE;
END NHS_ACT_COMCONITEM;
/
