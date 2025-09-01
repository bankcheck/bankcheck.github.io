<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String loginDeptCode = userBean.getDeptCode();
String loginDeptDesc = userBean.getDeptDesc();

String deptCode = request.getParameter("deptCode");
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
String category = request.getParameter("category");
boolean includeAllDept = "Y".equals(request.getParameter("includeAllDept"));	
// include dummy departments and departments with no staffs
boolean allowAll = "Y".equals(request.getParameter("allowAll"));
boolean showDescWithCode = "Y".equals(request.getParameter("showDescWithCode"));

ArrayList record = null;
ReportableListObject row = null;
if (allowAll) {
	if ("cash".equals(category)) {
		%><option value="CASH">CASH</option><%	
	}	
	if ("nominee".equals(category)) {
		record = EmployeeVoteDB.getDeptCodeList();
	%><option value=""></option><%	
	} else if ("costCentre".equals(category)) {
		record = DepartmentDB.getCostCentreList(true);
	} else if (includeAllDept) {
		record = DepartmentDB.getList(true);
	} else {
		if(showDescWithCode){
			record = StaffDB.getDeptCodeListWithCode(null);			
		}else{
			record = StaffDB.getDeptCodeList(null);			
		}
	}

	if (record.size() > 0) {
		if("CASH".equals(deptCode)){
			%><option value="CASH"<%="CASH".equals(deptCode)?" selected":"" %>>CASH</option><%			
		}
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			if (ignoreDeptCodes.isEmpty() || !ignoreDeptCodes.contains(row.getValue(0))) { 
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(deptCode)?" selected":"" %>><%=row.getValue(1) %></option><%
			}
		}
	}
} else if (loginDeptCode != null) {
%><option value="<%=loginDeptCode %>"<%=loginDeptCode.equals(deptCode)?" selected":"" %>><%=loginDeptDesc %></option><%
	if(showDescWithCode){
		record = StaffDB.getDeptCode2ListWithCode(userBean.getStaffID());		
	}else{
		record = StaffDB.getDeptCode2List(userBean.getStaffID());		
	}
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			if (ignoreDeptCodes.isEmpty() || !ignoreDeptCodes.contains(row.getValue(0))) {  
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(deptCode)?" selected":"" %>><%=row.getValue(1) %></option><%
			}
		}
	}
}
%>