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

String nurobSiteCode = request.getParameter("nurobSiteCode");
String nurobDeliRmId = request.getParameter("nurobDeliRmId");
String nurobMoPatno = request.getParameter("nurobMoPatno");
String nurobMoPatname = TextUtil.parseStrUTF8(request.getParameter("nurobMoPatname"));
String nurobMoPatfname = TextUtil.parseStrUTF8(request.getParameter("nurobMoPatfname"));
String nurobMoPatgname = TextUtil.parseStrUTF8(request.getParameter("nurobMoPatgname"));
String nurobMoPatcname = TextUtil.parseStrUTF8(request.getParameter("nurobMoPatcname"));
String nurobPhysStaffId = request.getParameter("nurobPhysStaffId");
String nurobPhysName = TextUtil.parseStrUTF8(request.getParameter("nurobPhysName"));
String nurobAge = request.getParameter("nurobAge");
String nurobGrav = request.getParameter("nurobGrav");
String nurobPara = request.getParameter("nurobPara");
String nurobEdc = request.getParameter("nurobEdc");
String nurobAbnMatHis = TextUtil.parseStrUTF8(request.getParameter("nurobAbnMatHis"));
String nurobAnc = request.getParameter("nurobAnc");
String nurobOpdVisits = request.getParameter("nurobOpdVisits");
String nurobFeed = request.getParameter("nurobFeed");
String nurobRubellaTiter = request.getParameter("nurobRubellaTiter");
String nurobHbsag = request.getParameter("nurobHbsag");
String nurobVdrl = request.getParameter("nurobVdrl");
String nurobHiv = request.getParameter("nurobHiv");
String nurobInduPe2 = request.getParameter("nurobInduPe2");
String nurobInduPit = request.getParameter("nurobInduPit");
String nurobIolReason = TextUtil.parseStrUTF8(request.getParameter("nurobIolReason"));
String nurobPosition = request.getParameter("nurobPosition");
String nurobAnesthesia = request.getParameter("nurobAnesthesia");
String nurobDeliDate = request.getParameter("nurobDeliDate");
String nurobModeReason = TextUtil.parseStrUTF8(request.getParameter("nurobModeReason"));
String nurobEpiRepair = request.getParameter("nurobEpiRepair");
String nurobPlacenta = request.getParameter("nurobPlacenta");
String nurobLaboDura = request.getParameter("nurobLaboDura");
String nurobApgarFrom = request.getParameter("nurobApgarFrom");
String nurobApgarTo = request.getParameter("nurobApgarTo");
String nurobSex = request.getParameter("nurobSex");
String nurobWeight = request.getParameter("nurobWeight");
String nurobPostNatal = TextUtil.parseStrUTF8(request.getParameter("nurobPostNatal"));
String nurobNurAssistName = TextUtil.parseStrUTF8(request.getParameter("nurobNurAssistName"));
String nurobNurCircName = TextUtil.parseStrUTF8(request.getParameter("nurobNurCircName"));

// derived fields
String nurobDeliDateDate = request.getParameter("nurobDeliDateDate");
String nurobDeliDateTimeHour = request.getParameter("nurobDeliDateTimeHour");
String nurobDeliDateTimeMins = request.getParameter("nurobDeliDateTimeMins");

String nurobLaboDuraMins = request.getParameter("nurobLaboDuraMins");
String nurobLaboDuraSec = request.getParameter("nurobLaboDuraSec");


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

if (fileUpload) {
	// No file upload supported
}

