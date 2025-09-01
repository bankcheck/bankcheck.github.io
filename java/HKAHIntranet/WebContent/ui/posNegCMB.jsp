<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %><%
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%><option value=""><%=emptyLabel %></option><%
}

String posNeg = request.getParameter("posNeg");%>
<option value="P"<%="P".equals(posNeg)?" selected":"" %>>Positive</option>
<option value="N"<%="N".equals(posNeg)?" selected":"" %>>Negative</option>
	