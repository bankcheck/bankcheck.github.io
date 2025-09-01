<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="java.util.*"%>
<%
// store session key
String sessionKey = request.getParameter("session");
String pageNo = request.getParameter("pageNo");
int pageNoInt = 0;
try {
	pageNoInt = Integer.parseInt(pageNo);
} catch (Exception e) {
	pageNoInt = 1;
}
String language = request.getParameter("language");
if (language == null) {
	language = "eng";
}
Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else if ("eng".equals(language)) {
	locale = Locale.US;
}


String address = null;
int httpPort = 80;
String contextPath = null;
String protocol = null;
String action = null;

String label1 = null;
String label2 = null;
String label3 = null;
String label4 = null;
String label5 = null;
if (pageNoInt == 1) {
	label1 = "step1_1";
	label2 = "step1_2";
	label3 = "step1_2";
	label4 = "step1_2";
	label5 = "step1_3";
} else if (pageNoInt == 2) {
	label1 = "step2_1";
	label2 = "step2_2";
	label3 = "step1_2";
	label4 = "step1_2";
	label5 = "step1_3";
} else if (pageNoInt == 3) {
	label1 = "step3_1";
	label2 = "step3_2";
	label3 = "step2_2";
	label4 = "step1_2";
	label5 = "step1_3";
} else {
	label1 = "step3_1";
	label2 = "step3_1";
	label3 = "step3_2";
	label4 = "step2_2";
	label5 = "step1_3";
	address = request.getLocalAddr();

	if (address == null || "0.0.0.0".equals(address) || "0:0:0:0:0:0:0:1".equals(address) ) {
		address = request.getServerName();
	}
	httpPort = request.getServerPort();
	contextPath = request.getContextPath();
	protocol = "http";

	if (ConstantsServerSide.SECURE_SERVER) {
		protocol = "https";
		if (httpPort == 8080) {
			httpPort = 8443;
		} else {
			httpPort = 443;
		}
	}

	action = protocol + "://" + address + ":" + httpPort + contextPath + "/registration/admission_client_landing_vpc.jsp?sessionKey=" + sessionKey+"&language="+language;
}

// clear session and cookie
if (pageNoInt == 1) {
	UserBean userBean = new UserBean(request);
	userBean.invalidate(request, response);
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />
</jsp:include>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/registration/background.css" />" />
<body>
<jsp:include page="admission_header.jsp" flush="false" />
<center style="background-color:white;" class="wrapper">
<div class="normal_area">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<table width="700" border="0" cellpadding="0" cellspacing="0" style="background-color:white;">
<tr>
	<td align="center">
	<b class="b1"></b><b class="b2"></b><b class="b3"></b><b class="b4"></b>
		<div class="contentb">
			<table width="690" border="0" cellpadding="0" cellspacing="0" style="background-color:white;">
				<tr>
					<td colspan="2">
						<span class="admissionLabel mediumText">
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr valign="center">
									<td class="<%=label1 %>" width="25%"><p><%=MessageResources.getMessage(locale, "adm.intro.pg1.sec1") %></p></td>
									<td class="<%=label2 %>" width="20%"><p><%=MessageResources.getMessage(locale, "adm.intro.pg2.sec1") %></p></td>
									<td class="<%=label3 %>" width="20%"><p><%=MessageResources.getMessage(locale, "adm.intro.pg3.sec1") %></td>
									<td class="<%=label4 %>" width="20%"><p><%=MessageResources.getMessage(locale, "label.additionalInformation") %></p></td>
									<td class="<%=label5 %>" width="15%"><p><%=MessageResources.getMessage(locale, "prompt.enrollment") %></p></td>
								</tr>
							</table>
						</span>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td rowspan="2" width="10">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="top" align="left">
<%if (pageNoInt == 1) { %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr style="background-color:#aa0066;">
											<td colspan="3" height="25" style="background-color:#aa0066;">
												<table width="80%" border="0" align="center" cellpadding="0"
													cellspacing="0">
													<tr>
														<td class="style1"><font color="white"><strong>Please choose the language<br>請選擇語言</strong></font></td>
													</tr>
												</table>
											</td>

													<td class="style1" ><%if ("chi".equals(language)) { %><a href="intro.jsp?language=eng&session=<%=sessionKey%>"><font color="#ffffff">English</font></a><%} else {%><font color="#ffffff">English</font><%} %></td>
													<td class="style1" ><%if ("eng".equals(language)) { %><a href="intro.jsp?language=chi&session=<%=sessionKey%>"><font color="#ffffff">中文</font></a><%} else {%><font color="#ffffff">中文</font><%} %></td>
										</tr>
														<tr>
															<td rowspan="2" width="10">&nbsp;</td>
															<td>&nbsp;</td>
														</tr>
									</table>
									<p><span class="headingLabel extraBigText"><%=MessageResources.getMessage(locale, "adm.intro.pg1.sec1") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg1.sec2") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><font color="red"><%=MessageResources.getMessage(locale, "adm.intro.pg1.sec3") %></font></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
<%} else if (pageNoInt == 2) { %>
									<p><span class="headingLabel extraBigText"><%=MessageResources.getMessage(locale, "adm.intro.pg2.sec1") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg2.sec2") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg2.sec3") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg2.sec4") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
<%} else if (pageNoInt == 3) { %>
									<p><span class="headingLabel extraBigText"><%=MessageResources.getMessage(locale, "adm.intro.pg3.sec1") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg3.sec2") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg3.sec3") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg3.sec4") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg3.sec5") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg3.sec6") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg3.sec7") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg3.sec8") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg3.sec9") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>

