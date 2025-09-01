CREATE OR REPLACE FUNCTION "NHS_RPT_REGSEARCHPRINTDOBWTHNO"
(
    v_patno Varchar,
    V_Nooflbl Varchar2
)
return types.cursor_type
as
    outcur types.cursor_type;
begin
open outcur for
    Select
         decode(UPPER(GET_REAL_STECODE()),'HKAH','HKAH - SR',UPPER(GET_REAL_STECODE())), p.patno, p.patfname||' '||p.patgname, p.patcname, to_char(p.patbdate,'dd/mm/yyyy'), p.patsex
    From
         Patient P
    Left Join
    (Select 1 From Dual Connect By Level <= V_Nooflbl) On 1=1
    Where
         p.patno= v_patno;
  return outcur;
end NHS_RPT_REGSEARCHPRINTDOBWTHNO;
/
