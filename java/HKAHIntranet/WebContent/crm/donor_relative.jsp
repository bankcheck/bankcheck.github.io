<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%!
public static String add(UserBean userBean,String lastName,String firstName) {

	String relativeClientID = getNextClientID();	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("INSERT INTO CRM_CLIENTS "); 
	sqlStr.append(" (CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME, ");
	sqlStr.append(" CRM_DONOR, "); 
	sqlStr.append(" CRM_CREATED_USER, CRM_CREATED_SITE_CODE, CRM_CREATED_DEPARTMENT_CODE, CRM_MODIFIED_USER) ");
	sqlStr.append(" VALUES "); 
	sqlStr.append("('"+relativeClientID+"','"+lastName+"','"+firstName+"', ");
	sqlStr.append("'Y_relative', ");	
	sqlStr.append("'"+userBean.getLoginID()+"', ");
	sqlStr.append("'"+userBean.getSiteCode()+"','"+userBean.getDeptCode()+"','"+userBean.getLoginID()+"')");
	// try to insert a new record
	
	//System.out.println(sqlStr.toString());
	if (UtilDBWeb.updateQueue(sqlStr.toString() )) {	
		return relativeClientID;
	} else {
		return null;
	}
}

public static boolean addRelationship(UserBean userBean,String clientID,String clientRelativeID,String relationshipManagement,String remark) {

	StringBuffer sqlStr = new StringBuffer();
	StringBuffer testStr = new StringBuffer();
	testStr.append("SELECT * FROM CRM_CLIENTS_RELATIONSHIP ");
	testStr.append("WHERE CRM_CLIENT_ID = '"+clientRelativeID+"' AND CRM_RELATED_CLIENT_ID = '"+clientID+"' AND CRM_ENABLED = '0' ");
	ArrayList record = UtilDBWeb.getReportableList(testStr.toString());
	if(record.size() > 0 ){
		sqlStr.append("UPDATE CRM_CLIENTS_RELATIONSHIP ");
		sqlStr.append("SET    CRM_RELATIONSHIP = '"+relationshipManagement+"', CRM_REMARKS = '"+remark+"', ");
		sqlStr.append("       CRM_ENABLED = 1, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientRelativeID+"' ");
		sqlStr.append("AND    CRM_RELATED_CLIENT_ID = '"+clientID+"'");
	}else{
		sqlStr.append("INSERT INTO CRM_CLIENTS_RELATIONSHIP ");
		sqlStr.append("(CRM_CLIENT_ID, CRM_RELATED_CLIENT_ID, CRM_RELATIONSHIP,CRM_REMARKS, ");
		sqlStr.append("CRM_CREATED_USER, CRM_MODIFIED_USER) ");
		sqlStr.append("VALUES ");		
		sqlStr.append("('"+clientRelativeID	+"','"+clientID+"','"+relationshipManagement+"','"+remark+"', ");	
		sqlStr.append("'"+userBean.getLoginID()+"','"+userBean.getLoginID()+"') ");
	}
	return UtilDBWeb.updateQueue(sqlStr.toString());
	
}

private static String getNextClientID() {
	String clientID = null;

	// get next schedule id from db
	ArrayList result = UtilDBWeb.getReportableList(
			"SELECT MAX(CRM_CLIENT_ID) + 1 FROM CRM_CLIENTS");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		clientID = reportableListObject.getValue(0);

		// set 1 for initial
		if (clientID == null || clientID.length() == 0) return "1";
	}
	return clientID;
}

