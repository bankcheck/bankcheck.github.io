CREATE OR REPLACE FUNCTION "NHS_ACT_QUALIFICATION"
(v_action		IN VARCHAR2,
v_QLFID		QUALIFICATION.QLFID%TYPE,
v_QLFNAME		QUALIFICATION.QLFNAME%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
o_errcode	 NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM QUALIFICATION WHERE QLFID = v_QLFID;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO QUALIFICATION
      (
        QLFID,
        QLFNAME
      ) VALUES (
        v_QLFID,
        v_QLFNAME
      );
    --ELSE
     -- o_errcode := -1;
     -- o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	QUALIFICATION
      SET
        QLFNAME			= v_QLFNAME
      WHERE	QLFID = v_QLFID;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE QUALIFICATION WHERE QLFID = v_QLFID;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_QUALIFICATION;
/


