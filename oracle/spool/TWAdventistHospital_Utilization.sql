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


-- No of download per month
select count(1), source, status_code, to_char(create_dtm, 'YYYYMM') from sa_download_request_status group by source, status_code, to_char(create_dtm, 'YYYYMM');

-- number of edit local allergy record from download record
select count(1), to_char(action_datetime, 'YYYYMM') from sa_audit_log where log_type_id='00027' group by to_char(action_datetime, 'YYYYMM');

-- number of new added allergy record from download record
select count(1), to_char(action_datetime, 'YYYYMM') from sa_audit_log where log_type_id='00019' group by to_char(action_datetime, 'YYYYMM');

-- number of new added ADR record from download record
select count(1), to_char(action_datetime, 'YYYYMM') from sa_audit_log where log_type_id='00021' group by to_char(action_datetime, 'YYYYMM');

-- number of edit ADR record from download record
select count(1), to_char(action_datetime, 'YYYYMM') from sa_audit_log where log_type_id='00029' group by to_char(action_datetime, 'YYYYMM');

-- average number of download allergy record per hcr
select count(1), a.ehr_no, to_char(b.create_dtm, 'YYYYMM') from hepr_temp_download_pat_allergy a, hepr_temp_download_pat_status b where a.download_id = b.download_id group by a.ehr_no, to_char(b.CREATE_DTM, 'YYYYMM');

-- average number of download adr record per hcr
select count(1), a.ehr_no, to_char(b.create_dtm, 'YYYYMM') from HEPR_TEMP_DOWNLOAD_PAT_ADR a, hepr_temp_download_pat_status b where a.download_id = b.download_id group by a.ehr_no, to_char(b.CREATE_DTM, 'YYYYMM');

-- No of copied downloaded allergy
select count(1), to_char(trx_dtm, 'YYYYMM') from sa_download_patient_allergy group by to_char(trx_dtm, 'YYYYMM');

-- No of copied downloaded adr
select count(1), to_char(trx_dtm, 'YYYYMM') from sa_download_patient_adr group by to_char(trx_dtm, 'YYYYMM');


-- remarks: remove for half-year utilization statistics by EH2 on 13-Sep-2021
/*
-- For ADR 
select b.drug_reaction_desc, count(a.drug_reaction) as 
patient_drug_reaction
from sa_patient_adr_reaction a, sa_adr_common_reaction b
where a.drug_reaction = b.reaction_seq_no
group by b.drug_reaction_desc;
*/

-- Allergy delete reason
select delete_reason, allergen_type ,count(1) from sa_patient_allergy_log where trx_type='D' and delete_reason is not null
group by delete_reason,allergen_type;

-- ADR delete reason
select delete_reason, adr_type, count(1) from sa_patient_adr_log where trx_type='D' and delete_reason is not null
group by delete_reason, adr_type;

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


-- Free Text Allergy Possible Value 
-- select distinct display_name, allergen_type, count(1) as free_text_allergy_count from sa_patient_allergy where allergen_type in ('X', 'O') group by display_name, allergen_type;
select display_name, allergen_type,manifestation, certainty, count(1) as count
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


-- Get FeedBack --
select id, feedback_content,  feedback_name, feedback_phone, feedback_email, app_name, sub_app_name, submit_date from  wheel_feedback_detail;


--MOE 
-- total prescription count, patient and user per presc_type
select to_char( a.ord_date,'yyyy') as "year", to_char(a.ord_date,'mm') as "month", a.presc_type, count(distinct b.ord_no) as ord_no_number, count(distinct b.create_user_id) as user_number, count(distinct b.moe_patient_key) as patient_number
from moe_order a, moe_ehr_order b, moe_med_profile c
where a.ord_no = b.ord_no
and a.ord_status = 'O'
and c.ord_no = a.ord_no
and c.hospcode = a.hospcode
and a.ord_date >= to_date('2014-01-21 14:00', 'YYYY-MM-DD HH24:MI')
and not exists (select 1 from moe_patient where b.moe_patient_key = moe_patient_key and patient_ref_key = 'A123456(7)')
group by to_char( a.ord_date,'yyyy'), to_char(a.ord_date,'mm'), a.presc_type
order by to_char( a.ord_date,'yyyy'), to_char(a.ord_date,'mm') asc, a.presc_type;

-- total prescription count, patient and user 
select to_char( a.ord_date,'yyyy') as "year", to_char(a.ord_date,'mm') as "month", count(distinct b.ord_no) as ord_no_number, count(distinct b.create_user_id) as user_number, count(distinct b.moe_patient_key) as patient_number
from moe_order a, moe_ehr_order b, moe_med_profile c
where a.ord_no = b.ord_no
and a.ord_status = 'O'
and c.ord_no = a.ord_no
and c.hospcode = a.hospcode
and a.ord_date >= to_date('2014-01-21 14:00', 'YYYY-MM-DD HH24:MI')
and not exists (select 1 from moe_patient where b.moe_patient_key = moe_patient_key and patient_ref_key = 'A123456(7)')
group by to_char( a.ord_date,'yyyy'), to_char(a.ord_date,'mm')
order by to_char( a.ord_date,'yyyy'), to_char(a.ord_date,'mm') asc;
 
-- number item line
select to_char( a.ord_date,'yyyy') as "year", to_char(a.ord_date,'mm') as "month", a.presc_type, c.name_desc, d.order_line_type, count(*) as name_type_count
from moe_order a, moe_med_profile b, moe_drug_display_name_type c, moe_ehr_med_profile d
where a.ord_no = b.ord_no
and b.ord_no = d.ord_no
and b.cms_item_no = d.cms_item_no
and b.hospcode = d.hospcode
and a.hospcode = b.hospcode
and b.name_type = c.name_type
and a.ord_date >= to_date('2014-01-21 14:00', 'YYYY-MM-DD HH24:MI')
and not exists (select 1 from moe_patient aa, moe_ehr_order bb where a.ord_no = bb.ord_no and bb.moe_patient_key = aa.moe_patient_key and aa.patient_ref_key = 'A123456(7)')
group by to_char( a.ord_date,'yyyy'), to_char(a.ord_date,'mm'), c.name_desc, a.presc_type, d.order_line_type
order by to_char( a.ord_date,'yyyy') asc, to_char(a.ord_date,'mm') asc, a.presc_type, c.name_desc, d.order_line_type;

