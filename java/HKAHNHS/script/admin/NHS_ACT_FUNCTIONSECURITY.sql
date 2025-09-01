CREATE OR REPLACE FUNCTION "NHS_ACT_FUNCTIONSECURITY"
(v_action   IN VARCHAR2,
 v_ROLID	IN ROLE.ROLID%TYPE,
 v_FSCID    IN FUNCSEC.FSCID%TYPE,
 v_FSCDESC  IN FUNCSEC.FSCDESC%TYPE,
 o_errmsg   OUT VARCHAR2
)
  RETURN NUMBER
AS
  o_errcode NUMBER;
  v_noOfRec NUMBER;
  v_maxid NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM ROLEFUNCSEC
    WHERE ROLID = v_ROLID
    AND   FSCID = v_FSCID;
  SELECT MAX(RFSID) + 1 INTO v_maxid FROM ROLEFUNCSEC;

  IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO ROLEFUNCSEC
        (RFSID,
         ROLID,
         FSCID)
      VALUES
        (v_maxid,
         v_ROLID,
         v_FSCID);
    ELSE
      o_errcode := -1;
      o_errmsg := 'Record already exists.';
    END IF;

  ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
      DELETE ROLEFUNCSEC
      WHERE FSCID = v_FSCID
      AND   ROLID = v_ROLID;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
  END IF;
  RETURN o_errcode;
END NHS_ACT_FUNCTIONSECURITY;
/


