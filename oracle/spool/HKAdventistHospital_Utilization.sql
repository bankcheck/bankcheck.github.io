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

--SAAM
-- Average number of allergy for Patient
select count( distinct patient_key), NKDA, free_text_import, structured_import, structured, allergen_group, free_text_drug, free_text_non_drug, local_drug from (
select sum(case when allergen_type ='N' then 1 else 0 end) as NKDA,
sum(case when allergen_type ='D' then 1 else 0 end) as structured,
sum(case when allergen_type ='G' then 1 else 0 end) as allergen_group,
sum(case when allergen_type ='O' then 1 else 0 end) as free_text_drug,
sum(case when allergen_type ='X' then 1 else 0 end) as free_text_non_drug, 
sum(case when allergen_type ='C' then 1 else 0 end) as free_text_import,
sum(case when allergen_type ='S' then 1 else 0 end) as structured_import,
sum(case when allergen_type ='L' then 1 else 0 end) as local_drug,
patient_key from sa_patient_allergy 
group by patient_key) group by NKDA, structured, allergen_group, free_text_drug, free_text_non_drug, free_text_import, structured_import, local_drug;


-- Average number of allergy for Patient
select no_of_allergy_record, count(distinct patient_key) as no_of_allergy_patient, allergen_type 
from 
(select patient_key, count(distinct(allergy_seq_no)) as no_of_allergy_record, allergen_type from sa_patient_allergy group by patient_key, sa_patient_allergy.ALLERGEN_TYPE) a
group by no_of_allergy_record, allergen_type;

-- Average number of adr for Patient
select no_of_adr_record, count(distinct patient_key) as no_of_adr_patient, display_name_type 
from 
(select patient_key, count(distinct(adr_seq_no)) as no_of_adr_record, display_name_type from sa_patient_adr group by patient_key, display_name_type) a
group by no_of_adr_record, display_name_type;

-- average number of download allergy record per hcr
select count(1), a.ehr_no, to_char(b.create_dtm, 'YYYYMM') from hepr_temp_download_pat_allergy a, hepr_temp_download_pat_status b where a.download_id = b.download_id group by a.ehr_no, to_char(b.CREATE_DTM, 'YYYYMM');

-- average number of download adr record per hcr
select count(1), a.ehr_no, to_char(b.create_dtm, 'YYYYMM') from HEPR_TEMP_DOWNLOAD_PAT_ADR a, hepr_temp_download_pat_status b where a.download_id = b.download_id group by a.ehr_no, to_char(b.CREATE_DTM, 'YYYYMM');

-- No of download per month
select count(1), source, status_code, to_char(create_dtm, 'YYYYMM')  from sa_download_request_status group by status_code, source, to_char(create_dtm, 'YYYYMM'); 

-- Get FeedBack --
select id, feedback_content,  feedback_name, feedback_phone, feedback_email, app_name, sub_app_name, submit_date from  wheel_feedback_detail;


-- No of copied downloaded allergy
select count(1), to_char(trx_dtm, 'YYYYMM') from sa_download_patient_allergy group by to_char(trx_dtm, 'YYYYMM');

-- No of copied downloaded adr
select count(1), to_char(trx_dtm, 'YYYYMM') from sa_download_patient_adr group by to_char(trx_dtm, 'YYYYMM');


-- remarks: remove for half-year utilization statistics by EH2 on 13-Sep-2021
/*
-- For ADR 
select b.drug_reaction_desc, count(a.drug_reaction) as patient_drug_reaction
from sa_patient_adr_reaction a, sa_adr_common_reaction b
where a.drug_reaction = b.reaction_seq_no
group by b.drug_reaction_desc;
*/

-- System Setting
select param_name, param_value from sa_system_setting;

-- SAAM local drug
select allergen_id, hk_reg_no, vtm, trade_name, former_ban, abbreviation, other_name, update_dtm, generic_product_ind from sa_drug_local;

-- SAAM patient with Allergy local drug
select allergy_seq_no, allergy_code, allergen_type, display_name, display_name_type, vtm, tradename, former_ban, abbreviation, other_name, certainty, remark,create_dtm, update_dtm from sa_patient_allergy where allergen_type='L';
-- SAAM patient with ADR local drug
select adr_seq_no, drug_code, drug_desc, display_name_type, vtm, tradename, former_ban, abbreviation, other_name, severity, create_dtm, update_dtm, remark, adr_type from sa_patient_adr where adr_type='L';

-- For Patient Allergy Record (Data Import Record):
select to_char( update_dtm,'yyyy') as "year", to_char(update_dtm,'mm') as "month", 
       count(distinct allergy_seq_no) as "waiting_to_convert"
from sa_patient_allergy 
where (allergen_type is not null and allergen_type in ('C', 'S'))
group by to_char( update_dtm,'yyyy'), to_char(update_dtm,'mm')
order by to_char( update_dtm,'yyyy') asc, to_char(update_dtm,'mm') asc;

-- For Patient Allergy Record (Data Input by SAAM):
select to_char(update_dtm,'yyyy') as "year", to_char(update_dtm,'mm') as "month", 
       count(distinct allergy_seq_no) as "no_of_allergy_record",
       count(distinct patient_key) as "patient_count", 
       count(distinct update_user_id) as "user_count"
from sa_patient_allergy 
where (allergen_type is null or allergen_type not in ('C', 'S'))
group by to_char(update_dtm,'yyyy'), to_char(update_dtm,'mm')
order by to_char(update_dtm,'yyyy') asc, to_char(update_dtm,'mm') asc;

