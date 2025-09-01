<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%!
public static ReportableListObject getLocation(String locCode) {
	
	ReportableListObject row = null;
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT l.LOC_CODE, l.LOC_NAME, l.LOC_OWNER, l.EMAIL  ");
	sqlStr.append(" FROM lm_location l ");
	sqlStr.append(" WHERE l.LOC_CODE = ? ");
	
	ArrayList rec =  UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { locCode });
	
	if (rec.size() > 0) {
		row = (ReportableListObject) rec.get(0);			
	}
	
	return row;
}

public static ArrayList getStaffList(String locCode) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT R.LOC_CODE, R.STAFF_ID, S.CO_STAFFNAME ");
	sqlStr.append(" FROM   LM_UPLOAD_RIGHT R LEFT OUTER JOIN  CO_STAFFS S ON R.STAFF_ID = S.CO_STAFF_ID ");
	sqlStr.append(" WHERE  R.LOC_CODE = ? ");
	sqlStr.append(" ORDER BY S.CO_STAFFNAME, R.STAFF_ID ");

	return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { locCode });
}

public static boolean addLocation(UserBean userBean, String locCode, String owner, String email) {
	
	StringBuffer sqlStr = new StringBuffer();
	String updateUser =  userBean.getStaffID();
		
	sqlStr.append("insert into lm_location ");
	sqlStr.append(" (LOC_OWNER, EMAIL, UPDATE_USER, LOC_CODE) ");
	sqlStr.append(" VALUES (?, ?, ?, ?) ");
		
	if (UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{owner, email, updateUser,  locCode})) {
		grantAccess(updateUser, "function.leaflet.main", owner);
		return true;
	} 
	
	return false;
}

public static boolean updateLocation(UserBean userBean, String locCode, String owner, String email, String locName) {
	
	String updateUser =  userBean.getStaffID();
	
	grantAccess(updateUser, "function.leaflet.main", owner);

	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("update lm_location ");
	sqlStr.append(" set LOC_OWNER = ?, ");
	sqlStr.append(" email = ?, ");
	sqlStr.append(" UPDATE_USER = ?, ");
	sqlStr.append(" LOC_NAME = ? ");
	sqlStr.append(" where LOC_CODE = ? ");
	
	return UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{owner, email, updateUser, locName, locCode});
}

public static boolean addRight(UserBean userBean, String locCode, String staffId) {

	String updateUser = userBean.getStaffID();

	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("insert into LM_UPLOAD_RIGHT (LOC_CODE, STAFF_ID, UPDATE_USER)");
	sqlStr.append(" VALUES (?, ?, ?) ");
	
	return UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{locCode, staffId, updateUser});
}

public static boolean delRight(String locCode, String staffId) {
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("delete LM_UPLOAD_RIGHT ");
	sqlStr.append(" WHERE LOC_CODE = ? and STAFF_ID = ? ");
	
	return UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{locCode, staffId});
}

public static boolean grantAccess(String updateUser, String functionId, String staffId) {
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("select CO_STAFF_ID from co_staffs ");
	sqlStr.append(" WHERE CO_STAFF_ID = ? and CO_ENABLED = 1 ");
	
	ArrayList rec =  UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffId });

	if (rec.size() <= 0) {
		return false;
	}
	
	sqlStr = new StringBuffer();

	sqlStr.append("select * from AC_FUNCTION_access ");
	sqlStr.append(" WHERE ac_function_id = ? and ac_staff_id = ? ");
	
	rec =  UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { functionId, staffId });
	System.out.println("Grand access");
	
	if (rec.size() <= 0) {
		
		sqlStr = new StringBuffer();

		sqlStr.append("Insert into AC_FUNCTION_access (AC_FUNCTION_ID,AC_SITE_CODE,AC_STAFF_ID,AC_GROUP_ID,AC_ACCESS_MODE,AC_CREATED_DATE,AC_CREATED_USER,AC_MODIFIED_DATE,AC_MODIFIED_USER,AC_ENABLED) "); 
		sqlStr.append("	select ?, co_site_code, co_staff_id,'ALL','F',sysdate, ?, sysdate, ?, 1 from CO_USERS ");
		sqlStr.append(" where co_staff_id = ? ");
		
		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{ functionId, updateUser, updateUser, staffId });
	}
			
	return true;
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

