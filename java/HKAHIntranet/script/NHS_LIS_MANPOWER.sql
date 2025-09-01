create or replace
Function "NHS_LIS_MANPOWER"
(V_PROJECT IN VARCHAR2, V_MODULE IN varchar2, V_TASK IN VARCHAR2, V_YEAR IN VARCHAR2, V_perf_person IN varchar2, V_WEEK IN VARCHAR2)
RETURN
Types.Cursor_Type
As
--  S_Year Varchar2(10);
--  S_Perform_Dept Varchar2(10);
--  S_Week Varchar2(10);
  OUTCUR TYPES.cursor_type;
Begin
--    S_Year := '2012';
--    S_Perform_Dept := '720';
--    S_Week := '16';

    OPEN OUTCUR FOR
     select pp.pmp_perform_year, pp.PMP_SITE_CODE, pp.pmp_perform_department_code, pp.PMP_SERVICE_CAT, pp.PMP_REQUEST_DEPARTMENT_CODE, 
       pp.PMP_PROJECT_ID, pp.PMP_MODULE_ID, pp.PMP_TASK_ID, pp.PMP_CURRENT_STATUS, pp.PMP_PERFORM_USER_ID, 
       pm.pmp_week, pm.pmp_manpower_used
    from pmp_person pp
    join pmp_manpower pm on pp.PMP_SITE_CODE = pm.PMP_SITE_CODE and pp.PMP_PROJECT_ID = pm.PMP_PROJECT_ID and
                        pp.PMP_MODULE_ID = pm.PMP_MODULE_ID and pp.PMP_TASK_ID = pm.PMP_TASK_ID and 
                        pp.PMP_PERFORM_USER_ID = pm.PMP_USER_ID
    WHERE pp.PMP_PROJECT_ID like '%' || v_PROJECT || '%' AND  pp.PMP_MODULE_ID like '%' || v_MODULE || '%' AND
          PP.PMP_TASK_ID like '%' || V_TASK || '%' AND
          pp.PMP_REQUEST_YEAR like '%' || v_YEAR || '%' AND pp.pmp_perform_user_id like '%' || V_perf_person || '%' AND 
          pm.PMP_WEEK like '%' || v_WEEK || '%'
    order by pp.pmp_perform_year, pm.pmp_week, pp.PMP_SITE_CODE, pp.PMP_SERVICE_CAT, pp.PMP_PROJECT_ID, pp.PMP_MODULE_ID, pp.PMP_TASK_ID;
    RETURN OUTCUR; 
END NHS_LIS_MANPOWER;