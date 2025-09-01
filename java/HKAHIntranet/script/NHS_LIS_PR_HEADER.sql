create or replace
FUNCTION NHS_LIS_PR_HEADER(
  as_purNo IN VARCHAR2
)
  RETURN Types.cursor_type
  AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(2000);
BEGIN
  sqlstr:='SELECT
          ppm.pur_no,
          TO_CHAR(TO_DATE(ppm.pur_date,''YYYYMMDD''),''DD/MM/YYYY''),
          ppm.pur_dept,
          ppm.shipped_to,          
          ppm.pur_op,          
          ppm.remark,
          DECODE(ppm.cancel_flag,''Y'',''CANCELLED'',''N'',DECODE(ppm.approve_flag,1,''APPROVED'',0,''WAITING APPROVAL''))
          FROM pms_pur_m@tah ppm
          WHERE ppm.pur_no ='''||as_purNo||'''';
  OPEN OUTCUR FOR sqlstr;
  RETURN OUTCUR;
END NHS_LIS_PR_HEADER;