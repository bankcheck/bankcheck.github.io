CREATE OR REPLACE FUNCTION "NHS_ACT_CALLCHARTPURPOSE"
(v_action		IN VARCHAR2,
v_SEQ       IN CALLCHARTPURPOSE.SEQ%TYPE,
v_PURPOSE   IN CALLCHARTPURPOSE.PURPOSE%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
  v_id      NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM CALLCHARTPURPOSE WHERE SEQ = v_SEQ;
  SELECT max(SEQ) + 1 INTO v_id FROM CALLCHARTPURPOSE;
	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO CALLCHARTPURPOSE
      (
        SEQ,
        PURPOSE
      ) VALUES (
        v_id,
        v_PURPOSE
      );
    ELSE
      o_errcode := -1;
      o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	CALLCHARTPURPOSE
      SET
        PURPOSE = v_PURPOSE
      WHERE	SEQ = v_SEQ;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE CALLCHARTPURPOSE WHERE SEQ = v_SEQ;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_CALLCHARTPURPOSE;
/


