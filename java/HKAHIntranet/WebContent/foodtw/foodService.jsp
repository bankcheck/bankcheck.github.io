<%@ page language="java" contentType="text/html; charset=UTF-8"
     pageEncoding="UTF-8"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>

<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../foodtw/index.jsp", "_self");
	</script>
	<%
	return;
}

String custom = request.getParameter("custom");
boolean freeInput = (custom != null && custom.length()> 0 && custom.equals("Y"));
String psID;
String patNo;
String ward;
String wardCode;
String wardNo;
String room;
String bed;
String patName;
String regID;
String regType;
String remark;
String romCode;
String sex = "";
String surName = "";
String givenName = "";
String dob = "";
String idNo = "";
String chiName = "";
String isLCB = "";
String accessWardList = "";
if(custom != null && custom.length()> 0 && custom.equals("Y")) {
	psID = "";
	patNo = "";
	ward = "";
	wardCode = "";
	wardNo = request.getParameter("wardNo");
	room = "";
	bed = request.getParameter("bed");
	patName = "";
	regID = "";
	regType = "";
	remark = "";
	romCode = request.getParameter("romCode");
	accessWardList = request.getParameter("accessWardList");

}
else {
	psID = request.getParameter("psID");
	patNo = request.getParameter("patNo");
	ward = request.getParameter("ward");
	wardCode = request.getParameter("wardCode");
	wardNo =  request.getParameter("wardNo");
	room = request.getParameter("room");
	bed = request.getParameter("bed");
	patName = request.getParameter("patName");
	regID = request.getParameter("regID");
	regType = request.getParameter("regType");
	remark = java.net.URLDecoder.decode(request.getParameter("remark"));
	romCode = request.getParameter("romCode");
	isLCB = request.getParameter("isLCB");
	accessWardList = request.getParameter("accessWardList");
	
	ArrayList record = PatientDB.getPatInfo(patNo);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject)record.get(0);
		sex = row.getValue(1);
		surName = row.getValue(11);
		givenName = row.getValue(12); 
		dob = row.getValue(17);
		idNo = row.getValue(18);
		chiName = row.getValue(4);
	}
}

if (accessWardList == null || "null".equals(accessWardList)) {
	accessWardList = "";
}

