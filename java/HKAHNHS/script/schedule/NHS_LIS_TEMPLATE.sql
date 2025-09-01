create or replace FUNCTION "NHS_LIS_TEMPLATE" (
	v_DocCode IN VARCHAR2,
	v_SpcCode IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	outcur TYPES.CURSOR_TYPE;
BEGIN
	OPEN outcur FOR
		SELECT
			D.DOCFNAME || ' ' || D.DOCGNAME,
			T.TEMDAY,
			CASE T.TEMDAY
			WHEN 1 THEN
				'Sunday'
			WHEN 2 THEN
				'Monday'
			WHEN 3 THEN
				'Tuesday'
			WHEN 4 THEN
				'Wednesday'
			WHEN 5 THEN
				'Thursday'
			WHEN 6 THEN
				'Friday'
			WHEN 7 THEN
				'Saturday'
			ELSE
				'Nil'
			END,
			T.TEMLEN,
			TO_CHAR(T.TEMSTIME,'hh24:mi'),
			TO_CHAR(T.TEMETIME,'hh24:mi'),
			T.DOCPRACTICE,
			T.DOCLOCID,
			T.TEMID,
			T.DocCode,
      T.RMID,
      H.HPSTATUS
		FROM  TEMPLATE T, DOCTOR D, (SELECT HPSTATUS FROM HPSTATUS WHERE HPTYPE = 'DRROOM') H
		WHERE T.DocCode = D.DocCode
    AND T.RMID = H.HPSTATUS(+)
		AND   T.DocCode = v_DocCode
		AND  (v_SpcCode IS NULL OR D.SpcCode = v_SpcCode OR (v_SpcCode = 'DENTIST' AND D.SpcCode IN ('DENTIST', 'DENHYG', 'ORALMAX', 'PROSDON')))
		AND   T.SteCode = GET_CURRENT_STECODE
		ORDER BY T.TEMDAY;

	RETURN OUTCUR;
END NHS_LIS_TEMPLATE;
/
