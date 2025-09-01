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

private static boolean isSentSMS(Calendar date) {
	StringBuffer sqlStr = new StringBuffer();
	Calendar currentCal = Calendar.getInstance();
	SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
	currentCal.add(Calendar.DATE, -7);
	
	sqlStr.append("SELECT 1 FROM ( ");
	sqlStr.append("SELECT BKGSDATE FROM BOOKING@IWEB B, ");
	sqlStr.append("(SELECT KEY_ID FROM SMS_LOG S WHERE S.ACT_TYPE = 'OUTPAT' ");
	sqlStr.append("AND S.SEND_TIME >= TO_DATE('"+smf.format(currentCal.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') "); 
	sqlStr.append("ORDER BY S.SEND_TIME DESC) S ");
	sqlStr.append("WHERE B.BKGID = S.KEY_ID ");
	sqlStr.append("AND B.BKGSDATE >= TO_DATE('"+smf.format(date.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS')) ");
	sqlStr.append("WHERE ROWNUM = 1 ");
	
	System.out.println(sqlStr.toString());
	
	return (UtilDBWeb.isExist(sqlStr.toString()));
}
%>
<%
Calendar startCal = Calendar.getInstance();
Calendar endCal = Calendar.getInstance();
Calendar currentCal = Calendar.getInstance();
boolean debug = false;
boolean ignoreSentDate = false;

SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
SimpleDateFormat esmf = new SimpleDateFormat("'on' dd MMMM yyyy '('EEE') at 'hh:mm a", Locale.ENGLISH);
SimpleDateFormat csmf = new SimpleDateFormat("MM月dd日Eahh時mm分", Locale.CHINESE);
SimpleDateFormat scsmf = new SimpleDateFormat("MM月dd日Eahh时mm分", Locale.SIMPLIFIED_CHINESE);
SimpleDateFormat jcsmf = new SimpleDateFormat("MM月dd日Eahh時mm分", Locale.JAPAN);

if(startCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || 
			isHolidayAndDisableSMS(startCal)) {
	return;
}
else if(startCal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY || 
			startCal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY) {
	startCal.add(Calendar.DATE, 3);
	endCal.add(Calendar.DATE, 3);
}else {
	startCal.add(Calendar.DATE, 2);
	endCal.add(Calendar.DATE, 2);
}

while(isHolidayAndDisableSMS(startCal) || (!ignoreSentDate && isSentSMS(startCal))) {
	startCal.add(Calendar.DATE, 1);
	endCal.add(Calendar.DATE, 1);
}

System.out.println(smf.format(startCal.getTime()));
%>

<%=smf.format(startCal.getTime())%>
<%/*the booking list
sqlStr.append("SELECT P.MOTHCODE, B.BKGPNAME, P.PATSMS, B.SMCID, BKGMTEL, ");
		sqlStr.append("D.DOCFNAME || ' ' || D.DOCGNAME, D.DOCCNAME, ");
		sqlStr.append("TO_CHAR(B.BKGSDATE, 'DD'), TO_CHAR(B.BKGSDATE, 'MM'), ");
		sqlStr.append("TO_CHAR(B.BKGSDATE, 'YYYY'), TO_CHAR(B.BKGSDATE, 'HH24'), ");
		sqlStr.append("TO_CHAR(B.BKGSDATE, 'MI'), B.BKGID, B.SMSSDTOK, ");
		sqlStr.append("P.PATNO, P.PATPAGER, B.SMCID, CD.CO_DISPLAYNAME, P.COUCODE, D.TITTLE, B.SMSRTNMSG ");

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
		sqlStr.append("AND   (P.PATSMS = '-1' OR P.PATNO IS NULL) ");//receive sms
		//AND	  (P.PATSMS = '0') not receive sms
		sqlStr.append("AND   D.DOCCODE <> 'OPDN' ");
		sqlStr.append("AND   D.DOCCODE <> 'N020' ");
		sqlStr.append("AND   D.DOCCODE <> 'N024' ");
		sqlStr.append("AND   B.SMSSDT IS NULL ");
*/
 %>