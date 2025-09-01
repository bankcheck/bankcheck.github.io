create or replace FUNCTION "NHS_CMB_APPREFERDOCTOR"
(
	V_ACTIVE_ONLY IN VARCHAR2,	-- Y, N
	V_DOCCODE IN VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE
AS
  OUTCUR TYPES.CURSOR_TYPE;
  STRSQL VARCHAR2(2000);
BEGIN
  STRSQL := 'SELECT DOCCODE, NAME FROM (SELECT doccode, docfname || '' '' || docgname || '' ('' || doccode || '') ''||DECODE(company,NULL,NULL,'' - ''||company)  as name,
            DECODE(MSTRDOCCODE, NULL,DOCCODE, MSTRDOCCODE||''S'') AS ORDERING
	FROM doctor
	WHERE (1 = 1';

  if V_DOCCODE is not null then
	  IF V_ACTIVE_ONLY = 'Y' THEN
	  	strsql := strsql || ' AND';
	  ELSE
	  	strsql := strsql || ' OR';
	  end if;
	  strsql := strsql || ' doccode = ''' || V_DOCCODE || '''';
  END IF;
  STRSQL := STRSQL || ')';
  STRSQL := STRSQL || ' ORDER BY docfname, docgname, ordering asc)';

  open outcur for
    STRSQL;
   RETURN OUTCUR;
END NHS_CMB_APPREFERDOCTOR;
/