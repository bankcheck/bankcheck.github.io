CREATE OR REPLACE FUNCTION "NHS_ACT_SICK"
(v_action		IN VARCHAR2,
v_SCKCODE		SICK.SCKCODE%TYPE,
v_SCKDESC	SICK.SCKDESC%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM SICK WHERE SCKCODE = v_SCKCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO SICK
      (
        SCKCODE,
        SCKDESC
      ) VALUES (
        v_SCKCODE,
        v_SCKDESC
      );

   -- ELSE
     -- o_errcode := -1;
    --  o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	SICK
      SET
        SCKDESC		= v_SCKDESC
      WHERE	SCKCODE = v_SCKCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE SICK WHERE SCKCODE = v_SCKCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_SICK;
/


