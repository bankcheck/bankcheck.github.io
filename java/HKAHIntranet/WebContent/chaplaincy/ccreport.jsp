<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%!
public class RecordCount{
	public String date;
	public String servCategory;
	public String servItem;
	public int numOfVisit = 1;
	public ArrayList<String> patNo = new ArrayList<String>();
	public int uniquePat = 1;
	public RecordCount(String date, String servCategory, String servItem) {
		this.date = date;
		this.servCategory = servCategory;
		this.servItem = servItem;
	}
}

public ArrayList getAdmissionHistoryYearTotal(String modifiedUser, String startDate, String endDate, String detail, boolean isVisit, boolean isEmergency) {
	if (isVisit) {
		return UtilDBWeb.getReportableList(getAdmissionHistoryYearTotalStr(modifiedUser, startDate, endDate, detail, "R.REGDATE", isVisit, isEmergency));
	} else {
		return UtilDBWeb.getReportableList(getAdmissionHistoryYearTotalStr(modifiedUser, startDate, endDate, detail, "PS.EFFECTIVE_DATE", isVisit, isEmergency));
	}
}

public String getAdmissionHistoryYearTotalStr(String modifiedUser, String startDate, String endDate, String detail, String dbField, boolean isVisit, boolean isEmergency) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT TO_CHAR(");
	sqlStr.append(dbField);
	if ("patTotal".equals(detail) || "recordTotal".equals(detail)) {
		sqlStr.append(", 'DD'), ");
	} else if ("patTotalMonth".equals(detail) || "recordTotalMonth".equals(detail)) {
		sqlStr.append(", 'MM'), ");
	} else if ("patTotalYear".equals(detail) || "recordTotalYear".equals(detail)) {
		sqlStr.append(", 'YYYY'), ");
	}

	if (isVisit) {
		sqlStr.append("'Other', 'Visit24hour', ");
	} else if (isEmergency) {
		sqlStr.append("'Other', 'EmergencyAttended', ");
	} else {
		sqlStr.append("SERVICE_CATEGORY, SERVICE_ITEM, ");
	}

	if (isVisit) {
		sqlStr.append("COUNT(DISTINCT PS.PATNO) ");
	} else {
		if ("patTotal".equals(detail) || "patTotalMonth".equals(detail) || "patTotalYear".equals(detail)) {
			sqlStr.append("COUNT(DISTINCT CONCAT(PS.PATNO, TO_CHAR(");
			sqlStr.append(dbField);
			sqlStr.append(", 'DD/MM/YYYY'))) ");
		} else {
			sqlStr.append("COUNT(PS.MODIFIED_USER) ");
		}
	}

	sqlStr.append("FROM PAT_SERVICES PS ");

	if (isVisit) {
		sqlStr.append("INNER JOIN REG@IWEB R ON PS.REGID = R.REGID ");
	} else {
		sqlStr.append("LEFT JOIN CO_STAFFS S ON PS.MODIFIED_USER = S.CO_STAFF_ID ");
	}

	sqlStr.append("WHERE PS.ENABLE = 1  ");

	if (modifiedUser != null && modifiedUser.length() > 0) {
		sqlStr.append("AND S.CO_STAFF_ID = '");
		sqlStr.append(modifiedUser);
		sqlStr.append("' ");
	}

	if (isVisit) {
		sqlStr.append("AND PS.STATUS IS NULL ");
		if ("patTotal".equals(detail) || "patTotalMonth".equals(detail) || "patTotalYear".equals(detail)) {
			sqlStr.append("AND TRUNC(TO_NUMBER(PS.EFFECTIVE_DATE - R.REGDATE), 0) < 1 ");
		}
	} else if (isEmergency) {
		sqlStr.append("AND  PS.EMERGENCY IS NOT NULL ");
		sqlStr.append("AND (PS.EMERGENCY = 'e' ");
		sqlStr.append("OR   PS.ATTENDED1HR = 'a') ");
		if ("patTotal".equals(detail) || "patTotalMonth".equals(detail) || "patTotalYear".equals(detail)) {
			sqlStr.append("AND  PS.ATTENDED1HR IS NOT NULL ");
			sqlStr.append("AND  PS.ATTENDED1HR = 'a' ");
		}
	} else {
		sqlStr.append("AND PS.STATUS IS NULL ");
	}

	sqlStr.append("AND ");
	sqlStr.append(dbField);
	sqlStr.append(" >= TO_DATE('");
	sqlStr.append(startDate);
	sqlStr.append(" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND ");
	sqlStr.append(dbField);
	sqlStr.append(" <= TO_DATE('");
	sqlStr.append(endDate);
	sqlStr.append(" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("GROUP BY TO_CHAR(");
	sqlStr.append(dbField);
	if ("patTotal".equals(detail) || "recordTotal".equals(detail)) {
		sqlStr.append(", 'DD') ");
	} else if ("patTotalMonth".equals(detail) || "recordTotalMonth".equals(detail)) {
		sqlStr.append(", 'MM') ");
	} else if ("patTotalYear".equals(detail) || "recordTotalYear".equals(detail)) {
		sqlStr.append(", 'YYYY') ");
	}

	if (!isVisit && !isEmergency) {
		sqlStr.append(", SERVICE_CATEGORY, SERVICE_ITEM ");
	}

	return sqlStr.toString();
}

public int getCategoryCount(ArrayList arraylistTotal, String servCategory, String servItem, String dayofMonth) {
	int count = 0;

	String arraylistDayOfMonth = null;
	String arraylistCategory = null;
	String arraylistItem = null;
	ReportableListObject arraylistRecord = null;
	for (int i = 0; i < arraylistTotal.size(); i++) {
		arraylistRecord = (ReportableListObject) arraylistTotal.get(i);
		arraylistDayOfMonth = arraylistRecord.getValue(0);
		arraylistCategory = arraylistRecord.getValue(1);
		arraylistItem = arraylistRecord.getValue(2);
		if ((dayofMonth == null || arraylistDayOfMonth.equals(dayofMonth)) && arraylistCategory.equals(servCategory) && arraylistItem.equals(servItem)) {
			count += Integer.parseInt(arraylistRecord.getValue(3));
		}
	}

	return count;
}

public String getCategoryInfo(
		ArrayList monthRecordTotal, ArrayList monthPatTotal,
		ArrayList yearRecordTotal, ArrayList yearPatTotal,
		String selectedYear, String selectedMonth, int maxDaysInMonth, String servCategory, String servItem) {
	String yearCategory = servCategory;
	String yearItem = servItem;

	StringBuffer sqlStr = new StringBuffer();

	String dayofMonth = null;
	for (int i = 1; i<= maxDaysInMonth; i++) {
		if (i < 10) {
			dayofMonth = "0" + String.valueOf(i);
		} else {
			dayofMonth = String.valueOf(i);
		}

		sqlStr.append("<td style='text-align:center;' valign='top' id='");
		sqlStr.append(yearCategory);
		sqlStr.append("_");
		sqlStr.append(yearItem);
		sqlStr.append("_");
		sqlStr.append(selectedYear);
		sqlStr.append("_");
		sqlStr.append(selectedMonth);
		sqlStr.append("_");
		sqlStr.append(i);
		sqlStr.append("'>");

		int dayRecordCount = getCategoryCount(monthRecordTotal, yearCategory, yearItem, dayofMonth);
		int dayPatCount = getCategoryCount(monthPatTotal, yearCategory, yearItem, dayofMonth);
		if (dayRecordCount > 0 && dayPatCount > 0) {
			sqlStr.append(dayRecordCount);
			sqlStr.append(" / ");
			sqlStr.append(dayPatCount);
		} else {
			sqlStr.append("&nbsp;");
		}
	}

	// Insert month record/patient total.
	sqlStr.append("<td style='text-align:center;' valign='top' class='total'>");
	int monthRecordCount = getCategoryCount(monthRecordTotal, yearCategory, yearItem, null);
	int monthPatCount = getCategoryCount(monthPatTotal, yearCategory, yearItem, null);
	sqlStr.append(monthRecordCount);
	sqlStr.append(" / ");
	sqlStr.append(monthPatCount);
	sqlStr.append("</td>");

	// Insert year record/patient total.
	sqlStr.append("<td style='text-align:center;' valign='top' class='yearTotal'>");
	int yearRecordCount = getCategoryCount(yearRecordTotal, yearCategory, yearItem, null);
	int yearPatCount = getCategoryCount(yearPatTotal, yearCategory, yearItem, null);
	sqlStr.append(yearRecordCount);
	sqlStr.append(" / ");
	sqlStr.append(yearPatCount);
	sqlStr.append("</td>");

	return sqlStr.toString();
}

public String getDaysCategoryInfo(
		ArrayList yearRecordTotal, ArrayList yearPatTotal,
		String selectedYear, String servCategory, String servItem) {

	String yearCategory = servCategory;
	String yearItem = servItem;

	StringBuffer sqlStr = new StringBuffer();

	String monthOfYear = null;
	for (int i = 1; i <= 12; i++) {
		if (i < 10) {
			monthOfYear = "0" + String.valueOf(i);
		} else {
			monthOfYear = String.valueOf(i);
		}

		sqlStr.append("<td style='text-align:center;' valign='top' id='");
		sqlStr.append(yearCategory);
		sqlStr.append("_");
		sqlStr.append(yearItem);
		sqlStr.append("_");
		sqlStr.append(selectedYear);
		sqlStr.append("_");
		sqlStr.append(i);
		sqlStr.append("'>");

		int monthRecordCount = getCategoryCount(yearRecordTotal, yearCategory, yearItem, monthOfYear);
		int monthPatCount = getCategoryCount(yearPatTotal, yearCategory, yearItem, monthOfYear);
		if (monthRecordCount > 0 && monthPatCount > 0) {
			sqlStr.append(monthRecordCount);
			sqlStr.append(" / ");
			sqlStr.append(monthPatCount);
		} else {
			sqlStr.append("&nbsp;");
		}
	}

	// Insert year record/patient total.
	sqlStr.append("<td style='text-align:center;' valign='top' class='yearTotal'>");
	int yearRecordCount = getCategoryCount(yearRecordTotal, yearCategory, yearItem, null);
	int yearPatCount = getCategoryCount(yearPatTotal, yearCategory, yearItem, null);
	sqlStr.append(yearRecordCount);
	sqlStr.append(" / ");
	sqlStr.append(yearPatCount);
	sqlStr.append("</td>");

	return sqlStr.toString();
}

public static boolean isLeapYear(int year) {
	if (year % 4 != 0) {
		return false;
	} else if (year % 400 == 0) {
		return true;
	} else if (year % 100 == 0) {
		return false;
	} else {
		return true;
	}
}
%>
<%
String showGraph = request.getParameter("showGraph");
if (showGraph == null || showGraph.equals("showDays")) {

String sSelectedYear = request.getParameter("searchDate_yy");
String sSelectedMonth = request.getParameter("searchDate_mm");
String modifiedUser = request.getParameter("modifiedUser");
if (modifiedUser == null) {
	modifiedUser = "";
}

int selectedYear = 0;
int selectedMonth = 0;
if (sSelectedYear != null && sSelectedMonth != null) {
	selectedYear = Integer.parseInt(sSelectedYear);
	selectedMonth = Integer.parseInt(sSelectedMonth);
} else {
	selectedYear = DateTimeUtil.getCurrentYear();
	selectedMonth = DateTimeUtil.getCurrentMonth();
}

String selectedYearString = Integer.toString(selectedYear);
String selectedYearMonth = Integer.toString(selectedMonth);

int maxDaysInMonth = 0;
if (selectedMonth == 4 || selectedMonth == 6 || selectedMonth == 9 || selectedMonth == 11) {
	maxDaysInMonth = 30;
} else if (selectedMonth == 2) {
	if (isLeapYear(selectedYear)) {
		maxDaysInMonth = 29;
	} else {
		maxDaysInMonth = 28;
	}
} else {
	maxDaysInMonth = 31;
}

String dayStartDate = "01/" + Integer.toString(selectedMonth) + "/" + Integer.toString(selectedYear);
String dayEndDate = maxDaysInMonth + "/" + Integer.toString(selectedMonth) + "/" + Integer.toString(selectedYear);
ArrayList monthRecordTotal = getAdmissionHistoryYearTotal(modifiedUser, dayStartDate, dayEndDate, "recordTotal", false, false);
ArrayList monthPatTotal = getAdmissionHistoryYearTotal(modifiedUser, dayStartDate, dayEndDate, "patTotal", false, false);
ArrayList monthRecordTotalVisit = null;
ArrayList monthPatTotalVisit = null;
ArrayList monthRecordTotalEmergency = null;
ArrayList monthPatTotalEmergency = null;
if (ConstantsServerSide.isHKAH()) {
	monthRecordTotalVisit = getAdmissionHistoryYearTotal(modifiedUser, dayStartDate, dayEndDate, "recordTotal", true, false);
	monthPatTotalVisit = getAdmissionHistoryYearTotal(modifiedUser, dayStartDate, dayEndDate, "patTotal", true, false);
	monthRecordTotalEmergency = getAdmissionHistoryYearTotal(modifiedUser, dayStartDate, dayEndDate, "recordTotal", false, true);
	monthPatTotalEmergency = getAdmissionHistoryYearTotal(modifiedUser, dayStartDate, dayEndDate, "patTotal", false, true);
}

String yearStartDate = "01/01/" + Integer.toString(selectedYear);
String yearEndDate  = "31/12/" + Integer.toString(selectedYear);
ArrayList yearRecordTotal = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "recordTotalYear", false, false);
ArrayList yearPatTotal = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "patTotalYear", false, false);
ArrayList yearRecordTotalVisit = null;
ArrayList yearPatTotalVisit = null;
ArrayList yearRecordTotalEmergency = null;
ArrayList yearPatTotalEmergency = null;
if (ConstantsServerSide.isHKAH()) {
	yearRecordTotalVisit = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "recordTotalYear", true, false);
	yearPatTotalVisit = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "patTotalYear", true, false);
	yearRecordTotalEmergency = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "recordTotalYear", false, true);
	yearPatTotalEmergency = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "patTotalYear", false, true);
}
%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>