-- For Patient Allergy Record (NKDA Record) :
select to_char(update_dtm,'yyyy') as "year", to_char(update_dtm,'mm') as "month", 
       count(distinct allergy_seq_no) as "no_of_nkda_record",
       count(distinct patient_key) as "patient_count", 
       count(distinct update_user_id) as "user_count"
from sa_patient_allergy 
where allergen_type = 'N'
group by to_char(update_dtm,'yyyy'), to_char(update_dtm,'mm')
order by to_char(update_dtm,'yyyy') asc, to_char(update_dtm,'mm') asc;

-- For Patient ADR Record (Data import Record):
select to_char(update_dtm,'yyyy') as "year", to_char(update_dtm,'mm') as "month", 
       count(distinct adr_seq_no) as "waiting_to_convert",
       count(distinct patient_key) as "patient_count", 
       count(distinct update_user_id) as "user_count"
from sa_patient_adr 
where (adr_type is not null and adr_type in ('C', 'S'))
group by to_char(update_dtm,'yyyy'), to_char(update_dtm,'mm')
order by to_char(update_dtm,'yyyy') asc, to_char(update_dtm,'mm') asc;

-- For Patient ADR Record (Data import by SAAM):
select to_char(update_dtm,'yyyy') as "year", to_char(update_dtm,'mm') as "month", 
       count(distinct adr_seq_no) as "no_of_adr_record",
       count(distinct patient_key) as "patient_count", 
       count(distinct update_user_id) as "user_count"
from sa_patient_adr 
where (adr_type is null or adr_type not in ('C', 'S'))
group by to_char(update_dtm,'yyyy'), to_char(update_dtm,'mm')
order by to_char(update_dtm,'yyyy') asc, to_char(update_dtm,'mm') asc;

-- For Patient Alert Record (Data Import Record):
select to_char(update_dtm,'yyyy') as "year", to_char(update_dtm,'mm') as "month", 
       count(distinct alert_seq_no ) as "no_of_alert_record",
       count(distinct patient_key) as "patient_count", 
       count(distinct update_user_id) as "user_count"
from sa_patient_alert
where (alert_type is not null and alert_type in ('C', 'S'))
group by to_char(update_dtm,'yyyy'), to_char(update_dtm,'mm')
order by to_char(update_dtm,'yyyy') asc, to_char(update_dtm,'mm') asc;

-- For Patient Alert Record (Data Input by SAAM):
select to_char(update_dtm,'yyyy') as "year", to_char(update_dtm,'mm') as "month", 
       count(distinct alert_seq_no ) as "no_of_alert_record",
       count(distinct patient_key) as "patient_count", 
       count(distinct update_user_id) as "user_count"
from sa_patient_alert
where (alert_type is null or alert_type not in ('C', 'S'))
group by to_char(update_dtm,'yyyy'), to_char(update_dtm,'mm')
order by to_char(update_dtm,'yyyy') asc, to_char(update_dtm,'mm') asc;

-- Get total number of distinct patient in all patient Allergy record
select count(distinct patient_key) from sa_patient_allergy where update_dtm < trunc(sysdate,'MM');

-- Get total number of distinct patient in patient Allergy record not from Data Import
select count(distinct patient_key) from sa_patient_allergy where (allergen_type is not null and allergen_type not in ('C', 'S')) and update_dtm < trunc(sysdate,'MM');

-- Get total number of distinct patient in all patient ADR record
select count(distinct patient_key) from sa_patient_adr where update_dtm < trunc(sysdate,'MM');

-- Get total number of distinct patient in patient ADR record not from Data Import
select count(distinct patient_key) from sa_patient_adr where (adr_type is null or adr_type not in ('C', 'S')) and update_dtm < trunc(sysdate,'MM');

-- Get total number of distinct patient in all patient Alert record
select count(distinct patient_key) from sa_patient_alert where update_dtm < trunc(sysdate,'MM');

-- Get total number of distinct patient in patient Alert record not from Data Import
select count(distinct patient_key) from sa_patient_alert where (alert_type is null or alert_type not in ('C', 'S')) and update_dtm < trunc(sysdate,'MM');

-- Get distinct user and patient
select count(distinct update_user_id) as distinct_user, count(distinct patient_key) as distinct_patient_key
from (
select distinct update_user_id, patient_key from sa_patient_allergy where update_dtm < trunc(sysdate,'MM')
union
select distinct update_user_id, patient_key from sa_patient_adr where update_dtm < trunc(sysdate,'MM')
union
select distinct update_user_id, patient_key from sa_patient_alert where update_dtm < trunc(sysdate,'MM')) aa;


-- Added by EH2 on 26-Aug-2020
-- Cumulative distinct user for allergy
select count(distinct update_user_id) as distinct_user, count(distinct patient_key) as distinct_patient_key
from (
select distinct update_user_id, patient_key from sa_patient_allergy where update_dtm < trunc(sysdate,'MM')
) aa;


-- Added by EH2 on 26-Aug-2020
-- Cumulative distinct user for ADR
select count(distinct update_user_id) as distinct_user, count(distinct patient_key) as distinct_patient_key
from (
select distinct update_user_id, patient_key from sa_patient_adr where update_dtm < trunc(sysdate,'MM')
) aa;


