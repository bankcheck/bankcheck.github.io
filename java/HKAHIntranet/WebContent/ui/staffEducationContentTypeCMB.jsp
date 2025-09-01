<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*" %>
<%@ page import="com.hkah.config.*"%>


<%
UserBean userBean = new UserBean(request);

String moduleCode = request.getParameter("moduleCode");
String level = request.getParameter("level");
String eeType = request.getParameter("eeType");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = MessageResources.getMessage(session, "label.selectAllTest");
	}
%><option value=""><%=emptyLabel %></option><%
}
Map<String, String> eeTypes = StaffEducationModelHelper.getEeTypes(moduleCode, level);
if (eeTypes != null && !eeTypes.isEmpty()) {
	Set<String> keySet = eeTypes.keySet();
	Iterator<String> itr = keySet.iterator();
	String key = null;
	String value = null;
	while (itr.hasNext()) {
		key = itr.next();
		value = eeTypes.get(key);
%><option value="<%=key %>"<%=(key.equals(eeType))?" selected":"" %>><%=value %></option><%
	}
}
%>