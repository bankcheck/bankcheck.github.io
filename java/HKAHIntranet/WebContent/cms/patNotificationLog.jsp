<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
public static ArrayList getList(String patno, String date_from, String date_to, String status) {
	StringBuffer sqlStr = new StringBuffer();
/*
	sqlStr.append("SELECT m.hospnum, m.patient, M.LOCATION, ");
	sqlStr.append(" to_char(r.rpt_date, 'dd/mm/yyyy hh24:mi:ss') rpt_date, ");
	sqlStr.append(" decode(msg_lang, 'ENG', 'SMS-ENGLISH', 'UTF8', 'SMS-CHINESE', 'SMS') msgtype, ");
	sqlStr.append(" nvl2(s.rev_mobile, s.rev_operator || ': (' || s.rev_area_code || ') ' || s.rev_mobile, NVL2(P.PATPAGER, '(' || NVL(PE.PATPGRCOUCODE, P.COUCODE) || ') ' || P.PATPAGER, 'NO PHONE NUMBER') ), ");
	sqlStr.append(" decode(r.pat_notify_status, 'R', 'Ready', s.res_msg ), ");
	sqlStr.append(" to_char(s.send_time, 'dd/mm/yyyy hh24:mi:ss') send_time, m.lab_num ");
	sqlStr.append(" FROM labo_masthead@lis m ");
	sqlStr.append(" JOIN labo_detail@lis d on m.lab_num = d.lab_num and d.test_num in ('SARS', 'WUCPC', 'XSARS' ,'HC', 'XHC', 'XSAR') and d.test_type <> '0' ");
	sqlStr.append(" JOIN LABO_REPORT_LOG@LIS r on m.lab_num = r.lab_num and r.test_cat = 'M' ");
	sqlStr.append(" JOIN patient@iweb p on m.hospnum = p.patno ");
	sqlStr.append(" LEFT JOIN PATIENT_EXTRA@IWEB PE ON P.PATNO = PE.PATNO ");
	sqlStr.append(" LEFT JOIN sms_log s on m.lab_num = s.key_id and s.smcid in ('COVID', 'H1N1') ");
	
	sqlStr.append(" WHERE M.TYPE = 'O' ");
	
	if (patno != null && patno.trim().length() > 0) {
		sqlStr.append(" AND M.HOSPNUM = '" + patno + "' ");
	}
	
	if (date_from != null && date_from.length() == 10) {
		sqlStr.append(" AND R.RPT_DATE >= TO_DATE('");
		sqlStr.append(date_from);
		sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
	}
	
	if (date_to != null && date_to.length() == 10) {
		sqlStr.append(" AND R.RPT_DATE <= TO_DATE('");
		sqlStr.append(date_to);
		sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
	}
	
	if ("S".equals(status)) {
		sqlStr.append(" AND s.success = 1 ");
	} else if ("F".equals(status)) {
		sqlStr.append(" AND (s.success is null or s.success <> 1) AND r.pat_notify_status <> 'R' ");
	}
	
	sqlStr.append(" UNION ");
*/	
	sqlStr.append("SELECT m.hospnum, m.patient, M.LOCATION, ");
	sqlStr.append(" to_char(r.rpt_date, 'dd/mm/yyyy hh24:mi:ss') rpt_date, ");
	sqlStr.append(" 'EMAIL' msgtype, ");
	sqlStr.append(" NVL(p.patemail, 'NO EMAIL ADDRESS'), ");
	sqlStr.append(" decode(r.pat_email_log_id, null, 'Ready', 1, 'SUCCESS', 'Failed ' || e.return_message), ");
	sqlStr.append(" to_char(e.sent_date, 'dd/mm/yyyy hh24:mi:ss') send_time, m.lab_num ");
	sqlStr.append(" FROM labo_masthead@lis m ");
	sqlStr.append(" JOIN labo_detail@lis d on m.lab_num = d.lab_num and d.test_num in ('SARS', 'WUCPC', 'XSARS' ,'HC', 'XHC', 'XSAR') and d.test_type <> '0'  ");
	sqlStr.append(" JOIN LABO_REPORT_LOG@LIS r on m.lab_num = r.lab_num and r.test_cat = 'M' ");
	sqlStr.append(" JOIN patient@iweb p on m.hospnum = p.patno ");
	sqlStr.append(" LEFT JOIN dms_email_log@cis e on r.pat_email_log_id = e.log_id ");
	
	sqlStr.append(" WHERE M.TYPE = 'O' ");
	
	if (patno != null && patno.trim().length() > 0) {
		sqlStr.append(" AND M.HOSPNUM = '" + patno + "' ");
	}
	
	if (date_from != null && date_from.length() == 10) {
		sqlStr.append(" AND R.RPT_DATE >= TO_DATE('");
		sqlStr.append(date_from);
		sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
	}
	
	if (date_to != null && date_to.length() == 10) {
		sqlStr.append(" AND R.RPT_DATE <= TO_DATE('");
		sqlStr.append(date_to);
		sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
	}
	
	if ("S".equals(status)) {
		sqlStr.append(" AND e.success = 1 ");
	} else if ("F".equals(status)) {
		sqlStr.append(" AND (e.success is null or e.success <> 1) AND r.pat_email_log_id IS NOT NULL ");
	}
	
	sqlStr.append(" ORDER BY RPT_DATE desc, lab_num, msgtype ");
	
	//System.out.println("[patNotificationLog DEBUG] sql:" + sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");

String message = request.getParameter("message");
if (message == null) {
	message = "";	
}
String errorMessage = "";

Calendar calendar = Calendar.getInstance();
String currentDate = DateTimeUtil.formatDate(calendar.getTime());

String patno = request.getParameter("patno");
String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String status = request.getParameter("status");

if ("report".equals(command))
	request.setAttribute("notificationList", getList(patno, date_from, date_to, status));
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
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.notification.history" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post" action="patNotificationLog.jsp" >
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="25%">PATNO:</td>
		<td class="infoData" width="75%">
			<input type="textfield" name="patno" id="patno" maxlength="10" size="10" value="<%=patno==null?"":patno %>" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="25%">DATE RANGE:</td>
		<td class="infoData" width="75%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" value="<%=date_from==null?currentDate:date_from %>" /> (DD/MM/YYYY) - <input type="textfield" name="date_to" id="date_to" class="datepickerfield" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" value="<%=date_to==null?currentDate:date_to %>" /> (DD/MM/YYYY)		
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="25%">STATUS:</td>
		<td class="infoData" width="75%">
			<input type="radio" name="status" id="success" value="S" /> Success <input type="radio" name="status" id="fail" value="F" /> Fail
		</td>
	</tr>	
	<tr class="smallText">
		<td colspan="2" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
		</td>
	</tr>
</table>
<input type="hidden" id="command" name="command" value="report" />
</form>
<display:table id="row" name="requestScope.notificationList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column property="fields0" title="PATNO" style="width:5%" />
	<display:column property="fields1" title="NAME" style="width:25%" />
	<display:column property="fields2" title="LOCATION"  style="width:14%" />
	<display:column property="fields3" title="REPORT TIME"  style="width:9%" />
	<display:column property="fields4" title="MESSAGE TYPE"  style="width:9%" />
	<display:column property="fields5" title="DESTINATION" style="width:17%" />
	<display:column property="fields6" title="STATUS" style="width:6%" />
	<display:column property="fields7" title="SEND TIME" style="width:9%" />
	<display:column property="fields8" title="LABNUM" style="width:6%" />
</display:table>

</DIV>

</DIV></DIV>
<script language="javascript">
<!--
//IE compatibility
if (typeof console=="undefined") var console={ log: function(x) {document.getElementById('msg').innerHTML=x} };
 
if(typeof String.prototype.trim !== 'function') {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, ''); 
  }
}

$(document).ready(function(){

});
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>