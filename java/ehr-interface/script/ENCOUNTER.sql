---------
-- Create in CIS db
----------

create or replace view ehr_enc_pending as
select 
	decode( p.initenctr, null, 'BL-M', 'BL' ) upload_mode, 
	case when p.initenctr is null or ( la.ehr_enc_log_no is null and ld.ehr_enc_log_no is null ) then 'I' 
    when (( la.ehr_enc_log_no is not null and r.regsts = 'C') or ( ld.ehr_enc_log_no is not null and r.regsts = 'C') ) then 'D' 
		when ( la.ehr_enc_log_no is not null or ld.ehr_enc_log_no is not null ) then 'U' 
	end transaction_mode,
	la.ehr_enc_log_no adm_log_no, ld.ehr_enc_log_no dis_log_no,
    r.patno, r.regid, r.regtype, nvl2(r.regdate, to_char(r.regdate, 'yyyy-mm-dd hh24:mi:ss')||'.000', null) as regdate,
    nvl2(i.inpddate, to_char(i.inpddate, 'yyyy-mm-dd hh24:mi:ss')||'.000', null) as inpddate, i.descode, r.doccode, i.doccode_a, i.doccode_d, i.inpid,
    nvl2(re.modify_date, to_char(re.modify_date, 'yyyy-mm-dd hh24:mi:ss')||'.000', null) reg_modify_date, 
    nvl2(re.create_date, to_char(re.create_date, 'yyyy-mm-dd hh24:mi:ss')||'.000', null) reg_create_date, 
    decode(b.bkgid, 0, null, b.bkgid) bkgid, r.daypid, 
    nvl2(b.bkgsdate, to_char(b.bkgsdate, 'yyyy-mm-dd hh24:mi:ss')||'.000', null) as bkgsdate, 
    nvl2(b.bkgsdate, to_char(b.bkgedate, 'yyyy-mm-dd hh24:mi:ss')||'.000', null) as bkgedate, 
    nvl2(b.bkgsdate, to_char(b.bkgcdate, 'yyyy-mm-dd hh24:mi:ss')||'.000', null) as bkgcdate, 
    to_char(greatest(nvl(b.bkgcdate, to_date('1900', 'yyyy')), nvl(b.bkgfdate,to_date('1900', 'yyyy')), nvl(b.bkgadate,to_date('1900', 'yyyy')), nvl(be.bkgudate,to_date('1900', 'yyyy'))), 'yyyy-mm-dd hh24:mi:ss')||'.000' bkg_last_update_date ,
	la.ehr_enc_log_no last_adm_enc_log_no, la.episode_start_specialty last_adm_start_specialty, ( select nvl(e.ehr_spccode, 'OTH') from doctor@hat d, ehr_spccode_mapping@hat e where d.spccode = e.hosp_spccode(+) and d.doccode = decode( r.regtype, 'I', i.doccode_a , r.doccode ) ) adm_start_specialty,
	ld.ehr_enc_log_no last_dis_enc_log_no, ld.episode_end_specialty last_dis_end_specialty, ( select nvl(e.ehr_spccode, 'OTH') from doctor@hat d, ehr_spccode_mapping@hat e where d.spccode = e.hosp_spccode(+) and d.doccode = i.doccode_d ) dis_end_specialty
    from reg@hat r join ehr_pmi@hat p on r.patno = p.patno
    left outer join inpat@hat i on r.inpid = i.inpid 
    left outer join reg_extra@hat re on r.regid = re.regid 
    left outer join booking@hat b on r.bkgid = b.bkgid 
    left outer join booking_extra@hat be on b.bkgid = be.bkgid
    left outer join ehr_enc_log la on la.return_code = '00000' and la.patientkey = r.patno and la.record_key = 'ADM-'||r.regid
         and not exists ( select 1 from ehr_enc_log la2 where la2.return_code = '00000' and la2.patientkey = r.patno and la2.record_key = 'ADM-'||r.regid and la2.ehr_enc_log_no > la.ehr_enc_log_no )
    left outer join ehr_enc_log ld on ld.return_code = '00000' and ld.patientkey = r.patno and ld.record_key = 'DIS-'||r.regid
         and not exists ( select 1 from ehr_enc_log ld2 where ld2.return_code = '00000' and ld2.patientkey = r.patno and ld2.record_key = 'DIS-'||r.regid and ld2.ehr_enc_log_no > ld.ehr_enc_log_no )
  where r.regsts in ('N', 'C') and p.active = -1 and
  ( 
    -- (1) BL-M for both adm/disch
    p.initenctr is null
    -- (2a) BL new admission
    or la.ehr_enc_log_no is null 
    -- (2b) BL new discharge
    or (ld.ehr_enc_log_no is null and i.inpddate is not null)
    -- (3a) BL admission update
	  or ( la.ehr_enc_log_no is not null and ( 
        -- IP
        la.episode_start_specialty != ( select nvl(e.ehr_spccode, 'OTH') from doctor@hat d, ehr_spccode_mapping@hat e where d.spccode = e.hosp_spccode(+) and d.doccode = decode( r.regtype, 'I', i.doccode_a , r.doccode ) )
        or
        -- OP
        la.episode_end_specialty != ( select nvl(e.ehr_spccode, 'OTH') from doctor@hat d, ehr_spccode_mapping@hat e where d.spccode = e.hosp_spccode(+) and d.doccode = decode( r.regtype, 'I', i.doccode_a , r.doccode ) )
                                          ) )
    -- (3b) BL discharge update
	  or ( ld.ehr_enc_log_no is not null and ( ld.episode_start_specialty != ( select nvl(e.ehr_spccode, 'OTH') from doctor@hat d, ehr_spccode_mapping@hat e where d.spccode = e.hosp_spccode(+) and d.doccode = i.doccode_a )
	                                        or ld.episode_end_specialty != ( select nvl(e.ehr_spccode, 'OTH') from doctor@hat d, ehr_spccode_mapping@hat e where d.spccode = e.hosp_spccode(+) and d.doccode = i.doccode_d )
	                                        or nvl( nvl2(i.inpddate, to_char(i.inpddate, 'yyyy-mm-dd hh24:mi:ss')||'.000', null), 'null') != nvl( ld.episode_end_dtm, 'null') )	)                                       
    -- (4) BL admission cancel
    or (
      (la.transaction_type <> 'D' and r.regsts = 'C') or
      (ld.transaction_type <> 'D' and r.regsts = 'C')
    )
  )
  and r.regdate >= to_date((select param1 from sysparam@hat where parcde = 'EHRCF_ENC'), (select param2 from sysparam@hat where parcde = 'EHRCF_ENC'))
  order by r.patno, la.ehr_enc_log_no, ld.ehr_enc_log_no, r.regid;  

