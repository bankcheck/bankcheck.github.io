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
String deptCode = userBean.getDeptCode();
String reqNo = null;
String reqDept = null;
String chargeTo = null;
String itemDesc = null;
String fromDate = null;
String toDate = null;
String servFromDate = null;
String servToDate = null;
String reqStatus = null;
String deptHead = null;
String requestType = null;
String role = null;
String ableChargeBill = "N";
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

try{		
	boolean searchAction = false;
	boolean testAction = false;
	String isValid = null;
	
	if("search".equals(command)){
		searchAction = true;
	}
	
	ArrayList record = null;	
	
	fromDate = request.getParameter("fromDate");
	toDate = request.getParameter("toDate");
	servFromDate = request.getParameter("servFromDate");
	servToDate = request.getParameter("servToDate");
	reqNo = request.getParameter("reqNo");
	chargeTo = request.getParameter("chargeTo");
	reqDept = request.getParameter("reqDept");
	reqStatus = request.getParameter("reqStatus");
	requestType = request.getParameter("reqType");
	if(FsDB.ableChargeBill(userBean,"HKAH")){
		ableChargeBill = "Y";
	}
		
	if(FsDB.isApprover(userBean,"HKAH")){
		if(FsDB.isChef(userBean,"HKAH")){
			role = "AC";					
		}else{
			role = "A";			
		}		
	}else{
		if(FsDB.isChef(userBean,"HKAH")){
			role = "C";					
		}else{
			role = "R";			
		}
	}	
	
	if(searchAction){
		request.setAttribute("trackList", FsDB.getTrackList(userBean.getStaffID(), serverSiteCode, reqNo, fromDate, toDate, servFromDate, servToDate, reqDept, chargeTo, reqStatus, requestType, "HKAH" ));
	}else{	
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		Calendar today_plus_1yr = Calendar.getInstance();  
		today_plus_1yr.add( Calendar.YEAR, 1 ); 
		toDate = dateFormat.format(calendar.getTime());
		servToDate = dateFormat.format(today_plus_1yr.getTime());
		request.setAttribute("trackList", FsDB.getTrackList(userBean.getStaffID(), serverSiteCode, reqNo, fromDate, toDate, servFromDate, servToDate, reqDept, chargeTo, reqStatus, requestType, "HKAH" ));	
	}
	
	record = ApprovalUserDB.getDepartmentHead(userBean.getStaffID());
	if (!record.isEmpty()) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		deptHead = row.getValue(0);
	}else{
		System.err.println("[no record]");		
	}

	if(deptHead != null && !deptHead.equals(userBean.getStaffID())){
		deptHead = null;
	}
	System.err.println("[ableChargeBill]:"+ableChargeBill);
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
<form name="search_form" action="fsTrackList.jsp" method="post" onsubmit="return submitSearch();">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">	
		<td class="infoLabel" width="10%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData2" width="20%" colspan=3>
			<input type="textfield" name="reqNo" id="reqNo" value="<%=reqNo==null?"":reqNo %>" maxlength="8" size="30">			
		</td>			
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="10%"><bean:message key="prompt.fromReqDate" /></td>
		<td class="infoData2" width="25%">
			<input type="textfield" name="fromDate" id="fromDate" class="datepickerfield" value="<%=fromDate==null?"":fromDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)			
		</td>
		<td class="infoLabel" width="10%"><bean:message key="prompt.toReqDate" /></td>
		<td class="infoData2" width="25%">
			<input type="textfield" name="toDate" id="toDate" class="datepickerfield" value="<%=toDate==null?"":toDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)			
		</td>
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="10%"><bean:message key="prompt.servFromDate" /></td>
		<td class="infoData2" width="25%">
			<input type="textfield" name="servFromDate" id="servFromDate" class="datepickerfield" value="<%=servFromDate==null?"":servFromDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)			
		</td>
		<td class="infoLabel" width="10%"><bean:message key="prompt.servToDate" /></td>
		<td class="infoData2" width="25%">
			<input type="textfield" name="servToDate" id="servToDate" class="datepickerfield" value="<%=servToDate==null?"":servToDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)			
		</td>
	</tr>			
	<tr class="smallText">		
		<td class="infoLabel" width="15%"><bean:message key="prompt.reqDept" /></td>
		<td class="infoData2" width="40%">
			<select name="reqDept">
			<option></option>
			<%reqDept = reqDept == null ? deptCode : reqDept; %>	
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=reqDept %>" />
				<jsp:param name="allowAll" value="Y" />					
			</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.reqStatus" /></td>	
		<td class="infoData2" width="30%" >		
			<select name="reqStatus" >
				<option value="" />
				<option value="S"<%="S".equals(reqStatus)?" selected":""%>>Waiting approve</option>	
				<option value="R"<%="R".equals(reqStatus)?" selected":""%>>Rejected</option>				
				<option value="A"<%="A".equals(reqStatus)?" selected":""%>>Approved</option>
				<option value="M"<%="M".equals(reqStatus)?" selected":""%>>Menu settle</option>				
				<option value="B"<%="B".equals(reqStatus)?" selected":""%>>Bill settle</option>
				<option value="P"<%="P".equals(reqStatus)?" selected":""%>>Post</option>											
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.chargeTo" /></td>
		<td class="infoData2" width="40%">
			<select name="chargeTo">
			<option></option>
			<%chargeTo = chargeTo == null ? deptCode : chargeTo; %>	
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=chargeTo %>" />
				<jsp:param name="allowAll" value="Y" />					
			</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.requestType" /></td>	
		<td class="infoData2" width="30%">		
			<select name="reqType">
			<option></option>
				<option value="1"<%="1".equals(requestType)?" selected":""%>>Meal Order</option>	
				<option value="2"<%="2".equals(requestType)?" selected":""%>>Miscellaneous Order</option>
			</select>
		</td>
	</tr>		
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">		
			<button onclick="return submitSearch('search');"><bean:message key="button.search" /></button>
