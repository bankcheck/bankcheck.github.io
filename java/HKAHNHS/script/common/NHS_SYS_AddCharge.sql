-- TxnCharge.frm \ PostTransactions
create or replace procedure NHS_SYS_AddCharge(
	p_usrid varchar2,
	p_TranMode varchar2, -- TXN_ADD_MODE : ADD
	p_ItmCode Item.ItmCode%TYPE,
	p_ItmType Item.ItmType%TYPE,
	p_ItmCat Item.ItmCat%TYPE,
	-- Deposit columns : begin
	p_DpsAmt Deposit.DpsAmt%TYPE,  -- doCharge.StnBAmt
	p_SlpNo Deposit.SlpNo_S%TYPE,
	p_DpsCDate Deposit.DpsTDate%TYPE,
	p_DpsTDate Deposit.DpsTDate%TYPE,
	-- Deposit columns : end

	-- AddSlipTx : Begin
	p_StnType SlipTx.StnType%TYPE,
	p_StnOAmt SlipTx.StnOAmt%TYPE,
	p_StnBAmt SlipTx.StnBAmt%TYPE,
	p_DocCode SlipTx.DocCode%TYPE,
	p_StnRlvl SlipTx.StnRlvl%TYPE,
	p_AcmCode SlipTx.AcmCode%TYPE,
	p_StnDisc SlipTx.StnDisc%TYPE,
	p_PkgCode SlipTx.PkgCode%TYPE,
	p_StnCDate SlipTx.StnCDate%TYPE,
	p_StnTDate SlipTx.StnTDate%TYPE,
	p_StnDesc SlipTx.StnDesc%TYPE,
	p_StnSts SlipTx.StnSts%TYPE,
	p_GlcCode SlipTx.GlcCode%TYPE,
	p_StnXRef SlipTx.StnXRef%TYPE,
	p_BedCode Bed.BedCode%TYPE,
	p_DixRef SlipTx.DixRef%TYPE,
	p_StnDiFlag SlipTx.StnDiFlag%TYPE,
	p_StnCpsFlag SlipTx.StnCpsFlag%TYPE,
	p_Cpsid ItemChg.Cpsid%TYPE,
	p_Unit SlipTx.Unit%TYPE,
	p_StnDesc1 SlipTx.StnDesc1%TYPE,
	p_IRefNo SlipTx.IRefNo%TYPE
	-- AddSlipTx : End
) is
	r_Item Item%ROWTYPE ;
	l_StnXRef SlipTx.StnXRef%TYPE ;
	SLIPTX_TYPE_DEPOSIT_O VARCHAR2(1) := 'O';
	SLIPTX_TYPE_DEBIT VARCHAR2(1) := 'D';
	v_StnID NUMBER;
	v_flagToDi BOOLEAN;
begin
	if p_TranMode = 'ADD' then
		for r in ( select * from Item where ItmCode = p_ItmCode ) loop
			r_Item := r ;
			exit ;
		end loop ;

		IF p_StnDiFlag = '-1' THEN
			v_flagToDi := TRUE;
		ELSE
			v_flagToDi := FALSE;
		END If;

		if p_ItmCat = SLIPTX_TYPE_DEPOSIT_O or r_Item.ItmCat = SLIPTX_TYPE_DEPOSIT_O then
			l_StnXRef := NHS_SYS_AddDeposit( p_DpsAmt, p_SlpNo, p_ItmCode, p_DpsCDate, p_DpsTDate ) ;
			if l_StnXRef is null then
				-- Error Message
				null ;
			else
				-- p_ItmType is outdated
				v_StnID := NHS_UTL_AddEntry ( p_SlpNo, p_ItmCode, p_ItmType, SLIPTX_TYPE_DEPOSIT_O,
					TO_CHAR(p_StnOAmt), TO_CHAR(p_StnBAmt), UPPER(p_DocCode), p_StnRlvl,
					p_AcmCode, TO_CHAR(p_StnDisc), p_PkgCode, p_StnCDate,
					p_StnTDate, p_StnDesc, null, null, l_StnXRef,
					FALSE, p_BedCode, null, v_flagToDi, p_StnCpsFlag,
					p_Cpsid, p_Unit, p_StnDesc1, p_IRefNo, NULL, p_usrid ) ;
			end if ;
		else
			v_StnID := NHS_UTL_AddEntry ( p_SlpNo, p_ItmCode, p_ItmType, SLIPTX_TYPE_DEBIT,
				TO_CHAR(p_StnOAmt / p_unit), TO_CHAR(p_StnBAmt), UPPER(p_DocCode), p_StnRlvl,
				p_AcmCode, TO_CHAR(p_StnDisc), p_PkgCode, p_StnCDate,
				p_StnTDate, p_StnDesc, null, null, l_StnXRef,
				FALSE, p_BedCode, null, v_flagToDi, p_StnCpsFlag,
				p_Cpsid, p_Unit, p_StnDesc1, p_IRefNo, NULL, p_usrid ) ;
		end if ;
		NHS_UTL_UPDATESLIP( p_SlpNo ) ;
	end if ;
end ;
/
