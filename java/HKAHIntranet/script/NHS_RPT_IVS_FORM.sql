create or replace
FUNCTION NHS_RPT_IVS_FORM (
  v_reqNo VARCHAR2,
  v_printBy VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
  SELECT  iam.apply_no AS req_no,   
          TRIM(pn.dept_ename) AS billed_to,    
          iam.ins_dt,   
          iam.apply_date AS req_date,   
          (SELECT TRIM(pd.dept_ename) FROM pn_dept@tah pd WHERE pd.dept_id = iam.out_dept) AS out_dept,    
          iam.ins_op,    
          iam.allot_type,
          iam.remarks,
          pn.area,
          (SELECT TRIM(pd.dept_ename) FROM pn_dept@tah pd WHERE pd.dept_id = iam.shipped_to) AS shipped_to,
          (SELECT TRIM(sub.user_name) FROM sys_user_basic@tah sub WHERE TRIM(sub.user_id) = TRIM(v_printBy)) AS print_by,
          (SELECT COUNT(im.apply_no)
          FROM ivs_apply_m@tah im
          WHERE im.apply_date = iam.apply_date
          AND im.apply_dept = iam.apply_dept
          AND im.apply_no <= iam.apply_no
          AND im.allot_type = '1') AS no_of_inv,
          (SELECT COUNT(im.apply_no)
          FROM ivs_apply_m@tah im
          WHERE im.apply_date = iam.apply_date
          AND im.apply_dept = iam.apply_dept
          AND im.allot_type = '1') AS tno_of_inv,
          '<BT>MSCDN</BT><RNO>'||iam.apply_no||'</RNO>' AS req_no_2d
  FROM	  ivs_apply_m@tah iam, pn_dept@tah pn
  WHERE   iam.apply_dept = pn.dept_id(+)
  AND     iam.apply_no = v_reqNo;
RETURN OUTCUR;
END NHS_RPT_IVS_FORM;