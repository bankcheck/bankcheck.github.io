CREATE OR REPLACE FUNCTION "NHS_ACT_DESTINATION"
(v_action		IN VARCHAR2,
v_DESCODE		DEST.DESCODE%TYPE,
v_DESDESC	DEST.DESDESC%TYPE,
V_DESTYPE   DEST.DESTYPE%TYPE,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM DEST WHERE DESCODE = v_DESCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO DEST
      VALUES (
        v_DESCODE,
        v_DESDESC,
        V_DESTYPE
      );
   -- ELSE
     -- o_errcode := -1;
     -- o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	DEST
      SET
        DESDESC		= v_DESDESC,
        DESTYPE    = V_DESTYPE

      WHERE	DESCODE = v_DESCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE DEST WHERE DESCODE = v_DESCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_DESTINATION;
/


