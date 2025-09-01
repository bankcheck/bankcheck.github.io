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

//derived fields
String nurobDeliDateDate = request.getParameter("nurobDeliDateDate");
String nurobDeliDateTimeHour = request.getParameter("nurobDeliDateTimeHour");
String nurobDeliDateTimeMins = request.getParameter("nurobDeliDateTimeMins");

String nurobLaboDuraMins = request.getParameter("nurobLaboDuraMins");
String nurobLaboDuraSec = request.getParameter("nurobLaboDuraSec");


// bld_mrsa_esbl
String ICSiteCode = TextUtil.parseStrUTF8(request.getParameter("ICSiteCode"));
String CaseNum = TextUtil.parseStrUTF8(request.getParameter("CaseNum"));
String CaseDate = TextUtil.parseStrUTF8(request.getParameter("CaseDate"));
String LabNum = TextUtil.parseStrUTF8(request.getParameter("LabNum"));
String HospNum = TextUtil.parseStrUTF8(request.getParameter("HospNum"));
String PatName = TextUtil.parseStrUTF8(request.getParameter("PatName"));
String PatSex = TextUtil.parseStrUTF8(request.getParameter("PatSex"));
String PatBDate = TextUtil.parseStrUTF8(request.getParameter("PatBDate"));
String Age = TextUtil.parseStrUTF8(request.getParameter("Age"));
String Month = TextUtil.parseStrUTF8(request.getParameter("Month"));
String Ward = TextUtil.parseStrUTF8(request.getParameter("Ward"));
String RoomNum = TextUtil.parseStrUTF8(request.getParameter("RoomNum"));
String BedNum = TextUtil.parseStrUTF8(request.getParameter("BedNum"));
String DateIn = TextUtil.parseStrUTF8(request.getParameter("DateIn"));
String REC_DATE = TextUtil.parseStrUTF8(request.getParameter("REC_DATE"));
String TEMP = TextUtil.parseStrUTF8(request.getParameter("TEMP"));
String WBC = TextUtil.parseStrUTF8(request.getParameter("WBC"));
String BP = TextUtil.parseStrUTF8(request.getParameter("BP"));
String UO = TextUtil.parseStrUTF8(request.getParameter("UO"));
String VENT_FIO2 = TextUtil.parseStrUTF8(request.getParameter("VENT_FIO2"));
String CXR = TextUtil.parseStrUTF8(request.getParameter("CXR"));
String RESP_SS = TextUtil.parseStrUTF8(request.getParameter("RESP_SS"));
String PROGRESS = TextUtil.parseStrUTF8(request.getParameter("PROGRESS"));
String ANTIBIOTICS = TextUtil.parseStrUTF8(request.getParameter("ANTIBIOTICS"));
String LAB_RESULT = TextUtil.parseStrUTF8(request.getParameter("LAB_RESULT"));

