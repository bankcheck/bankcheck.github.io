CREATE OR REPLACE Function "NHS_CMB_DOCTORPROFILE" (
	v_Criteria VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	Outcur Types.Cursor_Type;
	SqlStr VARCHAR2(1000);
Begin
	IF UPPER(v_Criteria) = 'DOCTOR_NAME' THEN
		SqlStr := 'SELECT d.DocCode, d.DocFName || '' '' || d.DocGName || '' '' || d.DocCName || '' ('' || d.DocCode || '')'', s.SpcName';
		SqlStr := SqlStr || ' FROM Doctor d, Spec s';
		SqlStr := SqlStr || ' WHERE d.SpcCode = s.SpcCode AND d.DocSts = -1 AND ShowProfile = -1';
		SqlStr := SqlStr || ' ORDER BY d.DocFName || '' '' || d.DocGName || '' '' || d.DocCName, s.SpcName, d.DocCode';
	ELSIF UPPER(v_Criteria) = 'SPECIALTY' THEN
		SqlStr := 'SELECT d.DocCode, s.SpcName || '' ('' || d.DocCode || '')'', d.DocFName || '' '' || d.DocGName || '' '' || d.DocCName';
		SqlStr := SqlStr || ' FROM  Doctor d, Spec s';
		SqlStr := SqlStr || ' WHERE d.SpcCode = s.SpcCode AND d.DocSts = -1 AND ShowProfile = -1';
		SqlStr := SqlStr || ' ORDER BY s.SpcName, d.DocFName || '' '' || d.DocGName || '' '' || d.DocCName, d.DocCode';
	ELSE
		SqlStr := 'SELECT d.DocCode, d.DocCode, d.DocFName || '' '' || d.DocGName || '' '' || d.DocCName, s.SpcName';
		SqlStr := SqlStr || ' FROM Doctor d, Spec s';
		SqlStr := SqlStr || ' WHERE d.SpcCode = s.SpcCode AND d.DocSts = -1 AND ShowProfile = -1';
		SqlStr := SqlStr || ' ORDER BY d.DocCode, d.DocFName || '' '' || d.DocGName || '' '' || d.DocCName, s.SpcName';
	END IF;

	Open Outcur For SqlStr;
	RETURN Outcur;
END NHS_CMB_DOCTORPROFILE;
/