try {
	if ("1".equals(step)) {
		// construct fields
		nurobDeliDate = joinDateTime(nurobDeliDateDate, nurobDeliDateTimeHour, nurobDeliDateTimeMins);
		nurobLaboDura = convertMinsSec(nurobLaboDuraMins, nurobLaboDuraSec);
		
		if (createAction) {
			
			nurobDeliRmId = NurobDeliRmDB.add(
					userBean,
					nurobMoPatno,
					nurobMoPatname,
					nurobMoPatfname,
					nurobMoPatgname,
					nurobMoPatcname,
					nurobPhysStaffId,
					nurobPhysName,
					nurobAge,
					nurobGrav,
					nurobPara,
					nurobEdc,
					nurobAbnMatHis,
					nurobAnc,
					nurobOpdVisits,
					nurobFeed,
					nurobRubellaTiter,
					nurobHbsag,
					nurobVdrl,
					nurobHiv,
					nurobInduPe2,
					nurobInduPit,
					nurobIolReason,
					nurobPosition,
					nurobAnesthesia,
					nurobDeliDate,
					nurobModeReason,
					nurobEpiRepair,
					nurobPlacenta,
					nurobLaboDura,
					nurobApgarFrom,
					nurobApgarTo,
					nurobSex,
					nurobWeight,
					nurobPostNatal,
					nurobNurAssistName,
					nurobNurCircName
				);

			if (nurobDeliRmId != null) {
				message = "Delivery created.";
				createAction = false;
				step = null;
			} else {
				errorMessage = "Delivery create fail.";
			}
		} else if (updateAction) {
			
			boolean success = false; 
			if (nurobDeliRmId != null) {
				success = NurobDeliRmDB.update(
								userBean,
								nurobDeliRmId,
								nurobMoPatno,
								nurobMoPatname,
								nurobMoPatfname,
								nurobMoPatgname,
								nurobMoPatcname,
								nurobPhysStaffId,
								nurobPhysName,
								nurobAge,
								nurobGrav,
								nurobPara,
								nurobEdc,
								nurobAbnMatHis,
								nurobAnc,
								nurobOpdVisits,
								nurobFeed,
								nurobRubellaTiter,
								nurobHbsag,
								nurobVdrl,
								nurobHiv,
								nurobInduPe2,
								nurobInduPit,
								nurobIolReason,
								nurobPosition,
								nurobAnesthesia,
								nurobDeliDate,
								nurobModeReason,
								nurobEpiRepair,
								nurobPlacenta,
								nurobLaboDura,
								nurobApgarFrom,
								nurobApgarTo,
								nurobSex,
								nurobWeight,
								nurobPostNatal,
								nurobNurAssistName,
								nurobNurCircName
							);
			}

			if (success) {	// do update
				message = "Delivery updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "Delivery update fail.";
			}		
		
		} else if (deleteAction) {
			boolean success = NurobDeliRmDB.delete(userBean, nurobDeliRmId); 
			
			if (success) {	
				message = "Delivery removed.";
				closeAction = true;
			} else {
				errorMessage = "Delivery remove fail.";
			}
		}
	} else if (createAction) {
		// start new record for insert
		nurobDeliDateDate = DateTimeUtil.getCurrentDate();
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (nurobDeliRmId != null && nurobDeliRmId.length() > 0) {
			ArrayList record = NurobDeliRmDB.get(nurobDeliRmId);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				nurobMoPatno = row.getValue(2);
				nurobMoPatname = row.getValue(3);
				nurobMoPatfname = row.getValue(4);
				nurobMoPatgname = row.getValue(5);
				nurobMoPatcname = row.getValue(6);
				nurobPhysStaffId = row.getValue(7);
				nurobPhysName = row.getValue(8);
				nurobAge = row.getValue(9);
				nurobGrav = row.getValue(10);
				nurobPara = row.getValue(11);
				nurobEdc = row.getValue(12);
				nurobAbnMatHis = row.getValue(13);
				nurobAnc = row.getValue(14);
				nurobOpdVisits = row.getValue(15);
				nurobFeed = row.getValue(16);
				nurobRubellaTiter = row.getValue(17);
				nurobHbsag = row.getValue(18);
				nurobVdrl = row.getValue(19);
				nurobHiv = row.getValue(20);
				nurobInduPe2 = row.getValue(21);
				nurobInduPit = row.getValue(22);
				nurobIolReason = row.getValue(23);
				nurobPosition = row.getValue(24);
				nurobAnesthesia = row.getValue(25);
				nurobDeliDate = row.getValue(26);
				nurobModeReason = row.getValue(27);
				nurobEpiRepair = row.getValue(28);
				nurobPlacenta = row.getValue(29);
				nurobLaboDura = row.getValue(30);
				nurobApgarFrom = row.getValue(31);
				nurobApgarTo = row.getValue(32);
				nurobSex = row.getValue(33);
				nurobWeight = row.getValue(34);
				nurobPostNatal = row.getValue(35);
				nurobNurAssistName = row.getValue(36);
				nurobNurCircName = row.getValue(37);
				
				// construct fields
				String[] nurobDeliDateTimeArray = splitDateTimeHourMins(nurobDeliDate);
				if (nurobDeliDateTimeArray.length > 0) nurobDeliDateDate = nurobDeliDateTimeArray[0];
				if (nurobDeliDateTimeArray.length > 1) nurobDeliDateTimeHour = nurobDeliDateTimeArray[1];
				if (nurobDeliDateTimeArray.length > 2) nurobDeliDateTimeMins = nurobDeliDateTimeArray[2];
				
				String[] nurobLaboDuraArray = parseMinsSec(nurobLaboDura);
				if (nurobLaboDuraArray.length > 0) nurobLaboDuraMins = nurobLaboDuraArray[0];
				if (nurobLaboDuraArray.length > 1) nurobLaboDuraSec = nurobLaboDuraArray[1];
				
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
	title = "function.nurob.dr." + commandType;
	
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

<form name="form1" id="form1" action="<html:rewrite page="/nurob/deliveryRoom.jsp" />" method="post">
<%	if (!createAction) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="10%">Ref. No.</td>
		<td class="infoData" width="20%"><%=nurobDeliRmId == null ? "" : nurobDeliRmId %></td>
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

		<td class="infoLabel" width="15%">Mother's Hosp. No.</td>
		<td class="infoData" width="35%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="nurobMoPatno" name="nurobMoPatno" value="<%=nurobMoPatno == null ? "" : nurobMoPatno %>" maxlength="10" size="15" />
	<%	} else { %>
			<%=nurobMoPatno == null ? "" : nurobMoPatno %>
<%	} %>
		</td>
		<td colspan="2">
			<table cellpadding="0" cellspacing="1" border="0">
				<tr>
					<td class="infoLabel" width="40%">Mother's Name</td>
					<td class="infoData" width="60%">
<%	if (createAction || updateAction) { %>
						<input type="text" name="nurobMoPatname" value="<%=nurobMoPatname == null ? "" : nurobMoPatname %>" maxlength="40" size="35" />
<%	} else { %>	
						<%=nurobMoPatname == null ? "" : nurobMoPatname %>
<%	} %>
					</td>
				</tr>
				<tr>
					<td class="infoLabel">Mother's Chinese Name<br />中文姓名</td>
					<td class="infoData">
<%	if (createAction || updateAction) { %>
						<input type="text" name="nurobMoPatcname" value="<%=nurobMoPatcname == null ? "" : nurobMoPatcname %>" maxlength="40" size="35" />
<%	} else { %>	
						<%=nurobMoPatcname == null ? "" : nurobMoPatcname %>
<%	} %>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Physician</td>
		<td class="infoData" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobPhysName" value="<%=nurobPhysName == null ? "" : nurobPhysName %>" maxlength="40" size="50" />
<%	} else { %>	
			<%=nurobPhysName == null ? "" : nurobPhysName %>
		</td>
<%	} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Age</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobAge" value="<%=nurobAge == null ? "" : nurobAge %>" maxlength="3" size="15" />
<%	} else { %>			
			<%=nurobAge == null ? "" : nurobAge %>
<%	} %>	
		</td>
		<td class="infoLabel" width="15%">Grav.</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobGrav" value="<%=nurobGrav == null ? "" : nurobGrav %>" maxlength="1" size="5" />
