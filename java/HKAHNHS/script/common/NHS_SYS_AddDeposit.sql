create or replace function NHS_SYS_AddDeposit (
-- Deposit.bas \ AddDeposit
	p_DpsAmt Deposit.DpsAmt%TYPE,
	p_SlpNo Deposit.SlpNo_S%TYPE,
	p_ItmCode Deposit.ItmCode%TYPE,
	p_DpsCDate Deposit.DpsTDate%TYPE,
	p_DpsTDate Deposit.DpsTDate%TYPE
) return Deposit.DpsId%TYPE is
	l_DpsId Deposit.DpsId%TYPE ;
	DEPOSIT_STATUS_NORMAL VARCHAR2(1) := 'N';
begin
	select Seq_Deposit.NEXTVAL into l_DpsId from dual ;

	insert into Deposit ( DpsId, DpsAmt, SlpNo_S, ItmCode, DpsCDate, DpsTDate, DpsLCDate, DpsLTDate, DpsSts )
	values ( l_DpsId, p_DpsAmt, p_SlpNo, p_ItmCode, nvl( p_DpsCDate, sysdate ), nvl( p_DpsTDate, sysdate ), nvl( p_DpsCDate, sysdate ), nvl( p_DpsTDate, sysdate ), DEPOSIT_STATUS_NORMAL ) ;

	return l_DpsId ;
end ;
/
