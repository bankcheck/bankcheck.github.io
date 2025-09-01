create or replace
Function "NHS_LIS_MANPOWER_2"
(v_task_type IN VARCHAR2, v_site in varchar2, v_req_dept IN varchar2, v_project_id IN varchar2, v_module_id IN varchar2, v_task_id IN varchar2, v_user_id in varchar2)
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
    select pm.PMP_SITE_CODE, pm.PMP_SERVICE_CAT, pm.PMP_REQUEST_DEPARTMENT_CODE,
       pm.PMP_PROJECT_ID, pm.PMP_MODULE_ID, pm.PMP_TASK_ID, pm.PMP_STATUS,
       pm.PMP_USER_ID,
       pm.pmp_week, decode(pm.pmp_requirement, 'Blank', '', pm.pmp_requirement),
       pm.pmp_stage, pm.pmp_cycle,
       pm.pmp_manpower_used, pm.pmp_requirement 
    from pmp_manpower pm
    WHERE pm.PMP_TASK_TYPE like '%' || v_task_type || '%' and
          pm.PMP_SITE_CODE like '%' || v_site || '%' and
          pm.PMP_REQUEST_DEPARTMENT_CODE like '%' || v_req_dept || '%' and
          pm.PMP_PROJECT_ID = v_project_id and
          pm.PMP_MODULE_ID = v_module_id and
          pm.PMP_TASK_ID = v_task_id and
          pm.PMP_USER_ID = v_user_id
    order by pm.pmp_week, pm.PMP_USER_ID;

    RETURN OUTCUR;
END NHS_LIS_MANPOWER_2;