<%@ page import="java.io.IOException"%>
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
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
			
<%!	
	private ArrayList getName() {
		return UtilDBWeb.getReportableListHATS("SELECT NAME FROM AA_QUERY ORDER BY STATEMENT_NO");
	}

	private String getStatement(String name) {
		ArrayList record = UtilDBWeb.getReportableListHATS("SELECT STATEMENT FROM AA_QUERY WHERE NAME = ?", new String[] { name });
		if (record.size() == 1) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}

	private ArrayList runStatement(String statement) {
		return UtilDBWeb.getReportableListHATS(statement);
	}
		
%>
<%!
private static boolean insertSMSRecord(String keyID, String patNo,
		String mobilePhone,String revCode,String mothCode,String expDate,String patName) {
	String expDateStr = null;	
	System.err.println("[expDate]:"+expDate+";");	
	if(expDate==null){
		expDateStr = null;
	}else{
		expDateStr = "to_date('"+ expDate + "','dd/mm/yyyy')";
	}
	
	String sqlStr = "INSERT INTO PE_SMS (SMS_ID, PATNO, PATNAME, PATMTEL, MOTHCODE, REVCODE,EXPIRY_DATE, CREATE_DATE) " +
	"VALUES ('" + keyID + "' , '" + patNo + "' , '" + patName  + "' , '" + mobilePhone  + "' , '" + mothCode + "' , '" + revCode + "' , " 
	+ expDateStr+" , SYSDATE)";
	System.err.println("[sqlStr]:"+sqlStr);
	return UtilDBWeb.updateQueue(
			sqlStr);			 
}

private static String getHATemplate(String type, String lang, String dateStr) {
	StringBuffer smsContent = new StringBuffer();	
//	if("HA".equals(type)){
	System.err.println("[lang]:"+lang);
		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.ipdis.block1"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.ipdis.block1"));			
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.ipdis.block1"));	
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.ipdis.block1"));			
		}				
//	}
	
	return smsContent.toString();
}	
%>
<%
System.out.println("[1]");
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String mobile = ParserUtil.getParameter(request, "mobile");
String couCode = ParserUtil.getParameter(request, "couCode");
String lang = ParserUtil.getParameter(request, "lang");
String patNo = ParserUtil.getParameter(request, "patNo");
//String patNo1 = TextUtil.parseStrUTF8((String) request.getAttribute("patNo"));
String slpNo = ParserUtil.getParameter(request, "slpNo");
String expDate = ParserUtil.getParameter(request, "expDate");
String patName = ParserUtil.getParameter(request, "patName");
String staffID = ParserUtil.getParameter(request, "staffID");
String SMS_LINK = "http://smsc.xgate.com.hk/smshub/sendsms?";
String SMS_SENDER_ID = "Adventist H";
String SMS_MSG_TYPE = "TEXT";
String SMS_MSG_LANG = "UTF8";
String mobCouCode = null;
boolean sendAction = false;
boolean viewAction = false;

String content = "";
boolean success = true;
if("view".equals(command)){
	viewAction = true;
}else if("send".equals(command)){
	sendAction = true;	
}
System.out.println("[command]:"+command+";[patNo]:"+patNo+";[mobile]"+mobile+";[slpNo]:"+slpNo+";[staffID]:"+staffID);

ArrayList record2 = PatientDB.getPatInfo(patNo);
int noOfPat = record2.size();

if(noOfPat>0){
	ReportableListObject row2 = (ReportableListObject) record2.get(0);
	mobile = row2.getValue(6);
	lang = row2.getValue(20);
	mobCouCode = row2.getValue(23);
	
	if(mobCouCode != null && !mobCouCode.isEmpty()){
		couCode = mobCouCode;
	} else if(couCode == null || couCode.isEmpty()){
		couCode = row2.getValue(21);		
	}

	if (lang.length() <= 0) {
		lang = "ENG";
	}
}
System.out.println("2[command]:"+command+";[patNo]:"+patNo+";[mobile]"+mobile+";[slpNo]:"+slpNo+";[staffID]:"+staffID+";[couCode]:"+couCode);
if(sendAction){
	if (mobile != null && mobile.length()>0) {
	//	String lang = "";
	//	ReportableListObject row = (ReportableListObject)record.get(0);
	
	//	lang = row.getValue(0);
	
//		if (lang.length() <= 0) {
//			lang = "ENG";
//		}
	
		//lang = "JAP";//for testing only
	
System.out.println("3[command]:"+command+";[patNo]:"+patNo+";[mobile]"+mobile+";[slpNo]:"+slpNo+";[staffID]:"+staffID);
		String phoneNo = UtilSMS.getPhoneNo2(mobile, couCode,
					patNo.trim(), patNo.trim() + "/"+slpNo.trim(), lang, "INPATDISCH", UtilSMS.SMS_INPAT_DISCH);
	
System.out.println("[patNo]:"+patNo+";[phoneNo]:"+phoneNo+";[mobile]"+mobile+";[slpNo]:"+slpNo+";[staffID]:"+staffID);
		if (phoneNo == null) {
			insertSMSRecord(patNo + "/"+slpNo, patNo, mobile, slpNo, lang, expDate, patName);
			success = false;
		} else {
//			content =  getHATemplate(UtilSMS.SMS_TWMKT, lang, null);
			content =  getHATemplate("INPATDISCH", lang, null);			

			if (content != null) {
/*				
				boolean sendMailSuccess = false;
				String[] emailListToArray = null;
				String[] mailToCcArray = new String[1];				
				Vector emailTo = new Vector();
				emailTo.add("terence.ho@hkah.org.hk");
				emailListToArray = (String[]) emailTo.toArray(new String[emailTo.size()]);
				mailToCcArray[0] = "terence.ho@hkah.org.hk";

				// Send mail
				sendMailSuccess = UtilMail.sendMail(
						ConstantsServerSide.MAIL_ALERT,
						emailListToArray,
						mailToCcArray,
						new String[] { "terence.ho@hkah.org.hk" },
						"Hong Kong Adventist Hospital - Patient Get Patient SMS1",
						"SMS: <br/>patno: "+patNo+" PHONENO: "+phoneNo+
						"<br/><br/>"+content,false);				
*/
				String keyID = patNo + "/"+slpNo;
					
//				if (content != null) {
					try {						
						String msgId = UtilSMS.sendSMS(staffID, new String[] { phoneNo },
								content,
								UtilSMS.SMS_INPAT_DISCH,  patNo + "/"+slpNo , lang, "");
						
						System.err.println("[msgId]:"+msgId);
						
						insertSMSRecord(keyID, patNo, phoneNo, 
								slpNo, lang,expDate,patName);						
						
					} catch (IOException e) {								
						// TODO Auto-generated catch block
						e.printStackTrace();
					}					
//				}
			} else {
				//error
				insertSMSRecord(patNo + "/"+slpNo, patNo, "", 
								slpNo, lang,expDate,patName);	
				
				UtilSMS.saveLog("Cannot retrieve any template",
						patNo + "/"+slpNo, UtilSMS.SMS_HA, "", "INPATDISCH");
				success = false;
			}
		}
	} else {
		System.err.println("2[mobile]:"+mobile);		
		//Fail
		UtilSMS.saveLog("Cannot find any record with this slpNo",
				"INPATDISCH"+slpNo, UtilSMS.SMS_HA, "", "INPATDISCH");
		success = false;
%>

<%		if(!success){ System.err.println("3[mobile]:"+mobile);%>
		<script language="javascript">
			alert('Patient['+<%=patNo%>+'], No moblie number.');
		</script>			
<%		}		
	}
	System.err.println("[sendAction]:"+sendAction+";[viewAction]:"+viewAction);	
	sendAction = false;
	viewAction = true;		
}

