<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>


<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String patNo = (String) request.getParameter("patNo");
String preBookID = (String) request.getParameter("preBookID");

String patName = null;
String patcName = null;
String patTitelDesc = null;
String patSex = null;
String admDate = null;
String pathTel = null;
String patoTel = null;
String patPager = null;
String docName = null;
String docRmk = null;
String patage = null;
String docUpdateDate = null;
String patInHouse = null;
String acm = null;
String ward = null;
String bed  = null;
String bkStatus = null;
String patEmail = null;
String language = null;
String pboRmk = null;
String patRmk = null;
String clRmk = null;
String ckRmk = null;
//String reached = null;
String flwUpDate = null;
String payMth = null;
String lastModify = null;
String sendMethod = null;
String insuranceRmk = null;
String preferClass = null;
String flwUpSts = null;
String otherRmk = null;
String patSms = null;
String coucode = null;
String arcode = null;
String copaytype = null;
String aredate = null;
String arcamt = null;
String lastAdmDate = null;
String lastAdmPayMth = null;
String surTime = null;
String bpbContactNo = null;
String smsAdmDate = null;
String patIdNo= null;
String ot_prod = null;
String otPso = null;
String lastAdmType = null;

String uptDate = null;
String uptUser = userBean.getUserName();

boolean createAction = false;
boolean updateAction = false;
boolean closeAction = false;
boolean updateEmailAction = false;
boolean deleteAction = false;
boolean updatePagerAction = false;

String message = "";
String errorMessage = "";

ArrayList coucodes = null;

