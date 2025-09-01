<%@ page language="java" contentType="application/json; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.RISDB"%>
<%@ page import="com.hkah.web.common.UserBean"%>
<%@ page import="java.util.Date" %>
<%
	UserBean userBean = new UserBean(request);
	String command = request.getParameter("command");
	String docCode = request.getParameter("docCode");
	String sendRisEmail = request.getParameter("sendRisEmail");
	
	System.out.println(new Date() + " [di.docEmailUpdate] user=" + userBean.getLoginID() + ", command="+command+", docCode="+docCode+", sendRisEmail="+sendRisEmail);
	
	String ret = "";
	if (userBean.isAccessible("function.di.docEmail.update")) {
		if ("updateSendRisEmail".equals(command)) {
			String status = request.getParameter("status");
			
			if (RISDB.updateDocRISEmail(docCode, sendRisEmail)) {
				ret = "The send mail status of doctor code: " + docCode + " is changed to " + ("-1".equals(sendRisEmail) ? "Allow" : "Not allow");
			} else {
				ret = "Cannot change send mail status of doctor code: " + docCode;
			}
		} else {
			ret = "No update action is selected.";
		}
	} else {
		ret = "No permission to update DI Doctor Email";
	}
	System.out.println(new Date() + " [di.docEmailUpdate] ret="+ret);
    
	out.print(ret);
    out.flush();
%>