CREATE OR REPLACE FUNCTION "NHS_ACT_CUSRPT"
(v_action		IN VARCHAR2,
v_CURDESC		CUSRPT.CURDESC%TYPE,
v_CURPATH		CUSRPT.CURPATH%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
  V_CURID NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM CUSRPT WHERE CURDESC = v_CURDESC;
  SELECT MAX(CURID)+1 INTO V_CURID FROM CUSRPT;
  IF V_CURID = NULL THEN
    V_CURID:=0;
  END IF;
	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO CUSRPT
      (
        CURID,
        CURDESC,
        CURPATH
      ) VALUES (
        V_CURID,
        v_CURDESC,
        v_CURPATH
      );

    --ELSE
     -- o_errcode := -1;
     -- o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	CUSRPT
      SET
        CURID       = V_CURID,
        CURPATH			= v_CURPATH
      WHERE	CURDESC = v_CURDESC;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE CUSRPT WHERE CURDESC = v_CURDESC;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_CUSRPT;
/


