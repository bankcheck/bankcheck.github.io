<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String docCode = request.getParameter("docCode");
String procedure = request.getParameter("procedure");
String procDesc = request.getParameter("procDesc");
String comp = request.getParameter("comp");
String[] pArray = null;
boolean success =false;
ArrayList<ReportableListObject> record = null;
if (procedure != null && docCode != null) {
	pArray = procedure.split(";");
		if (pArray != null && pArray.length > 0) {
			for (int i = 0; i < pArray.length; i++) {
				success = "0".equals(UtilDBWeb.callFunction
						("NHS_ACT_CFMDRFAVLIST", "ADD", new String[] { docCode, pArray[i],pArray[i],comp.toUpperCase()}));
			}
		}
	
} else if (procDesc != null && docCode != null) {
		success = "0".equals(UtilDBWeb.callFunction
			("NHS_ACT_CFMDRFAVLIST", "ADD", new String[] { docCode, "",procDesc,comp.toUpperCase()}));
}
%>
<%=success%>