<%	} else { %>			
			<%=nurobGrav == null ? "" : nurobGrav %>
<%	} %>	
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Para.</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobPara" value="<%=nurobPara == null ? "" : nurobPara %>" maxlength="1" size="15" />
<%	} else { %>			
			<%=nurobPara == null ? "" : nurobPara %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">E.D.C</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobEdc" class="datepickerfield" value="<%=nurobEdc == null ? "" : nurobEdc %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
<%	} else { %>			
			<%=nurobEdc == null ? "" : nurobEdc %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Abnormal Maternal History</td>
		<td class="infoData" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="nurobAbnMatHis" rows="3" cols="90"><%=nurobAbnMatHis==null?"":nurobAbnMatHis %></textarea>
  			</div>
<%	} else { %>			
			<%=nurobAbnMatHis == null ? "" : nurobAbnMatHis %>
<%	} %>
  		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">ANC</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobAnc" value="<%=nurobAnc == null ? "" : nurobAnc %>" maxlength="1" size="15" />
<%	} else { %>			
			<%=nurobAnc == null ? "" : nurobAnc %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">O.P.D. Visits</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobOpdVisits" value="<%=nurobOpdVisits == null ? "" : nurobOpdVisits %>" maxlength="3" size="5" />
<%	} else { %>			
			<%=nurobOpdVisits == null ? "" : nurobOpdVisits %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Feed</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobFeed" value="<%=nurobFeed == null ? "" : nurobFeed %>" maxlength="2" size="15" />
<%	} else { %>			
			<%=nurobFeed == null ? "" : nurobFeed %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Rubella Titer</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobRubellaTiter" value="<%=nurobRubellaTiter == null ? "" : nurobRubellaTiter %>" maxlength="2" size="5" />
<%	} else { %>			
			<%=nurobRubellaTiter == null ? "" : nurobRubellaTiter %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="4">
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td class="infoLabel" width="15%">HBsAg</td>
					<td class="infoData" width="17%">
<%	if (createAction || updateAction) { %>
						<select name="nurobHbsag">
<jsp:include page="../ui/posNegCMB.jsp" flush="false">
	<jsp:param name="posNeg" value="<%=nurobHbsag %>" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
						</select>
<%	} else { %>			
						<%
							if ("Y".equals(nurobHbsag)) {
						%>
							Positive
						<%	
							} else if ("N".equals(nurobHbsag)) {
						%>
							Negative
						<%	
							}
						
						%>
<%	} %>
					</td>
					<td class="infoLabel" width="15%">VDRL</td>
					<td class="infoData" width="17%">
<%	if (createAction || updateAction) { %>
						<input type="text" name="nurobVdrl" value="<%=nurobVdrl == null ? "" : nurobVdrl %>" maxlength="2" size="5" />
<%	} else { %>			
						<%=nurobVdrl == null ? "" : nurobVdrl %>
<%	} %>	
					</td>
					<td class="infoLabel" width="15%">HIV</td>
					<td class="infoData" width="17%">
<%	if (createAction || updateAction) { %>
						<select name="nurobHiv">
<jsp:include page="../ui/posNegCMB.jsp" flush="false">
	<jsp:param name="posNeg" value="<%=nurobHbsag %>" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
						</select>
<%	} else { %>			
						<%
							if ("Y".equals(nurobHbsag)) {
						%>
							Positive
						<%	
							} else if ("N".equals(nurobHbsag)) {
						%>
							Negative
						<%	
							}
						
						%>
<%	} %>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Induction PE<sub>2</sub></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="nurobInduPe2">
				<option value=""></option>
				<option value="Y"<%="Y".equals(nurobInduPe2)?" selected":"" %>>YES</option>
				<option value="-"<%="-".equals(nurobInduPe2)?" selected":"" %>>---</option>
			</select>
<%	} else { %>			
			<%
				if ("-".equals(nurobInduPe2)) {
			%>
				---
			<%	
				} else if ("Y".equals(nurobInduPe2)) {
			%>
				YES
			<%	
				}
			
			%>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Induction PIT</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="nurobInduPit">
				<option value=""></option>
				<option value="Y"<%="Y".equals(nurobInduPit)?" selected":"" %>>YES</option>
				<option value="-"<%="-".equals(nurobInduPit)?" selected":"" %>>---</option>
			</select>
<%	} else { %>			
			<%
				if ("-".equals(nurobInduPit)) {
			%>
				---
			<%	
				} else if ("Y".equals(nurobInduPit)) {
			%>
				YES
			<%	
				}
			
			%>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Reason of IOL</td>
		<td class="infoData" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="nurobIolReason" rows="3" cols="90"><%=nurobIolReason==null?"":nurobIolReason %></textarea>
  			</div>
<%	} else { %>
			<%=nurobIolReason == null ? "" : nurobIolReason %>
<%	} %>
  		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Position</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobPosition" value="<%=nurobPosition == null ? "" : nurobPosition %>" maxlength="2" size="15" />
