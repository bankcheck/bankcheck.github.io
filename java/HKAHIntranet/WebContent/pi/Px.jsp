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
String pirPXID = request.getParameter("PIR_PXID");
String incidentType = request.getParameter("incidentType");
String incidentClassification = request.getParameter("incidentClassification");

ReportableListObject row = null;
ReportableListObject row2 = null;
String outVal = "";
String ReceiverType = "admin";
String ccList = "";
Boolean IsReponsiblePerson = null;
//Boolean IsDoubleReponsiblePerson = null;
Boolean IsAddRptPerson = null;
Boolean IsDHead = null;
Boolean IsOshIcn = null;
Boolean IsPx = null;
String rptSts = null;
String reportStatusDesc = null;
String submitBtnLabel = null;
String RespPerson = null;
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
String causeReaction = null;
// End Px
%>
<%
	ArrayList record = PiReportDB.fetchReportPxComment(pirID);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		pirPXID = row.getValue(1);
		PxRiskAss = row.getValue(2);
		HighAlert = row.getValue(3);
		BeforeWard = row.getValue(4);
		BeforeOutpat = row.getValue(5);
		AfterWardInv = row.getValue(6);
		AfterWardGiven = row.getValue(7);
		AfterOutpatNottaken = row.getValue(8);
		AfterOutpatTaken = row.getValue(9);
		BeforeDischarge = row.getValue(10);
		AfterDischarge = row.getValue(11);
		BeforeAdmin = row.getValue(12);
		AfterAdmin = row.getValue(13);
		BeforeAdminUnit = row.getValue(14);
		AfterAdminUnit = row.getValue(15);
		causeReaction = row.getValue(16);
	}

	IsDHead = PiReportDB.IsDHead(userBean.getStaffID());
	IsPx = PiReportDB.IsPx(userBean.getStaffID());
	IsPx = true;
