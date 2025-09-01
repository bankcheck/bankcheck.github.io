CREATE OR REPLACE FUNCTION NHS_ACT_OTAPP (
	v_action in varchar2,
	v_otasts in varchar2,
	v_otaId in varchar2,
	o_errmsg out varchar2
)
	return number
AS
	o_errcode number;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	if v_action = 'MOD' then
		update ot_app
		set    otasts = v_otasts
		where  otaId = v_otaId;
	else
		o_errmsg := 'update error.';
	end if;

	return o_errcode;
END NHS_ACT_OTAPP;
/
