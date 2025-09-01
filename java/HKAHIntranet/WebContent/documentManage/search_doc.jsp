<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.search.*" %>
<%@ page import="org.apache.commons.io.FilenameUtils"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="org.apache.lucene.document.Document"%>
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
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
if (ConstantsServerSide.isHKAH()) {
%>
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="prompt.documentSearchResult" />
	</jsp:include>
<%
}
else {
%>
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="prompt.documentSearchResult" />
		<jsp:param name="mustLogin" value="N"/>
	</jsp:include>
<%
}
%>
<form name="form1" method="post" target="content">
<%
boolean error = false;				//used to control flow for error messages
int startindex = 0;				//the first index displayed on this page
int maxpage    = 10;				//the maximum items displayed on this page
String queryString = null;			//the query entered in the previous page
int thispage = 0;				//used for the for/next either maxpage or
						//list.size() - startindex - whichever is
						//less
List list = null;
String policyFolder = ConstantsServerSide.POLICY_FOLDER;

// open the index
if (!error) {
	queryString = request.getParameter("query");		// get the search criteria
	if (queryString != null) {
		queryString = queryString.trim();
		if (queryString.indexOf(" ") < 0 && queryString.indexOf("\"") < 0) {
			queryString = "\"" + queryString + "\"";
		}
	}
	try {
		// get the start index
		startindex = Integer.parseInt(request.getParameter("startat"));
	} catch (Exception e) { }
	//we don't care if something happens we'll just start at 0
	//or end at 50
}

