<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.hibernate.*"%>
<%@ page import="com.hkah.config.*"%>

<%
UserBean userBean = new UserBean(request);
String targetID = request.getParameter("targetID");
String targetName = request.getParameter("targetName");

boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%>
<option value=""><%=emptyLabel %></option>
<%
}
List<CrmTarget> crmTargetList = CRMPromotionDB2.getCrmTargetList();
if (crmTargetList != null && !crmTargetList.isEmpty()) {
	CrmTarget crmTarget = null;
	boolean isSelected = false;
	for (Iterator<CrmTarget> itr = crmTargetList.iterator(); itr.hasNext();) {
		crmTarget = itr.next();
		
		if ((targetID != null && targetID.equals(crmTarget.getCrmTargetId().toString())) ||
				(targetName != null && targetName.equals(crmTarget.getCrmTargetName()))) {
			isSelected = true;
		} else {
			isSelected = false;
		}
%>
<option value="<%=crmTarget.getCrmTargetId() %>"<%=isSelected?" selected":"" %>><%=crmTarget.getCrmTargetName() %></option>
<%
	}
}
%>