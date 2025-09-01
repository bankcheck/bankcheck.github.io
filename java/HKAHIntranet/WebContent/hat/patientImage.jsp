<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.servlet.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.hkah.servlet.*" %>
<%@ page import="java.io.*" %>

<%
String patNo = request.getParameter("patno");
String fileName = request.getParameter("fileName");

Blob patImage = null;
String sql = null;
ResultSet rs = null;
Connection con = HKAHInitServlet.getDataSourceHATS().getConnection();
Statement stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
sql = "SELECT PATPHOTO FROM PATPHOTO "+
		"WHERE PATNO = '"+patNo+"' ";

try{
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		patImage = rs.getBlob(1);
		
		response.setContentType("image/jpeg");
	
		OutputStream os = response.getOutputStream();
		InputStream is = patImage.getBinaryStream();
		int blobsize =(int)patImage.length();
		
	   byte[] buffer = new byte[8192];
	      for (int length = 0; (length = is.read(buffer)) > 0;) {
	    	  os.write(buffer, 0, length);
	      }
	
		is.close();
		os.flush();
		os.close();	
		out.clear();
		out = pageContext.pushBody();
	}
	else {
		%>
			<script>
				alert("Cannot find this document.");
				window.close();
			</script>
		<%
	}
}finally{
	con.close();
}
%>