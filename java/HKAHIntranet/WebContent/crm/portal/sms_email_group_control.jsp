<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%!
	private static String getNextGroupID() {
		String groupID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT COUNT(1) + 1 FROM CRM_SMSEMAIL_CUS_GROUP");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			groupID = reportableListObject.getValue(0);
		}
		return groupID;
	}
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String step = request.getParameter("step");
String cusGroupID = request.getParameter("cusGroupID");
String topic = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "topic"));

boolean select2IsEmpty = "Y".equals(request.getParameter("select2IsEmpty"));
String clientID[] = request.getParameterValues("clientID");
String clientIDDesc[] = null;
boolean clientIDSelect2IsEmpty = "Y".equals(request.getParameter("clientIDSelect2IsEmpty"));	

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		if (clientID != null || clientIDSelect2IsEmpty) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr = new StringBuffer();
			
			sqlStr.append("UPDATE CRM_SMSEMAIL_CUS_GROUP_MEMB ");
			sqlStr.append("SET    CRM_ENABLED = 0, ");
			sqlStr.append("       CRM_MODIFIED_USER = '"+loginID+"', ");
			sqlStr.append("       CRM_MODIFIED_DATE = sysdate ");
			sqlStr.append("WHERE  CRM_CUS_GROUP_ID = '"+cusGroupID+"' ");
			sqlStr.append("AND    CRM_ENABLED = 1 ");
			
			UtilDBWeb.updateQueue(
				sqlStr.toString());
		}
		
		if ((createAction || updateAction) && (topic == null || topic.length() == 0)) {
			errorMessage = MessageResources.getMessage(session, "error.topic.required");
			step = "0";
		} else if (createAction) {
			StringBuffer sqlStr = new StringBuffer();
			cusGroupID = getNextGroupID();
			
			sqlStr.append("INSERT INTO CRM_SMSEMAIL_CUS_GROUP (");
			sqlStr.append(" CRM_CUS_GROUP_ID, CRM_CUS_GROUP_DESC,  ");
			sqlStr.append(" CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ("+cusGroupID+", ?, ?, ?)");
				
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {topic, loginID, loginID} )) {
				message = "Customize Group created.";
				
				
				boolean userSuccess = false;	
				if (clientID != null) {
					for (int i = 0; i < clientID.length; i++) {
						StringBuffer sqlStr2 = new StringBuffer();
						
						sqlStr2.append("INSERT INTO CRM_SMSEMAIL_CUS_GROUP_MEMB ");
						sqlStr2.append("( CRM_CUS_GROUP_ID , CRM_CLIENT_ID , CRM_CREATED_USER, CRM_MODIFIED_USER) ");
						sqlStr2.append("VALUES ("+cusGroupID+" , "+clientID[i]+" , '"+loginID+"','"+loginID+"') ");					
					
						if (UtilDBWeb.updateQueue(sqlStr2.toString())) {
							userSuccess = true;
						}
					}
				} else {
					userSuccess = true;
				}
				
				if (userSuccess) {
					message = "Customize Group created.";
					createAction = false;
				} else {
					errorMessage = "Customize Group create fail.";
				}
			} else {
				errorMessage = "Customize Group create fail.";
			}
			
		
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			
			sqlStr.append("UPDATE CRM_SMSEMAIL_CUS_GROUP ");
			sqlStr.append("SET    CRM_CUS_GROUP_DESC = ?, ");
			sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_CUS_GROUP_ID = ?");
			
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {topic,loginID, cusGroupID} )) {
				message = "Customize Group modified.";

				boolean userSuccess = false;	
				if (clientID != null) {
					for (int i = 0; i < clientID.length; i++) {
						StringBuffer sqlStr2 = new StringBuffer();
						
						sqlStr2.append("INSERT INTO CRM_SMSEMAIL_CUS_GROUP_MEMB ");
						sqlStr2.append("( CRM_CUS_GROUP_ID , CRM_CLIENT_ID , CRM_CREATED_USER, CRM_MODIFIED_USER) ");
						sqlStr2.append("VALUES ("+cusGroupID+" , "+clientID[i]+" , '"+loginID+"','"+loginID+"') ");					
					
						if (UtilDBWeb.updateQueue(sqlStr2.toString())) {
							userSuccess = true;
						}
					}
				} else {
					userSuccess = true;
				}
				
				if (userSuccess) {
					message = "Customize Group modified.";
					updateAction = false;
				} else {
					errorMessage = "Customize Group modify fail.";
				}
			} else {
				errorMessage = "Customize Group modify fail.";
			}						
		} else if (deleteAction) {	
			StringBuffer sqlStr = new StringBuffer();
			
			sqlStr.append("UPDATE CRM_SMSEMAIL_CUS_GROUP SET CRM_ENABLED = 0, ");
			sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_CUS_GROUP_ID = ?");
			
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { loginID, cusGroupID } )) {
				message = "Customize Group deleted.";
				
				sqlStr.setLength(0);
				sqlStr.append("UPDATE CRM_SMSEMAIL_CUS_GROUP_MEMB ");
				sqlStr.append("SET    CRM_ENABLED = 0, ");
				sqlStr.append("       CRM_MODIFIED_USER = '"+loginID+"', ");
				sqlStr.append("       CRM_MODIFIED_DATE = sysdate ");
				sqlStr.append("WHERE  CRM_CUS_GROUP_ID = '"+cusGroupID+"' ");
				sqlStr.append("AND    CRM_ENABLED = 1 ");
				
				UtilDBWeb.updateQueue(sqlStr.toString());
				
				closeAction = true;
			} else {
				errorMessage = "Customize Group delete fail.";
			}
		}
	} else if (createAction) {
		cusGroupID = "";
		topic = "";		
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (cusGroupID != null && cusGroupID.length() > 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT CRM_CUS_GROUP_DESC, CRM_CUS_GROUP_ID ");
			sqlStr.append("FROM   CRM_SMSEMAIL_CUS_GROUP ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 AND CRM_CUS_GROUP_ID = ?");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { cusGroupID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				topic = row.getValue(0);				
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
	
	if (cusGroupID != null && cusGroupID.length() > 0) {
		StringBuffer sqlStr = new StringBuffer();
		ArrayList record =null;
		sqlStr.setLength(0);
		
		sqlStr.append("SELECT   C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME ");
		sqlStr.append("FROM     CRM_SMSEMAIL_CUS_GROUP_MEMB S, CRM_CLIENTS C ");
		sqlStr.append("WHERE    S.CRM_CLIENT_ID = C.CRM_CLIENT_ID ");
		sqlStr.append("AND      S.CRM_ENABLED = 1 ");
		sqlStr.append("AND      C.CRM_ENABLED = 1 ");
		sqlStr.append("AND      S.CRM_CUS_GROUP_ID = ? ");
		sqlStr.append("ORDER BY C.CRM_LASTNAME, C.CRM_FIRSTNAME ");
		
		record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { cusGroupID });
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<script type="text/javascript" src="<html:rewrite page="/js/filterlist.js" />"></script> 
<html:html xhtml="true" lang="true">
<jsp:include page="../../common/header.jsp"/>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../../common/banner2.jsp"/>
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
	title = "function.crm.cusgroup." + commandType;	
%>
<jsp:include page="../../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Customize Group" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="sms_email_group_control.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Group Name</td>
<%	if (createAction || updateAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="topic" value="<%=topic %>" maxlength="100" size="50"></td>
<%	} else {%>
		<td class="infoData" width="70%"><%=topic %></td>
<%	} %>
	</tr>

</table>
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.clientName" /></td>
		<td class="infoData" width="70%">
<%			if (createAction || updateAction) { %>
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
						<%if(cusGroupID != null && cusGroupID.length() > 0){ %>				
							<% request.setAttribute("clientIDCMB_filterValues", clientID); %>
							<jsp:include page="../../ui/clientCusGroupCMB.jsp" flush="true">
								<jsp:param name="isFilterValues" value="Y" />
								<jsp:param name="cusGroupID" value="<%=cusGroupID %>" />
							</jsp:include>
						<%} %>
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
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else {%>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.crm.cusgroup.update" /></button>
			<button onclick="return submitAction('delete', 1);" class="btn-click"><bean:message key="function.crm.cusgroup.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="" />
<input type="hidden" name="step" value="" />
<input type="hidden" name="cusGroupID" value="<%=cusGroupID%>"/>
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
		if(cmd == 'delete'){
		   var deleteGroup = confirm("Delete group ?");
		   if( deleteGroup == true ){	
				document.form1.command.value = cmd;		
				document.form1.step.value = stp;
				document.form1.submit();
			}
		}else{
<%	if (createAction || updateAction) { %>
			if (cmd == 'create' || cmd == 'update') {
				if (document.form1.topic.value == '') {
					alert("Group name cannot be empty.");
					document.form1.topic.focus();
					return false;
				}
			}
<%}%>

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
	}
	
	
	var myfilter1 = new filterlist(document.form1.clientIDAvailable, document.form1.searchField1);
	var myfilter2 = new filterlist(document.form1.clientID, document.form1.searchField2);

	$().ready(function() {		
		$('#add2').click(function() {		
			return !$('#clientIDSelect1 option:selected').appendTo('#clientIDSelect2');
		});
		$('#remove2').click(function() {
			return !$('#clientIDSelect2 option:selected').appendTo('#clientIDSelect1');
		});	
	});

	$('form').submit(function() {	
		$('#clientIDSelect2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
	});

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
<%} %>
</html:html>