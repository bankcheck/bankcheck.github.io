<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.Date"%>
<%
UserBean userBean = new UserBean(request);
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>
body{
    font-size: 15px;
}
li {margin:.5em 10% .5em 0}
.tablePadding td {
padding: 3px;
}
</style>
<body id="backToTop">
<form name="form1" method="post">
<table>
<tr>
<td>
<div id="typ-zh">
<%-- <jsp:include page="../common/page_title.jsp" flush="false"> --%>
<%-- 	<jsp:param name="pageTitle" value="八號或以上烈風或暴風信號生效時應注意事項 " /> --%>
<%-- 	<jsp:param name="pageTitleEncode" value="UTF8" /> --%>
<%-- 	<jsp:param name="translate" value="N" /> --%>
<%-- 	<jsp:param name="mustLogin" value="N" /> --%>
<%-- 	<jsp:param name="pageMap" value="N" /> --%>
<%-- </jsp:include> --%>
<table width="100%">
<tr>
<TD>
<H2><B class=b1></B><B class=b2></B>
<B class=b3></B><B class=b4></B>
<DIV class=contentb><SPAN class="pageTitle bigText">
八號或以上烈風或暴風信號生效時應注意事項</SPAN> 
</DIV><B class=b4></B><B class=b3></B><B class=b2></B><B class=b1></B></H2></TD>
</tr>
</table>
<table width="100%">
	<tr>
		<td><span  style="font-size: 12px;">（修訂日期：2017年9月） <a href="#typ-en">English</a>| 中文</span>
		</td>
	</tr>
</table>
<div  style="text-align: center">

