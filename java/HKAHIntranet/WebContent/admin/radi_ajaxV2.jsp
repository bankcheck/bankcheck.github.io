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
	sqlStr.append(" decode(Msg_Trans_Type,'R','Ready','P','Pending','D','Done'),S.Msg_Trans_Type,to_char(r.CREATED_DATE,'dd/mm/yyyy HH24:MI')  ");
	sqlStr.append(" ,  DECODE(SIGN(ROUND((s.SL_MODIFIED_DATE-r.CREATED_DATE)*24*60)),-1,'N/A',ROUND((s.SL_MODIFIED_DATE-r.CREATED_DATE)*24*60)) ");
	sqlStr.append(" ,st.refer_doctor, Nvl(Exam_Image_Path,'N'), Nvl(Exam_Report_Path,'N'),r.result  ");
	sqlStr.append("from systemlog@"+dblink+" s, study@"+dblink+" st, ");
	sqlStr.append("radi_act_log r ");
	sqlStr.append("where s.accession_no = r.accession_no(+)");
	sqlStr.append(" and s.accession_no = st.access_no and st.order_key is not null ");
	
	if (("P".equals(ckRdyUnSent) || "Y".equals(ckRdyUnSent)) && (patNo!=null && !"".equals(patNo)) && (patNo.contains(",") || patNo.contains(" "))) {
		
		patNo = "'"+patNo.replace(" ",",").replace(",","','").replace(" ","")+"'";
		sqlStr.append(" AND (s.pat_patno in (");
		sqlStr.append(patNo);
		sqlStr.append(") OR S.ACCESSION_NO in ("+patNo+") )");
	} else if ("P".equals(ckRdyUnSent) && (patNo!=null && !"".equals(patNo))) {
		sqlStr.append(" AND (s.pat_patno='");
		sqlStr.append(patNo);
		sqlStr.append("' OR S.ACCESSION_NO = '"+patNo+"' )");
	}	
	else if ("Y".equals(ckRdyUnSent) && (dateFrom!=null && !"".equals(dateFrom)||(patNo != null && !"".equals(patNo)))) {
		sqlStr.append(" AND r.accession_no is null ");
		if (patNo != null && !"".equals(patNo)) {
			sqlStr.append(" AND s.pat_patno='");
			sqlStr.append(patNo);
			sqlStr.append("' ");
		} else if (dateFrom != null && !"".equals(dateFrom)) {
			sqlStr.append(" AND exam_date >= to_date('");
			sqlStr.append(dateFrom);
			sqlStr.append("','dd/mm/yyyy') ");
		}  		
			
		sqlStr.append("and exam_image_path is not null and exam_report_path is not null ");
		sqlStr.append("and sl_status is null and  s.Msg_Trans_Type <> 'H' ");
		

		
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
		
	if ("D".equals(ckRdyUnSent)) {
		sqlStr.append("order by r.CREATED_DATE  ");
		
	} else {
		sqlStr.append("order by s.accession_no ");
	}
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
	
	public static boolean saveSendLog(String accessionNo, String result, String user) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO RADI_ACT_LOG(");
		sqlStr.append("ACCESSION_NO, FUNCTION_ID, RESULT, USER_ID ) ");
		sqlStr.append("VALUES (");
		sqlStr.append("'"+accessionNo+"', ");
		sqlStr.append("'SEND_CFMCASEANDSEND', ");
		sqlStr.append("'"+result+"' , ");
		sqlStr.append("'SYSTEM') ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
		
	}
	

%><%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String accessionNo = ParserUtil.getParameter(request, "accessionNo");
String patNo = request.getParameter("patNo");
String message = request.getParameter("message");
String imgPath = request.getParameter("imgPath");
String resultLog = request.getParameter("result");

String imgServer = request.getParameter("imgServer");
String imgPort = request.getParameter("imgPort");
String imgAET = request.getParameter("imgAET");

String reportServer = request.getParameter("reportServer");

String sender = request.getParameter("sender");


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

if (("getCaseDetail".equals(command)) && accessionNo!=null) {
	ArrayList<ReportableListObject> record = getCaseDetails(accessionNo);
 	JSONObject caseJSON = new JSONObject();
 	ReportableListObject row = null;
 	if(record.size() > 0) {
 		 row = (ReportableListObject) record.get(0);
 		caseJSON.put("accessionNo", row.getValue(0));
 		caseJSON.put("reportPath", row.getValue(1));
 		caseJSON.put("imgPath", row.getValue(2));
 		caseJSON.put("pdfPath", RadiSharingUtil.getXmlPdf(row.getValue(1)));

 		HashMap<String,String> xmlMap = RadiSharingUtil.getMapOfXml(row.getValue(1));
 		caseJSON.put("hkid",xmlMap.get("PID.3"));
 		caseJSON.put("pName",xmlMap.get("PID.5"));
 		caseJSON.put("dob",xmlMap.get("PID.7"));
 		caseJSON.put("rptSts",xmlMap.get("ORC.25"));
 		
 		caseJSON.put("imgCount",RadiSharingUtil.countUnsentFile("Image",row.getValue(2)));
 		
 		
 		
 		
 		response.setContentType("text/javascript");
 		PrintWriter writer = response.getWriter();
 		writer.print(request.getParameter("callback")+"("+caseJSON.toString()+ ");");
 		writer.close();
 	}
		
%>
			<%-- <%="rpt:"+String.valueOf(result)+" img:"+dcmResult %>	   --%>
<%	 // }
} else if (("sendRpt".equals(command)) && accessionNo!=null
		&& (!"".equals(reportServer) && reportServer != null )) {
	ArrayList<ReportableListObject> record = getCaseDetails(accessionNo);
 	JSONObject caseJSON = new JSONObject();
 	ReportableListObject row = null;
 	if(record.size() > 0) {
 		 row = (ReportableListObject) record.get(0);
 		caseJSON.put("accessionNo", row.getValue(0));
 		caseJSON.put("reportPath", row.getValue(1));
 		caseJSON.put("imgPath", row.getValue(2));
		//testing site
 		 boolean result = RadiSharingUtil.sendXML(
	 			row.getValue(1),
	 			reportServer);
		
 		//prod site (TW)
		/* boolean result = RadiSharingUtil.sendXML(
	 			row.getValue(1),
		"https://eai-igw-hkp.ha.org.hk:32262/eai_reverseproxy/eai_common_receiver/receiver/cidhl7eai/upload"); */
		
		//prod site (HK)
		/*  boolean result = RadiSharingUtil.sendXML(
	 			row.getValue(1),
		"https://eai-igw-hkp.ha.org.hk:32262/eai_reverseproxy/eai_common_receiver/receiver/cidhl7eai/upload");  */
		
 		caseJSON.put("sendRptResult", String.valueOf(result));
 		
 		response.setContentType("text/javascript");
 		PrintWriter writer = response.getWriter();
 		writer.print(request.getParameter("callback")+"("+caseJSON.toString()+ ");");
 		writer.close();
 	}
		
%>
<%
} else if (("updateCaseSts".equals(command)) && (!"".equals(accessionNo) && accessionNo != null )) {
	int result = -1;
	 
	result = Integer.parseInt(UtilDBWeb.callFunction
			("NHS_ACT_RADISHARING","MOD", new String[] { 
				"SendSuccess2",accessionNo,
				"","","","","",userBean.getStaffID(),userBean.getSiteCode(),"S"
			}));

%>
<%	 
} else if (("saveSendLog".equals(command)) && (!"".equals(accessionNo) && accessionNo != null )) {
	boolean resultL = saveSendLog(accessionNo, resultLog, "ITADMIN" ); 
} else if (("insertToUpdate".equals(command)) && (!"".equals(accessionNo) && accessionNo != null )) {
		RadiSharingUtil.generateMsg(accessionNo,"UPDATE");%>
			<%=RadiSharingUtil.getMapOfXml(accessionNo).get("ORC.25")%>
	
%>
<%	 
} else if (("updateToinsert".equals(command)) && (!"".equals(accessionNo) && accessionNo != null )) {
		RadiSharingUtil.generateMsg(accessionNo,"INSERT");%>
			<%=RadiSharingUtil.getMapOfXml(accessionNo).get("ORC.25")%>
			
<%	 	 
} else if (("sendImg".equals(command)) && (!"".equals(imgPath) && imgPath != null )
		&& (!"".equals(imgServer) && imgServer != null )&& (!"".equals(imgPort) && imgPort != null )
		&& (!"".equals(imgAET) && imgAET != null )) {
	//testing
	String dcmResult = RadiSharingUtil.sendDCM(imgPath,imgServer,imgAET,imgPort);
	//testing site
	//String dcmResult = RadiSharingUtil.sendDCM(imgPath,"ehrrispp-fps-gw1.ha.org.hk","DC4MIDAP01","11112");
	
	//prod site (TW)
	//String dcmResult = RadiSharingUtil.sendDCM(imgPath,"ehrrispp-twah-gw1.ha.org.hk","HOCIDSV01","43000");
	
	//prod site (HK)
	//String dcmResult = RadiSharingUtil.sendDCM(imgPath,"ehrrispp-hkah-gw1.ha.org.hk","HOCIDSV01","43000");
%>
	<%=dcmResult%>
<%} else {
if (("updateToReady".equals(command)) && (accessionNo!=null && !"".equals(patNo))) {
	updatetoReady(accessionNo);
	ckRdyUnSent = "Y";
} 
ArrayList<ReportableListObject> record = getList(userBean,patNo, ckRdyUnSent, dateFrom);

ReportableListObject row = null;
  if(record.size() > 0){%>
	  <table class="w3-table">
		<tr>
		<% if (!"email".equals(command)){%>
		   <th></th>
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
		<% } else {%>

		<th  colspan="9">Image uploaded</th>
		<th>Date</th>
		<th>Sender</th>
		<%}%>
		</tr>
	<%
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
		if ("email".equals(command)){%>
			<tr>
				<td colspan="9"><div class="tooltip" >
				<% if (row.getValue(13).indexOf("DCM") > 0) { %>
					<%=row.getValue(13).split("No of DCM Sent:")[1].split("\\(")[0]%>
				<%} %>
				  <span class="tooltiptext" style="left: 500%!important;"><%=row.getValue(1) %></span>
				</div></td>
				<td><%=row.getValue(8).substring(0,10) %></td>
				<td><%=sender%></td>
			</tr>
	<%	} else {
	%>
			<tr>
			<td>(<%=i+1%>)</td>
			<td><%=row.getValue(0) %></td>
			<td><%=row.getValue(1) %></td>
			<td><%=row.getValue(2) %></td>
			<td><%=row.getValue(3) %></td>
			<td style="max-width:150px !important; word-wrap:break-word;"><%=row.getValue(10) %></td>
			<td><%=row.getValue(4) %></td>
			<td><%=row.getValue(5) %></td>
			<td><%=row.getValue(6) %></td>
			<td><%=row.getValue(8) %><br><%=row.getValue(13) %></td>
			<td>
				 <div class="w3-container"><p>
				 <%if (!"R".equals(row.getValue(7))) { %>
					<button class="w3-btn w3-black updateToReady" onclick="updateR('<%=row.getValue(1)%>','<%=row.getValue(0)%>')">up To R</button><br>
				 <% }%>
				 <%if ("R".equals(row.getValue(7))) { %>
				 <div class="tooltip">
									<button class="w3-btn w3-red w3-margin-top sendCase sd<%=row.getValue(1)%>" onclick="sendBtnAction('<%=row.getValue(1)%>')">Send</button>

				  <span class="tooltiptext"><%=row.getValue(1) %></span>
				</div>
				<%} %>	
				 </p></div>
			 </td>

			</tr>
		<% 	 }
		  }
		%>
		</table>
		
<%	 }
	}%>	