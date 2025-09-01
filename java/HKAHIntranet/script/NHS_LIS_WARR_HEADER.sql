create or replace
FUNCTION NHS_LIS_WARR_HEADER (
  as_applyNo IN VARCHAR2
)
  RETURN Types.cursor_type
  AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(2000);
BEGIN
  sqlstr:='SELECT
          iam.apply_no,
          TO_CHAR(TO_DATE(iam.apply_date,''YYYYMMDD''),''DD/MM/YYYY'') AS apply_date,
          iam.apply_dept,
          iam.shipped_to,          
          iam.out_dept,
          iam.allot_type,
          iam.if_close,
          iam.block_flag,
          iam.remarks,
          iam.ins_op,
          TO_CHAR(TO_DATE(iam.ins_dt,''YYYYMMDDHH24MI''),''DD/MM/YYYY HH24:MI''),
          iam.mod_op,
          TO_CHAR(TO_DATE(iam.mod_dt,''YYYYMMDDHH24MI''),''DD/MM/YYYY HH24:MI'')
          FROM ivs_apply_m@tah iam
          WHERE iam.apply_no ='''||as_applyNo||'''';
  OPEN OUTCUR FOR sqlstr;
  RETURN OUTCUR;
END NHS_LIS_WARR_HEADER;