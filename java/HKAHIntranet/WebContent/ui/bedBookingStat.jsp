<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@page import="java.util.*"%>
<%@page import="com.hkah.servlet.*"%>
<%@page import="com.hkah.util.*"%>
<%@page import="com.hkah.util.db.*"%>
<%@page import="com.hkah.web.common.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@	page import="java.text.*"%>

<%!
	private ArrayList<ReportableListObject> fetchBedBookingStat(String date_from, String date_to) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT W.WRDCODE, W.WRDNAME, BOOK.BPBHDATE, BOOK.BOOKING, BOOK.CAN, BOOK.NS ");
		sqlStr.append("FROM WARD@IWEB W left join ");
		sqlStr.append("( Select WRDCODE, TO_CHAR(BPBHDATE, 'DD-MM-YYYY') AS BPBHDATE, Count(*) As BOOKING, ");
		sqlStr.append("Sum(Decode(BPBSTS, 'D', 1, 0)) AS CAN, Sum(Decode(abs(BPBHDATE - (SYSDATE-1)), BPBHDATE - (SYSDATE-1), 0, 0, 0, Decode(BPBSTS, 'N', 1, 0))) AS NS ");
		sqlStr.append("From BEDPREBOK@IWEB ");
		sqlStr.append("Where WRDCODE in ");
		sqlStr.append("( SELECT WRDCODE ");
		sqlStr.append("FROM WARD@IWEB where WRDNAME not like '%CLOSED%') ");
		sqlStr.append("And BPBHDATE >= TO_DATE('"+date_from+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND BPBHDATE <= TO_DATE('"+date_to+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND ACMCODE IS NOT NULL ");
		sqlStr.append("AND WRDCODE IS NOT NULL ");
		sqlStr.append("AND BPBSTS <> 'F' ");
		sqlStr.append("GROUP BY WRDCODE, TO_CHAR(BPBHDATE, 'DD-MM-YYYY') ");
		sqlStr.append("Order by WRDCODE) BOOK ON W.WRDCODE = BOOK.WRDCODE ");
		sqlStr.append("where W.WRDNAME not like '%CLOSED%' ");
		sqlStr.append("Order by W.WRDCODE, TO_DATE(BOOK.BPBHDATE, 'DD-MM-YYYY') ");
		
		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> fetchTotalBedBookingStat(String date_month) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT W.WRDCODE, W.WRDNAME, BOOK.BOOKING, BOOK.CAN, BOOK.NS ");
		sqlStr.append("FROM WARD@IWEB W left join ");
		sqlStr.append("( Select WRDCODE, Count(*) As BOOKING, ");
		sqlStr.append("Sum(Decode(BPBSTS, 'D', 1, 0)) AS CAN, Sum(Decode(abs(BPBHDATE - (SYSDATE-1)), BPBHDATE - (SYSDATE-1), 0, 0, 0, Decode(BPBSTS, 'N', 1, 0))) AS NS ");
		sqlStr.append("From BEDPREBOK@IWEB ");
		sqlStr.append("Where WRDCODE in ");
		sqlStr.append("( SELECT WRDCODE ");
		sqlStr.append("FROM WARD@IWEB where WRDNAME not like '%CLOSED%') ");
		sqlStr.append("And BPBHDATE >= TO_DATE('"+date_month+" 00:00:00', 'MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND BPBHDATE <= LAST_DAY(TO_DATE('"+date_month+" 23:59:59', 'MM/YYYY HH24:MI:SS')) ");
		sqlStr.append("AND ACMCODE IS NOT NULL ");
		sqlStr.append("AND WRDCODE IS NOT NULL ");
		sqlStr.append("AND BPBSTS <> 'F' ");
		sqlStr.append("GROUP BY WRDCODE ");
		sqlStr.append("Order by WRDCODE) BOOK ON W.WRDCODE = BOOK.WRDCODE ");
		sqlStr.append("where W.WRDNAME not like '%CLOSED%' ");
		sqlStr.append("Order by W.WRDCODE ");
		
		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>

<%
	String selectedDate = request.getParameter("date");
	String dateInfo[] = selectedDate.split("-");
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
	SimpleDateFormat monSdf = new SimpleDateFormat("MM/yyyy", Locale.ENGLISH);
	SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy", Locale.ENGLISH);
	int showDay = 7;
	ArrayList<String> totalMonthly = new ArrayList<String>();
	ArrayList<String> dateRange = new ArrayList<String>();
	int total[] = new int[]{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

	cal.set(Integer.parseInt(dateInfo[2]), Integer.parseInt(dateInfo[1]) - 1, Integer.parseInt(dateInfo[0]));
	String date_month = monSdf.format(cal.getTime());
	String date_to = sdf.format(cal.getTime());
	cal.add(Calendar.DAY_OF_MONTH, -6);
	String date_from = sdf.format(cal.getTime());
	cal.add(Calendar.DAY_OF_MONTH, -1);
%>
		<tr><td></td>
<%
	for(int day = 0; day < showDay; day++) {
		cal.add(Calendar.DAY_OF_MONTH, 1);
		String date = sdf.format(cal.getTime());
		dateRange.add(sdf2.format(cal.getTime()));
	
%>
		<td colspan="3" class="title" style="width:12%; border-style:outset; border-width:1px;">
			<%=date %>
		</td>
<%
	}
%>
		<td colspan="3" class="title" style="width:12%; border-style:outset; border-width:1px;">Total (<%=date_month %>)</td></tr>
		<tr><td></td>
<%
	for(int day = 0; day <= showDay; day++) {
%>
		<td class="booking" style="width:4%; border-style:outset; border-width:1px;">
			Booking
		</td>
		<td class="cancel" style="width:4%; border-style:outset; border-width:1px;">
			Cancel
		</td>
		<td class="noshow" style="width:4%; border-style:outset; border-width:1px;">
			No Show
		</td>
<%
	}
%>
		</tr><tr></tr>
<%	

	ArrayList<ReportableListObject> record;
	ReportableListObject row = null;
	
	record = fetchTotalBedBookingStat(date_month);
	if(record.size() > 0) {
		for(int i = 0; i < record.size(); i++) {
			row = record.get(i);
			
			totalMonthly.add(row.getValue(0)+"_"+
						row.getValue(1)+"_"+
						(row.getValue(2).equals("")?"0":row.getValue(2))+"_"+
						(row.getValue(3).equals("")?"0":row.getValue(3))+"_"+
						(row.getValue(4).equals("")?"0":row.getValue(4)));
		}
	}
	
	for(int i = 0; i < totalMonthly.size(); i++) {
		System.out.println(totalMonthly.get(i));
	}

	record = fetchBedBookingStat(date_from, date_to);
	if(record.size() > 0) {
		String currentWard = null;
		int currentRow = 0;
		int currentCol = 0;
		for(int i = 0, j = 0; i <= record.size(); i++, j++) {
			if(i == record.size() && j - dateRange.size() == 1)
				break;
			
			if(i == record.size() && j <= dateRange.size())
				i--;

			row = record.get(i);
			if(j == dateRange.size()) {
				String tmp[] = totalMonthly.get(currentRow).split("_");
				total[currentCol++] += Integer.parseInt(tmp[2]);
				total[currentCol++] += Integer.parseInt(tmp[3]);
				total[currentCol++] += Integer.parseInt(tmp[4]);
%>
				<td><%=tmp[2] %></td>
				<td><%=tmp[3] %></td>
				<td><%=tmp[4] %></td></tr>
<%				
				currentRow++;
				currentCol = 0;
				System.out.print(currentWard);
				System.out.print(row.getValue(0));
				if(currentWard.equals(row.getValue(0))) {
					continue;
				}
			}
			
			System.out.print(i + " ");
			for(int k = 0; k < row.getSize(); k++) {
				System.out.print(row.getValue(k) + " ");
			}
			System.out.println();
			
			
			if(currentWard == null) {
				currentWard = row.getValue(0);
%>
				<tr class="<%=currentWard%>" style="height:60px; "><td style='border-style:outset; border-width:1px;'><%=row.getValue(1) %></td>
<%
			}
			
			
			if(currentWard.equals(row.getValue(0))) {
				//System.out.println(row.getValue(2));
				//System.out.println(dateRange.get(j));
				if(row.getValue(2).indexOf(dateRange.get(j)) > -1) {
					total[currentCol++] += Integer.parseInt(row.getValue(3));
					total[currentCol++] += Integer.parseInt(row.getValue(4));
					total[currentCol++] += Integer.parseInt(row.getValue(5));
%>
					<td class="history" id='<%=row.getValue(0) %>_<%=row.getValue(2) %>_booking'><%=(row.getValue(3).equals("")?"0": row.getValue(3)) %></td>
					<td class="history" id='<%=row.getValue(0) %>_<%=row.getValue(2) %>_cancel'><%=(row.getValue(4).equals("")?"0": row.getValue(4)) %></td>
					<td class="history" id='<%=row.getValue(0) %>_<%=row.getValue(2) %>_noshow'><%=(row.getValue(5).equals("")?"0": row.getValue(5)) %></td>
<%					
				}
				else {
					i--;
					currentCol += 3;
%>
					<td class="history">0</td>
					<td class="history">0</td>
					<td class="history">0</td>
<%					
				}
			}
			else {
				if(j < dateRange.size()) {
					i--;
					currentCol += 3;
%>
					<td class="history">0</td>
					<td class="history">0</td>
					<td class="history">0</td>
<%						
				}
				else {
					j = 0;
					currentWard = row.getValue(0);
%>
					<tr style="height:10px; "></tr>
					<tr class="<%=currentWard%>" style="height:60px; "><td style='border-style:outset; border-width:1px;'><%=row.getValue(1) %></td>
<%
					if(row.getValue(2).indexOf(dateRange.get(j)) > -1) {
						total[currentCol++] += Integer.parseInt(row.getValue(3));
						total[currentCol++] += Integer.parseInt(row.getValue(4));
						total[currentCol++] += Integer.parseInt(row.getValue(5));
%>
						<td class="history" id='<%=row.getValue(0) %>_<%=row.getValue(2) %>_booking'><%=(row.getValue(3).equals("")?"0": row.getValue(3)) %></td>
						<td class="history" id='<%=row.getValue(0) %>_<%=row.getValue(2) %>_cancel'><%=(row.getValue(4).equals("")?"0": row.getValue(4)) %></td>
						<td class="history" id='<%=row.getValue(0) %>_<%=row.getValue(2) %>_noshow'><%=(row.getValue(5).equals("")?"0": row.getValue(5)) %></td>
<%					
					}
					else {
						i--;
						currentCol += 3;
%>
						<td class="history">0</td>
						<td class="history">0</td>
						<td class="history">0</td>
<%					
					}
				}
			}
		}
		
%>
		<tr class="total" style="height:60px; "><td style='border-style:outset; border-width:1px;'>TOTAL</td>
<%
		int totalBk = 0;
		DecimalFormat noDigit = new DecimalFormat("#,##0");

		for(int i = 0; i < total.length; i++) {
			if((i+1)%3 == 1) {
				totalBk = total[i];
			}
%>
			<td><%=total[i] %> <%=((i+1)%3 != 1)?((totalBk == 0)?"(0%)":"("+noDigit.format((total[i]*100.0)/totalBk)+"%)"):"" %></td>
<%
		}
%>
		</tr>
<%
	}
%>