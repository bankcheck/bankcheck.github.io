CREATE OR REPLACE FUNCTION "NHS_ACT_SOURCE"
(v_action		IN VARCHAR2,
v_SRCCODE		IN SOURCE.SRCCODE%TYPE,
v_SRCDESC		IN SOURCE.SRCDESC%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM SOURCE WHERE SRCCODE = v_SRCCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO SOURCE
      (
        SRCCODE,
        SRCDESC
      ) VALUES (
        v_SRCCODE,
        v_SRCDESC
      );

   -- ELSE
     -- o_errcode := -1;
      --o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	SOURCE
      SET
        SRCDESC			= v_SRCDESC
      WHERE	SRCCODE = v_SRCCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE SOURCE WHERE SRCCODE = v_SRCCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_SOURCE;
/


