CREATE OR REPLACE FUNCTION NHS_LIS_SEARCH_TALERT (
	v_PATNO     IN VARCHAR2,
	v_emailAddr IN VARCHAR2
)
RETURN
	types.cursor_type
AS
	outcur types.cursor_type;
	Sqlstr VARCHAR2(1000);
BEGIN
	Sqlstr := 'Select distinct a.altid, a.altcode, a.altdesc, e.Email
		From alert a, AlertEmail e
		Where a.altid in
		(Select altid from pataltlink where Patno = ''' || v_PATNO || ''' and usrid_c is null)
		and e.altid = a.altid
		and a.ALTEMAIL = -1';
	IF v_emailAddr IS NOT NULL THEN
		SQLSTR := SQLSTR || ' and e.Email = ''' || v_emailAddr || '''';
	END IF;
	SQLSTR := SQLSTR || ' Order by e.Email, a.altdesc';

	OPEN OUTCUR FOR SQLSTR;
	RETURN OUTCUR;
END NHS_LIS_SEARCH_TALERT;
/
