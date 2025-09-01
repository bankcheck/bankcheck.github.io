<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
public static ArrayList getEnrolledClients(String eventID,String scheduleID) {
	StringBuffer sqlStr = new StringBuffer();
			
	sqlStr.append("SELECT C.CRM_CLIENT_ID, C.CRM_USERNAME, C.CRM_LASTNAME, C.CRM_FIRSTNAME , C.CRM_MOBILE_NUMBER , C.CRM_EMAIL , C.CRM_GROUP_ID ");
	sqlStr.append(" , E.CO_EVENT_ID, E.CO_SCHEDULE_ID, E.CO_ENROLL_ID, E.CO_ATTEND_DATE ");
	sqlStr.append("FROM CO_ENROLLMENT E, CRM_CLIENTS C ");
	sqlStr.append("WHERE TO_CHAR(C.CRM_CLIENT_ID)  = E.CO_USER_ID ");
	sqlStr.append("AND   E.CO_EVENT_ID = '"+eventID+"' ");
	sqlStr.append("AND   E.CO_SCHEDULE_ID = '"+scheduleID+"' ");
	sqlStr.append("AND   E.CO_ENABLED = 1 ");
	sqlStr.append("AND   E.CO_MODULE_CODE = 'lmc.crm' ");

	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getTeamMember(String teamID) {
	StringBuffer sqlStr = new StringBuffer();
			
	sqlStr.append("SELECT CRM_CLIENT_ID,CRM_USERNAME, CRM_LASTNAME, CRM_FIRSTNAME , CRM_MOBILE_NUMBER , CRM_EMAIL , CRM_GROUP_ID ");
	sqlStr.append("FROM   CRM_CLIENTS ");
	sqlStr.append("WHERE  CRM_GROUP_ID = '"+teamID+"' ");
	sqlStr.append("AND    	CRM_ENABLED = 1 ");
	sqlStr.append("ORDER BY CRM_LASTNAME, CRM_FIRSTNAME");

	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

String type = request.getParameter("type");
String eventID = request.getParameter("eventID");
String scheduleID = request.getParameter("scheduleID");
String groupID = request.getParameter("groupID");

String title = "";
if("enrolledClients".equals(type)){
	request.setAttribute("client_list", getEnrolledClients(eventID,scheduleID));
	title="Enrolled Clients";
}else if ("teamMember".equals(type)){
	request.setAttribute("client_list", getTeamMember(groupID));
	title = "Team Members";
}
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

String realUserID = "";
if(userBean.getLoginID()!=null&&userBean.getLoginID().length()>0){
	realUserID=userBean.getLoginID();
}else{
	realUserID=userBean.getUserName();
}
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
		<jsp:param name="pageTitle" value="<%=title %>" />
		<jsp:param name="category" value="group.crm" />
		<jsp:param name="keepReferer" value="N" />
	</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.event.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form2">
<display:table id="row" name="requestScope.client_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" title="Login ID" style="width:10%" />	
	<display:column title="Client Name" style="width:30%">
		<c:out value="${row.fields2}" />,<c:out value="${row.fields3}" />
	</display:column>
	<display:column property="fields4" title="Mobile Number" style="width:15%" />	
	<display:column property="fields5" title="Email" style="width:20%" />
	<display:column titleKey="prompt.action" media="html" style="width:20%; text-align:center">		
			<button type="button" onclick="return viewTeamMemberAction('view', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" />
			</button>	
			<button type="button" onclick="return viewClientSummaryAction('view', '<c:out value="${row.fields1}" />' , '<c:out value="${row.fields6}" />');">Summary
			</button>	
			
			<logic:notEmpty name="row" property="fields1">
				<button type="button" onclick="return changeLoginID('login', '<c:out value="${row.fields1}" />','<%=realUserID%>');">
				<bean:message key="button.login" />
				</button>	
				<button onclick="return viewNote('view', '<c:out value="${row.fields0}" />', '');">Progress Note</button>		
			
				<c:set var="attendClientID" value="${row.fields0}"/>
<%
				if ("teamMember".equals(type)){
					String attendClientID = (String)pageContext.getAttribute("attendClientID") ;
					
					ArrayList clientAttendPWPRecord = EnrollmentDB.isAttendWorkshop("lmc.pwp",attendClientID);
					if(clientAttendPWPRecord.size() != 0 ){	
						ReportableListObject clientAttendPWPRow = (ReportableListObject)clientAttendPWPRecord.get(0);
%>
					<button type="button" onclick="return enrollWorkshop('lmc.pwp', '<c:out value="${row.fields0}" />', 'withdraw','<%=clientAttendPWPRow.getValue(0)%>','enroll_workshop');">Withdraw from PWP</button>
<%	 				}else{%>
					<button type="button" onclick="return enrollWorkshop('lmc.pwp', '<c:out value="${row.fields0}" />', 'enroll','','enroll_workshop');">Attend PWP</button>
<%	 				}	%>
				
<%				
					ArrayList clientAttendScrRecord = EnrollmentDB.isAttendWorkshop("lmc.scr",attendClientID);
					if(clientAttendScrRecord.size() != 0 ){	
						ReportableListObject clientAttendScrRow = (ReportableListObject)clientAttendScrRecord.get(0);
%>
					<button type="button" onclick="return enrollWorkshop('lmc.scr', '<c:out value="${row.fields0}" />', 'withdraw','<%=clientAttendScrRow.getValue(0)%>','enroll_workshop');">Withdraw from Screening</button>
<% 					}else{%>
					<button type="button" onclick="return enrollWorkshop('lmc.scr', '<c:out value="${row.fields0}" />', 'enroll','','enroll_workshop');">Attend Screening</button>
<%
					}
				}
%>
<%				if ("enrolledClients".equals(type)){ %>
				<logic:notEmpty name="row" property="fields10">
					<button type="button" onclick="return enrollWorkshop('', '', 'withdraw','<c:out value="${row.fields9}" />','attend_event','<c:out value="${row.fields7}" />','<c:out value="${row.fields8}" />');">Remove Attended Event</button>
				</logic:notEmpty>
				<logic:empty name="row" property="fields10">
					<button type="button" onclick="return enrollWorkshop('', '', 'attend','<c:out value="${row.fields9}" />','attend_event','<c:out value="${row.fields7}" />','<c:out value="${row.fields8}" />');">Attended Event</button>
				</logic:empty>
<%				} %>
			</logic:notEmpty>		
	</display:column>
</display:table>
</form>
<form name="changeLoginIDForm" action="index.jsp" method="post">
<input type="hidden" name="command"/>
<input type="hidden" name="clientID"/>
<input type="hidden" name="realUserID"/>
<input type="hidden" name="eventID" value="<%=eventID%>"/>
<input type="hidden" name="scheduleID" value="<%=scheduleID%>"/>
</form>
<form name="form3" action="<html:rewrite page="/crm/progress_note_update.jsp" />" method="post"/>

<script language="javascript">
	function enrollWorkshop(module,clientID,action,enrollNo,type, eventID, scheduleID) {		
		if(type=='enroll_workshop'){
		  var baseUrl ='../../crm/portal/enroll_workshop.jsp?type=enroll_workshop&action='+action+'&module='+module;		
			var url = baseUrl + '&clientID='+clientID+'&enrollNo='+enrollNo;	
			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values){
					if(values) {							
						alert($.trim(values));			
						location.replace("client_group_control.jsp?command=view&clientGroupDesc=" + $('input[name=clientGroupDesc]').val() + "&clientGroupID=" + $('input[name=clientGroupID]').val());					
					}else {
						alert('Error occured while submitting.');
					}
				},
				error: function() {
					alert('Error occured while submitting.');
				}
			});	
		}else if(type=='attend_event'){
			 var baseUrl ='../../crm/portal/enroll_workshop.jsp?type=attend_event&action='+action;		
				var url = baseUrl + '&eventID='+eventID+'&enrollNo='+enrollNo+'&scheduleID='+scheduleID;	
			
				$.ajax({					
					url: url,
					async: false,
					cache:false,
					success: function(values){
						if(values) {							
							alert($.trim(values));			
							location.replace("client_list.jsp?command=view&type=enrolledClients&eventID=" + $('input[name=eventID]').val()+"&scheduleID=" + $('input[name=scheduleID]').val());					
						}else {
							alert('Error occured while submitting.');
						}
					},
					error: function() {
						alert('Error occured while submitting.');
					}
				});	
		}
	}

	function viewNote(cmd, uid, sid) {
		callPopUpWindow(document.form3.action + "?command=" + cmd + "&clientID=" + uid + "&staffID=" + sid);
		return false;
	}

	function viewTeamMemberAction(cmd, cid) {			
		callPopUpWindow("basic_info.jsp?command=" + cmd + "&clientID=" + cid + "&useClientID=Y");
		return false;
	}
	function viewClientSummaryAction(cmd, cid , gid) {			
		callPopUpWindow("client_summary.jsp?command=" + cmd + "&clientID=" + cid + "&groupID=" + gid);
		return false;
	}
	
	function changeLoginID(cmd,cid,rid){	
		
		if( cid.length === 0 ) {
			alert('Unable to login without Login ID.');
		}else{
			document.changeLoginIDForm.command.value = cmd;
			document.changeLoginIDForm.clientID.value = cid;
			document.changeLoginIDForm.realUserID.value = rid;
			document.changeLoginIDForm.submit();
		}
		return false;
	}
		
	$(document).ready(function() {			
	
	});
</script>

<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html>