-- number of item line per order
select aa.year, aa.month, aa.no_of_item_per_order, count(aa.no_of_item_per_order) as number_count
from (
select to_char( a.ord_date,'yyyy') as year, to_char(a.ord_date,'mm') as month, a.ord_no, count(distinct b.cms_item_no) as no_of_item_per_order
from moe_order a, moe_med_profile b
where a.ord_no = b.ord_no
and a.hospcode = b.hospcode
and a.ord_status = 'O'
and b.item_status = 'A'
and a.ord_date >= to_date('2014-01-21 14:00', 'YYYY-MM-DD HH24:MI')
and not exists (select 1 from moe_patient aa, moe_ehr_order bb where a.ord_no = bb.ord_no and bb.moe_patient_key = aa.moe_patient_key and aa.patient_ref_key = 'A123456(7)')
group by to_char( a.ord_date,'yyyy'), to_char(a.ord_date,'mm'), a.ord_no) aa
group by aa.year, aa.month, aa.no_of_item_per_order
order by aa.year asc, aa.month;

-- distinct user and patient
select count(distinct last_upd_by) as total_moe_user, count(distinct b.moe_patient_key) as total_patient from moe_order a, moe_ehr_order b where a.ord_no = b.ord_no and a.ord_date < trunc(sysdate,'MM') and not exists (select 1 from moe_patient where b.moe_patient_key = moe_patient_key and patient_ref_key = 'A123456(7)');

-- patient count with different type
select count(distinct b.moe_patient_key) as patient_count, a.presc_type from moe_order a, moe_ehr_order b where a.ord_no = b.ord_no and a.ord_date < trunc(sysdate,'MM') and not exists (select 1 from moe_patient where b.moe_patient_key = moe_patient_key and patient_ref_key = 'A123456(7)') group by a.presc_type;

-- get MOE Delete Prescription reason
select remark_text, count(1) from moe_order where ord_status = 'CO' and remark_text is not null and ord_date < trunc(sysdate,'MM') and not exists (select 1 from moe_patient c, moe_ehr_order b where b.ord_no = moe_order.ord_no and b.moe_patient_key = c.moe_patient_key and c.patient_ref_key = 'A123456(7)') group by remark_text;

-- My Favourite with Calcium
select my_favourite_id, item_no, regimen, vtm, trade_name, generic_indicator, name_type, order_line_type, danger_drug, form_eng, dose_form_extra_info, route_eng, freq_code, freq_text, site_eng, prn, duration, duration_unit, screen_display, dosage, dosage_unit, suppl_freq_eng, suppl_freq_text, mo_qty, mo_qty_unit, spec_instruct, action_status, preparation, drug_route_eng, strength_level_extra_info, strength_compulsory
from moe_my_favourite_detail where vtm like 'calcium%' and vtm not like '% + %';

-- MOE Setting
select hospcode, user_specialty, param_name, param_name_desc, param_value, param_value_type, param_possible_value, param_level, param_display from moe_hospital_setting;
select param_name, param_name_desc, param_value, param_value_type, param_possible_value, param_level, param_display from moe_system_setting;

