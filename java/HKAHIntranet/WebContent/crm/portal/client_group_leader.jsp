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
String isClient = request.getParameter("isClient");

boolean select2IsEmpty = "Y".equals(request.getParameter("select2IsEmpty"));
String clientID[] = request.getParameterValues("clientID");
String clientIDDesc[] = null;

String clientLeaderID[] = request.getParameterValues("clientLeaderID");
String clientLeaderIDDesc[] = null;
boolean clientIDSelect2IsEmpty = "Y".equals(request.getParameter("clientIDSelect2IsEmpty"));	
boolean updateAction = false;

String message = "";
String errorMessage = "";

if ("update".equals(command)) {
	updateAction = true;
}

boolean userSuccess = false;	
try {	
	if ("1".equals(step)) {			
		// clean up user access control
		
		if (clientID != null || clientIDSelect2IsEmpty) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr = new StringBuffer();
					
			sqlStr.append("UPDATE CRM_GROUP_COMMITTEE ");
			sqlStr.append("SET CRM_ENABLED = 0, ");
			sqlStr.append("CRM_MODIFIED_DATE = sysdate ");
			sqlStr.append("WHERE CRM_GROUP_ID = '"+groupID+"' ");
			sqlStr.append("AND CRM_GROUP_POSITION = 'team_leader' ");
			sqlStr.append("AND CRM_ENABLED = 1 ");
			
			UtilDBWeb.updateQueue(sqlStr.toString());
		}
		
		if (updateAction) {
			
			if (clientID != null) {
				for (int i = 0; i < clientID.length; i++) {
					StringBuffer sqlStr = new StringBuffer();
					sqlStr = new StringBuffer();
					
					sqlStr.append("insert into CRM_GROUP_COMMITTEE "); 
					sqlStr.append("(CRM_SITE_CODE ,CRM_GROUP_ID ,CRM_GROUP_POSITION ,CRM_CLIENT_ID ");
					sqlStr.append(",CRM_RECEIVE_EMAIL ,CRM_CREATED_USER, CRM_MODIFIED_USER) ");
					sqlStr.append("VALUES ('"+userBean.getSiteCode()+"' , '"+groupID+"' ,'team_leader' ,'"+clientID[i]+"' ,1 ,'"+userBean.getLoginID()+"' ,'"+userBean.getLoginID()+"' ) ");
					
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
	
	if (groupID != null && groupID.length() > 0) {
		StringBuffer sqlStr = new StringBuffer();
		ArrayList record =null;
		
		sqlStr.setLength(0);
		
		sqlStr.append("select    C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME "); 
		sqlStr.append("from      CRM_GROUP_COMMITTEE G, CRM_CLIENTS C ");
		sqlStr.append("where     G.CRM_CLIENT_ID  = C.CRM_CLIENT_ID ");
		sqlStr.append("and       G.CRM_ENABLED = 1 ");
		sqlStr.append("and       G.CRM_GROUP_ID = '"+groupID+"' ");
		sqlStr.append("and       G.CRM_GROUP_POSITION = 'team_leader' "); 
		sqlStr.append("ORDER BY  C.CRM_LASTNAME, C.CRM_FIRSTNAME ");
		
		//System.out.println(sqlStr.toString());
	
		record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			clientLeaderID = new String[record.size()];
			clientLeaderIDDesc = new String[record.size()];
			ReportableListObject row = null;
		
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				String tempClientID = row.getValue(0);
				String clientName = row.getValue(1) +", "+row.getValue(2);
				clientLeaderID[i] = tempClientID;
				clientLeaderIDDesc[i] = clientName;
			}
		} else {
			clientLeaderID = null;
			clientLeaderIDDesc = null;
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
<script type="text/javascript" src="<html:rewrite page="/js/filterlist.js" />"></script> 
<html:html xhtml="true" lang="true">
<jsp:include page="header.jsp"/>
<body>
<%if (userSuccess) { %>
		<script type="text/javascript">
		window.location.replace("client_group.jsp?command=view&grpDesc=<%=groupDesc%>&grpID=<%=groupID%>&isClient=<%=isClient%>");
	</script>
<%}%>
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
<%if(!"Y".equals(isClient)){ %>
<jsp:include page="../../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<%} %>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="client_group_leader.jsp" method="post">
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
					<td>Avaliable Clients for Team Leader</td>
					<td>&nbsp;</td>
					<td>Selected Clients for Team Leader</td>
				</tr>
				<tr>
					<td>
						<select name="clientIDAvailable" size="10" multiple id="clientIDSelect1">
						
							<% request.setAttribute("clientIDCMB_filterValues", clientID); %>
							<jsp:include page="../../ui/clientIDCMB.jsp" flush="true">
								<jsp:param name="isFilterValues" value="Y" />
							</jsp:include>
						</select>
						<div>
							<bean:message key="button.search" />:&nbsp;
							<input name="searchField1" onkeyup="myfilter1.set(this.value, event)" />
						</div>
					</td>
					<td>
						<div id='oneLeaderError'></div>
						<button id="add2"><bean:message key="button.add" /> &gt;&gt;</button><br>
						<button id="remove2">&lt;&lt; <bean:message key="button.delete" /></button>
					</td>
								 
					 <td>
						<select name="clientID" size="10" multiple id="clientIDSelect2">
						
							<% request.setAttribute("clientGroupLeaderCMB_filterValues", clientLeaderID); %>
							<jsp:include page="../../ui/clientGroupLeaderCMB.jsp" flush="true">
								<jsp:param name="isFilterValues" value="Y" />
								<jsp:param name="type" value="leader" />
								<jsp:param name="groupID" value="<%=groupID %>" />
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
				if (clientLeaderID != null) {
					for (int i = 0; i < clientLeaderID.length; i++) {
						try {
%><bean:message key="<%=clientLeaderIDDesc[i] %>" /><br/><%
						} catch (Exception e) {
%><%=clientLeaderIDDesc[i] %><br/><%
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
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - Update Team Leader</button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click">Update Team Leader</button>
<%	}  %>
			<button onclick="return returnToTeamEdit('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - Update Team Leader</button>

		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="clientGroupID" value="<%=groupID%>">
<input type="hidden" name="clientGroupDesc" value="<%=groupDesc%>">

<input type="hidden" name="grpID" value="<%=groupID%>">
<input type="hidden" name="grpDesc" value="<%=groupDesc%>">
<input type="hidden" name="isClient" value="<%=isClient%>">			
</form>

<script language="javascript">

	// filter staff list
	var myfilter1 = new filterlist(document.form1.clientIDAvailable, document.form1.searchField1);
	var myfilter2 = new filterlist(document.form1.clientID, document.form1.searchField2);

	function returnToTeamEdit(){
		document.form1.action = "client_group.jsp";
		document.form1.command.value = "view";							
		document.form1.submit();
	}

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