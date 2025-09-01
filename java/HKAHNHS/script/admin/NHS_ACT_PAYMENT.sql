CREATE OR REPLACE FUNCTION "NHS_ACT_PAYMENT"
(v_action		IN VARCHAR2,
v_PAYCODE   IN PAYCODE.PAYCODE%TYPE,
v_PAYTYPE IN PAYCODE.PAYTYPE%TYPE,
v_PAYDESC  IN PAYCODE.PAYDESC%TYPE,
v_PAYCDESC  IN PAYCODE.PAYCDESC%TYPE,
v_GLCCODE  IN PAYCODE.GLCCODE%TYPE,
v_STECODE  IN PAYCODE.STECODE%TYPE,
v_RETGLCCODE  IN PAYCODE.RETGLCCODE%TYPE,
v_PAYNOTEAR  IN  PAYCODE.PAYNOTEAR%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER

AS
o_errcode		NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM PAYCODE WHERE PAYCODE = v_PAYCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO PAYCODE
      VALUES (
          v_PAYCODE,
          v_PAYTYPE,
          v_PAYDESC,
          v_PAYCDESC,
          v_GLCCODE,
          v_STECODE,
          v_RETGLCCODE,
          v_PAYNOTEAR
      );
    --ELSE
    --  o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	PAYCODE
      SET
          PAYCODE=v_PAYCODE,
          PAYTYPE=v_PAYTYPE,
          PAYDESC=v_PAYDESC,
          PAYCDESC=v_PAYCDESC,
          GLCCODE=v_GLCCODE,
          STECODE=v_STECODE,
          RETGLCCODE=v_RETGLCCODE,
          PAYNOTEAR=v_PAYNOTEAR
      WHERE	PAYCODE = v_PAYCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE PAYCODE WHERE PAYCODE = v_PAYCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_PAYMENT;
/


