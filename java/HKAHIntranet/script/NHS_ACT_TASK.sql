create or replace
Function "NHS_ACT_TASK"
( p_Action		In Varchar2,
--
  p_Proj_Year   In Varchar2,
  p_Perform_Dept  In Varchar2,
  p_Site_Id In Varchar2,
  p_Service_Cat  In Varchar2,
  p_Request_Dept  In Varchar2,
--
  p_Project_Id  In Varchar2,
  p_Module_Id  In Varchar2,
  p_Task_Id  In Varchar2,
  p_Task_type  In Varchar2,
  p_Status In Varchar2,
  p_Prioritize In Varchar2,
  p_MANPOWER_req in varchar2,
  p_MANPOWER_left in varchar2,
--
  p_InPosPlanDate in Varchar2,
  p_InPosActDate in Varchar2,
  p_CompPlanDate in Varchar2,
  p_CompActDate in Varchar2,
  p_UATPlanDate in Varchar2,
  p_UATActDate in Varchar2,
  p_ReadyPlanDate in Varchar2,
  p_ReadyActDate in Varchar2,
  p_LivePlanDate in Varchar2,
  p_LiveActDate in Varchar2,
--
  o_errmsg		OUT VARCHAR2
)
RETURN NUMBER AS
  o_errcode	NUMBER; 
  v_count_task number;  
  ecode NUMBER;
  emesg VARCHAR2(200);
