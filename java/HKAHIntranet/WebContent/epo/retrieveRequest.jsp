<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String reqNo = request.getParameter("reqNo");
String reqBy = null;
String reqDept = null;
String folderId = null;
String approver = null;
String reqStatus = null;
String deptHead = null;
String deptHeadName = null;
String message = "";
String errorMessage = "";
String isFirstApprover = null;
int noOfRow = 0;
boolean isPurchaser = false;
boolean isDIDept = false;
ArrayList record = null;
String displayTitle = null;
String catType = request.getParameter("catType");
String serverSiteCode = ConstantsServerSide.SITE_CODE;

boolean runAction = false;

if("run".equals(command)){
	runAction = true;
}
System.err.println("[runAction]:"+runAction+";[reqNo]:"+reqNo+";[command]:"+command);
try {
	if(runAction){
//		EPORequestDB.menuGenWeeklyBill();
		System.err.println("[run doAction]");
	}else{
		System.err.println("2[runAction]:"+runAction+";[reqNo]:"+reqNo+";[command]:"+command);		
		// load data from database		
		if (reqNo != null&&reqNo.length() > 0&&"view".equals(command)) {
			System.err.println("[reqNo]:"+reqNo);		
			isPurchaser = EPORequestDB.isPurchaser(userBean,"HKAH");		
			
			record = EPORequestDB.getRequestHdr(reqNo.toUpperCase());
			noOfRow = record.size();
			
			if(noOfRow>0){
				ReportableListObject row = (ReportableListObject) record.get(0);
				reqNo = row.getValue(0);
				reqBy = row.getValue(2);
				reqDept = row.getValue(4);			
				reqStatus = row.getValue(9);			
				approver = row.getValue(11);
				folderId = row.getValue(13);
				deptHead = EPORequestDB.getDeptHead(reqDept);
				deptHeadName = UserDB.getUserName(deptHead);
			}
			
			isFirstApprover = EPORequestDB.checkFirstApprover(reqNo, userBean.getStaffID());	
		}else{
			System.err.println("[userBean.getStaffID()]:"+userBean.getStaffID());
			if(DepartmentDB.isDeptHead(userBean.getStaffID())){
				record = ApprovalUserDB.getDepartmentHead(userBean.getStaffID());
				if(!record.isEmpty()){
					ReportableListObject row = (ReportableListObject) record.get(0);				
					deptHead = row.getValue(0);
					System.err.println("1[deptHead]:"+deptHead);
					if(!userBean.getStaffID().equals(deptHead)){
						ArrayList deptHeadList = DepartmentDB.getDeptHeadList(userBean.getStaffID());
						ReportableListObject row1 = (ReportableListObject) record.get(0);					
						deptHead = row1.getValue(0);
					}					
				}
			}else{
				record = ApprovalUserDB.getDepartmentHead(userBean.getStaffID());
				if(!record.isEmpty()){
					ReportableListObject row = (ReportableListObject) record.get(0);
					deptHead = row.getValue(0);
					System.err.println("2[deptHead]:"+deptHead);
					if(!userBean.getStaffID().equals(deptHead)){
						deptHead = null;
					}					
				}			
			}
		}
	}
	
	if ("hkah".equals(serverSiteCode)) {	
		isDIDept = EPORequestDB.isDIDept(userBean.getDeptCode());
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
	String title = "function.epo.list";
	String suffix = "_2";
	if("noninv".equals(catType)){
		displayTitle = "Non-inventory item";
	}else if("capitem".equals(catType)){
		displayTitle = "Captial item";
	}else{
		displayTitle = title;
	}
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=displayTitle %>" />
	<jsp:param name="suffix" value="<%=suffix %>" />	
	<jsp:param name="category" value="admin" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.epo.list" /></bean:define>
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
		if(command=='run'){
			document.form1.command.value = command;			
			document.form1.submit();
			return false;			
		}else{
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
	}

	function openAction(command,reqNo,noOfRow,folderId,deptHead) {		
		if(noOfRow>0){
			if(command=='request'){
				if(deptHead!=''){
					callPopUpWindow("../epo/requestFormDeptH.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);					
				}else{
					callPopUpWindow("../epo/requestForm.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);					
				}
			}else if (command=='approve'){
				callPopUpWindow("../epo/approveForm.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
			}else if (command=='order'){
				callPopUpWindow("../epo/orderDetail.jsp?reqNo="+reqNo+"&command=order&folderID="+folderId);				
			}
		}else{
			alert('Please enter valid request NO.');
			return false;						
		}
	}

	function checkReqNo(reqNo) {
		$.ajax({
			type: "POST",
			url: "epo_hidden.jsp",
			data: 'p1=6&p2=' + reqNo,
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
		callPopUpWindow("../epo/requestForm.jsp");
	}

	function newDeptHRequest() {
		callPopUpWindow("../epo/requestFormDeptH.jsp");
	}	
	
	
	function newHKIOCRequest() {
		callPopUpWindow("../epo/requestFormHKIOC.jsp");
	}		

	function trackList() {
		callPopUpWindow("../epo/epoTrackList.jsp");
	}
	<%if(userBean.getStaffID()!=null && userBean.getStaffID().length()>0){%>
	<%System.err.println("1[isFirstApprover]:"+isFirstApprover+";[approver]:"+approver+";[deptHead]:"+deptHead+";[userBean.getStaffID()]:"+userBean.getStaffID());%>;	
	<%if (reqNo!=null && reqNo.length()>0 && "view".equals(command)){%>	
		<%if(reqBy.equals(userBean.getStaffID()) || userBean.getStaffID().equals(deptHead) || userBean.getStaffID().equals(deptHeadName)){ %>
			<%if("H".equals(reqStatus)){%>
				<%if(userBean.getStaffID().equals(approver) || "1".equals(isFirstApprover) || userBean.getStaffID().equals(approver)){%>
					openAction('approve','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');
				<%}else{%>
					<%if(userBean.getStaffID().equals(deptHead)||userBean.getStaffID().equals(deptHeadName) ){%>					
						openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');					
					<%}else{%>				
						openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','');					
					<%}%>
				<%}%>
			<%}else if("F".equals(reqStatus)){%>
				<%if(userBean.getStaffID().equals(approver)){%>
					openAction('approve','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');
				<%}else{%>
					<%if(userBean.getStaffID().equals(deptHead)||userBean.getStaffID().equals(deptHeadName) ){%>					
						openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');					
					<%}else{%>					
						openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','');					
					<%}%>
				<%}%>			
			<%}else{%>			
				<%if(userBean.getStaffID().equals(deptHead)||userBean.getStaffID().equals(deptHeadName)){%>			
					openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');
				<%}else{%>	
					openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','');				
				<%}%>
			<%}%>					
		<%}else if(userBean.getStaffID().equals(approver) || "1".equals(isFirstApprover)){%>		
			<%if("C".equals(reqStatus)){ %>			
				openAction('request','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');
			<%}else{%>			
				openAction('approve','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');
			<%}%>
		<%}else if(isPurchaser){%>		
			<% if("A".equals(reqStatus) || "O".equals(reqStatus) || "P".equals(reqStatus) || "Z".equals(reqStatus)){%>			
				openAction('order','<%=reqNo %>','<%=noOfRow %>','<%=folderId %>','<%=deptHead %>');
			<%}else{%>	
				alert('<%=reqNo%>'+' requisition not yet approved or cancal or pending');
			<%}%>										
		<%}else{%>
			alert('<%=reqNo%>'+' only open by owner or approver ');
		<%}%>			
	<%}%>
	<%System.err.println("2[isFirstApprover]:"+isFirstApprover+";[approver]:"+approver+";[userBean.getStaffID()]:"+userBean.getStaffID());%>;	
	<%}%>
</script>
</div>

</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>