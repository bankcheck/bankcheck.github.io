create or replace function NHS_ACT_HOMELEAVE
(
	v_action in varchar2,
	v_hlId in varchar2,
	v_slpNo in varchar2,
	v_inpId in varchar2,
	v_leave_date in varchar2,
	v_leave_user in varchar2,
	v_return_date in varchar2,
	v_return_user in varchar2,
	o_errmsg out varchar2
)
	return number
as
	o_errcode	number;
	v_noOfRec	number;
	v_newOtcid number;
	l_hlid number;
begin
	o_errcode := 0;
	o_errmsg := 'OK';
	l_hlid := to_number(v_hlId);

	select count(1) into v_noOfRec from home_leave WHERE hlid = l_hlid;

	if v_action = 'ADD' then
		if v_noOfRec = 0 then
			select seq_home_leave.NEXTVAL into v_newOtcid from dual;
	   insert into home_leave
	   values
	   (
		   v_newOtcid,
		   v_slpNo,
		   v_inpId,
		   to_date(v_leave_date,'dd/mm/yyyy hh24:mi:ss'),
		   v_leave_user,
		   to_date(v_return_date,'dd/mm/yyyy hh24:mi:ss'),
		   v_return_user
	   );
		end if;
	elsif v_action = 'MOD' then
		if v_noOfRec > 0 then
			if v_return_date is not null then
				update home_leave
				set leave_date = to_date(v_leave_date,'dd/mm/yyyy hh24:mi:ss'),
					return_date = to_date(v_return_date,'dd/mm/yyyy hh24:mi:ss'),
					return_user = leave_user
				where hlid = v_hlId;
			elsif v_return_date is null then
				update home_leave
				set leave_date = to_date(v_leave_date,'dd/mm/yyyy hh24:mi:ss'),
					return_date = to_date(v_return_date,'dd/mm/yyyy hh24:mi:ss'),
					return_user = ''
				where hlid = v_hlId;
			end if;
		else
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		end if;
	elsif v_action = 'DEL' then
		if v_noOfRec > 0 then
			delete from home_leave where hlid = v_hlId;
		else
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		end if;
	end if;

	return o_errcode;
end NHS_ACT_HOMELEAVE;
/
