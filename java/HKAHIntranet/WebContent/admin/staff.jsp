<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String month[] = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };

HashMap categoryDesc = new HashMap();
categoryDesc.put("N", MessageResources.getMessage(session, "label.nursing"));
categoryDesc.put("P", MessageResources.getMessage(session, "label.paramedical"));
categoryDesc.put("H", MessageResources.getMessage(session, "label.otherHealthcare"));
categoryDesc.put("O", MessageResources.getMessage(session, "label.other"));
categoryDesc.put("", MessageResources.getMessage(session, "label.unknown"));

boolean selfView = false;

UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String step = request.getParameter("step");
String siteCode = request.getParameter("siteCode");
String staffID = request.getParameter("staffID");

if ("SelfView".equals(command) || "SelfUpdate".equals(command)) {
	selfView = true;
}

if (selfView) {
	staffID = userBean.getStaffID();
} else {
	if (staffID != null) {
		session.setAttribute("staffID", staffID);
	} else {
		staffID = (String) session.getAttribute("staffID");
	}
}

String deptCode = request.getParameter("deptCode");
String deptCode2[] = request.getParameterValues("deptCode2");
String deptDesc = request.getParameter("deptDesc");
String staffName = request.getParameter("staffName");
String status = request.getParameter("status");
String annual_incr = request.getParameter("annual_incr_mm");
String hireDate = request.getParameter("hireDate");
String category = request.getParameter("category");
String terminationDate = request.getParameter("terminationDate");
String position1 = request.getParameter("position1");
String position2 = request.getParameter("position2");
String deptCodeList[] = null;
HashMap deptCodeMap = new HashMap();
String isMarkDeleted = request.getParameter("isMarkDeleted");
isMarkDeleted = isMarkDeleted == null ? "N" : isMarkDeleted;
String enabled = request.getParameter("enabled");

