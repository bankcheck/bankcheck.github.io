<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
private static ArrayList getPosition(String govDept) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT	GOVJOBCODE, GOVPOSITION "); 
	sqlStr.append("FROM		GOVJOB@IWEB ");
	sqlStr.append("WHERE   	ARCCODE = '" + govDept + "' ");
	sqlStr.append("ORDER BY GOVPOSITION ");

	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

%>
<option></option>
<% 
String govDept = request.getParameter("govDept");
String govPosition = request.getParameter("govPosition");

ArrayList record = new ArrayList();

record = getPosition(govDept);
if(record.size() > 0){
	for(int i=0; i<record.size(); i++){
		ReportableListObject row = (ReportableListObject) record.get(i);
%>
		<option value="<%=row.getValue(0)%>" <%=row.getValue(0).equals(govPosition)?"selected":"" %>><%=row.getValue(1) %></option>
<%
		
	}
}

%>


