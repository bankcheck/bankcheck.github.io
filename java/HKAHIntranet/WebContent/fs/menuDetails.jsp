<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String req_no = request.getParameter("reqNo");

ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList("SELECT MENU FROM FS_REQUEST WHERE REQ_NO  = ? ORDER BY REQ_NO", new String[] { req_no });
ReportableListObject row = null;
System.err.println("[req_no]:"+req_no+";[record.size]:"+record.size());
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		
		String chgNextLineString = row.getValue(0).replace("</p>","");
		String noHTMLMenu = chgNextLineString.replaceAll("\\<.*?>","");
		String[] ss=noHTMLMenu.split(";");
		for(int j=0;j<ss.length;j++)
		{
		    System.out.println(ss[j]);
%>
						
		<tr class="displayBigText"><td class="infoData2" width="100%"><%=ss[j] %></td></tr>
<%
		}
		


	}
}
%>