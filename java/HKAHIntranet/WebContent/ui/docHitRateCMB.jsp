<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String docID = request.getParameter("docID");
String module = request.getParameter("module");
String docHitRate=null;

if("poster".equals(module) && (docID != null||!"".equals(docID))){
NewsDB.updateEnabled(docID,module,"1");	
}else{
docHitRate = DocumentDB.addHitRate(docID);
}
%>
<%if("poster".equals(module)){%>Approved<%}%>
<%if("PEM".equals(module)){%> (HitRate:<%=docHitRate %>) <%}%>
<%if(userBean.isEducationManager()){%> (HitRate:<%=docHitRate %>) <%}%>