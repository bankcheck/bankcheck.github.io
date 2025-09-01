CREATE OR REPLACE FUNCTION "NHS_ACT_PATIENTCATEGORY"
(v_action		IN VARCHAR2,
v_PCYID   IN VARCHAR2,
v_PCYCODE IN VARCHAR2,
v_PCYDESC IN VARCHAR2,
v_PCYREF  IN VARCHAR2,
v_PCYSCM  IN VARCHAR2,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
o_errcode		NUMBER;
  v_noOfRec NUMBER;
  v_id NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  v_id := 0;
  SELECT count(1) INTO v_noOfRec FROM PATCAT WHERE PCYID =to_number(v_PCYID);
  SELECT max(PCYID) + 1 INTO v_id FROM PATCAT;
	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO PATCAT(
        PCYID,
        PCYCODE,
        PCYDESC,
        PCYREF,
        PCYSCM
      )
       VALUES (
        v_id,
        v_PCYCODE,
        v_PCYDESC,
        to_number(v_PCYREF),
        to_number(v_PCYSCM)
      );
  ---  ELSE
  --    o_errcode := -1;
  --    o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	PATCAT
      SET
        PCYCODE =v_PCYCODE,
        PCYDESC = v_PCYDESC,
        PCYREF =to_number(v_PCYREF),
        PCYSCM =to_number(v_PCYSCM)
      WHERE	PCYID =to_number(v_PCYID);
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE PATCAT WHERE PCYID =to_number(v_PCYID);
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_PATIENTCATEGORY;
/
