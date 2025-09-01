<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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
String newsCategory = ParserUtil.getParameter(request, "newsCategory");
String newsID = ParserUtil.getParameter(request, "newsID");
String newsType = ParserUtil.getParameter(request, "newsType");
String newsSender = ParserUtil.getParameter(request, "newsSender");
String newsTitle = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "newsTitle"));
String newsTitleUrl = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "newsTitleUrl"));
String newsTitleImage = ParserUtil.getParameter(request, "newsTitleImage");
String prevNewsTitleImage = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "prevNewsTitleImage"));
String newsPostDate = ParserUtil.getParameter(request, "newsPostDate");
String newsExpireDate = ParserUtil.getParameter(request, "newsExpireDate");
String postHomepage = ParserUtil.getParameter(request, "postHomepage");
String content = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "content"));
String emailNotifyFromSelf = ParserUtil.getParameter(request, "emailNotifyFromSelf");
String emailNotifyToAll = ParserUtil.getParameter(request, "emailNotifyToAll");
String emailExclude = ParserUtil.getParameter(request, "emailExclude");
String privateDate = DateTimeUtil.getCurrentDateTimeWithoutSecond();

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

boolean isRenovUpd = "renov.upd".equals(newsCategory);
boolean showSender = "executive order".equals(newsCategory) ||
		"physician".equals(newsCategory) ||
		"vpma".equals(newsCategory);

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}


if (fileUpload) {
	if (createAction && "1".equals(step)) {
		// get news id with dummy data
		newsID = NewsDB.add(userBean, newsCategory);
	}
	
	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(newsCategory);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(newsID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(content);

		for (int i = 0; i < fileList.length; i++) {

			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);

			// skip newsTitleImage
			if (!fileList[i].equals(newsTitleImage)) {
				tempStrBuffer.append("<a href=\"");
				tempStrBuffer.append("/upload/");
				tempStrBuffer.append(newsCategory);
				tempStrBuffer.append("/");
				tempStrBuffer.append(newsID);
				tempStrBuffer.append("/");
				tempStrBuffer.append(fileList[i]);
				tempStrBuffer.append("\">");
				tempStrBuffer.append("<img src=\"../images/attachment.png\" />&nbsp;");
				tempStrBuffer.append(fileList[i]);
				tempStrBuffer.append("</a><BR>");
			}

			// update education calendar link in hkah
			if (ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(ConstantsServerSide.SITE_CODE) && newsTitle.indexOf("Education Calendar") >=0) {
				StringBuffer staffCalendar = new StringBuffer();
				staffCalendar.append("/upload/");
				staffCalendar.append(newsCategory);
				staffCalendar.append("/");
				staffCalendar.append(newsID);
				staffCalendar.append("/");
				staffCalendar.append(fileList[i]);
				AccessControlDB.updateDocumentUrl("adventist.corner", "Staff Education Calendar", staffCalendar.toString());
			}
		}
		content = tempStrBuffer.toString();
	}
}

