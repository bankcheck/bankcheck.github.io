-- Deposit.bas \ UnConfirmDeposit
create or replace
FUNCTION NHS_SYS_UNCONFIRMDEPOSIT
(
	v_action    IN VARCHAR2,
	v_slpno     IN VARCHAR2,
	o_errmsg	OUT VARCHAR2
)
	return NUMBER
AS
	o_errcode NUMBER;
begin
	o_errmsg := 'OK';
	o_errcode := 0;

	if v_action = 'MOD' then
		update	Deposit
		set		Dpssts = 'N'	---DEPOSIT_STATUS_NORMAL
		where	slpno_s = v_slpno
		and		DpsSts = 'A';	---DEPOSIT_STATUS_AVAILABLE
	else
		o_errmsg := 'parameter error.';
		o_errcode := -1;
	end if;
	return o_errcode;
end NHS_SYS_UNCONFIRMDEPOSIT
;
/