String hospNo = request.getParameter("hospNo");
String isFixDepartmentCode = request.getParameter("isFixDepartmentCode");
isFixDepartmentCode = isFixDepartmentCode == null ? "N" : isFixDepartmentCode;
String displayPhoto = request.getParameter("displayPhoto");
displayPhoto = displayPhoto == null ? "N" : displayPhoto;
String positionCode = request.getParameter("positionCode");
String chiName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "chiName"));
String lastName = request.getParameter("lastName");
String firstName = request.getParameter("firstName");
String email = request.getParameter("email");
String jobCode = request.getParameter("jobCode");
String jobDescription = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "jobDescription"));
String displayName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "displayName"));
String createdDate = request.getParameter("createdDate");
String createdUser = request.getParameter("createdUser");
String modifiedDate = request.getParameter("modifiedDate");
String modifiedUser = request.getParameter("modifiedUser");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command) || "SelfUpdate".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			if (StaffDB.add(userBean, siteCode, staffID, deptCode, deptCode2, staffName, status, annual_incr,hireDate, category, terminationDate, position1, position2, isMarkDeleted,
					hospNo, isFixDepartmentCode, positionCode, chiName, lastName, firstName, email, jobCode, jobDescription, displayName, enabled)) {
				message = "Staff created.";
				createAction = false;
				step = "0";
			} else {
				errorMessage = "Staff create fail.";
			}
		} else if (updateAction) {
			if (StaffDB.update(userBean, siteCode, staffID, deptCode, deptCode2, staffName, status, annual_incr, hireDate, category, terminationDate, position1, position2, isMarkDeleted,
					hospNo, isFixDepartmentCode, positionCode, chiName, lastName, firstName, email, jobCode, jobDescription, displayName, enabled, displayPhoto)) {
				message = "Staff updated.";
				updateAction = false;
				step = "0";
			} else {
				errorMessage = "Staff update fail.";
			}
		} else if (deleteAction) {
			// Real delete record!
			if (StaffDB.delete(siteCode, staffID)) {
				message = "Staff removed.";
				//closeAction = true;
			} else {
				errorMessage = "Staff remove fail.";
			}
		}
	} else if (createAction) {
		siteCode = ConstantsServerSide.SITE_CODE;
		staffID = "";
		staffName = "";
		hireDate = DateTimeUtil.getCurrentDate();
	}

	ReportableListObject row = null;

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (staffID != null && staffID.length() > 0) {
			ArrayList record = StaffDB.get(staffID, enabled);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				siteCode = row.getValue(0);
				deptCode = row.getValue(1);
				deptDesc = row.getValue(2);
				staffName = row.getValue(3);
				status = row.getValue(4);
				annual_incr = row.getValue(5);
				hireDate = row.getValue(6);
				category =row.getValue(7);
				terminationDate = row.getValue(10);
				position1= row.getValue(8);
				position2= row.getValue(9);
				hospNo = row.getValue(11);
				isFixDepartmentCode = row.getValue(12);
				isMarkDeleted = row.getValue(13);
				enabled = row.getValue(14);
				positionCode = row.getValue(15);
				chiName = row.getValue(16);
				lastName = row.getValue(17);
				firstName = row.getValue(18);
				email = row.getValue(19);
				jobCode = row.getValue(20);
				jobDescription = row.getValue(21);
				displayName = row.getValue(22);
				createdDate = row.getValue(23);
				createdUser = row.getValue(24);
				modifiedDate = row.getValue(25);
				modifiedUser = row.getValue(26);
				displayPhoto = row.getValue(27);

				// get associate department code
				record = StaffDB.getDeptCode2List(staffID);
				deptCode2 = new String[record.size()];
				if (record.size() > 0) {
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						deptCode2[i] = row.getValue(0);
					}
				}
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}

	// get department code list
	ArrayList record = StaffDB.getDeptCodeList(null);
	if (record.size() > 0) {
		deptCodeList = new String[record.size()];
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			deptCodeList[i] = row.getValue(0);
			deptCodeMap.put(row.getValue(0), row.getValue(1));
		}
	} else {
		deptCodeList = new String[0];
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.staff." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<%	if (!selfView) {%>
<jsp:include page="staff_brief.jsp" flush="false">
	<jsp:param name="tabId" value="1" />
</jsp:include>
<%	} %>
<form name="form1" id="form1" action="staff.jsp" method="post">
<%	if (!createAction) { %>
<div style="margin: 0 5px; padding-top: 5px; padding-right: 5px; padding-bottom: 5px; padding-left: 5px; border-top-color: grey; border-right-color: grey; border-bottom-color: grey; border-left-color: grey; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid;">
	<span>Created on <%=createdDate == null ? "" : createdDate %> by <%=createdUser == null ? "" : createdUser %></span><span style="margin-left: 20px;"> Last modified on <%=modifiedDate == null ? "" : modifiedDate %> by <%=modifiedUser == null ? "" : modifiedUser %></span>
</div>
<%	} %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="5"><bean:message key="prompt.data.staff" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="20%">
<%	if (createAction) { %>
			<input type="textfield" name="staffID" value="<%=staffID==null?"":staffID %>" maxlength="10" size="50">
<%	} else { %>
			<%=staffID==null?"":staffID %><input type="hidden" name="staffID" value="<%=staffID%>">
<%	} %>
		</td>

		<td class="infoLabel" width="15%"><bean:message key="prompt.site" /></td>
		<td class="infoData" colspan="2">
