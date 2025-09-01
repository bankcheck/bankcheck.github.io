package test.client;

import hk.gov.ehr.epis.transform.ws.EpisRecordByPeriodRequest;
import hk.gov.ehr.epis.transform.ws.EpisRecordResponse;
import hk.gov.ehr.epis.transform.ws.ObjectFactory;

import java.util.Date;

import javax.xml.bind.JAXBElement;

import org.apache.log4j.Logger;
import org.springframework.ws.client.core.WebServiceTemplate;

import com.hkah.constant.ConstantsEhr;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.util.XMLGregorianCalendarConversionUtil;

public class DataCollectEpisWebServiceClient {
	protected static Logger logger = Logger.getLogger(DataCollectEpisWebServiceClient.class);
	private WebServiceTemplate wsTemplate=null;
	private ObjectFactory objectFactory = new ObjectFactory();
	
	public DataCollectEpisWebServiceClient(WebServiceTemplate webServiceTemplate) {
		this.wsTemplate = webServiceTemplate;
		
		String defaultUri = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_EHREPISWSL);
		//logger.debug("Set WebServiceTemplate defaultUri: "+defaultUri);
		if (wsTemplate != null) {
			wsTemplate.setDefaultUri(defaultUri);
		} else {
			logger.error("Cannot set defaultUri to null WebServiceTemplate.");
		}
	}
	
	public EpisRecordResponse collectEpisRecord(String patientKey, Date startTime, String serviceType, String uploadMode) {
		return collectEpisRecord(patientKey, startTime, new Date(), serviceType, uploadMode);
	}
	
	public EpisRecordResponse collectEpisRecord(String patientKey, Date startTime, Date endTime, String serviceType, String uploadMode) {
		try {		
			EpisRecordByPeriodRequest reqParam = new EpisRecordByPeriodRequest();
			reqParam.setPatientKey(patientKey);
			reqParam.setStartTime(XMLGregorianCalendarConversionUtil.asXMLGregorianCalendar(startTime));
			reqParam.setEndTime(XMLGregorianCalendarConversionUtil.asXMLGregorianCalendar(endTime));
			reqParam.setType(serviceType);
			reqParam.setUploadMode(uploadMode);
			
			@SuppressWarnings("unchecked")
			JAXBElement<EpisRecordResponse> response = (JAXBElement<EpisRecordResponse>) wsTemplate.marshalSendAndReceive(
					objectFactory.createGetEpisRecordByPeriodRequest(reqParam));
			
			return response.getValue();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
