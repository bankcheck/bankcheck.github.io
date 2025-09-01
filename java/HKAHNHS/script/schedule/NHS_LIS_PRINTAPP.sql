CREATE OR REPLACE FUNCTION NHS_LIS_PRINTAPP (
	v_temp     IN VARCHAR2,
	v_doccode  IN VARCHAR2,
	v_spccode  IN VARCHAR2
)
	RETURN types.cursor_type
as
	outcur types.cursor_type;
BEGIN
	IF v_temp = '1' THEN
		OPEN outcur FOR
			SELECT '', doccode, docfname || ' ' || docgname AS docname
			FROM   doctor
			WHERE  docpicklist = -1
			AND    docsts = -1
			ORDER  BY docname;
	ELSIF v_temp = '2' THEN
		OPEN outcur FOR
			SELECT '', doccode, docfname || ' ' || docgname AS docname
			FROM  doctor
			WHERE (docpicklist = 0 OR docpicklist IS NULL)
			AND   docsts = -1
			ORDER BY docname;
	ELSIF v_temp = '3' THEN
		OPEN outcur FOR
			SELECT '', doccode, docfname || ' ' || docgname AS docname
			FROM  doctor
			WHERE doccode = v_doccode
			AND   docsts = -1
			ORDER BY docname;
	ELSIF v_temp = '4' THEN
		OPEN outcur FOR
			SELECT '', doccode, docfname || ' ' || docgname AS docname
			FROM  doctor
			WHERE doccode != v_doccode
			AND   docsts = -1
			ORDER BY docname;
	ELSIF v_temp = '5' THEN
		OPEN outcur FOR
			SELECT '', doccode, docfname || ' ' || docgname AS docname
			FROM  doctor
			WHERE spccode = v_spccode
			AND   docsts = -1
			ORDER BY docname;
	ELSIF v_temp = '6' THEN
		OPEN outcur FOR
			SELECT '', doccode, docfname || ' ' || docgname AS docname
			FROM  doctor
			WHERE spccode != v_spccode
			AND   docsts = -1
			ORDER BY docname;
	ELSE
		OPEN outcur FOR
			SELECT '', doccode, docfname || ' ' || docgname AS docname
			FROM  doctor
			WHERE docsts = -1
			ORDER BY docname;
	END IF;

	RETURN outcur;
END NHS_LIS_PRINTAPP;
/
