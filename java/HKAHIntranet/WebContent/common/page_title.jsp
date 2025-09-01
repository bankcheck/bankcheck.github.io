<%@ page buffer="16kb" %>
<%@ page import="java.net.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%!
	public static String capitalizeFirstLetter(String text) {
		if (text != null) {
			return StringUtils.capitalize(text);
		} else {
			return text;
		}
	}
%>
<%
if (session == null) {
	%><jsp:forward page="../common/access_deny.jsp" /><%
	return;
}

UserBean userBean = new UserBean(request);
boolean isKeepReferer = false;
String referer = null;

if (!"N".equals(request.getParameter("keepReferer")) || !userBean.isLogin()) {
	// store current page url
	isKeepReferer = true;
	StringBuffer refererSB = new StringBuffer();
	refererSB.append(request.getServletPath().substring(1));
	refererSB.append("?");
	Enumeration parameterList = request.getParameterNames();
	String paramter = null;
	while( parameterList.hasMoreElements() ) {
		paramter = parameterList.nextElement().toString();
		refererSB.append(paramter);
		refererSB.append("=");
		refererSB.append(request.getParameter(paramter));
		refererSB.append("&");
	}
	referer = refererSB.toString();

	if (referer != null && referer.length() > 0) {
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_REFERER, referer);
	}
}

if ("N".equals(request.getParameter("loadBalance")) && !ConstantsServerSide.CORE_SERVER && ConstantsServerSide.LOAD_BALANCE) {
	StringBuffer strBuf = new StringBuffer();
	strBuf.append("http://");
	strBuf.append(ConstantsServerSide.INTRANET_URL);
	strBuf.append("/intranet/portal/index.jsp?");

	Enumeration parameterList = request.getParameterNames();
	String parameterName = null;
	while( parameterList.hasMoreElements() ) {
		parameterName = parameterList.nextElement().toString();
		strBuf.append(parameterName);
		strBuf.append("=");
		strBuf.append(URLEncoder.encode(request.getParameter(parameterName)));
		strBuf.append("&");
	}
	strBuf.append("referer=");
	strBuf.append(referer);
	strBuf.append("&sessionID=");
	if (request.getSession() != null) {
		strBuf.append(request.getSession().getId());
	}
	strBuf.append("&staffID=");
	if (userBean != null && userBean.isLogin()) {
		strBuf.append(userBean.getStaffID());
	}
	%><script language="javascript">window.location.href = "<%=strBuf.toString() %>";</script><%
	return;
}

// store current category
String pageCategory = (String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY);
if ("title.education".equals(pageCategory) || "group.crm".equals(pageCategory)) {
	pageCategory = null;
}
String category = request.getParameter("category");
String pageTitleEncode = request.getParameter("pageTitleEncode");
String pageTitle;
if (pageTitleEncode != null) {
	if ("UTF8".equals(pageTitleEncode)) {
		pageTitle = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pageTitle"));
	} else {
		pageTitle = request.getParameter("pageTitle");
	}
} else {
	pageTitle = request.getParameter("pageTitle");
}

if (pageTitle != null) {
	session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_TITLE, pageTitle);
}

String sLoginID = request.getParameter("sLoginID");
String sSource = request.getParameter("sSource");

String RemoteAddr = request.getRemoteAddr();
String contextPath = request.getContextPath();
System.out.println(new Date() + " [" + contextPath + "] (from:" + RemoteAddr + ") page_title.jsp user:" + userBean.getLoginID() + ", pageTitle=" + pageTitle);

boolean mustLogin = !"N".equals(request.getParameter("mustLogin"));
String suffix = null;
String isHideTitle = request.getParameter("isHideTitle");

