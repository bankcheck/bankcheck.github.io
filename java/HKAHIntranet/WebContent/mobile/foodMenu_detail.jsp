<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> checkMenu(String menuCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  	MENU_CODE ");
		sqlStr.append("FROM   	MA_FOOD_MENU ");
		sqlStr.append("WHERE 	MENU_CODE = '"+menuCode+"' ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> getMenuDetail(String menuCode, String sitecode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  	C.CODE_NO, C.CODE_VALUE1, C.CODE_VALUE2, M.DISPLAY, M.DWEEKDAY, M.DTIME ");
		sqlStr.append("FROM   	AH_SYS_CODE C, MA_FOOD_MENU@PORTAL_" + sitecode + " M ");
		sqlStr.append("WHERE 	C.CODE_NO = M.MENU_CODE ");
		sqlStr.append("AND 		C.SYS_ID = 'DIT' ");
		sqlStr.append("AND 		C.CODE_TYPE = 'MENU_TYPE' ");
		sqlStr.append("AND 		C.CODE_NO = '"+menuCode+"' ");

		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}

	private Boolean createMenu(String menuCode, UserBean userBean) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO MA_FOOD_MENU ");
		sqlStr.append("(MENU_CODE, CREATE_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?) ");

		return UtilDBWeb.updateQueue( sqlStr.toString(),
				new String[] { menuCode, userBean.getStaffID()});
	}

	private Boolean updateMenu(String menuCode, String display, String displayWeekday, String displayTimeRange, UserBean userBean) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE MA_FOOD_MENU ");
		sqlStr.append("SET DISPLAY = ?, DWEEKDAY = ?, DTIME = ?, UPDATE_DATE = SYSDATE, UPDATE_USER = ? ");
		sqlStr.append("WHERE MENU_CODE = ? ");

		return UtilDBWeb.updateQueue( sqlStr.toString(),
				new String[] { display, displayWeekday, displayTimeRange, userBean.getStaffID(), menuCode });
	}

	private ArrayList<ReportableListObject> getlist(String menuType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  I.ITEM_CODE, I.ITEM_NAME1, I.ITEM_NAME2, I.ITEM_NAME3 ");
		sqlStr.append("FROM   DIT_MENU_ITEM I ");
		sqlStr.append("WHERE (SYSDATE BETWEEN I.EFFECTIVE_DATE AND NVL(I.EXPIRED_DATE, SYSDATE)) ");
		if(menuType != null && menuType.length()>0){
			sqlStr.append("AND I.MENU_TYPE = '" + menuType + "' ");
		}
		sqlStr.append("ORDER BY I.ITEM_CODE ");

		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
%>
<%

UserBean userBean = new UserBean(request);

String sitecode = "";
if (ConstantsServerSide.isTWAH()) {
	sitecode = "TW";
} else if (ConstantsServerSide.isHKAH()) {
	sitecode = "HK";
}

String command = request.getParameter("command");
String step = request.getParameter("step");
String menuCode = request.getParameter("menuCode");
String display = request.getParameter("display");
String displayWeekday = request.getParameter("newDayRange");
String displayTimeRange = request.getParameter("newTimeRange");

String menuE = "";
String menuC = "";

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";


ArrayList<ReportableListObject> record = checkMenu(menuCode);
ReportableListObject row = null;
if (record.size() == 0) {
	command = "create";
	step = "1";
}

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
}

if ("1".equals(step)) {
	if (createAction) {
		if (createMenu(menuCode, userBean)) {
			message = "Menu created.";
			createAction = false;
		} else {
			errorMessage = "Menu create fail.";
		}
	} else if (updateAction) {
		if (updateMenu(menuCode, display, displayWeekday, displayTimeRange, userBean)) {
			message = "Menu updated.";
			updateAction = false;
		} else {
			errorMessage = "Menu update fail.";
		}
	}
}

