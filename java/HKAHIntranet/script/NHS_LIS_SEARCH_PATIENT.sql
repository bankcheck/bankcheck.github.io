create or replace
FUNCTION "NHS_LIS_SEARCH_PATIENT"
(
	v_PATNO	   IN VARCHAR2,
	v_PATIDNO  IN VARCHAR2,
	v_PATHTEL  IN VARCHAR2,
	v_PATBDATE IN VARCHAR2,
	v_PATSEX   IN VARCHAR2,
	v_PATFNAME IN VARCHAR2,
	v_PATGNAME IN VARCHAR2,
	v_PATMNAME IN VARCHAR2,
	v_SCR	   IN VARCHAR2,
	v_ORDBY	   IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR types.cursor_type;
	sqlstr VARCHAR2(2000);
BEGIN
  -- revise from NHS_LIS_PATIENT() by ck on 2013/3/18
	sqlstr := '
		SELECT
			P.PATNO,
			P.PATFNAME,
			P.PATGNAME,
			P.PATMNAME,
			P.PATSEX,
			TO_CHAR(P.PATBDATE, ''DD/MM/YYYY''),
			P.PATHTEL,
			P.PATIDNO,
			P.PATVCNT,
			TO_CHAR(P.LASTUPD, ''DD/MM/YYYY'')
	FROM PATIENT@IWEB P LEFT JOIN LOCATION@IWEB L
	ON P.LOCCODE= L.LOCCODE where ROWNUM < 100';

	IF v_PATNO IS NOT NULL THEN
		sqlstr := sqlstr || ' AND P.PATNO=''' || v_PATNO || '''';
	END IF;

	IF v_PATIDNO IS NOT NULL THEN
		CASE v_SCR
			WHEN 'Cross' THEN
				sqlstr := sqlstr || ' AND P.PATIDNO like ''%' || v_PATIDNO || '%''';
			WHEN 'Wildcard' THEN
				sqlstr := sqlstr || ' AND P.PATIDNO like ''%' || v_PATIDNO || '%''';
			WHEN 'Soundex' THEN
				sqlstr := sqlstr || ' AND P.PATIDNO=''' || v_PATIDNO || '''';
			ELSE
				sqlstr := sqlstr || ' AND P.PATIDNO=''' || v_PATIDNO || '''';
		END CASE;
	END IF;

	IF v_PATHTEL IS NOT NULL THEN
		sqlstr := sqlstr || ' AND P.PATHTEL=''' || v_PATHTEL || '''';
	END IF;

	IF v_PATBDATE IS NOT NULL THEN
		sqlstr := sqlstr || ' AND to_char(P.PATBDATE,''dd/mm/yyyy'')=''' || to_char(to_date(v_PATBDATE,'dd/mm/yyyy'),'dd/mm/yyyy') || '''';
	END IF;

	IF v_PATSEX IS NOT NULL AND v_PATSEX<>'-' THEN
		sqlstr := sqlstr || ' AND P.PATSEX=''' || v_PATSEX || '''';
	END IF;

	IF v_PATFNAME IS NOT NULL THEN
		CASE v_SCR
			WHEN 'Cross' THEN
				sqlstr := sqlstr || ' AND P.PATFNAME=''' || v_PATFNAME || '''';
			WHEN 'Wildcard' THEN
				sqlstr := sqlstr || ' AND P.PATFNAME like ''%' || v_PATFNAME || '%''';
			WHEN 'Soundex' THEN
				sqlstr := sqlstr || ' AND P.PATFNAME=''' || v_PATFNAME || '''';
			ELSE
				sqlstr := sqlstr || ' AND P.PATFNAME like ''%' || v_PATFNAME || '%''';
		END CASE;
	END IF;

	IF v_PATGNAME IS NOT NULL THEN
		CASE v_SCR
			WHEN 'Cross' THEN
				sqlstr := sqlstr || ' AND P.PATGNAME=''' || v_PATGNAME || '''';
			WHEN 'Wildcard' THEN
				sqlstr := sqlstr || ' AND P.PATGNAME like ''%' || v_PATGNAME || '%''';
			WHEN 'Soundex' THEN
				sqlstr := sqlstr || ' AND P.PATGNAME=''' || v_PATGNAME || '''';
			ELSE
				sqlstr := sqlstr || ' AND P.PATGNAME like ''%' || v_PATGNAME || '%''';
		END CASE;
	END IF;

	IF v_PATMNAME IS NOT NULL THEN
		CASE v_SCR
			WHEN 'Cross' THEN
				sqlstr := sqlstr || ' AND P.PATMNAME=''' || v_PATMNAME || '''';
			WHEN 'Wildcard' THEN
				sqlstr := sqlstr || ' AND P.PATMNAME like ''%' || v_PATMNAME || '%''';
			WHEN 'Soundex' THEN
				sqlstr := sqlstr || ' AND P.PATMNAME=''' || v_PATMNAME || '''';
			ELSE
				sqlstr := sqlstr || ' AND P.PATMNAME like ''%' || v_PATMNAME || '%''';
		END CASE;
	END IF;

	IF v_ORDBY='Patient Name' THEN
		sqlstr := sqlstr || ' order by P.PATFNAME,P.PATGNAME';
	ELSE
		sqlstr := sqlstr || ' order by P.PATNO';
	END IF;

	OPEN OUTCUR FOR sqlstr;
	RETURN OUTCUR;
END;