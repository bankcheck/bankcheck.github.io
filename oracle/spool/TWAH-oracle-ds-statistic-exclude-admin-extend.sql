-- set NLS_LANG=AMERICAN_AMERICA.ZHT16HKSCS
-- sqlplus ehr_dh/pwd$123@ce3oradb01

ALTER SESSION SET NLS_DATE_LANGUAGE=American;
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';

set trimspool on;
set trimout on;
set trims on;

SET LINESIZE 13000;
SET PAGESIZE 10000;
SET LONG 10000;

col TAB# new_value TAB NOPRINT
select chr(9) TAB# from dual;
set colsep "&TAB"

CREATE GLOBAL TEMPORARY TABLE t_dxpx_dummy_patient_20150304 (patient_id varchar2(32));

VAR goLiveDtm varchar2(19);
EXEC :goLiveDtm := '20150204000000';

VAR cutoffDtm varchar2(19);
EXEC :cutoffDtm := '20170101000000';


VAR freetextcutoffDtm varchar2(19);
EXEC :freetextcutoffDtm := '20160601000000';

-- eg. 'DUMMY_PATIENT_MRN','TEST1_PATIENT_MRN','TEST2_PATIENT_MRN'
insert into t_dxpx_dummy_patient_20150304 
select patient_key from dxpx_patient
where patient_ref_key IN ('DUMMY_PATIENT_MRN');

-----------------
--Distinct No of Diagnosis (freetext)
-----------------
-- calculate the no. of reccord for freetext diagnosis (Distinct)
select 
d_pg.description AS  freetext_diagnosis,
COUNT(d_pg.description ) AS  no_freetext_diagnosis
from dxpx_patient_episode p_e,  dxpx_diagnosis_profile d_pr, dxpx_diagnosis_progress d_pg where 
d_pr.dx_profile_seq = d_pg.dx_profile_seq 
and d_pg.case_no = p_e.case_no 
and p_e.episode_type_id = 'I' 
and d_pg.isfreetext = 'Y'
--***
and p_e.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and p_e.update_dtm >= to_date(:freetextcutoffDtm, 'yyyymmddhh24miss')  -- freetext cutoff
and p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304) 
--***
GROUP BY d_pg.description
ORDER BY freetext_diagnosis;





-----------------
--Distinct No of Procedure (freetext)
-----------------
-- calculate the no. of reccord for freetext procedure (Distinct)
select 
p_pr.description AS  freetext_procedure,
COUNT(p_pr.description ) AS  no_freetext_procedure
from dxpx_procedure_profile p_pr, dxpx_patient_episode p_e where 
p_pr.case_no = p_e.case_no  
and p_e.episode_type_id = 'I'
AND p_pr.isfreetext = 'Y'
--***
and p_e.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and p_e.update_dtm >= to_date(:freetextcutoffDtm, 'yyyymmddhh24miss')  -- freetext cutoff
and p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304) 
--***
GROUP BY p_pr.description
ORDER BY freetext_procedure;

----------------------------
-- Check DX user and patient
----------------------------

-- Distinct user (accumulated)
select count(distinct p_pr.update_by) total_no_of_users_dx
FROM dxpx_diagnosis_profile_log p_pr, 
     dxpx_diagnosis_progress_log d,
     dxpx_patient_episode p_e 
WHERE d.case_no = p_e.case_no  
AND  d.dx_profile_seq = p_pr.dx_profile_seq
AND p_e.update_by NOT IN ('ehradmin', 'admin') -- exclude admin user
AND p_e.update_dtm     > to_date(:goLiveDtm, 'yyyymmddhh24miss')  -- ds go live date-time
AND p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304)  -- ds dummy patients  
;


-- Distinct user (per month)
SELECT to_char(p_pr.update_dtm, 'YYYYMM') update_date, count(distinct p_pr.update_by) no_of_users_dx
FROM dxpx_diagnosis_profile_log p_pr, 
     dxpx_diagnosis_progress_log d,
     dxpx_patient_episode p_e 
WHERE d.case_no = p_e.case_no  
AND  d.dx_profile_seq = p_pr.dx_profile_seq
AND p_e.update_by NOT IN ('ehradmin', 'admin') -- exclude admin user
AND p_e.update_dtm      > to_date(:goLiveDtm, 'yyyymmddhh24miss')  -- ds go live date-time
AND p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304)  -- ds dummy patients  
group by to_char(p_pr.update_dtm, 'YYYYMM')
order by to_char(p_pr.update_dtm, 'YYYYMM');


