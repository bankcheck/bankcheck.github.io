create or replace
Function "NHS_LIS_TASK"
(V_PROJECT IN VARCHAR2, V_MODULE IN varchar2, V_TASK IN VARCHAR2, V_YEAR IN VARCHAR2)
RETURN
Types.Cursor_Type
As
  OUTCUR TYPES.cursor_type;
Begin 
    OPEN OUTCUR FOR
    SELECT pt.PMP_PERFORM_YEAR, pt.PMP_SITE_CODE, pt.PMP_PERFORM_DEPARTMENT_CODE, 
           pt.PMP_SERVICE_CAT, pt.PMP_REQUEST_DEPARTMENT_CODE, pt.PMP_PROJECT_ID, pt.PMP_MODULE_ID, pt.PMP_TASK_ID,
           pt.PMP_TASK_TYPE,
           pt.PMP_MANPOWER_REQUIRED, SUM(pm.PMP_MANPOWER_USED), DECODE(pt.PMP_MANPOWER_REQUIRED, 0, 0, pt.PMP_MANPOWER_REQUIRED - SUM(pm.PMP_MANPOWER_USED)),
           pt.PMP_CURRENT_STATUS, pt.PMP_PRIORITIZE,
           to_char(pt.PMP_IN_PROGRESS_SDATE, 'dd/mm/yyyy'), to_char(pt.PMP_IN_PROGRESS_EDATE, 'dd/mm/yyyy'),
           to_char(pt.PMP_COMPLETED_SDATE, 'dd/mm/yyyy'), to_char(pt.PMP_COMPLETED_EDATE, 'dd/mm/yyyy'),
           to_char(pt.PMP_UAT_SDATE, 'dd/mm/yyyy'), to_char(pt.PMP_UAT_EDATE, 'dd/mm/yyyy'),
           to_char(pt.PMP_READY_SDATE, 'dd/mm/yyyy'), to_char(pt.PMP_READY_EDATE, 'dd/mm/yyyy'),
           to_char(pt.PMP_LIVE_RUN_SDATE, 'dd/mm/yyyy'), to_char(pt.PMP_LIVE_RUN_EDATE, 'dd/mm/yyyy')
      FROM PMP_TASK pt, PMP_MANPOWER pm
     WHERE pt.PMP_SITE_CODE = pm.PMP_SITE_CODE (+)
      AND  pt.PMP_REQUEST_YEAR = pm.PMP_REQUEST_YEAR (+)
      AND  pt.PMP_REQUEST_DEPARTMENT_CODE = pm.PMP_REQUEST_DEPARTMENT_CODE (+)
      AND  pt.PMP_PERFORM_YEAR = pm.PMP_PERFORM_YEAR (+)
      AND  pt.PMP_PERFORM_DEPARTMENT_CODE = pm.PMP_PERFORM_DEPARTMENT_CODE (+)
      AND  pt.PMP_SERVICE_CAT = pm.PMP_SERVICE_CAT (+)
      AND  pt.PMP_PROJECT_ID = pm.PMP_PROJECT_ID (+)
      AND  pt.PMP_MODULE_ID = pm.PMP_MODULE_ID (+)
      AND  pt.PMP_TASK_ID = pm.PMP_TASK_ID (+)
      AND  pt.PMP_TASK_TYPE = pm.PMP_TASK_TYPE (+)
      AND  pt.PMP_PROJECT_ID like '%' || v_PROJECT || '%'
      AND  pt.PMP_MODULE_ID like '%' || v_MODULE || '%'
      AND  pt.PMP_TASK_ID like '%' || V_TASK || '%'
      AND  pt.PMP_REQUEST_YEAR like '%' || v_YEAR || '%'
    group by pt.PMP_PERFORM_YEAR, pt.PMP_SITE_CODE, pt.PMP_PERFORM_DEPARTMENT_CODE, pt.PMP_SERVICE_CAT, pt.PMP_REQUEST_DEPARTMENT_CODE, pt.PMP_PROJECT_ID, pt.PMP_MODULE_ID, pt.PMP_TASK_ID, pt.PMP_TASK_TYPE, pt.PMP_MANPOWER_REQUIRED, pt.PMP_CURRENT_STATUS, pt.PMP_PRIORITIZE, to_char(pt.PMP_IN_PROGRESS_SDATE, 'dd/mm/yyyy'), to_char(pt.PMP_IN_PROGRESS_EDATE, 'dd/mm/yyyy'), to_char(pt.PMP_COMPLETED_SDATE, 'dd/mm/yyyy'), to_char(pt.PMP_COMPLETED_EDATE, 'dd/mm/yyyy'), to_char(pt.PMP_UAT_SDATE, 'dd/mm/yyyy'), to_char(pt.PMP_UAT_EDATE, 'dd/mm/yyyy'), to_char(pt.PMP_READY_SDATE, 'dd/mm/yyyy'), to_char(pt.PMP_READY_EDATE, 'dd/mm/yyyy'), to_char(pt.PMP_LIVE_RUN_SDATE, 'dd/mm/yyyy'), to_char(pt.PMP_LIVE_RUN_EDATE, 'dd/mm/yyyy')
    ORDER BY pt.PMP_PERFORM_YEAR, pt.PMP_SITE_CODE, pt.PMP_SERVICE_CAT, pt.PMP_PROJECT_ID, pt.PMP_MODULE_ID, pt.PMP_TASK_ID;
    RETURN OUTCUR; 
END NHS_LIS_TASK;