create or replace FUNCTION "NHS_ACT_OTAPP_CANC" (
	v_action     	IN VARCHAR2,
	v_otaid         IN VARCHAR2,
	v_CANCELRSNCDE	IN varchar2,
	v_CANCELISADM	IN varchar2,
	v_CANCELBY	IN varchar2,
	v_CANCELRSNCDE2	IN varchar2,
	v_otacnclrmk	IN varchar2,
	o_errmsg  	OUT varchar2
)
	return number
as
	o_errcode  number;
    V_PATTYPE  OT_APP.PATTYPE%TYPE;
  	V_STECODE VARCHAR2(4);
begin
	o_errcode := 0;
	o_errmsg  := 'OK';

	-- update other bedprebok
	if v_action = 'MOD' then
		update ot_app
		set
			otasts = 'C',
			pbpid = null,
			CANCELISADM = v_CANCELISADM,
			CANCELBY = v_CANCELBY,
			CANCELRSNCDE2 = v_CANCELRSNCDE2,
			otacnclrmk = v_otacnclrmk
		where
			otaid = v_otaid;

        SELECT PATTYPE 
        INTO V_PATTYPE 
        FROM OT_APP
        where otaid = v_otaid;

        SELECT GET_CURRENT_STECODE() 
        INTO V_STECODE
        FROM DUAL;
        
        IF V_PATTYPE = 'D' AND V_STECODE = 'HKAH' THEN
          UPDATE BEDPREBOK
          SET
            BPBSTS = 'D',
            EDITUSER = v_CANCELBY,
            EDITDATE = SYSDATE
          WHERE otaid = v_otaid;       
        END IF;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := SQLERRM;

	RETURN -999;
END NHS_ACT_OTAPP_CANC;
/