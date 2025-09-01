<%@ page import="com.hkah.util.Encryptor"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
UserBean userBean = new UserBean(request);
if (!userBean.isAdmin()) {
	return;
}

String pt = ParserUtil.getParameter(request, "pt");
Encryptor e = new Encryptor();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Encrypt</title>
</head>
<body>
	<div>
		<form method="post">
		<p>
			<input name="pt" size="20" value="<%=pt != null ? pt : "" %>" /><button type="submit">Submit</button><br />
			plain text: <%=pt != null ? pt : "" %><br />
			encrypted: <%=pt != null ? e.encrypt(pt) : "" %>
		</p>
		</form>
	</div>
</body>
</html>