CREATE OR REPLACE FUNCTION "NHS_ACT_DEPTSERVICE"
(v_action		IN VARCHAR2,
v_DSCCODE		IN DPSERV.DSCCODE%TYPE,
v_DSCDESC		IN DPSERV.DSCDESC%TYPE,
v_DSCCDESC	IN 	DPSERV.DSCCDESC%TYPE,
o_errmsg		OUT VARCHAR2
)

	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  SELECT count(1) INTO v_noOfRec FROM DPSERV WHERE DSCCODE = v_DSCCODE;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      INSERT INTO DPSERV
      VALUES (
        v_DSCCODE,
        v_DSCDESC,
        V_DSCCDESC
      );

   -- ELSE
    --  o_errcode := -1;
     -- o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	DPSERV
      SET
        DSCDESC			= v_DSCDESC,
        DSCCDESC    = v_dsccdesc
      WHERE	DSCCODE = v_DSCCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE DPSERV WHERE DSCCODE = v_DSCCODE;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_DEPTSERVICE;
/


