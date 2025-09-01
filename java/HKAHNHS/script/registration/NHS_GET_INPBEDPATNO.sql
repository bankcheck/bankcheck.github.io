create or replace
FUNCTION           "NHS_GET_INPBEDPATNO" (
	V_BEDCODE    IN VARCHAR2,
  V_PATNO    IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	REG_STS_NORMAL VARCHAR2(1) := 'N';
  SQLSTR VARCHAR2(10000);
BEGIN
	Sqlstr := 'SELECT 
              REG.PATNO,
              INP.BEDCODE,
              ROM.WRDCODE
            FROM Reg reg,
              Inpat inp,
              Patient pat,
              Bed bed,
              Room rom
            WHERE reg.patno   = pat.patno
            AND inp.bedcode   = bed.bedcode(+)
            AND bed.romcode   = rom.romcode(+)
            AND REG.INPID     = INP.INPID';
    if V_PATNO is not null then
      SQLSTR := SQLSTR || ' AND reg.patno = ''' || V_PATNO || '''';
    end if;
    IF V_BEDCODE IS NOT NULL THEN
      SQLSTR := SQLSTR || ' AND bed.bedcode = ''' || V_BEDCODE || '''';
    end if;
      SQLSTR := SQLSTR || ' AND REG.REGSTS    = ''N''
                AND reg.regtype   = ''I''
                AND INP.INPDDATE IS NULL';

   OPEN outcur FOR sqlstr;
    RETURN OUTCUR;
END NHS_GET_INPBEDPATNO;
/
