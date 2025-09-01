<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.helper.FsModelHelper"%>
<%
UserBean userBean = new UserBean(request);

String stationID = request.getParameter("stationID");
boolean allowAll = "Y".equals(request.getParameter("allowAll"));
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
Map<String, String> stationIDs = FsModelHelper.stationIDs;

if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%><option value=""><%=emptyLabel %></option><%
}
if (allowAll) {
%><option value="ALL">All</option><%
}
if (stationIDs.size() > 0) {
	String thisStationID = null;
	String thisStationHost = null;
	Iterator<String> itr = stationIDs.keySet().iterator();
	while (itr.hasNext()) {
		thisStationID = itr.next();
		thisStationHost = stationIDs.get(thisStationID);
%><option value="<%=thisStationID %>"<%=thisStationID.equals(stationID)?" selected":"" %>><%=thisStationID %> (<%=thisStationHost %>)</option><%
	}
}
%>