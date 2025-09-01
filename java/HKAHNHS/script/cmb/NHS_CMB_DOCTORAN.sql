create or replace FUNCTION "NHS_CMB_DOCTORAN" (
	v_ACTIVE_ONLY IN VARCHAR2,	-- Y, N
	v_DOCCODE IN VARCHAR2
)
	RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
	STRSQL VARCHAR2(2000);
BEGIN
	STRSQL := 'SELECT doccode, docfname || '' '' || docgname || '' ('' || doccode || '') ''||DECODE(company,NULL,NULL,'' - ''||company)  as name 
  FROM Doctor WHERE isOTAnesthetist = -1 ';

	IF v_DOCCODE IS NOT NULL THEN
		IF v_ACTIVE_ONLY = 'Y' THEN
			strsql := strsql || ' AND';
		ELSE
			strsql := strsql || ' OR';
		END IF;
		strsql := strsql || ' doccode = ''' || v_DOCCODE || '''';
	END IF;

	STRSQL := STRSQL || ' ORDER BY docfname, docgname';

	open outcur for STRSQL;
	RETURN OUTCUR;
END NHS_CMB_DOCTORAN;
/
