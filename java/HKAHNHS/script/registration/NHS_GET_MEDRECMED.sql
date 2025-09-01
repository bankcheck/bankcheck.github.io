CREATE OR REPLACE FUNCTION "NHS_GET_MEDRECMED" (
V_mrldesc Varchar2
)

  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
      SELECT
        l.mrmid
      FROM MEDRECMED l
      WHERE l.mrmdesc ='PAPER'
      ORDER BY l.mrmid;
   RETURN OUTCUR;
END NHS_GET_MEDRECMED;
/
