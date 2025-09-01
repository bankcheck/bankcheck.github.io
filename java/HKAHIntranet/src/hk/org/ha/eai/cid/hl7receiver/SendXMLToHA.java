package hk.org.ha.eai.cid.hl7receiver;

//import hk.org.ha.eai.cid.hl7receiver.EAI_CID_HL7Receiver_WSSStub.GetImageDataElement;
//import hk.org.ha.eai.cid.hl7receiver.EAI_CID_HL7Receiver_WSSStub.GetImageDataResponseElement;

import hk.org.ha.eai.cid.hl7receiver.types.EAI_CID_HL7Receiver_WSSSoapHttpPortBindingStub;
import hk.org.ha.eai.cid.hl7receiver.types.GetImageDataElement;
import hk.org.ha.eai.cid.hl7receiver.types.GetImageDataResponseElement;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import org.apache.log4j.*;
import javax.net.ssl.SSLContext;


public class SendXMLToHA {
	private static Logger logger = Logger.getLogger(SendXMLToHA.class);

	public static void main(String[] args)  {
		//System.setProperty("javax.net.ssl.keyStore", "C:/Users/cherry_wong/.keystore");
		//System.setProperty("javax.net.ssl.keyStorePassword", "123456");
		
		System.setProperty("javax.net.ssl.trustStore", "C:/Users/cherry_wong/.keystore");
		System.setProperty("javax.net.ssl.trustStorePassword", "123456");
		
		//SendXMLToHA.sendHL7();
	}
	
	 private static String readFileAsString(String filePath)
	    throws java.io.IOException{
	        StringBuffer fileData = new StringBuffer(1000);
	        BufferedReader reader = new BufferedReader(
	                new FileReader(filePath));
	        char[] buf = new char[1024];
	        int numRead=0;
	        while((numRead=reader.read(buf)) != -1){
	            String readData = String.valueOf(buf, 0, numRead);
	            fileData.append(readData);
	            buf = new char[1024];
	        }
	        reader.close();
	        return fileData.toString();
	    }
	 
	public static boolean sendHL7(String xml,String destination) {
		try {
			String inHL7XML = readFileAsString(xml);
			logger.info(xml+": inHL7XML= "+inHL7XML);
//			EAI_CID_HL7Receiver_WSSStub stub = 
//				new EAI_CID_HL7Receiver_WSSStub(destination);
//			logger.info(xml+": destination= "+destination);
//			GetImageDataElement element = new GetImageDataElement();
//			element.setInHL7XML(inHL7XML);
//			logger.info(xml+": element:"+element.getInHL7XML());
//			GetImageDataResponseElement res = stub.getImageData(element);
//			if(res.getResult().length()>0){
//				logger.info(xml+" ACK:"+res.getResult());
//				return true;
//			}else{
//				return false;
//			}
			
			SSLContext sslContext = SSLContext.getInstance("TLSv1.2");
		    sslContext.init(null, null, null);
		    SSLContext.setDefault(sslContext);
			    
			EAI_CID_HL7Receiver_WSSSoapHttpPortBindingStub stub = 
				new EAI_CID_HL7Receiver_WSSSoapHttpPortBindingStub(new java.net.URL(destination),null);
			logger.info(xml+": destination= "+destination);
			GetImageDataElement element = new GetImageDataElement();
			element.setInHL7XML(inHL7XML);
			logger.info(xml+": element:"+element.getInHL7XML());
			GetImageDataResponseElement res = stub.getImageData(element);
			if(res.getResult().length()>0){
				logger.info(xml+" ACK:"+res.getResult());
				return true;
			}else{
				return false;
			}		
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
