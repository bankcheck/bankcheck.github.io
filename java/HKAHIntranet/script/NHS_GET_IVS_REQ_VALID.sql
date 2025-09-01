create or replace
FUNCTION NHS_GET_IVS_REQ_VALID (
V_REQNO IN VARCHAR2,
V_USERID IN VARCHAR2
) RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
  VALIDCODE NUMBER := 0;
  DEPTNO VARCHAR(5);
  SHIPPED_TO VARCHAR(5);
  o_errcode NUMBER := 0;
  o_errmsg VARCHAR2(1000);
  NOT_IN_DEPT_ERR EXCEPTION;
  INVALID_REQ_ERR EXCEPTION;
	CURSOR c_getRelDept IS  
  SELECT TRIM(bu.station) 
  FROM bas_user@tah bu 
  WHERE user_id = (
    SELECT sub.user_id 
    FROM sys_user_basic@tah sub 
    WHERE TRIM(sub.user_id) = V_USERID OR 
      TRIM(sub.user_alias) = V_USERID)
  UNION
  SELECT TRIM(pnt.unit) 
  FROM pms_notice_to@tah pnt 
  WHERE pnt.active = 1  
  AND TRIM(pnt.staff_no) IN (
    SELECT TRIM(sub.user_id) 
    FROM sys_user_basic@tah sub 
    WHERE TRIM(sub.user_id) = V_USERID OR 
      TRIM(sub.user_alias) = V_USERID) 
    AND pnt.type = 'RA';   
BEGIN
  BEGIN
    SELECT 1, shipped_to
    INTO VALIDCODE, SHIPPED_TO
    FROM ivs_apply_m@tah
    WHERE apply_no = V_REQNO;
  EXCEPTION
  WHEN OTHERS THEN  
    o_errcode := -1;
    o_errmsg := '[NO SUCH REQ NO]';
    RAISE INVALID_REQ_ERR;
  END;  
  
  IF VALIDCODE = 1 THEN
    VALIDCODE := 0;

    OPEN c_getRelDept;
    LOOP
    FETCH c_getRelDept INTO DEPTNO;
    EXIT WHEN c_getRelDept%NOTFOUND;
      IF TRIM(SHIPPED_TO) = TRIM(DEPTNO) THEN
        VALIDCODE := 1;    
      END IF;
    END LOOP;
    CLOSE c_getRelDept;  
  END IF;
  
  IF VALIDCODE = 1 THEN
    o_errmsg := '[VALID REQ]';
  ELSE
    o_errcode := -2;  
    o_errmsg := '['||V_REQNO||' IS NOT BELONG TO YOU DEPARTMENT]';
		RAISE NOT_IN_DEPT_ERR;	  
  END IF;
 
  OPEN OUTCUR FOR
    SELECT VALIDCODE,o_errmsg FROM DUAL;
  RETURN OUTCUR;
EXCEPTION
WHEN INVALID_REQ_ERR THEN
  OPEN OUTCUR FOR
    SELECT o_errcode,o_errmsg FROM DUAL;
  RETURN OUTCUR;
WHEN NOT_IN_DEPT_ERR THEN
  OPEN OUTCUR FOR
    SELECT o_errcode,o_errmsg FROM DUAL;
  RETURN OUTCUR;  
WHEN OTHERS THEN
	o_errcode := -3;
	o_errmsg := ';An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM;	
  OPEN OUTCUR FOR
    SELECT o_errcode,o_errmsg FROM DUAL;
  RETURN OUTCUR;
--  dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);    
END NHS_GET_IVS_REQ_VALID;