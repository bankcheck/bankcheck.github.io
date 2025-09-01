CREATE OR REPLACE FUNCTION NHS_LIS_SEARCHALERT (
	v_patnum     IN VARCHAR2,
	v_alertgroup IN VARCHAR2
)
	RETURN types.cursor_type
AS
	outcur types.cursor_type;
begin
	IF v_alertgroup IS NOT NULL THEN
		OPEN outcur for
			SELECT DISTINCT e.Email
			FROM   alert a, AlertEmail e
			WHERE  a.altid IN (
				SELECT altid
				FROM   pataltlink
				WHERE  Patno = v_patnum
				AND    usrid_c IS NULL)
			AND    a.altid IN ( SELECT altid FROM AlertGroup WHERE atgid = v_alertgroup )
			AND    e.altid = a.altid
			AND    a.ALTEMAIL = -1;
	ELSE
		OPEN outcur for
			SELECT DISTINCT e.Email
			FROM   alert a, AlertEmail e
			WHERE  a.altid IN (
				SELECT altid
				FROM   pataltlink
				WHERE  Patno = v_patnum
				AND    usrid_c IS NULL)
			AND    a.altid NOT IN ( SELECT altid FROM AlertGroup )
			AND    e.altid = a.altid
			AND    a.ALTEMAIL = -1;
	END IF;

	RETURN outcur;
end NHS_LIS_SEARCHALERT;
/