try {
	if ("1".equals(step)) {
		if (createAction || updateAction) {
//		System.out.println("createAction updateAction step newsID fileUpload postHomepage : " + createAction + ", " + updateAction + ", " + step + ", " + newsID + ", " + fileUpload + ", " + postHomepage);
			// get news id with dummy data
			if (createAction && newsID == null) {
				newsID = NewsDB.add(userBean, newsCategory);
			}
 
			// update previous image
			if (newsTitleImage ==  null && prevNewsTitleImage != null && prevNewsTitleImage.length() > 0) {
				newsTitleImage = prevNewsTitleImage;
			}
			// set newsPostDate, newsExpireDate for post to homepage or not
			if (isRenovUpd) {
//				if ("Y".equals(postHomepage)) {				
//					newsExpireDate = "";
//				} else {
//					newsExpireDate = newsPostDate; 
//				}
			}
			if (NewsDB.update(userBean, newsID, newsCategory, newsType, newsSender, newsTitle, newsTitleUrl, newsTitleImage, 
					newsPostDate, newsExpireDate, content,
					emailNotifyFromSelf, emailNotifyToAll, emailExclude, postHomepage)) {
				if (createAction) {
					message = "news created.";
					createAction = false;
				} else {
					message = "news updated.";
					updateAction = false;
				}
				step = null;
			} else {
				if (createAction) {
					errorMessage = "news create fail.";
				} else {
					errorMessage = "news update fail.";
				}
			}
		} else if (deleteAction) {
			if (NewsDB.delete(userBean, newsID, newsCategory)) {
				message = "news removed.";
				closeAction = true;
			} else {
				errorMessage = "news remove fail.";
			}
		}
	} else if (createAction) {
		newsID = "";
		if("classRelatedNews".equals(newsType)){
			
		}else{
			newsType = "news";
		}
		newsTitle = "";
		newsTitleUrl = "";
		newsPostDate = DateTimeUtil.getCurrentDateTimeWithoutSecond();
		if (newsPostDate != null && newsPostDate.length() > 16) {
			newsPostDate = newsPostDate.substring(0, 16);
		}
		newsExpireDate = "";
		content = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (newsID != null && newsID.length() > 0) {
			ArrayList record = NewsDB.get(userBean, newsID, newsCategory);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				newsType = row.getValue(2);
				newsTitle = row.getValue(3);
				newsTitleUrl = row.getValue(4);
				newsTitleImage = row.getValue(5);
				newsPostDate = row.getValue(6);
				newsExpireDate = row.getValue(7);
//				System.out.println("newsExpireDate="+newsExpireDate);
//				if (newsExpireDate.isEmpty()) {
//					postHomepage = "Y";
//				}
				newsSender = row.getValue(11);
				postHomepage = row.getValue(12);

				StringBuffer contentSB = new StringBuffer();
				record = NewsDB.getContent(newsID, newsCategory);
				if (record != null) {
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						contentSB.append(row.getValue(0));
					}
				}
				content = contentSB.toString();
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { 
	if("poster".equals(newsCategory)){%>
<script type="text/javascript">alert("Poster will be available after marketing Approval.");</script>	 
	<%} %>
<script type="text/javascript">window.close();</script>
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
	title = "function.news." + commandType;
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
<form name="form1" id="form1" enctype="multipart/form-data" action="news.jsp" method="post">
<div class="createActionOnly privateRmk" style="display:none; margin: 5px; font-size: 15px;">
	<% if (!isRenovUpd) { %>
	*
	<input type="checkbox" name="private" value="Y" />
		&nbsp;Private sharing (NOT publish to the Intranet Portal front page news section)
	<%} %>	
</div>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
  <%if(!"infection control".equals(newsCategory)||
		  ("infection control".equals(newsCategory)&&!"article".equals(newsType) && !"1".equals(newsID))){ %>
		<tr class="smallText">
				<td class="infoLabel" width="30%"><bean:message key="prompt.category" /></td>
				<td class="infoData" width="70%">
		<%		if (createAction) { %>
				<% if (isRenovUpd) { %>
					Renovation Update
					<input type="hidden" name="newsCategory" value="<%=newsCategory %>">
				<% } else { %>
					<select name="newsCategory" onchange="updateNewsType(''); updateNewsSender();">
						<jsp:include page="../ui/newsCategoryCMB.jsp" flush="false">
							<jsp:param name="newsCategory" value="<%=newsCategory %>" />
							<jsp:param name="allowEmpty" value="N" />
						</jsp:include>
					</select>
				<% } %>			
		<%		} else{ %>
					<% if (isRenovUpd) { %>
						Renovation Update
					<% } else { %>	
						<%=NewsDB.categories.containsKey(newsCategory) ? NewsDB.categories.get(newsCategory) : newsCategory.toUpperCase() %>
					<% } %>
		<%		} %>
				</td>
			</tr>
		
			<tr class="smallText">
				<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
				<td class="infoData" width="70%">
		<%		if (createAction || updateAction) { %>
				<% if (isRenovUpd) { %>
					<select name="newsType">
						<option value="status1">Completed</option>
						<option value="status2">To be Completed</option>
						<option value="status3">To Commence</option>
						<option value="status4">Delay</option>
					</select> 
				<% } else { %>		
					<span id="matchNewsType_indicator">
				<% } %>		
		<%		} else { %>
					<% if (isRenovUpd) { %>
						<%=NewsDB.getRenovationClass(newsType)%>
					<% } else { %>
						<%=newsType==null?"":newsType.toUpperCase() %>
					<% } %>
		<%		} %>
				</td>
			</tr>
			<% if (isRenovUpd) { %>
				<input type="hidden" name="newsCategory" value="<%=newsCategory %>">
			<% } else { %>
				<tr class="smallText" id="newsSenderBlk">
					<td class="infoLabel" width="30%"><bean:message key="prompt.sender" /></td>
					<td class="infoData" width="70%">
			<%	if (createAction || updateAction) { %>				
						<span id="matchNewsSender_indicator">
			<%		} else { %>
						<%=NewsDB.senders.containsKey(newsSender) ? NewsDB.senders.get(newsSender) : newsSender %>
			<%		} %>
					</td>
				</tr>
			<% } %>	
 <%} else { %>
 	<input type="hidden" name="newsType" value="<%=newsType %>">
 	<input type="hidden" name="newsSender" value="<%=newsSender %>">
 <% } %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.headline" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="newsTitle" value="<%=newsTitle==null?"":newsTitle %>" maxlength="100" size="80">
<%	} else { %>
			<%=newsTitle==null?"":newsTitle %>
<%	} %>
		</td>
	</tr>
	
  <%if(!"infection control".equals(newsCategory)||
		("infection control".equals(newsCategory)&&!"article".equals(newsType) && !"1".equals(newsID))){ %>
		<% if (isRenovUpd) { %>
			  <tr class="smallText publicNewsOnly">
				<td class="infoLabel" width="30%"><bean:message key="prompt.postHomepage" /></td>
				<td class="infoData" width="70%">
				<%	if (createAction || updateAction) { %>
					<input type="checkbox" name="postHomepage" value ="1" <%if ("1".equals(postHomepage)) {%> checked <% } %>/>
				<%	} else { %>
						<%="0".equals(postHomepage)?"No":"Yes" %>
				<%	} %>					
			  </td>				
		<% } else { %>
			<input type="hidden" name="postHomepage" value="N" />
		<% } %>
				
			  <tr class="smallText publicNewsOnly">
				<td class="infoLabel" width="30%"><bean:message key="prompt.postDate" /></td>
				<td class="infoData" width="70%">
			<%	if (createAction || updateAction) { %>
						<input type="textfield" name="newsPostDate" id="newsPostDate" class="datepickerfield" value="<%=newsPostDate==null?"":newsPostDate %>" maxlength="16" size="16">
						<br>(The news will be appeared in front page after this date)</td>
			<%	} else { %>
						<%=newsPostDate==null?"N/A":newsPostDate %>
			<%	} %>
		</tr>

			<tr class="smallText publicNewsOnly">
				<td class="infoLabel" width="30%"><bean:message key="prompt.expiryDate" /></td>
				<td class="infoData" width="70%">
			<%	if (createAction || updateAction) { %>
						<input type="textfield" name="newsExpireDate" id="newsExpireDate" class="datepickerfield" value="<%=newsExpireDate==null?"":newsExpireDate %>" maxlength="16" size="16">
						<br>(The news will be removed after this date. Empty if want to keep it forever)
			<%	} else { %>
						<%=newsExpireDate==null?"N/A":newsExpireDate %>
			<%	} %>
					</td>
		</tr>
 <%} else { %>
 	<input type="hidden" name="newsPostDate" value="<%=newsPostDate %>">
 	<input type="hidden" name="newsExpireDate" value="<%=newsExpireDate %>">
 <%} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Display Image</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="file" name="newsTitleImage" size="50" class="multi" maxlength="1">
<%	} %>
<%	if (!createAction && newsTitleImage != null && newsTitleImage.length() > 0) { %>
			<img src="/upload/<%=newsCategory %>/<%=newsID %>/<%=newsTitleImage %>">
<%	} %>
		 (Small Size <100K, no restriction for Poster and Private Sharing)</td>
	</tr>
<%	if (createAction || updateAction) { %>
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.attachment" /></td>
		<td class="infoData">
			<input type="file" name="file1" size="50" class="multi" maxlength="5">
		</td>
	</tr>
<%	} %>
<!--
	<tr class="smallText">
		<td class="infoLabel" width="30%">Url</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="newsTitleUrl" value="<%=newsTitleUrl==null?"":newsTitleUrl %>" maxlength="100" size="80">
			<br>(Add hyperlink when no news content)
<%	} else { %>
			<%=newsTitleUrl==null?"":newsTitleUrl %>
<%	} %>
		</td>
	</tr>
