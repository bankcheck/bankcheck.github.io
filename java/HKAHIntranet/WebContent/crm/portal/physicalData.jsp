<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.io.PrintWriter" %>

<%
UserBean userBean = new UserBean(request);
String figureID = request.getParameter("figureID");
String measure = TextUtil.parseStrUTF8(
						java.net.URLDecoder.decode(
								request.getParameter("measure").replaceAll("%", "%25")));

ArrayList result = CRMClientPhysical.getAllFigures(
						CRMClientDB.getClientID(userBean.getLoginID()), 
						figureID);
ReportableListObject row = null;
JSONObject resultJSON = new JSONObject();

if(result.size() > 0) {
	for(int i = 0; i < result.size(); i++) {
		row = (ReportableListObject)result.get(i);
		
		JSONObject dataJSON = new JSONObject();
		
		dataJSON.put("date", row.getValue(2));
		dataJSON.put("value", row.getValue(1));
		resultJSON.put(i, dataJSON);
	}
}

response.setContentType("text/javascript");
PrintWriter writer = response.getWriter();
writer.print(request.getParameter("callback")+"("+resultJSON.toString()+ ");");
writer.close();
%>