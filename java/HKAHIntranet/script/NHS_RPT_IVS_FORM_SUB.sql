CREATE OR REPLACE FUNCTION NHS_RPT_IVS_FORM_SUB (
  v_reqNo VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
  SELECT  iad.seq_no,
          SUBSTR(iad.code,1,2)||'-'||SUBSTR(iad.code,3,5)||'-'||SUBSTR(iad.code,-4,4) AS code,
          DECODE(pd.area,'HKAH',ig.csr_code,'TWAH',ig.tw_csr_code,NULL) AS csr_code,           
          DECODE(ig.pms_qty,1,TRIM(ig.code_name),TRIM(ig.code_name)||' ['||'1'||(SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE bs.code_no = ig.pms_unit)||'/'||to_char(ig.pms_qty)||(SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE bs.code_no = ig.stock_unit)||']' ) AS code_name,
          iad.apply_qty,
          (SELECT TRIM(bs.code_name) FROM bas_systm@tah bs WHERE bs.code_no = iad.apply_unit and bs.code_type = 'UNIT') AS apply_unit,          
          iad.remarks,
          sufe.enabled	
  FROM 	  ivs_apply_d@tah iad, ivs_goods@tah ig, ivs_apply_m@tah iam, pn_dept@tah pd, stock_update_for_ewell@tah sufe
  WHERE	  iad.code = ig.code_NO (+)
  AND     iam.apply_no = iad.apply_no (+)
  AND     iam.apply_dept = pd.dept_id (+)
  AND     iad.code = sufe.code
  AND	    iad.APPLY_NO = v_reqNo
  ORDER BY sufe.enabled DESC,iad.SEQ_NO,iad.code;
RETURN OUTCUR;
END NHS_RPT_IVS_FORM_SUB;