package test.client;

import hk.gov.ehr.alert.ws.beans.AuditDTO;
import hk.gov.ehr.alert.ws.beans.LocalEMRDownloadRequestBean;
import hk.gov.ehr.alert.ws.beans.LocalEMRDownloadResponseBean;
import hk.gov.ehr.alert.ws.beans.ObjectFactory;
import hk.gov.ehr.alert.ws.beans.common.EhrPatientDTO;

import javax.xml.bind.JAXBElement;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.ws.client.core.WebServiceTemplate;

import com.hkah.constant.ConstantsEhr;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.ehr.service.DomainCommonService;
import com.hkah.ehr.service.MessagingService;
import com.hkah.ehr.service.SaamService;

public class AlertWebServiceClient {
	protected static Logger logger = Logger.getLogger(AlertWebServiceClient.class);
	private WebServiceTemplate wsTemplate=null;
	private ObjectFactory objectFactory = new ObjectFactory();
	private DomainCommonService domainCommonService;
	private SaamService saamService;
	private MessagingService messagingService;
	
	public DomainCommonService getDomainCommonService() {
		return domainCommonService;
	}

	public void setDomainCommonService(DomainCommonService domainCommonService) {
		this.domainCommonService = domainCommonService;
	}
	
	public SaamService getSaamService() {
		return saamService;
	}

	public void setSaamService(SaamService saamService) {
		this.saamService = saamService;
	}

	public MessagingService getMessagingService() {
		return messagingService;
	}

	public void setMessagingService(MessagingService messagingService) {
		this.messagingService = messagingService;
	}

	public AlertWebServiceClient(WebServiceTemplate webServiceTemplate) {
		this.wsTemplate = webServiceTemplate;
		
		String defaultUri = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_EHRAAGWSL);
		//logger.debug("Set WebServiceTemplate defaultUri: "+defaultUri);
		if (wsTemplate != null) {
			wsTemplate.setDefaultUri(defaultUri);
		} else {
			logger.error("Cannot set defaultUri to null WebServiceTemplate.");
		}
	}
	
	public LocalEMRDownloadResponseBean downloadAdrAllergy(String patno, String userId) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		DomainCommonService domainCommonService = (DomainCommonService) context.getBean("domainCommonService");
		LocalEMRDownloadResponseBean wsResponse = null;
		String responseCode = null;
		String responseMessage = null;
		
		try {
			EhrPatientDTO ehrPatientDTO = saamService.convertParticipant2EhrPatientDTO(
					domainCommonService.getEhrHl7Participant4DomainByPatNo(patno));
			AuditDTO auditDTO = new AuditDTO();
			auditDTO.setMrn(patno);
			auditDTO.setLoginId(userId);
			
			LocalEMRDownloadRequestBean reqParam = new LocalEMRDownloadRequestBean();
			reqParam.setSource(ConstantsEhr.SOURCE_SYSTEM_PRI_HOSP);
			reqParam.setEhrPatientDTO(ehrPatientDTO);
			reqParam.setAuditDTO(auditDTO);
			
			@SuppressWarnings("unchecked")
			JAXBElement<LocalEMRDownloadResponseBean> response = (JAXBElement<LocalEMRDownloadResponseBean>) wsTemplate.marshalSendAndReceive(
					objectFactory.createHandleLocalEMRDownloadPatientAdrAndAllergyRequest(reqParam));
			wsResponse = response.getValue();
			
			responseCode = wsResponse.getResponseCode();
			responseMessage = wsResponse.getResponseMessage();
		} catch (Exception e) {
			e.printStackTrace();
			
			responseCode = "ERROR";
			responseMessage = e.getMessage();
			
			wsResponse = new LocalEMRDownloadResponseBean();
			wsResponse.setResponseCode(responseCode);
			wsResponse.setResponseMessage(responseMessage);
		}
		
		// send mail outside method
		//messagingService.sendMailDownloadAdrAllergy(responseCode, responseMessage, patno, userId);
		return wsResponse;
	}
}
