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
String Source = TextUtil.parseStrUTF8(request.getParameter("Source"));
String CaseDefine = TextUtil.parseStrUTF8(request.getParameter("CaseDefine"));
String Status = TextUtil.parseStrUTF8(request.getParameter("Status")); 
String BodySystem = TextUtil.parseStrUTF8(request.getParameter("BodySystem"));
String IsolateOrgan = TextUtil.parseStrUTF8(request.getParameter("IsolateOrgan"));
String Phx = TextUtil.parseStrUTF8(request.getParameter("Phx"));
String PhxOther = TextUtil.parseStrUTF8(request.getParameter("PhxOther"));
String ClinicalInfo = TextUtil.parseStrUTF8(request.getParameter("ClinicalInfo"));
String BpP = TextUtil.parseStrUTF8(request.getParameter("BpP"));
String BpPTemp = TextUtil.parseStrUTF8(request.getParameter("BpPTemp"));
String ISOLATE = TextUtil.parseStrUTF8(request.getParameter("ISOLATE"));
String STD_PRECAUTION = TextUtil.parseStrUTF8(request.getParameter("STD_PRECAUTION"));
String TRANDATE = TextUtil.parseStrUTF8(request.getParameter("TRANDATE"));
String TRANSFER = TextUtil.parseStrUTF8(request.getParameter("TRANSFER"));
String Wcc = TextUtil.parseStrUTF8(request.getParameter("Wcc"));
String WccN = TextUtil.parseStrUTF8(request.getParameter("WccN"));
String WccL = TextUtil.parseStrUTF8(request.getParameter("WccL"));
String Device = TextUtil.parseStrUTF8(request.getParameter("Device"));
String IVCatheter = TextUtil.parseStrUTF8(request.getParameter("IVCatheter"));
String IVCatheterOther = TextUtil.parseStrUTF8(request.getParameter("IVCatheterOther"));
String Proc = TextUtil.parseStrUTF8(request.getParameter("Proc"));
String ChestSign = TextUtil.parseStrUTF8(request.getParameter("ChestSign"));
String IVSite = TextUtil.parseStrUTF8(request.getParameter("IVSite"));
String IVSiteOther = TextUtil.parseStrUTF8(request.getParameter("IVSiteOther"));
String Urinary = TextUtil.parseStrUTF8(request.getParameter("Urinary"));
String UrinaryOther = TextUtil.parseStrUTF8(request.getParameter("UrinaryOther"));
String OtherPhySign = TextUtil.parseStrUTF8(request.getParameter("OtherPhySign"));
String Antibiotics = TextUtil.parseStrUTF8(request.getParameter("Antibiotics"));
String FinalDisp = TextUtil.parseStrUTF8(request.getParameter("FinalDisp"));
String TransferTo = TextUtil.parseStrUTF8(request.getParameter("TransferTo"));
String HospDefine = TextUtil.parseStrUTF8(request.getParameter("HospDefine"));
String AdmissionCO = TextUtil.parseStrUTF8(request.getParameter("AdmissionCO"));
String DeviceMrsaEsbl = TextUtil.parseStrUTF8(request.getParameter("DeviceMrsaEsbl"));
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
			
			CaseNum = ICBldMrsaEsblDB.add(
					userBean,
					icType, 
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
					Source, CaseDefine,
					Status, BodySystem, IsolateOrgan, Phx, PhxOther, ClinicalInfo,
					BpP, BpPTemp, ISOLATE, STD_PRECAUTION, TRANDATE, TRANSFER, Wcc, WccN, WccL,
					Device, IVCatheter, IVCatheterOther, Proc, ChestSign,
					IVSite, IVSiteOther, Urinary, 
					OtherPhySign, Antibiotics, FinalDisp, TransferTo,
					HospDefine, AdmissionCO, DeviceMrsaEsbl, UrinaryOther
				);
			//, BodySystem, IsolateOrgan, Phx, PhxOther, ClinicalInfo
			if (CaseNum != null) {
				message = "Blood Culture created.";
				createAction = false;
				step = null;
			} else {
				errorMessage = "Blood Culture create fail.";
			}
		} else if (updateAction) {
			
			boolean success = false; 
			if (CaseNum != null) {
				success = ICBldMrsaEsblDB.update(
								userBean,
								CaseDate, LabNum, HospNum, PatName, PatSex, 
								PatBDate,
								Age, Month, Ward, RoomNum, BedNum, 
								DateIn, 
								Source, CaseDefine, Status, BodySystem, 
								IsolateOrgan, Phx, PhxOther, ClinicalInfo, 
								BpP, BpPTemp, ISOLATE, STD_PRECAUTION, TRANDATE, TRANSFER, Wcc, WccN, WccL,
								Device, IVCatheter, IVCatheterOther, Proc, ChestSign,
								IVSite, IVSiteOther, Urinary, OtherPhySign, 
								Antibiotics, FinalDisp, TransferTo, HospDefine, AdmissionCO, DeviceMrsaEsbl,
								UrinaryOther, icType,
								CaseNum
							);
			}

			if (success) {	// do update
				message = "Blood Culture updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "Blood Cultureupdate fail.";
			}		
		
		} else if (deleteAction) {
			boolean success = ICBldMrsaEsblDB.delete(userBean, CaseNum ); 
			
			if (success) {	
				message = "Blood Culture removed.";
				closeAction = true;
			} else {
				errorMessage = "Blood Culture remove fail.";
			}
		}
	} else if (createAction) {
		// start new record for insert
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (CaseNum != null && CaseNum.length() > 0) {
			ArrayList record = ICBldMrsaEsblDB.get(CaseNum);
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
				Source = row.getValue(14);
				CaseDefine = row.getValue(15);
				Status = row.getValue(16); 
				BodySystem = row.getValue(17);				
				IsolateOrgan = row.getValue(18);				
				Phx = row.getValue(19);
				PhxOther = row.getValue(20);
				ClinicalInfo = row.getValue(21);
				BpP = row.getValue(22);
				BpPTemp = row.getValue(23);
				Wcc = row.getValue(24);
				WccN = row.getValue(25);
				WccL = row.getValue(26);
				Device = row.getValue(27);
				IVCatheter = row.getValue(28);
				IVCatheterOther = row.getValue(29);
				Proc = row.getValue(30);
				ChestSign = row.getValue(31);
				IVSite = row.getValue(32);
				IVSiteOther = row.getValue(33);
				Urinary = row.getValue(34);
				OtherPhySign = row.getValue(35);		
				Antibiotics = row.getValue(36);
				FinalDisp = row.getValue(37);
				TransferTo = row.getValue(38);
				HospDefine = row.getValue(39);
				AdmissionCO = row.getValue(40);
				DeviceMrsaEsbl = row.getValue(41); 
				UrinaryOther = row.getValue(42);
				icType = row.getValue(43);
				ISOLATE = row.getValue(44);
				STD_PRECAUTION = row.getValue(45);
				TRANDATE = row.getValue(46);
				TRANSFER = row.getValue(47);
				System.out.println("call twice ? " + icType);
			} else {
				message = "Bld/MRSA/ESBL record does not exist.";
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
	
	//System.out.println("Hello !!! " + icType + " " + commandType );
	// set submit label
	title = "function.ic.bld_mrsa_esbl." + commandType;
	if ("bld".equals(icType)) {
		pageTitle = "Blood Culture";
	} else if ("mrsa".equals(icType)) {
		pageTitle = "MDRO MRSA/CA-MRSA/ESBL/Others";
	} else if ("cmrsa".equals(icType)) {
		pageTitle = "MDRO MRSA/CA-MRSA/ESBL/Others";
	} else if ("esbl".equals(icType)) {
		pageTitle = "MDRO MRSA/CA-MRSA/ESBL/Others";
	} else if ("other".equals(icType)) {
		pageTitle = "MDRO MRSA/CA-MRSA/ESBL/Others";				
	} else {
		pageTitle = "Good ah !";
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
<form name="form1" id="form1" action="<html:rewrite page="/ic/bld_mrsa_esbl.jsp" />" method="post">
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
	<td class="infoLabel" width="15%">Case Date</td>
		<td class="infoData"" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="text" name="CaseDate" id="CaseDate" class="datepickerfield" value="<%=CaseDate == null ? "" : CaseDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)			
<%	} else { %>
			<%=CaseDate == null ? "" : CaseDate %>
<%	} %>
    </td>

<% if (! "bld".equals(icType)) { %>
	<td class="infoLabel" width="15%">IC  Type</td>
		<td class="infoData" width="17%">
		<%	if (createAction || updateAction) { %>
			<select name="icType">
				<option value="mrsa"<%="mrsa".equals(icType)?" selected":"" %>>MRSA</option>
				<option value="cmrsa"<%="cmrsa".equals(icType)?" selected":"" %>>CA-MRSA</option>
				<option value="esbl"<%="esbl".equals(icType)?" selected":"" %>>ESBL</option>				
				<option value="other"<%="other".equals(icType)?" selected":"" %>>OTHERS</option>				
			</select>
		<%	} else { %>
			<%
				if ("mrsa".equals(icType)) {
			%>
				MRSA
			<%	
				} else if ("cmrsa".equals(icType)) {
			%>
				CA-MRSA
			<%
				} else if ("esbl".equals(icType)) {
			%>
				ESBL
			<%
				} else if ("other".equals(icType)) {
			%>
				Others
			<%	
				}
			%>
		<%	} %>
		</td>
<% } %>    
    
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
<% if ("mrsa".equals(icType) || "esbl".equals(icType)) { %>
	
		<tr>
			<td class="infoLabel" width="15%">Hospital Definition</td>
			<td class="infoData" width="17%">
		<%	if (createAction || updateAction) { %>
			<select name="HospDefine">
				<option value=""></option>
				<option value="N"<%="N".equals(HospDefine)?" selected":"" %>>New Case</option>
				<option value="O"<%="O".equals(HospDefine)?" selected":"" %>>Old Case</option>
			</select>
		<%	} else { %>
		<%
			if ("N".equals(HospDefine)) {
		%>
			New Case
		<%	
			} else if ("O".equals(HospDefine)) {
		%>
			Old Case
		<%	
			}
		%>
		<%	} %>
		</td>
		  </tr>
<%} %> 
	
	<tr>
		<td class="infoLabel" width="15%">Source</td>
		<td class="infoData" width="17%">
<%	if (createAction || updateAction) { %>
		<select name="Source">
			<option value=""></option>
			<option value="H"<%="H".equals(Source)?" selected":"" %>>Home</option>
			<option value="O"<%="O".equals(Source)?" selected":"" %>>OAH</option>					
			<option value="T"<%="T".equals(Source)?" selected":"" %>>Other Hospital</option>			
		</select>
<%	} else { %>			
	<%
		if ("H".equals(Source)) {
	%>
		Home
	<%	
		} else if ("O".equals(Source)) {
	%>
		OAH
	<%	
		} else if ("T".equals(Source)) {
	%>
		Other Hospital		
	<%	
		}	
	%>
<%	} %>
	</td>
		<td class="infoLabel" width="15%">Case Definition</td>
		<td class="infoData" width="17%">
<%	if (createAction || updateAction) { %>
		<select name="CaseDefine">
			<option value=""></option>
			<option value="N"<%="N".equals(CaseDefine)?" selected":"" %>>Nosocomial</option>
			<option value="C"<%="C".equals(CaseDefine)?" selected":"" %>>Community</option>					
			<option value="U"<%="U".equals(CaseDefine)?" selected":"" %>>Unknown</option>			
		</select>
<%	} else { %>			
	<%
		if ("N".equals(CaseDefine)) {
	%>
		Nosocomial
	<%	
		} else if ("C".equals(CaseDefine)) {
	%>
		Community
	<%	
		} else if ("U".equals(CaseDefine)) {
	%>
		Unknown		
	<%	
		}	
	%>
<%	} %>
	</td>
		<td class="infoLabel" width="15%">Status</td>
		<td class="infoData" width="17%">
<%	if (createAction || updateAction) { %>
		<select name="Status">
			<option value=""></option>
			<option value="I"<%="I".equals(Status)?" selected":"" %>>Infection</option>
			<option value="C"<%="C".equals(Status)?" selected":"" %>>Colonization</option>					
			<option value="O"<%="O".equals(Status)?" selected":"" %>>Contamination</option>			
		</select>
<%	} else { %>			
	<%
		if ("I".equals(Status)) {
	%>
		Infection
	<%	
		} else if ("C".equals(Status)) {
	%>
		Colonization
	<%	
		} else if ("O".equals(Status)) {
	%>
		Contamination		
	<%	
		}	
	%>
<%	} %>

<% if ("bld".equals(icType)) { %>

   </td>
   		<td class="infoLabel" width="15%">Body System</td>
		<td class="infoData" width="17%">
<%	if (createAction || updateAction) { %>
		<select name="BodySystem">
			<option value=""></option>
			<option value="UTI"<%="UTI".equals(BodySystem)?" selected":"" %>>UTI</option>
			<option value="SSI"<%="SSI".equals(BodySystem)?" selected":"" %>>SSI</option>					
			<option value="PNEU"<%="PNEU".equals(BodySystem)?" selected":"" %>>PNEU</option>			
			<option value="BSI"<%="BSI".equals(BodySystem)?" selected":"" %>>BSI</option>			
			<option value="BJ"<%="BJ".equals(BodySystem)?" selected":"" %>>BJ</option>			
			<option value="CNS"<%="CNS".equals(BodySystem)?" selected":"" %>>CNS</option>			
			<option value="GI"<%="GI".equals(BodySystem)?" selected":"" %>>GI</option>			
			<option value="LRTI"<%="LRTI".equals(BodySystem)?" selected":"" %>>LRTI</option>			
			<option value="SST"<%="SST".equals(BodySystem)?" selected":"" %>>SST</option>
		</select>
<%	} else { %>			
	<%
		if ("UTI".equals(BodySystem)) {
	%>
		UTI
	<%	
		} else if ("SSI".equals(BodySystem)) {
	%>
		SSI
	<%	
		} else if ("PNEU".equals(BodySystem)) {
	%>
		PNEU
	<%	
		} else if ("BSI".equals(BodySystem)) {
	%>
		BSI
	<%	
		} else if ("BJ".equals(BodySystem)) {
	%>
		BJ		
	<%	
		} else if ("CNS".equals(BodySystem)) {
	%>
		CNS		
	<%	
		} else if ("GI".equals(BodySystem)) {
	%>
		GI		
	<%	
		} else if ("LRTI".equals(BodySystem)) {
	%>
		LRTI		
	<%	
		} else if ("SST".equals(BodySystem)) {
	%>
		SST		
	<%	
		}	
	%>
<%	} %>
	</td>
<% } %>	
	</tr>
	<tr class="smallText">
	<% if ("bld".equals(icType)) { %>
		<td class="infoLabel" width="30%">Isolate Organisms</td>
	<%} else { %>
		<td class="infoLabel" width="30%">Organisms (other than MRSA)</td>	
	<%} %>
		<td class="infoData" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="IsolateOrgan" rows="3" cols="50"><%=IsolateOrgan==null?"":IsolateOrgan %></textarea>
  			</div>
<%	} else { %>			
			<%=IsolateOrgan == null ? "" : IsolateOrgan %>
<%	} %>
  		</td>
	</tr>
	<tr>
   		<td class="infoLabel" width="5%">PHx</td>
		<td class="infoData" width="5%">
