CREATE OR REPLACE FUNCTION "NHS_GET_SLIPISINPAT"
(in_slpno slip.slpno%TYPE)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;

BEGIN
  OPEN outcur FOR
    select
    r.regtype
    from slip s,reg r
    where s.slpno=r.slpno
    and s.slpno=in_slpno;
    return outcur;
end;
/
