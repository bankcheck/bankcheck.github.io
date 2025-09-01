<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.TreeMap"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String as_docNo = request.getParameter("docNo");
String as_recType = request.getParameter("recType");
String as_recStatus = request.getParameter("rdStatus");
String as_approver = request.getParameter("approver");
String as_ctsNo = null;

String message = request.getParameter("message");
if (message == null) {
	message = "";
}

String errorMessage = "";
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
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper>
<div id=mainFrame>
<div id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.cts.docAssign" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.cts.list2" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="search_form" action="docAgnRecordList.htm" method="post" >
<input type="hidden" name="search" value="yes"/>
<table cellpadding="0" cellspacing="5" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.approvalDoc" /></td>
		<td class="infoData" width="15%">
			<%=as_approver==null?"":as_approver %>
			<input type="hidden" name="approver" value="<%=as_approver==null?"":as_approver %>" maxlength="10" size="50">
		</td>
		<td class="infoLabel" width="10%"><bean:message key="prompt.approvalFname" /></td>
		<td class="infoData" width="15%"><c:out value="${cts.docFname }"/></td>
		<td class="infoLabel" width="10%"><bean:message key="prompt.approvalGname" /></td>
		<td class="infoData" width="15%"><c:out value="${cts.docGname }"/></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.docNo" /></td>
		<td class="infoData" width="15%">
			<input type="textfield" name="docNo" value="<c:out value="${cts.as_docNo }"/>" maxlength="10" size="50">
		</td>
		<td class="infoLabel" width="10%"><bean:message key="prompt.recStatus" /></td>
		<td class="infoData" width="15%">
			<select name="rdStatus">
				<option value="">
				<option value="V"<%="V".equals(as_recStatus)?" selected":""%>>Information verified</option>
				<option value="A"<%="A".equals(as_recStatus)?" selected":""%>>Approved</option>
				<option value="R"<%="R".equals(as_recStatus)?" selected":""%>>Reject</option>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.docfName" /></td>
		<td class="infoData" width="15%"><input type="textfield" name="docfName" value="" maxlength="10" size="50"></td>
		<td class="infoLabel" width="10%"><bean:message key="prompt.docgName" /></td>
		<td class="infoData" width="35%" colspan=3><input type="textfield" name="docgName" value="<c:out value="${cts.as_docGname }"/>" maxlength="10" size="50"></td>
		<td align="left">
			<button onclick="return submitSearch();">Search</button>
		</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="middleText">
		<td class=infoLabelBlk width="100" >
			<input type="checkbox" id="selectAll" />&nbsp;Select all
			&nbsp
			<select id="allRdStatus">
				<option value="A"<%="A".equals(as_recStatus)?" selected":""%>>Approved</option>
				<option value="J"<%="J".equals(as_recStatus)?" selected":""%>>Rejected</option>
			</select>
			&nbsp
			<button onclick="return submitAllAction();" >
					Submit All
			</button>
		</td>
	</tr>
