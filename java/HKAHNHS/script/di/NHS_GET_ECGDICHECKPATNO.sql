create or replace FUNCTION NHS_GET_ECGDICHECKPATNO (
	v_DINO IN VARCHAR2
)
	RETURN TYPES.cursor_type
AS
	OUTCUR TYPES.cursor_type;
BEGIN
	OPEN OUTCUR FOR
		select FM_patno,to_patno 
    from Patmercht 
    where PMCId = (select Max(PMCId) from patmerdtl where Tabref= v_DINO);
	RETURN OUTCUR;
END NHS_GET_ECGDICHECKPATNO;