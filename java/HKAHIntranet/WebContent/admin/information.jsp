<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> fetchStaffByFunctionID(String function_id) {
		StringBuffer sb = new StringBuffer();
		sb.append("select co_department_desc, co_staffname, co_staff_id ");
		sb.append("from (select d.co_department_desc, s.co_staffname, s.co_staff_id ");
		sb.append("from ac_function_access a ");
		sb.append("inner join co_staffs s on a.ac_site_code = s.co_site_code and a.ac_staff_id = s.co_staff_id and s.co_enabled = 1 ");
		sb.append("left join co_departments d on s.co_department_code = d.co_department_code ");
		sb.append("where ac_function_id = ? ");
		sb.append("and ac_enabled = 1 ");
		sb.append("union ");
		sb.append("select d.co_department_desc, s.co_staffname, s.co_staff_id ");
		sb.append("from ac_function_access a ");
		sb.append("inner join ac_user_groups g on a.ac_group_id = g.ac_group_id and g.ac_enabled = 1 ");
		sb.append("inner join co_staffs s on g.ac_site_code = s.co_site_code and g.ac_staff_id = s.co_staff_id and s.co_enabled = 1 ");
		sb.append("left join co_departments d on s.co_department_code = d.co_department_code ");
		sb.append("where a.ac_function_id = ? ");
		sb.append("and a.ac_enabled = 1) ");
		sb.append("order by co_department_desc, co_staffname, co_staff_id ");

		return UtilDBWeb.getReportableList(sb.toString(), new String[] { function_id, function_id });
	}

	private ArrayList<ReportableListObject> fetchStaffByDocumentID(String document_id) {
		StringBuffer sb = new StringBuffer();
		sb.append("select co_department_desc, co_staffname, co_staff_id ");
		sb.append("from (select d.co_department_desc, s.co_staffname, s.co_staff_id ");
		sb.append("from ac_document_access a ");
		sb.append("inner join co_staffs s on a.ac_site_code = s.co_site_code and a.ac_staff_id = s.co_staff_id and s.co_enabled = 1 ");
		sb.append("left join co_departments d on s.co_department_code = d.co_department_code ");
		sb.append("where ac_document_id = ? ");
		sb.append("and ac_enabled = 1 ");
		sb.append("union ");
		sb.append("select d.co_department_desc, s.co_staffname, s.co_staff_id ");
		sb.append("from ac_document_access a ");
		sb.append("inner join ac_user_groups g on a.ac_group_id = g.ac_group_id and g.ac_enabled = 1 ");
		sb.append("inner join co_staffs s on g.ac_site_code = s.co_site_code and g.ac_staff_id = s.co_staff_id and s.co_enabled = 1 ");
		sb.append("left join co_departments d on s.co_department_code = d.co_department_code ");
		sb.append("where a.ac_document_id = ? ");
		sb.append("and a.ac_enabled = 1) ");
		sb.append("order by co_department_desc, co_staffname, co_staff_id ");

		return UtilDBWeb.getReportableList(sb.toString(), new String[] { document_id, document_id });
	}

	private boolean isExistInProgram(UserBean userBean, String function_id, String staffID) {
		return UtilDBWeb.isExist("select 1 from ac_function_access where ac_function_id = ? and ac_site_code = ? and ac_staff_id = ?",
			new String[] { function_id, getStaffSiteCode(staffID), staffID } );
	}

	private boolean isExistInDocument(UserBean userBean, String document_id, String staffID) {
		return UtilDBWeb.isExist("select 1 from ac_document_access where ac_document_id = ? and ac_site_code = ? and ac_staff_id = ?",
			new String[] { document_id, getStaffSiteCode(staffID), staffID } );
	}

	private boolean isExistMoreThanOneInProgram(UserBean userBean, String function_id, String staffID) {
		return UtilDBWeb.isExist("select 1 from ac_user_groups where ac_group_id in (select ac_group_id from ac_function_access where ac_function_id = ? and ac_group_id != 'ALL') and ac_site_code = ? and ac_staff_id = ?",
				new String[] { function_id, getStaffSiteCode(staffID), staffID } );
	}

	private boolean isExistMoreThanOneInDocument(UserBean userBean, String document_id, String staffID) {
		return UtilDBWeb.isExist("select 1 from ac_document_access where ac_group_id in (select ac_group_id from ac_document_access where ac_document_id = ? and ac_group_id != 'ALL') and ac_site_code = ? and ac_staff_id = ?",
				new String[] { document_id, getStaffSiteCode(staffID), staffID } );
	}
	
	private String getStaffSiteCode(String staffID) {
		String siteCode = null;
		ArrayList record = UtilDBWeb.getReportableList("select co_site_code from co_staffs where co_staff_id = ?", new String[]{staffID});
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			siteCode = row.getValue(0);
		}
		return siteCode;
	}

	private boolean addRight(HttpServletResponse response, UserBean userBean, String infoType, String function_id, String document_id, String staffID) throws IOException {
		PrintWriter out = response.getWriter();
		UtilDBWeb.getReportableList("select co_site_code from co_staffs where co_staff_id = ?", new String[]{staffID});
		String staffSiteCode = getStaffSiteCode(staffID);
		if ("PROGRAM".equals(infoType)) {
			if (isExistInProgram(userBean, function_id, staffID)) {
				return UtilDBWeb.updateQueue(
					"update ac_function_access set ac_enabled = 1, ac_modified_date = sysdate, ac_modified_user = ? where ac_function_id = ? and ac_site_code = ? and ac_staff_id = ?",
					new String[] { userBean.getStaffID(), function_id, staffSiteCode, staffID } );
			} else {
				return UtilDBWeb.updateQueue(
					"insert into ac_function_access (ac_function_id, ac_site_code, ac_staff_id, ac_group_id, ac_created_user, ac_modified_user) values (?, ?, ?, 'ALL', ?, ?) ",
					new String[] { function_id, staffSiteCode, staffID, userBean.getStaffID(), userBean.getStaffID() } );
			}
		} else {
			if (isExistInDocument(userBean, document_id, staffID)) {
				return UtilDBWeb.updateQueue(
					"update ac_document_access set ac_enabled = 1, ac_modified_date = sysdate, ac_modified_user = ? where ac_document_id = ? and ac_site_code = ? and ac_staff_id = ?",
					new String[] { userBean.getStaffID(), document_id, staffSiteCode, staffID } );
			} else {
				return UtilDBWeb.updateQueue(
					"insert into ac_document_access (ac_document_id, ac_site_code, ac_staff_id, ac_group_id, ac_created_user, ac_modified_user) values (?, ?, ?, 'ALL', ?, ?) ",
					new String[] { document_id, staffSiteCode, staffID, userBean.getStaffID(), userBean.getStaffID() } );
			}
		}
	}

	private boolean deleteRightInProgram(HttpServletResponse response, UserBean userBean, String infoType, String function_id, String staffID) throws IOException {
		PrintWriter out = response.getWriter();
		String staffSiteCode = getStaffSiteCode(staffID);
		return UtilDBWeb.updateQueue(
			"update ac_function_access set ac_enabled = 0, ac_modified_date = sysdate, ac_modified_user = ? where ac_function_id = ? and ac_site_code = ? and ac_staff_id = ?",
			new String[] { userBean.getStaffID(), function_id, staffSiteCode, staffID } )
			||
			UtilDBWeb.updateQueue(
			"update ac_user_groups set ac_enabled = 0, ac_modified_date = sysdate, ac_modified_user = ? where ac_group_id in (select ac_group_id from ac_function_access where ac_function_id = ? and ac_group_id != 'ALL') and ac_site_code = ? and ac_staff_id = ?",
			new String[] { userBean.getStaffID(), function_id, staffSiteCode, staffID } );
	}

	private boolean deleteRightInDocument(HttpServletResponse response, UserBean userBean, String infoType, String document_id, String staffID) throws IOException {
		PrintWriter out = response.getWriter();
		String staffSiteCode = getStaffSiteCode(staffID);
		return UtilDBWeb.updateQueue(
			"update ac_document_access set ac_enabled = 0, ac_modified_date = sysdate, ac_modified_user = ? where ac_document_id = ? and ac_site_code = ? and ac_staff_id = ?",
			new String[] { userBean.getStaffID(), document_id, staffSiteCode, staffID } )
			||
			UtilDBWeb.updateQueue(
			"update ac_user_groups set ac_enabled = 0, ac_modified_date = sysdate, ac_modified_user = ? where ac_group_id in (select ac_group_id from ac_document_access where ac_document_id = ? and ac_group_id != 'ALL') and ac_site_code = ? and ac_staff_id = ?",
			new String[] { userBean.getStaffID(), document_id, staffSiteCode, staffID } );
	}
