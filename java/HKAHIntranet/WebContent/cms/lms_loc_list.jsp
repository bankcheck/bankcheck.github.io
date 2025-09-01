<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>

<%!
public static ArrayList getLocationList() {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT l.LOC_CODE, l.LOC_NAME, l.LOC_OWNER, l.EMAIL, s.co_staffname  ");
	sqlStr.append(" FROM lm_location l ");
	sqlStr.append(" LEFT JOIN co_staffs s on l.loc_owner = s.co_staff_id ");
	sqlStr.append(" ORDER BY l.LOC_NAME ");
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean delLocation(UserBean userBean, String locCode) {
	
	String updateUser =  userBean.getStaffID();
	
	StringBuffer sqlStr = new StringBuffer();		
	sqlStr.append("UPDATE co_document ");
	sqlStr.append(" SET CO_ENABLED = 0, ");
	sqlStr.append(" CO_MODIFIED_DATE = SYSDATE, ");
	sqlStr.append(" CO_MODIFIED_USER = ? ");
	sqlStr.append(" WHERE CO_DOCUMENT_ID in ");
	sqlStr.append(" ( SELECT DOCUMENT_ID FROM lm_leaflet WHERE LOC_CODE = ? ) ");

	UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{updateUser, locCode});
	
	sqlStr = new StringBuffer();		
	sqlStr.append("UPDATE lm_leaflet ");
	sqlStr.append(" SET ENABLE = 0, ");
	sqlStr.append(" UPDATE_DATE = SYSDATE, ");
	sqlStr.append(" UPDATE_USER = ? ");
	sqlStr.append(" WHERE LOC_CODE = ? ");
	
	UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{updateUser, locCode});
	
	sqlStr = new StringBuffer();		
	sqlStr.append("DELETE lm_LOCATION ");
	sqlStr.append(" WHERE LOC_CODE = ? ");
	
	return UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{ locCode });
}
%>
<%
UserBean userBean = new UserBean(request);
boolean isAdmin = userBean.isAccessible("function.leaflet.admin");

String staffID = userBean.getStaffID();
String message = request.getParameter("message");

if (message == null) {
	message = "";	
}
String errorMessage = "";

String command = request.getParameter("command");
String locCode = request.getParameter("locCode");

if ("delete".equals(command)) {
	if ( isAdmin ) {
		if ( delLocation(userBean, locCode) ) {
			message = "Deleted";
		} else {
			errorMessage = "Failed to delete";
		}
	} else {
		message = "Access Deny!";
	}
}

request.setAttribute("location_list", getLocationList());
	
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.leaflet.main" />
	<jsp:param name="pageSubTitle" value="Location List" />
</jsp:include><jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="form1" method="post">
<display:table id="row" name="requestScope.location_list" class="tablesorter" >
	<display:column property="fields0" title="Code" style="width:10%" />
	<display:column property="fields1" title="Name" style="width:65%" />
	<display:column property="fields4" title="Owner" style="width:10%" />
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<button onclick="return editAction('<c:out value="${row.fields0}" />', '<c:out value="${row.fields2}" />');"><bean:message key='button.edit' /></button>
		<button onclick="return delAction('<c:out value="${row.fields0}" />');"><bean:message key='button.delete' /></button>		
	</display:column>
</display:table>
<% if (isAdmin) { %>
	<center><button onclick="return newAction();"><bean:message key="button.add" /></button></center>
<% } %>
<input type="hidden" name="command" id="command">
<input type="hidden" name="locCode" id="locCode">
</form>
<script language="javascript">
<!--
	function newAction() {
		callPopUpWindow("lms_loc_entry.jsp?command=new");
		return false;
	}
	
	function editAction(locCode, owner) {
		$("#command").val("edit");
	<% if (isAdmin) { %>
			callPopUpWindow("lms_loc_entry.jsp?command=edit&locCode=" + locCode);
	<% } else { %>
			if (owner == "<%=staffID %>") {
				callPopUpWindow("lms_loc_entry.jsp?command=edit&locCode=" + locCode);
			} else {
				alert("Access Deny");
			}
	<% } %>
	}
	
	function delAction(locCode) {
	<% if (isAdmin) { %>
	
		var r = confirm("You are about to delete a location. All leaflets under the location will be inaccessible. Press OK to confirm.");
	
		if (r == true) {
			$("#command").val("delete");
			$("#locCode").val(locCode);
			document.form1.action = "lms_loc_list.jsp";
			document.form1.submit();
		}
		
	<% } else { %>
		alert("Access Deny");
	<% } %>		
		return false;
	}
-->	
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>