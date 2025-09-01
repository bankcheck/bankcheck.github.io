<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.json.*" %>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.StaffDB"%>
<%@ page import="com.hkah.util.db.*"%>
<%
String message = null;
String errorMessage = null;
JSONObject returnJSON = new JSONObject();

UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
String staffID = ParserUtil.getParameter(request, "staffID");
String siteCode = ParserUtil.getParameter(request, "siteCode");

System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [staff_update.jsp] staffID="+staffID+", command="+command+", siteCode="+siteCode+", user="+userBean.getLoginID());

boolean createOtherSiteAction = false;
boolean staffAccOtherSiteAction = false;

if ("createOtherSite".equals(command)) {
	if (!userBean.isAccessible("function.staff.create")) {
		errorMessage = "No staff create access right.";
	} else { 
		createOtherSiteAction = true;
	}
} else if ("staffAccOtherSite".equals(command)) {
	if (!userBean.isAccessible("function.staff.view")) {
		errorMessage = "No view staff access right.";
	} else { 
		staffAccOtherSiteAction = true;
	}
}

try {
	if (createOtherSiteAction && siteCode != null) {
		message = UtilDBWeb.callFunction("HAT_ACT_STAFF_" + siteCode.toUpperCase(), "ADD", new String[] { staffID }, true);
	} else if (staffAccOtherSiteAction && siteCode != null) {
		ArrayList result = StaffDB.getStaffOtherSite(staffID, siteCode);
		
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			message = rlo.getFields1() + " (site code: " + rlo.getFields0() + ") " + ("1".equals(rlo.getFields2()) ? "ACTIVE" : "INACTIVE");
		}
	}
} catch (Exception e) {
	e.printStackTrace();
	errorMessage = e.getMessage();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

returnJSON.put("message", message);
returnJSON.put("errorMessage", errorMessage);
%>
<%=returnJSON.toString() %>