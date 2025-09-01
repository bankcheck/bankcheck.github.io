create or replace function "NHS_LIS_REGSEARCHPRINTDOB"(
	v_patno varchar
)
	return types.cursor_type
as
	outcur types.cursor_type;
begin
	open outcur for
	select decode(UPPER(get_real_stecode()),'HKAH','HKAH - SR',UPPER(get_real_stecode())), p.patno, p.patfname||' '||p.patgname, p.patcname, to_char(p.patbdate,'dd/mm/yyyy'), p.patsex
	From   patient p
	Where  p.patno= v_patno;

	RETURN outcur;
end NHS_LIS_REGSEARCHPRINTDOB;
/
