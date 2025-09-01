create or replace
FUNCTION NHS_LIS_SEARCH_IVS_REQ  (
  as_userID IN VARCHAR2,
  as_applyNo IN VARCHAR2,
  as_from IN VARCHAR2,
  as_to IN VARCHAR2,
  as_shippTo IN VARCHAR2
)
  RETURN Types.cursor_type
--RETURN VARCHAR2
  AS
  OUTCUR types.cursor_type;
  sqlstr VARCHAR2(2000);
  wherestr VARCHAR2(2000);
  ordstr VARCHAR2(100);
BEGIN          
  sqlstr:= 'SELECT 
            iam.apply_no, 
            TO_CHAR(TO_DATE(iam.apply_date,''YYYYMMDD''),''DD/MM/YYYY''),
            (SELECT TRIM(pd.dept_ename) FROM pn_dept@tah pd WHERE pd.dept_id = iam.apply_dept),
            (SELECT TRIM(pd.dept_ename) FROM pn_dept@tah pd WHERE pd.dept_id = iam.shipped_to),  
            (SELECT TRIM(pd.dept_ename) FROM pn_dept@tah pd WHERE pd.dept_id = iam.out_dept),
            DECODE(iam.allot_type,''1'',''PAT'',''0'',''EXP''), 
            iam.if_close, 
            iam.ins_op, 
            iam.remarks
            FROM ivs_apply_m@tah iam';

          
  wherestr :=' WHERE iam.shipped_to IN (SELECT station FROM bas_user@tah WHERE TRIM(emp_no) = (SELECT TRIM(user_alias) FROM sys_user_basic@tah WHERE user_id = '''||
  as_userID||''' OR user_alias = '''||as_userID||''') UNION ALL SELECT unit FROM pms_notice_to@tah WHERE TRIM(staff_no) = (SELECT TRIM(user_alias) FROM sys_user_basic@tah WHERE user_id = '''||
  as_userID||''' OR user_alias = '''||as_userID||'''))';          
         
  IF TRIM(as_applyNo) IS NOT NULL THEN
    wherestr := wherestr||' AND iam.apply_no ='''||as_applyNo||'''';    
  ELSE
    IF TRIM(as_from) IS NOT NULL THEN
      wherestr := wherestr||' AND TO_DATE(iam.apply_date,''YYYYMMDD'') >= TO_DATE('''||as_from||''',''DD/MM/YYYY'')';    
  --    wherestr := wherestr||' AND ppm.pur_date >= '''||as_from||'''';
    END IF;
   
    IF TRIM(as_to) IS NOT NULL THEN
      wherestr := wherestr||' AND TO_DATE(iam.apply_date,''YYYYMMDD'') <= TO_DATE('''||as_to||''',''DD/MM/YYYY'')';    
  --    wherestr := wherestr||' AND ppm.pur_date <='''||as_to||'''';    
    END IF;  
  END IF;
  
  IF TRIM(as_shippTo) != 'ALL' THEN
    wherestr := wherestr||' AND iam.shipped_to = '''||as_shippTo||'''';    
  END IF;
  
  ordstr:=' ORDER BY iam.apply_no DESC';

  OPEN OUTCUR FOR sqlstr||wherestr||ordstr;
  RETURN OUTCUR;
--RETURN  sqlstr||wherestr||ordstr;
END NHS_LIS_SEARCH_IVS_REQ;