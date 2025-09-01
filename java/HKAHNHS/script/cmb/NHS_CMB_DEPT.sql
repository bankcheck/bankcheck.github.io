CREATE OR REPLACE FUNCTION "NHS_CMB_DEPT" (
	v_DPTCODE VARCHAR2,
	v_SortBy  VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	sqlbuf varchar2(200);
BEGIN
	sqlbuf := 'SELECT DPTCODE, DPTNAME ';
	sqlbuf := sqlbuf || 'FROM   DEPT ';
	sqlbuf := sqlbuf || 'WHERE  ROWNUM < 100 ';

	IF v_DPTCODE IS NOT NULL THEN
		sqlbuf := sqlbuf || ' AND DPTCODE = ''' || v_DPTCODE || '''';
	END IF;

	IF v_SortBy IS NOT NULL AND v_SortBy = 'NAME' THEN
		sqlbuf := sqlbuf || 'ORDER  BY DPTNAME ';
	ELSE
		sqlbuf := sqlbuf || 'ORDER  BY DPTCODE ';
	END IF;

	OPEN outcur FOR sqlbuf;
	Return Outcur;
END NHS_CMB_DEPT;
/