<%	if (createAction || updateAction) { %>
		<select name="Phx">
			<option value=""></option>
			<option value="DM"<%="DM".equals(Phx)?" selected":"" %>>DM</option>
			<option value="HT"<%="HT".equals(Phx)?" selected":"" %>>HT</option>					
			<option value="CVA"<%="CVA".equals(Phx)?" selected":"" %>>CVA</option>			
			<option value="CHF"<%="CHF".equals(Phx)?" selected":"" %>>CHF</option>			
			<option value="Dementia"<%="BJ".equals(Phx)?" selected":"" %>>Dementia</option>			
			<option value="ESRF"<%="CNS".equals(Phx)?" selected":"" %>>ESRF</option>			
			<option value="Gout"<%="Gout".equals(Phx)?" selected":"" %>>Gout</option>			
			<option value="CA Primary"<%="CA Primary".equals(Phx)?" selected":"" %>>CA Primary</option>			
			<option value="CA Metastasis"<%="CA Metastasis".equals(Phx)?" selected":"" %>>CA Metastasis</option>
			<option value="AML"<%="AML".equals(Phx)?" selected":"" %>>AML</option>		
			<option value="ALL"<%="ALL".equals(Phx)?" selected":"" %>>ALL</option>
			<% if ("mrsa".equals(icType) || "esbl".equals(icType)) { %>
				<option value="Parkinsonism"<%="Parkinsonism".equals(Phx)?" selected":"" %>>Parkinsonism</option>
			<%} %>
		</select>
<%	} else { %>			
	<%
		if ("DM".equals(Phx)) {
	%>
		DM
	<%	
		} else if ("HT".equals(Phx)) {
	%>
		HT
	<%	
		} else if ("CVA".equals(Phx)) {
	%>
		CVA
	<%	
		} else if ("CHF".equals(Phx)) {
	%>
		CHF
	<%	
		} else if ("Dementia".equals(Phx)) {
	%>
		Dementia
	<%	
		} else if ("ESRF".equals(Phx)) {
	%>
		ESRF
	<%	
		} else if ("Gout".equals(Phx)) {
	%>
		Gout		
	<%	
		} else if ("CA Primary".equals(Phx)) {
	%>
		Ca Primary
	<%	
		} else if ("CA Metastasis".equals(Phx)) {
	%>
		CA Metastasis		
	<%		
		} else if ("AML".equals(Phx)) {
	%>
		AML		
	<%	
		} else if ("ALL".equals(Phx)) {
	%>
		ALL	
	<%
		} else if ("Parkinsonism".equals(Phx)) {
	%>	
		Parkinsonism
	<%
		}	
	%>
<%	} %>
</td>
		<td class="infoLabel" width="30%">Phx Other</td>
		<td class="infoData" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="PhxOther" rows="3" cols="50"><%=PhxOther==null?"":PhxOther %></textarea>
  			</div>
