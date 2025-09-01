<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%><%@ page import="java.sql.*"
%><%@ page import="com.hkah.servlet.*"
%><%@ page import="java.io.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.file.*"
%><%
String otNo = request.getParameter("otNo");
String seqNo = request.getParameter("seqNo");
String version = request.getParameter("version");
String regID = request.getParameter("regID");
String patNo = request.getParameter("patNo");
String rptPath = request.getParameter("reportPath");

Blob otReport = null;
String sql = "SELECT NOTES_CONTENT, NOTES_NAME "+
			 "FROM OT_NOTES_DTL "+
			 "WHERE OTNO = '"+otNo+"' "+
			 "AND SEQ_NO = '"+seqNo+"' "+
			 "AND VERSION = '"+version+"' "+
			 "AND REGID = '"+regID+"' "+
			 "AND PATNO = '"+patNo+"' ";
ResultSet rs = null;
Connection con = HKAHInitServlet.getDataSourceCIS().getConnection();
Statement stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

rptPath = TextUtil.parseStrUTF8(java.net.URLDecoder.decode(rptPath));
String path = null;
boolean success = false;

try{
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		otReport = rs.getBlob(1);
		String fileName = rs.getString(2).replace("Revised:", "(Revised)");
		if (!(fileName.indexOf(".doc") > -1)) {
			fileName = fileName+".doc";
		}

		path = "\\\\"+rptPath.replace("/", "\\")+otNo+"\\"+seqNo+"\\Ver. "+version+"\\"+fileName;
		File file = new File(path);

		if (!file.exists()) {
			success = UtilFile.blobToFile("\\\\"+rptPath.replace("/", "\\")+otNo+"\\"+seqNo+"\\Ver. "+version+"\\", fileName, otReport);
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