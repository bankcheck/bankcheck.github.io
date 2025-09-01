<%@page import="com.hkah.util.*"%>
<%@page import="com.hkah.util.db.*"%>
<%@page import="java.util.*"%>
<%@page import="com.hkah.servlet.*"%>
<%@page import="com.hkah.web.common.*"%>
<%! 
	private String getField(String field, String date, String acm, String ward) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT "+field+" ");
		sqlStr.append("FROM HAT_BED_STAT ");
		sqlStr.append("WHERE HAT_ACMCODE = '"+acm+"' AND ");
		sqlStr.append("HAT_WRDCODE = '"+ward+"' AND ");
		sqlStr.append("HAT_PERIOD BETWEEN TRUNC(TO_Date('");
		sqlStr.append(date);
		sqlStr.append("', 'dd/mm/yyyy')) AND ");
		sqlStr.append("TRUNC(TO_Date('");
		sqlStr.append(date);
		sqlStr.append("', 'dd/mm/yyyy')) ");
		
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject row = null;
		
		if(record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		}
		return "";
	}

	private boolean updateBedStat(String total, String date, String acm, String ward) {
		int newAvailable = Integer.parseInt(getField("HAT_AVAILABLE", date, acm, ward)) + Integer.parseInt(total) - Integer.parseInt(getField("HAT_ADJUST", date, acm, ward));
		int newTotal = Integer.parseInt(getField("HAT_TOTAL", date, acm, ward)) + Integer.parseInt(total) - Integer.parseInt(getField("HAT_ADJUST", date, acm, ward));
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE   HAT_BED_STAT ");
		sqlStr.append("SET HAT_ADJUST = '"+total+"', ");
		sqlStr.append("HAT_AVAILABLE = '"+String.valueOf(newAvailable)+"', ");
		sqlStr.append("HAT_TOTAL = '"+String.valueOf(newTotal)+"' ");
		sqlStr.append("WHERE HAT_ACMCODE = '"+acm+"' AND ");
		sqlStr.append("HAT_WRDCODE = '"+ward+"' AND ");
		sqlStr.append("HAT_PERIOD BETWEEN TRUNC(TO_Date('");
		sqlStr.append(date);
		sqlStr.append("', 'dd/mm/yyyy')) AND ");
		sqlStr.append("TRUNC(TO_Date('");
		sqlStr.append(date);
		sqlStr.append("', 'dd/mm/yyyy')) ");
		
		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	private boolean updateLog(String enable, String acm, String ward, String rm, 
			String bed, String date, String change, UserBean userBean) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO HAT_BED_DETAIL_LOG (");
		sqlStr.append("HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE, ");
		sqlStr.append("HAT_ROMCODE, HAT_BEDCODE, HAT_STATUS, ");
		sqlStr.append("HAT_CREATED_DATE, HAT_CREATED_USER, HAT_MODIFIED_DATE, HAT_MODIFIED_USER, HAT_ENABLED) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(TO_Date('"+date+"', 'dd/mm/yyyy'), '"+ward+"', (select ACMCODE from ACM@IWEB WHERE  ACMNAME like '"+acm+"'), ");
		sqlStr.append("'"+rm+"', '"+bed+"', '"+change+"', SYSDATE, '"+userBean.getLoginID()+"', SYSDATE, '"+userBean.getLoginID()+"', '"+enable+"' )");
			
		System.err.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	private boolean updateBedEnable(String enable, String acm, String ward, String rm, 
							String bed, String date, String change) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE   HAT_BED_DETAIL ");
		if(change.equals("R") || change.equals("X") || change.equals("U")) {
			sqlStr.append("SET HAT_ENABLED = '"+enable+"' ");
		}
		else {
			sqlStr.append("SET HAT_ACMCODE = '"+change+"' ");
		}
		sqlStr.append("WHERE HAT_ACMCODE = (select ACMCODE from ACM@IWEB WHERE  ACMNAME like '"+acm+"') AND ");
		sqlStr.append("HAT_WRDCODE = '"+ward+"' AND ");
		sqlStr.append("HAT_ROMCODE = '"+rm+"' AND ");
		if((change.equals("R") || change.equals("X") || change.equals("U"))) {
			sqlStr.append("HAT_BEDCODE = '"+bed+"' AND ");
		}
		if(true) {
			sqlStr.append("HAT_PERIOD >= TRUNC(TO_Date('");
			sqlStr.append(date);
			sqlStr.append("', 'dd/mm/yyyy')) ");
		}
		else {
			sqlStr.append("HAT_PERIOD BETWEEN TRUNC(TO_Date('");
			sqlStr.append(date);
			sqlStr.append("', 'dd/mm/yyyy')) AND ");
			sqlStr.append("TRUNC(TO_Date('");
			sqlStr.append(date);
			sqlStr.append("', 'dd/mm/yyyy')) ");
		}
		
		System.err.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	private boolean resetBedClass(String rm, String bed, String date) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE HAT_BED_DETAIL ");
		sqlStr.append("SET HAT_ACMCODE = (SELECT ACMCODE FROM ROOM@IWEB WHERE ROMCODE='"+rm+"') ");
		sqlStr.append("WHERE HAT_BEDCODE = '"+bed+"' ");
		sqlStr.append("AND HAT_PERIOD >= TO_DATE('"+date+"', 'dd/mm/yyyy') ");
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
%>

<%
String type = request.getParameter("type");
String total = request.getParameter("total");
String date = request.getParameter("date");
String acm = request.getParameter("acm");
String ward = request.getParameter("ward");
String enable = request.getParameter("enable");
String rm = request.getParameter("rm");
String bed = request.getParameter("bed");
String change = request.getParameter("change");
String blockBeds = request.getParameter("blockBed");
UserBean userBean = new UserBean(request);

String success = "false";
if(type.equals("update"))
	success = String.valueOf(updateBedStat(total, date, acm, ward));
else if(type.equals("enable")) {
	if(change.equals("R") || change.equals("X") || change.equals("U")) {
		updateBedEnable("1", acm, ward, rm, bed, date, "U");
	}
	else{
		if(blockBeds != null && blockBeds.length() > 0) {
			String[] bBed = blockBeds.split(":");
			for(int i = 0; i < bBed.length; i++) {
				updateBedEnable("0", acm, ward, rm, bBed[i], date, "X");
				updateLog("0", acm, ward, rm, bBed[i], date, "X", userBean);
			}
		}
	}
	success = String.valueOf(updateBedEnable(enable, acm, ward, rm, bed, date, change));
	if(change.equals("U")) {
		resetBedClass(rm, bed, date);
	}
	if(change.equals("R") || change.equals("X") || change.equals("U")) {
		updateLog(enable, acm, ward, rm, bed, date, change, userBean);
	}
}else
	success = getField("HAT_ADJUST", date, acm, ward);

%>

<%=success%>