<%	} else { %>			
			<%=PhxOther == null ? "" : PhxOther %>
<%	} %>
  		</td>
  	</tr>
  	
  	<% if ("mrsa".equals(icType) || "esbl".equals(icType)) { %>
		<tr class="smallText">
			<td class="infoLabel" width="30%">Admission C/O</td>
			<td class="infoData" width="70%" colspan="3">
	<%	if (createAction || updateAction) { %>
				<div class="box" >
	  				<textarea name="AdmissionCO" rows="3" cols="50"><%=AdmissionCO==null?"":AdmissionCO %></textarea>
	  			</div>
	<%	} else { %>			
				<%=AdmissionCO == null ? "" : AdmissionCO %>
	<%	} %>
	  		</td>
		</tr>  	
  	<%} %>
  	
  	
	<tr class="smallText">
		<td class="infoLabel" width="30%">Clinical Information</td>
		<td class="infoData" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="ClinicalInfo" rows="3" cols="50"><%=ClinicalInfo==null?"":ClinicalInfo %></textarea>
  			</div>
<%	} else { %>			
			<%=ClinicalInfo == null ? "" : ClinicalInfo %>
<%	} %>
  		</td>
	</tr>


	<tr>
		<td class="infoLabel" width="10%">BP/P</td>
		<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="BpP" name="BpP" value="<%=BpP == null ? "" : BpP %>" maxlength="10" size="15" />
	<%	} else { %>
			<%=BpP == null ? "" : BpP %>
<%	} %>    
		</td>
		<td class="infoLabel" width="10%">Temp</td>
		<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="BpPTemp" name="BpPTemp" value="<%=BpPTemp == null ? "" : BpPTemp %>" maxlength="10" size="15" />
	<%	} else { %>
			<%=BpPTemp == null ? "" : BpPTemp %>
<%	} %>    
		</td>
	</tr>
			
			
		<tr>
			<td class="infoLabel" width="15%">Isolation</td>
			<td class="infoData" width="17%">
		<%	if (createAction || updateAction) { %>
				<select name="ISOLATE">
					<option value=""></option>
					<option value="CP"<%="CP".equals(ISOLATE)?" selected":"" %>>CP</option>
					<option value="DP"<%="DP".equals(ISOLATE)?" selected":"" %>>DP</option>
					<option value="AP"<%="AP".equals(ISOLATE)?" selected":"" %>>AP</option>
				</select>
		<%	} else { %>			
			<%
				if ("CP".equals(ISOLATE)) {
			%>
				CP
			<%	
				} else if ("DP".equals(ISOLATE)) {
			%>
				DP
			<%	
				} else if ("AP".equals(ISOLATE)) {
			%>
				AP
			<%	
				}
			%>
		<%	} %>
			</td>
			<td class="infoLabel" width="15%">Standard Precaution</td>
			<td class="infoData" width="17%">
		<%	if (createAction || updateAction) { %>
				<select name="STD_PRECAUTION">
					<option value=""></option>
					<option value="Y"<%="Y".equals(STD_PRECAUTION)?" selected":"" %>>Y</option>
					<option value="N"<%="N".equals(STD_PRECAUTION)?" selected":"" %>>N</option>
				</select>
		<%	} else { %>			
			<%
				if ("Y".equals(STD_PRECAUTION)) {
			%>
				Y
			<%	
				} else if ("N".equals(STD_PRECAUTION)) {
			%>
				N
			<%
				}
			%>
		<%	} %>
			</td>							
		</tr>
		
		<tr>
			<td class="infoLabel" width="15%">Transfer Date</td>
			<td class="infoData"" width="70%" colspan="3">
	<%	if (createAction || updateAction) { %>
				<input type="text" name="TRANDATE" id="TRANDATE" class="datepickerfield" value="<%=TRANDATE == null ? "" : TRANDATE %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)			
	<%	} else { %>
				<%=TRANDATE == null ? "" : TRANDATE %>
	<%	} %>
		    </td>		
		   	<td class="infoLabel" width="10%">Transfer</td>
			<td class="infoData" width="70%" valign="top">
	<%	if (createAction || updateAction) { %>
				<div class="box" >
	  				<textarea name="TRANSFER" rows="5" cols="50"><%=TRANSFER==null?"":TRANSFER %></textarea>
	  			</div>			
		<%	} else { %>
				<%=TRANSFER == null ? "" : TRANSFER %>
	<%	} %>    
			</td>
	</tr>
		
		<tr>		
			<td class="infoLabel" width="10%">WCC</td>
			<td class="infoData" width="70%" valign="top">
	<%	if (createAction || updateAction) { %>
				<input type="text" id="Wcc" name="Wcc" value="<%=Wcc== null ? "" : Wcc %>" maxlength="10" size="15" />
		<%	} else { %>
				<%=Wcc == null ? "" : Wcc %>
	<%	} %>    
			</td>		
			<td class="infoLabel" width="10%">N</td>
			<td class="infoData" width="70%" valign="top">
	<%	if (createAction || updateAction) { %>
				<input type="text" id="WccN" name="WccN" value="<%=WccN== null ? "" : WccN %>" maxlength="10" size="15" />
		<%	} else { %>
				<%=WccN == null ? "" : WccN %>
	<%	} %>    
			</td>		
			<td class="infoLabel" width="10%">L</td>
			<td class="infoData" width="70%" valign="top">
	<%	if (createAction || updateAction) { %>
				<input type="text" id="WccL" name="WccL" value="<%=WccL== null ? "" : WccL %>" maxlength="10" size="15" />
		<%	} else { %>
				<%=WccL == null ? "" : WccL %>
	<%	} %>    
			</td>
		</tr>
		<tr>

