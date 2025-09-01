<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%
UserBean userBean = new UserBean(request);

String projectID = request.getParameter("projectID");
String projectDesc = null;
String requestUserID = null;
String approval = null;
String budget = null;

// load data from database
if (projectID != null && projectID.length() > 0) {
	ArrayList record = ProjectSummaryDB.get(projectID);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		projectDesc = row.getValue(0);
		requestUserID = row.getValue(2);
		approval = row.getValue(6);
		budget = row.getValue(7);
	}
}
%>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle">Overall Summary - <%=projectDesc==null?"Blank":projectDesc %></td>
<%	if ((userBean.getStaffID() != null && userBean.getStaffID().equals(requestUserID))
				|| (userBean.getUserName() != null && userBean.getUserName().equals(requestUserID))
				|| userBean.isAccessible("function.projectSummary.supervisor")) { %>
		<td class="infoButton">
			<button onclick="submitAction('update', 0);return false;"><bean:message key="function.projectSummary.update" /></button>
			<button onclick="submitAction('delete', 0);return false;"><bean:message key="function.projectSummary.delete" /></button>
		</td>
<%	} %>
		<td class="infoButton">
			<button onclick="submitAction('createComment', '0');return false;"><bean:message key="function.projectSummary.comment.create" /></button>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="3">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle3" colspan="3">Involved Person:
<jsp:include page="summary_userlist.jsp" flush="false">
	<jsp:param name="projectID" value="<%=projectID %>" />
</jsp:include>
		</td>
	</tr>
</table>
<table width="1000" cellpadding="0" cellspacing="0" border="0" align="left" valign="top">
	<tr>
		<td valign="top" width="32%">
<jsp:include page="../pmp/summary_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="PROPOSED ISSUES FOR DISCUSSION" />
	<jsp:param name="projectID" value="<%=projectID %>" />
	<jsp:param name="category" value="issue" />
</jsp:include>
		</td>
		<td>&nbsp;</td>
		<td valign="top" width="32%">
			<span id="showSearch_indicator">
<jsp:include page="../pmp/summary_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="TO DO LIST" />
	<jsp:param name="projectID" value="<%=projectID %>" />
	<jsp:param name="category" value="outstanding" />
	<jsp:param name="contactType" value="" />
	<jsp:param name="dateRange" value="" />
	<jsp:param name="dateFrom" value="" />
	<jsp:param name="dateTo" value="" />
	<jsp:param name="commentType" value="" />
	<jsp:param name="sortBy" value="" />
	<jsp:param name="topic" value="" />
</jsp:include>
			</span>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td height="10"></td></tr>
			</table>
			<br/>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td class="title"><span><bean:message key="button.search" />  <img src="../images/title_arrow.gif"></span></td></tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td height="10"></td></tr>
				<tr><td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr class="smallText">
							<td class="infoLabel">Target</td>
							<td class="infoData">
								<select name="searchContactType">
									<option value="" selected><bean:message key="label.all" /></option>
									<option value="from"><bean:message key="prompt.from" /></option>
									<option value="to"><bean:message key="prompt.to" /></option>
									<option value="cc">CC</option>
								</select>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel">Date Range</td>
							<td class="infoData">
								<select name="searchDateRange">
									<option value="modifiedDate"><bean:message key="prompt.modifiedDate" /></option>
									<option value="deadline"><bean:message key="prompt.deadline" /></option>
								</select>
								<br/>
								<bean:message key="prompt.from" /> :
								<input type="textfield" name="searchDateFrom" id="searchDateFrom" class="datepickerfield" value="" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
								<br/>
								<bean:message key="prompt.to" /> :
								<input type="textfield" name="searchDateTo" id="searchDateTo" class="datepickerfield" value="" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel">Comment Type</td>
							<td class="infoData">
								<select name="searchCommentType">
									<option value="" selected><bean:message key="label.all" /></option>
									<option value="q & a"><bean:message key="label.qna" /></option>
									<option value="issue"><bean:message key="label.issue" /></option>
									<option value="urgent"><bean:message key="label.urgent" /></option>
									<option value="to do"><bean:message key="label.todo" /></option>
									<option value="in progress"><bean:message key="label.inprogress" /></option>
									<option value="memo"><bean:message key="label.memo" /></option>
									<option value="done"><bean:message key="label.done" /></option>
								</select>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel">Sort by</td>
							<td class="infoData">
								<select name="searchSortBy">
									<option value="topic" selected><bean:message key="prompt.topic" /></option>
									<option value="modifiedDate"><bean:message key="prompt.modifiedDate" /></option>
									<option value="priority">Priority</option>
									<option value="deadline"><bean:message key="prompt.deadline" /></option>
								</select>
								<select name="ordering">
									<option value="ASC">Ascending</option>
									<option value="DESC">Decending</option>
								</select>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel">Topic</td>
							<td class="infoData"><input type="textfield" name="searchTopic" value="" maxlength="20" size="20"></td>
						</tr>
						<tr class="smallText">
							<td class="infoData">&nbsp;</td>
							<td class="infoData">
								<button onclick="showSearch();return false;" class="btn-click"><bean:message key="button.search" /></button>
							</td>
						</tr>
					</table>
				</td></tr>
			</table>
			<br/>
			<span id="showArchive_indicator">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td class="title"><span>ARCHIVE <img src="../images/title_arrow.gif"></span></td></tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td height="10"></td></tr>
				<tr><td><a href="javascript:void();" onclick="return showCommentArchive();">Click here to show detail</a></td></tr>
			</table>
			</span>
		</td>
		<td>&nbsp;</td>
		<td valign="top" width="32%">
<jsp:include page="../pmp/summary_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="TO DO LIST BY SUBJECT OFFICER" />
	<jsp:param name="projectID" value="<%=projectID %>" />
	<jsp:param name="category" value="todo" />
	<jsp:param name="deptCodeInclude" value="<%=userBean.getDeptCode() %>" />
</jsp:include>
<jsp:include page="../pmp/summary_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="" />
	<jsp:param name="projectID" value="<%=projectID %>" />
	<jsp:param name="category" value="todo" />
	<jsp:param name="deptCodeExclude" value="<%=userBean.getDeptCode() %>" />
</jsp:include>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td class="title"><span>IMPORTANT INFO <img src="../images/title_arrow.gif"></span></td></tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td><b><bean:message key="prompt.approval" />:</b></td></tr>
				<tr><td><%=approval==null?"":approval %></td></tr>
				<tr><td><b><bean:message key="prompt.budget" />:</b></td></tr>
				<tr><td><%=budget==null?"":budget %></td></tr>
				<tr><td><b><bean:message key="prompt.document" />:</b></td></tr>
				<tr><td>
<jsp:include page="../common/attach_document.jsp" flush="false">
	<jsp:param name="moduleID" value="pmp" />
	<jsp:param name="keyID" value="<%=projectID %>" />
	<jsp:param name="key2ID" value="0" />
</jsp:include>
					</td></tr>
			</table>
		</td>
	</tr>
</table>