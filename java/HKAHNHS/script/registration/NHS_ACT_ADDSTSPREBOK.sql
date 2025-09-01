create or replace function NHS_ACT_ADDSTSPREBOK (
	v_action in varchar2,
	v_pbNo varchar2,
	v_expDate varchar2,
	v_computerName varchar2,
	v_obBokStatus varchar2,
	o_errmsg out varchar2
)
return number as
	o_errcode	number;
begin
	o_errcode := 0;
	o_errmsg := 'OK';
	if v_action = 'ADD' then
		INSERT INTO stsprebok (
			pbno,
			startdate,
			confinedate,
			computername,
			bpbtype
		) VALUES (
			v_pbNo,
			sysdate,
			to_date(v_expDate,'dd/mm/yyyy'),
			v_computerName,
			v_obBokStatus
		);
	else
		o_errmsg := 'update error.';
	end if;

	return o_errcode;
end NHS_ACT_ADDSTSPREBOK;
/