<% if ("bld".equals(icType)) { %>			
		   	<td class="infoLabel" width="5%">Devices</td>
				<td class="infoData" width="5%">
		<%	if (createAction || updateAction) { %>
				<select name="Device">
					<option value=""></option>
					<option value="ETT"<%="ETT".equals(Device)?" selected":"" %>>ETT</option>
					<option value="BIPAP"<%="BIPAP".equals(Device)?" selected":"" %>>BIPAP</option>					
					<option value="CPAP"<%="CPAP".equals(Device)?" selected":"" %>>CPAP</option>			
					<option value="Foley"<%="Foley".equals(Device)?" selected":"" %>>Foley</option>			
					<option value="RT"<%="RT".equals(Device)?" selected":"" %>>RT</option>			
					<option value="Tenckhoff"<%="Tenckhoff".equals(Device)?" selected":"" %>>Tenckhoff Hickman</option>			
					<option value="Shunt"<%="Shunt".equals(Device)?" selected":"" %>>Shunt</option>			
				</select>
		<%	} else { %>			
			<%
				if ("Device".equals(Device)) {
			%>
				ETT
			<%	
				} else if ("BIPAP".equals(Device)) {
			%>
				BIPAP
			<%	
				} else if ("CPAP".equals(Device)) {
			%>
				CPAP
			<%	
				} else if ("Foley".equals(Device)) {
			%>
				Foley
			<%	
				} else if ("RT".equals(Device)) {
			%>
				RT
			<%	
				} else if ("Tenckhoff".equals(Device)) {
			%>
				Tenckhoff Hickman
			<%	
				} else if ("Shunt".equals(Device)) {
			%>
				Shunt		
			<%	
				}	
			%>
		<%	} %>
		</td>
<%} %>

