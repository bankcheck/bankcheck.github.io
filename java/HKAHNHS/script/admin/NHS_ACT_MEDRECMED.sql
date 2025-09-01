CREATE OR REPLACE FUNCTION "NHS_ACT_MEDRECMED"
(v_action		IN VARCHAR2,
v_MRMDESC		IN MEDRECMED.MRMDESC%TYPE,
v_AUTOADD	IN MEDRECMED.AUTOADD%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
  V_MAX_ID  NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM MEDRECMED WHERE MRMDESC = v_MRMDESC;
  SELECT MAX(MRMID)+1 INTO V_MAX_ID FROM MEDRECMED;
	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO MEDRECMED
      (
        MRMID,
        MRMDESC,
        AUTOADD
      ) VALUES (
        V_MAX_ID,
        v_MRMDESC,
        v_AUTOADD
      );

   -- ELSE
    --  o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	MEDRECMED
      SET
        AUTOADD			= v_AUTOADD
      WHERE	MRMDESC = v_MRMDESC;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE MEDRECMED WHERE MRMDESC = v_MRMDESC;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_MEDRECMED;
/