<%	if (createAction) { %>
<jsp:include page="../ui/siteCodeRDB.jsp" flush="false">
	<jsp:param name="allowAll" value="N" />
	<jsp:param name="siteCode" value="<%=siteCode %>" />
</jsp:include>
<%	} else { %>
		<%if (ConstantsServerSide.SITE_CODE_HKAH.equals(siteCode)) { %><bean:message key="label.hkah" /><%} else if (ConstantsServerSide.SITE_CODE_TWAH.equals(siteCode)) {%><bean:message key="label.twah" /><%} else {%><%=siteCode%><%} %>
		<input type="hidden" name="siteCode" value="<%=siteCode%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.hospitalNo" /> (<bean:message key="prompt.patNo" />)</td>
		<td class="infoData" colspan="4">
<%	if (createAction) { %>
			<input type="textfield" name="hospNo" value="<%=hospNo==null?"":hospNo %>" maxlength="10" size="50">
<%	} else { %>
			<%=hospNo==null?"":hospNo %><input type="hidden" name="hospNo" value="<%=hospNo%>">
<%	} %>
		</td>
	</tr>

	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
			<td class="infoLabel" >Enabled</td>
			<td class="infoData" colspan="4">
	<%	if (createAction || updateAction) {%>
	<% if (createAction) {
		enabled = "1";
	}%>
				<input type="radio" name="enabled" value="1"<%="1".equals(enabled)?" checked":"" %> />&nbsp;<font color="green">Enable</font>&nbsp;&nbsp;
				<input type="radio" name="enabled" value="0"<%="0".equals(enabled)?" checked":"" %> />&nbsp;<font color="red">Disable</font>
	<%	} else {%>
	<%		if ("1".equals(enabled)) { %>
				<font color="green">Enable</font>
	<%		} else { %>
				<font color="red">Disable</font>
	<%		} %>
				<input type="hidden" name="enabled" value="<%=enabled %>">
	<%	} %>
		<div>(System will disable this staff account automatically when it is (1) before hire date, or (2) on or after termination date.)</div>
			</td>
	</tr>

	<tr class="smallText">
		<td class="infoTitle" colspan="5">Personal Info</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.staffName" /></td>
		<td class="infoData">
<%	if (!selfView && (createAction || updateAction)) { %>
			<input type="textfield" name="displayName" value="<%=displayName==null?"":displayName %>" maxlength="200" size="50" <% if (selfView) {%>readonly<%} %>>
<%	} else { %>
			<%=displayName==null?"":displayName %><input type="hidden" name="displayName" value="<%=displayName %>">
<%	} %>
		</td>
		
		<td class="infoLabel"><bean:message key="prompt.displayName" /></td>
		<td class="infoData">
<%	if (!selfView && (createAction || updateAction)) { %>
			<input type="textfield" name="staffName" value="<%=staffName==null?"":staffName %>" maxlength="100" size="50" <% if (selfView) {%>readonly<%} %>>
<%	} else { %>
			<%=staffName==null?"":staffName %><input type="hidden" name="staffName" value="<%=staffName %>">
<%	} %>
		</td>

		<td class="infoData" rowspan="4">
<%	if (ConstantsServerSide.isHKAH()) { %>
			<center>
			<img id="staffPhoto" src="../admin/staffPhoto.jsp?staffID=<%=staffID %>" height="157" width="120" onerror="this.src='../images/Photo_not_available.jpg';"></img><br>
			<bean:message key="function.staff.isAllowPublicViewPhoto" />
<%		if (createAction || updateAction) {%>
			<input type="checkbox" name="displayPhoto" value="Y"<%="Y".equals(displayPhoto)?" checked":"" %> />
<%		} else {%>
<%			if ("Y".equals(displayPhoto)) { %>
			<font color="green">YES</font>
<%			} else { %>
			<font color="red">No</font>
<%			} %>
			<input type="hidden" name="displayPhoto" value="<%=displayPhoto %>">
<%		} %>
			</center>
<%	} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.lastName" /></td>
		<td class="infoData">
<%	if (!selfView && (createAction || updateAction)) { %>
			<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName %>" maxlength="30" size="50" <% if (selfView) {%>readonly<%} %>>
<%	} else { %>
			<%=lastName==null?"":lastName %><input type="hidden" name="lastName" value="<%=lastName %>">
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="15%">
<%	if (!selfView && (createAction || updateAction)) { %>
			<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>" maxlength="60" size="50" <% if (selfView) {%>readonly<%} %>>
<%	} else { %>
			<%=firstName==null?"":firstName %><input type="hidden" name="firstName" value="<%=firstName %>">
<%	} %>
		</td>

	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="15%" colspan="3">
<%	if (!selfView && (createAction || updateAction)) { %>
			<input type="textfield" name="chiName" value="<%=chiName==null?"":chiName %>" maxlength="128" size="50" <% if (selfView) {%>readonly<%} %>>
<%	} else { %>
			<%=chiName==null?"":chiName %><input type="hidden" name="chiName" value="<%=chiName %>">
<%	} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.email" /></td>
		<td class="infoData" width="15%" colspan="3">
<%	if (!selfView && (createAction || updateAction)) { %>
			<input type="textfield" name="email" value="<%=email==null?"":email %>" maxlength="255" size="50" <% if (selfView) {%>readonly<%} %>>
<%	} else { %>
			<%=email==null?"":email %><input type="hidden" name="email" value="<%=email %>">
<%	} %>
		</td>
	</tr>

	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
		<td class="infoTitle" colspan="5">Employment Info</td>
	</tr>

	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
		<td class="infoLabel"><bean:message key="prompt.department" /> (Main)</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<select name="deptCode">
				<option value=""></option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
<%	} else { %>
			<%=deptDesc==null?"":deptDesc %><input type="hidden" name="deptDesc" value="<%=deptDesc %>">
			<input type="hidden" name="deptCode" value="<%=deptCode%>">
<%	} %>
		</td>
		<td class="infoLabel"><bean:message key="prompt.department" /> <bean:message key="prompt.code" /></td>
		<td class="infoData" colspan="2">
			<%=deptCode==null?"":deptCode %><input type="hidden" name="deptCode" value="<%=deptCode %>">
		</td>
	</tr>
	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
		<td class="infoLabel"><bean:message key="prompt.department" /> (Associated)</td>
		<td class="infoData" colspan="4">
<%	if (createAction || updateAction) { %>
			<table border="0">
				<tr>
					<td>Available Department</td>
					<td>&nbsp;</td>
					<td>Selected Department</td>
				</tr>
				<tr>
					<td>
						<select name="deptCodeList" size="10" multiple id="select1">
<%				try {
					if (deptCodeList != null) {
						for (int i = 0; i < deptCodeList.length; i++) {
%><option value="<%=deptCodeList[i] %>"><%=deptCodeMap.get(deptCodeList[i]) %></option><%
						}
					}
				} catch (Exception e) {} %>
						</select>
					</td>
					<td>
						<button id="add"><bean:message key="button.add" /> >></button><br>
						<button id="remove"><< <bean:message key="button.delete" /></button>
					</td>
					<td>
						<select name="deptCode2" size="10" multiple id="select2">
<%				try {
					if (deptCode2 != null) {
						for (int i = 0; i < deptCode2.length; i++) {
%><option value="<%=deptCode2[i] %>"><%=deptCodeMap.get(deptCode2[i]) %></option><%
						}
					}
				} catch (Exception e) {} %>
						</select>
					</td>
				</tr>
			</table>
<%		} else {
			if (deptCode2 != null) {
				for (int i = 0; i < deptCode2.length; i++) {
					%><%=deptCodeMap.get(deptCode2[i]) %><br/><%
				}
			}
		} %>
		</td>
	</tr>
	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
		<td class="infoLabel"><bean:message key="prompt.status" /></td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<select name="status">
		<%if (ConstantsServerSide.SITE_CODE_TWAH.equals(siteCode)) { %>
				<option value="FTW"<%="FTW".equals(status)?" selected":"" %>>FTW</option>
				<option value="FT"<%="FT".equals(status)?" selected":"" %>>FT</option>
				<option value="CA"<%="CA".equals(status)?" selected":"" %>>CA</option>
				<option value="CAS"<%="CAS".equals(status)?" selected":"" %>>CAS</option>
				<option value="PTW"<%="PTW".equals(status)?" selected":"" %>>PTW</option>
				<option value="MEDM"<%="MEDM".equals(status)?" selected":"" %>>MEDM</option>
				<option value="MEDB"<%="MEDB".equals(status)?" selected":"" %>>MEDB</option>
				<option value="NA"<%="NA".equals(status)?" selected":"" %>>NA</option>
				<option value="RN"<%="RN".equals(status)?" selected":"" %>>RN</option>
				<option value="Others"<%="Others".equals(status)?" selected":"" %>>Others</option>
		<%} else { %>
				<option value="FTW"<%="FTW".equals(status)?" selected":"" %>>FTW</option>
				<option value="FT"<%="FT".equals(status)?" selected":"" %>>FT</option>
				<option value="CA"<%="CA".equals(status)?" selected":"" %>>CA</option>
				<option value="PT"<%="PT".equals(status)?" selected":"" %>>PT</option>
				<option value="UC"<%="UC".equals(status)?" selected":"" %>>UC</option>
				<option value="CAS"<%="CAS".equals(status)?" selected":"" %>>CAS</option>
				<option value="MEDB"<%="MEDB".equals(status)?" selected":"" %>>MEDB</option>
				<option value="Others"<%="Others".equals(status)?" selected":"" %>>Others</option>
		<%} %>
			</select>
<%	} else { %>
			<%=status==null?"":status %><input type="hidden" name="status" value="<%=status %>">
<%	} %>
		</td>
		<td class="infoLabel"><bean:message key="prompt.category" /></td>
		<td class="infoData" colspan="2">
