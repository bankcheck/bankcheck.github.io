<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String loginDeptCode = userBean.getDeptCode();
String loginDeptDesc = userBean.getDeptDesc();

String deptCode = request.getParameter("deptCode");
/*
String ignoreDeptCode = request.getParameter("ignoreDeptCode");
Set<String> ignoreDeptCodes = new HashSet<String>();
if (ignoreDeptCode != null) {
	String[] values = ignoreDeptCode.split(",");
	for (String value : values) {
		if (value != null) {
			value = value.trim();
			ignoreDeptCodes.add(value);
		}
	}
}
*/
//String category = request.getParameter("category");
//boolean includeAllDept = "Y".equals(request.getParameter("includeAllDept"));	
// include dummy departments and departments with no staffs
//boolean allowAll = "Y".equals(request.getParameter("allowAll"));
//boolean showDescWithCode = "Y".equals(request.getParameter("showDescWithCode"));

ArrayList record = null;
ReportableListObject row = null;

record = DepartmentDB.getJointList(true);
	
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(deptCode)?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>