-- get steroids data
-- select n.moe_patient_key, o.moe_case_no,concat((case when (a.presc_type = 'O') then 'Outpatient' 
-- 	                when (a.presc_type = 'H') then 'Home-Leave' 
-- 			        when (a.presc_type = 'D') then 'Discharge' 
--                else '' end), case when a.ord_subtype = 'B' then ' (Back-dated)' else '' end) AS episode_type,
-- 	   a.ord_no as ord_no, 
--        d.trade_name AS trade_name,
--        (case when (c.name_type = 'F') then d.screen_display else cast(d.vtm as varchar(2000)) end) AS vtm,
--        d.drug_route_eng AS drug_route,
--        c.route_desc AS regimen_route,
--        c.form_desc AS form_desc,
--        d.dose_form_extra_info AS dose_form_extra_info,
--        d.generic_indicator AS generic_indicator,
--        c.strength AS strength,
--        d.strength_level_extra_info AS strength_level_extra_info,
--        d.strength_compulsory AS strength_compulsory,
--        c.dangerdrug AS dangerdrug,
--        m.name_desc AS name_desc,
--        c.cms_item_no AS cms_item_no,
--        c.org_item_no as org_item_no,
--        e.step_no AS step_no,
--        e.mult_dose_no AS mult_dose_no,
--        (case when (d.order_line_type = 'M') then 'Multiple Line' when (d.order_line_type = 'N') then 'Basic' when (d.order_line_type = 'S') then 'Step up / down' when (d.order_line_type = 'R') then 'Special Interval' when (d.order_line_type = 'A') then 'Advance' end) AS order_line_type,
--        cast((case when ((d.order_line_type in ('M', 'S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) then e.dosage else c.dosage end) as number(15, 4)) AS dosage,
--        c.modu AS modu,
--        (case when (d.order_line_type = 'S') then nvl(e.prn, 'N') else c.prn end) AS prn,
--        c.start_date as start_date,
-- 	   c.end_date as end_date,
--        (case when (((d.order_line_type in ('M', 'S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) and c.dangerdrug = 'Y') then e.mo_qty else c.mo_qty end) AS mo_qty,
--        (case when (((d.order_line_type in ('M', 'S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) and c.dangerdrug = 'Y') then e.mo_qty_unit else c.mo_qty_unit end) AS mo_qty_unit,
--         l.action_status AS action_status,
-- 	   case when c.name_type = 'F' then cast(d.alias_name || nvl2(c.strength, concat(n' ', c.strength), n'') || (case when exists (select 1 from moe_form_route_map where form_id = d.form_id and route_id = d.drug_route_id and display_route = 'Y') then nvl2(d.drug_route_eng, concat(n' ', cast(d.drug_route_eng as nvarchar2(255))), n'') else n'' end) || nvl2(c.form_desc, concat(n' ', c.form_desc), n'') || nvl2(d.dose_form_extra_info, concat(n' ', n'(' || cast(d.dose_form_extra_info as nvarchar2(255)) || n')'), n'') || nvl2(d.strength_level_extra_info, concat(n' ', n'(' || cast(d.strength_level_extra_info as nvarchar2(50))|| n')'), '') as varchar(4000))
--             else case when (instr(d.vtm, ' + ') > 0) or c.name_type = 'L' then 
-- 			 d.screen_display
--                  else cast(d.screen_display || nvl2(c.strength, concat(n' ', c.strength), n'') || (case when exists (select 1 from moe_form_route_map where form_id = d.form_id and route_id = d.drug_route_id and display_route = 'Y') then nvl2(d.drug_route_eng, concat(n' ', cast(d.drug_route_eng as nvarchar2(255))), n'') else n'' end) || nvl2(c.form_desc, concat(n' ', c.form_desc), n'') || nvl2(d.dose_form_extra_info, concat(n' ', n'(' || cast(d.dose_form_extra_info as nvarchar2(255)) || n')'), '') || nvl2(d.strength_level_extra_info, concat(n' ', n'(' || cast(d.strength_level_extra_info as nvarchar2(50)) || n')'), '') as varchar(4000))
--             end
--         end as drug_desc_long,
--        (case when ((d.order_line_type in ('M','S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) then e.freq_code else c.freq_code end) AS freq_code,
--        (case when ((d.order_line_type in ('M','S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) then e.freq1 else c.freq1 end) AS freq1,
--        (case when ((d.order_line_type in ('M','S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) then e.freq_text else c.freq_text end) AS freq_text,
--        c.sup_freq_code AS sup_freq_code,
--        (case when ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days')) then e.sup_freq1 else c.sup_freq1 end) AS sup_freq1,
--        (case when ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days')) then e.sup_freq2 else c.sup_freq2 end) AS sup_freq2,
--        (case when ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days')) then e.sup_freq_text else c.sup_freq_text end) AS sup_freq_text,
--        (case when (d.order_line_type = 'S') then e.duration else c.duration end) AS duration,
--        q.duration_unit_desc,
--        (case when c.regimen = 'C' then d.cycle_multiplier else q.duration_multiplier end) as duration_multiplier,
--        c.site_desc AS site_desc,
--        c.spec_instruct AS spec_instruct,
--        c.itemcode AS itemcode
-- from moe_order a, moe_ehr_order b,
--             moe_med_profile c left outer join moe_med_mult_dose e on(((c.ord_no = e.ord_no) and (c.cms_item_no = e.cms_item_no))),
--             moe_ehr_med_profile d,
--             moe_action_status l,
--             moe_drug_display_name_type m,
--             moe_patient n,
--             moe_patient_case o,
-- 			moe_duration_unit_multiplier q
-- where (
--         n.patient_ref_key <> 'A123456(7)' and
--        (a.ord_status = 'O') and
--        (a.ord_no = c.ord_no) and
--        (a.ord_no = b.ord_no) and
--        (c.ord_no = d.ord_no) and
--        (c.cms_item_no = d.cms_item_no) and
--        (l.action_status_type = c.action_status) and
--        (m.name_type = c.name_type) and
--        (n.moe_patient_key = b.moe_patient_key) and
--        (o.moe_case_no = b.moe_case_no) and
-- 	   q.duration_unit = (case when (d.order_line_type = 'S') then e.duration_unit else c.duration_unit end) and
-- 	   (d.vtm LIKE '%betamethasone%' OR d.vtm LIKE '%dexamethasone%' OR d.vtm LIKE '%hydrocortisone%' OR d.vtm LIKE '%methylprednisolone%' OR d.vtm LIKE '%prednisolone%' OR d.vtm LIKE '%prednisone%' OR d.vtm LIKE '%triamcinolone%' OR d.vtm LIKE '%cortisone%' OR d.vtm LIKE '%fludrocortisone%') AND
-- 	   a.ord_date >= to_date('2017-01-01 00:00', 'YYYY-MM-DD HH24:MI') and a.ord_date <= to_date('2018-05-01 00:00', 'YYYY-MM-DD HH24:MI') 
--       )
-- union
-- select n.moe_patient_key, o.moe_case_no,concat((case when (a.presc_type = 'O') then 'Outpatient' 
-- 	                when (a.presc_type = 'H') then 'Home-Leave' 
-- 			        when (a.presc_type = 'D') then 'Discharge' 
--                else '' end), case when a.ord_subtype = 'B' then ' (Back-dated)' else '' end) AS episode_type,
-- 	   a.ord_no as ord_no, 
--        d.trade_name AS trade_name,
--        (case when (c.name_type = 'F') then d.screen_display else cast(d.vtm as varchar(2000)) end) AS vtm,
--        d.drug_route_eng AS drug_route,
--        c.route_desc AS regimen_route,
--        c.form_desc AS form_desc,
--        d.dose_form_extra_info AS dose_form_extra_info,
--        d.generic_indicator AS generic_indicator,
--        c.strength AS strength,
--        d.strength_level_extra_info AS strength_level_extra_info,
--        d.strength_compulsory AS strength_compulsory,
--        c.dangerdrug AS dangerdrug,
--        m.name_desc AS name_desc,
--        c.cms_item_no AS cms_item_no,
--        c.org_item_no as org_item_no,
--        e.step_no AS step_no,
--        e.mult_dose_no AS mult_dose_no,
--        (case when (d.order_line_type = 'M') then 'Multiple Line' when (d.order_line_type = 'N') then 'Basic' when (d.order_line_type = 'S') then 'Step up / down' when (d.order_line_type = 'R') then 'Special Interval' when (d.order_line_type = 'A') then 'Advance' end) AS order_line_type,
--        cast((case when ((d.order_line_type in ('M', 'S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) then e.dosage else c.dosage end) as number(15, 4)) AS dosage,
--        c.modu AS modu,
--        (case when (d.order_line_type = 'S') then nvl(e.prn, 'N') else c.prn end) AS prn,
--        c.start_date as start_date,
-- 	   c.end_date as end_date,
--        (case when (((d.order_line_type in ('M', 'S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) and c.dangerdrug = 'Y') then e.mo_qty else c.mo_qty end) AS mo_qty,
--        (case when (((d.order_line_type in ('M', 'S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) and c.dangerdrug = 'Y') then e.mo_qty_unit else c.mo_qty_unit end) AS mo_qty_unit,
--         l.action_status AS action_status,
-- 	   case when c.name_type = 'F' then cast(d.alias_name || nvl2(c.strength, concat(n' ', c.strength), n'') || (case when exists (select 1 from moe_form_route_map where form_id = d.form_id and route_id = d.drug_route_id and display_route = 'Y') then nvl2(d.drug_route_eng, concat(n' ', cast(d.drug_route_eng as nvarchar2(255))), n'') else n'' end) || nvl2(c.form_desc, concat(n' ', c.form_desc), n'') || nvl2(d.dose_form_extra_info, concat(n' ', n'(' || cast(d.dose_form_extra_info as nvarchar2(255)) || n')'), n'') || nvl2(d.strength_level_extra_info, concat(n' ', n'(' || cast(d.strength_level_extra_info as nvarchar2(50))|| n')'), '') as varchar(4000))
--             else case when (instr(d.vtm, ' + ') > 0) or c.name_type = 'L' then 
-- 			 d.screen_display
--                  else cast(d.screen_display || nvl2(c.strength, concat(n' ', c.strength), n'') || (case when exists (select 1 from moe_form_route_map where form_id = d.form_id and route_id = d.drug_route_id and display_route = 'Y') then nvl2(d.drug_route_eng, concat(n' ', cast(d.drug_route_eng as nvarchar2(255))), n'') else n'' end) || nvl2(c.form_desc, concat(n' ', c.form_desc), n'') || nvl2(d.dose_form_extra_info, concat(n' ', n'(' || cast(d.dose_form_extra_info as nvarchar2(255)) || n')'), '') || nvl2(d.strength_level_extra_info, concat(n' ', n'(' || cast(d.strength_level_extra_info as nvarchar2(50)) || n')'), '') as varchar(4000))
--             end
--         end as drug_desc_long,
--        (case when ((d.order_line_type in ('M','S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) then e.freq_code else c.freq_code end) AS freq_code,
--        (case when ((d.order_line_type in ('M','S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) then e.freq1 else c.freq1 end) AS freq1,
--        (case when ((d.order_line_type in ('M','S')) or ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days'))) then e.freq_text else c.freq_text end) AS freq_text,
--        c.sup_freq_code AS sup_freq_code,
--        (case when ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days')) then e.sup_freq1 else c.sup_freq1 end) AS sup_freq1,
--        (case when ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days')) then e.sup_freq2 else c.sup_freq2 end) AS sup_freq2,
--        (case when ((d.order_line_type = 'R') and (c.sup_freq_code = 'on odd / even days')) then e.sup_freq_text else c.sup_freq_text end) AS sup_freq_text,
--        (CASE WHEN (d.order_line_type = 'S') THEN e.duration ELSE c.duration END) AS duration,
--        NULL AS duration_unit_desc,
--        null as duration_multiplier,
--        c.site_desc AS site_desc,
--        c.spec_instruct AS spec_instruct,
--        c.itemcode AS itemcode
-- from moe_order a, moe_ehr_order b,
--             moe_med_profile c left outer join moe_med_mult_dose e on(((c.ord_no = e.ord_no) and (c.cms_item_no = e.cms_item_no))),
--             moe_ehr_med_profile d,
--             moe_action_status l,
--             moe_drug_display_name_type m,
--             moe_patient n,
--             moe_patient_case o
-- where (
--         n.patient_ref_key <> 'A123456(7)' and
--        (a.ord_status = 'O') and
--        (a.ord_no = c.ord_no) and
--        (a.ord_no = b.ord_no) and
--        (c.ord_no = d.ord_no) and
--        (c.cms_item_no = d.cms_item_no) and
--        (l.action_status_type = c.action_status) and
--        (m.name_type = c.name_type) and
--        (n.moe_patient_key = b.moe_patient_key) and
--        (o.moe_case_no = b.moe_case_no) AND
-- 	     (e.duration_unit is null and c.duration_unit is null) and
-- 	   (d.vtm LIKE '%betamethasone%' OR d.vtm LIKE '%dexamethasone%' OR d.vtm LIKE '%hydrocortisone%' OR d.vtm LIKE '%methylprednisolone%' OR d.vtm LIKE '%prednisolone%' OR d.vtm LIKE '%prednisone%' OR d.vtm LIKE '%triamcinolone%' OR d.vtm LIKE '%cortisone%' OR d.vtm LIKE '%fludrocortisone%') AND
-- 	   A.ord_date >= to_date('2017-01-01 00:00', 'YYYY-MM-DD HH24:MI') AND A.ord_date <= to_date('2018-05-01 00:00', 'YYYY-MM-DD HH24:MI') 
--       )order by moe_patient_key, start_date;

-- get local drug
select a.hk_reg_no, a.trade_name, a.vtm, a.form_eng, a.dose_form_extra_info, a.route_eng, b.strength, b.strength_level_extra_info, b.amp from moe_drug_local a, moe_drug_strength_local b where a.local_drug_id = b.local_drug_id and terminology_name is null;

-- DAC -  Allergy / HLAB checking count
select to_char(record_dtm, 'yyyy') as year, to_char(record_dtm, 'mm') as month, allergen, drug_vtm, button_label, count(*) as action 
from moe_ehr_accept_drug_checking 
where allergen is not null and drug_vtm is not null and record_dtm >= to_date('2015-04-28 13:35', 'YYYY-MM-DD HH24:MI') and button_label <> 'Drug Allergy Checking'
group by to_char(record_dtm, 'yyyy'), to_char(record_dtm, 'mm'), allergen, drug_vtm, button_label
order by to_char(record_dtm, 'yyyy') asc, to_char(record_dtm, 'mm'),allergen, drug_vtm, button_label asc;

-- DAC Reaction Overriding Reason
select to_char(a.ord_date, 'yyyy') as year, to_char(a.ord_date, 'mm') as month, d.allergen, c.vtm, c.trade_name, c.drug_route_eng, b.route_desc, b.form_desc, c.dose_form_extra_info, d.override_reason, count(*) as override_count
from moe_order a, moe_med_profile b, moe_ehr_med_profile c, moe_ehr_med_allergen d
where a.ord_status = 'O'
and c.ord_no = a.ord_no
and c.ord_no = b.ord_no
and c.hospcode = a.hospcode
and c.ord_no = d.ord_no
and c.hospcode = d.hospcode
and c.cms_item_no = d.cms_item_no
and c.cms_item_no = b.cms_item_no
and a.ord_date >= to_date('2015-04-28 13:35', 'YYYY-MM-DD HH24:MI')
GROUP BY to_char(A.ord_date, 'yyyy'), to_char(A.ord_date, 'mm'), d.allergen , c.vtm, c.trade_name, c.drug_route_eng, b.route_desc, b.form_desc, c.dose_form_extra_info, d.override_reason
ORDER BY to_char(A.ord_date, 'yyyy') ASC, to_char(A.ord_date, 'mm') ASC, d.allergen , c.vtm, c.trade_name, c.drug_route_eng, b.route_desc, b.form_desc, c.dose_form_extra_info, d.override_reason;

-- get reaction pair
select to_char(action_datatime, 'yyyy') as year, to_char(action_datatime, 'mm') as month, prescibe_drug_vtm, dbms_lob.substr(patient_allergy_result, 2000, 1) as allergy_result, reaction_level, count(*) as no_of_count
from dac_response_audit_log
where action_datatime >= to_date('2015-04-28 13:35', 'YYYY-MM-DD HH24:MI')
group by to_char(action_datatime, 'yyyy'), to_char(action_datatime, 'mm'), prescibe_drug_vtm, dbms_lob.substr(patient_allergy_result, 2000, 1), reaction_level
order by to_char(action_datatime, 'yyyy') asc, to_char(action_datatime, 'mm'), prescibe_drug_vtm, dbms_lob.substr(patient_allergy_result, 2000, 1), reaction_level asc;

-- get dac system setting
select * from dac_system_setting;

CREATE GLOBAL TEMPORARY TABLE t_dummy_patient_20150304 (patient_id varchar2(32));

CREATE GLOBAL TEMPORARY TABLE t_dxpx_dummy_patient_20150304 (patient_id varchar2(32));

VAR goLiveDtm varchar2(19);
EXEC :goLiveDtm := '20150204000000';

-- eg. 'DUMMY_PATIENT_MRN','TEST1_PATIENT_MRN','TEST2_PATIENT_MRN'
insert into t_dummy_patient_20150304 
select patient_id from csds_patient
where medical_record_no in ('DUMMY_PATIENT_MRN');

insert into t_dxpx_dummy_patient_20150304 
select patient_key from dxpx_patient
where patient_ref_key IN ('DUMMY_PATIENT_MRN');



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
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
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
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304) 
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss')
--***
group by TO_CHAR(A.UPDATE_DTM,'YYYYMM'), A.STATUS
union
select to_char(a.update_dtm,'YYYYMM') update_date, 
A.STATUS, (count(*)/2) no_of_trans
from ds_discharge_summary_log a
--***
where a.update_by not in ('ehradmin', 'admin')  -- exclude non-user
and a.status = 3
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
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
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
--***
group by to_char(a.create_dtm,'YYYYMM'), (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end)
order by to_char(a.create_dtm,'YYYYMM'), (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end);

-- calculate the total no of episode
select count(distinct episode_no) total_no_of_episode
from csds_summary a, ds_discharge_summary b
where a.summary_id = b.summary_id
--***
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
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
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and b.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and b.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
--***
group by to_char(b.update_dtm,'YYYYMM')
order by to_char(b.update_dtm,'YYYYMM');

-- calculate the no of patient by month (created date)
select to_char(a.create_dtm,'YYYYMM') create_dtm,count(distinct a.patient_id) no_of_patient 
FROM csds_patient a, csds_summary b, ds_discharge_summary c
where a.patient_id = b.patient_id
and b.summary_id = c.summary_id
--***
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and b.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and b.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
--***
group by to_char(a.create_dtm,'YYYYMM')
order by to_char(a.create_dtm,'YYYYMM');

-- calculate the total no of patient
select count(distinct a.patient_id) total_no_of_patient 
FROM csds_patient a, csds_summary b, ds_discharge_summary c
where a.patient_id = b.patient_id
--***
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and b.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and b.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
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
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and b.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and b.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
--***
group by to_char(b.update_dtm,'YYYYMM')
order by to_char(b.update_dtm,'YYYYMM');

-- calculate the total no of user
SELECT count(distinct b.update_by) total_no_of_users
FROM csds_patient a, csds_summary b, ds_discharge_summary c
where a.patient_id = b.patient_id
and b.summary_id = c.summary_id
--***
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and b.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and b.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
--***
;

-- calculate the no of login and logout by action date per month
select to_char(a.action_datetime,'YYYYMM') action_date, b.log_description, a.login_id, count(1) 
from ac_audit_log a, ac_audit_log_type b
where a.log_type_id = b.log_type_id
and b.log_component = 'DS'
--***
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.login_id not in ('ehradmin', 'admin')  -- exclude admin user
and a.action_datetime > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
--***
group by to_char(a.action_datetime,'YYYYMM'), b.log_description, a.login_id
order by to_char(a.action_datetime,'YYYYMM'), b.log_description, a.login_id;

-- calculate no of episode create by users
select a.create_by create_by, (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status, count(1) no_of_episode
from csds_summary a, ds_discharge_summary b
where a.summary_id = b.summary_id
--***
and a.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
--***
group by a.create_by, (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end)
order by a.create_by, (case a.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end);



----------------------
--No of discharge note
----------------------
-- calculate the no of record for discharge note
select to_char(a.update_dtm,'YYYYMM') update_date, (case b.status when 0 then 'DELETE' when 2 then 'DRAFT' when 3 then 'SIGNOFF' end) as status, count(1) no_discharge_note
from ds_discharge_note a, csds_summary b
where a.free_text_id = b.summary_id
and a.content is not null
--***
and b.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
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
and b.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
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
and b.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
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
and b.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
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
and b.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
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
and d.patient_id NOT IN (select patient_id from t_dummy_patient_20150304)
and a.update_by not in ('ehradmin', 'admin')  -- exclude admin user
and a.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss') 
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
and p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304) 
and p_e.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss')
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
and p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304) 
and p_e.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss')
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
and p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304) 
and p_e.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss')
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
and p_e.patient_key NOT IN (select patient_id from t_dxpx_dummy_patient_20150304) 
and p_e.update_dtm > to_date(:goLiveDtm, 'yyyymmddhh24miss')
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


drop table t_dummy_patient_20150304;

drop table t_dxpx_dummy_patient_20150304;

VAR goLiveDtm varchar2(19);
EXEC :goLiveDtm := '2015-02-04 00:00:00';

-- if more than one dummy patient, append the mrn into value list
-- eg. 'DUMMY_PATIENT_MRN,TEST1_PATIENT_MRN,TEST2_PATIENT_MRN'
VAR dummyPatient varchar2(255);
EXEC :dummyPatient := 'DUMMY_PATIENT_MRN';

/*-------------------------------------------------------------------------------------
--No of letter summary which is either created by or updated by ehradmin or admin
--------------------------------------------------------------------------------------*/
SELECT update_date, letter_name, sum(no_of_letter) 
from 
(SELECT
    TO_CHAR(update_dtm, 'YYYYMM') as  update_date,
    letter_name,
    1 as no_of_letter
FROM
    le_letter_summary
where
-- ***
    (create_by = 'ehradmin' and update_by <> 'ehradmin' and update_by <> 'admin')
OR  (create_by = 'admin' and update_by <> 'ehradmin' and update_by <> 'admin')
OR  (create_by <> 'admin' and create_by <> 'ehradmin' and update_by = 'ehradmin')
OR  (create_by <> 'admin' and create_by <> 'ehradmin' and update_by = 'admin')							-- exclude non-user
AND update_dtm > TO_DATE(:goLiveDtm,'YYYY-MM-DD HH24:MI:SS')            -- le go live date-time;
AND patient_id NOT IN (SELECT patient_id FROM le_patient WHERE medical_record_no IN (SELECT trim(regexp_substr(:dummyPatient, '[^,]+', 1, LEVEL)) str_2_tab  FROM dual CONNECT BY LEVEL <= regexp_count(:dummyPatient, ',')+1)) -- le dummy patients
-- ***
)
GROUP BY
    update_date,
    letter_name
ORDER BY
    update_date;

/*-------------------------
--No of letter summary
-------------------------*/
-- calculate the no of letter done per month
SELECT update_date, letter_name, 
sum(no_of_letter), 
sum(in_patient_case) AS in_patient_case, 
sum(out_patient_case) AS out_patient_case, 
sum(no_of_letter_printed) AS no_of_letter_printed, 
sum(deleted) as no_of_letter_deleted
from (
SELECT
    TO_CHAR(update_dtm, 'YYYYMM') update_date,
    letter_name,
    1 as no_of_letter,
    CASE episode_type
            WHEN 'I'
            THEN 1
            ELSE 0
        END
    as in_patient_case,
    CASE episode_type
            WHEN 'O'
            THEN 1
            ELSE 0
        END
    as out_patient_case,
    CASE
            WHEN first_print_dtm IS NULL
            THEN 0
            ELSE 1
        END
    as no_of_letter_printed,
    deleted
FROM
    le_letter_summary
where
-- ***
    update_by NOT IN ('ehradmin', 'admin') -- exclude non-users
AND update_dtm > TO_DATE(:goLiveDtm,'YYYY-MM-DD HH24:MI:SS')            -- le go live date-time;
AND patient_id NOT IN (select patient_id from le_patient where medical_record_no in (SELECT trim(regexp_substr(:dummyPatient, '[^,]+', 1, LEVEL)) str_2_tab  FROM dual CONNECT BY LEVEL <= regexp_count(:dummyPatient, ',')+1)) -- le dummy patients
-- ***
)
GROUP BY
    update_date,
    letter_name
ORDER BY
    update_date;


/*---------------
--No of episode
---------------*/
-- calculate the no of episode by month (created date)
SELECT
    TO_CHAR(create_dtm, 'YYYYMM') create_dtm,
    letter_name,
    COUNT(1) no_of_episode,
    SUM(
        CASE episode_type
            WHEN 'I'
            THEN 1
            ELSE 0
        END
    ) in_patient_case,
    SUM(
        CASE episode_type
            WHEN 'O'
            THEN 1
            ELSE 0
        END
    ) out_patient_case
FROM
    le_letter_summary
WHERE
-- ***
    update_by NOT IN ('ehradmin', 'admin') -- exclude admin users
AND update_dtm > TO_DATE(:goLiveDtm,'YYYY-MM-DD HH24:MI:SS')            -- le go live date-time
AND patient_id NOT IN (select patient_id from le_patient where medical_record_no in (SELECT trim(regexp_substr(:dummyPatient, '[^,]+', 1, LEVEL)) str_2_tab  FROM dual CONNECT BY LEVEL <= regexp_count(:dummyPatient, ',')+1))  -- le dummy patients
-- ***
GROUP BY
    TO_CHAR(create_dtm, 'YYYYMM'),
    letter_name
ORDER BY
    create_dtm;

-- calculate the total no of episode
SELECT
    COUNT(DISTINCT episode_no) total_no_of_episode
FROM
    le_letter_summary
WHERE
-- ***
    update_by NOT IN ('ehradmin', 'admin') -- exclude admin users
AND update_dtm > TO_DATE(:goLiveDtm,'YYYY-MM-DD HH24:MI:SS')            -- le go live date-time
AND patient_id NOT IN (select patient_id from le_patient where medical_record_no in (SELECT trim(regexp_substr(:dummyPatient, '[^,]+', 1, LEVEL)) str_2_tab  FROM dual CONNECT BY LEVEL <= regexp_count(:dummyPatient, ',')+1))  -- le dummy patients
-- ***
;


/*---------------
--No of patient
---------------*/
-- calculate no. of letters by patients in each month (create date)
SELECT
    TO_CHAR(letter.create_dtm, 'YYYYMM') create_dtm,
    COUNT(DISTINCT patient.patient_id) no_of_distinct_patient,
    COUNT(DISTINCT letter.episode_no) no_of_distinct_epiosde,
    COUNT(letter.letter_summary_id) no_of_letter_created,
    SUM(
        CASE
            WHEN first_print_dtm IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) no_of_letter_printed,
    SUM(deleted) no_of_letter_deleted
FROM
    le_patient patient,
    le_letter_summary letter
WHERE
    patient.patient_id = letter.patient_id
-- ***
AND letter.update_by NOT IN ('ehradmin', 'admin') -- exclude admin users
AND letter.update_dtm > TO_DATE(:goLiveDtm,'YYYY-MM-DD HH24:MI:SS')            -- le go live date-time
AND letter.patient_id NOT IN (select patient_id from le_patient where medical_record_no in (SELECT trim(regexp_substr(:dummyPatient, '[^,]+', 1, LEVEL)) str_2_tab  FROM dual CONNECT BY LEVEL <= regexp_count(:dummyPatient, ',')+1)) -- le dummy patients
-- ***
GROUP BY
     TO_CHAR(letter.create_dtm, 'YYYYMM')
ORDER BY
     TO_CHAR(letter.create_dtm, 'YYYYMM');


-- calculate the total no of patient
SELECT
    COUNT(1) total_no_of_patient
FROM
    le_patient patient,
    le_letter_summary letter
WHERE
    patient.patient_id = letter.patient_id
-- ***
AND letter.update_by NOT IN ('ehradmin', 'admin') -- exclude admin users
AND letter.update_dtm > TO_DATE(:goLiveDtm,'YYYY-MM-DD HH24:MI:SS')            -- le go live date-time
AND letter.patient_id NOT IN (select patient_id from le_patient where medical_record_no in (SELECT trim(regexp_substr(:dummyPatient, '[^,]+', 1, LEVEL)) str_2_tab  FROM dual CONNECT BY LEVEL <= regexp_count(:dummyPatient, ',')+1)) -- le dummy patients
-- ***
;


/*----------------------
--No of user created letter and login
----------------------*/
-- calculate the no of user created letter per month
SELECT
    TO_CHAR(letter.update_dtm, 'YYYYMM') update_date,
    COUNT(DISTINCT letter.update_by) no_of_users
FROM
    le_patient patient,
    le_letter_summary letter
WHERE
    patient.patient_id = letter.patient_id
-- ***
AND letter.update_by NOT IN ('ehradmin', 'admin') -- exclude admin users
AND letter.update_dtm > TO_DATE(:goLiveDtm,'YYYY-MM-DD HH24:MI:SS')            -- le go live date-time
AND letter.patient_id NOT IN (select patient_id from le_patient where medical_record_no in (SELECT trim(regexp_substr(:dummyPatient, '[^,]+', 1, LEVEL)) str_2_tab  FROM dual CONNECT BY LEVEL <= regexp_count(:dummyPatient, ',')+1)) -- le dummy patients
-- ***
GROUP BY
    TO_CHAR(letter.update_dtm, 'YYYYMM')
ORDER BY
    TO_CHAR(letter.update_dtm, 'YYYYMM');

-- calculate the total no of user
SELECT	
    COUNT(DISTINCT letter.update_by) total_no_of_users
FROM
    le_patient patient,
    le_letter_summary letter
WHERE
    patient.patient_id = letter.patient_id
-- ***
AND letter.update_by NOT IN ('ehradmin', 'admin') -- exclude admin users
AND letter.update_dtm > TO_DATE(:goLiveDtm,'YYYY-MM-DD HH24:MI:SS')            -- le go live date-time
AND letter.patient_id NOT IN (select patient_id from le_patient where medical_record_no in (SELECT trim(regexp_substr(:dummyPatient, '[^,]+', 1, LEVEL)) str_2_tab  FROM dual CONNECT BY LEVEL <= regexp_count(:dummyPatient, ',')+1)) -- le dummy patients
-- ***
;

-- calculate the no of login and logout by action date per month
SELECT
    TO_CHAR(a.action_datetime, 'YYYYMM') action_date,
    b.log_description,
    a.login_id,
    COUNT(1)  no_of_count
FROM
    ac_audit_log a,
    ac_audit_log_type b
WHERE
    a.log_type_id = b.log_type_id
AND b.log_component = 'LE'
  -- ***
AND a.login_id NOT IN ('ehradmin', 'admin') -- exclude admin users
AND a.action_datetime > TO_DATE(:goLiveDtm,'YYYY-MM-DD HH24:MI:SS')            -- le go live date-time
  -- ***
GROUP BY
    TO_CHAR(a.action_datetime, 'YYYYMM'),
    b.log_description,
    a.login_id
ORDER BY
    action_date,
    b.log_description,
    a.login_id;


/*----------------------
-- calculate the no of distinct login by action date per month
----------------------*/
SELECT
    TO_CHAR(a.action_datetime, 'YYYYMM') action_date,
    COUNT(distinct(login_id))  no_of_distinct_user_login
FROM
    ac_audit_log a,
    ac_audit_log_type b
WHERE
    a.log_type_id = b.log_type_id
AND b.log_component = 'LE'
AND b.log_description = 'LOG IN'
  -- ***
AND a.login_id NOT IN ('ehradmin', 'admin') -- exclude admin users
AND a.action_datetime > TO_DATE(:goLiveDtm,'YYYY-MM-DD HH24:MI:SS')            -- le go live date-time
  -- ***
GROUP BY
    TO_CHAR(a.action_datetime, 'YYYYMM')
ORDER BY
    action_date;


-- system setting 1
select 
system_config_id,
allow_update_on_maint,
config_group,
config_key,
remark,
value,
hospital_code 
from le_system_config;

-- system setting 2
select
system_config_id,
app_code,
config_group,
frontend,
config_key,
remark,
value 
from ac_system_config where app_code = 'LE';

-- audit log number
select 
log_type_id, 
count(*) 
from ac_audit_log
where log_type_id like 'LE%'
group by log_type_id;

-- audit log type
select
log_type_id,
log_component,
log_description,
fail_action_type,
severity,
success_action_type 
from ac_audit_log_type where log_component = 'LE';

-- clinician title
select 
clinician_title_id,
description,
status,
hospital_code 
from ac_clinician_title;

-- clinician type
select
clinician_type_id,
description,
status 
from ac_clinician_type;

-- hospital setting
select
hospital_code,
barcode_format,
hospital_address,
hospital_name,
logo_id,
hci_id,
hcp_id 
from ac_hospital;

-- specialty
select
specialty_id,
description,
specialty_code,
status,
hospital_code 
from ac_specialty;

-- access control
select
access_control_id,
control_item_id,
display_item,
display_item_group,
display_item_group_seq,
display_item_seq,
status 
from le_access_control;

-- letter audit log number
select
log_type_id, 
count(*) 
from le_audit_log group by log_type_id;

-- letter audit log type
select
log_type_id,
log_component,
log_description,
fail_action_type,
severity,
success_action_type 
from le_audit_log_type;

-- letter block setting
select
block_id,
bottom_border_width,
data_type,
editable,
height,
left_border_width,
personal_identifier,
right_border_width,
top_border_width,
value,
width,
position_x,
position_y,
field_id,
template_id 
from le_data_block;

-- letter template setting
select
template_id,
move_unit,
print_text_type,
status,
image_name,
page_num,
paper_orientation_id,
paper_size_id,
letter_type_id
from le_letter_template;

-- letter type setting
select
type_id,
description,
display_seq,
leaf_folder,
status,
app_type,
hospital_code,
parent_letter_type_id,
user_define,
show_episode_list,
editable,
default_printer,
referral,
print_copy
from le_letter_type;

-- letter field setting
select
field_id,
app_type,
display_seq,
field_name,
field_name_inpatient,
field_name_outpatient,
field_type,
status,
tag_value,
user_define,
type_id,
field_set_id,
sample_id,
web_parameter,
ws_type,
alias 
from le_letter_field;

-- letter field set setting
select
field_set_id,
display_seq,
field_set_name,
group_name,
status,
user_define,
hospital_code,
parent_id,
set_name_inpatient,
set_name_outpatient 
from le_letter_field_set;

-- selected letter type
select
selected_id,
profile_desc,
display_seq,
profile,
hospital_code,
letter_type_id,
back_gen_type
from le_letter_type_sel;

-- paper orientation setting
select
paper_orientation_id,
description,
status 
from le_paper_orientation;

-- paper size setting
select
paper_size_id,
description,
height,
status,
width 
from le_paper_size;

-- selection text setting
select
text_id,
description,
display,
display_seq,
type 
from le_text_selection;

-- user access control
select
user_access_control_id,
permission_status,
profile_id,
profile_name,
profile_status,
access_control_id,
hospital_code 
from le_user_access_control;

-- group block
select
block_id,
bottom_border_width,
data_type,
editable,
height,
left_border_width,
personal_identifier,
right_border_width,
top_border_width,
value,
width,
position_x,
position_y,
field_id,
template_id 
from le_group_block;

-- group field tempalte setting
select
template_id,
move_unit,
print_text_type,
status,
paper_orientation_id,
paper_size_id,
field_group_type_id 
from le_field_group_template;

-- group field type
select
type_id,
description,
display_seq,
leaf_folder,
status,
group_height,
group_width,
inner_html,
min_x,
min_y,
hospital_code,
parent_type_id,
user_define,
editable,
default_printer,
print_copy
from le_field_group_type;

-- LAAM System Setting --
select param_name, param_value 
from hepr_system_setting where param_name not in ('ehr_cert_mark','encrypt_sftp_log_password', 'ks_constant', 'pmi_external_ks_constant', 'rpt_decrypt_password', 'sftp_passphrase', 'sftp_password');

select domain_id, param_name, param_value 
from hepr_domain_info where param_name not in ('cs_ws_password', 'ds_ws_password', 'encrypt_zip_password', 'ws_password');

select * from hepr_domain_setting;

select * from hepr_report_setting;





-- Get FeedBack --
-- select id, feedback_content,  feedback_name, feedback_phone, feedback_email, app_name, sub_app_name, submit_date from  wheel_feedback_detail;



-- check any duplicate batch in LAAM
SELECT * FROM hepr_batch b1 , hepr_batch b2 where b1.batch_id <  b2.batch_id and b1.create_dtm = b2.create_dtm and b1.record_type = b2.record_type;