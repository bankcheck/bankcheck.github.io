CREATE OR REPLACE FUNCTION "NHS_ACT_PRIVILEGE"
(v_action		IN VARCHAR2,
v_PRICODE		PRIVILEGE.PRICODE%TYPE,
v_PRINAME		PRIVILEGE.PRINAME%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  O_errcode	NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM PRIVILEGE WHERE PRICODE = v_PRICODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO PRIVILEGE
      (
        PRICODE,
        PRINAME
      ) VALUES (
        v_PRICODE,
        v_PRINAME
      );
   -- ELSE
     -- o_errcode := -1;
     -- o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	PRIVILEGE
      SET
        PRINAME			= v_PRINAME
      WHERE	PRICODE = v_PRICODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE PRIVILEGE WHERE PRICODE = v_PRICODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_PRIVILEGE;
/


