<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> checkItem(String itemCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  	ITEM_CODE ");
		sqlStr.append("FROM   	MA_FOOD_ITEM ");
		sqlStr.append("WHERE 	ITEM_CODE = '"+itemCode+"' ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> getItemDetail(String itemCode, String sitecode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  	I.MENU_TYPE, I.ITEM_CODE, I.ITEM_NAME1, I.ITEM_NAME2, I.ITEM_NAME3, I.CURRENCY, I.UNIT_PRICE, I.APPLICABLE, C.CODE_VALUE1, C.CODE_VALUE2, ");
		sqlStr.append("			M.DISPLAY, M.DWEEKDAY, M.DTIME, M.COMPMUST, I.MENU_TYPE, ");
		sqlStr.append("			P.COMP_CODE, P.COMPMUST, P.COMPMIN, P.COMPMAX ");
		sqlStr.append("FROM   	DIT_MENU_ITEM I, AH_SYS_CODE C, MA_FOOD_ITEM@PORTAL_" + sitecode + " M, MA_FOOD_COMP@PORTAL_" + sitecode + " P ");
		sqlStr.append("WHERE 	I.MENU_TYPE = C.CODE_NO ");
		sqlStr.append("AND 		M.ITEM_CODE = I.ITEM_CODE ");
		sqlStr.append("AND 		I.ITEM_CODE = P.ITEM_CODE(+) ");
		sqlStr.append("AND 		(SYSDATE BETWEEN I.EFFECTIVE_DATE AND NVL(I.EXPIRED_DATE, SYSDATE)) ");
		sqlStr.append("AND 		I.ITEM_CODE = '"+itemCode+"' ");
		System.out.println("[Debug]"+sqlStr.toString());
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> getItemApplicable(String applicable) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CODE_NO, CODE_VALUE1, CODE_VALUE2 ");
		sqlStr.append("FROM   AH_SYS_CODE ");
		sqlStr.append("WHERE SYS_ID = 'DIT' ");
		sqlStr.append("AND CODE_TYPE = 'APPL_TYPE' ");
		sqlStr.append("AND CODE_NO = '"+applicable+"' ");

		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}

	private Boolean createItem(String itemCode, UserBean userBean) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO MA_FOOD_ITEM ");
		sqlStr.append("(ITEM_CODE, CREATE_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?) ");

		return UtilDBWeb.updateQueue( sqlStr.toString(),
				new String[] { itemCode, userBean.getStaffID()});
	}

	private Boolean updateItem(String itemCode, String display, String displayWeekday, String displayTimeRange, String compMust, UserBean userBean) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE MA_FOOD_ITEM ");
		sqlStr.append("SET DISPLAY = ?, DWEEKDAY = ?, DTIME = ?, COMPMUST = ?, UPDATE_DATE = SYSDATE, UPDATE_USER = ? ");
		sqlStr.append("WHERE ITEM_CODE = ? ");

		return UtilDBWeb.updateQueue( sqlStr.toString(),
				new String[] { display, displayWeekday, displayTimeRange, compMust, userBean.getStaffID(), itemCode });
	}
	
	private ArrayList<ReportableListObject> getItemComp(String itemcode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.COMP_CODE, D.COMP_NAME1, D.COMP_NAME2 ");
		sqlStr.append("FROM   DIT_ITEM_COMP D ");
		sqlStr.append("WHERE D.ITEM_CODE = '"+itemcode+"' ");
		sqlStr.append("ORDER BY D.SEQ_NO ");

		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
	
	private Boolean updateComp(String itemCode, String compCode, String compMust, String compMin, String compMax, UserBean userBean) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE MA_FOOD_COMP ");
		sqlStr.append("SET COMPMUST = ?, COMPMIN = ?, COMPMAX = ?, UPDATE_DATE = SYSDATE, UPDATE_USER = ? ");
		sqlStr.append("WHERE ITEM_CODE = ? ");
		sqlStr.append("AND COMP_CODE = ? ");
		if(UtilDBWeb.updateQueue( sqlStr.toString(),
			new String[] { compMust, compMin, compMax, userBean.getStaffID(), itemCode, compCode})){
			return true;
		}else{
			StringBuffer sqlStr1 = new StringBuffer();
			sqlStr1.append("INSERT INTO MA_FOOD_COMP ");
			sqlStr1.append("VALUES (?,?,?,TO_NUMBER(?),TO_NUMBER(?),SYSDATE,?,SYSDATE,?)");
			return UtilDBWeb.updateQueue( sqlStr1.toString(),
					new String[] {itemCode, compCode, compMust, compMin, compMax, userBean.getStaffID(), userBean.getStaffID()});
		}
	}
%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = true;
}

UserBean userBean = new UserBean(request);
Map<String, String> compMustSelect = new HashMap<String, String>();
Map<String, String> compMin = new HashMap<String, String>();
Map<String, String> compMax = new HashMap<String, String>();

