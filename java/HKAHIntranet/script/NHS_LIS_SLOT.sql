create or replace
FUNCTION "NHS_LIS_SLOT"
( v_SCHID IN VARCHAR2 )
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN OUTCUR FOR
	SELECT
		SLTID,
		SCHID,
		to_char(SLTSTIME,'dd/mm/yyyy hh24:mi:ss'),
		to_char(SLTSTIME,'hh24:mi'),
		SLTCNT
	FROM SLOT@IWEB
	WHERE SCHID = TO_NUMBER(v_SCHID)
	ORDER BY SLTSTIME;

	RETURN OUTCUR;
END NHS_LIS_SLOT;