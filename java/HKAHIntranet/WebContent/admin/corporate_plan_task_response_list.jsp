<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private String fetchDeptDesc(String deptCode) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM   CO_DEPARTMENTS ");
		sqlStr.append("WHERE  CO_DEPARTMENT_CODE = '");
		sqlStr.append(deptCode);
		sqlStr.append("'");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}

	private String fetchStaffName(String staffID) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_STAFFNAME ");
		sqlStr.append("FROM   CO_STAFFS ");
		sqlStr.append("WHERE  CO_STAFF_ID = '");
		sqlStr.append(staffID);
		sqlStr.append("'");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}
%>
<%
String command = ParserUtil.getParameter(request, "command");
String deptCode = ParserUtil.getParameter(request, "byDeptCode");
String staffID = ParserUtil.getParameter(request, "byStaffID");
String byDeptCode = null;
String byStaffID = null;

HashSet deptCodeHashSet = (HashSet) session.getAttribute("corporate.plan.deptCodeHashSet");
if (deptCodeHashSet == null) {
	deptCodeHashSet = new HashSet();
}
HashMap deptCodeHashMap = (HashMap) session.getAttribute("corporate.plan.deptCodeHashMap");
if (deptCodeHashMap == null) {
	deptCodeHashMap = new HashMap();
}
HashSet staffIDHashSet = (HashSet) session.getAttribute("corporate.plan.staffIDHashSet");
if (staffIDHashSet == null) {
	staffIDHashSet = new HashSet();
}
HashMap staffIDHashMap = (HashMap) session.getAttribute("corporate.plan.staffIDHashMap");
if (staffIDHashMap == null) {
	staffIDHashMap = new HashMap();
}

boolean addAction = false;
boolean removeAction = false;

if ("add".equals(command)) {
	addAction = true;
} else if ("remove".equals(command)) {
	removeAction = true;
}

if (deptCode != null && deptCode.length() > 0) {
	if (addAction) {
		deptCodeHashSet.add(deptCode);
		if (!deptCodeHashMap.containsKey(deptCode)) {
			deptCodeHashMap.put(deptCode, fetchDeptDesc(deptCode));
		}
	} else {
		for (Iterator i = deptCodeHashSet.iterator(); i.hasNext();) {
			byDeptCode = (String) i.next();
			if (byDeptCode.equals(deptCode)) {
				deptCodeHashSet.remove(byDeptCode);
			}
		}
	}
} else if (staffID != null && staffID.length() > 0) {
	if (addAction) {
		staffIDHashSet.add(staffID);
		if (!staffIDHashMap.containsKey(staffID)) {
			staffIDHashMap.put(staffID, fetchStaffName(staffID));
		}
	} else {
		staffIDHashSet.remove(staffID);
	}
}

session.setAttribute("corporate.plan.deptCode", deptCodeHashSet);
session.setAttribute("corporate.plan.staffID", staffIDHashSet);

for (Iterator i = deptCodeHashSet.iterator(); i.hasNext();) {
	byDeptCode = (String) i.next();
	%><a href="javascript:void(0);" onclick="removeTaskResponsibleBy('deptCode', '<%=byDeptCode %>');"><img src="../images/remove-button.gif"/></a><%
	%><input type="hidden" name="taskResponsibleByDeptCode" value="<%=byDeptCode %>"><%
	if (deptCodeHashMap.containsKey(byDeptCode)) {
		%><%=deptCodeHashMap.get(byDeptCode) %><br/><%
	} else if (((String) byDeptCode).length() > 0) {
		%><%=byDeptCode %><%
	}
	%><br/><%
}
for (Iterator i = staffIDHashSet.iterator(); i.hasNext();) {
	byStaffID = (String) i.next();
	%><a href="javascript:void(0);" onclick="removeTaskResponsibleBy('staffID', '<%=byStaffID %>');"><img src="../images/remove-button.gif"/></a><%
	%><input type="hidden" name="taskResponsibleByStaffID" value="<%=byStaffID %>"><%
	if (staffIDHashMap.containsKey(byStaffID)) {
		%><%=staffIDHashMap.get(byStaffID) %><br/><%
	} else if (((String) byStaffID).length() > 0) {
		%><%=byStaffID %><%
	}
	%><br/><%
}
%>