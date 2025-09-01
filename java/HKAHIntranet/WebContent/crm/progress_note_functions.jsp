<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c'%>
<%!
public static boolean deleteProgressNote(UserBean userBean,String pnID){	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS_PROGRESS_NOTE  ");		
	sqlStr.append("SET CRM_ENABLED = '0', ");	
	sqlStr.append("CRM_MODIFIED_DATE=SYSDATE, ");
	sqlStr.append("CRM_MODIFIED_USER='" + userBean.getLoginID() + "' ");
	sqlStr.append("WHERE CRM_PNID = '" + pnID + "' ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}


public static ArrayList getProgressNoteList(String clientID){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT CRM_PNID, CRM_CLIENT_ID,CRM_PROGRESS_NOTE,CRM_MODIFIED_USER,TO_CHAR(CRM_CREATED_DATE, 'DD/MM/YYYY HH24:MI:SS') ");	
	sqlStr.append("FROM CRM_CLIENTS_PROGRESS_NOTE ");
	sqlStr.append("WHERE CRM_ENABLED = '1' ");
	if(clientID!=null && clientID.length()>0){
		sqlStr.append("AND CRM_CLIENT_ID ='"+clientID+"' ");	
	}
	sqlStr.append("ORDER BY CRM_CREATED_DATE DESC");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}


public static boolean insertProgressNote(UserBean userBean,String clientID,String progressNote){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("INSERT INTO CRM_CLIENTS_PROGRESS_NOTE(CRM_PNID, CRM_CLIENT_ID,CRM_PROGRESS_NOTE,CRM_CREATED_USER,CRM_MODIFIED_USER) ");
	sqlStr.append("VALUES ('"+getNextID()+"','"+clientID+"','"+progressNote+"','"+userBean.getLoginID()+"', '"+userBean.getLoginID()+"') ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

private static String getNextID() {
	String id = null;

	ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CRM_PNID) + 1 FROM CRM_CLIENTS_PROGRESS_NOTE");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);		
		id = reportableListObject.getValue(0);
		// set 1 for initial
		if (id == null || id.length() == 0) return "1";
	}
	return id;
}
%>
<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../index.jsp", "_self");
	</script>
	<%
	return;
}

String action = request.getParameter("action");
String clientID = request.getParameter("clientID");
String allowDelete = request.getParameter("allowDelete");
if(action.equals("insert")) {	
	String progressNote = TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("progressNote").replaceAll("%", "%25")));
%>
	<%=insertProgressNote(userBean,clientID,progressNote)%>
<%}else if(action.equals("view")){
	ArrayList record = getProgressNoteList(clientID) ;
	
	if(record.size() != 0){		
%><tbody><%
		for(int i=0;i<record.size();i++){
			ReportableListObject row = (ReportableListObject)record.get(i);
			String tempPnID = row.getValue(0);
			String tempClientID = row.getValue(1);
			String tempProgressNote = row.getValue(2);
			String tempModifiedUser = row.getValue(3);
			String tempCreatedDate = row.getValue(4);
%>
			<tr>	
				<td width='12%' style='text-align:right;' class="infoLabel">Created Date:</td>		
				<td width='' class="infoData"><%=tempCreatedDate %></td>
				<%if("true".equals(allowDelete)){ %>			
				<td  title='Delete Notes' width='4%' class="infoData">
					<img width='24px' src='../images/delete5.png' onclick='progressNoteUpdate("delete","<%=tempClientID %>","<%=tempPnID%>")'/>
				</td>					
				<%} %>
			</tr>
			<tr>
				<td valign='top' style='text-align:right;' class="infoLabel">Progress Note:</td>
				<td colspan="4" class="infoData">
					<%=tempProgressNote %>
				</td>	
			</tr>
<%			if(record.size() -1 != i){ %>
			<tr>
				<td colspan='5'><hr/></td>	
			</tr>
<%
			}
		}
%></tbody><%
	}
}else if(action.equals("delete")){
	String pnID = request.getParameter("pnID");
	%><%=deleteProgressNote(userBean,pnID)%><%
}
%>

