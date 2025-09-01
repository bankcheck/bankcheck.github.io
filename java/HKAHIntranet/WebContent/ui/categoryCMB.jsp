<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %><%
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Category ---";
	}
%><option value="A"><%=emptyLabel %></option><%
}

String category = request.getParameter("category");%>
	<option value="N"<%="N".equals(category)?" selected":"" %>><bean:message key="label.nursing" /></option>
	<option value="P"<%="P".equals(category)?" selected":"" %>><bean:message key="label.paramedical" /></option>
	<option value="H"<%="H".equals(category)?" selected":"" %>><bean:message key="label.otherHealthcare" /></option>	
	<option value="O"<%="O".equals(category)?" selected":"" %>><bean:message key="label.other" /></option>
	<option value=""<%="".equals(category)?" selected":"" %>><bean:message key="label.unknown" /></option>
	