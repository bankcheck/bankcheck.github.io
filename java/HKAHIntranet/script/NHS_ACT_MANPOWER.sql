create or replace
Function "NHS_ACT_MANPOWER"
( P_Action		In Varchar2,
--
  P_Proj_Year   In Varchar2,
  P_Perform_Dept  In Varchar2,
  P_Site_Id In Varchar2,
  P_Service_Cat  In Varchar2,
  P_Request_Dept  In Varchar2,
--
  P_Project_Id  In Varchar2,
  P_Module_Id  In Varchar2,
  P_Task_Id  In Varchar2,
  P_Person_Id In Varchar2,
  P_Status In Varchar2,
--
  P_Proj_Week In Varchar2,
  p_MANPOWER_USED in varchar2,
  p_new_status in varchar2,
-- old keys
  P_Site_Id_old In Varchar2,
  P_Project_Id_old  In Varchar2,
  P_Module_Id_old  In Varchar2,
  P_Task_Id_old  In Varchar2,
  P_Person_Id_old In Varchar2,
  P_Proj_Week_old In Varchar2, 
--
  o_errmsg		OUT VARCHAR2
)
RETURN NUMBER AS
  o_errcode	NUMBER;
--  v_noOfRec NUMBER;
  v_count_person number;
  v_count_manpower number;
  v_tot_count_manpower number;
  v_same_person number;
  v_same_manpower number;
  v_error number;
  seq_usersiteid NUMBER;
