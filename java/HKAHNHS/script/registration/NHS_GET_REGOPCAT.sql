CREATE OR REPLACE FUNCTION "NHS_GET_REGOPCAT"
(in_slpno varchar2)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN

  OPEN outcur FOR
    select regopcat from reg where regid=
    (select regid from reg r where r.slpno=in_slpno);
    return outcur;
end;
/
