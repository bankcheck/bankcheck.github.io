CREATE OR REPLACE FUNCTION NHS_GET_DOCCERT(
  v_DOCCODE IN doccert.doccode%TYPE
)
RETURN Types.cursor_type
  AS
    outcur types.cursor_type;
 BEGIN
   open outcur for
  select *from doccert where doccode= v_doccode;
      RETURN outcur;
END NHS_GET_DOCCERT;
/
