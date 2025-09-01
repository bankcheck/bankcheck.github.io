<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getQuotaList() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  BKAID, BKADESC ");
		sqlStr.append("FROM    BOOKINGALERT@IWEB ");
		sqlStr.append("WHERE ( BKAQUOTAD = -1 ) ");
		sqlStr.append("AND     BKASTS = -1 ");
		sqlStr.append("AND   ( GET_CURRENT_STECODE@IWEB = 'TWAH' OR BKAID NOT IN ('35')) ");
		sqlStr.append("ORDER BY BKAORD ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getQuota(String hptype, String hpkey, String hpstatus) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT H.HPTYPE, H.HPKEY, A.BKADESC, H.HPSTATUS, H.HPRMK ");
		sqlStr.append("FROM   HPSTATUS@IWEB H ");
		sqlStr.append("LEFT JOIN BOOKINGALERT@IWEB A ON H.HPKEY = A.BKAID ");
		sqlStr.append("WHERE  H.HPTYPE = ? ");
		sqlStr.append("AND    H.HPKEY = ? ");
		sqlStr.append("AND    H.HPSTATUS = ? ");
		sqlStr.append("AND    H.HPACTIVE = -1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { hptype, hpkey, hpstatus });
	}

	private boolean isExist(String hptype, String hpkey, String hpstatus) {
		return UtilDBWeb.isExist(
			"SELECT 1 FROM HPSTATUS@IWEB WHERE HPTYPE = ? AND HPKEY = ? AND HPSTATUS = ?",
			new String[]{ hptype, hpkey, hpstatus });
	}

	private boolean isQuotaDaily(String hpkey) {
		return UtilDBWeb.isExist(
			"SELECT 1 FROM BOOKINGALERT@IWEB WHERE BKAID = ? AND BKAQUOTAD = -1",
			new String[]{ hpkey });
	}

	private boolean isQuotaMonthly(String hpkey) {
		return UtilDBWeb.isExist(
			"SELECT 1 FROM BOOKINGALERT@IWEB WHERE BKAID = ? AND BKAQUOTAM = -1",
			new String[]{ hpkey });
	}

	private boolean addQuota(UserBean userBean, String hptype, String hpkey, String hpstatus, String hprmk, String hpsdate) {
		if (isExist(hptype, hpkey, hpstatus)) {
			return UtilDBWeb.updateQueue(
				"UPDATE HPSTATUS@IWEB SET HPRMK = ?, HPACTIVE = -1, HPMUSR = ?, HPMDATE = SYSDATE, HPSDATE = TO_DATE(?, 'DD/MM/YYYY'), HPEDATE = TO_DATE(?, 'DD/MM/YYYY') WHERE HPTYPE = ? AND HPKEY = ? AND HPSTATUS = ?",
				new String[] { hprmk, userBean.getStaffID(), hpsdate, hpsdate, hptype, hpkey, hpstatus } );
		} else {
			return UtilDBWeb.updateQueue(
				"INSERT INTO HPSTATUS@IWEB (HPTYPE, HPKEY, HPSTATUS, HPRMK, HPCUSR, HPSDATE, HPEDATE) VALUES (?, ?, ?, ?, ?, TO_DATE(?, 'DD/MM/YYYY'), TO_DATE(?, 'DD/MM/YYYY'))",
				new String[] { hptype, hpkey, hpstatus, hprmk, userBean.getStaffID(), hpsdate, hpsdate } );
		}
	}

	private boolean updateQuota(UserBean userBean, String hptype, String hpkey, String hpstatus, String hprmk, String hpsdate) {
		if (isExist(hptype, hpkey, hpstatus)) {
			return UtilDBWeb.updateQueue(
				"UPDATE HPSTATUS@IWEB SET HPRMK = ?, HPMUSR = ?, HPMDATE = SYSDATE, HPSDATE = TO_DATE(?, 'DD/MM/YYYY'), HPEDATE = TO_DATE(?, 'DD/MM/YYYY') WHERE HPTYPE = ? AND HPKEY = ? AND HPSTATUS = ?",
				new String[] { hprmk, userBean.getStaffID(), hpsdate, hpsdate, hptype, hpkey, hpstatus } );
		} else {
			return false;
		}
	}

	private boolean deleteQuota(UserBean userBean, String hptype, String hpkey, String hpstatus) {
		if (isExist(hptype, hpkey, hpstatus)) {
			return UtilDBWeb.updateQueue(
				"UPDATE HPSTATUS@IWEB SET HPACTIVE = 0, HPMUSR = ?, HPMDATE = SYSDATE WHERE HPTYPE = ? AND HPKEY = ? AND HPSTATUS = ?",
				new String[] { userBean.getStaffID(), hptype, hpkey, hpstatus } );
		} else {
			return false;
		}
	}