if (userBean.isLogin() || !mustLogin) {
	String displayTitle = request.getParameter("displayTitle");
	String pageSubTitle = request.getParameter("pageSubTitle");
	boolean isTranslate = !"N".equals(request.getParameter("translate"));
	boolean isAccessControl = !"N".equals(request.getParameter("accessControl"));
	boolean isPageAccessable = userBean.isAccessible(pageTitle);
	String isHideHeader = request.getParameter("isHideHeader");

	if (request.getParameter("suffix") != null) {
		suffix = request.getParameter("suffix");
	} else if (pageTitle.indexOf("view") >= 0) {
		suffix = "_2";
	} else {
		suffix = "";
	}

	if (isPageAccessable || !isAccessControl || !mustLogin) {
		if (isKeepReferer && (pageCategory != null || category != null)) {
			if (!"N".equals(request.getParameter("pageMap")) && !"Y".equals(isHideTitle)) {
				if(!"Y".equals(isHideHeader)){
						%><br/><span class="reported_quote"><%
						if (pageCategory != null) {
							%><a href="../portal/general.jsp?category=<%=pageCategory %>"><%
							try {
								%><bean:message key="<%=pageCategory %>" /><%
							} catch (Exception e) {
								%><%=capitalizeFirstLetter(pageCategory) %><%
							}
							%></a><%
						} else {
							try {
								%><bean:message key="<%=category %>" /><%
							} catch (Exception e) {
								%><%=capitalizeFirstLetter(category) %><%
							}
						}
						%> -> <%
						if (displayTitle != null) {
							%><%=capitalizeFirstLetter(displayTitle) %><%
						} else {
							if (isTranslate) {
								try {
									%><bean:message key="<%=pageTitle %>" /><%
								} catch (Exception e) {
									%><%=capitalizeFirstLetter(pageTitle) %><%
								}
							} else {
								%><%=capitalizeFirstLetter(pageTitle) %><%
							}
						}
						%></span><br/><br/><%
					}
			}
			if (!ConstantsServerSide.DEBUG) {
				AccessControlDB.addAccessControlLog(userBean, pageTitle, referer, request.getRemoteAddr());
			}
		}

		if (!"Y".equals(isHideTitle)) {
%>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
<tr>
	<td>
		<h2>
			<b class="b1<%=suffix %>"></b><b class="b2<%=suffix %>"></b><b class="b3<%=suffix %>"></b><b class="b4<%=suffix %>"></b>
			<div class="contentb<%=suffix %>">
				<span class="pageTitle bigText"><%
					if (displayTitle != null) {
						%><%=capitalizeFirstLetter(displayTitle) %><%
					} else {
						if (isTranslate) {
							try {
								%><bean:message key="<%=pageTitle %>" /><%
							} catch (Exception e) {
								%><%=capitalizeFirstLetter(pageTitle) %><%
							}
						} else {
							%><%=pageTitle %><%
						}
						if (pageSubTitle != null && pageSubTitle.length() > 0) {
							%> ( <%
							try {
								%><bean:message key="<%=pageSubTitle %>" /><%
							} catch (Exception e) {
								%><%=capitalizeFirstLetter(pageSubTitle) %><%
							}
							%> )<%
						}
					}
				%></span>
			</div>
			<b class="b4<%=suffix %>"></b><b class="b3<%=suffix %>"></b><b class="b2<%=suffix %>"></b><b class="b1<%=suffix %>"></b>

		</h2>
	</td>
</tr>
</table><%
		}
	} else if (session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_REFERER) != null) {
		%><script language="javascript">parent.location.href = "../common/access_deny.jsp";</script><%
		return;
	} else {
		%><script language="javascript">parent.location.href = "../index.jsp?redirect=Y<%=sLoginID==null?"":"&sLoginID="+sLoginID %><%=sSource==null?"":"&sSource="+sSource %>";</script><%
		return;
	}
} else {
	%><script language="javascript">parent.location.href = "../portal/index.jsp?redirect=Y<%=sLoginID==null?"":"&sLoginID="+sLoginID %><%=sSource==null?"":"&sSource="+sSource %>";</script><%
	return;
}
%>