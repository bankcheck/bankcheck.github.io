<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String reqNo = request.getParameter("reqNo");
String reqBy = null;
String reqDept = null;
String folderId = null;
String reqStatus = null;
String deptHead = null;
String deptHeadName = null;
String sendAppTo = null;
String message = "";
String errorMessage = "";
String isFirstApprover = null;
boolean runAction = false;

if("run".equals(command)){
	runAction = true;
}

int noOfRow = 0;
boolean isChef = false;
ArrayList record = null;
String displayTitle = null;
String catType = request.getParameter("catType");
try {	
	// load data from database		
	if (reqNo != null&&reqNo.length() > 0&&"view".equals(command)) {	
		isChef = FsDB.isChef(userBean,"HKAH");		
		
		record = FsDB.getReqRecord(reqNo);
		noOfRow = record.size();
		ReportableListObject row = (ReportableListObject) record.get(0);
			
		reqNo = row.getValue(0);
		reqDept = row.getValue(7);
		reqStatus = row.getValue(11);
		sendAppTo = row.getValue(18);
	}else{		
		if(DepartmentDB.isDeptHead(userBean.getLoginID())){
			record = ApprovalUserDB.getDepartmentHead(userBean.getLoginID());
			if(!record.isEmpty()){
				ReportableListObject row = (ReportableListObject) record.get(0);				
				deptHead = row.getValue(0);
				System.err.println("1[deptHead]:"+deptHead);
				if(!deptHead.equals(userBean.getStaffID())){
					ArrayList deptHeadList = DepartmentDB.getDeptHeadList(userBean.getLoginID());
					ReportableListObject row1 = (ReportableListObject) record.get(0);					
					deptHead = row1.getValue(0);
				}					
			}
		}else{
			record = ApprovalUserDB.getDepartmentHead(userBean.getLoginID());
			if(!record.isEmpty()){
				ReportableListObject row = (ReportableListObject) record.get(0);
				deptHead = row.getValue(0);
				System.err.println("2[deptHead]:"+deptHead);
				if(!deptHead.equals(userBean.getStaffID())){
					deptHead = null;
				}					
			}			
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<%
	String title = "function.dfsr.list"; 
	String suffix = "_2";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="suffix" value="<%=suffix %>" />	
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.dfsr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="retrieveRequest.jsp" method="post">
<table cellpadding="0" cellspacing="5" align="left"
		class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqNo" /></td>		
		<td class="infoData" width="80%">
			<input type="textfield" name="reqNo" value="" maxlength="8" size="30">
			&nbsp;<button onclick="return submitAction('view');">Enter</button>
			<%if(deptHead!=null && deptHead.length()>0) {%>
				&nbsp;<button onclick="return newDeptHRequest();">New</button>
			<%}else{ %>
				&nbsp;<button onclick="return newRequest();">New</button>
			<%} %>						
			&nbsp;<button onclick="return trackList();">Tracking List</button>
			<%if("3799".equals(userBean.getStaffID()) || "terence.ho".equals(userBean.getStaffID())) {%>
				&nbsp;<button onclick="return submitAction('run');">Weekly Bill</button>
			<%} %>														
		</td>					
	</tr>				
</table>
<input type="hidden" name="command" />
</form>
<script language="javascript">
	function submitAction(command) {
		var reqNo = document.form1.reqNo.value.toUpperCase();
		
		if (reqNo == '') {
			alert('Please enter request NO.');
			document.form1.reqNo.focus();
			return false;
		}else{
			document.form1.command.value = command;			
			document.form1.submit();
			return false;						
		}
	}

	function openAction(command,reqNo,noOfRow,folderId,deptHead) {		
		if(noOfRow>0){
			<%System.err.println("[noOfRow]:"+noOfRow+";[command]:"+command+";[reqNo]:"+reqNo+";[deptHead]:"+deptHead);%>
			if(command=='request'){				
				callPopUpWindow("../fs/requestFormCreate.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
			}else if (command=='approve'){
				callPopUpWindow("../fs/requestFormApprove.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
			}else if (command=='menu'){
				callPopUpWindow("../fs/setMenuFormDetail.jsp?reqNo="+reqNo+"&command=order&folderID="+folderId);
			}else if (command=='charge'){
				callPopUpWindow("../fs/setChageFormDetail.jsp?reqNo="+reqNo+"&command=order&folderID="+folderId);								
			}
		}else{
			alert('Please enter valid request NO.');
			return false;						
		}
	}

	function checkReqNo(reqNo) {
		$.ajax({
			type: "POST",
			url: "fs_hidden.jsp",
			data: 'p3=1&p2=' + reqNo,
			async: false,
			success: function(values){				
			if(values != '') {			
				if(values.substring(0, 1) == 1) {
					rtnVal = true;
					return false;																													
				}else if (values.substring(0, 1) == 0){				
					alert('Invalid Requisition Number, Please enter again!');
					document.form1.reqNo.focus();
					rtnVal = false;						
					return false;
				}										
			}else{alert('null value');}//if
			}//success
		});//$.ajax	

		return rtnVal;				
	}	
	
	function newRequest() {
		callPopUpWindow("../fs/requestFormCreate.jsp");
	}

	function newDeptHRequest() {
		callPopUpWindow("../fs/requestFormCreate.jsp");
	}	

	function trackList() {
		callPopUpWindow("../fs/fsTrackList.jsp");
	}	
	<%System.err.println("1[sendAppTo]:"+sendAppTo+";[reqNo]:"+reqNo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus);%>
	<%if(userBean.getLoginID()!=null && userBean.getLoginID().length()>0){ %>
	<%System.err.println("1.1[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus);%>	
	<%if (reqNo!=null && reqNo.length()>0 && "view".equals(command)){%>
	<%System.err.println("1.2[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus+";[userBean.getStaffID():]"+userBean.getStaffID());%>	
		<%if(userBean.getLoginID().equals(reqBy)){ %>
		<%System.err.println("1.3[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus);%>		
			<%if("S".equals(reqStatus)){%>
				<%if(sendAppTo.equals(userBean.getLoginID()) || sendAppTo.equals(userBean.getStaffID())){%>
				<%System.err.println("s1[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus);%>				
					openAction('approve','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');
				<%}else{%>
				<%System.err.println("s2[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus);%>				
					openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','');					
				<%}%>
			<%}else if("A".equals(reqStatus)){%>
				<%if(isChef){%>	
					openAction('menu','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>', '');
				<%}else{%>
					openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','');				
				<%}%>
			<%}else if("M".equals(reqStatus)){%>
				<%if(isChef){%>	
					openAction('charge','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>', '');
				<%}else{%>
					openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','');				
				<%}%>
			<%}else{%>
					openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','');
			<%}%>
		<%}else if(sendAppTo.equals(userBean.getLoginID())|| sendAppTo.equals(userBean.getStaffID())){%>
		<%System.err.println("1.4[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus);%>
			<% if("A".equals(reqStatus)){%>		
				openAction('approve','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');
			<%}else if("S".equals(reqStatus)){%>
				<%if(sendAppTo.equals(userBean.getLoginID()) || sendAppTo.equals(userBean.getStaffID())){%>
				<%System.err.println("s1[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus);%>				
					openAction('approve','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');
				<%}else{%>
				<%System.err.println("s2[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus);%>				
					openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','');					
				<%}%>				
			<%}else{%>
				<%if(isChef){%>	
					openAction('menu','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>', '');
				<%}else{%>
					openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','');				
				<%}%>			
			<%}%>
		<%}else if(isChef){%>
		<%System.err.println("1.5[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus);%>		
			<%if("M".equals(reqStatus)||"B".equals(reqStatus)||"P".equals(reqStatus)||"C".equals(reqStatus)){%>
				openAction('menu','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>', '');
			<%}else{%>
				openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','');
			<%}%>			
		<%}else{%>
		<%System.err.println("1.6[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[reqStatus]:"+reqStatus);%>		
			alert('<%=reqNo%>'+' only open by owner or approver ');
		<%}%>
		<%}else{%>
			<%System.err.println("2[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID());%>
		<%}%>
	<%}else{%>		
		<%System.err.println("3[sendAppTo]:"+sendAppTo+";[userBean.getLoginID()]:"+userBean.getLoginID());%>	
	<%}%>
</script>
</div>

</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>