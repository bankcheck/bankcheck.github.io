CREATE OR REPLACE FUNCTION NHS_ACT_ADDDEPOSIT(
	v_action      IN VARCHAR2,
	v_amt         IN VARCHAR2,
	v_slpno       IN VARCHAR2,
	v_itmCode     IN VARCHAR2,
	v_cdate       IN VARCHAR2,
	v_tdate       IN VARCHAR2,
	o_errmsg      OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	rs_deposit Deposit%ROWTYPE;
	v_DpsID NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
	if v_action = 'ADD' then
		select seq_deposit.NEXTVAL into v_DpsID from dual;
		rs_deposit.dpsid := v_DpsID;
		rs_deposit.dpsamt := to_number(v_amt);
		rs_deposit.slpno_s := v_slpno;
		rs_deposit.itmcode := v_itmCode;
		if v_cdate is null then
			rs_deposit.dpscdate := sysdate;
			rs_deposit.dpslcdate := sysdate;
		else
			if length(v_cdate) = 10 then
				rs_deposit.dpscdate := to_date(v_cdate,'dd/mm/yyyy');
				rs_deposit.dpslcdate := to_date(v_cdate,'dd/mm/yyyy');
			else
				rs_deposit.dpscdate := to_date(v_cdate,'dd/mm/yyyy hh24:mi:ss');
				rs_deposit.dpslcdate := to_date(v_cdate,'dd/mm/yyyy hh24:mi:ss');
			end if;
		end if;

		if v_tdate is null then
			rs_deposit.dpstdate:=sysdate;
			rs_deposit.dpsltdate:=sysdate;
		else
			if length(v_tdate) = 10 then
				rs_deposit.dpstdate := to_date(v_tdate,'dd/mm/yyyy');
				rs_deposit.dpsltdate := to_date(v_tdate,'dd/mm/yyyy');
			else
				rs_deposit.dpstdate := to_date(v_tdate,'dd/mm/yyyy hh24:mi:ss');
				rs_deposit.dpsltdate := to_date(v_tdate,'dd/mm/yyyy hh24:mi:ss');
			end if;
		end if;
		rs_deposit.dpssts := 'N';--DEPOSIT_STATUS_NORMAL

		insert into Deposit(
			DPSID,
			DPSAMT,
			DPSSTS,
			SLPNO_S,
			SLPNO_T,
			DPSCDATE,
			DPSTDATE,
			DPSLCDATE,
			DPSLTDATE,
			ITMCODE
		) values(
			rs_deposit.DPSID,
			rs_deposit.DPSAMT,
			rs_deposit.DPSSTS,
			rs_deposit.SLPNO_S,
			rs_deposit.SLPNO_T,
			rs_deposit.DPSCDATE,
			rs_deposit.DPSTDATE,
			rs_deposit.DPSLCDATE,
			rs_deposit.DPSLTDATE,
			rs_deposit.ITMCODE
		);

		o_errcode:=v_DpsID;
		if SQL%rowcount=0 then
			o_errcode := -1;
			o_errmsg := 'Insert fail.';
			rollback;

		end if;
	else
		o_errcode :=-1;
		o_errmsg := 'parameter error.';
	end if;
	return(o_errcode);
end NHS_ACT_ADDDEPOSIT;
/