<!--			
			<button onclick="return submitSearch('urgentOrder');">Urgent Order</button>
-->			
				<%if (("hkah".equals(serverSiteCode) && ("300".equals(deptCode) || "640".equals(deptCode))) ||
						("twah".equals(serverSiteCode) && ("FOOD".equals(deptCode) || "FOOD".equals(deptCode)))) {%>
						<button onclick="return submitSearch('post');">Generate Charges</button>			
						<button onclick="return submitSearch('report');">Report</button>
						<button onclick="return menuList();">Menu List</button>	
				<%}%>			
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>			
		</td>			
	</tr>
</table>
<display:table id="row" name="requestScope.trackList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column title="Req NO." style="width:5%" >
		<a href="javascript:void(0);" onclick="openSheet('<c:out value="${row.fields0}" />','<c:out value="${row.fields7}" />','<%=role %>','<c:out value="${row.fields8}" />','<%=user %>','<%=staffId %>','<%=deptHead %>','<c:out value="${row.fields9}" />','<c:out value="${row.fields10}" />');"><c:out value="${row.fields0}" /></a>	
	</display:column>			
	<display:column property="fields1" title="Serve Datetime" style="width:5%" />
	<display:column property="fields2" title="Req By" style="width:5%" />
	<display:column property="fields3" title="Charge To" style="width:10%" />	
	<display:column property="fields4" title="Location" style="width:10%" />	
	<display:column property="fields5" title="NO. of Meals" style="width:5%" />
	<display:column property="fields6" title="Purpose" style="width:10%" />
	<display:column title="Status" media="html" style="width:5%">
		<logic:equal name="row" property="fields7" value="S">
			<input type=hidden name="status<c:out value="${row.fields0}" />" value="S">Waiting approve</input>
		</logic:equal>
		<logic:equal name="row" property="fields7" value="C">
			<input type=hidden name="status<c:out value="${row.fields0}" />" value="C">Cancelled</input>
		</logic:equal>		
		<logic:equal name="row" property="fields7" value="R">
			<input type=hidden name="status<c:out value="${row.fields0}" />" value="R">Rejected</input>
		</logic:equal>				
		<logic:equal name="row" property="fields7" value="A">
			<input type=hidden name="status<c:out value="${row.fields0}" />" value="A">Approved</input>
		</logic:equal>
		<logic:equal name="row" property="fields7" value="M">
			<input type=hidden name="status<c:out value="${row.fields0}" />" value="M">Menu settled</input>
		</logic:equal>				
		<logic:equal name="row" property="fields7" value="B">
			<input type=hidden name="status<c:out value="${row.fields0}" />" value="B">Bill settled</input>
		</logic:equal>
		<logic:equal name="row" property="fields7" value="P">
			<input type=hidden name="status<c:out value="${row.fields0}" />" value="P">Post</input>
		</logic:equal>		
	</display:column>
<!-- 	
	<display:column property="fields12" title="Request Type" style="width:0%" />
 -->	
	<display:column property="fields11" title="Approver" style="width:0%" />		
	<display:column title="View" media="html" style="width:8%; text-align:center">
		<button onclick="return viewLog('<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="command" />
