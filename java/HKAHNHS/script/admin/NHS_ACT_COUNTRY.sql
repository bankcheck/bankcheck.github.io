CREATE OR REPLACE FUNCTION "NHS_ACT_COUNTRY"
(v_action		IN VARCHAR2,
v_COUCODE		COUNTRY.COUCODE%TYPE,
v_COUDESC		COUNTRY.COUDESC%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM COUNTRY WHERE COUCODE = v_COUCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO COUNTRY
      (
        COUCODE,
        COUDESC
      ) VALUES (
        v_COUCODE,
        v_COUDESC
      );

    --ELSE
     -- o_errcode := -1;
     -- o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	COUNTRY
      SET
        COUDESC			= v_COUDESC
      WHERE	COUCODE = v_COUCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE COUNTRY WHERE COUCODE = v_COUCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_COUNTRY;
/