.dataSummary {
	border-left:1px solid #000;
	border-top:1px solid #000;
	border-right:1px solid #CCC;
	border-bottom:1px solid #ccc;
	cursor: pointer;
}
</style>
<body>
<DIV id=indexWrapper style="width:100%">
<DIV id=mainFrame style="width:100%">
<DIV id=contentFrame style="width:100%">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Caretracking Report" />
	<jsp:param name="category" value="Chaplaincy" />
</jsp:include>
<div id="obBookingDetail"></div>
<br/>
Show : Days|
<a href = "../chaplaincy/ccreport.jsp?showGraph=showMonths">
		Months
</a>

<form name="search_form" action="ccreport.jsp" method="get">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch search" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Search Year</td>
		<td class="infoData" width="70%">
		<jsp:include page="../ui/dateCMB.jsp" flush="false">
		<jsp:param name="label" value="searchDate" />
		<jsp:param name="day_yy" value="<%=sSelectedYear %>" />
		<jsp:param name="day_mm" value="<%=sSelectedMonth %>" />
		<jsp:param name="yearRange" value="10" />
		<jsp:param name="YearAndMonth" value="Y" />
		</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Modified User</td>
		<td class="infoData" width="70%">
			<select name="modifiedUser" id="modifiedUser">
				<jsp:include page="../ui/staffIDCMB.jsp">
				<jsp:param value='<%=ConstantsServerSide.isHKAH()?"660":"CHAP" %>' name="deptCode"/>
					<jsp:param value="Y" name="showFT"/>
					<jsp:param value="Y" name="allowEmpty"/>
					<jsp:param value="<%=modifiedUser %>" name="value"/>
				</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="submitSearch()">Submit</button>
			<button type='button' onclick="clearSearch()">Reset</button>
		</td>
	</tr>
