create or replace
FUNCTION "NHS_LIS_DEPATSUBCHRG"
(
  V_DEPT_CODE VARCHAR2,
  V_DSC_TYPE  VARCHAR2,
  V_SLPNO VARCHAR2,
  V_OTLID VARCHAR2  
)
RETURN TYPES.CURSOR_TYPE
--RETURN VARCHAR2
AS
  OUTCUR types.CURSOR_TYPE;
  SQLSTR VARCHAR2(2000);
  V_SQL VARCHAR2(2000);
  V_CODE OT_PROC.ITMCODE%TYPE;
  V_stnnamt NUMBER;
begin
      SELECT DSC_SQL 
      INTO V_SQL
      FROM DEPT_SUB_CHRG
      WHERE
      DEPT_CODE = '' || V_DEPT_CODE || ''
      AND DSC_TYPE = '' || V_DSC_TYPE || ''
      ORDER BY DSC_ID;

      IF V_DSC_TYPE='R' THEN
        BEGIN
          V_SQL := UPPER(V_SQL);
          SQLSTR := REPLACE(V_SQL,'[SLPNO]',''''||V_SLPNO||'''');
          SQLSTR := REPLACE(SQLSTR,'[OTLID]',''''||V_OTLID||'''');       
          EXECUTE IMMEDIATE SQLSTR INTO V_CODE;
        EXCEPTION
        WHEN OTHERS THEN
          V_CODE := '';
        END;
        SQLSTR := 'SELECT '''||V_CODE||''' FROM DUAL';
      ELSIF V_DSC_TYPE = 'S' THEN
        BEGIN
          V_SQL := UPPER(V_SQL);
          SQLSTR := REPLACE(V_SQL,'[SLPNO]',''''||V_SLPNO||'''');
          SQLSTR := REPLACE(SQLSTR,'[OTLID]',''''||V_OTLID||'''');       
          EXECUTE IMMEDIATE SQLSTR INTO V_CODE,V_STNNAMT;
          SQLSTR := 'SELECT '''||V_CODE||''','''||V_STNNAMT||''' FROM DUAL';
        EXCEPTION
        WHEN OTHERS THEN
          V_CODE := '';
          V_STNNAMT := 0;          
        END;      
        SQLSTR := 'SELECT '''||V_CODE||''','||V_STNNAMT||' FROM DUAL';
      END IF;
    OPEN outcur FOR SQLSTR;
    RETURN OUTCUR;
end NHS_LIS_DEPATSUBCHRG;
/