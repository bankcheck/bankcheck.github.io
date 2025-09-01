<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>
<%
UserBean userBean = new UserBean(request);
String pirID = null;
String rptSts = null;
ReportableListObject rowRtn = null;
Boolean showViewButton = false;
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
<body style="width:100%">
	<DIV id=indexWrapper>
		<DIV id=mainFrame>
			<DIV id=contentFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.pi.report.list" />
					<jsp:param name="keepReferer" value="Y" />
					<jsp:param name="accessControl" value="Y"/>
				</jsp:include>
				<bean:define id="functionLabel"><bean:message key="function.pi.report.list" /></bean:define>
				<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
				<form method="post">
				<%
					pirID = PiReportDB.hasRedoReport(userBean.getStaffID());
					rptSts = PiReportDB.getRptSts(pirID);
					if ("piuser".equals(userBean.getLoginID())) { // temop user for DOH
						showViewButton = true;
					}
					else if (ConstantsServerSide.isHKAH()) {
						showViewButton = PiReportDB.IsDHead(userBean.getStaffID()) ||
									PiReportDB.IsAdminStaff(userBean.getStaffID()) ||
									PiReportDB.IsOshIcnSeniorStaff(userBean.getStaffID()) ||
									PiReportDB.IsPharmacySeniorStaff(userBean.getStaffID()) ||
									PiReportDB.IsPharmacyStaff(userBean.getStaffID()) ||
									PiReportDB.IsPIManager(userBean.getStaffID()) ||
									PiReportDB.IsIRSAdmin(userBean.getStaffID()) ||
									PiReportDB.IsSNO(userBean.getStaffID()) ||
									PiReportDB.IsDutyMgr(userBean.getStaffID()) ||
									userBean.isAccessible("function.irsview.all");
					}
					else if (ConstantsServerSide.isTWAH()) {
						showViewButton = true;

						if ("achsi".equals(userBean.getLoginID())) {
							showViewButton = false;
						}
					}
				%>
				</form>
			<%
			if (ConstantsServerSide.isHKAH()) {
			%>
				<table border=0>
				<tr>
					<td></td>
					<td>
						<b>For Front line staff</b>
					</td>
					<td></td>
					<td></td>
					<td>
						<%
						if (showViewButton) {
						%>
							<b>For UM/DM, Administration</b>
						<%
						}
						%>
					</td>
				</tr>
				<tr>
						<td> <img src="../images/pi/1.jpg" height="52" width="52"></img>
						</td>
						<td>
						 	Create 1 report for 1 incident &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br/>
							<button onclick="return submitAction('create', '');">Create Report</button>
							<span style="color:#F40A0A"><-- Click Here</span>
						</td>
						<td>
						<%
						if (!pirID.isEmpty() && "0".equals(rptSts)) {
						%>
							Edit the report by clicking here<br/>
							<button onclick="return submitAction('edit', '<%=pirID%>');">Edit Report</button>
							<span style="color:#F40A0A"><-- Click Here</span>
						<%
						}
						%>
						</td>
						<%
						//System.out.println("pirID, rptSts : " + pirID + ", " + rptSts);
						//if (userBean.isManager() || PiReportDB.IsAdminStaff(userBean.getStaffID()) ||
						if (showViewButton) {
						%>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							Enter the list view<br/>
							<button onclick="return submitAction('list', '');">View Report</button>
							<span style="color:#F40A0A"><-- Click Here</span>
						</td>
						<%
						}
						%>
					</tr>
					<tr></tr>
					<tr></tr>
					<tr></tr>
					<tr>
					<td><img src="../images/pi/2.jpg" height="52" width="52"></img></td>
					<%
					if (ConstantsServerSide.isHKAH()) {
					%>
						<td colspan="2" style="color:#FF0000">
					<%} else {%>
						<td colspan="2">
					<%} %>
					<%
					if (ConstantsServerSide.isHKAH()) {
					%>
						<span style="color:#F40A0A">
					<%} else {%>
						<span >
					<%} %>
						For patient incidents (only with patient injury and medications error causing harm to patient) and all injury incidents,<br/>
					</span>
					1. Print
					<%
					if (ConstantsServerSide.isHKAH()) {
					%>
						<%--
						<a href="file://www-server/pi/IRForm131223.doc" target="_blank">Post Incident Doctor Examination Form</a>
						--%>
						<a class="topstoryblue" onclick=" downloadFile('614', ''); return false;" href="javascript:void(0);" target="_blank">Post Incident Doctor Examination Form</a>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<%--
						<a href="file://www-server/pi/AdditionalInformation.doc" target="_blank">Additional Information Form</a>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						 --%>
						<%--
						<button onclick="">Print Post Exam-Form</button>
					 	--%>
					<%
					}
					else if (ConstantsServerSide.isTWAH()) {
					%>
						<%--
						<a href="file://192.168.0.20/pi/IRForm131223.doc" target="_blank">Post Incident Doctor Examination Form</a>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						--%>
						<a class="topstoryblue" onclick=" downloadFile('481', ''); return false;" href="javascript:void(0);" target="_blank">
							<u>Post Incident Doctor Examination Form</u>
						</a>
						<span style="color:F40A0A"><-- Click Here</span>
						<%--
						<a href="file://192.168.0.20/pi/AdditionalInformation.doc" target="_blank">Additional Information Form</a>
						--%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<%
					}
					%>
					<br/>
					2. Doctor to complete the form
					<br/>
					3. Send the completed form to Performance Improvement Department
					</td>
					</tr>
				</table>
				<%--
				end here
				 --%>
		<%
			} else {
		%>
				<table border=0>
				<tr>
					<td></td>
					<td></td>
					<td>
						<b>For Front line staff</b>
					</td>
					<td></td>
					<tr></tr>
					<tr></tr>
					<td>
						<%
						if (showViewButton) {
							if (ConstantsServerSide.isHKAH()) {
						%>
							<b>For UM/DM, Administration</b>
						<%
							}
						}
						%>
					</td>

					<td><img src="../images/pi/1.jpg" height="52" width="52"></img></td>
					<td colspan="2">
					<span >
						For all patient incidents (except security) and all injury incidents, <br/>
					</span>
					1. Print
						<a class="topstoryblue" style="color:red" onclick=" downloadFile('481', ''); return false;" href="javascript:void(0);" target="_blank">
							<u>Post Incident Doctor Examination Form</u>
						</a>
						<span style="color:#F40A0A"><-- Click Here</span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<br/>
					2. Doctor to complete the form TW
					<br/>
					3. Send the completed form to Performance Improvement Department
					</td>
					</td>
				</tr>

				<tr></tr>
				<tr></tr>
				<tr></tr>
				<tr>
				<td></td>
						<td> <img src="../images/pi/2.jpg" height="52" width="52"></img>
						</td>
						<td>
						 	Create 1 report for 1 incident &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br/>
							<button onclick="return submitAction('create', '');">Create Report</button>
							<span style="color:#F40A0A"><-- Click Here</span>
						</td>
						<td>
						<%
						if (!pirID.isEmpty() && "0".equals(rptSts)) {
						%>
							Edit the report by clicking here<br/>
							<button onclick="return submitAction('edit', '<%=pirID%>');">Edit Report</button>
							<span style="color:#F40A0A"><-- Click Here</span>
						<%
						}
						%>
						</td>
						<%
						//System.out.println("pirID, rptSts : " + pirID + ", " + rptSts);
						//if (userBean.isManager() || PiReportDB.IsAdminStaff(userBean.getStaffID()) ||
						if (showViewButton) {
						%>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							Enter the list view<br/>
							<button onclick="return submitAction('list', '');">View Report</button>
							<span style="color:#F40A0A"><-- Click Here</span>
						</td>
						<%
						}
						%>
					</tr>
				</table>

<%
}
%>

					<br/>
					<br/>
					<br/>
					<%
					if (ConstantsServerSide.isHKAH()) {
					%>
						To Learn how to write an incident report
					 	<br/>
					 	<%--
					 	<a  href="file://www-server/pi/elearning.ppt"><img src="../images/pi/4.jpg" height="60" width="170" target="_blank"></img></a>
					 	--%>
					 	<a class="topstoryblue" onclick=" downloadFile('615', ''); return false;" href="javascript:void(0);" target="_blank">
							<img src="../images/pi/4.jpg" height="60" width="170" target="_blank"></img>
						</a>
					 	<span style="color:F40A0A"><-- Click Here</span>
					<%
					} else if (ConstantsServerSide.isTWAH()) {
					%>
						<%--
						To Learn how to write an incident report
					 	<br/><a  href="file://192.168.0.20/pi/elearning.ppt"><img src="../images/pi/4.jpg" height="60" width="170" target="_blank"></img></a>
						--%>
					 	To Learn how to write an incident report<br/>
						<a class="topstoryblue" onclick=" downloadFile('482', ''); return false;" href="javascript:void(0);" target="_blank">
							<img src="../images/pi/4.jpg" height="60" width="170" target="_blank"></img>
						</a>
						<span style="color:F40A0A"><-- Click Here</span>
					<%
					}
					%>

				<script language="javascript">
					keepAlive(60000);
				</script>
			</DIV>
		</DIV>
	</DIV>
	<jsp:include page="../common/footer.jsp" flush="false" />
</body>


<script language="javascript">
	function submitAction(cmd, pirid) {
		if(cmd == 'create'){
			callPopUpWindow('incident_report2.jsp');
		}
		else if (cmd == 'list'){
		 	window.open("../pi/reportlist.jsp", "content");
		}
		else if (cmd == 'edit'){
			window.open("../pi/incident_report2.jsp?command=edit&pirID=" + pirid, "content");
		}
	}

</script>

</html:html>				