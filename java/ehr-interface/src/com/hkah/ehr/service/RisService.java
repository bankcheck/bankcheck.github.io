package com.hkah.ehr.service;

import hk.gov.ehr.hepr.ws.Response;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.log4j.Logger;
import org.hl7.v3.Participant;
import org.hl7.v3.RadiologyDetail;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import test.client.HeprWebServiceClient;

import com.hkah.constant.ConstantsEhr;
import com.hkah.ehr.model.PatientUploadResp;

public class RisService {
	private static Logger logger = Logger.getLogger(RisService.class);
	
	private DomainCommonService domainCommonService;
	
	public DomainCommonService getDomainCommonService() {
		return domainCommonService;
	}

	public void setDomainCommonService(DomainCommonService domainCommonService) {
		this.domainCommonService = domainCommonService;
	}
	
	public Response uploadBlank(List<String> patnos) {
		logger.info("[uploadBlankRad]");
		
		Map<Participant, RadiologyDetail> map = new HashMap<Participant, RadiologyDetail>();
		for (String patno : patnos) {
			RadiologyDetail radDetail = new RadiologyDetail();
			map.put(getDomainCommonService().getEhrHl7Participant4DomainByPatNo(patno), radDetail);
		}
		 
		return uploadToEhr(map, ConstantsEhr.UPLOAD_MODE_CODE_BLM, false);
	}
	
	public Response uploadToEhr(Map<Participant, RadiologyDetail> map, String mode, boolean isUpdatePatInit){
		logger.info("Upload to eHR mode: " + mode + " , no. of participant: " + map.size() + ", isUpdatePatInit="+isUpdatePatInit);
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		HeprWebServiceClient heprWebServiceClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");
		
		Response msg = null;
		Map<String,File> fileMap_BL_M = new HashMap<String,File>() ;
		
		Date uploadDate = new Date();
		String uploadMode = "";
		if (ConstantsEhr.UPLOAD_MODE_CODE_BLM.equals(mode)){
			uploadMode = ConstantsEhr.UPLOAD_MODE_NAME_BLM;
		} else {
			uploadMode = ConstantsEhr.UPLOAD_MODE_NAME_BL;
		}
		
		msg = heprWebServiceClient.uploadRadData(map, fileMap_BL_M, uploadMode);
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
            for (Entry<Participant, RadiologyDetail> entry : map.entrySet()) {
            	Participant p = entry.getKey();
                PatientUploadResp patientUploadResp = new PatientUploadResp(p.getPatientKey(), p.getEhrNo(), null);
                patientUploadResps.add(patientUploadResp);
                
                if (!isSuccess) {
                	patErrorList.add(p.getPatientKey());
                }
            }  
        }
        
        // update patient initEnctr
        if (ConstantsEhr.UPLOAD_MODE_CODE_BLM.equals(mode) && isUpdatePatInit) {
        	if (isSuccess) {
	        	logger.debug(mode + " Update Patient init");
	            for (int i = 0; i < patientUploadResps.size(); i++) {
	            	boolean uploadPatInitBirth = true;
	            	// check if uplaod success
	            	for( String ePatNo : patErrorList){
	            		if(ePatNo.equals(patientUploadResps.get(i).getPatNo())){
	            			uploadPatInitBirth = false;
	            		}
	            	}
	            	
	            	if(uploadPatInitBirth == true) {
	            		domainCommonService.updatePatInit(patientUploadResps.get(i).getPatNo(), ConstantsEhr.DOMAIN_CODE_RADI);
	            	}
	            }
	        }
        }
        
		return msg;
	}
}
