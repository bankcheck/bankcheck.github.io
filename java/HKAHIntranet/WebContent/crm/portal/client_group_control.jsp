<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String step = request.getParameter("step");
String groupID = request.getParameter("clientGroupID");
String groupDesc = request.getParameter("clientGroupDesc");


boolean select2IsEmpty = "Y".equals(request.getParameter("select2IsEmpty"));
String clientID[] = request.getParameterValues("clientID");
String clientIDDesc[] = null;
boolean clientIDSelect2IsEmpty = "Y".equals(request.getParameter("clientIDSelect2IsEmpty"));	
boolean updateAction = false;

String message = "";
String errorMessage = "";

if ("update".equals(command)) {
	updateAction = true;
}

try {
	
	if ("1".equals(step)) {			
		// clean up user access control
		
		if (clientID != null || clientIDSelect2IsEmpty) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_CLIENTS ");
			sqlStr.append("SET CRM_GROUP_ID = null, ");
			sqlStr.append("CRM_MODIFIED_DATE = sysdate ");
			sqlStr.append("WHERE CRM_GROUP_ID = '"+groupID+"' ");
			sqlStr.append("AND CRM_ENABLED = 1 ");
			

			UtilDBWeb.updateQueue(
				sqlStr.toString());
		}
		
	
		
		boolean userSuccess = false;		
		if (updateAction) {
			
			if (clientID != null) {
				for (int i = 0; i < clientID.length; i++) {
					StringBuffer sqlStr = new StringBuffer();
					sqlStr = new StringBuffer();
					sqlStr.append("UPDATE CRM_CLIENTS ");
					sqlStr.append("SET CRM_GROUP_ID = '"+groupID+"', ");
					sqlStr.append("CRM_MODIFIED_DATE = sysdate ");
					sqlStr.append("WHERE CRM_CLIENT_ID = '"+ clientID[i]+"' ");
					sqlStr.append("AND CRM_ENABLED = 1 ");
					
					if (UtilDBWeb.updateQueue(sqlStr.toString())) {
						userSuccess = true;
					}
				}
			} else {
				userSuccess = true;
			}
			
			if (userSuccess) {
				message = "Access control updated.";
				updateAction = false;
			} else {
				errorMessage = "Access control update fail.";
			}
		}
	}
	
	// load data from database
	if (groupID != null && groupID.length() > 0) {
		StringBuffer sqlStr = new StringBuffer();
		ArrayList record =null;
		
		
		sqlStr.setLength(0);
		
		sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME ");
		sqlStr.append("FROM   CRM_CLIENTS ");
		sqlStr.append("WHERE  CRM_GROUP_ID = ? ");
		sqlStr.append("AND    	CRM_ENABLED = 1 ");
		sqlStr.append("ORDER BY CRM_LASTNAME, CRM_FIRSTNAME");
		
		
		record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { groupID });
		if (record.size() > 0) {
			clientID = new String[record.size()];
			clientIDDesc = new String[record.size()];
			ReportableListObject row = null;
		
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				String tempClientID = row.getValue(0);
				String clientName = row.getValue(1) +", "+row.getValue(2);
				clientID[i] = tempClientID;
				clientIDDesc[i] = clientName;
			}
		} else {
			clientID = null;
			clientIDDesc = null;
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<script type="text/javascript" src="<html:rewrite page="/js/filterlist.js" />"></script> 
<html:html xhtml="true" lang="true">
<style>

.dataSummary {
	border-left:1px solid #000; 
	border-top:1px solid #000; 
	border-right:1px solid #CCC; 
	border-bottom:1px solid #ccc;
	cursor: pointer;
	
}

.zero{background:#FF8C8C}
.one{background:#A0D7D7}
.two{background:#50D050}
.three{background:#E178E1}
.four{background:#DAB35F}
.five{background:#8C8CFF}

	body {
		font: 0.8em arial, helvetica, sans-serif;
	}
	
    #header ul {
		list-style: none;
		padding: 0;
		margin: 0;
    }
    
	#header li {
		float: left;
		border: 1px solid #bbb;
		border-bottom-width: 0;
		margin: 0;
    }
    
	#header a {
		text-decoration: none;
		display: block;
		background: #eee;
		padding: 0.24em 1em;
		color: #00c;
		width: 10em;
		text-align: center;
    }
	
	#header a:hover {
		background: #ddf;
	}
	
	#header .selected {
		border-color: black;
	}
	
	#header .selected a {
		position: relative;
		top: 1px;
		background: white;
		color: black;
		font-weight: bold;
	}
	
	.pageContent {		
		clear: both;
		width:100%;	
	}
	
	h1 {
		margin: 0;
		padding: 0 0 1em 0;
	}
</style>
<jsp:include page="header.jsp"/>
<body>
<jsp:include page="../../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (updateAction) {
		commandType = "update";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.crm.group.control." + commandType;
%>
<jsp:include page="../../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="client_group_control.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.crm.group" /></td>
		<td class="infoData" width="70%">
			<%=groupDesc==null?"":groupDesc %>
		</td>
	</tr>
	
		
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.clientName" /></td>
		<td class="infoData" width="70%">
<%			if (updateAction) { %>
			<table border="0">
				<tr>
					<td>Avaliable Clients</td>
					<td>&nbsp;</td>
					<td>Selected Clients</td>
				</tr>
				<tr>
					<td>
						<select name="clientIDAvailable" size="10" multiple id="clientIDSelect1">
							<jsp:include page="../../ui/clientIDCMB.jsp" flush="true" >
								<jsp:param name="isTeam20" value="Y" />
							</jsp:include>
						</select>
						<div>
							<bean:message key="button.search" />:&nbsp;
							<input name="searchField1" onkeyup="myfilter1.set(this.value, event)" />
						</div>
					</td>
					<td>
						<button id="add2"><bean:message key="button.add" /> &gt;&gt;</button><br>
						<button id="remove2">&lt;&lt; <bean:message key="button.delete" /></button>
					</td>
								 
					 <td>
						<select name="clientID" size="10" multiple id="clientIDSelect2">
							<% request.setAttribute("clientIDCMB_filterValues", clientID); %>
							<jsp:include page="../../ui/clientIDCMB.jsp" flush="true">
								<jsp:param name="isFilterValues" value="Y" />
							</jsp:include>
						</select>
						<div>
							<bean:message key="button.search" />:&nbsp;
							<input name="searchField2" onkeyup="myfilter2.set(this.value, event)"/>
						</div>
					</td>
				</tr>
			</table>
<%			} else {
				if (clientID != null) {
					for (int i = 0; i < clientID.length; i++) {
						try {
%><bean:message key="<%=clientIDDesc[i] %>" /><br/><%
						} catch (Exception e) {
%><%=clientIDDesc[i] %><br/><%
						}
					}
				}
			} %>
			<input type="hidden" name="clientIDSelect2IsEmpty" value="N" />
		</td>
	</tr>

</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (updateAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - Update Clients Group</button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - Update Clients Group</button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click">Update Clients Group</button>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="clientGroupID" value="<%=groupID%>">
<input type="hidden" name="clientGroupDesc" value="<%=groupDesc%>">
</form>

<%
if (!updateAction) {
%>

<jsp:include page="client_list.jsp">
	<jsp:param name="type" value="teamMember" />    
    <jsp:param name="groupID" value="<%=groupID %>" />
</jsp:include>



<div style="width:100%;" class="pageContent" id="page-teamSummary" >
	</br>
	<jsp:include page="../../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="Team Summary" />
		<jsp:param name="category" value="group.crm" />
		<jsp:param name="keepReferer" value="N" />
	</jsp:include>
	<jsp:include page="../../crm/portal/summary.jsp" flush="true">
		<jsp:param name="groupID" value="<%=groupID %>" />
		<jsp:param name="clientSummary" value="Y" />
	</jsp:include>	
</div>
<%} %>				
<script language="javascript">

	// filter staff list
	var myfilter1 = new filterlist(document.form1.clientIDAvailable, document.form1.searchField1);
	var myfilter2 = new filterlist(document.form1.clientID, document.form1.searchField2);

	$().ready(function() {
	

		$('#add2').click(function() {
			return !$('#clientIDSelect1 option:selected').appendTo('#clientIDSelect2');
		});
		$('#remove2').click(function() {
			return !$('#clientIDSelect2 option:selected').appendTo('#clientIDSelect1');
		});
		
		$('#contentFrame').append($('#page-teamSummary'));
		 showPageSummary('newstartSummary');
	});

	$('form').submit(function() {	
		$('#clientIDSelect2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
	});

	function submitAction(cmd, stp) {
<%	if (updateAction) { %>
		if (cmd == 'update') {
			selectItem('form1', 'clientID');
		}
		checkSelectEmpty();
<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function checkSelectEmpty() {
	
		u2 = document.getElementById("clientIDSelect2");	
		var u_count = 0;
		if (u2) {
			for (i = 0; i < u2.length; i++ ) {
				if (u2.options[i] && u2.options[i].selected) {
					u_count++;
				}
			}
		}
		if (u_count == 0) {
			document.forms["form1"].elements["clientIDSelect2IsEmpty"].value = "Y";
		}
	}
	
	
<%	if (updateAction) { %>	
		removeDuplicateItem('form1', 'clientIDAvailable', 'clientID');
<%	} %>

</script>
</DIV>

</DIV></DIV>

<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html>