-- Added by EH2 on 26-Aug-2020
-- Cumulative distinct user for alert
select count(distinct update_user_id) as distinct_user, count(distinct patient_key) as distinct_patient_key
from (
select distinct update_user_id, patient_key from sa_patient_alert where update_dtm < trunc(sysdate,'MM')
) aa;


-- Get Re-confirm NKDA count
select to_char( update_dtm,'yyyy') as "year", to_char(update_dtm,'mm') as "month", count (allergy_seq_no) as no_of_reconfirm_nkda 
from sa_patient_allergy_log where trx_type='U' and allergen_type='N'
group by to_char( update_dtm,'yyyy'), to_char(update_dtm,'mm'), update_user_id
order by to_char( update_dtm,'yyyy') asc, to_char(update_dtm,'mm') asc;

-- Number of different Patient Allergy Record Type Summary
select data_type, count(1) as result_count
from(select 
case when (allergen_type is not null and allergen_type in ('C', 'S')) then 'dataImport'
     when (allergen_type is not null and allergen_type = 'X') then 'freeTextNonDrug'
     when (allergen_type is not null and allergen_type = 'O') then 'freeTextDrug'
     when (allergen_type is not null and allergen_type = 'L') then 'localAllergen'
	 when (allergen_type is not null and allergen_type = 'N') then 'NKDA'
else 'hkmtt' end as data_type, allergy_seq_no 
from sa_patient_allergy where update_dtm < trunc(sysdate,'MM')) a
group by data_type
order by data_type;

-- Number of different Patient ADR Record Type Summary
select data_type, count(1) as result_count
from(select 
case when (adr_type is not null and adr_type in ('C', 'S')) then 'dataImport'
     when (adr_type is not null and adr_type = 'L') then 'localAllergen'
     when (adr_type is null and display_name_type is not null) then 'hkmtt'
else 'freeText' end as data_type, adr_seq_no 
from sa_patient_adr where update_dtm < trunc(sysdate,'MM')) a
group by data_type
order by data_type;


-- Added by EH2 on 26-Aug-2020
-- Number of different Patient Alert Record Type Summary
select data_type, count(1) as result_count
from(select 
case when alert_type is not null and alert_type in ('C', 'S') then 'dataImport'
     when alert_code is null then 'freeText'
else 'localAlert' end as data_type, alert_seq_no 
from sa_patient_alert where update_dtm < trunc(sysdate,'MM')) a
group by data_type
order by data_type;


-- Top 10 of the Patient Allergy Name (VTM)
select display_name, count(1) result_count from(
SELECT 
case when (pa.allergen_type = 'D') then
    -- ALLERGEN_TYPE_DRUG_ALLERGY Or Local drug
    cast( case when pa.display_name_type = 'V' then case when (instr(pa.vtm, '+')>0 and length(pa.tradename)>0) then (pa.tradename || ' (' || pa.vtm || ')') else pa.vtm end else
    case when pa.display_name_type = 'T' then (pa.tradename || ' (' || pa.vtm  || ')') else
    case when pa.display_name_type = 'B' then case when instr(pa.vtm, '+')>0 then case when length(pa.tradename)>0 then (pa.tradename || ' (' || pa.vtm  || ')') else (pa.tradename || ' (' || pa.vtm || ')') end else (pa.former_ban || ' ('|| pa.vtm ||  ')') end else
    case when pa.display_name_type = 'A' then (pa.abbreviation || ' ('  || pa.vtm || ')') else
    case when pa.display_name_type = 'O' then (pa.other_name || ' (' || pa.vtm || ')') else
    case when pa.display_name_type = 'G' then pa.vtm else
    null end end end end end end AS NVARCHAR2(2000))
else
pa.display_name
end 
display_name
FROM sa_patient_allergy pa
where 
pa.allergen_type in ('D','G'))
group by display_name order by result_count desc;

-- Top 10 of the Patient ADR Name (VTM)
select drug_desc, count(1) result_count from(
SELECT
case when pa.drug_desc is null then
    -- adr_type_structured ADR or local drug
    cast(case when pa.display_name_type = 'V' then case when (instr(pa.vtm, '+')>0 and length(pa.tradename)>0) then (pa.tradename || ' ('  || pa.vtm || ')') else pa.vtm end else
    case when pa.display_name_type = 'T' then (pa.tradename || ' (' || pa.vtm || ')') else
    case when pa.display_name_type = 'B' then case when instr(pa.vtm, '+')>0  then case when length(pa.tradename)>0 then (pa.tradename || ' (' || pa.vtm || ')') else (pa.tradename || ' (' || pa.vtm || ')') end else (pa.former_ban || ' (' || pa.vtm || ')') end else
    case when pa.display_name_type = 'A' then (pa.abbreviation || ' (' || pa.vtm || ')') else
    case when pa.display_name_type = 'O' then (pa.other_name || ' (' || pa.vtm || ')') else
    null end end end end end AS NVARCHAR2(2000))
else
pa.drug_desc
end 
drug_desc
FROM sa_patient_adr pa
where 
pa.adr_type is null and pa.drug_code is not null)
group by drug_desc order by result_count desc;

-- Top 10 of the Patient Alert
select alert_desc, count(1)result_count from
(select b.alert_desc alert_desc from sa_patient_alert a, sa_alert b
where a.alert_code = b.alert_code) c
group by c.alert_desc order by result_count desc;


