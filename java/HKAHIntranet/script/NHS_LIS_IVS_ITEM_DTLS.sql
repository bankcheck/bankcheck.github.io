create or replace
FUNCTION NHS_LIS_IVS_ITEM_DTLS(
  as_applyNo IN VARCHAR2
)
  RETURN Types.cursor_type
  AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(2000);
BEGIN
  sqlstr:='SELECT
          DECODE(SIGN(INSTR(iad.remarks, ''[REQUEST LABEL]'')),1,''true'',''false'') AS wlb,
          iad.seq_no,
          iad.apply_no,
          SUBSTR(iad.code,1,2)||''-''||SUBSTR(iad.code,3,5)||''-''||SUBSTR(iad.code,-4,4) AS code,
          DECODE((SELECT TRIM(pd.area) FROM pn_dept@tah pd WHERE pd.dept_id = iam.apply_dept),''HKAH'',ig.csr_code,''TWAH'',ig.tw_csr_code,null) AS csr_code,
          TRIM(ig.code_name),           
          iad.apply_qty,   
          iad.real_qty,   
          (SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE bs.code_no = iad.apply_unit AND bs.code_type = ''UNIT'') AS unit,
          DECODE(ig.unit_flag,''1'',NULL,''0'','' 1''||((SELECT TRIM(pu.code_name) FROM bas_systm@tah pu WHERE pu.code_no = ig.pack_unit AND pu.code_type = ''UNIT'')||''/''||TO_CHAR(ig.pack_qty)||(SELECT trim(su.code_name) FROM bas_systm@tah su WHERE su.code_no = ig.stock_unit AND su.code_type = ''UNIT''))) AS pack_desc,
          iad.apply_unit,
          iad.remarks,          
          iad.if_close,
          NULL AS stock_bal,
          iad.ins_op,   
          TO_CHAR(TO_DATE(iad.ins_dt,''YYYYMMDDHH24MI''),''DD/MM/YYYY HH24:MI''),
          iad.mod_op,          
          TO_CHAR(TO_DATE(iad.mod_dt,''YYYYMMDDHH24MI''),''DD/MM/YYYY HH24:MI'')
  FROM    ivs_apply_d@tah iad, ivs_apply_m@tah iam, ivs_goods@tah ig
  WHERE   iam.apply_no = iad.apply_no(+) 
  AND     iad.code = ig.code_no(+)
  AND     iam.apply_no ='''||as_applyNo||'''';
  OPEN OUTCUR FOR sqlstr;
  RETURN OUTCUR;
END NHS_LIS_IVS_ITEM_DTLS;