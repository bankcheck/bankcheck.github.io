<!-- Under Development -->
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
<%!
private static String getFsCategoryTree(List<FsCategory> list, FsCategory itemCategory, boolean isEditable, LinkedHashMap<String, String> catBreadCrumb) {
	if (list == null)
		return null;
	
	StringBuffer outputStr = new StringBuffer();
	
	for (int i = 0; i < list.size(); i++) {
		FsCategory category = list.get(i);
		if (category != null) {
			String categoryTitle = category.getFsName();
			List<FsCategory> children = category.getChildList();
			List<FsFileIndex> fsFileIndexes = category.getFsFileIndexes();
			FsFileIndex fsFileIndex = null;
			if (fsFileIndexes != null && fsFileIndexes.size() > 0) {
				fsFileIndex = fsFileIndexes.get(0);
			}
			
			boolean isSelected = false;
			boolean isAlongPath = false;
			String categoryId = null;
			if (category != null && category.getFsCategoryId() != null) {
				categoryId = category.getFsCategoryId().toPlainString();
				if (itemCategory != null && itemCategory.getFsCategoryId() != null) {
					isSelected = category.getFsCategoryId().equals(itemCategory.getFsCategoryId());
				}
				if (catBreadCrumb != null && catBreadCrumb.get(categoryId) != null) {
					isAlongPath = true;
				}
			}
			
			
			outputStr.append("<li class=\"" + (isAlongPath ? "open" : "closed") + (isSelected ? " highlight" : " normal") + "\">");
			outputStr.append("<span class=\"folder" + (isSelected ? " matchedCat" : "") + "\">");
			if (isEditable) {
				outputStr.append("<button onclick=\"return submitAction('delete', '" + categoryId + "');\" class=\"btn-delete\">Delete</button>");
				outputStr.append("<button onclick=\"return submitAction('view', '" + categoryId + "');\" class=\"btn-click\">Edit</button>");
				outputStr.append(categoryTitle);
			} else {
				outputStr.append(categoryTitle);
			}
			outputStr.append("</span>");
			
			if (children != null && children.size() > 0) {
				outputStr.append("<ul>");
				outputStr.append(getFsCategoryTree(children, itemCategory, isEditable, catBreadCrumb));
				outputStr.append("</ul>");
			}
			
			outputStr.append("</li>");
		}
	}
	
	return outputStr.toString();
}

private static LinkedHashMap<String, String> getCategoryBreadCrumb(List<FsCategory> list, String itemCategoryId) {
	for (int i = 0; i < list.size(); i++) {
		FsCategory category = list.get(i);
		LinkedHashMap<String, String> ret = matchCategory(category, itemCategoryId);
		if (ret != null)
			return ret;
	}
	return null;
}

private static LinkedHashMap<String, String> matchCategory(FsCategory category, String itemCategoryId) {
	if (itemCategoryId == null)
		return null;
	
	String thisCatId = category.getFsCategoryId().toPlainString();
	String thisCatTitle = category.getFsName();
	if (itemCategoryId.equals(thisCatId)) {
		LinkedHashMap<String, String> ret = new LinkedHashMap<String, String>();
		ret.put(thisCatId, thisCatTitle);
		return ret;
	} else {
		List<FsCategory> children = category.getChildList();
		LinkedHashMap<String, String> ret = null;
		for (int i = 0; i < children.size(); i++) {
			FsCategory child = children.get(i);
			LinkedHashMap<String, String> childRet = matchCategory(child, itemCategoryId);
			if (childRet != null) {
				ret = new LinkedHashMap<String, String>();
				ret.put(thisCatId, thisCatTitle);
				ret.putAll(childRet);
				return ret;
			}
		}
	}
	return null;
}
%>
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

String categorySelect = ParserUtil.getParameter(request, "categorySelect");

FsModelHelper helper = FsModelHelper.getInstance();
List<FsCategory> fsCategories = null;
FsCategory itemCategory = null;
String itemCategoryId = null;
LinkedHashMap<String, String> catBreadCrumb = null;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}
try {
	if ("1".equals(step)) {
		if (createAction) {
			// message = "File index created.";
			message = "Function under development.";
			createAction = false;
		} else if (updateAction) {
			// message = "File index updated.";
			message = "Function under development.";
			updateAction = false;
		} else if (deleteAction) {
			// message = "File index deleted.";
			message = "Function under development.";
			deleteAction = false;
		}
		step = null;
	}
	
	// load data from database
	if (!createAction && !"1".equals(step)) {
		message = "Function under development.";
	}
	
	
	fsCategories = helper.getGeneralCategoryList();
	if (!createAction) 
		catBreadCrumb = getCategoryBreadCrumb(fsCategories, itemCategoryId);
	//helper.printCategoryTree(fsCategories, 0);
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
	String title = "function.fs." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" enctype="multipart/form-data" action="category.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="150px">Category</td>
		<td class="infoData" colspan="5">
			<ul id="browser" class="filetree">
				<%=getFsCategoryTree(fsCategories, itemCategory, createAction || updateAction, catBreadCrumb) %>
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
				<%if (userBean.isAccessible("function.fs.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.fs.update" /></button><%} %>
				<%if (userBean.isAccessible("function.fs.delete")) { %><button class="btn-delete"><bean:message key="function.fs.delete" /></button><%} %>
	<%	}  %>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
</form>
<script language="javascript">
	$().ready(function(){
	});

	function submitAction(cmd, stp) {
		if (stp == 1) {
			if (cmd == 'create' || cmd == 'update') {
				if (document.form1.patno.value == '') {
					document.form1.patno.focus();
					alert("Please input Patient No.");
					return false;
				}
				if (document.form1.regId.value == '') {
					document.form1.regId.focus();
					alert("Please input Reg. Id.");
					return false;
				}
			}
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