-->
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.content" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<div class="box"><textarea id="wysiwyg" name="content" rows="12" cols="100"><%=content %></textarea></div>
<%	} else { %>
			<%=content==null?"":content %>
<%	} %>
		</td>
	</tr>
<%	if (createAction || updateAction) { %>
<%
		String emailSelf = UserDB.getUserEmail(null, userBean.getStaffID());
		if (emailSelf == null || emailSelf.length() == 0) {
			emailSelf = ConstantsServerSide.MAIL_ALERT;
		}
%>
  <%if(!"infection control".equals(newsCategory)||
		("infection control".equals(newsCategory)&&!"article".equals(newsType) && !"1".equals(newsID))){ %>				
		<tr class="smallText publicNewsOnly">
				<td class="infoLabel" width="30%">Send Email From</td>
				<td class="infoData" width="70%" colspan=3">
					<input type="radio" name="emailNotifyFromSelf" value="Y" checked><%=emailSelf %>
					<br/><input type="radio" name="emailNotifyFromSelf" value="N"><%=ConstantsServerSide.MAIL_ALERT %>
				</td>
			</tr>
			<tr class="smallText publicNewsOnly">
				<td class="infoLabel" width="30%">Send Email To</td>
				<td class="infoData" width="70%" colspan=3">
					<input type="radio" name="emailNotifyToAll" value="Y">All <% if (ConstantsServerSide.isTWAH()) { %>TWAH<% } else { %>HKAH<% } %> Staff</input>
		<%		if (userBean.isAccessible("function.news.type.marketing") && ConstantsServerSide.isHKAH()) { %>
					&nbsp;(<input type="checkbox" name="emailExclude" value="Y">Exclude <b>Dental</b> and <b>HR department</b></input> and Email will be sent from  <a href="mailto:marketing@hkah.org.hk">marketing@hkah.org.hk</a>)
		<%		} %>			
					
					<br/><input type="radio" name="emailNotifyToAll" value="unitManager">All Unit Manager</input>
					<br/><input type="radio" name="emailNotifyToAll" value="adminDept">All Administrative Department</input>
					<br/><input type="radio" name="emailNotifyToAll" value="ancillaryDept">All Ancillary Department</input>
					<br/><input type="radio" name="emailNotifyToAll" value="nursingUnit">All Nursing Unit</input>
					<br/><input type="radio" name="emailNotifyToAll" value="supportDept">All Supporting Department</input>
					<br/><input type="radio" name="emailNotifyToAll" value="serviceUnit">All Service Unit</input>
					<br/><input type="radio" name="emailNotifyToAll" value=ammed>AmMed Cancer Center</input>
						
					
					<br/><input type="radio" name="emailNotifyToAll" value="S"><%=emailSelf %>
					<br/><input type="radio" name="emailNotifyToAll" value="N" checked>Don't send email</input>
				</td>
			</tr>
	<%} %>  
<%} %> 
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.news.update" /></button>
  <%if(!"infection control".equals(newsCategory)||
		  ("infection control".equals(newsCategory)&&!"article".equals(newsType) && !"1".equals(newsID))){ %>    				
		  <button class="btn-delete"><bean:message key="function.news.delete" /></button>
    		<%}  %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="newsID" value="<%=newsID==null?"":newsID %>">
