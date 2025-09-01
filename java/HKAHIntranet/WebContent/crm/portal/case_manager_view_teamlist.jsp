<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
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

public static ArrayList getClientCaseManagerGroups(String clientID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select CRM_GROUP_ID ");
	sqlStr.append("from   CRM_GROUP_COMMITTEE ");
	sqlStr.append("where  CRM_ENABLED = 1 ");
	sqlStr.append("and    CRM_GROUP_POSITION = 'case_manager' ");
	sqlStr.append("AND    CRM_CLIENT_ID = '"+clientID+"' ");
	sqlStr.append("Order By CRM_GROUP_ID ");
	
	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getTeamName(String teamID) {
	StringBuffer sqlStr = new StringBuffer();
			
	sqlStr.append("SELECT CRM_GROUP_DESC ");
	sqlStr.append("FROM   CRM_GROUP ");
	sqlStr.append("WHERE  CRM_GROUP_ID = '"+teamID+"' ");
	sqlStr.append("AND    	CRM_ENABLED = 1 ");	

	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String clientID = CRMClientDB.getClientID(userBean.getLoginID());

ArrayList record = CRMClientDB.get(clientID);
if (record != null && record.size() > 0) {
	ReportableListObject row = (ReportableListObject) record.get(0);
}

String title = "Team Members";

ArrayList<String> groupID = new ArrayList<String>();
ArrayList clientIDGroupRecord = getClientCaseManagerGroups(clientID);
if (clientIDGroupRecord.size() > 0) {
	for(int i = 0; i < clientIDGroupRecord.size();i++){
		ReportableListObject row = (ReportableListObject) clientIDGroupRecord.get(i);
		if(!groupID.contains(row.getValue(0))){
			groupID.add(row.getValue(0));
		}
	}
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
<head>
<style>
* {
	margin:0;
	padding:0;
}

body {
	background:url(../../images/background.png) top left;
	font: .8em "Lucida Sans Unicode", "Lucida Grande", sans-serif;
}

h2{ 
	margin-bottom:10px;
}

#wrapper{
	width:720px;
	
}

#wrapper h1{
	color:#FFF;
	text-align:center;
	margin-bottom:20px;
}

.tabs{
	height:30px;
}

.tabs > ul{
	font-size: 1em;
	list-style:none;
}

.tabs > ul > li{
	margin:0 2px 0 0;
	padding:7px 10px;
	display:block;
	float:left;
	color:#FFF;
	-webkit-user-select: none;
	-moz-user-select: none;
	user-select: none;
	-moz-border-radius-topleft: 4px;
	-moz-border-radius-topright: 4px;
	-moz-border-radius-bottomright: 0px;
	-moz-border-radius-bottomleft: 0px;
	border-top-left-radius:4px;
	border-top-right-radius: 4px;
	border-bottom-right-radius: 0px;
	border-bottom-left-radius: 0px; 
	background: #C9C9C9; /* old browsers */
	background: -moz-linear-gradient(top, #0C91EC 0%, #257AB6 100%); /* firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#0C91EC), color-stop(100%,#257AB6)); /* webkit */
}

.tabs > ul > li:hover{
	background: #FFFFFF; /* old browsers */
	background: -moz-linear-gradient(top, #FFFFFF 0%, #F3F3F3 10%, #F3F3F3 50%, #FFFFFF 100%); /* firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFFFFF), color-stop(10%,#F3F3F3), color-stop(50%,#F3F3F3), color-stop(100%,#FFFFFF)); /* webkit */
	cursor:pointer;
	color: #333;
}

.tabs > ul > li.tabActiveHeader{
	background: #FFFFFF; /* old browsers */
	background: -moz-linear-gradient(top, #FFFFFF 0%, #F3F3F3 10%, #F3F3F3 50%, #FFFFFF 100%); /* firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFFFFF), color-stop(10%,#F3F3F3), color-stop(50%,#F3F3F3), color-stop(100%,#FFFFFF)); /* webkit */
	cursor:pointer;
	color: #333;
}

.tabscontent {
	-moz-border-radius-topleft: 0px;
	-moz-border-radius-topright: 4px;
	-moz-border-radius-bottomright: 4px;
	-moz-border-radius-bottomleft: 4px;
	border-top-left-radius: 0px;
	
	background: -moz-linear-gradient(top, #FFFFFF 0%, #FFFFFF 90%, #e4e9ed 100%); /* firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFFFFF), color-stop(90%,#FFFFFF), color-stop(100%,#e4e9ed)); /* webkit */
	margin:0;
	color:#333;
}
</style>
</head>
<body>

	
	
	<div id="wrapper" style="width:100%">
  <div id="tabContainer">
    <div class="tabs">
      <ul>
     <%for(int i = 0;i < groupID.size(); i++){ 
	ArrayList teamNameRecord = getTeamName(groupID.get(i));
	String teamName = "";
	if (teamNameRecord.size() > 0) {
			ReportableListObject row = (ReportableListObject) teamNameRecord.get(0);
			teamName = row.getValue(0);
	}
%>
        <li id="tabHeader_<%=i%>"><%=teamName %></li>
<%} %>
        
      </ul>
    </div>
    <jsp:include page="../../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="<%=title %>" />
		<jsp:param name="category" value="group.crm" />
		<jsp:param name="keepReferer" value="N" />
	</jsp:include>
	
      <div class="tabscontent">
<%
for(int i = 0;i < groupID.size(); i++){
request.setAttribute("client_list", getTeamMember(groupID.get(i)));

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
%>
   
      <div class="tabpage" id="tabpage_<%=i%>">	
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
			<button type="button" onclick="return viewClientSummaryAction('view', '<c:out value="${row.fields1}" />' , '<c:out value="${row.fields6}" />');">Summary
			</button>
			<button onclick="return viewNote('view', '<c:out value="${row.fields0}" />', '');">Progress Note</button>					
	</display:column>
</display:table>
</form>
<form name="changeLoginIDForm" action="index.jsp" method="post">
<input type="hidden" name="command"/>
<input type="hidden" name="clientID"/>
</form>
  
      </div>
   
<%} %> 
     </div>
    
    
</div>
</div>
<form name="form3" action="<html:rewrite page="/crm/progress_note_update.jsp" />" method="post"/>

<script language="javascript">
		function viewTeamMemberAction(cmd, cid) {			
		callPopUpWindow("basic_info.jsp?userType=caseManager&command=" + cmd + "&clientID=" + cid + "&useClientID=Y");
		return false;
	}
	function viewClientSummaryAction(cmd, cid , gid) {			
		callPopUpWindow("client_summary.jsp?command=" + cmd + "&clientID=" + cid + "&groupID=" + gid);
		return false;
	}
	function viewNote(cmd, uid, sid) {
		callPopUpWindow(document.form3.action + "?command=" + cmd + "&clientID=" + uid + "&staffID=" + sid);
		return false;
	}
	
	$(document).ready(function() {			
	
	});
	
	window.onload=function() {
		  // get tab container
		  var container = document.getElementById("tabContainer");
		    // set current tab
		    var navitem = container.querySelector(".tabs ul li");
		    //store which tab we are on
		    var ident = navitem.id.split("_")[1];
		    navitem.parentNode.setAttribute("data-current",ident);
		    //set current tab with class of activetabheader
		    navitem.setAttribute("class","tabActiveHeader");

		    //hide two tab contents we don't need
		    var pages = container.querySelectorAll(".tabpage");
		    for (var i = 1; i < pages.length; i++) {
		      pages[i].style.display="none";
		    }

		    //this adds click event to tabs
		    var tabs = container.querySelectorAll(".tabs ul li");
		    for (var i = 0; i < tabs.length; i++) {
		      tabs[i].onclick=displayPage;
		    }
		}

		// on click of one of tabs
		function displayPage() {
		  var current = this.parentNode.getAttribute("data-current");
		  //remove class of activetabheader and hide old contents
		  document.getElementById("tabHeader_" + current).removeAttribute("class");
		  document.getElementById("tabpage_" + current).style.display="none";

		  var ident = this.id.split("_")[1];
		  //add class of activetabheader to new active tab and show contents
		  this.setAttribute("class","tabActiveHeader");
		  document.getElementById("tabpage_" + ident).style.display="block";
		  this.parentNode.setAttribute("data-current",ident);
		}
</script>

<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html>