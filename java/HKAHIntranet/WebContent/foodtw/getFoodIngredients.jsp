<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList<ReportableListObject> fetchFoodIngredients(String param) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT F_FSD_INGREDIENTS('"+param+"') ");
		sqlStr.append("FROM DUAL ");
		
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
%>
<%
	String itemCode = request.getParameter("itemCode");
	
	ArrayList<ReportableListObject> record = fetchFoodIngredients(itemCode);
	ReportableListObject row = record.get(0);
%>
<%=row.getValue(0)%>