</table>
<display:table id="row" name="requestScope.cts.table" export="false" pagesize="" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:2%">
		<%=pageContext.getAttribute("row_rowNum")%>
		<input type="checkbox" name="isRcdCheck" id="isRcdCheck" value="<c:out value="${row.fields0}" />" class="isRcdCheck" />
	</display:column>
	<display:column title="CTS NO." style="width:5%">
		<logic:equal name="row" property="fields8" value="R">
			<a href="javascript:void(0);" onclick="submitRenew('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><c:out value="${row.fields0}" /></a>
		</logic:equal>
		<logic:equal name="row" property="fields8" value="F">
			<a href="javascript:void(0);" onclick="submitRenew('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><c:out value="${row.fields0}" /></a>
		</logic:equal>
		<logic:equal name="row" property="fields8" value="V">
			<a href="javascript:void(0);" onclick="submitRenew('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><c:out value="${row.fields0}" /></a>
		</logic:equal>
		<logic:equal name="row" property="fields8" value="A">
			<a href="javascript:void(0);" onclick="submitRenew('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><c:out value="${row.fields0}" /></a>
		</logic:equal>
		<logic:equal name="row" property="fields8" value="S">
			<c:out value="${row.fields0}" />
		</logic:equal>
		<logic:equal name="row" property="fields8" value="X">
			<c:out value="${row.fields0}" />
		</logic:equal>
		<logic:equal name="row" property="fields8" value="Y">
			<c:out value="${row.fields0}" />
		</logic:equal>
		<logic:equal name="row" property="fields8" value="Z">
			<c:out value="${row.fields0}" />
		</logic:equal>
		<logic:equal name="row" property="fields8" value="I">
			<c:out value="${row.fields0}" />
		</logic:equal>
		<logic:equal name="row" property="fields8" value="L">
			<c:out value="${row.fields0}" />
		</logic:equal>
		<logic:equal name="row" property="fields8" value="K">
			<c:out value="${row.fields0}" />
		</logic:equal>
		<logic:equal name="row" property="fields8" value="N">
			<c:out value="${row.fields0}" />
		</logic:equal>
		<logic:equal name="row" property="fields8" value="D">
			<c:out value="${row.fields0}" />
		</logic:equal>
	</display:column>
	<display:column property="fields1" title="Doctor NO." style="width:5%" />
	<display:column title="Doctor Name" style="width:5%">
		<div id="docName[${row_rowNum - 1}].fields2">
			<c:out value="${row.fields2}" />
		</div>
	</display:column>
	<display:column property="fields3" title="Specialty" style="width:10%" />
	<display:column property="fields4" title="Start_Date" style="width:5%" />
	<display:column property="fields5" title="Termination Date" style="width:5%" />
	<display:column property="fields11" title="Record Create Date" style="width:5%" />
	<display:column property="fields6" title="Email" style="width:8%" />
	<display:column title="Record Status" style="width:5%">
		<logic:equal name="row" property="fields8" value="V">
			<select name="recordStatus<c:out value="${row.fields0}" />">
				<option value="V"<%="V".equals(((ReportableListObject) pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Information verified</option>
				<option value="A"<%="A".equals(((ReportableListObject) pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Approved</option>
				<option value="J"<%="J".equals(((ReportableListObject) pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Rejected</option>
			</select>
		</logic:equal>
		<logic:equal name="row" property="fields8" value="A">
			<select name="recordStatus<c:out value="${row.fields0}" />">
				<option value="A"<%="A".equals(((ReportableListObject) pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Approved</option>
			</select>
		</logic:equal>
		<logic:equal name="row" property="fields8" value="J">
			<select name="recordStatus<c:out value="${row.fields0}" />">
				<option value="J"<%="J".equals(((ReportableListObject) pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Rejected</option>
			</select>
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<%if ("V".equals(((ReportableListObject) pageContext.getAttribute("row")).getFields8())) { %>
			<%if ("A".equals(((ReportableListObject) pageContext.getAttribute("row")).getFields14())) { %>
				<font color="green">Approved</font>
			<%} else if ("J".equals(((ReportableListObject) pageContext.getAttribute("row")).getFields14())) { %>
				<font color="red">Rejected</font>
			<%} else { %>
			<button onclick="return submitApprove('approve','A','<c:out value="${row.fields0}" />','<c:out value="${row_rowNum - 1}" />');">
				<bean:message key='button.approve' />
			</button>
			<button onclick="return submitApprove('reject','R','<c:out value="${row.fields0}" />','<c:out value="${row_rowNum - 1}" />');">
				<bean:message key='button.reject' />
			</button>
			<%} %>
		<%} %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<div id="progressbar" style="position:absolute; z-index:15;display:none;"
		class="ui-dialog ui-widget ui-widget-content ui-corner-all">
	<div class="ui-widget-header">Status</div><br/>
	<div class="progress-label">Loading...</div><br/>
</div>
<input type="hidden" name="command"/>
<input type="hidden" name="ctsNo"/>
<input type="hidden" name="recType"/>
<input type="hidden" name="recStatus"/>
<input type="hidden" name="remarks"/>
</form>
<script language="javascript">
$(document).ready(function() {
	$('#selectAll').click(function() {
		if ($(this).attr('checked')) {
			$('.isRcdCheck').attr('checked', true);
		} else {
			$('.isRcdCheck').attr('checked', false);
		}
	});

	$('#allRdStatus').change(function() {
		if ($(this).attr("selected","selected")) {
			var value = $(this).val();

			var checkboxes = document.search_form.elements['isRcdCheck'];
			for (i = 0; i < checkboxes.length; i++) {
				if (checkboxes[i].checked) {
					$('select[name=recordStatus + checkboxes[i].value] option[value='+value+']').attr('selected', 'selected');
				}
			}
		}
	});
});

function submitSearch() {
	document.search_form.submit();
}

function submitRenew(ctsNO,docCode) {
	callPopUpWindowMX('../cts/renewForm.jsp?ctsNo='+ctsNO+'&docCode='+docCode+'&command=check&role=approver');
}

function submitAllAction() {
	$('#progressbar').css('top', 350);
	$('#progressbar').css('left', $(window).width()/2-$('#progressbar').width()/2);
	$('#progressbar').show();

	var successPost = 0;
	var failPost = 0;
	var totalPost = 0;
	var postRecord = 0;
	var isCheck = null;
	var rStatus = document.getElementById("allRdStatus").value;

	var checkboxes = document.search_form.elements['isRcdCheck'];
	for (i = 0; i < checkboxes.length; i++) {
		if (checkboxes[i].checked) {
			totalPost++;
			$.ajax({
				url: '../cts/submitAllCtsRecord.jsp',
				data: {ctsNo:checkboxes[i].value, docCode:'<%=as_approver %>', recStatus:rStatus, mode:'DOCTOR'},
				async: true,
				type: 'POST',
				success: function(data, textStatus, jqXHR) {
					if ($.trim(data)=='true') {
						successPost++;
					} else {
						failPost++;
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					failPost++;
				},
				complete: function(jqXHR, textStatus) {
					postRecord++;
					if (totalPost==postRecord) {
						submitSearch();
					}
					$('.progress-label').html(
							'Posting.......'+postRecord+'/'+totalPost+'<br/>'+
							'(Success: '+successPost+' Fail: '+failPost+')');
				}
			});

		}
	}

	return false;
}

function submitApprove(cmd,status,ctsNo,index) {
	var docName = document.getElementById("docName["+index+"].fields2").innerHTML;
	var remarks = '';
	if (cmd == 'reject') {
		remarks = prompt("Please enter reject reason:");
		if (remarks == null) {
			return false;
		} else if (remarks.length > 50) {
			alert("Please enter reject reason within 50 characters!");
			return false;
		}
	}

	$.prompt('Confirm ' + cmd + ' renew record of:<br>Dr. ' + docName,{
		buttons: { Ok: true, Cancel: false },
		callback: function(v,m,f) {
			if (v) {
				submit: confirmAction(cmd,ctsNo,status,remarks);
				return true;
			} else {
				return false;
			}
		},
		prefix:'cleanblue'
	});
	return false;
}

function confirmAction(cmd,ctsNo,status,remarks) {
	document.search_form.command.value = cmd;
	document.search_form.ctsNo.value = ctsNo;
	document.search_form.recStatus.value = status;
	document.search_form.remarks.value = remarks;
	document.search_form.submit();
	return false;
}

</script>
</div>
</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>