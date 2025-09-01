CREATE OR REPLACE FUNCTION "NHS_ACT_CREDITALLOCATION" (
	v_action          IN VARCHAR2,
	v_aRTransactionID IN VARCHAR2,
	v_arPaymentID     IN VARCHAR2,
	v_Amount          IN VARCHAR2,
	v_transactionDate IN VARCHAR2,
	v_capturedate     IN VARCHAR2,
	o_ERRMSG          OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_RET NUMBER;
	v_count NUMBER;
	v_NewID NUMBER;
	v_ARCCODE VARCHAR2(5);
	v_PATNO VARCHAR2(10);
	v_SLPNO VARCHAR2(15);
	v_Amount_N Number;
	v_Transactiondate_D DATE;
	v_capturedate_d DATE;
	v_ATXDESC VARCHAR2(100);
	v_ATXTTYPE VARCHAR2(1);
	v_ATXSTS VARCHAR2(1);
	v_USRID_OLD VARCHAR2(10);
BEGIN
	o_errcode := 0;
	o_errmsg  := 'Credit allocation success.';

	SELECT COUNT(1) INTO v_COUNT FROM ARTX WHERE ATXID = v_aRTransactionID;
	IF v_COUNT > 0 THEN
		SELECT
--			ATXID,
		  	ARCCODE,
		  	PATNO,
		  	SLPNO,
--			ATXAMT,
--			ATXSAMT,
--			ATXTDATE,
--			ATXCDATE,
		  	ATXDESC,
		  	Atxttype,
--			ATXREFID,
		  	ATXSTS,
--			ARPID,
		  	USRID
		INTO
--			v_ATXID_OLD,
		  	v_ARCCODE,
		  	v_PATNO,
		  	v_Slpno,
--			v_ATXAMT,
--			v_ATXSAMT,
--			v_ATXTDATE,
--			v_ATXCDATE,
		  	v_ATXDESC,
		  	v_Atxttype,
--			v_ATXREFID,
		  	v_ATXSTS,
--			v_ARPID,
		  	v_USRID_OLD
		FROM ARTX
		WHERE ATXID = v_aRTransactionID;
	END IF;

	-- Add a Payment Record for credit allocation history
	Select Seq_Artx.Nextval Into v_Newid From Dual;

	IF v_Transactiondate IS NULL Then
		v_Transactiondate_D := Trunc(Sysdate);
  	ELSE
		v_Transactiondate_D := TO_DATE(v_Transactiondate, 'DD/MM/YYYY');
	END IF;

	IF v_Capturedate IS NULL Then
		v_Capturedate_D := Sysdate;
  	ELSE
		v_Capturedate_D := TO_DATE(v_Transactiondate, 'DD/MM/YYYY HH24:MI:SS');
	END IF;
	v_Amount_N := To_Number(Trim(v_Amount));

	INSERT INTO Artx (
		ATXID,
		ARCCODE,
		PATNO,
		SLPNO,
		ATXAMT,
		ATXSAMT,
		ATXTDATE,
		ATXCDATE,
		ATXDESC,
		ATXTTYPE,
		ATXREFID,
		ATXSTS,
		ARPID,
		USRID
	) values (
		v_NewID,
		v_ARCCODE,
		v_PATNO,
		v_SLPNO,
		-1 * v_amount_n,
		-1 * v_amount_n,
		v_Transactiondate_D,
		v_capturedate_d,
		v_ATXDESC,
		v_ATXTTYPE,
		v_aRTransactionID,
		v_ATXSTS,
		v_arPaymentID,
		v_USRID_OLD
	);

	-- Update ArpTx Record
	UPDATE ArpTx SET ArpAAmt = ArpAAmt + v_amount_n
	WHERE ArpID = v_arPaymentID;

	-- Update ArTx Record
	UPDATE ArTx SET AtxSAmt = AtxSAmt + v_amount_n
	WHERE AtxID = v_aRTransactionID;

	-- UpdateARBalance
	UPDATE ArCode
	SET ArcAmt = ArcAmt + (-1 * v_amount_n), ArcUAmt = ArcUAmt + v_amount_n
	WHERE  ArcCode = v_ARCCODE;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errcode := -1;
	o_errmsg := 'Fail to allocate.<br><font color=red>Error Code:' || SQLCODE || '</font>';
	RETURN o_errcode;
END NHS_ACT_CREDITALLOCATION;
/
