CREATE OR REPLACE FUNCTION "NHS_LIS_PATALERT" (
	v_patno   IN VARCHAR2,
	v_showhis IN VARCHAR2,
	v_usrid   IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	sqlstr VARCHAR2(2000);
BEGIN
	sqlstr := '
		SELECT
			'''',
			A.ALTCODE,
			A.ALTDESC,
			DECODE(U1.USRNAME, '''', P.USRID_A, U1.USRNAME),
			TO_CHAR(P.PALDATE,''DD/MM/YYYY''),
			DECODE(U2.USRNAME, '''', P.USRID_C, U2.USRNAME),
			TO_CHAR(P.PALCDATE,''DD/MM/YYYY''),
			A.ALTID,
			P.PALID
		FROM PATALTLINK P
		LEFT JOIN ALERT A ON P.ALTID = A.ALTID
		LEFT JOIN USR U1 ON P.USRID_A = U1.USRID
		LEFT JOIN USR U2 ON P.USRID_C = U2.USRID
		WHERE P.PATNO = ''' || v_patno || '''';

	IF v_usrid != GET_CURRENT_STECODE THEN
		sqlstr := sqlstr || ' AND P.ALTID IN (SELECT DISTINCT R.ALTID
						FROM USRROLE U, ROLALTLINK R
						WHERE U.ROLID = R.ROLID
						AND U.USRID = ''' || v_usrid || ''')';
	END IF;

	IF v_showhis = '0' THEN
		sqlstr := sqlstr || ' AND P.USRID_C IS NULL';
	END IF;

	sqlstr := sqlstr || ' ORDER  BY p.paldate';

	OPEN outcur FOR sqlstr;
	RETURN OUTCUR;
END NHS_LIS_PATALERT;
/
