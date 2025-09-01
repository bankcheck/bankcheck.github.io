<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.io.*"%><%@
page import="javax.servlet.ServletException"%><%@
page import="javax.servlet.http.HttpServlet"%><%@
page import="javax.servlet.http.*"%><%@
page import="java.util.*" %><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*" %><%@
page import="com.hkah.util.db.*" %><%@
page import="com.hkah.web.common.*" %><%@
page import="com.hkah.web.db.*"%><%@
page import="net.glxn.qrgen.QRCode"%><%@
page import="net.glxn.qrgen.image.ImageType"%>
<%!
	private ByteArrayOutputStream getQRCode(HttpServletResponse response, String qrCode) {
		ByteArrayOutputStream out = QRCode.from(qrCode).to(ImageType.PNG).withSize(300, 300).stream();

	        response.setContentType("image/png");
	        response.setContentLength(out.size());

		try {
		        OutputStream os = response.getOutputStream();
		        os.write(out.toByteArray());

		        os.flush();
		        os.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	        return out;
	}
%><%
UserBean userBean = new UserBean(request);
String bkgID = request.getParameter("bkgID");
String patno = null;

String sVolNumber = ConstantsVariable.EMPTY_VALUE;
String sSteCode = null;
String sSteName = null;
String bkgpname = null;
String sDocCode = null;
String sDoctorName = null;
String bkgsdate = null;
String bkgstime = null;
String bkgsdatetime = null;

StringBuffer sqlStr = new StringBuffer();
sqlStr.append("SELECT B.PATNO ");
sqlStr.append("FROM   BOOKING B ");
sqlStr.append("LEFT JOIN SCHEDULE S ON B.SCHID = S.SCHID ");
sqlStr.append("LEFT JOIN PATIENT P ON B.PATNO = P.PATNO ");
sqlStr.append("LEFT JOIN DOCTOR DR ON S.DOCCODE = DR.DOCCODE ");
sqlStr.append("LEFT JOIN SITE ST ON B.STECODE = ST.STECODE ");
sqlStr.append("WHERE B.BKGID = ? ");

ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { bkgID });
ReportableListObject row = null;

if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	patno = row.getValue(0);
} else {
	return;
}

record = UtilDBWeb.getFunctionResultsHATS("NHS_GET_GETPATIENTQRCODE", new String[] { patno, bkgID });
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);

	ByteArrayOutputStream output = getQRCode(response, row.getValue(0));
	ServletOutputStream outStream = response.getOutputStream();
	output.writeTo(outStream);

	outStream.flush();
	outStream.close();
} else {
	return;
}
%>