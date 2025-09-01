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
	<jsp:param name="pageTitle" value="HOSPITAL ORIENTATION PROGRAM" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<form name="search_form" action="class_enrollment.jsp" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="bigText">
		<td style="padding:5px" align="left"  ><b>13:00-13:30</b></td>
		<td style="padding:5px" valign="top" align="left"  ><span class="labelColor1">Chaplain<br/>院牧</span></td>
		<td style="padding:5px" align="left"  >
			<span class="labelColor1">Hospital faith and background <br/>醫院信仰及背景</span>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td style="padding:5px" align="left"  ><b>13:31-15:10</b></td>
		<td style="padding:5px" valign="top" align="left"  ><span class="labelColor2">HR Officer<br/>人力資源部主任</span></td>
		<td style="padding:5px" align="left"  >
			<span class="labelColor2">
				Hospital Introduction<br/>醫院簡介<br/>
				<ul>
				  <li>Adventist Health Mission & Value<br/>港安使命宣言及價值觀</li>
				  <li>Employee Handbook & MPF<br/>員工手冊重點及強制性公積金</li>
				  <li>Confidential Information & policy<br/>機密資料或政策</li>
				  <li>E-leave application</li>
				</ul>  
			</span>		
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td style="padding:5px" align="left"  ><b>15:11-15:30</b></td>
		<td style="padding:5px" valign="top" align="left"  ><span class="labelColor3">PI Manager<br/>品質改善部經理</span></td>
		<td style="padding:5px" align="left"  >
			<span class="labelColor3">
				Performance Improvement (PI), ACHS, Portal<br/>醫院品質改善, 澳洲醫護認證考試, 內聯網		
			</span>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td style="padding:5px" align="left"  ><b>15:31-16:00</b></td>
		<td style="padding:5px" valign="top" align="left"  ><span class="labelColor4">Infection Control Nurse<br/>感染控制護士</span></td>
		<td style="padding:5px" align="left"  >
			<span class="labelColor4">
				Infection Control information <br/>感染控制資訊
			</span>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td style="padding:5px" align="left"  ><b>16:01-16:30</b></td>
		<td style="padding:5px" valign="top" align="left"  ><span class="labelColor5">Manager, OSH/EH/SE<br/>職安健/員工健康/員工培訓經理</span></td>
		<td style="padding:5px" align="left"  >
			<span class="labelColor5">
				Occupational Safety, Fire Safety, Office Safety, Manual handling procedure<br/>職業安全, 防火安全, 辦公室安全, 人力提舉				
			</span>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td style="padding:5px" align="left"  ><b>16:30-16:50</b></td>
		<td style="padding:5px" valign="top" align="left"  ><span class="labelColor6">Staff Education Coordinator <br/>員工培訓統籌</span></td>
		<td style="padding:5px" align="left"  >
			<span class="labelColor6">In Service Training Information<br/>院內員工培訓資訊</span>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>	
	<tr class="bigText">
		<td align="center" colspan="3">&nbsp;</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><button type="button" onclick="showtext()">View Schedule</button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3" id="schedule" style="display:none;">
			Hospital Orientation programs are provided monthly. <br/>
			Departments will receive emails from HRD for details of schedule.
		</td>
	</tr>
</table>
</form>
</DIV>

</DIV></DIV>
<script>
	function showtext(){
		var x = document.getElementById("schedule");
	    if (x.style.display === "none") {
	        x.style.display = "block";
	    } else {
	        x.style.display = "none";
	    }
	}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />

</body>
</html:html>