-- Added by EH2 on 26-Aug-2020
-- Classified count for Alert
select 'No. of Classified Alert', count(classified_indicator) from sa_patient_alert where classified_indicator = 'Y';


-- Free Text Allergy Possibble Value 
--select distinct display_name, allergen_type, count(1) as free_text_allergy_count from sa_patient_allergy where allergen_type in ('X', 'O') group by display_name, allergen_type;
select display_name, allergen_type,manifestation, certainty, count(*) as count
from (
select distinct a.allergy_seq_no, a.display_name, a.allergen_type, a.certainty,
LISTAGG(c.manifestation_desc, ',') WITHIN GROUP (ORDER BY b.manifestation_seq_no ASC) as manifestation
from sa_patient_allergy a, sa_patient_allergy_manifest b, sa_manifestation c
where a.allergy_seq_no = b.allergy_seq_no and b.manifestation_seq_no = c.manifestation_seq_no
and   allergen_type in ('X', 'O')
group by a.allergy_seq_no, a.display_name, a.allergen_type, a.certainty) a
group by display_name, allergen_type,manifestation, certainty;

-- Free Text ADR Possibble Value 
select distinct drug_desc, count(1) as free_text_adr_count from sa_patient_adr where adr_type is null and display_name_type is null group by drug_desc;

-- Free Text Alert Possibble Value 
select distinct alert_desc, count(1) as free_text_alert_count from sa_patient_alert where alert_code is null and create_dtm >= to_date('20161201000000', 'yyyymmddhh24miss') group by alert_desc;

-- remarks: remove for half-year utilization statistics by EH2 on 13-Sep-2021
/*
-- Obsoleted HKMTT allergy record
select vtm, affected_desc, case when display_name_type = 'V' then 'VTM' when display_name_type = 'T' then 'Trade Name' when display_name_type = 'A' then 'Abbreviation' when display_name_type = 'O' then 'Other Name' when display_name_type = 'B' then 'Former BAN' else display_name_type end as affected_type, count(*) as record_count
from (
select vtm, null as affected_desc, display_name_type from sa_patient_allergy
where allergen_type not in ('C', 'S', 'X', 'O', 'N', 'L')
and display_name_type = 'V' and not exists (select 1 from sa_allergen_list where vtm = sa_patient_allergy.vtm)
union all
select vtm, tradename as affected_desc, display_name_type from sa_patient_allergy
where allergen_type not in ('C', 'S', 'X', 'O', 'N', 'L')
and display_name_type = 'T' and not exists (select 1 from sa_allergen_list where vtm = sa_patient_allergy.vtm and trade_name = sa_patient_allergy.tradename)
union all
select vtm, abbreviation as affected_desc, display_name_type from sa_patient_allergy
where allergen_type not in ('C', 'S', 'X', 'O', 'N', 'L')
and display_name_type = 'A' and not exists (select 1 from sa_allergen_list where vtm = sa_patient_allergy.vtm and abbreviation = sa_patient_allergy.abbreviation)
union all
select vtm, other_name as affected_desc, display_name_type from sa_patient_allergy
where allergen_type not in ('C', 'S', 'X', 'O', 'N', 'L')
and display_name_type = 'O' and not exists (select 1 from sa_allergen_list where vtm = sa_patient_allergy.vtm and other_name = sa_patient_allergy.other_name)
union all
select vtm, former_ban as affected_desc, display_name_type from sa_patient_allergy
where allergen_type not in ('C', 'S', 'X', 'O', 'N', 'L')
and display_name_type = 'B' and not exists (select 1 from sa_allergen_list where vtm = sa_patient_allergy.vtm and former_ban = sa_patient_allergy.former_ban)
) a
group by vtm, affected_desc, display_name_type
order by count(*) desc;

-- Obsoleted HKMTT ADR record
select vtm, affected_desc, affected_type, count(*) as record_count
from (
select vtm, null as affected_desc, case when display_name_type = 'V' then 'VTM' when display_name_type = 'T' then 'Trade Name' when display_name_type = 'A' then 'Abbreviation' when display_name_type = 'O' then 'Other Name' when display_name_type = 'B' then 'Former BAN' else display_name_type end as affected_type from sa_patient_adr
where adr_type is null and display_name_type is not null 
and display_name_type = 'V' and not exists (select 1 from sa_allergen_list where vtm = sa_patient_adr.vtm)
union all
select vtm, tradename as affected_desc, case when display_name_type = 'V' then 'VTM' when display_name_type = 'T' then 'Trade Name' when display_name_type = 'A' then 'Abbreviation' when display_name_type = 'O' then 'Other Name' when display_name_type = 'B' then 'Former BAN' else display_name_type end as affected_type from sa_patient_adr
where adr_type is null and display_name_type is not null 
and display_name_type = 'T' and not exists (select 1 from sa_allergen_list where vtm = sa_patient_adr.vtm and trade_name = sa_patient_adr.tradename)
union all
select vtm, abbreviation as affected_desc, case when display_name_type = 'V' then 'VTM' when display_name_type = 'T' then 'Trade Name' when display_name_type = 'A' then 'Abbreviation' when display_name_type = 'O' then 'Other Name' when display_name_type = 'B' then 'Former BAN' else display_name_type end as affected_type from sa_patient_adr
where adr_type is null and display_name_type is not null 
and display_name_type = 'A' and not exists (select 1 from sa_allergen_list where vtm = sa_patient_adr.vtm and abbreviation = sa_patient_adr.abbreviation)
union all
select vtm, other_name as affected_desc, case when display_name_type = 'V' then 'VTM' when display_name_type = 'T' then 'Trade Name' when display_name_type = 'A' then 'Abbreviation' when display_name_type = 'O' then 'Other Name' when display_name_type = 'B' then 'Former BAN' else display_name_type end as affected_type from sa_patient_adr
where adr_type is null and display_name_type is not null 
and display_name_type = 'O' and not exists (select 1 from sa_allergen_list where vtm = sa_patient_adr.vtm and other_name = sa_patient_adr.other_name)
union all
select vtm, former_ban as affected_desc, case when display_name_type = 'V' then 'VTM' when display_name_type = 'T' then 'Trade Name' when display_name_type = 'A' then 'Abbreviation' when display_name_type = 'O' then 'Other Name' when display_name_type = 'B' then 'Former BAN' else display_name_type end as affected_type from sa_patient_adr
where adr_type is null and display_name_type is not null 
and display_name_type = 'B' and not exists (select 1 from sa_allergen_list where vtm = sa_patient_adr.vtm and former_ban = sa_patient_adr.former_ban)
) a
group by vtm, affected_desc, affected_type
order by count(*) desc;

-- Obtain the SAAM additional information
select a.remark, a.clinical_manifestation, count(1) as allergy_remark_count from 
(select allergy_seq_no, remark, clinical_manifestation from sa_patient_allergy_log a where remark is not null group by remark, clinical_manifestation, allergy_seq_no) a
group by a.remark, a.clinical_manifestation;


select a.remark, a.reaction, count(1) as adr_remark_count from 
(select remark, reaction, adr_seq_no from sa_patient_adr_log where remark is not null group by remark, reaction, adr_seq_no) a
group by a.remark, a.reaction ;

select remark, count(1) as alert_remark_count from sa_patient_alert_log where remark is not null group by remark;

-- number of auto download
select count(1) as auto_download from sa_audit_log where log_type_id='00031';

-- number of manual download
select count(1) as manual_download from sa_audit_log where log_type_id='00017';

-- number of edit local allergy record from download record
select count(1) as edit_local_allergy from sa_audit_log where log_type_id='00027';

-- number of new added allergy record from download record
select count(1) as added_allergy from sa_audit_log where log_type_id='00019';

-- number of new added ADR record from download record
select count(1) as added_adr from sa_audit_log where log_type_id='00021';

-- number of edit ADR record from download record
select count(1) as edit_allergy from sa_audit_log where log_type_id='00029';
*/

