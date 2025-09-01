<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.struts.Globals" %>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
String[] current_year = DateTimeUtil.getCurrentYearRange();
String date_from = request.getParameter("date_from");
if (date_from == null || date_from.length() == 0) {
	date_from = DateTimeUtil.getRollDate(current_year[0], 0, 0, 0);
}
String date_to = request.getParameter("date_to");
if (date_to == null || date_to.length() == 0) {
	date_to = current_year[1];
}
String[] current_month = DateTimeUtil.getCurrentMonthRange();
String curent_date = DateTimeUtil.getCurrentDate();

String elearningID = "17"/*request.getParameter("elearningID")*/;
String eventID = null;
String topic = null;
String questionNumPerTest = null;
String passGrade = null;
String deptCode = request.getParameter("deptCode");

String message = "";
String errorMessage = "";
Locale locale = (Locale) session.getAttribute(Globals.LOCALE_KEY);
try {
	// load data from database
	if (elearningID != null && elearningID.length() > 0) {
		ArrayList record = ELearning.getCRM(elearningID);

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			eventID = row.getValue(0);
			topic = row.getValue(1);
			questionNumPerTest = row.getValue(2);
			passGrade = row.getValue(3);

			request.setAttribute("elearning_list", EnrollmentDB.getCRMAttendedClass(CRMClientDB.getClientID(userBean.getUserName())));
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	<body>
	<DIV id=contentFrame style="width:100%;height:100%">
<%	
	String docLvl1KeyID = "1";
	String docLvl2KeyID = "2";

	if(Locale.TRADITIONAL_CHINESE.equals(locale)){		
		docLvl1KeyID = "3";
		docLvl2KeyID = "4";
	}	
%>		
		<jsp:include page="title.jsp">
				<jsp:param name="title" value="function.crm.portal.wellnessOnlineCourse"/>
				<jsp:param name="isFunction" value="Y"/>
		</jsp:include>		
		<br/>
		<div class="infoContent3" style="width:80%;">
			<div class="content2">
				<table>
					<tr><td><b><bean:message key="label.level" arg0="1" /> .</b></td></tr>			
					<jsp:include page="../../common/document_list.jsp">
						<jsp:param name="moduleCode" value="crm.course"/>
						<jsp:param name="siteCode" value="hkah"/>						
						<jsp:param name="keyID" value="<%=docLvl1KeyID %>"/>						
						<jsp:param name="order" value="1"/>
					</jsp:include>
					<tr><td>&nbsp;</td></tr>
					<tr><td><b><bean:message key="label.level" arg0="2" /> .</b></td></tr>
					<jsp:include page="../../common/document_list.jsp">
						<jsp:param name="moduleCode" value="crm.course"/>
						<jsp:param name="siteCode" value="hkah"/>
						<jsp:param name="keyID" value="<%=docLvl2KeyID %>"/>
						<jsp:param name="order" value="1"/>
					</jsp:include>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							<button onclick="elearningTest('17');return false;" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
								<bean:message key="button.test" />
							</button>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<br/>
		<div class="crmField3"><bean:message key="label.crm.pastresult" />  /  <bean:message key="label.crm.passgrade" /> :16</div>
		<br/>
		<bean:define id="notFoundMsg"><bean:message key="message.crm.notfound" /></bean:define>
		<display:table id="row" name="requestScope.elearning_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
			<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
			<display:column titleKey="prompt.courseName" style="width:25%">
			<%if(Locale.TRADITIONAL_CHINESE.equals(locale)){ %>
				<c:out value="${row.fields11}" />
			<%}else{ %>
				<c:out value="${row.fields3}" />
			<%} %>
			</display:column>
			<display:column titleKey="prompt.correctAnswer" style="width:25%">
				<c:out value="${row.fields9}" /> / <c:out value="${row.fields10}" />
			</display:column>
			<display:column titleKey="prompt.attendDate" style="width:10%">
				<c:out value="${row.fields7}" /> <c:out value="${row.fields8}" />
			</display:column>
			<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
		</display:table>
		</DIV>
	</body>
</html:html>
