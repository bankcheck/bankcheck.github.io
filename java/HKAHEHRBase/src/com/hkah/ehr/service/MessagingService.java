package com.hkah.ehr.service;

import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.mail.UtilMail2;

public class MessagingService {
	private static Logger logger = Logger.getLogger(MessagingService.class);
	
	public boolean sendMailHeprUploaded(String domainCode, String responseCode, String responseMessage, int recordSize) {
        try {
    		String subject = getMailFullSubject("Data upload sent to HePR adaptor (" + domainCode + ")");
    		String content = ConstantsServerSide.SITE_CODE.toUpperCase() + " eHR Data upload sent to HePR adaptor." + "\n<br />" +
    					"Domain: " + domainCode + "\n<br />" +
    					"Record size: " + recordSize + "\n<br />" +
    					"Result: " + responseCode + " - " + responseMessage;
    		return UtilMail2.sendEmailAlert("ehr.laam.uploaded", subject, content);
        } catch (Exception e) {
        	logger.error("Send hepr domain upload email failed: " + e.getMessage());
        	e.printStackTrace();
        }
        return false;
	}
	
	public boolean sendMailDownloadAdrAllergy(String responseCode, String responseMessage, String patno, String userId) {
        try {
    		String subject = getMailFullSubject("Download Allergy and ADR");
    		String content = ConstantsServerSide.SITE_CODE.toUpperCase() + " eHR Download Allergy and ADR." + "\n<br />" +
    					"Patno: " + patno + "\n<br />" +    					
    					"Result: " + responseCode + " - " + responseMessage + "\n<br />" + 
    					"Triggered by: " + userId;
    		return UtilMail2.sendEmailAlert("ehr.laam.download", subject, content);
        } catch (Exception e) {
        	logger.error("Send eHR download Allery and ADR email failed: " + e.getMessage());
        	e.printStackTrace();
        }
        return false;
	}
	
	private String getMailFullSubject(String subject) {
		StringBuffer subjectFull = new StringBuffer();
		
		subjectFull.append("[");
		subjectFull.append(ConstantsServerSide.getSiteShortFormUpper());
		if ("UAT".equalsIgnoreCase(ConstantsServerSide.SITE_ENV)) {
			subjectFull.append(" ");
			subjectFull.append(ConstantsServerSide.SITE_ENV);
		}
		subjectFull.append("]");
		subjectFull.append(" eHR LAAM");
		if (subject != null) {
			subjectFull.append(": ");
			subjectFull.append(subject);
		}
		
		return subjectFull.toString();
	}
}
