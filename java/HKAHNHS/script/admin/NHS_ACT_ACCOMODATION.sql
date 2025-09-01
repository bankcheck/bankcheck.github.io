CREATE OR REPLACE FUNCTION "NHS_ACT_ACCOMODATION"
(v_action		IN VARCHAR2,
v_ACMCODE		IN ACM.ACMCODE%TYPE,
v_ACMNAME		IN ACM.ACMNAME%TYPE,
V_ACMCNAME  IN ACM.ACMCNAME%TYPE,
o_errmsg    OUT VARCHAR2
)
  RETURN NUMBER
AS
  o_errcode NUMBER;
   v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';

  SELECT count(1) INTO v_noOfRec FROM ACM WHERE ACMCODE = v_ACMCODE;

  IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO ACM
      (
        ACMCODE,
        ACMNAME,
        ACMCNAME
      ) VALUES (
        v_ACMCODE,
        v_ACMNAME,
        V_ACMCNAME
      );
   -- ELSE
    --  o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	ACM
      SET
    --    ACMNAME			= v_ACMNAME,
        ACMCNAME     = V_ACMCNAME
      WHERE	ACMCODE = v_ACMCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE ACM WHERE ACMCODE = v_ACMCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
  END IF;
  RETURN o_errcode;
END NHS_ACT_ACCOMODATION;
/
