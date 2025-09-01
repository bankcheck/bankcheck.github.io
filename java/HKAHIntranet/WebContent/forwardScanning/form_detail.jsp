<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
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
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = true;
}

UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String moduleCode = ParserUtil.getParameter(request, "moduleCode");
String listTablePageParaName = ParserUtil.getParameter(request, "listTablePageParaName");
String listTableCurPage = ParserUtil.getParameter(request, "listTableCurPage");

String formId = ParserUtil.getParameter(request, "formId");
String formName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "formName"));
String formCode = ParserUtil.getParameter(request, "formCode");
String pattype = ParserUtil.getParameter(request, "pattype");
String section = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "section"));
String seq = ParserUtil.getParameter(request, "seq");
String categorySelect = ParserUtil.getParameter(request, "categorySelect");
String formAliasId = ParserUtil.getParameter(request, "formAliasId");
String formAlias = ParserUtil.getParameter(request, "formAlias");
String isDefault = ParserUtil.getParameter(request, "isDefault");

FsModelHelper helper = FsModelHelper.getInstance();
List<FsCategory> fsCategories = null;
FsCategory itemCategory = null;
String itemCategoryId = null;
LinkedHashMap<String, String> catBreadCrumb = null;
ArrayList formAliases = null;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean refreshOpenerList = false;
boolean updateFormAliasAction = false;
boolean insertFormAliasAction = false;
boolean deleteFormAliasAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("updateFormAlias".equals(command)) {
	updateFormAliasAction = true;
} else if ("insertFormAlias".equals(command)) {
	insertFormAliasAction = true;
} else if ("deleteFormAlias".equals(command)) {
	deleteFormAliasAction = true;
}
try {
	if ("1".equals(step)) {
		if (formCode != null) {
			formCode = formCode.trim();
		}
		if (formAlias != null) {
			formAlias = formAlias.trim();
		}
		
		if (createAction) {
			FsForm fsForm = FsModelHelper.addFsForms(userBean, formName, formCode,
					pattype, section, seq, categorySelect, isDefault);
			if (fsForm != null) {
				formId = fsForm.getFsFormId().toPlainString();
				message = "Form created.";
				createAction = false;
				refreshOpenerList = true;
			} else {
				errorMessage = "Form create fail.";
			}
			createAction = false;
		} else if (updateAction) {
			FsForm fsForm = FsModelHelper.updateFsForms(userBean, formId, formName, formCode,
					pattype, section, seq, categorySelect, isDefault);
			if (fsForm != null) {
				message = "Form updated.";
				updateAction = false;
				refreshOpenerList = true;
			} else {
				errorMessage = "Form update fail.";
			}
			updateAction = false;
		} else if (deleteAction) {
			boolean success = ForwardScanningDB.deleteFsForm(userBean, formId);
			if (success) {
				message = "Form deleted.";
				deleteAction = false;
				refreshOpenerList = true;
			} else {
				errorMessage = "Form delete fail.";
			}
			deleteAction = false;
		} else if (insertFormAliasAction) {
			if (ForwardScanningDB.addFormAlias(userBean, formId, formAlias)) {
				message = "Form alias saved.";
				insertFormAliasAction = false;
				step = null;
			} else {
				errorMessage = "Form alias save fail.";
			}
		} else if (deleteFormAliasAction) {
			if (ForwardScanningDB.deleteFormAlias(userBean, formAliasId)) {
				message = "Form alias deleted.";
				deleteFormAliasAction = false;
				step = null;
			} else {
				errorMessage = "Form alias fail.";
			}
		}
		step = null;
	}
	
	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (formId != null && formId.length() > 0) {
			FsForm fsForm = FsModelHelper.getFsForm(formId);
			if (fsForm != null) {
				formId = fsForm.getFsFormId().toPlainString();
				formCode = fsForm.getFsFormCode();
				formName = fsForm.getFsFormName();
				section = fsForm.getFsSection();
				pattype = fsForm.getFsPattype();
				seq = fsForm.getFsSeq();
				isDefault = fsForm.getFsIsDefault();
				itemCategoryId = fsForm.getFsCategoryId() != null ? fsForm.getFsCategoryId().toPlainString() : null;
				itemCategory = new FsCategory();
				itemCategory.setFsCategoryId(fsForm.getFsCategoryId());
				
				// load form aliases
				formAliases = ForwardScanningDB.getFormAliasList(formId);
				if (insertFormAliasAction && "0".equals(step)) {
					if (formAliases == null) {
						formAliases = new ArrayList();
					}
					int columnSize = 2;
					ReportableListObject rlo = new ReportableListObject(columnSize);
					for (int i = 0; i < columnSize; i++) {
						rlo.setValue(i, "");
					}
					formAliases.add(rlo);
					
					formAliasId = "";
					formAlias = "";
				}
				request.setAttribute("formAliases", formAliases);
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
	
	fsCategories = helper.getGeneralCategoryList();
	if (!createAction) 
		catBreadCrumb = FsModelHelper.getCategoryBreadCrumb(fsCategories, itemCategoryId);
	
	// == DEBUG ==
	//helper.printCategoryTree(false);
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
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
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
	String title = "function.fs.form." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" enctype="multipart/form-data" action="form_detail.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="6">Form</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="150px">Form Code</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="formCode" value="<%=formCode == null ? "" : formCode %>" maxlength="50" size="20" />
<%	} else { %>
			<%=formCode == null ? "" : formCode %>
<%	} %>
		</td>
		<td class="infoLabel" width="150px">Form Name</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="formName" value="<%=formName == null ? "" : formName %>" maxlength="200" size="80" />
<%	} else { %>
			<%=formName == null ? "" : formName %>
<%	} %>
		</td>
		<td class="infoLabel" width="150px">Is default form for empty patient type</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="hidden" name="isDefault" value="N" />
			<input type="checkbox" name="isDefault" value="Y" <%=ConstantsVariable.YES_VALUE.equals(isDefault) ? "checked=\"checked\"" : "" %>><%=ConstantsVariable.YES_VALUE %>/<%=ConstantsVariable.NO_VALUE %></input>
<%	} else { %>
			<%=ConstantsVariable.YES_VALUE.equals(isDefault) ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE %>
<%	} %>
		</td>		
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="150px">Patient Type</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<select name="pattype" id="pattype">
				<option value=""></option>
				<option value="<%=FsModelHelper.PAT_TYPE_CODE_IP %>"<%=FsModelHelper.PAT_TYPE_CODE_IP.equals(pattype) ? " selected=\"selected\"" : "" %>><%=FsModelHelper.pattypes.get(FsModelHelper.PAT_TYPE_CODE_IP) %></option>
				<option value="<%=FsModelHelper.PAT_TYPE_CODE_OP %>"<%=FsModelHelper.PAT_TYPE_CODE_OP.equals(pattype) ? " selected=\"selected\"" : "" %>><%=FsModelHelper.pattypes.get(FsModelHelper.PAT_TYPE_CODE_OP) %></option>
				<option value="<%=FsModelHelper.PAT_TYPE_CODE_DAYCASE %>"<%=FsModelHelper.PAT_TYPE_CODE_DAYCASE.equals(pattype) ? " selected=\"selected\"" : "" %>><%=FsModelHelper.pattypes.get(FsModelHelper.PAT_TYPE_CODE_DAYCASE) %></option>
			</select>
