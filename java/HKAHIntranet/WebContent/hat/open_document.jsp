<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.file.*"
%><%
String filePath = request.getParameter("filePath");

System.out.println("[filePath]:"+filePath);
String newFilePath = filePath.replace("\\", "\\\\");
System.out.println(newFilePath);

try {
	UtilFile.getServerImage(request, response, filePath);
} catch (Exception e) {
%>
	<script type="text/javascript">
		alert('File not found');
		window.close();
	</script>
<%
}
%>