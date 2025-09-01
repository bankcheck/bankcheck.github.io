<%@ page import="java.util.*" %>
<%@ page import="com.hkah.web.common.*" %>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=big5" %>
<%
String patNo = request.getParameter("patNo");
String admNo = request.getParameter("admNo");
String patientACM = request.getParameter("patientACM");
String bedNo = request.getParameter("bedNo");
String admDate = request.getParameter("admDate");



ArrayList record = null;

if (patNo != null && patNo.length() > 0) {
	record = AdmissionDB.getHATSRoomBedInfo(patNo,admDate);
} 
if (record != null && record.size() > 0) {
	ReportableListObject row = null;
	%>
	<tr>
		<td>ACM Patient Chose</td><td>Hospital Assigned ACM</td><td>Hospital Assigned Bed No</td>
	</tr>
	<%
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		String hospitalACM ="S".equals(row.getValue(1))?"SEMI-PRIVATE":("P".equals(row.getValue(1))?"PRIVATE":("T".equals(row.getValue(1))?"STANDARD":"VIP"));
		%>
		<tr>
		<td><%=patientACM%></td>
		<td><button onclick="return submitAction('updateACM', 1, '<%=hospitalACM %>');" class="btn-click">Update RoomType:(<%=hospitalACM%>) From HATS</button></td>
		<td><button onclick="return submitAction('updateBedNo', 1, '<%=row.getValue(0) %>');" class="btn-click">Update BedNo:(<%=row.getValue(0)%>) From HATS</button></td>
		<BR />		
		</tr>
		<%
	}
	%>
  <%
    }
  %>