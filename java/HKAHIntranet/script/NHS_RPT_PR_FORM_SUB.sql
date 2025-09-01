create or replace
FUNCTION NHS_RPT_PR_FORM_SUB (
  v_PrNo VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
  SELECT
        SUBSTR(p.code,1,2)||'-'||SUBSTR(p.code,3,5)||'-'||SUBSTR(p.code,-4,4) AS code,
        DECODE(p.supp_prod_code,NULL,'','[')||p.supp_prod_code||DECODE(p.supp_prod_code,NULL,'','] ')||
        p.code_name||
        DECODE(p.remarks,NULL,'','-'||TRIM(p.remarks))||
        DECODE(p.pms_qty,1,'',' [')||DECODE(p.pms_qty,1,'','1')||DECODE(p.pms_qty,1,'',p.pms_unit)||DECODE(p.pms_qty,1,'','/')||DECODE(p.pms_qty,1,'',p.pms_qty)||DECODE(p.pms_qty,1,'',p.stock_unit)||DECODE(p.pms_qty,1,'',']') AS item_desc,
        p.pur_qty AS qty,
        p.add_qty AS gift_qty,
        p.pms_unit AS unit,
        null AS unit_price,
        null AS amount
  FROM
  (
  SELECT ppd.rowid as row_id,ppd.pur_no, ppd.code, Trim(ig.code_name) AS code_name, ppd.pur_qty, ppd.add_qty, ig.pms_qty, ig.remarks,
  (SELECT Trim(bs.code_name) FROM bas_systm@tah bs WHERE bs.code_type = 'UNIT' AND Trim(bs.code_no) = Trim(ig.pms_unit)) AS pms_unit, 
  (SELECT Trim(bs.code_name) FROM bas_systm@tah bs WHERE bs.code_type = 'UNIT' AND Trim(bs.code_no) = Trim(ig.stock_unit)) AS stock_unit, 
  (SELECT Trim(MAX(pc.product_code)) FROM pms_contract@tah pc WHERE pc.con_no = ppd.code AND pc.ver_no = ppd.ver_no) AS supp_prod_code
  FROM pms_pur_d@tah ppd, ivs_goods@tah ig
  WHERE	ppd.code = ig.code_no (+)
  ) p
  WHERE p.pur_no= v_PrNo
  ORDER BY p.row_id ;
RETURN OUTCUR;
END NHS_RPT_PR_FORM_SUB;