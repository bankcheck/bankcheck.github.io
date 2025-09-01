package com.hkah.ehr.service;

import hk.gov.ehr.hepr.ws.Response;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.log4j.Logger;
import org.hl7.v3.EncounterDetail;
import org.hl7.v3.EncounterDetail.Admission;
import org.hl7.v3.EncounterDetail.Discharge;
import org.hl7.v3.CausativeAgent;
import org.hl7.v3.InpatientAdmissionEncounterType;
import org.hl7.v3.InpatientDischargeEncounterType;
import org.hl7.v3.OutpatientAndOtherAdmissionEncounterType;
import org.hl7.v3.Participant;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import test.client.HeprWebServiceClient;

import com.hkah.constant.ConstantsEhr;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.ehr.model.PatientUploadResp;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.ConnUtil;

public class EncounterService {
	private static Logger logger = Logger.getLogger(EncounterService.class);
	private DomainCommonService domainCommonService;
	
	public DomainCommonService getDomainCommonService() {
		return domainCommonService;
	}

	public void setDomainCommonService(DomainCommonService domainCommonService) {
		this.domainCommonService = domainCommonService;
	}
	
	protected Response uploadToEhr(Map<Participant, List<EncounterDetail>> map, String mode, 
			Date startDate, Date endDate){
		return uploadToEhr(map, mode, startDate, endDate, true);
	}
	
	protected Response uploadToEhr(Map<Participant, List<EncounterDetail>> map, String mode, Date startDate, Date endDate, boolean isUpdatePatInit){
		logger.info("Upload to eHR mode: " + mode + " , no. of participant: " + map.size() + ", isUpdatePatInit="+isUpdatePatInit);
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		Response msg = null;
		Date c = new Date();
		
		if (!map.isEmpty()) {
			Date uploadDate = new Date();
			String uploadMode = "";
			if (ConstantsEhr.UPLOAD_MODE_CODE_BLM.equals(mode)){
				uploadMode = ConstantsEhr.UPLOAD_MODE_NAME_BLM;
			} else {
				uploadMode = ConstantsEhr.UPLOAD_MODE_NAME_BL;
			}
	        HeprWebServiceClient wsClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");
	        msg = wsClient.uploadEncounterData(map, uploadMode);
	        boolean isSuccess = ConstantsEhr.UPLOAD_SUCCESS_CODES.containsKey(msg.getResponseCode());
	        List<PatientUploadResp> patientUploadResps = new ArrayList<PatientUploadResp>();
	        
	        logger.debug(mode + " upload finish, response:" + msg.getResponseCode() + " - " + msg.getResponseMessage());
	        ArrayList<String> patErrorList = new ArrayList<String>();
	        if (!msg.getRecordDetail().isEmpty()) {
		        for(int i = 0; i < msg.getRecordDetail().size(); i++){
		        	String patno = msg.getRecordDetail().get(i).getPatientKey();
		        	patientUploadResps.add(new PatientUploadResp(patno, msg.getRecordDetail().get(i).getEhrNo(), null));
		        	
		        	logger.debug(mode + " exception (" + msg.getRecordDetail().get(i).getExceptionType() + "): Patno = " + patno + " Desc = " + msg.getRecordDetail().get(i).getExceptionDescription());
		        	if("e".equals(msg.getRecordDetail().get(i).getExceptionType().toLowerCase())){
		        		patErrorList.add(patno);
		        	}
		        }    
	        } else {
                for (Entry<Participant, List<EncounterDetail>> entry : map.entrySet()) {
                	Participant p = entry.getKey();
                    PatientUploadResp patientUploadResp = new PatientUploadResp(p.getPatientKey(), p.getEhrNo(), null);
                    patientUploadResps.add(patientUploadResp);
                    
                    if (!isSuccess) {
                    	patErrorList.add(p.getPatientKey());
                    }
		        }    
	        }
	        
            // update ehr_enc_log 
			saveEhrEncLog(map, mode, msg);
	        
	        // log upload
			domainCommonService.updateDataUploadLog(patientUploadResps, patErrorList, uploadDate, startDate, endDate, mode, ConstantsEhr.DOMAIN_CODE_ENCTR);
	        
	        // update patient initEnctr
	        if (ConstantsEhr.UPLOAD_MODE_CODE_BLM.equals(mode) && isUpdatePatInit) {
	        	if (isSuccess) {
		        	logger.debug(mode + " Update Patient initEnctr");
		            for (int i = 0; i < patientUploadResps.size(); i++) {
		            	boolean uploadPatInitBirth = true;
		            	// check if uplaod success
		            	for( String ePatNo : patErrorList){
		            		if(ePatNo.equals(patientUploadResps.get(i).getPatNo())){
		            			uploadPatInitBirth = false;
		            		}
		            	}
		            	
		            	if(uploadPatInitBirth == true) {
		            		domainCommonService.updatePatInit(patientUploadResps.get(i).getPatNo(), ConstantsEhr.DOMAIN_CODE_ENCTR);
		            	}
		            }
		        }
	        }
		}
		return msg;
	}
	