boolean edit = "Y".equals(request.getParameter("edit"));
String orderNo = null;
if(edit) {
	orderNo = request.getParameter("orderNo");
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	<jsp:include page="../foodtw/checkSession.jsp" />
	<script type="text/javascript" src="<html:rewrite page="/js/jquery.uuid.js" />"></script>
	<style>
		TD {
			font-size: 18px !important;
		}
		LABEL, SELECT, OPTION, TEXTAREA {
			font-size: 20px !important;
		}
		.selected {
			background: url("../images/ui-bg_highlight-soft_75_ffe45c_1x100.png") repeat-x scroll 50% 50% #F6F6F6 !important;
		}
		.ingredients {
			cursor: pointer;
			padding: 10px;
		}
	</style>
	<body>
		<input type="hidden" name="patNo" value='<%=(patNo==null?"":patNo) %>' />
		<input type="hidden" name="ward" value='<%=(ward==null?"":ward) %>' />
		<input type="hidden" name="room" value='<%=(room==null?"":room) %>' />
		<input type="hidden" name="bed" value='<%=(bed==null?"":bed) %>' />
		<input type="hidden" name="patName" value='<%=(patName==null?"":patName) %>' />
		<input type="hidden" name="regID" value='<%=(regID==null?"":regID) %>' />
		<input type="hidden" name="edit" value='<%=edit %>' />
		<input type="hidden" name="orderNo" value='<%=(orderNo==null?"":orderNo) %>' />
		<input type="hidden" name="remark" value='<%=(remark==null?"":remark) %>' />
		<input type="hidden" name="psID" value='<%=(psID==null?"":psID) %>' />
		<input type="hidden" name="acmCode" value='<%=(psID==null?"":psID) %>' />
		<input type="hidden" name="regType" value='<%=(regType==null?"":regType) %>' />
		<input type="hidden" name="wardNo" value='<%=(wardNo==null?"":wardNo) %>' />
		<input type="hidden" name="romCode" value='<%=(romCode==null?"":romCode) %>' />
		<input type="hidden" name="wardCode" value='<%=(wardCode==null?"":wardCode) %>' />
		<input type="hidden" name="custom" value='<%=custom %>' />
		<input type="hidden" name="isLCB" value='<%=(isLCB==null?"false":isLCB) %>' />
		
		<div class="summaryHidden orderBtn" style="position:absolute; z-index:1;">
			<button onclick="addOrder()" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
					style="width:150px; height:60px;font-size:24px!important;position:absolute; z-index:1;">
				Add
			</button>
		</div>
		
		<div class="summaryHidden updateRmkDialog ui-dialog ui-widget ui-widget-content ui-corner-all" style="position:absolute; z-index:1;<%=freeInput?"display:none":"" %>">
			<div class="ui-widget-header">Remark</div>
			<div>
				<input class="remarkDay" style='width:25px; height:25px;' name='remarkDay' type='radio' value='today' checked/><span style="font-size:18px!important;">Today</span>&nbsp;&nbsp;&nbsp;
				<input class="remarkDay" style='width:25px; height:25px;' name='remarkDay' type='radio' value='tmr'/><span style="font-size:18px!important;">Tomorrow</span>
			</div>
			<br/>
			<hr/>
			<div style="float:left;width:60%;">
				<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus' type='radio' value='NPO'/><span style="font-size:18px!important;">NPO</span><br/>
				<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus' type='radio' value='Unable to Access'/><span style="font-size:18px!important;">Unable to Access</span><br/>
				<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus' type='radio' value='No Order'/><span style="font-size:18px!important;">No Order</span><br/>
			</div>
			<div style="float:right;width:40%;">
				<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus' type='radio' value='Discharge'/><span style="font-size:18px!important;">Discharge</span><br/>
				<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus' type='radio' value='Order Later'/><span style="font-size:18px!important;">Order Later</span><br/>
				<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus' type='radio' value='Normal'/><span style="font-size:18px!important;">Normal</span><br/>
			</div>
			<div style="float:right">
				<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
						onclick="updateRemark(this)">
					Update
				</button>
			</div>
		</div>
		
		<div id="overlay" class="ui-widget-overlay" style="display:none; z-index:11;"></div>
		<div class="ui-dialog ui-widget ui-widget-content ui-corner-all"
				style="width:250px; height:120px; position:absolute; z-index:12; display:none;"
				id="alertMsgDialog">
			<div class="ui-widget-header"><img src="../images/info.gif"/></div>
			<br/>
			<div style="text-align:center;">
				<span id="alertMsg" style="font-size:20px">
				</span>
				<br/><br/>
				<div id="alerResponetBtn">
				</div>
			</div>
		</div>
		
		
		<div id="fdIngredients" style="display:none; z-index:10; position:absolute; 
					background-color:#FFCC66; padding:10px; width:300px;">
			<div id="fdIngredients-content"></div>
		</div>
		
		<table width="95%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="center" colspan="4">
					&nbsp;
				</td>
			</tr>
			<tr id="btnRow">
				<td align="center" colspan="4">
					<div style="float:left">
						<div style="float:left">
							<button class = "backWard ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
								style="width:150px; height:50px;"> 
								<a href="../foodtw/patlist.jsp?ward=<%=wardNo%>&bed=<%=bed %>&room=<%=romCode%>&accessWardList=<%=accessWardList %>">Back to ward</a>
							</button>
						</div>
						<div style="float:right">
							<button class = "backList ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
								style="width:150px; height:50px;"> 
								<a href="../foodtw/patlist.jsp?accessWardList=<%=accessWardList%>">Back to list</a>
							</button>
						</div>
					</div>
					<img src="../images/logo_twah.gif" border="0" />
					<div style="float:right">
						<button class = "logout ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
								style="width:150px; height:50px;"> 
							<a href="../foodtw/logout.jsp"><%=MessageResources.getMessageEnglish("prompt.logout") %></a>
						</button>
					</div>
				</td>
			</tr>
			<tr>
				<td width="20%"><b>Patient No.:</b></td><td width="30%"><%=freeInput?"<input name='patNo_input' style='font-size:16px'/>":patNo %></td>
				<td width="20%"><b>Patient Name:</b></td><td width="30%"><%=freeInput?"<input name='patName_input' style='font-size:16px'/>":patName %></td>
			</tr>
			<tr>
				<td width="20%"><b>Ward:</b></td><td width="30%"><%=freeInput?"<input name='ward_input' style='font-size:16px'/>":ward %></td>
				<td width="20%"><b>Room:</b></td><td width="30%"><%=freeInput?"<input name='room_input' style='font-size:16px'/>":room %></td>
			</tr>
			<tr>
				<td width="20%"><b>Bed:</b></td><td width="30%"><%=freeInput?"<input name='bed_input' style='font-size:16px'/>":bed %></td>
				<td width="20%">
					<b>Allergy:</b>
				</td>
				<td width="30%">
					<%=freeInput?"<input name='allergy_input' style='font-size:16px'/>":(PatientDB.getInpatientAllergy(patNo, bed).replace("<", "&lt;").replace(">", "&gt;"))%>
				</td>
			</tr>
			<tr>
				<td width="20%"></td><td width="30%"></td>
				<td width="20%"><b>Structure Alert:</b></td>
				<td width="30%">
					<form method="POST" target="_blank"
						action="http://160.100.3.35/AdaptationFrame/html/AdaptationFrame.jsp?sex=<%=sex %>&engSurName=<%=surName %>&engGivenName=<%=givenName %>&mrnPatientIdentity=<%=patNo %>&dob=<%=dob %>&doctype=ID&docnum=<%=idNo %>&login=admin&loginName=FoodTW&userRight=A&userRank=720&userRankDesc=720&hospitalCode=AH&systemLogin=ALERT_ALLERGY&sourceSystem=CIS">
						<input type="hidden" name="chiName" value="<%=chiName%>"/>
						<input type="submit" value="View" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="font-size:18px;!important;width:160px;" >
					</form>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		
		<table id="preview" width="95%" border="0" cellpadding="0" cellspacing="0">
		</table>
		<div class="orderDisplay" style="display:none;float:right;">
			<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
						style="width:150px; height:60px;font-size:24px!important;" onclick="window.location.reload();return false;">
				New Order
			</button>
		</div>
		
		<table class="summaryHidden" width="95%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td align="center" colspan="2"><button style="font-size:24px; width:400px;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only menuBtn selected">Menu</button></td>
				<td align="center" colspan="2"><button style="font-size:24px; width:400px;" class = "menuBtnSet ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only menuBtn">Set</button></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="5">
					<table>
						<tr>
							<td valign="top">
								<button key="common" class = "filter menu ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Common</button>
								<button key="snack" class = "filter menu ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Snack</button>
								<button key="drink" class = "filter menu ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Drink</button>
							</td>
							<td colspan="2">&nbsp;</td>
							<td valign="top">
								<div>
									<button key="0" class = "filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">0</button>
									<button key="1" class = "filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">1</button>
									<button key="2" class = "filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">2</button>
									<button key="3" class = "filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">3</button>
									<button key="4" class = "filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">4</button>
									<button key="5" class = "filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">5</button>
									<button key="6" class = "filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">6</button>
								</div>
								<br/>
								<div>
									<button key="A" class = "menu mSet filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">A</button>
									<button key="B" class = "menu mSet filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">B</button>
									<button key="C" class = "menu mSet filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">C</button>
									<button key="D" class = "menu mSet filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">D</button>
									<button key="E" class = "menu mSet filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">E</button>
									<button key="F" class = "menu mSet filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">F</button>
									<button key="G" class = "menu mSet filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">G</button>
								</div>
							</td>
							<td colspan="2">&nbsp;</td>
							<td valign="top">
								<button key="others" class = "others filter ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Others</button>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr class = "menu updateRmkLoc">
				<td width="15%">
					<label>Category: </label>
				</td>
				<td colspan="4"><select id="foodCategory"></select></td>
			</tr>
			<tr class = "menu"><td>&nbsp;</td></tr>
			<tr class = "menu"><td>&nbsp;</td></tr>
			<tr class = "menu">
				<td width="5%">
					<label>Order Menu: </label>
				</td>
				<td colspan="4">
					<select id="orderMenu"></select><br/>
					<img class="ingredients" src="../images/ball-green.png" width="20"/>
				</td>	
			</tr>
			<tr class = "menu"><td>&nbsp;</td></tr>
			<tr class = "menu"><td>&nbsp;</td></tr>
			<tr class = "set">
				<td id="setItemRecord" colspan="4">
					
				</td>
			</tr>
			<tr class = "set"><td colspan="4"><hr/></td></tr>
			<tr class = "set"><td>&nbsp;</td></tr>
			<tr class = "set">
				<td width="5%">
					<label>Set Menu: </label>
				</td>
				<td colspan="4"><select id="setMenu"></select></td>	
			</tr>
			<tr class = "set"><td>&nbsp;</td></tr>
			<tr class = "set">
				<td width="5%">
					<label>Composition: </label>
				</td>
				<td colspan="4">
					<div id="setCompDiv">
					</div>
					<br/>
					<select id="setComp"></select> 
					<button onclick="recordSetItem();" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Record</button>
				</td>	
			</tr>
			<tr class = "set"><td>&nbsp;</td></tr>
			<tr class = "set">
				<td width="5%">
					<label>Order Menu: </label>
				</td>
				<td colspan="4" valign="middle" align="left">
					<img class="ingredients" src="../images/ball-green.png" width="20"/>
					<div id="setOrderMenuDiv">
					</div>
					<br/>
					<select id="setOrderMenu"></select>
				</td>	
			</tr>
			<tr class = "set"><td>&nbsp;</td></tr>
			<tr>
				<td width="5%">
					<label>Composition: </label>
				</td>
				<td colspan="4" width="85%"><select id="orderComp"></select></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td valign="top" width="5%">
					<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
							onclick="toggleOption(this)">
						Options: 
					</button>
				</td>
				<td colspan="4" align="left" width="95%">
					<div id="options" style="float:left; width:100%"></div>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					<label>Remark: </label>
				</td>
				<td colspan="4" width="85%"><textarea cols="35" rows="3" id="orderRemark"></textarea></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="5" align="center">
					<div style="float:left; background-color:yellow;"><label style="font-weight:bold">Total Price: <span class="totalCur"></span>&nbsp;<span class="totalPriceShow"></span><span class="totalPrice" style="visibility:hidden;"></span></label></div>
				</td>
			</tr>
		</table>
		<br/>
		<br/>
		<br/>
		<table class="summaryHidden" style="border-width:1px; border-style:outset; width:95%;">
			<tr>
				<td><label><b>Summary: </b></label></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr class="order">
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
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr class="order">
				<td>
					<label class="text">Order Type:&nbsp;</label>
					<label id="orderType" class="text"></label>
					<select id="fdOrderType" style="width:150px; height:30px; font-size:21px;">
						<option value="I">Inpatient</option>
						<option value="P">Low Charge (Free)</option>
						<option value="L">Low Charge (50%)</option>
						<option value="G">Guest</option>
						<option value="S">Supplement</option>
						<option value="W">Walkin</option>
					</select>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr class="order">
				<td colspan="2">
					<div style="float:left">
						<div style="float:left">
							<label class="text">Serve Time:&nbsp;</label><label class="text orderHidden">(Please click one of the boxes below)</label>
							<label id="selectedTime" class="text"></label>
						</div>
						<div id="serveTimeContent">
							<br/>
							<br/>
							<div class="serveTime" style="float:left">
								<input class="now" type="radio" name="time" value="now" style="width:30px; height:30px;"/><label class="text now"><b>Now</b></label>
							</div>
							<br/>
							<br/>
							<br/>
							<div class="serveTime" style="float:left">
								<input type="radio" name="time" value="now30" style="width:30px; height:30px;"/><label class="text"><b>Now + 30 mins</b></label>
								<label class="text selected30Time"></label>
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
											for( int i = 7; i < 21; i++) {
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
					</div>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr class="orderHidden">
				<td></td>
				<td style="width:45%;"><label>Item</label></td>
				<td style="width:25%;"><label>Quantity</label></td>
				<td style="width:20%;"><label>Price</label></td>
			</tr>
			<tr><td colspan="4"><hr/></td></tr>
			<tr id="indicator"><td>&nbsp;</td></tr>
			<tr class="orderHidden order">
				<td class="summaryHidden"></td>
				<td></td>
				<td><label>Total: </label></td>
				<td><span class="totalCur"></span>&nbsp;<span class="totalPriceShow"></span><span class="totalPrice" style="visibility:hidden;"></span></td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<button onclick="alertMsgEvent('open', 'Confirm to submit order?', 'confirm', 'orderInfo')" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
						Submit
					</button>
				</td>
			</tr>
		</table>
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>
<script>
	var currentMenu = "menu";
	var currentOptCode = new Array();
	var allOrder = new Array();
	var currentSetOrder = new Array();
	var time = new Date();
	var time30 = new Date();
	time30.setMinutes(time30.getMinutes() + 30);
	var h;
	var m;
	var edit = $('input[name=edit]').val() == 'true';
	var orderNo = $('input[name=orderNo]').val();
	var isLCB = $('input[name=isLCB]').val() == 'true';

	$(document).ready(function() {
		$('div.orderBtn').css('left', $(document).width()-$('div.orderBtn').find('button').width()-50);
		scrollEvent();
		
		$('button.logout').click(function() {
			window.open('../foodtw/logout.jsp', '_self');
		});
		$('button.backList').click(function() {
			window.open('../foodtw/patlist.jsp?accessWardList=<%=accessWardList%>', '_self');
		});
		$('button.backWard').click(function() {
			window.open('../foodtw/patlist.jsp?ward=<%=wardNo%>&bed=<%=bed %>&room=<%=romCode%>&accessWardList=<%=accessWardList%>', '_self');
		});
		//getFoodCategory('select#foodCategory');
		selectFilterBtnEvent();
		var today = new Date();
		$('button.filter:eq('+(today.getDay()+3)+')').trigger('click');
		selectMenuBtnEvent();
		$('div#options').toggle();
		
		if(edit) {
			$.ajax ({
				url: "getFoodOrder.jsp?callback=?",
				data: "orderNo="+orderNo,
				dataType: "jsonp",
				cache: false,
				async: false,
				success: function(values){
					loadOrder(values);
				},
				error: function(x, s, e) {
					alert("error");
				}
			});
		}
		
		$('div.updateRmkDialog').css('top', $('.updateRmkLoc').position().top+((navigator.appVersion.indexOf("MSIE") != -1)?-10:15));
		$('div.updateRmkDialog').css('left', $('.updateRmkLoc').find('td:first').width()+$('.updateRmkLoc').find('select').width()+280);
		if(isLCB) {
			$('.now').hide();
			$('div.updateRmkDialog').hide();
			$('.mSet').css('display', 'none');
			$('.others').css('display', 'none');
			$('.menuBtnSet').css('display', 'none');
		} else {
			$('div.updateRmkDialog').show();
			$('.menu').css('display', '');
			$('.others').css('display', '');
			$('.menuBtnSet').css('display', '');
		}
		selectRemarkDateEvent();		
		selectServeTypeEvent();
		selectTimeNowEvent();
		selectTimeNow30Event();
		clickFoodIngredientsEvent();
		
		$('input.remarkDay:checked').trigger('click');
		
		//alert low cost bed
		//alert($('input[name=acmCode]').val())
		if ($('input[name=acmCode]').val() == 'L') {
			alertMsgEvent('open', 'Patient in low-cost bed<br/>病人屬於低消費床號。', 'normal');
		}
	});
	
	function loadOrder(orders) {
		$.each(orders, function(i, all) {
			if(i == 'serveDate') {
				if(all.length > 0) {
					time = new Date();
					var temp = all.split('\/');
					
					if(temp[1].indexOf("0") == 0) {
						temp[1] = temp[1].substring(1);
					}
					
					if(temp[0].indexOf("0") == 0) {
						temp[0] = temp[0].substring(1);
					}
					
					time.setFullYear(parseInt(temp[2]), parseInt(temp[1])-1, parseInt(temp[0]));
				}
			}
			else if(i == 'serveTime') {
				if(all == 'now') {
					time = all;
				}
				else {
					var temp = all.split(':');
					h = temp[0];
					m = temp[1];
				}
			}
			else if(i == 'serveType') {
				$('select#fdServeType').find('option[value='+all+']').attr('selected', true);
			}
			else if (i == 'orderType') {
				$('select#fdOrderType').find('option[value='+all+']').attr('selected', true);
			}
			else if(i == 'allOrder') {
				$.each(all, function(k, order) {
					var temp = {};
					if(order['itemMenuType'] == "M") {
						temp['uuid'] = jQuery.uidGen({prefix: 'M',mode:'sequential'});
						temp['itemMenuType'] = "M";
						temp['itemName'] = order['itemName'];
						temp['itemPrice'] = order['itemPrice'];
						temp['amount'] = order['amount'];
						if(order['itemRmk']) {
							temp['itemRmk'] = order['itemRmk'];
						}
						else {
							temp['itemRmk'] = "";
						}
						if(order['itemOpt']) {
							var tempOpt = new Array();
							$.each(order['itemOpt'], function(l, opt){
								if(opt) {
									tempOpt.splice(tempOpt.length, 0, opt);
								}
							});
							temp['itemOpt'] = tempOpt;
						}
						else {
							temp['itemOpt'] = new Array();
						}
						showOrder(temp);
					}
					else if(order['itemMenuType'] == "S") {
						temp['uuid'] = jQuery.uidGen({prefix: 'S',mode:'sequential'});
						temp['itemMenuType'] = "S";
						temp['itemName'] = order['itemName'];
						temp['itemPrice'] = order['itemPrice'];
						temp['amount'] = order['amount'];
						temp['itemOpt'] = order['itemOpt'];
						
						var allSubItems = new Array();
						$.each(order['subItem'], function(j, v) {
							var subItem = {};
							
							subItem['parentSet'] = temp['uuid'];
							subItem['itemMenuType'] = "I";
							subItem['itemName'] = v['itemName'];
							subItem['itemPrice'] = v['itemPrice'];
							subItem['amount'] = v['amount'];
							if(v['itemOpt']) {
								var tempOpt = new Array();
								$.each(v['itemOpt'], function(l, opt){
									if(opt) {
										tempOpt.splice(tempOpt.length, 0, opt);
									}
								});
								subItem['itemOpt'] = tempOpt;
							}
							else {
								subItem['itemOpt'] = new Array();
							}
							if(v['itemRmk']) {
								subItem['itemRmk'] = v['itemRmk'];
							}
							else {
								subItem['itemRmk'] = "";
							}
							if(v['itemExtraCurr']) {
								subItem['itemExtraCurr'] = v['itemExtraCurr'];
							}
							if(v['itemExtraPrice']) {
								subItem['itemExtraPrice'] = v['itemExtraPrice'];
							}
							
							allOrder.splice(allOrder.length, 0, subItem);
							allSubItems[allSubItems.length] = subItem;
						});
						showOrder(temp, allSubItems);
					}
					allOrder.splice(allOrder.length, 0, temp);
				});
			}
		});
		selectServTimeEvent();
	}

//************************Start - event************************//
	function toggleOption(dom) {
		if($(dom).hasClass('selected')) {
			$(dom).removeClass('selected');
		}
		else {
			$(dom).addClass('selected');
		}
		$('div#options').toggle();
	}
	
	function selectFilterBtnEvent() {
		$('button.filter').click(function() {
			$('button.filter.selected').removeClass('selected');
			$(this).addClass('selected');
			if(currentMenu == "menu") {
				getFoodCategory('select#foodCategory', $(this).attr('key'));
			}
			else {
				getSets('select#setMenu', $(this).attr('key'));
			}
			
			if(!isNaN($(this).attr('key'))) {
				var today = new Date();
				var hour = today.getHours();
				var minute = today.getMinutes();
				var type = "";
				
				if(hour <= 11) {
					if(minute < 30 || hour < 11) {
						//breakfast
						type = "L";
					}
					else {
						//lunch
						type = "D";
					}
				}
				else if(hour <= 15) {
					if(minute < 30 || hour < 15) {
						//lunch
						type = "D";
					}
					else {
						//snack
						type = "D";
					}
				}
				else if(hour <= 17) {
					if(minute < 30 || hour < 17) {
						//snack
						type = "D";
					}
					else {
						//dinner
						type = "B";
					}
				}
				else {
					//dinner
					type = "B";
				}
				
				if(currentMenu == "menu") {
					if(type == "B") {
						$('select#foodCategory')[0].selectedIndex = 0;
					}
					else if(type == "L") {
						$('select#foodCategory')[0].selectedIndex = 1;
					}
					else if(type == "D") {
						$('select#foodCategory')[0].selectedIndex = 2;
					}
					$('select#foodCategory').trigger('change');
				}
				else {
					if(type == "B" || type == "L") {
						$('select#setMenu')[0].selectedIndex = 0;
					}
					else if(type == "D") {
						$('select#setMenu')[0].selectedIndex = 2;
					}
					$('select#setMenu').trigger('change');
				}
			}
		});
	}
	
	function scrollEvent() {
		$(window).scroll(function () { 
				$('div.orderBtn').css('top', $(window).scrollTop()+$(window).height()-$('div.orderBtn').find('button').height()-30);
		   }).trigger('scroll');
	}
	
	function selectServTimeEvent() {
		$("input#datepicker").datepicker('destroy');
		$('input:radio[name="time"]').unbind('click');
		
		$("input#datepicker").datepicker({
			//buttonImage: "../images/calendar.jpg",
			//buttonImageOnly: true,
			//showOn: "button",
			onSelect: function(dateText, inst) {
				$("#ui-datepicker-div").hide();
				var selectDate = new Date();
				selectDate.setFullYear(inst.selectedYear, inst.selectedMonth, inst.selectedDay);
				
				time = selectDate;
			  }
		});
		$("#ui-datepicker-div").css('z-index', 13);
		
		if(time == "now") {
			$('input:radio[value="now"]').attr('checked', true);
			$('#serveHour').attr('disabled', true);
			$('#serveMin').attr('disabled', true);
			$('#serveHour option[value=null]').attr("selected", true);
			$('#serveMin option[value=null]').attr("selected", true);
		}else if(time == "now30") {
				$('input:radio[value="now30"]').attr('checked', true);
				$('#serveHour').attr('disabled', true);
				$('#serveMin').attr('disabled', true);
				$('#serveHour option[value=null]').attr("selected", true);
				$('#serveMin option[value=null]').attr("selected", true);
		}else if(time == "custom" || time != null) {
			//$("input#datepicker").datepicker("setDate", time);
			$("input#datepicker").val(time.getDate()+'/'+(time.getMonth()+1)+'/'+time.getFullYear());
			$('#serveHour option[value='+h+']').attr("selected", true);
			$('#serveMin option[value='+m+']').attr("selected", true);
			$('input:radio[value="custom"]').attr('checked', true);
			$('#serveHour').attr('disabled', false);
			$('#serveMin').attr('disabled', false);
			$("#ui-datepicker-div").hide();
		}else {
			$('#serveHour').attr('disabled', true);
			$('#serveMin').attr('disabled', true);
		}
		
		$('input:radio[name="time"]').each(function() {
			$(this).click(function() {
				if($(this).val() == "now") {
					time = $(this).val();
					$('#serveHour').attr('disabled', true);
					$('#serveMin').attr('disabled', true);
				} else if($(this).val() == "now30") {
					time = $(this).val();
					$('#serveHour').attr('disabled', true);
					$('#serveMin').attr('disabled', true); 
				} else {
					time = "custom";
					$('#serveHour').attr('disabled', false);
					$('#serveMin').attr('disabled', false);
					$("input#datepicker").focus();
				}
				return;
			});
		});
		
		$('#serveHour').change(function() {
			$('option:selected', this).each(function(){
		        	h = $(this).val();
		        	if(h == 7 || h == 19) {
		        		$('#serveMin')[0].selectedIndex = 3;
		        		$('#serveMin').trigger('change');
		        	}
		    	});
			});
		$('#serveMin').change(function() {
			$('option:selected', this).each(function(){
		        	m = $(this).val();
		        	if((h == 19 && m > 30)) {
		        		$('#serveMin')[0].selectedIndex = 3;
		        		$('#serveMin').trigger('change');
		        	}
		    	});
			});
	}
	
	function selectMenuBtnEvent() {
		$('.menuBtn').click(function() {
			$('.menuBtn.selected').removeClass('selected');
			$(this).addClass('selected');
			var today = new Date();
			if($(this).html() == "Menu") {
				currentMenu = "menu";
			}
			else {
				currentMenu = "set";
			}
			//selecting filter button
			$('button.filter:eq('+(today.getDay()+3)+')').trigger('click');
			clickFoodIngredientsEvent();
		});
	}
	
	function clickFoodIngredientsEvent() {
		$('.ingredients').unbind('click');
		$('.ingredients').click(function() {
			var left = $(this).position().left-($('div#fdIngredients').width()/2);
			if (left < 0) left = 5;
			$('div#fdIngredients').css('left', left);
			$('div#fdIngredients').css('top', $(this).position().top+$(this).height()+10);
			
			if ($("div#fdIngredients").is(':hidden')) {
				$('div#fdIngredients').show();
			}
			else {
				$('div#fdIngredients').hide();
			}
		});
	}
	
	function checkFoodOptEvent() {
		$('.foodOpt').each(function() {
			if(currentOptCode.length > 0) {
				for(var i = 0; i < currentOptCode.length; i++) {
					if(currentOptCode[i].split('#')[2] == $(this).val()) {
						$(this).attr('checked', true);
					}
				}
			}
		});
		
		$('.foodOpt').each(function() {
			$(this).click(function() {
				var compID = $('select#orderComp').find('option:selected').val();
				var added = false;
				var addIndex = 0;
				
				var max = parseInt($('select#orderComp').find('option:selected').attr('maxchoice'));
				var addPriceIn;
				var addPricePlus;

				if(!max && max != 0) {
					max = 999;
				}
				
				addPriceIn = parseInt($(this).attr('priceIn'));
				addPricePlus = parseInt($(this).attr('pricePlus'));
				
				for(var i = 0; i < currentOptCode.length; i++) {
					if(currentOptCode[i].indexOf(compID+'#'+max+'#'+$(this).val()+'#'+$(this).parent().next().html()) > -1) {
						currentOptCode.splice(i, 1);
						added = true;
					}
					if(currentOptCode[i].indexOf(compID) > -1) {
						addIndex = i+1;
					}
				}
				
				if(!added) {
					currentOptCode.splice(addIndex, 0, compID+'#'+max+'#'+$(this).val()+'#'+$(this).parent().next().html()+'#'+addPriceIn+'#'+addPricePlus);
					//currentOptCode[currentOptCode.length] = compID+'#'+$(this).val()+'#'+$(this).parent().next().html();
				}
				
				//$.dump(currentOptCode)
			});
		});
	}
	
	function clickChoiceEvent(target, type) {
		$(target).click(function() {
			if(type == 'comp') {
				$('select#setComp')
					.find('option[index='+$(this).attr('index')+']').attr('selected', true);
				$('select#setComp').trigger('change');
			}
			else if(type == 'orderMenu') {
				$('select#setOrderMenu')
					.find('option[index='+$(this).attr('index')+']').attr('selected', true);
				$('select#setOrderMenu').trigger('change');
			}
		});
	}
	
	function selectChangeEvent(target, method) {
		$(target).unbind('change');
		$(target).change(function() {
			$('option:selected', this).each(function(){
				if(method == 'setMenu') {
					//only for currentMenu == set
					$('td#setItemRecord').html('');
					$("select#setComp").css('display', 'none');
					getItemComp("select#setComp", $(this).val(), true, false,isLCB);
					selectChangeEvent("select#setComp", 'category');
					getItemComp("div#setCompDiv", $(this).val(), true, true,isLCB);
					clickChoiceEvent('div#setCompDiv input', 'comp');
					$('div#setCompDiv input:first').attr('checked', true).trigger('click');
				}
				else if(method == 'category') {
					$("select#orderComp").html('');
					$("div#options").html('');
					if(currentMenu == 'menu') {
						$("select#orderMenu").html('');
						getMenuItem('select#orderMenu', $(this).val(), null, false);
						selectChangeEvent("select#orderMenu", 'orderMenu');
					}else {
						$("select#setOrderMenu").html('');
						$("select#setOrderMenu").css('display', 'none');
						getMenuItem('select#setOrderMenu', "set", $(this).val(), false);
						selectChangeEvent("select#setOrderMenu", 'orderMenu');
						getMenuItem('div#setOrderMenuDiv', "set", $(this).val(), true);
						clickChoiceEvent('div#setOrderMenuDiv input', 'orderMenu');
						$('div#setOrderMenuDiv input:first').attr('checked', true).trigger('click');
					}
				}
				else if(method == 'orderMenu') {
					//for both set and menu
					getItemComp("select#orderComp", $(this).val(), false, false,isLCB);
					selectChangeEvent("select#orderComp", 'comp');
					getFsdIngredients($(this).val());
				}
				else if(method == 'comp') {
					//for both set and menu
					getItemOpt("div#options", $(this).val(), 
							(currentMenu=="set")?
										$('select#setOrderMenu option:selected').val():
											$('select#orderMenu option:selected').val());
				}
		    });
		}).trigger('change');
	}
	
	function getFsdIngredients(itemCode) {
		$.ajax({
			type: "GET",
			url: "getFoodIngredients.jsp",
			async: false,
			contentType: "UTF-8",//"UTF-8", 
			data: "itemCode="+itemCode,
			success: function(values){
				if ($.trim(values).length > 0) {
					$('div#fdIngredients').find('#fdIngredients-content').html(values);
				}
				else {
					$('div#fdIngredients').find('#fdIngredients-content').html('Ingredient is not found');
				}
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getFsdIngredients"');
				hideLoadingBox('body', 500);
			}
		});//$.ajax
	}
	
	function spinnerEvent() {
		$('button.quantityBtn').unbind('click');
		$('button.quantityBtn').click(function() {
			var quantityInput = $(this).parent().find('.quantity-input');
			var curQuan = quantityInput.val();
			
			if($(this).attr('id') == 'spinner_add') {
				quantityInput.val(parseInt(quantityInput.val()) + 1);
			}else if($(this).attr('id') == 'spinner_sub') {
				quantityInput.val(parseInt(quantityInput.val()) - 1);
			}
			
			if(parseInt(quantityInput.val()) == 0) {
				quantityInput.val(1);
			}
			modifiyOrderQuantity($(this).parent().attr('uuid'), quantityInput.val());
			
			var curPrice = $('.itemPrice[uuid='+$(this).parent().attr('uuid')+']').html();

			$('label[uuid='+$(this).parent().attr('uuid')+']').each(function() {
				if($(this).hasClass('itemPrice')) {
					$(this).html((parseInt(curPrice)/curQuan)*quantityInput.val());
					var total = parseInt($('span.totalPrice').html())-
								parseInt(curPrice)+
								(parseInt(curPrice)/curQuan)*quantityInput.val();
					$('span.totalPrice').html(total);
					$('span.totalPriceShow').html(total<0?0:total);
				}
				else if($(this).hasClass('quantity')) {
					$(this).html(quantityInput.val());
				}
			});
		});
	}
	
	function alertMsgEvent(action, msg, btnType, extraInfo) {
		if(action == 'open') {
			$('div#alertMsgDialog').css('left', ($(window).width()/2)-($('div#alertMsgDialog').width()/2));
			$('div#alertMsgDialog').css('top', $(window).scrollTop()+($(window).height()/2)-($('div#alertMsgDialog').height()/2));
			$('div#overlay').css('height', $(document).height());
			$('div#overlay').css('width', $(document).width());
			
			$('span#alertMsg').html(msg);
			if(extraInfo) {
				$('div#alertMsgDialog').css('height', '180px');
				if(extraInfo == 'orderInfo') {
					$('span#alertMsg').append('<br/>');
					$('span#alertMsg').append('Serve Date: '+$("input#datepicker").val());
					$('span#alertMsg').append('<br/>');
					if(time == "now") {
						$('span#alertMsg').append('Serve Time: Now');
					} else if(time == "now30") {
						$('span#alertMsg').append('Serve Time: Now + 30 Minutes');
					} else {
						$('span#alertMsg').append('Serve Time: '+$('#serveHour option:selected').val()+':'+
								$('#serveMin option:selected').val());
					}
				}
			}
			else {
				$('div#alertMsgDialog').css('height', '150px');
			}
			
			if(btnType == 'confirm') {
				$('div#alerResponetBtn').html(
					'<button class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" '	+
						'onclick="submitOrder()" style="width:80px;">'+
						'Yes' +
					'</button>' +
					'<button class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" '	+
						'onclick="alertMsgEvent(\'close\')" style="width:80px;">'+
						'No' +
					'</button>'
				);
			}
			else if(btnType == 'normal') {
				$('div#alerResponetBtn').html(
					'<button class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" '	+
						'onclick="alertMsgEvent(\'close\')" style="width:80px;">'+
						'OK' +
					'</button>'
				);
			}
			
			$('div#alertMsgDialog').css('display', '');
			$('div#overlay').css('display', '');
		}
		else if(action == 'close') {
			$('div#alertMsgDialog').css('display', 'none');
			$('div#overlay').css('display', 'none');
		}
	}
	
	function selectTimeNow30Event() {
		$('input:radio[value="now30"]').unbind('click');
		$('input:radio[value="now30"]').click(function(){
			time="now30";
			var temp = new Date();
			temp.setMinutes(temp.getMinutes()+30);
			var tempH = temp.getHours();
			var tempM = temp.getMinutes();
			$('.selected30Time').html(' ( Time:'+tempH+':'+((tempM >= 10) ? tempM : "0" + tempM)+' ) ');
			selectTimeLayoutAction(temp,tempH, tempM);
		});
	}
	
	function selectTimeNowEvent() {
		$('input:radio[value="now"]').unbind('click');
		$('input:radio[value="now"]').click(function() {
			time="now";
			var temp = new Date();
			var tempH = temp.getHours();
			var tempM = temp.getMinutes();
			selectTimeLayoutAction(temp,tempH, tempM);
		});
	}
	
	function selectTimeLayoutAction(temp,tempH, tempM) {
		if((tempH >= 7) && (tempH <= 11)) {
			if(tempH > 7 && tempH < 11) {
				$('select#fdServeType option[value="B"]').attr('selected', true);
			}else if(tempH == 7) {
				//if(tempM >= 30) {
					$('select#fdServeType option[value="B"]').attr('selected', true);
				//}
			}else if(tempH == 11) {
				if(tempM < 30) {
					$('select#fdServeType option[value="B"]').attr('selected', true);
				}
			}
		}
		if ((tempH >= 11) && (tempH <= 15)){
			if(tempH > 11 && tempH < 15) {
				$('select#fdServeType option[value="L"]').attr('selected', true);
			}else if(tempH == 11) {
				if(tempM >= 45) {
					$('select#fdServeType option[value="L"]').attr('selected', true);
				}
			}else if(tempH == 15) {
				if(tempM < 30) {
					$('select#fdServeType option[value="L"]').attr('selected', true);
				}
			}
		}
		if ((tempH >= 15) && (tempH <= 17)){
			if(tempH > 15 && tempH < 17) {
				$('select#fdServeType option[value="S"]').attr('selected', true);
			}else if(tempH == 15) {
				if(tempM >= 30) {
					$('select#fdServeType option[value="S"]').attr('selected', true);
				}
			}else if(tempH == 17) {
				if(tempM < 30) {
					$('select#fdServeType option[value="S"]').attr('selected', true);
				}
			}
		}
		if ((tempH >= 17) && (tempH <= 19)){
			if(tempH > 17 && tempH < 19) {
				$('select#fdServeType option[value="D"]').attr('selected', true);
			}else if(tempH == 17) {
				if(tempM >= 30) {
					$('select#fdServeType option[value="D"]').attr('selected', true);
				}
			}else if(tempH == 19) {
				if(tempM <= 30) {
					$('select#fdServeType option[value="D"]').attr('selected', true);
				}
			}
		}
	}
	
	function selectServeTypeEvent() {
		$('select#fdServeType').unbind('change');
		$('#fdServeType').change(function() {
			$('option:selected', this).each(function(){
				$('input:radio[value="custom"]').attr('checked', true);

				var st = $(this).val();
				if(st == "B") {
					time = new Date();
					time.setDate(time.getDate()+1);
					h = '07';
				}
				else if(st == "L") {
					time = new Date();
					h = '11';
				}
				else if(st == "S") {
					time = new Date();
					h = '15';
				}
				else if(st == "D") {
					time = new Date();
					h = '17';
				}
				m = 30;
				if(st == "L") {
					m = 45;
				}
				
				$("input#datepicker").val(time.getDate()+'/'+(time.getMonth()+1)+'/'+time.getFullYear());
				$('#serveHour option[value='+h+']').attr("selected", true);
				$('#serveMin option[value='+m+']').attr("selected", true);
				$('#serveHour').attr('disabled', false);
				$('#serveMin').attr('disabled', false);
				$("#ui-datepicker-div").hide();
			});
		});
	}
//************************End - event************************//
	
	function addOrder() {
		var temp = {};
		var currentItem;
		var added = false;
		
		if(currentMenu == "menu") {
			currentItem = $('select#orderMenu option:selected');
			
			temp['uuid'] = jQuery.uidGen({prefix: 'M',mode:'sequential'});
			temp['itemMenuType'] = "M";
			temp['itemName'] = currentItem.val()+'_'+currentItem.html();
			temp['itemPrice'] = currentItem.attr('currency')+" "+currentItem.attr('unitPrice');
			temp['itemOpt'] = currentOptCode;
			temp['itemRmk'] = $('textarea#orderRemark').val();
			temp['amount'] = 1;
				
			currentOptCode = new Array();
			$('.foodOpt').attr('checked', false);
			$('textarea#orderRemark').val('');
			
			if(allOrder.splice(allOrder.length, 0, temp) && showOrder(temp)) {
				added = true;
			}
		}
		else {
			if($('td#setItemRecord').children().length > 0) {
				currentItem = $('select#setMenu option:selected');
				var allSubItems = new Array();
				
				temp['uuid'] = jQuery.uidGen({prefix: 'S',mode:'sequential'});
				temp['itemMenuType'] = "S";
				temp['itemName'] = currentItem.val()+'_'+currentItem.html();
				temp['itemPrice'] = currentItem.attr('currency')+" "+currentItem.attr('unitPrice');
				temp['amount'] = 1;
				temp['itemOpt'] = '';
				
				$.each($('td#setItemRecord').find('div'), function(index, value) {
					var subItem = {};
					var thisOpt = new Array();
					var iname = '';
					var opt = '';
					subItem['parentSet'] = temp['uuid'];
					subItem['itemMenuType'] = "I";
					subItem['itemPrice'] = 'HKD 0';
					subItem['amount'] = 1;
					$.each($(value).find('label'), function(i, v) {
						if($(v).attr('class') == 'setOrderMenu') {
							subItem['itemName'] = $(v).attr('id')+'_'+$(v).html();
							iname = $(v).attr('id');
						}
						else if($(v).attr('class') == 'setOpt') {
							thisOpt[thisOpt.length] = $(v).attr('id');
							opt += '.'+$(v).attr('id').split('#')[2].split('@')[1];
						}
						else if($(v).attr('class') == 'setRmk') {
							subItem['itemRmk'] = $(v).html();
							if($(v).html().length > 0)
								opt += '.'+$(v).html();
						}
						else if($(v).attr('class') == 'extraCurr') {
							subItem['itemExtraCurr'] = $(v).html();
						}
						else if($(v).attr('class') == 'extraPrice') {
							subItem['itemExtraPrice'] = $(v).html();
						}
					});
					subItem['itemOpt'] = thisOpt;
					temp['itemOpt'] += ((index > 0)?"+":"")+iname+opt;
					allOrder.splice(allOrder.length, 0, subItem);
					allSubItems[allSubItems.length] = subItem;
				});
				//$.dump(temp)
				//$.dump(allSubItems)
				if(allOrder.splice(allOrder.length, 0, temp) && showOrder(temp, allSubItems)) {
					added = true;
				}
			}
		}
		
		if(added) {
			alertMsgEvent('open', 'Added Item(s).', 'normal');
		}
		selectTimeNowEvent();
	}
	
	function cancelOrder() {
		$('.cancel').unbind('click');
		$('.cancel').click(function() {
			var start = parseInt($(this).attr('id'));
			var uuid = $(this).attr('uuid');
			$.each(allOrder, function(i, v) {
				if(v['uuid']) {
					if(uuid == v['uuid']) {
						start = i;
					}
				}
			});
			var len = parseInt($(this).attr('length'));
			var uuid = $(this).attr('uuid');
			for(var i  = start; len > 0; i--, len--) {
				allOrder.splice(i, 1);
			}
			
			var total = (parseInt($('span.totalPrice').html()))-
							parseInt($('tr#'+uuid).find('.itemPrice').html());
			$('span.totalPrice').html(total);
			$('span.totalPriceShow').html(total<0?0:total);
			$('tr#'+uuid).remove();
		});
	}
	
	function showOrder(order, subItems) {
		var opt = order.itemOpt;
		var displayOpt = "";
		var content = "";
		var len = 0;
		var extraCurr = "";
		var extraPrice = 0;
		var optExtraPrice = 0;
		var curCompCode = "";
		var maxChoice;
		var compOptChoice = 0;
		
		if(subItems) {
			$.each(subItems, function(index, value) {
				displayOpt += value.itemName.split('_')[1];
				if(value.itemExtraPrice) {
					displayOpt += ' '+value.itemExtraCurr+' '+value.itemExtraPrice+'<br/>';
					extraCurr = value.itemExtraCurr;
					extraPrice += parseFloat(value.itemExtraPrice);
				}
				else {
					displayOpt += '<br/>';
				}
				$.each(value.itemOpt, function(i, v) {
					displayOpt += '- '+v.split('#')[3]+'<br/>';
					if(curCompCode != v.split('#')[0]) {
						curCompCode = v.split('#')[0];
						maxChoice = v.split('#')[1];
						compOptChoice = 0;
					}
					
					compOptChoice++;
					if(compOptChoice <= maxChoice) {
						optExtraPrice += parseInt(v.split('#')[4]);
					}
					else {
						optExtraPrice += parseInt(v.split('#')[5]);
					}
				});
				if(value.itemRmk.length > 0) {
					displayOpt += '- Remark: '+value.itemRmk+'<br/>';
				}
			});
			len = subItems.length+1;
		}
		else {
			for(var j = 0; j < opt.length; j++) {
				displayOpt += opt[j].split('#')[3]+'<br/>';
				
				if(curCompCode != opt[j].split('#')[0]) {
					curCompCode = opt[j].split('#')[0];
					maxChoice = opt[j].split('#')[1];
					compOptChoice = 0;
				}
				
				compOptChoice++;
				
				if(compOptChoice <= maxChoice) {
					optExtraPrice += parseInt(opt[j].split('#')[4]);
				}
				else {
					optExtraPrice += parseInt(opt[j].split('#')[5]);
				}
			} 	
			if(order.itemRmk.length > 0) {
				displayOpt += 'Remark: '+order.itemRmk;
			}
			len = 1;
		}
		var cur = order.itemPrice.split(' ')[0];
		var price = (parseFloat(order.itemPrice.split(' ')[1])+(extraPrice>0?extraPrice:0)+(optExtraPrice>0?optExtraPrice:0)) * order.amount;
		
		content = '<tr id="'+ order.uuid +'" class="order">' +
					'<td class="summaryHidden"><button uuid="'+ order.uuid +'" length = "'+len+'" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only cancel" id = "'+(allOrder.length-1)+'" style = "float:left"><label>Cancel</label></button></td>'+
					'<td>'+
						'<div style = "float:left"><label id = "itemName" class="text"><b>'+order.itemName.split('_')[1]+' x '+
						'<label class="orderDisplay quantity text" uuid="'+ order.uuid +'" style="display:none;">1</label>' +
						'</b></label></div></td>'+
						//quantity
					'<td>' +  
						'<div class="quantity-container orderHidden" uuid="'+ order.uuid +'"><input style="font-size:21px; width:50px;" class="quantity-input" value="'+order.amount+'"/>' +
						'<button id="spinner_add" class = "quantityBtn ui-button ui-widget ui-state-default ui-corner-all"><label class="text">+</label></button>' +
						'<button id="spinner_sub" class = "quantityBtn ui-button ui-widget ui-state-default ui-corner-all"><label class="text">-</label></button>' +'</div>' + '</td>' +
						/**********/
					'<td><label class="text">&nbsp;'+cur+'</label> <label uuid="'+ order.uuid +'" class="text itemPrice">'+price+'</label></td>'+
				'</tr>' +
				'<tr id="'+ order.uuid +'" class="order">' +
					'<td class="summaryHidden">&nbsp;</td>' +
					'<td><label id = "itemOpt" class="text">'+displayOpt+'</label></td>' +
					'<td>&nbsp;</td>' +
					'<td>&nbsp;</td>' +
				'</tr>';
		
		$('tr#indicator').before(content);
		$('span.totalCur').html(cur);
		
		var total = (($('span.totalPrice').html().length<=0)?0:parseInt($('span.totalPrice').html()))+price;
		$('span.totalPrice').html(total);
		$('span.totalPriceShow').html(total<0?0:total);
		
		cancelOrder();
		spinnerEvent();
		return true;
	}
	
	function recordSetItem() {
		var itemId = $('select#setComp option:selected').val()+'_'+$('select#setComp option:selected')[0].index;
		$('.'+itemId).remove();
		
		var extraPrice = $('select#setOrderMenu option:selected').attr('extraPrice');
		var extraCurr = $('select#setOrderMenu option:selected').attr('extraCurr');
		
		content = "<div class='"+itemId+"'>"+
					"<label class='setComp' id='"+$('select#setComp option:selected').val()+"'><b>"+$('select#setComp option:selected').html()+":&nbsp;&nbsp;&nbsp;&nbsp;</b></label><br/>"+
					"<label class='setOrderMenu' id='"+$('select#setOrderMenu option:selected').val()+"'>"+$('select#setOrderMenu option:selected').html()+"</label>"+
					(extraPrice.length>0?(
						" <label class='extraCurr'>"+extraCurr+"</label> "+
						"<label class='extraPrice'>"+extraPrice+"</label>"):"");
					
		$.each(currentOptCode, function(index, value){
			content += "+ <label class='setOpt' id='"+value+"'>"+value.split('#')[3]+"</label>";
		});
			
		if($('textarea#orderRemark').val().length > 0) 
			content += "+";
		content += "<label class='setRmk'>"+$('textarea#orderRemark').val()+"</label>";
		content += "</div><br class='"+itemId+"'/>";
		
		$('td#setItemRecord').append(content);
	}
	
	function submitOrder() {
		$('div#alertMsgDialog').css('display', 'none');
		showLoadingBox('body', 500, $(window).scrollTop());
		var serveType = $('select#fdServeType option:selected').val();
		var orderType = $('select#fdOrderType option:selected').val();

		if(serveType == "null") {
			alert("Please choose a Serve Type.");
			hideLoadingBox('body', 500);
			alertMsgEvent('close');
			return;
		}
		
		if(time == null) {
			alert("Please choose Serve Time");
			hideLoadingBox('body', 500);
			alertMsgEvent('close');
			return;	
		} else if(((h == null || h == "null") || (m == null || m == "null")) && time !== "now" && time !== "now30") {
			alert("Please choose Serve Time");
			hideLoadingBox('body', 500);
			alertMsgEvent('close');
			return;
		}
		
		if(allOrder.length > 0) {
			//$.dump(allOrder);
			var selectedItemCode = new Array();
			var selectedOptCode = new Array();
			var selectedItemAmount = new Array();
			var selectedMenuType = new Array();
			
			for(var i = 0; i < allOrder.length; i++) {
				selectedMenuType.splice(selectedMenuType.length, 0, allOrder[i].itemMenuType);
				selectedItemCode.splice(selectedItemCode.length, 0, allOrder[i].itemName.split('_')[0]);
				
				var opt = "";
				if(allOrder[i].itemMenuType !== "S") {
					if(allOrder[i].itemOpt.length == 0) {
						if(allOrder[i].itemRmk.length > 0) {
							opt = allOrder[i].itemRmk+".";
						}else {
							opt = "null.";
						}
					}
					else {
						for(var j = 0; j < allOrder[i].itemOpt.length; j++) {
							opt += allOrder[i].itemOpt[j].split('#')[2]+'.';	
						}
						
						if(allOrder[i].itemRmk.length > 0) {
							opt += allOrder[i].itemRmk+".";
						}
					}
					selectedOptCode.splice(selectedOptCode.length, 0, opt.substring(0, opt.length-1));
				}
				else {
					selectedOptCode.splice(selectedOptCode.length, 0, allOrder[i].itemOpt);
				}
				
				selectedItemAmount.splice(selectedItemAmount.length, 0, allOrder[i].amount);
			}
			//alert(selectedItemCode);
			//alert(selectedOptCode);
			//alert(selectedItemAmount);
			//alert(selectedMenuType);
			var param = "";
			if($('input[name=custom]').val() == 'Y') {
				param = '&patNo='+$('input[name=patNo_input]').val()+'&romCode='+$('input[name=room_input]').val() +
							'&bedCode='+$('input[name=bed_input]').val()+'&patName='+$('input[name=patName_input]').val()+
							'&ward='+$('input[name=ward_input]').val()+'&allergy='+$('input[name=allergy_input]').val()+
							'&custom=Y';
			}
			else {
				param = '&patNo='+$('input[name=patNo]').val() + '&romCode='+$('input[name=room]').val() +
							'&bedCode='+$('input[name=bed]').val() + '&regID='+$('input[name=regID]').val() +
							(edit?('&orderNo='+orderNo):'');
			}
				$.ajax({
					type: "GET",
					url: "../patient/foodServicesProcess.jsp",
					async: true,
					contentType: "UTF-8",//"UTF-8", 
					data: "selectedMenuType="+selectedMenuType+
							"&selectedItemCode=" + selectedItemCode +
							'&selectedOptCode=' + encodeURI(selectedOptCode) +
							'&selectedItemAmount=' + selectedItemAmount +'&serveTime=' + 
							(
							(time == "now")?time:
								((time == "now30")?"now30":								
									(((time.getDate()<10)?"0":"")+time.getDate()+'-'+
									((time.getMonth() < 9)?"0":"")+(time.getMonth()+1)+'-'+time.getFullYear())
								)
							) +
							'&serveType=' + serveType + '&h=' + h + '&m=' + m + '&orderType=' + orderType + 
							'&isLCB='+$('input[name=isLCB]').val()+
							param,
					success: function(values){
	
						if(values.indexOf('true') > -1) {
							
							var stype = $('select#fdServeType option:selected').text();
							var otype = $('select#fdOrderType option:selected').text(); 
							var orderTime = 
								((time == "now")?time:
									((time == "now30")?"now+30 minutes":
									(((time.getDate()<10)?"0":"")+time.getDate()+'-'+
									((time.getMonth() < 9)?"0":"")+(time.getMonth()+1)+'-'+time.getFullYear()
										+" "+h+":"+m))
								);
							var content="";
							$.each($('.order'), function(i, v) {
								content += '<tr>'+$(v).html()+'</tr>';
							});
							
							$('table#preview').html('<tbody>'+
									'<tr><td align="center"><img src="../images/food.jpg"><br/><span class="enquiryLabel extraBigText">Food Services</span></td></tr>' +
									'<tr align="center"><td colspan="2">Order Summary</td></tr><tr><td colspan="2"><HR></td></tr>' +
									'<tr><td>&nbsp;</td></tr>' +
									'<tr><td align="center"><span class="bigText"><table>'+content+'<tr><td>&nbsp;</td></tr>'+values+'</table></span></td></tr>' +
									'<tr><td>&nbsp;</td></tr>'+
									'<tr><td align="center"><label class="text"><b>It takes about 15 minutes for delivery.</b></label></td></tr>'+
									'<tr><td align="center"><label class="text"><b>Thank you for your order. Out staff will contact you shortly.</b></label></td></tr>'+
									'<tr><td>&nbsp;</td></tr>'+
									'<tr><td>&nbsp;</td></tr>'+
									'<tr><td>&nbsp;</td></tr>'+'</tbody>'
							);
							
							$('label#selectedType').html(stype);
							$('label#orderType').html(otype);
							$('label#selectedTime').html(orderTime);
							$('select#fdServeType').remove();
							$('select#fdOrderType').remove();
							$('div#serveTimeContent').remove();
							$('.summaryHidden').remove();
							$('.orderHidden').css('display', 'none');
							$('.orderDisplay').css('display', '');
							
							if($('div#orderSuccess').html() == "false") {
								$('table#preview').html('<tbody>'+
										'<tr><td>Order Fail</td></tr>'
										+'</tbody>');
							}
							$(window).scrollTop(0);
						} else if (values.indexOf('false') > -1 && values.indexOf('LCB') > -1) {
							alertMsgEvent('close');
							alert('LCB Patient can only order one order per meal.');
						}else {
							alertMsgEvent('close');
							alert('Error in send order.');
						}
						alertMsgEvent('close');
						hideLoadingBox('body', 500);
					},//success
					error: function(jqXHR, textStatus, errorThrown) {
						alert('Error in "submitOrder"');
						hideLoadingBox('body', 500);
					}
				});//$.ajax
		}
		else {
			alertMsgEvent('close');
			alert("No order");
			hideLoadingBox('body', 500);
			return;
		}
	}
	
	function modifiyOrderQuantity(uuid, amount) {
		for(var i = 0; i < allOrder.length; i++) {
			if(allOrder[i].itemMenuType == "I") {
				if(allOrder[i].parentSet == uuid) {
					allOrder[i].amount = amount;
				}
			}
			else if(allOrder[i].uuid == uuid) {
				allOrder[i].amount = amount;
			}
		}
	}
	
	function selectRemarkDateEvent() {
		$('input.remarkDay').click(function() {
			$(this).parent().parent().find('input.remarkStatus:checked').attr('checked', false);
			var patno = $('input[name=patNo]').val();
			var regID = $('input[name=regID]').val();
			var selection = $(this).val();
			var dom = $(this);
			
			if(patno.length > 0 && regID.length > 0) {
				$.ajax({
					url: 'getFsdOrderRemark.jsp',
					data: 'today='+(selection=='today'?'Y':'N')+
							'&patNo='+patno+'&regID='+regID+'&all=false',
					async: false,
					success: function(values){
						if(values && values.length > 0) {
							var temp = $.trim(values).split('_');
							$('input[name=psID]').val(temp[0]);
							$('input[name=remark]').val(temp[1]);
							dom.parent().parent().find('input.remarkStatus').each(function(i, v) {
								if($(this).val().toUpperCase() == temp[1].toUpperCase()) {
									$(this).attr('checked', true);
								}
							});
						}
					},
					error: function() {
						alert('error');
					}
				});
			}
		});
	}
	
	function updateRemark() {
		showLoadingBox('body', 500);
		if($('input[name=remarkStatus]:checked').length > 0) {
			$.ajax({
				url: '../foodtw/fsdOrderRemarkProcess.jsp?'+
						'patNo='+$('input[name=patNo]').val()+
						'&patName='+$('input[name=patName]').val()+
						'&psID='+$('input[name=psID]').val()+
						'&regID='+$('input[name=regID]').val()+
						'&regType='+$('input[name=regType]').val()+
						'&wardCode='+$('input[name=wardCode]').val()+
						'&romCode='+$('input[name=room]').val()+
						'&bedCode='+$('input[name=bed]').val()+
						'&status='+$('input[name=remarkStatus]:checked').val()+
						'&today='+($('input.remarkDay:checked').val()=='today'?"Y":"N")+
						'&reset=false',
				async: false,
				success: function(values){
					if(values) {
						if(values.indexOf('Fail') > -1) {
							alert("Fail to update of patient# "+patno);
						}
						else {
							$('button.backWard').trigger('click');
						}
					}
				},
				error: function() {
					alert('error');
				}
			});		
		}
		hideLoadingBox('body', 500);
	}
//************************Start - get information by ajax************************//
	function getItemOpt(target, compCode, itemCode) {
		$.ajax({
			type: "GET",
			url: "../ui/fsdItemOptCMB.jsp",
			data: "compCode=" + compCode + "&itemCode=" + itemCode,
			async: false,
			success: function(values){
				$(target).html(values);
				checkFoodOptEvent();
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getItemOpt"');
			}
		});//$.ajax
	}
	
	function getMenuItem(target, categoryID, setComp, format) {
		$.ajax({
			type: "GET",
			url: "../ui/fsdMenuItemCMB.jsp",
			data: "menuType=" + categoryID +'&compCode=' + setComp +
					(format?"&format=radio":""),
			async: false,
			success: function(values){
				$(target).html(values);
				clear();
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				//hideLoadingBox('body', 500);
				alert('Error in "getMenuItem"');
			}
		});//$.ajax
	}
	
	function getItemComp(target, selectedItemCode, isSet, format,isLCB) {
		$.ajax({
			type: "GET",
			url: "../ui/fsdItemCompCMB.jsp",
			data: "menuType=" + ((isSet)?currentMenu:"menu") + "&itemCode=" + selectedItemCode +
					(format?"&format=radio":"")+"&isLCB="+isLCB,
			async: false,
			success: function(values){
				$(target).html(values);
				clear();
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getItemComp"');
			}
		});//$.ajax
	}
	
	function getFoodCategory(target, key) {
		$.ajax({
			type: "GET",
			url: "../ui/fsdMenuCategoryCMB.jsp?filterKey="+key,
			async: false,
			success: function(values){
				currentMenu = "menu";
				$('.set').css('display', 'none');
				 if(!isLCB) {
					$('.mSet').css('display', '');
					$('.menu').css('display', '');
				} 
				clear();
				$(target).html(values);
				selectChangeEvent(target, 'category');
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getFoodCategory"');
			}
		});//$.ajax
	}
	
	function getSets(target, key) {
		$.ajax({
			type: "GET",
			url: "../ui/fsdMenuSetCMB.jsp?filterKey="+key,
			async: false,
			success: function(values){
				currentMenu = "set";
				$('.menu').css('display', 'none');
				$('.set').css('display', '');
				clear();
				$(target).html(values);
				selectChangeEvent(target, 'setMenu');
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getSets"');
			}
		});//$.ajax
	}
//************************End - get information by ajax************************//
	function clear() {
		currentOptCode = new Array();
		$('.foodOpt').attr('checked', false);
		$('textarea#orderRemark').val('');
		selectServTimeEvent();
	}
</script>