String sitecode = "";
if (ConstantsServerSide.isTWAH()) {
	sitecode = "TW";
} else if (ConstantsServerSide.isHKAH()) {
	sitecode = "HK";
}

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String menuCode = ParserUtil.getParameter(request, "menuCode");
String itmcode = ParserUtil.getParameter(request, "itmcode");
String compcode = ParserUtil.getParameter(request, "compcode");
if(compcode != null && !"".equals(compcode)){
	String[] complist = compcode.split(",");
	for(int i=0; i<complist.length; i++){
		compMustSelect.put(complist[i], ParserUtil.getParameter(request, "compMust"+complist[i]));
		compMin.put(complist[i], ParserUtil.getParameter(request, "compMin"+complist[i]));
		compMax.put(complist[i], ParserUtil.getParameter(request, "compMax"+complist[i]));
	}
}
String display = ParserUtil.getParameter(request, "display");
String displayWeekday = ParserUtil.getParameter(request, "newDayRange");
String displayTimeRange = ParserUtil.getParameter(request, "newTimeRange");
String compMust = ParserUtil.getParameter(request, "compMust");
String foodPhotoImage = ParserUtil.getParameter(request, "foodPhotoImage");

String categoryE = "";
String categoryC = "";
String itmEname = "";
String itmTCname = "";
String itmSCname = "";
String currency = "";
String price = "";
String applicable = "";

ArrayList applist = new ArrayList();
ArrayList appClist = new ArrayList();
ArrayList appElist = new ArrayList();
ArrayList itemComp = new ArrayList();
ArrayList itemCompE = new ArrayList();
ArrayList itemCompC = new ArrayList();

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

ArrayList<ReportableListObject> record = checkItem(itmcode);
ReportableListObject row = null;
ReportableListObject row1 = null;
if (record.size() == 0) {
	command = "create";
	step = "1";
}

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
}

if (fileUpload) {
	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append("/Food Service/foodPhoto/");
		tempStrBuffer.append(menuCode);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + itmcode + ".jpg"
			);
		}
	}
}

if ("1".equals(step)) {
	if (createAction) {
		if (createItem(itmcode, userBean)) {
			message = "Item created.";
			createAction = false;
		} else {
			errorMessage = "Item create fail.";
		}
	} else if (updateAction) {
		if (updateItem(itmcode, display, displayWeekday, displayTimeRange, compMust, userBean)) {
			boolean success = true;
			String[] complist = compcode.split(",");
			if(complist.length>0){
				for (int i=0; i<compMustSelect.size(); i++){
					success = updateComp(itmcode, complist[i], compMustSelect.get(complist[i]), compMin.get(complist[i]), compMax.get(complist[i]), userBean);
				}
			}
			if(success){
				message = "Item updated.";
				updateAction = false;
			}else{
				errorMessage = "Item update fail.";
			}
		} else {
			errorMessage = "Item update fail.";
		}
	}
}

// load data from database
if (!createAction) {
	record = getItemDetail(itmcode, sitecode);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		categoryE = row.getValue(8);
		categoryC = row.getValue(9);
		itmEname = row.getValue(2);
		itmTCname = row.getValue(3);
		itmSCname = row.getValue(4);
		currency = row.getValue(5);
		price = row.getValue(6);
		applicable = row.getValue(7);
		menuCode = row.getValue(14);
		if(!"1".equals(step)){
			display = row.getValue(10);
			displayWeekday = row.getValue(11);
			displayTimeRange = row.getValue(12);
			compMust = row.getValue(13);
				for(int i=0;i<record.size();i++){
					row1 = (ReportableListObject) record.get(i);
					compMustSelect.put(row1.getValue(15), row1.getValue(16));
					compMin.put(row1.getValue(15), row1.getValue(17));
					compMax.put(row1.getValue(15), row1.getValue(18));
				}
		}
		String[] app = applicable.split(",");
		for (int i=0; i < app.length; i++) {
			record = getItemApplicable(app[i]);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				applist.add(i,app[i]);
				appElist.add(i, row.getValue(1));
				appClist.add(i, row.getValue(2));
			}
		}
		record = getItemComp(itmcode);
		if (record.size() > 0) {
			compcode = "";
			for (int i=0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				if(compcode != null && !"".equals(compcode)){
					compcode = compcode + "," + row.getValue(0);
				}else{
					compcode = row.getValue(0);
				}
				itemComp.add(i, row.getValue(0));
				itemCompE.add(i, row.getValue(1));
				itemCompC.add(i, row.getValue(2));
			}
		}
	}
}
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
	<jsp:param name="pageTitle" value="Food Detail" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<form name="form1" id="form1" enctype="multipart/form-data" action="food_detail.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Menu Category</td>
		<td class="infoData" width="70%"><%=categoryE %> <%=categoryC %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Item Code</td>
		<td class="infoData" width="70%"><%=itmcode %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Display Name (English)</td>
		<td class="infoData" width="70%"><%=itmEname %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Display Name (Traditional Chinese)</td>
		<td class="infoData" width="70%"><%=itmTCname %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Display Name (Simplified Chinese)</td>
		<td class="infoData" width="70%"><%=itmSCname %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Price</td>
		<td class="infoData" width="70%"><%=currency %> <%=price %></td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Applicable</td>
		<td class="infoData" width="70%">
			<table style="border:1px solid; border-collapse: collapse;" width="80%">
