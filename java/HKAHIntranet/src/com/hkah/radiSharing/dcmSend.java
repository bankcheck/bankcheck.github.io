package com.hkah.radiSharing;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import org.apache.log4j.*;
import org.apache.log4j.helpers.LogLog;
import org.dcm4che2.net.ConfigurationException;

public class dcmSend {
	
	private static Logger logger = Logger.getLogger(dcmSend.class);
	private static int fileSending = 0; 
	

    public dcmSend() {}
    
	public static void main(String[] args)  {
			
		//File dcmFile = new File("C:\\radioSharing\\logic7\\DCM"); 
		//String test = sendDcmFile(dcmFile);
	} 
	
	@SuppressWarnings("finally")
	
	public int getFileSending(){
		return fileSending;
	}
	//for override
	public void postSendDcmFile(){};

	public static String sendDcmFile(File dcmFile,String remoteHost, String AET,int port) {
		
		String returnValue="";
		try{
		DcmSnd dcmsnd = new DcmSnd("NETGATE"){
			@Override
			public void postSendingImg(){
				//logger.info("sending:"+getNumberOfFilesSending());
				fileSending = getNumberOfFilesSending();
			};
		};
		//HA//
		//dcmsnd.setCalledAET(AET);
		//dcmsnd.setRemoteHost(remoteHost); 
		//UAT//
		dcmsnd.setCalledAET(AET);
		dcmsnd.setRemoteHost(remoteHost);		
		dcmsnd.setRemotePort(port);

		dcmsnd.setOfferDefaultTransferSyntaxInSeparatePresentationContext(false);
		dcmsnd.setSendFileRef(false);
		dcmsnd.setStorageCommitment(false);
		dcmsnd.setPackPDV(true);
		dcmsnd.setTcpNoDelay(true);
		
		
		dcmsnd.addFile(dcmFile);
		dcmsnd.configureTransferCapability();

		try {
		dcmsnd.start();
		} catch (Exception e) {
		logger.info("ERROR: Failed to start server for receiving " +
		"Storage Commitment results:" + e.getMessage());
		returnValue = "0";	
		}

		try {
		long t1 = System.currentTimeMillis();
		dcmsnd.open();
		long t2 = System.currentTimeMillis();
		logger.info("Connected to " + "DCM4CHEE" + " in "
		+ ((t2 - t1) / 1000F) + "s");
		
		dcmsnd.send();
		dcmsnd.close();
		logger.info("\nReleased connection to " + "DCM4CHEE");
			if(dcmsnd.getNumberOfFilesSent() < dcmsnd.getNumberOfFilesToSend()){
				returnValue = "ERROR:"+Integer.toString(dcmsnd.getNumberOfFilesSent())+"("+Integer.toString(dcmsnd.getNumberOfFilesToSend())+")";
			}else{
				returnValue = Integer.toString(dcmsnd.getNumberOfFilesSent())+"("+Integer.toString(dcmsnd.getNumberOfFilesToSend())+")";
			}
		} catch (java.net.SocketException e){
			logger.info("\nERROR: Failed to establish association:"
					+ e.getMessage());
					returnValue = "0";				
		} catch (IOException e) {
		logger.info("\nERROR: Failed to establish association:"
		+ e.getMessage());
		returnValue = "0";	
		} catch (ConfigurationException e) {
		logger.info("\nERROR: Failed to establish association:"
		+ e.getMessage());
		returnValue = "0";	
		} catch (InterruptedException e) {
		logger.info("\nERROR: Failed to establish association:"
		+ e.getMessage());
		returnValue = "0";
		}catch(Exception e){
			logger.info("\nERROR: Failed to establish association:"
					+ e.getMessage());
					returnValue = "0";					
		} 
		finally {
		dcmsnd.stop();
		logger.info("pass");
		logger.info("Value:"+returnValue);
		return returnValue;
		}
		} catch (Exception e) {
			 return returnValue;
			}
		}
	

}
