<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.file.*"
%><%
String patno = request.getParameter("patno");
try {
	UtilFile.getServerImage(request, response, "\\\\hkim\\im\\Patients Accounts\\Staff share\\Authorization for Release of Medical Records (PBO-OPB)", patno + ".pdf");
} catch (Exception e) {
%>
	<script type="text/javascript">
		alert('File not found');
		window.close();
	</script>
<%
}
%>