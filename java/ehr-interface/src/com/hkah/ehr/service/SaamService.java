package com.hkah.ehr.service;

import hk.gov.ehr.alert.ws.beans.common.EhrPatientDTO;
import hk.gov.ehr.hepr.ws.Response;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.hl7.v3.AllergyDetail;
import org.hl7.v3.CausativeAgent;
import org.hl7.v3.Participant;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import test.client.HeprWebServiceClient;

import com.hkah.constant.ConstantsEhr;
import com.hkah.ehr.model.PatientUploadResp;

public class SaamService {
	private static Logger logger = Logger.getLogger(SaamService.class);
	
	private DomainCommonService domainCommonService;
	
	public DomainCommonService getDomainCommonService() {
		return domainCommonService;
	}

	public void setDomainCommonService(DomainCommonService domainCommonService) {
		this.domainCommonService = domainCommonService;
	}
	
	//=== ADR ===
	protected Response uploadToEhrAdr(Map<Participant,List<CausativeAgent>> map, String mode, 
			List<PatientUploadResp> patientUploadResps, Date startDate, Date endDate){
		return uploadToEhrAdr(map, mode, patientUploadResps, startDate, endDate, true);
	}
	
	protected Response uploadToEhrAdr(Map<Participant,List<CausativeAgent>> map, String mode, 
			List<PatientUploadResp> patientUploadResps, Date startDate, Date endDate, boolean isUpdatePatInit){
		logger.debug("Upload to eHR mode: " + mode + " , no. of participant: " + map.size() + ", isUpdatePatInit="+isUpdatePatInit);
		Set<Participant> keys = map.keySet();
		Iterator<Participant> itr = keys.iterator();
		while (itr.hasNext()) {
			Participant p = itr.next();
			if (p != null) {
				List<CausativeAgent> list = map.get(p);
				int listSize = (list != null ? list.size() : 0);
				logger.debug("  Patno: " + p.getPatientKey() + " (eHR No.: " + p.getEhrNo() + "), list size: " + listSize);
			}
		}
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		Response msg = null;
		
		if (!map.isEmpty()) {
			Date uploadDate = new Date();
			String uploadMode = "";
			if ("DM".equals(mode)){
				uploadMode = "BL-M";
			} else {
				uploadMode = "BL";
			}
	        HeprWebServiceClient wsClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");
	        msg = wsClient.uploadAdrData(map, uploadMode);        
	        ArrayList<String> patErrorList = new ArrayList<String>();
	        
	        logger.debug(mode + " upload finish, response:" + msg.getResponseCode() + " - " + msg.getResponseMessage());
	        
	        for(int i = 0; i < msg.getRecordDetail().size(); i++){
	        	logger.debug(mode + " exception (" + msg.getRecordDetail().get(i).getExceptionType() + "): Patno = " + msg.getRecordDetail().get(i).getPatientKey() + " Desc = " + msg.getRecordDetail().get(i).getExceptionDescription());
	        	if("e".equals(msg.getRecordDetail().get(i).getExceptionType().toLowerCase())){
	        		patErrorList.add(msg.getRecordDetail().get(i).getPatientKey());
	        	}
	        }    
	        
	        // log upload
	        domainCommonService.updateDataUploadLog(patientUploadResps, patErrorList, uploadDate, startDate, endDate, mode, ConstantsEhr.DOMAIN_CODE_ADR);
	        
	        // update patient initadr
	        if ("DM".equals(mode) && isUpdatePatInit) {
		        if(msg.getResponseCode().equals("00000") || msg.getResponseCode().equals("00001") || msg.getResponseCode().equals("00002")){
		        	logger.debug(mode + " Update Patient " + domainCommonService.getInitColName(ConstantsEhr.DOMAIN_CODE_ADR));
		        	 for (int i = 0; i < patientUploadResps.size(); i++) {
		             	boolean uploadPatInitAdr = true;
		             	for( String ePatNo : patErrorList){
		             		if(ePatNo.equals(patientUploadResps.get(i).getPatNo())){
		             			uploadPatInitAdr = false;
		             		}
		             	}
		             	
		             	if(uploadPatInitAdr == true) {
		             		domainCommonService.updatePatInit(patientUploadResps.get(i).getPatNo(), ConstantsEhr.DOMAIN_CODE_ADR);
		             	}
		             }
		        }
	        }
		}
		
		return msg;
	}
	
	public Response uploadBlankAdr(List<String> patnos) {
		 Map<Participant,List<CausativeAgent>> map = new HashMap<Participant,List<CausativeAgent>>();
		 List<PatientUploadResp> patientUploadResps = domainCommonService.getEhrPatnos(patnos, ConstantsEhr.DOMAIN_CODE_ADR);
		 
		 for (String patno : patnos) {
			 List<CausativeAgent> caList = new ArrayList<CausativeAgent>();
			 caList.add(new CausativeAgent());
			 map.put(domainCommonService.participant(patno), caList);
		 }
		 
		 return uploadToEhrAdr(map, ConstantsEhr.UPLOAD_MODE_CODE_BLM, patientUploadResps, null, null, false);
	}
	
