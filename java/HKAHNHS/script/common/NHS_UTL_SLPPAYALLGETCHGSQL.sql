CREATE OR REPLACE FUNCTION "NHS_UTL_SLPPAYALLGETCHGSQL" (
	i_SlpNo IN VARCHAR2
)
	RETURN VARCHAR2
AS
	STRSQL VARCHAR2(2000);

	SLIPTX_TYPE_DEBIT VARCHAR2(1) := 'D';
	TYPE_DOCTOR VARCHAR2(1) := 'D';
	SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	SLIPTX_STATUS_ADJUST VARCHAR2(1) := 'A';
BEGIN
	STRSQL := ' SELECT tx.StnID, tx.PkgCode, tx.ItmCode, tx.StnDesc, tx.DocCode, tx.StnCDate,
			tx.StnNAmt - NVL(SUM(spd.spdaamt), 0) AS StnNAmt, s.PcyID
		FROM Slip s, SlipTx tx, SlpPayDtl spd ';

	IF i_SlpNo IS NULL OR LENGTH(i_SlpNo) = 0 THEN
		STRSQL := STRSQL || ' WHERE 1 = 2 ';
	ELSE
		STRSQL := STRSQL || ' WHERE s.SlpNo = ''' || i_SlpNo || '''
			AND tx.Stnseq >= nvl(slpseqfm, 1)
			AND s.SlpNo = tx.SlpNo
			AND tx.StnType = ''' || SLIPTX_TYPE_DEBIT || '''
			AND tx.ItmType = ''' || TYPE_DOCTOR || '''
			AND tx.StnID = spd.StnID (+)
			AND tx.StnSts IN (''' || SLIPTX_STATUS_NORMAL || ''', ''' || SLIPTX_STATUS_ADJUST || ''')
			AND tx.StnADoc IS NULL ';
	END IF;

	STRSQL := STRSQL || '
		GROUP BY tx.StnID, tx.PkgCode, tx.ItmCode, tx.StnDesc, tx.DocCode, tx.StnCDate, tx.StnNAmt, s.PcyID
		HAVING tx.StnNAmt - NVL(SUM(spd.SpdAAmt), 0) <> 0';

	RETURN STRSQL;
END NHS_UTL_SLPPAYALLGETCHGSQL;
/