<%			for(int i=0; i < applist.size(); i++){ %>
				<tr>
					<td style="border:1px solid; padding:2px;" width="6%"><%=applist.get(i) %></td>
					<td style="border:1px solid; padding:2px;" width="47%"><%=appElist.get(i) %></td>
					<td style="border:1px solid; padding:2px;" width="47%"><%=appClist.get(i) %></td>
				</tr>
<%			} %>
			</table>
		</td>
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
			<input type="checkbox" id="" name="displayTimeRange" class="timeRange" value="B" onclick="updateTimeRange()" <%if (displayTimeRange.contains("B")) {%>checked<%} %>> Breakfast<br/>
			<input type="checkbox" id="" name="displayTimeRange" class="timeRange" value="L" onclick="updateTimeRange()" <%if (displayTimeRange.contains("L")) {%>checked<%} %>> Lunch<br/>
			<input type="checkbox" id="" name="displayTimeRange" class="timeRange" value="D" onclick="updateTimeRange()" <%if (displayTimeRange.contains("D")) {%>checked<%} %>> Dinner<br/>
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
<!--	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="30%">Composition Must Be Selected:</td>
		<td class="infoData" width="70%">
			<input type="radio" id="" name="compMust" value="1" <%if ("1".equals(compMust)) {%>checked<%} %>> Yes
			<input type="radio" id="" name="compMust" value="0" <%if ("0".equals(compMust)) {%>checked<%} %>> No
		</td>
	</tr>-->
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="30%">Composition:</td>
		<td class="infoData" width="70%">
<%			if (itemComp.size()>0){ %>
			<table style="border:1px solid; border-collapse: collapse;" width="100%">
				<tr>
					<th style="border:1px solid; padding:2px;" width="35%">Composition</th>
					<th style="border:1px solid; padding:2px;" width="25%">Must Select</th>
					<th style="border:1px solid; padding:2px;" width="40%">Value</th>
				</tr>
<%				for(int i=0; i < itemComp.size(); i++){ %>
					<tr>
						<td style="border:1px solid; padding:2px;"><%=itemCompE.get(i) %>(<%=itemCompC.get(i) %>)</td>
						<td style="border:1px solid; padding:2px;">
							<input type="radio" onclick="updateMinMax(this, '<%=itemComp.get(i) %>')" name="compMust<%=itemComp.get(i) %>" value="1" <%if ("1".equals(compMustSelect.get(itemComp.get(i)))) {%>checked<%} %>> Yes
							<input type="radio" onclick="updateMinMax(this, '<%=itemComp.get(i) %>')" name="compMust<%=itemComp.get(i) %>" value="0" <%if ("0".equals(compMustSelect.get(itemComp.get(i)))) {%>checked<%} %>> No
						</td>
						<td style="border:1px solid; padding:2px;">
							<select id="compMin<%=itemComp.get(i) %>" name="compMin<%=itemComp.get(i) %>">
									<option value=""></option>
	<%							for(int j=0; j < 10; j++){ %>
									<option value="<%=j %>" <%=compMin.get(itemComp.get(i)) == null?"":(Integer.valueOf(compMin.get(itemComp.get(i))) == j?"selected=selected":"") %>><%=j %></option>
	<%							} %>
							</select> - 
							<select id="compMax<%=itemComp.get(i) %>" name="compMax<%=itemComp.get(i) %>">
									<option value=""></option>
	<%							for(int j=0; j < 10; j++){ %>
									<option value="<%=j %>" <%=compMax.get(itemComp.get(i)) == null?"":(Integer.valueOf(compMax.get(itemComp.get(i))) == j?"selected=selected":"") %>><%=j %></option>
	<%							} %>
							</select>
						</td>
					</tr>
<%				} %>
			</table>
<%			} else {  %>No composition under this item.<%}%>
		</td>
	</tr>
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="30%">Photo:</td>
		<td class="infoData" width="70%">
			<img src="/upload/Food%20Service/foodPhoto/<%=menuCode %>/<%=itmcode %>.jpg?nocache=<%=System.currentTimeMillis()%>" onerror="this.src='../images/alert_general.gif'" height="114">
			<br><input type="file" name="foodPhotoImage" size="50" class="multi" maxlength="1">
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="submitAction('update',1);" class="btn-click"><bean:message key="button.update" /></button>
			<button onclick="window.close();" class="btn-click"><bean:message key="button.close" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="menuCode" value="<%=menuCode %>">
<input type="hidden" name="itmcode" value="<%=itmcode %>">
<input type="hidden" name="compcode" value="<%=compcode %>">
<input type="hidden" name="command">
<input type="hidden" name="step">

</form>

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
function updateMinMax(e, compcode){
	if(e.value == 0){
		$("#compMin"+compcode).val('0');
		$("#compMax"+compcode).val('9');
	}else{
		$("#compMin"+compcode).val('1');
		$("#compMax"+compcode).val('1');
	}
}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>