</table>
</form>

<table id="patientTable" border="1" width="100%">
	<tr>
		<td>

		</td>
		<td colspan="33">
		<table>
			<tr >
				<td style="vertical-align:middle" class="infoLabel">Legend for each cell :</td>
				<td style="vertical-align:middle" class="infoData" >
				Number of Records / Number of Patients
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<th width="5%">Date</th>
<%
	for (int i = 1; i <= maxDaysInMonth; i++) {
%>
		<th width="3%"><%=i %></th>
<%
	}
%>
		<th width="5%">Total-M</th>
		<th width="5%">Total-Y</th>
	</tr>
<%
	String[] categoryString = new String[6];
	categoryString[0] = "Bible Study";
	categoryString[1] = "Contact";
	categoryString[2] = "Contact (Indirect)";
	categoryString[3] = "Counseling";
	categoryString[4] = "Decision for Christ";
	categoryString[5] = "Off Site Visitation";

//	for (String servCategory:categoryString) {
	for (int i = 0; i < 6; i++) {
%>
	<tr bgcolor="#FFD067" >
		<td  colspan="34">
			<b><%=categoryString[i] %></b>
		</td>
	</tr>
	<tr>
		<td valign='top'>
<%		if (ConstantsServerSide.isTWAH() && i == 1) { %>
			&nbsp;- Attended within 24 hrs
<%		} else { %>
			&nbsp;-Patient
<%		} %>
		</td>
		<%=getCategoryInfo(monthRecordTotal, monthPatTotal, yearRecordTotal, yearPatTotal, selectedYearString, selectedYearMonth, maxDaysInMonth, categoryString[i], "Patient")%>
	</tr>
<%		if (ConstantsServerSide.isTWAH() && i == 1) { %>
	<tr>
		<td valign='top'>
			&nbsp;-Following Visit
		</td>
		<%=getCategoryInfo(monthRecordTotal, monthPatTotal, yearRecordTotal, yearPatTotal, selectedYearString, selectedYearMonth, maxDaysInMonth, categoryString[i + 1], "Patient Family")%>
	</tr>
<%		} %>
<%		if (ConstantsServerSide.isHKAH() || i != 2) { %>
	<tr>
		<td valign='top'>
			&nbsp;-Patient Family
		</td>
		<%=getCategoryInfo(monthRecordTotal, monthPatTotal, yearRecordTotal, yearPatTotal, selectedYearString, selectedYearMonth, maxDaysInMonth, categoryString[i], "Patient Family")%>
	</tr>
<%		} %>
	<tr>
		<td valign='top'>
			&nbsp;-Staff
		</td>
		<%=getCategoryInfo(monthRecordTotal, monthPatTotal, yearRecordTotal, yearPatTotal, selectedYearString, selectedYearMonth, maxDaysInMonth, categoryString[i], "Staff")%>
	</tr>
	<tr>
		<td valign='top'>
			&nbsp;-Staff Family
		</td>
		<%=getCategoryInfo(monthRecordTotal, monthPatTotal, yearRecordTotal, yearPatTotal, selectedYearString, selectedYearMonth, maxDaysInMonth, categoryString[i], "Staff Family")%>
	</tr>
<%
	}
