create or replace
function "NHS_LIS_REGSEARCHPRINTDOB"
(
    v_stecode varchar
)
return types.cursor_type
as
    outcur types.cursor_type;
begin
open outcur for
    select
         p.stecode, p.patno, p.patfname, p.patgname, p.patcname, to_char(p.patbdate,'dd/mm/yyyy'), p.patsex
    From
         patient@IWEB p
    Where
         p.patno= v_stecode;
  return outcur;
end NHS_LIS_REGSEARCHPRINTDOB;