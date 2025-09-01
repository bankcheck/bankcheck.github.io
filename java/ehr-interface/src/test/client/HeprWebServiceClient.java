package test.client;

import hk.gov.ehr.hepr.ws.AdrRecordUploadRequest;
import hk.gov.ehr.hepr.ws.AdrUploadRecord;
import hk.gov.ehr.hepr.ws.AllergyRecordUploadRequest;
import hk.gov.ehr.hepr.ws.AllergyUploadRecord;
import hk.gov.ehr.hepr.ws.BirthDataUploadRequest;
import hk.gov.ehr.hepr.ws.BirthUploadRecord;
import hk.gov.ehr.hepr.ws.EnctrDataUploadRequest;
import hk.gov.ehr.hepr.ws.EnctrUploadRecord;
import hk.gov.ehr.hepr.ws.EpisDataUploadRequest;
import hk.gov.ehr.hepr.ws.EpisUploadRecord;
import hk.gov.ehr.hepr.ws.LabgenDataUploadRequest;
import hk.gov.ehr.hepr.ws.LabgenUploadRecord;
import hk.gov.ehr.hepr.ws.LabmbDataUploadRequest;
import hk.gov.ehr.hepr.ws.LabmbUploadRecord;
import hk.gov.ehr.hepr.ws.LabapDataUploadRequest;
import hk.gov.ehr.hepr.ws.LabapUploadRecord;
import hk.gov.ehr.hepr.ws.ObjectFactory;
import hk.gov.ehr.hepr.ws.RadDataUploadRequest;
import hk.gov.ehr.hepr.ws.RadUploadRecord;
import hk.gov.ehr.hepr.ws.Response;
import hk.gov.ehr.hepr.ws.RxdRecordUploadRequest;
import hk.gov.ehr.hepr.ws.RxdUploadRecord;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.xml.bind.JAXBElement;

import org.apache.log4j.Logger;
import org.hl7.v3.AllergyDetail;
import org.hl7.v3.BirthDetail;
import org.hl7.v3.CausativeAgent;
import org.hl7.v3.ClinicalNoteDetail;
import org.hl7.v3.ClinicalNoteDetail.EpisDetail;
import org.hl7.v3.EncounterDetail;
import org.hl7.v3.LabResultGenDetail;
import org.hl7.v3.LabResultMBDetail;
import org.hl7.v3.LabResultAPDetail;

import org.hl7.v3.Participant;
import org.hl7.v3.RadiologyDetail;
import org.hl7.v3.RxdDetail;
import org.springframework.ws.WebServiceMessage;
import org.springframework.ws.client.core.WebServiceMessageCallback;
import org.springframework.ws.client.core.WebServiceTemplate;
import org.springframework.ws.soap.SoapMessage;

import com.hkah.constant.ConstantsEhr;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.ehr.service.MessagingService;

public class HeprWebServiceClient {
	protected static Logger logger = Logger.getLogger(HeprWebServiceClient.class);
	private WebServiceTemplate wsTemplate=null;
	private MessagingService messagingService = null;
	private ObjectFactory objectFactory = new ObjectFactory();
	
	public MessagingService getMessagingService() {
		return messagingService;
	}

	public void setMessagingService(MessagingService messagingService) {
		this.messagingService = messagingService;
	}

