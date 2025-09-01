create or replace
FUNCTION NHS_CMB_DEPTPROC
(
	V_ACTIVE_ONLY IN VARCHAR2,	-- Y, N
	V_DEPTPID IN VARCHAR2,
 	 V_ACTIVE IN VARCHAR2,
 	 V_DEPTTYPE IN VARCHAR2
)
  RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
  STRSQL VARCHAR2(2000);
BEGIN
  STRSQL := 'SELECT deptpid,deptpdesc || '' ('' || deptpcode || '')'' deptpname
	FROM DEPT_PROC
	WHERE 1 = 1 ';
	
	IF v_DEPTTYPE IS NOT NULL THEN
		STRSQL := STRSQL || ' AND DEPTTYPE = ''' || V_DEPTTYPE || '''';
	END IF;
      
  IF V_ACTIVE IS NOT NULL AND LENGTH(V_ACTIVE) > 0 THEN
    IF V_ACTIVE = 'Y' THEN
       STRSQL := STRSQL || 'AND (DEPTPSTS = -1';
    ELSIF V_ACTIVE = 'N' THEN
       STRSQL := STRSQL || 'AND (DEPTPSTS = 0';
    END IF;
  END IF;

  if V_DEPTPID is not null then
	  IF V_ACTIVE_ONLY = 'Y' THEN
	  	strsql := strsql || ' AND';
	  ELSE
	  	strsql := strsql || ' OR';
	  end if;
	  strsql := strsql || ' DEPTPID = ' || V_DEPTPID;
  END IF;

  IF V_ACTIVE IS NOT NULL AND LENGTH(V_ACTIVE) > 0 THEN
    STRSQL := STRSQL || ' )';
  END IF;
  STRSQL := STRSQL || ' ORDER BY deptpname';

  open outcur for
    STRSQL;
  RETURN OUTCUR;
END NHS_CMB_DEPTPROC;
/