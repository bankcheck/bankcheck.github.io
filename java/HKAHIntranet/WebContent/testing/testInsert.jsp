<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@	page import="java.text.*"%>
<%@ page import="com.hkah.config.MessageResources" %>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.constant.ConstantsServerSide" %>
<%@ page import="com.spreada.utils.chinese.ZHConverter" %>
<%@ page import="com.hkah.util.sms.UtilSMS" %>
<%@ page import="java.io.IOException" %>
<%!
private static String getResponeData(String respone, String key) {
	if(respone.indexOf("</"+key+">") > -1) {
		return respone.substring(respone.indexOf("<"+key+">")+("<"+key+">").length(), 
				respone.indexOf("</"+key+">")).replaceAll("'", "''");
	}
	else {
		return "";
	}
}	
private static boolean saveLog(String smsID, String respone, UserBean userbean,
		String type, String keyId, String tempLang, String smcId) {
StringBuffer sqlStr = new StringBuffer();

sqlStr.append("INSERT INTO SMS_LOG(");
sqlStr.append("MSG_BATCH_ID, MSG_LANG, NO_OF_MSG, NO_OF_SUCCESS, ");
sqlStr.append("REV_AREA_CODE, REV_MOBILE, REV_OPERATOR, RES_CODE, ");
sqlStr.append("RES_MSG, SUCCESS, SEND_TIME, SENDER, SMS_AC, ACT_TYPE, KEY_ID ");
if(tempLang != null) {
sqlStr.append(", TEMPLATE_LANG");
}
if(smcId != null) {
sqlStr.append(", SMCID");
}
sqlStr.append(", MSGID");
sqlStr.append(") ");
sqlStr.append("VALUES (");
sqlStr.append("'"+getResponeData(respone, "MessageBatchID")+"', ");
sqlStr.append("'"+getResponeData(respone, "MessageLanguage")+"', ");
sqlStr.append("'"+getResponeData(respone, "NumberOfMessage")+"', ");
sqlStr.append("'"+getResponeData(respone, "NumberOfSuccess")+"', ");
sqlStr.append("'"+getResponeData(respone, "AreaCode")+"', ");
sqlStr.append("'"+getResponeData(respone, "MobileNumber")+"', ");
sqlStr.append("'"+getResponeData(respone, "OperatorID")+"', ");
sqlStr.append("'"+getResponeData(respone, "ResponseCode")+"', ");
sqlStr.append("'"+getResponeData(respone, "ResponseMessage")+"', ");
sqlStr.append("'"+(getResponeData(respone, "Success").equals("true")?"1":"0")+"', ");
//send time
sqlStr.append("SYSDATE, ");
//sender
sqlStr.append("'"+((userbean==null)?"SYSTEM":userbean.getLoginID())+"', ");
sqlStr.append("'"+smsID+"', ");
sqlStr.append("'"+type+"', ");
sqlStr.append("'"+keyId+"' ");
if(tempLang != null) {
sqlStr.append(",'"+tempLang+"' ");
}
if(smcId != null) {
sqlStr.append(",'"+smcId+"' ");
}
sqlStr.append(",'"+getResponeData(respone, "MessageID")+"' ");
sqlStr.append(") ");

System.out.println(sqlStr.toString());

return true;
}
%>
<%
UserBean userBean = new UserBean(request);
%>
<%=saveLog("123", "<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE XGATE_Response><ShortMessageResponse><Success>true</Success><ResponseCode>A000</ResponseCode><ResponseMessage>OK</ResponseMessage><MessageBatchID>12779105</MessageBatchID><SessionID>null</SessionID><NumberOfMessage>1</NumberOfMessage><NumberOfSuccess>1</NumberOfSuccess><NumberOfFailure> 0</NumberOfFailure><ReceiverList><Receiver><MessageID>2611</MessageID><MessageType>TEXT</MessageType><MessageLanguage>ENG</MessageLanguage><MessageScheduleTime> 000000000000</MessageScheduleTime><TimeToLive>-1</TimeToLive><AreaCode>852</AreaCode><DestinationCountry>Hong Kong</DestinationCountry><MobileNumber>98162991</MobileNumber><OperatorID>ORANGE-3G</OperatorID><MessageBody>Not available</MessageBody><ACK>1</ACK><PartNo>1</PartNo><Status>Sent to SMS Centre</Status></Receiver></ReceiverList></ShortMessageResponse>",
			userBean, "OUTPAT", "123", null, null)%>