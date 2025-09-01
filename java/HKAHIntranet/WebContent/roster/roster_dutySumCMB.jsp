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
public ArrayList getMinusTotal(String startDate, String endDate, String deptCode) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT P.CO_STAFF_ROLE, TO_CHAR(R.CO_STAFF_DUTY_DATE, 'DDMMYYYY'), ");
	sqlStr.append("	    R.CO_STAFF_DUTY_CODE, ");
	sqlStr.append("	    COUNT(1) AS TOTAL, R.CO_STAFF_DUTY_DATE ");
	sqlStr.append("FROM CO_STAFFS_ROSTER_POSITION P, CO_STAFFS S, CO_STAFFS_ROSTER R ");
	sqlStr.append("WHERE S.CO_STAFF_ID = P.CO_STAFF_ID ");
	sqlStr.append("AND S.CO_STAFF_ID = R.CO_STAFF_ID ");
	sqlStr.append("AND R.CO_STAFF_DUTY_DATE >= TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");   
	sqlStr.append("AND R.CO_STAFF_DUTY_DATE <= TO_DATE('"+endDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND (P.CO_STAFF_ROLE = 'SRN') ");
	sqlStr.append("AND R.CO_STAFF_DUTY_CODE LIKE 'PDM%' ");
	sqlStr.append("AND S.CO_ENABLED = '1' ");
	sqlStr.append("AND P.CO_ENABLED = '1' ");
	sqlStr.append("AND R.CO_ENABLED = '1' ");
	sqlStr.append(" AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	sqlStr.append("GROUP BY P.CO_STAFF_ROLE, R.CO_STAFF_DUTY_DATE, R.CO_STAFF_DUTY_CODE ");
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public ArrayList getStaffRosterSumList(String time, String startDate, String endDate, String deptCode) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT * FROM ( ");
	sqlStr.append(" SELECT P.CO_STAFF_ROLE, TO_CHAR(R.CO_STAFF_DUTY_DATE, 'DDMMYYYY'), ");
	if (time.equals("A")) {
		sqlStr.append("DECODE(P.CO_STAFF_ROLE, ");
		sqlStr.append("'HCA', ");
        sqlStr.append("CASE WHEN R.CO_STAFF_DUTY_CODE LIKE 'A%' THEN 'A' END, ");
        sqlStr.append("'SRN', ");                    
        sqlStr.append("CASE WHEN R.CO_STAFF_DUTY_CODE LIKE 'A%' THEN 'A' END, ");
        sqlStr.append("'RN', ");                    
        sqlStr.append("CASE WHEN R.CO_STAFF_DUTY_CODE LIKE 'A%' THEN 'A' END, '') AS SHIFT, ");
	}
	else if (time.equals("P")) {
		sqlStr.append("DECODE(P.CO_STAFF_ROLE, ");
		sqlStr.append("'HCA', ");                    
		sqlStr.append("CASE WHEN R.CO_STAFF_DUTY_CODE LIKE 'P' THEN 'P' END, ");
		sqlStr.append("'SRN', ");                    
		sqlStr.append("CASE WHEN R.CO_STAFF_DUTY_CODE LIKE 'P%' THEN 'P' END, ");
		sqlStr.append("'RN', ");                    
		sqlStr.append("CASE WHEN (R.CO_STAFF_DUTY_CODE LIKE 'P%') THEN ( ");
		sqlStr.append("    CASE WHEN (R.CO_STAFF_DUTY_CODE NOT LIKE '%PDM%') THEN 'P' END) ");
		sqlStr.append("END, '') AS SHIFT, ");
	}
	else if (time.equals("N")) {
		sqlStr.append("DECODE(P.CO_STAFF_ROLE, ");
		sqlStr.append("'HCA', "); 
		sqlStr.append("CASE WHEN R.CO_STAFF_DUTY_CODE LIKE '%N' THEN 'N' END, ");
		sqlStr.append("'SRN', ");                     
		sqlStr.append("CASE WHEN R.CO_STAFF_DUTY_CODE LIKE '%N%' THEN 'N' END, ");
		sqlStr.append("'RN', ");                    
		sqlStr.append("CASE WHEN R.CO_STAFF_DUTY_CODE LIKE '%N%' THEN 'N' END, ");
		sqlStr.append("'') AS SHIFT, ");
	}
    sqlStr.append("COUNT(1) AS TOTAL, ");
    sqlStr.append(" DECODE(P.CO_STAFF_ROLE, 'HCA', '1', 'SRN', '2', 'RN', '3') AS CO_STAFF_ORDER, ");
    sqlStr.append(" R.CO_STAFF_DUTY_DATE ");
    sqlStr.append(" FROM CO_STAFFS_ROSTER_POSITION P, CO_STAFFS S, CO_STAFFS_ROSTER R ");
    sqlStr.append(" WHERE S.CO_STAFF_ID = P.CO_STAFF_ID ");
    sqlStr.append(" AND S.CO_STAFF_ID = R.CO_STAFF_ID ");
    sqlStr.append(" AND R.CO_STAFF_DUTY_DATE >= TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");   
    sqlStr.append(" AND R.CO_STAFF_DUTY_DATE <= TO_DATE('"+endDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
    sqlStr.append(" AND (P.CO_STAFF_ROLE = 'RN' OR P.CO_STAFF_ROLE = 'SRN' OR P.CO_STAFF_ROLE = 'HCA') ");
    sqlStr.append(" AND R.CO_STAFF_DUTY_CODE <> 'AL' ");
    sqlStr.append(" AND R.CO_STAFF_DUTY_CODE <> 'A A/V' ");  
    sqlStr.append(" AND R.CO_STAFF_DUTY_CODE <> 'P A/V' ");
    sqlStr.append(" AND R.CO_STAFF_DUTY_CODE <> 'N A/V' ");
    sqlStr.append(" AND R.CO_STAFF_DUTY_CODE <> 'NPL' ");
    sqlStr.append(" AND R.CO_STAFF_DUTY_CODE NOT LIKE '%NuOR%' ");
    sqlStr.append(" AND S.CO_ENABLED = '1' ");
    sqlStr.append(" AND P.CO_ENABLED = '1' ");
    sqlStr.append(" AND R.CO_ENABLED = '1' ");
    sqlStr.append(" AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
    if (time.equals("A")) {
    	sqlStr.append("GROUP BY P.CO_STAFF_ROLE, R.CO_STAFF_DUTY_DATE, ");
    	sqlStr.append("DECODE(P.CO_STAFF_ROLE, 'HCA', CASE WHEN R.CO_STAFF_DUTY_CODE LIKE 'A%' THEN 'A' END, ");
       	sqlStr.append("'SRN', CASE WHEN R.CO_STAFF_DUTY_CODE LIKE 'A%' THEN 'A' END, ");
        sqlStr.append("'RN', CASE WHEN R.CO_STAFF_DUTY_CODE LIKE 'A%' THEN 'A' END, '') ");
    }
	else if (time.equals("P")) {
		sqlStr.append("GROUP BY P.CO_STAFF_ROLE, R.CO_STAFF_DUTY_DATE, ");
		sqlStr.append("DECODE(P.CO_STAFF_ROLE, 'HCA', CASE WHEN R.CO_STAFF_DUTY_CODE LIKE 'P' THEN 'P' END, ");
		sqlStr.append("'SRN', CASE WHEN R.CO_STAFF_DUTY_CODE LIKE 'P%' THEN 'P' END, ");
		sqlStr.append("'RN', CASE WHEN (R.CO_STAFF_DUTY_CODE LIKE 'P%') THEN ( ");
		sqlStr.append("      CASE WHEN (R.CO_STAFF_DUTY_CODE NOT LIKE '%PDM%') THEN 'P' END) END, '') ");
	}
	else if (time.equals("N")) {
	    sqlStr.append("GROUP BY P.CO_STAFF_ROLE, R.CO_STAFF_DUTY_DATE, "); 
	    sqlStr.append("DECODE(P.CO_STAFF_ROLE, 'HCA', CASE WHEN R.CO_STAFF_DUTY_CODE LIKE '%N' THEN 'N' END, "); 
	    sqlStr.append("'SRN', CASE WHEN R.CO_STAFF_DUTY_CODE LIKE '%N%' THEN 'N' END, ");
	    sqlStr.append("'RN', CASE WHEN R.CO_STAFF_DUTY_CODE LIKE '%N%' THEN 'N' END, '') ");
	}
    sqlStr.append(") WHERE SHIFT IS NOT NULL ");
    sqlStr.append("ORDER BY CO_STAFF_ORDER, CO_STAFF_DUTY_DATE ");
    
    //System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public String getDayDiff(Calendar cal, String date) {
	Calendar cal2 = Calendar.getInstance();
	cal2.set(Integer.parseInt(date.substring(4)), 
				Integer.parseInt(date.substring(2, 4)) - 1,
				Integer.parseInt(date.substring(0, 2)));
	long milsecs1= cal.getTimeInMillis();
	long milsecs2 = cal2.getTimeInMillis();
	long diff = milsecs2 - milsecs1;
	long dsecs = diff / 1000;
	long dminutes = diff / (60 * 1000);
	long dhours = diff / (60 * 60 * 1000);
	long ddays = diff / (24 * 60 * 60 * 1000);
	
	return String.valueOf(ddays+1);
}

public class Summary {
	String role = null;
	String time = null;
	String day = null;
	int count = 0;
	
	public Summary(String role, String time, String day) {
		this.role = role;
		this.time = time;
		this.day = day;
	}
	
	public Summary(String role, String time, String day, int count) {
		this.role = role;
		this.time = time;
		this.day = day;
		this.count = count;
	}
	
	public String getRole() {
		return this.role;
	}
	
	public String getTime() {
		return this.time;
	}
	
	public String getDay() {
		return this.day;
	}
	
	public int getCount() {
		return this.count;
	}
	
	public void addCount(int count) {
		this.count += count;
	}
}
%>

<%
String deptCode = request.getParameter("deptCode");
String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");

ReportableListObject row = null;
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
SimpleDateFormat sdf2 = new SimpleDateFormat("ddMMyyyy", Locale.ENGLISH);

ArrayList<Summary> hcaSum = new ArrayList<Summary>();
ArrayList<Summary> srnSum = new ArrayList<Summary>();
ArrayList<Summary> rnSum = new ArrayList<Summary>();

//init arraylist
int dayDiff = Integer.parseInt(getDayDiff(cal, sdf2.format(cal2.getTime())));
for (int i = 1; i <= dayDiff; i++) {
	hcaSum.add(new Summary("HCA", "A-Shift", "day"+i));
	srnSum.add(new Summary("SRN", "A-Shift", "day"+i));
	rnSum.add(new Summary("RN", "A-Shift", "day"+i));
}
for (int i = 1; i <= dayDiff; i++) {
	hcaSum.add(new Summary("HCA", "P-Shift", "day"+i));
	srnSum.add(new Summary("SRN", "P-Shift", "day"+i));
	rnSum.add(new Summary("RN", "P-Shift", "day"+i));
}
for (int i = 1; i <= dayDiff; i++) {
	hcaSum.add(new Summary("HCA", "N-Shift", "day"+i));
	srnSum.add(new Summary("SRN", "N-Shift", "day"+i));
	rnSum.add(new Summary("RN", "N-Shift", "day"+i));
}

ArrayList record = getStaffRosterSumList("A", sdf.format(cal.getTime()), sdf.format(cal2.getTime()), deptCode);
record.addAll(getStaffRosterSumList("P", sdf.format(cal.getTime()), sdf.format(cal2.getTime()), deptCode));
record.addAll(getStaffRosterSumList("N", sdf.format(cal.getTime()), sdf.format(cal2.getTime()), deptCode));

if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		Summary temp = null;
		if (row.getValue(0).equals("HCA")) {
			if (row.getValue(2).equals("A")) {
				temp = hcaSum.get(Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1);
			}
			else if (row.getValue(2).equals("P")) {
				temp = hcaSum.get(dayDiff+Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1);
			}
			else if (row.getValue(2).equals("N")) {
				temp = hcaSum.get(dayDiff*2+Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1);
			}
		}
		else if (row.getValue(0).equals("SRN")) {
			if (row.getValue(2).equals("A")) {
				temp = srnSum.get(Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1);
			}
			else if (row.getValue(2).equals("P")) {
				temp = srnSum.get(dayDiff+Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1);
			}
			else if (row.getValue(2).equals("N")) {
				temp = srnSum.get(dayDiff*2+Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1);
			}
		}
		else if (row.getValue(0).equals("RN")) {
			if (row.getValue(2).equals("A")) {
				temp = rnSum.get(Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1);
			}
			else if (row.getValue(2).equals("P")) {
				temp = rnSum.get(dayDiff+Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1);
			}
			else if (row.getValue(2).equals("N")) {
				temp = rnSum.get(dayDiff*2+Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1);
			}
		}
		
		if (temp != null) {
			temp.addCount(Integer.parseInt(row.getValue(3)));
		}
	}
	
	for (int i = 0; i < rnSum.size(); i++) {
		rnSum.get(i).addCount(srnSum.get(i).getCount());
	}
	
	ArrayList minusTotal = getMinusTotal(sdf.format(cal.getTime()), sdf.format(cal2.getTime()), deptCode);
	
	if (minusTotal.size() > 0) {
		for (int i = 0; i < minusTotal.size(); i++) {
			row = (ReportableListObject) minusTotal.get(i);
			
			int index = 0;
			if (row.getValue(2).startsWith("P")) {
				index = dayDiff+Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1;
			}
			else if (row.getValue(2).startsWith("A")) {
				index = Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1;
			}
			else if (row.getValue(2).startsWith("N")) {
				index = dayDiff*2+Integer.parseInt(getDayDiff(cal, row.getValue(1)))-1;
			}
			rnSum.get(index).addCount(Integer.parseInt(row.getValue(3))*-1);
		}
	}
	
	String curTime = "";
	for (int i = 0; i < hcaSum.size(); i++) {
		Summary temp = hcaSum.get(i);
		//System.out.println(temp.getDay());
		
		if (curTime.equals(temp.getTime())) {
			staffJSON.put(temp.getDay(), temp.getCount());
		}
		else {
			if (i != 0) {
				jsonArray.add(staffJSON);
			}
			
			staffJSON = new JSONObject();
			staffJSON.put("type", temp.getRole());
			staffJSON.put("time", temp.getTime());
			staffJSON.put(temp.getDay(), temp.getCount());
			curTime = temp.getTime();
		}
	}
	jsonArray.add(staffJSON);
	curTime = "";
	for (int i = 0; i < srnSum.size(); i++) {
		Summary temp = srnSum.get(i);
		
		if (curTime.equals(temp.getTime())) {
			staffJSON.put(temp.getDay(), temp.getCount());
		}
		else {
			if (i != 0) {
				jsonArray.add(staffJSON);
			}
			
			staffJSON = new JSONObject();
			staffJSON.put("type", temp.getRole());
			staffJSON.put("time", temp.getTime());
			staffJSON.put(temp.getDay(), temp.getCount());
			curTime = temp.getTime();
		}
	}
	jsonArray.add(staffJSON);
	curTime = "";
	for (int i = 0; i < rnSum.size(); i++) {
		Summary temp = rnSum.get(i);
		
		if (curTime.equals(temp.getTime())) {
			staffJSON.put(temp.getDay(), temp.getCount());
		}
		else {
			if (i != 0) {
				jsonArray.add(staffJSON);
			}
			
			staffJSON = new JSONObject();
			staffJSON.put("type", temp.getRole());
			staffJSON.put("time", temp.getTime());
			staffJSON.put(temp.getDay(), temp.getCount());
			curTime = temp.getTime();
		}
	}
	jsonArray.add(staffJSON);
}
else {
	String curTime = "";
	for (int i = 0; i < hcaSum.size(); i++) {
		Summary temp = hcaSum.get(i);
		//System.out.println(temp.getDay());
		
		if (curTime.equals(temp.getTime())) {
			staffJSON.put(temp.getDay(), temp.getCount());
		}
		else {
			if (i != 0) {
				jsonArray.add(staffJSON);
			}
			
			staffJSON = new JSONObject();
			staffJSON.put("type", temp.getRole());
			staffJSON.put("time", temp.getTime());
			staffJSON.put(temp.getDay(), temp.getCount());
			curTime = temp.getTime();
		}
	}
	jsonArray.add(staffJSON);
	curTime = "";
	for (int i = 0; i < srnSum.size(); i++) {
		Summary temp = srnSum.get(i);
		
		if (curTime.equals(temp.getTime())) {
			staffJSON.put(temp.getDay(), temp.getCount());
		}
		else {
			if (i != 0) {
				jsonArray.add(staffJSON);
			}
			
			staffJSON = new JSONObject();
			staffJSON.put("type", temp.getRole());
			staffJSON.put("time", temp.getTime());
			staffJSON.put(temp.getDay(), temp.getCount());
			curTime = temp.getTime();
		}
	}
	jsonArray.add(staffJSON);
	curTime = "";
	for (int i = 0; i < rnSum.size(); i++) {
		Summary temp = rnSum.get(i);
		
		if (curTime.equals(temp.getTime())) {
			staffJSON.put(temp.getDay(), temp.getCount());
		}
		else {
			if (i != 0) {
				jsonArray.add(staffJSON);
			}
			
			staffJSON = new JSONObject();
			staffJSON.put("type", temp.getRole());
			staffJSON.put("time", temp.getTime());
			staffJSON.put(temp.getDay(), temp.getCount());
			curTime = temp.getTime();
		}
	}
	jsonArray.add(staffJSON);
}

rootJSON.put("page", "1");
rootJSON.put("total", "1");
rootJSON.put("records", "9");
rootJSON.put("rows", jsonArray);

response.setContentType("application/json");
//System.out.println(rootJSON.toString());
PrintWriter writer = response.getWriter();
writer.print(request.getParameter("callback")+"("+rootJSON.toString()+ ");");
writer.close();
%>