BEGIN
  o_errcode := 0;
  O_Errmsg := 'OK'; 
 
  select count(1) into v_count_task from PMP_task
        WHERE PMP_SITE_CODE = trim(p_Site_Id) and PMP_REQUEST_YEAR = trim(p_Proj_Year)
              and PMP_REQUEST_DEPARTMENT_CODE = trim(p_Request_Dept)
              and PMP_PERFORM_YEAR = trim(p_Proj_Year)
              and PMP_PERFORM_DEPARTMENT_CODE = trim(p_Perform_Dept)              
              and PMP_SERVICE_CAT = trim(p_Service_Cat)
              and PMP_PROJECT_ID = trim(p_Project_Id) AND PMP_MODULE_ID = trim(p_Module_Id) and PMP_TASK_ID = trim(p_Task_Id)
              and PMP_TASK_TYPE = trim(p_Task_type);
  --o_errcode := -1;    
  IF p_action = 'ADD' THEN
    IF v_count_task = 0 THEN
       insert into PMP_task (
            PMP_SITE_CODE, PMP_REQUEST_YEAR, PMP_REQUEST_DEPARTMENT_CODE, PMP_PERFORM_YEAR,
            PMP_PERFORM_DEPARTMENT_CODE, PMP_SERVICE_CAT, PMP_PROJECT_ID,
            PMP_MODULE_ID, PMP_TASK_ID, PMP_TASK_TYPE,
            PMP_MANPOWER_REQUIRED, PMP_CURRENT_STATUS, PMP_PRIORITIZE,
            PMP_IN_PROGRESS_SDATE, PMP_IN_PROGRESS_EDATE, PMP_COMPLETED_SDATE, PMP_COMPLETED_EDATE,
            PMP_UAT_SDATE, PMP_UAT_EDATE, PMP_READY_SDATE, PMP_READY_EDATE,
            PMP_LIVE_RUN_SDATE, PMP_LIVE_RUN_EDATE
            )
       values (p_Site_Id, p_Proj_Year, p_Request_Dept, p_Proj_Year, 
              p_Perform_Dept, p_Service_Cat, p_Project_Id,
              p_Module_Id, p_Task_Id, p_task_type,
              p_MANPOWER_req, p_Status, p_Prioritize,
              to_date(p_InPosPlanDate, 'dd/mm/yyyy'), to_date(p_InPosActDate, 'dd/mm/yyyy'), to_date(p_CompPlanDate, 'dd/mm/yyyy'), to_date(p_CompActDate, 'dd/mm/yyyy'),
              to_date(p_UATPlanDate, 'dd/mm/yyyy'), to_date(p_UATActDate, 'dd/mm/yyyy'), to_date(p_ReadyPlanDate, 'dd/mm/yyyy'), to_date(p_ReadyActDate, 'dd/mm/yyyy'),
              to_date(p_LivePlanDate, 'dd/mm/yyyy'), to_date(p_LiveActDate, 'dd/mm/yyyy') 
       );
    ELSE
      O_Errcode := -1;
      o_errmsg := 'Fail to insert due to PMP_task Record already exists. (ADD)';
    End If;
	ELSIF p_action = 'MOD' THEN
    IF v_count_task = 1 THEN
        UPDATE PMP_TASK
        SET    PMP_MANPOWER_REQUIRED = p_MANPOWER_req, PMP_CURRENT_STATUS = p_Status, PMP_PRIORITIZE = p_Prioritize,
               PMP_IN_PROGRESS_SDATE = to_date(p_InPosPlanDate, 'dd/mm/yyyy'), PMP_IN_PROGRESS_EDATE = to_date(p_InPosActDate, 'dd/mm/yyyy'),
               PMP_Completed_SDATE = to_date(p_CompPlanDate, 'dd/mm/yyyy'), PMP_completed_EDATE = to_date(p_CompActDate, 'dd/mm/yyyy'),
               PMP_UAT_SDATE = to_date(p_UATPlanDate, 'dd/mm/yyyy'), PMP_UAT_EDATE = to_date(p_UATActDate, 'dd/mm/yyyy'),
               PMP_Ready_SDATE = to_date(p_ReadyPlanDate, 'dd/mm/yyyy'), PMP_Ready_EDATE = to_date(p_ReadyActDate, 'dd/mm/yyyy'),               
               PMP_LIVE_Run_SDATE = to_date(p_LivePlanDate, 'dd/mm/yyyy'), PMP_LIVE_RUN_EDATE = to_date(p_LiveActDate, 'dd/mm/yyyy')
        WHERE PMP_SITE_CODE = p_Site_Id
        and   PMP_REQUEST_YEAR = p_Proj_Year
        and   PMP_REQUEST_DEPARTMENT_CODE = p_Request_Dept
        and   PMP_PERFORM_YEAR = p_Proj_Year
        and   PMP_PERFORM_DEPARTMENT_CODE = p_Perform_Dept
        and   PMP_SERVICE_CAT = p_Service_Cat
        and   PMP_PROJECT_ID = p_Project_Id
        AND   PMP_MODULE_ID = p_Module_Id
        AND   PMP_TASK_ID = p_Task_Id
        and   PMP_TASK_TYPE = trim(p_Task_type);
    ELSE
      O_Errcode := -1;
      o_errmsg := 'Fail to modify due to PMP_task Record Not exists. (MOD)';
      --O_Errmsg := v_count_task || ' ' || p_Site_Id || ' ' || p_Proj_Year || ' ' || p_Perform_Dept || ' ' || p_Proj_Year || ' ' || p_Request_Dept || ' ' || p_Service_Cat || ' ' || p_Project_Id || ' ' || p_Module_Id || ' ' || p_Task_Id;
    End If;
	ELSIF p_action = 'DEL' THEN
    IF v_count_task = 1 THEN
      DELETE
      FROM    PMP_task 
      WHERE   PMP_SITE_CODE = p_Site_Id
      AND     PMP_REQUEST_YEAR = p_Proj_Year
      AND     PMP_REQUEST_DEPARTMENT_CODE = p_Request_Dept
      AND     PMP_PERFORM_YEAR = p_Proj_Year
      AND     PMP_PERFORM_DEPARTMENT_CODE = p_Perform_Dept
      AND     PMP_SERVICE_CAT = p_Service_Cat
      AND     PMP_PROJECT_ID = p_Project_Id
      AND     PMP_MODULE_ID = p_Module_Id
      AND     PMP_TASK_ID = p_Task_Id
      AND     PMP_TASK_TYPE = trim(p_Task_type);
    ELSE
      o_errcode := -1;
      o_errmsg := v_count_task || ' ' || 'Fail to delete due to PMP_pserson record not exist. (DEL)';
      O_Errmsg := v_count_task || ' ' || p_Site_Id || ' ' || p_Proj_Year || ' ' || p_Perform_Dept || ' ' || p_Proj_Year || ' ' || p_Request_Dept || ' ' || p_Service_Cat || ' ' || p_Project_Id || ' ' || p_Module_Id || ' ' || p_Task_Id;
    END IF;
  end if; 
  COMMIT;
  return o_errcode;  
EXCEPTION
WHEN OTHERS THEN
	o_errcode := -1;
	o_errmsg := 'Fail to save the Record.';
  ecode := SQLCODE;
  emesg := SQLERRM;
  o_errmsg := TO_CHAR(ecode) || '-' || emesg;
	ROLLBACK;
  return o_errcode;
END NHS_ACT_TASK;