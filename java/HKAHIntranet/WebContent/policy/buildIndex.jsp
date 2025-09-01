<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.search.Indexer" %>
<%@ page import="com.hkah.constant.ConstantsServerSide" %>
<%@ page import="com.hkah.web.common.UserBean"%>
<%
	UserBean userBean = new UserBean(request);
	if (userBean == null || !userBean.isAdmin()) {
%>
<jsp:forward page="" /> 
<%
	}
%>
<!DOCTYPE html>
<html>
<head>
<title>Manual re-build policy index</title>
</head>
<body>
<div>
Manual run Indexer.optimize. Please wait for few minutes...
<%
try {
	// Test other location for index
	String indexFolder = ConstantsServerSide.INDEX_FOLDER;
	String policyFolder = ConstantsServerSide.POLICY_FOLDER;
	
	System.out.println("== Manual re-build policy index (POLICY_FOLDER="+policyFolder+")");
	String[] policyFolders = null;
	if (ConstantsServerSide.isHKAH()) {
		policyFolders = new String[]{policyFolder,
		"\\\\hkim\\im\\Intranet\\Dept\\Infection Control\\INFC\\Policy"};
	} else if (ConstantsServerSide.isTWAH()) {
		policyFolders = new String[]{policyFolder};
	}
	Indexer.optimize(true, ConstantsServerSide.INDEX_FOLDER, policyFolders);
} catch (Exception e) {
	System.err.println("Thread BuildIndexThread error :" + e.toString());
%>
<%=e.toString() %>
<%
}
%>
<br />
Finished
</div>
</body>
</html>