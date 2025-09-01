create or replace
FUNCTION NHS_ACT_PR_APPROVAL (
as_action IN VARCHAR2,
as_reqNo IN VARCHAR2,
as_approvalBy IN VARCHAR2,
as_purDept IN VARCHAR2,
as_shippedTo IN VARCHAR2, 
o_errmsg OUT VARCHAR2
)
RETURN NUMBER AS
ls_sysDate VARCHAR2(12);
o_errcode NUMBER(1);
BEGIN  
  ls_sysDate := TO_CHAR(SYSDATE,'yyyymmddhh24mi');

  o_errmsg := 'APPROVE FLAG UPDATE ERROR!'; 
  UPDATE pms_pur_m@tah
  SET approve_flag = 1,
  approve_by = as_approvalBy,
  approve_date = ls_sysDate
  WHERE pur_no = as_reqNo;
  				
  IF as_purDept <> as_shippedTo THEN
    o_errmsg := 'SEND BILL NOTICE FAIL';
    INSERT INTO PMS_BILLTO_NOTICE@tah (
    PUR_NO,
    PUR_DEPT,
    SHIPPED_TO,
    SEND_FLAG,
    INSERT_DATE,
    INSERT_BY,
    SEND_DATE) VALUES (
    as_reqNo,
    as_purDept,
    as_shippedTo,
    0,
    SYSDATE,
    as_approvalBy,
    NULL);
  END IF;

  o_errcode := 1;
  o_errmsg := 'OK';
  RETURN o_errcode;
EXCEPTION  
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line(SQLCODE||' -ERROR- '||SQLERRM);
  o_errcode := -1;
  IF TRIM(o_errmsg) IS NOT NULL THEN
    o_errmsg := o_errmsg||'--[RETURN MSG]:'||SQLERRM;
  ELSE
    o_errmsg := '[RETURN MSG]:'||SQLERRM;
  END IF;
  RETURN o_errcode;
END;