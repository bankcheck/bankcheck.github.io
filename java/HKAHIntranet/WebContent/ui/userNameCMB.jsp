<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchUserName(String deptCode) {
		// fetch user
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT U.CO_USERNAME, S.CO_STAFFNAME ");
		sqlStr.append("FROM   CO_USERS U, CO_STAFFS S ");
		sqlStr.append("WHERE  U.CO_GROUP_ID != 'admin' ");
		sqlStr.append("AND    U.CO_STAFF_ID = S.CO_STAFF_ID ");
		if (deptCode != null && deptCode.length() != 0) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY S.CO_STAFFNAME");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);

String deptCode = request.getParameter("deptCode");

// if not admin, use login dept code as default dept code
if (!userBean.isAdmin() && (deptCode == null || deptCode.length() == 0)) {
	deptCode = userBean.getDeptCode();
}

ArrayList record = fetchUserName(deptCode);
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"><%=row.getValue(1) %></option><%
	}
}
%>