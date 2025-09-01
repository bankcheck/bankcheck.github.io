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
String TOCC = TextUtil.parseStrUTF8(request.getParameter("TOCC"));
String TOCC2 = TextUtil.parseStrUTF8(request.getParameter("TOCC2"));
String ISOLATE = TextUtil.parseStrUTF8(request.getParameter("ISOLATE"));
String STD_PRECAUTION = TextUtil.parseStrUTF8(request.getParameter("STD_PRECAUTION"));
String TRANDATE = TextUtil.parseStrUTF8(request.getParameter("TRANDATE"));
String TRANSFER = TextUtil.parseStrUTF8(request.getParameter("TRANSFER"));
String fever38C = TextUtil.parseStrUTF8(request.getParameter("fever38C"));
String admit_icu = TextUtil.parseStrUTF8(request.getParameter("admit_icu"));
String hai_cai = TextUtil.parseStrUTF8(request.getParameter("hai_cai"));
String oahr = TextUtil.parseStrUTF8(request.getParameter("oahr"));
String remark = TextUtil.parseStrUTF8(request.getParameter("remark"));
String onset_date = TextUtil.parseStrUTF8(request.getParameter("onset_date"));
String dv = TextUtil.parseStrUTF8(request.getParameter("dv"));

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
		
		if (createAction) {
			
			CaseNum = IcGeRespDB.add(
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
					TOCC, TOCC2, ISOLATE, STD_PRECAUTION, fever38C,
					admit_icu, onset_date, dv, hai_cai,  
					oahr, remark, TRANDATE, TRANSFER 					
				);

			if (CaseNum != null) {
				message = "GE/RESP Culture created.";
				createAction = false;
				step = null;
			} else {
				errorMessage = "GE/RESP Culture create fail.";
			}
		} else if (updateAction) {
			
			boolean success = false; 
			if (CaseNum != null) {
//				System.out.println("tocc2 : " + TOCC2);
				success = IcGeRespDB.update( 
								userBean,
								CaseDate, LabNum, 
								HospNum, PatName, PatSex, PatBDate,
								Age, Month, Ward, RoomNum, 
								BedNum, DateIn, 
								TOCC, TOCC2, ISOLATE, STD_PRECAUTION, fever38C,
								admit_icu, onset_date, dv, hai_cai,
								oahr, remark, TRANDATE, TRANSFER, 											
								CaseNum
							);
			}

			if (success) {	// do update
				message = "GE/RESP updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "GE/RESP Culture update fail.";
			}		
		
		} else if (deleteAction) {
			boolean success = IcGeRespDB.delete(userBean, CaseNum ); 
			
			if (success) {	
				message = "GE/RESP Culture removed.";
				closeAction = true;
			} else {
				errorMessage = "GE/RESP Culture remove fail.";
			}
		}
	} else if (createAction) {
		// start new record for insert
		nurobDeliDateDate = DateTimeUtil.getCurrentDate();
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (CaseNum != null && CaseNum.length() > 0) {
			ArrayList record = IcGeRespDB.get(CaseNum);
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
				TOCC = row.getValue(14);
				TOCC2 = row.getValue(15);
				ISOLATE = row.getValue(16);
				STD_PRECAUTION = row.getValue(17);
				fever38C = row.getValue(18);
				admit_icu = row.getValue(19);
				onset_date = row.getValue(20);
				dv = row.getValue(21);
				hai_cai = row.getValue(22);
				oahr = row.getValue(23);
				remark = row.getValue(24);
				TRANDATE = row.getValue(25);
				TRANSFER = row.getValue(26);
				//System.out.println("debug get method " + Source + " " + CaseDefine + " " + Status + " " + BodySystem);			
			} else {
				message = "GE/Resp record does not exist.";
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
	
//	System.out.println("Hello !!! " + icType + " " + commandType );
	// set submit label
	title = "function.ic.ge_resp." + commandType;
	if ("ge".equals(icType)) {
		pageTitle = "GE";
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
<form name="form1" id="form1" action="<html:rewrite page="/ic/ge_resp.jsp" />" method="post">
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
<%-- 
<% if ("resp".equals(icType)) { %> 
--%>
	<tr>	
	   	<td class="infoLabel" width="15%">TOCC</td>
		<td class="infoData" width="17%">
	<%	if (createAction || updateAction) { %>
			<select name="TOCC">
				<option value=""></option>
				<option value="Y"<%="Y".equals(TOCC)?" selected":"" %>>Y</option>
				<option value="N"<%="N".equals(TOCC)?" selected":"" %>>N</option>					
			</select>
	<%	} else { %>			
		<%
			if ("Y".equals(TOCC)) {
		%>
			Y
		<%	
			} else if ("N".equals(TOCC)) {
		%>
			Y
		<%	
			}
		%>
	<%	} %>
		</td>
		
		<td class="infoLabel" width="15%"></td>
		<td class="infoData" width="17%">
	<%	if (createAction || updateAction) { %>
			<select name="TOCC2">
				<option value=""></option>
				<option value="OPD"<%="OPD".equals(TOCC2)?" selected":"" %>>OPD</option>
				<option value="OB"<%="OB".equals(TOCC2)?" selected":"" %>>OB</option>
				<option value="SUR"<%="SUR".equals(TOCC2)?" selected":"" %>>SUR</option>
				<option value="MED"<%="MED".equals(TOCC2)?" selected":"" %>>MED</option>
				<option value="PED"<%="PED".equals(TOCC2)?" selected":"" %>>PED</option>
				<option value="ICU"<%="ICU".equals(TOCC2)?" selected":"" %>>ICU</option>							
			</select>
	<%	} else { %>			
		<%
			if ("OPD".equals(TOCC2)) {
		%>
			OPD
		<%	
			} else if ("OB".equals(TOCC2)) {
		%>
			OB
		<%	
			} else if ("SUR".equals(TOCC2)) {
		%>
			SUR
		<%	
			} else if ("MED".equals(TOCC2)) {
		%>
			MED
		<%	
			} else if ("PED".equals(TOCC2)) {
		%>
			PED
		<%	
			} else if ("ICU".equals(TOCC2)) {
		%>
			ICU			
		<%	
			}
		%>
	<%	} %>
		</td>
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
	</tr>
	<tr>
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
<%--	
<%} %>
--%>	
	
	
	<tr>
		<td class="infoLabel" width="15%">Fever > 38C</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
		<input type="text" id="fever38C" name="fever38C" value="<%=fever38C == null ? "" : fever38C %>" maxlength="5" size="15" />
<%	} else { %>
			<%=fever38C == null ? "" : fever38C %>
<%	} %>
		</td>
		
<% if ("resp".equals(icType)) { %>		
	   	<td class="infoLabel" width="15%">Admit to ICU</td>
		<td class="infoData" width="17%">
	<%	if (createAction || updateAction) { %>
			<select name="admit_icu">
				<option value=""></option>
				<option value="Y"<%="Y".equals(admit_icu)?" selected":"" %>>Y</option>
				<option value="N"<%="N".equals(admit_icu)?" selected":"" %>>N</option>					
			</select>
	<%	} else { %>			
		<%
			if ("Y".equals(admit_icu)) {
		%>
			Y
		<%	
			} else if ("N".equals(admit_icu)) {
		%>
			N
		<%	
			}
		%>
	<%	} %>
		</td>	   	
<%} %>		

 		
<% if ("ge".equals(icType)) { %>				
		<td class="infoLabel" width="15%">Onset Date</td>
		<td class="infoData"" width="70%" colspan="3">
	<%	if (createAction || updateAction) { %>
		<input type="text" name="onset_date" id="onset_date" class="datepickerfield" value="<%=onset_date == null ? "" : onset_date %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)			
	<%	} else { %>
		<%=onset_date == null ? "" : onset_date %>
	<%	} %>
   	</td>
<%} %>
   	<td class="infoLabel" width="15%">D/V</td>
	<td class="infoData" width="17%">
	<%	if (createAction || updateAction) { %>
			<select name="dv">
				<option value=""></option>
				<option value="D"<%="D".equals(dv)?" selected":"" %>>D</option>
				<option value="V"<%="V".equals(dv)?" selected":"" %>>V</option>
				<option value="B"<%="B".equals(dv)?" selected":"" %>>D & V</option>					
				<option value="N"<%="N".equals(dv)?" selected":"" %>>NA</option>
			</select>
	<%	} else { %>			
		<%
			if ("D".equals(dv)) {
		%>
			D
		<%	
			} else if ("V".equals(dv)) {
		%>
			V
		<%	
			} else if ("B".equals(dv)) {
		%>
			D & V
		<%
			} else if ("N".equals(dv)) {
		%>
			NA
		<%		
			}
		%>		
	<%	} %>
		</td>	   	
</tr>
	<tr>
		<td class="infoLabel" width="15%">HAI/CAI</td>
		<td class="infoData" width="17%">
	<%	if (createAction || updateAction) { %>
			<select name="hai_cai">
				<option value=""></option>
				<option value="H"<%="H".equals(hai_cai)?" selected":"" %>>HAI</option>
				<option value="C"<%="C".equals(hai_cai)?" selected":"" %>>CAI</option>					
			</select>
	<%	} else { %>			
		<%
			if ("H".equals(hai_cai)) {
		%>
			HAI
		<%	
			} else if ("C".equals(hai_cai)) {
		%>
			CAI
		<%	
			}
		%>
	<%	} %>
		</td>
		<td class="infoLabel" width="15%">OAHR</td>
		<td class="infoData" width="17%">
	<%	if (createAction || updateAction) { %>
			<select name="oahr">
				<option value=""></option>
				<option value="Y"<%="Y".equals(oahr)?" selected":"" %>>Y</option>
				<option value="N"<%="N".equals(oahr)?" selected":"" %>>N</option>					
			</select>
	<%	} else { %>			
		<%
			if ("Y".equals(oahr)) {
		%>
			Y
		<%	
			} else if ("N".equals(oahr)) {
		%>
			N
		<%	
			}
		%>
	<%	} %>
		</td>			   	
	</tr>
	<tr>
	   	<td class="infoLabel" width="10%">Remarks</td>
		<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="remark" rows="5" cols="50"><%=remark==null?"":remark %></textarea>
  			</div>			
	<%	} else { %>
			<%=remark == null ? "" : remark %>
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
		$("textarea[name=remark]").supertextarea({
			maxl: 100,
			tabr: {use: false}
		});
		$("textarea[name=TRANSFER]").supertextarea({
			maxl: 100,
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