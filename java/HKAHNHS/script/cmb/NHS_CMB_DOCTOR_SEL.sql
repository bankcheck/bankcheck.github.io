create or replace FUNCTION "NHS_CMB_DOCTOR_SEL"
(
	V_DOCCODE IN VARCHAR2
)
  RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
  STRSQL VARCHAR2(2000);
BEGIN
  STRSQL := 'select distinct d.doccode, d.docfname || '' '' || d.docgname||DECODE(d.company,NULL,NULL,'' - ''||d.company) as docname
	from docitmpct dip, doctor d
	where dip.doccode = d.doccode';

  if V_DOCCODE is not null then
	  strsql := strsql || ' AND d.doccode = ''' || V_DOCCODE || '''';
  END IF;

  STRSQL := STRSQL || ' ORDER BY 2';

  open outcur for
    STRSQL;
   RETURN OUTCUR;
END NHS_CMB_DOCTOR_SEL;
/