<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.util.search.Indexer"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
public static boolean buildIndex() {
	boolean done = false;
	try {
		// Indexer.recreateIndexes(ConstantsServerSide.INDEX_FOLDER);
		String[] policyFolders = new String[]{ConstantsServerSide.POLICY_FOLDER,
				"\\\\hkim\\im\\Intranet\\Dept\\Infection Control\\INFC\\Policy"};
		Indexer.optimize(true, ConstantsServerSide.INDEX_FOLDER, policyFolders);
		done = true;
	} catch (Exception e) {
		e.printStackTrace();
	}
	return done;
}


%>
<%
	UserBean userBean = new UserBean(request);
	if (userBean == null || !userBean.isAdmin()) {
%>
<jsp:forward page="" /> 
<%
	}
	
	boolean done = buildIndex();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Rebuild policy search index</title>
</head>
<body>
Rebuilding...<br />
Result:<%=done %>
</body>
</html>