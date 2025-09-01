CREATE OR REPLACE FUNCTION NHS_ACT_ACCOUNTSLIP (
	v_ACTION      IN VARCHAR2,
	v_Orig_AtxID  IN VARCHAR2,
	v_Alloc_AtxID IN VARCHAR2,
	v_UserID      IN VARCHAR2,
	o_errmsg      OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode  NUMBER;
	o_errmsg2  VARCHAR2(100);
	v_Count    NUMBER;
	v_AtxRefID NUMBER;
	v_ArpID    NUMBER;
	v_AtxAmt   NUMBER;
	v_NewID    NUMBER;
	v_ArcCode  ArTx.ArcCode%TYPE;
	v_Patno    ArTx.PatNo%TYPE;
	v_SlpNo    ArTx.SlpNo%TYPE;
	v_AtxTDate ArTx.AtxTDate%TYPE;
	v_AtxDesc  ArTx.AtxDesc%TYPE;
	v_spdaamt  slppaydtl.spdaamt%TYPE;
	v_settled_AtxAmt ArTx.AtxAmt%TYPE;

	SLIPTX_TYPE_PAYMENT_A VARCHAR2(1) := 'P';
BEGIN
	o_errmsg  := 'OK';
	o_errcode := -1;

	SELECT COUNT(1) INTO v_Count FROM ArTx WHERE ArpID is null and AtxTType = 'C' and AtxSts = 'N' AND AtxID = v_Orig_AtxID;
	IF v_Count = 1 THEN
		SELECT Arccode, PatNo, SlpNo, AtxTDate, AtxDesc INTO v_ArcCode, v_PatNo, v_SlpNo, v_AtxTDate, v_AtxDesc FROM ArTx WHERE ArpID is null and AtxTType = 'C' and AtxSts = 'N' AND AtxID = v_Orig_AtxID;
	ELSE
		o_errmsg := 'Fail to find AR record.';
		RETURN o_errcode;
	END IF;

	SELECT COUNT(1) INTO v_Count FROM ArTx a, ArpTx b WHERE a.ArpID = b.ArpID AND a.AtxSts <> 'R' AND a.AtxID = v_Alloc_AtxID;
	IF v_Count = 1 THEN
		SELECT a.AtxRefID, a.ArpID, a.AtxAmt INTO v_AtxRefID, v_ArpID, v_AtxAmt FROM ArTx a, ArpTx b WHERE a.ArpID = b.ArpID AND a.AtxSts <> 'R' AND a.AtxID = v_Alloc_AtxID;
	ELSE
		o_errmsg := 'Fail to find AR record.';
		RETURN o_errcode;
	END IF;

	o_errcode := NHS_UTL_SLPPAYALLARCRREVERSE(SLIPTX_TYPE_PAYMENT_A, v_Alloc_AtxID);
	IF o_errcode < 0 THEN
		ROLLBACK;
		o_errmsg := ' Fail to reverse all ar slip pay.';
		RETURN o_errcode;
	END IF;

	o_errcode := NHS_UTL_SCMARCRREVERSE(SLIPTX_TYPE_PAYMENT_A, v_Alloc_AtxID);
	IF o_errcode < 0 THEN
		ROLLBACK;
		o_errmsg := ' Fail to reverse scm ar credit.';
		RETURN o_errcode;
	END IF;

	UPDATE Artx SET Atxsts = 'C' WHERE AtxID = v_Alloc_AtxID;

	UPDATE Artx SET AtxsAmt = AtxsAmt + v_AtxAmt WHERE AtxID = v_Orig_AtxID;

	UPDATE Arptx SET ArpaAmt = ArpaAmt + v_AtxAmt WHERE ArpID = v_ArpID;

	UPDATE Arcode SET ARCUAMT = ARCUAMT + v_AtxAmt, ARCAMT = ARCAMT - v_AtxAmt WHERE Arccode = v_Arccode;

	SELECT SEQ_ARTX.NEXTVAL INTO v_NewID FROM DUAL;

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
		v_ArcCode,
		v_Patno,
		v_SlpNo,
		-1 * v_AtxAmt,
		-1 * v_AtxAmt,
		v_AtxTDate,
		SysDate,
		v_Alloc_AtxID || v_AtxDesc,
		'C',
		v_AtxRefID,
		'R',
		v_ArpID,
		v_UserID
	);

	o_errcode := 0;
	
	-- set M allocate to true if no slppaydtl but AR is fully settled (abnormal case)
	select sum(spdaamt) into v_spdaamt
	from slppaydtl where slpno = v_SlpNo
	and payref = v_Alloc_AtxID;
	
	select sum(atxsamt) into v_settled_AtxAmt from artx where slpno = v_SlpNo and  atxsts = 'N';
	if v_spdaamt <> v_settled_AtxAmt then
		update slip set slpmanall = -1 where slpno = v_SlpNo;
		
		o_errcode := NHS_ACT_SYSLOG('ADD', 'ARCreditAlloc', 'Cancel', 'Manual Allocation for slpno:' || v_SlpNo, v_UserID, NULL, o_errmsg2);
		
		o_errcode := 1;
		o_errmsg := 'Manual Allocation for doctor''s share is required.';
	end if;
	--

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := 'Fail to Cancel.<br><font color=red>Error Code:' || SQLCODE || '</font>';

	RETURN -999;
END NHS_ACT_ACCOUNTSLIP;
/
