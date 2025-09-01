create or replace
FUNCTION "NHS_CMB_APPANESMETH"
(
	V_ACTIVE_ONLY IN VARCHAR2,	-- Y, N
	V_OTCID IN VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE
AS
  OUTCUR TYPES.CURSOR_TYPE;
  STRSQL VARCHAR2(2000);
BEGIN
  STRSQL := 'SELECT OTCID, OTCDESC
	FROM OT_CODE
	WHERE (OTCTYPE = ''AM''
		and OTCSTS = -1 ) ';

  if V_OTCID is not null then
	  IF V_ACTIVE_ONLY = 'Y' THEN
	  	strsql := strsql || ' AND';
	  ELSE
	  	strsql := strsql || ' OR';
	  end if;
	  strsql := strsql || ' OTCID = ''' || V_OTCID || '''';
  END IF;

  STRSQL := STRSQL || ' ORDER BY OTCORD';

  open outcur for
    STRSQL;
   RETURN OUTCUR;
END NHS_CMB_APPANESMETH;
/