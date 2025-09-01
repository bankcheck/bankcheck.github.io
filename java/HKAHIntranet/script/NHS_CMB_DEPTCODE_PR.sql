create or replace
FUNCTION "NHS_CMB_DEPTCODE_PR"
(i_TYPE IN VARCHAR2,
i_USRID  IN VARCHAR2)
  RETURN Types.cursor_type
--  RETURN VARCHAR2
AS
  v_count INTEGER;
  v_DEPTCODE VARCHAR2(10);
  v_showAll BOOLEAN;
  outcur types.cursor_type;
  sqlstr VARCHAR2(2000);  
BEGIN
  v_showAll := false;  
  IF i_TYPE = 'REQ' THEN
    SELECT count(1) INTO v_count
    FROM   AC_FUNCTION_ACCESS
    WHERE  AC_FUNCTION_ID = 'function.projectManagement.admin'
    AND    AC_ENABLED = 1
    AND    AC_USER_ID = (SELECT CO_USERNAME FROM CO_USERS WHERE CO_STAFF_ID = i_USRID);

    IF v_count = 1 THEN
        -- super users
        v_showAll := true;
    ELSE
      SELECT count(1) INTO v_count FROM CO_STAFFS WHERE CO_STAFF_ID = i_USRID AND CO_STAFF_ID IS NOT NULL;

      IF v_count = 1 THEN
        SELECT CO_DEPARTMENT_CODE INTO v_DEPTCODE FROM CO_STAFFS WHERE CO_STAFF_ID = i_USRID AND CO_STAFF_ID IS NOT NULL;

        Open Outcur For
          SELECT CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC
          FROM   CO_DEPARTMENTS
          WHERE  CO_DEPARTMENT_CODE = v_DEPTCODE
          ORDER BY CO_DEPARTMENT_DESC;
      ELSE
        SELECT count(1) INTO v_count FROM CO_STAFFS@TWAH WHERE CO_STAFF_ID = i_USRID AND CO_STAFF_ID IS NOT NULL;

        IF v_count = 1 THEN
          SELECT CO_DEPARTMENT_CODE INTO v_DEPTCODE FROM CO_STAFFS@TWAH WHERE CO_STAFF_ID = i_USRID AND CO_STAFF_ID IS NOT NULL;

          Open Outcur For
            SELECT D.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC
            FROM   CO_DEPARTMENTS D, CO_DEPARTMENT_MAPPING M
            WHERE  D.CO_DEPARTMENT_CODE = M.CO_DEPARTMENT_CODE1
            AND    M.CO_DEPARTMENT_CODE2 IN (v_DEPTCODE, '770')
            ORDER BY D.CO_DEPARTMENT_DESC;
        END IF;
      END IF;
    END IF;
  ELSIF i_TYPE = 'PREF' THEN
    Open Outcur For
      SELECT d.CO_DEPARTMENT_CODE, d.CO_DEPARTMENT_DESC
      FROM   CO_DEPARTMENTS d, PMP_TASK t
      WHERE  Rownum < 100
      AND    d.CO_DEPARTMENT_CODE = t.PMP_REQUEST_DEPARTMENT_CODE
      GROUP BY d.CO_DEPARTMENT_CODE, d.CO_DEPARTMENT_DESC
      ORDER BY d.CO_DEPARTMENT_CODE, d.CO_DEPARTMENT_DESC;
  ELSE
    v_showAll := true;
  END IF;

  IF v_showAll THEN
    sqlstr:=' SELECT CD.CO_DEPARTMENT_CODE, CD.CO_DEPARTMENT_DESC
              FROM   CO_DEPARTMENTS CD
              WHERE TRIM(CD.CO_DEPARTMENT_CODE) IN (SELECT TRIM(station) FROM bas_user@tah WHERE TRIM(emp_no) = (SELECT TRIM(user_alias) FROM sys_user_basic@tah WHERE user_id = '''||
              i_USRID||''' OR user_alias = '''||i_USRID||''') UNION ALL SELECT TRIM(unit) FROM pms_notice_to@tah WHERE TRIM(staff_no) = (SELECT TRIM(user_alias) FROM sys_user_basic@tah WHERE user_id = '''||
              i_USRID||''' OR user_alias = '''||i_USRID||''')) ORDER BY CO_DEPARTMENT_DESC';          
    OPEN OUTCUR FOR sqlstr;     
  END IF;
  RETURN outcur;
END NHS_CMB_DEPTCODE_PR;