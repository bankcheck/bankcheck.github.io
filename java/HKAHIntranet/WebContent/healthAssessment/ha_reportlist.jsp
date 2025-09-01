<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.displaytag.tags.*"%>
<%@ page import="org.displaytag.util.*"%>
<%@ page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.ss.usermodel.Cell"%>
<%@ page import="org.apache.poi.ss.usermodel.CellStyle"%>
<%@ page import="org.apache.poi.ss.usermodel.CreationHelper"%>
<%@ page import="org.apache.poi.ss.usermodel.DataFormat"%>
<%@ page import="org.apache.poi.ss.usermodel.Font"%>
<%@ page import="org.apache.poi.ss.usermodel.IndexedColors"%>
<%@ page import="org.apache.poi.ss.usermodel.Row"%>
<%@ page import="org.apache.poi.ss.usermodel.Sheet"%>
<%@ page import="org.apache.poi.ss.usermodel.Workbook"%>
<%

String command = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "command"));
String moduleCode = ParserUtil.getParameter(request, "moduleCode");
String accessControlYN = "cis".equalsIgnoreCase(moduleCode) ? "N" : "Y";
String drCode = ParserUtil.getParameter(request, "drCode");

UserBean userBean = new UserBean(request);
String input_date_from = request.getParameter("input_date_from");
String input_date_to = request.getParameter("input_date_to");
String incident_date_to = request.getParameter("incident_date_to");
String report_date_from = request.getParameter("report_date_from");
String report_date_to = request.getParameter("report_date_to");
String classification = request.getParameter("classification");
String status = request.getParameter("status");
String nearmiss = request.getParameter("nearmiss");
String patNo = request.getParameter("patNo");
String patName = request.getParameter("patName");
String patIDNo = request.getParameter("patIDNo");
String patTel = request.getParameter("patTel");
String completed = request.getParameter("completed");

//incident classfication
String equip = request.getParameter("equip");
String increlopr = request.getParameter("increlopr");
String bloodtrans = request.getParameter("bloodtrans");
String adr = request.getParameter("adr");
String med = request.getParameter("med");
String patfall = request.getParameter("patfall");
String patgen = request.getParameter("patgen");
String bef = request.getParameter("bef");
String stagen = request.getParameter("stagen");
String stafall = request.getParameter("stafall");
String secu = request.getParameter("secu");
String vrofall = request.getParameter("vrofall");
String vrogen = request.getParameter("vrogen");
String oth = request.getParameter("oth");
//
String[] traffics = null;
String[] patNos = null;
String[] piremarks = null;
String[] piremarks2 = null;
String[] piremarks3 = null;
String[] umdmRemarks = null;
String[] umdmRemarks2 = null;
String[] umdmRemarks3 = null;
String[] donremarks = null;
String[] vparemarks = null;
String listTablePageParaName = (new ParamEncoder("row").encodeParameterName(TableTagParameters.PARAMETER_PAGE));
String listTableCurPage = request.getParameter(listTablePageParaName);


Boolean IsRedoStatus = false;
Boolean SaveTrafficAction = false;
Boolean SaveDonReamrkAction = false;
Boolean SaveVPARemarkAction = false;
Boolean SaveUMDMRemark = false;
Boolean ExcelReport = false;
Workbook wb = null;
Boolean IsPIManager = null;
Boolean IsDHead = null;
Boolean IsPharmacySeniorStaff = null;
Boolean IsNursingAdmin = null;
Boolean IsCooVpa = null;
String xlsFileName = null;
Boolean ExcelPIReportType = false;
Boolean ExcelPIReportUnit = false;
Boolean ExcelPIReportTypeUnit = false;
Boolean ExcelPIReportSummary = false;
Boolean ExcelPIReportComparison = false;
Boolean ExcelPIReportBoard = false;
Boolean ExcelPIReportFall = false;
Boolean ExcelPIReportFallNurse = false;
Boolean ExcelPIReportFallControlChart = false;
Boolean SearchRecord = false;
ArrayList viewList = null;
Boolean IsNursingStaff = false;
Boolean furtherActionReminder = false;
Boolean reporterReminder = false;
Boolean postExamReminder = false;
Boolean ceoReminder = false;
//
String currYear = request.getParameter("ceoyear");
String currMonth = request.getParameter("ceomonth");
if ("".equals(currYear) || currYear == null) {
	currYear = Integer.toString(DateTimeUtil.getCurrentYear());
}
if ("".equals(currMonth) || currMonth == null) {
	currMonth = Integer.toString(DateTimeUtil.getCurrentMonth());
}
String currDay = null;
//inc_date_to = getLastMonthDay("1/" + Integer.toString(Integer.parseInt(currMonth) + 1) + "/2015");
Boolean ExcelPIReportCEO = false;
Boolean ExcelPIReportDOH = false;
Boolean ExcelPIReportPX = false;
String StatusLabel = null;
String staffID = userBean.getStaffID();