	public HeprWebServiceClient(WebServiceTemplate webServiceTemplate) {
		this.wsTemplate = webServiceTemplate;
		
		String defaultUri = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_EHRHEPRWSL);
		//logger.debug("Set WebServiceTemplate defaultUri: "+defaultUri);
		if (wsTemplate != null) {
			wsTemplate.setDefaultUri(defaultUri);
		} else {
			logger.error("Cannot set defaultUri to null WebServiceTemplate.");
		}
	}
	
	public Response uploadAdrData(Map<Participant,List<CausativeAgent>> list , String batchMode){
        AdrRecordUploadRequest causativeAgentReq = objectFactory.createAdrRecordUploadRequest();
        causativeAgentReq.setUploadMode(batchMode);

        for (Map.Entry<Participant, List<CausativeAgent>> entry : list.entrySet()) {
              Participant p = entry.getKey();
              List<CausativeAgent> dList = entry.getValue();
              if(dList.size()==0)
                    continue;

              AdrUploadRecord r = new AdrUploadRecord();
              r.setParticipant(p);
              List<CausativeAgent> newList = new ArrayList<CausativeAgent>();
              for(CausativeAgent d:(List<CausativeAgent>)dList){
                    if(d.getRecordKey()!=null && !d.getRecordKey().isEmpty()){
                          newList.add(d);   
                    }
              }
              r.getCausativeAgent().addAll(newList);    
              causativeAgentReq.getAdrRecords().add(r);
        }

        @SuppressWarnings("unchecked")
        JAXBElement<Response> response = (JAXBElement<Response>) wsTemplate.marshalSendAndReceive(objectFactory.createUploadAdrRecordRequest(causativeAgentReq));
        Response wsResponse = response.getValue();
        
    	messagingService.sendMailHeprUploaded(ConstantsEhr.DOMAIN_CODE_ADR, 
  			  wsResponse.getResponseCode(), wsResponse.getResponseMessage(), list == null ? 0 : list.size());
        return wsResponse;
  }
	
	public Response uploadAllergyData(Map<Participant,List<AllergyDetail>> list , String batchMode){
		AllergyRecordUploadRequest allergyDetailReq = objectFactory.createAllergyRecordUploadRequest();
		allergyDetailReq.setUploadMode(batchMode);

      for (Map.Entry<Participant, List<AllergyDetail>> entry : list.entrySet()) {
            Participant p = entry.getKey();
            List<AllergyDetail> dList = entry.getValue();
            if(dList.size()==0)
                  continue;

            AllergyUploadRecord r = new AllergyUploadRecord();
            r.setParticipant(p);
            List<AllergyDetail> newList = new ArrayList<AllergyDetail>();
            for(AllergyDetail d:(List<AllergyDetail>)dList){
                  if(d.getRecordKey()!=null && !d.getRecordKey().isEmpty()){
                        newList.add(d);   
                  }
            }
           r.getAllergyDetail().addAll(newList);    
           allergyDetailReq.getAllergyRecords().add(r);
      }

      @SuppressWarnings("unchecked")
      JAXBElement<Response> response = (JAXBElement<Response>) wsTemplate.marshalSendAndReceive(objectFactory.createUploadAllergyRecordRequest(allergyDetailReq));           
      Response wsResponse = response.getValue();
      messagingService.sendMailHeprUploaded(ConstantsEhr.DOMAIN_CODE_ALLERGY, 
    		  wsResponse.getResponseCode(), wsResponse.getResponseMessage(), list == null ? 0 : list.size());

      return response.getValue();
	}
	
	public Response uploadEpisData(Map<Participant,List> list, final Map<String,File> attachments)
	{
		EpisDataUploadRequest episDetailReq =
			objectFactory.createEpisDataUploadRequest();
		
		for (Map.Entry<Participant, List> entry : list.entrySet()) {
			Participant p = entry.getKey();
			List<EpisDetail> dList = (List<EpisDetail>)entry.getValue();
			
			if(dList.size()==0)
				continue;
			
			EpisUploadRecord r = new EpisUploadRecord();
			ClinicalNoteDetail episDetail = new ClinicalNoteDetail();
			r.setParticipant(p);
			
			List<EpisDetail> newList = new ArrayList<EpisDetail>();
			for (EpisDetail d:(List<EpisDetail>)dList)
			{
				if (d.getRecordKey()!=null && !d.getRecordKey().isEmpty())
					newList.add(d);
			}
			
//			episDetail.setEpisDetail(newList);
			r.setClinicalNoteDetail(episDetail);
			episDetailReq.getEpisRecords().add(r);
		}
		
		@SuppressWarnings("unchecked")
		JAXBElement<Response> response = (JAXBElement<Response>) wsTemplate.marshalSendAndReceive(objectFactory.createUploadEpisDataRequest(episDetailReq),new WebServiceMessageCallback(){
			public void doWithMessage(WebServiceMessage message){
				SoapMessage sm = ((SoapMessage)message);
				for (Map.Entry<String, File> entry : attachments.entrySet()) {
					sm.addAttachment(entry.getValue().getName(), entry.getValue());
				}
			}
		});
		
		return response.getValue();
	}
	
	public Response uploadLabgenData(Map<Participant, List> list, final Map<String, File> attachments, String mode) {

		LabgenDataUploadRequest req = objectFactory.createLabgenDataUploadRequest();
		req.setUploadMode(mode);
		
		LabgenUploadRecord r = null;
		for (Map.Entry<Participant, List> entry : list.entrySet()) {
				
			Participant p = entry.getKey();
			List<LabResultGenDetail> dList = (List <LabResultGenDetail>)entry.getValue();
			if(dList.size()==0) {
				r = new LabgenUploadRecord();
				r.setParticipant(p);
				req.getLabgenRecords().add(r);	
			} else {
				for (LabResultGenDetail labResultGenDetail : dList) {
					r = new LabgenUploadRecord();
					r.setParticipant(p);
					r.setLabResultGenDetail(labResultGenDetail);									
					req.getLabgenRecords().add(r);			
				}
			}
		}
			
		@SuppressWarnings("unchecked")
		JAXBElement<Response> response = (JAXBElement<Response>) wsTemplate.marshalSendAndReceive(objectFactory.createUploadLabgenDataRequest(req),new WebServiceMessageCallback(){
			public void doWithMessage(WebServiceMessage message){
				SoapMessage sm = ((SoapMessage)message);
				for (Map.Entry<String, File> entry : attachments.entrySet()) {
					sm.addAttachment(entry.getValue().getName(), entry.getValue());
				}					
			}
		});
        Response wsResponse = response.getValue();
        
    	messagingService.sendMailHeprUploaded(ConstantsEhr.DOMAIN_CODE_LABGEN, 
  			  wsResponse.getResponseCode(), wsResponse.getResponseMessage(), list == null ? 0 : list.size());
        return wsResponse;
	}
	
	public Response uploadLabmbData(Map<Participant, List> list, final Map<String, File> attachments, String mode) {

		LabmbDataUploadRequest req = objectFactory.createLabmbDataUploadRequest();
		req.setUploadMode(mode);
		
		for (Map.Entry<Participant, List> entry : list.entrySet()) {
				
			Participant p = entry.getKey();
			List<LabResultMBDetail> dList = (List <LabResultMBDetail>)entry.getValue();
			if(dList.size()==0)
				continue;
				
			for (LabResultMBDetail labResultMBDetail : dList) {
				LabmbUploadRecord r = new LabmbUploadRecord();
				r.setParticipant(p);
				r.setLabResultMBDetail(labResultMBDetail);									
				req.getLabmbRecords().add(r);			
			}
		}
			
		@SuppressWarnings("unchecked")
		JAXBElement<Response> response = (JAXBElement<Response>) wsTemplate.marshalSendAndReceive(objectFactory.createUploadLabmbDataRequest(req),new WebServiceMessageCallback(){
			public void doWithMessage(WebServiceMessage message){
				SoapMessage sm = ((SoapMessage)message);
				for (Map.Entry<String, File> entry : attachments.entrySet()) {
					sm.addAttachment(entry.getValue().getName(), entry.getValue());
				}
			}
		});
        Response wsResponse = response.getValue();
        
    	messagingService.sendMailHeprUploaded(ConstantsEhr.DOMAIN_CODE_LABMICRO, 
  			  wsResponse.getResponseCode(), wsResponse.getResponseMessage(), list == null ? 0 : list.size());
        return wsResponse;
	}

	public Response uploadLabapData(Map<Participant, List> list, final Map<String, File> attachments, String mode) {

		LabapDataUploadRequest req = objectFactory.createLabapDataUploadRequest();
		
		req.setUploadMode(mode);
		
		for (Map.Entry<Participant, List> entry : list.entrySet()) {
				
			Participant p = entry.getKey();
			List<LabResultAPDetail> dList = (List <LabResultAPDetail>)entry.getValue();
			if(dList.size()==0)
				continue;
				
			for (LabResultAPDetail labResultAPDetail : dList) {
				LabapUploadRecord r = new LabapUploadRecord();
				r.setParticipant(p);
				r.setLabResultAPDetail(labResultAPDetail);									
				req.getLabapRecords().add(r);			
			}
		}
			
		@SuppressWarnings("unchecked")
		JAXBElement<Response> response = (JAXBElement<Response>) wsTemplate.marshalSendAndReceive(objectFactory.createUploadLabapDataRequest(req),new WebServiceMessageCallback(){
			public void doWithMessage(WebServiceMessage message){
				SoapMessage sm = ((SoapMessage)message);
				for (Map.Entry<String, File> entry : attachments.entrySet()) {
					sm.addAttachment(entry.getValue().getName(), entry.getValue());
				}
			}
		});
        Response wsResponse = response.getValue();
        
    	messagingService.sendMailHeprUploaded(ConstantsEhr.DOMAIN_CODE_LABAP, 
  			  wsResponse.getResponseCode(), wsResponse.getResponseMessage(), list == null ? 0 : list.size());
        return wsResponse;
	}	
	
	public Response uploadRadData(Map<Participant,RadiologyDetail> list, final Map<String, File> attachments , String batchMode){
		RadDataUploadRequest radDetailReq = objectFactory.createRadDataUploadRequest();
		radDetailReq.setUploadMode(batchMode);

        for (Map.Entry<Participant, RadiologyDetail> entry : list.entrySet()) {
              Participant p = entry.getKey();
              RadiologyDetail rd = entry.getValue();

              RadUploadRecord r = new RadUploadRecord();
              r.setParticipant(p);
              r.setRadiologyDetail(rd);
             radDetailReq.getRadRecords().add(r);
        }

		@SuppressWarnings("unchecked")
		JAXBElement<Response> response = (JAXBElement<Response>) wsTemplate.marshalSendAndReceive(objectFactory.createUploadRadDataRequest(radDetailReq),new WebServiceMessageCallback(){
			public void doWithMessage(WebServiceMessage message){
				SoapMessage sm = ((SoapMessage)message);
				for (Map.Entry<String, File> entry : attachments.entrySet()) {
					sm.addAttachment(entry.getValue().getName(), entry.getValue());
				}					
			}
		});
        
        Response wsResponse = response.getValue();
        
    	messagingService.sendMailHeprUploaded(ConstantsEhr.DOMAIN_CODE_RADI, 
  			  wsResponse.getResponseCode(), wsResponse.getResponseMessage(), list == null ? 0 : list.size());
        return wsResponse;
  }

	public Response uploadRxdData(Map<Participant,RxdDetail> list, final Map<String, File> attachments , String batchMode){
		RxdRecordUploadRequest rxdDetailReq = objectFactory.createRxdRecordUploadRequest() ;
		rxdDetailReq.setUploadMode(batchMode);

        for (Map.Entry<Participant, RxdDetail> entry : list.entrySet()) {
              Participant p = entry.getKey();
              RxdDetail rd = entry.getValue();

              RxdUploadRecord r = new RxdUploadRecord();
              r.setParticipant(p);
              r.getRxdDetail().add(rd);
              rxdDetailReq.getRxdRecords().add(r);
        }

		@SuppressWarnings("unchecked")
		JAXBElement<Response> response = (JAXBElement<Response>) wsTemplate.marshalSendAndReceive(objectFactory.createUploadRxdRecordRequest(rxdDetailReq),new WebServiceMessageCallback(){
			public void doWithMessage(WebServiceMessage message){
				SoapMessage sm = ((SoapMessage)message);
				for (Map.Entry<String, File> entry : attachments.entrySet()) {
					sm.addAttachment(entry.getValue().getName(), entry.getValue());
				}					
			}
		});
        
        Response wsResponse = response.getValue();
        
    	messagingService.sendMailHeprUploaded(ConstantsEhr.DOMAIN_CODE_DISP, 
  			  wsResponse.getResponseCode(), wsResponse.getResponseMessage(), list == null ? 0 : list.size());
        return wsResponse;
  }
	
	public Response uploadBirthData(Map<Participant,BirthDetail> list, String batchMode){
		BirthDataUploadRequest birthDetailReq = objectFactory.createBirthDataUploadRequest();
		birthDetailReq.setUploadMode(batchMode);
        for (Entry<Participant, BirthDetail> entry : list.entrySet()) {
            Participant p = entry.getKey();
            BirthDetail detail = entry.getValue();
            BirthUploadRecord r = new BirthUploadRecord();
            r.setBirthDetail(detail);
            r.setParticipant(p);
            birthDetailReq.getBirthRecords().add(r);
        }
        
		@SuppressWarnings("unchecked")
		JAXBElement<Response> response = (JAXBElement<Response>) wsTemplate.marshalSendAndReceive(
				objectFactory.createUploadBirthDataRequest(birthDetailReq));
		Response wsResponse = response.getValue();
		
    	messagingService.sendMailHeprUploaded(ConstantsEhr.DOMAIN_CODE_BIRTH, 
  			  wsResponse.getResponseCode(), wsResponse.getResponseMessage(), list == null ? 0 : list.size());
        return response.getValue();
	}
	
	public Response uploadEncounterData(Map<Participant,List<EncounterDetail>> list, String batchMode){
		EnctrDataUploadRequest enctrDetailReq = objectFactory.createEnctrDataUploadRequest();
		enctrDetailReq.setUploadMode(batchMode);
		EnctrUploadRecord r = null;
        for (Entry<Participant, List<EncounterDetail>> entry : list.entrySet()) {
            Participant p = entry.getKey();
            List<EncounterDetail> details = entry.getValue();
            
            //System.out.println("details size="+(details == null ? "null" : details.size()));
            
            for (EncounterDetail detail : details) {
            	r = new EnctrUploadRecord();
            	
            	String recordKey = (!detail.getAdmission().isEmpty() ? detail.getAdmission().get(0).getRecordKey() :
            			(!detail.getAppointment().isEmpty() ? detail.getAppointment().get(0).getRecordKey() :
            			(!detail.getDischarge().isEmpty() ? detail.getDischarge().get(0).getRecordKey() : null)));
            	
            	boolean isBlank = "-1".equals(recordKey);
            	//System.out.println("  isBlank="+isBlank);
            	logger.debug("Upload Enc ehrno="+p.getEhrNo()+", isBlank="+isBlank);
            	if (!isBlank) {
            		r.setEncounterDetail(detail);
            	}
	            r.setParticipant(p);
	            
	            /*
	            System.out.println(" r setParticipant getEhrNo="+p.getEhrNo());
	            System.out.println("    detail.getAdmission().size()="+detail.getAdmission().size());
	            System.out.println("    detail.getAppointment().size()="+detail.getAppointment().size());
	            System.out.println("    detail.getDischarge().size()="+detail.getDischarge().size());
	            */
	            
	            enctrDetailReq.getEnctrRecords().add(r);
            }
        }
        
		@SuppressWarnings("unchecked")
		JAXBElement<Response> response = (JAXBElement<Response>) wsTemplate.marshalSendAndReceive(
				objectFactory.createUploadEnctrDataRequest(enctrDetailReq));
		Response wsResponse = response.getValue();
		
    	messagingService.sendMailHeprUploaded(ConstantsEhr.DOMAIN_CODE_ENCTR, 
  			  wsResponse.getResponseCode(), wsResponse.getResponseMessage(), list == null ? 0 : list.size());
        return response.getValue();
	}
}