try {
	// default last element to maxpage run the query
	// if we got no results tell the user
	if (!error) {
		thispage = maxpage;

		// search content
		list = Search.search("contents", queryString, ConstantsServerSide.INDEX_FOLDER);
		if (list.size() == 0) {
			// search and handle twah policy file name
			list = Search.search("name", queryString + ConstantsVariable.SPACE_VALUE + queryString + ConstantsVariable.COMMA_VALUE, ConstantsServerSide.INDEX_FOLDER);
			if (list.size() == 0) {
				out.println("<center><img src=\"../images/sorry.jpg\"><br><font size=\"3\">no match document.</font></center>");
				error = true;
			}
		}
	}
	if (!error) {
%>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="80%">
			<table id="headerSearch" border="0" cellpadding="5" cellspacing="5">
				<tbody>
					<tr>
						<td class="boxSearch">
							<input type="textfield" name="query" value="<%=queryString %>"
								maxlength="25" size="10" class="searchField" onclick="searchClear();" onblur="searchDefault();" />
							<input type="image" src="../images/search.gif" onclick="return searchEngine();">
							&nbsp;&nbsp;
						    <input type="radio" name="searchType" value="policy" checked><bean:message key="menu.policy" />
						</td>
					</tr>
				</tbody>
			</table>
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
<%
		if ((startindex + maxpage) > list.size()) {
			// set the max index to maxpage or last
			// actual search result whichever is less
			thispage = list.size() - startindex;
		}

		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		Document doc = null;
		String doctitle = null;
		String url = null;
		String highlight = null;
		String size = null;
		String lastModified = null;
		String imageIcon = null;
		String rootFolder = ConstantsServerSide.POLICY_FOLDER;
		for (int i = startindex; i < (thispage + startindex); i++) {  // for each element
%>
	<tr class="bigText">
		<td>&nbsp;</td>
<%
			doc = (Document) list.get(i);		// get the next document
			doctitle = doc.get("name");	// get its title
			url = doc.get("path");		// get its path field
			highlight = doc.get("highlight");		// get its highlight
			size = doc.get("size");		// get its size
			lastModified = doc.get("date");		// get its date
			imageIcon = IconSelector.selectIcon(doctitle);

			// strip off prefix if present
			if (url != null) {
				if (url.startsWith(policyFolder)) {
					url = url.substring(policyFolder.length());
				}
				// replace the slash
				url = url.replace("\\", "/");
				url = url.replace("'", "\\'");
			}

			// use the path if it has no title
			if ((doctitle == null) || doctitle.equals("")) {
				doctitle = url;
			}
			doctitle = doctitle.substring(doctitle.lastIndexOf("/") + 1);
			if (doctitle.indexOf("~") == 0) {
				// skip temp file
				continue;
			}

			String docType = null;
			if (url != null) {
				if (url.indexOf("/departmental") == 0) {
					docType = "(Departmental Policy)";
				} else if (url.indexOf("/hospital") == 0) {
					docType = "(Hospital-Wide Policy)";
				} else if (url.contains("/Infection Control/INFC/Policy")){
					docType = "(Departmental Policy)";
				}
			}
			//then output!
%>
		<td>
<% if ("pdf".equalsIgnoreCase(FilenameUtils.getExtension(url))) { %>		
			
	<%
		String fullpath = null;
		if (!url.startsWith("\\")) {
			fullpath = (rootFolder + url);
		} else {
			fullpath = url;
		}
		fullpath = fullpath.replace("/", "\\");
		if (ConstantsServerSide.isHKAH()) {%>
			<a href="javascript:showPdfjs('<%=fullpath.replaceAll("\\\\" , "/").replace("'", "\\'")%>', '<%=FilenameUtils.getName(fullpath).replace("'", "\\'")%>')">
<%		}else{ %>
			<a href="javascript:void();" onclick="downloadFileByFilePath('<%=url%>');">
<%		}
	} else { %>
			<a href="javascript:void();" onclick="downloadFileByFilePath('<%=url%>');">
<% } %>				
				<img src="../<%=imageIcon %>"><%=doctitle %>
			</a></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>...<%=highlight %>...</td>
		<td>&nbsp;</td>
	</tr>
<%			if (docType != null) { %>
	<tr>
		<td>&nbsp;</td>
		<td style="font-weight:bold"><%=docType %></td>
		<td>&nbsp;</td>
	</tr>
<%			} %>
	<tr>
		<td>&nbsp;</td>
		<td><bean:message key="prompt.fileSize" />:<%=size %>kb; <bean:message key="prompt.modifiedDate" />:<%=sdf.format(new java.util.Date(Long.parseLong(lastModified))) %></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
<%
		}
%>
	<tr>
		<td>&nbsp;</td>
		<td align="center">
<%
		// if there are more results...display the more link
		if ( (startindex - maxpage) >= 0) {
			//construct the "more" link
%>
			<a href="search_doc.jsp?query=<%=URLEncoder.encode(queryString) %>&amp;startat=<%=(startindex - maxpage) %>"><img src="../images/previous.gif"></a>
<%
		}

		if (list.size() > maxpage) {
%>
		&nbsp;[&nbsp;
<%
		}

		int noOfPage = list.size() / maxpage;
		if (list.size() > noOfPage * maxpage) {
			noOfPage++;
		}

		for (int i = 0; i < noOfPage; i++) {
			if (i > 0) {
%>
				|&nbsp;
<%
			}
			if (startindex == i * maxpage) {
%>
				<%=i + 1 %>&nbsp;
<%
			} else {
%>
				<a href="search_doc.jsp?query=<%=URLEncoder.encode(queryString) %>&amp;startat=<%=(i * maxpage) %>"><%=i + 1 %></a>&nbsp;
<%
			}
		}

		if (list.size() > maxpage) {
%>
		]&nbsp;
<%
		}

		// if there are more results...display the more link
		if ( (startindex + maxpage) < list.size()) {
			//construct the "more" link
%>
			<a href="search_doc.jsp?query=<%=URLEncoder.encode(queryString) %>&amp;startat=<%=(startindex + maxpage) %>"><img src="../images/next.gif"></a>
<%
		}
%>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
<%
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>
</table>
<input type="hidden" name="locationPath" value="">
<input type="hidden" name="rootFolder" value="">
<input type="hidden" name="policyYN" value="Y">
</form>
<script language="javascript">
<!--
	function downloadFileByFilePath(file) {
		document.form1.action = '../documentManage/download.jsp';
		document.form1.locationPath.value = file;
		if (file.substring(0, 2) == "//" || file.substring(0, 2) == "\\") {
			document.form1.rootFolder.value = '/';
		} else {
			document.form1.rootFolder.value = '';
		}
		document.form1.submit();
	}

	function searchClear() {
		if (document.form1.query.value == "<bean:message key="menu.search" /> ...") {
			document.form1.query.value = "";
		}
	}

	function searchDefault() {
		if (document.form1.query.value == "") {
			document.form1.query.value = "<bean:message key="menu.search" /> ...";
		}
	}

	function searchEngine() {
		document.form1.action = '../documentManage/search.jsp';
		if (document.form1.query.value == "" || document.form1.query.value == "<bean:message key="menu.search" /> ...") {
			alert("Empty search value");
			document.form1.query.value = "";
			document.form1.query.focus();
			return false;
		} else {
			document.form1.action = "../documentManage/search_doc.jsp";
			document.form1.submit();
			return true;
		}
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>