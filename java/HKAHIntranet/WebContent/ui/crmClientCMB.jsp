<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.hibernate.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%
UserBean userBean = new UserBean(request);
String start = request.getParameter("start");

String search = TextUtil.parseStrUTF8(request.getParameter("search"));

System.out.println(search);

boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
String startvalue = request.getParameter("startvalue");
String backvalue = request.getParameter("backvalue");

%>
<select name="crmclient" size="15" multiple id="clientSelect">
<%

if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%>

<option value=""><%=emptyLabel %></option>
<%
}

List<CrmClients> crmClientList = CRMPromotionDB2.getCrmClientList(start,search);
if (crmClientList != null && !crmClientList.isEmpty()) {
	CrmClients crmClients = null;
	boolean isSelected = false;
	for (Iterator<CrmClients> itr = crmClientList.iterator(); itr.hasNext();) {
		crmClients = itr.next();
		
	//	if ((clientID != null && targetID.equals(crmTarget.getCrmTargetId().toString())) ||
	//			(targetName != null && targetName.equals(crmTarget.getCrmTargetName()))) {
	//		isSelected = true;
	//	} else {
	//		isSelected = false;
	//	}
if(crmClients.getCrmChinesename() != null && (crmClients.getCrmFirstname() == null || crmClients.getCrmLastname()== null)) {

%>
<option value="<%=crmClients.getCrmClientId() %>"<%=isSelected?" selected":"" %>><%=crmClients.getCrmClientId() %> <%=crmClients.getCrmChinesename() %></option>
<%} else if (crmClients.getCrmFirstname() != null && crmClients.getCrmLastname() != null){%>

<option value="<%=crmClients.getCrmClientId() %>"<%=isSelected?" selected":"" %>><%=crmClients.getCrmClientId() %> <%=crmClients.getCrmLastname() %> <%=crmClients.getCrmFirstname() %></option>
<%} else if (crmClients.getCrmLastname() == null){%>
<option value="<%=crmClients.getCrmClientId() %>"<%=isSelected?" selected":"" %>><%=crmClients.getCrmClientId() %> <%=crmClients.getCrmFirstname() %></option>
<%} else if (crmClients.getCrmFirstname() == null){%>
<option value="<%=crmClients.getCrmClientId() %>"<%=isSelected?" selected":"" %>><%=crmClients.getCrmClientId() %> <%=crmClients.getCrmLastname() %></option>
<%} 
startvalue = crmClients.getCrmClientId().toString();

}
	
}
backvalue = start;
%>
</select>
<input type="hidden" name="startvalue" value="<%=startvalue %>" />
<input type="hidden" name="backvalue" value="<%=backvalue %>" />
 
