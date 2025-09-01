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
String user = userBean.getLoginID();
String staffId = userBean.getStaffID();
String reqNo = null;
String reqDept = null;
String deptCode = null;
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
	System.err.println("[fsTrackList][requestType]:"+requestType);	
	
	if(FsDB.isApprover(userBean,"HKAH")){	
		role = "A";
		System.err.println("1[role]"+role);
	}else{
		if(FsDB.isChef(userBean,"HKAH")){
			role = "C";		
			System.err.println("2[role]"+role);			
		}else{
			role = "R";
			System.err.println("3[role]"+role);			
		}
	}	
	
	if(searchAction){
		System.err.println("[searchAction]:"+searchAction);
		request.setAttribute("trackList", FsDB.getTodayPastList(userBean.getLoginID(), serverSiteCode));
	}else{	
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		Calendar today_plus_1yr = Calendar.getInstance();  
		today_plus_1yr.add( Calendar.YEAR, 1 ); 
		toDate = dateFormat.format(calendar.getTime());
		servToDate = dateFormat.format(today_plus_1yr.getTime());
		request.setAttribute("trackList", FsDB.getTodayPastList(userBean.getLoginID(), serverSiteCode));	
	}
	
	record = ApprovalUserDB.getDepartmentHead(userBean.getLoginID());
	if (!record.isEmpty()) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		deptHead = row.getValue(0);
		System.err.println("1[deptHead]"+deptHead+";[userBean.getLoginID()]:"+userBean.getLoginID());
	}else{
		System.err.println("[no record]");
		System.err.println("2[deptHead]"+deptHead+";[userBean.getLoginID()]:"+userBean.getLoginID());		
	}

	if(deptHead != null && !deptHead.equals(userBean.getStaffID())){
		deptHead = null;
		System.err.println("3[deptHead]"+deptHead+";[userBean.getLoginID()]:"+userBean.getLoginID());
	}
	System.err.println("4[deptHead]"+deptHead+";[userBean.getLoginID()]:"+userBean.getLoginID()+";[userBean.getStaffID()]"+userBean.getStaffID());	
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
	<jsp:param name="mustLogin" value="N" />	
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.dfsr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="search_form" action="fsMenuList.jsp" method="get">
<table id="fsMenuList" class="display" cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="bigText">
		<td>						
		<button class="ui-button ui-widget ui-state-default ui-button-text-only" 
					style="width:200px; height:60px;font-size:24px!important;" onclick="return submitAction('print');return false;">
			COMING ORDER
		</button>
		<button class="ui-button ui-widget ui-state-default ui-button-text-only" 
				style="width:150px; height:60px;font-size:24px!important;" onclick="return pageRefresh();return false;">
			REFRESH
		</button>
		</td>																	
	</tr>
	<tr valign="top" class="bigText" id="orderList">	
		<td >
<display:table id="row" name="requestScope.trackList" class="tablesorter1">
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column title="" media="html" style="width:10%;">	
		<input type=hidden name="reqNo[${row_rowNum - 1}]" value=${requestScope.trackList[row_rowNum - 1].fields0}></input>			
	</display:column>	
	<display:column property="fields1" title="Serve Date" style="width:5%" />
	<display:column property="fields2" title="Time" style="width:5%" />	
	<display:column property="fields3" title="Charge To" style="width:30%" />	
	<display:column property="fields4" title="Location" style="width:30%" />	
	<display:column property="fields5" title="NO. of Meals" style="width:5%" />	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>		
		</td>
		<td>
		<table class="contentFrameMenu" border="0" id="MenuSelect_indicator">
		</table>			
		</td>			
	</tr>	
</table>
<input type="hidden" name="command" />
</form>
<script type="text/javascript" src="jquery-1.4.2.min.js"></script>
<script language="javascript">
	var assumeMaxRow = 1000;

	function closeAction() {
		window.close();
	}
	
	function showDetails(reqNo) {
		$.ajax({
			type: "POST",
			url: "../fs/menuDetails.jsp",
			data: "reqNo=" + reqNo,
			success: function(values){
				if(values != '') {
					$("#MenuSelect_indicator").html(values);
				}//if
			}//success
		});//$.ajax
	}	
	
	function submitSearch(cmd) {
		document.search_form.command.value = cmd;
		
	 	if(cmd=='post') {
			callPopUpWindow("../fs/generateCharges.jsp");
			return false;
	 	}else if(cmd=='urgentOrder'){
			callPopUpWindow("../fs/requestFormUrgent.jsp");
			return false;	 		
	 	}
		document.search_form.submit();
		return false;
	}
	
	function clearBackGroundColor(){
		$('#row tr').each(function(i,v) { 
		       $(this).find('td').each (function() {
			        $(this).css("background","");
			       });
		});		
	}	
	
	function createClickableRow(){  
		$('#row td').each(function(i,v) { 
			$(this).click(
				function(){
					var str = $.trim( $(this).parent('tr').find("td").eq(1).html());
					var reqNo = null;
					var pos = 0;
					for(var i = 0 ; i<=assumeMaxRow; i++){
							reqNo = document.getElementsByName("reqNo["+i+"]")[0].value;
							pos = str.indexOf(reqNo);
							if(pos>0){
								break;
							}
					}
					showDetails(reqNo);					
//			 		showDetails($.trim( $(this).parent('tr').find("td").eq(1).html()));
			 		clearBackGroundColor();
			 		$(this).parent('tr').find('td').css('background', '#FFFF99');
			 		
				}		
			);	
					
/*				
			$(this).parent('tr').hover(
		      function () {
		       $(this).find('td').each (function() {
		        $(this).css("background","yellow");
		       });
		        
		      }, 
		      function () {
		       $(this).find('td').each (function() {
		        $(this).css("background","");
		       });
		      }
		    );
			*/
		});
	}
	
	function pageRefresh(){
		window.location.reload();
		return false;
	}	
	
	function viewLog(reqNo, reqSeq){
		callPopUpWindow("../fs/fsTrackLog.jsp?reqNo="+reqNo);
		return false;
	}
	
	$(document).ready(function(){	    	    
	    createClickableRow();	    
	});
	
	function Timer(callback, delay) {
	    var timerId, start, remaining = delay;

	    this.pause = function() {
	        window.clearTimeout(timerId);
	        remaining -= new Date() - start;
	        isRunning = false;
	        alert('pause');	        
	    };

	    this.resume = function() {
	        start = new Date();
	        timerId = window.setTimeout(callback, remaining);
	        isRunning = true;
			var str = $.trim( $("#row tr:eq(1)").find("td").eq(1).html());
			var reqNo = null;
			var pos = 0;
			for(var i = 0 ; i<=assumeMaxRow; i++){
					reqNo = document.getElementsByName("reqNo["+i+"]")[0].value;
					pos = str.indexOf(reqNo);
					if(pos>0){
						break;
					}
			}	        
	        showDetails(reqNo);
	        $("#row tr:eq(1)").find("td").css('background', '#FFFF99');
	    };

	    
	    this.resume();
	}
	var isRunning = false;
	
	var timer = new Timer(function myrefresh()
	{
		window.location.reload();
		}, 999999999);
</script>
</div>
</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>