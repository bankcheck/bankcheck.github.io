package com.hkah.convert;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.ConnectException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.log4j.Logger;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.tools.imageio.ImageIOUtil;

import com.artofsolving.jodconverter.DocumentConverter;
import com.artofsolving.jodconverter.openoffice.connection.OpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.connection.OpenOfficeException;
import com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.CMSDB;

public class Converter {
	private static int docCount = 1 ;
	private static Logger logger = Logger.getLogger(Converter.class);
		
	private static synchronized void checkOpenOffice(String type){
		if("restart".equals(type)){
logger.info("Restart OpenOffice");	
			try{
				Thread.sleep(2500);
				stopOpenOffice();
			    startOpenOffice();
			} catch(InterruptedException ex) {
			    Thread.currentThread().interrupt();
			}			
		} else {			
			for(int i = 0; i < 2; i ++){
				if(isOpenOfficeRunning() == false){
					startOpenOffice();
				} else {
logger.info("OpenOffice is running");
					break;
				}
			}
		}
	}		
	
	private static boolean isOpenOfficeRunning(){
		boolean isRunning = false;
		try {
			String line;
			String pidInfo ="";
	
			Process p = Runtime.getRuntime().exec(System.getenv("windir") +"\\system32\\"+"tasklist.exe");
			
			BufferedReader input =  new BufferedReader(new InputStreamReader(p.getInputStream()));	
			while ((line = input.readLine()) != null) {
			    pidInfo+=line; 
			}
	
			input.close();	
			if(pidInfo.contains("soffice.exe"))
			{
				isRunning = true;
			} else {
				isRunning = false;
			}

		} catch (IOException e) {
logger.error("Exception: " + e.getMessage());;
			isRunning = false;
		}
		return isRunning;
	}
	
	private static void startOpenOffice() {
logger.info("Starting Open Office");
		try {
			Process p=Runtime.getRuntime().exec("soffice -headless -accept=\"socket,host=127.0.0.1,port=8100;urp;\" -nofirststartwizard");
			Thread.sleep(12500);
		} catch (IOException e) {				
logger.error("Exception: " + e.getMessage());;
		} catch (InterruptedException e) {
logger.error("Exception: " + e.getMessage());
		} 
	}
	
	private static void stopOpenOffice() {
		logger.info("Stop open Office");

		try {
			Process p=Runtime.getRuntime().exec("tskill soffice");
			Thread.sleep(5000);
		} catch (IOException e) {				
logger.error("Exception: " + e.getMessage());
		} catch (InterruptedException e) {
logger.error("Exception: " + e.getMessage());
		} 
	}
	
	public static boolean isFileExtensionAllowed(String ext){			
		boolean allowed = false;
		ext = ext.toLowerCase();
		if("doc".equals(ext) || "xls".equals(ext) || "ppt".equals(ext) || "pptx".equals(ext) || "docx".equals(ext) || "docm".equals(ext) || "rtf".equals(ext)){
			allowed = true;
		}
		
		return allowed;
	}
	
	public static void listFilesForFolder(final File folder,final DocumentConverter converter, final StringBuffer message) throws ConnectException {
		List<File> files = (List<File>) FileUtils.listFiles(folder, null, true);
		for (int i = 0; i < files.size(); i++) {			
			if (isFileExtensionAllowed(FilenameUtils.getExtension(files.get(i).getName()))){			
	        	final File inputFile = new File(files.get(i).getAbsolutePath());
	        	final File outputFile = new File(FilenameUtils.removeExtension(files.get(i).getAbsolutePath()) + ".pdf");
	        	
	        	if (message != null) {
	        		if(convertFile(converter, inputFile, outputFile, false)) {
	        			message.append("Convert success: " + inputFile.getAbsolutePath() + "<br>");
	        			
	        		} else {	        				
	        			message.append("<font color='red'>Convert failed : " + inputFile.getAbsolutePath() + "</font><br>");
	        		}
	        	} else {
	        		convertFile(converter, inputFile, outputFile, false);
	             }	   
        	}else {
	    		if (!"pdf".equals(FilenameUtils.getExtension(files.get(i).getName())) && !"Thumbs.db".equals(files.get(i).getName())) {
	    			if (message != null) {
	    				//message.append("Convert skipped - Unsupported file type: " + files.get(i).getAbsolutePath() + "<br>");
	    			}
	    		}
	    	}       
		}				
	}
	
	public static String convertAllPolicy2Pdf(String path) {
		checkOpenOffice("startup");					
		String rootFolder = "";		
logger.info("============Convert all policy=================");			
		rootFolder = path;		
		
		File dir = new File(rootFolder);
		try {
logger.info("Make connection to OpenOffice through 8100 port");			
			OpenOfficeConnection connection = new SocketOpenOfficeConnection(8100);			
			connection.connect();
			DocumentConverter converter = new OpenOfficeDocumentConverter(connection);
logger.info("Connected successfully");			
			listFilesForFolder(dir, converter, null);
			
			connection.disconnect();	
		} catch (ConnectException e) {			
logger.error("Exception: " + e.getMessage());;					
		} catch (Exception e) {
logger.error("Exception: " + e.getMessage());;
		}
		
		return null;
	}
	
