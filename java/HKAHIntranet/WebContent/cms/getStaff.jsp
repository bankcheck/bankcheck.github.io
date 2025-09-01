<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%
//System.out.println("[DEBUG] getStaff");

String staffId = request.getParameter("staffId");
String name = request.getParameter("name");
ArrayList<String> paramStr = new ArrayList<String>();

StringBuffer sqlStr = new StringBuffer();
sqlStr.append(" select co_staff_id, co_department_desc, co_staffname ");
sqlStr.append(" from co_staffs ");
sqlStr.append(" where co_enabled = 1 ");

if (staffId != null) {
	sqlStr.append(" and co_staff_id = ? ");
	paramStr.add(staffId);
}

if (name != null){
	sqlStr.append(" and upper(co_staffname) like '%' || upper(?) || '%' " );
	paramStr.add(name);
}
sqlStr.append(" order by co_staffname ");

String data = null;
ArrayList record = UtilDBWeb.getReportableList( sqlStr.toString(), paramStr.toArray(new String[paramStr.size()]) );

for (int i = 0; i < record.size(); i++) {

	ReportableListObject row = (ReportableListObject) record.get(i);
	
	if (data == null) {
		data = "[";
		data += "{\"staffId\":\"" + row.getValue(0).replace("\\", "\\\\").replace("\"", "\\\"") + "\",";
		data += "\"dept\":\"" + row.getValue(1).replace("\\", "\\\\").replace("\"", "\\\"") + "\",";
		data += "\"name\":\"" + row.getValue(2).replace("\\", "\\\\").replace("\"", "\\\"") + "\"}";		
	} else {
		data += ",";
		data += "{\"staffId\":\"" + row.getValue(0).replace("\\", "\\\\").replace("\"", "\\\"") + "\",";
		data += "\"dept\":\"" + row.getValue(1).replace("\\", "\\\\").replace("\"", "\\\"") + "\",";
		data += "\"name\":\"" + row.getValue(2).replace("\\", "\\\\").replace("\"", "\\\"") + "\"}";
	}					
}
	
if (data == null) {
	data = "null";
} else {
	data += "]";
}
%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%=data %>