<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
String comment = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "comment"));

String message = null;
String errorMessage = null;

if (comment != null && comment.length() > 0) {
	// send email
	String userName = null;
	if (userBean.isLogin()) {
		userName = userBean.getUserName();
	} else {
		userName = "anonymous";
	}

	if (UtilMail.sendMail(
			ConstantsServerSide.MAIL_ADMIN,
			ConstantsServerSide.MAIL_ADMIN,
			"Intranet Portal (" + ConstantsServerSide.SITE_CODE + ") comment from " + userName + " (" + request.getRemoteAddr() + ")",
			comment)) {
		message = "Thank you for your comment. We will get back to you shortly!";
	} else {
		errorMessage = "Fail to send comment. Please try again later.";
	}
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<jsp:include page="../common/header.jsp"/>
<body>
<form name="form1" method="post">
<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0" align="left" valign="top">
	<tr>
		<td valign="top">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Contact Us" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="pageMap" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
			<table>
				<tr>
			 		<td colspan="2">
						<table width="100%" border="0">
							<tr class="smallText">
								<td class="infoLabel" width="30%"><bean:message key="prompt.comment" /></td>
							<td class="infoData" width="70%"><div class="box"><textarea name="comment" rows="12" cols="80"></textarea></div></td>
						</tr>
						<tr class="smallText">
							<td colspan="2">* Please leave your contact information and we will reply you as soon as possible</td>
						</tr>
						<tr class="smallText">
							<td colspan="2" align="center">
								<button onclick="javascript:submitAction();return false;"><bean:message key="button.submit" /></button>
							</td>
						</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<input type="hidden" name="category"/>
</form>
<script language="javascript">
<!--
	function submitAction() {
		document.form1.action = "../portal/contactUs.jsp";
		if (document.form1.comment.value == '') {
			alert('Please fill in comment.');
			document.form1.comment.focus;
			return false;
		}
		document.form1.submit();
		return true;
	}

	function readNews(cid, nid) {
		document.form1.action = "../portal/news_view.jsp";
		document.form1.newsCategory.value = cid;
		document.form1.newsID.value = nid;
		document.form1.submit();
		return true;
	}

	function changeUrl(aid, cid) {
		if (aid != '') {
			document.form1.action = aid;
			document.form1.category.value = cid;
			document.form1.submit();
		} else {
			alert("Under Construction");
		}
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>