String icType = request.getParameter("icType");

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
//		nurobDeliDate = joinDateTime(nurobDeliDateDate, nurobDeliDateTimeHour, nurobDeliDateTimeMins);
//		nurobLaboDura = convertMinsSec(nurobLaboDuraMins, nurobLaboDuraSec);
		
		if (createAction) {
			
			CaseNum = ICIcuDailyDB.add(
					userBean, 
					"icu_d", 
					CaseDate, 
					LabNum, 
					HospNum, 
					PatName, 
					PatSex,
					PatBDate, 
					Age, 
					Month,
					Ward,
					RoomNum, BedNum, 
					DateIn,
					REC_DATE, TEMP, WBC, BP, UO,
					VENT_FIO2, CXR, RESP_SS, PROGRESS, ANTIBIOTICS, LAB_RESULT					
				);
			//, BodySystem, IsolateOrgan, Phx, PhxOther, ClinicalInfo
			if (CaseNum != null) {
				message = "ICU Daily created.";
				createAction = false;
				step = null;
			} else {
				errorMessage = "ICU Daily create fail.";
			}
		} else if (updateAction) {
			
			boolean success = false; 
			if (CaseNum != null) {
				
				System.out.println(icType);
				
				success = ICIcuDailyDB.update(  
								userBean,
								CaseDate, LabNum, 
								HospNum, PatName, PatSex, PatBDate,
								Age, Month, Ward, RoomNum, 
								BedNum, DateIn,	
								REC_DATE, TEMP, WBC, BP, UO,
								VENT_FIO2, CXR, RESP_SS, PROGRESS, ANTIBIOTICS, LAB_RESULT,
								"icu_d", CaseNum
							);
			}

			if (success) {	// do update
				message = "ICU Daily updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "ICU Daily update fail.";
			}		
		
		} else if (deleteAction) {
			boolean success = ICIcuDailyDB.delete(userBean, CaseNum ); 
			
			if (success) {	
				message = "ICU Daily removed.";
				closeAction = true;
			} else {
				errorMessage = "ICU Daily remove fail.";
			}
		}
	} else if (createAction) {
		// start new record for insert
		nurobDeliDateDate = DateTimeUtil.getCurrentDate();
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (CaseNum != null && CaseNum.length() > 0) {
			ArrayList record = ICIcuDailyDB.get(CaseNum);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
		
				CaseNum = row.getValue(1);
				CaseDate = row.getValue(2);
				LabNum = row.getValue(3);
				HospNum = row.getValue(4);				
				PatName = row.getValue(5);
				PatSex = row.getValue(6);				
				PatBDate = row.getValue(7);
				Age = row.getValue(8);
				Month = row.getValue(9);
				Ward = row.getValue(10);
				RoomNum = row.getValue(11);
				BedNum = row.getValue(12); 
				DateIn = row.getValue(13);
				REC_DATE = row.getValue(14);
				TEMP = row.getValue(15);
				WBC = row.getValue(16);
				BP = row.getValue(17);
				UO = row.getValue(18);
				VENT_FIO2 = row.getValue(19);
				CXR = row.getValue(20);
				RESP_SS = row.getValue(21);
				PROGRESS = row.getValue(22);
				ANTIBIOTICS = row.getValue(23);
				LAB_RESULT = row.getValue(24);
				
				//System.out.println("debug get method " + Source + " " + CaseDefine + " " + Status + " " + BodySystem);			
			} else {
				message = "ICU Daily record does not exist.";
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
<div id=indexWrapper>
<div id=mainFrame> 
<div id=contentFrame>
<%
	String title = null;
	String pageTitle = null;
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
	
	System.out.println("Hello !!! " + icType + " " + commandType );
	// set submit label
	title = "function.ic.ge_resp." + commandType;
	if ("icu_daily".equals(icType)) {
		pageTitle = "ICU (Daily Progress)";
	} else if ("resp".equals(icType)) {
		pageTitle = "RESP";
	} else {
		pageTitle = "Error Title passing !";
	}
	
	String accessControl = "Y";
	if (ConstantsServerSide.DEBUG) {
		accessControl = "N";
	} 
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="mustLogin" value="<%=mustLogin %>" />
	<jsp:param name="accessControl" value="<%=accessControl %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<% if (!closeAction) { %>
<form name="form1" id="form1" action="<html:rewrite page="/ic/icu_daily.jsp" />" method="post">
<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
	<%	if (createAction || updateAction || deleteAction) { %>
				<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /></button>
	<%		if (!createAction) { %>
				<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
	<%		}  %>
	<%	} else { %>
				<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="button.update" /></button>
				<button class="btn-delete"><bean:message key="button.delete" /></button>
	<%	}  %>
			</td>
		</tr>
	</table>
</div>
<%	//if (!createAction) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="10%">Case No.</td>
		<td class="infoData" width="20%"><%=CaseNum == null ? "" : (createAction ? "New" : CaseNum) %></td>
	<td class="infoLabel" width="15%">Hosp. Adm. Date</td>
		<td class="infoData"" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="text" name="CaseDate" id="CaseDate" class="datepickerfield" value="<%=CaseDate == null ? "" : CaseDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)			
<%	} else { %>
			<%=CaseDate == null ? "" : CaseDate %>
<%	} %>
    </td>
	</tr>
</table>
<% //} %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%">Lab No.</td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="LabNum" name="LabNum" value="<%=LabNum == null ? "" : LabNum %>" maxlength="8" size="15" />
	<%	} else { %>
			<%=LabNum == null ? "" : LabNum %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Reg Date</td>
		<td class="infoData"" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<span id="DateIn_span"><%=DateIn == null ? "" : DateIn %></span>
<%	} else { %>
			<%=DateIn == null ? "" : DateIn %>
<%	} %></td>	
	</tr>
	<tr>		
		<td class="infoLabel" width="15%">Hosp. No.</td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<span id="HospNum_span"><%=HospNum == null ? "" : HospNum %></span>
	<%	} else { %>
			<%=HospNum == null ? "" : HospNum %>
<%	} %>
		</td>		
		<td class="infoLabel" width="10%">Patient Name</td>
		<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<span id="PatName_span"><%=PatName == null ? "" : PatName %></span>
	<%	} else { %>
			<%=PatName == null ? "" : PatName %>
<%	} %>    
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Gender</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="PatSex_span"><%=PatSex == null ? "" : PatSex %></span>
	<%	} else { %>
			<%=PatSex == null ? "" : PatSex %>
<%	} %>    
		</td>
		<td class="infoLabel" width="15%">Birthdate</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="PatBDate_span"><%=PatBDate == null ? "" : PatBDate %></span>
