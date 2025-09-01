CREATE OR REPLACE FUNCTION "NHS_GET_PATIENTBYNO"(
	v_PATNO IN VARCHAR2
)
	RETURN TYPES.cursor_type
AS
	OUTCUR TYPES.cursor_type;
BEGIN
	OPEN OUTCUR FOR
		select
			p.Patfname,
			p.patgname,
			p.patidno,
			to_char(p.patbdate,'dd/mm/yyyy'),
			pathtel,
			p.patSex,
			p.patcname,
			p.patpager,
			e.patmiscrmk
		from Patient p
		left join Patient_Extra e on p.patno = e.patno
		where p.patno = v_PATNO;
	RETURN OUTCUR;
END NHS_GET_PATIENTBYNO;
/
