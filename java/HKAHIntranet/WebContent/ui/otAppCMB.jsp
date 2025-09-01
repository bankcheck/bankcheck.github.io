<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@	page import="java.text.*"%>

<%!
	private ArrayList<ReportableListObject> fetchApp(String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(OTAOSDATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("TO_CHAR(OTAOEDATE, 'DD/MM/YYYY HH24:MI'), DOCCODE_E, DOCCODE_S, ");
		sqlStr.append("DOCCODE_A, OTAPROCRMK, TO_CHAR(OTACDATE, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM OT_APP@IWEB ");
		sqlStr.append("WHERE (OTAPROCRMK LIKE '%260%' OR OTAPROCRMK LIKE '%180%') ");
		sqlStr.append("AND OTAOSDATE >= TO_DATE('"+dateFrom+" 00:00:00', 'dd-MM-YYYY HH24:MI:SS') ");
		sqlStr.append("AND OTAOEDATE <= TO_DATE('"+dateTo+" 23:59:59', 'dd-MM-YYYY HH24:MI:SS') ");
		sqlStr.append("ORDER BY OTAOSDATE");
		
		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<String> getTimeList(int diff) {
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");
		int half = 0;
		
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		
		ArrayList<String> timeList = new ArrayList<String>();
		timeList.add(dateFormat.format(cal.getTime()));
		cal.add(Calendar.MINUTE, diff);

		while(half != 1+60/diff) {
			timeList.add(dateFormat.format(cal.getTime()));
			cal.add(Calendar.MINUTE, diff);
			if(cal.get(Calendar.HOUR) == 0) {
				half++;
			}
		}
		
		return timeList;
	}
	
	private Calendar setTime(String dateTime) {
		String[] dt = dateTime.split(" ");
		int year = Integer.parseInt(dt[0].split("-")[2]);
		int month = Integer.parseInt(dt[0].split("-")[1]);
		int day = Integer.parseInt(dt[0].split("-")[0]);
		
		int hour = Integer.parseInt(dt[1].split(":")[0]);
		int min = Integer.parseInt(dt[1].split(":")[1]);
		
		Calendar cal = Calendar.getInstance();
		cal.set(year, month-1, day, hour, min);
		
		return cal;
	}
	
	private void reorderTheData(ArrayList<String> firstList, 
							ArrayList<String> secondList, ArrayList<String> original) {
		for(String o: original) {
			String[] tmp = o.split("_"); //o[0]: start date, o[1]: end date, o[2]: doccode
			
			if(firstList.size() > 0) {
				Calendar fistEnd = setTime(firstList.get(firstList.size()-1).split("_")[1]);
				Calendar secondStart = setTime(tmp[0]);
				
				if(fistEnd.get(Calendar.DATE) != secondStart.get(Calendar.DATE)) {
					firstList.add(new String(o));
					continue;
				}
				
				if(secondList.size() > 0) {
					fistEnd = setTime(secondList.get(secondList.size()-1).split("_")[1]);
					if(fistEnd.get(Calendar.DATE) != secondStart.get(Calendar.DATE)) {
						secondList.add(new String(o));
						continue;
					}
					
					fistEnd = setTime(firstList.get(firstList.size()-1).split("_")[1]);
					if(fistEnd.getTimeInMillis() - secondStart.getTimeInMillis() > 0) {
						long distance1 = fistEnd.getTimeInMillis() - secondStart.getTimeInMillis();
						fistEnd = setTime(secondList.get(secondList.size()-1).split("_")[1]);
						long distance2 = fistEnd.getTimeInMillis() - secondStart.getTimeInMillis();
						//compare with second list
						if(distance2 > 0) {
							if(distance1 > distance2) {
								secondList.add(new String(o));
							}else {
								firstList.add(new String(o));
							}
						}else {
							secondList.add(new String(o));
						}
					}else {
						fistEnd = setTime(secondList.get(secondList.size()-1).split("_")[1]);
						if(fistEnd.getTimeInMillis() - secondStart.getTimeInMillis() > 0) {
							firstList.add(new String(o));
						}else {
							firstList.add(new String(o));
						}
					}
				}
				else {
					if(fistEnd.getTimeInMillis() - secondStart.getTimeInMillis() > 0) {
						secondList.add(new String(o));
					}else {
						firstList.add(new String(o));
					}
				}
			}
			else {
				firstList.add(o);
			}
		}
	}
%>

<%
String dateFrom = request.getParameter("dateFrom");
String dateTo = request.getParameter("dateTo");

Calendar cal = setTime(dateFrom+" 00:00");
cal.add(Calendar.DAY_OF_MONTH, -1);
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

ArrayList<ReportableListObject> record = fetchApp(dateFrom, dateTo);
ReportableListObject row = null;
int showDays = 3;

/***************************** ui ********************************/
ArrayList<String> timeList = getTimeList(30);
%>
<tbody>
	<tr><td></td>
<%
for(int day = 0; day < showDays; day++) {
	cal.add(Calendar.DAY_OF_MONTH, 1);
	sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
	String d = sdf.format(cal.getTime());
%>
	<td class="<%=((day%2 == 0)?"title_odd":"title_even") %> title dateHeader" colspan="3"
		style="font-weight:bold; border-style:outset; border-width:1px;">
		<span><%=d %></span>
	</td>
<%
}
%>
	</tr>
	<tr id="dateHeaderRow"><td></td>
<%
cal = setTime(dateFrom+" 00:00");
cal.add(Calendar.DAY_OF_MONTH, -1);
for(int day = 0; day < showDays; day++) {
	cal.add(Calendar.DAY_OF_MONTH, 1);
	sdf = new SimpleDateFormat("dd-MM-yyyy", Locale.ENGLISH);
	String d = sdf.format(cal.getTime());
%>
	<td date='<%=d%>' class="bheader_2601 <%=((day%2 == 0)?"title_odd":"title_even") %> title">
		<span>260</span>
	</td>
	<td date='<%=d%>' class="bheader_2602 <%=((day%2 == 0)?"title_odd":"title_even") %> title">
		<span>260</span>
	</td>
	<td date='<%=d%>' class="bheader_1801 <%=((day%2 == 0)?"title_odd":"title_even") %> title">
		<span>180</span>
	</td>
<%
}

for(String time: timeList) {
%>
	<tr><td id='<%=time.replace(":", "")%>' class="time" style="width:50px !important;"><%=time%></td>
<%
	for(int day = 0; day < showDays; day++) {
%>
		<td class="<%=((day%2 == 0)?"title_odd":"title_even") %> cell">&nbsp;</td>
		<td class="<%=((day%2 == 0)?"title_odd":"title_even") %> cell">&nbsp;</td>
		<td class="<%=((day%2 == 0)?"title_odd":"title_even") %> cell">&nbsp;</td>
<%
	}
%>
	</tr>
<%
}

/**********************************************************/

/*************************** data generation ***************************/
ArrayList<String> data180 = new ArrayList<String>();
ArrayList<String> data260 = new ArrayList<String>();

ArrayList<String> data1801 = new ArrayList<String>();
ArrayList<String> data1802 = new ArrayList<String>();
ArrayList<String> data2601 = new ArrayList<String>();
ArrayList<String> data2602 = new ArrayList<String>();

if(true){//record.size() > 0) {
	for(int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		
		if(row.getValue(5).indexOf("180") > -1) {
			data180.add(row.getValue(0).replaceAll("/", "-") + "_" + row.getValue(1).replaceAll("/", "-") + "_" + row.getValue(3) + "_" + row.getValue(6));
		}
		else if(row.getValue(5).indexOf("260") > -1) {
			data260.add(row.getValue(0).replaceAll("/", "-") + "_" + row.getValue(1).replaceAll("/", "-") + "_" + row.getValue(3) + "_" + row.getValue(6));
		}
		
		for(int j = 0; j < row.getSize(); j++) {
			System.out.print(row.getValue(j) + " ");
		}
		System.out.println();
	}
	
/*	data180.add(dateFrom+" 07:30_"+dateFrom+" 08:00_999_02/06/2011 10:25");
	data180.add(dateFrom+" 08:00_"+dateFrom+" 09:00_999_02/06/2011 10:25");
	data180.add(dateFrom+" 08:30_"+dateFrom+" 09:30_999_02/06/2011 10:25");
	data180.add(dateFrom+" 09:00_"+dateFrom+" 10:30_999_02/06/2011 10:25");
	data180.add(dateFrom+" 09:30_"+dateFrom+" 10:30_999_02/06/2011 10:25");
	data180.add(dateFrom+" 10:45_"+dateFrom+" 11:15_999_02/06/2011 10:25");
	data180.add(dateFrom+" 11:00_"+dateFrom+" 12:00_999_02/06/2011 10:25");
	data180.add(dateFrom+" 11:30_"+dateFrom+" 12:00_999_02/06/2011 10:25");
	data180.add(dateFrom+" 12:00_"+dateFrom+" 12:30_999_02/06/2011 10:25");
	
	data180.add(dateTo+" 09:00_"+dateTo+" 10:30_999_02/06/2011 10:25");
	data180.add(dateTo+" 09:30_"+dateTo+" 10:30_999_02/06/2011 10:25");
	
	data260.add(dateTo+" 08:00_"+dateTo+" 09:00_999_02/06/2011 10:25");*/
	
	//reorderTheData(data1801, null, data180);
	reorderTheData(data2601, data2602, data260);
	
	System.out.println("--------------1801-------------");
	for(String data: data180) {
		System.out.println(data);
	}
	System.out.println("--------------2601-------------");
	for(String data: data2601) {
		System.out.println(data);
	}
	System.out.println("--------------2602-------------");
	for(String data: data2602) {
		System.out.println(data);
	}
	
	
	//generation all app event
%>
	<tr id="eventRow" style="display:none"><td>
<%
	for(String data: data180) {
		String[] tmp = data.split("_");
		String d = tmp[0].split(" ")[0];
		String col = "1801";
		String st = tmp[0].split(" ")[1].substring(0, 5);
		String et = tmp[1].split(" ")[1].substring(0, 5);
		
%>
		<div id="<%=d%>_<%=col%>_<%=st%>_<%=et%>" class="event ui-dialog ui-widget ui-widget-content ui-corner-all">
			<div class = "ui-widget-header">
			<label style="font-weight:bold">DR Code: </label>
			<label><%=tmp[2] %></label></div>
			<label style="font-weight:bold">Order Date: </label><br/>
			<label><%=tmp[3] %></label>
		</div>
<%
	}
	
	for(String data: data2601) {
		String[] tmp = data.split("_");
		String d = tmp[0].split(" ")[0];
		String col = "2601";
		String st = tmp[0].split(" ")[1].substring(0, 5);
		String et = tmp[1].split(" ")[1].substring(0, 5);
		
%>
		<div id="<%=d%>_<%=col%>_<%=st%>_<%=et%>" class="event ui-dialog ui-widget ui-widget-content ui-corner-all">
			<div class = "ui-widget-header">
			<label style="font-weight:bold">DR Code: </label>
			<label><%=tmp[2] %></label></div>
			<label style="font-weight:bold">Order Date: </label><br/>
			<label><%=tmp[3] %></label>
		</div>
<%
	}
	
	for(String data: data2602) {
		String[] tmp = data.split("_");
		String d = tmp[0].split(" ")[0];
		String col = "2602";
		String st = tmp[0].split(" ")[1].substring(0, 5);
		String et = tmp[1].split(" ")[1].substring(0, 5);
		
%>
		<div id="<%=d%>_<%=col%>_<%=st%>_<%=et%>" class="event ui-dialog ui-widget ui-widget-content ui-corner-all">
			<div class = "ui-widget-header">
			<label style="font-weight:bold">DR Code: </label>
			<label><%=tmp[2] %></label></div>
			<label style="font-weight:bold">Order Date: </label><br/>
			<label><%=tmp[3] %></label>
		</div>
<%
	}
%>
	</td></tr>
</tbody>
<%
}

/**********************************************************************/
%>