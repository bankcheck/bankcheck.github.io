<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.db.*" %>
<%@ page import="com.hkah.util.mail.*" %>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.web.common.*" %>
<%@ page import="com.hkah.web.schedule.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.hkah.util.sms.UtilSMS" %>;
<%@ page import="java.net.InetAddress" %>;
<%@ page import="java.net.HttpURLConnection" %>;
<%@ page import="java.net.URL" %>;
<%@ page import="javax.xml.parsers.*" %>;
<%@ page import="org.w3c.dom.*" %>;
<%@ page import="org.xml.sax.InputSource" %>;
<%@ page import="org.json.simple.JSONObject" %>;
<%@ page import="org.json.simple.parser.JSONParser" %>;
<%!
private static String parseData(String data) throws IOException {
	
	String output = null;
		
	try {
		//DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        InputSource is = new InputSource();
        //System.out.println(data);
        is.setCharacterStream(new StringReader(data));
        
        Document doc = dBuilder.parse(is);
        doc.getDocumentElement().normalize();
        output = doc.getElementsByTagName("string").item(0).getTextContent();

	}
	catch (Exception e) {
		System.out.println("parse Error: " + e.toString());
	}
	
	return output;
}

private static String getData(String regid) throws IOException {
	
	String strURL = "http://192.168.0.140:8081/NIS.asmx/getAdmissionData";	
	String response = new String();
	
	try {
		URL url = new URL(strURL);			
		HttpURLConnection http = (HttpURLConnection)url.openConnection();

		http.setRequestMethod("POST");
		http.setDoOutput(true);
		http.setRequestProperty("Accept", "text/plain");
		http.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");	
		
		StringBuffer data = new StringBuffer();
		data.append("FeeNo=");
		data.append(regid);
		
		DataOutputStream outputStream = new DataOutputStream(http.getOutputStream());							
		BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream, "UTF-8"));					
		writer.write(data.toString());
		writer.close();
		outputStream.close();
															
		BufferedReader in = new BufferedReader(new InputStreamReader(
											http.getInputStream()));
		String inputLine;
			
		while ((inputLine = in.readLine()) != null) {
			response = response + inputLine;
		}
		in.close();
	}
	catch (Exception e) {
		System.out.println("RECV Error: " + e.toString());
	}
	//System.out.println("RECV: " + response);
	return parseData(response);
}

private static void setTmpData(String data) throws IOException {
					
	try {				
		if ((data.length() != 0) && (data != null)) {
			
			JSONParser jParser = new JSONParser();
			
			JSONObject obj =  (JSONObject)jParser.parse(data);
			
	        for (Object key : obj.keySet()) {
	        	
		    	Object value = obj.get(key);	
		    	
		    	if (value != null)
		    		System.out.println(key.toString() + "=" + value.toString());
	        }
			
		}
	} catch (Exception e) {
		System.out.println("setTmpData Error: data=" + data + " exception=" + e.toString());
	}
}
%>
<%
String action = request.getParameter("a");
boolean debug = !("N".equals(request.getParameter("d")));

String email = request.getParameter("e");
if (email == null)
	email = "arran.siu@hkah.org.hk";

String filename = request.getParameter("f");
String labnum = request.getParameter("l");
String message = request.getParameter("m");
String phone = request.getParameter("p");
String regid = request.getParameter("r");
String rptId = request.getParameter("rp");
String rptType = request.getParameter("rt");
String surveyDate = request.getParameter("s");
String type = request.getParameter("t");

if (phone == null) 
	phone = "85252388322";

if (phone.length() == 8)
	phone =  "852" + phone;

String tmpFolder = ConstantsServerSide.TEMP_FOLDER;
String site = ConstantsServerSide.SITE_CODE;

//String site = ConstantsServerSide.SITE_CODE;

String rtnmsg = "SUCCESS";

System.out.println("testClient: action=" + action);

if ( "covid".equals(action) ) {
	try {	
		message = NotifyPatientCOVID.send ( labnum, email, debug );
			
		if ( message != null )
			rtnmsg = message;				
		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		rtnmsg = e.getMessage();
	}
} else if ( "report".equals(action) ) {
	try {	
		message = SendPatientReport.sendSingleReport( rptId, rptType, email, debug );
			
		if ( message != null )
			rtnmsg = message;				
		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		rtnmsg = e.getMessage();
	}
} else if ( "newDischarge".equals(action) ) {
	try {	
		message = SendDocNewDischarge.sendSingleDischarge( rptId, email, debug );
			
		if ( message != null )
			rtnmsg = message;				
		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		rtnmsg = e.getMessage();
	}
} else if ( "oldDischarge".equals(action) ) {
	try {	
		message = SendDocRevisedDischarge.sendSingleDischarge( rptId, email, debug );
			
		if ( message != null )
			rtnmsg = message;				
		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		rtnmsg = e.getMessage();
	}		
} else if ( "surveyData".equals(action) ) {
	try {
		Date date = null;
				
		if (surveyDate.isEmpty() || surveyDate == null) {
	        date = new Date();
		} else {
			date = new SimpleDateFormat("yyyyMMdd").parse(surveyDate);
		}
	    
		rtnmsg = InsertSurveyData.getData(date, debug);
		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		rtnmsg = e.getMessage();
	}	
} else if ( "surveyInsert".equals(action) ) {
	try {
		Date date = null;
		
		if (surveyDate.isEmpty() || surveyDate == null) {
	        date = new Date();
		} else {
			date = new SimpleDateFormat("yyyyMMdd").parse(surveyDate);
		}
	    
		InsertSurveyData.process(date);
		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		rtnmsg = e.getMessage();
	}		
} else if ( "sms".equals(action) ) {
	try {
		
		String acc = UtilSMS.SMS_TWDENT;
		System.out.println(type);
		if (type != null) {
			message = NotifyPatientRecall.getSmsContent(type);			
			System.out.println(message);
			String msgId = UtilSMS.sendSMS("", new String[] { phone },
					message,
					acc, "TESTING", "ENG", "PRS@CIS");
			
			rtnmsg = "SMS: MSGID=" + msgId;
			
			ArrayList<ReportableListObject> extraMessage = NotifyPatientRecall.getSmsContentExtra( type );
						
			if ( (extraMessage != null) && (extraMessage.size() > 0) ) {
				for (int j = 0; j < extraMessage.size(); j++) {
					ReportableListObject row = (ReportableListObject) extraMessage.get(j);
					message =  row.getValue(0);
					
					if (message != null) {
						msgId = UtilSMS.sendSMS("", new String[] { phone },
								message,
								acc, "TESTING", "ENG", "PRS@CIS");
					}
					
					rtnmsg += "<br>SMS" + j + ": MSGID=" + msgId;
				}
			}			
	
		} else if (message != null) {
			String msgId = UtilSMS.sendSMS("", new String[] { phone },
					message,
					acc, "TESTING", "ENG", "PRS@CIS");
			rtnmsg = "SMS MSGID=" + msgId;
		}
	
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		rtnmsg = e.getMessage();
	}
	
} else if ( "env".equals(action) ) {	
	rtnmsg = "SITE CODE: " + site;
	rtnmsg += "<br>TEMP FOLDER: " + tmpFolder;
	rtnmsg += "<br>IP: " + InetAddress.getLocalHost().getHostAddress();
} else if ( "n".equals(action) ) {	
	setTmpData(getData(regid));
	rtnmsg = "DATA: " + getData(regid);
} else {
	rtnmsg = "Hello World v1.20";
}
%>
<%=rtnmsg%>