%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)) {
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
String infoCategory = ParserUtil.getParameter(request, "infoCategory");
String infoID = ParserUtil.getParameter(request, "infoID");
String infoType = ParserUtil.getParameter(request, "infoType");
String infoDescription = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "infoDescription"));
String info_func_ID = ParserUtil.getParameter(request, "info_func_ID");
String info_func_URL = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "info_func_URL"));
String info_doc_ID = ParserUtil.getParameter(request, "info_doc_ID");
String info_doc_URL = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "info_doc_URL"));
String info_target = ParserUtil.getParameter(request, "info_target");
String info_type_content = ParserUtil.getParameter(request, "info_type_content");
String info_type_URL = ParserUtil.getParameter(request, "info_type_URL");
String info_withfolder = ParserUtil.getParameter(request, "info_withfolder");
String info_latestfile = ParserUtil.getParameter(request, "info_latestfile");
String info_showsub = ParserUtil.getParameter(request, "info_showsub");
String info_onlycurrent = ParserUtil.getParameter(request, "info_onlycurrent");
String info_showpoint = ParserUtil.getParameter(request, "info_showpoint");
String info_showroot = ParserUtil.getParameter(request, "info_showroot");
String info_file = ParserUtil.getParameter(request, "info_file");
String selectFile = ParserUtil.getParameter(request, "selectFile");
String addStaffID = ParserUtil.getParameter(request, "addStaffID");
String deleteStaffID = ParserUtil.getParameter(request, "deleteStaffID");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean addRightAction = false;
boolean deleteRightAction = false;
boolean closeAction = false;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("addRight".equals(command)) {
	addRightAction = true;
} else if ("deleteRight".equals(command)) {
	deleteRightAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction || updateAction) {

			// get info id with dummy data
			if (info_withfolder == null || info_withfolder == "")
				info_withfolder = "N";
			if (info_latestfile == null || info_latestfile == "" && info_latestfile != "Y")
				info_latestfile = "N";
			if (info_showsub == null || info_showsub == "")
				info_showsub = "N";
			if (info_onlycurrent == null || info_onlycurrent == "")
				info_onlycurrent = "N";
			if (info_showpoint == null || info_showpoint == "")
				info_showpoint = "N";
			if (info_showroot == null || info_showroot == "")
				info_showroot = "N";

			if (createAction) {
				infoID = InformationDB.add(
					userBean, infoCategory,infoType,infoDescription,
					info_func_ID, info_func_URL, info_doc_ID, info_doc_URL,
					info_withfolder, info_latestfile,
					info_showsub, info_onlycurrent, info_showpoint,
					info_showroot,info_target);

				if (infoID != null) {
					message = "information page created.";
					createAction = false;
				} else {
					message = "Create information page fail.";
				}
				step = null;
			}
			if (updateAction) {
				if (InformationDB.update(userBean,infoID,infoCategory, infoType, infoDescription,
						info_func_ID,info_func_URL, info_doc_ID, info_doc_URL, info_withfolder, info_latestfile,
						info_showsub, info_onlycurrent, info_showpoint, info_showroot, info_target)) {
					message = "information page updated.";
					updateAction = false;
				} else {
					message = "Update information page fail.";
				}
				step = null;
			}
		} else if (deleteAction) {
			if (InformationDB.delete(userBean, infoID, infoCategory)) {
				message = "information page removed.";
				closeAction = true;
			} else {
				errorMessage = "information page remove fail.";
			}
		} else if (addRightAction) {
			if (addRight(response, userBean, infoType, info_func_ID, info_doc_ID, addStaffID)) {
				message = "user right is added.";
				addRightAction = false;
			} else {
				errorMessage = "user right add fail.";
			}
			step = null;
		} else if (deleteRightAction) {
			if ("PROGRAM".equals(infoType)) {
				if (isExistMoreThanOneInProgram(userBean, info_func_ID, deleteStaffID)) {
					errorMessage = "user right remove fail due to same role with multiple function.";
				} else if (!deleteRightInProgram(response, userBean, infoType, info_func_ID, deleteStaffID)) {
					errorMessage = "user right remove fail.";
				} else {
					message = "user right is removed.";
					deleteRightAction = false;
				}
			} else {
				if (isExistMoreThanOneInDocument(userBean, info_doc_ID, deleteStaffID)) {
					errorMessage = "user right remove fail due to same role with multiple function.";
				} else if (!deleteRightInDocument(response, userBean, infoType, info_doc_ID, deleteStaffID)) {
					errorMessage = "user right remove fail.";
				} else {
					message = "user right is removed.";
					deleteRightAction = false;
				}
			}
			step = null;
		}
	} else if (createAction) {
		infoID = "";
		infoType = "PROGRAM";
		infoDescription = "";
		info_target = "Content";
		info_func_URL = "";
		info_func_ID = "";
		info_doc_ID = "";
		info_doc_URL = "";
		info_withfolder = "N";
		info_latestfile = "";
		info_showsub = "";
		info_onlycurrent = "N";
		info_showpoint = "N";
		info_showroot = "";

	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (infoID != null && infoID.length() > 0) {
			ArrayList record = InformationDB.get(infoID, infoCategory);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				infoType = row.getValue(2);
				infoDescription = row.getValue(3);
				info_func_ID = row.getValue(4);
				info_func_URL = row.getValue(5);
				info_doc_ID = row.getValue(6);
				info_doc_URL = row.getValue(7);
				info_target= row.getValue(8);

				if ("PROGRAM".equals(infoType)) {
					request.setAttribute("staff_list", fetchStaffByFunctionID(info_func_ID));
				} else {
					request.setAttribute("staff_list", fetchStaffByDocumentID(info_doc_ID));
				}
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
}
catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { %>

<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
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
	title = "function.info." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" enctype="multipart/form-data" action="information.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.category" /></td>
		<td class="infoData" width="70%">
<%	if (updateAction || createAction) { %>
			<select name="infoCategory">
<jsp:include page="../ui/infoCategoryCMB.jsp" flush="false">
	<jsp:param name="infoCategory" value="<%=infoCategory %>" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
<%	} else { %>
			<%=infoCategory==null?"":infoCategory.toUpperCase() %><input type="hidden" name="infoCategory" value="<%=infoCategory %>">
<%	} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.type" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
		<select name="infoType" onchange="return changeTypeDisplayStyle()">
				<option value="PROGRAM"<%="PROGRAM".equals(infoType)?" selected":"" %>><%="PROGRAM"%></option>
				<option value="DOCUMENT"<%="DOCUMENT".equals(infoType)?" selected":"" %>><%="DOCUMENT"%></option>
			</select>
<%	} else { %>
			<%=infoType==null?"":infoType.toUpperCase() %><input type="hidden" name="infoType" value="<%=infoType %>">
<%	} %>
		</td>

	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.headline" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="infoDescription" value="<%=infoDescription==null?"":infoDescription %>" maxlength="100" size="80">
<%	} else { %>
			<%=infoDescription==null?"":infoDescription %>
<%	}
%>
		</td>
	</tr>