	public static String convertPathFile2Pdf(String path) {		
		checkOpenOffice("startup");
		
		StringBuffer message = new StringBuffer();
		//File dir = new File(path);
		//File[] filesList = dir.listFiles();
		
		File dir = new File(path);
		try {
logger.info("Make connection to OpenOffice through 8100 port");			
			OpenOfficeConnection connection = new SocketOpenOfficeConnection(8100);			
			connection.connect();
			DocumentConverter converter = new OpenOfficeDocumentConverter(connection);
logger.info("Connected successfully");
			listFilesForFolder(dir, converter, message);
			connection.disconnect();	
		} catch (ConnectException e) {			
logger.error("Exception: " + e.getMessage());;					
		} catch (Exception e) {
logger.error("Exception: " + e.getMessage());;
		}
		
		return message.toString();
	}
	
	public static String convertDoc2Pdf(String sourcePath, String fileName) {
		checkOpenOffice("startup");
		
		StringBuffer message = new StringBuffer();		
		if (isFileExtensionAllowed(FilenameUtils.getExtension(fileName))){
			boolean retryConnect = false;			
			try {
				String docFileName = fileName;
				String pdfFileName = FilenameUtils.removeExtension(fileName) + ".pdf"; 
				
				File inputFile = new File(sourcePath+docFileName);
				File outputFile = new File(sourcePath+pdfFileName);
						 
logger.info("Make connection to OpenOffice through 8100 port");			
				OpenOfficeConnection connection = new SocketOpenOfficeConnection(8100);			
				connection.connect();
				DocumentConverter converter = new OpenOfficeDocumentConverter(connection);
logger.info("Connected successfully");				
				if(convertFile(converter, inputFile, outputFile, false)) {
					message.append("Convert success: " + inputFile.getAbsolutePath() + "<br>");
				} else {
					message.append("<font color='red'>Convert failed : " + inputFile.getAbsolutePath() + "</font><br>");        								
				}
				connection.disconnect();
			} catch (ConnectException e) { 
				retryConnect = true;
logger.error("Exception: " + e.getMessage());;
				message.append("Convert fail: Error with convert services.<br>");				
			} catch (Exception e) {
logger.error("Exception: " + e.getMessage());;
			}
			
			if(retryConnect == true) {
				try {
					String docFileName = fileName;
					String pdfFileName = FilenameUtils.removeExtension(fileName) + ".pdf"; 
					
					File inputFile = new File(sourcePath+docFileName);
					File outputFile = new File(sourcePath+pdfFileName);
							 
	logger.info("Make connection to OpenOffice through 8100 port");			
					OpenOfficeConnection connection = new SocketOpenOfficeConnection(8100);			
					connection.connect();
					DocumentConverter converter = new OpenOfficeDocumentConverter(connection);
	logger.info("Connected successfully");				
					if(convertFile(converter, inputFile, outputFile, false)) {
						message.append("Convert success: " + inputFile.getAbsolutePath() + "<br>");
					} else {
						message.append("<font color='red'>Convert failed : " + inputFile.getAbsolutePath() + "</font><br>");        								
					}
					connection.disconnect();
				} catch (ConnectException e) { 
	logger.error("Exception: " + e.getMessage());
					message.append("Convert fail: Error with convert services.<br>");				
				} catch (Exception e) {
	logger.error("Exception: " + e.getMessage());;
				}
			}
		} else {
			if (!"pdf".equals(FilenameUtils.getExtension(fileName))) {
				message.append(message + "Convert skipped - Unsupported file type: " + fileName + "<br>");
			}
		}
		return message.toString();
	}
		
	private static synchronized boolean convertFile(final DocumentConverter converter, final File inputFile, final File outputFile, boolean retry){
		boolean success = false;
		try {			
			ExecutorService taskExecutor = Executors.newSingleThreadExecutor();			
			Runnable r = new Runnable() {
		        public void run() {
logger.info("Convert file : " + inputFile.getAbsolutePath());		
		        	converter.convert(inputFile, outputFile);
		        	
		        }
		    };

	        Future<?> f = taskExecutor.submit(r);
			f.get(180, TimeUnit.SECONDS);
			
		    taskExecutor.shutdown();			
			taskExecutor.awaitTermination(Long.MAX_VALUE, TimeUnit.NANOSECONDS);
			
    		success = true;
		} catch (InterruptedException e) {
logger.error("Interrupted Exception: " + e.getMessage());
		} catch (TimeoutException e) {
logger.error("Timeout Exception: Converting file took too long.");
			checkOpenOffice("restart");
    	} catch (IllegalArgumentException e) {
logger.error("Illegal Argument Exception: " + e.getMessage());
    	} catch (OpenOfficeException e) {
logger.error("OpenOffice Exception: " + e.getMessage());	
			checkOpenOffice("restart");
		}  catch (ExecutionException e) {
			if (e.getMessage().toLowerCase().contains("illegalargumentexception")){
logger.error("Illegal Argument Exception: " + e.getMessage());
			} else {
logger.error("Execution Exception: " + e.getMessage());
				checkOpenOffice("restart");
				if( retry == false){
logger.info("Retry convert after exception");
					success = convertFile(converter, inputFile, outputFile, true);
				}
			}
		}  
		return success;		
	}
	