</div>
<table cellpadding="1" cellspacing="0" width="100%" height="100%" border="0" align="left" valign="top">
	<tr>
		<td>
			<ul style="margin-left:20px; font-size: 16px;">
			  <li><a href="#transportation">八號或以上颱風專車接載安排</a></li>
			  <li><a href="#hotline">查詢熱線</a></li>
			  <li><a href="#location">接載地點和車牌號碼</a></li>			 
			  <li><a href="http://www-server/intranet/common/convertPdfToSwf.jsp?policyType=H&fileName=GLD-056%20Typhoon%20policy.pdf" target="_blank">醫院政策 ── 颱風守則 (英文版)</a></li>			  
			  <li><a href="#notes">重要資訊</a></li>
			  <li><a href="" onclick="return downloadFile('685');">Typhoon Guidelines and Safety Instructions (English version only)</a></li>
			</ul>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td id="transportation" style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">
		八號或以上颱風專車接載安排</td>
	</tr>
	
	<tr><td>
		<table width="70%" border="1">
			<tr>
				<td width="15%">車型及車牌</td>
				<td>七人車ST 9571(棕色)及TS 3310(銀色)</td>
			</tr>
			<tr>
				<td >路線</td>
				<td>銅鑼灣霎東街（時代廣場連卡佛門口）↔ 醫院</td>
			</tr>
			<tr>
				<td>時間</td>
				<td>
		<table width="100%" border="1">			
			<tr><th>港安醫院開</th><th>班次</th></tr>				
			<tr><td colspan="2" style="background-color:red;color:white;">繁忙時段#</td></tr>
			<tr><td>06:00 - 08:00</td><td rowspan="3">連續運作</td></tr>
			<tr><td>14:00 - 15:30</td></tr>
			<tr><td>22:00 - 23:30</td></tr>
			<tr><td colspan="2" style="background-color:grey;color:white;">非繁忙時段</td></tr>
			<tr><td>08:00 - 09:00</td><td rowspan="4">約每30分鐘/班<br />預計逢0:30 或 0:00到達霎東街</td></tr>
			<tr><td>12:00 - 14:00</td></tr>
			<tr><td>15:30 - 17:00</td></tr>
			<tr><td>23:30 - 00:00</td></tr>
			<tr><td>09:00 - 12:00</td><td rowspan="2">約每60分鐘/班<br />預計逢 0:00到達霎東街</td></tr>
			<tr><td>17:00 - 22:00</td></tr>
			<tr><td>00:00 - 06:00</td><td>不設接載服務</td></tr>
		</table>
				</td>
			</tr>
			<tr>
				<td>首班車</td>
				<td>八號風球懸掛起約半個小時到達霎東街*<br />（首兩班車相隔約15分鐘）

				</td>
			</tr>
			<tr>
				<td>停止服務時間</td>
				<td>八號風球除下後約一個小時
				</td>
			</tr>
			<tr>
				<td colspan="2">* 如八號風球於05:30仍然懸掛，該日首班車約06:30到達霎東街。</td>
			</tr>
			<tr>
				<td colspan="2">
				<span class="bold">#繁忙時段為</span>天文台發出八號或以上烈風或暴風信號後首1.5小時; 
				及上下班繁忙時段。</td>
			</tr>
			<tr>
				<td colspan="2">
					<ul style="font-size: 20px;">
					  <li>1. <span class="bold">繁忙</span>時段內如未能接載所有正等候員工，
					  將<span class="bold italic">加開額外班次。</span></li>
					  <li>2. 務請禮讓較早上班的同事優先上車。</li>
					  <li>3. 班次可能因路況延誤，司機將與醫院密切聯繫。各同事可致電熱線3651 8666收聽最新消息錄音。</li>
					</ul>
				</td>
			</tr>
		</table>
	</td></tr>

	<tr><td>&nbsp;</td></tr>
	<tr>
		<td id="hotline" style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">查詢熱線</td>
	</tr>
	<tr>
		<td>	
			<ul style="margin-left:50px;">
			    <li>如有任何查詢，請致電3651 8666。</li>
			</ul>  
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td id="location" style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">接載地點和車牌號碼</td>		
	</tr>
	<tr>
		<td>
		<table border="1" width="60%">
			<tr>
				<td>地點：</td>
				<td>銅鑼灣霎東街（時代廣場連卡佛門口）</td>
			</tr>
			<tr>
				<td>車型：</td>
				<td>七人車ST 9571(棕色)及TS 3310(銀色)</td>
			</tr>
			<tr>
				<td>車輛數目：</td>
				<td>2</td>
			</tr>
			<tr>
				<td>車牌號碼：</td>
				<td>ST9571<br />TS3310</td>
			</tr>
		  </table>
		  </br>
		  <table>
			<tr>
				<td>
					<img src="../images/typhoon/location1.png?<%=(new Date()).getTime()%>" width="600px" onclick="callPopUpWindow('../images/typhoon/location1.png');" />
					<img src="../images/typhoon/location2.png?<%=(new Date()).getTime()%>" width="600px" onclick="callPopUpWindow('../images/typhoon/location2.png');" />
					<img src="../images/typhoon/car1.png?<%=(new Date()).getTime()%>" width="600px" onclick="callPopUpWindow('../images/typhoon/car1.png');" />
					<img src="../images/typhoon/car2.png?<%=(new Date()).getTime()%>" width="600px" onclick="callPopUpWindow('../images/typhoon/car2.png');" />
					<img src="../images/typhoon/car3.png?<%=(new Date()).getTime()%>" width="600px" onclick="callPopUpWindow('../images/typhoon/car3.png');" />
				</td>
			</tr>
		</table>
			
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	
	<tr>
		<td id="policy" style="background-color:#007   0C0;color:white;font-weight:bold;font-size:16px">
		醫院政策 ── 颱風守則</td>
	</tr>
	<tr style="hieght: 100px;">
		<td>&nbsp;</td>
	</tr>
<% if (false) { // TBC %>

<% } %>
	<tr>
		<td id="notes" style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">重要資訊</td>
	</tr>
	<tr>
		<td>			
			<ol type="a"  style="color:#00008B;margin-left:50px;">
				<li>
				當八號或以上烈風或暴風信號生效時，醫院車 Toyota Noah TS3310 (金屬銀) 
				和 Nissan Serena ST9571 (金屬棕))將成為指定員工接載車輛。			
				</li>				
				<li>
				八號或以上烈風或暴風信號生效期間，所有住客和員工之租車預約將即日取消。
				</li>	
				<li>
				關於八號或以上烈風或暴風信號生效時之安排和注意事項，請參考&lt;醫院颱風政策&gt;。 
				</li>	
				<li>
				若閣下於夜間因颱風影響下未能離開醫院，請聯繫當值主任安排住宿，院方會盡力協助。
				</li>		
			</ol>			
		</td>
	</tr>	
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
		<a href="#typ-zh">返回頂項</a>
		</td>
	</tr>