<%	} else { %>
			<%=nurobPosition == null ? "" : nurobPosition %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Anesthesia</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobAnesthesia" value="<%=nurobAnesthesia == null ? "" : nurobAnesthesia %>" maxlength="2" size="5" />
<%	} else { %>
			<%=nurobAnesthesia == null ? "" : nurobAnesthesia %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Delivery Date</td>
		<td class="infoData"" width="35%" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobDeliDateDate" id="nurobDeliDateDate" class="datepickerfield" value="<%=nurobDeliDateDate == null ? "" : nurobDeliDateDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
			-	
			<select name="nurobDeliDateTimeHour">
				<%
					for (int i = 0; i < 24; i++) {
						String hourCode = (i < 10 ? "0" + i : "" + i);
				%>
				<option value="<%=hourCode %>"<%=hourCode.equals(nurobDeliDateTimeHour)?" selected":"" %>><%=hourCode %></option>
				<%
					}
				%>
			</select>:
			<select name="nurobDeliDateTimeMins">
				<%
					for (int i = 0; i < 60; i++) {
						String minsCode = (i < 10 ? "0" + i : "" + i);
				%>
				<option value="<%=minsCode %>"<%=minsCode.equals(nurobDeliDateTimeMins)?" selected":"" %>><%=minsCode %></option>
				<%
					}
				%>
			</select> (hour:minute)
<%	} else { %>
			<%=nurobDeliDateDate == null ? "" : nurobDeliDateDate %> <%=nurobDeliDateTimeHour == null ? "" : nurobDeliDateTimeHour %>:<%=nurobDeliDateTimeMins == null ? "" : nurobDeliDateTimeMins %>
<%	} %>


		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Mode & Reason of Delivery</td>
		<td class="infoData" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>  	 
			<div class="box" >
  				<textarea name="nurobModeReason" rows="3" cols="90"><%=nurobModeReason==null?"":nurobModeReason %></textarea>
  			</div>
