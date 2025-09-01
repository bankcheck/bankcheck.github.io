<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.util.mail.UtilMail" %>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.DateTimeUtil" %>
<%@ page import="org.apache.struts.Globals" %>
<%!
private ArrayList getCardEmailContent() {
	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CO_CONTENT FROM CO_NEWS_CONTENT WHERE CO_NEWS_CATEGORY = 'eSHARECard' AND CO_ENABLED = 1 ");


	ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
	if (record.size() > 0) {
		return record;
	} else {
		return null;
	}
}

private String getNominNeeMail(String staffID) {
	
	String email = UserDB.getUserEmail(staffID);

	if (email == null || email.trim().isEmpty()) {
		email = UserDB.getUserEmail(DepartmentDB
				.getDeptHeadID(StaffDB.getDepartmentCode(staffID)));	
	}
	return email;
}
%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String entryDate = request.getParameter("entryDate");
if (entryDate == null) {
	entryDate = DateTimeUtil.formatDate(new Date());
}
String nominatorName = request.getParameter("nominatorName");
String nominatorEmail = request.getParameter("nominatorEmail");
String nominatorTel = request.getParameter("nominatorTel");
String nomineeStaffName = request.getParameter("nomineeStaffName");
String desc = TextUtil.parseStrUTF8(request.getParameter("desc"));
String relationship = request.getParameter("relationship");
String nomineeDeptCode = request.getParameter("nomineeDeptCode");
String nomineeStaffID= request.getParameter("nomineeStaffID");
String nominatorDeptCode = request.getParameter("nominatorDeptCode");
String language = request.getParameter("language");
String allowDisplay = request.getParameter("allowDisplay");

Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else if ("eng".equals(language)) {
	locale = Locale.US;
}
if (language == null) {
	locale = (Locale) session.getAttribute(Globals.LOCALE_KEY);
}
boolean emailSuccess = false;
if ("".equals(command)|| command == null) {
	command = "create";
}
if ("sendEmail".equals(command)) {
	  if (!"".equals(nominatorName)&& !"".equals(nomineeStaffName)) {
		  if (EmployeeVoteDB.addEShare(userBean,nomineeStaffName,nominatorEmail,nominatorTel,desc, allowDisplay)) {
			StringBuffer commentStr = new StringBuffer();
			commentStr.append("<br>The details of eSHARE are as follows: ");
			commentStr.append("<br>");
			commentStr.append("<br>Date of entry: <u>"+entryDate+"</u><br>");
			commentStr.append("<br>Nominator's Name:  <u>"+nominatorName+"</u><br>");
			commentStr.append("<br>Nominator's email address:  <u>"+nominatorEmail+"</u><br>");
			commentStr.append("<br>Nominator's contract phone No:  <u>"+nominatorTel+"</u><br>");
			commentStr.append("<br>Nominator's Department:  <u>"+DepartmentDB.getDeptDesc(nominatorDeptCode)+"</u><br>");
			commentStr.append("<br>*************************************<br>");
			commentStr.append("<br>Nominee's Name:  <u>"+StaffDB.getStaffName(nomineeStaffName)+"</u><br>");
			commentStr.append("<br>Nominee's Department:  <u>"+DepartmentDB.getDeptDesc(nomineeDeptCode)+"</u><br>");
			commentStr.append("<br>Nominee's outstanding performance:<br>");
			commentStr.append("<br><u>"+desc+"</u><br>");
			commentStr.append("<br>Allow Disclose: <u>"+allowDisplay+"</u><br>");
			//commentStr.append("<br>Nominator's relationship to nominee: <u>"+relationship+"</u><br>");

		
			EmailAlertDB.sendEmail("eshare", 
			"New eSHARE(Date: " + DateTimeUtil.getCurrentDateTimeWithoutSecond() + ")", 
			commentStr.toString()); 
			
/* 			if (ConstantsServerSide.isTWAH()) {
				ArrayList record = getCardEmailContent();
				String email = getNominNeeMail(nomineeStaffID);
				StringBuffer cardStr = new StringBuffer();

				if (record != null) {
					for (int i = 0; i < record.size(); i++) {
						ReportableListObject row = (ReportableListObject) record.get(i);
						String content = row.getValue(0);
						content = content.replace("{1}",StaffDB.getStaffName(nomineeStaffName))
						.replace("{2}",nominatorName).replace("{3}",desc);					
						cardStr.append(content);
					}
				}
				
				if (email != null && email.length() > 0 && cardStr.length() > 0 ) {
					
					UtilMail.sendMail("esharing@twah.org.hk",email,
							nominatorName+"的感謝卡 "+" Received a Thank You Card from "+nominatorName+" (eSHARE)", 
							cardStr.toString(),true);
					
				}

			} */
				
		message = "eSHARE submit Success.";
	} else {
		message = "eSHARE submit Fail";
	}
} else {
	message = "eSHARE submit Fail";
}


}
if ("close".equals(command)) {
%>
<script type="text/javascript">window.close();</script>
<%
}
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}


