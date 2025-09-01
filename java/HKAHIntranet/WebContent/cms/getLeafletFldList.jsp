<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%
String fld = request.getParameter("fld");
String code = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"code"));
String debug = request.getParameter("debug");

StringBuffer sqlStr = new StringBuffer();
sqlStr.append(" select distinct " + fld + " from lm_leaflet ");
sqlStr.append(" where upper(" + fld + ") like upper(?) || '%' ");
sqlStr.append(" order by " + fld);

String data =  null;

ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{code});

for (int i = 0; i < record.size(); i++) {

	ReportableListObject row = (ReportableListObject) record.get(i);

	if (data == null) {
		data = "[";
		data += "{\"" + fld + "\":\"" + row.getValue(0).replace("\\", "\\\\").replace("\"", "\\\"") + "\"}";		
	} else {
		data += ",";
		data += "{\"" + fld + "\":\"" + row.getValue(0).replace("\\", "\\\\").replace("\"", "\\\"") + "\"}";		
	}	
}

if (data == null) {
	data = "null";
} else {
	data += "]";
}

if ("Y".equals(debug)) {
	System.out.println("[DEBUG] getLeafletFldList parameters: fld=" + fld + " code=" + code);
	System.out.println("[DEBUG] getLeafletFldList sql:" + sqlStr.toString());
	System.out.println("[DEBUG] getLeafletFldList data:" + data);
}

%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%=data %>