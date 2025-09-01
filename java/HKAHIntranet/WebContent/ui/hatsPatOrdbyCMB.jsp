<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
String[] ordby = request.getParameterValues("ordby");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));

boolean isEmpty = false;
boolean isPatname = false;
boolean isPatno = false;
if (ordby != null && ordby.length > 0) {
	for (int i = 0; i < ordby.length; i++) {
		if ("".equals(ordby[i])) isEmpty = true;
		if ("patname".equals(ordby[i])) isPatname = true;
		if ("patno".equals(ordby[i])) isPatno = true;
	}
}

if (allowEmpty) {%>
	<option value=""<%=isEmpty?" selected":"" %>></option>
<%}%>
	<option value="Patient Name"<%=isPatname?" selected":"" %>>Patient Name</option>
	<option value="Patient No."<%=isPatno?" selected":"" %>>Patient No.</option>
	