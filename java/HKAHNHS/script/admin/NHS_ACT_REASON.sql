CREATE OR REPLACE FUNCTION "NHS_ACT_REASON"
(v_action		IN VARCHAR2,
v_RSNCODE		IN REASON.RSNCODE%TYPE,
v_RSNDESC		IN REASON.RSNDESC%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM REASON WHERE RSNCODE = v_RSNCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO REASON
      VALUES (
        v_RSNCODE,
        v_RSNDESC
      );
   -- ELSE
    --  o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	REASON
      SET
        RSNDESC			= v_RSNDESC
      WHERE	RSNCODE = v_RSNCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE REASON WHERE RSNCODE = v_RSNCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_REASON;
/