</table>
</div>
</td>
</tr>

<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>

<tr>
<td>
<div id="typ-en">
<table width="100%">
<tr>
<TD>
<H2><B class=b1></B><B class=b2></B>
<B class=b3></B><B class=b4></B>
<DIV class=contentb><SPAN class="pageTitle bigText">
Notice for Typhoon No.8 or above</SPAN> 
</DIV><B class=b4></B><B class=b3></B><B class=b2></B><B class=b1></B></H2></TD>
</tr>
</table>
<table width="100%">
	<tr>
		<td><span  style="font-size: 12px;">(Last revised on Sept 2017)
		English | <a href="#typ-zh">中文</a></span>
		</td>
	</tr>
</table>
<div   style="text-align:center;">
</div>
<table cellpadding="1" cellspacing="0" width="100%" height="100%" border="0" align="left" valign="top">
	<tr>
		<td >
			<ul style="margin-left:20px; font-size: 16px;">
			  <li><a href="#transportationE">Hospital vehicle transportation arrangement during Typhoon Warning Signal No. 8 or above</a></li>
			  <li><a href="#hotlineE">Hotline</a></li>
			  <li><a href="#locationE">Pick-up location and car license plate</a></li>			 
			  <li><a href="http://www-server/intranet/common/convertPdfToSwf.jsp?policyType=H&fileName=GLD-056%20Typhoon%20policy.pdf" target="_blank">Typhoon policy</a></li>
			  <li><a href="#notesE">Typhoon important notes</a></li>
			  <li><a href="" onclick="return downloadFile('685');">Typhoon Guidelines and Safety Instructions (English version only)</a></li>
			</ul>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td id="transportationE" style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">
		Hospital Vehicle Transportation Arrangement During Typhoon Warning Signal No. 8 or Above</td>
	</tr>
	
	<tr><td>
		<table border="1" width="70%">
			<tr>
				<td width="7%">Vehicle Type</td>
				<td>Two seven-seat vehicles(metallic silver & metallic brown)</td>
			</tr>
			<tr>
				<td>Vehicle No.:</td>
				<td>ST9571<br />TS3310</td>
			</tr>
			<tr>
				<td>Route</td>
				<td>Causeway Bay Sharp Street East next to the Lane Crawford of Time Square ↔ Hospital</td>
			</tr>
			<tr>
				<td>Schedule</td>
				<td>
		<table width="100%"border="1">			
			<tr><th>Departs at HKAH-SR</th><th>Frequency</th></tr>				
			<tr><td colspan="2" style="background-color:red;color:white;">Peak hours#</td></tr>
			<tr><td>06:00 - 08:00</td><td rowspan="3">Non-stop transportation</td></tr>
			<tr><td>14:00 - 15:30</td></tr>
			<tr><td>22:00 - 23:30</td></tr>
			<tr><td colspan="2" style="background-color:grey;color:white;">Off-peak hours</td></tr>
			<tr><td>08:00 - 09:00</td><td rowspan="4">Around 30 minutes<br />Estimate to arrive at Sharp Street East every 0:30 or 0:00</td></tr>
			<tr><td>12:00 - 14:00</td></tr>
			<tr><td>15:30 - 17:00</td></tr>
			<tr><td>23:30 - 00:00</td></tr>
			<tr><td>09:00 - 12:00</td><td rowspan="2">Around 60 minutes<br />Estimate to arrive at Sharp Street East every 0:00</td></tr>
			<tr><td>17:00 - 22:00</td></tr>
			<tr><td>00:00 - 06:00</td><td>No transportation</td></tr>
		</table>
				</td>
			</tr>
			<tr>
				<td>The first van</td>
				<td>Arrives at Sharp Street East in approximately 30 minutes once Typhoon Signal No.8 or above is in force.*<br />
				(The second van arrives at the pick-up location about 15 minutes after the first van departs.)
				</td>
			</tr>
			<tr>
				<td>End of service</td>
				<td>Approximately one hour after Typhoon Signal No. 8 or above is cancelled.
				</td>
			</tr>
			<tr>
				<td colspan="2">* If Typhoon Signal No. 8 or above is still in force at 05:30, the first van will be arriving at Sharp Street East at around 06:30.</td>
			</tr>
			<tr>
			<td colspan="2">
				<span class="bold">#Peak Hours =<br /></span>
				(1) The first 1.5 hours once Typhoon No.8 or above is in force; and<br />
				(2) Rush hour, the peak hours during commuting time.</td>
			</tr>
			<tr>
					<td colspan="2">
					<ul style="font-size: 20px;">
					  <li>1. If hospital transportation is not able to pick up all colleagues waiting in the queue during peak hours, extra runs will be added.</li>
					  <li>2. Please let colleagues who have to report to duty earlier get on first.</li>
					  <li>3. The hospital vehicles may be delayed subject to traffic conditions. Drivers remain in contact with the hospital and colleagues may listen to the latest typhoon information recording by calling 3651 8666.</li>
					</ul>
				</td>
			</tr>
		</table>
	</td></tr>

	<tr><td>&nbsp;</td></tr>
	<tr>
		<td id="hotlineE" style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">Hotline</td>
	</tr>
	<tr>
		<td>	
			<ul style="margin-left:50px;">
			    <li>For inquiries regarding the hospital van transportation schedule, please call 3651 8666.</li>
			</ul>  
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td id="locationE" style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">Pick-up location and car license plate</td>		
	</tr>
	<tr>
		<td>
		<table border="1" width="70%">
			<tr>
				<td>Location:</td>
				<td>Causeway Bay Sharp Street East next to the Lane Crawford of Time Square </td>
			</tr>
			<tr>
				<td>Vehicle Type:</td>
				<td>Seven-seat vehicles (metallic silver & metallic silver)</td>
			</tr>
			<tr>
				<td>Quantity:</td>
				<td>Two</td>
			</tr>
			<tr>
				<td>Vehicle License Plates:</td>
				<td>ST9571<br />TS3310</td>
			</tr>
			</table>
			<table>
			<tr>
				<td>
					<img src="../images/typhoon/location1.png?<%=(new Date()).getTime()%>" width="600px" onclick="callPopUpWindow('../images/typhoon/location1.png');" />
					<img src="../images/typhoon/location2.png?<%=(new Date()).getTime()%>" width="600px" onclick="callPopUpWindow('../images/typhoon/location2.png');" />
					<img src="../images/typhoon/car1.png?<%=(new Date()).getTime()%>" width="600px" onclick="callPopUpWindow('../images/typhoon/car1.png');" />
					<img src="../images/typhoon/car2.png?<%=(new Date()).getTime()%>" width="600px" onclick="callPopUpWindow('../images/typhoon/car2.png');" />
					<img src="../images/typhoon/car3.png?<%=(new Date()).getTime()%>" width="600px" onclick="callPopUpWindow('../images/typhoon/car3.png');" />
				</td>
			</tr>
		</table>
			
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr style="hieght: 100px;">
		<td>&nbsp;</td>
	</tr>