<%
	String eduCategory = StaffDB.getEduCategory(staffID);
%>
			<%=eduCategory == null ? "" : eduCategory %>
		</td>
	</tr>
	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
		<td class="infoLabel"><bean:message key="prompt.positionCode" /></td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="positionCode" value="<%=positionCode==null?"":positionCode %>" maxlength="28" size="10">
<%	} else { %>
			<%=positionCode==null?"":positionCode %><input type="hidden" name="positionCode" value="<%=positionCode %>">
<%	} %>
		</td>
		<td class="infoLabel"><bean:message key="prompt.positionDesc" /></td>
		<td class="infoData" colspan="2">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="position1" value="<%=position1==null?"":position1 %>" maxlength="100" size="40">
			<input type="textfield" name="position2" value="<%=position2==null?"":position2 %>" maxlength="100" size="20">
<%	} else { %>
			<%=(position1==null&&position2==null)?"":position1+" "+position2 %><input type="hidden" name="position1" value="<%=position1 %>">
			<input type="hidden" name="position2" value="<%=position2 %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
		<td class="infoLabel"><bean:message key="prompt.jobCode" /></td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="jobCode" value="<%=jobCode==null?"":jobCode %>" maxlength="28" size="10">
<%	} else { %>
			<%=jobCode==null?"":jobCode %><input type="hidden" name="jobCode" value="<%=jobCode %>">
<%	} %>
		</td>
		<td class="infoLabel"><bean:message key="prompt.jobDesc" /></td>
		<td class="infoData" colspan="2">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="jobDescription" value="<%=jobDescription==null?"":jobDescription %>" maxlength="100" size="40">