<%	if ("DOCUMENT".equals(infoType)) {
		if (info_doc_ID != null && !"".equals(info_doc_ID)) {
			ArrayList record = InformationDB.getDOC(info_doc_ID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				info_type_content = row.getValue(0);
				info_type_URL = row.getValue(1);
			}
		} else {
			info_type_URL = info_doc_URL;
		}
	} else if ("PROGRAM".equals(infoType)) {
		info_type_content = info_func_ID;
		info_type_URL = info_func_URL;
	}
%>
<%	if (createAction || updateAction) { %>
	<tr class="smallText" id="info_typecontent">
		<td class="infoLabel" width="30%"><bean:message key="prompt.name" /></td>
		<td class="infoData" width="70%">
			<input type="textfield" name="info_type_content" value="<%=info_type_content==null?"":info_type_content %>" maxlength="100" size="80">
		</td>
	</tr>
<%	} else { %>
	<tr class="smallText" id="info_typecontent">
		<td class="infoLabel" width="30%"><bean:message key="prompt.name" /></td>
		<td class="infoData" width="70%">
			<%=info_type_content==null?"":info_type_content %>
		</td>
	</tr>
<%	} %>

<%	if (createAction || updateAction) { %>
	<tr class="smallText" id="info_typeURL">
		<td class="infoLabel" width="30%"><bean:message key="prompt.url" /></td>
		<td class="infoData" width="70%">
			<input type="textfield" name="info_type_URL" value="<%=info_type_URL==null?"":info_type_URL %>" maxlength="100" size="80">
		</td>
	</tr>
<%	} else { %>
	<tr class="smallText" id="info_typeURL">
		<td class="infoLabel" width="30%"><bean:message key="prompt.url" /></td>
		<td class="infoData" width="70%">
			<%=info_type_URL==null?"":info_type_URL %>
		</td>
	</tr>
<%	} %>