%>
	<tr bgcolor="#FFD067" >
		<td colspan="34">
			<b>Other</b>
		</td>
	</tr>
	<tr>
		<td valign='top'>
			&nbsp;-Ceremony
		</td>
		<%=getCategoryInfo(monthRecordTotal, monthPatTotal, yearRecordTotal, yearPatTotal, selectedYearString, selectedYearMonth, maxDaysInMonth, "Other", "Ceremony")%>
	</tr>
	<tr>
		<td valign='top'>
			&nbsp;-Devotions
		</td>
		<%=getCategoryInfo(monthRecordTotal, monthPatTotal, yearRecordTotal, yearPatTotal, selectedYearString, selectedYearMonth, maxDaysInMonth, "Other", "Devotions")%>
	</tr>
	<tr>
		<td valign='top'>
			&nbsp;-Referral
		</td>
		<%=getCategoryInfo(monthRecordTotal, monthPatTotal, yearRecordTotal, yearPatTotal, selectedYearString, selectedYearMonth, maxDaysInMonth, "Other", "Referral")%>
	</tr>
<%		if (ConstantsServerSide.isHKAH()) { %>
	<tr>
		<td valign='top'>
			&nbsp;-Visit admitted patients within 24 hours
		</td>
		<%=getCategoryInfo(monthRecordTotalVisit, monthPatTotalVisit, yearRecordTotalVisit, yearPatTotalVisit, selectedYearString, selectedYearMonth, maxDaysInMonth, "Other", "Visit24hour")%>
	</tr>
	<tr>
		<td valign='top'>
			&nbsp;-Emergency Call attended within 1 hour
		</td>
		<%=getCategoryInfo(monthRecordTotalEmergency, monthPatTotalEmergency, yearRecordTotalEmergency, yearPatTotalEmergency, selectedYearString, selectedYearMonth, maxDaysInMonth, "Other", "EmergencyAttended")%>
	</tr>
<%		} %>
</table>

