<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.File"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%!
public long whenGetFolderSizeUsingApacheCommonsIO_thenCorrect(String path) {
    File folder = new File(path);
    return FileUtils.sizeOfDirectory(folder);
}
%>
<%
UserBean userBean = new UserBean(request);

String filePath = "\\\\160.100.2.79\\fs";

System.out.println(new Date() + " Start calc folder size, path=" + filePath);
long size = whenGetFolderSizeUsingApacheCommonsIO_thenCorrect(filePath);

System.out.println(new Date() + " Finish calc folder size=" + size);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>test file</title>
</head>
<body>
	<div>
		<p>
			
		</p>
	</div>
</body>
</html>