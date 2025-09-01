<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="org.jasig.cas.client.constant.*"%>
<%
	HttpSession ses = request.getSession(false);
	//Assertion assertion = session != null ? (Assertion) session.getAttribute(CONST_CAS_ASSERTION) : null;
	String authUser = (String) ses.getAttribute(AssertionConst.CONST_CAS_ASSERTION_PRINCIPAL_USER);
	
	//System.out.println("INFO [intranet] casAuth.jsp(15) authUser = " + authUser);
	
	// retrieve user details without authentication
	UserBean userBean = UserDB.getUserBeanSkipPassword(request, authUser);

	String message = request.getParameter("message");
	String errorMessage = request.getParameter("errorMessage");
	
	String redirectURL = "index.jsp";
	response.sendRedirect(redirectURL);
%>