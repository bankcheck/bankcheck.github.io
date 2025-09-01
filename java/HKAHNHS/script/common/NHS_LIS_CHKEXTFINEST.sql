create or replace
FUNCTION "NHS_LIS_CHKEXTFINEST" (
	v_PATNO    IN VARCHAR2,
	v_PATNAME IN VARCHAR2,
	v_docCode IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	sqlStr VARCHAR2(5000);
BEGIN
	sqlStr := 'select PATNO,patname,DOCCODE, PROCCODE, DIAGNOSIS, LOS,
				ACMCODE,DRRNDDAYSUMMIN1,DRRNDDAYSUMMAX1, PROFEEMIN,PROFEEMAX,
				ANAESTHETISTFEEMIN, ANAESTHETISTFEEMAX, OTHERMIN1, OTHERMAX1,OTHERMIN2, 
				OTHERMAX2,DRRNDDAYSUMMIN2, DRRNDDAYSUMMAX2, -- RMSUMMIN, RMSUMMAX, 
				OTMIN,OTMAX, OTHERMIN3, OTHERMAX3
				from fin_quotation where';
 
	IF (v_patno is not null AND LENGTH(v_patno) > 0 ) THEN
		sqlStr := sqlStr || ' patno = '''||v_patno||'''';
	END IF;
	IF v_PATNAME is not null  AND LENGTH(TRIM(v_PATNAME)) > 0 THEN
		if (v_patno is not null AND LENGTH(v_patno) > 0 ) THEN
			sqlStr := sqlStr || ' OR ';
		END IF;
		sqlStr := sqlStr || 'PATNAME LIKE ''' || v_PATNAME || '%'' ';
	END IF;
	
	IF v_docCode is not null  AND LENGTH(TRIM(v_docCode)) > 0 THEN
		if (v_PATNAME is not null AND LENGTH(v_PATNAME) > 0 ) THEN
			sqlStr := sqlStr || ' OR ';
		END IF;
		 sqlStr := sqlStr || 'v_docCode = ''' || v_PATNAME || ''' ';
	END IF;


	OPEN OUTCUR FOR sqlStr;
	RETURN OUTCUR;

END NHS_LIS_CHKEXTFINEST;
/