create sequence sq_ehr_enc_log_no NOCACHE start with 1;
create sequence sq_ehr_enc_rec_key NOCACHE ;
  
CREATE TABLE "EHR_ENC_LOG"  (
    "EHR_ENC_LOG_NO"            NUMBER(32,0),
-- Participant : begin
-- 1
    "EHR_NO"                    VARCHAR2(12 BYTE),
    "PATIENTKEY"                VARCHAR2(50 BYTE),
    "HKID"                      VARCHAR2(12 BYTE),
    "DOC_TYPE"                  VARCHAR2(6 BYTE),
    "DOC_NO"                    VARCHAR2(30 BYTE),
    "PERSON_ENG_SURNAME"        VARCHAR2(40 BYTE),
    "PERSON_ENG_GIVEN_NAME"     VARCHAR2(40 BYTE),
    "PERSON_ENG_FULL_NAME"      VARCHAR2(100 BYTE),
    "SEX"                       VARCHAR2(1 BYTE),
    "BIRTH_DATE"                VARCHAR2(23 BYTE),
-- 10
    "UPLOADMODE"                VARCHAR2(20 BYTE),
-- Participant : end
    "RECORD_KEY"                VARCHAR2(50 BYTE) NOT NULL ENABLE,
    "RECORD_CREATION_DTM"       VARCHAR2(23 BYTE),
    "RECORD_UPDATE_DTM"         VARCHAR2(23 BYTE),
    "TRANSACTION_DTM"           VARCHAR2(23 BYTE),
    "TRANSACTION_TYPE"          VARCHAR2(1 BYTE),
    "LAST_UPDATE_DTM"           VARCHAR2(23 BYTE),
	"HEALTHCARE_PROV_ID"        VARCHAR2(30 BYTE),
	"HEALTHCARE_INST_ID"        VARCHAR2(30 BYTE),
	"ENCOUNTER_TYPE"            VARCHAR2(6 BYTE),
-- 20
	"TRANSACTION_PROFILE_TYPE"  VARCHAR2(20 BYTE),
    "EPISODE_NO"                VARCHAR2(20 BYTE),
	"EPISODE_ATTENDANCE_IND"    VARCHAR2(6 BYTE),
	"APPOINTMENT_NUMBER"        VARCHAR2(20 BYTE),
	"EPISODE_START_SPECIALTY"   VARCHAR2(30 BYTE),
	"EPISODE_START_DTM"         VARCHAR2(23 BYTE),
	"EPISODE_START_SPECIALTY_REMARK" VARCHAR2(100 BYTE),
	"EPISODE_END_SPECIALTY"     VARCHAR2(30 BYTE),
	"EPISODE_END_DTM"           VARCHAR2(23 BYTE),
	"EPISODE_END_SPECIALTY_REMARK"    VARCHAR2(100 BYTE),
-- 30
	"ENCOUNTER_SERVICE_TYPE"    VARCHAR2(6 BYTE),
	"VISIT_SPECIALTY"           VARCHAR2(30 BYTE),
	"VISIT_NUMBER"              VARCHAR2(30 BYTE),
	"VISIT_DATETIME"            VARCHAR2(23 BYTE),
	"VISIT_SPECIALTY_REMARK"          VARCHAR2(100 BYTE),
	"DISCHARGE_TYPE"            VARCHAR2(20 BYTE),
	"RETURN_CODE"				VARCHAR2(255 BYTE),
	"RETURN_MESSAGE"			VARCHAR2(255 BYTE),
--
  	CONSTRAINT EHR_ENC_LOG_PK PRIMARY KEY ( "EHR_ENC_LOG_NO" ) ) ;

