CREATE OR REPLACE FUNCTION "NHS_GET_MEDRECLOC" (
V_mrldesc Varchar2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
      SELECT
        l.mrlid
      FROM MEDRECLOC l
      WHERE l.mrldesc ='REGISTRATION'
      ORDER BY l.mrlid;
   RETURN OUTCUR;
END NHS_GET_MEDRECLOC;
/
