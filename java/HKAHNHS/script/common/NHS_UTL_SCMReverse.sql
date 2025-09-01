-- SlipPaymentAllocation.bas / SCMReverse
CREATE OR REPLACE FUNCTION "NHS_UTL_SCMREVERSE"(
	i_SydID       IN VARCHAR2,
	i_CaptureDate IN DATE,
	i_UserCancel  IN BOOLEAN := TRUE
)
	RETURN NUMBER
AS
	o_errcode  NUMBER := -1;
	v_Count    NUMBER;
	v_SydID    NUMBER;
	v_SyhID    SpecomDtl.SyhID%TYPE;
	v_SydAAmt  SpecomDtl.SydAAmt%TYPE;
	v_SpdSts   SpecomDtl.SydSTS%TYPE;
	v_SydCDate SpecomDtl.SydCDate%TYPE;
	v_StnID    SpecomDtl.StnID%TYPE;
	v_SlpNo    SpecomDtl.SlpNo%TYPE;
	v_StnType  SpecomDtl.StnType%TYPE;
	v_PayRef   SpecomDtl.PayRef%TYPE;
	v_SlpType  SpecomDtl.SlpType%TYPE;
	v_DocCode  SpecomDtl.DocCode%TYPE;
	v_CtnCType SpecomDtl.CtnCType%TYPE;
	v_CraRate  SpecomDtl.CraRate%TYPE;
	v_PcyID    SpecomDtl.PcyID%TYPE;

	SLIP_PAYMENT_USER_REVERSE VARCHAR2(1) := 'U';      -- Reverse by User
	SLIP_PAYMENT_REVERSE VARCHAR2(1) := 'R';           -- Reverse by System
	SLIP_PAYMENT_B4_PAID_REVERSE VARCHAR2(1) := 'X';   -- Reverse before Paid, not affect Dr.Fee
	SLIP_PAYMENT_CANCEL VARCHAR2(1) := 'C';            -- Cancelled
BEGIN
	SELECT COUNT(1) INTO v_Count FROM SpecomDtl WHERE SydID = i_SydID;
	IF v_Count = 1 THEN
		SELECT SYHID, SydAAMT, StnID, SlpNo, StnType, PayRef, SlpType, DocCode, CtnCType, CraRate, PcyID
		INTO   v_SyhID, v_SydAAmt, v_StnID, v_SlpNo, v_StnType, v_PayRef, v_SlpType, v_DocCode, v_CtnCType, v_CraRate, v_PcyID
		FROM   SpecomDtl
		WHERE  SydID = i_SydID;
	ELSE
		RETURN o_errcode;
	END IF;

	SELECT SEQ_SPECOMDTL.NEXTVAL INTO v_SydID FROM DUAL;

    IF v_SyhID IS NULL THEN
        v_SpdSts := SLIP_PAYMENT_B4_PAID_REVERSE;
    ELSE
        IF i_UserCancel THEN
            v_SpdSts := SLIP_PAYMENT_USER_REVERSE;
        ELSE
            v_SpdSts := SLIP_PAYMENT_REVERSE;
        End IF;
    End IF;

    IF i_CaptureDate IS NULL THEN
        v_SydCDate := SYSDATE;
    ELSE
        v_SydCDate := i_CaptureDate;
    End IF;

	INSERT INTO SpecomDtl (
		SydID, StnID, SlpNo, StnType, PayRef, SydAAMT, SlpType,
		DocCode, SydCDate, CtnCType, CraRate, SydSTS, SydPCT, SydFAmt,
		SYHID, SydPAmt, PcyID, StnNAmt, SydSAmt,
		SydCAmt, SydID_R
	) VALUES (
		v_SydID, v_StnID, v_SlpNo, v_StnType, v_PayRef, -1 * v_SydAAMT, v_SlpType,
		v_DocCode, v_SydCDate, v_CtnCType, v_CraRate, v_SPDSTS, NULL, NULL,
		NULL, NULL, v_PcyID, NULL, NULL,
		NULL, i_SydID
	);

    UPDATE SpecomDtl
    SET    SydSTS = SLIP_PAYMENT_CANCEL
    WHERE  SydID = i_SydID;

    UPDATE SLIPTX SET StnaScm = NULL WHERE StnID = v_StnID;

	o_errcode := 1;
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_UTL_SCMREVERSE;
/
