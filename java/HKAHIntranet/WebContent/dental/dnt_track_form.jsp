<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private String joinDateTime(String dateString, String hourString, String minsString) {
		if (dateString == null || "".equals(dateString.trim())) {
			return null;
		}
		return (dateString == null || dateString == "" ? "//" : dateString) + " " + (hourString == null ? "" : hourString) + ":" + (minsString == null ? "" : minsString);
	}

	private String[] splitDateTimeHourMins(String dateTime) {
		String[] ret = new String[3];
		if (dateTime != null) {
			String[] temp = dateTime.split(" ");
			if (temp.length > 0) {
				ret[0] = temp[0];
				if (temp.length > 1 && temp[1] != null) {
					ret[1] = temp[1].split(":")[0];
					ret[2] = temp[1].split(":")[1];
				}
			}
		}
		return ret;
	}
	
	private String convertMinsSec(String mins, String sec) {
		String ret = null;
		Long totalSec = null;
		Long secLong = null;
		Long minsLong = null;
		
		try {
			 secLong = Long.parseLong(sec);
		} catch (NumberFormatException nfex) {
		}
		try {
			 minsLong = Long.parseLong(mins);
		} catch (NumberFormatException nfex) {
		}
		
		if (!(secLong == null && minsLong == null)) {
			totalSec = ((minsLong == null ? 0 : minsLong)* 60) + (secLong == null ? 0 : secLong);
			ret = Long.toString(totalSec);
		}
			
		return ret;
	}
	
	private String[] parseMinsSec(String totalSec) {
		String[] ret = new String[2];
		if (totalSec != null) {
			try {
				
				
				long totalSecLong = Long.parseLong(totalSec);
				long minsLong = totalSecLong / 60;
				long secLong = totalSecLong % 60;
				ret[0] = Long.toString(minsLong);
				ret[1] = Long.toString(secLong);
			} catch (NumberFormatException nfex) {
			}
		}
		return ret;
	}
%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = true;
}

UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

String command = request.getParameter("command");
String step = request.getParameter("step");

String dntSiteCode = request.getParameter("dntSiteCode");
String dntTrackId = request.getParameter("dntTrackId");
String dntInstruId = TextUtil.parseStrUTF8(request.getParameter("dntInstruId"));
String dntHospno = TextUtil.parseStrUTF8(request.getParameter("dntHospno"));
String dntPatientname = TextUtil.parseStrUTF8(request.getParameter("dntPatientname"));
String dntDate = TextUtil.parseStrUTF8(request.getParameter("dntDate"));

// derived fields
String dntTrackDateDate = request.getParameter("dntTrackDateDate");
String dntTrackDateTimeHour = request.getParameter("dntTrackDateTimeHour");
String dntTrackDateTimeMins = request.getParameter("dntTrackDateTimeMins");

// String dntLaboDuraMins = request.getParameter("dntLaboDuraMins");
// String dntLaboDuraSec = request.getParameter("dntLaboDuraSec");


boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

//DntTrackDB.add(userBean, "AAA", "123456","Kenneth", "01/01/2011");

if (fileUpload) {
	// No file upload supported
}

