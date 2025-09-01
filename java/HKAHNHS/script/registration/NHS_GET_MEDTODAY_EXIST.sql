CREATE OR REPLACE FUNCTION "NHS_GET_MEDTODAY_EXIST"
(
V_PATNO VARCHAR2)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
      SELECT
        count(*)
      FROM MEDRECDTL d,medrechdr h
      WHERE d.mrdid=h.mrdid
      and h.patno=v_patno
      and to_char(d.mrdddate,'dd/mm/yyyy')=to_char(sysdate,'dd/mm/yyyy')
      ORDER BY d.mrdddate;
   RETURN OUTCUR;
END NHS_GET_MEDTODAY_EXIST;
/
