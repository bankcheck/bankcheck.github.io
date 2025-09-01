<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.web.common.*"%>



<% 
UserBean userBean = new UserBean(request);
boolean isTW = ConstantsServerSide.isTWAH();
if (userBean == null || !userBean.isLogin()) {
	if(isTW) {
		%>
		<script>
			window.open("../foodtw/index.jsp", "_self");
		</script>
		<%
	}
	else {
		%>
		<script>
			window.open("../patient/index.jsp", "_self");
		</script>
		<%
	}
	
	return;
}
	String romCode = userBean.getRemark1();
	String bedCode = userBean.getRemark2();
	String regID = userBean.getRemark3();
%>
<!--  
<tr align="center">
	<td colspan='2' align="center">
		<div align="center">
			<img src="../images/food.jpg"><br/>
			<span class="enquiryLabel extraBigText">Food Services</span>
		</div>
	</td>
</tr>

<tr><td>&nbsp;</td></tr>

<tr align='center'><td align="center" colspan='2'>Order Summary</td></tr>
-->
<tr>
	<td>&nbsp;</td>
	<td><label class="text">Patient:&nbsp;<b><%= userBean.getUserName() %></b></label></td>
	<td>&nbsp;</td>
	<td><label class="text">&nbsp;Rm:&nbsp;<b><%= userBean.getDeptCode() %></b></label></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td><label class="text">HN:&nbsp;<b><%= userBean.getStaffID() %></b></label></td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td colspan="4"><hr/></td>
</tr>
<tr>
	<td colspan="4">
		<jsp:include page="../ui/foodAllergyCMB.jsp" flush="true">
			<jsp:param name="patno" value="<%=userBean.getStaffID() %>" />
		</jsp:include>
	</td>
</tr>

<tr style="<%=isTW?"":"display:none"%>">
	<td>&nbsp;</td>
	<td>
		<label class="text">Serve Type:&nbsp;</label>
		<label id="selectedType" class="text"></label>
		<select id="fdServeType" style="width:150px; height:30px; font-size:21px;">
			<option value="null">--</option>
			<option value="B">Breakfast</option>
			<option value="L">Lunch</option>
			<option value="D">Dinner</option>
			<option value="S">Snack</option>
		</select>
	</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>

<tr>
	<td colspan="4"><hr/></td>
</tr>

<tr id="serveTimeDef" style="<%=isTW?"display:none":""%>">
	<td>&nbsp;</td>
	<td style="background-color:#FFFFCE;" colspan="2">
		<div style="float:left">
			<div style="float:left">
				<label class="text">Serve Time:&nbsp;</label><label class="text orderHidden">(Please click one of the boxes below)</label>
				<label id="selectedTime" class="text"></label>
			</div>
			<br/>
			<br/>
			<div class="serveTime" style="float:left">
				<input type="radio" name="time" value="now" style="width:30px; height:30px;"/><label class="text"><b>Now</b></label>
			</div>
			<br/>
			<br/>
			<br/>
			<div class="serveTime" style="float:left;">
				<input type="radio" name="time" value="custom" style="width:30px; height:30px;" />
				<!--<div id="bfChosenLabel"><label class="text"><b>Custom Time</b></label></div>  -->
				
					<input style="width:130px; font-size:21px; background:yellow; color:	#2F0000; font-weight:bold" id="datepicker" disabled/>
					<select id="serveHour" style="width:80px; height:30px; font-size:21px;">
								<option value = 'null'>--</option>
						<%
							for( int i = 7; i < 20; i++) {
							%>
								<option value = '<%=(i <10)?"0"+i:i %>'><%=(i <10)?"0"+i:i %></option>
							<%
								}
						%>
					</select>
					<span> : </span>
					<select id="serveMin" style="width:80px; height:30px; font-size:21px;">
								<option value = 'null'>--</option>
						<%
							for( int i = 0; i < 60; i+=15) {
							%>
								<option value = '<%=(i <10)?"0"+i:i %>'><%=(i <10)?"0"+i:i %></option>
							<%
							}
						%>
					</select>
					<label class="text">(07:30 - 19:30)</label>
			</div>
		</div>
	</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td colspan="4"><hr/></td>
</tr>
<tr id="summaryContent"></tr>
<tr><td>&nbsp;</td></tr>
<tr class="relatedToTW" style="<%=(isTW)?"":"display:none;"%>">
	<td colspan="3">
	</td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>

<tr class="orderHidden">
	<td colspan="3"><label class="text" style="color:red">*If there is any changes, please <b>cancel</b> the item and <b>re-order</b> it.</label></td>
</tr>
<tr><td>&nbsp;</td></tr>
<!--  <tr>	
	<td><label id = "itemName"></label></td>
	<td><label id = "itemPrice"></label></td>
</tr>
<tr>
	<td><label id = "itemOpt"></label></td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
	<td>&nbsp;</td>
	<td><label id = "total"></label></td>
</tr>-->
