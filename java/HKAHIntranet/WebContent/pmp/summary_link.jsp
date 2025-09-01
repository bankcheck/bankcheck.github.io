<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String projectID = request.getParameter("projectID");
String commentID = request.getParameter("commentID");
String linkProjectID = request.getParameter("linkProjectID");
boolean allowRemove = "Y".equals(request.getParameter("allowRemove"));

boolean createCommentAction = false;
boolean updateCommentAction = false;
boolean viewCommentAction = false;
boolean replyCommentAction = false;
boolean hiddenCommentAction = false;
boolean allowToEdit = false;

if ("createComment".equals(command)) {
	createCommentAction = true;
} else if ("updateComment".equals(command)) {
	updateCommentAction = true;
} else if ("replyComment".equals(command)) {
	replyCommentAction = true;
} else if ("viewComment".equals(command)) {
	viewCommentAction = true;
} else {
	hiddenCommentAction = true;
}

if ("addCommentLink".equals(command) && linkProjectID != null && linkProjectID.length() > 0) {
	ProjectSummaryDB.addCommentLink(userBean, projectID, commentID, linkProjectID);
} else if ("deleteCommentLink".equals(command)) {
	ProjectSummaryDB.deleteCommentLink(userBean, projectID, commentID);
}

ArrayList record = ProjectSummaryDB.getCommentLinkList(projectID, commentID);
ReportableListObject row = null;
String linkCommentID = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		linkProjectID = row.getValue(0);
		linkCommentID = row.getValue(2);
		if (!linkProjectID.equals(projectID)) {
			if (!createCommentAction && !updateCommentAction && !replyCommentAction) {
				if (allowRemove) { %>
	<a href="javascript:void(0);" onclick="removeCommentLink('<%=commentID %>');">x</a>
<%				} %>
	<a href="summary.jsp?command=viewComment&projectID=<%=linkProjectID %>&commentID=<%=linkCommentID %>"><%=row.getValue(1) %></a></br>
<%
			} else {
%>
	<%=row.getValue(1) %></br>
<%
			}
		}
	}
} else if (allowRemove) { %>
	<button onclick="return addCommentLink('<%=commentID %>');" class="btn-click">Link</button>
	<select name="linkProjectID">
		<option value=""></option>
<jsp:include page="../ui/projectIDCMB.jsp" flush="false">
	<jsp:param name="emptyLabel" value="" />
	<jsp:param name="ignoreProjectID" value="<%=projectID %>" />
</jsp:include>
	</select>
<%} %>