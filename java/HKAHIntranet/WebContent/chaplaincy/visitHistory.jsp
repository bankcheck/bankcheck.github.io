<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c'%>
<%!
public void removeDateTime(Calendar date) {
	date.set(Calendar.HOUR_OF_DAY, 0);
	date.set(Calendar.MINUTE, 0);
	date.set(Calendar.SECOND, 0);
	date.set(Calendar.MILLISECOND, 0);
}

public String getCategoryInfo(String patNo, String servCategory,String servItem, String regType)
{
	StringBuffer sqlStr = new StringBuffer();
	ArrayList record;
	if (servCategory.equals("Chronological History")) {
		record = PatientDB.getChaplaincyServiceList(patNo, null, null, null, regType);
	}
	else {
		record = PatientDB.getChaplaincyServiceList(patNo, servCategory, servItem, null, regType);
	}

	if (record.size() != 0) {
		ReportableListObject row = null;
		for (int i =0;i< record.size();i++) {
			row = (ReportableListObject)record.get(i);

			sqlStr.append("<tr >");
			sqlStr.append("<td  width='60px' style='text-align:right;'>");
			sqlStr.append("Date: ");
			sqlStr.append("</td>");
			sqlStr.append("<td width='150px'>");
			sqlStr.append(row.getValue(15));
			sqlStr.append("</td>");
			sqlStr.append("<td style='text-align:right;' width='120px'>");
			sqlStr.append("Modified User: ");
			sqlStr.append("</td>");
			sqlStr.append("<td >");
			sqlStr.append(row.getValue(21));
			sqlStr.append("</td>");
			sqlStr.append("<td  title='Edit remark' width='18px'>");
			sqlStr.append("<img width='24px' src='../images/edit1.png' onclick='editRemark(");
			sqlStr.append(row.getValue(1));
			sqlStr.append(")'/>");
			sqlStr.append("   ");
			sqlStr.append("</td>");
			sqlStr.append("<td title='Delete remark' width='16px'>");
			sqlStr.append("<img  width='24px' src='../images/delete5.png' onclick='deleteRemark(");
			sqlStr.append(row.getValue(1));
			sqlStr.append(")'/>");
			sqlStr.append("</td>");
			sqlStr.append("</tr>");
			sqlStr.append("<tr>");
			sqlStr.append("<td style='text-align:right;' valign='top'>");
			sqlStr.append("Remark:");
			sqlStr.append("</td>");
			sqlStr.append("<td colspan='3'>");
			sqlStr.append(row.getValue(14));
			sqlStr.append("</td>");
			sqlStr.append("</tr>");

			if (record.size() -1 != i) {
				sqlStr.append("<tr>");
				sqlStr.append("<td colspan='10'>");
				sqlStr.append("<hr/>");
				sqlStr.append("</td>");
				sqlStr.append("</tr>");
			}
		}
	}
	return sqlStr.toString();
}
%>
<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../index.jsp", "_self");
	</script>
	<%
	return;
}

String action = request.getParameter("action");

