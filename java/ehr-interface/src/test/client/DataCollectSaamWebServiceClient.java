package test.client;

import hk.gov.ehr.saam.transform.ws.AdrRecordResponse;
import hk.gov.ehr.saam.transform.ws.AllergyRecordResponse;
import hk.gov.ehr.saam.transform.ws.ObjectFactory;
import hk.gov.ehr.saam.transform.ws.PatientRecordByPeriodRequest;

import java.util.Date;

import javax.xml.bind.JAXBElement;

import org.apache.log4j.Logger;
import org.springframework.ws.client.core.WebServiceTemplate;

import com.hkah.constant.ConstantsEhr;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.util.XMLGregorianCalendarConversionUtil;

public class DataCollectSaamWebServiceClient {
	protected static Logger logger = Logger.getLogger(DataCollectSaamWebServiceClient.class);
	private WebServiceTemplate wsTemplate=null;
	private ObjectFactory objectFactory = new ObjectFactory();
	
	public DataCollectSaamWebServiceClient(WebServiceTemplate webServiceTemplate) {
		this.wsTemplate = webServiceTemplate;
		
		String defaultUri = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_EHRSAAMWSL);
		//logger.debug("Set WebServiceTemplate defaultUri: "+defaultUri);
		if (wsTemplate != null) {
			wsTemplate.setDefaultUri(defaultUri);
		} else {
			logger.error("Cannot set defaultUri to null WebServiceTemplate.");
		}
	}
	
	public AdrRecordResponse collectAdrRecord(String patientKey, Date startTime, String uploadMode) {
		return collectAdrRecord(patientKey, startTime, new Date(), uploadMode);
	}
	
	public AdrRecordResponse collectAdrRecord(String patientKey, Date startTime, Date endTime, String uploadMode) {
		try {		
			PatientRecordByPeriodRequest reqParam = new PatientRecordByPeriodRequest();
			reqParam.setPatientKey(patientKey);
			reqParam.setStartTime(XMLGregorianCalendarConversionUtil.asXMLGregorianCalendar(startTime));
			reqParam.setEndTime(XMLGregorianCalendarConversionUtil.asXMLGregorianCalendar(endTime));
			reqParam.setUploadMode(uploadMode);

			@SuppressWarnings("unchecked")
			JAXBElement<AdrRecordResponse> response = (JAXBElement<AdrRecordResponse>) wsTemplate.marshalSendAndReceive(
					objectFactory.createGetAdrRecordByPeriodRequest(reqParam));
			
			return response.getValue();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public AllergyRecordResponse collectAllergyRecord(String patientKey, Date startTime, String uploadMode) {
		return collectAllergyRecord(patientKey, startTime, new Date(), uploadMode);
	}
	
	public AllergyRecordResponse collectAllergyRecord(String patientKey, Date startTime, Date endTime, String uploadMode) {
		try {
			PatientRecordByPeriodRequest reqParam = new PatientRecordByPeriodRequest();
			reqParam.setPatientKey(patientKey);
			reqParam.setStartTime(XMLGregorianCalendarConversionUtil.asXMLGregorianCalendar(startTime));
			reqParam.setEndTime(XMLGregorianCalendarConversionUtil.asXMLGregorianCalendar(endTime));
			reqParam.setUploadMode(uploadMode);
			
			@SuppressWarnings("unchecked")
			JAXBElement<AllergyRecordResponse> response = (JAXBElement<AllergyRecordResponse>) wsTemplate.marshalSendAndReceive(
					objectFactory.createGetAllergyRecordByPeriodRequest(reqParam));
			
			return response.getValue();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