<%} else { %>
									<p><span class="headingLabel extraBigText"><%=MessageResources.getMessage(locale, "label.additionalInformation") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg4.sec1") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg4.sec2") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg4.sec3") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg4.sec4") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg4.sec5") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.intro.pg4.sec6") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "prompt.onlinereg.admission.office") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "prompt.onlinereg.tel") %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><%=MessageResources.getMessage(locale, "adm.emailAdd") %>: <a href="mailto:hkahpsr@hkah.org.hk">hkahpsr@hkah.org.hk</a></span></p>
<%} %>
								</td>
							</tr>
							<tr>
								<td height="30">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="pane">
							<table>
								<tr class="middleText">
									<td>
										<form name="form1" action="intro.jsp" method="post">
<%	if (pageNoInt > 1) { %>
										<button onclick="pageAction('<%=pageNoInt - 1 %>');return false;" class="btn-click"><%=MessageResources.getMessage(locale, "button.page.previous") %></button>
<%	} %>
<%	if (pageNoInt < 4) { %>
										<button onclick="pageAction('<%=pageNoInt + 1 %>');return false;" class="btn-click">&nbsp;&nbsp;<%=MessageResources.getMessage(locale, "button.page.next") %>&nbsp;&nbsp;</button>
<%	} %>
										<input type="hidden" name="pageNo" />
										<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
										<input type="hidden" name="language" value="<%=language%>"/>
										</form>
									</td>
									<td>
										<form name="form2" action="<%=action %>" method="post">
<%	if (pageNoInt > 3) { %>
										<button onclick="submitAction();return false;" class="btn-click"><%=MessageResources.getMessage(locale, "adm.button.rdagree") %></button>
<%	} %>
										<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
										</form>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>
		</div>
		<b class="b4"></b><b class="b3"></b><b class="b2"></b><b class="b1"></b>
	</td>
</tr>
</table>
<div class="push"></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
</table>
</div>
</center>
<jsp:include page="admission_footer.jsp" flush="false" />

<script language="javascript">
<!--//
	function pageAction(pno) {
		document.form1.pageNo.value = pno;
		document.form1.submit();
	}

	function submitAction() {
		document.form2.submit();
	}
//-->
</script>
</body>
</html:html>