if ("view".equals(action)) {
	boolean getList = "Y".equals(request.getParameter("getList"));
	boolean setRecord = "Y".equals(request.getParameter("setRecord"));
	boolean editRecord = "Y".equals(request.getParameter("editRecord"));
	if (getList) {
		String patNo = request.getParameter("patNo");
		String regType = request.getParameter("regType");
		int height = 450;
%>
		<tbody>
<%
		String[] categoryString = new String[6];
		categoryString[0] = "Bible Study";
		categoryString[1] = "Contact";
		categoryString[2] = "Contact (Indirect)";
		categoryString[3] = "Counseling";
		categoryString[4] = "Decision for Christ";
		categoryString[5] = "Off Site Visitation";

//		for (String servCategory:categoryString) {
		for (int i = 0; i < 6; i++) {
%>
			<tr bgcolor="#FFD067" style='width:100%;height:30px;'>
				<td colspan="2" style='width:180px;'>
					<%= categoryString[i] %>
				</td>
			</tr>
			<tr style='width:100%;height:30px;'>
				<td style='width:180px; vertical-align:top;'>
					<button id='<%=categoryString[i]%>_Patient' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
<%			if (ConstantsServerSide.isTWAH() && i == 1) { %>
							style='width:180px;text-align:left; height:30px; font-size:14px;'>
						- Attended within 24 hrs
<%			} else { %>
							style='width:180px;text-align:left; height:30px; font-size:15px;'>
						- Patient
<%			} %>

					</button>
				</td>
				<td>
					<table width='100%'>
						<%=getCategoryInfo(patNo, categoryString[i], "Patient", regType) %>
					</table>
				</td>
			</tr>
<%			if (ConstantsServerSide.isTWAH() && i == 1) { %>
			<tr style='width:100%;height:30px;'>
				<td style="vertical-align:top;">
					<button id='<%=categoryString[i + 1]%>_Patient Family' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:180px;text-align:left; height:30px; font-size:15px;'>
						- Following Visit
					</button>
				</td>
				<td>
				<table width='100%'>
					<%=getCategoryInfo(patNo, categoryString[i + 1], "Patient Family", regType) %>
				</table>
				</td>
			</tr>
<%			} %>
			<tr>
				<td colspan="2">
					<hr/>
				</td>
			</tr>
<%			if (ConstantsServerSide.isTWAH() && i != 2) { %>
			<tr style='width:100%;height:30px;'>
				<td style="vertical-align:top;">
					<button id='<%=categoryString[i]%>_Patient Family' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:180px;text-align:left; height:30px; font-size:15px;'>
						- Patient Family
					</button>
				</td>
				<td>
				<table width='100%'>
					<%=getCategoryInfo(patNo, categoryString[i], "Patient Family", regType) %>
				</table>
				</td>
			</tr>
<%			} %>
<%
		}
%>
			<tr bgcolor="#FFD067" style='width:100%;height:30px;'>
				<td colspan="2" style='width:180px;'>
				Other
				</td>

			</tr>
			<tr style='width:100%;height:30px;'>
				<td style='width:180px; vertical-align:top;'>
					<button id='Other_Ceremony' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:180px;text-align:left; height:30px; font-size:15px;'>
						- Ceremony
					</button>
				</td>
				<td>
					<table width="100%">
						<%=getCategoryInfo(patNo, "Other", "Ceremony", regType) %>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<hr/>
				</td>
			</tr>
			<tr style='width:100%;height:30px;'>
				<td style="vertical-align:top;">
					<button id='Other_Devotions' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:180px;text-align:left; height:30px; font-size:15px;'>
						- Devotions
					</button>
				</td>
				<td>
				<table  width="100%">
					<%=getCategoryInfo(patNo, "Other" ,"Devotions", regType) %>
				</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<hr/>
				</td>
			</tr>
			<tr style='width:100%;height:30px;'>
				<td style="vertical-align:top;">
					<button id='Other_Referral' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:180px;text-align:left; height:30px; font-size:15px;'>
						- Referral
					</button>
				</td>
				<td>
				<table  width="100%">
					<%=getCategoryInfo(patNo, "Other", "Referral", regType) %>
				</table>
				</td>
			</tr>

			<tr bgcolor="#FFD067" style='width:100%;height:30px;'>
				<td colspan="2" style='width:180px;'>
					Chronological History
				</td>
			</tr>
			<tr style='width:100%;height:30px;'>
				<td style='width:180px; vertical-align:top;'>
					<button id='Chronological_History_Show' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:180px;text-align:left; height:30px; font-size:15px;'>
						- Show
					</button>
					<button id='Chronological_History_Hide' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='display:none;width:180px;text-align:left; height:30px; font-size:15px;'>
						- Hide
					</button>
				</td>
				<td>
				<div id='chronologicalRow'style="display:none;">
				<table width="100%">
					<%=getCategoryInfo(patNo, "Chronological History", "Show", regType) %>
				</table>
				</div>
				</td>
			</tr>
			<tr>
		</tbody>
<%
	} else if (setRecord) {
		String button_id = request.getParameter("buttonID");
		String[] category = button_id.split("_");
		String servCategory = category[0];
		String servItem = category[1];

		if ("Patient".equals(servItem)) {
			servItem = "Patient";
		} else if ("pf".equals(servItem)) {
			servItem = "Patient Family";
		} else if ("Ceremony".equals(servItem)) {
			servItem = "Ceremony";
		} else if ("Devotions".equals(servItem)) {
			servItem = "Devotions";
		} else if ("Referral".equals(servItem)) {
			servItem = "Referral";
		}

		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		SimpleDateFormat stf = new SimpleDateFormat("HH:mm", Locale.ENGLISH);
		String date = sdf.format(cal.getTime()).toString() + " " + stf.format(cal.getTime()).toString();
%>
		<tbody>
			<tr>
				<td>
					<span style='font-size:16px;'>Date: </span>
						<jsp:include page="../ui/dateCMB.jsp" flush="false">
							<jsp:param name="label" value="recordDate" />
							<jsp:param name="yearRange" value="10" />
							<jsp:param name="date" value="<%=date %>" />
							<jsp:param name="showTime" value="Y" />
							<jsp:param name="defaultValue" value="N" />
							<jsp:param name="isDetailedTime" value="Y"/>
						</jsp:include>
				</td>
			</tr>
			<tr>
				<td>
					<span style='font-size:16px;'>User ID: <%=userBean.getUserName() %></span>
				</td>
			</tr>

			<tr>

				<td id='servCategory' style='display:none;'>
					<%=servCategory.trim() %>
				</td>
				<td id='servItem' style='display:none;'>
					<%=servItem.trim() %>
				</td>
				<td>
					<span style='font-size:16px;'>Category: <%=servCategory %> - <%=servItem %></span>
				</td>
			</tr>
			<tr>
				<td style="vertical-align:top;">
					<textarea id="recordEntry"style='resize:none;height:230px;width:440px;'></textarea>
				</td>
			</tr>
			<tr>
				<td style="vertical-align:bottom;">
					<button class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
							style='width:100px; height:30px; font-size:15px;float:right'
							onclick="saveRecord('save')">
							Save
					</button>
				</td>
			</tr>
		</tbody>
<%
	} else if (editRecord) {
		String psID = request.getParameter("psID");
		ArrayList record = PatientDB.getPatientServiceByID(psID) ;
		if (record.size() != 0) {
			ReportableListObject row = (ReportableListObject)record.get(0);
			String arrayDate[] = row.getValue(15).split(" ");

			String date = arrayDate[0] + " " + arrayDate[1];
%>
	<tbody>
		<tr>
			<span style='display:none;font-size:16px;'>Last Modified Date: <%=row.getValue(18)%></span>
			<td>
				<span style='font-size:16px;'>Date: </span>
				<jsp:include page="../ui/dateCMB.jsp" flush="false">
					<jsp:param name="label" value="editDate" />
					<jsp:param name="yearRange" value="10" />
					<jsp:param name="date" value="<%=date %>" />
					<jsp:param name="defaultValue" value="N" />
					<jsp:param name="showTime" value="Y" />
					<jsp:param name="isDetailedTime" value="Y"/>
				</jsp:include>
			</td>
		</tr>

		<tr>
			<td>
				<span style='font-size:16px;'>Last Modified User: <%=row.getValue(20) %></span>
			</td>
		</tr>
		<tr>
			<td id='servCategory' style='display:none;'>
				<%=row.getValue(11)%>
			</td>
			<td id='servItem' style='display:none;'>
				<%=row.getValue(12)%>
			</td>
			<td>
			<span style='font-size:16px;'>Category: <%=row.getValue(11)%> - <%=row.getValue(12)%></span>
			</td>
		</tr>
		<tr>
			<td style="vertical-align:top;">

				<textarea id="recordEntry"style='resize:none;height:230px;width:440px;'><%=row.getValue(14)%></textarea>
			</td>
		</tr>
		<tr>
			<td style="vertical-align:bottom;">
				<button class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				style='width:100px; height:30px; font-size:15px;float:right' onclick="saveRecord('edit','<%=psID%>')">
				Save
				</button>
			</td>
		</tr>
	</tbody>
<%
		}
	}
} else if ("insert".equals(action)) {
	String patNo = request.getParameter("patNo");
	String name = request.getParameter("name");
	String regID = request.getParameter("regID");
	String regType = request.getParameter("regType");
	String ward=request.getParameter("ward");
	String room=request.getParameter("room");
	String bed=request.getParameter("bed");
	String allergy= request.getParameter("allergy");
	String status= request.getParameter("status");

	String remark= TextUtil.parseStrUTF8(
					java.net.URLDecoder.decode(
							request.getParameter("remark").replaceAll("%", "%25")));

	String servCategory = request.getParameter("servCategory");
	String servItem = request.getParameter("servItem");

	String recordDate = request.getParameter("recordDate");
	String recordTime = request.getParameter("recordTime");

	boolean insertSuccess = PatientDB.addChaplaincyService(userBean,patNo.trim(),name,regID,regType,ward,room,bed,allergy,status,remark,servCategory.trim(),servItem.trim(),recordDate,recordTime);
	%><%=insertSuccess %><%

	if (insertSuccess) {

		ArrayList patientReferralRecord = PatientDB.checkPatientChapReferralWithChapID(patNo,userBean.getStaffID());
		if (patientReferralRecord.size() != 0 ) {
			PatientDB.editPatientReferral(userBean, patNo, "", "","");
			%>removedreferral<%
		}
	}

	ArrayList record =  PatientDB.checkPatientVisitStatusExists(patNo.trim(), "a");

	if (record.size() != 0) {
		ReportableListObject row = (ReportableListObject)record.get(0);
		ArrayList loggingAfterPatientStatusRecord =  PatientDB.checkLoggingAfterPatientStatus(row.getValue(0),row.getValue(4));
		if (loggingAfterPatientStatusRecord.size() != 0) {
			PatientDB.editPatientVisitStatus(userBean, patNo, "n", "chaplaincy");
			%>neededupdate<%
		}
	}

	ArrayList patientOTHasLog =  PatientDB.getPatientOTHaveLog(patNo.trim());
	if (patientOTHasLog.size() > 0) {
		%>patientothaslog<%
	}

} else if ("edit".equals(action)) {
	String psID = request.getParameter("psID");
	String remark = TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("remark").replaceAll("%", "%25")));
	String editDate = request.getParameter("editDate");
	String editTime = request.getParameter("editTime");
	String patNo = request.getParameter("patNo");

	String date = editDate + " " + editTime;
	%><%=PatientDB.updateChaplaincyServiceList(psID, remark, userBean, date) %><%

	ArrayList patientOTHasLog =  PatientDB.getPatientOTHaveLog(patNo.trim());
	if (patientOTHasLog.size() > 0) {
		%>patientothaslog<%
	}
} else if ("delete".equals(action)) {
	String psID = request.getParameter("psID");
	String patNo = request.getParameter("patNo");
	%><%=PatientDB.deletePatientService(userBean, psID, null, null, null, null) %><%

} else if ("checkContact".equals(action)) {

	String dischargedPatient = request.getParameter("dischargedDate");
	if ("".equals(dischargedPatient)) {
		String patNo = request.getParameter("patNo");
		String regID = request.getParameter("regID");
		String admissionDate = request.getParameter("admissionDate");

		ArrayList recordCount= PatientDB.getChaplaincyServiceList(patNo, null, null, regID);

		String[] aDate = admissionDate.split(" ");
		String[] date = aDate[0].split("/");
		String day = date[0];
		String month = date[1];
		String year = date[2];

		String[] time = aDate[1].split(":");
		String hour = time[0];
		String minute = time[1];

		Calendar adDate = Calendar.getInstance();
		Calendar currentDate = Calendar.getInstance();
		adDate.set( Integer.parseInt(year),  Integer.parseInt(month)-1,  Integer.parseInt(day),
				 Integer.parseInt(hour),  Integer.parseInt(minute)) ;
		adDate.add(Calendar.DATE,1);

		if (currentDate.after(adDate) && recordCount.size() == 0) {
			%>notContactedAfterOneDay<%
		} else {

			ArrayList record = PatientDB.getPatientServiceByPatNo(patNo , "I") ;
			if (record.size() != 0) {

				boolean contactedCurrentAdmission = false;
				boolean contactedIndirectly = false;
				boolean contactedPreviousAdmission = false;
				boolean contactedPreviousIndirectly = false;
				ReportableListObject row = null;

				String dbRegID = null;
				String dbServCategory = null;
				String dbServItem = null;

				for (int i = 0;i< record.size();i++) {
					row = (ReportableListObject)record.get(i);

					dbRegID = row.getValue(4);
					dbServCategory = row.getValue(11);
					dbServItem = row.getValue(12);

					if (regID.equals(dbRegID) && ((!"Contact (Indirect)".equals(dbServCategory) && "Patient".equals(dbServItem)) || "Other".equals(dbServCategory))) {
						contactedCurrentAdmission = true;
					}
					else if (regID.equals(dbRegID) && ConstantsServerSide.isTWAH() && "Contact (Indirect)".equals(dbServCategory) && "Patient Family".equals(dbServItem)) {
						contactedCurrentAdmission = true;
					}
					else if (regID.equals(dbRegID) && ("Contact (Indirect)".equals(dbServCategory) || "Patient Family".equals(dbServItem))) {
						contactedIndirectly = true;
					}
					else if (!regID.equals(dbRegID) && ("Patient".equals(dbServItem) || "Other".equals(dbServCategory))) {
						contactedPreviousAdmission = true;
					}
					else if (!regID.equals(dbRegID) && ("Contact (Indirect)".equals(dbServCategory) || "Patient Family".equals(dbServItem))) {
						contactedPreviousIndirectly = true;
					}

				}
				if (contactedCurrentAdmission) {
					%>contactedCurrentAdmission<%
				} else if (contactedIndirectly) {
					%>contactedIndirectly<%
				} else if (contactedPreviousAdmission) {
					%>contactedPreviousAdmission<%
				} else if (contactedPreviousIndirectly) {
					%>contactedPreviousIndirectly<%
				}
			}
		}
		ArrayList patientOTRecord = PatientDB.getPatientOTRecord(patNo,"1");
		if (patientOTRecord.size() != 0) {
			%>procedureScheduled<%
		}
	} else {
		String patNo = request.getParameter("patNo");
		ArrayList record = PatientDB.getPatientServiceByPatNo(patNo , "I") ;
		if (record.size() != 0) {

			ReportableListObject row = null;
			boolean contactedPreviousAdmission = false;
			boolean contactedPreviousIndirectly = false;
			String dbRegID = null;
			String dbServCategory = null;
			String dbServItem = null;

			for (int i =0;i< record.size();i++) {
				row = (ReportableListObject)record.get(i);

				dbRegID = row.getValue(4);
				dbServCategory = row.getValue(11);
				dbServItem = row.getValue(12);

				if ("Patient".equals(dbServItem) || "Other".equals(dbServCategory)) {
					contactedPreviousAdmission = true;
				}
				else if (("Contact (Indirect)".equals(dbServCategory) || "Patient Family".equals(dbServItem))) {
					if (ConstantsServerSide.isTWAH()) {
						contactedPreviousAdmission = true;
					} else {
						contactedPreviousIndirectly = true;
					}
				}

			}
			if (contactedPreviousAdmission) {
				%>contactedPreviousAdmission<%
			} else if (contactedPreviousIndirectly) {
				%>contactedPreviousIndirectly<%
			}
		}
	}
} else if ("checkContactOutPatient".equals(action)) {
	String patNo = request.getParameter("patNo");
	String regID = request.getParameter("regID");

	ArrayList record = PatientDB.getPatientServiceByPatNo(patNo , "O") ;
	if (record.size() != 0) {
		boolean contactedCurrentAdmission = false;
		boolean contactedIndirectly = false;
		boolean contactedPreviousAdmission = false;
		boolean contactedPreviousIndirectly = false;
		ReportableListObject row = null;
		String dbRegID = null;
		String dbServCategory = null;
		String dbServItem = null;

		for (int i = 0; i < record.size();i++) {
			row = (ReportableListObject)record.get(i);

			dbRegID = row.getValue(4);
			dbServCategory = row.getValue(11);
			dbServItem = row.getValue(12);

			if (regID.equals(dbRegID) && ((!"Contact (Indirect)".equals(dbServCategory) && "Patient".equals(dbServItem)) || "Other".equals(dbServCategory))) {
				contactedCurrentAdmission = true;
			} else if (regID.equals(dbRegID) && ("Contact (Indirect)".equals(dbServCategory) || "Patient Family".equals(dbServItem))) {
				contactedIndirectly = true;
			} else if (!regID.equals(dbRegID) && ("Patient".equals(dbServItem) || "Other".equals(dbServCategory))) {
				contactedPreviousAdmission = true;
			} else if (!regID.equals(dbRegID) && ("Contact (Indirect)".equals(dbServCategory) || "Patient Family".equals(dbServItem))) {
				contactedPreviousIndirectly = true;
			}
		}
		if (contactedCurrentAdmission) {
			%>contactedCurrentAdmission<%
		} else if (contactedIndirectly) {
			%>contactedIndirectly<%
		} else if (contactedPreviousAdmission) {
			%>contactedPreviousAdmission<%
		} else if (contactedPreviousIndirectly) {
			%>contactedPreviousIndirectly<%
		}
	}
}
%>
