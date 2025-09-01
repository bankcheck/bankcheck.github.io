create or replace FUNCTION           "NHS_LIS_APPBWSERM" (
  v_SCHSDATE   IN VARCHAR2,
	v_SCHEDATE   IN VARCHAR2,
	v_DOCCODE    IN VARCHAR2,
	v_LOCATION   IN VARCHAR2,
	v_BLOCKSTS   IN VARCHAR2,
	v_SCHSTS     IN VARCHAR2,
	v_SORTBYTIME IN VARCHAR2,
	v_USRID      IN VARCHAR2
)
  RETURN Types.cursor_type
AS
	outcur types.cursor_type;
  v_COUNT NUMBER;
	sqlbuffer VARCHAR2(2000);
BEGIN
	SELECT COUNT(1) INTO v_COUNT FROM USRACCESSDOC WHERE USRID = v_USRID;

	sqlbuffer := '
		SELECT
			S.SCHID,
			SE.RMID AS RMID,
			CASE TO_NUMBER(TO_CHAR(S.SCHSDATE, ''D''))
				WHEN 1 THEN
					''Sun''
				WHEN 2 THEN
					''Mon''
				WHEN 3 THEN
					''Tue''
				WHEN 4 THEN
					''Wed''
				WHEN 5 THEN
					''Thu''
				WHEN 6 THEN
					''Fri''
				WHEN 7 THEN
					''Sat''
				ELSE
					''Nil''
			END,
			TO_CHAR(S.SCHSDATE, ''DD/MM/YYYY HH24:MI'') AS SCHSDATE,
			TO_CHAR(S.SCHEDATE, ''HH24:MI''),
			S.DOCCODE,
			D.DOCFNAME,
			D.DOCGNAME,
			ROUND(S.SCHCNT / S.SCHNSLOT * 100, 2),
			RANK() OVER(PARTITION BY RMID ORDER BY ROWNUM) AS SEQN,
			S.DOCPRACTICE,
			S.SCHSTS,
			U1.USRNAME,
			U2.USRNAME, TO_CHAR(S.SCHDATE_B, ''DD/MM/YYYY HH24:MI:SS''),
			U3.USRNAME, TO_CHAR(S.SCHDATE_U, ''DD/MM/YYYY HH24:MI:SS''),
			U4.USRNAME, TO_CHAR(S.RMKMODDATE, ''DD/MM/YYYY HH24:MI:SS''),
			S.SCHLEN,
			S.SCHCNT,
      TO_CHAR(S.SCHEDATE, ''DD/MM/YYYY HH24:MI''),
      D.SPCCODE
		FROM SCHEDULE S
		LEFT JOIN DOCTOR D ON S.DOCCODE = D.DOCCODE
		LEFT JOIN USR U1 ON S.USRID_C = U1.USRID
		LEFT JOIN USR U2 ON S.USRID_B = U2.USRID
		LEFT JOIN USR U3 ON S.USRID_U = U3.USRID
		LEFT JOIN USR U4 ON S.RMKMODUSER = U4.USRID
    LEFT JOIN SCHEDULE_EXTRA SE ON S.SCHID = SE.SCHID
		WHERE S.STECODE = GET_CURRENT_STECODE
		AND S.SchNSlot <> 0 ';


	IF v_SCHSDATE IS NOT NULL THEN
		IF LENGTH(v_SCHSDATE) = 10 THEN
		  sqlbuffer := sqlbuffer || ' AND S.SCHSDATE >= TO_DATE(''' || v_SCHSDATE || ' 00:00:00'', ''DD/MM/YYYY HH24:MI:SS'')';
		ELSIF LENGTH(v_SCHSDATE) = 16 THEN
		  sqlbuffer := sqlbuffer || ' AND (S.SCHSDATE >= TO_DATE(''' || v_SCHSDATE || ':00'', ''DD/MM/YYYY HH24:MI:SS'')OR  S.SCHEDATE >= TO_DATE(''' || v_SCHSDATE || ':00'', ''DD/MM/YYYY HH24:MI:SS'') ) ';
		ELSIF LENGTH(v_SCHSDATE) = 19 THEN
		  sqlbuffer := sqlbuffer || ' AND (S.SCHSDATE >= TO_DATE(''' || v_SCHSDATE || ''', ''DD/MM/YYYY HH24:MI:SS'') OR  S.SCHEDATE >= TO_DATE(''' || v_SCHSDATE || ''', ''DD/MM/YYYY HH24:MI:SS'') )';
		END IF;
	END IF;

	IF v_SCHEDATE IS NOT NULL THEN
		IF LENGTH(v_SCHEDATE) = 10 THEN
		  sqlbuffer := sqlbuffer || ' AND S.SCHEDATE <= TO_DATE(''' || v_SCHEDATE || ' 23:59:59'', ''DD/MM/YYYY HH24:MI:SS'')';
		ELSIF LENGTH(v_SCHEDATE) = 16 THEN
		  sqlbuffer := sqlbuffer || ' AND S.SCHEDATE <= TO_DATE(''' || v_SCHEDATE || ':59'', ''DD/MM/YYYY HH24:MI:SS'')';
		ELSIF LENGTH(v_SCHEDATE) = 19 THEN
		  sqlbuffer := sqlbuffer || ' AND S.SCHEDATE <= TO_DATE(''' || v_SCHEDATE || ''', ''DD/MM/YYYY HH24:MI:SS'')';
		END IF;
	END IF;

	IF v_DOCCODE IS NOT NULL AND LENGTH(v_DOCCODE) > 0 THEN
		IF INSTR(v_doccode, ',') > 0 THEN
			sqlbuffer := sqlbuffer || ' AND S.DOCCODE in ( ''' || REPLACE(v_DOCCODE, ',', ''',''') || ''' ) ';
		ELSIF SUBSTR(v_DOCCODE, -1) <> '%' THEN
			sqlbuffer := sqlbuffer || ' AND S.DOCCODE = ''' || v_DOCCODE || '''';
		ELSE
			sqlbuffer := sqlbuffer || ' AND S.DOCCODE like ''' || v_DOCCODE || '''';
		END IF;
	END IF;

	IF v_COUNT > 0 THEN
		sqlbuffer := sqlbuffer || ' AND (D.DOCCODE IN (SELECT DOCCODE FROM USRACCESSDOC WHERE USRID = ''' || v_USRID || ''' AND SPCCODE = ''ALL'')';
		sqlbuffer := sqlbuffer || ' OR   D.DOCCODE IN (SELECT DOCCODE FROM DOCTOR WHERE SPCCODE IN (SELECT SPCCODE FROM USRACCESSDOC WHERE USRID = ''' || v_USRID || '''  AND DOCCODE = ''ALL''))) ';
	END IF;

	IF v_BLOCKSTS = 'Y' THEN
		sqlbuffer := sqlbuffer || ' AND SCHSTS = ''B''';
	ELSIF v_SCHSTS = 'N' THEN
		sqlbuffer := sqlbuffer || ' AND SCHSTS = ''' || v_SCHSTS || '''';
	END IF;

    sqlbuffer := sqlbuffer || ' AND SE.RMID IS NOT NULL ';
IF v_LOCATION IS NOT NULL AND LENGTH(v_LOCATION) > 0 THEN
  sqlbuffer := sqlbuffer || ' AND SE.RMID IN (SELECT HPSTATUS FROM HPSTATUS WHERE HPTYPE=''DRROOM'' AND HPKEY = ''' || v_LOCATION || ''') ';
END IF;
  sqlbuffer := sqlbuffer || ' UNION ';
  sqlbuffer := sqlbuffer || ' SELECT 1,HPKEY AS RMID ,''NA'',''' || v_SCHSDATE || ' '' '||'||TO_CHAR(HPSDATE,''HH24:MI'') AS SCHSDATE, ';
  sqlbuffer := sqlbuffer || ' TO_CHAR(HPEDATE, ''HH24:MI''),''BLOCK'' AS DOCCODE,''BLOCK'',''BLOCK'',0,0, HPRMK,''B'', ';
  sqlbuffer := sqlbuffer || ' '''','''','''','''', ';
  sqlbuffer := sqlbuffer || ' '''','''','''',0,0,''' || v_SCHSDATE || ' '' '||'||TO_CHAR(HPEDATE,''HH24:MI''),''NA'' ';
  sqlbuffer := sqlbuffer || ' FROM HPSTATUS WHERE HPTYPE = ''RMBLKSESS'' AND HPSTATUS = ''B'' AND HPACTIVE = -1 ';
    sqlbuffer := sqlbuffer || ' ORDER BY RMID, SCHSDATE,DOCCODE';

DBMS_OUTPUT.PUT_LINE(sqlbuffer);
	OPEN outcur FOR sqlbuffer;
	RETURN OUTCUR;
END NHS_LIS_APPBWSERM;
/