// load data from database
if (!createAction) {
	record = getMenuDetail(menuCode, sitecode);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		menuE = row.getValue(1);
		menuC= row.getValue(2);
		if(!"1".equals(step)){
			display = row.getValue(3);
			displayWeekday = row.getValue(4);
			displayTimeRange = row.getValue(5);
		}
	}
}
request.setAttribute("list", getlist(menuCode));

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

	 http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<meta http-equiv="cache-control" content="no-cache" />
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Menu Detail" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<form name="form1" id="form1" action="foodMenu_detail.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Menu Code</td>
		<td class="infoData" width="70%"><%=menuCode %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Menu Display (English)</td>
		<td class="infoData" width="70%"><%=menuE %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Menu Display (Chinese)</td>
		<td class="infoData" width="70%"><%=menuC %></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText">
		<th colspan=2 class="infoLabel" width="100%">Other information</th>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Display in Mobile</td>
		<td class="infoData" width="70%">
			<input type="radio" id="" name="display" value="1" <%if ("1".equals(display)) {%>checked<%} %>> Yes
			<input type="radio" id="" name="display" value="0" <%if ("0".equals(display)) {%>checked<%} %>> No
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Display Weekday</td>
		<td class="infoData" width="70%">
			<input type="button" id="" name="displayWeekdayAll" value="Select All" onclick="selectAllWeekday()"> <br/>
			<input type="checkbox" id="" name="displayWeekday" class="dayRange" value="1" onclick="updateDayRange()" <%if (displayWeekday.contains("1")) {%>checked<%} %>> Sunday <br/>
			<input type="checkbox" id="" name="displayWeekday" class="dayRange" value="2" onclick="updateDayRange()" <%if (displayWeekday.contains("2")) {%>checked<%} %>> Monday <br/>
			<input type="checkbox" id="" name="displayWeekday" class="dayRange" value="3" onclick="updateDayRange()" <%if (displayWeekday.contains("3")) {%>checked<%} %>> Tuesday <br/>
			<input type="checkbox" id="" name="displayWeekday" class="dayRange" value="4" onclick="updateDayRange()" <%if (displayWeekday.contains("4")) {%>checked<%} %>> Wednesday <br/>
			<input type="checkbox" id="" name="displayWeekday" class="dayRange" value="5" onclick="updateDayRange()" <%if (displayWeekday.contains("5")) {%>checked<%} %>> Thurday <br/>
			<input type="checkbox" id="" name="displayWeekday" class="dayRange" value="6" onclick="updateDayRange()" <%if (displayWeekday.contains("6")) {%>checked<%} %>> Friday <br/>
			<input type="checkbox" id="" name="displayWeekday" class="dayRange" value="7" onclick="updateDayRange()" <%if (displayWeekday.contains("7")) {%>checked<%} %>> Saturday <br/>
			<input type="hidden" id="newDayRange" name="newDayRange" value="<%=displayWeekday%>">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Time Range</td>
		<td class="infoData" width="70%">
			<input type="button" id="" name="displayTimeRangeAll" value="Select All" onclick="selectAllTimeRange()"> <br/>
			<input type="checkbox" id="" name="displayTimeRange" class="timeRange" value="B" onclick="updateTimeRange()" <%if (displayTimeRange.contains("B")) {%>checked<%} %>> Breakfast <br/>
			<input type="checkbox" id="" name="displayTimeRange" class="timeRange" value="L" onclick="updateTimeRange()" <%if (displayTimeRange.contains("L")) {%>checked<%} %>> Lunch <br/>
			<input type="checkbox" id="" name="displayTimeRange" class="timeRange" value="D" onclick="updateTimeRange()" <%if (displayTimeRange.contains("D")) {%>checked<%} %>> Dinner <br/>
			<input type="hidden" id="newTimeRange" name="newTimeRange" value="<%=displayTimeRange%>">
			<div>	
				<table>
					<tr>
						<th>Item Type</th>
						<th>Display Time</th>
						<th>Serve Time</th>
					</tr>
					<tr>
						<td>Breakfast</td>
						<td>20:00 - 11:00</td>
						<td>07:00 - 11:00</td>
					</tr>
					<tr>
						<td>Lunch</td>
						<td>09:00 - 17:30</td>
						<td>11:00 - 17:30</td>
					</tr>
					<tr>
						<td>Dinner</td>
						<td>15:30 - 20:00</td>
						<td>17:30 - 20:00</td>
					</tr>
				</table>
				**Each item will only be shown in the related display times slot.<br/>
				**The patient can only select the delivery time between the serving time.
			</div>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="submitAction('update',0);" class="btn-click">Refresh</button>
			<button onclick="submitAction('update',1);" class="btn-click"><bean:message key="button.update" /></button>
			<button onclick="window.close();" class="btn-click"><bean:message key="button.close" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="menuCode" value="<%=menuCode %>">
<input type="hidden" name="command">
<input type="hidden" name="step">

</form>

<display:table id="row1" name="requestScope.list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="Item Code" style="width:20%">
		<c:out value="${row1.fields0}" /><br>
		<img src="/upload/Food%20Service/foodPhoto/<%=menuCode %>/<c:out value="${row1.fields0}" />.jpg?nocache=<%=System.currentTimeMillis()%>" onerror="this.src='../images/alert_general.gif'" width="171" height="114">
	</display:column>
	<display:column property="fields1" title="Display Name (English)" style="width:23%"/>
	<display:column property="fields2" title="Display Name (Traditional Chinese)" style="width:23%"/>
	<display:column property="fields3" title="Display Name (Simplified Chinese)" style="width:23%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return getFoodDetail('update', '<c:out value="${row1.fields0}" />');"><bean:message key="button.update" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="No record"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<script language="javascript">
function selectAllWeekday(){
	$("input[type=checkbox][name=displayWeekday]").attr('checked', true);
	updateDayRange();
}
function selectAllTimeRange(){
	$("input[type=checkbox][name=displayTimeRange]").attr('checked', true);
	updateTimeRange();
}
function updateDayRange(){
	var i = 0;
	var arr = [];
	$('.dayRange:checked').each(function () {
	    arr[i++] = $(this).val();
	});
	$("#newDayRange").val(arr.toString());
	}
function updateTimeRange(){
	var i = 0;
	var arr = [];
	$('.timeRange:checked').each(function () {
	    arr[i++] = $(this).val();
	});
	$("#newTimeRange").val(arr.toString());
}
function submitAction(cmd, stp) {
	document.form1.command.value = cmd;
	document.form1.step.value = stp;
	document.form1.submit();
}
function getFoodDetail(cmd, cid) {
	callPopUpWindow("food_detail.jsp?command=" + cmd + "&itmcode=" + cid);
	return false;
}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>