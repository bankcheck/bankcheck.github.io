CREATE OR REPLACE FUNCTION "NHS_ACT_CARDRATE"
(v_action		IN VARCHAR2,
v_CRANAME		CARDRATE.CRANAME%TYPE,
v_CRARATE		CARDRATE.CRARATE%TYPE,
v_PAYCODE		CARDRATE.PAYCODE%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM CARDRATE WHERE CRANAME = v_CRANAME;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO CARDRATE
      (
        CRANAME,
        CRARATE,
        PAYCODE
      ) VALUES (
        v_CRANAME,
        v_CRARATE,
        V_PAYCODE
      );

    --ELSE
    --  o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	CARDRATE
      SET
        CRARATE			= v_CRARATE,
        PAYCODE     =V_PAYCODE
      WHERE	CRANAME = v_CRANAME;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE CARDRATE WHERE CRANAME = v_CRANAME;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_CARDRATE;
/


