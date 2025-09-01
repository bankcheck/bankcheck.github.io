CREATE OR REPLACE FUNCTION "NHS_ACT_TITLE"
(v_action		IN VARCHAR2,
v_TITDESC		IN TITLE.TITDESC%TYPE,
v_TITDESC1		IN TITLE.TITDESC%TYPE,
o_errmsg		OUT VARCHAR2)
	RETURN NUMBER
AS
o_errcode		NUMBER;
  v_noOfRec NUMBER;

BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM TITLE WHERE TITDESC = v_TITDESC;


	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO TITLE
         VALUES (
        v_TITDESC
      );

    --ELSE
      --o_errcode := -1;
      --o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
   -- IF v_noOfRec > 0 THEN
      UPDATE	TITLE
      SET
        TITDESC = v_TITDESC
      WHERE	TITDESC = v_TITDESC1;
   -- ELSE
  --  o_errcode := -1;
    --  o_errmsg := 'Fail to update due to record not exist.';
   -- END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE TITLE WHERE TITDESC = v_TITDESC;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_TITLE;
/
