create or replace function RECORDLOCK (
	v_type in varchar2,
	v_key in varchar2,
	v_errmsg out varchar2
)
	return boolean
is
	e_invalid_stecode exception;
	e_slip_lock_by_other exception;
	pragma exception_init (e_slip_lock_by_other, -1);
	v_usrid rlock.usrid%type := GET_CURRENT_USRID;
	v_rlkmac rlock.rlkmac%type;
	v_usrname usr.usrname%type;
	v_stecode varchar2(10) := GET_CURRENT_STECODE();
	v_record number;
	v_terminal varchar2(16) := 'HATS_' || userenv('SESSIONID');
begin
	if v_stecode is null then
		v_errmsg := 'Invalid user site code.';
		raise e_invalid_stecode;
	end if;

	insert into rlock values(seq_rlock.nextval, v_usrid, v_type, v_key, sysdate, v_terminal, v_stecode);
	return true;
exception
when e_slip_lock_by_other then
	begin
		select usrid, rlkmac into v_usrid, v_rlkmac from rlock where rlktype = v_type and rlkkey = v_key;
		select count(1) into v_record from usr where usrid = v_usrid;
		-- diff user lock
		if v_record = 1 then
			select usrname into v_usrname from usr where usrid = v_usrid;
			v_errmsg := 'The ' || lower(v_type) || ' is being locked by ' || v_usrname || ' in pc [' || v_rlkmac || '].';
		else
			v_errmsg := 'The ' || lower(v_type) || ' is being locked by ' || v_usrid || ' in pc [' || v_rlkmac || '].';
		end if;
	exception
	when NO_DATA_FOUND then
		v_errmsg := 'The ' || lower(v_type) || ' is being locked by other.';
	end;
	return false;
when e_invalid_stecode then
	return false;
end;
/
