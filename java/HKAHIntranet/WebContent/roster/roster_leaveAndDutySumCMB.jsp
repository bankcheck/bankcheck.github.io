<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="net.sf.json.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%!
public String getSubSql(String type, String startDate, String endDate, String deptCode) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT T1.CO_STAFF_ID, ");
	if (type.equals("H")) {
		sqlStr.append("DECODE(T2.TOTAL, NULL, 0, T2.TOTAL) AS H_TOTAL, ");
	}
	else if (type.equals("AL/ML/NSL")) {
		sqlStr.append("DECODE(T2.TOTAL, NULL, 0, T2.TOTAL) AS L_TOTAL, ");
	}
	else if (type.equals("EL")) {
		sqlStr.append("DECODE(T2.TOTAL, NULL, 0, T2.TOTAL) AS EL_TOTAL, ");
	}
	else if (type.equals("BL")) {
		sqlStr.append("DECODE(T2.TOTAL, NULL, 0, T2.TOTAL) AS BL_TOTAL, ");
	}
	else if (type.equals("CO")) {
		sqlStr.append("DECODE(T2.TOTAL, NULL, 0, T2.TOTAL) AS CO_TOTAL, ");
	}
	else if (type.equals("A")) {
		sqlStr.append("DECODE(T2.TOTAL, NULL, 0, T2.TOTAL) AS A_TOTAL, ");
	}
	else if (type.equals("P")) {
		sqlStr.append("DECODE(T2.TOTAL, NULL, 0, T2.TOTAL) AS P_TOTAL, ");
	}
	else if (type.equals("N")) {
		sqlStr.append("DECODE(T2.TOTAL, NULL, 0, T2.TOTAL) AS N_TOTAL, ");
	}
	
	sqlStr.append("T1.CO_STAFF_ROLE, T1.CO_STATUS "); 
	sqlStr.append("FROM ");
	sqlStr.append("( ");
	sqlStr.append("  SELECT S.CO_STATUS, R.CO_STAFF_ROLE, S.CO_STAFF_ID, ");
	sqlStr.append("          DECODE(S.CO_STAFFNAME, NULL, S.CO_FIRSTNAME||' '||S.CO_LASTNAME, S.CO_STAFFNAME) ");
	sqlStr.append("      FROM CO_STAFFS_ROSTER_POSITION R, CO_STAFFS S ");
	sqlStr.append("      WHERE S.CO_STAFF_ID = R.CO_STAFF_ID ");
	sqlStr.append("      AND S.CO_ENABLED = '1' ");
	sqlStr.append("		 AND R.CO_ENABLED = '1' ");
	sqlStr.append("		 AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	sqlStr.append(") T1, ");
	sqlStr.append("( ");
	sqlStr.append("  SELECT CO_STAFF_ID, TOTAL FROM ( ");
	sqlStr.append("      SELECT P.CO_STAFF_ROLE, S.CO_STATUS, S.CO_STAFF_ID, ");
	sqlStr.append("              COUNT(1) AS TOTAL ");
	sqlStr.append("      FROM CO_STAFFS_ROSTER_POSITION P, CO_STAFFS S, CO_STAFFS_ROSTER R ");
	sqlStr.append("      WHERE S.CO_STAFF_ID = P.CO_STAFF_ID ");
	sqlStr.append("      AND S.CO_STAFF_ID = R.CO_STAFF_ID ");
	sqlStr.append("      AND ( ");
	sqlStr.append("      R.CO_STAFF_DUTY_DATE >= TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("      AND R.CO_STAFF_DUTY_DATE <= TO_DATE('"+endDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("      OR R.CO_STAFF_DUTY_DATE IS NULL) ");
	sqlStr.append("      AND S.CO_ENABLED = '1' ");
	sqlStr.append("      AND R.CO_ENABLED = '1' ");
	sqlStr.append("      AND P.CO_ENABLED = '1' ");
	sqlStr.append("      AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	if (type.equals("H")) {
		sqlStr.append("  AND R.CO_STAFF_DUTY_CODE LIKE 'H%' ");
	}
	else if (type.equals("AL/ML/NSL")) {
		sqlStr.append("  AND (R.CO_STAFF_DUTY_CODE = 'AL' OR R.CO_STAFF_DUTY_CODE = 'ML' OR R.CO_STAFF_DUTY_CODE = 'NSL') ");
	}
	else if (type.equals("EL")) {
		sqlStr.append("  AND (R.CO_STAFF_DUTY_CODE = 'EL') ");
	}
	else if (type.equals("BL")) {
		sqlStr.append("  AND (R.CO_STAFF_DUTY_CODE = 'BL') ");
	}
	else if (type.equals("CO")) {
		sqlStr.append("  AND (R.CO_STAFF_DUTY_CODE = 'CO') ");
	}
	else if (type.equals("A")) {
		sqlStr.append("  AND (R.CO_STAFF_DUTY_CODE like 'A%' AND R.CO_STAFF_DUTY_CODE <> 'AL') ");
	}
	else if (type.equals("P")) {
		sqlStr.append("  AND (R.CO_STAFF_DUTY_CODE like 'P%') ");
	}
	else if (type.equals("N")) {
		sqlStr.append("  AND (R.CO_STAFF_DUTY_CODE like '%N%') ");
	}
	sqlStr.append("AND R.CO_STAFF_DUTY_CODE not like '%A/V%' ");
	sqlStr.append("AND R.CO_STAFF_DUTY_CODE not like '%NuOR%' ");
	if (!type.equals("A") && !type.equals("P") && !type.equals("N")) {
		sqlStr.append("      AND S.CO_STATUS <> 'CA' ");
	}
	sqlStr.append("      GROUP BY P.CO_STAFF_ROLE, S.CO_STATUS, S.CO_STAFF_ID ");
	sqlStr.append("      ) ");
	sqlStr.append(") T2 ");
	sqlStr.append("WHERE T1.CO_STAFF_ID = T2.CO_STAFF_ID(+) ");
	
	//System.out.println(sqlStr.toString());
	return sqlStr.toString();
}

public ArrayList getStaffRosterLnDList(String startDate, String endDate, String deptCode) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT T1.CO_STAFF_ID, H_TOTAL, L_TOTAL, EL_TOTAL, BL_TOTAL, ");
	sqlStr.append("		  CO_TOTAL, A_TOTAL, P_TOTAL, N_TOTAL ");
	sqlStr.append("FROM   ");
	sqlStr.append("("+getSubSql("H", startDate, endDate, deptCode)+") T1, ");
	sqlStr.append("("+getSubSql("AL/ML/NSL", startDate, endDate, deptCode)+") T2, ");
	sqlStr.append("("+getSubSql("EL", startDate, endDate, deptCode)+") T3, ");
	sqlStr.append("("+getSubSql("BL", startDate, endDate, deptCode)+") T4, ");
	sqlStr.append("("+getSubSql("CO", startDate, endDate, deptCode)+") T5, ");
	sqlStr.append("("+getSubSql("A", startDate, endDate, deptCode)+") T6, ");
	sqlStr.append("("+getSubSql("P", startDate, endDate, deptCode)+") T7, ");
	sqlStr.append("("+getSubSql("N", startDate, endDate, deptCode)+") T8 ");
	sqlStr.append("WHERE T1.CO_STAFF_ID = T2.CO_STAFF_ID ");
	sqlStr.append("AND T2.CO_STAFF_ID = T3.CO_STAFF_ID ");
	sqlStr.append("AND T3.CO_STAFF_ID = T4.CO_STAFF_ID ");
	sqlStr.append("AND T4.CO_STAFF_ID = T5.CO_STAFF_ID ");
	sqlStr.append("AND T5.CO_STAFF_ID = T6.CO_STAFF_ID ");
	sqlStr.append("AND T6.CO_STAFF_ID = T7.CO_STAFF_ID ");
	sqlStr.append("AND T7.CO_STAFF_ID = T8.CO_STAFF_ID ");
	sqlStr.append("ORDER BY T1.CO_STAFF_ROLE DESC, T1.CO_STATUS DESC, T1.CO_STAFF_ID ");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<% 
String recordCount = request.getParameter("row");
String deptCode = request.getParameter("deptCode");
String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");

JSONObject staffJSON = new JSONObject();
JSONArray jsonArray = new JSONArray();
JSONObject rootJSON = new JSONObject();

Calendar cal = Calendar.getInstance();
Calendar cal2 = Calendar.getInstance();
cal.set(Calendar.MONTH, Integer.parseInt(startDate.substring(2, 4), 10)-1);
cal.set(Calendar.YEAR, Integer.parseInt(startDate.substring(4)));
cal2.set(Calendar.MONTH, Integer.parseInt(endDate.substring(2, 4), 10)-1);
cal2.set(Calendar.YEAR, Integer.parseInt(endDate.substring(4)));
cal.set(Calendar.DATE, 21);
cal2.set(Calendar.DATE, 20);

SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
ArrayList record = getStaffRosterLnDList(sdf.format(cal.getTime()), sdf.format(cal2.getTime()), deptCode);

if (record.size() > 0) {
	ReportableListObject row = null;
	for (int i = 0; i < record.size(); i++) {
		staffJSON = new JSONObject();
		row = (ReportableListObject) record.get(i);
		
		staffJSON.put("empNo", row.getValue(0));
		staffJSON.put("h", row.getValue(1));
		staffJSON.put("alml", row.getValue(2));
		staffJSON.put("el", row.getValue(3));
		staffJSON.put("bl", row.getValue(4));
		staffJSON.put("co", row.getValue(5));
		staffJSON.put("all", String.valueOf(
								Integer.parseInt(row.getValue(1))+
								Integer.parseInt(row.getValue(2))+
								Integer.parseInt(row.getValue(3))+
								Integer.parseInt(row.getValue(4))+
								Integer.parseInt(row.getValue(5))
								));
		staffJSON.put("a", row.getValue(6));
		staffJSON.put("p", row.getValue(7));
		staffJSON.put("n", row.getValue(8));
		staffJSON.put("hours", String.valueOf(
									(Integer.parseInt(row.getValue(1))+
									Integer.parseInt(row.getValue(2))+
									Integer.parseInt(row.getValue(3))+
									Integer.parseInt(row.getValue(4))+
									Integer.parseInt(row.getValue(5))+
									Integer.parseInt(row.getValue(6))+
									Integer.parseInt(row.getValue(7))+
									Integer.parseInt(row.getValue(8))) * 8
									));
		jsonArray.add(staffJSON);
	}
	rootJSON.put("page", "1");
	rootJSON.put("total", "1");
	rootJSON.put("records", recordCount);
	rootJSON.put("rows", jsonArray);
	
	response.setContentType("application/json");
	//System.out.println(rootJSON.toString());
	PrintWriter writer = response.getWriter();
	writer.print(request.getParameter("callback")+"("+rootJSON.toString()+ ");");
	writer.close();
}
%>