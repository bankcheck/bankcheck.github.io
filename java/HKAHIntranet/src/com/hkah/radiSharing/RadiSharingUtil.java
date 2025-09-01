package com.hkah.radiSharing;

import hk.org.ha.eai.cid.hl7receiver.SendXMLToHA;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter; 
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.io.FileOutputStream;

import org.apache.commons.io.FileUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;
import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.*;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.tools.imageio.ImageIOUtil;

import com.hkah.radiSharing.Converter;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.parser.PdfTextExtractor;

public class RadiSharingUtil   {
	String tempPid = null;	
	static int filesSending = 0;
	static int filesTotal = 0;
	private static Logger logger = Logger.getLogger(RadiSharingUtil.class);

	public static Integer countUnsentFile(String Type, String File){
		File tempFile = new File(File);
		if("Image".equals(Type)){
			String[] tempCount = tempFile.list();
			if(tempCount.length>0){
			return tempCount.length;
			}else{
				return 0;
			}
		}else if("Report".equals(Type)){
			
			String[] tempCount = tempFile.list();
			Integer countXML = 0;
		    for (String s : tempCount) {
		        if(s.indexOf(".xml") >-1){countXML++;};
		     }
		    return countXML;
		}
		return 0;

	}

	public static int getFilesSending() {
		return filesSending;
	}

	public static int getFilesTotal() {
		return filesTotal;
	}


	public static String openFile(String path){
		String sourceFolder = "c:\\Program Files\\Apache Software Foundation\\Tomcat 6.0\\radi_logs\\";

		try {
				path=sourceFolder+path;
				BufferedReader input = new BufferedReader (new FileReader(path));
				String line = "";	
				String content = "";
				while(null != (line = input.readLine())) {
					if(line.contains("====")){
						content+="<br>"; 
					}
					content+=line+"<br>";  
				}
				input.close();

				return content;

		} catch (Exception  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;

		} 
	}

	public static String writeToDailyLog(String text){
		 Calendar calendar = Calendar.getInstance();
		 calendar.getInstance();
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyMMdd");
		String filePreFix ="SentRadi";
			 if(text.indexOf("<report>")>-1){
				 sdFormat = new SimpleDateFormat("yyMM");	 			
			 }

			try {
				File tempFile = new File("c:\\Program Files\\Apache Software Foundation\\Tomcat 6.0\\radi_logs\\"+filePreFix+"_"+sdFormat.format(calendar.getTime())+".log"); 
				if(text.indexOf("<report>")>-1){
					text = text.substring("<report>".length());
					filePreFix = "MonthlyStat";
				}
				FileWriter outFile = new FileWriter("c:\\Program Files\\Apache Software Foundation\\Tomcat 6.0\\radi_logs\\"+filePreFix+"_"+sdFormat.format(calendar.getTime())+".log",true);
				PrintWriter  writer = new PrintWriter (outFile);
				
				writer.println(text);
				writer.close();
				return "c:\\Program Files\\Apache Software Foundation\\Tomcat 6.0\\radi_logs\\"+filePreFix+"_"+sdFormat.format(calendar.getTime())+".log";
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return null;
			}

		
	}