<input type="hidden" name="toPDF" value="N">
<input type="hidden" name="prevNewsTitleImage" value="<%=newsTitleImage==null?"":newsTitleImage %>">
<%	if (!createAction) { %><input type="hidden" name="newsCategory" value="<%=newsCategory %>"><%} %>
</form>
<script language="javascript">
<!--
	$(document).ready(function(){
		$("input[name=private]").click(function(){
			privateMode(this.checked);
		});
<%	if (createAction) { %>
		$('.createActionOnly').show();
<%} %>
	});
	
	function privateMode(enable) {
		if (enable) {
			$('input[name=private]')[0].checked = true;
			$('.privateRmk').css("font-weight","bold");
<%	if (createAction) { %>				
			$('input[name=newsPostDate]').val('<%=privateDate %>');
			$('input[name=newsExpireDate]').val('<%=privateDate %>');
			$('input[name=emailNotifyToAll][value=N]')[0].checked = true;
<%} %>		
			$('.publicNewsOnly').hide();
		} else {
			$("input[name=private]")[0].checked = false;
			$('.privateRmk').css("font-weight","normal");
<%	if (createAction) { %>			
			$('input[name=newsPostDate]').val('<%=privateDate %>');
			$('input[name=newsExpireDate]').val('');
<%} %>			
			$('.publicNewsOnly').show();
		}
	}
	
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.newsType && document.form1.newsType.value == '') {
				alert("Empty news type.");
				document.form1.newsType.focus();
				return false;
			}
			if (document.form1.newsTitle.value == '') {
				alert("Empty title.");
				document.form1.newsTitle.focus();
				return false;
			}
		}
