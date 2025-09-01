<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%><%@ page import="java.io.InputStream"
%><%@ page import="java.io.IOException"
%><%@ page import="java.io.Writer"
%><%@ page import="java.io.StringWriter"
%><%@ page import="java.io.Reader"
%><%@ page import="java.io.BufferedReader"
%><%@ page import="java.io.InputStreamReader"
%><%@ page import="java.sql.Connection"
%><%@ page import="com.hkah.servlet.HKAHInitServlet"
%><%@ page import="com.hkah.util.upload.HttpFileUpload"
%><%@ page import="org.apache.commons.fileupload.FileItemFactory"
%><%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"
%><%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"
%><%@ page import="org.apache.commons.fileupload.FileItemIterator"
%><%@ page import="java.io.ByteArrayOutputStream"
%><%@ page import="org.apache.commons.fileupload.FileItemStream"
%><%@ page import="java.sql.PreparedStatement"
%><%@ page import="java.sql.SQLException"
%><%!
	public static String convertStreamToString(InputStream is) throws IOException {
		//
		// To convert the InputStream to String we use the
		// Reader.read(char[] buffer) method. We iterate until the
		// Reader return -1 which means there's no more data to
		// read. We use the StringWriter class to produce the string.
		//
		if (is != null) {
		    Writer writer = new StringWriter();

		    char[] buffer = new char[1024];
		    try {
		        Reader reader = new BufferedReader(
		                new InputStreamReader(is, "UTF-8"));
		        int n;
		        while ((n = reader.read(buffer)) != -1) {
		            writer.write(buffer, 0, n);
		        }
		    } finally {
		        is.close();
		    }
		    return writer.toString();
		} else {
		    return null;
		}
	}
%><%
Connection con = HKAHInitServlet.getDataSourceCIS().getConnection();

try {
	if (HttpFileUpload.isMultipartContent(request)) {
		String mode = null;
		String otNo = null;
		String seqNo = null;
		String version = null;
		String regID = null;
		String patNo = null;
		String otTplNo = null;

		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setHeaderEncoding("UTF-8");
		FileItemIterator it = upload.getItemIterator(request);
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();

		while(it.hasNext()) {
			FileItemStream fileItem = (FileItemStream) it.next();
			InputStream stream = fileItem.openStream();

			if (fileItem.isFormField()) {
				String value = convertStreamToString(stream);
				// System.out.println("DEBUG: isFormField name="+name+", value="+value);
				if (fileItem.getFieldName().equalsIgnoreCase("otNo")) {
					otNo = value;
				}
				else if (fileItem.getFieldName().equalsIgnoreCase("seqNo")) {
					seqNo = value;
				}
				else if (fileItem.getFieldName().equalsIgnoreCase("version")) {
					version = value.substring(5);
				}
				else if (fileItem.getFieldName().equalsIgnoreCase("regID")) {
					regID = value;
				}
				else if (fileItem.getFieldName().equalsIgnoreCase("patNo")) {
					patNo = value;
				}
				else if (fileItem.getFieldName().equalsIgnoreCase("mode")) {
					mode = value;
				}
				else if (fileItem.getFieldName().equalsIgnoreCase("otTplNo")) {
					otTplNo = value;
				}
			} else {
				int nRead;
				byte[] data = new byte[1024];

				while ((nRead = stream.read(data, 0, data.length)) != -1) {
			  		buffer.write(data, 0, nRead);
				}

				buffer.flush();
			}
		}

		if (mode != null) {
			if (mode.equalsIgnoreCase("TEMPLATE")) {
				//upload template
				String sql = "UPDATE OT_TMPLT "+
				"SET TMPLT_CONTENT = ?  "+
				"WHERE OT_TMPLT_NO = '"+otTplNo+"' ";

				System.out.println(sql);

				PreparedStatement pstmt = con.prepareStatement(sql);
				// the cast to int is necessary because with JDBC 4 there is
				// also a version of this method with a (int, long)
				// but that is not implemented by Oracle

				pstmt.setBytes(1, buffer.toByteArray());

				pstmt.executeUpdate();
				con.commit();
			}
			else if (mode.equalsIgnoreCase("REPORT")) {
				//upload report
				String sql = "UPDATE OT_NOTES_DTL "+
				"SET NOTES_CONTENT = ?  "+
				"WHERE OTNO = '"+otNo+"' "+
				"AND SEQ_NO = '"+seqNo+"' "+
				"AND VERSION = '"+version+"' ";

				if (regID != null && regID.length() > 0) {
					sql += "AND REGID = '"+regID+"' "+
					"AND PATNO = '"+patNo+"' ";
				}

				System.out.println(sql);

				PreparedStatement pstmt = con.prepareStatement(sql);
				// the cast to int is necessary because with JDBC 4 there is
				// also a version of this method with a (int, long)
				// but that is not implemented by Oracle

				pstmt.setBytes(1, buffer.toByteArray());

				pstmt.executeUpdate();
				con.commit();
			}
			else {
				//fail
				response.sendError(500);
			}
		}
		else {
			//fail
			response.sendError(500);
		}
	}
}
catch (IOException e) {
	e.printStackTrace();
	response.sendError(500);
}
catch (SQLException se) {
	se.printStackTrace();
	response.sendError(500);
}
finally {
	con.close();
}
%>