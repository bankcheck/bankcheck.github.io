<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
String loginStatus = request.getParameter("loginStatus");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
boolean allowAll = "Y".equals(request.getParameter("allowAll"));

if (allowEmpty) {%>
	<option value=""></option>
<%
}
if (allowAll) {%>
	<option value="ALL">ALL</option>
<%}%>
	<option value="0"<%="0".equals(loginStatus)?" selected":"" %>>Online</option>
	<option value="1"<%="1".equals(loginStatus)?" selected":"" %>>1</option>
	<option value="2"<%="2".equals(loginStatus)?" selected":"" %>>Logged out</option>
<%if (loginStatus != null && !loginStatus.isEmpty() && !"0".equals(loginStatus) && !"1".equals(loginStatus) && !"2".equals(loginStatus)) {%>
	<option value="<%=loginStatus %>" selected><%=loginStatus %></option>
<%}%>
