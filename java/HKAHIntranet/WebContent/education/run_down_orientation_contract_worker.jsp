<%@ page import="com.hkah.constant.*"%>
<%
	String category = "title.education";
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
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="HOSPITAL ORIENTATION SCHEDULE FOR CONTRACT WORKERS" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<%if (!ConstantsServerSide.isTWAH()) { %>
<form name="search_form" action="class_enrollment.jsp" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="bigText">
		<td align="right" width="20%"><b>12:30 - 12:45</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor1">INTRODUCTION, ORGANIZATIONAL CHART &amp; MANAGEMENT<br>
			醫院組織圖及管理</span><br>
			<b>Linda Yeung, Lee Wai Chong & G4S Company</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>12:45 - 13:15</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor2">SDA SPIRITUAL/BELIEF EMPHASIS<br>
			基督復臨安息日教會精神</span><br>
			<b>Spencer Lai</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>13:15 - 13:45</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor3">HOSPITAL CUSTOMER SERVICE- SHARE, COURTESY &amp; RECEPTION<br>
			顧客服務 – 與爾共享，禮貌與接待</span><br>
			<b>Spencer Lai</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>13:45 - 14:15</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor4">PATIENT HANDLING &amp; WHEELCHAIR TRAINING &amp; MANUAL HANDLING<br>
			參扶病人及輪椅訓練</span><br>
			<b>Connie Leung – Rehabilitation Center</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>14:15 - 14:45</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor5">OCCUPATIONAL SAFETY &amp; HEALTH<br>
			職業安全及健康</span>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>14:45 - 14:50</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%"><b>B R E A K 小休</b></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>14:50 - 15:20</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor6">STANDARD PRECAUTION- MASKS &amp; HAND HYGIENE<br>
			標準預防措施</span><br>
			<b>Infection Control Representative</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>15:20 - 15:50</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor7">VIP RECEPTION, CAR PARKING &amp; PRESS CONTROL<br>
			接待貴賓，泊車及控制傳媒採訪</span><br>
			<b>Lee Wai Chong</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>15:50 - 16:50</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor8">SECURITY DUTIES &amp; RESPONSIBILITIES<br>
			保安員的職責及義務</span><br>
			<b>Hospital Security Policy & Procedure 醫院政策<br>
			Role in Disaster Management<br>
			Hospital Disaster Plan & Fire Service 醫院災難應變及火災服務<br>
			Lee Wai Chong<br>
			Summary of Training & Post-tests 訓練總結及能力測試</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>16:50 - 17:15</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor9">CARPARK BARRIER OPERATIONAL TRAINING<br>
			停車場路障設置訓練</span><br>
			<b>Ski Data</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3">&nbsp;</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><button type="button"><bean:message key="button.comingSoon" /></button></td>
	</tr>
</table>
</form>
<%} %>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />

</body>
</html:html>