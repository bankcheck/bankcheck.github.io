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
			 "AND VERSION = '"+version+"' ";
if (regID != null && regID.length() > 0) {
	sql += "AND REGID = '"+regID+"' "+
	 		"AND PATNO = '"+patNo+"' ";
}

ResultSet rs = null;
Connection con = HKAHInitServlet.getDataSourceCIS().getConnection();
Statement stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

rptPath = TextUtil.parseStrUTF8(java.net.URLDecoder.decode(rptPath));
String path = null;
System.out.println("rptPath: "+rptPath);
try{
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		otReport = rs.getBlob(1);
		String fileName = rs.getString(2).replace("Revised:", "(Revised)");
		if (!(fileName.indexOf(".doc") > -1)) {
			fileName = fileName+".doc";
		}

		path = "\\\\"+rptPath.replace("/", "\\")+otNo+"\\"+seqNo+"\\Ver. "+version+"\\"+fileName;
		System.out.println("path1: "+path);
		File file = new File(path);

		byte[] blobbytes = null;
		String length = null;

		if (file.exists()) {
			blobbytes = UtilFile.getBytesFromFile(file);
			length = String.valueOf(blobbytes.length);
		}
		else {
			boolean success = UtilFile.blobToFile("\\\\"+rptPath.replace("/", "\\")+otNo+"\\"+seqNo+"\\Ver. "+version+"\\", fileName, otReport);
			System.out.println("path2: "+"\\\\"+rptPath.replace("/", "\\")+otNo+"\\"+seqNo+"\\Ver. "+version+"\\"+fileName);
			length = String.valueOf(otReport.length());

			InputStream is = otReport.getBinaryStream();
			int blobsize = (int)otReport.length();
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
	}
	else {
		%>
			<script>
				alert("Cannot find this report.");
				window.close();
			</script>
		<%
	}
}
catch (Exception e) {
	%>
		<script>
			alert("Cannot find this report.");
			window.close();
		</script>
	<%
}
finally {
	if (rs != null) {
		rs.close();
	}
	if (stmt != null) {
		stmt.close();
	}
	if (con != null) {
		con.close();
	}
}
%>