	public static String convertPDF2SWF(String sourcePath, String outputPath, String fileName) throws IOException {
		File source = new File(sourcePath);
		
		if (!source.exists()) {
			return null;
		}
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		Date date = new Date();
		
		String fileNameWithoutSpace = docCount++ + dateFormat.format(date);
		
		File dest = new File(outputPath+"/"+fileNameWithoutSpace+".pdf");
		FileUtils.copyFile(source, dest);
		
		String output = outputPath + "/" + fileNameWithoutSpace + ".swf";
		
		String cmd2swf= "C:\\SWFTools\\pdf2swf.exe -i "+dest.getPath()+" -o "+output;
		String cmdCombineViewer = "C:\\SWFTools\\swfcombine.exe C:\\SWFTools\\rfxview.swf viewport=\""+output+"\" -o "+output;
		System.out.println("cmd:"+cmd2swf);
		if (runProcess(cmd2swf) == 0) {
			System.out.println("cmd:"+cmdCombineViewer);
			runProcess(cmdCombineViewer);
		}
//Only For Testin
		//File tempSource = new File(output);
		//File tempDest = new File("C:\\Program Files\\Apache Software Foundation\\Tomcat 6.0\\webapps\\swf\\tempPolicy\\" + fileNameWithoutSpace + ".swf");
		//FileUtils.copyFile(tempSource, tempDest);
		
		return fileNameWithoutSpace;
	}
	
	private static int runProcess(String cmd) throws IOException {			
		Process process = Runtime.getRuntime().exec(cmd); 
		final InputStream is1 = process.getInputStream();
		new Thread(new Runnable() {
			public void run() {
				BufferedReader br = new BufferedReader(new InputStreamReader(is1));
				try {
					while(br.readLine()!= null) ;
				} catch (IOException e) {
logger.error("Exception: " + e.getMessage());
				}
			}
		}).start();
		InputStream is2 = process.getErrorStream();
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf = new StringBuilder(); 
		String line = null;
		while((line = br2.readLine()) != null) {
			buf.append(line);
		}
logger.info("The output is:" + buf);
 
		// BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(pro.getInputStream()));
		while (br2.readLine() != null);
 
		try {
			process.waitFor();
		} catch (InterruptedException e) {
logger.error("Exception: " + e.getMessage());;
		}
		
		return process.exitValue();
	}
	
	public static ArrayList getAllPolicyAccessID(){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT AC_FUNCTION_ID ");	
		sqlStr.append("FROM   AC_FUNCTION_ACCESS ");
		sqlStr.append("WHERE  AC_FUNCTION_ID LIKE '%function.policy.%' ");
		sqlStr.append("AND    AC_ENABLED = '1' ");
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean checkPolicyAccess(UserBean userBean){
		boolean allowConvert = false;
		ArrayList policyRecord = Converter.getAllPolicyAccessID();
		if(policyRecord.size() != 0){
			for(int i =0;i<policyRecord.size();i++){		 
				ReportableListObject policyList = (ReportableListObject)policyRecord.get(i);
				allowConvert = userBean.isAccessible(policyList.getValue(0));
				if(allowConvert){
					break;
				}
			}
		}
		return allowConvert;
	}
	
	public static boolean checkHospitalWideAccess(UserBean userBean){
		boolean allowConvert = false;
		if("870".equals(userBean.getDeptCode())){
			allowConvert = true;
		}
		return allowConvert;
	}
	
	public static ArrayList<String> convertPdfToImage(String sourceDir, String destinationDir, int dpi) throws IOException{
		ArrayList<String> listOfImagePath = new ArrayList<String>();
		
		File sourceDirFile = null;
		try {
	        InputStream in = null;
	        PDDocument document = null;
	        sourceDirFile = new File(sourceDir);

	        if (sourceDirFile.canRead()) {
	        	document = PDDocument.load(sourceDirFile);
	        } else {
	        	// use samba
	        	SmbFile smbFile = new SmbFile("smb:" + sourceDir.replace("\\", "/"), 
	    				new NtlmPasswordAuthentication("",CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password")));
	        	in = new SmbFileInputStream(smbFile);
	        	document = PDDocument.load(in);
	        }

	        PDFRenderer pdfRenderer = new PDFRenderer(document);
	        //String fileName = java.util.UUID.randomUUID().toString();
	        for (int page = 0; page < document.getNumberOfPages(); ++page) { 
	            BufferedImage bim = pdfRenderer.renderImageWithDPI(page, dpi, ImageType.RGB);
	            
	            // suffix in filename will be used as the file format	            
	            if(ImageIOUtil.writeImage(bim, destinationDir + (page+1) + ".png", dpi)){
	            	listOfImagePath.add((page+1) + ".png");
	            }
	        }
	        document.close();

	    } catch (Exception e) {
	        e.printStackTrace();		    
	    }	    
		return listOfImagePath;
	}	
}