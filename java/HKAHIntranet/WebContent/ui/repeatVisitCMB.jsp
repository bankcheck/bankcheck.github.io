<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
String[] repeatvisit = request.getParameterValues("repeatvisit");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
boolean isEmpty = false;
boolean isAgain = false;
boolean isFrequently = false;
boolean isDaily = false;
if (repeatvisit != null && repeatvisit.length > 0) {
	for (int i = 0; i < repeatvisit.length; i++) {
		if ("".equals(repeatvisit[i])) isEmpty = true;
		if ("a".equals(repeatvisit[i])) isAgain = true;
		if ("f".equals(repeatvisit[i])) isFrequently = true;
		if ("d".equals(repeatvisit[i])) isDaily = true;
		
	}
}

if (allowEmpty) {%>
	<option value=""<%=isEmpty?" selected":"" %>><bean:message key="label.unknown" /></option>
<%}%>
	<option value="a"<%=isAgain?" selected":"" %>>Again</option>
	<option value="f"<%=isFrequently?" selected":"" %>>Frequently</option>	
	<option value="d"<%=isDaily?" selected":"" %>>Daily</option>