<% if (false) { // TBC %>
	<tr>
		<td style="padding: 3px;">	
			<span style="margin-left:50px;">
			The Typhoon allowance is essentially given to those who are greatly 
			inconvenienced in having to travel to or from work during the Typhoon 8 or above signal.
			</span>
		</td>
	</tr>
	<tr>
		<td><span style="margin-left:25px;font-weight:bold;font-size:15px">Procedure:</span></td>
	</tr>
	<tr>
		<td><span style="margin-left:50px;">When Typhoon Signal Number 8 or above is up:</span></td>
	</tr>
	<tr>
		<td>
			<ol style="margin-left:70px;">
			  <li>
			  The <u>Duty Manager</u> will be designated as the Coordinator for the entire Hospital. 
			   Department Heads will work through this individual and administrative staff will be available as needed.
			  </li>				  
			  <li>
			  Please contact your respective departments to inquire if you are required to work.  
			  If you are required to report to work, please refer to the attached <b>Master Schedule with 
			  Maps</b> for pick-up times and pick-up points.  If signal #9 or above is expected, a different
			   schedule will be followed, employees affected should contact the <u>Duty Manager</u> for details.
			  </li>
			  <li>
			  As signal # 3 is hoisted, Department Heads are responsible to take immediate steps
			  to secure their work area and to prepare/alert their staff for implementation of this policy.
			  Staff may be called in early in anticipation of the # 8 signal.  An official announcement over
			  the P.A. system will be made from the <u>Duty Manager</u> office to allow non-essential staff to
			  leave the Hospital.  Only regular payment will be given to non-essential staff who choose
			  to stay behind after the announcement was made.  A memo from the <u>Duty Manager</u> office will
			  be sent (after each Typhoon) to all departments stating the starting and ending times
			  of signal #8 to facilitate payroll computations.
			  </li>
			  <li>
			  <b><u>During a weekday (Monday - Friday):</u></b> Each Department Head is required to make necessary
			  arrangements before he/she allows his/her employees to go home.  The Department Head usually
			  is the last one to leave.			  
			  </li>
			  <li>
			  <b><u>On a weekend day or Public Holiday:</u></b> The Department Head is always expected to have advance arrangements 
			  made for the next Typhoon.
			  </li>
			  <li>
			  <b><u>The minimum number of employees staying in the Hospital during a Typhoon:</u></b>
			  Each Department needs to have an appropriate number of employees to keep operations running smoothly.
			 The Doctor on-call, inpatient nurses, telephone operators and security guards should be on duty as
			  usually scheduled.  The Food Services Department must make sure that it provides adequate food for 
			  patient and staff.  Maintenance Department must have enough employees on stand-by during the Typhoon
			  for the protection of the Hospital. 
			  </br></br>
			  Employees who are scheduled to work but who are not required to report for duty will be paid as if
			  they came to work.<u>But if the signal #8 is lowered during their shift, they should contact their
			  Department Head as to whether they need to come back to work for the rest of their shift. 
			  Failure to call in will result in loss of pay.</u>
			  </br></br>
			  <b>The following is a list of departments who should have staff working to keep the operation running smoothly:</b>
			  <table class="tablePadding"  border="0">
			  	<tr><td style="background-color:#E0E0E0">Medical Staff</td><td class="infoData">Doctor on-call</td></tr>			  	
			  	<tr><td style="background-color:#E0E0E0">Nursing Department</td><td class="infoData">In-Patient nurses - as usually scheduled</td></tr>
			  	<tr><td style="background-color:#E0E0E0">Outpatient Department</td><td class="infoData">2 Nurses (at least 1 RN) from 08:00 to 22:00</br>1 RN from 22:00 to 08:00</td></tr>
			  	<tr><td style="background-color:#E0E0E0">Patient Business Office</td><td class="infoData">2 Inpatient Service Officers</br>Operators - as usually scheduled</td></tr>
			  	<tr><td style="background-color:#E0E0E0">Security Department</td><td class="infoData">As usually scheduled</td></tr>
			  	<tr><td style="background-color:#E0E0E0">Maintenance Department</td><td class="infoData">2 (including driver)</td></tr>
			  	<tr><td style="background-color:#E0E0E0">Housekeeping Department</td><td class="infoData">9</td></tr>
			  	<tr><td style="background-color:#E0E0E0">Laboratory Department</td><td class="infoData">2 Lab Technicians in day time</br>1 Lab Technician in the evening or at night</td></tr>
			  	<tr><td style="background-color:#E0E0E0">Diagnostic Services</td><td class="infoData">2 Radiographers</td></tr>
			  	<tr><td style="background-color:#E0E0E0">Cardiopulmonary Lab</td><td class="infoData">1 Nurse</td></tr>
			  	<tr><td style="background-color:#E0E0E0">Pharmacy Department</td><td class="infoData">3 (1 Pharmacist and 2 Dispensers)</td></tr>
			  </table>
			  </br>
			  It is advised that Department Heads assign their staff to work on a rotating basis during the Typhoon season.
			  Beds will be provided for those employees who are asked to stay behind, so that they can sleep following
			  their regular shift of duty.  The Duty Manager on duty will make arrangements to provide beds.
			  </li>
			  <li>
			  If the number 8 is up, an employee who lives outside Hospital premises and is assigned to work 
			  but is unable to get public transport or a taxi, he/she will be paid regular salary for that shift.
			  <u>However, he/she must call in to notify the Department Head that he/she cannot get into work,
			  failure of which will result in loss of normal compensation.</u>
			  </li>
			  <li>
			  If the # 8 signal is hoisted after a worker comes on duty then the allowance is not payable if the signal
			   is lowered within the shift.  In other words, the Typhoon allowance will be paid at the regular hourly
			    rate for each hour worked while the # 8 signal (or above) is posted so long as the shift starts or ends
			     with the signal.  If the worker works overtime due to the Typhoon, then the overtime rate is paid plus
			      the Typhoon allowance.
			  </br>
			  On-call pay during signal #8 will be 2/3 times regular rate (with cap which may be revised from time to time)
			   and call-back pay during signal #8 will be 2 times regular rate (with cap which may be revised from time to
			   time).			  
			  </li>
			  <li>
			  Necessary travel by taxi to the nearest MTR station will be reimbursed 
			  with receipt up to HK$150 with prior approval from the Supervisor.  Transportation by hospital van,
			   from the Wanchai and Happy Valley pick-up points, will be coordinated by the <u>Duty Manager</u> and the 
			   Maintenance Department.  Transportation by hospital van from the Hospital to the drop-off points, 
			   may be provided if possible but is not guaranteed.
				</br></br>
			<b>Reimbursement for transportation to home will not be necessary because:</b>
				<ol type="a" style="margin-left:20px;">					
					<li>If the signal is still posted, staff will not be allowed to leave.</li>					
					<li>If the signal is down, routine public transport will be available</li>
				</ol> 			  
			  </li>
			  <li>
				When Typhoon signal number 8 is lowered, employees who were scheduled to work 
			  but are not on duty should contact their Department Heads as to whether they need to
			   come back to work for the rest of their shift.  Failure to call in will result in loss of pay.
			  </li>
			</ol>
		</td>
	</tr>	
	<tr>
		<td><span style="margin-left:25px;font-weight:bold;font-size:15px">Affected Personnel:</span></td>		
	</tr>
	<tr>
		<td><ol style="margin-left:50px;"><li>All employees in the Hospital.</li></ol></td>
	</tr>
	<tr>
		<td><span style="margin-left:25px;font-weight:bold;font-size:15px">Other related Documents and Policies:</span></td>		
	</tr>
	<tr>
		<td><ol style="margin-left:50px;">
		<li>On Call Remuneration Policy</li>
		<li>Overtime Salary</li>
		</ol></td>
	</tr>
	<tr>
		<td><span style="margin-left:25px;font-weight:bold;font-size:15px">Accreditation/Standards Cross-Reference:</span></td>		
	</tr>
	<tr>
		<td><ol style="margin-left:50px;">
		<li>JCI QPS-1.1, -2, FMS-4</li>
		<li>TRENT</li>
		<li>DOH</li>
		<li>HK Ordinances</li>
		</ol></td>
	</tr>	
	<tr><td>&nbsp;</td></tr>
<% } %>
	<tr>
		<td id="notesE" style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">Important Notes</td>
	</tr>
	<tr>
		<td>			
			<ol type="a"  style="color:#00008B;margin-left:50px;">
				<li>
				By defaults the hospital Toyota Noah TS3310 (Silver) and Nissan Serena ST9571 (Brown) will be the transport vehicle for hospital staff during typhoon.			
				</li>				
				<li>
				All bookings for both vehicles by residence or approved staffs will be voided when an advance announcement of Typhoon signal 8 is made. 
				</li>	
				<li>
				For details on arrangements and precautions to be taken during Typhoon Signal No. 8 or above, please refer to 'Hospital Typhoon Policy'.
				</li>	
				<li>
				If you are unable to leave the hospital during Typhoon Signal No. 8 or above in the evening, please contact the duty manager for accommodation arrangement. We will do our best to make the necessary arrangements.
				</li>		
			</ol>			
		</td>
	</tr>	
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
		<a href="#typ-zh">Back to Top</a>
		</td>
	</tr>
</table>
</div>
</td>
</tr>
</table>
</form>
<script language="javascript">
<!--
	
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>