<%	} else { %>
			<%=FsModelHelper.pattypes.get(pattype) == null ? "" : FsModelHelper.pattypes.get(pattype) %>
<%	} %>
		</td>
		<td class="infoLabel" width="150px">Section</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="section" value="<%=section == null ? "" : section %>" maxlength="200" size="50" />
<%	} else { %>
			<%=section == null ? "" : section %>
<%	} %>
		</td>
		<td class="infoLabel" width="150px">Order Seq</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="seq" value="<%=seq == null ? "" : seq %>" maxlength="2" size="5" />
<%	} else { %>
			<%=seq == null ? "" : seq %>
<%	} %>
		</td>
	</tr>
	
<%	if (!createAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="150px">Form Code(s)<br />(Alias)</td>
		<td class="infoData" colspan="5">
			<table>
	<tr>
		<td colspan="2">
			<div class="pane">
				<table width="100%" border="0">
					<tr class="smallText">
						<td align="left">
<% if (userBean.isAccessible("function.fs.form.update")) { %>	
							<button onclick="return submitActionFormAlias('insertFormAlias', 0);" class="btn-click"><bean:message key="button.add" /></button>
<%	} %>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2">
<bean:define id="functionLabel">Form Code Alias List</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<% if (formAliases != null && !formAliases.isEmpty()) { %>
<display:table id="row" name="requestScope.formAliases" export="false" class="tablesorter">
<%
	String thisFormAliasId = ((ReportableListObject)pageContext.getAttribute("row")).getFields0();
	String thisFormAlias = ((ReportableListObject)pageContext.getAttribute("row")).getFields1();
	boolean isUpdate = (thisFormAliasId != null && thisFormAliasId.equals(formAliasId)) && 
			(thisFormAliasId != null && thisFormAliasId.equals(formAliasId));
%>
	<display:column title="Alias" style="width:80%">
<%			if ((insertFormAliasAction || updateFormAliasAction) && isUpdate) { %>
		<html:text property="formAlias" value="<%=thisFormAlias %>" maxlength="20" size="17" />
<%			} else {  %>
		<c:out value="${row.fields1}" />
<%			}  %>
	</display:column>
	<display:column title="Action" style="width:20%" media="html">
<%			
		if (insertFormAliasAction) {
			commandType = "insertFormAlias";
		} else if (updateFormAliasAction) {
			commandType = "updateFormAlias";
		}


		if (isUpdate && (insertFormAliasAction || updateFormAliasAction)) { %>
	<button onclick="return submitActionFormAlias('insertFormAlias', 1, '<c:out value="${row.fields0}" />', '<c:out value="${row.fields1}" />');" class="btn-click"><bean:message key="button.save" /></button>
	<button onclick="return submitActionFormAlias('cancelFormAlias', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else if (userBean.isAccessible("function.fs.form.update")) { %>
	<!-- <button onclick="return submitActionFormAlias('updateFormAlias', 0, '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.update" /></button>-->
	<button onclick="return submitActionFormAlias('deleteFormAlias', 2, '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.delete" /></button>
<%		}  %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} %>
		</td>
	</tr>
			</table>
		</td>
	</tr>
<% } %>	
	
	<tr class="smallText">
		<td class="infoLabel" width="150px">Category<br />(to which belongs)</td>
		<td class="infoData" colspan="5">
			<ul id="browser" class="filetree">
				<p style="padding: 5px; border: 1px solid grey">