<%	} else { %>
			<%=PatBDate == null ? "" : PatBDate %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Age</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="Age_span"><%=Age == null ? "" : Age %></span>
<%	} else { %>
			<%=Age == null ? "" : Age %>
<%	} %>
		</td>		
		<td class="infoLabel" width="15%">Month</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="Month_span"><%=Month == null ? "" : Month %></span>
<%	} else { %>
			<%=Month == null ? "" : Month %>
<%	} %>
		</td>		
	</tr>
	<tr>
		<td class="infoLabel" width="15%">Ward</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="Ward_span"><%=Ward == null ? "" : Ward %></span>
<%	} else { %>
			<%=Ward == null ? "" : Ward %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">RoomNum</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="RoomNum_span"><%=RoomNum == null ? "" : RoomNum %></span>
<%	} else { %>
			<%=RoomNum == null ? "" : RoomNum %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">BedNum</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="BedNum_span"><%=BedNum == null ? "" : BedNum %></span>
<%	} else { %>
			<%=BedNum == null ? "" : BedNum %>
<%	} %>
		</td>
	</tr>
	
  <tr><td>
  <input type="hidden" id="HospNum" name="HospNum" value="<%=HospNum == null ? "" : HospNum %>" maxlength="12" size="15" />
  <input type="hidden" id="PatName" name="PatName" value="<%=PatName == null ? "" : PatName %>" maxlength="100" size="15" />
  <input type="hidden" id="PatSex" name="PatSex" value="<%=PatSex == null ? "" : PatSex %>" maxlength="100" size="15" />
  <input type="hidden" id="PatBDate" name="PatBDate" value="<%=PatBDate == null ? "" : PatBDate %>" maxlength="100" size="15" />  
  <input type="hidden" id="Age" name="Age" value="<%=Age == null ? "" : Age %>" maxlength="100" size="15" />
  <input type="hidden" id="Month" name="Month" value="<%=Month == null ? "" : Month %>" maxlength="100" size="15" />    
  <input type="hidden" id="Ward" name="Ward" value="<%=Ward == null ? "" : Ward %>" maxlength="100" size="15" />					
  <input type="hidden" id="RoomNum" name="RoomNum" value="<%=RoomNum == null ? "" : RoomNum %>" maxlength="100" size="15" />		 
  <input type="hidden" id="BedNum" name="BedNum" value="<%=BedNum == null ? "" : BedNum %>" maxlength="100" size="15" />			 
  <input type="hidden" id="DateIn" name="DateIn" value="<%=DateIn == null ? "" : DateIn %>" maxlength="100" size="15" />
  <input type="hidden" name="icType" value="<%=icType %>" />			
  </td></tr> 
  
</table>

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
    <tr>
	<td class="infoLabel" width="10%">Date</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="REC_DATE" id="REC_DATE" class="datepickerfield" value="<%=REC_DATE == null ? "" : REC_DATE %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)			
<%	} else { %>
			<%=REC_DATE == null ? "" : REC_DATE %>
<%	} %>
    </td>
	<td class="infoLabel" width="10%">Temp</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="TEMP" name="TEMP" value="<%=TEMP == null ? "" : TEMP %>" maxlength="10" size="15" />
	<%	} else { %>
			<%=TEMP == null ? "" : TEMP %>
<%	} %>
	</td>
	<td class="infoLabel" width="10%">WBC</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="WBC" name="WBC" value="<%=WBC == null ? "" : WBC %>" maxlength="10" size="15" />
	<%	} else { %>
			<%=WBC == null ? "" : WBC %>
<%	} %>
	</td>
	<td class="infoLabel" width="10%">BP</td>
		<td class="infoData" width="10%">
		<%	if (createAction || updateAction) { %>
			<select name="icType">
				<option value="N"<%="N".equals(BP)?" selected":"" %>>Normal</option>
				<option value="L"<%="L".equals(BP)?" selected":"" %>>SBP&lt;90</option>				
				<option value="I"<%="I".equals(BP)?" selected":"" %>>with Inotrope support</option>				
			</select>
		<%	} else { %>
			<%
				if ("N".equals(BP)) {
			%>
				Normal
			<%	
				} else if ("L".equals(BP)) {
			%>
				SBP&lt;90
			<%
				} else if ("I".equals(BP)) {
			%>
				with Inotrope support
			<%
				}
			%>
		<%	} %>
		</td>

	<td class="infoLabel" width="10%">UO</td>
		<td class="infoData" width="10%">
		<%	if (createAction || updateAction) { %>
			<select name="icType">
				<option value="N"<%="N".equals(UO)?" selected":"" %>>Normal</option>
				<option value="L"<%="L".equals(UO)?" selected":"" %>>UO&lt;20cc/hr</option>				
				<option value="F"<%="F".equals(UO)?" selected":"" %>>renal failure &lt;100ml/12hrs</option>				
			</select>
		<%	} else { %>
			<%
				if ("N".equals(UO)) {
			%>
				Normal
			<%	
				} else if ("L".equals(UO)) {
			%>
				UO &lt;20cc/hr
			<%
				} else if ("F".equals(UO)) {
			%>
				renal failure &lt;100ml/12hrs
			<%
				}
			%>
		<%	} %>
		</td>
	</tr>
	<tr>
	<td class="infoLabel" width="10%">Vent/FiO2</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
	<div class="box" >
		<textarea name="VENT_FIO2" rows="3" cols="50"><%=VENT_FIO2==null?"":VENT_FIO2 %></textarea>
	</div>
