CREATE OR REPLACE FUNCTION NHS_GET_CTNTRACE
(v_ctnid cardtx.ctntrace%TYPE)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
  v_doccode slip.doccode%TYPE;
BEGIN
  OPEN outcur FOR
   select CtnTrace from Cardtx where ctnid=v_ctnid;
    return outcur;
END NHS_GET_CTNTRACE;
/