%>
<%
ArrayList record = null;
ReportableListObject row = null;
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
		Licensed to the Apache Software Foundation (ASF) under one or more
		contributor license agreements.  See the NOTICE file distributed with
		this work for additional information regarding copyright ownership.
		The ASF licenses this file to You under the Apache License, Version 2.0
		(the "License"); you may not use this file except in compliance with
		the License.  You may obtain a copy of the License at

				 http://www.apache.org/licenses/LICENSE-2.0

		Unless required by applicable law or agreed to in writing, software
		distributed under the License is distributed on an "AS IS" BASIS,
		WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
		See the License for the specific language governing permissions and
		limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>
<jsp:include page="../common/page_title.jsp">
	<jsp:param name="pageTitle" value="Send History" />
	<jsp:param name="isAccessControl" value="N" />
	<jsp:param name="mustLogin" value="N" />
</jsp:include>
<form name="form1" action="sendHATSSms.jsp" method="post">
<%
	String statement = null;
	int size = 0;
	if (slpNo != null && (viewAction||sendAction)) {
//			record = UtilSMS.getLog(slpNo,"INPATDISCH");
			record = UtilSMS.getLog(patNo + "/"+slpNo,"INPATDISCH");
			System.out.println("[record.size()]:"+record.size());			
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				size = row.getSize();
				request.setAttribute("aa_query", record);
%>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="Data" /></bean:define>
<display:table id="row2" name="requestScope.aa_query" export="false" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row2_rowNum")%>)</display:column>
		<display:column title="Staff ID"><div>${requestScope.aa_query[row2_rowNum - 1].fields0}</div></display:column>	
		<display:column title="Send Date"><div>${requestScope.aa_query[row2_rowNum - 1].fields1}</div></display:column>
		<display:column title="Success"><div>${requestScope.aa_query[row2_rowNum - 1].fields2}</div></display:column>		
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%
			}
	}
%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return sendAction('<%=slpNo==null?"":slpNo %>','<%=patNo==null?"":patNo %>','<%=staffID==null?"":staffID %>');"><bean:message key="button.send" /></button>
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="slpNo" />
<input type="hidden" name="patNo" "/>
<input type="hidden" name="staffID" "/>
</form>
<script language="javascript">
	function sendAction(slpNo,patNo,staffID) {
		if(chkPatSMSStatus(patNo)){
			var r=confirm("Confirm to send SMS?");
			if (r==true){
				document.form1.command.value = 'send';
				document.form1.slpNo.value = slpNo;
				document.form1.patNo.value = patNo;
				document.form1.staffID.value = staffID;		
				document.form1.submit();		
				return false;	
			 }else{
				 return false;	
			 }			
		}else{
			return false;
		}
		 return false;	
	}
	
	function chkPatSMSStatus(patNo){
		var rtnVal = false;
			
		$.ajax({
			type: "POST",
			url: "../registration/registration_hidden.jsp",
			data: 'p1=2&p2=' + patNo,
			async: false,
			success: function(values){
			if(values != '') {
				if(values.substring(0, 2) == '-1') {
					rtnVal = true;
					return false;																													
				}else if (values.substring(0, 1) == '0'){
					alert('Patient request NO SMS.');					
					rtnVal = false;						
					return false;
				}										
			}else{alert('null value');}//if
				rtnVal = false;						
				return false;				
			}//success
		});//$.ajax
	
		return rtnVal;	
	}
	
	function closeAction() {
		window.close();
	}
</script>
</div>
</div>
</div>
<br/><p/><br/><p/><br/>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>