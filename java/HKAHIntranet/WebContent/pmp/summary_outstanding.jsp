<%
String projectID = request.getParameter("projectID");
String contactType = request.getParameter("contactType");
String dateRange = request.getParameter("dateRange");
String dateFrom = request.getParameter("dateFrom");
String dateTo = request.getParameter("dateTo");
String commentType = request.getParameter("commentType");
String sortBy = request.getParameter("sortBy");
String topic = request.getParameter("topic");
%>
<jsp:include page="../pmp/summary_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="TO DO LIST" />
	<jsp:param name="projectID" value="<%=projectID %>" />
	<jsp:param name="category" value="outstanding" />
	<jsp:param name="contactType" value="<%=contactType %>" />
	<jsp:param name="dateRange" value="<%=dateRange %>" />
	<jsp:param name="dateFrom" value="<%=dateFrom %>" />
	<jsp:param name="dateTo" value="<%=dateTo %>" />
	<jsp:param name="commentType" value="<%=commentType %>" />
	<jsp:param name="sortBy" value="<%=sortBy %>" />
	<jsp:param name="topic" value="<%=topic %>" />
</jsp:include>