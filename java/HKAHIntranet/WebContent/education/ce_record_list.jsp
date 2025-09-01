<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.hibernate.*"%>
<%@ page import="org.apache.poi.ss.usermodel.*"%>
<%@ page import="org.apache.poi.ss.util.*"%>
<%!
	private final static SimpleDateFormat hireDateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

	//sheet column
	private static HashMap<String, Integer> contentCell = new HashMap<String, Integer>();
	static {
		contentCell.put("hireDate", new Integer(3));
		contentCell.put("empNo", new Integer(0));
		contentCell.put("hours_prev1", new Integer(10));
		contentCell.put("hours_prev2", new Integer(12));
		contentCell.put("hours_Jan", new Integer(20));
		contentCell.put("hours_Feb", new Integer(22));
		contentCell.put("hours_Mar", new Integer(24));
		contentCell.put("hours_Apr", new Integer(26));
		contentCell.put("hours_May", new Integer(28));
		contentCell.put("hours_Jun", new Integer(30));
		contentCell.put("hours_Jul", new Integer(32));
		contentCell.put("hours_Aug", new Integer(34));
		contentCell.put("hours_Sep", new Integer(36));
		contentCell.put("hours_Oct", new Integer(38));
		contentCell.put("hours_Nov", new Integer(40));
		contentCell.put("hours_Dec", new Integer(42));
		contentCell.put("amount_prev1", new Integer(11));
		contentCell.put("amount_prev2", new Integer(13));
		contentCell.put("amount_Jan", new Integer(21));
		contentCell.put("amount_Feb", new Integer(23));
		contentCell.put("amount_Mar", new Integer(25));
		contentCell.put("amount_Apr", new Integer(27));
		contentCell.put("amount_May", new Integer(29));
		contentCell.put("amount_Jun", new Integer(31));
		contentCell.put("amount_Jul", new Integer(33));
		contentCell.put("amount_Aug", new Integer(35));
		contentCell.put("amount_Sep", new Integer(37));
		contentCell.put("amount_Oct", new Integer(39));
		contentCell.put("amount_Nov", new Integer(41));
		contentCell.put("amount_Dec", new Integer(43));
		contentCell.put("remark", new Integer(44));
		
		contentCell.put("hours_current", new Integer(18));
		contentCell.put("amount_current", new Integer(19));
	}

	private String getDateValue(Row row1, String field, int current_yy) {
		try {
			// convert to date
			Object value = SpreadSheetUtil.getCellContent(row1.getCell(contentCell.get(field)));
			Date date = null;
			if(value != null){
				date = hireDateFormat.parse((String) value);
			}
			
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			// set current year
			calendar.set(Calendar.YEAR, current_yy);
			return DateTimeUtil.formatDate(calendar.getTime());
		} catch (Exception e) {	
			return null;
		}
	}

	private String getStringValue(Row row1, int fieldIndex, boolean isNumeric) {
		try {
			if (isNumeric) {
				return String.valueOf(SpreadSheetUtil.getCellContentNumeric(row1.getCell(fieldIndex)));
			} else {
				return String.valueOf(SpreadSheetUtil.getCellContent(row1.getCell(fieldIndex), Cell.CELL_TYPE_STRING));
			}
		} catch (Exception e) {
			return null;
		}
	}

	private String getStringValue(Row row1, String field, boolean isNumeric) {
		try {
			return getStringValue(row1, contentCell.get(field), isNumeric);
		} catch (Exception e) {
			return null;
		}
	}

	private double getDoubleValue(Row row1, String field) {
		try {
			return Double.parseDouble(getStringValue(row1, field, true));
		} catch (Exception e) {
			return 0;
		}
	}
%>
<%
UserBean userBean = new UserBean(request);

String listLabel = "function.ce.list";
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

// constant
String documentID = "327";
String sheetName = "CEHours (2020-2021)";

int contentStartRow = 2;

ArrayList record_real = new ArrayList();
ArrayList record = null;
String location = null;
String filePath = null;
int current_yy = DateTimeUtil.getCurrentYear();
boolean dataReady = true;

