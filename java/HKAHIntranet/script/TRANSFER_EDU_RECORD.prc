create or replace procedure transfer_edu_record
(
  v_old_user_id in varchar2,
  v_new_user_id in varchar2
)
as 
  cur_co_enrollment sys_refcursor;
  rs_co_enrollment co_enrollment%rowtype;
  v_next_co_enroll_id number;
BEGIN

  open cur_co_enrollment for 
  select
    e.*
  from co_enrollment e
  where 
  --e.co_site_code = 'hkah'
  e.co_module_code = 'education'
  and e.co_user_id = v_old_user_id
  and e.co_enabled = 1
  order by e.co_event_id;

  loop
     fetch cur_co_enrollment into rs_co_enrollment;
     exit when cur_co_enrollment%notfound;
     
      select nvl(max(e2.co_enroll_id), 0) + 1
      into v_next_co_enroll_id
      from co_enrollment e2
      where 
        e2.co_site_code = rs_co_enrollment.co_site_code
        and e2.co_module_code = rs_co_enrollment.co_module_code
        and e2.co_event_id = rs_co_enrollment.co_event_id;
        
      
      -- insert
      insert into co_enrollment
      values
      (
          rs_co_enrollment.co_site_code,
          rs_co_enrollment.co_module_code,
          rs_co_enrollment.co_event_id,
          rs_co_enrollment.CO_SCHEDULE_ID,
          v_next_co_enroll_id,
          rs_co_enrollment.co_user_type,
          v_new_user_id,
          rs_co_enrollment.CO_ENROLL_NO,
          rs_co_enrollment.co_attend_date,
          rs_co_enrollment.CO_ATTEND_STATUS,
          rs_co_enrollment.co_remark,
          sysdate,
          'admin',
          rs_co_enrollment.co_modified_date,
          rs_co_enrollment.CO_MODIFIED_USER,
          rs_co_enrollment.co_enabled,
          rs_co_enrollment.CO_ATTEND_DATE2,
          rs_co_enrollment.co_assessment_pass_date,
          rs_co_enrollment.has_followup
      );
         
  end loop;
  close cur_co_enrollment;

END TRANSFER_EDU_RECORD;
/