CREATE OR REPLACE FUNCTION "NHS_ACT_EDULEVEL"
(v_action		IN VARCHAR2,
v_EDUID     IN EDULEVEL.EDUID%TYPE,
v_DESCRIPTION IN EDULEVEL.DESCRIPTION%TYPE,
v_EDUSTS    IN EDULEVEL.EDUSTS%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
o_errcode		NUMBER;
  v_noOfRec NUMBER;
  v_id      NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM EDULEVEL WHERE EDUID = v_EDUID;
  SELECT max(EDUID) + 1 INTO v_id FROM EDULEVEL;
	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO EDULEVEL(
        EDUID,
        DESCRIPTION,
        EDUSTS
      )
       VALUES (
        v_id,
        v_DESCRIPTION,
        v_EDUSTS
      );
   --ELSE
    -- o_errcode := -1;
    -- o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	EDULEVEL
      SET
        DESCRIPTION = v_DESCRIPTION,
        EDUSTS = v_EDUSTS
      WHERE	EDUID = v_EDUID;
   ELSE
     o_errcode := -1;
     o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE EDULEVEL WHERE EDUID = v_EDUID;
   ELSE
     o_errcode := -1;
     o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_EDULEVEL;
/


