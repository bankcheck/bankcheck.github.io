<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.ConstantsVariable"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
String parameterType = request.getParameter("parameterType");
String parameterValueName = request.getParameter("parameterValueName");
String[] parameterValue = null;
if (parameterValueName != null) {
	parameterValue = request.getParameterValues(parameterValueName);
} else {
	parameterValue = request.getParameterValues("parameterValue");
}
String parentID = request.getParameter("parentID");

// default allow empty
boolean allowEmpty = !"N".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
%><option value=""><%
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel != null) {
		%><%=emptyLabel %><%
	} else {
		%><bean:message key="label.others" /><%
	}
%></option><%
}
ArrayList record = CRMParameter.getList(parameterType, parentID);
ReportableListObject row = null;
String value = null;
boolean isSelected = false;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		value = row.getValue(0);
		// special handle for default result
		if (value == null || value.length() == 0 || ConstantsVariable.ZERO_VALUE.equals(value)) {
			value = ConstantsVariable.EMPTY_VALUE;
		}
		isSelected = false;
		if (parameterValue != null && parameterValue.length > 0) {
			for (int j = 0; j < parameterValue.length && !isSelected; j++) {
				if (value.equals(parameterValue[j])) {
					isSelected = true;
				}
			}
		}
%><option value="<%=value %>"<%=isSelected?" selected":"" %>><%if (row.getValue(2) != null && row.getValue(2).length() > 0) {%><bean:message key="<%=row.getValue(2)%>" /><%} else { %><%=row.getValue(1) %><%} %></option><%
	}
}
%>