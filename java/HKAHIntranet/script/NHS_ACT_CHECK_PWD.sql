create or replace
FUNCTION NHS_ACT_CHECK_PWD (
ac_actType VARCHAR2,
as_pwd VARCHAR2,
as_approvalBy VARCHAR2,
as_purDept VARCHAR2,
o_errmsg	OUT VARCHAR2
)
RETURN VARCHAR2 AS
o_errcode NUMBER(1);
ls_returnFlag VARCHAR2(2);
ls_approver VARCHAR2(10);
li_valid NUMBER;
ls_ePwd VARCHAR2(10);
ls_lEPwd VARCHAR2(10);
ls_uEPwd VARCHAR2(10);
INVALID_PWD_ERR EXCEPTION;
BEGIN
  ls_ePwd := FUNC_ENCRY_PWD@tah(as_pwd);
  ls_uEPwd := FUNC_ENCRY_PWD@tah(UPPER(as_pwd));
  ls_lEPwd := FUNC_ENCRY_PWD@tah(LOWER(as_pwd));
  dbms_output.put_line('[ls_ePwd]'||ls_ePwd||';[ls_uEPwd]:'||ls_uEPwd||';[ls_lEPwd]'||ls_lEPwd);
     
  BEGIN
    SELECT staff_no
    INTO ls_approver
    FROM pms_notice_to@tah 
    WHERE active = 1 
    AND area = (SELECT area FROM pn_dept@tah WHERE Trim(dept_id) = Trim(as_purDept))
    AND type ='RA' 
    AND Trim(unit) = Trim(as_purDept)
    AND staff_no = as_approvalBy;  
  EXCEPTION
  WHEN OTHERS THEN   
    RAISE INVALID_PWD_ERR;
  END;

  BEGIN
    SELECT 1
    INTO li_valid
    FROM sys_user_basic@tah
    WHERE user_id = (SELECT user_id FROM sys_user_basic@tah WHERE Trim(user_alias) = Trim(as_approvalBy)) 
    AND (password = as_pwd OR
    password = ls_ePwd OR  
    password = ls_lEPwd OR
    password = ls_uEPwd );
  EXCEPTION
  WHEN OTHERS THEN
    li_valid := 0;
  END;    

  IF li_valid = 1 THEN
    o_errcode := 1;
    o_errmsg:='Password Correct';  
    RETURN o_errcode;
  ELSE
    o_errcode := -1;  
    o_errmsg:='Incorrect password';    
    RETURN o_errcode;  
  END IF;
EXCEPTION
WHEN INVALID_PWD_ERR THEN
  o_errcode := -1; 
  o_errmsg := 'No access right for approval';
  RETURN o_errcode;
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line(SQLCODE||' -ERROR- '||SQLERRM);
  o_errcode := -1;   
  o_errmsg := '[RETURN MSG]:'||SQLERRM;
  RETURN o_errcode;
END;