</DIV>
</DIV>
</DIV>

<script language="javascript">
	$(document).ready(function() {
		$('#modifiedUser :nth-child(1)').html("--- All Staff ---");
	});

	function submitSearch() {
		document.forms["search_form"].submit();
		return true;
	}

	function clearSearch() {
		var month = (new Date).getMonth()+1;
		if (month < 10) {
			month = "0" + month;
		}

		$('table.contentFrameSearch').find('select#searchDate_yy').val((new Date).getFullYear());
		$('table.contentFrameSearch').find('select#searchDate_mm').val(month);
		$('#modifiedUser :nth-child(1)').attr('selected', 'selected')
	}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
<%
} else {

String sSelectedYear = request.getParameter("searchDate_yy");

String modifiedUser = request.getParameter("modifiedUser");
if (modifiedUser == null) {
	modifiedUser = "";
}

int selectedYear = 0;
if (sSelectedYear != null ) {
	selectedYear = Integer.parseInt(sSelectedYear);
} else {
	selectedYear = DateTimeUtil.getCurrentYear();
}

String selectedYearString = Integer.toString(selectedYear);

String yearStartDate = "01/01/" + Integer.toString(selectedYear);
String yearEndDate  = "31/12/" + Integer.toString(selectedYear);
ArrayList yearRecordTotal2 = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "recordTotalMonth", false, false);
ArrayList yearPatTotal2 = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "patTotalMonth", false, false);
ArrayList yearRecordTotal2Visit = null;
ArrayList yearPatTotal2Visit = null;
ArrayList yearRecordTotal2Emergency = null;
ArrayList yearPatTotal2Emergency = null;
if (ConstantsServerSide.isHKAH()) {
	yearRecordTotal2Visit  = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "recordTotalMonth", true, false);
	yearPatTotal2Visit = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "patTotalMonth", true, false);
	yearRecordTotal2Emergency = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "recordTotalMonth", false, true);
	yearPatTotal2Emergency = getAdmissionHistoryYearTotal(modifiedUser, yearStartDate, yearEndDate, "patTotalMonth", false, true);
}
%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>

