<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%
UserBean userBean = new UserBean(request);

String type = request.getParameter("type");

Enumeration paramNames = request.getParameterNames();
String[] successValues = null;
String[] failValues = null;
while(paramNames.hasMoreElements())
{
    String paramName = (String)paramNames.nextElement();
    
    if("success".equals(paramName)){
        successValues = request.getParameterValues(paramName);     
    }
    if("fail".equals(paramName)){
        failValues = request.getParameterValues(paramName);     
    }
}

String pageTitle = "";
if("email".equals(type)){
	pageTitle = "Email sent result";
}else{
	pageTitle = "SMS sent result";
}

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
<jsp:include page="header.jsp"/>
<body>
<jsp:include page="../../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="" method="post">

</form>
<bean:define id="functionLabel"><bean:message key="function.event.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" method="post">
<div id="tableContainer">
<table id="row" border="1" class="tablesorter">
	<thead>
		<tr>
			<th class="header"> </th>
			<th class="header">Client Name</th>
			<th class="header">Client <%=("email".equals(type)?"Email":"Mobile") %></th>
			<th class="header">Status</th>
		</tr>
	</thead>
	<tbody>
<%
		int i = 1;
		if(successValues != null){
			for(String clientID:successValues){
				ArrayList clientInfoRecord = CRMClientDB.get(clientID);
				String clientName = "";
				String clientSendTypeValue = "";
				String sendStatus = "Success";
				if(clientInfoRecord.size()>0){
					ReportableListObject clientInfoRow = (ReportableListObject)clientInfoRecord.get(0);
					clientName = clientInfoRow.getValue(0) + ", " + clientInfoRow.getValue(1); 
					if("email".equals(type)){
						clientSendTypeValue = clientInfoRow.getValue(29);
					}else{
						clientSendTypeValue = clientInfoRow.getValue(27);
					}
				}	
%>
		<tr><td><%=i++ +")" %></td><td><%=clientName %></td><td><%=clientSendTypeValue%></td><td><%=sendStatus%></td></tr>
<%			
			}	
		}
		if(failValues != null){
			for(String clientID:failValues){
				ArrayList clientInfoRecord = CRMClientDB.get(clientID);
				String clientName = "";
				String clientSendTypeValue = "";
				String sendStatus = "Fail";
				if(clientInfoRecord.size()>0){
					ReportableListObject clientInfoRow = (ReportableListObject)clientInfoRecord.get(0);
					clientName = clientInfoRow.getValue(0) + ", " + clientInfoRow.getValue(1); 
					if("email".equals(type)){
						clientSendTypeValue = clientInfoRow.getValue(29);
					}else{
						clientSendTypeValue = clientInfoRow.getValue(27);
					}
				}
%>
			<tr><td><%=i++ +")" %></td><td><%=clientName%></td><td><%=clientSendTypeValue%></td><td><%=sendStatus%></td></tr>
<%			
			}
		}
%>
	</tbody>
</table>
</div>
</form>
<script language="javascript">
	function submitSearch() {
		
	}

	function clearSearch() {
		
	}

	function submitAction(cmd, cid, sid) {		
	
	}		
</script>
<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html>