if (staffID == null) {
	staffID = drCode;
}

//System.out.println("staffID list : " + staffID);
//System.out.println("command : " + command);
//System.out.println("moduleCode : " + moduleCode);
//System.out.println("drCode : " + drCode);


if ("null".equals(moduleCode)) {
	moduleCode = null;
}
if ("null".equals(drCode)) {
	drCode = null;
}


// temp code
//staffID = "3883";
//

if(status == null) {
	status = "";
}

//IsPIManager = PiReportDB.IsPIManager(userBean.getLoginID(), "");
//IsDHead = PiReportDB.IsDHead(userBean.getLoginID());
//IsNursingStaff = PiReportDB.IsNursingStaff(userBean.getStaffID());
//IsPharmacySeniorStaff = PiReportDB.IsPharmacySeniorStaff(userBean.getStaffID());
//IsNursingAdmin = PiReportDB.IsNursingAdmin(userBean.getStaffID());
//IsCooVpa = PiReportDB.IsCooVpa(userBean.getStaffID());

if (command == null) {
	command = "search";
	SearchRecord = true;
}
else if (command.equals("search")) {
	SearchRecord = true;
}
else if(command != null && command.equals("save_pi")) {
	SaveTrafficAction = true;
}

if(command != null) {
	if (SearchRecord = true) {
		if ((input_date_from == "") || (input_date_from == null)) {
			//input_date_from = DateTimeUtil.getCurrentDateTime().substring(0, 10);
		}
		if ((input_date_to == "") || (input_date_to == null)) {
			//input_date_to = DateTimeUtil.getCurrentDateTime().substring(0, 10);
		}
		viewList = HAFormDB.getHAReportList(drCode, patNo, patName, patIDNo, patTel, completed, input_date_from, input_date_to);
		request.setAttribute("reportList", viewList);
	} else if (SaveTrafficAction) { // save pi remark
		command = "view";
		SaveTrafficAction = false;
	}
}

//viewList = HAFormDB.getHAReportList(drCode, patNo, patName, patIDNo, patTel, completed, input_date_from, input_date_to);
//request.setAttribute("reportList", viewList);
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

<%
if (ConstantsServerSide.isHKAH()) {
	StatusLabel = "Wait for ";
} else {
	StatusLabel = "Pending ";
}
%>