.dataSummary {
	border-left:1px solid #000;
	border-top:1px solid #000;
	border-right:1px solid #CCC;
	border-bottom:1px solid #ccc;
	cursor: pointer;
}
</style>
<body>
<DIV id=indexWrapper style="width:100%">
<DIV id=mainFrame style="width:100%">
<DIV id=contentFrame style="width:100%">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Caretracking Report" />
	<jsp:param name="category" value="Chaplaincy" />
</jsp:include>
<div id="obBookingDetail"></div>
<br/>
Show : <a href = "../chaplaincy/ccreport.jsp?showGraph=showDays">Days</a>
|Months
<form name="search_form" action="ccreport.jsp" method="get">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch search" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Search Year</td>
		<td class="infoData" width="70%">
			<jsp:include page="../ui/dateCMB.jsp" flush="false">
				<jsp:param name="label" value="searchDate" />
				<jsp:param name="day_yy" value="<%=sSelectedYear %>" />
				<jsp:param name="isYearOnly" value="Y" />
				<jsp:param name="yearRange" value="10" />
			</jsp:include>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Modified User</td>
		<td class="infoData" width="70%">
			<select name="modifiedUser" id="modifiedUser">
				<jsp:include page="../ui/staffIDCMB.jsp">
					<jsp:param value='<%=ConstantsServerSide.isHKAH()?"660":"CHAP" %>' name="deptCode"/>
					<jsp:param value="Y" name="showFT"/>
					<jsp:param value="Y" name="allowEmpty"/>
					<jsp:param value="<%=modifiedUser %>" name="value"/>
				</jsp:include>
			</select>
		</td>
	</tr>

	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="submitSearch()">Submit</button>
			<button type='button' onclick="clearSearch()">Reset</button>
		</td>
	</tr>

	<tr>
		<td><input type="hidden" name="showGraph" value="showMonths"></td>
	</tr>
</table>
</form>

<table id="patientTable" border="1" width="100%">
	<tr>
		<td>&nbsp</td>
		<td colspan="13">
			<table>
				<tr >
					<td  style="vertical-align:middle" class="infoLabel">Legend for each cell :</td>
					<td style="vertical-align:middle" class="infoData" >
					Number of Records / Number of Patients
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<th width="25%">Month</th>
<%
	for (int i = 1; i <= 12; i++) {
%>
		<th width="5%"><%=i %></th>
<%
	}
%>
		<th width="15%">Total-Y</th>
	</tr>