<%
	if (catBreadCrumb != null) {
		Set<String> keys = catBreadCrumb.keySet();
		Iterator<String> it = keys.iterator();
		while (it.hasNext()) {
			String catId = it.next();
			String catTitle = catBreadCrumb.get(catId);
%>
	<% if (it.hasNext()) { %>
		<%=catTitle %><span style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&gt;&nbsp;</span>
	<% } else { %>
		<span class="matchedCat"><%=catTitle %></span>
	<% } %>
<%
		}
	} else if (createAction) {
%>
					Select a category below.
<%	} else { %>
					No category matched.
<%	} %>
				</p>
				<%=FsModelHelper.getFsCategoryTreeHTML(fsCategories, itemCategory, createAction || updateAction, catBreadCrumb) %>
			</ul>
		</td>
	</tr>
</table>
<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
	<%	if (createAction || updateAction || deleteAction) { %>
				<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
	<%		if (updateAction || deleteAction) { %>
				<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
	<%		} %>
	<%	} else { %>
				<%if (userBean.isAccessible("function.fs.form.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.fs.form.update" /></button><%} %>
				<%if (userBean.isAccessible("function.fs.form.delete")) { %><button class="btn-delete"><bean:message key="function.fs.form.delete" /></button><%} %>
	<%	}  %>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="formId" value="<%=formId==null?"":formId %>" />
<input type="hidden" name="formAliasId" />
<input type="hidden" name="listTablePageParaName" value="<%=listTablePageParaName %>" />
<input type="hidden" name="listTableCurPage" value="<%=listTableCurPage %>" />
</form>
<script language="javascript">
	$().ready(function(){
	});

	function submitAction(cmd, stp) {
		if (stp == 1) {
			if (cmd == 'create' || cmd == 'update') {
				if (document.form1.formCode.value == '') {
					document.form1.formCode.focus();
					alert("Please input Form Code.");
					return false;
				} else if (document.form1.formCode.value == '.') {
					document.form1.formCode.focus();
					alert('Form Code cannot be ".".');
					return false;
				}
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function submitActionFormAlias(cmd, stp, formAliasId, formAlias) {
		if (cmd == 'deleteFormAlias' && stp == 2) {
			$(".pane").animate({ backgroundColor: "#fbc7c7" }, "fast")
			.animate({ backgroundColor: "#F9F3F7" }, "slow");
			$.prompt('<bean:message key="message.record.delete" />!',{
				buttons: { Ok: true, Cancel: false },
				callback: function(v,m,f){
					if (v){
						submit: submitActionFormAlias(cmd, '1', formAliasId, formAlias);
						return true;
					} else {
						return false;
					}
				},
				prefix:'cleanblue'
			});
			return false;
		}
		
		document.forms["form1"].elements["command"].value = cmd;
		document.forms["form1"].elements["step"].value = stp;
		document.forms["form1"].elements["formAliasId"].value = formAliasId;
		document.forms["form1"].submit();
		return false;
	}
</script>

</DIV>

</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html>