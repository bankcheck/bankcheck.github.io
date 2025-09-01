<%@ page import="java.util.*" %>
<%@ page import="com.hkah.web.common.*" %>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=big5" %>
<%
String patno = request.getParameter("patno");
String patidno = request.getParameter("patidno");
String patpassport = request.getParameter("patpassport");
String pathtel = request.getParameter("pathtel");
String patbdate = request.getParameter("patbdate");
String patSex = request.getParameter("patSex");
String patFName = request.getParameter("patFName");
String patGName = request.getParameter("patGName");
String patMName = request.getParameter("patMName");
String patmtel = request.getParameter("patmtel");
String patemail = request.getParameter("patemail");
ArrayList record = null;

if (patidno != null && patidno.length() > 0) {
	record = AdmissionDB.getHATSPatientList(patno, patidno, pathtel, patbdate, patSex, patFName==null?"":patFName.toUpperCase(), patGName==null?"":patGName.toUpperCase(), patMName==null?"":patMName.toUpperCase(),patmtel,patemail);
} else { 
	record = AdmissionDB.getHATSPatientList(patno, patpassport, pathtel, patbdate, patSex, patFName==null?"":patFName.toUpperCase(), patGName==null?"":patGName.toUpperCase(), patMName==null?"":patMName.toUpperCase(),patmtel,patemail);
}
if (record != null && record.size() > 0) {
	ReportableListObject row = null;
	%>
	<tr>
		<td>Patient No</td><td>Name</td><td>DOB</td><td>Mobile</td><td>Home</td><td>Email</td>
	</tr>
	<%
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		%>
		<tr>
		<td><button onclick="return submitAction('updatePatNo', 1, '<%=row.getValue(0) %>');" class="btn-click">Select (<%=row.getValue(0) %>)</button></td>
		<td><%=row.getValue(1) %>, <%=row.getValue(2) %></td>
		<td><%=row.getValue(5) %></td>
		<td><%=row.getValue(27) %></td>
		<td><%=row.getValue(6) %></td>
		<td><%=row.getValue(25) %></td>
		<BR />		
		</tr>
		<%
	}
	%>
  <%
    }
  %>