-- SlipPaymentAllocation.bas / SlpPayAllReverse
CREATE OR REPLACE FUNCTION "NHS_UTL_SLPPAYALLREVERSE"(
	i_SpdID       IN VARCHAR2,
	i_CaptureDate IN DATE,
	i_UserCancel  IN BOOLEAN := true,
	i_UserID	  IN VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := -1;
	o_errcode2 NUMBER;
	o_errmsg VARCHAR2(500);
	v_Count NUMBER;
	v_SpdID SlpPayDtl.SpdID%TYPE;
	v_SphID SlpPayDtl.SphID%TYPE;
	v_SpdSts SlpPayDtl.SpdSts%TYPE;
	v_SpdCDate SlpPayDtl.SpdCDate%TYPE;
	v_StnID SlpPayDtl.StnID%TYPE;
	i_slpno SlpPayDtl.slpno%TYPE;

	SLIP_PAYMENT_USER_REVERSE VARCHAR2(1) := 'U';      -- Reverse by User
	SLIP_PAYMENT_REVERSE VARCHAR2(1) := 'R';           -- Reverse by System
	SLIP_PAYMENT_B4_PAID_REVERSE VARCHAR2(1) := 'X';   -- Reverse before Paid, not affect Dr.Fee
	SLIP_PAYMENT_CANCEL VARCHAR2(1) := 'C';            -- Cancelled
BEGIN
	SELECT COUNT(1) INTO v_Count FROM SlpPayDtl WHERE SpdID = i_SpdID;
	IF v_Count = 1 THEN
		SELECT SphID, StnID
		INTO   v_SphID, v_StnID
		FROM   SlpPayDtl
		WHERE  SpdID = i_SpdID;
	ELSE
		RETURN o_errcode;
	END IF;

	SELECT SEQ_SLPPAYDTL.NEXTVAL INTO v_SpdID FROM DUAL;

	IF v_SphID IS NULL THEN
		v_SpdSts := SLIP_PAYMENT_B4_PAID_REVERSE;
	ELSE
		IF i_UserCancel THEN
			v_SpdSts := SLIP_PAYMENT_USER_REVERSE;
		ELSE
			v_SpdSts := SLIP_PAYMENT_REVERSE;
		END IF;
	END IF;

	IF i_CaptureDate IS NULL THEN
		v_SpdCDate := SYSDATE;
	ELSE
		v_SpdCDate := i_CaptureDate;
	END IF;

	INSERT INTO SlpPayDtl (
		SpdID, StnID, SlpNo, StnType, PayRef, SpdAAmt, SlpType,
		DocCode, SpdCDate, CtnCType, CraRate, SpdSts, SpdPct,
		SpdFAmt, SphID, SpdPAmt, StnNAmt, SpdSAmt, SpdCAmt,
		PcyID, SpdID_R
	)
	SELECT
		v_SpdID, StnID, SlpNo, StnType, PayRef, -1 * SpdAAmt, SlpType,
		DocCode, v_SpdCDate, CtnCType, CraRate, v_SpdSts, NULL,
		NULL, NULL, NULL, NULL, NULL, NULL,
		PcyID, SpdID
	FROM   SlpPayDtl
	WHERE  SpdID = i_SpdID;

	UPDATE SlpPayDtl
	SET    SpdSts = SLIP_PAYMENT_CANCEL
	WHERE  SpdID = i_SpdID;

	UPDATE SLIPTX SET StnaDoc = NULL WHERE StnID = v_StnID;
	
	-- debug
	SELECT SlpNo into i_slpno
	FROM   SlpPayDtl
	WHERE  SpdID = i_SpdID;
	
	o_errcode2 := NHS_ACT_SYSLOG('ADD', 'SlpPayAllAuto', 'Reverse', i_SlpNo || ', SpdID=' || i_SpdID || ', UserCancel=' || case when i_UserCancel = true then 'Y' else 'N' end || ', UserID=' || i_UserID, null, null, o_errmsg);

	o_errcode := 1;
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_UTL_SLPPAYALLREVERSE;
/