-- average number of download allergy record per hcr
select count(1) as allergy_download_count, ehr_no from hepr_temp_download_pat_allergy group by ehr_no;

-- average number of download adr record per hcr
select count(1) as adr_download_count, ehr_no from hepr_temp_download_pat_adr group by ehr_no;

-- ----------------------------------
-- DXPX system setting
-- ----------------------------------
SELECT config_name, config_value 
FROM dxpx_app_config 
where config_name in ( 'searchingHeader'  ,  'searchingICD10' , 'searchingICPC2' ,  'elsaVersionId', 'systemMessagePrintEnabled');

select diagnosis_recordno_ctrl , procedure_recordno_ctrl , diagnosis_freetext_ctrl, procedure_freetext_ctrl   from dxpx_hospital;

-------------------------
--No of discharge summary
-------------------------
-- calculate the no of discharge summary done per month
select to_char(a.update_dtm,'YYYYMM') update_date, (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status, count(1) no_of_ds
from csds_summary a, ds_discharge_summary b
where a.summary_id = b.summary_id
--***
and a.update_by not in ('ehradmin', 'admin')  -- exclude non-user
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(a.update_dtm,'YYYYMM'), (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end)
order by to_char(a.update_dtm,'YYYYMM'), (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end);

-- calculate the no of discharge summary done per month (for transaction)
select update_date, (case U.STATUS when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status, no_of_trans from 
(
select TO_CHAR(A.UPDATE_DTM,'YYYYMM') update_date, 
A.STATUS, count(*) no_of_trans
from ds_discharge_summary_log a
--***
where a.update_by not in ('ehradmin', 'admin')  -- exclude non-user
and (a.status = 0 or a.status = 2)
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by TO_CHAR(A.UPDATE_DTM,'YYYYMM'), A.STATUS
union
select to_char(a.update_dtm,'YYYYMM') update_date, 
A.STATUS, (count(*)/2) no_of_trans
from ds_discharge_summary_log a
--***
where a.update_by not in ('ehradmin', 'admin')  -- exclude non-user
and a.status = 3
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by TO_CHAR(A.UPDATE_DTM,'YYYYMM'), A.STATUS
) u
order by U.UPDATE_DATE, (case U.STATUS when 0 then 'DELETE' when 2 then 'DRAFT' WHEN 3 THEN 'SIGNOFF' end);


---------------
--No of episode
---------------
-- calculate the no of episode by month (created date)
select to_char(a.create_dtm,'YYYYMM') create_dtm, (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status, count(1) no_of_episode
from csds_summary a, ds_discharge_summary b
where a.summary_id = b.summary_id
--***
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(a.create_dtm,'YYYYMM'), (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end)
order by to_char(a.create_dtm,'YYYYMM'), (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end);

-- calculate the total no of episode
select count(distinct episode_no) total_no_of_episode
from csds_summary a, ds_discharge_summary b
where a.summary_id = b.summary_id
--***
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
;

---------------
--No of patient
---------------
-- calculate the no of patient per month (update date)
SELECT to_char(b.update_dtm,'YYYYMM') update_date, count(distinct a.patient_id) no_of_patient
FROM csds_patient a, csds_summary b, ds_discharge_summary c
where a.patient_id = b.patient_id
and b.summary_id = c.summary_id
--***
and b.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and b.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(b.update_dtm,'YYYYMM')
order by to_char(b.update_dtm,'YYYYMM');

-- calculate the no of patient by month (created date)
select to_char(a.create_dtm,'YYYYMM') create_dtm,count(distinct a.patient_id) no_of_patient 
FROM csds_patient a, csds_summary b, ds_discharge_summary c
where a.patient_id = b.patient_id
and b.summary_id = c.summary_id
--***
and b.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and b.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(a.create_dtm,'YYYYMM')
order by to_char(a.create_dtm,'YYYYMM');

-- calculate the total no of patient
select count(distinct a.patient_id) total_no_of_patient 
FROM csds_patient a, csds_summary b, ds_discharge_summary c
where a.patient_id = b.patient_id
--***
and b.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and b.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
and b.summary_id = c.summary_id;


----------------------
--No of user and login
----------------------
-- calculate the no of user per month
SELECT to_char(b.update_dtm,'YYYYMM') update_date, count(distinct b.update_by) no_of_users
FROM csds_patient a, csds_summary b, ds_discharge_summary c
where a.patient_id = b.patient_id
and b.summary_id = c.summary_id
--***
and b.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and b.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(b.update_dtm,'YYYYMM')
order by to_char(b.update_dtm,'YYYYMM');

-- calculate the total no of user
SELECT count(distinct b.update_by) total_no_of_users
FROM csds_patient a, csds_summary b, ds_discharge_summary c
where a.patient_id = b.patient_id
and b.summary_id = c.summary_id
--***
and b.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and b.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
;

-- calculate the no of login and logout by action date per month
select to_char(a.action_datetime,'YYYYMM') action_date, b.log_description, a.login_id, count(1) 
from ac_audit_log a, ac_audit_log_type b
where a.log_type_id = b.log_type_id
and b.log_component = 'DS'
--***
and a.login_id not in ('ehradmin', 'admin')  -- exclude admin user
and a.action_datetime > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(a.action_datetime,'YYYYMM'), b.log_description, a.login_id
order by to_char(a.action_datetime,'YYYYMM'), b.log_description, a.login_id;


----------------------
--No of discharge note
----------------------
-- calculate the no of record for discharge note
select to_char(a.update_dtm,'YYYYMM') update_date, (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status, count(1) no_discharge_note
from ds_discharge_note a, csds_summary b
where a.free_text_id = b.summary_id
and a.content is not null
--***
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(a.update_dtm,'YYYYMM'), (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end)
order by to_char(a.update_dtm,'YYYYMM'), (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end);

--------------------------
--No of plan of management
--------------------------
-- calculate the no of record for plan of management
select to_char(a.update_dtm,'YYYYMM') update_date, (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status,count(1) no_plan_of_management
from ds_plan_of_management a, csds_summary b
where a.free_text_id = b.summary_id
and a.content is not null
--***
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(a.update_dtm,'YYYYMM'), (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end)
order by to_char(a.update_dtm,'YYYYMM'), (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end);

--------------
--No of remark
--------------
-- calculate the no of record for remark
select to_char(a.update_dtm,'YYYYMM') update_date, (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status,count(1) no_remark
from ds_remark a, csds_summary b
where a.free_text_id = b.summary_id
and a.content is not null
--***
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(a.update_dtm,'YYYYMM'), (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end)
order by to_char(a.update_dtm,'YYYYMM'), (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end);

-------------------
--No of appointment
-------------------
-- calculate the no of record for appointment
select to_char(a.update_dtm,'YYYYMM') update_date, (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status,count(1) no_appointment
from ds_appointment a, csds_summary b
where a.discharge_summary_id = b.summary_id
and (a.appt_dtm is not null or a.appointmenttime is not null or a.follow_up_doctor_id is not null or a.hospital_code is not null)
--***
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(a.update_dtm,'YYYYMM'), (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end)
order by to_char(a.update_dtm,'YYYYMM'), (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end);

---------------------
--No of investigation
---------------------
-- calculate the no of record for investigation
select to_char(a.update_dtm,'YYYYMM') update_date, (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status, count(1) no_investigation
from ds_investigation a, csds_summary b
where a.discharge_summary_id = b.summary_id
and (a.test is not null or a.investigation_date is not null)
--***
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(a.update_dtm,'YYYYMM'), (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end)
order by to_char(a.update_dtm,'YYYYMM'), (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end);

-----------------------
--No of local moe order
-----------------------
-- calculate the no of record for local moe order
select to_char(a.update_dtm,'YYYYMM') update_date, (case d.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status, count(1) no_local_moe
from csds_local_edit_medication a, csds_prescription b,  ds_discharge_summary c, csds_summary d
where a.prescription_id  = b.prescription_id
and c.summary_id = b.prescription_id
and d.summary_id = b.prescription_id
and drug_description is not null
--***
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
--***
group by to_char(a.update_dtm,'YYYYMM'), (case d.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end)
order by to_char(a.update_dtm,'YYYYMM'), (case d.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end);


----------------------------------
--No of Diagnosis (structured)
----------------------------------
-- calculate the no. of reccord for structured diagnosis
SELECT to_char(p_e.update_dtm,'YYYYMM') update_date,
	(
	CASE d_pg.dx_status 
		WHEN 'C' 
		THEN 'DELETE' 
		ELSE (
			CASE p_e.status_id 
				WHEN 'D' 
				THEN 'DRAFT' 
				WHEN 'S' 
				THEN 'SIGNOFF' 
			END) 
	END) AS  status,
	COUNT(d_pr.term_id ) AS  no_structured_diagnosis
FROM dxpx_patient_episode p_e,
		 dxpx_diagnosis_profile d_pr,
		 dxpx_diagnosis_progress d_pg 
WHERE d_pr.dx_profile_seq = d_pg.dx_profile_seq
AND d_pg.case_no = p_e.case_no
AND p_e.episode_type_id = 'I'
AND d_pg.isfreetext = 'N'
	--***
AND p_e.update_by not in ('ehradmin', 'admin')  -- exclude admin user
AND p_e.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
	--***
GROUP BY to_char(p_e.update_dtm,'YYYYMM'), 
	(
	CASE d_pg.dx_status 
		WHEN 'C' 
		THEN 'DELETE' 
		ELSE (
				 CASE p_e.status_id 
					 WHEN 'D' 
					 THEN 'DRAFT' 
					 WHEN 'S' 
					 THEN 'SIGNOFF' 
				 END) 
	END)
ORDER BY update_date, status;


----------------------------------
--No of Diagnosis (freetext)
----------------------------------
-- calculate the no. of reccord for freetext diagnosis
SELECT to_char(p_e.update_dtm,'YYYYMM') update_date,
	(
	CASE d_pg.dx_status 
		WHEN 'C' 
		THEN 'DELETE' 
		ELSE (
			CASE p_e.status_id 
				WHEN 'D' 
				THEN 'DRAFT' 
				WHEN 'S' 
				THEN 'SIGNOFF' 
			END) 
	END) AS  status,
	COUNT(d_pr.term_id ) AS  no_freetext_diagnosis
FROM dxpx_patient_episode p_e,
		 dxpx_diagnosis_profile d_pr,
		 dxpx_diagnosis_progress d_pg 
WHERE d_pr.dx_profile_seq = d_pg.dx_profile_seq
AND d_pg.case_no = p_e.case_no
AND p_e.episode_type_id = 'I'
AND d_pg.isfreetext = 'Y'
	--***
AND p_e.update_by not in ('ehradmin', 'admin')  -- exclude admin user
AND p_e.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
	--***
GROUP BY to_char(p_e.update_dtm,'YYYYMM'), 
	(
	CASE d_pg.dx_status 
		WHEN 'C' 
		THEN 'DELETE' 
		ELSE (
				 CASE p_e.status_id 
					 WHEN 'D' 
					 THEN 'DRAFT' 
					 WHEN 'S' 
					 THEN 'SIGNOFF' 
				 END) 
	END)
ORDER BY update_date, status;


----------------------------------
--No of Procedure (structured)
----------------------------------
-- calculate the no. of reccord for structured procedure
SELECT to_char(p_e.update_dtm,'YYYYMM') update_date,
	(
		CASE p_pr.px_status 
			WHEN 'C' 
			THEN 'DELETE' 
			ELSE (
					 CASE p_e.status_id 
						 WHEN 'D' 
						 THEN 'DRAFT' 
						 WHEN 'S' 
						 THEN 'SIGNOFF' 
					 END) 
	END) AS status,
	COUNT(p_pr.term_id ) AS  no_structured_procedure
FROM dxpx_procedure_profile p_pr, 
		dxpx_patient_episode p_e 
WHERE p_pr.case_no = p_e.case_no
AND p_e.episode_type_id = 'I' 
AND p_pr.isfreetext = 'N'
	--***
AND p_e.update_by not in ('ehradmin', 'admin')  -- exclude admin user
AND p_e.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
	--***
GROUP BY to_char(p_e.update_dtm,'YYYYMM'), 
	(CASE p_pr.px_status 
		 WHEN 'C' 
		 THEN 'DELETE' 
		 ELSE (
					CASE p_e.status_id 
						WHEN 'D' 
						THEN 'DRAFT' 
						WHEN 'S' 
						THEN 'SIGNOFF' 
					END) 
	END) 
ORDER BY update_date, status;


----------------------------------
--No of Procedure (freetext)
----------------------------------
-- calculate the no. of reccord for freetext procedure
SELECT to_char(p_e.update_dtm,'YYYYMM') update_date,
	(
		CASE p_pr.px_status 
			WHEN 'C' 
			THEN 'DELETE' 
			ELSE (
					 CASE p_e.status_id 
						 WHEN 'D' 
						 THEN 'DRAFT' 
						 WHEN 'S' 
						 THEN 'SIGNOFF' 
					 END) 
	END) AS status,
	COUNT(p_pr.term_id ) AS  no_freetext_procedure
FROM dxpx_procedure_profile p_pr, 
		dxpx_patient_episode p_e 
WHERE p_pr.case_no = p_e.case_no
AND p_e.episode_type_id = 'I' 
AND p_pr.isfreetext = 'Y'
	--***
AND p_e.update_by not in ('ehradmin', 'admin')  -- exclude admin user
AND p_e.update_dtm > to_date('20130916150000', 'yyyymmddhh24miss') -- ds go live date-time: 2013/09/16 15:00:00
	--***
GROUP BY to_char(p_e.update_dtm,'YYYYMM'), 
	(CASE p_pr.px_status 
		 WHEN 'C' 
		 THEN 'DELETE' 
		 ELSE (
					CASE p_e.status_id 
						WHEN 'D' 
						THEN 'DRAFT' 
						WHEN 'S' 
						THEN 'SIGNOFF' 
					END) 
	END) 
ORDER BY update_date, status;

-- system configuration
select system_config_id,app_code,config_group,frontend,config_key,remark,value 
from ac_system_config 
where app_code='DS';

select system_config_id,hospital_code,config_group,config_key,value,allow_update_on_maint,remark,optlock,create_by,create_by_ehrid,create_dtm,update_by,update_by_ehrid,update_dtm 
from ds_system_config;

-- hospital info
select hospital_code, hospital_name, barcode_format, update_by, update_dtm 
from ac_hospital;

-- component info
select component_id,component_name,default_height,default_width,in_form,in_pdf,minimum_height,minimum_width,status,update_by,update_dtm,free_text_note,pdf_component_name 
from ds_component 
where status = 1;

-- component selected usage
(select p.perspective_id, p.hospital_code, (select clinician_code from ac_clinician where clinician_id = p.clinician_id) as clinician_code, p.perspective_name,  cs.component_id, cs.position, cs.sequence, cs.height, cs.width, cs.update_by, cs.update_dtm 
from ds_component_selected cs, ds_component c, ds_perspective p 
where cs.component_id = c.component_id and cs.perspective_id = p.perspective_id and p.hospital_code IS NOT NULL and c.status = 1 ) 
order by p.perspective_id, cs.position, cs.sequence asc;

-- item info
select item_id,default_display,default_print,display_compulsory,display_item_seq,edit_item_name,item_alias,item_name,item_type,print_compulsory,print_item_seq,status,update_by,update_dtm,component_id,display_sign_in_pdf,display_sign_in_patient_pdf 
from ds_item 
where status = 1;

-- item selected usage
(select i.component_id, its.display_item_seq, its.print_item_seq, i.item_alias, i.item_name, its.custom_item_name, (case its.display_item when 0 then 'DISABLE' when 1 then 'ENABLE' end) as display_item, (case its.print_item when 0 then 'DISABLE' when 1 then 'ENABLE' end) as print_item, its.update_by, its.update_dtm 
from ds_item_selected its, ds_item i 
where its.item_id = i.item_id and i.status = 1 and its.hospital_code IS NOT NULL ) 
order by i.component_id, its.display_item_seq asc;

-- Total number of Group template
select (select clinician_code from ac_clinician where clinician_id = t.clinician_id) as clinician_code, count(*) as Total 
from ds_grp_template t 
group by t.clinician_id;

-- Total number of dataset template
select (select clinician_code from ac_clinician where clinician_id = t.clinician_id) as clinician_code, count(*) as Total 
from ds_discharge_note_template t 
group by t.clinician_id;

select (select clinician_code from ac_clinician where clinician_id = t.clinician_id) as clinician_code, count(*) as Total 
from ds_plan_template t 
group by t.clinician_id;

select (select clinician_code from ac_clinician where clinician_id = t.clinician_id) as clinician_code, count(*) as Total 
from ds_remark_template t 
group by t.clinician_id;

select (select clinician_code from ac_clinician where clinician_id = t.clinician_id) as clinician_code, count(*) as Total 
from ds_investigation_set t 
group by t.clinician_id;

-- Access control usage
select uac.profile_id, uac.profile_name, ac.display_item_group, ac.display_item_seq, ac.display_item, (case uac.permission_status when 0 then 'DISABLE' when 1 then 'ENABLE' end) as permission_status, uac.create_by, uac.create_dtm, uac.update_by, uac.update_dtm 
from ds_user_access_control uac, ds_access_control ac 
where uac.access_control_id = ac.access_control_id and uac.profile_status='A' and ac.status=1 
order by uac.profile_id, ac.display_item_group_seq, ac.display_item_seq asc;

-- View Type of Discharge Summary usage
select distinct(ds.view_type) 
from ds_discharge_summary ds, csds_summary csds 
where ds.summary_id = csds.summary_id;

-- View Group of Discharge Summary usage
select distinct(ds.view_group) 
from ds_discharge_summary ds, csds_summary csds 
where ds.summary_id = csds.summary_id;

-- Discharge Summary with MRO usage
select distinct(ds.created_by_mro) 
from ds_discharge_summary ds, csds_summary csds 
where ds.summary_id = csds.summary_id;

-- LAAM System Setting --
select param_name, param_value 
from hepr_system_setting where param_name not in ('ehr_cert_mark','encrypt_sftp_log_password', 'ks_constant', 'pmi_external_ks_constant', 'rpt_decrypt_password', 'sftp_passphrase', 'sftp_password');

select domain_id, param_name, param_value 
from hepr_domain_info where param_name not in ('cs_ws_password', 'ds_ws_password', 'encrypt_zip_password', 'ws_password');

select * from hepr_domain_setting;

select * from hepr_report_setting;

-- check any duplicate batch in LAAM
SELECT * FROM hepr_batch b1 , hepr_batch b2 where b1.batch_id <  b2.batch_id and b1.create_dtm = b2.create_dtm and b1.record_type = b2.record_type;