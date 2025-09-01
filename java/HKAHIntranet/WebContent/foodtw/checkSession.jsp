<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<style type="text/css">
button { margin:0 7px 0 0; border:10px solid #aeaeae; border-top:10px solid #eee; border-left:10px solid #eee; font: 12px Arial, Helvetica, sans-serif; font-size:32px; line-height:100%; text-decoration:none; color:#565656; cursor:pointer; padding:10px 10px 10px 10px; /* Links */ ; }
</style>

<%
UserBean userBean = new UserBean(request);

if (userBean == null || !userBean.isLogin()) {
	%>
		<jsp:forward page="../foodtw/index.jsp" />
	<%
	return;
}
%>