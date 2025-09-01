<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

String command = request.getParameter("command");
String step = request.getParameter("step");
String campaignID = request.getParameter("campaignID");
String siteCode = request.getParameter("siteCode");
String campaignDesc = request.getParameter("campaignDesc");
String campaignStatus = request.getParameter("campaignStatus");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		if ((createAction || updateAction) && (campaignDesc == null || campaignDesc.length() == 0)) {
			errorMessage = MessageResources.getMessage(session, "error.campaign.required");
			step = "0";
		} else if (createAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT MAX(CRM_CAMPAIGN_ID) + 1 FROM CRM_CAMPAIGN");
			
			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				campaignID = row.getValue(0);
				
				// set 1 for initial
				if(campaignID == null || campaignID.length() == 0){
					campaignID = "1";
				}
			}
			sqlStr.setLength(0);
			sqlStr.append("INSERT INTO CRM_CAMPAIGN ");
			sqlStr.append("(CRM_CAMPAIGN_ID, CRM_SITE_CODE, CRM_CAMPAIGN_DESC, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ");
			sqlStr.append("(?, ?, ?, ?, ?)");

			
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { campaignID, siteCode, campaignDesc, loginID, loginID} )) {
				message = "campaign created.";
				createAction = false;
			} else {
				errorMessage = "campaign create fail.";
			}
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_CAMPAIGN ");
			sqlStr.append("SET    CRM_SITE_CODE = ?, CRM_CAMPAIGN_DESC = ?, ");
			sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ?, CRM_ENABLED = ? ");
			sqlStr.append("WHERE    CRM_CAMPAIGN_ID = ?");
			
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { siteCode, campaignDesc, loginID, campaignStatus, campaignID } )) {
				message = "campaign updated.";
				updateAction = false;
			} else {
				errorMessage = "campaign update fail.";
			}
		} 
	} else if (createAction) {
		//siteCode = ConstantsServerSide.SITE_CODE;
		siteCode = ConstantsServerSide.SITE_CODE_TWAH;
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (campaignID != null && campaignID.length() > 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT CRM_SITE_CODE, CRM_CAMPAIGN_DESC, CRM_ENABLED ");
			sqlStr.append("FROM   CRM_CAMPAIGN ");
			sqlStr.append("WHERE  CRM_CAMPAIGN_ID = ?");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { campaignID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				siteCode = row.getValue(0);
				campaignDesc = row.getValue(1);
				campaignStatus = row.getValue(2);
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
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
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.campaign." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="campaign.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.site" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
<jsp:include page="../ui/siteCodeRDB.jsp" flush="false">
	<jsp:param name="allowAll" value="N" />
	<jsp:param name="siteCode" value="<%=siteCode %>" />
</jsp:include>
<%	} else { %>
			<%=siteCode==null?"N/A":siteCode.toUpperCase() %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.description" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="campaignDesc" value="<%=campaignDesc==null?"":campaignDesc %>" maxlength="100" size="50">
<%	} else { %>
			<%=campaignDesc==null?"":campaignDesc %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="70%">
<%
	if (createAction || updateAction) {
%>
			<input type="radio" name="campaignStatus" value="1"<%="1".equals(campaignStatus) || createAction ?" checked":"" %>>Active 
			<input type="radio" name="campaignStatus" value="0"<%="0".equals(campaignStatus)?" checked":"" %>>Inactive
<%	} else {%>
		<%="1".equals(campaignStatus)?"Active":"Inactive" %>
<%	} %>
	</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.campaign.update" /></button>
			<button class="btn-click" onclick="return window.close();"><bean:message key="button.close" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="" />
<input type="hidden" name="step" value="" />
<input type="hidden" name="campaignID" value="<%=campaignID %>">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.campaignDesc.value == '') {
				alert("<bean:message key="error.campaign.required" />.");
				document.form1.campaignDesc.focus();
				return false;
			}
		}
<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>