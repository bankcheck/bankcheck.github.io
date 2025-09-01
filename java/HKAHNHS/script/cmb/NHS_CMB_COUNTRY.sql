CREATE OR REPLACE FUNCTION "NHS_CMB_COUNTRY"
	RETURN types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	open outcur for
		select coucode, coudesc || ' ' || coucode
		from   country
--		where  rownum<100
		order by coudesc;
	RETURN outcur;
END NHS_CMB_COUNTRY;
/
