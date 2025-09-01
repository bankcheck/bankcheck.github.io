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

ReportableListObject row = null;
%>
<form>
<BODY bgcolor="#F7EFEF">
<%--  Follow up dialog --%>
<table border=1>
<tr bgcolor="#D3D3D3" color="white"><td>Reporter Near Miss</td><td>PI Near Miss</td><td>Reporter Classification</td><td>PI Classification</td><td>Document</td></tr>
<%
ArrayList flwUpDialog = PiReportDB.fetchReportPIclass(pirID);
if (flwUpDialog.size() > 0) {
	for (int i = 0; i < flwUpDialog.size(); i++) {
		row = (ReportableListObject) flwUpDialog.get(i);
%>

	<tr bgcolor="#F7EFEF"><td><%=row.getValue(1)%><td><%=row.getValue(2)%></td><td><%=PiReportDB.getClassDesc(ConstantsServerSide.SITE_CODE, row.getValue(3))%></td><td><%=PiReportDB.getClassDesc(ConstantsServerSide.SITE_CODE, row.getValue(4))%></td>
<%
	}
%>
		<td>
			<jsp:include page="../common/document_list.jsp" flush="false">
			<jsp:param name="moduleCode" value="flwup" />
			<jsp:param name="keyID" value="<%=row.getValue(1) %>" />
			</jsp:include>
		</td>
	</tr>
<%
	}
%>
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

	/*
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
	*/


	/*
	$(document).ready(function() {
		showInfoFlwUp('staff');
		}
	);
	*/


	function submitAction2(cmd, stp) {

		// followup to person\
		var personInfo = '';

		$('.ShowflwUpStaffInfo').each(function(index, value) {
			//alert($(this).children().size());
			if($(this).children().size() > 0) {
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
</BODY>
</form>
