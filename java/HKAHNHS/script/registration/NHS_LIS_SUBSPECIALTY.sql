CREATE OR REPLACE FUNCTION "NHS_LIS_SUBSPECIALTY" (
	V_DOCCODE DOCTOR.DOCCODE%TYPE
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
	SELECT s.spccode, s.spcname, dsl.isofficial
	FROM   docspclink dsl, spec s
	WHERE  dsl.spccode = s.spccode
	AND    dsl.doccode = V_DOCCODE
	ORDER  BY isofficial, spcname;

	RETURN OUTCUR;
END NHS_LIS_SUBSPECIALTY;
/
