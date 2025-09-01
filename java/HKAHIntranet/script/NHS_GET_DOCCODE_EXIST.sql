create or replace
FUNCTION "NHS_GET_DOCCODE_EXIST"
(in_doccode varchar2)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
    select doccode, docfname || ' ' ||docgname
    from   doctor@IWEB
    where  doccode = in_doccode and rownum=1;
    return outcur;
end;