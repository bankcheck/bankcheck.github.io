<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%@
page import="org.json.simple.JSONObject" %><%@ 
page import="java.io.PrintWriter" %><%@ 
page import="com.hkah.web.mobile.*"%><%@
page import="java.text.SimpleDateFormat" %><%@
page import="com.spreada.utils.chinese.ZHConverter" %><%@
page import="java.text.ParseException" %><%@
page import="java.util.Calendar" %>
<%!
private ArrayList getMsgList(UserBean userBean) {

		
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT DISTINCT ID, SUBSTR(ID,5) FROM DESCRIPTION_MAPPING@IWEB WHERE TYPE = 'MOBILEAPP' AND ID like 'MSG_%' ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getMsgContentList(UserBean userBean, String id) {

	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT  LANGUAGE,DESCRIPTION FROM DESCRIPTION_MAPPING@IWEB WHERE TYPE = 'MOBILEAPP' AND ID = '"+id+"' ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private String getMsgString(UserBean userBean, String type, String id, String lang) {

	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT  DESCRIPTION FROM DESCRIPTION_MAPPING@IWEB WHERE TYPE = '"+type+"' AND ID = '"+id+"' and LANGUAGE='"+lang+"' ");

	ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
	if(record.size() > 0){
		ReportableListObject row = (ReportableListObject) record.get(0);
		return row.getValue(0);
	} else {
		return null;
	}
}

private ArrayList getRecipientList(UserBean userBean, String patNo) {

	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT patno,patFname,patGname,patCname from patient@iweb where patno= UPPER('"+patNo+"') ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private static ArrayList getBookingList(UserBean userBean,String startDate, String patNo, String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT P.PATNO, patFname,patGname,patCname, ");//0, 1, 2, 3,
		sqlStr.append("D.DOCFNAME || ' ' || D.DOCGNAME, D.DOCCNAME, ");//4, 5
		sqlStr.append("TO_CHAR(B.BKGSDATE, 'DD'), TO_CHAR(B.BKGSDATE, 'MM'), ");//6, 7
		sqlStr.append("TO_CHAR(B.BKGSDATE, 'YYYY'), TO_CHAR(B.BKGSDATE, 'HH24'), ");//8, 9
		sqlStr.append("TO_CHAR(B.BKGSDATE, 'MI'), B.BKGID, B.SMSSDTOK, ");//10, 11, 12
		if (ConstantsServerSide.isTWAH()) {
		sqlStr.append("P.PATNO, P.PATPAGER,  "); //13,14
		} else {
		sqlStr.append("P.PATNO, P.PATPAGER, CD.CO_DISPLAYNAME, "); //13,14,15
		sqlStr.append("D.TITTLE, "); //tw 15 hk 16 
		sqlStr.append("S.DOCCODE, B.BKGSTS, to_char(B.BKGSDATE,'dd/mm/yyyy HH24:MI') "); // tw 16,17,18 hk 17,18,19
		}
		if (ConstantsServerSide.isTWAH()) {
		sqlStr.append("FROM BOOKING@IWEB B, SCHEDULE@IWEB S, DOCTOR@IWEB D, PATIENT@IWEB P ");
		} else {
		sqlStr.append("FROM BOOKING@IWEB B, SCHEDULE@IWEB S, DOCTOR@IWEB D, PATIENT@IWEB P, CO_DOCTORS CD ");
		}
		sqlStr.append("WHERE B.BKGSDATE >= ");
		sqlStr.append("TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND   B.BKGSDATE <= ");
		sqlStr.append("TO_DATE('"+startDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND   S.SCHID(+) = B.SCHID ");
		sqlStr.append("AND   D.DOCCODE(+) = S.DOCCODE ");
		sqlStr.append("AND   P.PATNO = B.PATNO ");
		if (ConstantsServerSide.isHKAH()) {
		//sqlStr.append("AND B.BKSID = '175' ");
		sqlStr.append("AND	 CD.CO_DOC_CODE(+) = S.DOCCODE ");
		}
		sqlStr.append("AND   B.BKGSTS = 'N' ");
		sqlStr.append("AND   (B.USRID <> 'HACCESS' OR (B.USRID = 'HACCESS' AND B.SMCID IS NOT NULL)) ");
		if (ConstantsServerSide.isHKAH()) {
		sqlStr.append("AND   CD.CO_DOC_CODE(+) = S.DOCCODE ");
		}
		/* sqlStr.append("AND   (P.PATSMS = '-1' OR P.PATNO IS NULL) "); */
		/* sqlStr.append("AND   (B.PATNO NOT IN ");
		sqlStr.append("( ");
		sqlStr.append("SELECT P.PATNO ");
		sqlStr.append("FROM PATIENT@IWEB P, BOOKING@IWEB B ");
		sqlStr.append("WHERE P.PATSMS = '0' ");
		sqlStr.append("AND B.BKGSDATE >= ");
		sqlStr.append("TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND   B.BKGSDATE <= ");
		sqlStr.append("TO_DATE('"+startDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND   P.PATNO = B.PATNO ");
		sqlStr.append("AND   B.BKGSTS = 'N' ");
		sqlStr.append(") OR B.PATNO IS NULL) "); */
		sqlStr.append("AND   D.DOCCODE <> 'N020' ");
		sqlStr.append("AND   D.DOCCODE <> 'N024' ");
		sqlStr.append("AND   D.DOCCODE <> 'N034' ");
		if ((patNo != null && !"".equals(patNo))) {
			sqlStr.append("AND B.PATNO='"+patNo+"' ");
		}
		
		if ((docCode != null && !"".equals(docCode))) {
			sqlStr.append("AND S.DOCCODE='"+docCode+"' ");
		}

		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
}

private String getHPStatus(String status,String key) {

	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT HPRMK FROM HPSTATUS@IWEB WHERE HPTYPE = 'MOBILEAPP' AND HPSTATUS = UPPER('"+status+"') AND  HPKEY = UPPER('"+key+"')");

	ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
	if(record.size() > 0){
		ReportableListObject row = (ReportableListObject) record.get(0);
		return row.getValue(0);
	} else {
		return null;
	}
	
}

public static boolean saveMsgLog(String errMsg, String keyId, String type, String tempLang, String smcId, int success,String user) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("INSERT INTO SMS_LOG(");
	sqlStr.append("RES_MSG, SUCCESS, SEND_TIME, SENDER, ACT_TYPE, KEY_ID, TEMPLATE_LANG, SMCID, SMS_AC ) ");
	sqlStr.append("VALUES (");
	sqlStr.append("'"+errMsg+"', ");
	sqlStr.append("'"+success+"', ");
	sqlStr.append("SYSDATE, ");
	sqlStr.append("'"+user+"', ");
	sqlStr.append("'"+type+"', ");
	sqlStr.append("'"+keyId+"', ");
	sqlStr.append("'"+tempLang+"', ");
	sqlStr.append("'"+smcId+"', ");
	sqlStr.append("'MOBILE') ");

	return UtilDBWeb.updateQueue(sqlStr.toString());
	
}

public Map<String,String> getDate(String datetime) {
	HashMap<String,String> dateTime = new HashMap<String,String>();
	
	Calendar startCal = Calendar.getInstance();
	SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy hh:mm", Locale.ENGLISH);	
	Date parsedDate= new Date();
	try
	{
		parsedDate = smf.parse(datetime);
		
	} catch (ParseException  e){
		
	}
	
	startCal.setTime(parsedDate);
	
	
	SimpleDateFormat esmf = new SimpleDateFormat("'on' EEE, MMM dd, yyyy' at 'h:mm a", Locale.ENGLISH);
	SimpleDateFormat csmf = new SimpleDateFormat("M月dd日Eah時mm分", Locale.CHINESE);
	SimpleDateFormat scsmf = new SimpleDateFormat("M月dd日Eah时mm分", Locale.SIMPLIFIED_CHINESE);
	SimpleDateFormat jcsmf = new SimpleDateFormat("M月dd日Eah時mm分", Locale.JAPAN);

	dateTime.put("ENG",esmf.format(startCal.getTime()));
	dateTime.put("TRC",csmf.format(startCal.getTime()).replaceAll("00分", ""));
	dateTime.put("SMC",scsmf.format(startCal.getTime()).replaceAll("00分", ""));
	dateTime.put("JAP",jcsmf.format(startCal.getTime()).replaceAll("00分", ""));
	
	
	return dateTime;
}


/* private boolean updatetoReady(String accessionNo) {
	StringBuffer sqlStr = new StringBuffer();


	return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {accessionNo} );
} */

%><%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String patNo = request.getParameter("patNo");
String docCode = request.getParameter("docCode");
String appDate = request.getParameter("appDate");
String message = request.getParameter("message");
String type = request.getParameter("type");
String msgID = request.getParameter("msgID");
String msgHK = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "msgHK"));
String msgCN = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "msgCN"));
String msgEN = request.getParameter("msgEN");
String bkgID = request.getParameter("bkgID");
String userID = request.getParameter("user");