<% if ("bld".equals(icType)) { %>
	   	<td class="infoLabel" width="5%">IV Catheter</td>
			<td class="infoData" width="5%">
	<%	if (createAction || updateAction) { %>
			<select name="IVCatheter">
				<option value=""></option>
				<option value="P_line"<%="P_line".equals(IVCatheter)?" selected":"" %>>P_line</option>
				<option value="C_line"<%="C_line".equals(IVCatheter)?" selected":"" %>>C_line</option>					
				<option value="A_line"<%="A_line".equals(IVCatheter)?" selected":"" %>>A_line</option>			
			</select>
	<%	} else { %>			
		<%
			if ("P_line".equals(IVCatheter)) {
		%>
			P_line
		<%	
			} else if ("C_line".equals(IVCatheter)) {
		%>
			C_line
		<%	
			} else if ("A_line".equals(IVCatheter)) {
		%>
			A_line
		<%	
			}	
		%>
	<%	} %>
	</td>
			<td class="infoLabel" width="10%">Others</td>
			<td class="infoData" width="70%" valign="top">
	<%	if (createAction || updateAction) { %>
				<input type="text" id="IVCatheterOther" name="IVCatheterOther" value="<%=IVCatheterOther== null ? "" : IVCatheterOther%>" maxlength="50" size="25" />
		<%	} else { %>
				<%=IVCatheterOther == null ? "" : IVCatheterOther %>
	<%	} %>    
			</td>			
		</tr>
<%} %>	
	<tr class="smallText">
		<td class="infoLabel" width="30%">Procedures (OT, CT scan, bronchoscopy etc)</td>
		<td class="infoData" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="Proc" rows="3" cols="50"><%=Proc==null?"":Proc %></textarea>
  			</div>
