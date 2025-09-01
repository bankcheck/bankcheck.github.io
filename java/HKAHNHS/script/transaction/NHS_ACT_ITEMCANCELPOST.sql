CREATE OR REPLACE FUNCTION "NHS_ACT_ITEMCANCELPOST" (
	i_action       IN  VARCHAR2,
	i_UserID       IN  VARCHAR2,
	i_CashierCode  IN  VARCHAR2,
	i_SlpNo        IN  VARCHAR2,
	i_StnID        IN  VARCHAR2,
	o_errMsg       OUT VARCHAR2
)
	RETURN NUMBER
as
	o_errCode NUMBER := -1;
	v_Count NUMBER;
	v_StnTDate VARCHAR2(10);
	v_StnID SlipTx.StnID%TYPE;
--	SLIPTX_STATUS_CANCEL VARCHAR2(1) := 'C';
--	SLIPTX_STATUS_REVERSE VARCHAR2(1) := 'R';
	MSG_INVALID_SLPNO VARCHAR2(50) := 'Slip No. ' || i_SlpNo || ' cannot be found in DataBase.';
BEGIN
	SELECT COUNT(1) INTO v_Count FROM SlipTx SX LEFT JOIN xReg XR ON SX.DiXref = XR.StnID WHERE SX.SlpNo = i_SlpNo AND SX.StnID = i_StnID;
	IF v_Count = 1 THEN
		SELECT TO_CHAR(SX.StnTDate, 'dd/mm/yyyy'), SX.StnID
		INTO   v_StnTDate, v_StnID
		FROM   SlipTx SX LEFT JOIN xReg XR ON SX.DiXref = XR.StnID WHERE SX.SlpNo = i_SlpNo AND SX.StnID = i_StnID;
	ELSE
		o_errMsg := MSG_INVALID_SLPNO;
		RETURN o_errCode;
	END IF;

--	IF v_StnSts = SLIPTX_STATUS_CANCEL OR v_StnSts = SLIPTX_STATUS_REVERSE THEN
--		o_errMsg := 'Cancel item is already cancelled.';
--		RETURN o_errCode;
--	END IF;

	o_errCode := NHS_ACT_REVERSEENTRY('ADD', i_SlpNo, v_StnID, '', v_StnTDate, '1', i_UserID, o_errMsg);
	IF o_errCode < 0 THEN
		ROLLBACK;
		o_errCode := -701;
		o_errMsg := 'Fail to add reverse transaction entry.';
		RETURN o_errCode;
	END IF;

	NHS_UTL_UPDATESLIP(i_SlpNo);

	o_errCode := 0;
	RETURN o_errCode;
EXCEPTION
WHEN OTHERS THEN
	o_errMsg := 'Fail to add reverse transaction entry. ' || SQLERRM;
	RETURN o_errCode;

END NHS_ACT_ITEMCANCELPOST;
/
