<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String serverSiteCode = ConstantsServerSide.SITE_CODE;
String user = userBean.getStaffID();
String staffId = userBean.getStaffID();
String reqNo = null;
String reqDept = null;
String itemDesc = null;
String fromDate = null;
String toDate = null;
String reqBugCode = null;
String adCouncil = null;
String boardCouncil = null;
String financeComm = null;
String reqStatus = null;
String deptHead = request.getParameter("deptHead");
String role = null;
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

try{
	ArrayList record = null;	
	
	if(EPORequestDB.isApprover(userBean,"HKAH")){	
		role = "A";
		System.err.println("1[role]"+role);
	}else{
		if(EPORequestDB.isPurchaser(userBean, "HKAH")){
			role = "P";		
			System.err.println("2[role]"+role);			
		}else{
			role = "R";
			System.err.println("3[role]"+role);			
		}
	}

	boolean searchAction = false;
	
	if("search".equals(command)){
		searchAction = true;
	}
	
	if(searchAction){
		reqNo = request.getParameter("reqNo");
		reqDept = request.getParameter("reqDept");
		itemDesc = request.getParameter("itemDesc");
		fromDate = request.getParameter("fromDate");
		toDate = request.getParameter("toDate");
		reqBugCode = request.getParameter("reqBugCode");
		adCouncil = request.getParameter("adCouncil");
		boardCouncil = request.getParameter("boardCouncil");
		financeComm = request.getParameter("financeComm");	
		reqStatus = request.getParameter("reqStatus");
		request.setAttribute("trackList", EPORequestDB.getTrackList(userBean.getStaffID(), reqNo.toUpperCase(), serverSiteCode, reqDept, reqStatus, fromDate, toDate, reqBugCode, itemDesc, "HKAH"));		
	}else{
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		toDate = dateFormat.format(calendar.getTime());
		request.setAttribute("trackList", EPORequestDB.getTrackList(userBean.getStaffID(), reqNo, serverSiteCode, reqDept, reqStatus, fromDate, toDate, reqBugCode, itemDesc, "HKAH"));	
	}
	
	record = ApprovalUserDB.getDepartmentHead(userBean.getStaffID());
	if (!record.isEmpty()) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		deptHead = row.getValue(0);
		System.err.println("1[deptHead]"+deptHead+";[userBean.getStaffID()]:"+userBean.getStaffID());
	}else{
		System.err.println("[no record]");
		System.err.println("2[deptHead]"+deptHead+";[userBean.getStaffID()]:"+userBean.getStaffID());		
	}

	if(deptHead != null && !deptHead.equals(userBean.getStaffID())){
		deptHead = null;
		System.err.println("3[deptHead]"+deptHead+";[userBean.getStaffID()]:"+userBean.getStaffID());
	}
	System.err.println("4[deptHead]"+deptHead+";[userBean.getStaffID()]:"+userBean.getStaffID()+";[userBean.getStaffID()]"+userBean.getStaffID());
} catch (Exception e) {
	e.printStackTrace();
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
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>
<%
	String title = "function.epo.list"; 
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
<bean:define id="functionLabel"><bean:message key="function.epo.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="search_form" action="epoTrackList.jsp" method="post" onsubmit="return submitSearch();">
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText">	
		<td class="infoLabel" width="15%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData2" width="35%" >
			<input type="textfield" name="reqNo" id="reqNo" value="<%=reqNo==null?"":reqNo %>" maxlength="8" size="30">			
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.reqStatus" /></td>	
		<td class="infoData2" width="35%">		
			<select name="reqStatus" >
				<option value="" />
				<option value="S"<%="S".equals(reqStatus)?" selected":""%>>Waiting for department head</option>
				<option value="H"<%="H".equals(reqStatus)?" selected":""%>>Waiting approve</option>				
				<option value="F"<%="F".equals(reqStatus)?" selected":""%> >Further Approval</option>	
				<option value="A"<%="A".equals(reqStatus)?" selected":""%> >Final Approval</option>
				<option value="C"<%="C".equals(reqStatus)?" selected":""%> >Cancelled</option>				
				<option value="R"<%="R".equals(reqStatus)?" selected":""%> >Rejected</option>  				
				<option value="D"<%="D".equals(reqStatus)?" selected":""%> >Pending</option>
				<option value="Z"<%="Z".equals(reqStatus)?" selected":""%> >PO Processing</option>
				<option value="P"<%="P".equals(reqStatus)?" selected":""%> >Partial order</option>				
				<option value="O"<%="O".equals(reqStatus)?" selected":""%> >Ordered</option>								
			</select>
		</td>					
	</tr>
	<tr class="smallText">		
		<td class="infoLabel" width="15%"><bean:message key="prompt.reqDept" /></td>
		<td class="infoData2" width="85%" colspan=3>
			<select name="reqDept">
			<option></option>
			<%reqDept = reqDept == null ? "" : reqDept; %>
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=reqDept %>" />
				<jsp:param name="allowAll" value="Y" />					
			</jsp:include>
			</select>
		</td>			
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="15%"><bean:message key="prompt.fromReqDate" /></td>
		<td class="infoData2" width="35%">
			<input type="textfield" name="fromDate" id="fromDate" class="datepickerfield" value="<%=fromDate==null?"":fromDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)			
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.toReqDate" /></td>
		<td class="infoData2" width="35%">
			<input type="textfield" name="toDate" id="toDate" class="datepickerfield" value="<%=toDate==null?"":toDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)			
		</td>
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="15%"><bean:message key="prompt.itemDesc" /></td>
		<td class="infoData2" width="85%" colspan=3>
			<input type="textfield" name="itemDesc" id="itemDesc" value="<%=itemDesc==null?"":itemDesc %>" maxlength="100" size="100" />			
		</td>				
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="15%"><bean:message key="prompt.reqBugCode" /></td>
		<td class="infoData2" width="85%" colspan=3>
			<input type="textfield" name="reqBugCode" id="reqBugCode" value="<%=reqBugCode==null?"":reqBugCode %>" maxlength="30" size="100" />			
		</td>				
	</tr>		
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">		
			<button onclick="return submitSearch('search');"><bean:message key="button.search" /></button>			
		</td>			
	</tr>
</table>
<%System.err.println("[deptHead]"+deptHead+";[user]:"+user+";[role]:"+role);%>
<display:table id="row" name="requestScope.trackList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column title="Req NO." style="width:5%" >
		<a href="javascript:void(0);" onclick="openSheet('<c:out value="${row.fields0}" />','<c:out value="${row.fields9}" />','<c:out value="${row.fields10}" />','<%=role %>','<c:out value="${row.fields11}" />','<%=user %>','<%=staffId %>','<%=deptHead %>','<c:out value="${row.fields12}" />','<c:out value="${row.fields13}" />','<c:out value="${row.fields14}" />');"><c:out value="${row.fields0}" /></a>	
	</display:column>		
	<display:column property="fields1" title="Req Date" style="width:5%" />
	<display:column property="fields2" title="Req By" style="width:5%" />
	<display:column property="fields3" title="Req Dept." style="width:10%" />
	<display:column property="fields4" title="Req Desc" style="width:15%" />
	<display:column property="fields5" title="Budget Code" style="width:5%" />
	<display:column property="fields6" title="Record Status" style="width:10%" />
	<display:column property="fields7" title="Last Modify By" style="width:5%" />
	<display:column title="View" media="html" style="width:10%; text-align:center">
		<button onclick="return viewPoDetail('<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>			
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">		
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>			
		</td>			
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="deptHead" />
</form>
<script language="javascript">
	function closeAction() {
		window.close();
	}
	
	function isExistApprovlGroupByReqNO(reqNo,deptHead ){
		$.ajax({
			type: "POST",
			url: "epo_hidden.jsp",
			data: 'p1=8&p2=' + reqNo +'&p3='+deptHead+'&p4=HKIOC',
			async: false,
			success: function(values){				
			if(values != '') {			
				if(values.substring(0, 1) == 1) {
					rtnVal = true;
					return false;																													
				}else if (values.substring(0, 1) == 0){
					rtnVal = false;						
					return false;
				}										
			}else{alert('null value');}//if
			}//success
		});//$.ajax	

		return rtnVal;		
	}

	function openSheet(reqNo, reqStatus, folderId, role, reqBy, user, staffId, deptHead, req_dept_head, reqDept, sendAppTo) {
		var siteCode = '<%=serverSiteCode%>';
		var appGrp = null;

		if(isExistApprovlGroupByReqNO(reqNo,deptHead) &&
				'HKAH'==siteCode.toUpperCase() && ('416'==reqDept||'417'==reqDept||'418'==reqDept)){
			if(reqStatus=='H' && role!='A'){
				role = 'A';
				appGrp = 'HKIOC';
			}
		}else{
			appGrp = 'HKAH';
		}
				
		if(user==reqBy){
			if(reqStatus=='A'){
				if(role=='A'){
					role = 'R';
				}else if(role=='P'){
					role = 'P';
				}
			}else if(reqStatus=='Z'){
				if(role=='A'){
					role = 'R';
				}else if(role=='P'){
					role = 'P';
				}
			}else if(reqStatus=='D'){
				if(role=='A'){
					role = 'R';
				}else if(role=='P'){
					role = 'P';
				}				
			}else if(reqStatus=='O'){
				if(role=='P'){
					role = 'R';
				}
			}	
		}
		
		if(role=='R'){				
			if(user==req_dept_head || staffId==req_dept_head || sendAppTo==user){				
				callPopUpWindow("../epo/requestFormDeptH.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);				
			}else{
				if(deptHead!='' && deptHead!='null'){
					callPopUpWindow("../epo/requestFormDeptH.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
				}else{
					callPopUpWindow("../epo/requestForm.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
				}				
			}
		}else if(role=='A'){
			if(reqStatus=='A' || reqStatus=='F' || reqStatus=='S' || reqStatus=='H'){
				callPopUpWindow("../epo/approveForm.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId+"&appGrp="+appGrp);								
			}else{
				if(user==reqBy){
					callPopUpWindow("../epo/requestForm.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
				}else{
					callPopUpWindow("../epo/requestForm.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
				}
			}
		}else if(role=='P'){
			if((deptHead!='' && deptHead!='null') || (user==req_dept_head || staffId==req_dept_head)){
				callPopUpWindow("../epo/requestFormDeptH.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
			}else{
				if(reqStatus=='A' || reqStatus=='O' || reqStatus=='P' || reqStatus=='Z' || reqStatus=='D'){
					callPopUpWindow("../epo/orderDetail.jsp?reqNo="+reqNo+"&command=order&folderID="+folderId);
				}else if(reqStatus=='S'||reqStatus=='C'){
					callPopUpWindow("../epo/requestForm.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
				}else if(reqStatus=='H'){
					callPopUpWindow("../epo/requestFormDeptH.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
				}else{
					if(user==reqBy){
						callPopUpWindow("../epo/requestForm.jsp?reqNo="+reqNo+"&command=view&folderID="+folderId);
					}else{
						alert('Requisition have not yet approved');
					}
				}
			}
		}
		return false;
	}
	
	function viewPoDetail(reqNo){
		callPopUpWindow("../epo/epoTrackDetail.jsp?reqNo="+reqNo);
		return false;
	}
	
	function refresh(){
		submitSearch('search');
	}	
	
	function submitSearch(cmd) {
		document.search_form.command.value = cmd;
		document.search_form.submit();
		return false;
	}
</script>
</div>
</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>