<%	} else { %>			
			<%=Proc == null ? "" : Proc %>
<%	} %>

<% if ("mrsa".equals(icType) || "esbl".equals(icType)) { %>
  		</td>
			<td class="infoLabel" width="30%">Devices</td>
			<td class="infoData" width="70%" colspan="3">
	<%	if (createAction || updateAction) { %>
				<div class="box" >
	  				<textarea name="DeviceMrsaEsbl" rows="3" cols="50"><%=DeviceMrsaEsbl==null?"":DeviceMrsaEsbl %></textarea>
	  			</div>
	<%	} else { %>			
				<%=DeviceMrsaEsbl == null ? "" : DeviceMrsaEsbl %>
	<%	} %>
	  		</td>
<%} %>
	</tr>	

<% if ("bld".equals(icType)) { %>	
		<tr class="smallText">
			<td class="infoLabel" width="30%">Chest Sign</td>
			<td class="infoData" width="70%" colspan="3">
	<%	if (createAction || updateAction) { %>
				<div class="box" >
	  				<textarea name="ChestSign" rows="3" cols="50"><%=ChestSign==null?"":ChestSign %></textarea>
	  			</div>
	<%	} else { %>			
				<%=ChestSign == null ? "" : ChestSign %>
	<%	} %>
	  		</td>
		</tr>
<%} %>
<% if ("bld".equals(icType)) { %>
		<tr>
	   	<td class="infoLabel" width="5%">IV Site</td>
			<td class="infoData" width="5%">
	<%	if (createAction || updateAction) { %>
			<select name="IVSite">
				<option value=""></option>
				<option value="Pain"<%="Pain".equals(IVSite)?" selected":"" %>>Pain</option>
				<option value="Hear"<%="Hear".equals(IVSite)?" selected":"" %>>Hear</option>					
				<option value="Erythema"<%="Erythema".equals(IVSite)?" selected":"" %>>Erythema</option>
				<option value="Pus"<%="Pus".equals(IVSite)?" selected":"" %>>Pus</option>
			</select>
	<%	} else { %>			
		<%
			if ("Pain".equals(IVSite)) {
		%>
			Pain
		<%	
			} else if ("Hear".equals(IVSite)) {
		%>
			Hear
		<%	
			} else if ("Erythema".equals(IVSite)) {
		%>
			Erythema
		<%	
			} else if ("Pus".equals(IVSite)) {
		%>
			Pus			
		<%	
			}	
		%>
	<%	} %>
	  </td>
<%} %>  

