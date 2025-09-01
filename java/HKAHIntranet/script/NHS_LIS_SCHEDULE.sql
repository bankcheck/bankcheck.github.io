create or replace
FUNCTION "NHS_LIS_SCHEDULE"
(
	v_STECODE IN VARCHAR2,
	v_DPTCODE IN VARCHAR2,
	v_SPCCODE IN VARCHAR2,
	v_SCHSDATE IN VARCHAR2,
	v_SCHEDATE IN VARCHAR2,
	v_DOCCODE IN  VARCHAR2,
	v_SCHSTS  IN  VARCHAR2
)
  RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	sqlbuffer VARCHAR2(2000);
BEGIN
	sqlbuffer:='
		select
			S.SCHID,
			CASE TO_NUMBER(TO_CHAR(S.SCHSDATE,''D''))
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
			TO_CHAR(S.SCHSDATE,''DD/MM/YYYY HH24:MI''),
			TO_CHAR(S.SCHEDATE,''HH24:MI''),
			S.DOCCODE,
			D.DOCFNAME,
			D.DOCGNAME,
			ROUND(S.SCHCNT*10000/S.SCHNSLOT)/100,
			S.SCHDESC,
			S.DOCPRACTICE,
			S.SCHSTS,
			S.USRID_C,
			S.USRID_B,
			S.USRID_U,
			S.RMKMODUSER,
			TO_CHAR(S.RMKMODDATE, ''DD/MM/YYYY HH24:MI:SS''),
			S.SCHLEN,
			S.SCHCNT
		FROM SCHEDULE@IWEB S,DOCTOR@IWEB D
		WHERE S.DOCCODE = D.DOCCODE';
	sqlbuffer := sqlbuffer || ' AND S.SCHSDATE >= TO_DATE(''' || v_SCHSDATE || ' 00:00:00'', ''DD/MM/YYYY HH24:MI:SS'')';
	sqlbuffer := sqlbuffer || ' AND S.SCHEDATE <= TO_DATE(''' || v_SCHEDATE || ' 23:59:59'', ''DD/MM/YYYY HH24:MI:SS'')';

	IF v_DOCCODE is not null THEN
		sqlbuffer := sqlbuffer || ' AND S.DOCCODE=''' || v_DOCCODE || '''';
	END IF;

	IF v_STECODE is not null THEN
		sqlbuffer := sqlbuffer || ' AND S.STECODE=''' || v_STECODE || '''';
	END IF;

	IF v_SPCCODE is not null THEN
		sqlbuffer := sqlbuffer || ' AND (D.DOCCODE IN (SELECT DOCCODE FROM DOCSPCLINK@IWEB WHERE SPCCODE = ''' || v_SPCCODE || ''')';
		sqlbuffer := sqlbuffer || ' OR D.DOCCODE IN (SELECT DOCCODE FROM DOCTOR@IWEB  WHERE SPCCODE = ''' || v_SPCCODE || '''))';
	END IF;

	IF v_DPTCODE is not null THEN
		sqlbuffer := sqlbuffer || ' AND  D.DOCCODE IN (SELECT DL.DOCCODE from DOCDPTLINK@IWEB DL WHERE DL.DPTCODE=''' || v_DPTCODE || ''')';
	END IF ;

	IF v_SCHSTS='N' THEN
		sqlbuffer := sqlbuffer || ' AND SCHSTS = ''' || v_SCHSTS || ''' order by D.DOCCODE ,S.SCHSDATE';
	END IF;

	OPEN outcur FOR sqlbuffer;
	RETURN OUTCUR;
END NHS_LIS_SCHEDULE;