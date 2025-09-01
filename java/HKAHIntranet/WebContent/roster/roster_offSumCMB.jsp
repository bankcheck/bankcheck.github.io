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
public ArrayList getStaffRosterOffList(String startDate, String endDate, String deptCode) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT  T1.CO_STAFF_ID, T1.DAYNAME, DECODE(OFF_TOTAL, NULL, 0, OFF_TOTAL), "); 
	sqlStr.append("    		DECODE(NIGHT_TOTAL, NULL, 0, NIGHT_TOTAL) ");
	sqlStr.append("FROM ( ");
	sqlStr.append("    SELECT T1.CO_STAFF_ID, T2.DAYNAME, T2.TOTAL AS OFF_TOTAL, T1.CO_STAFF_ROLE, T1.CO_STATUS ");
	sqlStr.append("    FROM   ( ");
	sqlStr.append("              SELECT S.CO_STATUS, R.CO_STAFF_ROLE, S.CO_STAFF_ID, ");
	sqlStr.append("                      DECODE(S.CO_STAFFNAME, NULL, S.CO_FIRSTNAME||' '||S.CO_LASTNAME, S.CO_STAFFNAME) ");
	sqlStr.append("              FROM CO_STAFFS_ROSTER_POSITION R, CO_STAFFS S ");
	sqlStr.append("              WHERE S.CO_STAFF_ID = R.CO_STAFF_ID ");
	sqlStr.append("              AND S.CO_ENABLED = '1' ");
	sqlStr.append("              AND R.CO_ENABLED = '1' ");
	sqlStr.append("              AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	sqlStr.append("          )T1, ");
	sqlStr.append("          ( ");
	sqlStr.append("              SELECT CO_STAFF_ID, CO_STAFF_DUTY_CODE, DAYNAME, TOTAL ");
	sqlStr.append("              FROM ( ");
	sqlStr.append("                     SELECT P.CO_STAFF_ROLE, S.CO_STATUS, S.CO_STAFF_ID, R.CO_STAFF_DUTY_CODE, ");
	sqlStr.append("                            TO_CHAR (R.CO_STAFF_DUTY_DATE, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') AS DAYNAME, ");
	sqlStr.append("                            COUNT(1) AS TOTAL ");
	sqlStr.append("                     FROM CO_STAFFS_ROSTER_POSITION P, CO_STAFFS S, CO_STAFFS_ROSTER R ");
	sqlStr.append("                     WHERE S.CO_STAFF_ID = P.CO_STAFF_ID ");
	sqlStr.append("                     AND S.CO_STAFF_ID = R.CO_STAFF_ID ");
	sqlStr.append("                     AND ( ");
	sqlStr.append("                             R.CO_STAFF_DUTY_DATE >= TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("                             AND R.CO_STAFF_DUTY_DATE <= TO_DATE('"+endDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("                             AND TO_CHAR (R.CO_STAFF_DUTY_DATE, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') IN ('SAT', 'SUN') ");
	sqlStr.append("                             OR R.CO_STAFF_DUTY_DATE IS NULL ");
	sqlStr.append("                         ) ");
	sqlStr.append("                     AND S.CO_ENABLED = '1' ");
	sqlStr.append("                     AND R.CO_ENABLED = '1' ");
	sqlStr.append("                     AND P.CO_ENABLED = '1' ");
	sqlStr.append("                     AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	sqlStr.append("                     AND R.CO_STAFF_DUTY_CODE = '/' ");
	sqlStr.append("                     AND S.CO_STATUS <> 'CA' ");
	sqlStr.append("                     GROUP BY P.CO_STAFF_ROLE, S.CO_STATUS, S.CO_STAFF_ID, R.CO_STAFF_DUTY_CODE, ");
	sqlStr.append("                              TO_CHAR (R.CO_STAFF_DUTY_DATE, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') ");
	sqlStr.append("                  ) ");
	sqlStr.append("            )T2 ");
	sqlStr.append("    WHERE T1.CO_STAFF_ID = T2.CO_STAFF_ID(+) ");
	sqlStr.append(") T1, ( ");
	sqlStr.append("    SELECT T1.CO_STAFF_ID, T2.TOTAL AS NIGHT_TOTAL, T1.CO_STAFF_ROLE, T1.CO_STATUS ");
	sqlStr.append("    FROM   ( ");
	sqlStr.append("              SELECT S.CO_STATUS, R.CO_STAFF_ROLE, S.CO_STAFF_ID, ");
	sqlStr.append("                     DECODE(S.CO_STAFFNAME, NULL, S.CO_FIRSTNAME||' '||S.CO_LASTNAME, S.CO_STAFFNAME) ");
	sqlStr.append("              FROM CO_STAFFS_ROSTER_POSITION R, CO_STAFFS S ");
	sqlStr.append("              WHERE S.CO_STAFF_ID = R.CO_STAFF_ID ");
	sqlStr.append("              AND S.CO_ENABLED = '1' ");
	sqlStr.append("              AND R.CO_ENABLED = '1' ");
	sqlStr.append("              AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	sqlStr.append("           )T1, ");
	sqlStr.append("          ( ");
	sqlStr.append("             SELECT CO_STAFF_ID, TOTAL ");
	sqlStr.append("             FROM ( ");
	sqlStr.append("                    SELECT P.CO_STAFF_ROLE, S.CO_STATUS, S.CO_STAFF_ID, COUNT(1) AS TOTAL ");
	sqlStr.append("                    FROM CO_STAFFS_ROSTER_POSITION P, CO_STAFFS S, CO_STAFFS_ROSTER R ");
	sqlStr.append("                    WHERE S.CO_STAFF_ID = P.CO_STAFF_ID ");
	sqlStr.append("                    AND S.CO_STAFF_ID = R.CO_STAFF_ID ");
	sqlStr.append("                    AND ( ");
	sqlStr.append("                          R.CO_STAFF_DUTY_DATE >= TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("                          AND R.CO_STAFF_DUTY_DATE <= TO_DATE('"+endDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("                          AND TO_CHAR (R.CO_STAFF_DUTY_DATE, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') IN ('SAT', 'SUN') ");
	sqlStr.append("                          OR R.CO_STAFF_DUTY_DATE IS NULL) ");
	sqlStr.append("                    AND S.CO_ENABLED = '1' ");
	sqlStr.append("                    AND R.CO_ENABLED = '1' ");
	sqlStr.append("                    AND P.CO_ENABLED = '1' ");
	sqlStr.append("                    AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	sqlStr.append("                    AND R.CO_STAFF_DUTY_CODE LIKE '%N' ");
	sqlStr.append("                    AND S.CO_STATUS <> 'CA' ");
	sqlStr.append("                    GROUP BY P.CO_STAFF_ROLE, S.CO_STATUS, S.CO_STAFF_ID ");
    sqlStr.append("                  ) "); 
    sqlStr.append("           )T2 ");   
    sqlStr.append("WHERE T1.CO_STAFF_ID = T2.CO_STAFF_ID(+) ");
    sqlStr.append(") T2 ");
	sqlStr.append("WHERE T1.CO_STAFF_ID = T2.CO_STAFF_ID ");
	sqlStr.append("ORDER BY T1.CO_STAFF_ROLE DESC, T1.CO_STATUS DESC, T1.CO_STAFF_ID, T1.DAYNAME "); 
	
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

ArrayList record = getStaffRosterOffList(sdf.format(cal.getTime()), 
											sdf.format(cal2.getTime()),
											deptCode);

if (record.size() > 0) {
	ReportableListObject row1 = null;
	ReportableListObject row2 = null;
	String curStaff = "";
	for (int i = 0; i < record.size(); i++) {
		row1 = (ReportableListObject) record.get(i);
		row2 = null;
		staffJSON = new JSONObject();
		
		staffJSON.put("satOff", "0");
		staffJSON.put("sunOff", "0");
		
		if (i == record.size()-1) {
			//last row
			staffJSON.put("empNo", row1.getValue(0));
			if (!row1.getValue(1).equals("")) {
				if (row1.getValue(1).equals("SAT")) {
					staffJSON.put("satOff", row1.getValue(2));
				}
				else if (row1.getValue(1).equals("SUN")) {
					staffJSON.put("sunOff", row1.getValue(2));
				}
			}
			else {
				staffJSON.put("satOff", "0");
				staffJSON.put("sunOff", "0");
			}
			staffJSON.put("totalOff", row1.getValue(2));
			staffJSON.put("WkEndN", row1.getValue(3));
		}
		else {
			row2 = (ReportableListObject) record.get(i+1);
		}
		
		if (row2 != null && row1.getValue(0).equals(row2.getValue(0))) {
			i++;
			staffJSON.put("empNo", row1.getValue(0));
			staffJSON.put("satOff", row1.getValue(2));
			staffJSON.put("sunOff", row2.getValue(2));
			staffJSON.put("totalOff", 
					String.valueOf(
							Integer.parseInt(row1.getValue(2).equals("")?"0":row1.getValue(2))+
							Integer.parseInt(row2.getValue(2).equals("")?"0":row2.getValue(2))));
			staffJSON.put("WkEndN", row1.getValue(3).equals("")?"0":row1.getValue(3));
		}
		else {
			staffJSON.put("empNo", row1.getValue(0));
			if (!row1.getValue(1).equals("")) {
				if (row1.getValue(1).equals("SAT")) {
					staffJSON.put("satOff", row1.getValue(2));
				}
				else if (row1.getValue(1).equals("SUN")) {
					staffJSON.put("sunOff", row1.getValue(2));
				}
			}else {
				staffJSON.put("satOff", "0");
				staffJSON.put("sunOff", "0");
			}
			staffJSON.put("totalOff", row1.getValue(2));
			staffJSON.put("WkEndN", row1.getValue(3));
		}
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
