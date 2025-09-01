<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
// get infomation from userbean
UserBean userBean = new UserBean(request);
String moduleCode = "main";
String moduleUserID = null;
String displayTitle = null;
String pageTitle = "function.hats." + moduleCode;
String hatSite = request.getParameter("hatSite");
String hatUrl = null;

String hatMCode = null;
String sessionID = session.getId();
if ("hkprodhats".equals(hatSite)) {
	hatMCode = "hats.prod.hkah";
	hatUrl = "160.100.3.22:9080/HKAHNHS_PROD";
	sessionID += ":3:22:HKP";
} else if ("hkuathats".equals(hatSite)) {
	hatMCode = "hats.uat.hkah";
	hatUrl = "160.100.2.73:9080/HKAHNHS_UAT";
	sessionID += ":2:73:HKU";
} else if ("twprodhats".equals(hatSite)) {
	hatMCode = "hats.prod.twah";
	hatUrl = "192.168.0.244:9080/TWAHNHS_PROD";
	sessionID += ":0:244:TWP";
} else if ("twuathats".equals(hatSite)) {
	hatMCode = "hats.uat.twah";
	hatUrl = "160.100.2.73:9080/TWAHNHS_UAT";
	sessionID += ":2:73:TWU";
} else if ("amcprodhats".equals(hatSite)) {
	hatMCode = "hats.prod.amc";
	hatUrl = "192.168.1.100/AMCNHS_PROD";
	sessionID += ":1.100:AMCP";
} else if ("amcuathats".equals(hatSite)) {
	hatMCode = "hats.uat.amc";
	hatUrl = "192.168.1.100/AMCNHS_UAT";
	sessionID += ":1.100:AMCU";
} else {
	hatMCode = hatSite;
}
ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListSEED("SELECT MODULE_USER_ID FROM SSO_USER_MAPPING WHERE MODULE_CODE = ? AND SSO_USER_ID = ? AND ENABLED = 1", new String[] { hatMCode, userBean.getStaffID() });
ReportableListObject row = null;
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	moduleUserID = row.getValue(0);

	record = UtilDBWeb.getReportableListSEED("SELECT COUNT(1) FROM SSO_SESSION WHERE SESSION_ID = ? AND USER_ID = ? AND MODULE_CODE = ?", new String[] { sessionID, moduleUserID, hatMCode });
	if (record.size() == 0) {
		UtilDBWeb.updateQueue("INSERT INTO SSO_SESSION (SESSION_ID, USER_ID, MODULE_CODE, IP_ADDRESS) VALUE (?, ?, ?, ?)", new String[] { sessionID, moduleUserID, hatMCode, request.getRemoteAddr() });
	}
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
<body style="zoom: 1">
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
<input name="moduleCode" type="hidden" value="<%=moduleCode%>"/>
<input name="moduleUserID" type="hidden" value="<%=moduleUserID%>"/>
<input name="siteCode" type="hidden" value="<%=ConstantsServerSide.SITE_CODE.toUpperCase()%>"/>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr>
		<td>
<%	if (hatUrl != null) { %>
			<table class="tablesorter">
				<tr><td align="center"><input type="button" value="Portal HATS" onclick="go2HATS('')"></input></td></tr>
				<tr><td align="center"><input type="button" value="Access HATS" onclick="go2HATS('-access')"></input></td></tr>
				<tr><td align="center"><input type="button" value="Black HATS" onclick="go2HATS('-black')"></input></td></tr>
				<tr><td align="center"><input type="button" value="Dark Gray HATS" onclick="go2HATS('-darkgray')"></input></td></tr>
				<tr><td align="center"><input type="button" value="Olive HATS" onclick="go2HATS('-olive')"></input></td></tr>
				<tr><td align="center"><input type="button" value="Purple HATS" onclick="go2HATS('-purple')"></input></td></tr>
				<tr><td align="center"><input type="button" value="Slate HATS" onclick="go2HATS('-slate')"></input></td></tr>
				<tr><td align="center"><input type="button" value="Slickness HATS" onclick="go2HATS('-slickness')"></input></td></tr>
				<tr><td align="center"><input type="button" value="Current HATS" onclick="go2HATS('-win2k')"></input></td></tr>
			</table>
<%	} %>
		</td>
	</tr>
</table>
</div>
</div>
</div>
<script type="text/javascript">
	function go2HATS(theme) {
		window.open("http://<%=hatUrl %>/HKAHNHS" + theme + ".html?rt=HKAHNHS&moduleCode="+$('input[name=moduleCode]').val()+"&siteCode="+$('input[name=siteCode]').val()+"&sessionID=<%=sessionID %>&ssoModuleCode=<%=hatMCode %>&userID="+$('input[name=moduleUserID]').val(), "_self");
	}
</script>
<%} else { %>
<script language="javascript">parent.location.href = "../common/access_deny.jsp";</script>
<%}%>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>