<%	} else { %>
			<%=(jobDescription==null)?"":jobDescription %><input type="hidden" name="jobDescription" value="<%=jobDescription %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
		<td class="infoLabel"><bean:message key="prompt.hireDate" /></td>
		<td class="infoData">
<%	if (createAction || updateAction) {%>
			<input type="textfield" name="hireDate" id="hireDate" value="<%=hireDate == null ? "" : hireDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else {%>
			<%=hireDate %>
			<input type="hidden" name="hireDate" value="<%=hireDate %>">
<%	} %>
		</td>
		<td class="infoLabel">Termination Date</td>
		<td class="infoData" colspan="2">
<%	if (createAction || updateAction) {%>
			<input type="textfield" name="terminationDate" id="terminationDate" value="<%=terminationDate == null ? "" : terminationDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else {%>
			<%=terminationDate %>
			<input type="hidden" name="terminationDate" value="<%=terminationDate %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
		<td class="infoLabel"><bean:message key="prompt.annualIncrement" /></td>
		<td class="infoData" colspan="4">
<%	if (createAction || updateAction) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="annual_incr" />
	<jsp:param name="allowEmpty" value="Y" />
	<jsp:param name="monthOnly" value="Y" />
	<jsp:param name="defaultValue" value="N" />
	<jsp:param name="day_mm" value="<%=annual_incr %>" />
</jsp:include>
<%	} else { %>
			<%=annual_incr==null || "".equals(annual_incr)?"":month[Integer.parseInt(annual_incr) - 1] %><input type="hidden" name="annual_incr_mm" value="<%=annual_incr %>">
<%	} %>
		</td>
	</tr>

	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
		<td class="infoLabel">Override HR (Keep active)</td>
		<td class="infoData">
<%	if (createAction || updateAction) {%>
			<select name="isMarkDeleted">
				<option value="N"<%="N".equals(isMarkDeleted)?" selected":"" %>>No</option>
				<option value="Y"<%="Y".equals(isMarkDeleted)?" selected":"" %>>Yes (Keep 6 months only)</option>
				<option value="B"<%="B".equals(isMarkDeleted)?" selected":"" %>>Yes (Board Member only)</option>
			</select>

			<input type="checkbox" name="isMarkDeleted" value="Y" />
<%	} else {%>
<%		if ("Y".equals(isMarkDeleted)) { %>
			<font color="red">YES</font>
<%		} else if ("B".equals(isMarkDeleted)) { %>
			<font color="red">YES</font>
<%		} else { %>
			<font color="green">No</font>
<%		} %>
			<input type="hidden" name="isMarkDeleted" value="<%=isMarkDeleted %>">
<%	} %>
			<br />(If YES, all this staff info will NOT be updated from HR System automatically.<br />Tick this box if the staff account does not exist in HR system.)
		</td>
		<td class="infoLabel">Fix department</td>
		<td class="infoData" colspan="3">
<%	if (createAction || updateAction) {%>
			<input type="checkbox" name="isFixDepartmentCode" value="Y"<%="Y".equals(isFixDepartmentCode)?" checked":"" %> />
<%	} else {%>
<%		if ("Y".equals(isFixDepartmentCode)) { %>
			<font color="red">YES</font>
<%		} else { %>
			<font color="green">No</font>
<%		} %>
			<input type="hidden" name="isFixDepartmentCode" value="<%=isFixDepartmentCode %>">
<%	} %>
			<br />(If YES, this staff's department code will NOT be updated from HR System automatically)
		</td>
	</tr>
<% if (ConstantsServerSide.isHKAH() || ConstantsServerSide.isTWAH()) { %>
	<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
		<td class="infoTitle" colspan="5">Related Accounts</td>
	</tr>
	<% if (!ConstantsServerSide.isHKAH()) { %>	
		<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
			<td class="infoLabel"><%=ConstantsServerSide.getSiteShortForm(ConstantsServerSide.SITE_CODE_HKAH) %></td>
			<td class="infoData" colspan="5">
				<button onclick="return addStaffToSite('hkah')" class="btn-click" id="btn-addStaffToSite_hkah" disabled>Add staff account</button><span id="getStaffSite_ret_hkah"></span>
				<div id="addStaffToSite_ret_hkah"></div>
			</td>
		</tr>	
	<% } %>
	<% if (!ConstantsServerSide.isTWAH()) { %>	
		<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
			<td class="infoLabel"><%=ConstantsServerSide.getSiteShortForm(ConstantsServerSide.SITE_CODE_TWAH) %></td>
			<td class="infoData" colspan="5">
				<button onclick="return addStaffToSite('twah')" class="btn-click" id="btn-addStaffToSite_twah" disabled>Add staff account</button><span id="getStaffSite_ret_twah"></span>
				<div id="addStaffToSite_ret_twah"></div>
			</td>
		</tr>
	<% } %>	
	<% if (!ConstantsServerSide.isAMC1()) { %>	
		<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
			<td class="infoLabel"><%=ConstantsServerSide.getSiteShortForm(ConstantsServerSide.SITE_CODE_AMC1) %></td>
			<td class="infoData" colspan="5">
				<button onclick="return addStaffToSite('amc1')" class="btn-click" id="btn-addStaffToSite_amc1" disabled>Add staff account</button><span id="getStaffSite_ret_amc1"></span>
				<div id="addStaffToSite_ret_amc1"></div>
			</td>
		</tr>
	<% } %>		
	<% if (!ConstantsServerSide.isAMC2()) { %>	
		<tr class="smallText" <%if (selfView) { %>style="display:none;"<%} %>>
			<td class="infoLabel"><%=ConstantsServerSide.getSiteShortForm(ConstantsServerSide.SITE_CODE_AMC2) %></td>
			<td class="infoData" colspan="5">
				<button onclick="return addStaffToSite('amc2')" class="btn-click" id="btn-addStaffToSite_amc2" disabled>Add staff account</button><span id="getStaffSite_ret_amc2"></span>
				<div id="addStaffToSite_ret_amc2"></div>
			</td>
		</tr>
	<% } %>		
<% } %>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction) { %>
			<button onclick="return submitAction('<%="SelfUpdate".equals(command)? command : commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('<%="SelfUpdate".equals(command)? "SelfView" : "view" %>', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else if (deleteAction) { %>
			<button onclick="window.close();">Close</button>
<%	} else if (selfView) { 
		if (ConstantsServerSide.isHKAH() || ConstantsServerSide.isTWAH()) {
%>
			<button onclick="return submitAction('SelfUpdate', 0);" class="btn-click"><bean:message key="function.staff.update.allowPblicViewPhoto" /></button>
<% 		} %>			
			<button onclick="changePassword()" class="btn-click"><bean:message key="prompt.change.password" /></button>				
<% 	} else { %>
			<% if (userBean.isAccessible("function.staff.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.staff.update" /></button><% } %>
			<% if (userBean.isAccessible("function.staff.delete")) { %><button class="btn-delete"><bean:message key="function.staff.delete" /></button><% } %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
</form>
<bean:define id="staffIDLabel"><bean:message key="prompt.staffID" /></bean:define>
<bean:define id="staffNameLabel"><bean:message key="prompt.staffName" /></bean:define>
<script language="javascript">
<!--
	$().ready(function() {
		$('#add').click(function() {
			return !$('#select1 option:selected').appendTo('#select2');
		});
		$('#remove').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});
		
		<% if (ConstantsServerSide.isHKAH() || ConstantsServerSide.isTWAH()) { %>
			<% if (!ConstantsServerSide.isHKAH()) { %>	getStaffSite('hkah');<% } %>
			<% if (!ConstantsServerSide.isTWAH()) { %>	getStaffSite('twah');<% } %>
			getStaffSite('amc1');
			getStaffSite('amc2');
		<% } %>
	});

	$('form').submit(function() {
		$('#select2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
	});

	// validate signup form on keyup and submit
	$("#form1").validate({
		rules: {
<%	if (createAction) { %>
			staffID: { required: true, minlength: 5 },
<%	} %>
			staffName: { required: true, minlength: 2 }
		},
		messages: {
<%	if (createAction) { %>
			staffID: { required: "<bean:message key="error.staffID.required" />", minlength: "<bean:message key="errors.minlength" arg0="<%=staffIDLabel %>" arg1="4" />" },
<%	} %>
			staffName: { required: "<bean:message key="error.staffName.required" />", minlength: "<bean:message key="errors.minlength" arg0="<%=staffNameLabel %>" arg1="2" />" }
		}
	});

	function changePassword() {
		window.location.href = "../admin/change_password.jsp";
	}
	
	function addStaffToSite(site) {
        $.ajax({
			url: "staff_update.jsp",
			data: {command: "createOtherSite", siteCode: site, staffID: "<%=staffID %>"},
			async: true,
			cache: false,
			success: function(values){
				var mVal = JSON.parse(values.trim())["message"];
				var emVal = JSON.parse(values.trim())["errorMessage"];
				$("#addStaffToSite_ret_" + site).html(mVal + emVal);
				getStaffSite(site);
			},
			error: function() {
			}
		});
        return false;
	}
	
	function getStaffSite(site) {
        $.ajax({
			url: "staff_update.jsp",
			data: {command: "staffAccOtherSite", siteCode: site, staffID: "<%=staffID %>"},
			async: true,
			cache: false,
			success: function(values){
				var val = JSON.parse(values.trim())["message"];
				$("#getStaffSite_ret_" + site).html(val);
				if (val == '') {
					$("#btn-addStaffToSite_" + site).removeAttr("disabled");
				} else {
					$("#btn-addStaffToSite_" + site).attr("disabled", true);
				}
			},
			error: function() {
				$("#getStaffSite_ret_" + site).html("cannot get staff info");
			}
		});
	}

	function submitAction(cmd, stp) {
		if (cmd == 'create' || cmd == 'update') {
<%	if (createAction) { %>
			if (document.form1.staffID.value == '') {
				alert("<bean:message key="error.staffID.required" />.");
				document.form1.staffID.focus();
				return false;
			}
<%	} %>
<%	if (createAction || updateAction) { %>
			if (document.form1.staffName.value == '') {
				alert("<bean:message key="error.staffName.required" />.");
				document.form1.staffName.focus();
				return false;
			}
			if (document.forms["form1"].elements["staffName"].value == "") {
				alert("<bean:message key="error.staffName.required" />");
				document.forms["form1"].elements["staffName"].focus();
				return false;
			}
			if (document.forms["form1"].elements["staffName"].value.length < 2) {
				alert("<bean:message key="errors.minlength" arg0="<%=staffNameLabel %>" arg1="2" />");
				document.forms["form1"].elements["staffName"].focus();
				return false;
			}
			selectItem('form1', 'deptCode2');
<%	} %>
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

<%	if (updateAction) { %>
		removeDuplicateItem('form1', 'deptCodeList', 'deptCode2');
<%	} %>
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>