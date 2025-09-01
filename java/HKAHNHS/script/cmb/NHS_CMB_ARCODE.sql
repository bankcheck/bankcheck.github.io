CREATE OR REPLACE FUNCTION "NHS_CMB_ARCODE" (
	i_txFrom    IN VARCHAR2,
	i_ACCODE    IN VARCHAR2,
	i_CheckDate IN VARCHAR2
)
	RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
	sqlStr VARCHAR2(2000);
	v_CheckDate VARCHAR2(21);
BEGIN
	sqlStr := '
		SELECT ArcCode, ArcName, ArcAdd1, ArcAdd2, ArcAdd3, CoPayTyp, ArLmtAmt, CvReDate, CoPayamt,
			DECODE(ItmTypeD, 0, ''N'', ''Y''), DECODE(ItmTypeH, 0, ''N'', ''Y''),
			DECODE(ItmTypeS, 0, ''N'', ''Y''), DECODE(ItmTypeO, 0, ''N'', ''Y''),
			FurGrtAmt, FurGrtDate
		FROM   Arcode
		WHERE  1 = 1 ';

	IF i_ACCODE IS NOT NULL THEN
		sqlStr := sqlStr || ' AND UPPER(ArcCode) LIKE ''' || UPPER(i_ACCODE) || '%'' ';
	END IF;

	IF i_CheckDate IS NOT NULL AND (i_txFrom = 'RegPatReg' OR i_txFrom = 'TxDetail') THEN
		IF LENGTH(i_CheckDate) = 21 THEN
			v_CheckDate := i_CheckDate;
		ELSE
			v_CheckDate := i_CheckDate || ' 00:00:00';
		END IF;

		sqlStr := sqlStr || ' AND (AR_S_Date IS NULL OR AR_S_Date <= TO_DATE(''' || v_CheckDate || ''', ''DD/MM/YYYY HH24:MI:SS'')) ';
		sqlStr := sqlStr || ' AND (AR_E_Date IS NULL OR TO_DATE(''' || v_CheckDate || ''', ''DD/MM/YYYY HH24:MI:SS'') <= AR_E_Date) ';

		IF i_txFrom = 'TxDetail' OR i_ACCODE IS NOT NULL THEN
			sqlStr := sqlStr || ' ORDER BY ArcCode, ArcName ';
		ELSE
			sqlStr := sqlStr || ' ORDER BY ArcName, ArcCode ';
		END IF;
	ELSE
		IF NOT (i_txFrom = 'RegPatReg' OR i_txFrom = 'cshMain' OR i_txFrom = 'NewEditOtApp') THEN
			sqlStr := sqlStr || ' AND Ar_Active = -1 ';
			sqlStr := sqlStr || ' AND AR_E_DATE IS NULL ';
		END IF;

		IF i_ACCODE IS NOT NULL THEN
			sqlStr := sqlStr || ' ORDER BY ArcCode, ArcName ';
		ELSE
			sqlStr := sqlStr || ' ORDER BY ArcName, ArcCode ';
		END IF;
	END IF;

	OPEN OUTCUR FOR sqlStr;
	RETURN OUTCUR;
END NHS_CMB_ARCODE;
/
