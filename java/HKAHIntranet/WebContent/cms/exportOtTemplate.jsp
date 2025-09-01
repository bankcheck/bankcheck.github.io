<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%><%@ page import="com.hkah.servlet.*"
%><%@ page import="java.sql.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.file.*"
%><%@ page import="java.io.*"
%><%
String otTplNo = request.getParameter("otTplNo");
String tplPath = request.getParameter("templatePath");

Blob otTemplate = null;
String sql = "SELECT TMPLT_CONTENT, TMPLT_NAME FROM OT_TMPLT WHERE OT_TMPLT_NO = '"+otTplNo+"' ";
ResultSet rs = null;
Connection con = HKAHInitServlet.getDataSourceCIS().getConnection();
Statement stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

tplPath = TextUtil.parseStrUTF8(java.net.URLDecoder.decode(tplPath));
boolean success = false;

try{
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		otTemplate = rs.getBlob(1);
		String fileName = rs.getString(2);
		if (!(fileName.indexOf(".doc") > -1)) {
			fileName = fileName+".doc";
		}

		File f = new File("\\\\"+tplPath.replace("/", "\\")+otTplNo+"\\"+fileName);
		if (!f.exists()) {
			success = UtilFile.blobToFile("\\\\"+tplPath.replace("/", "\\")+otTplNo+"\\", fileName, otTemplate);
		}
		else {
			success = true;
		}
	}
}
catch (Exception e) {
	e.printStackTrace();
}
finally {
	rs.close();
	stmt.close();
	con.close();
}
%>
<%=success%>