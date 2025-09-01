CREATE OR REPLACE FUNCTION "NHS_GET_CONPCECHANGE" (
	i_SlpNo         IN VARCHAR2,
	i_TransactionID IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SQLSTR VARCHAR2(2000);
BEGIN
	SQLSTR := '
		SELECT
			tx.StnID, tx.StnSeq, tx.PkgCode, tx.ItmCode, tx2.Stncpsflag, tx.Stndesc, tx.ItmType,
			SUM(tx2.StnBAmt) AS StnBAmt,
			tx.StnBAmt AS firstStnBAmt, tx2.stndisc,
			11 AS oldBAmt, 12 AS oldDisc, tx.acmcode AS newAcmCode, 14 AS newOAmt, 15 AS newBAmt,
			16 AS newDisc, 17 AS newcpsflag, 18 AS newGlcCode, tx.unit, tx.Glccode
		FROM  Sliptx tx, Sliptx tx2
		WHERE tx.SlpNo = ''' || i_SlpNo || '''
		AND   tx.SlpNo = tx2.SlpNo
		AND   tx.StnType = ''D''
		AND   tx2.StnSts in (''N'',''A'')
		AND   tx.DIXREF = TX2.DIXREF
		AND   tx.STNSTS = ''N''';

	IF i_TransactionID IS NOT NULL then
       SQLSTR := SQLSTR || ' AND tx.StnID =''' || i_TransactionID || '''';
  	END IF;

	SQLSTR := SQLSTR || ' GROUP BY tx.StnID, tx.StnSeq, tx.PkgCode, tx.ItmCode, tx.StnBAmt, tx2.Stncpsflag, tx.Stndesc, tx.ItmType, tx2.Stndisc, tx.Acmcode, tx.Unit, tx.Glccode';

	OPEN OUTCUR FOR SQLSTR;
	RETURN OUTCUR;
END NHS_GET_CONPCECHANGE;
/
