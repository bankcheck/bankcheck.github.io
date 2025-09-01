CREATE OR REPLACE FUNCTION NHS_ACT_ARPAYMENTCANCEL(
i_action	    IN VARCHAR2,
i_TransactionID IN VARCHAR2,
o_errmsg	    OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_ArpID NUMBER;
	rs_ArpTx ArpTx%ROWTYPE;

	ArpTx_STATUS_CANCEL VARCHAR2(1) := 'C';
	ArpTx_STATUS_REVERSE VARCHAR2(1) := 'R';
BEGIN
	o_errcode := -1;
	o_errmsg := 'OK';

	IF i_TransactionID IS NULL THEN
        o_errmsg := 'TransactionID is empty.';
		RETURN o_errcode;
	END IF;

	SELECT COUNT(1) INTO v_noOfRec FROM ArpTx WHERE ArpID = TO_NUMBER(i_TransactionID);
	IF v_noOfRec = 0 THEN
		o_errmsg := 'no record found.';
		RETURN o_errcode;
	END IF;

	SELECT * INTO rs_ArpTx FROM ArpTx WHERE ArpID = TO_NUMBER(i_TransactionID);
	IF rs_ArpTx.ArpSts = ArpTx_STATUS_CANCEL THEN
		o_errmsg := 'AP Payment Transaction is already cancelled.';
		RETURN o_errcode;
	END IF;

	SELECT SEQ_ArpTx.NEXTVAL INTO v_ArpID FROM DUAL;

	INSERT INTO ArpTx(
		ArpID,
		ArcCode,
		ArpOAmt,
		ArpAAmt,
		ArpTDate,
		ArpCDate,
		ArpRecNo,
		ArpDesc,
		ArpSts,
		UsrID,
		ArpType
	) VALUES (
		v_ArpID,
		rs_ArpTx.ArcCode,
		-rs_ArpTx.ArpOAmt,
		rs_ArpTx.ArpAAmt,
		rs_ArpTx.ArpTDate,
		rs_ArpTx.ArpCDate,
		rs_ArpTx.ArpRecNo,
		rs_ArpTx.ArpDesc,
		ArpTx_STATUS_REVERSE,
		rs_ArpTx.UsrID,
		rs_ArpTx.ArpType
	);

	IF SQL%ROWCOUNT = 0 THEN
		o_errmsg := 'insert fail.';
		ROLLBACK;
		RETURN o_errcode;
	END IF;

	-- Update old transaction record to 'Cancel'
	-- SetARPaymentEntry
	UPDATE ArpTx SET ArpSts = ArpTx_STATUS_CANCEL WHERE ArpID = TO_NUMBER(i_TransactionID);

	IF SQL%ROWCOUNT = 0 then
		o_errmsg := 'update fail.';
		ROLLBACK;
		RETURN o_errcode;
	END IF;

	-- UpdateARBalance
	UPDATE ArCode Set ArcAmt = ArcAmt + 0, ArcUAmt = ArcUAmt - rs_ArpTx.ArpOAmt WHERE ArcCode = rs_ArpTx.ArcCode;

	IF SQL%ROWCOUNT = 0 THEN
		o_errmsg := 'update fail.';
		ROLLBACK;
		RETURN o_errcode;
	END IF;

	RETURN v_ArpID;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_ACT_ARPAYMENTCANCEL;
/
