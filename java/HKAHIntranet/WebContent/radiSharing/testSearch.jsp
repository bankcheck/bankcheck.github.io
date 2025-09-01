<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.hkah.util.ParserUtil"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.security.cert.Certificate"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.radiSharing.RadiCase"%>
<%@ page import="com.hkah.radiSharing.RadiSharingUtil"%>
<%@ page import="com.hkah.convert.Converter"%>
<%!
public static ArrayList getCaseDetails(String accessionNo, String patNo) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT  RS.Accession_No, Rs.Exam_Report_Path, Rs.Exam_Image_Path,RS.pat_patno FROM SYSTEMLOG@TWA_RADI RS ");
	sqlStr.append(" WHERE 1=1 ");
	if (accessionNo.length() > 0 && accessionNo != null ) {
	sqlStr.append(" AND RS.ACCESSION_NO IN ('"+accessionNo+"') ");
	}
	if (patNo.length() > 0 && patNo != null ) {
		sqlStr.append(" AND RS.pat_patno IN ('"+patNo+"') ");
	}
	

	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<table>
<%
String accessionNo = ParserUtil.getParameter(request, "accessionNo");
String patNo = ParserUtil.getParameter(request, "patNo");
RadiCase rcase = new RadiCase();
String swfAfterConvert = null;

ArrayList record = getCaseDetails(accessionNo,patNo);
for (int i = 0; i < record.size(); i++) {
	ReportableListObject row = (ReportableListObject)record.get(i);
	rcase.setAccessionNo(row.getValue(0));
	rcase.setReportPath(row.getValue(1));
	rcase.setImagePath(row.getValue(2));
	rcase.setPatno(row.getValue(3));
%>
	<tr>
		<td>
			<table>
			 	<tr>
				   <th>Patno</th>
				   <th>Accession No.</th>
				 </tr>	
				<tr><td><%=rcase.getPatno()%></td><td><button style="font-size:12px;" class = "goToOrderBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
					onclick='viewCase("<%=rcase.getAccessionNo()%>")'>
					<%=rcase.getAccessionNo()%> 
				</button></td></tr>
			</table>
		</td>					
	</tr>				
		
<%}%>
</table>
