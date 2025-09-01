<%@ page import="com.hkah.util.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>


<%
String fileloc = null;

fileloc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "fileloc"));

System.out.println(fileloc);
%>

<form name="FooterForm"><input type="hidden" name="documentID" /><input type="hidden" name="fileName" />
</form>

<script type="text/javascript">
<!--
	downloadFile('616', '<%=fileloc %>');

	function downloadFile(did, fname) {
		document.FooterForm.action = "../documentManage/download.jsp";
		document.FooterForm.documentID.value = did;
		document.FooterForm.fileName.value = fname;
		document.FooterForm.submit();
		return false;
	}
	
	function downloadFileByFilePath(file) {
		document.FooterForm.action = "../documentManage/download.jsp";
		document.FooterForm.locationPath.value = file;
		document.FooterForm.submit();
	}
-->
</script>
</div>
<!--DIV id=footer>
<table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#888888" height="1"><tr><td></td></tr></table>
<a href="http://www.hkah.org/" style="text-decoration:none;">
<div style="color:#111111; font-size:10px; text-decoration:none; font-family:Arial;">(c) Copyright 2009 Hong Kong Adventist Hospital. All Rights Reserved.
</DIV-->