BEGIN
  o_errcode := 0;
  O_Errmsg := 'OK';
  
  if (P_Site_Id_old = P_Site_Id) and
     (P_Project_Id_old = P_Project_Id) and
     (P_Module_Id_old = P_Module_Id) and
     (p_task_id_old = p_task_id) and
     (p_person_id_old = p_person_id) then
    v_same_person := 1;
  else
    v_same_person := 0;
  end if;
  if (P_Site_Id_old = P_Site_Id) and
     (P_Project_Id_old = P_Project_Id) and
     (P_Module_Id_old = P_Module_Id) and
     (p_task_id_old = p_task_id) and
     (p_person_id_old = p_person_id) and
     (P_Proj_Week_old = P_Proj_Week) then
    v_same_manpower := 1;
  else
    v_same_manpower := 0;
  end if;
  
  select count(1) into v_count_person from pmp_person
  where PMP_SITE_CODE = P_Site_Id and PMP_PROJECT_ID = P_Project_Id and PMP_MODULE_ID = P_Module_Id and
        PMP_TASK_ID = P_Task_Id and PMP_PERFORM_USER_ID = P_Person_Id;

  select count(1) into v_count_manpower from pmp_manpower
  where PMP_SITE_CODE = P_Site_Id and PMP_PROJECT_ID = P_Project_Id and PMP_MODULE_ID = P_Module_Id and
        PMP_TASK_ID = P_Task_Id and PMP_USER_ID = P_Person_Id and PMP_WEEK = P_Proj_Week;

  dbms_output.put_line('after select');
  IF p_action = 'ADD' THEN
      IF v_count_person = 0 THEN
      Insert Into PMP_person
      (
          PMP_SITE_CODE, PMP_REQUEST_YEAR, PMP_REQUEST_DEPARTMENT_CODE, PMP_PERFORM_YEAR,
          PMP_PERFORM_DEPARTMENT_CODE, PMP_SERVICE_CAT, PMP_PROJECT_ID,
          PMP_MODULE_ID, PMP_TASK_ID, PMP_PERFORM_USER_ID, pmp_manpower_required, PMP_CURRENT_STATUS
       ) Values (
          P_Site_Id, p_proj_year, P_Request_Dept,
          p_proj_year, P_Perform_Dept, P_Service_Cat,
          P_Project_Id, P_Module_Id, P_Task_Id,
          P_Person_Id, '0', P_Status
       );
       dbms_output.put_line('after insert');
    ELSE
      O_Errcode := -1;
      o_errmsg := 'pmp_person Record already exists.';
    End If;
    IF (v_count_manpower = 0) THEN
      Insert Into PMP_Manpower
      (
          PMP_SITE_CODE, PMP_REQUEST_YEAR, PMP_REQUEST_DEPARTMENT_CODE,
          PMP_PERFORM_YEAR, PMP_PERFORM_DEPARTMENT_CODE, PMP_SERVICE_CAT,
          PMP_PROJECT_ID, PMP_MODULE_ID, PMP_TASK_ID,
          PMP_USER_ID, PMP_STATUS, PMP_WEEK,
          PMP_MANPOWER_USED
       ) Values (
          P_Site_Id, p_proj_year, P_Request_Dept,
          p_proj_year, P_Perform_Dept, P_Service_Cat,
          P_Project_Id, P_Module_Id, P_Task_Id,
          P_Person_Id, P_Status, P_Proj_Week,
          to_number(P_Manpower_Used)
       );
       dbms_output.put_line('after insert');
    ELSE
      O_Errcode := -1;
      o_errmsg := 'pmp_manpower Record already exists.';
    End If;
	ELSIF p_action = 'MOD' THEN
    v_error := 0;
    IF (v_count_person = 1) and (v_count_manpower = 1) THEN
      v_error := 1;
      O_Errcode := -1;
      o_errmsg := 'pmp_person Record and pmp_manpower Record already exists.';
    END IF;
    if v_error = 0 then
      -- is there any project,module,task related to this manpower ?
        select count(1) into v_tot_count_manpower from PMP_MANPOWER 
        Where	PMP_SITE_CODE = P_Site_Id_old and PMP_PROJECT_ID = P_Project_Id_old and PMP_MODULE_ID = P_Module_Id_old and
              PMP_TASK_ID = p_task_id_old and PMP_USER_ID = p_person_id_old;
        -- if only one manpower, then delete the person record
      if v_tot_count_manpower = 1 then
          DELETE pmp_person 
          Where	PMP_SITE_CODE = P_Site_Id_old and PMP_PROJECT_ID = P_Project_Id_old and PMP_MODULE_ID = P_Module_Id_old and
                PMP_TASK_ID = p_task_id_old and PMP_PERFORM_USER_ID = p_person_id_old;
      end if;
  		DELETE PMP_MANPOWER 
      Where	PMP_SITE_CODE = P_Site_Id_old and PMP_PROJECT_ID = P_Project_Id_old and PMP_MODULE_ID = P_Module_Id_old and
            PMP_TASK_ID = p_task_id_old and PMP_USER_ID = p_person_id_old and PMP_WEEK = p_proj_week_old; 
      IF v_count_person = 0 THEN
        Insert Into PMP_person
        (
            PMP_SITE_CODE, PMP_REQUEST_YEAR, PMP_REQUEST_DEPARTMENT_CODE,
            PMP_PERFORM_YEAR, PMP_PERFORM_DEPARTMENT_CODE,
            PMP_SERVICE_CAT, PMP_PROJECT_ID,
            PMP_MODULE_ID, PMP_TASK_ID,
            PMP_PERFORM_USER_ID,pmp_manpower_required,
            PMP_CURRENT_STATUS
         ) Values (
            P_Site_Id, p_proj_year, P_Request_Dept,
            p_proj_year, P_Perform_Dept, P_Service_Cat,
            P_Project_Id, P_Module_Id, P_Task_Id,
            P_Person_Id, '0', P_Status
         );
      end if;
--      if v_count_manpower = 0 then

        Insert Into PMP_Manpower
      (
          PMP_SITE_CODE, PMP_REQUEST_YEAR, PMP_REQUEST_DEPARTMENT_CODE,
          PMP_PERFORM_YEAR, PMP_PERFORM_DEPARTMENT_CODE, PMP_SERVICE_CAT,
          PMP_PROJECT_ID, PMP_MODULE_ID, PMP_TASK_ID,
          PMP_USER_ID, PMP_STATUS, PMP_WEEK,
          PMP_MANPOWER_USED
       ) Values (
          P_Site_Id, p_proj_year, P_Request_Dept,
          p_proj_year, P_Perform_Dept, P_Service_Cat,
          P_Project_Id, P_Module_Id, P_Task_Id,
          P_Person_Id, P_Status, P_Proj_Week,
          to_number(P_Manpower_Used)
       );

