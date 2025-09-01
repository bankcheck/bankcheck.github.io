<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>    
<%
UserBean userBean = new UserBean(request);
String patno = ParserUtil.getParameter(request, "patno");
String regid = ParserUtil.getParameter(request, "regid");

// debug
//patno = "333333";
//regid = "4000145";

String viewImageUrl = "mobilePhoto.jsp";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<jsp:include page="../common/header.jsp"/>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Medical Record - Registration History (In-patient) control panel</title>
	</head>
	<body>
		<div align="right" style="margin: 10px 0;">
			<button name="btn_view_photo">View Image</button>
			<button name="btn_close">Close</button>
		</div>
	</body>
	<script language="javascript">
		$().ready(function() {
			$('button[name=btn_view_photo]').click(function() {
				var url = "<%=viewImageUrl %>?patno=<%=patno %>&regid=<%=regid %>";
				callPopUpWindow(url);
			});
			
			$('button[name=btn_close]').click(function() {
				if (parent) {
					parent.window.close();
				} else {
					window.close();
				}
			});
		});
	</script>
</html>
