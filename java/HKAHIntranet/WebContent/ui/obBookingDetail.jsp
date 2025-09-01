<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>

<%! 
	//private ArrayList
	
	private ArrayList getDoctorBookingByDate(String searchYearFrom, String searchMonthFrom, 
								String searchYearTo, String searchMonthTo, boolean getTotalByDay) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT TO_CHAR(B.BPBHDATE, 'DD'), ");
		if(!getTotalByDay) {
			sqlStr.append("B.DOCCODE, D.DOCFNAME || ' ' || D.DOCGNAME as DOCNAME, ");
		}
		sqlStr.append("SUM(1), SUM(DECODE(PATDOCTYPE, 'L', 1, 'C', 1, 0)) ");
		sqlStr.append("FROM   BEDPREBOK@IWEB B ");
		if(!getTotalByDay) {
			sqlStr.append(", DOCTOR@IWEB D ");
		}
		sqlStr.append("WHERE (B.BPBNO LIKE 'B%' OR B.BPBNO LIKE 'S%') ");
		sqlStr.append("AND    B.BPBHDATE >= TO_DATE('01/"+searchMonthFrom+"/");
		sqlStr.append(searchYearFrom);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    B.BPBHDATE < TO_DATE('01/"+searchMonthTo+"/");
		sqlStr.append(searchYearTo);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    B.BPBSTS != 'D' ");
		sqlStr.append("AND    B.WRDCODE = 'OB' ");
		if(!getTotalByDay) {
			sqlStr.append("AND    B.DOCCODE = D.DOCCODE ");
		}
		sqlStr.append("GROUP BY TO_CHAR(B.BPBHDATE, 'DD') ");
		if(!getTotalByDay) {
			sqlStr.append(", B.DOCCODE, D.DOCFNAME || ' ' || D.DOCGNAME ");
		}
		sqlStr.append("ORDER BY TO_CHAR(B.BPBHDATE, 'DD') ");

		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>

<%
	String syf = request.getParameter("syf");
	String smf = request.getParameter("smf");
	String syt = request.getParameter("syt");
	String smt = request.getParameter("smt");
	
	ArrayList record = getDoctorBookingByDate(syf, smf, syt, smt, false);
	ArrayList totalByDay = getDoctorBookingByDate(syf, smf, syt, smt, true);
	int dayTotal[] = new int[32];
	
	ReportableListObject row = null;
	Calendar cal = Calendar.getInstance();
	cal.set(Calendar.MONTH, Integer.parseInt(smf) - 1);
	cal.set(Calendar.YEAR, Integer.parseInt(syf));
	SimpleDateFormat sdf = new SimpleDateFormat("MM/yyyy", Locale.ENGLISH);
	
	if(totalByDay.size() > 0) {
		for(int i  = 0; i < totalByDay.size(); i++) {
			row = (ReportableListObject) totalByDay.get(i);
			dayTotal[Integer.parseInt(row.getValue(0))] = Integer.parseInt(row.getValue(1));
		}
	}
	System.out.println();
	//if (record.size() > 0) {
		%>
			<table style="width:100%; border-width:1px; border-spacing; border-style:outset; border-collapse:separate;">
				<tr><td align="center" colspan="5" style="font-size:14px; background-color:#FE8080; border-width:1px; padding:1px; border-style:outset;"><%=sdf.format(cal.getTime()) %></td></tr>
		<%
		
		
		String curDate = null;
		int printCol = 1;
		boolean newCol = true;
		boolean newRow = true;
		cal = Calendar.getInstance();
		cal.set(Integer.parseInt(syf), Integer.parseInt(smf) - 1, 1);
		
		//System.out.println("Last Date: "+cal.getActualMaximum(Calendar.DATE));
		int j = 0;
		int i = 0;
		int lastday = cal.getActualMaximum(Calendar.DATE);
		while(j < lastday) {
			%>
				<tr>
			<%
					for(int tmp = 1; tmp < 6 && j+tmp <= lastday; tmp++) {
			%>
						<td style="font-size:14px; background-color:#80FE80; border-width:1px; padding:1px; border-style:outset;"><%=j+tmp %></td>
			<%
					}
			%>
				</tr>
			<%
			int counter = 0;
			while (i < record.size() && record.size() > 0) {
				
				row = (ReportableListObject) record.get(i);
				/*System.out.println("---------------------------------------");
				System.err.println("curDate: "+row.getValue(0));
				System.err.println("doc: "+row.getValue(1));
				System.err.println("data1: "+row.getValue(2));
				System.err.println("data2: "+row.getValue(3));
				System.err.println("printCol: "+printCol);*/
				
				if(curDate == null || !(curDate.equals(row.getValue(0)))) {
					curDate = row.getValue(0);
					newCol = true;
					counter = 0;
					printCol++;
					if(printCol > 2 && (printCol-1)%5 == 1) {
						%>
										</div>
									</td>
						<%
					}
				}
				
				if((printCol-1)%5 == 1 && newCol) {
					if(printCol > 2) {
			%>
						</tr>
			<%
						newCol = false;
						newRow = true;
						break;
					}
				}
				
				if(newRow) {
					newRow = false;
					newCol = true;
			%>
					<tr style="height:120px; ">
			<%
				}
				
				boolean nextRow = false;
				while((printCol < Integer.parseInt(row.getValue(0)))) {
					%>
						<td style="background-color:white; border-width:1px; padding:1px; border-style:inset;"></td>
					<%
					printCol++;
					
					if((printCol-1)%5 == 1) {
						// open new row
						if(printCol > 2) {
				%>
							</tr>
				<%
							nextRow = true;
							break;
						}
					}
				}
				if (nextRow) {
					newCol = false;
					newRow = true;
					break;
				}
				
				//System.out.println("printCol-1: "+(printCol-1));
				//System.out.println("Integer.parseInt(row.getValue(0)): "+Integer.parseInt(row.getValue(0)));
				
				if((printCol-1) != Integer.parseInt(row.getValue(0))) {
					%>
							<td style="background-color:white; border-width:1px; padding:1px; border-style:inset;"></td>
					<%
					
					printCol++;
					
					if((printCol-1)%5 == 1 && newCol) {
							if(printCol > 2) {
					%>
								</tr>
					<%
								newCol = false;
								newRow = true;
								break;
							}
						}
						
						if(newRow) {
							newRow = false;
							newCol = true;
					%>
							<tr style="height:120px; ">
					<%
						}
				}
				
				if(newCol) {
					newCol = false;
			%>
					
						<td VALIGN="top" style="font-size:14px; background-color:white; border-width:1px; padding:1px; border-style:inset;">
							<div class="dataSummary" style="background-color:#FFFFCC;">
								<label style="font-weight:bold;">- Total: <%=dayTotal[Integer.parseInt(curDate)] %></label>
							</div>
							<div style="display:none;">
								<div style="<%=(counter%2 == 0)?"background-color:#DEDADA":"background-color:white"%>">- <%=row.getValue(2) %> (<%=row.getValue(1) %>) <br/><br/> 
								<label style="font-weight:bold;">Total: <%=row.getValue(3) %> <%=row.getValue(0) %></label>
								<br/><br/></div>
			<%
					counter++;
				}else {
			%>
					<div style="<%=(counter%2 == 0)?"background-color:#DEDADA":"background-color:white"%>">- <%=row.getValue(2) %> (<%=row.getValue(1) %>) <br/><br/> 
					<label style="font-weight:bold;">Total: <%=row.getValue(3) %> <%=row.getValue(0) %></label>
					<br/><br/></div>
			<%
					counter++;
				}
				
				i++;
			}
			j += 5;
		}
				
	//}
%>