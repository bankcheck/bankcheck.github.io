CREATE OR REPLACE FUNCTION "NHS_GET_SLIPHOMELEAVE"
(in_slpno slip.slpno%TYPE)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;

BEGIN
  OPEN outcur FOR
    select
    s.slpno,
    p.patno,
    p.patfname||p.patgname,
    p.patcname,
    i.bedcode,
    i.acmcode,
    to_char(r.regdate,'dd/mm/yyyy HH24:MI:SS'),
    to_char(r.regmddate,'dd/mm/yyyy HH24:MI:SS')
    from slip s,patient p,reg r,inpat i
    where s.patno=p.patno
    and s.regid=r.regid
    and i.inpid=r.inpid
    and s.slpno=in_slpno;
    return outcur;
end;
/
