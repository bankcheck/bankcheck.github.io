CREATE OR REPLACE FUNCTION "NHS_LIS_ARCCODE" (
	v_ArcCode IN VARCHAR2,
	v_ArcName IN VARCHAR2,
	v_ArcTel  IN VARCHAR2,
	v_ArcCT   IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR types.cursor_type;
BEGIN
	OPEN OUTCUR FOR
		SELECT
			ArcCode,
			ArcName,
			ArcTel,
			ArcCT,
			ArcAdd1,
			ArcAdd2,
			ArcAdd3,
			ArcTitle,
			ArcUAmt,
			ArcAmt
		FROM  ArCode
		WHERE ROWNUM < 1000
		AND  (v_ArcCode IS NULL OR UPPER(ArcCode) LIKE UPPER(v_ArcCode) || '%')
		AND  (v_ArcName IS NULL OR UPPER(ArcName) LIKE '%' || UPPER(v_ArcName) || '%')
		AND  (v_ArcTel IS NULL OR UPPER(ArcTel) LIKE '%' || UPPER(v_ArcTel) || '%')
		AND  (v_ArcCT IS NULL OR UPPER(ArcCT) LIKE '%' || UPPER(v_ArcCT) || '%')
		ORDER BY ArcCode;
	RETURN OUTCUR;
END NHS_LIS_ARCCODE;
/
