<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%
UserBean userBean = new UserBean(request);

String moduleCode = request.getParameter("moduleCode");
String keyID = request.getParameter("keyID");
String subKeyID = request.getParameter("subKeyID");
String documentID = request.getParameter("documentID");
String siteCode = request.getParameter("siteCode");
String docIDs = request.getParameter("docIDs");
String separator = request.getParameter("separator");
String displayAll = request.getParameter("displayAll");
String order = request.getParameter("order");

if (order == null || (order != null && order.length() <= 0)) {
	order = "0";
}

ArrayList record = null;

if ("delete".equals(request.getParameter("command"))) {
/*	
	if("ctsnew".equals(moduleCode)){
		DocumentDB.delete(userBean, moduleCode, keyID, documentID, subKeyID);		
	}else{
		DocumentDB.delete(userBean, moduleCode, keyID, documentID);		
	}
*/
	DocumentDB.delete(userBean, moduleCode, keyID, documentID);


}

boolean allowRemove = "Y".equals(request.getParameter("allowRemove"));

if (keyID != null && keyID.length() > 0) {
/*	
	if("ctsnew".equals(moduleCode)){	
		if (siteCode!=null && siteCode.length() > 0) {
			record = DocumentDB.getList(userBean, siteCode, moduleCode, keyID, null, Integer.parseInt(order), subKeyID);		
		} else {
			record = DocumentDB.getList(userBean, null, moduleCode, keyID, subKeyID);
		}		
	}else if(docIDs != null && docIDs.length() > 0) {
		String[] docID = docIDs.split(separator);
		record = DocumentDB.getList(userBean, siteCode, moduleCode, keyID, docID, Integer.parseInt(order));
	} else if(documentID != null && documentID.length() > 0){		
		record = DocumentDB.getListWithDocID(userBean, siteCode, moduleCode, keyID, documentID, Integer.parseInt(order));		
	} else {
		if (displayAll == null || !displayAll.equals("false")) {
			if (siteCode!=null && siteCode.length() > 0) {
				record = DocumentDB.getList(userBean, siteCode, moduleCode, keyID, null, Integer.parseInt(order));		
			} else {
				record = DocumentDB.getList(userBean, moduleCode, keyID);
			}
		} else {
			return;
		}
	}
*/
	if (docIDs != null && docIDs.length() > 0) {
		String[] docID = docIDs.split(separator);
		record = DocumentDB.getList(userBean, siteCode, moduleCode, keyID, docID, Integer.parseInt(order));
	} else {
		if (displayAll == null || !displayAll.equals("false")) {
			if (siteCode!=null && siteCode.length() > 0) {
				record = DocumentDB.getList(userBean, siteCode, moduleCode, keyID, null, Integer.parseInt(order));		
			} else {
				record = DocumentDB.getList(userBean, moduleCode, keyID);
			}
		} else {
			return;
		}
	}

	ReportableListObject row = null;
	String documentUrl = null;
	String documentDesc = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			documentID = row.getValue(0);
			documentUrl = row.getValue(1);
			documentDesc = row.getValue(2);

			if (allowRemove) { %>
<%				if("ctsnew".equals(moduleCode)){	%>
					<a href="javascript:void(0);" onclick="return removeDocument('<%=moduleCode %>', '<%=subKeyID %>', '<%=documentID %>');">x</a>
<%				} else { %>							
					<a href="javascript:void(0);" onclick="return removeDocument('<%=moduleCode %>', '<%=documentID %>');">x</a>
<%			}} %>
<%			if ("epo".equals(moduleCode)) { %>
				<a href="../documentManage/download.jsp?moduleCode=epo&keyID=<%=keyID %>&documentID=<%=documentID%>"><%=documentDesc %></a>
<%			} else if ("ctsnew".equals(moduleCode)) { %>
				<a href="../documentManage/download.jsp?moduleCode=ctsnew&keyID=<%=keyID %>&documentID=<%=documentID%>&subKeyID=<%=subKeyID %>"><%=documentDesc %></a><br/>					
<%			} else if ("crm.course".equals(moduleCode)) { %>
				<tr>
					<td style="width:50%;">
						<label><%=i+1 %>. <%=documentDesc %></label>
					</td>
					<td>[<a href="<%=documentUrl %>/<%=documentDesc %>" target="_blank"><bean:message key="button.doc.view" /></a>]</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>				
<%			} else { %>
				<a href="<%=documentUrl %>/<%=documentDesc %>" target="_blank"><%=documentDesc %></a><br/>
<%			} %>
<%		}
	}
}
%>

<script language="javascript">
function elearningTest(eid) {
	callPopUpWindow('../../education/elearning_test.jsp?command=&elearningID=' + eid + '&module=lmc.crm');
	
}
</script>