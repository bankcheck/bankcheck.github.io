create or replace
FUNCTION NHS_LIS_GET_IVS_ITEM(
  as_itemNo IN VARCHAR2
  ,as_userDept IN VARCHAR2  
)
  RETURN Types.cursor_type
--RETURN VARCHAR2
  AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(2000);
BEGIN
  sqlstr:='SELECT
          ig.code_no,
          DECODE((SELECT pd.area FROM pn_dept@tah pd WHERE pd.dept_id = '''||as_userDept||'''),''HKAH'',ig.csr_code,''TWAH'',ig.tw_oe_code) AS csr_code,'
          ||'TRIM(ig.code_name),
          (SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE TRIM(bs.code_no) = TRIM(DECODE(ig.unit_flag,''1'',ig.stock_unit,''0'',ig.pack_unit)) AND bs.code_type = ''UNIT'') AS unit,          
          DECODE(ig.unit_flag,''1'',NULL,''0'','' 1''||((SELECT TRIM(pu.code_name) FROM bas_systm@tah pu WHERE pu.code_no = ig.pack_unit AND pu.code_type = ''UNIT'')||''/''||TO_CHAR(ig.pack_qty)||(SELECT trim(su.code_name) FROM bas_systm@tah su WHERE su.code_no = ig.stock_unit AND su.code_type = ''UNIT''))) AS pack_desc,'||
          ' TRIM(DECODE(ig.unit_flag,''1'',ig.stock_unit,''0'',ig.pack_unit)) AS apply_unit'||
          ' FROM ivs_goods@tah ig'||
          ' WHERE ig.code_no ='''||as_itemNo||''' OR ig.csr_code = '''||as_itemNo||''' OR ig.tw_oe_code = '''||as_itemNo||'''';
          
  OPEN OUTCUR FOR sqlstr;
  RETURN OUTCUR;
--RETURN sqlstr;
END NHS_LIS_GET_IVS_ITEM;