<%	} else { %>
			<%=nurobModeReason == null ? "" : nurobModeReason %>
<%	} %>
  		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Episiotomy & Repair</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobEpiRepair" value="<%=nurobEpiRepair == null ? "" : nurobEpiRepair %>" maxlength="20" size="15" />
<%	} else { %>
			<%=nurobEpiRepair == null ? "" : nurobEpiRepair %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Placenta</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobPlacenta" value="<%=nurobPlacenta == null ? "" : nurobPlacenta %>" maxlength="20" size="10" />
<%	} else { %>
			<%=nurobPlacenta == null ? "" : nurobPlacenta %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Labour Duration</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobLaboDuraMins" value="<%=nurobLaboDuraMins == null ? "" : nurobLaboDuraMins %>" maxlength="5" size="1" /> Mins
			<input type="text" name="nurobLaboDuraSec" value="<%=nurobLaboDuraSec == null ? "" : nurobLaboDuraSec %>" maxlength="2" size="1" /> Seconds
<%	} else { %>
			<%=nurobLaboDuraMins == null ? "" : nurobLaboDuraMins %>mins <%=nurobLaboDuraSec == null ? "" : nurobLaboDuraSec %>sec
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Apgar</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobApgarFrom" value="<%=nurobApgarFrom == null ? "" : nurobApgarFrom %>" maxlength="2" size="1" /> - 
			<input type="text" name="nurobApgarTo" value="<%=nurobApgarTo == null ? "" : nurobApgarTo %>" maxlength="2" size="1" />
<%	} else { %>
			<%=nurobApgarFrom == null ? "" : nurobApgarFrom %> - <%=nurobApgarTo == null ? "" : nurobApgarTo %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Sex</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="nurobSex">
<jsp:include page="../ui/sexCMB.jsp" flush="false">
	<jsp:param name="sex" value="<%=nurobSex %>" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
<%	} else { %>
			<%=nurobApgarFrom == null ? "" : nurobApgarFrom %> - <%=nurobApgarTo == null ? "" : nurobApgarTo %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Weight</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobWeight" value="<%=nurobWeight == null ? "" : nurobWeight %>" maxlength="4" size="5" />
<%	} else { %>
			<%=nurobWeight == null ? "" : nurobWeight %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Post-natal Complication & Condition of Baby</td>
		<td class="infoData" width="70%" colspan="3">  	
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="nurobPostNatal" rows="3" cols="90"><%if(!createAction){ %><%=nurobPostNatal==null?"":nurobPostNatal %><%} %></textarea>
  			</div>
<%	} else { %>
			<%=nurobPostNatal == null ? "" : nurobPostNatal %>
<%	} %>
  		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Nurses Assist</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobNurAssistName" value="<%=nurobNurAssistName == null ? "" : nurobNurAssistName %>" maxlength="20" size="18" />
<%	} else { %>
			<%=nurobNurAssistName == null ? "" : nurobNurAssistName %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Nurses Circ.</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="nurobNurCircName" value="<%=nurobNurCircName == null ? "" : nurobNurCircName %>" maxlength="20" size="18" />
<%	} else { %>
			<%=nurobNurCircName == null ? "" : nurobNurCircName %>
<%	} %>
		</td>
	</tr>
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
<input type="hidden" name="nurobDeliRmId" value="<%=nurobDeliRmId %>" />


<!-- reserved fields -->
<input type="hidden" name="nurobMoPatfname" value="<%=nurobMoPatfname %>" />
<input type="hidden" name="nurobMoPatgname" value="<%=nurobMoPatgname %>" />
<input type="hidden" name="nurobPhysStaffId" value="<%=nurobPhysStaffId %>" />

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
			if (document.form1.nurobDeliDateDate.value == '') {
				alert("Please input Delivery Date.");
				document.form1.nurobDeliDateDate.focus();
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