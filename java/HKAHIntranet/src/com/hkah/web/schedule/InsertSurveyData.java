package com.hkah.web.schedule;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Calendar;

import javax.net.ssl.HttpsURLConnection;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
//for testing
import com.sun.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.SSLSocket;
//JSON
import org.apache.commons.lang.ArrayUtils;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;

public class InsertSurveyData implements Job {

	private static final String defaultFormat = "yyyy-MM-dd";
	private static final String site = ConstantsServerSide.SITE_CODE;
	private static StringBuffer error = null; 
	
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("[InsertSurveyData] ===== v1.7 Start =====");
		//String[] errorEmails = getAdminEmail();
		String[] errorEmails = {"arran.siu@hkah.org.hk"};
		
		//processYesterday
		Date date = getDateFromToday(-1);	    
	    process(date);	  
		
		if (error != null) { 
			
			String emailFrom = "it-admin@hkah.org.hk";
			String url = "https://mail.hkah.org.hk/intranet/cms/testClient.jsp?a=surveyInsert&s=";
			
			if ("twah".equals(site)) {
				emailFrom = "alert@twah.org.hk";
				url = "https://mail.twah.org.hk/intranet/cms/testClient.jsp?a=surveyInsert&s=";
			}
			
			String message = error.toString() + "<br>Please click the following link to retry:<br>";
			message += url + convertDateFormat(date, "yyyyMMdd");
			
			String subject = "InsertSurveyData error " + convertDateFormat(date, defaultFormat);
		
			UtilMail.sendMail(emailFrom, errorEmails, subject, message);	
		}
		
