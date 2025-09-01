<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%
UserBean userBean = new UserBean(request);
String loginStaffID = userBean.getStaffID();

String search = request.getParameter("search");

String searchStaffID = request.getParameter("searchStaffID");
String searchStaffName = request.getParameter("searchStaffName");
String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");
String deptCode = request.getParameter("deptCode");
//String reportInterval = request.getParameter("reportInterval");
String reportInterval = "day";
String filterStatusO = request.getParameter("filterStatusO");
String filterStatusP = request.getParameter("filterStatusP");
String filterStatusA = request.getParameter("filterStatusA");
String filterStatusR = request.getParameter("filterStatusR");
String filterStatusC = request.getParameter("filterStatusC");
float balanceActual = -1;
float balancePending = -1;
int isSingleUser = 0;
String balanceYear = null;

NumberFormat balanceFormat = null;
balanceFormat = DecimalFormat.getNumberInstance();
balanceFormat.setMinimumIntegerDigits(1);

String title = null;
String message = null;
String errorMessage = null;

String staffID = request.getParameter("staffID");
if (staffID == null) {
	staffID = loginStaffID;
}

int current_yy = DateTimeUtil.getCurrentYear();
String fromDate = "01/01/" + current_yy;
String toDate = "31/12/" + current_yy;

boolean searchAll = false;
if (userBean.isAccessible("function.eleave.admin")) {
	searchAll = true;
}

if (searchStaffID == null) searchStaffID = userBean.getStaffID();
if (searchStaffName == null) searchStaffName = userBean.getUserName();
if (deptCode == null) deptCode = userBean.getDeptCode();


// When blank form
if (filterStatusO == null && filterStatusP == null && filterStatusA == null &&
		filterStatusR == null && filterStatusC == null) {
	filterStatusO = "O";
	filterStatusP = "P";
	filterStatusA = "A";
//	filterStatusR = "R";
	filterStatusC = "C";
}

ArrayList record = null;
if (search != null) {
	record = ELeaveDB.getInfoList(searchStaffID, searchStaffName, startDate, endDate,
			reportInterval,
			new String[] { filterStatusO, filterStatusP, filterStatusA,
			filterStatusR, filterStatusC },
			deptCode); 
	request.setAttribute("info_list", record);

	if (searchStaffID != null && searchStaffID.length() > 0) {
		isSingleUser = 1;
	} else {
		isSingleUser = ELeaveDB.checkSingleReturn(searchStaffID, searchStaffName, startDate, endDate,
				reportInterval,
				new String[] { filterStatusO, filterStatusP, filterStatusA,
				filterStatusR, filterStatusC },
				deptCode);
	}

	balanceYear = fromDate.substring(6, 10);
	float balance[] = ELeaveDB.getBalance(searchStaffID, balanceYear);
	if (balance != null) {
		balanceActual = balance[0];
		balancePending = balance[1];
	}
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.eleave.view" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="search_form" action="info_list.jsp" method="post">
<input type="hidden" name="search" value="yes"/>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="35%">
			<input type="text" name="searchStaffID" value="<%=searchStaffID==null?"":searchStaffID %>"
				   <%=searchAll?"":"disabled=disabled" %> />
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.name" /></td>
		<td class="infoData" width="35%">
			<input type="text" name="searchStaffName" value="<%=searchAll||searchStaffName==null?"":searchStaffName %>"
				   <%=searchAll?"":"disabled=disabled" %> />
		</td>
	</tr>
<%
String displayDeptCode = searchAll ? "" : deptCode;
%>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="35%" colspan="3">
			<select name="deptCode" <%=searchAll?"":"disabled=disabled" %>>
				<option value="">--- All Departments ---</option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=displayDeptCode %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
<%--<jsp:param name="ignoreDeptCode" value="880" /> --%>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.status" /></td>
		<td class="infoData" colspan="3" width="70%">
			<input type="checkbox" name="filterStatusO" value="O" id="checkboxO" <%=filterStatusO==null?"":"checked=checked" %> />
			<label  for="checkboxO"><bean:message key="label.waiting.for.approve" /></label>
			<input type="checkbox" name="filterStatusP" value="P" id="checkboxP" <%=filterStatusP==null?"":"checked=checked" %> />
			<label  for="checkboxP"><bean:message key="label.pending" /></label>
			<input type="checkbox" name="filterStatusA" value="A" id="checkboxA" <%=filterStatusA==null?"":"checked=checked" %> />
			<label  for="checkboxA"><bean:message key="label.approved" /></label>
			<input type="checkbox" name="filterStatusR" value="R" id="checkboxR" <%=filterStatusR==null?"":"checked=checked" %> />
			<label  for="checkboxR"><bean:message key="label.rejected" /></label>
			<input type="checkbox" name="filterStatusC" value="C" id="checkboxC" <%=filterStatusC==null?"":"checked=checked" %> />
			<label  for="checkboxC"><bean:message key="label.confirmed" /></label>
		</td>
	</tr>
<%--
	<tr class="smallText">
		<td class="infoLabel" width="15%">Report interval</td>
		<td class="infoData" width="35%" colspan="3">
			<select name="reportInterval">
				<option value="day" <%="day".equals(reportInterval)?" selected":""%>><bean:message key="prompt.day" /></option>
				<option value="month" <%="month".equals(reportInterval)?" selected":""%>><bean:message key="prompt.month" /></option>
				<option value="year" <%="year".equals(reportInterval)?" selected":""%>><bean:message key="prompt.year" /></option>
			</select>
		</td>
	</tr>
--%>

	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.from" /></td>
		<td class="infoData" width="35%">
			<input type="text" name="startDate" id="startDate" class="datepickerfield" value="<%=startDate==null?fromDate:startDate %>" />
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.to" /></td>
		<td class="infoData" width="35%">
			<input type="text" name="endDate" id="endDate" class="datepickerfield" value="<%=endDate==null?toDate:endDate %>" />
		</td>
	</tr>

	<tr class="smallText">
		<td colspan="4" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
<%	if (record != null && record.size() > 0 && balanceYear != null && search != null && isSingleUser == 1){%>
		<tr class="smallText">
			<td align="left" colspan="4">
			<span style="color: 'red'">
			<br>
			<b>Balance (<%=balanceYear%>)<%=balanceFormat.format(balanceActual) %> day(s)</b>
			</span>
			</td>
		</tr>
<%	} %>
<% if (search != null) { %>
<display:table id="row" name="requestScope.info_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%></display:column>
	<display:column property="fields0" titleKey="prompt.name" style="width:15%"/>
	<display:column property="fields4" titleKey="prompt.department" style="width:10%"/>
	<% if ("year".equals(reportInterval)) {  %>
		<display:column property="fields1" titleKey="prompt.year" style="width:5%"/>
	<% } else if ("month".equals(reportInterval)){ %>
		<display:column property="fields1" titleKey="prompt.year" style="width:5%"/>
		<display:column property="fields2" titleKey="prompt.month" style="width:5%"/>
	<% } else if ("day".equals(reportInterval)){ %>
		<display:column property="fields1" titleKey="prompt.from" style="width:5%"/>
		<display:column property="fields2" titleKey="prompt.to" style="width:5%"/>
	<% } %>
	<display:column titleKey="prompt.appliedDate" style="width:10%">
		<c:out value="${row.fields3}" /> Day(s)
	</display:column>
</display:table>


<% } %>
</table>
</form>
<script language="javascript">
<!--
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.location = "?";
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>