CREATE INDEX EHR_ENC_LOG_PAT_REC_KEY_IDX ON EHR_ENC_LOG ( PATIENTKEY, RECORD_KEY ) ;

--select ehr_enc_log_no, ehr_no, patientkey, hkid, doc_type, doc_no, person_eng_surname, person_eng_given_name, person_eng_full_name, sex, birth_date, uploadmode, record_key, record_creation_dtm, record_update_dtm, transaction_dtm, transaction_type, last_update_dtm, healthcare_prov_id, healthcare_inst_id, encounter_type, transaction_profile_type, episode_no, episode_attendance_ind,	appointment_number,	episode_start_specialty, episode_start_dtm,	episode_start_specialty_remark,	episode_end_specialty, episode_end_dtm,	episode_end_specialty_remark, encounter_service_type, visit_specialty, visit_number, visit_datetime, visit_specialty_remark, discharge_type
--from ehr_enc_log ;

---------
-- initial hats sysparam
---------
select * from sysparam@hat where parcde = 'EHRUL_ENC';

insert into sysparam@hat(parcde, param1, param2, pardesc) values ('EHRUL_ENC', '20171001002000', 'YYYYMMDDHH24MISS', 'Ehr ENC last upload');
update sysparam@hat set param1 = '20171001000000' where parcde = 'EHRUL_ENC';

select * from sysparam@hat where parcde = 'EHRENCDLY';
-- EHRENCDLY	0	day (int)	Ehr ENC upload delay

insert into sysparam@hat(parcde, param1, param2, pardesc) values ('EHRENCDLY', '0', 'day (int)', 'Ehr ENC upload delay');
update sysparam@hat set param1 = 0 where parcde = 'EHRENCDLY';
