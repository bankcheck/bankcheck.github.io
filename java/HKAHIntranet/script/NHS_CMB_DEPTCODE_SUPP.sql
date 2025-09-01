create or replace
FUNCTION NHS_CMB_DEPTCODE_SUPP (
i_TYPE IN VARCHAR2,
i_DEPTCODE  IN VARCHAR2)
  RETURN Types.cursor_type
--  RETURN VARCHAR2
AS
  v_DEPTCODE VARCHAR2(10);
  outcur types.cursor_type;
  sqlstr VARCHAR2(2000);  
BEGIN
--SELECT TRIM(dept_id) AS dept_id, dept_ename FROM pn_dept WHERE dept_type = '1' ORDER BY dept_ename"  
    sqlstr:=' SELECT TRIM(dept_id) AS dept_id, TRIM(dept_ename) AS dept_name 
              FROM pn_dept@tah 
              WHERE dept_type = ''1'' ORDER BY dept_ename';
    OPEN OUTCUR FOR sqlstr;     
  RETURN outcur;
END NHS_CMB_DEPTCODE_SUPP;