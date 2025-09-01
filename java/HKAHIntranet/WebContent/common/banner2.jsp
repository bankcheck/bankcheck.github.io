<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
// set default locale
MessageResources.getMessage(session, "prompt.loginPage");

UserBean userBean = new UserBean(request);

String userInfo = null;
if (userBean.isLogin()) {
	if (userBean.isAdmin()) {
		userInfo = userBean.getLoginID();
	} else {
		userInfo = userBean.getUserName() + " (" + userBean.getUserGroupDesc() + (userBean.getDeptDesc() == null || "".equals(userBean.getDeptDesc())?"":"@" + userBean.getDeptDesc()) + ")";
	}
} else {
	userInfo = "";
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
<DIV id=titleHeader>
<table width="100%" height="20">
	<tr>
		<td nowrap><bean:message key="message.welcome" arg0="<%=userInfo %>" /></td>
		<td align="right" nowrap><html:img page="/images/running_task.gif" styleId="status"/></td>
	</tr>
</table>
</DIV>
<script language="javascript">
<!--
	function isIE() {
		  var myNav = navigator.userAgent.toLowerCase();
		  var ret = (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
		  return ret;
	}

	function isChrome() {
		var isChromium = window.chrome,
			winNav = window.navigator,
			vendorName = winNav.vendor,
			isOpera = winNav.userAgent.indexOf("OPR") > -1,
			isIEedge = winNav.userAgent.indexOf("Edge") > -1,
			isIOSChrome = winNav.userAgent.match("CriOS");

		if (isIOSChrome) {
			return true;
		} else if (isChromium !== null && isChromium !== undefined && vendorName === "Google Inc." && isOpera == false && isIEedge == false) {
			return true;
		} else {
			return false;
		}
	}
-->
</script>