public static ArrayList getRelativeInfo(String clientRelativeID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT C.CRM_LASTNAME,C.CRM_FIRSTNAME,C.CRM_CHINESENAME,R.CRM_RELATIONSHIP,R.CRM_REMARKS ");	
	sqlStr.append("FROM   CRM_CLIENTS C, CRM_CLIENTS_RELATIONSHIP R ");
	sqlStr.append("WHERE C.CRM_CLIENT_ID = R.CRM_CLIENT_ID ");	
	sqlStr.append("AND   R.CRM_CLIENT_ID = '"+clientRelativeID+"' ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean update(UserBean userBean,String lastName,String firstName,String clientRelativeID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS ");
	sqlStr.append("SET CRM_LASTNAME = '"+lastName+"', CRM_FIRSTNAME = '"+firstName+"',   ");
	sqlStr.append("CRM_MODIFIED_USER = '"+userBean.getLoginID()+"',CRM_MODIFIED_DATE=SYSDATE ");
	sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientRelativeID+"' ");
	sqlStr.append("AND    CRM_DONOR = 'Y_relative'  ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean updateRelationship(UserBean userBean,String clientRelativeID,String relationshipManagement,String remark) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS_RELATIONSHIP ");
	sqlStr.append("SET CRM_RELATIONSHIP = '"+relationshipManagement+"', ");
	sqlStr.append("CRM_REMARKS = '"+remark+"', ");
	sqlStr.append("CRM_MODIFIED_USER = '"+userBean.getLoginID()+"',CRM_MODIFIED_DATE=SYSDATE ");
	sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientRelativeID+"' ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean delete(UserBean userBean, String clientRelativeID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS ");
	sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
	sqlStr.append("WHERE  CRM_ENABLED = 1 ");
	sqlStr.append("AND    CRM_CLIENT_ID = '"+clientRelativeID+"' ");
	sqlStr.append("AND    CRM_DONOR = 'Y_relative'  ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean deleteRelationship(UserBean userBean, String clientRelativeID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS_RELATIONSHIP ");
	sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
	sqlStr.append("WHERE  CRM_ENABLED = 1 ");
	sqlStr.append("AND    CRM_CLIENT_ID = '"+clientRelativeID+"' ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static ArrayList getClientInfo(String clientID) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME,  CRM_CHINESENAME, CRM_STREET1, ");
	sqlStr.append("       CRM_STREET2, CRM_STREET3, CRM_STREET4, ");
	sqlStr.append("       CRM_HOME_NUMBER,CRM_MOBILE_NUMBER, CRM_FAX_NUMBER,  CRM_EMAIL, CRM_PHOTO_NAME, ");
	sqlStr.append("       CRM_ORGANIZATION, CRM_SALUTATION, ");
	sqlStr.append("       CRM_DESCRIPTION,CRM_DONOR,  CRM_CREATED_USER, CRM_CREATED_SITE_CODE, ");
	sqlStr.append("       CRM_CREATED_DEPARTMENT_CODE, CRM_MODIFIED_USER ");	
	sqlStr.append("FROM   CRM_CLIENTS ");
	sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientID+"' ");	
	sqlStr.append("AND    CRM_DONOR = 'Y' ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%

UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String message = TextUtil.parseStr(ParserUtil.getParameter(request, "message"));
String errorMessage = "";

String lastName = TextUtil.parseStr(ParserUtil.getParameter(request, "lastName")).toUpperCase();
String firstName = TextUtil.parseStr(ParserUtil.getParameter(request, "firstName")).toUpperCase();
String remark = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark"));
String relationshipManagement = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "relationshipManagement"));
String clientID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "clientID"));
String clientRelativeID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "clientRelativeID"));

boolean loginAction = false;
boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;

boolean closeAction = false;

if ("login".equals(command) && userBean.isAdmin()) {
	loginAction = true;
} else if ("create".equals(command) || !userBean.isLogin()) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("close".equals(command)) {
	closeAction = true;
}

