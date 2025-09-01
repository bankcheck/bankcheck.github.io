create or replace
FUNCTION NHS_CMB_OTPROC
(
	V_ACTIVE_ONLY IN VARCHAR2,	-- Y, N
	V_OTPID IN VARCHAR2,
  V_ACTIVE IN VARCHAR2
)
  RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
  STRSQL VARCHAR2(2000);
BEGIN
  STRSQL := 'SELECT otpid,otpdesc || '' ('' || otpcode || '')'' otpname
	FROM OT_PROC
	WHERE 1 = 1 ';
      
  IF V_ACTIVE IS NOT NULL AND LENGTH(V_ACTIVE) > 0 THEN
    IF V_ACTIVE = 'Y' THEN
       STRSQL := STRSQL || 'AND (OTPSTS = -1';
    ELSIF V_ACTIVE = 'N' THEN
       STRSQL := STRSQL || 'AND (OTPSTS = 0';
    END IF;
  END IF;

  if V_OTPID is not null then
	  IF V_ACTIVE_ONLY = 'Y' THEN
	  	strsql := strsql || ' AND';
	  ELSE
	  	strsql := strsql || ' OR';
	  end if;
	  strsql := strsql || ' OTPID = ' || V_OTPID;
  END IF;

  IF V_ACTIVE IS NOT NULL AND LENGTH(V_ACTIVE) > 0 THEN
    STRSQL := STRSQL || ' )';
  END IF;
  STRSQL := STRSQL || ' ORDER BY otpname';

  open outcur for
    STRSQL;
  RETURN OUTCUR;
END NHS_CMB_OTPROC;
/