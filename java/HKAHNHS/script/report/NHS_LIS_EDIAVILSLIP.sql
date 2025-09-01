create or replace FUNCTION                               "NHS_LIS_EDIAVILSLIP" (
	V_ARCCODE IN VARCHAR2,
	V_STARTDATE   IN VARCHAR2,
	V_ENDDATE  IN VARCHAR2,
  V_PATNO IN VARCHAR2,
  V_SLPNO IN VARCHAR2,
  V_SLPTYPE IN VARCHAR2,
  V_SITECODE IN VARCHAR2
  )
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SqlStr VARCHAR2(2000);
	ARTX_STATUS_NORMAL VARCHAR2(1) := 'N';
BEGIN

		SQLSTR := '
        SELECT  
        '''',
        AT.ATXID,
        DECODE(SP.SLPTYPE, ''I'', ''I'', ''O'', ''O'', ''D'', ''D'', ''A'')     AS PTYPE,
        SP.PATNO,
        TO_CHAR(AT.ATXCDATE, ''DDMONYYYY'', ''nls_date_language=ENGLISH'') AS TDATE,
        AT.SLPNO AS SLPNO,
        TO_CHAR(R.REGDATE, ''DD/MON/YYYY'', ''nls_date_language=ENGLISH'') AS RDATE,
        (AT.ATXAMT - AT.ATXSAMT)       AS BAL,
        AT.ATXCDATE SORTDATE,
        SP.PATREFNO
      FROM ARCODE AM,
        ARTX AT,
        SLIP SP,
        REG R
        WHERE AM.STECODE              = '''||V_SITECODE||'''';
        IF v_ARCCODE IS NOT NULL THEN
        SQLSTR := SQLSTR || ' AND (AM.ARCCODE = ''' || V_ARCCODE || ''' OR ''' || V_ARCCODE || '''IS NULL) ';
        END IF;
        IF V_STARTDATE IS NOT NULL THEN  
          SQLSTR := SQLSTR || ' AND (''' || V_STARTDATE || ''' IS NULL OR AT.ATXCDATE >= TO_DATE(''' || V_STARTDATE ||''', ''DD/MM/YYYY'')) ';
        END IF;
        IF V_ENDDATE IS NOT NULL THEN  
          SQLSTR := SQLSTR || ' AND (''' || V_ENDDATE || ''' IS NULL OR AT.ATXCDATE < TO_DATE(''' || V_ENDDATE ||''', ''DD/MM/YYYY'')+ 1 ) ';
        END IF;
        IF V_SLPTYPE IS NOT NULL THEN
          SQLSTR := SQLSTR || ' AND SP.SLPTYPE = ''' || V_SLPTYPE || '''';
        END IF;
        IF v_PATNO IS NOT NULL THEN
          SqlStr := SqlStr || ' AND SP.PATNO = ''' || v_PATNO || '''';
        END IF;
        IF V_SLPNO IS NOT NULL THEN
          SQLSTR := SQLSTR || ' AND AT.SLPNO = ''' || V_SLPNO || '''';
        END IF;
        SQLSTR := SQLSTR || ' AND AT.ARCCODE              = AM.ARCCODE
        AND AT.ATXSTS               = ''N''
        AND AT.ATXAMT - AT.ATXSAMT <> 0
        AND AT.SLPNO                = SP.SLPNO(+)
        AND AT.SLPNO = R.SLPNO(+)
        ORDER BY PTYPE,
          SORTDATE';
    
  DBMS_OUTPUT.PUT_LINE(sqlstr);
	OPEN OUTCUR FOR SqlStr;
	RETURN OUTCUR;
END NHS_LIS_EDIAVILSLIP;
/