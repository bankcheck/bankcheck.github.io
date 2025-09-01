CREATE OR REPLACE FUNCTION "NHS_GET_SYSPARAM" (
  v_parCde IN VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur Types.cursor_type;
BEGIN
  OPEN outcur FOR
    SELECT
      PARCDE,PARAM1,PARAM2,PARDESC
    FROM SYSPARAM
    WHERE  PARCDE = v_parCde;
  RETURN outcur;
end NHS_GET_SYSPARAM;
/


