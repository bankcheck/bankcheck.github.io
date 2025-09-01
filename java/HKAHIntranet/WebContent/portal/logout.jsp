<%@ page import="com.hkah.constant.*" %>
<%
	session.invalidate();

	// clean up cookie from request
	Cookie cookies [] = request.getCookies();
	if (cookies != null) {
		for (int i = 0; i < cookies.length; i++) {
			if (ConstantsWebVariable.KEY_SESSION_LOGIN_STAFF_ID.equals(cookies[i].getName())) {
				cookies[i].setValue(ConstantsVariable.EMPTY_VALUE);
				break;
			}
		}
	}

	// clean up cookie from response
	Cookie cookie = new Cookie(ConstantsWebVariable.KEY_SESSION_LOGIN_STAFF_ID, ConstantsVariable.EMPTY_VALUE);
	response.addCookie(cookie);
%>
<script type="text/javascript">
<!--
	window.parent.location = '../portal/index.jsp'; // Refresh Page
-->
</script>