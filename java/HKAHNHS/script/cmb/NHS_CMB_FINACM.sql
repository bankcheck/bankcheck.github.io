create or replace
FUNCTION      "NHS_CMB_FINACM"
	RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN OUTCUR FOR
		Select Acmcode, Acmname
		FROM FIN_ACM
		Where Rownum < 100
		ORDER BY SORT;

	RETURN OUTCUR;
END NHS_CMB_FINACM;
/