<%	if (createAction || updateAction) { %>
	<tr class="smallText" id="info_attach">
		<td class="infoLabel" width="30%">Attachment Options</td>
		<td class="infoData" width="70%">
			<input type="radio" name="Selectfile" id ="Selectfile" value="Y"  onclick="changeFileDisplayStyle();"
			<%if (updateAction && info_doc_ID != "") {%> checked <%} else if (updateAction && info_doc_ID == "") {%>!checked<%} else{%>checked<%} %>/>Select from Files</input>
			<input type="radio" name="Selectfile" id ="Selectfile" value="N" onclick="changeFileDisplayStyle();"
			<%if (updateAction && info_doc_ID == "") {%> checked <%} else if (updateAction && info_doc_ID != "") {%>!checked<%} else{%>!checked<%} %>/>Input File URL</input>
		</td>
	</tr>

	<tr class="smallText" id="doc_option">
		<td class="infoLabel" width="30%"></td>
		<td class="infoData" width="70%">
			<button onclick="return submitcall('create','');" class="btn-click"> Add Document</button>
<%		if (updateAction && info_doc_ID.length() != 0) { %>
			<button onclick="return submitcall('update','<%=info_doc_ID %>');" class="btn-click"> Edit Document</button>
<%		} %>
			<button onclick="return updateFileList();" id="refresh">Get File List</button>
			<span id="FileList_indicator">
			<select name="file" size="10" id="file" onchange="return getfileID()">
			<jsp:include page="../ui/fileNameCMB.jsp" flush="false">
				<jsp:param name="infoCategory" value="<%=infoCategory %>" />
				<jsp:param name="allowAll" value="Y" />
			</jsp:include></select>
		</td>
	</tr>

	<tr class="smallText" id="doc_URL_show">
		<td class="infoLabel" width="30%">Document URL</td>
		<td class="infoData" width="70%">
			<input type="text" id="URL_show" name="URL_show" disabled="disabled" value="<%=info_type_URL%>" maxlength="100" size="80"/>
		</td>
	</tr>

	<tr class="smallText" id="doc_URL_input">
		<td class="infoLabel" width="30%">Input URL</td>
		<td class="infoData" width="70%">
			<input type="text" name="URL_input" value="<%=info_type_URL==null?"":info_type_URL %>" maxlength="100" size="80"/>
		</td>
	</tr>
<%	} %>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.target" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>

		<select name="info_target">
			<option value="Content" <%="Content".equals(info_target)?" selected":"" %>><%="Content"%></option>
			<option value="bigcontent"<%="bigcontent".equals(info_target)?" selected":"" %>><%="bigcontent"%></option>
			<option value="_blank"<%="_blank".equals(info_target)?" selected":"" %>><%="_blank"%></option>
		</select>
