<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.ForwardScanningDB"%>
<%@ page import="com.hkah.web.db.helper.FsModelHelper"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide" %>

<%!
private static int loadSysParam() {
	int ret = -1;
	ArrayList list = ForwardScanningDB.loadSysParam();
	ret = list.size();
	for (int i = 0; i < list.size(); i++) {
		ReportableListObject row = (ReportableListObject) list.get(i);
		String codeNo = row.getValue(1);
		String codeValue1 = row.getValue(2);
		//String codeValue2 = row.getValue(3);
		
		System.out.println("[fs loadSysParam] codeNo="+codeNo+", codeValue1="+codeValue1);
		
		FsModelHelper.getInstance().SID2srcHost.put(codeNo, codeValue1);
	}
	return ret;
}
%>
<%
UserBean userBean = new UserBean(request);
String action = request.getParameter("action");
if ("list".equals(action)) {
%>
<ul>
<%
	for (Iterator<String> itr = FsModelHelper.SID2srcHost.keySet().iterator(); itr.hasNext(); ) {
		String key = itr.next();
		String value = FsModelHelper.SID2srcHost.get(key);
%>
<li>key:<%=key %>, value:<%=value %></li>
<%
	}
%>
</ul>
<%
} else {
%>
OK. Return:<%=loadSysParam() %>
<%
}
%>