<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	
	private ArrayList<ReportableListObject> fetchRecord(String locid, String searchDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT T.WRDCODE, B.ROMCODE, T.BEDCODE, I.ACMCODE, R.PATNO, P.PATFNAME, P.PATSEX ");
		sqlStr.append("FROM TICKET_QUEUE@IWEB T, REG@IWEB R, INPAT@IWEB I, PATIENT@IWEB P, BED@IWEB B ");
		sqlStr.append("WHERE T.REGID = R.REGID ");
		sqlStr.append("AND I.INPID = R.INPID ");
		sqlStr.append("AND P.PATNO = T.PATNO ");
		sqlStr.append("AND B.BEDCODE = T.BEDCODE "); 
		sqlStr.append("AND TO_CHAR(T.PLAN_DATE,'DD/MM/YYYY') = '"+searchDate+"' ");
		sqlStr.append("AND START_DATE IS NULL ");
		if(!"PBO".equals(locid)&&!"PHAR".equals(locid)&&!"allDept".equals(locid)){
			if("SC".equals(locid) || "MS".equals(locid)){
				sqlStr.append("AND T.WRDCODE IN ('SC','MS') ");
			}else{
				sqlStr.append("AND T.WRDCODE = UPPER('"+locid+"') ");
			}
		}
		sqlStr.append("AND T.ENABLED = '1' ");
		sqlStr.append("ORDER BY T.WRDCODE, T.BEDCODE ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%><%
String locid = request.getParameter("locid");
String searchDate = request.getParameter("searchDate");
if (searchDate == null || "".equals(searchDate)){
	searchDate = DateTimeUtil.getCurrentDate(1);
}
ArrayList<ReportableListObject> record = fetchRecord(locid, searchDate);
int count = record.size();
request.setAttribute("record_list", record);

%>

<%	if (count > 0) { %>
<script>$("#dischargeDate").html("<%=searchDate %>");</script>
<display:table id="listTable" name="requestScope.record_list"  export="false" class="dataTable">
	<display:column property="fields0" title="Ward" style="width:9%; "/>
	<display:column property="fields2" title="Bed#" style="width:9%; "/>
	<display:column property="fields3" title="Class" style="width:9%; "/>
	<display:column property="fields4" title="Patient#" style="width:15%; "/>
	<display:column property="fields5" title="Last Name" style="width:40%; "/>
	<display:column property="fields6" title="Gender" style="width:9%; "/>
</display:table>

<%	} else {%>
	<script>$("#dischargeDate").html("<%=searchDate %>");</script>
	No discharge process planed on <%=searchDate %>.
<% 	} %>