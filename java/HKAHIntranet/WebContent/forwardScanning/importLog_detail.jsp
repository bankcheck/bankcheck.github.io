<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String listTablePageParaName = ParserUtil.getParameter(request, "listTablePageParaName");
String listTableCurPage = ParserUtil.getParameter(request, "listTableCurPage");

String importLogId = ParserUtil.getParameter(request, "importLogId");
String fileIndexId = ParserUtil.getParameter(request, "fileIndexId");
String encodedParams = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "encodedParams"));
String batchNo = ParserUtil.getParameter(request, "batchNo");
String description = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "description"));
String handledDesc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "handledDesc"));
String handledUser = null;
String importDate = ParserUtil.getParameter(request, "importDate");
boolean isImported = false;
boolean isHandled = "Y".equals(ParserUtil.getParameter(request, "isHandled"));

FsModelHelper helper = FsModelHelper.getInstance();

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

boolean updateAction = false;
boolean closeAction = false;
boolean refreshOpenerList = false;

if ("update".equals(command)) {
	updateAction = true;
}

try {
	if ("1".equals(step)) {
		if (updateAction) {
			boolean success = FsModelHelper.updateImportLogHandle(userBean, importLogId, isHandled, handledDesc);
				if (success) {
					message = "Handle status updated.";
					updateAction = false;
					refreshOpenerList = true;
				} else {
					errorMessage = "Handle status update fail.";
				}
				updateAction = false;
		}
		step = null;
	}
	
	// load data from database
	if (importLogId != null && importLogId.length() > 0) {
		FsImportLog fsImportLog = FsModelHelper.getFsImportLog(importLogId);
		if (fsImportLog != null) {
			importLogId = fsImportLog.getFsImportLogId() != null ? fsImportLog.getFsImportLogId().toPlainString() : null;
			fileIndexId = fsImportLog.getFsFileIndexId() != null ? fsImportLog.getFsFileIndexId().toPlainString() : null;
			batchNo = fsImportLog.getFsBatchNo() != null ? fsImportLog.getFsBatchNo().toPlainString() : null;
			encodedParams = fsImportLog.getFsEncodedParams();
			description = fsImportLog.getFsDescription();
			handledDesc = fsImportLog.getFsHandledDesc();
			importDate = DateTimeUtil.formatDateTime(fsImportLog.getFsImportDate());
			isImported = fsImportLog.isImported();
			isHandled = fsImportLog.isHandled();
		} else {
			closeAction = true;
		}
	} else {
		closeAction = true;
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html>
<jsp:include page="../common/header.jsp"/>
<style>
.highlight {
	color: blue;
}
.normal {
	color: black;
}
.matchedCat {
	font-weight: bold;
	font-size: 120%;
	color: blue;
}
</style>
<% if (refreshOpenerList) { %>
<script type="text/javascript">
if (opener && opener.document.search_form) {
	var form = opener.document.search_form;
	form.elements["<%=listTablePageParaName %>"].value = "<%=listTableCurPage %>";
	form.submit();
}
</script>
<% } %>
<% if (closeAction) { %>
<script type="text/javascript">
window.close();
</script>
<% } else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
	String commandType = null;
	if (updateAction) {
		commandType = "update";
	} else {
		commandType = "view";
	}

	// set submit label
	String title = "function.fs.importLog." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" action="importLog_detail.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%">Log ID</td>
		<td class="infoData">
			<%=importLogId == null ? "" : importLogId %>
		</td>
		<td class="infoLabel" width="15%">Batch No</td>
		<td class="infoData">
			<%=batchNo == null ? "" : batchNo %>
		</td>
		<td class="infoLabel" width="15%">Import Date</td>
		<td class="infoData">
			<%=importDate == null ? "" : importDate %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel">Import Status</td>
		<td class="infoData">
<%	if(isImported) { %>		
			<img src="<html:rewrite page="/images/tick_green_small.gif" />" alt="Success" />
			<button onclick="return submitAction('view_file', 1, '<%=fileIndexId %>');"> View Imported Entry</button>
<%  } else { %>
			<img src="<html:rewrite page="/images/cross_red_small.gif" />" alt="Fail" />
<%  } %>
		</td>
		<td class="infoLabel">Description</td>
		<td class="infoData" colspan="3">
			<%=description == null ? "" : description %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel">Handle Status</td>
		<td class="infoData" colspan="5">
<%	if (updateAction) { %>
<%		if(isHandled) { %>
			<img src="<html:rewrite page="/images/tick_amber_small.gif" />" alt="Handled" />
			<input type="hidden" name="isHandled" value="Y" />
<% 		} else { %>
			<input type="checkbox" name="isHandled" value="Y" />
<% 		} %>
			<input type="text" name="handledDesc" value="<%=handledDesc == null ? "" : handledDesc %>" maxlength="400" size="50" />
<%	} else { %>
<%		if(isHandled) { %>	
			<img src="<html:rewrite page="/images/tick_amber_small.gif" />" alt="Handled" />
<% 		} %>
			<%=handledDesc == null ? "" : handledDesc %>
<%	} %>		
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel">Import Values</td>
		<td class="infoData" colspan="5">
			<%=encodedParams == null ? "" : encodedParams %>
		</td>
	</tr>
</table>
<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
	<%	if (updateAction) { %>
				<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /></button>
				<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
	<%	} else { %>
				<%if (userBean.isAccessible("function.fs.importLog.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click">Update</button><%} %>
	<%	}  %>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="importLogId" value="<%=importLogId==null?"":importLogId %>" />
<input type="hidden" name="listTablePageParaName" value="<%=listTablePageParaName %>" />
<input type="hidden" name="listTableCurPage" value="<%=listTableCurPage %>" />
</form>
<script language="javascript">
	function submitAction(cmd, stp, keyId) {
		if (cmd == 'view_file') {
			callPopUpWindow("file_detail.jsp?command=view&fileIndexId=" + keyId);
			return false;			
		}
		
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
</html>