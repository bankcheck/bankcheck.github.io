CREATE OR REPLACE FUNCTION "NHS_ACT_MOTHERLANG"
(v_action		IN VARCHAR2,
v_MOTHCODE	IN MOTHERLANG.MOTHCODE%TYPE,
v_MOTHDESC	IN MOTHERLANG.MOTHDESC%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM MOTHERLANG WHERE MOTHCODE = v_MOTHCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO MOTHERLANG
      (
        MOTHCODE,
        MOTHDESC
      ) VALUES (
        v_MOTHCODE,
        v_MOTHDESC
      );

   -- ELSE
   --   o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	MOTHERLANG
      SET
        MOTHDESC			= v_MOTHDESC
      WHERE	MOTHCODE = v_MOTHCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE MOTHERLANG WHERE MOTHCODE = v_MOTHCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_MOTHERLANG;
/


