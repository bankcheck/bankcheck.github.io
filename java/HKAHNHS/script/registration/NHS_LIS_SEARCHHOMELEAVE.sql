create or replace function "NHS_LIS_SEARCHHOMELEAVE"
(
    v_slpNo varchar2
)
return types.cursor_type
as
    outcur types.cursor_type;
begin 
      open outcur for
      select 
       i.INPID, 
       t.PATNO, 
       t.PATFNAME || ' ' || t.PATGNAME as PatName, 
       t.PATCNAME,
       r.REGDATE, 
       i.INPDDATE, 
       i.BedCode, 
       i.AcmCode
from 
     slip s, 
     reg r, 
     inpat i, 
     patient t
where 
      s.PATNO = t.PATNO and s.SLPNO = v_slpNo
      and t.PATNO = s.PATNO
      and s.REGID = r.REGID
      and r.INPID = i.INPID;
    return outcur;
end NHS_LIS_SEARCHHOMELEAVE;
/
