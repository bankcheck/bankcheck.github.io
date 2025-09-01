create or replace
FUNCTION NHS_LIS_GET_ITEM_DETAIL(
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
          pc.product_code, 
          ig.code_name, 
          (SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE bs.code_type = ''UNIT'' AND bs.code_no = ig.pms_unit) AS pur_unit, 
          (SELECT pv.ver_sname FROM pms_ver@tah pv WHERE pv.ver_no=pc.ver_no) AS ver_name,
          pc.ver_no
          FROM ivs_goods@tah ig, pms_contract@tah pc
          WHERE ig.code_no = pc.con_no(+)
          AND pc.if_contract = ''Y'''||
          ' AND EXISTS (SELECT 1 FROM ivs_stock@tah ist WHERE ist.code_no = ig.code_no AND self_order = ''1'' AND ist.dept_no = '''||as_userDept||''')'||
--          ' AND EXISTS (SELECT 1 FROM ivs_stock@tah ist WHERE ist.code_no = ig.code_no AND self_order = ''1'' AND ist.dept_no = ''720'')'||
          ' AND ig.code_no ='''||as_itemNo||'''';
          
  OPEN OUTCUR FOR sqlstr;
  RETURN OUTCUR;
--RETURN sqlstr;
END NHS_LIS_GET_ITEM_DETAIL;