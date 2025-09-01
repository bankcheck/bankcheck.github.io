<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%
String incidentType = request.getParameter("incidentType");
String incidentTypePI = request.getParameter("incidentTypePI");
String action = request.getParameter("action");
boolean viewAction = "view".equals(action);
boolean editAction = "edit".equals(action);
boolean CreateAction = (!viewAction && !editAction);
String pirID = request.getParameter("pirID");
ReportableListObject rowRtn = null;
String rptSts = null;
UserBean userBean = new UserBean(request);
boolean IsPharmacy = false;
String pxdeptHead = null;
String pxdutyMgr = null;
String pxNurse = null;

ArrayList incidentTypeRec = PiReportDB.fetchIncidentType(incidentType);
ArrayList incidentTypeRecPI = PiReportDB.fetchIncidentType(incidentTypePI);
ReportableListObject row = null;
ReportableListObject rowPI = null;
IsPharmacy = PiReportDB.IsPharmacyStaff(userBean.getStaffID());

// check can edit the report
if (pirID != null) {
	ArrayList recordRtn = PiReportDB.fetchReportBasicInfo(pirID);
	if (recordRtn.size() > 0) {
		rowRtn = (ReportableListObject) recordRtn.get(0);
		rptSts = rowRtn.getValue(9);
		pxdeptHead = rowRtn.getValue(23);
		pxdutyMgr = rowRtn.getValue(24);
		pxNurse = rowRtn.getValue(25);
	}
}

