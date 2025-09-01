CREATE OR REPLACE FUNCTION "NHS_LIS_DEPATSUBCHRG"
(
  V_DEPT_CODE VARCHAR2,
  V_DSC_TYPE  VARCHAR2
)
 RETURN tYPES.CURSOR_TYPE
AS
  OUTCUR types.CURSOR_TYPE;
  sqlstr VARCHAR2(2000);

begin
      OPEN OUTCUR FOR
      SELECT
                  DSC_ID,
                  DSC_TYPE,
                  DSC_DESC,
                  DSC_SQL,
                  STECODE
                  FROM DEPT_SUB_CHRG
		          WHERE
                  DEPT_CODE = '' || V_DEPT_CODE || ''
                  AND DSC_TYPE = '' || V_DSC_TYPE || ''
                  ORDER BY DSC_ID;
    RETURN OUTCUR;
end NHS_LIS_DEPATSUBCHRG;
/


