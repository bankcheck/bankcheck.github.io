CREATE OR REPLACE FUNCTION "NHS_CMB_SUPPCODE"(
	i_ScyCode  IN VARCHAR2,
	i_StnID IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR  TYPES.CURSOR_TYPE;
	sqlStr  VARCHAR2(1000);
BEGIN
	IF i_ScyCode IS NOT NULL THEN
		OPEN OUTCUR FOR
			SELECT SupCode, SupDesc, ScyCode, SupActive
			FROM   SuppCode
			WHERE  ScyCode = i_ScyCode
			AND    SupCode NOT IN (
				SELECT SupCode FROM TxnEndosDtls
				where  StnID = i_StnID
				AND    USRID_C IS NULL)
			AND    SupActive = -1
			ORDER BY SupCode;
		RETURN OUTCUR;
	ELSE
		OPEN OUTCUR FOR
			SELECT SupCode, SupDesc, ScyCode, SupActive
			FROM   SuppCode
			WHERE  SupCode NOT IN (
				SELECT SupCode FROM TxnEndosDtls
				WHERE  StnID = i_StnID
				AND    USRID_C IS NULL)
			AND    SupActive = -1
			ORDER BY SupCode;
		RETURN OUTCUR;
	END IF;
END NHS_CMB_SUPPCODE;
/
