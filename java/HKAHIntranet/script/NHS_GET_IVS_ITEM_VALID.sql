create or replace
FUNCTION NHS_GET_IVS_ITEM_VALID (
V_CODE IN VARCHAR2,
V_APPLYDEPT IN VARCHAR2,
V_SUPPLYBY IN VARCHAR2
) RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
  VALIDCODE NUMBER := 0;
  o_errcode NUMBER := 0;
  o_errmsg VARCHAR2(1000);
  ITEM_INVALID_ERR EXCEPTION;  
BEGIN
  BEGIN
    SELECT 1
    INTO VALIDCODE
    FROM ivs_stock@tah ist
    WHERE TRIM(ist.dept_no) = V_SUPPLYBY
    AND ist.code_no = V_CODE
    AND ist.use_flag = '0';
  EXCEPTION
  WHEN OTHERS THEN
    o_errcode := -1;
    o_errmsg := '[THIS ITEM IS DISCONTINUE IN '||V_SUPPLYBY||']';
		RAISE ITEM_INVALID_ERR;	    
  END; 
  
  VALIDCODE := 0;
  BEGIN
    SELECT 1
    INTO VALIDCODE
    FROM ivs_stock@tah ist
    WHERE TRIM(ist.dept_no) = V_APPLYDEPT
    AND TRIM(ist.ord_dept) = V_SUPPLYBY
    AND ist.code_no = V_CODE;
  EXCEPTION
  WHEN OTHERS THEN
    o_errcode := -2;
    o_errmsg := '[ITEM NOT SUPPLY BY '||V_SUPPLYBY||']';
    RAISE ITEM_INVALID_ERR;	       
  END;

  OPEN OUTCUR FOR
    SELECT VALIDCODE,'[ITEM AVAILABLE]' FROM DUAL;
  RETURN OUTCUR;
EXCEPTION
WHEN ITEM_INVALID_ERR THEN
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
END NHS_GET_IVS_ITEM_VALID;