-- Distinct patient (accumulated)
select count(distinct p_e.patient_key) total_no_of_patients_dx
FROM dxpx_diagnosis_profile_log p_pr, 
     dxpx_diagnosis_progress_log d,
     dxpx_patient_episode p_e 
WHERE d.case_no = p_e.case_no  
AND  d.dx_profile_seq = p_pr.dx_profile_seq
AND p_e.update_by NOT IN ('ehradmin', 'admin') -- exclude admin user
AND p_e.update_dtm     > to_date(:goLiveDtm, 'yyyymmddhh24miss')            -- ds go live date-time
AND p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304)   -- ds dummy patients  
;

-- Distinct patient (per month)
SELECT to_char(p_pr.update_dtm, 'YYYYMM') update_date, count(distinct p_e.patient_key) no_of_patients_dx
FROM dxpx_diagnosis_profile_log p_pr, 
     dxpx_diagnosis_progress_log d,
     dxpx_patient_episode p_e 
WHERE d.case_no = p_e.case_no  
AND  d.dx_profile_seq = p_pr.dx_profile_seq
AND p_e.update_by NOT IN ('ehradmin', 'admin') -- exclude admin user
AND p_e.update_dtm     > to_date(:goLiveDtm, 'yyyymmddhh24miss')            -- ds go live date-time
AND p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304)  -- ds dummy patients  
group by to_char(p_pr.update_dtm, 'YYYYMM')
order by to_char(p_pr.update_dtm, 'YYYYMM');

----------------------------
-- Check PX user and patient
----------------------------

-- Distinct user (accumulated)
select count(distinct p_pr.update_by) total_no_of_users_px
FROM dxpx_procedure_profile_log p_pr, 
      dxpx_patient_episode p_e 
WHERE p_pr.case_no = p_e.case_no  
AND p_e.update_by NOT IN ('ehradmin', 'admin') -- exclude admin user
AND p_e.update_dtm     > to_date(:goLiveDtm, 'yyyymmddhh24miss')             -- ds go live date-time
AND p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304)  -- ds dummy patients
;

-- Distinct user (per month)
SELECT to_char(p_pr.update_dtm, 'YYYYMM') update_date, count(distinct p_pr.update_by) no_of_users_px
FROM dxpx_procedure_profile_log p_pr, 
      dxpx_patient_episode p_e 
WHERE p_pr.case_no = p_e.case_no  
AND p_e.update_by NOT IN ('ehradmin', 'admin') -- exclude admin user
AND p_e.update_dtm     > to_date(:goLiveDtm, 'yyyymmddhh24miss')            -- ds go live date-time
AND p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304)  -- ds dummy patients  
group by to_char(p_pr.update_dtm, 'YYYYMM')
order by to_char(p_pr.update_dtm, 'YYYYMM');
  

-- Distinct patient (accumulated)
select count(distinct p_e.patient_key) total_no_of_patients_px
FROM dxpx_procedure_profile_log p_pr, 
      dxpx_patient_episode p_e 
WHERE p_pr.case_no = p_e.case_no  
AND p_e.update_by NOT IN ('ehradmin', 'admin') -- exclude admin user
AND p_e.update_dtm     > to_date(:goLiveDtm, 'yyyymmddhh24miss')            -- ds go live date-time
AND p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304)  -- ds dummy patients
;
  
-- Distinct patient (per month)
SELECT to_char(p_pr.update_dtm, 'YYYYMM') update_date, count(distinct p_e.patient_key) no_of_patients_px
FROM dxpx_procedure_profile_log p_pr, 
      dxpx_patient_episode p_e 
WHERE p_pr.case_no = p_e.case_no  
AND p_e.update_by NOT IN ('ehradmin', 'admin') -- exclude admin user
AND p_e.update_dtm     > to_date(:goLiveDtm, 'yyyymmddhh24miss')            -- ds go live date-time
AND p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304)  -- ds dummy patients  
group by to_char(p_pr.update_dtm, 'YYYYMM')
order by to_char(p_pr.update_dtm, 'YYYYMM');


drop table t_dxpx_dummy_patient_20150304;

