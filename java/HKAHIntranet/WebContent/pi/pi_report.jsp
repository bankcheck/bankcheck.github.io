<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>
<%
UserBean userBean = new UserBean(request);
String pirID = null;
String rptSts = null;
ReportableListObject rowRtn = null;
Boolean IsPIManager = PiReportDB.IsPIManager(userBean.getStaffID());
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body style="width:100%">
	<DIV id=indexWrapper>
		<DIV id=mainFrame>
			<DIV id=contentFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.pi.report.list" />
					<jsp:param name="keepReferer" value="Y" />
					<jsp:param name="accessControl" value="Y"/>
				</jsp:include>
				<bean:define id="functionLabel"><bean:message key="function.pi.report.list" /></bean:define>
				<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
				<form method="post">

				</form>

				<%
				if (IsPIManager) {
				%>
					<button onclick="return submitAction('pirpt1', '');">Report 1 </button>
					<button onclick="return submitAction('pirpt2', '');">Report 2 </button>
				<%
				}
				%>
				<script language="javascript">

				</script>
			</DIV>
		</DIV>
	</DIV>
	<jsp:include page="../common/footer.jsp" flush="false" />
</body>


<script language="javascript">
	function submitAction(cmd, pirid) {
		if(cmd == 'create'){
			callPopUpWindow('incident_report2.jsp');

		}
	}
</script>

</html:html>				