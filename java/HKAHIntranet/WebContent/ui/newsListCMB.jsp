<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String newsID = request.getParameter("newsID");
String newsCategory = request.getParameter("newsCategory");
String newsType = request.getParameter("newsType");
String newsTypeExcept = request.getParameter("newsTypeExcept");
String activeNewsString = request.getParameter("activeNews");
int activeNews = 0;
if(activeNewsString!=null && activeNewsString.length()>0){
	activeNews =  Integer.parseInt(activeNewsString);
}
String noOfMaxRecordString = request.getParameter("noOfMaxRecord");
int noOfMaxRecord = 20;
if(noOfMaxRecordString!=null && noOfMaxRecordString.length()>0){
	noOfMaxRecord =  Integer.parseInt(noOfMaxRecordString);
}
String sortByString = request.getParameter("sortBy");
int sortBy = 0;
if(sortByString!=null && sortByString.length()>0){
	sortBy =  Integer.parseInt(sortByString);
}
%>
<option value=""></option>
<%
ArrayList record = NewsDB.getList(userBean,newsCategory, newsType, newsTypeExcept, activeNews, noOfMaxRecord, sortBy);
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(newsID)?" selected":"" %>>ID: <%=row.getValue(0) %> | Headline: <%=row.getValue(3) %></option><%
	}
}
%>