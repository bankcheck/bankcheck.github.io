<%@ page language="java" contentType="application/json; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.DiIncomeReportDB"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.*" %>
<%
	UserBean userBean = new UserBean(request);
	
	String ret = "";
	if (userBean.isAccessible("function.di.payrollReport")) {
		String reportMonth = request.getParameter("reportPeriod_mm");
		String reportYear = request.getParameter("reportPeriod_yy");
		
		// load data from database
		if (DiIncomeReportDB.isExam2PayActualRun(reportYear, reportMonth)) {
			ret = "Actual run has been done for the month: " + reportYear + "/" + reportMonth;
		}
	} else {
		String errorMsg = "Invalid access";
	}
    
	out.print(ret);
    out.flush();
%>
