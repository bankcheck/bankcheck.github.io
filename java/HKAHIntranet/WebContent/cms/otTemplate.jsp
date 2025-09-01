<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%><%@ page import="java.sql.*"
%><%@ page import="java.util.Date"
%><%@ page import="com.hkah.servlet.*"
%><%@ page import="java.io.*"
%><%@ page import="com.hkah.util.file.*"
%><%@ page import="com.hkah.util.*"
%><%
String rHost = request.getRemoteHost();
String rAddr = request.getRemoteAddr();
System.out.println(new Date() + " [DEBUG] otTemplate.jsp from:" + rHost + " (" + rAddr + ")");

String otTplNo = request.getParameter("otTplNo");
String tplPath = request.getParameter("templatePath");

Blob otTemplate = null;
String sql = "SELECT TMPLT_CONTENT, TMPLT_NAME FROM OT_TMPLT WHERE OT_TMPLT_NO = '"+otTplNo+"' ";
ResultSet rs = null;
Connection con = HKAHInitServlet.getDataSourceCIS().getConnection();
Statement stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

tplPath = TextUtil.parseStrUTF8(java.net.URLDecoder.decode(tplPath));
String path = null;
try{
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		otTemplate = rs.getBlob(1);
		String fileName = rs.getString(2);

		if (!(fileName.indexOf(".doc") > -1)) {
			fileName = fileName+".doc";
		}

		path = "\\\\"+tplPath.replace("/", "\\")+otTplNo+"\\"+fileName;
		File file = new File(path);

		byte[] blobbytes = null;
		String length = null;
		
		System.out.println(new Date() + " [DEBUG] otTemplate.jsp file path=" + path +", exists:" + file.exists());

		if (file.exists()) {
			blobbytes = UtilFile.getBytesFromFile(file);
			length = String.valueOf(blobbytes.length);
		}
		else {
			boolean success = UtilFile.blobToFile("\\\\"+tplPath.replace("/", "\\")+otTplNo+"\\", fileName, otTemplate);
			length = String.valueOf(otTemplate.length());

			InputStream is = otTemplate.getBinaryStream();
			int blobsize = (int)otTemplate.length();
			blobbytes = new byte[blobsize];
			is.read(blobbytes);
			is.close();
		}

		response.setContentType("application/msword");
		response.setHeader("Content-disposition", "attachment; filename=\"" + fileName + "\"");
		response.setHeader("Content-length",  length);

		OutputStream os = response.getOutputStream();

		os.write(blobbytes);
		os.flush();
		os.close();
		
		System.out.println(new Date() + " [DEBUG] otTemplate.jsp flush file: " + fileName);
	}
	else {
		%>
			<script>
				alert("Cannot find this template.");
				window.close();
			</script>
		<%
	}
}
catch (Exception e) {
	System.out.println(new Date() + " [DEBUG] otTemplate.jsp ex:" + e.getMessage());
	%>
		<script>
			alert("Cannot find this template.");
			window.close();
		</script>
	<%
}
finally {
	rs.close();
	stmt.close();
	con.close();
}
%>