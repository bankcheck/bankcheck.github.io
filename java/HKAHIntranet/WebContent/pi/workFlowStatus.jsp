<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
UserBean userBean = new UserBean(request);
String pirID = request.getParameter("pirID");
String incident_classification = request.getParameter("incidentType");
String incident_classification_pi = null;

ReportableListObject row = null;
ReportableListObject row2 = null;
String ccList = "";
String deptCode = null;
String deptCodeFlwup = null;
String rptSts = null;
String rptStsDesc = null;
String ReqPerson = null;
String RespPerson = null;

boolean isHKAH = ConstantsServerSide.isHKAH();
boolean isTWAH = ConstantsServerSide.isTWAH();

ArrayList flwUpDialogCCList = null;
String dialogContent = null;
String rowBgColor = null;
%>

<form>
<BODY bgcolor="#F7EFEF">
<%
	ArrayList record = PiReportDB.fetchReportBasicInfo(pirID);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		incident_classification = row.getValue(10);
		incident_classification_pi = row.getValue(29);
		deptCode = row.getValue(8);
		deptCodeFlwup = row.getValue(32);
		rptSts = row.getValue(9);
	}
%>

<%--  Follow up dialog --%>
<table border=1>
<%
if (isTWAH) {
	%><tr bgcolor="#D3D3D3" color="white"><td>Date</td><td>Message Type</td><td>From</td><td>Responsible Party</td><td>Status</td><td>Redo Reason</td><%
} else {
	%><tr bgcolor="#D3D3D3" color="white"><td>Date</td><td>Message Type</td><td>From</td><td>Status</td><td>Responsible Party</td><td>Redo Reason</td><%
}

if (isTWAH) {
	%><td>Completed&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><%
}
%>
</tr>
<%
ArrayList flwUpDialog = PiReportDB.fetchReportFlwUpDialog(pirID);
if (flwUpDialog.size() > 0) {
	for (int i = 0; i < flwUpDialog.size(); i++) {
		row = (ReportableListObject) flwUpDialog.get(i);
		flwUpDialogCCList = PiReportDB.fetchReportFlwUpDialogCCList(pirID, row.getValue(1));
		rptStsDesc = PiReportDB.getRptStsDesc(PiReportDB.IsPxDeptCode(deptCodeFlwup), incident_classification, deptCode, row.getValue(9));
		if (flwUpDialogCCList.size() > 0) {
			for (int j = 0; j < flwUpDialogCCList.size(); j++) {
				row2 = (ReportableListObject) flwUpDialogCCList.get(j);
				if (j == 0) {
					ccList = row2.getValue(1);
				}
				else {
					ccList = ccList + ", " + row2.getValue(1);
				}
			}
		}
		else {
			ccList = "";
		}

		// check double respond party
		if (row.getValue(11).isEmpty()) {
			RespPerson = row.getValue(7);
		}
		else {
			RespPerson = row.getValue(7) + ", " + row.getValue(11);
		}
		if (RespPerson == null || RespPerson.length() == 0) {
			RespPerson = "&nbsp;";
		}

		ReqPerson = StaffDB.getStaffName(row.getValue(3));
		if (ReqPerson == null || ReqPerson.length() == 0) {
			ReqPerson = "&nbsp;";
		}

		rowBgColor = i % 2 == 1 ? "#EF7DFDF" : "#F7EFEF";

		%><tr bgcolor="<%=rowBgColor%>"><%
			%><td><font color="<%=i==0?"black":"grey" %>"><%=row.getValue(4)%></font></td><%
			%><td><font color="<%=i==0?"black":"grey" %>"><%=row.getValue(2)%></font></td><%
			%><td><font color="<%=i==0?"black":"grey" %>"><%=ReqPerson %></font></td><%
		if (isTWAH) {
			%><td><font color="<%=i==0?"black":"grey" %>"><%=RespPerson%></font></td><%
			%><td><font color="<%=i==0?"black":"grey" %>"><%=rptStsDesc%></font></td><%
		} else {
			%><td><font color="<%=i==0?"black":"grey" %>"><%=rptStsDesc%></font></td><%
			%><td><font color="<%=i==0?"black":"grey" %>"><%=RespPerson%></font></td><%
		}

		// try to display larger dialog comment
		dialogContent = row.getValue(8);
		if (dialogContent.length() > 100) {
			%><td><font color="<%=i==0?"black":"grey" %>"><%=dialogContent.substring(0, 45)%> <a href="JavaScript:newPopup('flwUpDialogContent.jsp?pirid=<%=pirID%>&contentid=<%=row.getValue(1)%>&contentType=flwupmsg');">more...</a></font></td><%
		} else if (dialogContent.length() > 0) {
			%><td><font color="<%=i==0?"black":"grey" %>"><%=dialogContent %></font></td><%
		} else {
			%><td>&nbsp;</td><%
		}
%>
<!--
		<td>
			<jsp:include page="../common/document_list.jsp" flush="false">
			<jsp:param name="moduleCode" value="flwup" />
			<jsp:param name="keyID" value="<%=row.getValue(1) %>" />
			</jsp:include>
		</td>
-->
<%
if (isTWAH) {
%>
	<%
	if (i == 0 && !"5".equals(row.getValue(9))) {
	%>
		<td><font color="black">WIP</font></td>
	<%
	} else {
	%>
		<td><font color="grey">Completed</font></td>
	<%
	}
	%>
<%
}
%>
	</tr>

<%
	}
}
%>
</table>

<%--
display workflow diagram
--%>
<table border=1>
<td>
	<%=PiReportDB.getFlowchart(rptSts, incident_classification) %>
</td>
</table>

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

		// followup to person\
		var personInfo = '';

		$('.ShowflwUpStaffInfo').each(function(index, value) {
			//alert($(this).children().size());
			if ($(this).children().size() > 0) {
				personInfo = '<input type="hidden" name="fuStaffNo" value="'+
									$(this).find('[name=involveStaffNo]').val()+'||'+
									$(this).find('[name=involveStaffName]').val()
									+((editAction)?('||'+$(this).find('[name=pir_ip_id]').val()):"")
								+'"/>';

				$(personInfo).appendTo('div#ShowflwUpStaffInfo');
			}
		});


		$('#select2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});

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
		if (type == 'staff'){
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
			url,'popUpWindow','height=1000,width=1000,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
	}

</script>
</BODY>
</form>
