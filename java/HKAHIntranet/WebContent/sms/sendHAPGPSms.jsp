<%@ page import="com.hkah.web.common.UserBean"%>
<%@ page import="com.hkah.util.ParserUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.PatientDB"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.util.sms.UtilSMS"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.common.ReportableListObject"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>

<%!
public static String getPhoneNo(String phoneNo, String couCode,
			String patNo, String refCode, String lang, String smcId, String type) {
			String keyID = patNo + "/"+refCode;
			if (patNo != null && patNo.length() > 0) {
				if (phoneNo != null && phoneNo.length() > 0) {
					if (couCode != null && couCode.length() > 0) {
						if (couCode.equals("852") || couCode.equals("853")) {
							if (phoneNo.length() == 8) {
								//send
								return couCode + phoneNo;
							} else {
								//error
								UtilSMS.saveLog(
										"The country code is 852/853, but the phone no. "+phoneNo+" is not 8 digits",
										keyID, type, lang, smcId);
								return null;
							}
						} else if (couCode.equals("86")) {
							if (phoneNo.substring(0, 1).equals("1")
									&& phoneNo.length() == 11) {
								return couCode + phoneNo;
							} else {
								UtilSMS.saveLog(
										"The country code is 86, but first letter of phone no. "+phoneNo+" is not ''1'' or the phone no. is not 11 digits",
										keyID, type, lang, smcId);
								return null;
							}
						} else {
							UtilSMS.saveLog("The country code is not 852/853/86 Phone No. "+phoneNo,
									keyID, type, lang, smcId);
							return null;
						}
					} else {
						UtilSMS.saveLog("Country Code is empty value Phone No. "+phoneNo, keyID, type,
								lang, smcId);
						return null;
					}
				} else {
					UtilSMS.saveLog("Phone No. is empty value", keyID, type, lang,
							smcId);
					return null;
				}
			} else {
				if (phoneNo != null && phoneNo.length() > 0) {
					if (phoneNo.length() == 8) {
						return phoneNo;
					} else if (phoneNo.length() > 8) {
						if (phoneNo.substring(0, 3).equals("861")
								&& phoneNo.length() == 13) {
							return phoneNo;
						} else if (phoneNo.substring(0, 3).equals("853")
								&& phoneNo.length() == 11) {
							return phoneNo;
						} else {
							UtilSMS.saveLog(
									"Phone No. "+phoneNo+" is greater than 8 digits, but it does not belong to 86 or 853",
									keyID, type, lang, smcId);
							return null;
						}
					} else {
						UtilSMS.saveLog("Phone No. "+phoneNo+" is less than 8 digits", keyID,
								type, lang, smcId);
						return null;
					}
				} else {
					UtilSMS.saveLog("Phone No. "+phoneNo+" is empty value", keyID, type, lang,
							smcId);
					return null;
				}
			}
	}

private static boolean insertSMSRecord(String keyID, String patNo,
		String mobilePhone,String revCode,String mothCode,String expDate,String patName) {
	return UtilDBWeb.updateQueue(
			"INSERT INTO PE_SMS (SMS_ID, PATNO, PATNAME, PATMTEL, MOTHCODE, REVCODE,EXPIRY_DATE, CREATE_DATE) " +
			"VALUES ('" + keyID + "' , '" + patNo + "' , '" + patName  + "' , '" + mobilePhone  + "' , '" + mothCode + "' , '" + revCode + "' , " 
					+" to_date('"+ expDate + "','dd/mm/yyyy') , SYSDATE)");			 
}

	
%>
<%
UserBean userBean = new UserBean(request);
String mobile = ParserUtil.getParameter(request, "mobile");
String couCode = ParserUtil.getParameter(request, "couCode");
String lang = ParserUtil.getParameter(request, "lang");
String patNo = ParserUtil.getParameter(request, "patNo");
String refNo = ParserUtil.getParameter(request, "refNo");
String expDate = ParserUtil.getParameter(request, "expDate");
String patName = ParserUtil.getParameter(request, "patName");

String content = "";
boolean success = true;

