create or replace
FUNCTION      "NHS_CMB_RMDEREND"
	RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
BEGIN
	Open Outcur For
		SELECT 'Enclose', 'Enclosed the relevant document for your reference.' FROM DUAL
		Union
		Select 'Contact', 'Please feel free to contact your insurer for further details. ' From Dual
    Union
		Select 'All', 'All of the above' From Dual
    order by 1 desc;
	RETURN OUTCUR;
END NHS_CMB_RMDEREND;
/
