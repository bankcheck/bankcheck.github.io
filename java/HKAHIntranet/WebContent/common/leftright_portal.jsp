<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.AccessControlDB"%>
<%
// get infomation from userbean
UserBean userBean = new UserBean(request);
if (userBean == null) {
	throw new Exception("Please enable cookies!");
}

// store current category
String pageCategory = request.getParameter("category");
if (pageCategory != null) {
	session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY, pageCategory);
} else {
	pageCategory = (String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY);
}
String referer = (String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_REFERER);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
	 "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title>Hospital Intranet</title>
</head>
<% if (AccessControlDB.isDisablePortalFunctions()) { %>
	<frameset border="0" frameborder="0" framespacing="0">
		<frame name="bigcontent" src="../common/service_maintenance.html">
	</frameset>
<% } else { %>
<%	if (userBean.isLogin() && "hats".equals(pageCategory)) { %>
<frameset border="0" frameborder="0" framespacing="0">
	<frame name="bigcontent" src="http://160.100.2.73:9080/HKAHNHS/HKAHNHS.html?userID=HKAH&userName=<%=userBean.getUserName() %>">
</frameset>
<%	} else if (userBean.isLogin() && "cms3".equals(pageCategory)) { %>
<!-- ! hkahcms - ie problem inside frameset, lead to form post data encoding wrong -->
<frameset border="0" frameborder="0" framespacing="0">
	<frame name="bigcontent" src="http://160.100.2.73:9080/hkahcms/HKAHCMS.html?userID=<%=userBean.getLoginID() %>&userName=<%=userBean.getUserName() %>">
</frameset>
<%	} else if (userBean.isLogin() && "task".equals(pageCategory)) { %>
<frameset border="0" frameborder="0" framespacing="0">
	<frame name="bigcontent" src="../common/task_list.jsp">
</frameset>
<%	} else { %>
<%		if (userBean.isLogin() &&userBean.isDefaultPassword()) { %>
<frameset border="0" frameborder="0" framespacing="0" cols="0, *">
	<frame name="menu">
	<frame name="content" src="../admin/change_password.jsp?errorMsg=The%20password%20is%20default.%20Please%20change%20it%20for%20security%20reason.">
<%		} else if (userBean.isLogin() && userBean.isStudentUser()) { %>
<frameset border="0" frameborder="0" framespacing="0" cols="0, *">
	<frame name="menu">
	<frame name="content" src="../education/elearning_test_list_menu.jsp?eventCategory=compulsory&eventType=online">
<%		} else { %>
<frameset border="0" frameborder="0" framespacing="0" cols="230, *">
	<frame name="menu" src="../common/left_menu.jsp" noresize>
<%			if (userBean.isLogin()) { %>
<%				if ("home".equals(pageCategory)) { %>
	<frame name="content" src="../portal/news.general.jsp">
<%				} else if ("title.education".equals(pageCategory)) { %>
	<frame name="content" src="../education/reminder.jsp">
<%				} else if ("group.crm".equals(pageCategory)) { %>
	<frame name="content" src="../crm/client_info_list.jsp">
<%				} else if ("ic".equals(pageCategory)) { %>
	<frame name="content" src="../ic/testNewIndex.jsp">
<%				} else if (referer != null && referer.length() > 0) { %>
	<frame name="content" src="../common/dummy.jsp?referer=<%=referer %>">
<%  				} else { %>
	<frame name="content" src="../portal/news.general.jsp">
<%				} %>
<%			} else { %>
<%				if ("ic".equals(pageCategory)) { %>
	<frame name="content" src="../ic/material_index_test.jsp">
<%				} else {%>
	<frame name="content" src="../portal/news.general.jsp">
<%				} %>
<%			} %>
<%		} %>
<%	} %>
	<noframes>
			<P>Please use Internet Explorer or Mozilla!
	</noframes>
</frameset>
<%	} %>