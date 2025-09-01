CREATE OR REPLACE FUNCTION "NHS_ACT_UPDATEBALANCE" (
i_action          IN VARCHAR2,
i_CashierCode     IN VARCHAR2,
i_TransactionType IN VARCHAR2,
i_PaymentType     IN VARCHAR2,
i_Amount          IN VARCHAR2,
i_CountType       IN VARCHAR2,
o_errmsg          OUT VARCHAR2
)
	RETURN NUMBER
AS
BEGIN
	o_errmsg := 'OK';

	RETURN NHS_UTL_UPDATEBALANCE(i_CashierCode, i_TransactionType, i_PaymentType, TO_NUMBER(i_Amount), i_CountType);
END NHS_ACT_UPDATEBALANCE;
/
