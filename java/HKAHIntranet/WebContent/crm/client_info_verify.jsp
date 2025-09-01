<%@ page language="java" contentType="text/html; charset=utf-8"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"
%><%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"
%><%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"
%><%@ taglib uri="/WEB-INF/c.tld" prefix="c" %><%
UserBean userBean = new UserBean(request);

response.setHeader("Pragma","no-cache");

String clientID = request.getParameter("clientID");
String field = request.getParameter("field");
String value = request.getParameter("value");

String lastName = request.getParameter("lastName");
String dob_dd = request.getParameter("dob_dd");
String dob_mm = request.getParameter("dob_mm");
String dob_yy = request.getParameter("dob_yy");

String street1 = request.getParameter("street1");
String street2 = request.getParameter("street2");
String street3 = request.getParameter("street3");

boolean searchField = false;

try {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME, CRM_CHINESENAME, ");
	sqlStr.append("       CRM_HKID, ");
	sqlStr.append("       CRM_STREET1, CRM_STREET2, CRM_STREET3, CRM_STREET4, ");
	sqlStr.append("       CRM_MOBILE_NUMBER ");
	sqlStr.append("FROM   CRM_CLIENTS ");
	sqlStr.append("WHERE  CRM_ENABLED = 1 ");
	if (clientID != null && clientID.length() > 0) {
		sqlStr.append("AND    CRM_CLIENT_ID != '");
		sqlStr.append(clientID);
		sqlStr.append("' ");
		searchField = true;
	}
	if ("hkid".equals(field)) {
		sqlStr.append("AND    CRM_HKID = '");
		sqlStr.append(value);
		sqlStr.append("' ");
		searchField = true;
	} else if ("homeNumber".equals(field)) {
		sqlStr.append("AND    CRM_HOME_NUMBER = '");
		sqlStr.append(value);
		sqlStr.append("' ");
		searchField = true;
	} else if ("officeNumber".equals(field)) {
		sqlStr.append("AND    CRM_OFFICE_NUMBER = '");
		sqlStr.append(value);
		sqlStr.append("' ");
		searchField = true;
	} else if ("mobileNumber".equals(field)) {
		sqlStr.append("AND    CRM_MOBILE_NUMBER = '");
		sqlStr.append(value);
		sqlStr.append("' ");
		searchField = true;
	} else if ("faxNumber".equals(field)) {
		sqlStr.append("AND    CRM_FAX_NUMBER = '");
		sqlStr.append(value);
		sqlStr.append("' ");
		searchField = true;
	} else if ("email".equals(field)) {
		sqlStr.append("AND    CRM_EMAIL = '");
		sqlStr.append(value);
		sqlStr.append("' ");
		searchField = true;
	} else if ("dobLastName".equals(field)) {
		sqlStr.append("AND    CRM_LASTNAME = '");
		sqlStr.append(lastName);
		sqlStr.append("' AND    CRM_DOB_DD = '");
		sqlStr.append(dob_dd);
		sqlStr.append("' AND    CRM_DOB_MM = '");
		sqlStr.append(dob_mm);
		sqlStr.append("' AND    CRM_DOB_YY = '");
		sqlStr.append(dob_yy);
		sqlStr.append("' ");
		searchField = true;
	} else if ("address".equals(field)) {
		sqlStr.append("AND    CRM_STREET1 = '");
		sqlStr.append(street1);
		sqlStr.append("' AND    CRM_STREET2 = '");
		sqlStr.append(street2);
		sqlStr.append("' AND    CRM_STREET3 = '");
		sqlStr.append(street3);
		sqlStr.append("' ");
		searchField = true;
	}
	sqlStr.append("ORDER BY CRM_LASTNAME, CRM_FIRSTNAME, CRM_CLIENT_ID");

	if (searchField) {
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), 5);
		if (record.size() > 0) {
			request.setAttribute("client_match_list", record);
%><display:table id="row" name="requestScope.client_match_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.name" style="width:15%">
		<logic:equal name="row" property="fields1" value="">
			<c:out value="${row.fields2}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields1" value="">
			<logic:equal name="row" property="fields2" value="">
				<c:out value="${row.fields1}" />
			</logic:equal>
			<logic:notEqual name="row" property="fields2" value="">
				<c:out value="${row.fields1}" />, <c:out value="${row.fields2}" />
			</logic:notEqual>
		</logic:notEqual>
	</display:column>
	<display:column property="fields3" titleKey="prompt.chineseName" style="width:15%" />
	<display:column property="fields4" titleKey="prompt.hkid" style="width:10%" />
	<display:column titleKey="prompt.street" style="width:15%">
		<c:out value="${row.fields5}" /> <c:out value="${row.fields6}" /> <c:out value="${row.fields7}" /> <c:out value="${row.fields8}" />
	</display:column>
	<display:column property="fields9" titleKey="prompt.mobilePhone" style="width:10%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return matchView('<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
</display:table><%
		}
	}
} catch (Exception e) {
}
%>