--    end if;
    end if;
	ELSIF p_action = 'DEL' THEN
    If v_count_person > 0 Then
        select count(1) into v_tot_count_manpower from PMP_MANPOWER 
        Where	PMP_SITE_CODE = P_Site_Id and PMP_PROJECT_ID = P_Project_Id and PMP_MODULE_ID = P_Module_Id and
            PMP_TASK_ID = p_task_id and PMP_USER_ID = p_person_id;
         -- if only one manpower, then delete the person record
        if v_tot_count_manpower = 1 then
      		DELETE pmp_person 
          Where	PMP_SITE_CODE = P_Site_Id and PMP_PROJECT_ID = P_Project_Id and PMP_MODULE_ID = P_Module_Id and
          PMP_TASK_ID = p_task_id and PMP_PERFORM_USER_ID = p_person_id;
        end if;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to pmp_pserson record not exist.';
    END IF;

    If v_count_manpower > 0 Then
  		DELETE PMP_MANPOWER 
      Where	PMP_SITE_CODE = P_Site_Id and PMP_PROJECT_ID = P_Project_Id and PMP_MODULE_ID = P_Module_Id and
            PMP_TASK_ID = p_task_id and PMP_USER_ID = p_person_id and PMP_WEEK = p_proj_week;

    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to delete due to pmp_manpower record not exist.';
    END IF;
	END IF;
  return o_errcode;
END NHS_ACT_MANPOWER;

/*
    If v_count_person > 0 Then
      if p_new_status is not null then
        UPDATE pmp_person
        Set
           PMP_SITE_CODE = P_Site_Id,
           PMP_REQUEST_YEAR = p_proj_year,
           PMP_REQUEST_DEPARTMENT_CODE = P_Request_Dept,
           PMP_PERFORM_YEAR = p_proj_year,
           PMP_PERFORM_DEPARTMENT_CODE = P_Perform_Dept,
           PMP_SERVICE_CAT = P_Service_Cat,
           PMP_PROJECT_ID = P_Project_Id,
           PMP_MODULE_ID = P_Module_Id,
           PMP_TASK_ID = P_Task_Id,
           PMP_PERFORM_USER_ID = P_Person_Id,
           pmp_manpower_required = 0,
           PMP_CURRENT_STATUS = p_new_status
        Where	PMP_SITE_CODE = P_Site_Id and PMP_PROJECT_ID = P_Project_Id and PMP_MODULE_ID = P_Module_Id and
              PMP_TASK_ID = p_task_id and PMP_PERFORM_USER_ID = p_person_id;
      end if;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to pmp_person record not exist.';
    End If;
    If v_count_manpower > 0 Then
      UPDATE pmp_manpower
      Set
          PMP_SITE_CODE = P_Site_Id,
          PMP_REQUEST_YEAR = p_proj_year,
          PMP_REQUEST_DEPARTMENT_CODE = P_Request_Dept,
          PMP_PERFORM_YEAR = p_proj_year,
          PMP_PERFORM_DEPARTMENT_CODE = P_Perform_Dept,
          PMP_SERVICE_CAT = P_Service_Cat,
          PMP_PROJECT_ID = P_Project_Id,
          PMP_MODULE_ID = P_Module_Id,
          PMP_TASK_ID = P_Task_Id,
          PMP_USER_ID = P_Person_Id,
          PMP_STATUS = P_Status,
          PMP_WEEK = P_Proj_Week,
          pmp_Manpower_Used = to_number(P_Manpower_Used)
      Where	PMP_SITE_CODE = P_Site_Id and PMP_PROJECT_ID = P_Project_Id and PMP_MODULE_ID = P_Module_Id and
            PMP_TASK_ID = p_task_id and PMP_USER_ID = p_person_id and PMP_WEEK = p_proj_week;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to pmp_manpower record not exist.';
    End If;
    */