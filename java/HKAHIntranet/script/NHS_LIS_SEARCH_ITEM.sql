create or replace
FUNCTION NHS_LIS_SEARCH_ITEM(
  as_itemNo IN VARCHAR2,
  as_userDept IN VARCHAR2,
  as_isFav IN VARCHAR2
)
  RETURN Types.cursor_type
--  RETURN VARCHAR2
  AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(5000);
  wherestr VARCHAR2(3000);
  ordstr VARCHAR2(100);  
BEGIN          
  IF as_isFav = '1' THEN
    sqlstr:='SELECT DISTINCT
            ig.code_no,   
            TRIM(pc.product_code) AS product_code,   
            TRIM(ig.code_name) AS item_desc,
            pc.con_price,
            (SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE ig.pms_unit=bs.code_no AND bs.code_type = ''UNIT'') purch_unit,    
            1||(SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE ig.pms_unit=bs.code_no AND bs.code_type = ''UNIT'')||''=''||
            ig.pms_qty||(SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE ig.stock_unit=bs.code_no AND bs.code_type = ''UNIT'') AS packing_desc,  
            (SELECT pv.ver_fname FROM pms_ver@tah pv WHERE pc.ver_no = pv.ver_no) AS supplier_name,
            TRIM(ig.brand) AS brand,
            ig.csr_code,
            ig.old_code
            FROM ivs_goods@tah ig,   
            pms_contract@tah pc';
    wherestr:=' WHERE ig.code_no = pc.con_no (+)'||
            ' AND pc.if_contract = ''Y'''||
            ' AND ig.code_no IN (SELECT code FROM pms_pur_m@tah ppm, pms_pur_d@tah ppd WHERE ppm.pur_no = ppd.pur_no(+) AND ppm.pur_dept ='''||as_userDept||''' AND TO_DATE(ppm.pur_date,''YYYYMMDD'') >= ADD_MONTHS(SYSDATE,-6))';
  ELSE
    sqlstr:='SELECT DISTINCT
            ig.code_no,   
            TRIM(pc.product_code) AS product_code,   
            TRIM(ig.code_name) AS item_desc,
            pc.con_price,
            (SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE ig.pms_unit=bs.code_no AND bs.code_type = ''UNIT'') purch_unit,    
            1||(SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE ig.pms_unit=bs.code_no AND bs.code_type = ''UNIT'')||''=''||
            ig.pms_qty||(SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE ig.stock_unit=bs.code_no AND bs.code_type = ''UNIT'') AS packing_desc,  
            (SELECT pv.ver_fname FROM pms_ver@tah pv WHERE pc.ver_no = pv.ver_no) AS supplier_name,
            TRIM(ig.brand) AS brand,
            ig.csr_code,
            ig.old_code
            FROM ivs_goods@tah ig,   
            pms_contract@tah pc';
    wherestr:=' WHERE ig.code_no = pc.con_no (+)'||
            ' AND pc.if_contract = ''Y'''||          
            ' AND EXISTS (SELECT 1 FROM ivs_stock@tah ist WHERE ist.code_no = ig.code_no AND self_order = ''1'' AND ist.dept_no = '''||as_userDept||''''||
            ') AND (ig.code_no LIKE '''||as_itemNo||'%'' OR
            UPPER(pc.product_code) LIKE UPPER(''%'||as_itemNo||'%'') OR
            UPPER(ig.code_name) LIKE UPPER(''%'||as_itemNo||'%'') OR
            ig.csr_code = '''||as_itemNo||''' OR
            ig.old_code = '''||as_itemNo||''')';  
  END IF;
  ordstr:='ORDER BY ig.code_no';
          
  OPEN OUTCUR FOR sqlstr||wherestr||ordstr;
  RETURN OUTCUR;
--  RETURN sqlstr||wherestr||ordstr;
END NHS_LIS_SEARCH_ITEM;