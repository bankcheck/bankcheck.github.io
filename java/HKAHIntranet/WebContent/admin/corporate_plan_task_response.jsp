<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
String deptCode = ParserUtil.getParameter(request, "deptCode");
String fiscalYear = ParserUtil.getParameter(request, "fiscalYear_yy");
String planID = ParserUtil.getParameter(request, "planID");
String goalID = ParserUtil.getParameter(request, "goalID");
String taskID = ParserUtil.getParameter(request, "taskID");
String isAllowUpdateYN = ParserUtil.getParameter(request, "isAllowUpdateYN");

String byUserID = null;
String byUsername = null;
String byDeptCode = null;
String byDeptDesc = null;

boolean isAllowUpdate = ConstantsVariable.YES_VALUE.equals(isAllowUpdateYN);

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean createGoalAction = false;
boolean createTaskAction = false;
boolean updateTaskAction = false;
boolean createProgressAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("createGoal".equals(command)) {
	createGoalAction = true;
} else if ("createTask".equals(command)) {
	createTaskAction = true;
} else if ("updateTask".equals(command)) {
	updateTaskAction = true;
} else if ("createProgress".equals(command)) {
	createProgressAction = true;
}

HashSet staffIDHashSet = new HashSet();
HashSet deptCodeHashSet = new HashSet();
HashMap staffIDHashMap = new HashMap();
HashMap deptCodeHashMap = new HashMap();

if (!createTaskAction && taskID != null) {
	ArrayList record = CorporatePlanTaskResponsibleDB.getList(userBean, fiscalYear, deptCode, planID, goalID, taskID);
	ReportableListObject row = null;

	if (record.size() > 0) {
		for (int j = 0; j < record.size(); j++) {
			row = (ReportableListObject) record.get(j);
			byUserID = row.getValue(1);
			byUsername = row.getValue(2);
			byDeptCode = row.getValue(3);
			byDeptDesc = row.getValue(4);
			if (byUserID != null && byUserID.length() > 0) {
				staffIDHashSet.add(byUserID);
				staffIDHashMap.put(byUserID, byUsername);
			} else if (byDeptCode != null && byDeptCode.length() > 0) {
				deptCodeHashSet.add(byDeptCode);
				deptCodeHashMap.put(byDeptCode, byDeptDesc);
			}
		}
	}
}
if (!isAllowUpdate) {
	for (Iterator i = deptCodeHashSet.iterator(); i.hasNext();) {
		byDeptCode = (String) i.next();
		if (byDeptCode != null) {
			if (deptCodeHashMap.containsKey(byDeptCode)) {
				%><%=deptCodeHashMap.get(byDeptCode) %><br/><%
			} else if (((String) byDeptCode).length() > 0) {
				%><%=byDeptCode %><%
			}
			%><br/><%
		}
	}
	for (Iterator i = staffIDHashSet.iterator(); i.hasNext();) {
		byUserID = (String) i.next();
		if (byUserID != null) {
			if (staffIDHashMap.containsKey(byUserID)) {
				%><%=staffIDHashMap.get(byUserID) %><br/><%
			} else if (((String) byUserID).length() > 0) {
				%><%=byUserID %><%
			}
			%><br/><%
		}
	}
} else {
	session.setAttribute("corporate.plan.staffIDHashSet", staffIDHashSet);
	session.setAttribute("corporate.plan.deptCodeHashSet", deptCodeHashSet);
	session.setAttribute("corporate.plan.staffIDHashMap", staffIDHashMap);
	session.setAttribute("corporate.plan.deptCodeHashMap", deptCodeHashMap);
%>
										<span id="taskResponsibleBy-container">
<jsp:include page="corporate_plan_task_response_list.jsp" flush="false">
	<jsp:param name="isAllowUpdateYN" value="<%=isAllowUpdateYN %>" />
</jsp:include>
										</span>
										<hr/>
										<div>
											<select name="selectedTaskResponsibleByDeptCode" onchange="return changeStaffID()">
<%	if (userBean.isOfficeAdministrator()) { %>
												<option value="">--- All Departments ---</option>
<%	} %>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
											</select>
											<a href="javascript:void(0);" onclick="addTaskResponsibleBy('deptCode');">Add Department</a><br/>
											<span id="staff-container">
											<select name="selectedTaskResponsibleByStaffID">
<jsp:include page="corporate_plan_task_response_by.jsp" flush="false">
	<jsp:param name="siteCode" value="<%=userBean.getSiteCode() %>" />
	<jsp:param name="deptCode" value="<%=deptCode %>" />
</jsp:include>
											</select>
											</span>
											<a href="javascript:void(0);" onclick="addTaskResponsibleBy('staffID');">Add Person</a>
										</div>
<%
}
%>