<% if ("bld".equals(icType)) { %>
		<td class="infoLabel" width="10%">Others</td>
			<td class="infoData" width="70%" valign="top">
	<%	if (createAction || updateAction) { %>
				<input type="text" id="IVSiteOther" name="IVSiteOther" value="<%=IVSiteOther== null ? "" : IVSiteOther %>" maxlength="20" size="15" />
		<%	} else { %>
				<%=IVSiteOther == null ? "" : IVSiteOther %>
	<%	} %>    
			</td>	
	</tr>
	<tr>			
	   	<td class="infoLabel" width="5%">Urinary</td>
			<td class="infoData" width="5%">
	<%	if (createAction || updateAction) { %>
			<select name="Urinary">
				<option value=""></option>
				<option value="Dysuria"<%="Pain".equals(Urinary)?" selected":"" %>>Dysuria</option>
				<option value="Freq"<%="Freq".equals(Urinary)?" selected":"" %>>Freq</option>					
				<option value="Urgency"<%="Urgency".equals(Urinary)?" selected":"" %>>Urgency</option>
				<option value="SP tenderness"<%="SP tenderness".equals(Urinary)?" selected":"" %>>SP tenderness</option>
			</select>
	<%	} else { %>			
		<%
			if ("Dysuria".equals(Urinary)) {
		%>
			Dysuria
		<%	
			} else if ("Freq".equals(Urinary)) {
		%>
			Freq
		<%	
			} else if ("Urgency".equals(Urinary)) {
		%>
			Urgency
		<%	
			} else if ("SP tenderness".equals(Urinary)) {
		%>
			SP tenderness			
		<%	
			}	
		%>
	<%	} %>
		</td>
		<td class="infoLabel" width="10%">Others</td>
			<td class="infoData" width="70%" valign="top">
	<%	if (createAction || updateAction) { %>
				<input type="text" id="UrinaryOther" name="UrinaryOther" value="<%=UrinaryOther== null ? "" : UrinaryOther %>" maxlength="20" size="15" />
		<%	} else { %>
				<%=UrinaryOther == null ? "" : UrinaryOther %>
	<%	} %>    
			</td>			
	</tr>	 
<%} %>

