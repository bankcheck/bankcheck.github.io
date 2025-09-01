-- Transaction.bas / UpdateSlip
create or replace PROCEDURE "NHS_UTL_UPDATESLIP"(
	i_SlipNo IN Slip.SlpNo%TYPE
)
IS
	v_TotCredit  Slip.SlpCAmt%TYPE;
	v_TotPayment Slip.SlpPAmt%TYPE;
	v_TotCharges Slip.SlpDAmt%TYPE;
	SLIPTX_TYPE_PAYMENT_A VARCHAR2(1) := 'P';
	SLIPTX_TYPE_CREDIT VARCHAR2(1) := 'C';
	SLIPTX_TYPE_DEPOSIT_I VARCHAR2(1) := 'I';
	SLIPTX_TYPE_PAYMENT_C VARCHAR2(1) := 'S';
	SLIPTX_TYPE_REFUND VARCHAR2(1) := 'R';
	SLIPTX_TYPE_DEBIT VARCHAR2(1) := 'D';
	SLIPTX_TYPE_DEPOSIT_O VARCHAR2(1) := 'O';
	SLIPTX_TYPE_DEPOSIT_X VARCHAR2(1) := 'X';
BEGIN
	SELECT
		SUM(DECODE(StnType, SLIPTX_TYPE_PAYMENT_A, StnNAmt, SLIPTX_TYPE_CREDIT, StnNAmt, SLIPTX_TYPE_DEPOSIT_I, StnNAmt, 0)) as StnNAmt,
		SUM(DECODE(StnType, SLIPTX_TYPE_PAYMENT_C, StnNAmt, SLIPTX_TYPE_REFUND, StnNAmt, 0)) as StnNAmt,
		SUM(DECODE(StnType, SLIPTX_TYPE_DEBIT, StnNAmt, SLIPTX_TYPE_DEPOSIT_O, StnNAmt, SLIPTX_TYPE_DEPOSIT_X, StnNAmt, 0)) as StnNAmt
	INTO   v_TotCredit, v_TotPayment, v_TotCharges
	FROM   Sliptx
	WHERE  slpno = i_SlipNo;

	UPDATE Slip SET SlpCAmt = v_TotCredit, SlpPAmt = v_TotPayment, SlpDAmt = v_TotCharges WHERE SlpNo = i_SlipNo;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END NHS_UTL_UPDATESLIP;
/
