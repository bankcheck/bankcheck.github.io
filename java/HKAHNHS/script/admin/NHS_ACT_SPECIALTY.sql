CREATE OR REPLACE FUNCTION "NHS_ACT_SPECIALTY"
(v_action		IN VARCHAR2,
v_SPCCODE	 IN SPEC.SPCCODE%TYPE,
v_SPCNAME		IN SPEC.SPCNAME%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode		NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM SPEC WHERE SPCCODE = v_SPCCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO SPEC
      (
        SPCCODE,
        SPCNAME
      ) VALUES (
        v_SPCCODE,
        v_SPCNAME
      );
    --ELSE
    --  o_errcode := -1;
     -- o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	SPEC
      SET
        SPCNAME			= v_SPCNAME
      WHERE	SPCCODE = v_SPCCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE SPEC WHERE SPCCODE = v_SPCCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_SPECIALTY;
/


