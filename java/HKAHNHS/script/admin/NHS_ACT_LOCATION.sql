CREATE OR REPLACE FUNCTION "NHS_ACT_LOCATION"
(v_action		IN VARCHAR2,
v_LOCCODE		IN LOCATION.LOCCODE%TYPE,
v_LOCNAME		IN LOCATION.LOCNAME%TYPE,
v_DSTCODE		IN LOCATION.DSTCODE%TYPE,
v_STECODE		IN LOCATION.STECODE%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM LOCATION WHERE LOCCODE = v_LOCCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO LOCATION
       VALUES (
        v_LOCCODE,
        v_LOCNAME,
        V_DSTCODE,
        v_stecode
      );
   -- ELSE
     -- o_errcode := -1;
     -- o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	LOCATION
      SET
        LOCNAME			= v_LOCNAME,
        DSTCODE     = v_dstcode,
        stecode     = v_stecode
      WHERE	LOCCODE = v_LOCCODE;

    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE LOCATION WHERE LOCCODE = v_LOCCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_LOCATION;
/