%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.eshare" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="translate" value="Y" />
	<jsp:param name="keepReferer" value="N" />
	<jsp:param name="isHideHeader" value="Y" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" action="<html:rewrite page="/admin/eSHARE.jsp" />" method="post">
<table >
<tr><td style="text-align:center;"><%=MessageResources.getMessage(locale, "eshare.title" )%></td></tr>
<tr><td>&nbsp;</td></tr>
<%if (ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) { %>
<tr><td><%=MessageResources.getMessage(locale, "eshare.description" )%></td></tr>
<%} else { %>
<tr><td><%=MessageResources.getMessage(locale, "eshare.descriptiontw" )%></td></tr>
<%} %>
<tr><td>&nbsp;</td></tr>
<tr><td><%=MessageResources.getMessage(locale, "eshare.definition.title" )%></td></tr>
<tr><td style="padding-left:10;"><%=MessageResources.getMessage(locale, "eshare.definition.s" )%></td></tr>
<tr><td style="padding-left:10;"><%=MessageResources.getMessage(locale, "eshare.definition.h" )%></td></tr>
<tr><td style="padding-left:10;"><%=MessageResources.getMessage(locale, "eshare.definition.a" )%></td></tr>
<tr><td style="padding-left:10;"><%=MessageResources.getMessage(locale, "eshare.definition.r" )%></td></tr>
<tr><td style="padding-left:10;"><%=MessageResources.getMessage(locale, "eshare.definition.e" )%></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td><%=MessageResources.getMessage(locale, "eshare.processroute1" )%></td></tr>
<tr><td>&nbsp;</td></tr>
<%if (ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) { %>
 <tr><td><%=MessageResources.getMessage(locale, "eshare.processroute2" )%></td></tr>
<%} else { %>
 <tr><td><%=MessageResources.getMessage(locale, "eshare.processroute2tw" )%></td></tr>
<%} %>
</table>
<%if ("create".equals(command)) { %>
<div style="width: 1300px; ">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" style="width: 900px;  display: inline-block;">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=MessageResources.getMessage(locale, "eshare.entryDate" )%></td>
		<td class="infoData" width="70%">
			<%=entryDate == null ? "" : entryDate %>
		<input type="hidden" name="entryDate" id="entryDate" value="<%=entryDate == null ? "" : entryDate %>" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=MessageResources.getMessage(locale, "eshare.nominatorName" )%></td>
		<td class="infoData" width="70%">
		<%=StaffDB.getStaffName(userBean.getStaffID()) %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=MessageResources.getMessage(locale, "eshare.nominatorEmail" )%></td>
		<td class="infoData" width="70%">
		<input type="text" name="nominatorEmail" value="" maxlength="50" size="50">	(<%=MessageResources.getMessage(locale, "prompt.optional" )%>)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=MessageResources.getMessage(locale, "eshare.nominatorPhone" )%></td>
		<td class="infoData" width="70%">
		<input type="text" name="nominatorTel" value="" maxlength="20" size="20"> (<%=MessageResources.getMessage(locale, "prompt.optional" )%>)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=MessageResources.getMessage(locale, "eshare.nominatorDept" )%></td>
		<td class="infoData" width="70%">
		<%=userBean.getDeptDesc() %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle2" colspan="2"><%=MessageResources.getMessage(locale, "eshare.nominee" )%></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=MessageResources.getMessage(locale, "prompt.department")%></td>
		<td class="infoData" width="70%">
		<table>
		 <tr>
		 <td>
		 	<select name="nomineeDeptCode" onchange="return changeStaffID()">
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
			<jsp:param name="allowAll" value="Y" />
			<jsp:param name="category" value="nominee" />
			</jsp:include>
			</select>
		</td>
	     <td class="infoLabel" width="20%"><%=MessageResources.getMessage(locale, "eshare.nomineeName" )%></td>
		  <td>
		  	<span id="showStaffID_indicator">
			<select name="nomineeStaffName" onchange="return changeStaffName()">
				<option value=""></option>
				<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
					<jsp:param name="deptCode" value=" " />
					<jsp:param name="ignoreCurrentStaffID" value="Y" />
					<jsp:param name="showDeptDesc" value="N" />
					<jsp:param name="category" value="nominee" />
					<jsp:param name="hideDoctorForOutpatientNursing" value="Y" />
					<jsp:param name="hideVolunteer" value="Y" />
					<jsp:param name="hideDummyUser" value="Y" />
				</jsp:include>
			</select>
			</span>
		 </td>
		 <td><b><%=MessageResources.getMessage(locale, "prompt.staffID" )%>:</b> <input type="textfield" name="nomineeStaffID" value="<%=nomineeStaffID==null?"":nomineeStaffID %>" size="10"></td>

		 </tr>
		</table>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=MessageResources.getMessage(locale, "eshare.nomineePerformance" )%></td>
		<td class="infoData" width="70%">
		<%=MessageResources.getMessage(locale, "eshare.performanceDesc" )%>
		<textarea name="desc" rows="4" cols="140"></textarea>
		</td>
	</tr>

</table>

	<img style="float:right" id="staffPhoto" src="../images/Photo_not_available.jpg" height="236" width="187"
			onerror="this.src='../images/Photo_not_available.jpg';"></img>
	
</div>

<div class="pane">
<table width="100%" border="0">
	<tr>
	<td>
		<%=MessageResources.getMessage(locale, "eshare.allowDisplay" )%>&nbsp;&nbsp;
		<input type="radio" name="allowDisplay" value="Y"><%=MessageResources.getMessage(locale, "label.yes" )%>
	 	<input type="radio" name="allowDisplay" value="N"><%=MessageResources.getMessage(locale, "label.no" )%>
	</td>
	</tr>
	<tr class="smallText">
		<td align="center">
		<button onclick="return submitAction('sendEmail');" name="submit-eShare" class="btn-click"><%=MessageResources.getMessage(locale, "button.submit" )%> - <%=MessageResources.getMessage(locale, "function.eshare" )%></button>
		<button onclick="return clearForm();" name="clear-eShare" class="btn-click"><%=MessageResources.getMessage(locale, "button.clear" )%></button>

		</td>
	</tr>
</table>
</div>
<%} else { %>
<button onclick="return submitAction('close');" type='button' class="btn-click">Close</button>
<%} %>
<input type="hidden" name="command">
<input type="hidden" name="nominatorName" value="<%=StaffDB.getStaffName(userBean.getStaffID()) %>"/>
<input type="hidden" name="nominatorDeptCode" value="<%=userBean.getDeptCode() %>"/>
</form>
<script language="javascript">

	var path = "../admin/staffPhoto.jsp?staffID=";

	function submitAction(cmd) {
		document.form1.command.value = cmd;
		if (document.form1.command.value =='sendEmail') {
			if (document.form1.nomineeStaffName.value == '') {
				alert('<%=MessageResources.getMessage(locale, "eshare.nomineeStaffName.required" )%>');
				$('input[name=nomineeStaffName]').focus();
				return false;
			} else if (document.form1.desc.value == '') {
				alert('<%=MessageResources.getMessage(locale, "eshare.desc.required" )%>');
				$('textarea[name=desc]').focus();
				return false;
			} else if (document.form1.desc.value.length < 50) {
				alert('<%=MessageResources.getMessage(locale, "eshare.wordcount.required" )%>');
				$('textarea[name=desc]').focus();
				return false;
			} else if (!$('input[name=allowDisplay]:checked').length > 0) {
				alert('<%=MessageResources.getMessage(locale, "eshare.allowDisplay.required" )%>');
				$('input[name=allowDisplay]').focus();
				return false;
			} else {
				// disable button
				$('button[name=submit-eShare]').attr("disabled", true);
				$('button[name=clear-eShare]').attr("disabled", true);
				showLoadingBox('body', 500, $(window).scrollTop());
				
				document.form1.submit();
			}
		} else {
			window.location.replace("../hr/rrteam.jsp");
		}
	}

	function changeStaffName() {
		document.form1.nomineeStaffID.value = document.form1.nomineeStaffName.value;
		
		displayPhoto = $('select[name=nomineeStaffName] option:selected').attr('displayPhoto');
		if(displayPhoto == "Y"){
			var staffid = document.form1.nomineeStaffName.value;
		}else{
			staffid=null;
		}
		document.getElementById("staffPhoto").src = path + staffid;
		return false;
	}

	function clearForm() {
		document.form1.entryDate.value = "";
		document.form1.nominatorName.value = "";
		document.form1.nominatorEmail.value="";
		document.form1.nominatorTel.value="";
		$('select[name=nomineeDeptCode]')[0].selectedIndex = 0;
		$('select[name=nomineeStaffName]')[0].selectedIndex = 0;
		//document.form1.nomineeStaffName[0].selectIndex=0;
		document.form1.desc.value="";
		document.form1.nomineeStaffID.value = "";
		document.getElementById("staffPhoto").src = "";
		return false;
	}
	// ajax
	function changeStaffID() {
		var did = document.form1.nomineeDeptCode.value;
		$.ajax({
			type: "POST",
			url: "../ui/staffIDCMB.jsp",
			data: "deptCode=" + did + "&ignoreCurrentStaffID=Y&showDeptDesc=N&category=nominee&hideDoctorForOutpatientNursing=Y&hideVolunteer=Y&hideDummyUser=Y",
			success: function(values) {
			if (values != '') {
				$("#showStaffID_indicator").html("<select name='nomineeStaffName' onchange='return changeStaffName();'><option value=''></option>" + values + "</select>");
			}//if
			}//success
		});//$.ajax
	}

</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>