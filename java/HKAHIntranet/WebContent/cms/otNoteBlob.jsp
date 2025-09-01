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
String otNo = request.getParameter("otNo");
String seqNo = request.getParameter("seqNo");
String version = request.getParameter("version");
String fileName = request.getParameter("fileName");

Blob notes = null;
String sql = null;
ResultSet rs = null;
Connection con = HKAHInitServlet.getDataSourceCIS().getConnection();
Statement stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
sql = "SELECT NOTES_CONTENT FROM OT_NOTES_DTL "+
		"WHERE OTNO = '"+otNo+"' "+
		"AND SEQ_NO = '"+seqNo+"' "+
		"AND VERSION = '"+version+"' ";

rs = stmt.executeQuery(sql);
if (rs.next()) {
	notes = rs.getBlob(1);

	response.setContentType("application/msword");
	response.setHeader("Content-disposition", "attachment; filename=\"" + fileName + "\"");
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