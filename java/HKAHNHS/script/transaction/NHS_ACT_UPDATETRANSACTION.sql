CREATE OR REPLACE FUNCTION NHS_ACT_UPDATETRANSACTION (
	i_action    IN VARCHAR2,
	i_CtnID     IN VARCHAR2,
	i_SlipNo    IN VARCHAR2,
	i_SlipSeq   IN VARCHAR2,
	i_ReceiptNo IN VARCHAR2,
	i_CtnType   IN VARCHAR2,
	i_CtnRef    IN VARCHAR2,
	i_CtnAmt    IN VARCHAR2,
	i_CtnTips   IN VARCHAR2,
	i_CtnRspC   IN VARCHAR2,
	i_CtnRspD   IN VARCHAR2,
	i_CtnTime   IN VARCHAR2,
	i_CtnCType  IN VARCHAR2,
	i_CtnCNo    IN VARCHAR2,
	i_CtnExp    IN VARCHAR2,
	i_CtnHold   IN VARCHAR2,
	i_CtnTID    IN VARCHAR2,
	i_CtnMID    IN VARCHAR2,
	i_CtnTrace  IN VARCHAR2,
	i_CtnBatch  IN VARCHAR2,
	i_CtnACode  IN VARCHAR2,
	i_CtnRRN    IN VARCHAR2,
	i_CtnSNo    IN VARCHAR2,
	i_CtnVDate  IN VARCHAR2,
	i_CtnDAcc   IN VARCHAR2,
	i_CtnAResp  IN VARCHAR2,
	i_CtnSCnt   IN VARCHAR2,
	i_CtnSAmt   IN VARCHAR2,
	i_CtnRCnt   IN VARCHAR2,
	i_CtnRAmt   IN VARCHAR2,
	i_CtnTDate  IN VARCHAR2,
	i_RefNo     IN VARCHAR2,
	o_errmsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := -1;
	v_noOfRec NUMBER;
	v_CtnID NUMBER;
	v_CtnTime VARCHAR2(12);
	v_CtnRef CardTx.CtnRef%TYPE;
	v_CtnTDate CardTx.CtnTDate%TYPE;
	v_RefNo CardTx.RefNo%TYPE;
	rs_cardtx CardTx%ROWTYPE;

	CARDTX_STS_INITIAL VARCHAR2(1) := 'I';
	CARDTX_STS_NORMAL VARCHAR2(1) := 'N';
	CARDTX_STS_MANUAL VARCHAR2(1) := 'M';
BEGIN
	o_errmsg := 'OK';
	v_CtnID := TO_NUMBER(i_CtnID);

	IF i_CtnID IS NULL THEN
		o_errmsg := 'CtnID is empty.';
		return o_errcode;
	END IF;

	SELECT COUNT(1) INTO v_noOfRec FROM CardTx WHERE CtnID = v_CtnID AND Ctnsts = CARDTX_STS_INITIAL;
	IF v_noOfRec = 0 THEN
		o_errmsg := 'No Record Found.';
		RETURN o_errcode;
	END IF;

	IF i_CtnRspC = 'PF' THEN
		o_errmsg := 'Incorrect Password.';
		RETURN o_errcode;
	END IF;

	IF i_CtnTime IS NOT NULL AND LENGTH(i_CtnTime) > 12 THEN
		v_CtnTime := SUBSTR(i_CtnTime, 1, 12);
	ELSE
		v_CtnTime := i_CtnTime;
	END IF;

	SELECT * INTO rs_CardTx FROM CardTx WHERE CtnID = v_CtnID;

	IF i_CtnRspC = '78' AND i_CtnType = '3' THEN
		IF i_SlipNo IS NULL OR i_SlipSeq IS NULL THEN
			IF i_ReceiptNo IS NOT NULL THEN
				v_CtnRef := i_ReceiptNo;
			ELSE
				v_CtnRef := rs_cardtx.CtnRef;
			END IF;
		ELSE
			v_CtnRef := i_SlipNo || '-' || SUBSTR('0000' || i_SlipSeq, LENGTH(i_SlipSeq) + 1, 4);
		END IF;
	ELSE
		v_CtnRef := i_CtnRef;
	END IF;

	IF i_CtnTDate IS NOT NULL AND LENGTH(i_CtnTDate) = 19 THEN
		v_CtnTDate := TO_DATE(i_CtnTDate,'dd/mm/yyyy HH24:MI:SS');
	ELSE
		v_CtnTDate := rs_cardtx.CtnTDate;
	END IF;

	IF i_CtnType = 'a' OR i_CtnType = 'b' OR i_CtnType = 'c' OR i_CtnType = 'd' OR i_CtnType = 'h' OR i_CtnType = 'l'
			OR i_CtnType = 'A' OR i_CtnType = 'B' OR i_CtnType = 'C' THEN
		v_RefNo := i_RefNo;
	ELSE
		v_RefNo := rs_cardtx.RefNo;
	END IF;

	IF i_CtnRspC IS NOT NULL THEN
		UPDATE CardTx SET
			Ctnsts   = CARDTX_STS_NORMAL,
			CtnType  = CASE WHEN i_CtnType  IS NULL THEN rs_cardtx.CtnType  ELSE i_CtnType  END,
			CtnRef   = v_CtnRef,
			CtnAmt   = CASE WHEN i_CtnAmt   IS NULL THEN rs_cardtx.CtnAmt   ELSE i_CtnAmt   END,
			CtnTips  = CASE WHEN i_CtnTips  IS NULL THEN rs_cardtx.CtnTips  ELSE i_CtnTips  END,
			CtnRspC  = CASE WHEN i_CtnRspC  IS NULL THEN rs_cardtx.CtnRspC  ELSE i_CtnRspC  END,
			CtnRspD  = CASE WHEN i_CtnRspD  IS NULL THEN rs_cardtx.CtnRspD  ELSE i_CtnRspD  END,
			CtnTime  = CASE WHEN v_CtnTime  IS NULL THEN rs_cardtx.CtnTime  ELSE v_CtnTime  END,
			CtnCType = CASE WHEN i_CtnCType IS NULL THEN rs_cardtx.CtnCType ELSE i_CtnCType END,
			Ctncno   = CASE WHEN i_CtnCNo   IS NULL THEN rs_cardtx.Ctncno   ELSE i_CtnCNo   END,
			CtnExp   = CASE WHEN i_CtnExp   IS NULL THEN rs_cardtx.CtnExp   ELSE i_CtnExp   END,
			CtnHold  = CASE WHEN i_CtnHold  IS NULL THEN rs_cardtx.CtnHold  ELSE i_CtnHold  END,
			CtnTID   = CASE WHEN i_CtnTID   IS NULL THEN rs_cardtx.CtnTID   ELSE i_CtnTID   END,
			CtnMID   = CASE WHEN i_CtnMID   IS NULL THEN rs_cardtx.CtnMID   ELSE i_CtnMID   END,
			CtnTrace = CASE WHEN i_CtnTrace IS NULL THEN rs_cardtx.CtnTrace ELSE i_CtnTrace END,
			CtnBatch = CASE WHEN i_CtnBatch IS NULL THEN rs_cardtx.CtnBatch ELSE i_CtnBatch END,
			CtnACode = CASE WHEN i_CtnACode IS NULL THEN rs_cardtx.CtnACode ELSE i_CtnACode END,
			CtnRRN   = CASE WHEN i_CtnRRN   IS NULL THEN rs_cardtx.CtnRRN   ELSE i_CtnRRN   END,
			CtnSNo   = CASE WHEN i_CtnSNo   IS NULL THEN rs_cardtx.CtnSNo   ELSE i_CtnSNo   END,
			CtnVDate = CASE WHEN i_CtnVDate IS NULL THEN rs_cardtx.CtnVDate ELSE i_CtnVDate END,
			CtnDAcc  = CASE WHEN i_CtnDAcc  IS NULL THEN rs_cardtx.CtnDAcc  ELSE i_CtnDAcc  END,
			CtnAResp = CASE WHEN i_CtnAResp IS NULL THEN rs_cardtx.CtnAResp ELSE i_CtnAResp END,
			CtnSCnt  = CASE WHEN i_CtnSCnt  IS NULL THEN rs_cardtx.CtnSCnt  ELSE i_CtnSCnt  END,
			CtnSAmt  = CASE WHEN i_CtnSAmt  IS NULL THEN rs_cardtx.CtnSAmt  ELSE i_CtnSAmt  END,
			CtnRCnt  = CASE WHEN i_CtnRCnt  IS NULL THEN rs_cardtx.CtnRCnt  ELSE i_CtnRCnt  END,
			CtnRAmt  = CASE WHEN i_CtnRAmt  IS NULL THEN rs_cardtx.CtnRAmt  ELSE i_CtnRAmt  END,
			CtnTDate = v_CtnTDate,
			RefNo    = v_RefNo
		WHERE CtnID  = v_CtnID
		AND   Ctnsts = CARDTX_STS_INITIAL;
	ELSE
		UPDATE CardTx SET
			Ctnsts   = CARDTX_STS_MANUAL,
			CtnType  = CASE WHEN i_CtnType  IS NULL THEN rs_cardtx.CtnType  ELSE i_CtnType  END,
			CtnTDate = v_CtnTDate,
			RefNo    = v_RefNo
		WHERE CtnID  = v_CtnID
		AND   Ctnsts = CARDTX_STS_INITIAL;
	END IF;

	RETURN v_CtnID;
END NHS_ACT_UPDATETRANSACTION;
/