// get document url
ReportableListObject row = DocumentDB.getReportableListObject(documentID);
if (row != null) {
	location = row.getValue(2);
	if (ConstantsVariable.YES_VALUE.equals(row.getValue(3))) {
		filePath = ConstantsServerSide.DOCUMENT_FOLDER + File.separator + location;
	} else {
		filePath = location;
	}
	filePath += "/Cehours2020-2021.xls";
}

if (filePath == null || filePath.isEmpty()) {
	errorMessage = "No document found.";
} else {
	File file = new File(filePath);
	Sheet sheet = SpreadSheetUtil.getSheet(filePath, sheetName);
	if (sheet != null) {
		CellReference cellRef = null;

		Row row1 = null;
		Cell cell = null;
		int index = 0;
		String empNo = null;
		String hireDate = null;
		double hours = 0;
		double amount = 0;
		String remark = null;

		HashMap<String, String[]> ceRecord = new HashMap<String, String[]>();
		Integer empNoCol = contentCell.get("empNo");
		NumberFormat form = new DecimalFormat("#.##");
		for (int i = contentStartRow; i < sheet.getLastRowNum(); i++) {
			row1 = sheet.getRow(i);
			if (row1 != null) {
				cell = row1.getCell(empNoCol);

				// import each item
				if (cell != null) {
					empNo = getStringValue(row1, "empNo", false);
					hireDate = getStringValue(row1, "hireDate", false);
					remark = getStringValue(row1, "remark", false);
					if (remark == null) {
						remark = ConstantsVariable.MINUS_VALUE;
					}
					// fix when return double
					if ((index = empNo.indexOf(".0")) > 0) {
						empNo = empNo.substring(0, index);
					}
					hours = 0;
					amount = 0;

					try {
						hours = getDoubleValue(row1, "hours_current");
					} catch (Exception e) { }

					try {
						amount = getDoubleValue(row1, "amount_current");
					} catch (Exception e) { }

					ceRecord.put(empNo, new String[] { String.valueOf(hours), form.format(amount), remark });
				}
			}
		}

		int noOfUserInfoColumn = 3;
		record = StaffDB.getCEList(userBean);
		ReportableListObject row_real = null;
		String staffID = null;
		String[] ceResult = null;

		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				// copy to new reportable list object
				row_real = new ReportableListObject(noOfUserInfoColumn + 3);
				for (int j = 0; j < noOfUserInfoColumn; j++) {
					row_real.setValue(j, row.getValue(j + 1));
				}

				// set hour and balance
				staffID = row.getValue(2);
				if (ceRecord.containsKey(staffID)) {
					ceResult = ceRecord.get(staffID);
					row_real.setValue(noOfUserInfoColumn, ceResult[0]);
					row_real.setValue(noOfUserInfoColumn + 1, ceResult[1]);
					row_real.setValue(noOfUserInfoColumn + 2, ceResult[2]);
					record_real.add(row_real);
				}
			}
		}
		request.setAttribute("record_list", record_real);
	} else {
		errorMessage = "Cannot read spreadsheet.";
	}
}
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" width="100%">
	<tr class="bigText">
		<td class="infoLabel" width="35%"><bean:message key="prompt.title" /></td>
		<td class="infoData" width="65%">Continuing Education Allowance</td>
	</tr>
</table>
<bean:define id="functionLabel"><bean:message key="<%=listLabel %>" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<% if (dataReady) { %>
<display:table id="row_ce" name="requestScope.record_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><c:out value="${row_ce_rowNum}"/>)</display:column>
	<display:column property="fields0" titleKey="prompt.department" />
	<display:column property="fields1" titleKey="prompt.staffID" />
	<display:column property="fields2" titleKey="prompt.name" />
	<display:column property="fields3" titleKey="prompt.hours" />
	<display:column property="fields4" titleKey="prompt.amount" />
	<display:column property="fields5" titleKey="prompt.remarks" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>" />
</display:table>
<% } else { %>
<%="Data of CE budget " + DateTimeUtil.getCurrentYear() + " is processing...please try again later.  Thank you for your understanding." %>
<% } %>
<br/><p/><br/>