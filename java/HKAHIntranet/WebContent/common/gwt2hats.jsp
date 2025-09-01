<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
// get infomation from userbean
UserBean userBean = new UserBean(request);
String moduleCode = request.getParameter("moduleCode");
String patno = request.getParameter("patno");
String moduleUserID = null;
String displayTitle = null;
String pageTitle = "function.hats." + moduleCode;

ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListSEED("SELECT MODULE_USER_ID FROM SSO_USER_MAPPING WHERE MODULE_CODE = 'hats' AND SSO_USER_ID = ? AND ENABLED = 1", new String[] { userBean.getStaffID() });
ReportableListObject row = null;
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	moduleUserID = row.getValue(0);
}

StringBuffer sb = new StringBuffer();
if (moduleCode != null) {
	int index = moduleCode.indexOf(".");
	if (index >= 0) {
		try {
			sb.append(moduleCode.substring(0, 1).toUpperCase());
			sb.append(moduleCode.substring(1, index));
			sb.append(" ");
			sb.append(moduleCode.substring(index + 1, index + 2).toUpperCase());
			sb.append(moduleCode.substring(index + 2));
		} catch (Exception e) {
			sb.append(moduleCode);
		}
	} else {
		sb.append(moduleCode.substring(0, 1).toUpperCase());
		sb.append(moduleCode.substring(1));
	}
}
sb.append(" (Login As ");
sb.append(moduleUserID);
sb.append(")");

displayTitle = sb.toString();
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<%if (moduleUserID != null) { %>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="displayTitle" value="<%=displayTitle %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr>
		<td>
			<IFRAME src="http://160.100.3.24/HKAHHats/HKAHNHS.html?moduleCode=<%=moduleCode %>&userID=<%=moduleUserID %>&patno=<%=patno %>" width="850" height="650" scrolling="auto" frameborder="1">
				Your user agent does not support frames or is currently configured not to display frames.
			</IFRAME>
		</td>
	</tr>
</table>
</div>
</div>
</div>
<%} else { %>
<script language="javascript">parent.location.href = "../common/access_deny.jsp";</script>
<%}%>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>