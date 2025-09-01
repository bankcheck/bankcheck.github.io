<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%><%@ page import="com.hkah.util.TextUtil"
%><%@ page import="java.io.File"
%><%@ page import="com.hkah.util.file.UtilFile"
%><%@ page import="java.io.OutputStream"
%><%
String path = request.getParameter("path");

path = TextUtil.parseStrUTF8(java.net.URLDecoder.decode(path));

try {
	File file = new File(path);

	byte[] blobbytes = null;
	String length = null;

	if (file.exists()) {
		blobbytes = UtilFile.getBytesFromFile(file);
		length = String.valueOf(blobbytes.length);

		response.setHeader("Content-disposition", "inline; filename=\"" + file.getName() + "\"");
		response.setHeader("Content-length",  length);

		OutputStream os = response.getOutputStream();

		os.write(blobbytes);
		os.flush();
		os.close();
	}
	else {
		%>
			<script>
				alert("Cannot open the file.");
				window.close();
			</script>
		<%
	}
}
catch (Exception e) {
	e.printStackTrace();
	%>
		<script>
			alert("Cannot open the file.");
			window.close();
		</script>
	<%
}
finally {
}
%>