<%	} else { %>
			<%=info_target==null?"":info_target %>
<%	} %>
		</td>
	</tr>

<%	if (createAction || updateAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Options</td>
		<td class="infoData" width="70%">
			<input type="checkbox" name="info_withfolder" value="N" unchecked >With Folder?</input>
			<input type="checkbox" name="info_latestfile" value="Y" checked="checked">Latest File?</input>
			<input type="checkbox" name="info_showsub" value="Y" checked="checked">Show SubFolder?</input>
			<input type="checkbox" name="info_onlycurrent" value="N" unchecked>Show Only Current Year?</input>
			<input type="checkbox" name="info_showpoint" value="N" unchecked>Show Only Point Form?</input>
			<input type="checkbox" name="info_showroot" value="Y" checked="checked">Show Root?</input>

		</td>
	</tr>
<%	} %>
</table>

<!--
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1, '');" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0, '');" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0, '');" class="btn-click"><bean:message key="button.update" /></button>
			<button class="btn-delete"><bean:message key="button.delete" /></button>
<%	}  %>
		</td>
	</tr>
</table>
</div>
-->

<%	if (!createAction && !updateAction) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" width="100%">
	<tr class="smallText">
		<td class="infoTitle">Access Right</td>
	</tr>
</table>
<display:table id="row" name="requestScope.staff_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column property="fields0" titleKey="prompt.department" style="width:40%" />
	<display:column property="fields1" titleKey="prompt.staffName" style="width:30%" />
	<display:column property="fields2" titleKey="prompt.staffID" style="width:10%" />
	<display:column titleKey="prompt.action" media="html" style="width:20%; text-align:center">
		<button onclick="return submitAction('deleteRight', 1, '<c:out value="${row.fields2}" />');" class="btn-click"><bean:message key="button.delete" /> Access Right</button>
	</display:column>
