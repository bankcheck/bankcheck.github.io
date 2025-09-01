<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %><%
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- Both ---";
	}
%><option value="2"><%=emptyLabel %></option><%
}

String isClaimMoney = request.getParameter("isClaimMoney");%>
	<option value="0"<%="0".equals(isClaimMoney)?" selected":"" %>><bean:message key="label.no" /></option>
	<option value="1"<%="1".equals(isClaimMoney)?" selected":"" %>><bean:message key="label.yes" /></option>
	