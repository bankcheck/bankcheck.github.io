CREATE OR REPLACE FUNCTION "NHS_ACT_REMLTRSCH"
(v_action		IN VARCHAR2,
v_RLSTYPE	IN varchar2,
V_RLSID	IN varchar2,
V_RLSDAY	IN varchar2,
V_RLSPATH	IN REMLTRSCH.RLSPATH%TYPE,
V_COUCODE	IN REMLTRSCH.COUCODE%TYPE,
V_RLSDEF	IN varchar2,
V_DUEDAY	IN varchar2,
o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
  o_errcode	NUMBER;
  v_noOfRec NUMBER;
  V_RLSID1  NUMBER;
  v_RLSTYPE1 number;
  V_RLSDAY1 number;
  V_RLSDEF1 number;
  V_DUEDAY1 number;

BEGIN
  o_errcode := 0;
  o_errmsg := 'OK';
  V_RLSID1:=to_number(V_RLSID);
  v_RLSTYPE1:=to_number(v_RLSTYPE);
  V_RLSDAY1:=to_number(V_RLSDAY);
  V_RLSDEF1:=to_number(V_RLSDEF);
  V_DUEDAY1:=to_number(V_DUEDAY);

  SELECT count(1) INTO v_noOfRec FROM REMLTRSCH WHERE RLSID = V_RLSID;

	IF v_action = 'ADD' THEN
    IF v_noOfRec = 0 THEN
      select seq_remltrsch.NEXTVAL into V_RLSID1 from dual;
      INSERT INTO REMLTRSCH
      (
        RLSTYPE,
        RLSID,
        RLSDAY,
        RLSPATH,
        COUCODE,
        RLSDEF,
        DUEDAY
      ) VALUES (
        V_RLSTYPE1,
        V_RLSID1,
        V_RLSDAY1,
        V_RLSPATH,
        V_COUCODE,
        V_RLSDEF1,
        V_DUEDAY1
      );

   -- ELSE
     -- o_errcode := -1;
     -- o_errmsg := 'Record already exists.';
    END IF;
	ELSIF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      UPDATE	REMLTRSCH
      SET
        RLSTYPE =V_RLSTYPE1,
        RLSDAY	=V_RLSDAY1,
        RLSPATH	=V_RLSPATH,
        COUCODE	=V_COUCODE,
        RLSDEF	=V_RLSDEF1,
        DUEDAY	=V_DUEDAY1
      WHERE	RLSID = V_RLSID1;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
	ELSIF v_action = 'DEL' THEN
    IF v_noOfRec > 0 THEN
  		DELETE REMLTRSCH WHERE RLSID =V_RLSID1;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to record not exist.';
    END IF;
	END IF;
  RETURN o_errcode;
END NHS_ACT_REMLTRSCH;
/


