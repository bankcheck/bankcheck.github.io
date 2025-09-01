<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Locale"%>

<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.util.sms.UtilSMS"%>
<%@ page import="com.hkah.web.common.ReportableListObject"%>
<%@ page import="com.hkah.web.db.EmailAlertDB"%>
<%@ page import="com.spreada.utils.chinese.ZHConverter"%>
<%!


public static ArrayList getSMSList(SimpleDateFormat smf, Calendar startCal,
		Calendar endCal, boolean isReceiveSMS, String smcID) {
StringBuffer sqlStr = new StringBuffer();

sqlStr.append("SELECT P.MOTHCODE, B.BKGPNAME, P.PATSMS, B.SMCID, BKGMTEL, ");//0, 1, 2, 3, 4
sqlStr.append("D.DOCFNAME || ' ' || D.DOCGNAME, D.DOCCNAME, ");//5, 6
sqlStr.append("TO_CHAR(B.BKGSDATE, 'DD'), TO_CHAR(B.BKGSDATE, 'MM'), ");//7, 8
sqlStr.append("TO_CHAR(B.BKGSDATE, 'YYYY'), TO_CHAR(B.BKGSDATE, 'HH24'), ");//9, 10
sqlStr.append("TO_CHAR(B.BKGSDATE, 'MI'), B.BKGID, B.SMSSDTOK, ");//11, 12, 13
sqlStr.append("P.PATNO, P.PATPAGER, B.SMCID, CD.CO_DISPLAYNAME, P.COUCODE, ");//14, 15, 16, 17, 18
sqlStr.append("D.TITTLE, B.SMSRTNMSG, TO_CHAR(B.BKGSDATE, 'DD/MM/YYYY'), ");//19, 20, 21
sqlStr.append("S.DOCCODE, B.BKGSTS, P.PATEMAIL ");//22, 23, 24

sqlStr.append("FROM BOOKING@IWEB B, SCHEDULE@IWEB S, DOCTOR@IWEB D, PATIENT@IWEB P, CO_DOCTORS CD ");

sqlStr.append("WHERE B.BKGSDATE >= ");
sqlStr.append("TO_DATE('"+smf.format(startCal.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
sqlStr.append("AND   B.BKGSDATE <= ");
sqlStr.append("TO_DATE('"+smf.format(endCal.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
sqlStr.append("AND   S.SCHID(+) = B.SCHID ");
sqlStr.append("AND   D.DOCCODE(+) = S.DOCCODE ");
sqlStr.append("AND   P.PATNO(+) = B.PATNO ");
sqlStr.append("AND	 CD.CO_DOC_CODE(+) = S.DOCCODE ");
sqlStr.append("AND   B.BKGSTS = 'N' ");
sqlStr.append("AND   (B.USRID <> 'HACCESS' OR (B.USRID = 'HACCESS' AND B.SMCID IS NOT NULL)) ");
sqlStr.append("AND   CD.CO_DOC_CODE(+) = S.DOCCODE ");
if (isReceiveSMS) {
sqlStr.append("AND   (P.PATSMS = '-1' OR P.PATNO IS NULL) ");
sqlStr.append("AND   (B.PATNO NOT IN ");
sqlStr.append("( ");
sqlStr.append("SELECT P.PATNO ");
sqlStr.append("FROM PATIENT@IWEB P, BOOKING@IWEB B ");
sqlStr.append("WHERE P.PATSMS = '0' ");
sqlStr.append("AND B.BKGSDATE >= ");
sqlStr.append("TO_DATE('"+smf.format(startCal.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
sqlStr.append("AND   B.BKGSDATE <= ");
sqlStr.append("TO_DATE('"+smf.format(endCal.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
sqlStr.append("AND   P.PATNO = B.PATNO ");
sqlStr.append("AND   B.BKGSTS = 'N' ");
sqlStr.append(") OR B.PATNO IS NULL) ");
} else {
sqlStr.append("AND	 (P.PATSMS = '0') ");
}
if (smcID != null && smcID.length() > 0){
if( "rehab".equals(smcID)){
sqlStr.append("AND  (B.SMCID = '5' OR B.SMCID = '6' OR B.SMCID = '7' OR B.SMCID = '8' OR B.SMCID = '10') ");
} else {
sqlStr.append("AND  B.SMCID = '" + smcID + "' ");
}
}
sqlStr.append("AND   D.DOCCODE <> 'OPDN' ");
sqlStr.append("AND   D.DOCCODE <> 'OPDG' ");
sqlStr.append("AND   D.DOCCODE <> 'OPD1' ");
sqlStr.append("AND   D.DOCCODE <> 'OPD7' ");
sqlStr.append("AND   D.DOCCODE <> 'N020' ");
sqlStr.append("AND   D.DOCCODE <> 'N024' ");
sqlStr.append("AND   D.DOCCODE <> '1566' ");//DENTIST
sqlStr.append("AND   D.DOCCODE <> '1860' ");//DENTIST
sqlStr.append("AND   B.SMSSDT IS NULL ");// for whose are not processed

//sqlStr.append("AND   P.PATNO = '471944' "); For specific patient 307080
//System.out.println(sqlStr.toString());
return UtilDBWeb.getReportableList(sqlStr.toString());
}

//======================================================================
public static boolean isSmsScheduleDay(Calendar startCal) {
//check whether today is saturday or holiday with disable sms setting
if (startCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY ||
isHolidayAndDisableSMS(startCal)) {
return false;
}
return true;
}

//======================================================================
public static Calendar getAppointmentDay(Calendar startCal, boolean ignoreSentDate) {
//check whether today is thur or fri, then use T+3 to get the booking date
if (startCal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY ||
startCal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY) {
startCal.add(Calendar.DATE, 3);
} else {
//otherwise, use T+2 to get the booking date
startCal.add(Calendar.DATE, 2);
}

//check whether the booking date is holiday with disable sms setting
while(startCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY ||
isHolidayAndDisableSMS(startCal) || (!ignoreSentDate && isSentSMS(startCal))) {
startCal.add(Calendar.DATE, 1);
}

//set specific day (yyyy, m, d)
//m is current month - 1, example: April = 3
//startCal.set(2014, 3, 9);
return startCal;
}

/*
//======================================================================
private static boolean setSendSMSDate(Calendar date) {
StringBuffer sqlStr = new StringBuffer();
SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

sqlStr.append("UPDATE BOOKING@IWEB ");
sqlStr.append("SET SMSSDT = NULL, SMSSDTOK = NULL, SMSRTNMSG = NULL ");
sqlStr.append("WHERE BKGSDATE >= TO_DATE('"+smf.format(date.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
//sqlStr.append("AND BKGSDATE <= TO_DATE('"+smf.format(date.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");

return UtilDBWeb.updateQueue(sqlStr.toString());
}
*/

//======================================================================
public static void sendSMS(boolean ignoreSentDate) {
//get current day
Calendar startCal = Calendar.getInstance();
Calendar endCal = Calendar.getInstance();
Calendar currentCal = Calendar.getInstance();
boolean debug = false;
boolean sendEmail = false;

SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
/*
SimpleDateFormat esmf = new SimpleDateFormat("'on' dd MMMM yyyy '('EEE') at 'hh:mm a", Locale.ENGLISH);
SimpleDateFormat csmf = new SimpleDateFormat("MM月dd日Eahh時mm分", Locale.CHINESE);
SimpleDateFormat scsmf = new SimpleDateFormat("MM月dd日Eahh时mm分", Locale.SIMPLIFIED_CHINESE);
SimpleDateFormat jcsmf = new SimpleDateFormat("MM月dd日Eahh時mm分", Locale.JAPAN);
*/
SimpleDateFormat esmf = new SimpleDateFormat("'on' EEE, MMM dd, yyyy' at 'h:mm a", Locale.ENGLISH);
SimpleDateFormat csmf = new SimpleDateFormat("M月dd日Eah時mm分", Locale.CHINESE);
SimpleDateFormat scsmf = new SimpleDateFormat("M月dd日Eah时mm分", Locale.SIMPLIFIED_CHINESE);
SimpleDateFormat jcsmf = new SimpleDateFormat("M月dd日Eah時mm分", Locale.JAPAN);

if (!isSmsScheduleDay(startCal)) {
return;
}

startCal = getAppointmentDay(startCal, ignoreSentDate);
endCal = getAppointmentDay(endCal, ignoreSentDate);

//***********
// resend
//startCal.set(2016, 2, 25);
//endCal.set(2016, 2, 25);
//***********

ArrayList record = getSMSList(smf, startCal, endCal, true, null);
ReportableListObject row = null;
if (record.size() > 0) {
for(int i = 0; i < record.size(); i++) {
row = (ReportableListObject)record.get(i);

if (row.getValue(20) != null && row.getValue(20).length() > 0) {
System.out.println("The sms is sent for this appointment");
EmailAlertDB.sendEmail("appointment.sms",
"Hong Kong Adventist Hospital - SMS",
"It has return message already<br/>"+
"The sms is sent for this appointment - BKGID "  + row.getValue(12));
} else {
//if (row.getValue(2).equals("-1")) {
String msgId = null;
String smcid = row.getValue(16);
String lang = row.getValue(0);
String docName = null;
String dateTime = "";
String smsContent = null;
String type = null;

if (smcid == null || smcid.length() <= 0) {
smcid = "1";//set to default - registration desk
}

if (row.getValue(14).length() <= 0) {
smcid = "1";
}

if (smcid.equals("4")) {
type = UtilSMS.SMS_ONCOLOGY;
} else if (smcid.equals("5") || smcid.equals("6") || 
smcid.equals("7") || smcid.equals("8") || smcid.equals("10")){
type = UtilSMS.SMS_REHAB;
} else if (smcid.equals("9")){
type = UtilSMS.SMS_OUTPAT;
} else {
type = UtilSMS.SMS_OUTPAT;
}

if (lang.length() <= 0) {
lang = "ENG";
}

String phoneNo =
getPhoneNo(row.getValue(4).trim(), row.getValue(18).trim(),
	row.getValue(14).trim(), row.getValue(12),
	lang, smcid, type);

if (phoneNo != null) {//send sms
//set the appointment date & time
startCal.set(Integer.parseInt(row.getValue(9)), Integer.parseInt(row.getValue(8))-1,
Integer.parseInt(row.getValue(7)), Integer.parseInt(row.getValue(10)),
Integer.parseInt(row.getValue(11)));

//set the display name of doctor
if (lang.equals("ENG") || lang.equals("JAP")) {
if (row.getValue(17).length() > 0) {
docName = row.getValue(17);
} else {
docName = row.getValue(5);
}

if(smcid.equals("9")){
if(lang.equals("JAP")){
	docName = MessageResources.getMessageJapanese("prompt.sms.fs.dietitianTitle") + docName;
} else {
	docName = docName + " " + MessageResources.getMessageEnglish("prompt.sms.fs.dietitianTitle");
}
} else if (row.getValue(19).length() > 0) {
docName = row.getValue(19).trim() + " " + docName;
}
} else if (lang.equals("TRC")) {
if (smcid.equals("9")){
if (row.getValue(6).length() > 0) {
	docName = row.getValue(6);
} else if (row.getValue(17).length() > 0) {
	docName = row.getValue(17);
} else {
	docName = row.getValue(5);
}

docName = docName + MessageResources.getMessageTraditionalChinese("prompt.sms.fs.dietitianTitle");

} else if (row.getValue(6).length() > 0) {
docName = row.getValue(6);
if (row.getValue(19).length() > 0) {
	if (row.getValue(19).trim().equals("DR.")) {
		docName = docName + MessageResources.getMessageTraditionalChinese("prompt.sms.op.doctitle");
	} else if (row.getValue(19).trim().equals("MS") || row.getValue(19).trim().equals("MISS")){
		docName = docName + MessageResources.getMessageTraditionalChinese("prompt.sms.op.ms");
	}
}
} else {
if (row.getValue(17).length() > 0) {
	docName = row.getValue(17);
} else {
	docName = row.getValue(5);
}
if (row.getValue(19).length() > 0) {
	docName = row.getValue(19).trim() + " " + docName;
}
}
} else {
if (smcid.equals("9")){
if (row.getValue(6).length() > 0) {
	docName = row.getValue(6);
} else if (row.getValue(17).length() > 0) {
	docName = row.getValue(17);
} else {
	docName = row.getValue(5);
}

docName = docName + MessageResources.getMessageSimplifiedChinese("prompt.sms.fs.dietitianTitle");

} else if (row.getValue(6).length() > 0) {
docName = ZHConverter.convert(row.getValue(6), ZHConverter.SIMPLIFIED);
if (row.getValue(19).length() > 0) {
	if (row.getValue(19).trim().equals("DR.")) {
		docName = docName + MessageResources.getMessageSimplifiedChinese("prompt.sms.op.doctitle");
	} else if (row.getValue(19).trim().equals("MS") || row.getValue(19).trim().equals("MISS")){
		docName = docName + MessageResources.getMessageSimplifiedChinese("prompt.sms.op.ms");
	}
}
} else {
if (row.getValue(17).length() > 0) {
	docName = row.getValue(17);
} else {
	docName = row.getValue(5);
}
if (row.getValue(19).length() > 0) {
	docName = row.getValue(19).trim() + " " + docName;
}
}
}

//set the date time format
if (lang.equals("ENG")) {
dateTime = esmf.format(startCal.getTime());
} else if (lang.equals("TRC")) {
dateTime = csmf.format(startCal.getTime()).replaceAll("00分", "");
} else if (lang.equals("SMC")) {
dateTime = scsmf.format(startCal.getTime()).replaceAll("00分", "");
} else if (lang.equals("JAP")) {
dateTime = jcsmf.format(startCal.getTime()).replaceAll("00分", "");
}

smsContent = getSmsContent(row.getValue(14), smcid, lang, docName.toUpperCase(), dateTime);

//targetPhone="91603748";//prevent send sms during testing

if (smsContent != null) {
if (debug){
EmailAlertDB.sendEmail(
		"sms.reg.alert",
		"Hong Kong Adventist Hospital - SMS",
		smsContent);
} else {
try {
	msgId = UtilSMS.sendSMS(null, new String[] { phoneNo },
			smsContent,
			type, row.getValue(12), lang, smcid);

	if (getSuccessOfSMS(msgId)) {
		updateSuccessTimeAndMsg(row.getValue(12), msgId);
		updateSendTime(row.getValue(12));
	}

	if (sendEmail) {
		if (row.getValue(24).length() > 0) {
			if (UtilMail.sendMail(
					"regdesk@hkah.org.hk",
					new String[] { row.getValue(24) },
					null,
					null,
					"Hong Kong Adventist Hospital - Reminder",
					smsContent, false)) {
				UtilMail.insertEmailLog(null, row.getValue(12),
					"OUTPAT", "APPTREMINDER", true, "");
			} else {
				UtilMail.insertEmailLog(null, row.getValue(12),
					"OUTPAT", "APPTREMINDER", false, "");
			}
		}
	}
} catch (IOException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
}
} else {
if (!debug) {
UtilSMS.saveLog("Cannot find any template",
		row.getValue(12), type, lang, smcid);
updateErrorMsg(row.getValue(12), "BKERR08");
}
}
}
}
}
}

EmailAlertDB.sendEmail(
"appointment.sms",
"Hong Kong Adventist Hospital - SMS",
"SMS SCHEDULE START - " + currentCal.getTime() +"<br/><br/>"+
"BOOKING DATE - " + startCal.getTime());
}

//======================================================================
private static boolean isHolidayAndDisableSMS(Calendar date) {
StringBuffer sqlStr = new StringBuffer();
SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

sqlStr.append("SELECT 1 ");
sqlStr.append("FROM EL_PUBLIC_HOLIDAY ");
sqlStr.append("WHERE EL_SITE_CODE = ? ");
sqlStr.append("AND TO_CHAR(EL_HOLIDAY, 'DD/MM/YYYY') = ? ");
sqlStr.append("AND EL_SMS_ENABLE = 0 ");

return (UtilDBWeb.isExist(sqlStr.toString(), new String[] { ConstantsServerSide.SITE_CODE, smf.format(date.getTime()) }));
}

//======================================================================
private static boolean isSentSMS(Calendar date) {
StringBuffer sqlStr = new StringBuffer();
Calendar currentCal = Calendar.getInstance();
SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
currentCal.add(Calendar.DATE, -7);

sqlStr.append("SELECT 1 FROM ( ");
sqlStr.append("SELECT BKGSDATE FROM BOOKING@IWEB B, ");
sqlStr.append("(SELECT KEY_ID FROM SMS_LOG S WHERE S.ACT_TYPE = 'OUTPAT' ");
sqlStr.append("AND S.SEND_TIME >= TO_DATE('"+smf.format(currentCal.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
//sqlStr.append("AND S.SUCCESS = 1 ");
sqlStr.append("ORDER BY S.SEND_TIME DESC) S ");
sqlStr.append("WHERE B.BKGID = S.KEY_ID ");
sqlStr.append("AND B.BKGSDATE >= TO_DATE('"+smf.format(date.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS')) ");
sqlStr.append("WHERE ROWNUM = 1 ");

return (UtilDBWeb.isExist(sqlStr.toString()));
}

//======================================================================
public static String getPhoneNo(String phoneNo, String couCode, String patNo,
String bkgId, String lang, String smcId, String type) {
if (patNo != null && patNo.length() > 0) {
if (phoneNo != null && phoneNo.length() > 0) {
if (couCode != null && couCode.length() > 0) {
if (couCode.equals("852") || couCode.equals("853")) {
if (phoneNo.length() == 8) {
//send
return couCode+phoneNo;
} else {
//error
UtilSMS.saveLog("The country code is 852/853, but the phone no. is not 8 digits",
		bkgId, type, lang, smcId);
updateErrorMsg(bkgId, "BKERR01");
return null;
}
} else if (couCode.equals("86")) {
if (phoneNo.substring(0, 1).equals("1") && phoneNo.length() == 11) {
return couCode+phoneNo;
} else {
UtilSMS.saveLog("The country code is 86, but first letter of phone no. is not ''1'' or the phone no. is not 11 digits",
	bkgId, type, lang, smcId);
updateErrorMsg(bkgId, "BKERR02");
return null;
}
} else {
UtilSMS.saveLog("The country code is not 852/853/86",
bkgId, type, lang, smcId);
updateErrorMsg(bkgId, "BKERR03");
return null;
}
} else {
UtilSMS.saveLog("Country Code is empty value",
bkgId, type, lang, smcId);
updateErrorMsg(bkgId, "BKERR04");
return null;
}
} else {
UtilSMS.saveLog("Phone No. is empty value",
bkgId, type, lang, smcId);
updateErrorMsg(bkgId, "BKERR05");
return null;
}
} else {
if (phoneNo != null && phoneNo.length() > 0) {
if (phoneNo.length() == 8) {
return phoneNo;
} else if (phoneNo.length() > 8) {
if (phoneNo.substring(0, 3).equals("861") && phoneNo.length() == 13) {
return phoneNo;
} else if (phoneNo.substring(0, 3).equals("853") && phoneNo.length() == 11) {
return phoneNo;
} else {
UtilSMS.saveLog("Phone No. is greater than 8 digits, but it does not belong to 86 or 853",
bkgId, type, lang, smcId);
updateErrorMsg(bkgId, "BKERR06");
return null;
}
} else {
UtilSMS.saveLog("Phone No. is less than 8 digits",
bkgId, type, lang, smcId);
updateErrorMsg(bkgId, "BKERR07");
return null;
}
} else {
UtilSMS.saveLog("Phone No. is empty value",
bkgId, type, lang, smcId);
updateErrorMsg(bkgId, "BKERR05");
return null;
}
}
}

//======================================================================
private static String getSmsContent(String patNo, String smcid, String lang,
		String docName, String dateTime) {
if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8") || smcid.equals("10")) {
if ((patNo == null) || patNo.length() <= 0) {
return null;
} else {
return getRehabTemplate( lang, docName, dateTime, smcid);
}
} else if (smcid.equals("9")) {
if ((patNo == null) || patNo.length() <= 0) {
return null;
} else {
return getFSTemplate( lang, docName, dateTime);
}
}

if ((patNo == null) || patNo.length() <= 0) {
return getnewPatientTemplate(docName, dateTime);
} else if (smcid.equals("1")) {
return getRegDeskTemplate((patNo == null), lang, docName, dateTime);
} else if (smcid.equals("2")) {
return getHCTemplate((patNo == null), lang, docName, dateTime);
} else if (smcid.equals("3")) {
return getHATemplate((patNo == null), lang, docName, dateTime);
} else if (smcid.equals("4")) {
return getOncologyTemplate((patNo == null), lang, docName, dateTime);
} else {
return null;
}
}

//======================================================================
private static String getRehabTemplate( String lang, String docName, String dateTime, String smcid) {
StringBuffer smsContent = new StringBuffer();
String link = "https://mail.hkah.org.hk/online/documentManage/download.jsp?documentID=";
if(smcid.equals("5")){
link = link + "623";
} else if(smcid.equals("6")){
link = link + "624";
} else if(smcid.equals("7")){
link = link + "625";
} else if(smcid.equals("8")){
link = link + "626";
}

if (lang.equals("ENG")) {
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.rehab.block1"));
smsContent.append(" " + dateTime + ".");
if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8")) {
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.rehab.block2a"));
smsContent.append(" " + link + " ");
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.rehab.block2b"));
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.rehab.block3a"));
}
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.rehab.block3b"));
} else if (lang.equals("TRC")) {
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.rehab.block1"));
smsContent.append(" " + dateTime + "。");
if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8")) {
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.rehab.block2"));
smsContent.append(" " + link + "。");
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.rehab.block3a"));
}
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.rehab.block3b"));
} else if (lang.equals("SMC")) {
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.rehab.block1"));
smsContent.append(" " + dateTime + "。");
if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8")) {
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.rehab.block2"));
smsContent.append(" " + link + "。");
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.rehab.block3a"));
}
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.rehab.block3b"));
} else if (lang.equals("JAP")) {
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.rehab.block1"));
smsContent.append(" " + dateTime + ".");
if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8")) {
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.rehab.block2a"));
smsContent.append(" " + link + " ");
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.rehab.block2b"));
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.rehab.block3a"));
}
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.rehab.block3b"));
}
return smsContent.toString();
}

//======================================================================
private static String getFSTemplate( String lang, String docName, String dateTime) {
StringBuffer smsContent = new StringBuffer();

if (lang.equals("ENG")) {
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fs.block1"));
smsContent.append(" " + docName + " ");
smsContent.append("" + dateTime + ". ");
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fs.block2"));
} else if (lang.equals("TRC")) {
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fs.block1"));
smsContent.append("" + docName + ", ");
smsContent.append("" + dateTime + ". ");
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fs.block2"));
} else if (lang.equals("SMC")) {
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.fs.block1"));
smsContent.append("" + docName + ", ");
smsContent.append("" + dateTime + ". ");
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.fs.block2"));
} else if (lang.equals("JAP")) {
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.fs.block1"));
smsContent.append("" + docName + "、");
smsContent.append("" + dateTime + ". ");
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.fs.block2"));
}
return smsContent.toString();
}

//======================================================================
private static String getnewPatientTemplate(String docName, String dateTime) {
StringBuffer smsContent = new StringBuffer();

smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.newpatient.block1"));
smsContent.append(" ");
smsContent.append(docName);
smsContent.append(" ");
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.newpatient.block2"));

return smsContent.toString();
}

//======================================================================
private static String getOncologyTemplate(boolean newPatient, String lang,
				String docName, String dateTime) {
StringBuffer smsContent = new StringBuffer();

if (lang.equals("ENG")) {
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.oncology.block1"));
smsContent.append(" ");
smsContent.append(docName);
smsContent.append(" ");
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.oncology.block2"));
} else if (lang.equals("TRC")) {
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.oncology.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.oncology.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.oncology.block3"));
} else if (lang.equals("SMC")) {
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.oncology.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.oncology.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.oncology.block3"));
} else if (lang.equals("JAP")) {
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.oncology.block1"));
smsContent.append(dateTime);
smsContent.append(" ");
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.oncology.block2"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.oncology.block3"));
}

return smsContent.toString();
}

//======================================================================
private static String getHATemplate(boolean newPatient, String lang, String docName,
		String dateTime) {
StringBuffer smsContent = new StringBuffer();

if (lang.equals("ENG")) {
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.ha.block1"));
smsContent.append(" ");
smsContent.append(docName);
smsContent.append(" ");
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.ha.block2"));
} else if (lang.equals("TRC")) {
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.ha.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.ha.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.ha.block3"));
} else if (lang.equals("SMC")) {
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.ha.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.ha.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.ha.block3"));
} else if (lang.equals("JAP")) {
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.ha.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.ha.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.ha.block3"));
}

return smsContent.toString();
}

//======================================================================
private static String getHCTemplate(boolean newPatient, String lang, String docName,
		String dateTime) {
StringBuffer smsContent = new StringBuffer();

if (lang.equals("ENG")) {
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.hc.block1"));
smsContent.append(" ");
smsContent.append(docName);
smsContent.append(" ");
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.hc.block2"));
} else if (lang.equals("TRC")) {
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.hc.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.hc.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.hc.block3"));
} else if (lang.equals("SMC")) {
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.hc.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.hc.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.hc.block3"));
} else if (lang.equals("JAP")) {
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.hc.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.hc.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.hc.block3"));
}

return smsContent.toString();
}

private static String getRegDeskTemplate(boolean newPatient, String lang,
			String docName, String dateTime) {
StringBuffer smsContent = new StringBuffer();

if (lang.equals("ENG")) {
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.reg.block1"));
smsContent.append(" ");
smsContent.append(docName);
smsContent.append(" ");
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.reg.block2"));
} else if (lang.equals("TRC")) {
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block3"));
} else if (lang.equals("SMC")) {
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block3"));
} else if (lang.equals("JAP")) {
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block1"));
smsContent.append(docName);
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block2"));
smsContent.append(dateTime);
smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block3"));
}

return smsContent.toString();
}

//======================================================================
private static boolean updateSendTime(String id) {
StringBuffer sqlStr = new StringBuffer();

sqlStr.append("UPDATE BOOKING@IWEB ");
sqlStr.append("SET SMSSDT = SYSDATE ");
sqlStr.append("WHERE BKGID = '"+id+"' ");

//System.out.println("--------------Notify Patient Appointment (updateSendTime)--------------");
//System.out.println(sqlStr.toString());
//System.out.println("-----------------------------------------------------------------------");

return UtilDBWeb.updateQueue(sqlStr.toString());
}

//======================================================================
private static boolean getSuccessOfSMS(String msgId) {
StringBuffer sql_getSuccessStats = new StringBuffer();

sql_getSuccessStats.append("SELECT SUCCESS ");
sql_getSuccessStats.append("FROM SMS_LOG ");
sql_getSuccessStats.append("WHERE MSG_BATCH_ID = '"+msgId+"' ");

ArrayList record = UtilDBWeb.getReportableList(sql_getSuccessStats.toString());
ReportableListObject row = null;

if (record.size() > 0) {
row = (ReportableListObject)record.get(0);

return row.getValue(0).equals("1");
} else {
return false;
}
}

//======================================================================
private static boolean updateErrorMsg(String id, String msg) {
StringBuffer sqlStr = new StringBuffer();

sqlStr.append("UPDATE BOOKING@IWEB ");
sqlStr.append("SET SMSRTNMSG = '"+msg+"' ");
sqlStr.append("WHERE BKGID = '"+id+"' ");

//System.out.println("--------------Notify Patient Appointment (updateErrorMsg)--------------");
//System.out.println(sqlStr.toString());
//System.out.println("-----------------------------------------------------------------------");

return UtilDBWeb.updateQueue(sqlStr.toString());
}

//======================================================================
private static boolean updateSuccessTimeAndMsg(String id, String msgId) {
StringBuffer sqlStr = new StringBuffer();

sqlStr.append("UPDATE BOOKING@IWEB ");
sqlStr.append("SET SMSSDTOK = (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = '"+msgId+"'), ");
sqlStr.append("SMSRTNMSG = (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = '"+msgId+"') ");
sqlStr.append("WHERE BKGID = '"+id+"' ");

//System.out.println("--------------Notify Patient Appointment (updateSuccessTimeAndMsg)--------------");
//System.out.println(sqlStr.toString());
//System.out.println("-----------------------------------------------------------------------");

return UtilDBWeb.updateQueue(sqlStr.toString());
}




%>

<%
UserBean userBean = new UserBean(request);
if(!userBean.isAdmin()) {
	return;
}

System.out.println("re sendSmS appointment");
//sendSMS(false);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>

</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>testSendMail</title>
</head>
<body>
	<h1>re sendsms</h1>
</body>
</html>
