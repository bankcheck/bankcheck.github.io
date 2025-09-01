<%@ page language="java" contentType="application/json; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.RISDB"%>
<%@ page import="com.hkah.web.common.UserBean"%>
<%@ page import="java.util.Date" %>
<%
	UserBean userBean = new UserBean(request);
	String command = request.getParameter("command");
	String logno = request.getParameter("logno");
	String accessno = request.getParameter("accessno");
	
	System.out.println(new Date() + " [risAutoMatchLogUpdate] user=" + userBean.getLoginID() + ", command="+command+", logno="+logno+", accessno="+accessno);
	
	String ret = "";
	if (userBean.isAccessible("function.di.risAutoMatchLog.update")) {
		if ("updateStatus".equals(command)) {
			String status = request.getParameter("status");
			
			if (RISDB.updateRisAutoMatchLogStatus(logno, status)) {
				ret = "The status of RIS Accession No: " + accessno + " is changed to " + status;
			} else {
				ret = "Cannot change status of RIS Accession No: " + accessno;
			}
		} else {
			ret = "No update action is selected.";
		}
	} else {
		ret = "No permission to update RIS Auto Match Log";
	}
	System.out.println(new Date() + " [risAutoMatchLogUpdate] ret="+ret);
    
	out.print(ret);
    out.flush();
%>