<%
if (ConstantsServerSide.isHKAH()) {
%>
	<style>
		span.pagebanner { font-size: 15px; }
		span.pagelinks  { font-size: 15px; }
	</style>
<%
}
%>
<body>
	<DIV id=indexWrapper>
		<DIV id=mainFrame>
			<DIV id=contentFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="P.E. Health Assessment Form" />
					<jsp:param name="keepReferer" value="Y" />
					<jsp:param name="accessControl" value="<%=accessControlYN %>"/>
					<jsp:param name="mustLogin" value="<%=accessControlYN %>"/>
				</jsp:include>
				<bean:define id="functionLabel"><bean:message key="function.pe.report.list" /></bean:define>
				<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
				<form name="searchfrom" action="ha_reportlist.jsp" method="post">
					<input type="hidden" name="<%=listTablePageParaName %>" value="<%=listTableCurPage %>" />
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">

						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Input Date
							</td>
							<td class="infoData" width="85%">
								<input type="textfield" name="input_date_from" id="input_date_from"
									class="datepickerfield" value="<%=input_date_from==null?"":input_date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="input_date_to" id="input_date_to"
									class="datepickerfield" value="<%=input_date_to==null?"":input_date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>
						</tr>

						<tr class="smallText">
							<td  class="infoLabel" style="width:15%">
									Pat No
								</td>
								<td id="patNoCell" style="vertical-align:top" colspan="2" class="infoData" style="width:85%">
									<input name="patNo" type="textfield" value="<%=(patNo==null)?"":patNo %>" maxlength="30" size="30" />
								</td>
						</tr>
						<tr class="smallText">
							<td  class="infoLabel" style="width:15%">
									Name
								</td>
								<td id="patNameCell" style="vertical-align:top" colspan="2" class="infoData" style="width:85%">
									<input name="patName" type="textfield" value="<%=(patName==null)?"":patName %>" maxlength="30" size="30" />
								</td>
						</tr>
						<tr class="smallText">
							<td  class="infoLabel" style="width:15%">
									ID No
								</td>
								<td id="patIDNoCell" style="vertical-align:top" colspan="2" class="infoData" style="width:85%">
									<input name="patIDNo" type="textfield" value="<%=(patIDNo==null)?"":patIDNo %>" maxlength="30" size="30" />
								</td>
						</tr>
						<tr class="smallText">
							<td  class="infoLabel" style="width:15%">
									Tel
								</td>
								<td id="patTelCell" style="vertical-align:top" colspan="2" class="infoData" style="width:85%">
									<input name="patTel" type="textfield" value="<%=(patTel==null)?"":patTel %>" maxlength="30" size="30" />
								</td>
						</tr>
						<tr class="smallText">
							<td  class="infoLabel" style="width:15%">
									Status
							</td>
							<%--
							<td id="completed" style="vertical-align:top" colspan="2" class="infoData" style="width:85%">
								<input name="completed" type="textfield" value="<%=(completed==null)?"":completed%>" maxlength="30" size="30" />
							</td>
							 --%>
							<td id="completed">
								<select name="completed">
								<option value=""<%=(completed!=null && "".equals(completed))?"selected":"" %>>All</option>
								<option value="0"<%=(completed!=null && "0".equals(completed))?"selected":"" %>>To be Completed</option>
								<option value="1"<%=(completed!=null && "1".equals(completed))?"selected":"" %>>Completed</option>
								</select>
							</td>
						</tr>


						<tr class="smallText">
							<td colspan="2" align="center">
								<button onclick="return AddRegPEForm();">Add P.E. Form</button>
								<button onclick="submitSearch()">
									<bean:message key="button.search" />
								</button>
								<button onclick="clearSearch()">
									<bean:message key="button.clear" />
								</button>
							<%
							if ("cis".equals(moduleCode)) {
							%>
									<button onclick="windowClose()">
										Back to Clinical Main Screen
									</button>
							<%
							}
							%>
							</td>
						</tr>
					</table>
				<%
				String RegID = "";
				%>
				<display:table id="row" name="requestScope.reportList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable"
				 	excludedParams="piremarks piremarks2 piremarks3 patNos traffics">
					<display:column property="fields0" title="Date" style="text-align:center;width:1%" />
					<display:column media="html" title="Status" style="width:2%">
							<logic:equal name="row" property="fields14" value="0">
								To Be Completed
							</logic:equal>
							<logic:equal name="row" property="fields14" value="1">
								Completed
							</logic:equal>
					</display:column>

					<display:column property="fields1" title="Form ID" style="text-align:center;width:1%" />
					<display:column property="fields17" title="Physical Exam Type" style="text-align:center;width:2%" />
					<display:column property="fields16" title="Dr Name" style="text-align:center;width:4%" />
					<display:column property="fields5" title="Pat No" style="text-align:center;width:1%" />
					<display:column property="fields6" title="Name" style="text-align:left;width:3%" />
					<display:column property="fields8" title="ID No" style="text-align:center;width:2%" />
					<display:column property="fields9" title="Birth date" style="text-align:center;width:1%" />
					<display:column property="fields10" title="Sex" style="text-align:center;width:1%" />

					<%--
						<display:column property="fields11" title="Addr" style="width:1%" />
					--%>
					<display:column property="fields12" title="Tel" style="text-align:center;width:1%" />
					<%--
					<display:column property="fields13" title="Reg ID" style="width:8%" />
					 --%>
					<%--
					<display:column title="RegId" style="width:10%">
					--%>
         				<%--
         				 	<c:set var="RegID" value="${row.fields13}"/>
         				--%>
							<%//String regID = (String)pageContext.getAttribute("tempRegID") ;
								//tempRegId = HAFormDB.getLatesrRegID(tempRegID);
							%>
					<%--
						         <c:out value='<%=regID%>'/>
				     </display:column>
				     --%>
					<display:column titleKey="prompt.action" media="html" style="width:5%; text-align:center">
						<button onclick="return editReport('<c:out value="${row.fields5}" />', '<c:out value="${row.fields13}" />', '<c:out value="${row.fields18}" />', '<c:out value="${row.fields17}" />');"><bean:message key='button.view' /></button>
						<button onclick="return printReport('pdfAction', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields17}" />', 'NEW');"><bean:message key='button.print' /></button>
						<logic:equal name="row" property="fields17" value="CCRP1">
							<button onclick="return printReport('pdfAction', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields17}" />', 'OLD');"><bean:message key='button.print' /> (Old Form)</button>
						</logic:equal>
						<%
						if (userBean.isAccessible("function.haa.update.form_type")) {
							String type = (((ReportableListObject)pageContext.getAttribute("row")).getValue(17));
							
							if (type != null && type.startsWith("CCRP")) {
								if (!"CCRP1".equals(type)) {
									%>
									<button onclick="return submitAction2('changeFormType','1','<c:out value="${row.fields1}" />','<c:out value="${row.fields5}" />', 'CCRP1');">Change to CCRP1</button>
									<%
								}
							}
						}
						%>
					</display:column>
					<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
				</display:table>
					<input type="hidden" name="command" value="<%=command %>" />
					<input type="hidden" name="moduleCode" value="<%=moduleCode %>" />
					<input type="hidden" name="drCode" value="<%=drCode %>" />
				</form>
				<table align="center">
				</table>
				<script language="javascript">

		        	 function windowClose() {
	    	             window.open('','_parent','');
	        	         window.close();
			         }



					function showconfirm(cmd) {
						$.prompt('Are you sure?',{
							buttons: { Ok: true, Cancel: false },
							callback: function(v,m,f){
								if (v ){
									submitAction2(cmd);
									if (cmd == 'pifurtheraction_remind') {
										alert('Reminder Sent');
									}
									if (cmd == 'pireport_remind') {
										alert('Reminder Sent');
									}
								}
							},
							prefix:'cleanblue'
						});
						return false;
					}

					function submitAction2(cmd, step, haID, patno, newFormType) {
						if (cmd = 'changeFormType') {
							if (step == 1) {
								$.prompt('Are you sure to change form ID: ' + haID + ' to ' + newFormType + '?',{
									buttons: { Ok: true, Cancel: false },
									callback: function(v,m,f){
										if (v ){
											submitAction2(cmd, '2', haID, patno, newFormType);
										}
									},
									prefix:'cleanblue'
								});
								return false;
							} else {
								showOverLay('body');
								showLoadingBox('body', 500);
								
								$.ajax({
									type: "POST",
									url: "ha_reportlist_update.jsp?command="+cmd+"&haID="+haID+"&patno="+patno+"&newFormType="+newFormType,
									async: true,
									cache: false,
									dataType: 'text',
									success: function(values){
										hideLoadingBox('body', 500);
										hideOverLay('body');
										
										alert(values.trim());
										submitSearch();
									},//success
									error: function(jqXHR, textStatus, errorThrown) {
										hideLoadingBox('body', 500);
										hideOverLay('body');
										
										alert('Update failed:' + textStatus);
									}
								});//$.ajax
							}
						} else {
							document.searchfrom.command.value = cmd;
							document.searchfrom.submit();
	
							//$.prompt('Saving..... Please wait.',{
							//	prefix:'cleanblue', buttons: { }
							//});
						}

					}

					function AddRegPEForm() {
						newPopup('reg_reportlist.jsp?moduleCode=cis');
						return false;
					}

					function editReport(patNo, regid, seqno, formtype) {
						//alert(patNo + ' ' + regid);
						if(formtype == 'CCRP2') {
							newPopup('health_assess_form_ccrp2.jsp?staffID=<%=staffID%>&patNo=' + patNo + '&regID=' + regid + '&seqNo=' + seqno + '&formType=' + formtype);
						} else if (formtype == 'CCRP3') {
								newPopup('health_assess_form_ccrp2.jsp?staffID=<%=staffID%>&patNo=' + patNo + '&regID=' + regid + '&seqNo=' + seqno + '&formType=' + formtype);
						} else {
							newPopup('health_assess_form.jsp?staffID=<%=staffID%>&patNo=' + patNo + '&regID=' + regid + '&seqNo=' + seqno + '&formType=' + formtype);
						}
						return false;
					}

					function printReport(action, haID, formtype, type) {
						if(action == 'pdfAction') {
							callPopUpWindow("print_report.jsp?command="+action+"&haID="+haID+"&formType=" + formtype+"&type=" + type);
						}
						return false;
					}

					function printReportccr(action, haID) {
						if(action == 'pdfAction') {
							callPopUpWindow("print_report.jsp?command="+action+"&haID="+haID+"&formType=ccr");
						}
						return false;
					}

					function printReceipt(action,haID) {
						if(action == 'pdfAction') {
							callPopUpWindow("print_report.jsp?command="+action+"&haID="+haID);
						}
					}

					function viewReport(patNo) {
						callPopUpWindow('incident_report2.jsp?command=view&patNo='+patNo);
						return false;
					}

					function submitSearch() {
						document.searchfrom.command.value = 'search';
						document.searchfrom.submit();
					}

					function clearSearch() {
						document.searchfrom.patNo.value="";
						document.searchfrom.patName.value="";
						document.searchfrom.patIDNo.value="";
						document.searchfrom.patTel.value="";
						document.searchfrom.completed.value="";
						document.searchfrom.command.value = 'clear';
						document.searchfrom.submit();
					}
					function createReport() {
						document.searchfrom.command.value = "";
						callPopUpWindow('incident_report.jsp');
						return false;
					}
					function createReport2() {
						document.searchfrom.command.value = "";
						callPopUpWindow('incident_report2.jsp');
						return false;
					}
					// Popup window code
					function newPopup(url) {
						//callPopUpWindow(url);
						popupWindow = window.open(url,'','height=1024,width=1280,left=0,top=0,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=yes,directories=no,status=yes')
					}

				</script>
			</DIV>
		</DIV>
	</DIV>
	<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>



				