CREATE OR REPLACE FUNCTION "NHS_ACT_CASHREF"
(v_action		IN VARCHAR2,
v_CRFID IN VARCHAR2,
v_CRFDESC		CASHREF.CRFDESC%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode		NUMBER;
  v_noOfRec NUMBER;
  V_MAX_ID  NUMBER;

BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM CASHREF WHERE CRFID =to_number(v_CRFID);
  SELECT MAX(CRFID)+1 INTO V_MAX_ID FROM CASHREF;
  --IF V_MAX_ID = NULL THEN
   -- v_max_id:=0;
  --END IF;
	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO CASHREF
         VALUES (
        v_MAX_ID,
        v_CRFDESC
      );

   -- ELSE
    --  o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	CASHREF
      SET
        CRFDESC = v_CRFDESC
      WHERE	CRFID =to_number(v_CRFID);
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE CASHREF WHERE CRFID =to_number(v_CRFID);
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_CASHREF;
/
