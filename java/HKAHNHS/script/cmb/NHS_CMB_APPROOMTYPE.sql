create or replace
FUNCTION "NHS_CMB_APPROOMTYPE"
(
	V_ACTIVE_ONLY IN VARCHAR2,	-- Y, N
	V_OTCID IN VARCHAR2,
  V_ACTIVE IN VARCHAR2
)
RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
  STRSQL VARCHAR2(2000);
BEGIN
  STRSQL := 'SELECT OTCID, OTCDESC
	FROM OT_CODE
	WHERE (OTCTYPE = ''RM'' ';

  IF V_ACTIVE IS NOT NULL AND LENGTH(V_ACTIVE) > 0 THEN
    IF V_ACTIVE = 'Y' THEN
       STRSQL := STRSQL || 'AND OTCSTS = -1 ';
    ELSIF V_ACTIVE = 'N' THEN
       STRSQL := STRSQL || 'AND OTCSTS = 0 ';
    END IF;
  END IF;

  STRSQL := STRSQL || ') ';

  if v_otcid is not null then
	  IF V_ACTIVE_ONLY = 'Y' THEN
	  	strsql := strsql || ' AND';
	  ELSE
	  	strsql := strsql || ' OR';
	  end if;
	  strsql := strsql || ' OTCID = ' || v_otcid;
  END IF;

  STRSQL := STRSQL || ' ORDER BY OTCORD';

  open outcur for
    STRSQL;
  RETURN OUTCUR;
END NHS_CMB_APPROOMTYPE;
/