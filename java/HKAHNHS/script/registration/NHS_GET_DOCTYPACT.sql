create or replace
FUNCTION "NHS_GET_DOCTYPACT" (
	V_DOCTYPE IN Bed.BedCode%TYPE
)
	RETURN Types.cursor_type
AS
    outcur types.cursor_type;
BEGIN
	open outcur for
		SELECT 
		(
			CASE 
			WHEN V_DOCTYPE in ('ID','CI','BC') THEN '852'
			WHEN V_DOCTYPE in ('MA') THEN '853'
			WHEN V_DOCTYPE in ('TW') THEN '86'
			ELSE '' END
		) as IssueBy from Dual;
	RETURN outcur;
 END NHS_GET_DOCTYPACT;
/
