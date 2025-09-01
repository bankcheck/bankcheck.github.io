<%@ page import="java.io.File"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%!
private void addUploadedFile(HttpServletRequest request, UserBean userBean, String elearningID) {
	String documentSubPath = "Intranet" + File.separator + "Portal" + File.separator + "Documents" + File.separator;

	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.DOCUMENT_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(documentSubPath);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(documentSubPath);
		String webUrl = tempStrBuffer.toString();

		for (int i = 0; i < fileList.length; i++) {
			String documentID = DocumentDB.add(userBean, fileList[i], webUrl + fileList[i], null);
			if (documentID != null) {
				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
					baseUrl + documentID + File.separator + fileList[i]
				);

				DocumentDB.update(documentID, fileList[i], webUrl + documentID + File.separator + fileList[i],
						true, true, null, null, userBean);
				ELearning.addDocument(userBean, elearningID, documentID);
			}
		}
	}
}

// copy of com.hkah.util.upload.HttpFileUpload.toUploadFolder(HttpServletRequest request, String rootFolder, String tempFolder, String uploadFolder, String fileNameEncoding)
// problem: cannot upload non pdf file in twah site using original method
private static Vector toUploadFolder(HttpServletRequest request,
		String rootFolder,
		String tempFolder, String uploadFolder,
		String fileNameEncoding) {
	org.apache.commons.fileupload.FileUpload upload = null;
	List fileItemsList = null;
	Vector fileUploadedMessage = new Vector();
	try {
		// Create a factory for disk-based file items
		DiskFileItemFactory factory = new DiskFileItemFactory();

		// Set factory constraints
		 // the size threshold(buffer), in bytes
		factory.setSizeThreshold(4096);

		// The directory in which temporary files will be located.
		File repository = new File(tempFolder);
		repository.mkdir();
		factory.setRepository(repository);

		// create upload folder
		(new File(uploadFolder + "/")).mkdir();

		// Create a new file upload handler
		// ServletFileUpload upload = new ServletFileUpload(factory);
		upload = new org.apache.commons.fileupload.FileUpload(factory);

		// The maximum allowed size, in bytes. The default value of -1
		// indicates, that there is no limit.
		upload.setSizeMax(102400000);	// 100MB

		// set file name encoding
		if (fileNameEncoding != null) {
			upload.setHeaderEncoding(fileNameEncoding);
		}

		// get file list
		fileItemsList = upload.parseRequest(request);

		Iterator it = fileItemsList.iterator();
		FileItem fileItem = null;
		String fieldname = null;
		String fieldvalue = null;
		File uploadedFile = null;
		Vector fileList2 = null;
		Vector uploadedFileList = new Vector();

		HashMap keyPairArray = new HashMap();

		// use location path if exists
		String locationPath = (String) request.getAttribute("locationPath");
		if (locationPath != null && locationPath.length() > 0) {
			uploadFolder = rootFolder + locationPath;
		}

		while (it.hasNext()) {
			fileItem = (FileItem) it.next();
			fieldname = fileItem.getFieldName();
			fieldvalue = null;

			// leave it special handle file type
			if (fileItem.isFormField()) {
				fieldvalue = fileItem.getString();
			} else if (fileItem.getName().length() > 0 && fileItem.getSize() > 0) {
				/* The file item contains an uploaded file */
				try {
					fieldvalue = fileItem.getName();
					fieldvalue = fieldvalue.substring(fieldvalue.lastIndexOf(File.separator) + 1);
					uploadedFile = new File(uploadFolder + "/" + fieldvalue);
					// create file
					fileItem.write(uploadedFile);

					// add to uploaded file list
					uploadedFileList.add(uploadedFile.getName());

					fileUploadedMessage.add("<font color=\"blue\">Upload "
							+ uploadedFile.getName() + " succeed.</font><br>");
				} catch (Exception e) {
					fileUploadedMessage.add("<font color=\"red\">Upload "
							+ uploadedFile.getName() + " fail.</font><br>");
					e.printStackTrace();
					fieldvalue = null;
				}
			}

			if (fieldvalue != null) {
				// set key value pair to request attribute
				request.setAttribute(fieldname, fieldvalue);

				// store key value pair for string array
				fieldname += "_StringArray";

				// more than one string
				if (keyPairArray.containsKey(fieldname)) {
					// already exist in key pair array
					fileList2 = (Vector) keyPairArray.get(fieldname);
				} else {
					// new in key pair array
					fileList2 = new Vector();
				}

				// insert current value
				fileList2.add(fieldvalue);
				keyPairArray.put(fieldname, fileList2);
			}
		}

		// set back the value into attribute
		for (Iterator i = keyPairArray.keySet().iterator(); i.hasNext();) {
			fieldname = (String) i.next();
			fileList2 = (Vector) keyPairArray.get(fieldname);
			request.setAttribute(fieldname, (String[]) fileList2.toArray(new String[fileList2.size()]));
		}

		request.setAttribute("filelist", (String []) uploadedFileList.toArray(new String[uploadedFileList.size()]));
	} catch (Exception ex) {
		fileUploadedMessage.add("<font color=\"red\">Upload Fail<br>");
		fileUploadedMessage.add(ex.getMessage());
		if (ex instanceof HttpFileUpload.InvalidFileUploadException) {
			fileUploadedMessage.add("<p>The following file type are not allowed:</p>");
			Iterator unAllowFileS = ((HttpFileUpload.InvalidFileUploadException) ex)
			.getInvalidFileList().iterator();
			while (unAllowFileS.hasNext()) {
				fileUploadedMessage.add((String) unAllowFileS.next() + "<br>");
			}
		}
		fileUploadedMessage.add("</font>");
		ex.printStackTrace();
	}
	return fileUploadedMessage;
}