if (mobile != null || !mobile.isEmpty()) {
//	String lang = "";
//	ReportableListObject row = (ReportableListObject)record.get(0);

//	lang = row.getValue(0);

	if (lang.length() <= 0) {
		lang = "ENG";
	}

	//lang = "JAP";//for testing only

	String phoneNo =
		getPhoneNo(mobile, couCode.trim(),
				patNo.trim(), refNo.trim(), lang, "HAPGP", UtilSMS.SMS_HA);

	if (phoneNo == null) {
		
		insertSMSRecord(patNo + "/"+refNo, patNo, mobile, 
						refNo, lang,expDate,patName);
		success = false;
	} else {
		
		String[] eDate = expDate.split("/");

		
		if (lang.equals("ENG")) {
			content = MessageResources.getMessageEnglish("prompt.sms.ha.patgetpat1")+" "+refNo
					  +MessageResources.getMessageEnglish("prompt.sms.ha.patgetpat2")+" "+expDate
					  +MessageResources.getMessageEnglish("prompt.sms.ha.patgetpat3");
		} else if (lang.equals("TRC")) {
			content = MessageResources.getMessageTraditionalChinese("prompt.sms.ha.patgetpat1")+refNo
					  +MessageResources.getMessageTraditionalChinese("prompt.sms.ha.patgetpat2")
					  +eDate[2]+MessageResources.getMessageTraditionalChinese("prompt.year")
					  +eDate[1]+MessageResources.getMessageTraditionalChinese("prompt.month")
					  +eDate[0]+MessageResources.getMessageTraditionalChinese("label.day")
					  +MessageResources.getMessageTraditionalChinese("prompt.sms.ha.patgetpat3");			
		} else if (lang.equals("SMC")) {
			content = MessageResources.getMessageSimplifiedChinese("prompt.sms.ha.patgetpat1")+refNo
					  +MessageResources.getMessageSimplifiedChinese("prompt.sms.ha.patgetpat2")
					  +eDate[2]+MessageResources.getMessageSimplifiedChinese("prompt.year")
					  +eDate[1]+MessageResources.getMessageSimplifiedChinese("prompt.month")
					  +eDate[0]+MessageResources.getMessageSimplifiedChinese("label.day")
					  +MessageResources.getMessageSimplifiedChinese("prompt.sms.ha.patgetpat3");		
			
		} else if (lang.equals("JAP")) {
			content = MessageResources.getMessage(Locale.JAPAN, "prompt.sms.ha.patgetpat1")+refNo
					  +MessageResources.getMessage(Locale.JAPAN, "prompt.sms.ha.patgetpat2")
					  +eDate[2]+MessageResources.getMessage(Locale.JAPAN, "prompt.year")
					  +eDate[1]+MessageResources.getMessage(Locale.JAPAN, "prompt.month")
					  +eDate[0]+MessageResources.getMessage(Locale.JAPAN, "label.day")
					  +MessageResources.getMessage(Locale.JAPAN, "prompt.sms.ha.patgetpat3");		
		}

		if (content != null) {

			UtilMail.sendMail(
					"alert@hkah.org.hk",
					new String[] { "cherry.wong@hkah.org.hk" },
					null,
					null,
					"Hong Kong Adventist Hospital - Patient Get Patient SMS",
					"SMS: <br/>patno: "+patNo+" PHONENO: "+phoneNo+
					"<br/><br/>"+content,false);
			
			String keyID = patNo + "/"+refNo;
			
			insertSMSRecord(keyID, patNo, phoneNo, 
							refNo, lang,expDate,patName);	


  				UtilSMS.sendSMS(null, new String[] { phoneNo },
						content,
						UtilSMS.SMS_HA, patNo + "/"+refNo, lang, "HAPGP");   

		} else {
			//error
			insertSMSRecord(patNo + "/"+refNo, patNo, "", 
							refNo, lang,expDate,patName);	
			
			UtilSMS.saveLog("Cannot retrieve any template",
					patNo + "/"+refNo, UtilSMS.SMS_HA, "", "HAPGP");
			success = false;
		}
	}
} else {
	//Fail
	UtilSMS.saveLog("Cannot find any record with this REFNO",
			"HAPGP"+refNo, UtilSMS.SMS_HA, "", "HAPGP");
	success = false;
}

%>
<%=success%>