</display:table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" width="100%">
	<tr class="smallText">
		<td width="50%" align="right">Staff ID <input type="textfield" name="addStaffID" value="" maxlength="8" size="10"><td>
		<td width="50%" align="left"><button onclick="return submitAction('addRight', 1, '');" class="btn-click"><bean:message key="button.create" /> Access Right</button></td>
	</tr>
</table>
<%	} %>

<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="infoID" value="<%=infoID %>">
<input type="hidden" name="info_file">
<input type="hidden" name="info_func_ID" value="<%=info_func_ID %>">
<input type="hidden" name="info_func_URL">
<input type="hidden" name="info_doc_ID" value="<%=info_doc_ID %>">
<input type="hidden" name="info_doc_URL" <% if (updateAction) { %>value="<%=info_doc_URL %>" <%} else{ %> value=""<%} %>>
<input type="hidden" name="toPDF" value="N">
<input type="hidden" name="deleteStaffID">
</form>
<script language="javascript">
<!--
	function submitcall(cmd, did) {
		callPopUpWindow("document_details.htm?command=" + cmd + "&documentID=" + did);
		return false;
	}

	function submitAction(cmd, stp, uid) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.infoType.value == '') {
				alert("Empty news type.");
				document.form1.infoType.focus();
				return false;
			}
			if (document.form1.infoDescription.value == '') {
				alert("Empty title.");
				document.form1.infoDescription.focus();
				return false;
			}

			if (document.form1.infoType.value == "PROGRAM") {
				document.form1.info_func_ID.value = document.form1.info_type_content.value;
				document.form1.info_func_URL.value = document.form1.info_type_URL.value;
			}

			if (document.form1.infoType.value == "DOCUMENT") {
				for(i=0; i < document.form1.Selectfile.length; i++) {
					if (document.form1.Selectfile[i].checked) {
						if (document.form1.Selectfile[i].value == "Y") {
							document.form1.info_doc_ID.value = document.form1.info_file.value;
							document.form1.info_doc_URL.value = '';
						} else if (document.form1.Selectfile[i].value == "N") {
							document.form1.info_doc_URL.value = document.form1.URL_input.value;
							document.form1.info_doc_ID.value = '';
							document.form1.info_type_content.value = '';
						}
					}
				}
			}
		}