try {
	if ("1".equals(step)) {
		// construct fields
		dntDate = joinDateTime(dntTrackDateDate, dntTrackDateTimeHour, dntTrackDateTimeMins);
//		dntLaboDura = convertMinsSec(dntLaboDuraMins, dntLaboDuraSec);
		
		if (createAction) {
			
			dntTrackId = DntTrackDB.add(
					userBean,
					dntInstruId,
					dntHospno,
					dntPatientname,
					dntDate
				);

			if (dntTrackId != null) {
				message = "Record created.";
				createAction = false;
				step = null;
			} else {
				errorMessage = "Record create fail.";
			}
		} else if (updateAction) {
			
			boolean success = false; 
			if (dntTrackId != null) {
				success = DntTrackDB.update(
								userBean,
								dntTrackId,
								dntInstruId,
								dntHospno,
								dntPatientname,
								dntDate
							);
			}

			if (success) {	// do update
				message = "Record updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "Record update fail.";
			}		
		
		} else if (deleteAction) {
			boolean success = DntTrackDB.delete(userBean, dntTrackId); 
			
			if (success) {	
				message = "Record removed.";
				closeAction = true;
			} else {
				errorMessage = "Record remove fail.";
			}
		}
	} else if (createAction) {
		// start new record for insert
		dntTrackDateDate = DateTimeUtil.getCurrentDate();
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (dntTrackId != null && dntTrackId.length() > 0) {
			ArrayList record = DntTrackDB.get(dntTrackId);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				dntInstruId = row.getValue(2);
				dntHospno = row.getValue(3);
				dntPatientname = row.getValue(4);
				dntDate = row.getValue(5);
				
				// construct fields
				String[] dntTrackDateTimeArray = splitDateTimeHourMins(dntDate);
				if (dntTrackDateTimeArray.length > 0) dntTrackDateDate = dntTrackDateTimeArray[0];
				if (dntTrackDateTimeArray.length > 1) dntTrackDateTimeHour = dntTrackDateTimeArray[1];
				if (dntTrackDateTimeArray.length > 2) dntTrackDateTimeMins = dntTrackDateTimeArray[2];
				
				
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	String mustLogin = "Y";
	if (createAction) {
		commandType = "create";
		// can create by guest
		mustLogin = "N";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.dnt.tk." + commandType;
	
	String accessControl = "Y";
	if (ConstantsServerSide.DEBUG) {
		accessControl = "N";
	} 
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="mustLogin" value="<%=mustLogin %>" />
	<jsp:param name="accessControl" value="<%=accessControl %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="form1" id="form1" action="<html:rewrite page="/dental/dnt_track_form.jsp" />" method="post">
<%	if (!createAction) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="10%">Ref. No.</td>
		<td class="infoData" width="20%"><%=dntTrackId == null ? "" : dntTrackId %></td>
	</tr>
</table>
<% } %>
<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
	<%	if (createAction || updateAction || deleteAction) { %>
				<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
	<%		if (!createAction) { %>
				<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
	<%		}  %>
	<%	} else { %>
				<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="button.update" /></button>
				<button class="btn-delete"><bean:message key="button.delete" /></button>
	<%	}  %>
			</td>
		</tr>
	</table>
</div>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">

		<td class="infoLabel" width="15%">Instrument No</td>
		<td class="infoData" width="35%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="dntInstruId" name="dntInstruId" value="<%=dntInstruId == null ? "" : dntInstruId %>" maxlength="10" size="15" />
	<%	} else { %>
			<%=dntInstruId == null ? "" : dntInstruId %>
<%	} %>
		</td>
		<td colspan="2">
			<table cellpadding="0" cellspacing="1" border="0">
				<tr>
					<td class="infoLabel" width="40%">Hospital No</td>
					<td class="infoData" width="60%">
<%	if (createAction || updateAction) { %>
						<input type="text" name="dntHospno" value="<%=dntHospno == null ? "" : dntHospno %>" maxlength="40" size="35" />
<%	} else { %>	
						<%=dntHospno == null ? "" : dntHospno %>
<%	} %>
					</td>
				</tr>
				<tr>
					<td class="infoLabel">Patient Name</td>
					<td class="infoData">
<%	if (createAction || updateAction) { %>
						<input type="text" name="dntPatientname" value="<%=dntPatientname == null ? "" : dntPatientname %>" maxlength="40" size="35" />
<%	} else { %>	
						<%=dntPatientname == null ? "" : dntPatientname %>
<%	} %>
					</td>
				</tr>
			</table>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="15%">Date</td>
		<td class="infoData"" width="35%" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="text" name="dntTrackDateDate" id="dntTrackDateDate" class="datepickerfield" value="<%=dntDate == null ? "" : dntDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
			-	
			<select name="dntTrackDateTimeHour">
				<%
					for (int i = 0; i < 24; i++) {
						String hourCode = (i < 10 ? "0" + i : "" + i);
				%>
				<option value="<%=hourCode %>"<%=hourCode.equals(dntTrackDateTimeHour)?" selected":"" %>><%=hourCode %></option>
				<%
					}
				%>
			</select>:
			<select name="dntTrackDateTimeMins">
				<%
					for (int i = 0; i < 60; i++) {
						String minsCode = (i < 10 ? "0" + i : "" + i);
				%>
				<option value="<%=minsCode %>"<%=minsCode.equals(dntTrackDateTimeMins)?" selected":"" %>><%=minsCode %></option>
				<%
					}
				%>
			</select> (hour:minute)
<%	} else { %>
			<%=dntTrackDateDate == null ? "" : dntTrackDateDate %> <%=dntTrackDateTimeHour == null ? "" : dntTrackDateTimeHour %>:<%=dntTrackDateTimeMins == null ? "" : dntTrackDateTimeMins %>
<%	} %>
		</td>

</table>

<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
	<%	if (createAction || updateAction || deleteAction) { %>
				<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
	<%		if (!createAction) { %>
				<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
	<%		}  %>
	<%	} else { %>
				<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="button.update" /></button>
				<button class="btn-delete"><bean:message key="button.delete" /></button>
	<%	}  %>
			</td>
		</tr>
	</table>
</div>

<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="dntTrackId" value="<%=dntTrackId %>" />


<!-- reserved fields -->
<input type="hidden" name="dntInstruId" value="<%=dntInstruId %>" />
<input type="hidden" name="dntHospno" value="<%=dntHospno %>" />
<input type="hidden" name="dntPatientname" value="<%=dntPatientname %>" />

</form>

<script language="javascript">
$(document).ready(function() {
	<%	if (createAction || updateAction) { %>
		$("textarea[name=nurobAbnMatHis]").supertextarea({
			maxl: 200,
			tabr: {use: false}
		});
		$("textarea[name=nurobIolReason]").supertextarea({
			maxl: 200,
			tabr: {use: false}
		});
		$("textarea[name=nurobModeReason]").supertextarea({
			maxl: 400,
			tabr: {use: false}
		});
		$("textarea[name=nurobPostNatal]").supertextarea({
			maxl: 200,
			tabr: {use: false}
		});
	
		$("#form1").validate({

		});
	<%	} %>
});

function submitAction(cmd, stp) {
	if (stp == 1) {
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.dntTrackDateTimeHour.value == '') {
				alert("Please input Date.");
				document.form1.dntTrackDateTimeHour.focus();
				return false;
			}
		}
	}
	document.form1.command.value = cmd;
	document.form1.step.value = stp;
	document.form1.submit();
}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>