<% if ("bld".equals(icType)) { %>
	<tr>   
		<td class="infoLabel" width="10%">Other Physical Signs</td>
			<td class="infoData" width="70%" valign="top">
	<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="OtherPhySign" rows="3" cols="50"><%=OtherPhySign==null?"":OtherPhySign %></textarea>
  			</div>
		<%	} else { %>
				<%=OtherPhySign == null ? "" : OtherPhySign %>
	<%	} %>    
			</td>
		</tr>
<%} %>

   <tr>
   	<td class="infoLabel" width="10%">Antibiotics</td>
		<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="Antibiotics" rows="3" cols="50"><%=Antibiotics==null?"":Antibiotics %></textarea>
  			</div>			
	<%	} else { %>
			<%=Antibiotics == null ? "" : Antibiotics %>
<%	} %>    
		</td>	
   	<td class="infoLabel" width="15%">Final Disposition</td>
		<td class="infoData" width="17%">
<%	if (createAction || updateAction) { %>
		<select name="FinalDisp">
			<option value=""></option>
			<option value="Home"<%="Pain".equals(FinalDisp)?" selected":"" %>>Home</option>
			<option value="Died"<%="Freq".equals(FinalDisp)?" selected":"" %>>Died</option>					
			<option value="Transfer To"<%="Urgency".equals(FinalDisp)?" selected":"" %>>Transfer To</option>
		</select>
<%	} else { %>			
	<%
		if ("Home".equals(FinalDisp)) {
	%>
		Home
	<%	
		} else if ("Died".equals(FinalDisp)) {
	%>
		Died
	<%	
		} else if ("Transfer To".equals(FinalDisp)) {
	%>
		Transfer To
	<%	
		}	
	%>
<%	} %>
	</td>
	<td class="infoLabel" width="10%">Transfer To</td>
		<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="TransferTo" name="TransferTo" value="<%=TransferTo== null ? "" : TransferTo %>" maxlength="10" size="15" />
	<%	} else { %>
			<%=TransferTo == null ? "" : TransferTo %>
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
  <% if ("bld".equals(icType)) { %>
    <input type="hidden" name="icType" value="<%=icType %>" />
  <%} %>		
  </td></tr> 
  
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


<!-- reserved fields -->

</form>
<% } %>
<script language="javascript">
$(document).ready(function() {
	<%	if (createAction || updateAction) { %>
	
	$("textarea[name=IsolateOrgan]").supertextarea({
		maxl: 98,
		tabr: {use: false}
	});
	$("textarea[name=PhxOther]").supertextarea({
		maxl: 198,
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
				alert("Please input Case Date");
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