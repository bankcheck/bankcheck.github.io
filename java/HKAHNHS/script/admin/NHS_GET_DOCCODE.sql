CREATE OR REPLACE FUNCTION "NHS_GET_DOCCODE"
(in_doccode slip.doccode%TYPE)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
  v_doccode slip.doccode%TYPE;
BEGIN
  OPEN outcur FOR
    select doccode into v_doccode from slip where doccode = in_doccode;
    return outcur;
end;
/


