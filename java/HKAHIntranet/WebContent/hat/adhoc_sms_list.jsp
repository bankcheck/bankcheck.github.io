<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%!
public static ArrayList getList() {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append(" SELECT DOCCODE,REGEXP_REPLACE( DOCMTEL, '[[:space:]]', '' ), DOCNAME, KEYID,M.RES_MSG FROM( ");
	sqlStr.append(" SELECT DOCCODE,DOCMTEL,DOCFNAME||' '||DOCGNAME as DOCNAME,'IC'||DOCCODE||TO_CHAR(TO_DATE(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'),'YYYYMMDD') AS KEYID ");
	sqlStr.append(" FROM DOCTOR@IWEB WHERE DOCCODE IN  ");
	sqlStr.append(getDoctorCode());
	
/* 	sqlStr.append(" UNION (SELECT DOCCODE,REGEXP_SUBSTR(DOCMTEL, '[^/]+', 1, LEVEL),DOCNAME,'IC'||DOCCODE||TO_CHAR(TO_DATE(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'),'YYYYMMDD') AS KEYID ");
	sqlStr.append(" FROM (SELECT DOCCODE,DOCFNAME||' '||DOCGNAME AS DOCNAME, DOCMTEL FROM DOCTOR@IWEB WHERE DOCCODE IN ('1395')) ");
	sqlStr.append(" CONNECT BY REGEXP_SUBSTR(DOCMTEL, '[^/]+', 1, LEVEL) IS NOT NULL) ");
	
	sqlStr.append(" UNION (SELECT DOCCODE,REGEXP_SUBSTR(DOCMTEL, '[^/]+', 1, LEVEL),DOCNAME,'IC'||DOCCODE||TO_CHAR(TO_DATE(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'),'YYYYMMDD') AS KEYID ");
	sqlStr.append(" FROM (SELECT DOCCODE,DOCFNAME||' '||DOCGNAME AS DOCNAME, DOCMTEL FROM DOCTOR@IWEB WHERE DOCCODE IN ('1768')) ");
	sqlStr.append(" CONNECT BY REGEXP_SUBSTR(DOCMTEL, '[^/]+', 1, LEVEL) IS NOT NULL) "); */

	sqlStr.append(" ) L, SMS_LOG M WHERE L.KEYID = M.KEY_ID(+) ");
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static String getDoctorCode(){
	StringBuffer list = new StringBuffer();
	//20200401//
	list.append(" ('2184', '1307', '2078', '1585', '2235', '2210', '1621', '1698', '1905', '2276', '1855', '1456', '1644', '1046', '290', '1809', '1027', '1042', '722', '1823', '1604', '248', '791', '408', '1409', '1600', '1974', '1770', '2383', '1768', '2098', '1054', '559', '1965', '1813','1395', '2443', '1811', '1458', '1523', '1746', '1556', '2081', '521', '1265', '1032', '763', '2082', '848', '2117', '1717', '2130', '1767', '1673', '809', '2343', '2441', '581', '2054', '1171', '1020') ");
	//--20200327//
	//list.append(" ( '886', '1969', '1098', '1200', '290', '455', '1731', '1544', '1809', '1027', '1699', '2357', '2288', '1122', '1042', '722', '1823', '2387', '1604', '248', '791', '408', '1409', '2426', '1414', '1316', '1600', '1420', '2211', '2435', '1232', '2277', '1064', '1974', '1986', '880', '2005', '878', '1822', '2434', '1770', '1007', '2383', '524', '1267', '2098', '1475', '2124', '596', '1054', '2173', '1383', '559', '1192', '1355', '1965', '1813', '2432','2306', '1586', '2443', '1811', '1458', '2100', '1523', '1580', '1746', '1928', '2181', '1556', '2081', '1703', '521', '1707', '1774', '1265', '1032', '763', '2082', '848', '1482', '2117', '2183', '1717', '832', '2130', '1011', '2239', '1767', '1113', '1673', '2315', '1859', '809', '2343', '2441', '581', '2319', '2054', '1171', '1020', '2074', '2257', '2290', '2184', '1307', '1891', '80', '514', '2331', '119', '1084', '1111', '134', '1131', '1366', '2078', '1246', '1585', '2235', '2210', '1449', '2043', '1425', '1621','1698', '1995', '1905', '2276', '1855', '1456', '1644', '1081', '421', '1046', '2216', '480') ");
	//--20200325//
	//1-100   Dr 1564 with 2 no
	/* list.append(" ( '1564','24', '34', '80', '105', '117', '119', '134', '184', '279', '421', '480', '507', '514', '539', '595', '634', '671', '695', '701', '706', '727', '750', '751', '1038', '1046', '1069', '1075', '1078', '1081', '1084', '1111', '1125', '1130', '1131', '1139', '1152', '1154', '1158', '1178', '1184', '1203', '1207', '1218', '1226', '1243', '1246', '1257', '1262', '1276', '1279', '1287', '1305', '1307', '1311', '1337', '1359', '1366', '1367', '1368', '1379', '1392', '1417', '1425', '1427', '1435', '1438', '1449', '1455', '1456', '1460', '1478', '1489', '1514', '1518', '1543', '1554', '1557', '1565', '1568', '1569', '1571', '1574', '1585', '1587', '1598', '1603', '1605', '1606', '1607', '1621', '1628', '1630', '1644', '1657', '1664', '1681', '1696', '1698',  ");
	//101-200  Dr 2227 with 2 no
	list.append(" '2227','1715', '1751', '1771', '1806', '1845', '1850', '1855', '1864', '1866', '1876', '1891', '1898', '1901', '1902', '1905', '1916', '1922', '1927', '1931', '1949', '1954', '1960', '1990', '1995', '2008', '2013', '2030', '2039', '2043', '2078', '2083', '2090', '2107', '2151', '2155', '2161', '2166', '2171', '2184', '2187', '2189', '2210', '2216', '2222', '2224', '2235', '2238', '2240', '2257', '2261', '2275', '2276', '2290', '2298', '2303', '2314', '2318', '2325', '2329', '2331', '2332', '2333', '2344', '2347', '2351', '2359', '2369', '2371', '2386', '2393', '2402', '2414', '2431', '2436', '69', '108', '197', '199', '290', '455', '765', '793', '876', '886', '1030', '1098', '1200', '1477', '1507', '1636', '1679', '1821', '1969', '2118', '2149','2438', '725', '1714', '1731', ");
	//201-300 Dr 1889 1999 with 2 no
	list.append(" '1889','1999','983', '1041', '1544', '1799', '1809', '1979', '2064', '2088', '2114', '2176', '2186', '2217', '2254', '2425', '1566', '1027', '1112', '1699', '1704', '2337', '2355', '2357', '1473', '1732', '2288', '1042', '1122', '722', '885', '1194', '1230', '1298', '1405', '1629', '1639', '1655', '1823', '1865', '1871', '1972', '2204', '2387', '2427', '2440', '164', '248', '395', '408', '590', '755', '791', '967', '1017', '1119', '1528', '1604', '1945', '1978', '2174', '2269', '349', '512', '740', '880', '1004', '1036', '1064', '1232', '1316', '1329', '1409', '1414', '1420', '1494', '1600', '1718', '1833', '1838', '1858', '1974', '1986', '2005', '2069', '2211', '2277', '2426', '2435', '878', '1822', '2079', '1770', '2001', '2434', '363', '443', '1991', '366', '1007' , ");
	//301-400  Dr 2017 1768 1499 1395 with 2 no
	list.append(" '1700', '749', '845', '1187', '1924', '2156', '2383', '2430', '524', '907', '1077', '1086', '1259', '2160', '196', '889', '1267', '1327', '1547', '1768', '1879', '2248', '2350', '494', '559', '566', '596', '683', '696', '1054', '1127', '1168', '1192', '1256', '1355', '1383', '1475', '1499', '1570', '1599', '1907', '1964', '1965', '2098', '2124', '2173', '2196', '2280', '2429', '828', '1105', '1159', '1395', '1586', '1811', '1813', '2017', '2027', '2263', '2306', '2428', '2432', '2443', '1458', '33', '472', '940', '1274', '1451', '1485', '1523', '1556', '1580', '1625', '1746', '1870', '1928', '2100', '2140', '2181', '2253', '2327', '2442', '734', '1092', '1188', '1423', '1703', '1736', '2050', '2081', '2316', '762', '1447', '521', '1339', '1707', '1726', '2057', '234', ");
	//401-485 Dr 550 890 1444 1716 668 with 2 no
	list.append(" '420', '668', '691', '763', '848', '890', '1025', '1032', '1118', '1162', '1265', '1444', '1482', '1497', '1534', '1537', '1561', '1666', '1720', '1774', '1778', '2020', '2082', '2287', '2437', '1810', '2117', '240', '832', '1002', '1011', '1717', '2130', '2183', '2239', '2374', '1113', '1767', '1938', '2433', '1673', '1675', '1676', '1837', '1859', '2028', '2094', '2141', '2234', '2297', '2302', '2315', '2317', '2323', '2342', '956', '1107', '550', '581', '809', '938', '981', '1260', '1848', '1857', '1896', '2197', '2201', '2319', '2343', '2441', '40', '1716', '2439', '857', '1020', '1121', '1171', '1272', '1389', '1738', '1920', '2054', '2074', '2260' ) ");
	 */
	//--20200319//
	/* //surg
	list.append(" ('1121', '1127', '1171', '1188', '1230', '1235', '1256', '1260', '1316', '1327', '1409', '1420', '1451', '1477', ");
	list.append(" '1494', '1507', '1556', '1599', '1613', '1625', '1636', '1640', '1679', '1702', '1703', '1726', '1738', '1813', '1831', ");
	list.append(" '1835', '1838', '1928', '1964', '197', '1993', '2054', '2057', '2074', '2098', '2100', '2118', '2127', '2140', '2181', '2183', ");
	list.append(" '2196', '2204', '2253', '2260', '2327', '2364', '2374', '2381', '33', '455', '472', '7488', '7849', '793', '7951', '8094', '832', '857', '9344', '981', ");
	
	//en
	list.append(" '2099', '1194', '885' , '981' , '2207', '2204', '1004', '1972', '1838', '1494', '1260', '1034', '1230', '1871', '1492', '349', '1329', ");
	//an
	 list.append(" '184', '1337', '1178', '1603', '7593', '8244', '2275', '1262', '1131', '1543', '2224', '1366', '2238', ");
	list.append("  '634', '7928', '1184', '2240', '1585', '1169', '7422', '1630', '1916', '1554', '1866', '2331', '24', '1954', '2276', '2257',  ");
	list.append(" '1460', '2216', '1628', '1664', '1455', '1392', '1038', '2369', '1130', '2325', '9075', '2151', '1489', '1417',  ");
	list.append(" '1905', '706', '1456', '9396', '2166', '9083', '1438', '1367', '2039', '2107', '2013', '2347', '1990' ) "); */
	//--20200319//
	return list.toString();
}
%>
<%
UserBean userBean = new UserBean(request);

String sendSMS = request.getParameter("sendSms");
String sendType = ParserUtil.getParameter(request, "sendType");



ArrayList record = null;
	record = getList();

request.setAttribute("appointment_list", record);
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp" />
	<body>
		<div id="indexWrapper">
			<div id="mainFrame">
				<div id="contentFrame">
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="OPD Appointment List" />
					</jsp:include>
					
					<table>
						<tr>
							<td>
								<form name="search_form" action="adhoc_sms_list.jsp" method="post">
									<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
										<tr class="smallText">
											<td colspan="4" align="center">
												<button onclick="return submitSearch();">
													<bean:message key="button.search" />
												</button>
											</td>
										</tr>
									</table>
									<input type="hidden" name="sendSms" value="<%=sendSMS == null ? "":sendSMS %>" />
								</form>
							</td>
							<td>
								<button onclick="return promptSendSMS();" 
									class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
									Send  SMS
								</button>
							</td>
						</tr>
					</table>
					
					<input type="hidden" name="sendSMSDate" value="" />
					
					<bean:define id="functionLabel">List</bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
					<display:table id="row" name="requestScope.appointment_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">	
						<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
								<display:column title="Doctor Code" style="width:7%">
									<c:out value="${row.fields0}" /> 
								</display:column>
								<display:column title="Doctor Mobile" style="width:7%">
									<c:out value="${row.fields1}" /> 
								</display:column>
								<display:column title="Doctor Name" style="width:7%">
									<c:out value="${row.fields2}" /> 
								</display:column>
								<display:column title="result" style="width:7%">
									<c:out value="${row.fields4}" /> 
								</display:column>
						<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
					</display:table>
					<script language="javascript">
						function submitSearch() {
							
							
							showOverLay('body');
							showLoadingBox('body', 100, 350);
							document.search_form.submit();
						}
						
						
						function promptSendSMS() {
							$('#confirmSmsBoxContent').html('');
							$('#confirmSmsBoxContent').append('<div class="ui-widget-header">Confirm</div><br/>');
							$('#confirmSmsBoxContent').append('<label>Send  SMS to doctor on the list?</label><br/><br/>');
							
							$('#confirmSmsBox').css('top', 300);
							$('#confirmSmsBox').css('left', $(window).width()/2-$('#confirmSmsBox').width()/2);
							
							showOverLay('body');
							$('#confirmSmsBox').show();
							return false;
						}
						
						function sendSMS() {
							//showLoadingBox('body', 100, 350);
							$('#progressbar').css('top', 350);
							$('#progressbar').css('left', $(window).width()/2-$('#progressbar').width()/2);
							$('#progressbar').show();
							showOverLay('body');
							
							sentSMS = 0;
							successSent = 0;
							failSent = 0;
<%
							for (int i = 0; i < record.size(); i++) {
								ReportableListObject row = (ReportableListObject)record.get(i);
%>
   								$.ajax({
									url: '../sms/sendAdHocSms.jsp',
									//if smcid is null or empty, default 1
									data: {docCode:"<%=row.getValue(0)%>",docMobile:"<%=row.getValue(1)%>"
											,keyID:"<%=row.getValue(3)%>"},
									async: true,
									type: 'POST',
									success: function(data, textStatus, jqXHR) {
										if ($.trim(data)=='true') {
											successSent++;
										}
										else {
											failSent++;
										}
									},
									error: function(jqXHR, textStatus, errorThrown) {
										failSent++;
									},
									complete: function(jqXHR, textStatus) {
										sentSMS++;
										$('.progress-label').html(
												'Sending.......'+sentSMS+'/'+totalSMS+'<br/>'+
												'(Success: '+successSent+' Fail: '+failSent+')');
										sendSMSPost(sentSMS==totalSMS);
									}
								});  
<%
							}
%>
						}
						
						function sendSMSPost(complete) {
							if (complete) {
								$('#progressbar').append(
										'<button id="progressCloseBtn" '+
										'class="ui-button ui-widget ui-state-default'+
										' ui-corner-all ui-button-text-only">Close</button>');
								
								$('#progressCloseBtn').click(function() {
									$('#progressbar').hide();
									showLoadingBox('body', 100, 350);
									
									var url = window.location.href;
									url.replace("sendSms=Y", "sendSms=N"); //ensure send sms only one time
									window.location.replace(url);
								});
								
								$('input[name=sendSms]').val("N");
							}
						}
						
						var sentSMS = 0;
						var successSent = 0;
						var failSent = 0;
						var totalSMS = <%=record.size()%>;
						
						$(document).ready(function() {
							$('#confirmSmsBoxYesBtn').click(function() {
								$('#confirmSmsBox').hide();
								$('input[name=apptDate]').val($('input[name=sendSMSDate]').val());
								$('input[name=sendSms]').val("Y");
								submitSearch();
							});
							
							$('#confirmSmsBoxNoBtn').click(function() {
								$('#confirmSmsBox').hide();
								hideOverLay('body');
							});
							
							if ($('input[name=sendSms]').val() === "Y") {
								sendSMS();
							}
						});
					</script>
				</div>
			</div>
		</div>
		
		<div id="progressbar" style="position:absolute; z-index:15;display:none;"
				class="ui-dialog ui-widget ui-widget-content ui-corner-all">
			<div class="ui-widget-header">Status</div><br/>
			<div class="progress-label">Loading...</div><br/>
		</div>
		
		<div id="confirmSmsBox" class="ui-dialog ui-widget ui-widget-content ui-corner-all" 
				style="position:absolute; z-index:15;display:none;">
			<div id="confirmSmsBoxContent"></div>
			<button id="confirmSmsBoxYesBtn"
					class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				Yes
			</button>
			<button id="confirmSmsBoxNoBtn"
					class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				No
			</button>
		</div>
	</body>
</html:html>