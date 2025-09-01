<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>

<%

UserBean userBean = new UserBean(request);
String command = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "command"));
String pirID = null;
String pirPIID = null;
String rptSts = ""; 
String replyContent = null;

Boolean SendReplyAction = false;
Boolean closeAction = false;
Boolean viewAction = false;

ReportableListObject row = null;
Boolean IsActionRequestStaff = null;
Boolean IsOshIcn = null;
Boolean closeAccessDeniedAction = false;

String title = "PI Request Action Feedback";
String message = "";
String errorMessage = "";

String actionRequest = null;
String compDate = null;
String requestContent = null;
String autoReminder = null;
String actionrequestStaff = null;
String actionrequestReplyStaff = null;

String emailFromList = null;
%>


<%
if(command != null && command.indexOf("view") > -1) {
	pirID = request.getParameter("pirID");
	pirPIID = request.getParameter("pirPIID");
//	System.out.println("view pirID, pirPIID : " + pirID + " ," + pirPIID);
	viewAction = true;
}
else if(command != null && command.equals("fu_feedback")) {
	pirID = request.getParameter("pirID");
	pirPIID = request.getParameter("pirPIID");
	//System.out.println("fu_feedback pirID, pirPIID : " + pirID + " ," + pirPIID);
	replyContent = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "replyContent"));
	SendReplyAction = true;
}

// check is IsActionRequestStaff	
	IsActionRequestStaff = PiReportDB.IsActionRequestStaff(userBean, pirID, pirPIID); 

	if (!IsActionRequestStaff) {
		closeAccessDeniedAction = true;	
	}

	if (SendReplyAction) {
		PiReportDB.updatePIActionRequest(userBean, pirID, pirPIID, replyContent);		
		
		//reply to pi manager
				
		ArrayList actionRequestDialogByRow = PiReportDB.fetchReportActionRequestUpDialogByRow(pirID, pirPIID);
		if(actionRequestDialogByRow.size() > 0) {
			for(int i = 0; i < actionRequestDialogByRow.size(); i++) {
				row = (ReportableListObject) actionRequestDialogByRow.get(i);
			}
		}
		if (ConstantsServerSide.isHKAH()) {
			actionRequest = "(HKAH-SR) In reply to your request (Report ID : " + pirID + ") : " + row.getValue(2);
		} else if (ConstantsServerSide.isTWAH()) {
			actionRequest = "(HKAH-TW) In reply to your request (Report ID : " + pirID + ") : " + row.getValue(2);
		}
		
		//actionrequestStaff = StaffDB.getStaffEmail(row.getValue(4));
		actionrequestStaff = row.getValue(4);
		compDate = row.getValue(3);
		//actionrequestReplyStaff = StaffDB.getStaffEmail(row.getValue(8));
		actionrequestReplyStaff = row.getValue(8);
		requestContent = row.getValue(5);
		
		PiReportDB.sendEmailActionRequestReply(userBean, actionRequest, pirID, pirPIID, rptSts, "ActionRequestReply", actionrequestStaff, actionrequestReplyStaff, compDate, requestContent);
				
	    SendReplyAction = false;
//		updateAction = false;
//		viewAction = true;
		command = "view";
//		closeAccessDeniedAction = true;
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/banner2.jsp"/>
<%	if (userBean.isLogin() && closeAction) { %>
		<script type="text/javascript">alert('Reply Submitted');window.close();</script>
<%  }	
else if (userBean.isLogin() && closeAccessDeniedAction) {%>
	<script type="text/javascript">alert('Access Denied !');window.close();</script>
<%	} else { %>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="form1" action="actionrequestreply.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
<tr><td>Incident Report Feedback : 
</td></tr>
 
<tr><td><textarea name="replyContent" rows="15" cols="180"></textarea></td></tr>
 	
<tr><td>
<button onclick="return showconfirm('fu_feedback', 1);" class="btn-click">Send Feedback</button>
</td></tr>
</table>
<input type="hidden" name="pirID" value="<%=pirID%>">
<input type="hidden" name="pirPIID" value="<%=pirPIID%>">
<input type="hidden" name="command">
<input type="hidden" name="step">
</form>
</DIV>
</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
<script language="javascript">

	function showconfirm(cmd, stp) {
		$.prompt('Are you sure?',{
			buttons: { Ok: true, Cancel: false },			
			callback: function(v,m,f){
				if (v ){
					submitAction2(cmd, stp);
				}
			},
			prefix:'cleanblue'
		});
		return false;
	}
		
	$().ready(function(){
		// set javascript for the new add comment
		$('#add1').click(function() {
			var options = $('#select1 option:selected');
			if (options.length == 1 && options[0].value != '') {
				return !$('#select1 option:selected').appendTo('#select2');
			} else {
				return false;
			}
		});
		$('#remove1').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});
		removeDuplicateItem('form1', 'responseByIDAvailable', 'toStaffID');
	});



	$(document).ready(function() {
		showInfoFlwUp('staff');
		}
	);

	function submitAction2(cmd, stp) {
		document.form1.command.value = cmd;
		document.form1.submit();
	}

	function showhide(i, hideobj, showobj, showhidelink, hidelink, showlink){
		var showelem = document.getElementById(showobj + i);
		var hideelem = document.getElementById(hideobj + i);
		var linkelem=document.getElementById(showhidelink + i);

		showelem.style.display=showelem.style.display=='none'?'inline':'none';
		hideelem.style.display=hideelem.style.display=='none'?'inline':'none';

		if (hideelem.style.display=='none'){
			linkelem.className="invisible";
			linkelem.innerHTML = showlink;
		} else {
			linkelem.className="visible";
			linkelem.innerHTML = hidelink;
		}
	}

	function removeEventflwup() {
		$('.removeFlwUpStaffInfo').unbind('click');
		$('.removeFlwUpStaffInfo').each(function() {
			$(this).click(function() {
			  if ($('div.ShowflwUpStaffInfo').length > 1) {
				$(this).parent().parent().parent().parent().parent().remove();
			}
			});
		});
	}
	
	function addEventflwup(target, type){
		$(target).each(function() {
			$(this).unbind('click');
			$(this).click(function() {
				showInfoFlwUp(type);
			});
		});
	}
	
	function showInfoFlwUp(type){
		var addBtn = '';
		if(type == 'staff'){
				Row = $('div#hiddenFlwUpStaffInfo').html();
				$('<div class="ShowflwUpStaffInfo" style="">'+Row+'</div>').appendTo('div#ShowflwUpStaffInfo');
				addBtn = '.AddFlwUpStaffInfo';
		}
		addEventflwup(addBtn, type);
		removeEventflwup();
		referKeyEvent();
	}

	// Popup window code
	function newPopup(url) {
		popupWindow = window.open(
			url,'popUpWindow','height=700,width=800,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
	}

</script>
</body>
<%
}
%>
</html:html>