</form>
<script language="javascript">
	function closeAction() {
		window.close();
	}
	
	function openSheet(reqNo, reqStatus, role, reqBy, user, staffId, deptHead, req_dept_head, sendAppTo) {
		var ableCB = "<%=ableChargeBill%>";
		if(user==reqBy){			
			if(reqStatus=='A'){
				if(role=='A'){
					role = 'R';
				}else if(role=='C'){
					role = 'C';
				}				
			}else if(reqStatus=='M'){
				if(role=='A'){
					role = 'R';
				}else if(role=='C'){
					role = 'C';
				}				
			}else if(reqStatus=='B'){
				if(role=='A'){
					role = 'R';
				}else if(role=='C'){
					role = 'C';
				}				
			}	
		}else if(user==sendAppTo){
			if(reqStatus=='S'){				
				if(role=='R'){
					role = 'A';
				}else if(role=='C'){
					role = 'C';
				}					
			}else if(reqStatus=='A'){
				if(role=='A'){
					role = 'R';
				}else if(role=='C'){
					role = 'C';
				}				
			}else if(reqStatus=='M'){
				if(role=='A'){
					role = 'R';
				}else if(role=='C'){
					role = 'C';
				}				
			}else if(reqStatus=='B'){
				if(role=='A'){
					role = 'R';
				}else if(role=='C'){
					role = 'C';
				}				
			}			
		}

		if(role=='R'){
			if(reqStatus=='M' && ableCB=="Y"){				
				callPopUpWindow("../fs/setChargeFormDetail.jsp?reqNo="+reqNo+"&command=view");				
			}else{				
				callPopUpWindow("../fs/requestFormCreate.jsp?reqNo="+reqNo+"&command=view");				
			}
		}else if(role=='A'){		
			if(reqStatus=='S'){
				callPopUpWindow("../fs/requestFormApprove.jsp?reqNo="+reqNo+"&command=view");							
			}else{
				callPopUpWindow("../fs/requestFormCreate.jsp?reqNo="+reqNo+"&command=view");
			}
		}else if(role=='C'){
			if(reqStatus=='A'){
				callPopUpWindow("../fs/setMenuFormDetail.jsp?reqNo="+reqNo+"&command=view");			
			}else if(reqStatus=='M'){
				if(ableCB=="Y"){
					callPopUpWindow("../fs/setChargeFormDetail.jsp?reqNo="+reqNo+"&command=view");
				}else{
					callPopUpWindow("../fs/requestFormCreate.jsp?reqNo="+reqNo+"&command=view");
				}
			}else if(reqStatus=='B'){
				callPopUpWindow("../fs/setChargeFormDetail.jsp?reqNo="+reqNo+"&command=view");				
			}else {
				callPopUpWindow("../fs/requestFormCreate.jsp?reqNo="+reqNo+"&command=view");
			}
		}else if(role=='AC'){
			if(reqStatus=='S'){
				callPopUpWindow("../fs/requestFormApprove.jsp?reqNo="+reqNo+"&command=view");				
			}else if(reqStatus=='A'){
				callPopUpWindow("../fs/setMenuFormDetail.jsp?reqNo="+reqNo+"&command=view");
			}else if(reqStatus=='M'){
				callPopUpWindow("../fs/setChargeFormDetail.jsp?reqNo="+reqNo+"&command=view");
			}else if(reqStatus=='B'){
				callPopUpWindow("../fs/setChargeFormDetail.jsp?reqNo="+reqNo+"&command=view");				
			}else {
				callPopUpWindow("../fs/requestFormCreate.jsp?reqNo="+reqNo+"&command=view");
			}
		}
		return false;
	}	
	
	function refresh(){
		submitSearch('search');
	}
	
	
	function submitSearch(cmd) {
		document.search_form.command.value = cmd;
		
	 	if(cmd=='post') {
			callPopUpWindow("../fs/generateCharges.jsp");
			return false;
	 	}else if(cmd=='report') {
			callPopUpWindow("../fs/fsReport.jsp");
			return false;			
	 	}else if(cmd=='urgentOrder'){
			callPopUpWindow("../fs/requestFormUrgent.jsp");
			return false;	 		
	 	}
		document.search_form.submit();
		return false;
	}
	
	function viewLog(reqNo, reqSeq){
		callPopUpWindow("../fs/fsTrackLog.jsp?reqNo="+reqNo);
		return false;
	}
	
	function menuList() {
		callPopUpWindow("../fs/fsMenuList.jsp");
	}	
</script>
</div>
</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>