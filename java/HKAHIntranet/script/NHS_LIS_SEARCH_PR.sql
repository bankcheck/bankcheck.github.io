create or replace FUNCTION NHS_LIS_SEARCH_PR (
  as_userID IN VARCHAR2,
  as_purNo IN VARCHAR2,
  as_from IN VARCHAR2,
  as_to IN VARCHAR2,
  as_isApproved IN VARCHAR2,
  as_shippTo IN VARCHAR2,
  as_siteCode IN VARCHAR2,
  as_code IN VARCHAR2 
)
RETURN TYPES.CURSOR_TYPE
--RETURN VARCHAR2
  AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(2000);
  wherestr VARCHAR2(2000);
  ordstr VARCHAR2(100);
  SITECODE VARCHAR2(4);
  V_USRID VARCHAR2(20);    
BEGIN
  BEGIN
    SELECT DISTINCT TRIM(USER_ALIAS)
    INTO V_USRID
    FROM SYS_USER_BASIC@TAH 
    WHERE TRIM(as_userID) IN (TRIM(USER_ID),TRIM(USER_ALIAS));
  EXCEPTION
  WHEN OTHERS THEN
    V_USRID := NULL;
  END;

  sqlstr:='SELECT
          ppm.pur_no,
          TO_CHAR(TO_DATE(ppm.pur_date,''YYYYMMDD''),''DD/MM/YYYY''),
          (SELECT TRIM(pd.dept_ename) FROM pn_dept@tah pd WHERE pd.dept_id = ppm.pur_dept),
          (SELECT TRIM(pd.dept_ename) FROM pn_dept@tah pd WHERE pd.dept_id = ppm.shipped_to),        
          ppm.pur_op,          
          ppm.remark,
          DECODE(ppm.cancel_flag,''Y'',''CANCELLED'',''N'',DECODE(ppm.approve_flag,1,''APPROVED'',0,''WAITING APPROVAL''))
          FROM pms_pur_m@tah ppm';
          

  IF UPPER(as_sitecode) = 'HKAH' THEN
  	WHERESTR :=' WHERE (TRIM(ppm.shipped_to) IN (SELECT station FROM bas_user@tah WHERE TRIM(emp_no) = '''||V_USRID||
    ''' UNION SELECT unit FROM pms_notice_to@tah WHERE TRIM(staff_no) = '''||AS_USERID||
	''' UNION select TO_CHAR(CO_DEPARTMENT_CODE) from CO_STAFF_DEPARTMENTS where CO_STAFF_ID = '''||AS_USERID||
	''' UNION ';  
    WHERESTR := WHERESTR||'SELECT TO_CHAR(cs.co_department_code) FROM co_staffs cs WHERE cs.co_staff_id = '''||AS_USERID||''' UNION SELECT TO_CHAR(co_department_code) FROM co_staff_departments WHERE co_staff_id = '''||AS_USERID||''')';
    WHERESTR := WHERESTR||' OR TRIM(ppm.pur_op) IN ('''||AS_USERID||''','''||V_USRID||'''))';
    WHERESTR := WHERESTR||' AND TRIM(PPM.SHIPPED_TO) = '''||as_shippTo||'''';
  ELSE
  	wherestr :=' WHERE (TRIM(F_DEPT_DELIVERY_MAPPING@TAH(ppm.shipped_to)) IN (SELECT station FROM bas_user@tah WHERE TRIM(emp_no) = (SELECT DISTINCT TRIM(user_alias) FROM sys_user_basic@tah WHERE user_id = '''||
  	as_userID||''' OR user_alias = '''||as_userID||''') UNION SELECT unit FROM pms_notice_to@tah WHERE TRIM(staff_no) = (SELECT DISTINCT TRIM(user_alias) FROM sys_user_basic@tah WHERE user_id = '''||
  	as_userID||''' OR user_alias = '''||as_userID||''') UNION select CO_DEPARTMENT_CODE from CO_STAFF_DEPARTMENTS where CO_STAFF_ID = '''||
  	as_userID||''' UNION ';  
    WHERESTR := WHERESTR||'SELECT TO_CHAR(cdm.co_department_code3) FROM co_staffs cs, co_department_mapping cdm WHERE cs.co_department_code = cdm.co_department_code2 AND cs.co_staff_id = '''||AS_USERID||''' )';
    WHERESTR := WHERESTR||' OR TRIM(ppm.pur_op) IN ('''||AS_USERID||''','''||V_USRID||'''))';
    WHERESTR := WHERESTR||' AND TRIM(PPM.SHIPPED_TO) = '''||as_shippTo||'''';
  END IF;         
  
  IF TRIM(as_purNo) IS NOT NULL THEN
    wherestr := wherestr||' AND ppm.pur_no ='''||as_purNo||'''';    
  END IF;
  
  IF TRIM(as_code) IS NOT NULL THEN
    wherestr := wherestr||' AND ppm.pur_no IN (SELECT DISTINCT pur_no FROM pms_pur_d@tah ppd WHERE ppd.code = '''||as_code||''')';
  ELSE
    IF TRIM(as_purNo) IS NOT NULL THEN
      WHERESTR := WHERESTR||' AND ppm.pur_no ='''||AS_PURNO||'''';    
    ELSE
      IF TRIM(as_isApproved) = 'ALL' THEN
        IF TRIM(as_from) IS NOT NULL THEN
          wherestr := wherestr||' AND TO_DATE(ppm.pur_date,''YYYYMMDD'') >= TO_DATE('''||as_from||''',''DD/MM/YYYY'')';    
      --    wherestr := wherestr||' AND ppm.pur_date >= '''||as_from||'''';
        END IF;
       
        IF TRIM(as_to) IS NOT NULL THEN
          wherestr := wherestr||' AND TO_DATE(ppm.pur_date,''YYYYMMDD'') <= TO_DATE('''||as_to||''',''DD/MM/YYYY'')';    
      --    wherestr := wherestr||' AND ppm.pur_date <='''||as_to||'''';    
        END IF;  
      
        wherestr := wherestr||' AND DECODE('''||as_isApproved||''',''ALL'',1,ppm.approve_flag) = DECODE('''||as_isApproved||''',''ALL'',1,TO_NUMBER('''||as_isApproved||''')) AND cancel_flag = ''N''';
      ELSIF TRIM(as_isApproved) = '1' THEN -- APPROVED
        wherestr := wherestr||' AND (ppm.approve_flag = '''||as_isApproved||''' AND ppm.approve_date IS NOT NULL) AND cancel_flag = ''N''';
      ELSIF TRIM(as_isApproved) = '0' THEN -- WAITING APPROVED
        wherestr := wherestr||' AND (ppm.approve_flag = '''||as_isApproved||''' AND ppm.approve_date IS NULL) AND cancel_flag = ''N''';
      ELSE
        IF TRIM(as_from) IS NOT NULL THEN
          wherestr := wherestr||' AND TO_DATE(ppm.pur_date,''YYYYMMDD'') >= TO_DATE('''||as_from||''',''DD/MM/YYYY'')';    
      --    wherestr := wherestr||' AND ppm.pur_date >= '''||as_from||'''';
        END IF;
       
        IF TRIM(as_to) IS NOT NULL THEN
          wherestr := wherestr||' AND TO_DATE(ppm.pur_date,''YYYYMMDD'') <= TO_DATE('''||as_to||''',''DD/MM/YYYY'')';    
      --    wherestr := wherestr||' AND ppm.pur_date <='''||as_to||'''';    
        END IF;  
        
        IF TRIM(as_isApproved) ='0' OR TRIM(as_isApproved) ='1' OR TRIM(as_isApproved) ='ALL' THEN
          wherestr := wherestr||' AND DECODE('''||as_isApproved||''',''ALL'',1,ppm.approve_flag) = DECODE('''||as_isApproved||''',''ALL'',1,TO_NUMBER('''||as_isApproved||''')) ';
        ELSE
          wherestr := wherestr||' AND cancel_flag = ''N''';
        END IF;
      END IF;  
    END IF;   
  END IF;
/*    
  IF TRIM(as_shippTo) != 'ALL' AND TRIM(as_purNo) IS NULL THEN
    wherestr := wherestr||' AND ppm.shipped_to = '''||as_shippTo||'''';    
  END IF;
*/     
  ordstr:=' ORDER BY ppm.pur_no DESC';

  OPEN OUTCUR FOR SQLSTR||WHERESTR||ORDSTR;
  RETURN OUTCUR;
--RETURN  sqlstr||wherestr||ordstr;
END NHS_LIS_SEARCH_PR;
/