if (incidentTypeRec.size() > 0) {
	row = (ReportableListObject) incidentTypeRec.get(0);
	if (incidentTypeRecPI.size() > 0) {
		rowPI = (ReportableListObject) incidentTypeRecPI.get(0);
	} else {
		rowPI = row;
	}
%>
	<div id="report" style="height:610px;background-color:">
		<table border="0" style="width:100%">
			<tr>
				<td>
					<div align="left">
						<label style="font-size:22px; font-weight:bold;">
							<%=rowPI.getValue(0) %>
						</label>
					</div>
				</td>
				<td>
					<div class="confidential" style="">
						<p style="font-size:14px">
							<b><i><u>* CONFIDENTIAL</u></i></b>
						</p>
						<p style="font-size:14px">
							<b><i><u>* Not part of Patient's Medical Record</u></i></b>
						</p>
					</div>
				</td>
			</tr>
		</table>
<%

	String moduleCode = row.getValue(1);
	String displayGeneral = row.getValue(2);

	String generalModuleCode = null;
	ArrayList generalModuleRecord = PiReportDB.getGeneralModuleCode(displayGeneral);
	if (generalModuleRecord.size()>0){
		ReportableListObject generalModuleCodeRow = (ReportableListObject)generalModuleRecord.get(0);
		generalModuleCode = generalModuleCodeRow.getValue(0);
	}

	ArrayList category = PiReportDB.fetchReportHeading2(moduleCode, pirID, editAction,displayGeneral);

	if (category.size() > 0) {

		%>
			<div id="menu" style="width:24%; height:560px; background-color:white; float:left;">
				<div class='menu-pane scroll-pane jspScrollable' style='overflow: hidden; padding: 0px; height:100%;'>
		<%
		for(int i = 0; i < category.size(); i++) {
			row = (ReportableListObject) category.get(i);

			if (pirID != null) {
				if (row.getValue(1).equals("group")) {
				%>
					<jsp:include page="../pi/report_grpCatergory2.jsp" flush="false">
						<jsp:param name="group" value="Y" />
						<jsp:param name="grpID" value="<%=row.getValue(0)%>" />
						<jsp:param name="grpDesc" value="<%=row.getValue(2)%>" />
						<jsp:param name="moduleCode" value="<%=row.getValue(4)%>" />
						<jsp:param name="action" value="<%=action%>" />
						<jsp:param name="pirID" value="<%=pirID %>" />
						<jsp:param name="generalModuleCode" value="<%=generalModuleCode%>" />
					</jsp:include>
				<%
				}
				else {
				%>
					<jsp:include page="../pi/report_grpCatergory2.jsp" flush="false">
						<jsp:param name="group" value="N" />
						<jsp:param name="title" value="<%=row.getValue(2)%>" />
						<jsp:param name="categoryID" value="<%=row.getValue(0)%>" />
						<jsp:param name="category" value="<%=row.getValue(3)%>" />
						<jsp:param name="action" value="<%=action%>" />
						<jsp:param name="pirID" value="<%=pirID %>" />
					</jsp:include>
				<%
				}
			} else {
				if (row.getValue(1).equals("group")) {
				%>
					<jsp:include page="../pi/report_grpCatergory2.jsp" flush="false">
						<jsp:param name="group" value="Y" />
						<jsp:param name="grpID" value="<%=row.getValue(0)%>" />
						<jsp:param name="grpDesc" value="<%=row.getValue(2)%>" />
						<jsp:param name="moduleCode" value="<%=row.getValue(4)%>" />
						<jsp:param name="action" value="<%=action%>" />
						<jsp:param name="generalModuleCode" value="<%=generalModuleCode%>" />
					</jsp:include>
				<%
				}
				else {
				%>
					<jsp:include page="../pi/report_grpCatergory2.jsp" flush="false">
						<jsp:param name="group" value="N" />
						<jsp:param name="title" value="<%=row.getValue(2)%>" />
						<jsp:param name="categoryID" value="<%=row.getValue(0)%>" />
						<jsp:param name="category" value="<%=row.getValue(3)%>" />
						<jsp:param name="action" value="<%=action%>" />
					</jsp:include>
				<%
				}
			}
		}

		if (ConstantsServerSide.isTWAH()) {
		%>
			<br><br><div align="center">
			<%
			if (viewAction) {
			%>
				<%
				if (PiReportDB.IsCanEditPerson(pirID, userBean.getLoginID(), rptSts)) {
				%>
					<button class="reportSubmit" submitType="edit">Edit</button>
				<%
				}
				%>
				<%
			}
			else if (editAction) {
				%>
				<%
				if ("1040".equals(incidentType) && "12".equals(rptSts) && IsPharmacy)  { //20230327 Arran added for new ADR incident
				%>
					<button class="reportSubmit" submitType="update_saveonly">Update ADR Incident</button>
				<%
				} else {
				%>
					<button class="reportSubmit" submitType="update_saveonly">Save Only<br>(without submit)</button>
					<%
					if (!viewAction && IsPharmacy && ("52".equals(incidentType) || "62".equals(incidentType))) {  // medication or ADR incident
					%>
						<button class="reportSubmit" submitType="update">Update Pharmacy Incident</button>
					<%
					} else {
					%>
						<button class="reportSubmit" submitType="update">Save and submit</button>
					<%
					}
					%>
				<%
				}
				%>
			<%
			}
			else {
			%>
				<button class="reportSubmit" submitType="create_saveonly">Save Only<br>(without submit)</button>
				<%
				if (!viewAction && IsPharmacy && ("52".equals(incidentType) || "62".equals(incidentType))) {  // medication or ADR incident
				%>
					<button class="reportSubmit" submitType="create">Submit Pharmacy Incident</button>
				<%
				} else {
				%>
					<button class="reportSubmit" submitType="create">Save and Submit</button>
				<%
				}
				%>
			<%
			}
			%>
			<br><br>
			<%
			if (!viewAction && IsPharmacy && "52".equals(incidentType)) {  // medication
			%>
				<%
				if (editAction) {
				%>
					<button class="reportSubmit" submitType="update_px2">Update Ward / Satellite Incident</button>
				<%
				} else {
				%>
					<button class="reportSubmit" submitType="create_px2">Submit Ward / Satellite Incident</button>
				<%
				}
				%>
			<%
			}
			%>

			</div>
		<%
		}
		%>
		 </div>
		</div>
		<div id="content" style="width:75%; height:560px; background-color:white; float:right;">
			<div class='content-pane scroll-pane jspScrollable' style='overflow: hidden; padding: 0px; height:100%;'>
			</div>
		</div>
		<div id="content-container" style="display:none"></div>
<%
	}
%>
	</div>
	<input type="hidden" name="<%=incidentType%>_value" value=""/>
	<div align="center">
<%
	if (ConstantsServerSide.isHKAH()) {
%>
	<%
		if (viewAction) {
	%>
		<%
			if (PiReportDB.IsCanEditPerson(pirID, userBean.getLoginID(), rptSts)) {
		%>
				<button class="reportSubmit" submitType="edit">Edit</button>
		<%
			}
		%>
	<%
		}
		else if (editAction) {
	%>

		<%
			if ("1040".equals(incidentType) && "12".equals(rptSts) && IsPharmacy)  { //20230327 Arran added for new ADR incident			
		%>
				<button class="reportSubmit" submitType="update_saveonly">Update ADR Incident</button>
		<%
			} 
			else if (!viewAction && IsPharmacy && ("52".equals(incidentType) || "62".equals(incidentType))) {  // medication or ADR incident
		%>
				<button class="reportSubmit" submitType="update">Update to Senior Pharmacist</button>
		<%
			}
			else {
		%>
				<button class="reportSubmit" submitType="update">Update</button>
		<%
			}
		%>
	<%
		}
		else {
	%>
		<%
			if (!viewAction && IsPharmacy && ("52".equals(incidentType) || "62".equals(incidentType))) {  // medication or ADR incident
		%>
				<button class="reportSubmit" submitType="create">Submit to Senior Pharmacist</button>
		<%
			}
			else {
		%>
				<button class="reportSubmit" submitType="create">Submit</button>
		<%
			}
		%>
	<%
		}
	%>

	<%
	if (!viewAction && IsPharmacy && ("52".equals(incidentType) || "62".equals(incidentType))) {  // medication or ADR incident
	%>

	<%
		if (editAction) {
	%>
			<button class="reportSubmit" submitType="update_px2">Update to the relevant Unit Manager</button>
	<%
		} else {
	%>
			<button class="reportSubmit" submitType="create_px2">Submit to the relevant Unit Manager</button>
	<%
		}
	%>
<%
	}
%>
	</div>
<%
	}
%>
<%
//if (viewAction) {
%>
	<input type="hidden" name="pxdeptHead" value="<%=pxdeptHead%>"/>
	<input type="hidden" name="pxdutyMgr" value="<%=pxdutyMgr%>"/>
	<input type="hidden" name="pxNurse" value="<%=pxNurse%>"/>
<%
//}
%>
<%
	}
%>