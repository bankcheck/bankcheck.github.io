create or replace
FUNCTION "NHS_ACT_DEPTAPP_CANC"
(
    v_action     	IN VARCHAR2,
    v_deptaid		 	IN VARCHAR2,
    V_CANCELRSNCDE	in varchar2,
    v_CANCELISADM	IN varchar2,
    V_CANCELBY		in varchar2,
    V_CANCELRSNCDE2	in varchar2,
	  v_deptacnclrmk	IN varchar2,
    o_errmsg  		out varchar2
)
return number
as
  o_errcode  number;
begin
  o_errcode := 0;
  o_errmsg  := 'OK';

  if v_action = 'MOD' then
	  update dept_app
	  set
		deptasts = 'C',
	    CANCELISADM = v_CANCELISADM,
	    CANCELBY = V_CANCELBY,
	    CANCELRSNCDE2 = v_CANCELRSNCDE2,
		deptacnclrmk = v_deptacnclrmk
	  where
	  	deptaid = v_deptaid;
  END IF;

  RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := SQLERRM;

	RETURN -999;
END NHS_ACT_DEPTAPP_CANC;
/