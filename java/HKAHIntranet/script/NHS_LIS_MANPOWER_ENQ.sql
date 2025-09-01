create or replace
Function "NHS_LIS_MANPOWER_ENQ"
(V_YEAR IN VARCHAR2, V_perf_dept IN varchar2, V_req_dept IN varchar2, V_status IN varchar2,
 V_PROJECT IN VARCHAR2, V_MODULE IN varchar2, V_TASK IN varchar2)
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
    select pp.pmp_perform_DEPARTMENT_code, pp.PMP_SITE_CODE, pp.PMP_SERVICE_CAT, pp.PMP_REQUEST_DEPARTMENT_CODE,
       pp.PMP_PROJECT_ID, pp.PMP_MODULE_ID, pp.PMP_TASK_ID, pp.PMP_CURRENT_STATUS, null,
       null, sum(pm.pmp_manpower_used)
    from pmp_person pp
    join pmp_manpower pm on pp.PMP_SITE_CODE = pm.PMP_SITE_CODE and pp.PMP_PROJECT_ID = pm.PMP_PROJECT_ID and
                        pp.PMP_MODULE_ID = pm.PMP_MODULE_ID and pp.PMP_TASK_ID = pm.PMP_TASK_ID and
                        pp.PMP_PERFORM_USER_ID = pm.PMP_USER_ID
    WHERE pp.PMP_REQUEST_YEAR like '%' || v_YEAR || '%' AND pp.pmp_perform_DEPARTMENT_code like '%' || V_perf_dept || '%' and
          pp.PMP_REQUEST_DEPARTMENT_CODE like '%' || V_req_dept || '%' and pp.PMP_CURRENT_STATUS like '%' || v_status || '%' and
          pp.PMP_PROJECT_ID LIKE '%' || V_PROJECT || '%' and pp.PMP_MODULE_ID like '%' || v_module  || '%' and 
          pp.PMP_TASK_ID like '%' || v_task || '%'
    group by pp.pmp_perform_DEPARTMENT_code, pp.PMP_SITE_CODE, pp.PMP_SERVICE_CAT, pp.PMP_REQUEST_DEPARTMENT_CODE, pp.PMP_PROJECT_ID, pp.PMP_MODULE_ID, pp.PMP_TASK_ID, pp.PMP_CURRENT_STATUS, null, null
    order by pp.PMP_PROJECT_ID, pp.PMP_MODULE_ID, pp.PMP_TASK_ID, pp.PMP_CURRENT_STATUS, null, null; 

    RETURN OUTCUR;
END NHS_LIS_MANPOWER_ENQ;