	public static String updateTableContent(String xmlPath, String pName,String accessionNo, String hkID){
		File xmlFile = new File(xmlPath); 
		SAXReader reader = new SAXReader();  
		Document doc;
		HashMap<String, String> xmlMap = new HashMap<String, String>();	
		try {
			doc = reader.read(xmlFile);
			Element root = doc.getRootElement();
			xmlMap = treeWalk(root,xmlMap,0);
			xmlMap = generateFullXMLMap(xmlMap);
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String[] temp = xmlMap.get("PID.5").split(",");
		String pid5 = xmlMap.get("PID.5");
		if("NULL".equals(temp[1].trim().toUpperCase())){
			pid5 = temp[0];
		}
		System.out.println("pName:"+pName);
		System.out.println("xmlMap.get(PID.5):"+xmlMap.get("PID.5"));
		if(!pName.equals(pid5)){
			return pid5;
		}else{
			return "1";
		}
	}

	public static void generateMsg(String xmlPath, String attrValue){
		File xmlFile = new File(xmlPath);
		 Calendar calendar = Calendar.getInstance();
		 calendar.getInstance();
		 SimpleDateFormat sdFormat = new SimpleDateFormat("yyMMddHHmmss");	
		SAXReader reader = new SAXReader();  
		Document doc;
	    OutputFormat format = OutputFormat.createCompactFormat(); 
	    format.setEncoding("UTF-8");  
	    format.setSuppressDeclaration(false);
	    format.setIndent(false);
	    format.setNewLineAfterDeclaration(false);
		try {
			doc = reader.read(xmlFile);
			Element root = doc.getRootElement(); 
	        try {
	       	 XMLWriter writer = new XMLWriter(new FileWriter(new File(xmlFile.getParent()+"\\Sent\\"+sdFormat.format(calendar.getTime())+"_"+xmlFile.getName())),  
	                       format);  
		        writer.write( doc );
				writer.close();
				logger.info("Update to "+attrValue+": "+xmlFile.getName());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Element editedElement = treeWalkEdit(root,"CWE.1",attrValue,0);
			        try {
			        	 XMLWriter writer = new XMLWriter(new FileWriter(new File(xmlPath)),  
			                        format);  
				        writer.write( doc );
						writer.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}

		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}



	public static void copyDirectory(String sourceLocation) throws IOException{
		File sourceFile = new File(sourceLocation);
		 Calendar calendar = Calendar.getInstance();
		 calendar.getInstance();
		 SimpleDateFormat sdFormat = new SimpleDateFormat("yyMMddHHmmss");					 
		 String targetLocation = sourceLocation+"_"+sdFormat.format(calendar.getTime());
		 File targetFile = new File(targetLocation);
		 sourceFile.renameTo(targetFile);
		 logger.info("rename "+sourceLocation +"to "+targetLocation);
		 File replaceFile = new File(sourceLocation);
		 logger.info("new "+sourceLocation+" created");
		 replaceFile.mkdir();

	}

	public static void copyFile(String targetLocation,String Folder,String file) throws IOException{
		File fileToBeMoved = new File(file);
		File sourceFile = new File(targetLocation);
		 targetLocation = targetLocation+Folder+"\\";
		File targetFile = new File(targetLocation);
		FileUtils.copyFileToDirectory(fileToBeMoved, targetFile);
		logger.info("file "+file+" moved to "+targetLocation);
		fileToBeMoved.delete();

	}



	public static boolean checkFileExist(String xmlPath,String imgPath){
		File xmlFile = new File(xmlPath); 

		File imgFile = new File(imgPath);
		
		try {
			if(imgFile.getCanonicalFile().isDirectory()){
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		if(imgFile.isDirectory()){
		}
		
		if(xmlFile.exists()){
			//CallWebServer.callHL7toSend(xmlPath);
			return true;
		}else{
			return false;
		}
	}

	public static boolean sendXML(String xmlPath,String dest){
		 
		boolean result = SendXMLToHA.sendHL7(xmlPath,dest);
		String test = writeToDailyLog("Report Sent:"+result);
		return result;
	}

	public static String sendDCM(String imgPath,String remoteHost, String AET,String port){
		File dcmFile = new File(imgPath); 
		String result;
		 Calendar calendar = Calendar.getInstance();
		 calendar.getInstance();
		 dcmSend ds = new dcmSend(){
			 @Override
			 public void postSendDcmFile(){
				 filesSending = getFileSending();
			 };
		 };
		 SimpleDateFormat sdFormat = new SimpleDateFormat("yyMMddHHmmss");
		 	filesTotal = (int) dcmFile.length();
		 	result = ds.sendDcmFile(dcmFile,remoteHost,AET,Integer.parseInt(port));
			System.out.println("No of DCM Sent:"+result+"\n"+"Sent Date:"+sdFormat.format(calendar.getTime()));
		if(!"0".equals(result)){
			if(result.indexOf("ERROR")>-1){
				System.out.println("\n"+"DICOM Image sending Fail");
				return null;
			}else{
				System.out.println(imgPath+": No of DCM Sent:"+result+"\n"+"Sent Date:"+sdFormat.format(calendar.getTime()));
				return "No of DCM Sent:"+result;
			}
		}else{
			return null;	
		}
	}
	
	public static String getXmlPdf(String xmlName){
		HashMap<String, String> xmlMap = new HashMap<String, String>();

			File xmlFile = new File(xmlName); 
			SAXReader reader = new SAXReader();  
			Document doc = null;
			try {
				doc = reader.read(xmlFile);
			} catch (DocumentException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			Element root = doc.getRootElement(); 
			 
			xmlMap = treeWalk(root,xmlMap,0);
			xmlMap = generateFullXMLMap(xmlMap);				

		
		//BASE64Decoder decoder = new BASE64Decoder();
		Base64 decoder = new Base64();
		;
		try {
			//decodedBytes = decoder.decodeBuffer(xmlMap.get("ED.5"));
			byte[] decodedBytes = decoder.decode(xmlMap.get("ED.5").getBytes());
			File file = new File(xmlName.substring(0,xmlName.lastIndexOf("."))+".pdf");
			FileOutputStream fop = new FileOutputStream(file);
			fop.write(decodedBytes);
			fop.flush();
			fop.close();
			return file.getAbsolutePath();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;

		}

	        
		
	}

	public static void checkXmlPDF(String xmlName,String swfHostSite){
		HashMap<String, String> xmlMap = new HashMap<String, String>();

			File xmlFile = new File(xmlName); 
			SAXReader reader = new SAXReader();  
			Document doc = null;
			try {
				doc = reader.read(xmlFile);
			} catch (DocumentException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			Element root = doc.getRootElement(); 
			 
			xmlMap = treeWalk(root,xmlMap,0);
			xmlMap = generateFullXMLMap(xmlMap);				

		
			//BASE64Decoder decoder = new BASE64Decoder();
			Base64 decoder = new Base64();
			;
			try {
				//decodedBytes = decoder.decodeBuffer(xmlMap.get("ED.5"));
				byte[] decodedBytes = decoder.decode(xmlMap.get("ED.5").getBytes());
			File file = new File(xmlName.substring(0,xmlName.lastIndexOf("."))+".pdf");
			FileOutputStream fop = new FileOutputStream(file);
			fop.write(decodedBytes);
			fop.flush();
			fop.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	       try {
			Converter.convertPDF2SWF(xmlName.substring(0,xmlName.lastIndexOf("."))+".pdf",swfHostSite);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	        
		
	}
	
	public static void checkXmlImg(String xmlName,String swfHostSite){
		HashMap<String, String> xmlMap = new HashMap<String, String>();

			File xmlFile = new File(xmlName); 
			SAXReader reader = new SAXReader();  
			Document doc = null;
			try {
				doc = reader.read(xmlFile);
			} catch (DocumentException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			Element root = doc.getRootElement(); 
			 
			xmlMap = treeWalk(root,xmlMap,0);
			xmlMap = generateFullXMLMap(xmlMap);				

		
			//BASE64Decoder decoder = new BASE64Decoder();
			Base64 decoder = new Base64();
			;
			try {
				//decodedBytes = decoder.decodeBuffer(xmlMap.get("ED.5"));
				byte[] decodedBytes = decoder.decode(xmlMap.get("ED.5").getBytes());
			File file = new File(xmlName.substring(0,xmlName.lastIndexOf("."))+".pdf");
			FileOutputStream fop = new FileOutputStream(file);
			fop.write(decodedBytes);
			fop.flush();
			fop.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	       try {
			Converter.convertPdfToImage(xmlName.substring(0,xmlName.lastIndexOf("."))+".pdf",swfHostSite,100);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	        
		
	}
	
	
/*	public static String getRptDocTxt(String site,String accessionNo,String patNo){
		byte[] buf = null;
	    StringBuffer text = new StringBuffer();
		try {
			URL url = new URL( "http://localhost:8080/intranet/"+
							"convert/radiReportBlob2.jsp?accessionNo="+
							accessionNo+"&patNo="+patNo);
			
			System.out.println("URL:"+url.toString());
			URLConnection connection = url.openConnection();
		    InputStreamReader in = new InputStreamReader((InputStream)connection.getContent());
		    BufferedReader buff = new BufferedReader(in);
		    String line;
		    do {
		      line = buff.readLine();
		      text.append(line + "\n");
		    } while (line != null);
		    in.close();
			} catch (IOException e) {
	       	 	System.out.println("IOException :"+e);
				e.printStackTrace();
			}
		return text.toString().replaceAll("null","").trim() ; 
	}*/
	
/*	public static HashMap<String,String> checkXmlPDFWfCheck(String xmlName,String swfHostSite){
		HashMap<String, String> xmlMap = new HashMap<String, String>();
			File xmlFile = new File(xmlName); 
			SAXReader reader = new SAXReader();  
			Document doc = null;
			try { 
				doc = reader.read(xmlFile);
			} catch (DocumentException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			Element root = doc.getRootElement(); 
			 
			xmlMap = treeWalk(root,xmlMap,0);
			xmlMap = generateFullXMLMap(xmlMap);				

		
		BASE64Decoder decoder = new BASE64Decoder();
		byte[] decodedBytes;
		try {
			decodedBytes = decoder.decodeBuffer(xmlMap.get("ED.5"));
			File file = new File(xmlName.substring(0,xmlName.lastIndexOf("."))+".pdf");
			FileOutputStream fop = new FileOutputStream(file);
			fop.write(decodedBytes);
			fop.flush();
			fop.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	       try {
			Converter.convertPDF2SWF(xmlName.substring(0,xmlName.lastIndexOf("."))+".pdf",swfHostSite);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return checkPDF(xmlMap,xmlName.substring(0,xmlName.lastIndexOf("."))+".pdf");   
		
	}*/
	
	public static String getPDFContent(String pdfPath){
		 try {     
	         PdfReader reader = new PdfReader(pdfPath);
	         int n = reader.getNumberOfPages(); 
	         PdfTextExtractor e = new PdfTextExtractor(reader);
	         String str = e.getTextFromPage(1);
	         String tmpStg = null;
	         String tmpStg1 = null;
	         
	         return str;
	         /*try{
	         	 tmpStg = str.split(xmlMap.get("MSH.10"))[1];
	         	 tmpStg1 = str.substring(str.lastIndexOf("Birth"), str.lastIndexOf("Birth")+50);	
	         }catch(Exception a){
	        	 
	         }
	         if(tmpStg==null|| tmpStg.length() == 0) 
	         {
	        	 System.out.println("["+xmlMap.get("MSH.10")+"]"+"Accession No MisMatch");
	        	 matchMap.put("MSH.10","N");
	         }else {
	        	 matchMap.put("MSH.10","Y");
	         	if(tmpStg.indexOf(xmlMap.get("PID.5").replace(", null",""))>0){
	         		System.out.println("["+xmlMap.get("MSH.10")+"]"+"Patient Name match the Report");
	         		matchMap.put("PID.5","Y");
	         	}else{
	         		System.out.println("["+xmlMap.get("MSH.10")+xmlMap.get("PID.5").replace(", null","")+"]"+"Patient Name not match the Report");
	         		matchMap.put("PID.5","N");
	         	}
	         	String tmpDOB = 
	         	xmlMap.get("PID.7").substring(6,8)+"/"+xmlMap.get("PID.7").substring(4,6)+"/"+xmlMap.get("PID.7").substring(0,4);
	         	if(tmpStg1.indexOf(tmpDOB)>0){
	         		System.out.println("["+xmlMap.get("MSH.10")+tmpDOB+"]"+"Patient DOB match the Report");
	         		matchMap.put("PID.7","Y");
	         	}else{
	         		System.out.println("["+xmlMap.get("MSH.10")+tmpDOB+"]"+"Patient DOB not match the Report");
	         		matchMap.put("PID.7","N");
	         	}
	         
	         }*/
	     }
	     catch (Exception e) {
	         e.printStackTrace();
	         return null;
	     }
	}
	
	
	public static HashMap<String,String> checkPDF(HashMap<String,String> xmlMap,String pdfPath){
		HashMap<String,String> matchMap = new HashMap<String,String>();
		 try {     
	         PdfReader reader = new PdfReader(pdfPath);
	         int n = reader.getNumberOfPages(); 
	         PdfTextExtractor e = new PdfTextExtractor(reader);
	         String str = e.getTextFromPage(1);
	         String tmpStg = null;
	         String tmpStg1 = null;
	         try{
	         	 tmpStg = str.split(xmlMap.get("MSH.10"))[1];
	         	 tmpStg1 = str.substring(str.lastIndexOf("Birth"), str.lastIndexOf("Birth")+50);	
	         }catch(Exception a){
	        	 
	         }
	         if(tmpStg==null|| tmpStg.length() == 0) 
	         {
	        	 System.out.println("["+xmlMap.get("MSH.10")+"]"+"Accession No MisMatch");
	        	 matchMap.put("MSH.10","N");
	         }else {
	        	 matchMap.put("MSH.10","Y");
	         	if(tmpStg.indexOf(xmlMap.get("PID.5").replace(", null",""))>0){
	         		System.out.println("["+xmlMap.get("MSH.10")+"]"+"Patient Name match the Report");
	         		matchMap.put("PID.5","Y");
	         	}else{
	         		System.out.println("["+xmlMap.get("MSH.10")+xmlMap.get("PID.5").replace(", null","")+"]"+"Patient Name not match the Report");
	         		matchMap.put("PID.5","N");
	         	}
	         	String tmpDOB = 
	         	xmlMap.get("PID.7").substring(6,8)+"/"+xmlMap.get("PID.7").substring(4,6)+"/"+xmlMap.get("PID.7").substring(0,4);
	         	if(tmpStg1.indexOf(tmpDOB)>0){
	         		System.out.println("["+xmlMap.get("MSH.10")+tmpDOB+"]"+"Patient DOB match the Report");
	         		matchMap.put("PID.7","Y");
	         	}else{
	         		System.out.println("["+xmlMap.get("MSH.10")+tmpDOB+"]"+"Patient DOB not match the Report");
	         		matchMap.put("PID.7","N");
	         	}
	         
	         }
     }
     catch (Exception e) {
         System.out.println("["+xmlMap.get("MSH.10")+"] Exception:"+e);
         e.printStackTrace();
     }
		return matchMap;
	}	
	
/*		public static boolean checkAllPDF(String record){
			String[] record1 = TextUtil.split(record, TextUtil.LINE_DELIMITER);
			int matchNo = 0;
			int ErrorNo = 0;
			int ExceptionNo = 0;
			for (int i = 0; i < record1.length; i++) {
				String[]fields = TextUtil.split(record1[i]);
				String accessionNo = fields[0];
				String patNo = fields[1];
				String xmlPath = fields[2];
				String currentPDF = xmlPath.split(accessionNo)[1];
				System.out.println("=====================================================");
				System.out.println("["+accessionNo+"]"+"accessionNo: "+accessionNo);
				System.out.println("["+accessionNo+"]"+"patNo:"+patNo);
				System.out.println("["+accessionNo+"]"+" xmlPath: "+xmlPath);
				try {
				currentPDF= currentPDF.substring(1,currentPDF.length()-4);
				}catch(Exception b){
					System.out.println("["+accessionNo+"]"+"File Name Error: "+patNo);
	         		ErrorNo++;
	         		continue;
				}
				  try {     
				         PdfReader reader = new PdfReader("C:\\HApdf\\"+currentPDF+".pdf");
				         int n = reader.getNumberOfPages(); 
				         PdfTextExtractor e = new PdfTextExtractor(reader);
				         String str = e.getTextFromPage(1);
				         String tmpStg = null;
				         try{
				         	 tmpStg = str.split(accessionNo)[1];
				         }catch(Exception a){
				        	 
				         }
				         if(tmpStg==null|| tmpStg.length() == 0) 
				         {
				        	 System.out.println("["+accessionNo+"]"+"Accession No Error: "+patNo);
				         		ErrorNo++;
				         }else {
				         	if(tmpStg.indexOf(patNo)>0){
				         		System.out.println("["+accessionNo+"]"+"Patient Number "+ patNo+" match the Report");
				         		//System.out.println("["+accessionNo+"]"+"Report:"+tmpStg.split("Page")[0]);
				         		matchNo++;
				         	}else{
				         		System.out.println("["+accessionNo+"]"+"Patient No Error: "+patNo);
				         		ErrorNo++;
				         	}
				         }
		         }
		         catch (Exception e) {
		             System.out.println("["+accessionNo+"]"+e);
		             e.printStackTrace();
		             ExceptionNo++;
		         }
							     
				}
					System.out.println("************************************************************************");
					System.out.println("Total Case:"+record1.length+" Match Case:"+matchNo+" Error Case:"+ErrorNo+" Exception No:"+ExceptionNo);
			return true;
		}*/


		public static boolean checkXML(String xmlPath,HashMap<String,String> barCodeMap){
			try{
				File xmlFile = new File(xmlPath); 
				SAXReader reader = new SAXReader();  
				Document doc = reader.read(xmlFile);
				Element root = doc.getRootElement(); 
				Element foo; 
				HashMap<String, String> xmlMap = new HashMap<String, String>();
				 
				xmlMap = treeWalk(root,xmlMap,0);
				xmlMap = generateFullXMLMap(xmlMap);
					String tempDOB = (barCodeMap.get("DOB").length() == 4 && 
							barCodeMap.get("DOB").startsWith("19"))?barCodeMap.get("DOB")+"0101":barCodeMap.get("DOB");

		        if(!xmlMap.get("PID.3").equals(barCodeMap.get("HKID"))){
		        	System.out.println("PID3 not match");
		        	return false;
		        }else if(!xmlMap.get("PID.7").equals(tempDOB)){
			        	System.out.println("PID7 not match");
			        	return false;
		        }else if(!xmlMap.get("PID.8").equals(barCodeMap.get("SEX"))){ 
		        	System.out.println("PID8 not match");
		        	return false;
		        }else if(!xmlMap.get("PID.5").equals(barCodeMap.get("ENAME"))){ 
		        	System.out.println("PID5 not match");
		        	return false;
		        }else{
		        	return true;
		        }

				
			}catch (Exception e){
				System.out.println(e);
			}
			return false;
		}
		public static String getAttrValueOfXml(String xmlPath,String attrName){
			File xmlFile = new File(xmlPath); 
			SAXReader reader = new SAXReader();  
			Document doc;
			HashMap<String, String> xmlMap = new HashMap<String, String>();	
			try {
				doc = reader.read(xmlFile);
				Element root = doc.getRootElement();
				xmlMap = treeWalk(root,xmlMap,0);
				xmlMap = generateFullXMLMap(xmlMap);
			} catch (DocumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			return xmlMap.get(attrName);
		}
		
		public static HashMap<String,String> getMapOfXml(String xmlPath){
			File xmlFile = new File(xmlPath); 
			SAXReader reader = new SAXReader();  
			Document doc;
			HashMap<String, String> xmlMap = new HashMap<String, String>();	
			try {
				doc = reader.read(xmlFile);
				Element root = doc.getRootElement();
				xmlMap = treeWalk(root,xmlMap,0);
				xmlMap = generateFullXMLMap(xmlMap);
			} catch (DocumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			return xmlMap;
		}


		public static HashMap<String,String> getBarCodeData(String BarCodeData){
			HashMap<String, String> barCodeMap = new HashMap<String, String>();
	        try {  //read barcode
	            InputStream barCode = new ByteArrayInputStream(BarCodeData.getBytes("UTF-8"));
	            SAXReader reader = new SAXReader(); 
	            Document doc = reader.read(barCode);
	            Element root = doc.getRootElement(); 
		        root = doc.getRootElement();  
		        Element foo; 
		        for (Iterator i = root.elementIterator(); i.hasNext();) {
		        	foo = (Element) i.next();  
		        	barCodeMap.put(foo.getName().toUpperCase(), foo.getText().trim());
		        }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
			return barCodeMap;
		}

		private static  HashMap<String, String>  treeWalk(Element  element, HashMap<String,String> xmlMap,Integer count)  { 
			if(element.getName().indexOf("PID")==0 || element.getName().indexOf("ORC")==0 || element.getName().indexOf("ED.5")==0
				|| element.getName().indexOf("MSH.10")==0){
				xmlMap.put(element.getName(),element.asXML());
			}		
			   for  (  int  i  =  0,  size  =  element.nodeCount();  i  <  size;  i++  )  {  
			       Node  node  =  element.node(i); 
			           if  (  node  instanceof  Element  )  {
			               	treeWalk(  (Element)  node ,xmlMap,count+1);  
			           }  
			            
			     }		   
			   return xmlMap;
			}
		
		
		private static  Element treeWalkEdit(Element  element, String attrName,String revisedVal,Integer count)  { 
			if(attrName.equals(element.getName())){
					element.setText(revisedVal);
			}		
			   for  (  int  i  =  0,  size  =  element.nodeCount();  i  <  size;  i++  )  {  
			       Node  node  =  element.node(i); 
			           if  (  node  instanceof  Element  )  {
			        	   treeWalkEdit(  (Element)  node ,attrName,revisedVal,count+1);  
			           }  
			            
			     }
			   return element;
			}
		
		
		private static String getAttrValue(String attrString, String key){
			String result = null;
			if(attrString.indexOf("<"+key+">")> -1){
				result = attrString.substring(attrString.indexOf("<"+key+">")+("<"+key+">").length(),attrString.indexOf("</"+key+">"));
			}
					
			return result;
		}
		
		private static HashMap<String, String> generateFullXMLMap(HashMap xmlMap){
			HashMap<String, String> resultMap = new HashMap<String, String>();
			
			resultMap.put("PID.3",getAttrValue(xmlMap.get("PID.3").toString(),"CX.1")); //hkid
			resultMap.put("PID.5",getAttrValue(xmlMap.get("PID.5").toString(),"FN.1")+", "
					+getAttrValue(xmlMap.get("PID.5").toString(),"XPN.2")); //name
			resultMap.put("PID.7",getAttrValue(xmlMap.get("PID.7").toString(),"TS.1")); //dob
			resultMap.put("PID.8",getAttrValue(xmlMap.get("PID.8").toString(),"PID.8"));//sex
			resultMap.put("ORC.25",getAttrValue(xmlMap.get("ORC.25").toString(),"CWE.1")); //msg status
			resultMap.put("ED.5",getAttrValue(xmlMap.get("ED.5").toString(),"ED.5")); //report
			resultMap.put("MSH.10",getAttrValue(xmlMap.get("MSH.10").toString(),"MSH.10")); //accession no
			return resultMap;
		}
		
		
		
		private  HashMap  treeWalk2(Element  element, HashMap<String,String> xmlMap,Integer count)  { 
			if("PID.3".equals(element.getName())){

			}
			
			   for  (  int  i  =  0,  size  =  element.nodeCount();  i  <  size;  i++  )  {  
			       Node  node  =  element.node(i); 
			           if  (  node  instanceof  Element  )  {
			        	   if(count == 2){
			        		   tempPid = element.getName();
			        	   }
			        	   if(element.getName().indexOf("PID")==0 || element.getName().indexOf("ORC")==0){
			        		   tempPid = element.getName();
			        	   }
			               	treeWalk(  (Element)  node ,xmlMap,count+1);  
			           }  
			           else  {
			        	   if(count ==2){
			        		   tempPid = element.getName();
			        	   }
			        	   if(element.getName().indexOf("PID")==0 || element.getName().indexOf("ORC")==0){
			        		   tempPid = element.getName();
			        	   }
			        	   if(tempPid != null && !"".equals(node.getText().trim())){
			        		   
			        		   System.out.println("node[PName]"+tempPid+"[Value]"+node.getText());
			        		   if((xmlMap.get(tempPid) != null)){
			        			   if(!("PID.3".equals(tempPid))){ 
			        			   String temp = xmlMap.get(tempPid);
			        			   xmlMap.put(tempPid, temp+node.getText());
			        			   System.out.println("Map:ID:"+tempPid+",Value:"+xmlMap.get(tempPid));
			        			   }
			        		   }else{
			        			   if("PID.5".equals(tempPid)){
			        				   String temp = node.getText()+", ";
			        				   xmlMap.put(tempPid,temp);
			        			   }else{
			        			   xmlMap.put(tempPid,node.getText());
			        			   }
			        		   }
			        	   }
			           }  
			     }
			   return xmlMap;
			} 	
}
