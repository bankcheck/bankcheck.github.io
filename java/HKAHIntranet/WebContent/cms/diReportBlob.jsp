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
%><%!
	private int isWord(String xrpid) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ISWORD ");
		sqlStr.append("FROM XREPORTDTLS@IWEB WHERE XRPID = '"+xrpid+"' ");
		sqlStr.append("and rownum = 1 ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject row = null;
		if (result.size() > 0) {
			row = (ReportableListObject)result.get(0);
			if (row.getValue(0).equals("-1")) {
				return 1;
			}
			else {
				return 2;
			}
		}
		return 0;
	}

	private boolean insertReport(String xrpid) {
		int result = isWord(xrpid);
		if (result == 0) {
			return false;
		}
		else if (result == 1) {
			StringBuffer sqlStr = new StringBuffer();

			sqlStr.append("INSERT INTO HAT_XREPORTDTLS ");
			sqlStr.append("( XRPID, XRDSIZE, XWORDRPT, ISWORD ) ");
			sqlStr.append("SELECT XRPID, XRDSIZE, XWORDRPT, ISWORD ");
			sqlStr.append("FROM XREPORTDTLS@IWEB WHERE XRPID = '"+xrpid+"' ");
			sqlStr.append("and rownum = 1 ");

			return UtilDBWeb.updateQueue(sqlStr.toString());
		}
		else if (result == 2) {
			StringBuffer sqlStr = new StringBuffer();

			sqlStr.append("DECLARE ");
			sqlStr.append("V_XRPID NUMBER; ");
			sqlStr.append("V_XRDDTLS LONG RAW; ");
			sqlStr.append("V_XRDSIZE NUMBER; ");
			sqlStr.append("V_ISWORD NUMBER; ");
			sqlStr.append("BEGIN ");
			sqlStr.append("SELECT XRPID, XRDDTLS, XRDSIZE, ISWORD ");
			sqlStr.append("INTO V_XRPID, V_XRDDTLS, V_XRDSIZE, V_ISWORD ");
			sqlStr.append("FROM XREPORTDTLS@IWEB ");
			sqlStr.append("WHERE XRPID = '"+xrpid+"' AND ROWNUM = 1; ");
			sqlStr.append("INSERT INTO HAT_XREPORTDTLS VALUES ");
			sqlStr.append("(V_XRPID, V_XRDDTLS, V_XRDSIZE, NULL, V_ISWORD); ");
			sqlStr.append("END; ");

			return UtilDBWeb.updateQueue(sqlStr.toString());
		}
		else {
			return false;
		}
	}

	private boolean deleteReport(String xrpid) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("DELETE FROM HAT_XREPORTDTLS ");
		sqlStr.append("WHERE XRPID = '"+xrpid+"' ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
%>
<%
String xrpid = request.getParameter("xrpid");
if (xrpid != null) {
	//System.out.println("inserting.....");
	insertReport(xrpid);

	String sql = null;
	ResultSet rs = null;
	Connection con = HKAHInitServlet.getDataSourceIntranet().getConnection();
	Statement stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

	sql = "SELECT XRDSIZE, XWORDRPT, NVL(ISWORD, 0), XRDDTLS "+
		  "FROM HAT_XREPORTDTLS "+
		  "WHERE XRPID = '"+xrpid+"' ";

	//System.out.println("fetching.....");
	rs = stmt.executeQuery(sql);

	//System.out.println("deleting.....");
	deleteReport(xrpid);
	if (rs.next()) {
		String isWord = rs.getObject(3).toString();
		String size = rs.getObject(1).toString();

		response.setContentType("application/msword");
		response.setHeader("Content-disposition", "attachment; filename=\"" + "DI_REPORT.doc" + "\"");
		response.setHeader("Content-length", size);

		OutputStream os = response.getOutputStream();
		InputStream is = null;
		byte[] bytes = new byte[Integer.parseInt(size)];

		if (isWord.equals("-1")) {
			Blob word = rs.getBlob(2);
			is = word.getBinaryStream();
		}
		else {
			is = rs.getBinaryStream(4);
		}
		is.read(bytes);
		is.close();

		os.write(bytes);
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
} else {
	%>
		<script>
			alert("Cannot find this document.");
			window.close();
		</script>
	<%
}
%>