//	IsDoubleReponsiblePerson = PiReportDB.IsDoubleRespondsiblePerson(pirID, userBean.getStaffID(), rptSts);
	IsReponsiblePerson = PiReportDB.IsRespondsiblePerson(pirID, userBean.getStaffID());
	IsAddRptPerson = PiReportDB.IsAddRptPerson(userBean.getStaffID());
	IsOshIcn = PiReportDB.IsOshIcnPerson(userBean.getStaffID());

	if (IsPx) {
%>
	<%--  Follow up Entry--%>
	<table>
		<tr>
			<td>
				<table>
					<tr>
						<td><b>Risk rating :</b>
							<select name="pxPxRiskAss" class="notEmpty" value="2B">
			 					<option value="7"<%if ("7".equals(PxRiskAss)) {%>selected<%} %>>7</option>
								<option value="6"<%if ("6".equals(PxRiskAss)) {%>selected<%} %>>6</option>
								<option value="5"<%if ("5".equals(PxRiskAss)) {%>selected<%} %>>5</option>
								<option value="4"<%if ("4".equals(PxRiskAss)) {%>selected<%} %>>4</option>
								<option value="3"<%if ("3".equals(PxRiskAss)) {%>selected<%} %>>3</option>
			 					<option value="2"<%if ("2".equals(PxRiskAss)) {%>selected<%} %>>2</option>
								<option value="1"<%if ("1".equals(PxRiskAss)) {%>selected<%} %>>1</option>
								<option value="1(ii)"<%if ("1(ii)".equals(PxRiskAss)) {%>selected<%} %>>1(ii)</option>
								<option value="1(i)"<%if ("1(i)".equals(PxRiskAss)) {%>selected<%} %>>1(i)</option>
								<option value="0"<%if ("0".equals(PxRiskAss)) {%>selected<%} %>>0</option>
			 				</select>
			 				<a href="JavaScript:newPopup('PxAssessMatrix.jsp');">Risk Assessment Code</a>
						</td>
					</tr>
					<tr>
						<td>
							<br>
						</td>
					</tr>
<%		if ("530".equals(incidentClassification)) { %>
					<tr>
						<td>
							<b>Classification by cause of reaction</b>
						</td>
						<tr>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="causeReaction" id="causeReactionA" value="a" <%if ("a".equals(causeReaction)) {%>checked<%} %>>Type A: Augmented pharmacological effects
												<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="causeReaction" id="causeReactionB" value="b" <%if ("b".equals(causeReaction)) {%>checked<%} %>>Type B: Bizarre reactions (immunological-allergic)
							</td>
						</tr>
					</tr>
					<tr>
						<td>
							<br>
						</td>
					</tr>
<%		} %>
					<tr>
						<td>
							<b>Does the patient require monitoring ?</b>
						</td>
						<tr>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="HighAlert" id="HighAlert1" value="1" <%if ("1".equals(HighAlert)) {%>checked<%} %>>Yes
												<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="HighAlert" id="HighAlert0" value="0" <%if ("0".equals(HighAlert)) {%>checked<%} %>>No
							</td>
						</tr>
					</tr>
					<tr>
						<td>
							<br>
						</td>
					</tr>
					<tr>
						<td>
							<b>Dispensary</b>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="BeforeWard" value="1" <%if ("1".equals(BeforeWard)) {%>checked<%} %>> Discovered BEFORE drugs were dispensed to WARDS<br>
						</td>
					<tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="BeforeOutpat" value="1" <%if ("1".equals(BeforeOutpat)) {%>checked<%} %>> Discovered BEFORE drugs were dispensed to OUTPATIENTS<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterWardInv" value="1" <%if ("1".equals(AfterWardInv)) {%>checked<%} %>> Discovered AFTER drugs were dispensed to WARDS / UNITS (intervened)<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterWardGiven" value="1" <%if ("1".equals(AfterWardGiven)) {%>checked<%} %>> Discovered AFTER drugs were dispensed to WARDS / UNITS (given / omitted)<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterOutpatNottaken" value="1" <%if ("1".equals(AfterOutpatNottaken)) {%>checked<%} %>> Discovered AFTER drugs were dispensed to OUTPATIENTS (not taken)<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterOutpatTaken" value="1" <%if ("1".equals(AfterOutpatTaken)) {%>checked<%} %>> Discovered AFTER drugs were dispensed to OUTPATIENTS (taken)<br>
						</td>
					</tr>
						<td>
							<br>
						</td>
					<tr>
					</tr>
						<td>
							<b>Ward</b>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="BeforeDischarge" value="1" <%if ("1".equals(BeforeDischarge)) {%>checked<%} %>> Discovered BEFORE drugs were dispensed to DISCHARGED Patient<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterDischarge" value="1" <%if ("1".equals(AfterDischarge)) {%>checked<%} %>> Discovered AFTER drugs were dispensed to DISCHARGED Patient<br>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="BeforeAdmin" value="1" <%if ("1".equals(BeforeAdmin)) {%>checked<%} %>> Discovered BEFORE drugs were administered to patients<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterAdmin" value="1" <%if ("1".equals(AfterAdmin)) {%>checked<%} %>> Discovered AFTER drugs were administered to patients<br>
						</td>
					</tr>
					<tr>
					</tr>
					</tr>
						<td>
							<br>
						</td>
					<tr>
					<tr>
						<td>
							<b>Units other than wards or dispensary (e.g. endoscopy unit, radiology unit , OPD administration, UC satellite dispensing)</b>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="BeforeAdminUnit" value="1" <%if ("1".equals(BeforeAdminUnit)) {%>checked<%} %>> Discovered BEFORE drugs were administered to patients<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterAdminUnit" value="1" <%if ("1".equals(AfterAdminUnit)) {%>checked<%} %>> Discovered AFTER drugs were administered to patients<br>
						</td>
					</tr>
					<tr>
						<td>
							<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							*Items in blue prints are incidents reached the patient; Items in black prints are near misses
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td align="center"><button onclick="return showconfirm('fu_px_comment', 1);" class="btn-click">Save</button></td></tr>
	</table>
	<br/>
	<input type="hidden" name="incidentType" value="<%=incidentType%>"/>
<%--
	<input type="hidden" name="rptsts" value="<%=rptSts%>"/>
	<input type="hidden" name="respparty" value="<%=""%>"/>
--%>
	<input type="hidden" name="pirpxid" value="<%=pirPXID%>"/>
<%
	}
%>


<script language="javascript">

	function validateForm()
	{
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