		System.out.println("[InsertSurveyData] ===== End =====");
	}
	
	// ======================================================================	
	private static String getSysParam(String key){
		
		String value = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select PARAM1 from sysparam@iweb where parcde=?");
		
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {key});

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			value = row.getValue(0);
		}
        
        return value;
	}
	
	// ======================================================================			
	private static String[] getAdminEmail() {
		
		String email = null;
		
		email = getSysParam("ESURVEYERR");
	
		String[] emailArray = email.split(";");
		emailArray = (String[]) ArrayUtils.removeElement(emailArray, "");
				
		return emailArray;
	}
	
	// ======================================================================	
	private static boolean isLong(String input){
			
		try {						
			long test = Long.parseLong(input);			
		} catch (Exception e) {						
			return false;			
		}
		
		return true;
	}
	
	// ======================================================================	
	private static Date getDateFromToday(int amt){
			
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, amt);

        Date output = cal.getTime();
        	
		return output;
	}
	
	// ======================================================================	
	private static String convertDateFormat(Date input, String toFormat){
		
		String output = null; 
		
		try {	
			//Date date1 = new SimpleDateFormat(fromFormat).parse(input);  
		    
			SimpleDateFormat ft = new SimpleDateFormat(toFormat);
		    output = ft.format(input);
			
		} catch (Exception e) {
			System.out.println("[InsertSurveyData] convertDateFormat error: " + e.toString());
		}
		
		return output;
	}
	
	// ======================================================================		
	private static boolean addMaster(String sKeyMaster, String regid, String sCreateDate,  
			String patno, String sRegType, String sLocation, String sName, 
			String sMobile, String sEmail, String sSource, String sCustomerType) {
			
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT * FROM SURVEY_MASTER ");
		sqlStr.append(" WHERE SKEY_MASTER = ? ");
		sqlStr.append(" AND SCREATE_DATE >= ? ");

		ArrayList rec = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[]{sKeyMaster, sCreateDate});

		if (rec.size() > 0) {
			return false;
		} else {
		
			sqlStr = new StringBuffer();
			sqlStr.append("DELETE SURVEY_MASTER ");
			sqlStr.append(" WHERE SKEY_MASTER = ? ");
			
			UtilDBWeb.updateQueueHATS(sqlStr.toString(), 
				new String[]{sKeyMaster});
			
			sqlStr = new StringBuffer();
			sqlStr.append("DELETE SURVEY_TRAN ");
			sqlStr.append(" WHERE SKEY_MASTER = ? ");
			
			UtilDBWeb.updateQueueHATS(sqlStr.toString(), 
				new String[]{sKeyMaster});
			
			sqlStr = new StringBuffer();
			sqlStr.append("insert into SURVEY_MASTER ");
			sqlStr.append(" (SKEY_MASTER, REGID, SCREATE_DATE, PATNO, REGTYPE, SLOCATION, ");
			sqlStr.append(" SNAME, SMOBILE, SEMAIL, SSOURCE, SCUSTOMER_TYPE) ");
			sqlStr.append(" values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ");
			
			if (!UtilDBWeb.updateQueueHATS(sqlStr.toString(), 
				new String[]{sKeyMaster, regid, sCreateDate, patno, sRegType, sLocation, sName,
				sMobile, sEmail, sSource, sCustomerType})) {
				
				String message = "SURVEY_MASTER insert error: sKeyMaster=" + sKeyMaster
	    			+ " regid=" + regid
	    			+ " sCreateDate=" + sCreateDate
	    			+ " patno=" + patno
	    			+ " regType=" + sRegType
	    			+ " sLocation=" + sLocation
	    			+ " sName=" + sName
	    			+ " sMobile=" + sMobile
	    			+ " sEmail=" + sEmail
	    			+ " sSource=" + sSource
	    			+ " sCustomerType=" + sCustomerType;
		
				error.append(message + "<br>");	
		
				System.out.println("[InsertSurveryData] " + message); 	
				
				return false;
			}			
		}
		
		return true;
	}
	
	// ======================================================================		
	private static boolean addTran(String sKeyMaster, String sKeyTran, String sQuestionId,  
			String sQuestionName, String sAnswer, String optionId) {
					
		return addTran(sKeyMaster, sKeyTran, sQuestionId, sQuestionName, sAnswer, 
				null, null, null, null, optionId);
	}
	
	// ======================================================================		
	private static boolean addTran(String sKeyMaster, String sKeyTran, String sQuestionId,  
			String sQuestionName, String sAnswer, String sQuestionSubId, String sComment, 
			String groupTitle, String ratingTitle, String optionId) {
			
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("insert into SURVEY_TRAN ");
		sqlStr.append(" (SKEY_MASTER, SKEY_TRAN, SQUESTION_ID, SQUESTION_NAME, SANSWER, ");
		sqlStr.append("	SQUESTION_SUB_ID, SCOMMENT, GROUP_TITLE, RATING_TITLE, OPTION_ID) ");
		sqlStr.append(" values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ");
		
		return UtilDBWeb.updateQueueHATS(sqlStr.toString(), 
			new String[]{sKeyMaster, sKeyTran, sQuestionId, sQuestionName, sAnswer,
			sQuestionSubId, sComment, groupTitle, ratingTitle, optionId});
	}
	
	// ======================================================================	
	public static void process(Date date){
		
		JSONArray list = getJSONData(date);

		for (int m = 0; m < list.size(); m++) {

			JSONObject surveyMaster = (JSONObject)list.get(m);

	    	Long lKeyMaster = (Long)surveyMaster.get("id");
	    	String sKeyMaster = lKeyMaster.toString();
   				    	
	    	String type = (String)surveyMaster.get("type");
	    	
	    	String regType = null;
	    	
	    	if ("inp".equals(type)) 
	    		regType = "I";
	    	else if ("out".equals(type)) 
	    		regType = "O";
	    	
	    	String episode_id = (String)surveyMaster.get("episode_id");
   	
	    	String regid = null;
	    	if (isLong(episode_id)) 
	    		regid = episode_id;
 	    	
	    	String patno = (String)surveyMaster.get("patient_id");	
	    	if ((patno != null) && (patno.length() > 10)) 
	    		patno = patno.substring(0, 10);
	    	
	    	String sLocation = (String)surveyMaster.get("loc");
	    	String sSource = (String)surveyMaster.get("src");
	    	String sCustomerType = (String)surveyMaster.get("customer_type");
	    	String sName = (String)surveyMaster.get("name");
	    	String sMobile = (String)surveyMaster.get("mobile");
	    	String sEmail = (String)surveyMaster.get("email");

	    	String created_at = (String)surveyMaster.get("created_at");
	    	String sCreateDate = convertDateFormat(date, "yyyyMMddhhmmss");
	    	//0123456789012345678901234567
	    	//2022-04-19T04:08:35.000000Z
	    	if (created_at.length() >= 19) {
	    		sCreateDate = created_at.substring(0, 4) + created_at.substring(5, 7) + created_at.substring(8, 10)  
	    			+ created_at.substring(11, 13) + created_at.substring(14, 16) + created_at.substring(17, 19);	    		
	    	}
	    	
	    	if (addMaster(sKeyMaster, regid, sCreateDate, patno, regType, sLocation, sName,
	    		sMobile, sEmail, sSource, sCustomerType)) {
	    	
	    		JSONArray surveyDetail = (JSONArray)surveyMaster.get("details");
	    	
				for (int d = 0; d < surveyDetail.size(); d++) {
					JSONObject question = (JSONObject)surveyDetail.get(d);
			    	
					Long lQuestionId = (Long)question.get("question_id");
					String sQuestionId = lQuestionId.toString();
						
			    	String sQuestionName = (String)question.get("question");
			    	String sAnswer = (String)question.get("answer");
			    	
			    	Long answerOptionId = (Long)question.get("answer_option_id");
			    	String optionId = null;
			    	if (answerOptionId != null)
			    		optionId = answerOptionId.toString();
			    	
			    	if (!addTran(sKeyMaster, sQuestionId, sQuestionId, sQuestionName, sAnswer, optionId)) {
						 		
			    		String message = "SURVEY_TRAN insert error: sKeyMaster=" + sKeyMaster
			    			+ " sKeyTran=" + sQuestionId
			    			+ " sQuestionId=" + sQuestionId
			    			+ " sQuestionName=" + sQuestionName
			    			+ " sAnswer=" + sAnswer
			    			+ " optionId=" + optionId;
			    		
						error.append(message + "<br>");	
			    		
			    		System.out.println("[InsertSurveryData] " + message); 
			    	}
			    	
			    	JSONArray groups = (JSONArray)question.get("groups");
					for (int g = 0; g < groups.size(); g++) {
						JSONObject group = (JSONObject)groups.get(g);
						
						Long gid = (Long)group.get("id");
						String groupTitle = (String)group.get("title");
						
						JSONArray ratingItems = (JSONArray)group.get("rating_items");
						for (int i = 0; i < ratingItems.size(); i++) {
							JSONObject item = (JSONObject)ratingItems.get(i);
							
							Long rid = (Long)item.get("id");
							String sQuestionSubId = gid.toString() + "-" + rid.toString();
							
							String sKeyTran = sQuestionId + ":" + sQuestionSubId;
							
							String ratingTitle = (String)item.get("title");
							
							Long ratingOptionId = (Long)item.get("rating_option_id");
							optionId = null;
					    	if (ratingOptionId != null)
								optionId = ratingOptionId.toString();
														
							sAnswer = (String)item.get("rating_option_title");
							
							String sComment = (String)item.get("comment");
							
							if (sQuestionSubId.length() > 6) {
								System.out.println("[InsertSurveryData] sQuestionSubId too large: " + sQuestionSubId);
							} else if (sKeyTran.length() > 10) {
								System.out.println("[InsertSurveryData] sKeyTran too large: " + sKeyTran);
							} else {
								if (!addTran(sKeyMaster, sKeyTran, sQuestionId, sQuestionName, sAnswer,
									sQuestionSubId, sComment, groupTitle, ratingTitle, optionId)) {	
																			    		
									String message = "SURVEY_TRAN insert error: sKeyMaster=" + sKeyMaster
						    			+ " sKeyTran=" + sQuestionId
						    			+ " sQuestionId=" + sQuestionId
						    			+ " sQuestionName=" + sQuestionName
						    			+ " sAnswer=" + sAnswer
						    			+ " sQuestionSubId=" + sQuestionSubId
						    			+ " sComment=" + sComment
						    			+ " groupTitle=" + groupTitle
						    			+ " ratingTitle=" + ratingTitle
						    			+ " optionId=" + optionId;	
						    		
									error.append(message + "<br>");	
						    		
						    		System.out.println("[InsertSurveryData] " + message); 
						    	}								
							}														
						}
					}
				}			
	    	}
	    	
		}		
	}
	
	// ======================================================================	
	public static JSONArray getJSONData(Date date){
				
		JSONParser jParser = null;
		JSONArray surveyData = new JSONArray();
		Object obj = null;
		
		try {
			String data = getData(date, false);
		
			if ((data.length() != 0) && (data != null)) {
				jParser = new JSONParser();
				obj =  jParser.parse(data);
				surveyData = (JSONArray)obj;
			}
			
		} catch (Exception e) {
			
			String message = "getJSONData: " + e.toString();
			
			error.append(message + "<br>");	
			
			System.out.println("[InsertSurveryData] getJSONData error: " + e.toString());
			e.printStackTrace();
		}
				
		return surveyData;	
	}

	// ======================================================================	
	public static void setProtocol(String protocol, boolean debug){
				
		try {
			if (protocol == null) {		
				String[] protocols = getEnabledProtocols(debug);
				
				if ((protocols != null) && (protocols.length > 0 ))
					protocol = protocols[protocols.length - 1];
			}
			
			System.setProperty("https.protocols", protocol);
			
			if (debug)
				System.out.println("[InsertSurveryData] Set protocol: " + protocol);
			
		} catch (Exception e) {
			System.out.println("[InsertSurveryData] setProtocol error: " + e.toString());
		}
	}
	
	// ======================================================================	
	@SuppressWarnings("deprecation")
	public static String[] getEnabledProtocols(boolean debug){
		
		StringBuffer display = new StringBuffer();
		String[] protocols = null;
		
		try {
			SSLContext context = SSLContext.getInstance("TLS");
			context.init(null, null, null);
			
			SSLSocketFactory factory = (SSLSocketFactory) context.getSocketFactory();
			SSLSocket socket = (SSLSocket) factory.createSocket();
			
			protocols = socket.getSupportedProtocols();
			
			display.append("Supported protocols: ");
			for (int i = 0; i < protocols.length; i++) {
				display.append( protocols[i] + " " );
			}
			
			protocols = socket.getEnabledProtocols();
			
			display.append("\nEnabled protocols: ");			
			for (int i = 0; i < protocols.length; i++) {
				display.append( protocols[i] + " " );
			}
			
			if (debug)
				System.out.println("[InsertSurveryData] " + display.toString());
			
		} catch (Exception e) {
			System.out.println("[InsertSurveryData] getEnv error: " + e.toString());
		}
		
		return protocols;
	}
	
	// ======================================================================	
	public static String getData(Date date, boolean debug){
		
		String inputLine;
		String output = "";
		String strURL = getSysParam("ESURVEYURL");
			    
	    strURL += "?date=" + convertDateFormat(date, defaultFormat); 
	        
 		try {
 			
 			if (debug) {
 				System.setProperty("javax.net.debug", "all");
 			}
 			setProtocol(null, debug);
 			
			System.out.println("[InsertSurveryData] Survey URL: " + strURL);
					
			URL url = new URL(strURL);		
			HttpsURLConnection http = (HttpsURLConnection)url.openConnection();
						
			http.setRequestMethod("GET");
			http.setDoOutput(true);
			
			BufferedReader in = new BufferedReader(
									new InputStreamReader(
											http.getInputStream()));

			while ((inputLine = in.readLine()) != null) {
	    		output = output + inputLine;
	       	}

	    	in.close();		
				
		} catch (Exception e) {
				
			String message = "getData: " + e.toString() + "<br>";			
			error.append(message + "<br>");	
			
			System.out.println("[InsertSurveryData] getData error: " + e.toString());
			e.printStackTrace();
		}
				
		return output;
	}

}