<%	} else { %>			
			<%=VENT_FIO2 == null ? "" : VENT_FIO2 %>
<%	} %>
	</td>		
	<td class="infoLabel" width="10%">CXR</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
	<div class="box" >
		<textarea name="CXR" rows="3" cols="50"><%=CXR==null?"":CXR %></textarea>
	</div>
<%	} else { %>			
			<%=CXR == null ? "" : CXR %>
<%	} %>
	</td>
	</tr>
	<tr>	
	<td class="infoLabel" width="10%">Resp S/S</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="RESP_SS" name="RESP_SS" value="<%=RESP_SS == null ? "" : RESP_SS %>" maxlength="20" size="40" />
	<%	} else { %>
			<%=RESP_SS == null ? "" : RESP_SS %>
<%	} %>
	</td>	
	</tr>
	<tr>
	<td class="infoLabel" width="10%">Progress</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
	<div class="box" >
		<textarea name="PROGRESS" rows="3" cols="50"><%=PROGRESS==null?"":PROGRESS %></textarea>
	</div>
<%	} else { %>			
			<%=PROGRESS == null ? "" : PROGRESS %>
<%	} %>
	</td>
	</tr>
	</tr>
	<tr>
	<td class="infoLabel" width="10%">Antibiotics</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
	<div class="box" >
		<textarea name="ANTIBIOTICS" rows="3" cols="50"><%=ANTIBIOTICS==null?"":ANTIBIOTICS %></textarea>
	</div>
<%	} else { %>			
			<%=ANTIBIOTICS == null ? "" : ANTIBIOTICS %>
<%	} %>
	</td>
	<td class="infoLabel" width="10%">Lab Result</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
	<div class="box" >
		<textarea name="LAB_RESULT" rows="3" cols="50"><%=LAB_RESULT==null?"":LAB_RESULT %></textarea>
	</div>
<%	} else { %>			
			<%=LAB_RESULT == null ? "" : LAB_RESULT %>
<%	} %>
	</td>	
	</tr>
	
	
	
</table>

<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
	<%	if (createAction || updateAction || deleteAction) { %>
				<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /></button>
	<%		if (!createAction) { %>
				<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
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
<input type="hidden" name="CaseNum" value="<%=CaseNum %>" />

</form>


<% } %>
<script language="javascript">
$(document).ready(function() {
	<%	if (createAction || updateAction) { %>
		$("textarea[name=VENT_FIO2]").supertextarea({
			maxl: 48,
			tabr: {use: false}
		});
		$("textarea[name=CXR]").supertextarea({
			maxl: 48,
			tabr: {use: false}
		});
		$("textarea[name=PROGRESS]").supertextarea({
			maxl: 98,
			tabr: {use: false}
		});
		$("textarea[name=ANTIBIOTICS]").supertextarea({
			maxl: 98,
			tabr: {use: false}
		});		
		$("textarea[name=LAB_RESULT]").supertextarea({
			maxl: 98,
			tabr: {use: false}
		});
		
		$("#form1").validate({

		});
	<%	} %>
	$('input[name=LabNum]').change(function() {
		var temp = this.id.split('_');
		loadLabInfo(this.value, temp[1]);
	});
});

function loadLabInfo(labNum, rowNum) {
var param = {
	labNum:	labNum,
	command: '<%=command %>'
};
$.getJSON('getPatInfoByLabNum.jsp', param, function(data) {
	var items = [];
	$.each(data, function(key, val) {
		var id_span = '#' + key + "_span";
		var id = '#' + key;
		$(id).val(val);
		$(id_span).html(val);		
	});
});
}

function submitAction(cmd, stp) {
	if (stp == 1) {
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.LabNum.value == '') {
				alert("Please input Lab No.");
				document.form1.LabNum.focus();
				return false;
			}
		}
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.CaseDate.value == '') {
				alert("Please input Hosp. Adm. Date");
				document.form1.CaseDate.focus();
				return false;
			}
		}		
	}
	document.form1.command.value = cmd;
	document.form1.step.value = stp;
	document.form1.submit();
}
</script>

</div>
</div></div>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>