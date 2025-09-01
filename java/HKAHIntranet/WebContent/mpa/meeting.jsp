<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.hibernate.*"%>
<%@ page import="org.apache.poi.ss.usermodel.*"%>
<%@ page import="org.apache.poi.ss.util.*"%>
<%
UserBean userBean = new UserBean(request);

// constant
String documentID = "326";
String sheetName = "MPA Meeting";

// user name mapping
// (Users below are currently supported)
Map<String, String> userNames = new HashMap<String, String>();
userNames.put("rachel.yeung", "Rachel");
userNames.put("eve.lee", "Eve");
userNames.put("4325", "Anita");
userNames.put("sally.leung", "Sally");
userNames.put("sharona.tong", "Sharona");
String loginUserName = userNames.get(userBean.getLoginID());

// sheet column
Map<String, Integer[]> contentCell = new HashMap<String, Integer[]>();
contentCell.put("title", new Integer[]{0,0});
contentCell.put("lastUpdate", new Integer[]{1,0});
contentCell.put("date", new Integer[]{-1,0});
contentCell.put("responsibleBy", new Integer[]{-1,1});
contentCell.put("description", new Integer[]{-1,2});
contentCell.put("proposedDate", new Integer[]{-1,3});
contentCell.put("remarks", new Integer[]{-1,4});
contentCell.put("confirmedDate", new Integer[]{-1,5});
contentCell.put("confirmedTime", new Integer[]{-1,6});
int contentStartRow = 5;

