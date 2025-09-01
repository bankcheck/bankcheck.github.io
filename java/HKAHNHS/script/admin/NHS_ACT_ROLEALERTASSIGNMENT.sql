CREATE OR REPLACE FUNCTION "NHS_ACT_ROLEALERTASSIGNMENT"
(v_action   IN VARCHAR2,
 v_ROLID	IN ROLE.ROLID%TYPE,
 v_ALTID    IN ALERT.ALTID%TYPE,
 v_ALTCODE  IN ALERT.ALTCODE%TYPE,
 v_ALTDESC  IN ALERT.ALTDESC%TYPE,
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
  SELECT count(1) INTO v_noOfRec FROM ROLALTLINK
    WHERE ROLID = v_ROLID
    AND   ALTID = v_ALTID;

  IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO ROLALTLINK
       (ROLID,
        ALTID)
      VALUES
       (v_ROLID,
        v_ALTID);
    ELSE
      o_errcode := -1;
      o_errmsg := 'Record already exists.';
    END IF;

 ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
      DELETE ROLALTLINK
      WHERE ALTID = v_ALTID
      AND   ROLID = v_ROLID;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
  END IF;
  RETURN o_errcode;
END NHS_ACT_ROLEALERTASSIGNMENT;
/