	public Response uploadBlank(List<String> patnos) {
		Map<Participant, List<EncounterDetail>> map = new HashMap<Participant, List<EncounterDetail>>();
		 
		 for (String patno : patnos) {
			 List<EncounterDetail> encList = new ArrayList<EncounterDetail>();
			 EncounterDetail encDetail = new EncounterDetail();
			 
			 Admission adm = new Admission();
			 adm.setRecordKey("-1");
			 encDetail.getAdmission().add(adm);
			 encList.add(encDetail);
			 
			 map.put(domainCommonService.participant(patno), encList);
		 }
		 
		 return uploadToEhr(map, ConstantsEhr.UPLOAD_MODE_CODE_BLM, null, null, false);
	}

	private Map<Participant, List<EncounterDetail>> getEhrEncounter(
			Map<Participant, List<EncounterDetail>> map, String mode, String delay){		
		PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;

		try {
			/**
			 * for OP, Daycase: only upload after regdate + 5 (ensure no update/cancel) 
			 * for IP: only upload after discharge + 5 (ensure no update/cancel)
			 */
			sql = "select tx_profile_type_prefix, upload_mode, patno, regid, regtype, regdate, inpddate, descode, doccode, ";
			sql += "doccode_a, doccode_d, inpid, reg_modify_date, reg_create_date,bkgid, daypid, ";
			sql += "bkgsdate, bkgedate, bkgcdate, bkg_last_update_date, ";
			sql += "transaction_mode, last_adm_enc_log_no, last_adm_start_specialty, adm_start_specialty, last_dis_enc_log_no, last_dis_end_specialty, dis_end_specialty";
			sql += " from ehr_enc_pending ";
			sql += "where upload_mode = '" + mode + "'" ;
			
			logger.debug("getEhrEncounter sql=" + sql);

			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);
        	rs = ps.executeQuery();

        	while (rs.next()) {
        		String patno = rs.getString("patno");
        		
        		Participant patPatnoOnly = new Participant();
        		Participant pat = null;
        		patPatnoOnly.setPatientKey(patno);
        		List<EncounterDetail> details = null;
        		
        		for (Map.Entry<Participant, List<EncounterDetail>> pair : map.entrySet()) {
        			Participant key = pair.getKey();
        			try {
	        			if (patPatnoOnly.getPatientKey().equals(key.getPatientKey())) {
	        				pat = key;
	        				details = map.get(pat);
	        				if (map.get(pat) == null) {
	        					details = new ArrayList<EncounterDetail>();
	        					map.put(pat, details);
	        				}
	        			}
        			} catch (Exception e) {}
        		}
        		if (pat == null) {
        			pat = domainCommonService.participant(patno);
        			details = new ArrayList<EncounterDetail>();
        			map.put(pat, details);
        		}
        		
        		EncounterDetail detail = null;
        		if (details.isEmpty()) {
        			detail = new EncounterDetail();
        			details.add(detail);
        		} else {
        			detail = details.get(0);	// always use 1 detail object
        		}
        		
        		logger.debug(" [EncounterDetail] detail="+detail);
        		
	        		Date currentDate = new Date();
	        		
	        		String regType = rs.getString("regtype");
        			String regID = rs.getString("regid");
        			String regDate = rs.getString("regdate");
        			String bkgid = rs.getString("bkgid");
        			String bkgsdate = rs.getString("bkgsdate");
        			String daypid = rs.getString("daypid");
        			String hcp_id = FactoryBase.getInstance().getSysparamValue("hcp_id");
        			String hci_id = FactoryBase.getInstance().getSysparamValue("hci_id");
        			String transactionProfileTypePrefix = rs.getString("tx_profile_type_prefix");
        			String transactionType = rs.getString("transaction_mode");
        			String encounterType = ("D".equals(regType) ? "O" : (("I".equals(regType) || "O".equals(regType)) ? regType : "H"));
        			String serviceType = ("O".equals(regType) ? "OPD" : ("D".equals(regType)) ? "DAY" : "OTH");
        			String specialtyCode = null;
        			String dischargeDate = rs.getString("inpddate");
        			
        	        String recordKeyAdm = regID;
        	        String lastAdmEncLogNo = rs.getString("last_adm_enc_log_no");
        	        String lastDisEncLogNo = rs.getString("last_dis_enc_log_no");
        	        
        	        /*
        	         * no upload appointment 
        	         * String recordKeyAppt = bkgid;
        	         * 
        			if (bkgid != null) {
	        			//Appointment Part
	        	        List<Appointment> atList = detail.getAppointment();
	        	        Appointment appointment = new Appointment();

	        	        appointment.setRecordKey(recordKeyAppt);
	        	        appointment.setTransactionDtm(DateTimeUtil.formatEhrDateTime(currentDate));
	        	        appointment.setTransactionType(transactionType);
	        	        appointment.setLastUpdateDtm(rs.getString("bkg_last_update_date"));		// The last update datetime for HCP system
	        	        appointment.setRecordCreationDtm(rs.getString("BKGCDATE"));
	        	        appointment.setRecordUpdateDtm(rs.getString("bkg_last_update_date"));
	        	        
	        	        String apptTransactionProfileType = null;
	        	        if("I".equals(regType)){	// SCN1 (APP-IP)
	        	        	apptTransactionProfileType = "APP-IP";
	        	        	
	        	        	InpatientAppointmentEncounterType inpatApptEncType = new InpatientAppointmentEncounterType();
	        	        	inpatApptEncType.setEpisodeNo(regID);
	        	        	inpatApptEncType.setAppointmentNumber(bkgid);
	        	        	inpatApptEncType.setEpisodeStartDtm(bkgsdate);
	        	        	
	        	        	appointment.setInpatientAppointmentEncounterType(inpatApptEncType);
	        	        } else if ("O".equals(regType) || "D".equals(regType)) {	// OP SCN2 (APP-OP-EP)	// DC SCN2 (APP-OTH)
	        	        	apptTransactionProfileType = "APP-OP-EP";
	        	        	
	        	        	OutpatientAppointmentEncounterType outPatApptEncType = new OutpatientAppointmentEncounterType();
	        	        	outPatApptEncType.setEpisodeNo(regID);
	        	        	outPatApptEncType.setEncounterServiceType(serviceType);
	        	        	outPatApptEncType.setAppointmentNumber(bkgid);
	        	        	outPatApptEncType.setEpisodeStartDtm(bkgsdate);
	        	        	outPatApptEncType.setVisitDatetime(bkgsdate);
	        	        	
	        	        	appointment.setOutpatientAppointmentEncounterType(outPatApptEncType);
	        	        } else {	// other SCN3 (APP-OTH)
	        	        	apptTransactionProfileType = "APP-OTH";
	        	        	
	        	        	OtherAppointmentEncounterType otherApptEncType = new OtherAppointmentEncounterType();
	        	        	otherApptEncType.setEpisodeNo(regID);
	        	        	otherApptEncType.setEncounterServiceType(serviceType);
	        	        	otherApptEncType.setAppointmentNumber(bkgid);
	        	        	otherApptEncType.setEpisodeStartDtm(bkgsdate);
	        	        	otherApptEncType.setVisitDatetime(bkgsdate);
	        	        	otherApptEncType.setVisitAttendInd("A");	// A - Attended, C - Cancelled, N - Not attended
	        	        	
	        	        	appointment.setOtherAppointmentEncounterType(otherApptEncType);
	        	        }
	        	        appointment.setTransactionProfileType(apptTransactionProfileType);
	        	        appointment.setHealthcareProvId(hcp_id);
	        	        appointment.setHealthcareInstId(hci_id);
	        	        appointment.setEncounterType(encounterType);
	        	        
	        	        atList.add(appointment);
	        	        
	        	        logger.debug("  [appointment] recordKey=" + recordKeyAppt + ", encounterType="+encounterType+", serviceType="+serviceType+", regType=" + regType + ", bkgsdate="+bkgsdate);
        			}
        			*/
        	        
        	        if (transactionProfileTypePrefix != null && transactionProfileTypePrefix.startsWith("ADM")) {	// admission
	        	        //Admission Part
	        	        List<Admission> aList = detail.getAdmission();
	        	        Admission admission = new Admission();
	        	        
	        	        admission.setRecordKey(recordKeyAdm);
	        	        admission.setTransactionDtm(DateTimeUtil.formatEhrDateTime(currentDate));
	        	        admission.setTransactionType(transactionType);
	        	        admission.setLastUpdateDtm(rs.getString("REG_MODIFY_DATE"));
	        	        admission.setHealthcareProvId(hcp_id);
	        	        admission.setHealthcareInstId(hci_id);
	        	        
	        	        admission.setEncounterType(encounterType);
	        	        admission.setRecordCreationDtm(rs.getString("REG_CREATE_DATE"));
	        	        admission.setRecordUpdateDtm(rs.getString("REG_MODIFY_DATE"));
	        	        
	        	        
	        	       if("I".equals(regType)){	// SCN10 (ADM-IP)
	        	    	    String docCode_A = rs.getString("doccode_a");
	        	    	    specialtyCode = getDocSpec(docCode_A);
	        	    	   
	        	        	admission.setTransactionProfileType("ADM-IP");
	        	        	
	        	        	InpatientAdmissionEncounterType inpatEncType = new InpatientAdmissionEncounterType();
	        	        	inpatEncType.setEpisodeNo(regID);
	        	        	inpatEncType.setEpisodeStartDtm(regDate);
	        	        	inpatEncType.setEpisodeAttendanceInd("A");
	        	        	inpatEncType.setAppointmentNumber(bkgid);
	    	       			try {
	        	       			String[] spcDesc = specialtyCode.split(":");
	        	       			
	        	       			inpatEncType.setEpisodeStartSpecialty(spcDesc[0]);
	        	       			if (spcDesc.length > 1) {
	        	       				inpatEncType.setEpisodeStartSpecialtyRemark(spcDesc[1]);
	        	       			}
	    	       			} catch (Exception e) {
	    	       				logger.debug("(ADM-IP) Cannot get spcDesc from specialtyCode=<" + specialtyCode + ">");
	    	       			}
	    	       			
	        	        	admission.setInpatientAdmissionEncounterType(inpatEncType);
	        	        } else {	// OP SCN12 (ADM-OP-EP)	// DC SCN13 (ADM-OTH)
	        	        	String docCode = rs.getString("doccode");
	        	        	specialtyCode = getDocSpec(docCode);
	        	        	
	        	        	admission.setTransactionProfileType("ADM-OP-EP");
	        	        	
	        	        	OutpatientAndOtherAdmissionEncounterType outPatEncType = new OutpatientAndOtherAdmissionEncounterType();
	        	        	outPatEncType.setEpisodeNo(regID);
	        	        	outPatEncType.setEpisodeStartDtm(regDate);
	        	        	outPatEncType.setEpisodeAttendanceInd("A");
	        	        	outPatEncType.setAppointmentNumber(bkgid);
	        	        	outPatEncType.setEncounterServiceType(serviceType);
	        	        	outPatEncType.setVisitNumber(daypid);
	        	        	outPatEncType.setVisitDatetime(regDate);
	        	        	outPatEncType.setVisitAttendInd("A");	// A - Attended
	    	       			try {
	        	       			String[] spcDesc = specialtyCode.split(":");
	        	       			
	            	        	outPatEncType.setEpisodeStartSpecialty(spcDesc[0]);
	            	        	outPatEncType.setEpisodeEndSpecialty(spcDesc[0]);
	            	        	outPatEncType.setVisitSpecialty(spcDesc[0]);
	        	       			if (spcDesc.length > 1) {
	            	       			outPatEncType.setEpisodeStartSpecialtyRemark(spcDesc[1]);
	            	        		outPatEncType.setEpisodeEndSpecialtyRemark(spcDesc[1]);
	            	        		outPatEncType.setVisitSpecialtyRemark(spcDesc[1]);
	        	       			}
	    	       			} catch (Exception e) {
	    	       				logger.debug("(ADM-OP-EP) Cannot get spcDesc from specialtyCode=<" + specialtyCode + ">");
	    	       			}
	    	       			
	        	        	admission.setOutpatientAndOtherAdmissionEncounterType(outPatEncType);
	        	        }
	        	       	aList.add(admission);
	        	       	logger.debug("  [admission] recordKey=" + recordKeyAdm + ", encounterType="+encounterType+", serviceType=" + serviceType + ", regType="+regType+", regDate="+regDate + ", specialtyCode="+specialtyCode);
        	        } else if (transactionProfileTypePrefix != null && transactionProfileTypePrefix.startsWith("DIS")) {
	        	        
	        	       	//Discharge part (SCN22)
	        	       	String recordKeyDis = regID;
	        	       	
	        			String inpid = rs.getString("inpid");
        	       		String dischargeType = rs.getString("DESCODE");
        	       		String docCode_A = rs.getString("doccode_a");
        	       		String docCode_D = rs.getString("doccode_d");
        	       		
        	       		List<Discharge> dList = detail.getDischarge();
        	       		Discharge discharge = new Discharge();

        	       		discharge.setRecordKey(recordKeyDis);
        	       		discharge.setTransactionDtm(DateTimeUtil.formatEhrDateTime(currentDate));	   
        	       		discharge.setTransactionType(transactionType);
        	       		discharge.setLastUpdateDtm(rs.getString("REG_MODIFY_DATE"));
        	       		discharge.setTransactionProfileType("DIS-IP");
        	       		discharge.setHealthcareProvId(hcp_id);
        	       		discharge.setHealthcareInstId(hci_id);        	       		
        	       		discharge.setEncounterType("I");
        	       		
        	       		discharge.setRecordCreationDtm(rs.getString("REG_CREATE_DATE"));
        	       		discharge.setRecordUpdateDtm(rs.getString("REG_MODIFY_DATE"));
        	       		
        	       		String spcCodeStart = getDocSpec(docCode_A);
        	       		String spcCodeEnd = getDocSpec(docCode_D);
        	       		
        	       		InpatientDischargeEncounterType inpatDisEncType = new InpatientDischargeEncounterType();
        	       		inpatDisEncType.setEpisodeNo(regID);
        	       		inpatDisEncType.setEpisodeStartDtm(regDate);
    	       			try {
        	       			String[] spcDesc = spcCodeStart.split(":");
        	       			
        	       			inpatDisEncType.setEpisodeStartSpecialty(spcDesc[0]);
        	       			if (spcDesc.length > 1) {
        	       				inpatDisEncType.setEpisodeStartSpecialtyRemark(spcDesc[1]);
        	       			}
    	       			} catch (Exception e) {
    	       				logger.debug("(DIS-IP) Cannot get spcDesc from spcCodeStart=<" + spcCodeStart + ">");
    	       			}
        	       		inpatDisEncType.setEpisodeEndDtm(dischargeDate);
        	       		inpatDisEncType.setEpisodeAttendanceInd("A");
    	       			try {
        	       			String[] spcDesc = spcCodeEnd.split(":");
        	       			
        	       			inpatDisEncType.setEpisodeEndSpecialty(spcDesc[0]);
        	       			if (spcDesc.length > 1) {
        	       				inpatDisEncType.setEpisodeEndSpecialtyRemark(spcDesc[1]);
        	       			}
    	       			} catch (Exception e) {
    	       				logger.debug("(DIS-IP) Cannot get spcDesc from spcCodeEnd=<" + spcCodeEnd + ">");
    	       			}
    	       			if (dischargeType != null && !dischargeType.isEmpty()) {
	    	       			if("HOME".equals(dischargeType)){
	        	       			inpatDisEncType.setDischargeType("HFU");
	        	       		} else if("DEATH".equals(dischargeType)){
	        	       			inpatDisEncType.setDischargeType("DEATH");
	        	       		} else if("HOSP".equals(dischargeType)){
	        	       			inpatDisEncType.setDischargeType("NACUTE");
	        	       		} else {
	        	       			inpatDisEncType.setDischargeType("OTHER");
	        	       		}
    	       			}
        	       		
        	       		discharge.setInpatientDischargeEncounterType(inpatDisEncType);
        	       		
        	       		// record key cannot be the same at same upload batch, so separate it for adm and discharge change at the saem time
        	       		boolean isRecordKeyCollide = false;
        	       		for (Admission adm : detail.getAdmission()) {
        	       			if (adm.getRecordKey().equals(recordKeyDis)) {
        	       				isRecordKeyCollide = true;
        	       			}
        	       		}
        	       		if (!isRecordKeyCollide) {
        	       			dList.add(discharge);
        	       			
        	       			logger.debug("  [discharge] recordKey=" + recordKeyDis + ", inpid="+inpid+", dischargeDate=" + dischargeDate);
        	       		}
        	        }
        	}
        } catch (Exception e) {
            logger.error("Error getting Ehr Encounter: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();        		
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("Cannot close connection");
                e.printStackTrace();
        	}
        }
        
