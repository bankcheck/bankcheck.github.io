<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.Math"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%!
	private	ArrayList getCCICSchedule(String month, String sDate) {
		StringBuffer sqlStr = new StringBuffer();
		String requestYear = sDate.substring(6, sDate.length());
		
		sqlStr.append("SELECT OTAID, OA.DOCCODE_S, D.DOCFNAME||' '||D.DOCGNAME, "); 
		sqlStr.append("TO_CHAR(OA.OTAOSDATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("TO_CHAR(OA.OTAOEDATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("TO_CHAR(OA.OTAOSDATE, 'AM', 'NLS_DATE_LANGUAGE = AMERICAN'), ");
		sqlStr.append("OP.OTPDESC ");
		sqlStr.append("FROM OT_APP@IWEB OA, OT_PROC@IWEB OP, DOCTOR@IWEB D ");
		sqlStr.append("WHERE OA.OTASTS = 'N' ");
		sqlStr.append("AND (op.otpdesc LIKE 'CCIC%' or op.otpdesc LIKE 'CC%' ) ");
		sqlStr.append("AND OA.OTPID = OP.OTPID ");
		sqlStr.append("AND OA.OTAOSDATE >= TO_DATE('"+sDate+"'||' ");
		sqlStr.append("00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND OA.OTAOSDATE <= LAST_DAY(TO_DATE('"+month+"/"+requestYear);
		sqlStr.append("'||' 23:59:59', 'MM/YYYY HH24:MI:SS')) ");
		sqlStr.append("AND D.DOCCODE(+) = OA.DOCCODE_S ");
		sqlStr.append("ORDER BY OA.OTAOSDATE ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
Calendar calendar = Calendar.getInstance();
String currentDate = DateTimeUtil.formatDate(calendar.getTime());
String addMonth = request.getParameter("addMonth");
if (Integer.parseInt(addMonth) != 0) {
	calendar.add(Calendar.MONTH, Integer.parseInt(addMonth));
}
calendar.set(Calendar.DATE, 1);
int leadGap = calendar.get(Calendar.DAY_OF_WEEK) - 1;
int dom[] = {
		31, 28, 31, 30,	/* jan feb mar apr */
		31, 30, 31, 31,	/* may jun jul aug */
		30, 31, 30, 31	/* sep oct nov dec */
	};

int selectYearInt = calendar.get(Calendar.YEAR);
int selectMonthInt = calendar.get(Calendar.MONTH);
int daysInMonth = dom[selectMonthInt];
if (selectMonthInt == 1 && ((GregorianCalendar) calendar).isLeapYear(calendar.get(Calendar.YEAR))) {
	++daysInMonth;
}
String calendarDate = DateTimeUtil.formatDate(calendar.getTime());
boolean isCurrentDate = false;
SimpleDateFormat smf = new SimpleDateFormat("MMMMM yyyy", Locale.ENGLISH);

ArrayList result = getCCICSchedule(calendarDate.substring(3, 5), 
									(Integer.parseInt(addMonth) != 0)?DateTimeUtil.formatDate(calendar.getTime()):currentDate);
ArrayList am = new ArrayList();
ArrayList pm = new ArrayList();

ReportableListObject row = null;
for (int i = 0; i < result.size(); i++) {
	row = (ReportableListObject)result.get(i);

	if (row.getValue(5).equals("AM")) {
		am.add(row);
	}
	else if (row.getValue(5).equals("PM")) {
		pm.add(row);
	}
}
%>
<table>
	<tbody>
		<tr class="dayRow">
			<td style="width:25px!important;" class="changeMode">
				<img src="../images/down.gif" alt="Change Mode"/>
			</td>
			<td class="sunday">SUN</td>
			<td>MON</td>
			<td>TUE</td>
			<td>WED</td>
			<td>THU</td>
			<td>FRI</td>
			<td>SAT</td>
		</tr>
<%
	for (int i = 0; i < Math.ceil((daysInMonth+leadGap)/7.0); i++) {
		for (int loop = 0; loop < 2; loop++) {
	%>
			<tr>
	<%
			if (loop == 0) {
	%>
				<td style="width:25px!important;font-size:13px;font-weight:bold">AM</td>
	<%
			}
			else {
	%>
				<td style="width:25px!important;font-size:13px;font-weight:bold">PM</td>
	<%			
			}
			if (leadGap > 0 && i == 0) {
				for(int j = 0; j < leadGap; j++) {
	%>
				<td>&nbsp;</td>
	<%
				}
			}
	
			int weekend = (i+1)*7-leadGap;
			for (int k = (weekend-6<=0?1:weekend-6); k <= weekend && k <= daysInMonth; k++) {
				calendarDate = (k<10?"0":"") + String.valueOf(k) + calendarDate.substring(2);
				isCurrentDate = currentDate.equals(calendarDate);
	%>
				<td class="schContentCell <%=(loop==0)?"am":"pm" %> <%=(k==weekend-6)?"sunday":"" %>" valign="top">
					<span style="font-weight:bold" class="dateNum <%=(isCurrentDate&&loop==0)?"today":""%>">
						<%=(loop==0)?k:"&nbsp;" %>
					</span>
					<div style="float:left;width:85%">
					<%
					boolean isPrint = false;
					if (loop == 0) {
						for (int index = 0; index < am.size(); index++) {
							row = (ReportableListObject)am.get(index);
							
							if (row.getValue(3).substring(0, 10).equals(calendarDate)) {
								isPrint = true;
							%>
								<div class="schContent">
									<p><%=row.getValue(3).substring(11) %> - <%=row.getValue(4).substring(11) %></p>
									<p><%=row.getValue(2) %></p>
									<p><%=row.getValue(6) %></p>
									<br/>
								</div>
							<%
							}
						}
					}
					else {
						for (int index = 0; index < pm.size(); index++) {
							row = (ReportableListObject)pm.get(index);
							
							if (row.getValue(3).substring(0, 10).equals(calendarDate)) {
								isPrint = true;
							%>
								<div class="schContent">
									<p><%=row.getValue(3).substring(11) %> - <%=row.getValue(4).substring(11) %></p>
									<p><%=row.getValue(2) %></p>
									<p><%=row.getValue(6) %></p>
									<br/>
								</div>
							<%
							}
						}
					}
					%>
					</div>
					<%if (isPrint) { %>
					<div style="float:right;width:10%" class="contentControl">
						<span class="contentNum"></span>
						<div class="nextBtn">
							<img src="../images/next.gif"/>
						</div>
					</div>
					<%} %>
				</td>
	<%
				if (k == daysInMonth && ((leadGap + daysInMonth) % 7) != 0) {
					for(int l = 0; l < 7 - ((leadGap + daysInMonth) % 7); l++) {
						%><td>&nbsp;</td><%
					}
				}
			}
	%>
			</tr>
	<%
		}
	}
%>
		<tr>
	</tbody>
</table>
<%
calendar = Calendar.getInstance(); 
if (Integer.parseInt(addMonth) != 0) {
	calendar.add(Calendar.MONTH, Integer.parseInt(addMonth));
}
%>
<div id="todayInfo" style="display:none">
	<p style="font-size:20px;"><%=smf.format(calendar.getTime()) %></p>
	<p>Today: <%=currentDate %></p>
</div>