	//=== Allergy ===
	protected Response uploadToEhrAllergy(Map<Participant,List<AllergyDetail>> map, String mode, 
			List<PatientUploadResp> patientUploadResps, Date startDate, Date endDate){
		return uploadToEhrAllergy(map, mode, patientUploadResps, startDate, endDate, true);
	}
	
	protected Response uploadToEhrAllergy(Map<Participant,List<AllergyDetail>> map, String mode, 
			List<PatientUploadResp> patientUploadResps, Date startDate, Date endDate, boolean isUpdatePatInit){
		logger.debug("Upload to eHR mode: " + mode + " , no. of participant: " + map.size());
		Set<Participant> keys = map.keySet();
		Iterator<Participant> itr = keys.iterator();
		while (itr.hasNext()) {
			Participant p = itr.next();
			if (p != null) {
				List<AllergyDetail> list = map.get(p);
				int listSize = (list != null ? list.size() : 0);
				logger.debug("  Patno: " + p.getPatientKey() + " (eHR No.: " + p.getEhrNo() + "), list size: " + listSize);
			}
		}
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		Response msg = null;
		
		if (!map.isEmpty()) {
			Date uploadDate = new Date();
			String uploadMode = "";
			if ("DM".equals(mode)){
				uploadMode = "BL-M";
			} else {
				uploadMode = "BL";
			}
	        HeprWebServiceClient wsClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");
	        msg = wsClient.uploadAllergyData(map, uploadMode);        
	        ArrayList<String> patErrorList = new ArrayList<String>();
	        
	        logger.debug(mode + " upload finish, response:" + msg.getResponseCode() + " - " + msg.getResponseMessage());
	        
	        for(int i = 0; i < msg.getRecordDetail().size(); i++){
	        	logger.debug(mode + " exception (" + msg.getRecordDetail().get(i).getExceptionType() + "): Patno = " + msg.getRecordDetail().get(i).getPatientKey() + " Desc = " + msg.getRecordDetail().get(i).getExceptionDescription());
	        	if("e".equals(msg.getRecordDetail().get(i).getExceptionType().toLowerCase())){
	        		patErrorList.add(msg.getRecordDetail().get(i).getPatientKey());
	        	}
	        }    
	        
	        // log upload
	        domainCommonService.updateDataUploadLog(patientUploadResps, patErrorList, uploadDate, startDate, endDate, mode, ConstantsEhr.DOMAIN_CODE_ALLERGY);
	        
	        // update patient initadr
	        if ("DM".equals(mode) && isUpdatePatInit) {
		        if(msg.getResponseCode().equals("00000") || msg.getResponseCode().equals("00001") || msg.getResponseCode().equals("00002")){
		        	logger.debug(mode + " Update Patient " + domainCommonService.getInitColName(ConstantsEhr.DOMAIN_CODE_ALLERGY));
		        	 for (int i = 0; i < patientUploadResps.size(); i++) {
		             	boolean uploadPatInitAdr = true;
		             	for( String ePatNo : patErrorList){
		             		if(ePatNo.equals(patientUploadResps.get(i).getPatNo())){
		             			uploadPatInitAdr = false;
		             		}
		             	}
		             	
		             	if(uploadPatInitAdr == true) {
		             		domainCommonService.updatePatInit(patientUploadResps.get(i).getPatNo(), ConstantsEhr.DOMAIN_CODE_ALLERGY);
		             	}
		             }
		        }
	        }
		}
		
		return msg;
	}
	
	public Response uploadBlankAllergy(List<String> patnos) {
		 Map<Participant,List<AllergyDetail>> map = new HashMap<Participant,List<AllergyDetail>>();
		 List<PatientUploadResp> patientUploadResps = domainCommonService.getEhrPatnos(patnos, ConstantsEhr.DOMAIN_CODE_ALLERGY);
		 
		 for (String patno : patnos) {
			 List<AllergyDetail> algList = new ArrayList<AllergyDetail>();
			 algList.add(new AllergyDetail());
			 map.put(domainCommonService.participant(patno), algList);
		 }
		 
		 return uploadToEhrAllergy(map, ConstantsEhr.UPLOAD_MODE_CODE_BLM, patientUploadResps, null, null, false);
	}
	
	//=== utils ===
	public EhrPatientDTO convertParticipant2EhrPatientDTO(Participant p) {
		EhrPatientDTO ep = new EhrPatientDTO();
		if (p != null) {
			ep.setEhrNo(p.getEhrNo());
			ep.setPersonEngSurName(p.getPersonEngSurname());
			ep.setPersonEngGivenName(p.getPersonEngGivenName());
			ep.setPersonEngFullName(p.getPersonEngFullName());
			ep.setSex(p.getSex());
			ep.setHkid(StringUtils.trim(p.getHkid()));	// must trim the leading space
			ep.setDocType(p.getDocType());
			ep.setDocNum(p.getDocNo());
			ep.setBirthDate(p.getBirthDate());
		}
		
		return ep;
	}
}