%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String step = request.getParameter("step");
String hptype = request.getParameter("hptype");
String hpkey = request.getParameter("hpkey");
String hpDesc = null;
String hpstatus_dd = ParserUtil.getParameter(request, "hpstatus_dd");
String hpstatus_mm = ParserUtil.getParameter(request, "hpstatus_mm");
String hpstatus_yy = ParserUtil.getParameter(request, "hpstatus_yy");
String hpstatus = request.getParameter("hpstatus");
String []hpstatus_Range = request.getParameterValues("hpstatus");
String hprmk = request.getParameter("hprmk");
String hpsdate = null;
String quotaType = request.getParameter("quotaType");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

ReportableListObject row = null;
ArrayList record = null;
try {
	if ("1".equals(step)) {
		if (createAction) {
			if ("multiple".equals(quotaType)) {
				if (hpstatus_Range != null && hpstatus_Range.length > 0) {
					int hpstatusCount = 0;
					hptype = "QUOTADAILY";
					// check whether one of the quota is created
					for (int i = 0; hpstatusCount == 0 && i < hpstatus_Range.length; i++) {
						hpstatus = hpstatus_Range[i];
						if (isExist(hptype, hpkey, hpstatus)) {
							hpstatusCount = 1;
						}
					}
					if (hpstatusCount > 0) {
						message = "Quota add fail since some of the quota are created.";
					} else {
						hpstatusCount = 0;
						for (int i = 0; i < hpstatus_Range.length; i++) {
							hpstatus = hpstatus_Range[i];
							if (addQuota(userBean, hptype, hpkey, hpstatus, hprmk, hpstatus)) {
								hpstatusCount++;
							}
						}
						if (hpstatus_Range.length == hpstatusCount) {
							message = "Quota added.";
						} else if (hpstatus_Range.length > hpstatusCount && hpstatusCount > 0) {
							message = "some of Quota add fail.";
						} else {
							message = "Quota add fail.";
						}
						createAction = false;
						step = "0";
					}
				} else {
					message = "Quota add fail.";
				}
			} else {
				if (isQuotaDaily(hpkey)) {
					hptype = "QUOTADAILY";
					hpstatus = hpstatus_dd + "/" + hpstatus_mm + "/" + hpstatus_yy;
					hpsdate = hpstatus;
				} else if (isQuotaMonthly(hpkey)) {
					hptype = "QUOTAMONTH";
					hpstatus = hpstatus_mm + "/" + hpstatus_yy;
					hpsdate = "01/" + hpstatus;
				} else {
					hptype = "QUOTAYEAR";
					hpstatus = hpstatus_yy;
					hpsdate = "01/01/" + hpstatus;
				}

				if (addQuota(userBean, hptype, hpkey, hpstatus, hprmk, hpsdate)) {
					message = "Quota added.";
					createAction = false;
					step = "0";
				} else {
					errorMessage = "Quota add fail.";
				}
			}
		} else if (updateAction) {
			if ("QUOTADAILY".equals(hptype)) {
				hpsdate = hpstatus;
			} else if ("QUOTAMONTH".equals(hptype)) {
				hpsdate = "01/" + hpstatus;
			} else {
				hpsdate = "01/01/" + hpstatus;
			}

			if (updateQuota(userBean, hptype, hpkey, hpstatus, hprmk, hpsdate)) {
				message = "Quota updated.";
				updateAction = false;
				step = "0";
			} else {
				errorMessage = "Quota update fail.";
			}
		} else if (deleteAction) {
			if (deleteQuota(userBean, hptype, hpkey, hpstatus)) {
				message = "Quota removed.";
				deleteAction = false;
				step = "0";
			} else {
				errorMessage = "Quota remove fail.";
			}
		}
	} else if (createAction) {
		hptype = "";
		hpkey = "";
		hpstatus = "";
		hprmk = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (hpkey != null && hpkey.length() > 0) {
			record = getQuota(hptype, hpkey, hpstatus);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				hptype = row.getValue(0);
				hpkey = row.getValue(1);
				hpDesc = row.getValue(2);
				hpstatus = row.getValue(3);
				hprmk = row.getValue(4);
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.hats.quotaCheck." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1" action="quota_check.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=(ConstantsServerSide.SITE_CODE_HKAH.equals(userBean.getSiteCode())) ? "Initial Assessed":"Nature of Visits" %></td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<select name="hpkey"><%
			record = getQuotaList();
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"><%=row.getValue(1) %></option><%
				}
			}
%></select>
<%	} else { %>
			<%=hpDesc==null?"":hpDesc %><input type="hidden" name="hpkey" value="<%=hpkey==null?"":hpkey %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Date</td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<span id="dateRange_indicator">
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="hpstatus" />
	<jsp:param name="isShowNextYear" value="Y" />
	<jsp:param name="isFromCurrYear" value="Y" />
</jsp:include>(DD/MON/YYYY)
			&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="showDateRange" value="N" onclick="return showDateRangePanel();">Show Date Range
			</span>
<%	} else { %>
			<%=hpstatus==null?"":hpstatus %><input type="hidden" name="hpstatus" value="<%=hpstatus==null?"":hpstatus %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Quota</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="hprmk"><%
			for (int i = 0; i <= 300; i++) {
%><option value="<%=i %>"<%=String.valueOf(i).equals(hprmk)?" selected":"" %>><%=i %></option><%
			}
%></select>
<%	} else { %>
			<%=hprmk==null?"":hprmk %>
<%	} %>
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<%if (userBean.isAccessible("function.hats.quotaCheck.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.hats.quotaCheck.update" /></button><%} %>
			<%if (userBean.isAccessible("function.hats.quotaCheck.delete")) { %><button class="btn-delete"><bean:message key="function.hats.quotaCheck.delete" /></button><%} %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="hptype" value="<%=hptype==null?"":hptype %>">
<input type="hidden" name="quotaType" value="single" />
</form>
<script language="javascript">
<!--
	function submitAction(cmd, stp) {
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function showDateRangePanel() {
		var hpstatus = document.form1.hpstatus_dd.value + '/' + document.form1.hpstatus_mm.value + '/' + document.form1.hpstatus_yy.value;
		$.ajax({
			type: "POST",
			url: "quota_check_date_range.jsp",
			data: "quotaType=multiple&hpstatus1=" + hpstatus + "&hpstatus2=" + hpstatus,
			success: function(values) {
			if (values != '') {
				document.getElementById("dateRange_indicator").innerHTML = values;
				document.form1.quotaType.value = 'multiple';
			}//if
			}//success
		});//$.ajax

		return false;
	}

	function updateDateRangePanel() {
		var hpstatus1 = document.form1.hpstatus1_dd.value + '/' + document.form1.hpstatus1_mm.value + '/' + document.form1.hpstatus1_yy.value;
		var hpstatus2 = document.form1.hpstatus2_dd.value + '/' + document.form1.hpstatus2_mm.value + '/' + document.form1.hpstatus2_yy.value;
		var rangeType_sun = document.form1.rangeType_sun.checked?'Y':'N';
		var rangeType_mon = document.form1.rangeType_mon.checked?'Y':'N';
		var rangeType_tue = document.form1.rangeType_tue.checked?'Y':'N';
		var rangeType_wed = document.form1.rangeType_wed.checked?'Y':'N';
		var rangeType_thu = document.form1.rangeType_thu.checked?'Y':'N';
		var rangeType_fri = document.form1.rangeType_fri.checked?'Y':'N';
		var rangeType_sat = document.form1.rangeType_sat.checked?'Y':'N';
		var rangeType_holiday = document.form1.rangeType_holiday.checked?'Y':'N';

		$.ajax({
			type: "POST",
			url: "quota_check_date_range.jsp",
			data: "quotaType=multiple&hpstatus1=" + hpstatus1 + "&hpstatus2=" + hpstatus2 + "&rangeType_sun=" + rangeType_sun + "&rangeType_mon=" + rangeType_mon + "&rangeType_tue=" + rangeType_tue + "&rangeType_wed=" + rangeType_wed + "&rangeType_thu=" + rangeType_thu + "&rangeType_fri=" + rangeType_fri + "&rangeType_sat=" + rangeType_sat + "&rangeType_holiday=" + rangeType_holiday,
			success: function(values) {
			if (values != '') {
				document.getElementById("dateRange_indicator").innerHTML = values;
				document.form1.quotaType.value = 'multiple';
			}//if
			}//success
		});//$.ajax

		return false;
	}

	function hideDateRangePanel() {
		var hpstatus = document.form1.hpstatus1_dd.value + '/' + document.form1.hpstatus1_mm.value + '/' + document.form1.hpstatus1_yy.value;
		$.ajax({
			type: "POST",
			url: "quota_check_date_range.jsp",
			data: "quotaType=single&hpstatus1=" + hpstatus + "&hpstatus2=" + hpstatus,
			success: function(values) {
			if (values != '') {
				document.getElementById("dateRange_indicator").innerHTML = values;
				document.form1.quotaType.value = 'single';
			}//if
			}//success
		});//$.ajax

		return false;
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>