String locCode = request.getParameter("locCode");
String locName = TextUtil.parseStrUTF8(request.getParameter("locName"));
String owner = request.getParameter("owner");
String email = request.getParameter("email");
String command = request.getParameter("command");
String staffId = request.getParameter("staffId");

ReportableListObject row = null;

if ("edit".equals(command)) {
	row = getLocation(locCode);
	if (row == null) {
		errorMessage = "Location not found";
	} else {
		locName = row.getValue(1);
		owner = row.getValue(2);
		email = row.getValue(3);
	}
} else if ("updLoc".equals(command)) {
	if (updateLocation(userBean, locCode, owner, email, locName)) {
		message = "Updated";
	} else {
		errorMessage = "Failed to update";
	}
	command = "edit";
} else if ("addRight".equals(command)) {
	if (!addRight(userBean, locCode, staffId)) {
		errorMessage = "Failed to add user right";
	}
	command = "edit";
} else if ("delRight".equals(command)) {
	if (!delRight(locCode, staffId)) {
		errorMessage = "Failed to remove user right";
	}
	command = "edit";
} else if ("insLoc".equals(command)) {
	
	row = getLocation(locCode);
	
	if (row != null) {
		message = "Location code already exists";
		errorMessage = "Location create failed";
		command = "new";
	} else {
		
		if ( addLocation(userBean, locCode, owner, email) ){
			command = "edit";
		} else {
			errorMessage = "Location create failed";
			command = "new";
		}
	}
} 

request.setAttribute("staff_list", getStaffList(locCode));

boolean accessable = false;

if ( (userBean.isAccessible("function.leaflet.admin")) || (staffID.equals(owner)) )
	accessable = true;
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
	<jsp:param name="pageTitle" value="PFE Information Administration (Location)" />
	<jsp:param name="pageTitleEncode" value="UTF8" />
	<jsp:param name="pageMap" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="form1" action="lms_loc_entry.jsp" method="post">

<input type="hidden" name="command" id="command" value="<%=command==null?"":command %>">

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
		<tr class="smallText">
		<td class="infoLabel" width="20%">Location</td>
		<td class="infoData" width="80%">
			<input type="textfield" name="locCode" id="locCode" value="<%=locCode==null?"":locCode %>" <%="new".equals(command)?"":"readonly" %>  maxlength="10" size="5" />
			<input type="textfield" name="locName" id="locName" value="<%=locName==null?"":locName %>" maxlength="100" size="50" />			
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Owner</td>
		<td class="infoData" width="80%">
			<input type="textfield" name="owner" id="owner" value="<%=owner==null?"":owner %>" <%=userBean.isAccessible("function.leaflet.admin")?"":"readonly" %>  maxlength="10" size="10" />			
			<button id="ownerSrc" <%=userBean.isAccessible("function.leaflet.admin")?"":"disabled" %> ><img src="../images/search.gif"/></button>
			<span id="ownerName"></span>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Email list</td>
		<td class="infoData" width="80%"><input type="textfield" name="email" id="email" value="<%=email==null?"":email %>" size=90 /></td>
	</tr>
</table>

<div id="new">
<center><button id="save"><bean:message key="button.save" /></button> 
<button id="close"><bean:message key="button.close" /></button></center>
</div>

<div id="edit">
<center><button id="updLoc"><bean:message key="button.update" /></button></center>
<br />
<hr /><br />
<div style="font-size:150%;text-align:center">Uploading Right</div>
<br />
Staff No: <input type="textfield" name="staffId" id="staffId" maxlength="10" size="10" /><button id="addRight"><bean:message key="button.add" /></button>
<button id="staffSrc" ><img src="../images/search.gif"/></button>
<span id="staffName"></span>
<br />
<display:table id="staffList" name="requestScope.staff_list" class="tablesorter">
	<display:column property="fields1" title="Staff ID" style="width:10%" />
	<display:column property="fields2" title="Staff Name" style="width:80%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return delRight('<c:out value="${staffList.fields1}" />');"><bean:message key='button.delete' /></button>
	</display:column>