<%	 } %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function callback(msg) {
		document.getElementById("file").outerHTML = document.getElementById("file").outerHTML;
		document.getElementById("msg").innerHTML = "<font color=red>"+msg+"</font>";
	}

	// ajax
	var http = createRequestObject();
	var http2 = createRequestObject();

	function updateNewsType(pvalue) {
		var newsCategory = document.forms["form1"].elements["newsCategory"].value;

		http.open('get', '../ui/newsTypeCMB.jsp?newsCategory=' + newsCategory + '&newsType=' + pvalue + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponseNewsType;

		//actually send the request to the server
		http.send(null);
	}

	function processResponseNewsType() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("matchNewsType_indicator").innerHTML = '<select name="newsType">' + http.responseText + '</select>';
		}
	}
	
	function updateNewsSender(pvalue) {
		var newsCategory = document.forms["form1"].elements["newsCategory"].value;
		if ("executive order" == newsCategory || "physician" == newsCategory || "vpma" == newsCategory) {
			privateMode("executive order" != newsCategory);
			document.getElementById("newsSenderBlk").style.display = 'block';
			
			http2.open('get', '../ui/newsSenderCMB.jsp?newsCategory=' + newsCategory + '&newsSender=' + pvalue + '&timestamp=<%=(new java.util.Date()).getTime() %>');
			http2.onreadystatechange = processResponseNewsSender;
			http2.send(null);
		} else {
			privateMode(false);
			document.getElementById("newsSenderBlk").style.display = 'none';
			document.getElementsByName("newsSender").selectedIndex = 0;
		} 
	}

	function processResponseNewsSender() {
		if (http2.readyState == 4){
			document.getElementById("matchNewsSender_indicator").innerHTML = '<select name="newsSender">' + http2.responseText + '</select>';
		}
	}
	
<%	if ((createAction || updateAction) && !isRenovUpd) { %>	
	updateNewsType('<%=newsType %>');
	updateNewsSender('<%=newsSender %>');
<%	} %>
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>