if ("create".equals(command)) {
	patEmail = request.getParameter("patEmail");
	patPager = request.getParameter("patTel");
	//reached = request.getParameter("reached");
	payMth = request.getParameter("payMth");
	flwUpSts = request.getParameter("flwUpSts");
	flwUpDate = request.getParameter("flwUpDate");
	uptDate = request.getParameter("uptDate");
	insuranceRmk = request.getParameter("insuranceRmk");
	preferClass = request.getParameter("preferClass");
	patRmk = request.getParameter("patRmk");
	pboRmk = request.getParameter("pboRmk");
	clRmk = request.getParameter("clRmk");
	ckRmk = request.getParameter("ckRmk");
	bkStatus = request.getParameter("bkStatus");
	patSms = request.getParameter("patSms");
	otPso = request.getParameter("otPso");
	
	otherRmk = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "otherRmk"));
	createAction = true;
}
else if ("update".equals(command)) {
	patEmail = request.getParameter("patEmail");
	patPager = request.getParameter("patTel");
	//reached = request.getParameter("reached");
	payMth = request.getParameter("payMth");
	flwUpSts = request.getParameter("flwUpSts");
	flwUpDate = request.getParameter("flwUpDate");
	uptDate = request.getParameter("uptDate");
	insuranceRmk = request.getParameter("insuranceRmk");
	preferClass = request.getParameter("preferClass");
	patRmk = request.getParameter("patRmk");
	pboRmk = request.getParameter("pboRmk");
	clRmk = request.getParameter("clRmk");
	ckRmk = request.getParameter("ckRmk");
	bkStatus = request.getParameter("bkS tatus");
	patSms = request.getParameter("patSms");
	otPso = request.getParameter("otPso");
	
	otherRmk = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "otherRmk"));
	updateAction = true;
}
else if ("updateEmail".equals(command)) {
	patEmail = request.getParameter("patEmail");
	patPager = request.getParameter("patTel");
	//reached = request.getParameter("reached");
	payMth = request.getParameter("payMth");
	flwUpSts = request.getParameter("flwUpSts");
	flwUpDate = request.getParameter("flwUpDate");
	uptDate = request.getParameter("uptDate");
	insuranceRmk = request.getParameter("insuranceRmk");
	preferClass = request.getParameter("preferClass");
	patRmk = request.getParameter("patRmk");
	pboRmk = request.getParameter("pboRmk");
	clRmk = request.getParameter("clRmk");
	ckRmk = request.getParameter("ckRmk");
	bkStatus = request.getParameter("bkS tatus");
	patSms = request.getParameter("patSms");
	otPso = request.getParameter("otPso");
	
	otherRmk = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "otherRmk"));
	updateEmailAction = true;
}
else if("delete".equals(command)) {
	patEmail = request.getParameter("patEmail");
	patPager = request.getParameter("patTel");
	//reached = request.getParameter("reached");
	payMth = request.getParameter("payMth");
	flwUpSts = request.getParameter("flwUpSts");
	flwUpDate = request.getParameter("flwUpDate");
	uptDate = request.getParameter("uptDate");
	insuranceRmk = request.getParameter("insuranceRmk");
	preferClass = request.getParameter("preferClass");
	patRmk = request.getParameter("patRmk");
	pboRmk = request.getParameter("pboRmk");
	clRmk = request.getParameter("clRmk");
	ckRmk = request.getParameter("ckRmk");
	bkStatus = request.getParameter("bkS tatus");
	patSms = request.getParameter("patSms");
	otPso = request.getParameter("otPso");
	
	otherRmk = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "otherRmk"));
	deleteAction = true;
}
else if ("updatePager".equals(command)) {
	patEmail = request.getParameter("patEmail");
	patPager = request.getParameter("patTel");
	//reached = request.getParameter("reached");
	payMth = request.getParameter("payMth");
	flwUpSts = request.getParameter("flwUpSts");
	flwUpDate = request.getParameter("flwUpDate");
	uptDate = request.getParameter("uptDate");
	insuranceRmk = request.getParameter("insuranceRmk");
	preferClass = request.getParameter("preferClass");
	patRmk = request.getParameter("patRmk");
	pboRmk = request.getParameter("pboRmk");
	clRmk = request.getParameter("clRmk");
	ckRmk = request.getParameter("ckRmk");
	bkStatus = request.getParameter("bkS tatus");
	patSms = request.getParameter("patSms");
	otPso = request.getParameter("otPso");
	
	otherRmk = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "otherRmk"));
	updatePagerAction = true;
}
try {
	if (createAction) {
		if (InPatientPreBookDB.add(userBean, patNo, preBookID, bkStatus, pboRmk, patRmk, clRmk, ckRmk,
				preferClass, payMth, insuranceRmk, flwUpDate, flwUpSts , otherRmk, otPso)) {
			message = "history added.";
			createAction = false;
		} else {
			errorMessage = "history added fail.";
		}
	}
	else if (updateAction) {
		if (InPatientPreBookDB.update(userBean, patNo, preBookID, bkStatus, pboRmk, patRmk, clRmk, ckRmk,
				preferClass, payMth, insuranceRmk, flwUpDate, flwUpSts, uptUser, uptDate, otherRmk, otPso)) {
			message = "history updated.";
			updateAction = false;
		} else {
			errorMessage = "history update fail.";
		}
	}
	else if (updateEmailAction) {
		if(InPatientPreBookDB.updatePatientEmail(patNo, patEmail)) {
			message = "email updated.";
			updateEmailAction = false;
		}
		else {
			errorMessage = "email update fail.";
		}
	}
	else if(deleteAction) {
		String delTime = request.getParameter("delRecord");
		if(InPatientPreBookDB.delete(userBean, preBookID, delTime)) {
			message = "record deleted.";
			deleteAction = false;
		}
		else {
			errorMessage = "record delete fail.";
		}
	}
	else if(updatePagerAction) {
		if(InPatientPreBookDB.updatePatientPager(patNo, preBookID, patPager)) {
			message = "mobile phone updated.";
			updatePagerAction = false;
		}
		else {
			errorMessage = "mobile phone update fail.";
		}
	}
	else {
		errorMessage = "";
	}
	
	if (preBookID != null && preBookID.length() > 0) {	
		System.out.println(new Date() + " DEBUG: HKAHIntranet bookinginfo.jsp(233) patNo="+patNo+", preBookID="+preBookID+", ");
		ArrayList record = InPatientPreBookDB.getPatDtl(patNo, preBookID);
		ReportableListObject row = (ReportableListObject) record.get(0);
		
		patNo = row.getValue(0);
		patSex = row.getValue(1);
		patInHouse = row.getValue(2);
		patName = row.getValue(3);
		patcName = row.getValue(4);
		patage = row.getValue(5);
		patPager = row.getValue(6);//"97535320";//96217608
		pathTel = row.getValue(7);
		patEmail = row.getValue(8);//sandra.chow@hkah.org.hk//"andrew.lau@hkah.org.hk";
		docName = row.getValue(9);
		admDate = row.getValue(10);
		docUpdateDate = row.getValue(11);
		patoTel = row.getValue(12);
		language = row.getValue(14);
		acm = row.getValue(15);
		ward = row.getValue(16);
		bed = row.getValue(17);
		patRmk = row.getValue(18);
		pboRmk = row.getValue(19);
		clRmk = row.getValue(20);
		patSms = row.getValue(21);
		coucode = row.getValue(22);
		arcode = row.getValue(23);
		copaytype = row.getValue(24);
		aredate = row.getValue(25);
		arcamt = row.getValue(26);
		surTime = row.getValue(27);
		bpbContactNo = row.getValue(28);
		smsAdmDate = row.getValue(10);
		patIdNo = row.getValue(30);
		ot_prod = row.getValue(48);
		
		record = InPatientPreBookDB.getBkStatusAndPreClassAndPreMth(patNo, preBookID);
		if(record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			preferClass = row.getValue(0);
			bkStatus = row.getValue(1);
			payMth = row.getValue(2);
			uptDate = row.getValue(4);
			otPso = row.getValue(5);
		}
		
		record = InPatientPreBookDB.getLastAdmDate(patNo);
		if(record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			lastAdmDate = row.getValue(0);
			lastAdmType = row.getValue(1);
		}
		
		lastAdmPayMth = InPatientPreBookDB.getLastPayMth(patNo);
		coucodes = InPatientPreBookDB.getCountryCode();
	}
} catch (Exception e) {
	e.printStackTrace();
}

