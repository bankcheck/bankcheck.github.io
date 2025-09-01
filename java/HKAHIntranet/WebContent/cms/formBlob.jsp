<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ page import="com.hkah.servlet.*"
%><%@ page import="java.sql.*"
%><%@ page import="com.hkah.servlet.*"
%><%@ page import="java.io.*"
%><%
String form_uid = request.getParameter("uid");

Blob notes = null;
String sql = null;
ResultSet rs = null;
Connection con = HKAHInitServlet.getDataSourceCIS().getConnection();
Statement stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
sql = "SELECT form_name, xls_data FROM CIS_FORMS "+
		"WHERE form_uid = '"+form_uid+"' ";

rs = stmt.executeQuery(sql);
if (rs.next()) {
	notes = rs.getBlob(2);

	response.setContentType("application/msword");
	response.setHeader("Content-disposition", "attachment; filename=\"" + rs.getString(1) + "\"");
	response.setHeader("Content-length",  String.valueOf(notes.length()));

	OutputStream os = response.getOutputStream();
	InputStream is = notes.getBinaryStream();
	int blobsize =(int)notes.length();
	byte[] blobbytes = new byte[blobsize];

	is.read(blobbytes);
	is.close();

	os.write(blobbytes);
	os.flush();
	os.close();
}
else {
	%>
		<script>
			alert("Cannot find this document.");
			window.close();
		</script>
	<%
}
%>