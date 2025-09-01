<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
String[] sex = request.getParameterValues("sex");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));

boolean isEmpty = false;
boolean isMale = false;
boolean isFemale = false;
if (sex != null && sex.length > 0) {
	for (int i = 0; i < sex.length; i++) {
		if ("".equals(sex[i])) isEmpty = true;
		if ("M".equals(sex[i])) isMale = true;
		if ("F".equals(sex[i])) isFemale = true;
	}
}

if (allowEmpty) {%>
	<option value=""<%=isEmpty?" selected":"" %>><bean:message key="label.unknown" /></option>
<%}%>
	<option value="M"<%=isMale?" selected":"" %>><bean:message key="label.male" /></option>
	<option value="F"<%=isFemale?" selected":"" %>><bean:message key="label.female" /></option>