request.setAttribute("histList", InPatientPreBookDB.histList(patNo,preBookID));
request.setAttribute("smsHistList", SMSLogDB.getInpatSMSLog(preBookID));

%>
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<%if (closeAction) { %>
	<script type="text/javascript">window.close();</script>
	<%} else { %>
	<body>
		<jsp:include page="../common/banner2.jsp"/>
			<div id=indexWrapper>
				<div id=mainFrame>
					<div id=Frame>
						<%
							String title = "function.pbList.title"; 
							String suffix = "_2";
						%>
						<jsp:include page="../common/page_title.jsp" flush="false">
							<jsp:param name="pageTitle" value="<%=title %>" />
							<jsp:param name="suffix" value="<%=suffix %>" />	
							<jsp:param name="category" value="admin" />
							<jsp:param name="keepReferer" value="N" />
						</jsp:include>
						
						<font color="blue"><%=message %></font>
						<font color="red"><%=errorMessage %></font>
						
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0" style = "width:100%;">
							<tr class="smallText">
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.patNo" />
								</td>		
								<td class="infoData2" width="30%">
									<%=patNo==null?"":patNo %>
								</td>		
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.patSex" />
								</td>
								<td class="infoData2" width="15%">
									<%=patSex==null?"":patSex %>
								</td>
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.patient.curInHouse" />
								</td>
								<td class="infoData2" width="10%">
									<input type="checkbox" name="curInHouse" value="<%=patInHouse==null?"":patInHouse %>" <%=patInHouse==null?"":(patInHouse.equals("YES")?"checked":"") %>/>
								</td>
							</tr>
						</table>
						
						<table cellpadding="0" cellspacing="5"
								class="contentFrameMenu" border="0" style = "width:100%;">	
							<tr class="smallText">
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.pateName" />
								</td>
								<td class="infoData2" width="30%">
									<%=patName %>
								</td>
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.patcName" />
								</td>
								<td class="infoData2" width="15%">
									<%=patcName==null?"":patcName %>
								</td>
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.patage" />
								</td>
								<td class="infoData2" width="10%">
									<%=patage==null?"":patage %>
								</td>		
							</tr>
						</table>
						
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0" style = "width:100%;">
							<tr class="smallText">	
								<td class="infoLabel" width="15%">
									Country Code
								</td>
								<td class="infoData2" width="30%">
									<%=coucode==null?"":coucode %>
								</td>
								<td class="infoLabel" width="15%">
									ID/passport no. 
								</td>
								<td class="infoData2" width="50%" colspan="3">
									<%=patIdNo==null?"":patIdNo  %>
								</td>
							</tr>
						</table>
						
						<table cellpadding="0" cellspacing="5"
								class="contentFrameMenu" border="0" style = "width:100%;">	
							<tr class="smallText">	
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.mobilePhone" />
								</td>
								<td class="infoData2" width="30%">
									<select name="areaCode">
										<option value="N">--</option>
									<%
										ReportableListObject rowRecord = null;
										if(coucodes.size() > 0) {
											for(int i = 0; i < coucodes.size(); i++) {
												rowRecord = (ReportableListObject) coucodes.get(i);
									%>
												<option value="<%=rowRecord.getValue(0)%>"><%=rowRecord.getValue(0)%></option>
									<%
											}
										}
									%>
									</select>
									<input type="text" name="patTelInput" style="width:70%" value="<%=patPager %>"/>
									<button onclick="return submitAction('updatePager');">Save</button>
								</td>
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.homePhone" />
								</td>
								<td class="infoData2" width="15%">
									<%=pathTel==null?"":pathTel %>
								</td>
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.officePhone" />
								</td>
								<td class="infoData2" width="20%">
									<%=patoTel==null?"":patoTel %>
								</td>
							</tr>
						</table>
						
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0" style = "width:100%;">	
							<tr class="smallText">	
								<td class="infoLabel" width="15%">
									Other Contact No.
								</td>
								<td class="infoData2" width="30%">
									<%=bpbContactNo==null?"":bpbContactNo %>
								</td>
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.email" />
								</td>
								<td class="infoData2" width="50%" colspan="3">
									<input type='text' name='patEmailInput' style='width:70%' value='<%=patEmail %>'/>
									<button onclick="return submitAction('updateEmail');">Save</button>
									<button onclick="return sendEmail('#sendMsgResult', true, 'input[name=patEmailInput]'); return false;">Send Link</button>
									<button onclick="return sendEmail('#sendMsgResult', false, 'input[name=patEmailInput]'); return false;">Send Email</button>
									<span id="sendMsgResult" style="color:red"></span>
								</td>
							</tr>
						</table>
						
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0" style = "width:100%;">	
							<tr class="smallText">	
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.docName" />
								</td>
								<td class="infoData2" width="30%">
									<%=docName==null?"":docName %>
								</td>	
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.pbList.schAdmDate" />
								</td>
								<td class="infoData2" width="15%">
									<%=admDate==null?"":admDate %>
								</td>
								<td class="infoLabel" width="15%">
									Surgery Time
								</td>
								<td class="infoData2" width="20%">
									<%=surTime==null?"":surTime %>
								</td>
							</tr>
						</table>	
						
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0" style = "width:100%;">	
							<tr class="smallText">	
								<td class="infoLabel" width="15%">
									<bean:message key="prompt.updatedDate" />
								</td>
								<td class="infoData2" width="30%">
									<%=docUpdateDate==null?"":docUpdateDate %>
								</td>
								<td class="infoLabel" width="15%">OT Procedure</td>
								<td class="infoData2" width="40%"><%=ot_prod %></td>
							</tr>
						</table>
						
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0" style = "width:100%;">	
							<tr class="smallText">	
								<td class="infoLabel" width="15%">
									ACM
								</td>
								<td class="infoData2" width="30%">
									<%=acm==null?"":acm %>
								</td>
								<td class="infoLabel" width="15%">
									Ward
								</td>
								<td class="infoData2" width="15%">
									<%=ward==null?"":ward %>
								</td>
								<td class="infoLabel" width="15%">
									Bed
								</td>
								<td class="infoData2" width="10%">
									<%=bed==null?"":bed %>
								</td>
							</tr>
						</table>
						
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0" style = "width:100%;">	
							<tr class="smallText" style="height:50px">	
							<!-- 
								<td class="infoLabel" width="15%">
									Message
								</td>
								<td class="infoData2" width='30%'>
									<input type="radio" name="notify" value="SE"/>SMS(Eng)&nbsp;&nbsp;&nbsp;
									<input type="radio" name="notify" value="SC"/>SMS(Chi)&nbsp;&nbsp;&nbsp;
									<%-- <input type="radio" name="notify" value="EL"/>Email&nbsp;&nbsp;&nbsp;
									--%>
									<button onclick="sendMsg('input[name=notify]:checked', '#sendMsgResult','reminder1'); return false;">send</button>
									<br/>
									<span id="sendMsgResult" style="color:red"></span>
								</td>
							!-->
								<td style="background-color:#C0C0C0"class="infoLabel" width="15%">
									Message
								</td>
								<td  style = "background-color:#FDD017" class="infoData2" width="30%">
									<b>SMS - Reminder</b><br/>
									<input type="radio" name="notifyReminder" value="SE"/>SMS(Eng)&nbsp;&nbsp;&nbsp;
									<input type="radio" name="notifyReminder" value="SC"/>SMS(Chi)&nbsp;&nbsp;&nbsp;
									<%-- <input type="radio" name="notify" value="EL"/>Email&nbsp;&nbsp;&nbsp;
									--%>
									<button onclick="sendMsg('input[name=notifyReminder]:checked', '#sendMsgReminder','reminder2'); return false;">send</button>
									<span id="sendMsgReminder" style="color:red"></span>								
								</td>
								<td colspan="4"></td>
							</tr>
						</table>
						
						<br/><br/><br/>
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0" style = "width:100%;">	
							<tr class="smallText">	
								<td class="infoLabel" width="15%">
									Last Admission Date
								</td>
								<td class="infoData2" width="40%">
									<%=lastAdmDate==null?"":lastAdmDate %>
								</td>
								<td class="infoLabel" width="15%">
									Last Payment Method
								</td>
								<td class="infoData2" width="25%">
									<%=lastAdmPayMth==null?"":lastAdmPayMth %>
								</td>
							</tr>
							<tr class="smallText">	
								<td class="infoLabel" width="15%">
									Last Admission Type
								</td>
								<td class="infoData2" width="40%">
									<%=lastAdmType==null?"":lastAdmType %>
								</td>
							</tr>
						</table>
						
						<bean:define id="functionLabel"><bean:message key="function.pbList.list" /></bean:define>
						<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
						<form name="form1" action="bookingInfo.jsp" method="post">
							<span id="edit_indicator">
								<jsp:include page="bookingUpdate.jsp" flush="false">
									<jsp:param name="language" value="<%=language %>" />
									<jsp:param name="patPager" value="<%=patPager %>" />
									<jsp:param name="admDate" value="<%=smsAdmDate %>" />
									<jsp:param name="patEmail" value="<%=patEmail %>" />
									<jsp:param name="acmCode" value="<%=preferClass %>" />
									<jsp:param name="bkStatus" value="<%=bkStatus %>" />
									<jsp:param name="patSms" value="<%=patSms %>" />
									<jsp:param name="arcode" value="<%=arcode %>" />
									<jsp:param name="copaytype" value="<%=copaytype %>" />
									<jsp:param name="aredate" value="<%=aredate %>" />
									<jsp:param name="arcamt" value="<%=arcamt %>" />
									<jsp:param name="patNo" value="<%=patNo %>" />
									<jsp:param name="preBookID" value="<%=preBookID %>" />
									<jsp:param name="payMth" value="<%=payMth %>" />
									<jsp:param name="uptDate" value="<%=uptDate %>" />
									<jsp:param name="otPso" value="<%=otPso %>" />
								</jsp:include>
							</span>
							
							<label><b><u>Follow-up History</u></b></label><br/><br/>
							<display:table id="row" name="requestScope.histList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
								<display:column property="fields8" title="" style="width:5%" />
								<display:column property="fields1" title="Patient Name" style="width:8%" />
								<display:column title="Preferred payment method" style="width:5%">
									<logic:equal name="row" property="fields6" value="D">
										Credit Card
									</logic:equal>
									<logic:equal name="row" property="fields6" value="I">
										Insurance
									</logic:equal>
									<logic:equal name="row" property="fields6" value="C">
										Cash
									</logic:equal>
									<logic:equal name="row" property="fields6" value="E">
										EPS	
									</logic:equal>
									<logic:equal name="row" property="fields6" value="O">
										Others
									</logic:equal>		
								</display:column>
								<display:column property="fields11" title="Insurance Remark" style="width:8%" />	
								<display:column property="fields2" title="Follow up date" style="width:8%" />	
								<display:column title="Result (Patient reached By)" style="width:8%">
									<logic:equal name="row" property="fields9" value="4">
										Link
									</logic:equal>
									<logic:equal name="row" property="fields9" value="5">
										Email
									</logic:equal>
									<logic:equal name="row" property="fields9" value="6">
										SMS
									</logic:equal>
									<logic:equal name="row" property="fields9" value="7">
										Fax
									</logic:equal>
									<logic:equal name="row" property="fields9" value="8">
										Phone
									</logic:equal>
									<logic:equal name="row" property="fields9" value="9">
										Can't be reached
									</logic:equal>
									<logic:equal name="row" property="fields9" value="10">
										Preferred upfront registration
									</logic:equal>
									<logic:equal name="row" property="fields9" value="11">
										Booking cancelled/rescheduled
									</logic:equal>
									<logic:equal name="row" property="fields9" value="12">
										Web
									</logic:equal>								
									<logic:equal name="row" property="fields9" value="13">
										Same day booking
									</logic:equal>
									<logic:equal name="row" property="fields9" value="14">
										Booking made after printing call list (1 day ahead)
									</logic:equal>
									<logic:equal name="row" property="fields9" value="15">
										Without contact information
									</logic:equal>
									<logic:equal name="row" property="fields9" value="16">
										Duplicate booking
									</logic:equal>
									<logic:equal name="row" property="fields9" value="17">
										Virtual booking for LOG
									</logic:equal>
									<logic:equal name="row" property="fields9" value="18">
										Others
									</logic:equal>
								</display:column>
								<display:column property="fields13" title="Others Remark" style="width:8%" />		
								<display:column property="fields3" title="User" style="width:8%" />									
								<display:column property="fields4" title="Update date" style="width:8%" />	
								<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
									<button onclick=
									"return editHist('update'
									, '<c:out value="${row.fields6}" />', '<c:out value="${row.fields9}" />'
									, '<c:out value="${row.fields2}" />', '<c:out value="${row.fields4}" />'
									, '<%=language %>', '<%=patPager %>', '<%=smsAdmDate %>'
									, '<%=patEmail %>', '<%=preferClass %>', '<%=bkStatus %>'
									, '<c:out value="${row.fields3}" />', '<%=patSms %>'
									, '<%=patNo%>', '<%=preBookID%>', '<c:out value="${row.fields4}" />'
									, '<c:out value="${row.fields12}" />', '<%=userBean.getLoginID()%>' , '<c:out value="${row.fields14}" />')"><bean:message key='button.edit' /></button>
									<%if(userBean.isAccessible("function.pblist.delete")) { %>
										<button onclick="return submitAction('delete', '${row.fields4}');"><bean:message key='function.pblist.delete' /></button>
									<%} %>
								</display:column>
								<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
							</display:table>
							
							<input type="hidden" name="command" />
							<input type="hidden" name="patNo" value="<%=patNo %>" />
							<input type="hidden" name="preBookID" value="<%=preBookID %>" />
							<input type="hidden" name="patSms" value="<%=patSms %>" />
							<input type="hidden" name="patEmail" value=""/>
							<input type="hidden" name="delRecord" value=""/>
							<input type="hidden" name="patTel" value=""/>
						</form>
						
						<br/><br/><label><b><u>SMS History</u></b></label><br/><br/>
						<display:table id="row" name="requestScope.smsHistList" export="true" 
								pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
							<display:column property="fields17" title="Msg ID" style="width:5%" />
							<display:column property="fields1" title="Language" style="width:5%" />
							<display:column property="fields16" title="Template" style="width:5%" />
							<display:column property="fields9" title="Success" style="width:5%" />
							<display:column property="fields8" title="Status" style="width:5%" />
							<display:column property="fields11" title="Sender" style="width:5%" />
							<display:column property="fields18" title="Send Time" style="width:5%" />
						</display:table>
						
						<script language="javascript">
							function submitAction(cmd, delTime) {
								if (cmd == 'create' || cmd == 'update') {
								}
								
								if (cmd == 'delete') {
									$('input[name=delRecord]').val(delTime);
								}
								
								if(cmd == 'updateEmail') {
									$('input[name=patEmail]').val($('input[name=patEmailInput]').val());
								}
								
								if(cmd == 'updatePager') {
									$('input[name=patTel]').val($('input[name=patTelInput]').val());
								}
								
								document.form1.command.value = cmd;
								document.form1.submit();
								//if (cmd == 'update')
									//window.location.reload();
								return false;
							}
							
							function editHist(cmd, payMth, flwUpSts, flwUpDate, uptDate, 
									language, patPager, admDate, patEmail, acmCode,
									bkStatus, lastModify, patSms, patNo, preBookID, uptDate,
									ownUser, curUser, otPso) {
								
								if(ownUser == curUser) {
									$.ajax({
										type: "GET",
										url: "bookingUpdate.jsp",
										data: "command="+cmd+"&payMth="+payMth+"&flwUpSts="+flwUpSts+
												"&flwUpDate="+flwUpDate+"&uptDate="+uptDate+
												"&language="+language+"&patPager="+patPager+"&admDate="+admDate+
												"&patEmail="+patEmail+"&acmCode="+acmCode+"&bkStatus="+bkStatus+
												"&lastModify="+lastModify+"&patSms="+patSms+
												"&patNo="+patNo+"&preBookID="+preBookID+"&uptDate="+uptDate+"&otPso="+otPso,
										async: false,
										success: function(values){
											$("span#edit_indicator").html(values);
										},//success
										error: function(jqXHR, textStatus, errorThrown) {
											
										}
									});
								}
								else {
									alert('You are not the owner of this record.');
								}
								
								return false;
							}
						</script>
					</div>
				</div>
			</div>

			<jsp:include page="../common/footer.jsp" flush="false" />
		</body>
<%} %>
</html:html>