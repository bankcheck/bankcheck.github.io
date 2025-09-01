<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.math.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.displaytag.tags.*"%>
<%@ page import="org.displaytag.util.*"%>
<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String listTablePageParaName = (new ParamEncoder("row").encodeParameterName(TableTagParameters.PARAMETER_PAGE));
String listTableCurPage = request.getParameter(listTablePageParaName);

String formName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "formName"));
String formCode = ParserUtil.getParameter(request, "formCode");
String pattype = ParserUtil.getParameter(request, "pattype");
String section = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "section"));
String fsSeq = ParserUtil.getParameter(request, "fsSeq");
String categorySelect = ParserUtil.getParameter(request, "categorySelect");

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

String listLabel = "function.fs.form.list";

boolean deleteAction = false;
if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		if (deleteAction) {
			// boolean success = ForwardScanningDB.deleteFsFile(userBean, keyId);
			boolean success = false;
			if (success) {
				message = "Record is deleted.";
			} else {
				errorMessage = "Record delete fail.";
			}
			deleteAction = false;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

List<FsForm> form_list = FsModelHelper.searchFsForm(formName, formCode,
		pattype, section, fsSeq, formCode, null);
request.setAttribute("form_list", form_list);

FsModelHelper helper = FsModelHelper.getInstance();
List<FsCategory> fsCategories = helper.getGeneralCategoryList();
FsCategory itemCategory = new FsCategory();
BigDecimal fsCategoryId = null;
try {
	fsCategoryId = new BigDecimal(categorySelect);
} catch (Exception ex) { }
itemCategory.setFsCategoryId(fsCategoryId);

LinkedHashMap<String, String> catBreadCrumb = FsModelHelper.getCategoryBreadCrumb(fsCategories, categorySelect);
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame style="min-height:0px;">
<jsp:include page="../common/page_title.jsp">
	<jsp:param name="pageTitle" value="<%= listLabel %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<jsp:include page="back.jsp" flush="false" />
<form name="search_form" action="form_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
		<tr class="smallText">
			<td class="infoLabel" width="30%">Patient Type</td>
			<td class="infoData" width="70%">
				<select name="pattype" id="pattype">
					<option value=""></option>
					<option value="I"<%="I".equals(pattype) ? " selected=\"selected\"" : "" %>>In-Patient (I)</option>
					<option value="O"<%="O".equals(pattype) ? " selected=\"selected\"" : "" %>>Out-Patient (O)</option>
					<option value="D"<%="D".equals(pattype) ? " selected=\"selected\"" : "" %>>Day Case (D)</option>
				</select>
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel" width="30%">Form Code</td>
			<td class="infoData" width="70%"><input type="text" name="formCode" id="formCode" value="<%=formCode == null ? "" : formCode %>" maxlength="20" size="20" /></td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel" width="30%">Form Name</td>
			<td class="infoData" width="70%"><input type="text" name="formName" id="formName" value="<%=formName == null ? "" : formName %>" maxlength="200" size="100" /></td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel" width="30%">Section</td>
			<td class="infoData" width="70%"><input type="text" name="section" id="section" value="<%=section == null ? "" : section %>" maxlength="400" size="100" /></td>
		</tr>
		<!-- add category input -->
		<tr class="smallText">
			<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
			</td>
		</tr>
	</table>
	<input type="hidden" name="<%=listTablePageParaName %>" />
</form>
<bean:define id="functionLabel"><bean:message key="<%=listLabel %>" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="form_list.jsp" method="post">
<% if (form_list != null && !form_list.isEmpty()) { %>
	<display:table id="row" name="requestScope.form_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter"
			decorator="com.hkah.web.displaytag.ForwardScanningDecorator">
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column property="fsFormCode" title="Form Code" style="width:10%" />
		<display:column property="fsFormName" title="Form Name" style="width:30%" />
		<display:column property="fsPattype" title="Pat. Type" style="width:5%" />
		<display:column property="fsSection" title="Section" style="width:20%" />
	<%
		FsForm thisFsForm = ((FsForm) pageContext.getAttribute("row"));
		String recordId = thisFsForm.getFsFormId() != null ? thisFsForm.getFsFormId().toPlainString() : null;
	%>
		<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
<% if (userBean.isAccessible("function.fs.form.view")) { %>				
			<button onclick="return submitAction('view', 1, '<%=recordId %>');"><bean:message key='button.view' /></button>
<%	} %>		
			<!-- <button onclick="return submitAction('delete', 1, <%=recordId %>);" class="btn-click"><bean:message key="button.delete" /></button> -->
		</display:column>
		<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>" />
	</display:table>
<%	} %>
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
<% if (userBean.isAccessible("function.fs.form.create")) { %>			
			<button onclick="return submitAction('create', 0, '');"><bean:message key="button.create" /></button>
			</td>
<%	} %>
		</tr>
	</table>
	<input type="hidden" name="command" />
	<input type="hidden" name="step" />
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.formCode.value = "";
		document.search_form.formName.value = "";
		document.search_form.section.value = "";
		document.search_form.pattype.value = "";
		return false;
	}

	function submitAction(cmd, step, keyId) {
		if (cmd == 'delete') {
			document.form1.command.value = cmd;
			document.form1.step.value = step;
			document.form1.keyId.value = keyId;
			document.form1.submit();
			return true;
		} else {
			callPopUpWindow("form_detail.jsp?command=" + cmd + "&formId=" + keyId + "&listTablePageParaName=<%=listTablePageParaName %>" + "&listTableCurPage=<%=listTableCurPage %>");
			return false;
		}
	}
</script></DIV>

</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>