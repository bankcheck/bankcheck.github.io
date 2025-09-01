<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
public static ArrayList getLocationList() {	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT l.LOC_CODE, l.LOC_NAME ");
	sqlStr.append(" FROM lm_location L ");
	
	return  UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getLeafletList( UserBean userBean, String locCode, String showAll ) {
	
	String staffId = userBean.getStaffID();
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT L.CAT, L.leaflet_code, D.CO_DESCRIPTION, TO_CHAR(L.UPDATE_DATE, 'YYYY/MM/DD'), "); 
	sqlStr.append("	TO_CHAR(L.EXP_DATE, 'YYYY/MM/DD'), L.PRODUCE_BY, L.ENABLE, "); 
	sqlStr.append(" DECODE(CO_EXTERNAL_LINK, 'Y', D.CO_LOCATION, 'N', '../documentManage/download.jsp?documentID=' || L.DOCUMENT_ID ), ");
	
	if ( isAdmin(userBean, locCode) )
		sqlStr.append(" 'ENABLE' ");
	else
		sqlStr.append(" 'DISABLE' ");
	
	sqlStr.append(" FROM LM_LEAFLET L ");
	sqlStr.append(" LEFT OUTER JOIN CO_DOCUMENT D ON L.DOCUMENT_ID = D.CO_DOCUMENT_ID ");
	sqlStr.append(" WHERE LOC_CODE = '" + locCode + "' ");
		
	if ( !"on".equals(showAll) )
		sqlStr.append(" AND ENABLE = 1 ");
	
	sqlStr.append(" ORDER BY L.CAT, L.LEAFLET_CODE ");
	
	return  UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean isAdmin(UserBean userBean, String locCode) {
	
	
	if (userBean.isAccessible("function.leaflet.admin"))
		return true;
	
	String staffId = userBean.getStaffID();
	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append(" SELECT * from lm_location l ");
	sqlStr.append(" LEFT OUTER JOIN lm_UPLOAD_RIGHT r on l.loc_code = r.loc_code ");
	sqlStr.append(" WHERE l.LOC_CODE = '" + locCode + "' " );
	sqlStr.append(" AND (l.LOC_owner = '" + staffId + "' " );
	sqlStr.append(" OR r.STAFF_ID = '" + staffId + "') " );
	
	ArrayList rec = UtilDBWeb.getReportableList(sqlStr.toString());
	
	if  (rec.size() > 0 )
		return true;
	
	return false;
}

public static boolean setLeafletEnable(UserBean userBean, String leafletCode, String enable, String locCode) {
	
	if (!isAdmin(userBean, locCode))
		return false;
		
	String staffId = userBean.getStaffID();
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE LM_LEAFLET ");
	sqlStr.append(" SET ENABLE = ?, ");
	sqlStr.append(" update_user = ?, ");
	sqlStr.append(" update_date = sysdate ");
	sqlStr.append(" WHERE LEAFLET_CODE = ? ");
	sqlStr.append(" And LOC_CODE = ? ");
	
	return UtilDBWeb.updateQueue( sqlStr.toString(),
		new String[] { enable, staffId, leafletCode, locCode });
}
%>
<%
UserBean userBean = new UserBean(request);
String locCode = request.getParameter("locCode"); 

String showAll = null; 
String command = null; 
String leafletCode = null; 

if (isAdmin(userBean, locCode)) {
	showAll = request.getParameter("showAll"); 
	command = request.getParameter("command"); 
	leafletCode = request.getParameter("leafletCode");
}

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

if ("enable".equals(command)) {
	if (setLeafletEnable(userBean, leafletCode, "1", locCode)){
		message = leafletCode + " enabled";
	} else {
		errorMessage = "Fail to update";
	}
} else if ("disable".equals(command)) {
	if (setLeafletEnable(userBean, leafletCode, "0", locCode)){
		message = leafletCode + " disabled";
	} else {
		errorMessage = "Fail to update";
	}
}

request.setAttribute("leaflet_List", getLeafletList(userBean, locCode, showAll));

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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

<body lang=EN-US style='text-justify-trim:punctuation'>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Patient & Family Education (PFE) Information" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="form1" id="form1" action="lms_leaflet_list.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%">Location</td>
		<td class="infoData" width="80%"><select name="locCode" id="locCode">
			<option value="" >-- Location --</option>
<%
ArrayList rec = getLocationList();
ReportableListObject row = null;

for (int i = 0; i < rec.size(); i++) {	
	row = (ReportableListObject)rec.get(i);
%>		
			<option value="<%=row.getValue(0) %>" <%=row.getValue(0).equals(locCode)?"selected":"" %> ><%=row.getValue(1) %></option>
<%
}
%>			
		</select>
		</td>	
	</tr>
<%
	if (isAdmin(userBean, locCode)) {
%>	
	<tr class="smallText">
		<td /><td >
			<input type="checkbox" name="showAll" id="showAll" <%="on".equals(showAll)?"checked":"" %> /> Include disabled leaflets
			</td>		
	</tr>
<%
	}
%>		
</table>

<display:table id="tab" name="requestScope.leaflet_List" class="tablesorter">
	<display:column property="fields0" title="Category" style="width:15%" />
	<display:column property="fields1" title="Code" style="width:10%" />	
	<display:column  media="html" title="Topic" style="width:30%" >
		<a href="<c:out value="${tab.fields7}"/>" target="_blank"><c:out value="${tab.fields2}"/></a>
	</display:column>
	<display:column property="fields3" title="Last Revision" style="width:10%" />
	<display:column property="fields4" title="Next Revision" style="width:10%" />
	<display:column property="fields5" title="Produce By" style="width:15%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<logic:equal name="tab" property="fields8" value="ENABLE">				
			<button onclick="return editAction('<c:out value="${tab.fields1}" />');"><bean:message key='button.edit' /></button>
			
			<logic:equal name="tab" property="fields6" value="1">
				<button onclick="return disableAction('<c:out value="${tab.fields1}" />');">Disable</button>
			</logic:equal>
			<logic:notEqual name="tab" property="fields6" value="1">
				<button onclick="return enableAction('<c:out value="${tab.fields1}" />');">Enable</button>
			</logic:notEqual>
		</logic:equal>
	</display:column>
</display:table>
<%
	if (isAdmin(userBean, locCode)) {
%>	
		<center><button id="new"><bean:message key="button.add" /></button></center>
<%
	}
%>		
<input type="hidden" name="locCode" id="locCode" value="<%=locCode==null?"":locCode %>"/>
<input type="hidden" name="command" id="command" />
<input type="hidden" name="leafletCode" id="leafletCode" />
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
	$( "#locCode" ).change(function() {
		$("#form1").submit();
	});
	
	$( "#showAll" ).click(function() {
		$("#form1").submit();
	});
	
	$( "#new" ).click(function() {
		
		if ( $( "#locCode" ).val() == "" )
			alert("Please select a location");
		else
			callPopUpWindow("lms_leaflet_entry.jsp?command=new&locCode=" + $("#locCode").val());
		
		return false;
	});
});

function editAction(val) {
	var locCode = $("#locCode").val();
	callPopUpWindow("lms_leaflet_entry.jsp?command=edit&leafletCode=" + val + "&locCode=" + locCode);
	return false;
}

function enableAction(val) {
	$("#command").val("enable");
	$("#leafletCode").val(val);
	$("#form1").submit();
}

function disableAction(val) {
	$("#command").val("disable");
	$("#leafletCode").val(val);
	$("#form1").submit();
}
-->
</script>
</DIV>
</DIV>
</DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>