</display:table>
<center><button id="close"><bean:message key="button.close" /></button></center>
</div>

</form>
<script language="javascript">
<!--
//IE compatibility
if (typeof console=="undefined") var console={ log: function(x) {document.getElementById('msg').innerHTML=x} };
 
if(typeof String.prototype.trim !== 'function') {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, ''); 
  }
}

	$(document).ready(function(){
<% if (!accessable) { %>
		alert("Access Deny!");
		window.close();
<% } %>

		if ($("#command").val() != "new") {
			document.getElementById("new").innerHTML = "";
		}
		
		if ($("#command").val() != "edit") {
			document.getElementById("edit").innerHTML = "";
		}

		if ($("#command").val() == "close") {
			opener.location.reload();
			window.close();
		}

		getStaff($("#owner").val(), "ownerName");
		
		$("#owner").keyup (function(){
			getStaff($("#owner").val(), "ownerName");
		});
		
		$("#staffId").keyup (function(){
			getStaff($("#staffId").val(), "staffName");
		});
		
		$("#save").click(function(){		
			$("#command").val("insLoc");
			$("#form1").submit();
		});
		
		$("#updLoc").click(function(){			
			$("#command").val("updLoc");
			$("#form1").submit();
		});
		
		$("#addRight").click(function(){			
			$("#command").val("addRight");
			$("#form1").submit();
		});
		
		$("#close").click(function(){
			opener.location.reload();
			window.close();
			return false;
		});
		
		$("#ownerSrc").click(function(){
			var html = '<input type="text" id="txtOwnerSrc" name="txtOwnerSrc" onkeyup="search(0)">';			
			html += "<br /><span id='ownerList'></span>" 				
			document.getElementById("ownerName").innerHTML = html
			return false;
		});
		
		$("#staffSrc").click(function(){
			var html = '<input type="text" id="txtStaffSrc" name="txtStaffSrc" onkeyup="search(1)">';			
			html += "<br /><span id='staffList'></span>" 				
			document.getElementById("staffName").innerHTML = html
			return false;
		});
	});
	
	function delRight(staffId) {
		$("#command").val("delRight");
		$("#staffId").val(staffId);
		$("#form1").submit();
	}

	function getStaff(value, target) {
		
		var d = new Date();
		var n = d.getTime();
		
		$.post("getStaff.jsp",
			{
				staffId: value,
				time: n
			},
			function(data, status){
				document.getElementById(target).innerHTML = "";
				
				if (status == "success") {
					var obj = JSON.parse(data);
					document.getElementById(target).innerHTML = obj[0]["name"];							
				} else {
					alert(status);
				}
			});			
	}
	
	function search(type) {
		var d = new Date();
		var n = d.getTime();
		var spanId;
		var input;
		var html;
				
		if (type == 0) {
			html = '<select name="selOwner" id="selOwner" size=5 onchange="setOwner()">';
			spanId = "ownerList";
			input = $("#txtOwnerSrc").val();
		} else if (type == 1)  {
			html = '<select name="selStaff" id="selStaff" size=5 onchange="setStaff()">';
			spanId = "staffList";
			input = $("#txtStaffSrc").val();
		}
		
		$.post("getStaff.jsp",
			{
				name: input,
				time: n
			},
			function(data, status){
				
				document.getElementById(spanId).innerHTML = "";
				
				if (status == "success") {
					var i;
					var obj = JSON.parse(data);
					
					for (i in obj) {
						html += '<option value="' + obj[i]["staffId"] + '">';
						html += obj[i]["name"];
						html += ' (' + obj[i]["staffId"] + ')';
						html += '</option>';
					}
					
					html += "</select>";
					document.getElementById(spanId).innerHTML = html;				
				} else {
					alert(status);
				}
			});		
	}
	
	function setOwner() {
		$("#owner").val( $("#selOwner").val() );
		getStaff($("#selOwner").val(), "ownerName");
		//document.getElementById("ownerName").innerHTML = "";
	}
	
	function setStaff() {  
		$("#staffId").val( $("#selStaff").val() );
		getStaff($("#selStaff").val(), "staffName");
		//document.getElementById("staffName").innerHTML = "";
	}
			
-->	
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>