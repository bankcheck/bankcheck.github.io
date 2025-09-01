<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
// get infomation from userbean
UserBean userBean = new UserBean(request);
String moduleCode = "main";
String moduleUserID = null;
String moduleUserName = null;
String displayTitle = null;
String pageTitle = "function.hats." + moduleCode;
String hatSite = request.getParameter("hatSite");
String hatUrl = null;

String hatMCode = null;
String sessionID = null;

int randomno = 0;
long timestamp = (new Date()).getTime();
int seq = 1;

if ("hkprodhats".equals(hatSite)) {
	hatMCode = "hats.prod.hkah";
} else if ("hkuathats".equals(hatSite)) {
	hatMCode = "hats.uat.hkah";
} else if ("twprodhats".equals(hatSite)) {
	hatMCode = "hats.prod.twah";
} else if ("twuathats".equals(hatSite)) {
	hatMCode = "hats.uat.twah";
} else if ("amcprodhats".equals(hatSite)) {
	hatMCode = "hats.prod.amc";
} else if ("amc1prodhats".equals(hatSite)) {
	hatMCode = "hats.prod.amc1";
} else if ("amc2prodhats".equals(hatSite)) {
	hatMCode = "hats.prod.amc2";	
} else if ("amcuathats".equals(hatSite)) {
	hatMCode = "hats.uat.amc";
} else if ("amc1uathats".equals(hatSite)) {
	hatMCode = "hats.uat.amc1";
} else if ("amc2uathats".equals(hatSite)) {
	hatMCode = "hats.uat.amc2";
}

if (hatMCode != null) {
	ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListSEED("SELECT MODULE_USER_ID, SESSION_KEY, URL, SUM(NUM) FROM ( SELECT M.MODULE_USER_ID, U.SESSION_KEY, U.URL, COUNT(1) NUM FROM SSO_USER_MAPPING M INNER JOIN SSO_MODULE_URL U ON M.MODULE_CODE = U.MODULE_CODE AND M.ENABLED = U.ENABLED INNER JOIN SSO_SESSION S ON M.MODULE_CODE = S.MODULE_CODE AND S.SESSION_ID LIKE '%' || U.SESSION_KEY || '%' WHERE M.MODULE_CODE = ? AND M.SSO_USER_ID = ? AND M.ENABLED = 1 AND S.TIMESTAMP_UPDATE > SYSDATE - 1/144 AND S.TIMESTAMP_UPDATE IS NOT NULL GROUP BY M.MODULE_USER_ID, U.SESSION_KEY, U.URL UNION SELECT M.MODULE_USER_ID, U.SESSION_KEY, U.URL, 0 NUM FROM SSO_USER_MAPPING M INNER JOIN SSO_MODULE_URL U ON M.MODULE_CODE = U.MODULE_CODE AND M.ENABLED = U.ENABLED WHERE M.MODULE_CODE = ? AND M.SSO_USER_ID = ? AND M.ENABLED = 1 GROUP BY M.MODULE_USER_ID, U.SESSION_KEY, U.URL ) GROUP BY MODULE_USER_ID, SESSION_KEY, URL ORDER BY SUM(NUM)", new String[] { hatMCode, userBean.getStaffID(), hatMCode, userBean.getStaffID() });
	ReportableListObject row = null;
	if (record.size() > 0) {
//		randomno = (new Random()).nextInt(record.size());
		row = (ReportableListObject) record.get(randomno);
		moduleUserID = row.getValue(0);
		sessionID = row.getValue(1);
		hatUrl = row.getValue(2);

		if (moduleUserID != null) {
			record = UtilDBWeb.getReportableListHATS("SELECT UsrName FROM USR WHERE UsrID = ? AND UsrSts = -1", new String[] { moduleUserID });
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				moduleUserName = row.getValue(0);

				// for assigned server
				record = UtilDBWeb.getReportableListSEED("SELECT SESSION_KEY, URL FROM SSO_MODULE_URL_BY_IP WHERE MODULE_CODE = ? AND IP_ADDRESS = ? AND ENABLED = 1", new String[] { hatMCode, request.getRemoteAddr() });
				if (record.size() > 0) {
					row = (ReportableListObject) record.get(0);
					sessionID = row.getValue(0);
					hatUrl = row.getValue(1);
				}

				sessionID = session.getId() + ":" + sessionID + seq + ":" + timestamp;

				UtilDBWeb.updateQueueSEED("INSERT INTO SSO_SESSION (SESSION_ID, USER_ID, MODULE_CODE, IP_ADDRESS) VALUES (?, ?, ?, ?)", new String[] { sessionID, moduleUserID, hatMCode, request.getRemoteAddr() });
			} else {
				moduleUserID = null;
			}
		}
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
	<jsp:param name="isHideHeader" value="Y" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="accessControl" value="N" />
</jsp:include>
<input name="moduleCode" type="hidden" value="<%=moduleCode%>"/>
<input name="moduleUserID" type="hidden" value="<%=moduleUserID%>"/>
<input name="siteCode" type="hidden" value="<%=ConstantsServerSide.SITE_CODE.toUpperCase()%>"/>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr>
		<td>
<%	if (hatUrl != null) { %>
		<script type="text/javascript">
			function logOffAndOpenNHS(path, params, method) {
				method = method || "post"; // Set method to post by default, if not specified.

				// The rest of this code assumes you are not using a library.
				// It can be made less wordy if you use one.
				var form = document.createElement("form");
				form.setAttribute("method", method);
				form.setAttribute("action", path);

				for(var key in params) {
					var hiddenField = document.createElement("input");
					hiddenField.setAttribute("type", "hidden");
					hiddenField.setAttribute("name", key);
					hiddenField.setAttribute("value", params[key]);

					form.appendChild(hiddenField);
				}

				document.body.appendChild(form);    // Not entirely sure if this is necessary
				form.submit();
			}

			var url = "http://<%=hatUrl %>";
			if (isChrome()) {
				url = url + "-chrome";
			}
			url = url + ".html?rt=HKAHNHS&moduleCode="+$('input[name=moduleCode]').val()
				+"&siteCode="+$('input[name=siteCode]').val()
				+"&sessionID=<%=sessionID %>"
				+"&ssoSessionID=<%=sessionID %>"
				+"&ssoModuleCode=<%=hatMCode %>"
				+"&ssoUserID=<%=userBean.getStaffID() %>"
				+"&userID="+$('input[name=moduleUserID]').val()
				+"&localip=<%=request.getRemoteAddr() %>";

			if (isIE()) {
<%		if (ConstantsServerSide.isTWAH() && "medical".equals(userBean.getLoginID())) { %>
				window.open(url, "_self");
<%		} else { %>
				logOffAndOpenNHS('/intranet/Logoff.do', { mode: "redirect", rdURL: url });
<%		} %>
				//window.open("/intranet/Logoff.do?mode=redirect&rdURL="+url,'_self');
			} else if (isChrome()) {
//				alert("Hospital Administration And Tracking System (HATS):\n"+
//					"Chrome browser is not compatible to Hospital standard. "+
//					"Some HATS features may not work properly. Please contact IT support.");

				logOffAndOpenNHS('/intranet/Logoff.do', { mode: "redirect", rdURL: url });
			} else {
//				alert("Hospital Administration And Tracking System (HATS):\n"+
//					"This web browser is not compatible to Hospital standard. "+
//					"Some HATS features may not work properly. Please contact IT support.");

				window.open("../common/close.jsp", "_self");
//				window.open("../common/browserInvalid.jsp?messageType=HATS", "_self");
			}
		</script>
<%	} %>
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