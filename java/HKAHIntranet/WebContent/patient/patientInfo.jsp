<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
%>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><img src="../images/hkah_portal_logo.gif" border="0" width="302" height="81" /></td></tr>
	<tr><td align="center">Patient Name: <b><%=userBean.getUserName() %></b> (Room: <%=userBean.getRemark2() %> - <%=userBean.getDeptDesc() %>)</td></tr>
	<tr><td>&nbsp;</td></tr>