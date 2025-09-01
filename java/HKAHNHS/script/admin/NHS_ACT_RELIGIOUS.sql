create or replace
FUNCTION "NHS_ACT_RELIGIOUS"
(v_action		IN VARCHAR2,
v_RELCODE		IN RELIGIOUS.RELCODE%TYPE,
V_RELDESC		in RELIGIOUS.RELDESC%type,
v_OLDCODE IN VARCHAR2,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
o_errcode		NUMBER;
  V_NOOFREC number;
  v_noOfOLDRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  select COUNT(1) into V_NOOFREC from RELIGIOUS where RELCODE = V_RELCODE;
  select COUNT(1) into V_NOOFOLDREC from RELIGIOUS where RELCODE = V_OLDCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO RELIGIOUS
      (
        RELCODE,
        RELDESC
      ) VALUES (
        v_RELCODE,
        v_RELDESC
      );

    ELSE
      o_errcode := -1;
      o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfOLDRec > 0 THEN
      UPDATE	RELIGIOUS
      set
        RELCODE     = V_RELCODE,
        RELDESC			= V_RELDESC
      WHERE	RELCODE = v_OLDCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE RELIGIOUS WHERE RELCODE = v_RELCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
	RETURN o_errcode;
END NHS_ACT_RELIGIOUS;
/