try {
	if ("1".equals(step)) {
		if ((createAction || updateAction) && (clientID.equals(clientRelativeID))) {
			errorMessage = "Client cannot be his relative.";
			step = "0";
		}else if (createAction) {		
			if(clientRelativeID == null || (clientRelativeID != null && clientRelativeID.length() == 0)){				
				clientRelativeID = add(userBean, lastName, firstName);
			}
			if (clientRelativeID != null) {
				if(addRelationship(userBean,clientID,clientRelativeID,relationshipManagement,remark)){
					message = "Relative created.";
					createAction = false;
					step = null;
				}else {
					errorMessage = "Relationship create fail.";
				}
			} else {
				errorMessage = "Relative create fail.";
			}
		} else if (updateAction) {
			
				if(updateRelationship(userBean,clientRelativeID,relationshipManagement,remark)){
					message = "Client updated.";
					updateAction = false;
					step = null;
				}else{
					errorMessage = "Client update fail.";
				}
			
		}else if (deleteAction) {		
			if(deleteRelationship(userBean,clientRelativeID)){
				message = "Client removed.";				
				step = null;
				closeAction = true;
			}else{
				errorMessage = "Client remove fail.";
			}
		}
	} 
	
	if (clientRelativeID != null && clientRelativeID.length() > 0) {
		ArrayList record= getRelativeInfo(clientRelativeID);		
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			lastName = row.getValue(0);
			firstName = row.getValue(1);		
			relationshipManagement = row.getValue(3); 
			remark = row.getValue(4); 
		} else {
			
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
<html:html xhtml="true" lang="true">
<style>
	.hightLight {
		border: 2px solid #FF9696;
	}
</style>
<jsp:include page="../common/header.jsp"/>

<body>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper  style="width:100%">
<div id=mainFrame  style="width:100%">
<div id=contentFrame  style="width:100%">
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
	title = "function.donor.relative." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<%
	ArrayList clientRecord = getClientInfo(clientID);

	if(clientRecord.size() != 0){	
		ReportableListObject clientRow = (ReportableListObject)clientRecord.get(0);	
%>
<table cellpadding="0" width="100%" cellspacing="5"	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="16%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(1)%></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(2)%></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(3)%></td>
	</tr>
</table>		
<%
	}
%>

<form name="form1" method="post" action="donor_relative.jsp">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" style="width:100%">
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Relative Info</td>
	</tr>
<%	if (createAction) { %>
	<tr id="selectFromDonorList">
		<td></td>
		<td>
			<a href="donor_info_list.jsp?command=select&keepThis=true&TB_iframe=true&height=700&width=900" title="<bean:message key="function.client.list" />" class="thickbox button">
				<span>Select Relative from Client List</span>
			</a>or
		</td>
	</tr>
<%  } %>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="35%">

<%	if (createAction) { %>
			<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName%>"  maxlength="30" size="25"/>
<%	} else { %>
			<%=lastName==null?"":lastName %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="35%">
<%	if (createAction) { %>
			<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName%>"  maxlength="30" size="25"/>
<%	} else { %>
			<%=firstName==null?"":firstName %>
<%	} %>
		</td>
		</td>
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="15%">Remark</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<textarea name = "remark" style='height:50px;width:100%'><%=remark==null?"":remark%></textarea>
		 
<%	} else { %>
			<%=remark==null?"":remark%>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Relationship</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" id="relationshipManagement" name = "relationshipManagement" value="<%=relationshipManagement==null?"":relationshipManagement%>"  maxlength="30" size="25"/>
		 
<%	} else { %>
			<%=relationshipManagement==null?"":relationshipManagement %>
<%	} %>
		</td>		
	</tr>	
	
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
		<%	if (createAction || updateAction) { %>
			<button type="button" onclick="return submitAction('<%=commandType %>', 1);"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			
						
		<% }else{ %>
			<button type="button" onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.relative.update" /></button>
			<button type="button" onclick="return deleteAction('delete', 1);" class="btn-click"><bean:message key="function.relative.delete" /></button>
			
		<% } %>
		<button type="button" onclick="return returnRelativeList();" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
			
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command"/>
<input type="hidden" name="step"/>
<input type="hidden" name="clientID" value="<%=clientID %>"/>
<input type="hidden" name="clientRelativeID" value="<%=clientRelativeID %>"/>
</form>
<script language="javascript">
	function deleteAction(cmd,stp){
		  var deleteRecord = confirm("Delete record ?");
		   if( deleteRecord == true ){
			   submitAction(cmd,stp);
		   }
	}

	function submitAction(cmd, stp) {	
		var success = true;
		var msg = '';	
		$(".hightLight").removeClass();	
		if(stp==1 ){
			if(cmd!='delete'){	
				if($.trim($('#relationshipManagement').val()) == ''){				
					msg = 'Relationship cannot be empty.';
					$('#relationshipManagement').addClass("hightLight");
					success = false;
				}				
			}
		}
		
		if(success==false){			
			alert(msg);
			return false;
		}
		
		document.form1.command.value = cmd;
		document.form1.step.value = stp;			
		document.form1.submit();
	}
	
	function returnRelativeList(cid) {
		document.form1.action = "donor_relative_list.jsp";		
	
		document.form1.submit();
	}
	
	function tb_remove_4_search(cid, name1, name2) {
		$('input[name=lastName]').val(name1); 
		$("input[name=lastName]").attr("disabled", "disabled"); 
		$('input[name=firstName]').val(name2); 
		$("input[name=firstName]").attr("disabled", "disabled"); 
		$("input[name=clientRelativeID]").val(cid);
		$("#selectFromDonorList").remove();
		
	 	tb_remove();
	}
	
	
	$(document).ready(function() {			
	<%if (closeAction) { %>
		returnRelativeList('<%=clientID%>');
	<%}%>
	});
</script>
</div>
</div>
</div>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>