<%
	String[] categoryString = new String[6];
	categoryString[0] = "Bible Study";
	categoryString[1] = "Contact";
	categoryString[2] = "Contact (Indirect)";
	categoryString[3] = "Counseling";
	categoryString[4] = "Decision for Christ";
	categoryString[5] = "Off Site Visitation";

//	for (String servCategory:categoryString) {
	for (int i = 0; i < 6; i++) {
%>
	<tr bgcolor="#FFD067" >
		<td  colspan="14">
			<b><%=categoryString[i] %></b>
		</td>
	</tr>
	<tr>
		<td valign='top'>
<%		if (ConstantsServerSide.isTWAH() && i == 1) { %>
			&nbsp;- Attended within 24 hrs
<%		} else { %>
			&nbsp;-Patient
<%		} %>
		</td>
		<%=getDaysCategoryInfo(yearRecordTotal2, yearPatTotal2, selectedYearString, categoryString[i], "Patient")%>
	</tr>
<%		if (ConstantsServerSide.isTWAH() && i == 1) { %>
	<tr>
		<td valign='top'>
			&nbsp;-Following Visit
		</td>
		<%=getDaysCategoryInfo(yearRecordTotal2, yearPatTotal2, selectedYearString, categoryString[i + 1], "Patient Family")%>
	</tr>
<%		} %>
<%		if (ConstantsServerSide.isHKAH() || i != 2) { %>
	<tr>
		<td valign='top'>
			&nbsp;-Patient Family
		</td>
		<%=getDaysCategoryInfo(yearRecordTotal2, yearPatTotal2, selectedYearString, categoryString[i], "Patient Family")%>
	</tr>
<%		} %>
	<tr>
		<td valign='top'>
			&nbsp;-Staff
		</td>
		<%=getDaysCategoryInfo(yearRecordTotal2, yearPatTotal2, selectedYearString, categoryString[i], "Staff")%>
	</tr>
	<tr>
		<td valign='top'>
			&nbsp;-Staff Family
		</td>
	<%=getDaysCategoryInfo(yearRecordTotal2, yearPatTotal2, selectedYearString, categoryString[i], "Staff Family")%>
	</tr>
<%
	}
%>
	<tr bgcolor="#FFD067" >
		<td colspan="14">
			<b>Other</b>
		</td>
	</tr>
	<tr>
		<td valign='top'>
			&nbsp;-Ceremony
		</td>
		<%=getDaysCategoryInfo(yearRecordTotal2, yearPatTotal2, selectedYearString, "Other", "Ceremony")%>
	</tr>
	<tr>
		<td valign='top'>
			&nbsp;-Devotions
		</td>
		<%=getDaysCategoryInfo(yearRecordTotal2, yearPatTotal2, selectedYearString, "Other", "Devotions")%>
	</tr>
	<tr>
		<td valign='top'>
			&nbsp;-Referral
		</td>
		<%=getDaysCategoryInfo(yearRecordTotal2, yearPatTotal2, selectedYearString, "Other", "Referral")%>
	</tr>
<%		if (ConstantsServerSide.isHKAH()) { %>
	<tr>
		<td valign='top'>
			&nbsp;-Visit admitted patients within 24 hours
		</td>
		<%=getDaysCategoryInfo(yearRecordTotal2Visit, yearPatTotal2Visit, selectedYearString, "Other", "Visit24hour")%>
	</tr>
	<tr>
		<td valign='top'>
			&nbsp;-Emergency Call attended within 1 hour
		</td>
		<%=getDaysCategoryInfo(yearRecordTotal2Emergency, yearPatTotal2Emergency, selectedYearString, "Other", "EmergencyAttended")%>
	</tr>
<%		} %>
</table>
</DIV>
</DIV>
</DIV>

<script language="javascript">
	$(document).ready(function() {
		$('#modifiedUser :nth-child(1)').html("--- All Staff ---");
	});

	function submitSearch() {
		document.forms["search_form"].submit();
		return true;
	}

	function clearSearch() {
		var month = (new Date).getMonth()+1;
		if (month < 10) {
			month = "0" + month;
		}

		$('table.contentFrameSearch').find('select#searchDate_yy').val((new Date).getFullYear());
		$('#modifiedUser :nth-child(1)').attr('selected', 'selected')
	}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
<%
}
%>