create or replace FUNCTION "NHS_UTL_ARENTRY"(
i_UserID          IN VARCHAR2,
i_TransactionType IN VARCHAR2,
i_Arcode          IN VARCHAR2,
i_Amount          IN NUMBER,
i_Description     IN VARCHAR2,
i_PatientNumber   IN VARCHAR2,
i_SlipNumber      IN VARCHAR2,
i_ReferenceID     IN VARCHAR2,
i_TransactionDate IN DATE,
i_CaptureDate     IN VARCHAR2,
i_ArID            IN VARCHAR2
)
	RETURN NUMBER
AS
	o_AtxID           NUMBER;
	v_TransactionDate DATE;
	v_CaptureDate     DATE;
	v_Description     ArTx.AtxDesc%TYPE;
BEGIN
	-- TransactionType = ARTX_TYPE_PAYMENT And IsMissing(ReferenceID)
	IF i_TransactionType = 'P' AND i_ReferenceID IS NULL THEN
		RETURN o_AtxID;
	END IF;

	-- get next artx id
	SELECT SEQ_ArTx.NEXTVAL INTO o_AtxID FROM DUAL;

	-- set default transaction date if empty
	IF i_TransactionDate IS NOT NULL THEN
		v_TransactionDate := TRIM(i_TransactionDate);
	ELSE
		v_TransactionDate := TRIM(SYSDATE);
	END IF;

	-- set default capture date if empty
	IF i_CaptureDate IS NOT NULL THEN
		v_CaptureDate := i_CaptureDate;
	ELSE
		v_CaptureDate := SYSDATE;
	END IF;

	-- Not IsMissing(ArID)) And TransactionType = ARTX_TYPE_ADJUST
	IF i_ArID IS NOT NULL AND i_TransactionType = 'A' THEN
		v_Description := i_ArID || i_Description;
	ELSE
		v_Description := i_Description;
	END IF;

	-- ARTX_STATUS_NORMAL = 'N'
	INSERT INTO ArTx (AtxID, ArcCode, AtxAmt, AtxSAmt, AtxTDate, AtxCDate, AtxTType, AtxSts, AtxDesc, UsrId)
	VALUES (o_AtxID, i_Arcode, i_Amount, 0, v_TransactionDate, v_CaptureDate, i_TransactionType, 'N', v_Description, i_UserID);

	-- update patient number if not empty
	--IF i_PatientNumber IS NOT NULL THEN
	UPDATE ArTx SET PatNo = i_PatientNumber, SlpNo = i_SlipNumber WHERE AtxID = o_AtxID;
	--END IF;

	-- update reference id if not empty
	IF i_ReferenceID IS NOT NULL THEN
		UPDATE ArTx SET AtxRefID = i_ReferenceID WHERE AtxID = o_AtxID;
	END IF;

	-- Update Payer's Balance (UpdateARBalance)
	UPDATE ArCode
	Set    ArcAmt = ArcAmt + i_Amount, ArcUAmt = ArcUAmt + 0
	WHERE  ArcCode = i_Arcode;

	RETURN o_AtxID;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_UTL_ARENTRY;
/
