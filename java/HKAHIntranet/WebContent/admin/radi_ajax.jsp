<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%@ 
page import="org.json.simple.JSONObject" %><%@
page import="java.io.PrintWriter" %><%@ 
page import="com.hkah.radiSharing.RadiCase"%><%@ 
page import="com.hkah.radiSharing.RadiSharingUtil"%><%!
private ArrayList getList(UserBean userBean,String patNo, String ckRdyUnSent, String dateFrom) {
	String dblink = "";
	if( ConstantsServerSide.isHKAH()) {
		dblink = "HKA_RADI";
	}else if (ConstantsServerSide.isTWAH()){
		dblink =  "TWA_RADI";
	}
		
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("select s.pat_patno, s.accession_no, to_char(s.exam_date,'dd/mm/yyyy'),s.exam_report_desc, ");
	sqlStr.append("Decode(Nvl(Exam_Image_Path,'N'),'N','No','Yes'), decode(NVL(Exam_Report_Path,'N'),'N','No','Yes'), ");
	sqlStr.append(" decode(Msg_Trans_Type,'R','Ready','P','Pending','D','Done'),S.Msg_Trans_Type,to_char(r.CREATED_DATE,'dd/mm/yyyy')  ");
	sqlStr.append(" ,  DECODE(SIGN(ROUND((s.SL_MODIFIED_DATE-r.CREATED_DATE)*24*60)),-1,'N/A',ROUND((s.SL_MODIFIED_DATE-r.CREATED_DATE)*24*60)) ");
	sqlStr.append(" ,st.refer_doctor  ");
	sqlStr.append("from systemlog@"+dblink+" s, study@"+dblink+" st, ");
	sqlStr.append("radi_act_log r ");
	sqlStr.append("where s.accession_no = r.accession_no(+)");
	sqlStr.append(" and s.accession_no = st.access_no and st.order_key is not null ");
	
	if ("P".equals(ckRdyUnSent) && (patNo!=null && !"".equals(patNo))) {
		sqlStr.append(" AND s.pat_patno='");
		sqlStr.append(patNo);
		sqlStr.append("' ");
	}
	else if ("Y".equals(ckRdyUnSent) && (dateFrom!=null && !"".equals(dateFrom)||(patNo != null && !"".equals(patNo)))) {
		sqlStr.append(" AND r.accession_no is null ");
		sqlStr.append(" AND exam_date >= to_date('");
		sqlStr.append(dateFrom);
		sqlStr.append("','dd/mm/yyyy') ");
		sqlStr.append("and exam_image_path is not null and exam_report_path is not null ");
		sqlStr.append("and sl_status is null and  s.Msg_Trans_Type <> 'H' ");
		sqlStr.append(" and st.refer_doctor like 'HA%' ");
		
		if (patNo != null && !"".equals(patNo)) {
			sqlStr.append(" AND s.pat_patno='");
			sqlStr.append(patNo);
			sqlStr.append("' ");
		}
		
	} else if ("D".equals(ckRdyUnSent) && (dateFrom!=null && !"".equals(dateFrom))) {
		sqlStr.append(" And R.Function_Id = 'SEND_CFMCASEANDSEND' ");
		sqlStr.append(" AND to_char(r.CREATED_DATE,'dd/mm/yyyy') = '");
		sqlStr.append(dateFrom);
		sqlStr.append("'");
	
	} else if ("N".equals(ckRdyUnSent) && ((patNo!=null && !"".equals(patNo)))||(dateFrom!=null && !"".equals(dateFrom))) {
		sqlStr.append(" And R.Function_Id = 'SEND_CFMCASEANDSEND' ");
		if (patNo != null && !"".equals(patNo)) {	
			sqlStr.append(" and r.PAT_PATNO ='");
			sqlStr.append(patNo);
			sqlStr.append("' ");
		}
		if (dateFrom!=null && !"".equals(dateFrom)) {
			sqlStr.append(" AND to_char(r.CREATED_DATE,'dd/mm/yyyy') = '");
			sqlStr.append(dateFrom);
			sqlStr.append("'");

		}
	} 
		

	sqlStr.append("order by exam_date ");
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
	private boolean updatetoReady(String accessionNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("Update SYSTEMLOG@ ");
		if( ConstantsServerSide.isHKAH()) {
			sqlStr.append("HKA");
		}else if (ConstantsServerSide.isTWAH()){
			sqlStr.append("TWA");
		}
		sqlStr.append("_RADI Set Sl_Status = '', ");
		sqlStr.append("Msg_Trans_Type = 'R', ");
		sqlStr.append("Sl_Modified_User = 'SYSTEM' ");
		sqlStr.append("WHERE Accession_No =  ? ");


		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {accessionNo} );
	}
	
	private ArrayList getCaseDetails(String accessionNo) {
		String dblink = "";
		if( ConstantsServerSide.isHKAH()) {
			dblink = "HKA_RADI";
		}else if (ConstantsServerSide.isTWAH()){
			dblink =  "TWA_RADI";
		}
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select accession_no, ");
		sqlStr.append("Exam_Report_Path, Exam_Image_Path ");
		sqlStr.append("from systemlog@"+dblink+" ");
		sqlStr.append("WHERE accession_no = '"+accessionNo+"' ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

%><%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String accessionNo = ParserUtil.getParameter(request, "accessionNo");
String patNo = request.getParameter("patNo");
String message = request.getParameter("message");
String imgPath = request.getParameter("imgPath");

String ckRdyUnSent = ParserUtil.getParameter(request, "ckRdyUnSent");
if (ckRdyUnSent == null || ckRdyUnSent.length() == 0) {
	ckRdyUnSent = "Y";
}
String dateFrom = request.getParameter("date_from");
if (dateFrom == null || dateFrom.length() == 0) {
	dateFrom = DateTimeUtil.getCurrentDate();
}

int totalRecPerTable = 10;
String table = request.getParameter("table");
int tableInt = 0;
try {
	tableInt = Integer.parseInt(table);
} catch (Exception e) {}



if (("sendRpt".equals(command)) && accessionNo!=null) {
	ArrayList<ReportableListObject> record = getCaseDetails(accessionNo);
 	JSONObject caseJSON = new JSONObject();
 	ReportableListObject row = null;
 	if(record.size() > 0) {
 		 row = (ReportableListObject) record.get(0);
 		caseJSON.put("accessionNo", row.getValue(0));
 		caseJSON.put("reportPath", row.getValue(1));
 		caseJSON.put("imgPath", row.getValue(2));

 		boolean result = RadiSharingUtil.sendXML(
	 			row.getValue(1),
		"https://eai-igw-test.ha.org.hk:23262/eai_reverseproxy/eai_common_receiver/receiver/cidhl7eai/upload");
 		
 		caseJSON.put("sendRptResult", String.valueOf(result));
 		
 		response.setContentType("text/javascript");
 		PrintWriter writer = response.getWriter();
 		writer.print(request.getParameter("callback")+"("+caseJSON.toString()+ ");");
 		writer.close();
 	}
		
	/* ArrayList<ReportableListObject> record = getCaseDetails(accessionNo);

	ReportableListObject row = null;
	  if(record.size() > 0){
		  row = (ReportableListObject) record.get(0);
		  String dcmResult = "";
		  boolean result = RadiSharingUtil.sendXML(
		 			row.getValue(1),
			"https://eai-igw-test.ha.org.hk:23262/eai_reverseproxy/eai_common_receiver/receiver/cidhl7eai/upload");
			if (result) {
				dcmResult = RadiSharingUtil.sendDCM(row.getValue(2),"ehrrispp-fps-gw1.ha.org.hk","DC4MIDAP01","11112");
			} */
%>
			<%-- <%="rpt:"+String.valueOf(result)+" img:"+dcmResult %>	   --%>
<%	 // }
} else if (("sendRpt".equals(command)) && (!"".equals(imgPath) && imgPath != null )) {
	
} else {
if (("updateToReady".equals(command)) && (accessionNo!=null && !"".equals(patNo))) {
	updatetoReady(accessionNo);
} 
ArrayList<ReportableListObject> record = getList(userBean,patNo, ckRdyUnSent, dateFrom);

ReportableListObject row = null;
  if(record.size() > 0){%>
	  <table class="w3-table">
		<tr>
		  <th>Pat No</th>
		  <th>Acc.No</th>
		  <th>Exam Date</th>
		  <th>Exam Desc</th>
		  <th >Dr.</th>
		  <th>Image Ext?</th>
		  <th>Rpt Ext?</th>
		  <th>Sts</th>
		  <th>Msg Sts</th>
		  <th>Action</th>
		</tr>
	<%
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
	%>
		<tr>
		<td><%=row.getValue(0) %></td>
		<td><%=row.getValue(1) %></td>
		<td><%=row.getValue(2) %></td>
		<td><%=row.getValue(3) %></td>
		<td style="max-width:150px !important; word-wrap:break-word;"><%=row.getValue(10) %></td>
		<td><%=row.getValue(4) %></td>
		<td><%=row.getValue(5) %></td>
		<td><%=row.getValue(6) %></td>
		<td><%=row.getValue(8) %></td>
		<td>
			 <div class="w3-container"><p>
				<button class="w3-btn w3-black updateToReady" onclick="updateR('<%=row.getValue(1)%>')">up To R</button><br>
				<button class="w3-btn w3-red w3-margin-top sendCase" onclick="sendCase('<%=row.getValue(1)%>')">Send</button>	
			 </p></div>
		 </td>

		</tr>
		<%}
		%>
		</table>
<%	 }
	}%>	