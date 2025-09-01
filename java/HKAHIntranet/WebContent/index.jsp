<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
int randomno = 0;
String portalUrl = null;
ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;

if (session == null) {
	%><jsp:forward page="../common/access_deny.jsp" /><%
	return;
}

// get infomation from userbean
UserBean userBean = new UserBean(request);
if (userBean != null && userBean.isAdmin()) {
	// no need to check load balance
} else if (ConstantsServerSide.CORE_SERVER && ConstantsServerSide.LOAD_BALANCE) {
	if ("admin".equals(request.getParameter("mode"))) {
		String sessionID = request.getParameter("sessionID");
		String staffID = request.getParameter("staffID");

		if (sessionID != null && sessionID.length() > 0 && staffID != null && staffID.length() > 0) {
			record = UtilDBWeb.getReportableList("SELECT u.CO_STAFF_ID FROM SSO_SESSION@SSO s, co_users u WHERE s.USER_ID = U.CO_USERNAME AND s.MODULE_CODE = 'hk.portal' AND s.SESSION_ID = ? AND u.CO_STAFF_ID = ? AND s.TIMESTAMP_UPDATE > SYSDATE - 1", new String[] { sessionID, staffID });
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				userBean = UserDB.getUserBean(request, row.getValue(0));
				if (userBean != null) {
					// set to admin
					userBean.setAdmin(request);
				}
			}
		}
	} else {
		record = UtilDBWeb.getReportableListSEED("SELECT URL FROM SSO_MODULE_URL WHERE MODULE_CODE = 'hk.portal' AND ENABLED = 1 ORDER BY SEQ");
		if (record.size() > 0) {
			randomno = (new Random()).nextInt(record.size());
			row = (ReportableListObject) record.get(randomno);
			portalUrl = row.getValue(0);
		}
	}
}

if (portalUrl != null) {
	response.sendRedirect(portalUrl);
} else {
	boolean isAutoCasAuth = "true".equals(request.getParameter("autoCasAuth"));
	boolean isSingleSignOut = "true".equals(request.getParameter("singleSignOut"));

	if (isSingleSignOut) {
		// redirect to CAS logout
		response.sendRedirect(ConstantsServerSide.CAS_SINGLESIGNOUTURL);
	}

	// check whether is login system
	boolean isLogin = userBean != null && userBean.isLogin();

	// evaluate new HTTPS URL
	String absolutePath = request.getRequestURL().toString();

	absolutePath = request.getContextPath();
	StringBuffer urlPath = new StringBuffer();
	String message = request.getParameter("message");

	if (message != null) {
		urlPath.append("message=");
		urlPath.append(message);
	}
	String errorMessage = request.getParameter("errorMessage");
	if (errorMessage != null) {
		if (urlPath.length() > 0) {
			urlPath.append("&");
		}
		urlPath.append("errorMessage=");
		urlPath.append(errorMessage);
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
	 "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<% if (!ConstantsServerSide.isAMC2()) { %>
<meta http-equiv="X-UA-Compatible" content="IE=9">
<% } %>
<title>Hospital Intranet</title>
<link rel="stylesheet" type="text/css" href="<%=absolutePath %>/css/style.css" />
<link rel="shortcut icon" href="images/portal.ico" type="image/x-icon">
<script language="javascript">
	function goToCasAuth() {
		window.parent.location.href = "casAuth.jsp";
	}

<%	if (isAutoCasAuth) { %>
	goToCasAuth();

<%	} %>
<%	if (ConstantsServerSide.SECURE_SERVER) { %>
	var secureProtocol = "https:";
	if (window.location.protocol != secureProtocol) {
		var url = window.location.href;
		window.location.href = secureProtocol + url.substring(url.indexOf(":") + 1, url.length);
	}

<%	} %>
	if (this.window.name == 'title' || this.window.name == 'content' || this.window.name == 'bigcontent') {
		parent.location.href = "<%=absolutePath %>/index.jsp?<%=urlPath.toString() %>";
	}
</script>
</head>
<%	if (!ConstantsServerSide.SECURE_SERVER || isLogin) { %>
<frameset border="0" frameborder="0" framespacing="0" rows="130, *">
	<frame name="title" src="<%=absolutePath %>/common/banner.jsp" noresize scrolling="no">
	<frame name="bigcontent" src="<%=absolutePath %>/common/leftright_portal.jsp">
	<noframes>
			<P>Please use Internet Explorer or Mozilla!
	</noframes>
</frameset>
<%	} else { %>
<script language="javascript">
<%		if (ConstantsServerSide.CAS_SINGLESIGNON) { %>
	goToCasAuth();
<%		} else { %>
	parent.location.href = "<%=absolutePath %>/portal/index.jsp";
<%		} %>
</script>
<%	} %>
</html>
<%} %>