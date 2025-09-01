create or replace
FUNCTION "NHS_CMB_DEPT"
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
		SELECT DPTCODE, DPTNAME
		FROM   DEPT@IWEB
		WHERE  ROWNUM < 100
		ORDER  BY DPTCODE;
	RETURN outcur;
END NHS_CMB_DEPT;