		return map;
	}
	
	private void saveEhrEncLog(Map<Participant, List<EncounterDetail>> map, String mode, Response msg) {
		logger.debug("insert into ehr_enc_log: ");
		
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        InpatientAdmissionEncounterType i = null;
        OutpatientAndOtherAdmissionEncounterType o = null;
        InpatientDischargeEncounterType id = null;
        
		try {
			sql = "insert into ehr_enc_log ( ehr_enc_log_no, ehr_no, patientkey, hkid, doc_type, doc_no, person_eng_surname, person_eng_given_name, person_eng_full_name, sex, birth_date, uploadmode, record_key, record_creation_dtm, record_update_dtm, transaction_dtm, transaction_type, last_update_dtm, healthcare_prov_id, healthcare_inst_id, encounter_type, transaction_profile_type, episode_no, episode_attendance_ind, appointment_number, episode_start_specialty, episode_start_dtm, episode_start_specialty_remark, episode_end_specialty, episode_end_dtm, episode_end_specialty_remark, encounter_service_type, visit_specialty, visit_number, visit_datetime, visit_specialty_remark, discharge_type, return_code, return_message ) ";
			sql += " values ( sq_ehr_enc_log_no.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " ;
			sql += " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " ;
			sql += " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " ;
			sql += " ?, ?, ?, ?, ?, ?, ?, ? ) " ;
			conn = ConnUtil.getDataSourceCIS().getConnection();
			ps = conn.prepareStatement(sql);
			
			for (Entry<Participant, List<EncounterDetail>> entry : map.entrySet()) {
            	Participant p = entry.getKey();
            	
            	
				ps.setString(1, p.getEhrNo() );
				ps.setString(2, p.getPatientKey() );
				ps.setString(3, p.getHkid() );
				ps.setString(4, p.getDocType() );
				ps.setString(5, p.getDocNo() );
				ps.setString(6, p.getPersonEngSurname() );
				ps.setString(7, p.getPersonEngGivenName() );
				ps.setString(8, p.getPersonEngFullName() );
				ps.setString(9, p.getSex() );
				ps.setString(10, p.getBirthDate() );
				ps.setString(11, mode );
				// stop at here
				ps.setString(37, msg.getResponseCode() );
				ps.setString(38, msg.getResponseMessage() );
            	for ( EncounterDetail ed : entry.getValue() ) {
            		for ( Admission a : ed.getAdmission() ) {
            			ps.setString(12, a.getRecordKey());
            			ps.setString(13, a.getRecordCreationDtm());
            			ps.setString(14, a.getRecordUpdateDtm());
            			ps.setString(15, a.getTransactionDtm());
            			ps.setString(16, a.getTransactionType());
            			ps.setString(17, a.getLastUpdateDtm());
            			ps.setString(18, a.getHealthcareProvId());
            			ps.setString(19, a.getHealthcareInstId());
            			ps.setString(20, a.getEncounterType());
            			ps.setString(21, a.getTransactionProfileType());
            			
            			i = a.getInpatientAdmissionEncounterType();
            			if ( i != null ) {
                			ps.setString(22, i.getEpisodeNo());
                			ps.setString(23, i.getEpisodeAttendanceInd());
                			ps.setString(24, i.getAppointmentNumber());
                			ps.setString(25, i.getEpisodeStartSpecialty());
                			ps.setString(26, i.getEpisodeStartDtm());
                			ps.setString(27, i.getEpisodeStartSpecialtyRemark());
            			} else {
                			ps.setString(22, null);
                			ps.setString(23, null);
                			ps.setString(24, null);
                			ps.setString(25, null);
                			ps.setString(26, null);
                			ps.setString(27, null);
            			}
            			o = a.getOutpatientAndOtherAdmissionEncounterType();
            			if ( o != null) {
            				ps.setString(25, o.getEpisodeStartSpecialty());
            				ps.setString(26, o.getEpisodeStartDtm());
            				ps.setString(27, o.getEpisodeStartSpecialtyRemark());
                			ps.setString(28, o.getEpisodeEndSpecialty());
                			ps.setString(29, o.getEpisodeEndDtm());
                			ps.setString(30, o.getEpisodeEndSpecialtyRemark());
                			ps.setString(31, o.getEncounterServiceType());
                			ps.setString(32, o.getVisitSpecialty());
                			ps.setString(33, o.getVisitNumber());
                			ps.setString(34, o.getVisitDatetime());
                			ps.setString(35, o.getVisitSpecialtyRemark());
                			ps.setString(36, o.getDischargeType());
            			} else {
                			ps.setString(28, null);
                			ps.setString(29, null);
                			ps.setString(30, null);
                			ps.setString(31, null);
                			ps.setString(32, null);
                			ps.setString(33, null);
                			ps.setString(34, null);
                			ps.setString(35, null);
                			ps.setString(36, null);
            			}
            			ps.addBatch();
            		}
            		for ( Discharge d : ed.getDischarge() ) {
            			ps.setString(12, d.getRecordKey());
            			ps.setString(13, d.getRecordCreationDtm());
            			ps.setString(14, d.getRecordUpdateDtm());
            			ps.setString(15, d.getTransactionDtm());
            			ps.setString(16, d.getTransactionType());
            			ps.setString(17, d.getLastUpdateDtm());
            			ps.setString(18, d.getHealthcareProvId());
            			ps.setString(19, d.getHealthcareInstId());
            			ps.setString(20, d.getEncounterType());
            			ps.setString(21, d.getTransactionProfileType());
            			
            			id = d.getInpatientDischargeEncounterType() ;
            			if ( id != null ) {
                			ps.setString(22, id.getEpisodeNo());
                			ps.setString(23, id.getEpisodeAttendanceInd());
                			ps.setString(24, id.getAppointmentNumber());
                			ps.setString(25, id.getEpisodeStartSpecialty());
                			ps.setString(26, id.getEpisodeStartDtm());
                			ps.setString(27, id.getEpisodeStartSpecialtyRemark());
                			ps.setString(28, id.getEpisodeEndSpecialty());
                			ps.setString(29, id.getEpisodeEndDtm());
                			ps.setString(30, id.getEpisodeEndSpecialtyRemark());
            			} else {
                			ps.setString(22, null);
                			ps.setString(23, null);
                			ps.setString(24, null);
                			ps.setString(25, null);
                			ps.setString(26, null);
                			ps.setString(27, null);
                			ps.setString(28, null);
                			ps.setString(29, null);
                			ps.setString(30, null);
            			}
            			ps.setString(31, null);
            			ps.setString(32, null);
            			ps.setString(33, null);
            			ps.setString(34, null);
            			ps.setString(35, null);
            			ps.setString(36, id.getDischargeType());
            			ps.addBatch();
            		}
            	}
				
	        }
			ps.executeBatch();
		} catch (Exception e) {
            logger.error("Error");
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("Cannot close connection");
                e.printStackTrace();
        	}
        }		
	}
	
	private String getDocSpec(String docCode) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        String spcCode = null;
		
		try {
			sql = "SELECT nvl(E.EHR_SPCCODE, 'OTH' || ':' || INITCAP(S.SPCNAME)) FROM DOCTOR D, EHR_SPCCODE_MAPPING E, SPEC S WHERE D.SPCCODE = E.HOSP_SPCCODE(+) AND D.SPCCODE = S.SPCCODE(+) AND D.DOCCODE = '" + docCode + "'";
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			if (rs.next()) {
				spcCode = rs.getString(1);
			}
		} catch (Exception e) {
            logger.error("Error");
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("Cannot close connection");
                e.printStackTrace();
        	}
        }		
		
		return spcCode;
	}
}
