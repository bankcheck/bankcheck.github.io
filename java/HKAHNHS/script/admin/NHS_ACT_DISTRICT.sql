CREATE OR REPLACE FUNCTION "NHS_ACT_DISTRICT"
(v_action		IN VARCHAR2,
v_DSTCODE		DISTRICT.DSTCODE%TYPE,
v_DSTNAME		DISTRICT.DSTNAME%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode		NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM DISTRICT WHERE DSTCODE = v_DSTCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO DISTRICT
      (
        DSTCODE,
        DSTNAME
      ) VALUES (
        v_DSTCODE,
        v_DSTNAME
      );
   -- ELSE
    --  o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	DISTRICT
      SET
        DSTNAME			= v_DSTNAME
      WHERE	DSTCODE = v_DSTCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE DISTRICT WHERE DSTCODE = v_DSTCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_DISTRICT;
/


