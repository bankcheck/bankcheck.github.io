<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.net.MalformedURLException"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private boolean entryBabyTrack(String patno, String locid, String user){
		String sql = 	"INSERT INTO BABYTRACKING " + 
						"(TRACKID, PATNO, BEDCODE, ENTRYDATE, ENTRYUSER ) " +
						"VALUES " +
						"(SEQ_BABYTRACKID.nextval, ?, ?, SYSDATE, ?) ";
		//System.out.println(sql.toString());
		return UtilDBWeb.updateQueueHATS( sql, new String[] { patno, locid, user });
	}

	private boolean returnBabyTrack(String patno, String user){
		String sql = 	"UPDATE BABYTRACKING SET " + 
						"RETURNDATE = SYSDATE, RETURNUSER = ? " +
						"WHERE " +
						"TRACKID IN " +
						"(SELECT MAX(TRACKID) FROM BABYTRACKING WHERE PATNO = ?) " + 
						"AND RETURNDATE IS NULL " ;
		return UtilDBWeb.updateQueueHATS( sql, new String[] { user, patno });
	}
	
	private boolean newBornRecord(String patno, String locid, String user){
		String sql = 	"INSERT INTO BABYTRACKING " + 
						"(TRACKID, PATNO, BEDCODE, ENTRYDATE, ENTRYUSER, RETURNDATE, RETURNUSER ) " +
						"VALUES " +
						"(SEQ_BABYTRACKID.nextval, ?, ?, SYSDATE, ?, SYSDATE, ?) ";
		//System.out.println(sql.toString());
		return UtilDBWeb.updateQueueHATS( sql, new String[] { patno, locid, user, user });
	}
	
	private boolean dischargeBabyRecord(String patno, String locid, String user){
		String sql1 = 	"INSERT INTO BABYTRACKING " + 
						"(TRACKID, PATNO, BEDCODE, ENTRYDATE, ENTRYUSER, RETURNDATE, RETURNUSER ) " +
						"VALUES " +
						"(SEQ_BABYTRACKID.nextval, ?, ?, SYSDATE, ?, SYSDATE, ?) ";
		String sql2 = 	"UPDATE BABYTRACKING SET " + 
						"ENABLED = 0 " +
						"WHERE " +
						"PATNO = ? "; 
		return UtilDBWeb.updateQueueHATS( sql1, new String[] { patno, locid, user, user }) && UtilDBWeb.updateQueueHATS( sql2, new String[] { patno });
	}

	private ArrayList<ReportableListObject> getBabyHistory(String patno){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT B.TRACKID, B.PATNO, P.PATFNAME || ' ' || P.PATGNAME, B.BEDCODE, B.ENTRYUSER, S.CO_STAFFNAME, TO_CHAR(B.ENTRYDATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("B.RETURNUSER, R.CO_STAFFNAME, TO_CHAR(B.RETURNDATE, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM BABYTRACKING@IWEB B, PATIENT@IWEB P, CO_STAFFS S ");
		sqlStr.append(", (	SELECT B.TRACKID, B.RETURNUSER, S.CO_STAFFNAME, TO_CHAR(B.RETURNDATE, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("		FROM BABYTRACKING@IWEB B, CO_STAFFS S ");
		sqlStr.append("		WHERE B.RETURNUSER = S.CO_STAFF_ID) R ");
		sqlStr.append("WHERE B.PATNO = P.PATNO ");
		sqlStr.append("AND B.ENTRYUSER = S.CO_STAFF_ID ");
		sqlStr.append("AND B.TRACKID = R.TRACKID (+) ");
		if (patno != null && patno.length()>0 ){ 
			sqlStr.append("AND B.PATNO = '"+patno+"' ");
		}
		sqlStr.append("AND B.RETURNDATE IS NULL ");	
		sqlStr.append("AND ENABLED = 1 ");
		sqlStr.append("ORDER BY B.ENTRYDATE DESC ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> getCurrentNurseryRecord(String patno){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT B.TRACKID ");
		sqlStr.append("FROM BABYTRACKING B ");
		sqlStr.append("WHERE B.PATNO = '"+patno+"' ");
		sqlStr.append("AND B.BEDCODE = 'Nursery' ");	
		sqlStr.append("AND ENABLED = 1 ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
%>
<%
String mode = request.getParameter("mode"); 
String patno = request.getParameter("patno");
String userid = request.getParameter("userid");
String locid = request.getParameter("locid");
String msg = "";
boolean success = false;

if ("IN".equals(mode)){
	// check pat in nursery or not
	ArrayList<ReportableListObject> record = getBabyHistory(patno);
	if (record.size() == 0){
		ArrayList<ReportableListObject> record2 = getCurrentNurseryRecord(patno);
		if (record2.size() == 0){
			msg = "The baby have not yet add to Nursery.";
		}else{
			success = entryBabyTrack(patno, locid, userid);
		}
		
	}else{
		msg = "The baby have no return record, therefore new record cannot be added.";
	}
}else if ("OUT".equals(mode)){
	success = returnBabyTrack(patno, userid);
}else if ("newBorn".equals(mode)){
	// check pat in nursery or not
	ArrayList<ReportableListObject> record = getCurrentNurseryRecord(patno);
	if (record.size() == 0){
		success = newBornRecord(patno, locid, userid);
	}else{
		msg = "The baby have already added in Nursery.";
	}
}else if ("discharge".equals(mode)){
	success = dischargeBabyRecord(patno, locid, userid);
}else{
	msg = "Update fail.";
}
if(msg.length() == 0 || "".equals(msg)){
	if(success){
		msg = "Baby Tracking Success.";
	}else{
		msg = "Update fail.";
	}
}
%>
<%=msg %>