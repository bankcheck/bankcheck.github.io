<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
String userType = request.getParameter("userType");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
boolean allowAll = "Y".equals(request.getParameter("allowAll"));

if (allowEmpty) {%>
	<option value=""></option>
<%
}
if (allowAll) {%>
	<option value="ALL">ALL</option>
<%}%>
	<option value="0"<%="0".equals(userType)?" selected":"" %>>Requester (0)</option>
	<option value="1"<%="1".equals(userType)?" selected":"" %>>Supervisor (1)</option>
	<option value="2"<%="2".equals(userType)?" selected":"" %>>Workman (2)</option>
	<option value="3"<%="3".equals(userType)?" selected":"" %>>Administrator (3)</option>