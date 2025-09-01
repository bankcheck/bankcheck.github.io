CREATE OR REPLACE Function "NHS_CMB_DOCTOR_SPECIALTY"
	RETURN TYPES.CURSOR_TYPE
AS
	Outcur Types.Cursor_Type;
BEGIN
	Open Outcur For
		SELECT D.DocCode, S.SpcName || ' ' || d.DocFName || ' ' || d.DocGName || ' ' || d.DocCName || ' ' || D.DocCode
		FROM   SPEC S, Doctor D
		WHERE  D.SpcCode = S.SpcCode
		AND    D.DocSts = -1
		ORDER BY S.SpcName;

	RETURN OUTCUR;
END NHS_CMB_DOCTOR_SPECIALTY;
/
