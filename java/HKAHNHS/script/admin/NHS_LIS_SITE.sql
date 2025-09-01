CREATE OR REPLACE FUNCTION "NHS_LIS_SITE"
(V_STECODE SITE.STECODE%TYPE,
v_STENAME SITE.STENAME%TYPE)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
      SELECT
        STECODE, STENAME, STELOGO
      FROM SITE
      WHERE ( STECODE LIKE '%' || v_stecode || '%')
      AND ( STENAME like '%' || v_stename || '%')
      AND ROWNUM < 100
      ORDER BY STECODE;
   RETURN OUTCUR;
END NHS_LIS_SITE;
/


