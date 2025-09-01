<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
String[] scr = request.getParameterValues("scr");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));

boolean isEmpty = false;
boolean isCross = false;
boolean isSoundex = false;
boolean isWildcard = false;
if (scr != null && scr.length > 0) {
	for (int i = 0; i < scr.length; i++) {
		if ("".equals(scr[i])) isEmpty = true;
		if ("Cross".equals(scr[i])) isCross = true;
		if ("Soundex".equals(scr[i])) isSoundex = true;
		if ("Wildcard".equals(scr[i])) isWildcard = true;
	}
}

if (allowEmpty) {%>
	<option value=""<%=isEmpty?" selected":"" %>></option>
<%}%>
	<option value="Wildcard"<%=isWildcard?" selected":"" %>>Wildcard</option>
	<option value="Cross"<%=isCross?" selected":"" %>>Cross</option>
	<option value="Soundex"<%=isSoundex?" selected":"" %>>Soundex</option>
	