%>
<%
String alpha[] = new String[] {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j"};

UserBean userBean = new UserBean(request);

String category = "title.education";
String command = request.getParameter("command");
String step = request.getParameter("step");
String elearningID = request.getParameter("elearningID");
String topic = request.getParameter("topic");
if (topic != null) {
	topic = new String(topic.getBytes("ISO-8859-1"), "UTF-8");
}
String topicZh = request.getParameter("topicZh");
if (topicZh != null) {
	topicZh = new String(topicZh.getBytes("ISO-8859-1"), "UTF-8");
}
String documentID = request.getParameter("documentID");
String questionNumPerTest = request.getParameter("questionNumPerTest");
String passGrade = request.getParameter("passGrade");
String duration = request.getParameter("duration");
String swffileEn = request.getParameter("swffileEn");
String swffileZh = request.getParameter("swffileZh");
String courseDesc = request.getParameter("courseDesc");
String courseCategory = request.getParameter("courseCategory");
String courseType = request.getParameter("courseType");
String[] videoPathEngArray = (String[]) request.getAttribute("videoPathEng[]_StringArray");
String[] videoPathTChiArray = (String[]) request.getAttribute("videoPathTChi[]_StringArray");
List<String> videoPathsEng = new ArrayList<String>();
List<String> videoPathsTChi = new ArrayList<String>();
if (HttpFileUpload.isMultipartContent(request)){
	// HttpFileUpload.toUploadFolder(
	toUploadFolder(
			request,
			ConstantsServerSide.DOCUMENT_FOLDER,
			ConstantsServerSide.TEMP_FOLDER,
			ConstantsServerSide.UPLOAD_FOLDER,
			"UTF-8"
		);
	command = (String) request.getAttribute("command");
	step = (String) request.getAttribute("step");
	elearningID = (String) request.getAttribute("elearningID");
	topic = (String) request.getAttribute("topic");
	if (topic != null) {
		topic = new String(topic.getBytes("ISO-8859-1"), "UTF-8");
	}
	topicZh = (String) request.getAttribute("topicZh");
	if (topicZh != null) {
		topicZh = new String(topicZh.getBytes("ISO-8859-1"), "UTF-8");
	}
	documentID = (String) request.getAttribute("documentID");
	questionNumPerTest = (String) request.getAttribute("questionNumPerTest");
	passGrade = (String) request.getAttribute("passGrade");
	duration = (String) request.getAttribute("duration");
	courseDesc = (String) request.getAttribute("courseDesc");
	courseCategory = (String) request.getAttribute("courseCategory");
	courseType = (String) request.getAttribute("courseType");
	swffileEn = (String) request.getAttribute("swffileEn");
	swffileZh = (String) request.getAttribute("swffileZh");
	videoPathEngArray = (String[]) request.getAttribute("videoPathEng[]_StringArray");
	videoPathTChiArray = (String[]) request.getAttribute("videoPathTChi[]_StringArray");
	if (videoPathEngArray != null) videoPathsEng = Arrays.asList(videoPathEngArray);
	if (videoPathTChiArray != null) videoPathsTChi = Arrays.asList(videoPathTChiArray);
}

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
	if ("3".equals(step) && ELearning.deleteDocument(userBean, elearningID, documentID)) {
		step = "0";
	} else if ("2".equals(step) && ELearning.addDocument(userBean, elearningID, documentID)) {
		step = "0";
	} else if ("1".equals(step)) {
		if (createAction) {
			elearningID = ELearning.add(userBean, topic, topicZh, questionNumPerTest, passGrade, duration, documentID, swffileEn, swffileZh, videoPathEngArray, videoPathTChiArray);
			if (elearningID != null) {
				// add upload file
				addUploadedFile(request, userBean, elearningID);

				message = "Question created.";
				createAction = false;
			} else {
				errorMessage = "Question create fail.";
			}
		} else if (updateAction) {
			if (ELearning.update(userBean, elearningID, topic, topicZh, questionNumPerTest, passGrade, duration, swffileEn, swffileZh, videoPathEngArray, videoPathTChiArray,courseDesc,courseCategory,courseType)) {
				// add upload file
				addUploadedFile(request, userBean, elearningID);

				message = "Question modified.";
				updateAction = false;
			} else {
				errorMessage = "Question modify fail.";
			}
		} else if (deleteAction) {
			if (ELearning.delete(userBean, elearningID)) {
				message = "Question deleted.";
				closeAction = true;
			} else {
				errorMessage = "Question delete fail.";
			}
			command = "admin";
		}
	} else if (createAction) {
		elearningID = "";
		topic = "";
		topicZh = "";
		documentID = "";
		questionNumPerTest = "";
		passGrade = "";
		duration = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (elearningID != null && elearningID.length() > 0) {
			ArrayList record = ELearning.get(elearningID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				topic = row.getValue(1);
				questionNumPerTest = row.getValue(2);
				passGrade = row.getValue(3);
				duration = row.getValue(5);
				swffileEn = row.getValue(6);
				swffileZh = row.getValue(7);
				topicZh = row.getValue(9);
				courseDesc = row.getValue(10);

				// get video paths
				ArrayList record2 = ELearning.getVideoList(elearningID);
				ReportableListObject row2 = null;
				String swffileLang = null;
				String videoPath = null;
				for (int i = 0; i < record2.size(); i++) {
					row2 = (ReportableListObject) record2.get(i);
					swffileLang = row2.getValue(1);
					videoPath = row2.getValue(2);
					if ("e".equals(swffileLang)) {
						videoPathsEng.add(videoPath);
					} else if ("z".equals(swffileLang)) {
						videoPathsTChi.add(videoPath);
					}
				}

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
	title = "function.eLesson." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr valign="center">
		<td class="step1_1"><p><bean:message key="prompt.topic" /></p></td>
		<td class="step1_2"><p><bean:message key="prompt.question" /></p></td>
		<td class="step1_3"><p><bean:message key="prompt.answer" /></p></td>
	</tr>
</table>
<bean:define id="functionLabel"><bean:message key="function.question.list" /></bean:define>
<form name="form1" enctype="multipart/form-data" action="elearning.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.topic" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<input type="text" name="topic" value="<%=topic %>" maxlength="200" size="100" /> (English)<br />
			<input type="text" name="topicZh" value="<%=topicZh %>" maxlength="200" size="100" /> (Chinese)
<%	} else {%>
			<%=topic %> (English)<br />
			<%=topicZh %> (Chinese)
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "prompt.document.twah" : "prompt.document" %>' /></td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
<%		if (updateAction) { %>
			<input type="file" name="file1" size="50" class="multi" maxlength="5">
			<input type="hidden" name="toPDF" value="N">
<%		} %>

			<select name="documentID">
<jsp:include page="../ui/documentIDCMB.jsp" flush="false">
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select><%if (updateAction) { %><button onclick="return addFile();"><bean:message key="button.add" /></button><%} %>
<%			if (updateAction) {
%><br><p><%
			ArrayList record = ELearning.getDocuments(elearningID);
			ReportableListObject row = null;
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%><br><button onclick="return deleteFile('<%=row.getValue(0) %>');"><bean:message key="button.delete" /> <%=row.getValue(1) %></button><%
				}
			}
		}
	} else { %>
<jsp:include page="../helper/viewDocument.jsp" flush="false">
	<jsp:param name="elearningID" value="<%=elearningID %>" />
</jsp:include>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Course Description</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
  	 <div class="box" >
  		<textarea  id="wysiwyg" name=courseDesc rows="3" cols="50"><%if(!createAction){ %><%=courseDesc==null?"":courseDesc %><%} %></textarea>
  	</div>
<%	} else {%>
			<%=courseDesc==null?"":courseDesc %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Course Category</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<select name="courseCategory">
			<option value="inservice">In-services and Special Training</option>
			<option value="compulsory">Mandatory Class</option>
			<option value="other">Other</option>
		</select>
<%	} else {%>
			<%=courseCategory==null?"":courseCategory %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Course Type</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<select name="courseType">
			<option value="class">Class</option>
			<option value="online">Online Test</option>
		</select>
<%	} else {%>
			<%=courseType==null?"":courseType %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.video" />(<bean:message key="prompt.flashSwfLink" />) (<bean:message key="label.english.version" />)</td>
		<td class="infoData" width="70%">
<%				if (createAction || updateAction) { %>
					<div id="videoPathEngCell">
<%						for (Iterator<String> itr = videoPathsEng.iterator(); itr.hasNext(); ) {
							String videoPath = itr.next();
%>
							<p>
								<input type="textfield" name="videoPathEng[]" value="<%=videoPath %>" maxlength="200" size="100">
								<a href="#" class="removeVideoPathEng"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
							</p>
<%						}	%>
					</div>
					<a href="#" class="addVideoPathEng"><bean:message key="button.add" /></a>
<%				} else { %>
<%						for (Iterator<String> itr = videoPathsEng.iterator(); itr.hasNext(); ) {
							String videoPath = itr.next();
%>
						<p><%=videoPath == null ? "" : videoPath %></p>
<%						}	%>
<%				} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.video" />(<bean:message key="prompt.flashSwfLink" />) (<bean:message key="label.chinese.version" />)</td>
		<td class="infoData" width="70%">
<%				if (createAction || updateAction) { %>
					<div id="videoPathTChiCell">
<%						for (Iterator<String> itr = videoPathsTChi.iterator(); itr.hasNext(); ) {
							String videoPath = itr.next();
%>
							<p>
								<input type="textfield" name="videoPathTChi[]" value="<%=videoPath %>" maxlength="200" size="100">
								<a href="#" class="removeVideoPathTChi"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
							</p>
<%						}	%>
					</div>
					<a href="#" class="addVideoPathTChi"><bean:message key="button.add" /></a>
<%				} else { %>
<%						for (Iterator<String> itr = videoPathsTChi.iterator(); itr.hasNext(); ) {
							String videoPath = itr.next();
%>
						<p><%=videoPath == null ? "" : videoPath %></p>
<%						}	%>
<%				} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "prompt.noOfQuestion.twah" : "prompt.noOfQuestion" %>' /></td>
		<td class="infoData">
<%	if (createAction || updateAction) {%>
		<input type="textfield" name="questionNumPerTest" value="<%=questionNumPerTest %>" maxlength="2" size="50">
<%	} else {%>
		<%=questionNumPerTest %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.passGrade" /></td>
		<td class="infoData">
<%	if (createAction || updateAction) {%>
		<input type="textfield" name="passGrade" value="<%=passGrade %>" maxlength="2" size="50">
<%	} else {%>
		<%=passGrade %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.readDocumentDuration" /></td>
		<td class="infoData">
<%	if (createAction || updateAction) {%>
		<input type="textfield" name="duration" value="<%=duration %>" maxlength="4" size="50"><bean:message key="label.seconds" />
<%	} else {%>
		<%=duration %> <bean:message key="label.seconds" />
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
<%	} else {%>
			<button onclick="return submitAction('update', 0, '');" class="btn-click"><bean:message key="function.eLesson.update" /></button>
			<button class="btn-delete"><bean:message key="function.eLesson.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<br>
<%
	if (!createAction && !updateAction) {
%>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<th align="left">&nbsp;</th>
		<th width="75%" align="center"><bean:message key="prompt.question" /></th>
		<th class="{sorter: false}"><bean:message key="prompt.action" /></th>
		<th align="right">&nbsp;</th>
	</tr>
<%
		boolean success = false;
		try {
			ArrayList record = ELearning.getQuestions(elearningID);
			ArrayList record2 = null;
			ReportableListObject row = null;
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%>
	<tr class="sessionColEven">
		<td align="center" valign="top">Q<%=i + 1 %>)</td>
		<td align="left"><%=row.getValue(1) %></td>
		<td align="center">
			<button onclick="return submitAction('view.detail',0,'<%=row.getValue(0) %>');"><bean:message key="button.view" /></button>
		</td>
		<td align="right">&nbsp;</td>
	</tr>
<%
					record2 = ELearning.getAnswers(elearningID, row.getValue(0));
					if (record2.size() > 0) {
						for (int j = 0; j < record2.size(); j++) {
							row = (ReportableListObject) record2.get(j);
%>
	<tr class="sessionColOdd">
		<td align="center"><%=alpha[j] %>)</td>
		<td align="left" colspan="3"><%=row.getValue(1) %><%=("1".equals(row.getValue(2))?"<img src=\"../images/tick_green_small.gif\">":"") %></td>
		<td align="right">&nbsp;</td>
	</tr>
<%
						}
					}
					success = true;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (!success) {
%>
	<tr class="smallText">
		<td align="center" colspan="5">
			<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
		</td>
	</tr>
<%
		}
%>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create.detail',0,'');"><bean:message key="function.question.create" /></button></td>
	</tr>
</table>
<%	}%>
<input type="hidden" name="command" value="<%=commandType %>">
<input type="hidden" name="step">
<input type="hidden" name="elearningID" value="<%=elearningID%>">
<input type="hidden" name="elearningQID">
<%	if (!createAction && !updateAction) {%>
<input type="hidden" name="documentID">
<%	} %>
</form>
<script language="javascript">
	$().ready(function(){

		// Video
		$('a.addVideoPathEng').click(function() {
	    	var videoPathEngInput = $('div#hiddenVideoPathEngInput').html();
	        $(videoPathEngInput).appendTo('#videoPathEngCell');

	        $('a.removeVideoPathEng').click(function() {
	    		$(this).parent().remove();
	    	});
	    });
	    $('a.removeVideoPathEng').click(function() {
	    	$(this).parent().remove();
	    });

	    $('a.addVideoPathTChi').click(function() {
	    	var videoPathTChiInput = $('div#hiddenVideoPathTChiInput').html();
	        $(videoPathTChiInput).appendTo('#videoPathTChiCell');

	        $('a.removeVideoPathTChi').click(function() {
	    		$(this).parent().remove();
	    	});
	    });
	    $('a.removeVideoPathTChi').click(function() {
	    	$(this).parent().remove();
	    });
	});


	// validate signup form on keyup and submit
	$("#form1").validate({
		rules: {
<%	if (createAction || updateAction) { %>
			topic: { required: true },
<%	} %>
			passGrade: { required: true }
		},
		messages: {
<%	if (createAction) { %>
			topic: { required: "<bean:message key="error.topic.required" />" },
<%	} %>
			passGrade: { required: "<bean:message key="error.passGrade.required" />" }
		}
	});

	function submitAction(cmd, stp, qid) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.topic.value == '') {
				alert("<bean:message key="error.topic.required" />.");
				document.form1.topic.focus();
				return false;
			}
			if (document.form1.questionNumPerTest.value == '' || isNaN(document.form1.questionNumPerTest.value)) {
				alert("<bean:message key="error.noOfQuestion.required" />.");
				document.form1.questionNumPerTest.focus();
				return false;
			}
			if (document.form1.passGrade.value == '') {
				alert("<bean:message key="error.passGrade.required" />.");
				document.form1.passGrade.focus();
				return false;
			}
			if (isNaN(document.form1.passGrade.value) || document.form1.passGrade.value <= 0) {
				alert("<bean:message key="error.passGrade.invalid" />.");
				document.form1.passGrade.focus();
				return false;
			}
			if (document.form1.documentID.selectIndex > 0) {
				if (document.form1.duration.value == '') {
					alert("<bean:message key="error.readDocumentDuration.required" />.");
					document.form1.duration.focus();
					return false;
				}
				if (isNaN(document.form1.duration.value) || document.form1.duration.value == '' || document.form1.duration.value <= 0) {
					alert("<bean:message key="error.readDocumentDuration.invalid" />.");
					document.form1.duration.focus();
					return false;
				}
			}
			if (document.form1.duration.value == '') {
				document.form1.duration.value = 0;
			}
		}
<%	} %>
		if (cmd == 'create.detail') {
			document.form1.action = "elearning_detail.jsp";
			document.form1.command.value = 'create';
		} else if (cmd == 'view.detail') {
			document.form1.action = "elearning_detail.jsp";
			document.form1.command.value = 'view';
		} else {
			document.form1.action = "elearning.jsp";
			document.form1.command.value = cmd;
		}
		document.form1.step.value = stp;
		document.form1.elearningQID.value = qid;
		document.form1.submit();
	}

	function addFile() {
		document.form1.action = "elearning.jsp";
		document.form1.step.value = 2;
		document.form1.submit();
	}

	function deleteFile(did) {
		document.form1.action = "elearning.jsp";
		document.form1.documentID.value = did;
		document.form1.step.value = 3;
		document.form1.submit();
	}

	function callback(msg) {
		document.getElementById("file").outerHTML = document.getElementById("file").outerHTML;
		document.getElementById("msg").innerHTML = "<font color=red>"+msg+"</font>";
	}
</script>
</DIV>

</DIV></DIV>
<div id="hiddenVideoPathEngInput" style="display:none">
	<p>
		<input type="textfield" name="videoPathEng[]" value="" maxlength="200" size="100">
		<a href="#" class="removeVideoPathEng"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
	</p>
</div>
<div id="hiddenVideoPathTChiInput" style="display:none">
	<p>
		<input type="textfield" name="videoPathTChi[]" value="" maxlength="200" size="100">
		<a href="#" class="removeVideoPathTChi"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
	</p>
</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>