// get document url
ReportableListObject rlo = DocumentDB.getReportableListObject(documentID);
String fileDescription = null;
String location = null;
String filePath = null;
boolean isWebFolder = false;
String fileLastModified = null;
String formattedFileLastModified = "";
if (rlo != null) {
	fileDescription = rlo.getValue(1);
	location = rlo.getValue(2);
	isWebFolder = ConstantsVariable.YES_VALUE.equals(rlo.getValue(3));
	fileLastModified = rlo.getValue(7);
	if (fileLastModified != null && !fileLastModified.isEmpty()) {
		try {
			formattedFileLastModified = DateTimeUtil.formatDateTime(new Date(Long.parseLong(fileLastModified)));
		} catch (Exception e) {
		}
	}
	
	if (isWebFolder) {
		filePath = ConstantsServerSide.DOCUMENT_FOLDER + File.separator + location;
	} else {
		filePath = location;
	}
}

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String title = null;
String lastUpdate = null;
String responsibleBy = null;
List<MpaMeeting> mpaMeetings = new ArrayList<MpaMeeting>();
List<MpaMeeting> filteredMpaMeetings = new ArrayList<MpaMeeting>();
if (filePath == null || filePath.isEmpty()) {
	errorMessage = "No document found.";
} else {
		File file = new File(filePath);
		Sheet sheet = SpreadSheetUtil.getSheet(filePath, sheetName);
		if (sheet != null) {
			CellReference cellRef = null;
			title = SpreadSheetUtil.getCellContentAsString(sheet.getRow((contentCell.get("title"))[0]).getCell((contentCell.get("title"))[1]));
			lastUpdate = SpreadSheetUtil.getCellContentAsString(sheet.getRow((contentCell.get("lastUpdate"))[0]).getCell((contentCell.get("lastUpdate"))[1]));
			
			Integer dateCol = (contentCell.get("date"))[1];
			Row row1 = null;
			Cell cell = null;
			boolean isSameEntry = false;
			for (int i = contentStartRow; i < sheet.getLastRowNum(); i++) {
				row1 = sheet.getRow(i);
				if (row1 != null) {
					cell = row1.getCell(dateCol);
					
					// import each item
					MpaMeeting mpaMeeting = null;
					if (cell != null) {
						mpaMeeting = new MpaMeeting();
						mpaMeeting.setDate(SpreadSheetUtil.getCellContentDate(cell));
						
						Integer responsibleByCol = (contentCell.get("responsibleBy"))[1];
						Integer descriptionCol = (contentCell.get("description"))[1];
						Integer proposedDateCol = (contentCell.get("proposedDate"))[1];
						Integer remarksCol = (contentCell.get("remarks"))[1];
						Integer confirmedDateCol = (contentCell.get("confirmedDate"))[1];
						Integer confirmedTimeCol = (contentCell.get("confirmedTime"))[1];
						
						Cell responsibleByCell = row1.getCell(responsibleByCol);
						Cell descriptionCell = row1.getCell(descriptionCol);
						Cell proposedDateCell = row1.getCell(proposedDateCol);
						Cell remarksCell = row1.getCell(remarksCol);
						Cell confirmedDateCell = row1.getCell(confirmedDateCol);
						Cell confirmedTimeCell = row1.getCell(confirmedTimeCol);
						
						mpaMeeting.setResponsibleBy((String) SpreadSheetUtil.getCellContent(responsibleByCell, Cell.CELL_TYPE_STRING));
						mpaMeeting.setDescription((String) SpreadSheetUtil.getCellContent(descriptionCell, Cell.CELL_TYPE_STRING));
						mpaMeeting.setProposedDate((String) SpreadSheetUtil.getCellContent(proposedDateCell, Cell.CELL_TYPE_STRING));
						mpaMeeting.setRemarks((String) SpreadSheetUtil.getCellContent(remarksCell, Cell.CELL_TYPE_STRING));
						mpaMeeting.setConfirmedDate((String) SpreadSheetUtil.getCellContent(confirmedDateCell, Cell.CELL_TYPE_STRING));
						mpaMeeting.setConfirmedTime((String) SpreadSheetUtil.getCellContent(confirmedTimeCell, Cell.CELL_TYPE_STRING));
						
						mpaMeetings.add(mpaMeeting);
						
						isSameEntry = true;
					} else if (isSameEntry) {
						// read details of the same entry in next row
						mpaMeeting = mpaMeetings.get(mpaMeetings.size() - 1);
						
						Integer descriptionCol = (contentCell.get("description"))[1];
						Integer proposedDateCol = (contentCell.get("proposedDate"))[1];
						Integer remarksCol = (contentCell.get("remarks"))[1];
						
						Cell descriptionCell = row1.getCell(descriptionCol);
						Cell proposedDateCell = row1.getCell(proposedDateCol);
						Cell remarksCell = row1.getCell(remarksCol);
						
						mpaMeeting.appendDescription((String) SpreadSheetUtil.getCellContent(descriptionCell, Cell.CELL_TYPE_STRING));
						mpaMeeting.appendProposedDate((String) SpreadSheetUtil.getCellContent(proposedDateCell, Cell.CELL_TYPE_STRING));
						mpaMeeting.appendRemarks((String) SpreadSheetUtil.getCellContent(remarksCell, Cell.CELL_TYPE_STRING));
						
					}
				}
			}
			
			// filtering
			if (userBean.isAdmin() || "rachel.yeung".equals(userBean.getLoginID())) {
				filteredMpaMeetings = mpaMeetings;
			} else if (loginUserName == null) {
				filteredMpaMeetings.clear();
			} else {
				for (Iterator<MpaMeeting> it = mpaMeetings.iterator(); it.hasNext();) {
					MpaMeeting mpaMeeting = it.next();
					
					if (mpaMeeting.getResponsibleBy() != null && mpaMeeting.getResponsibleBy().indexOf(loginUserName) >= 0) {
						filteredMpaMeetings.add(mpaMeeting);
					}
				}	
			}
			
			request.setAttribute("mpaMeetings", filteredMpaMeetings);
		} else {
			errorMessage = "Cannot read spreadsheet.";
		}
}
	
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.documentShare.meetingForMpa.list" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" method="post">
<bean:define id="functionLabel"><bean:message key="function.documentShare.meetingForMpa.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Title</td>
		<td class="infoData" width="70%">
			<%=title %><%=lastUpdate != null && !lastUpdate.isEmpty() ? " (" + lastUpdate + ")" : "" %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">File last update</td>
		<td class="infoData" width="70%">
			<%=formattedFileLastModified %>
		</td>
	</tr>
</table>

<display:table id="row" name="requestScope.mpaMeetings" export="true" decorator="com.hkah.web.displaytag.MpaMeetingDecorator"
		 pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><c:out value="${row_rowNum}"/>)</display:column>
	<display:column property="date" title="Date" style="width:10%"/>
	<display:column property="responsibleBy" title="Responsible By" style="width:10%"/>
	<display:column property="description" title="Description" style="width:40%"/>
	<display:column property="proposedDate" title="Proposed Date" style="width:30%"/>
	<display:column property="remarks" title="Remarks" style="width:20%"/>
	<display:column property="confirmedDate" title="Confirmed Date" style="width:10%"/>
	<display:column property="confirmedTime" title="Confirmed Time" style="width:10%"/>
</display:table>
</form>
<script language="javascript">
<!--
	function submitSearch() {
		document.search_form.submit();
	}

	function submitAction(cmd, cid, nid) {
		return false;
	}
-->
</script>

</div>

</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>