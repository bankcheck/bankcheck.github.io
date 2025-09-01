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

//for Toy mode
//String Toy = "Prod";
String Toy = "Toy";

UserBean userBean = new UserBean(request);
String pirID = request.getParameter("pirID");
String pirDID = request.getParameter("PIR_DID");
String incidentType = request.getParameter("incidentType");
String incident_classification_desc = request.getParameter("incidentType");
String pirPXID = request.getParameter("PIR_PXID");

ReportableListObject row = null;
ReportableListObject row2 = null;
String outVal = "";
String ReceiverType = "admin";
String ccList = "";
Boolean IsReponsiblePerson = null;
//Boolean IsDoubleReponsiblePerson = null;
Boolean IsAddRptPerson = null;
Boolean IsDHead = null;
Boolean IsPIManager = null;
Boolean IsOshIcn = null;
Boolean IsStaffIncident = null;
Boolean IsPatientIncident = null;
String rptSts = null;
String reportStatusDesc = null;
String submitBtnLabel = null;
String RespPerson = null;
String Narrative = null;
String Cause = null;
String ActionDone = null;
String ActionTaken = null;
String RiskAss = null;
String Mon = null;
String Inv = null;
String Treat = null;
String HighCare = null;
String MonSpec = null;
String InvSpec = null;
String TreatSpec = null;
String HighCareSpec = null;
String PersonFault = null;
String InadeTrain = null;
String NoPrevent = null;
String MachFault = null;
String MisUse = null;
String InadeInstru = null;
String InadeEquip = null;
String PoorQual = null;
String QualDetect = null;
String ExpItem = null;
String InadeMat = null;
String InstNotFollow = null;
String MotNature = null;
String Noise = null;
String DistEnv = null;
String UnvFloor = null;
String Slip = null;
String IM = null;
String Culture = null;
String Leader = null;
String Other = null;
String OtherSpec = null;
String Rpt_Narrative = null;
String Rpt_Cause = null;
String Rpt_ActionDone = null;
String Rpt_ActionTaken = null;
String failurecomply = null;
String samedrug = null;
String inappabb = null;
String ordermis = null;
String lasa = null;
String lapses = null;
String equipfailure = null;
String illegalhand = null;
String miscal = null;
String systemflaw = null;
String Inadtrainstaff = null;
String othersfreetext = null;
String othersfreetextedit = null;
String relatedstaff = null;
String sharestaff = null;
String sharestaffdate = null;
//Px
String PxRiskAss = null;
String HighAlert = null;
String BeforeWard = null;
String BeforeOutpat = null;
String AfterWardInv = null;
String AfterWardGiven = null;
String AfterOutpatNottaken = null;
String AfterOutpatTaken = null;
String BeforeDischarge = null;
String AfterDischarge = null;
String BeforeAdmin = null;
String AfterAdmin = null;
String BeforeAdminUnit = null;
String AfterAdminUnit = null;
// End Px
%>


<%
	ArrayList record = PiReportDB.fetchReporDheadComment(pirID);
	if(record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		pirDID = row.getValue(1);
		Narrative = row.getValue(3);
		Cause = row.getValue(4);
		ActionDone = row.getValue(5);
		ActionTaken = row.getValue(6);
		RiskAss = row.getValue(8);
		Mon = row.getValue(9);
		Inv = row.getValue(10);
		Treat = row.getValue(11);
		HighCare = row.getValue(12);
		//
	}


%>


<tr><td>Action Request :
<select name="action" class="notEmpty" value="">
	<option value=""></option>
	<option value="1">Provide general comment on the incident</option>
	<option value="2">Provide photocopy of related patient information</option>
	<option value="3">Provide report from related staff in your department</option>
	<option value="4">Provide investigation report on the incident</option>
	<option value="5">Recommend preventive/remedial measures</option>
	<option value="6">Please send the Post Incident Examination form to PI department</option>
	<option value="7">Others</option>
</select>
 </td></tr>

 <tr>
<td>Completed Date : <input name='fuCompDate' type='textfield' class='datepickerfield'></td>
 </tr>

<tr><td><textarea name="content" rows="7" cols="174"></textarea></td></tr>

<tr><td>
<button onclick="return showconfirm('fu_send', 1);" class="btn-click">Send Action Request</button>
</td></tr>



<script language="javascript">

	function validateForm()
	{
		<%
		if ("7".equals(rptSts) && IsOshIcn) {
		%>
		<%
		}
		else {
	 	%>
		if (document.forms["reportForm"]["myes"].checked) {
			var x=document.forms["reportForm"]["monspec"].value;
			if (x==null || x=="") {
				return false;
			}
//			else {
//				return true;
//			}

		}
		if (document.forms["reportForm"]["iyes"].checked) {
			var x=document.forms["reportForm"]["invspec"].value;
			if (x==null || x=="") {
				return false;
			}
//			else {
//				return true;
//			}

		}
		if (document.forms["reportForm"]["tyes"].checked) {
			var x=document.forms["reportForm"]["treatspec"].value;
			if (x==null || x=="") {
				return false;
			}
//			else {
//				return true;
//			}

		}
		if (document.forms["reportForm"]["hyes"].checked) {
			var x=document.forms["reportForm"]["highcarespec"].value;
			if (x==null || x=="") {
				return false;
			}
//			else {
//				return true;
//			}

		}
		<%
		}
		%>
	return true;
	}


	function showconfirm(cmd, stp) {
		$.prompt('Are you sure?',{
			buttons: { Ok: true, Cancel: false },
			callback: function(v,m,f){
				if (v ){
					if (validateForm()) {
						submitAction2(cmd, stp);
					}
					else {
						alert("Please enter Severity of patient injury");
					}
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

		$(window).unbind('beforeunload', windowOnClose);

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