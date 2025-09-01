CREATE OR REPLACE FUNCTION "NHS_GET_SPECIALTY" (
	v_SPCCODE IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	sqlbuff varchar(200);
BEGIN
	sqlbuff := 'SELECT SPCCNAME, SPCCODE, SPCNAME FROM SPEC';
	IF v_SPCCODE = 'DENTIST' THEN
		sqlbuff := sqlbuff || ' WHERE SPCCODE IN (''DENTIST'', ''DENHYG'', ''ORALMAX'', ''PROSDON'')';
	ELSIF v_SPCCODE IS NOT NULL THEN
		sqlbuff := sqlbuff || ' WHERE SPCCODE = ''' || v_SPCCODE || '''';
	END IF;
	sqlbuff := sqlbuff || ' ORDER BY SPCCODE';

	OPEN outcur FOR sqlbuff;
	RETURN OUTCUR;
END NHS_GET_SPECIALTY;
/
