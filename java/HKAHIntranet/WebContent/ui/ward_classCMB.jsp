<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="java.io.PrintWriter" %>
<%!
private boolean checkSelected(String[] dataSet, String value) {
	if (dataSet != null) {
		for (int i = 0; i < dataSet.length; i++) {
			if (dataSet[i].equals(value)) {
				return true;
			}
		}
		return false;
	}
	else {
		return false;
	}
}
%>
<%
StringBuffer sqlStr = new StringBuffer();
StringBuffer sqlStracc = new StringBuffer();
String Type = request.getParameter("Type");
String[] Value = (String[]) request.getAttribute("MultiValue");
String singleValue = request.getParameter("Value");
String iOS = request.getParameter("iOS");
String checkBox = request.getParameter("checkBox");
String checkBoxName = request.getParameter("checkBoxName");
String clientIP = request.getRemoteAddr();
String module = request.getParameter("module");
String accessWard = request.getParameter("accessWard"); 
String accessWardList = null;
 if ("fstw".equals(module) && "".equals(accessWard)) {
	accessWardList = PatientDB.getAccessibleWardList(clientIP);
} else if (!"".equals(accessWard)) {
	/* accessWardList = "'"+accessWard+"'"; */
	accessWardList = "'"+StringUtils.join(StringUtils.split(accessWard,","),"','")+"'";
}
if("Ward".equals(Type)){
	if("fstw".equals(module) && (accessWardList != null && !"".equals(accessWardList)) ) {
		sqlStr.append("SELECT WRDCODE,WRDNAME FROM WARD@IWEB WHERE ACTIVE=-1 AND WRDCODE IN ("+accessWardList.replace("''","'")+") ORDER BY WRDCODE");
	} else {
		sqlStr.append("SELECT WRDCODE,WRDNAME FROM WARD@IWEB WHERE ACTIVE=-1 ORDER BY WRDCODE");
	}
}else if ("Class".equals(Type)){
sqlStr.append("SELECT ACMCODE,ACMNAME FROM ACM@IWEB");
}
ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
JSONObject wardJSON = new JSONObject();

ReportableListObject row = null;
if (record.size() > 0) {
	if(("fstw".equals(module) && (accessWardList == null || "".equals(accessWardList))) 
			&& (checkBox == null || !checkBox.equals("true"))) { %>	
		<option value='ALL'>ALL</option>
	<%}
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		if(row.getValue(1).indexOf("CLOSED") < 0 && row.getValue(1).indexOf("DAYCASE") < 0) {
			if(iOS != null && iOS.equals("true")) {
				wardJSON.put(row.getValue(0), row.getValue(1));
			}else {
				if (checkBox != null && checkBox.equals("true")) {
%><input value="<%=row.getValue(0) %>" name="<%=checkBoxName%>" type="checkbox"
		<%=checkSelected(Value, row.getValue(0))?" checked":"" %>>
	<%=row.getValue(1) %>
	</input><br/><%
				}
				else {
%><option value="<%=row.getValue(0) %>"
			<%=checkSelected(Value, row.getValue(0))||row.getValue(0).equals(singleValue)?" selected":"" %>>
		<%=row.getValue(1) %>
</option><%
				}
			}
		}
	}
if (checkBox != null && checkBox.equals("true")) {
%><input value="NONE" name="<%=checkBoxName%>" type="checkbox"
		<%=checkSelected(Value, "NONE")?" checked":"" %>>
		NONE
		</input><br/><%
	}

	if(iOS != null && iOS.equals("true")) {
		response.setContentType("text/javascript");
		PrintWriter writer = response.getWriter();
		//System.out.println(request.getParameter("callback")+"("+wardJSON.toString()+ ");");
		writer.print(request.getParameter("callback")+"("+wardJSON.toString()+ ");");
		writer.close();
	}
}
%>