if (userID == null || "".equals(userID)) {
	userID = userBean.getStaffID();
}

org.json.JSONObject resultJSON = new  org.json.JSONObject();
String token = null;

//ArrayList<ReportableListObject> record = getList(userBean,patNo, ckRdyUnSent, dateFrom);

ReportableListObject row = null;
ArrayList<ReportableListObject> record = null;
 if ("msgType".equals(type)) {
	 record = getMsgList(userBean);
	  if(record.size() > 0){%>
			<option value="">Choose your option</option>
		<%
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
		%>
			<option value="<%=row.getValue(0)%>"><%=row.getValue(1) %></option>
		<%	}
	  }
 }
 
 if (("msgContent").equals(type) && (msgID != null && !"".equals(msgID)) ) {
 	record = getMsgContentList(userBean,msgID);
 	JSONObject msgJSON = new JSONObject();

 	if(record.size() > 0) {
 		msgJSON.put("ID", msgID);
 		for (int i = 0; i < record.size(); i++) {		
			row = (ReportableListObject) record.get(i);
			if (!"".equals(msgJSON.get(row.getValue(0)))) {
		 		msgJSON.put(row.getValue(0), row.getValue(1));
			}
 		}
 		
 		response.setContentType("text/javascript");
 		PrintWriter writer = response.getWriter();
 		writer.print(request.getParameter("callback")+"("+msgJSON.toString()+ ");");
 		writer.close();
 	}
   }
 
 if ("getRecord".equals(type) && ((patNo != null && !"".equals(patNo)) || (appDate != null && !"".equals(appDate))) ) {
	 	if(appDate == null || "".equals(appDate)) {
			 record = getRecipientList(userBean,patNo);
			  if(record.size() > 0){%>
				  <table class="w3-table-all">
					<tr>
					  <th>Pat No</th>
					  <th>Pat Family Name</th>
					  <th>Pat Given Name</th>
					  <th>Pat Chinese Name</th>
		
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
					</tr>
					<%}
					%>
					</table>
			<%} %>
		<%}  else {
				record = getBookingList(userBean,appDate, patNo,docCode);
			  if(record.size() > 0){%>
				  <table class="w3-table-all">
					<tr>
					  <th>Pat No</th>
					  <th>Pat Family Name</th>
					  <th>Pat Given Name</th>
					  <th>Pat Chinese Name</th>
					  <th>Doc Name</th>
					  <th>Doc Chinese Name</th>
					  <th>Booking Time</th>
		
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
					<td><%=row.getValue(4) %></td>
					<td><%=row.getValue(5) %></td>
					<td><%=row.getValue(9)+":"+row.getValue(10) %></td>
					</tr>
					<%}
					%>
					</table>
		<%} %>	
	<%	}%>
 <%} 
 if ("sendMsg".equals(type)) {
		token = NotifyService.getToken(
				getHPStatus("token","target"),
				getHPStatus("token","path"),
				getHPStatus("token","OCPKEY"),
				getHPStatus("token","AUTH"),
				getHPStatus("token","USERNAME"),
				getHPStatus("token","PASSWORD"));
		
		if (token != null && !"".equals(token)) {
			String msgResult = NotifyService.sendMsg(
					getHPStatus("INAPPMSG_BK","TARGET"),
					getHPStatus("INAPPMSG_BK","PATH"),
					token,
					NotifyService.getMsgJSONString(patNo, bkgID, msgEN, msgHK, msgCN));
			
			if (msgResult != null && msgResult.length() > 0) {
				resultJSON = new  org.json.JSONObject(msgResult);
				boolean isSuccess = false;
				if (resultJSON.has("success")) {
					isSuccess = (Boolean) resultJSON.get("success");
				} else {
					isSuccess = false;
				}
				
				saveMsgLog((String)resultJSON.get("status"), patNo,
						"mobile", "", "",isSuccess?1:0, (userID == null || "".equals(userID)?"SYSTEM":userID));
				%>
				<%=isSuccess?"Success":"Fail" %>
			<%}
		}
		
 } 
 	if ("sendListMsg".equals(type) && ((patNo != null && !"".equals(patNo)) || (appDate != null && !"".equals(appDate))) ) {
	 	if(appDate == null || "".equals(appDate)) {
				 record = getRecipientList(userBean,patNo);
		} else {
			record = getBookingList(userBean,appDate, patNo, docCode);
		}
	 	if(record.size() > 0){
 				token = NotifyService.getToken(
				getHPStatus("token","target"),
				getHPStatus("token","path"),
				getHPStatus("token","OCPKEY"),
				getHPStatus("token","AUTH"),
				getHPStatus("token","USERNAME"),
				getHPStatus("token","PASSWORD"));
		
				if (token != null && !"".equals(token) && !"-999".equals(token)) {
					int success = 0;
					int fail= 0;
					String failReason = "";
					for (int i = 0; i < record.size(); i++) {

						row = (ReportableListObject) record.get(i);
						if (appDate != null && !"".equals(appDate)) {
							Map<String,String > date = getDate(row.getValue(19));
							msgEN = msgEN.replace("{dateTime}",date.get("ENG"));
							msgHK = msgHK.replace("{dateTime}",date.get("TRC"));
							msgCN = msgCN.replace("{dateTime}",date.get("SMC"));
							
							if (row.getValue(4) != null && !"".equals(row.getValue(4))) {
								msgEN = msgEN.replace("{doctor}",row.getValue(16)+row.getValue(4));
								if (row.getValue(5)!= null && !"".equals(row.getValue(5))) {
									msgHK = msgHK.replace("{doctor}",row.getValue(5)
											+getMsgString(userBean, "MAPLANGUAGE",row.getValue(16), "zh-HK"));
									msgCN = msgCN.replace("{doctor}",ZHConverter.convert(row.getValue(5), ZHConverter.SIMPLIFIED)
											+getMsgString(userBean, "MAPLANGUAGE",row.getValue(16), "zh-CN"));
								}
							}
						}
						

						
						String msgResult = NotifyService.sendMsg(
								getHPStatus("INAPPMSG_BK","TARGET"),
								getHPStatus("INAPPMSG_BK","PATH"),
								token,
								NotifyService.getMsgJSONString(row.getValue(0), row.getSize() > 4?row.getValue(11):"100", msgEN, msgHK, msgCN));
						
						
						if (msgResult != null && msgResult.length() > 0) {
							resultJSON = new  org.json.JSONObject(msgResult);
							boolean isSuccess = false;
							if (resultJSON.has("success")) {
								isSuccess = (Boolean) resultJSON.get("success");
							} else {
								isSuccess = false;
							}
							failReason = failReason+ " "+(!isSuccess?(String) resultJSON.get("error"):"");
							if(isSuccess){success++;}else{fail++;};
								saveMsgLog((String)resultJSON.get("status"), 
										((appDate == null || "".equals(appDate))?(String)row.getValue(0):(String)row.getValue(11))
										,"mobile2", "", "",isSuccess?1:0, (userID == null || "".equals(userID)?"SYSTEM":userID));
							%>
						<%}
					}%>							
					<%="Success Msg:"+Integer.toString(success)+"<br>Fail Msg:"+Integer.toString(fail)+((!"".equals(failReason.trim()))?"<br>("+failReason+")":"") %>
					
				<%} else {%>
					<%="Fail: Fail to get Token" %>
				<%}
	 	}
 	
 } %>	