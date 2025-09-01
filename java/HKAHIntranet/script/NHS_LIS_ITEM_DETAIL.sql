create or replace
FUNCTION NHS_LIS_ITEM_DETAIL(
  as_purNo IN VARCHAR2
)
  RETURN Types.cursor_type
  AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(2000);
BEGIN
  sqlstr:='SELECT
          '''',
          ppd.pur_no,
          SUBSTR(ppd.code,1,2)||''-''||SUBSTR(ppd.code,3,5)||''-''||SUBSTR(ppd.code,-4,4) AS code,
          ig.code_name,          
          (SELECT pc.product_code FROM pms_contract@tah pc WHERE ig.code_no = pc.con_no AND pc.if_contract = ''Y'') AS product_code, 
          ppd.pur_qty,
          (SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE bs.code_type = ''UNIT'' AND bs.code_no = ig.pms_unit) AS pur_unit, 
          (SELECT pv.ver_sname FROM pms_ver@tah pv WHERE pv.ver_no=ppd.ver_no) AS ver_name,
          ppd.ver_no,
          ppd.remark,
          F_GET_PONO_BYITEM@tah(ppd.pur_no,ppd.code),
          F_GET_EXP_DATE@tah(ppd.pur_no,ppd.code),
          ppd.ins_op,
          ppd.ins_dt,
          ppd.mod_op,
          ppd.mod_dt        
          FROM ivs_goods@tah ig, pms_pur_d@tah ppd
          WHERE ppd.code = ig.code_no(+)
          AND ppd.pur_no ='''||as_purNo||'''';
  OPEN OUTCUR FOR sqlstr;
  RETURN OUTCUR;
END NHS_LIS_ITEM_DETAIL;