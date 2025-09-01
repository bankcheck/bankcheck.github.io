CREATE OR REPLACE FUNCTION "NHS_LIS_MOMBABYSEARCH" (
	v_patno    IN VARCHAR2,
	v_patfname IN VARCHAR2,
	v_patgname IN VARCHAR2,
	v_mbAll    IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	sqlstr VARCHAR2(2000);
BEGIN
	sqlstr:='
		SELECT
			M.PATNO AS MPATNO ,
			M.PATFNAME AS MPATFNAME ,
			M.PATGNAME AS MPATGNAME ,
			M.PATCNAME AS MPATCNAME ,
			B.PATNO AS BPATNO ,
			B.PATSEX AS BPATSEX ,
			B.PATFNAME AS BPATFNAME ,
			B.PATGNAME AS BPATGNAME ,
			B.PATCNAME AS BPATCNAME ,
			to_char(B.PATBDATE, ''dd/mm/yyyy'') AS BPATBDATE ,
			L.MBLDESC AS MBLDESC
		FROM PATIENT M, PATIENT B, MBLINK L
		WHERE L.PATNO_M= M.PATNO
		AND L.PATNO_B= B.PATNO ';

	if v_patno is not null then
		if v_mbAll = 'M' then
			sqlstr := sqlstr ||' AND ( L.PATNO_M ='''||v_patno||''' )';
		elsif v_mbAll = 'B' then
			sqlstr := sqlstr ||' AND ( L.PATNO_B ='''||v_patno||''' )';
		elsif v_mbAll = 'ALL' then
			sqlstr := sqlstr ||' AND ( L.PATNO_M ='''||v_patno||'''  OR L.PATNO_B ='''||v_patno||''' )';
		end if;
	end if;

	if v_patfname is not null then
		if v_mbAll = 'M' then
			sqlstr := sqlstr ||
				' AND ( L.PATNO_M IN  (SELECT  PATNO
				FROM PATIENT
				WHERE   PATFNAME ='''||v_patfname||''' ) )';
		elsif v_mbAll = 'B' then
			sqlstr := sqlstr ||
				' AND ( L.PATNO_B IN  (SELECT  PATNO
				FROM PATIENT
				WHERE   PATFNAME = '''||v_patfname||''' ) )';
		elsif v_mbAll = 'ALL' then
			sqlstr := sqlstr ||
				' AND ( L.PATNO_M IN  (SELECT  PATNO
				FROM PATIENT
				WHERE   PATFNAME ='''||v_patfname||''' ) OR  L.PATNO_B IN  (SELECT  PATNO
				FROM PATIENT
				WHERE   PATFNAME = '''||v_patfname||''' ) )';
		end if;
	end if;

	if v_patgname is not null then
		if v_mbAll = 'M' then
			sqlstr := sqlstr ||' AND ( L.PATNO_M IN  (SELECT  PATNO
				FROM PATIENT
				WHERE   PATGNAME ='''||v_patgname||''' ) )';
		elsif v_mbAll = 'B' then
			sqlstr := sqlstr ||' AND (  L.PATNO_B IN  (SELECT  PATNO
				FROM PATIENT
				WHERE   PATGNAME = '''||v_patgname||''' ) )';
		elsif v_mbAll = 'ALL' then
			sqlstr := sqlstr ||' AND ( L.PATNO_M IN  (SELECT  PATNO
				FROM PATIENT
				WHERE   PATGNAME ='''||v_patgname||''' ) OR  L.PATNO_B IN  (SELECT  PATNO
				FROM PATIENT
				WHERE   PATGNAME = '''||v_patgname||''' ) )';
		end if;
	end if;

	sqlstr := sqlstr ||' ORDER BY M.PATNO';
	dbms_output.put_line('sql:'||sqlstr);

	OPEN outcur FOR sqlstr;
	RETURN OUTCUR;
END NHS_LIS_MOMBABYSEARCH;
/