<%	} else { %>
		if (cmd == 'deleteRight') {
			document.form1.deleteStaffID.value = uid;
		}
<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

		function updateFileList() {

		http.open('get', '../ui/fileNameCMB.jsp');

		//assign a handler for the response
		http.onreadystatechange = processResponseFileList;
		//actually send the request to the server
		http.send(null);

		return false;
	}

	function changeTypeDisplayStyle() {
		var infoType = document.forms["form1"].elements["infoType"].value;
		var info_type_content = document.getElementById("info_typecontent");
		var info_type_URL = document.getElementById("info_typeURL");
		var doc_option = document.getElementById("doc_option");
		var doc_URL_show = document.getElementById("doc_URL_show");
		var doc_URL_input = document.getElementById("doc_URL_input");
		var info_attach = document.getElementById("info_attach");

		if (infoType == "DOCUMENT") {
			info_type_content.style.display = "none";
			info_type_URL.style.display = "none";
			doc_option.style.display = "block";
			doc_URL_show.style.display = "block";
			info_attach.style.display = "block";
		} else if (infoType == "PROGRAM") {
			info_type_content.style.display = "block";
			info_type_URL.style.display = "block";
			doc_option.style.display = "none";
			doc_URL_show.style.display = "none";
			info_attach.style.display = "none"
			doc_URL_input.style.display = "none";
		} else {
			doc_URL_show.style.display = "none";
			doc_URLinputt.style.display = "none";
		}
	}

	function changeFileDisplayStyle() {
		var doc_option = document.getElementById("doc_option");
		var Selectfile = document.forms["form1"].elements["Selectfile"];
		var doc_URL_input = document.getElementById("doc_URL_input");
		var doc_URL_show = document.getElementById("doc_URL_show");
		for (i=0; i < document.form1.Selectfile.length; i++) {
			if (Selectfile[i].checked) {
				if (Selectfile[i].value == "Y") {
					doc_option.style.display = "block";
					doc_URL_show.style.display = "block";
					doc_URL_input.style.display = "none";
				} else if (Selectfile[i].value == "N") {
					doc_URL_input.style.display = "block";
					doc_option.style.display = "none";
					doc_URL_show.style.display = "none";
				}
			}
		}
	}

	function getfileID() {
		f2 = document.getElementById("file");
		f1 = document.getElementById("URL_show");
		for (i = 0; i < f2.length; i++ ) {
			if (f2.options[i].selected == true) {
				f1.value = f2.options[i].title;
				document.form1.info_file.value= f2.options[i].value;
			}
		}
		return false;
	}

	function setselected(doc_ID) {
		f3 = document.getElementById("file");
		for (j = 0; j < f3.length; j++ ) {
			if (f3.options[j].value == doc_ID) {
				f3.options[j].selected = true;
			}
		}
		return false;
	}

	function processResponseFileList() {
		//check if the response has been received from the server
		if (http.readyState == 4) {
			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("FileList_indicator").innerHTML = '<select name="file" size="10" id="file" onchange="return getfileID()">' + http.responseText + '</select>';
		}
	}
<%	if (createAction || updateAction) { %>
<%		if (updateAction) { %>
		changeTypeDisplayStyle();
		changeFileDisplayStyle();
<%		} else { %>
		changeFileDisplayStyle();
		changeTypeDisplayStyle();
<%		}
		if (updateAction && info_doc_ID.length() != 0|| info_doc_ID != null) { %>
		setselected(document.form1.info_doc_ID.value);
<%		} %>
<%	} %>
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>