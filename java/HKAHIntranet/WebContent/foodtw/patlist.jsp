<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>
<%@page import="org.apache.commons.lang.StringUtils"%>

<% 
UserBean userBean = new UserBean(request);
String ward = null;
String room = null;
String patNo = null;
String bed = null;
StringBuffer sqlStracc = new StringBuffer();
String accessFirstWard = null;

String clientIP = request.getRemoteAddr();
String test = request.getLocalAddr();
String[] accessWard = request.getParameterValues("accessWard");

String accessWardList = request.getParameter("accessWardList");

if (accessWardList == null || "".equals(accessWardList)) {
	accessWardList = PatientDB.getAccessibleWardList(clientIP);
}
if (accessWardList != null && !"".equals(accessWardList) && (accessWard == null)) {
	accessFirstWard = accessWardList.split(",")[0].replace("'","");
} else if (accessWard!= null && accessWard.length > 0 ){
	accessFirstWard = accessWard[0];
	accessWardList = StringUtils.join(accessWard,",");
}
boolean isLCB = (accessWardList != null && !"".equals(accessWardList))|| (accessWard != null);

if (userBean != null && userBean.isLogin()) {
	if (userBean.getStaffID().equals("4330")||
			userBean.getLoginID().equals("U3NURSE")||
			userBean.getLoginID().equals("U4NURSE")) {
		
	} else if (userBean.getDeptCode().equals("FOOD") || 
			userBean.getDeptCode().equals("HSKG") ||  
			userBean.getDeptCode().equals("U100") ||  
			userBean.getDeptCode().equals("U200") ||  
			userBean.getDeptCode().equals("U300") ||  
			userBean.getDeptCode().equals("SURG") ||  
			userBean.getDeptCode().equals("U400") ||
			userBean.getDeptCode().equals("LCB") ||
			userBean.getDeptCode().equals("IT") ||  
			userBean.getDeptCode().equals("720")) {
		if (userBean.getDeptCode().equals("IT") ||  
				userBean.getDeptCode().equals("720")) {
		}
		
		if (userBean.getDeptCode().equals("HSKG")) {
			if (userBean.getStaffID().equals("16119")) {
				
			}
			else if (!userBean.isAdmin()){
				%>
				<script>
					alert('You are not granted permission1.');
					window.close();
				</script>
				<%
				return;
			}
		}
	} else if (!userBean.isAdmin()){
		%>
		<script>
			alert('You are not granted permission2.');
			window.close();
		</script>
		<%
		return;
	}
		
	ward = request.getParameter("ward");
	if (ward == null && (accessFirstWard != null && !"".equals(accessFirstWard))) {
		ward = accessFirstWard;
	}
	room = request.getParameter("room");
	bed = request.getParameter("bed");
	patNo = request.getParameter("patNo");
	ArrayList record = PatientDB.getInPatList(patNo, ward, room, "food", false,
			(( (accessWard != null && !"".equals(accessWard))
				||(accessWardList != null && !"".equals(accessWardList)))?new String[]{"L","M"}:null)
			); 
		//getPatientList(ward, patNo, "foodservice");

	request.setAttribute("patList", record);
}
else {
	%>
	<script>
		window.open("../foodtw/index.jsp?accessWard=<%=accessWardList==null?"":accessWardList.replace("'","")%>", "_self");
	</script>
	<%
	return;
}
%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>	
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	<jsp:include page="../foodtw/checkSession.jsp" />
	<style>
		TD,TH,A,SPAN,INPUT {
			font-size:18px !important;
		}
		.ordered {
			background-color: greenyellow !important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.npo {
			background-color: lightpink !important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.discharge {
			background-color: orange !important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.unable {
			background-color: LightSkyBlue !important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.later {
			background-color: MediumPurple !important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.noorder {
			background-color: Yellow !important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.order {
			background-color: Green !important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
	</style>
	<body>	
		<DIV id=indexWrapper>
			<DIV id=mainFrame>
				<DIV id=contentFrame>
					<div id="orderHistory" style="width:90%; height:auto; display:none; position:absolute; z-index:15; "
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
						<table id="orderHistTable"></table>
					</div>
					<br/>
					<div style="float:left" id="buttonPanel">
						<button onclick="goToCustomOrder('<%=(ward==null)?"":ward%>', '<%=(bed==null)?"":bed%>', '<%=(room==null)?"":room%>')"  
										class = "nonLCBButton ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
										Ordering Note 臨時訂餐
						</button>
						<button class = "nonLCBButton adlist ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
							Admission List 出入院記錄
						</button> 
						<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
								onclick="goToRemarkList()">
							Summary List 訂餐總匯
						</button>
						<button class="nonLCBButton ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
								onclick="goToOrderingNoteList()">
							Ordering Note List 臨時訂餐備忘表
						</button>
					</div>
					<div style="float:right">
						<button class = "logout ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"> 
							<a href="../foodtw/logout.jsp"><%=MessageResources.getMessageEnglish("prompt.logout") %></a>
						</button>
					</div>
					
					<div class="updateRmkBtn" style="position:absolute; z-index:12;">
						<button onclick="updateRemark();" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
								style="width:180px; height:60px;font-size:18px!important;">
							Update All Remarks
						</button>
					</div>
					<form name="searchForm" action="patlist.jsp" method="get">
						<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" style="width:100%">
							<tr style="width:100%"><td colspan='5'>&nbsp;</td></tr>
							<tr style="width:100%">
								<td colspan="2" style="background-color:gray; color:white;">
									<label style="font-size:30px;"><u><b>Patient List</b></u></label>
								</td>
								<td colspan="1">
								</td>
								<td colspan="4" align="right">
									<button onclick="resetAllRemark();" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
										style="font-size:18px!important;">
										Reset All Remarks
									</button>
								</td>
							</tr>
							<tr style="width:100%"><td colspan='5'>&nbsp;</td></tr>
							<tr class="smallText" style="width:100%">
								<td class="infoLabel" width="15%">
									Ward
								</td>
								<td class="infoData" width="35%">
									<select id="ward"></select>
								</td>
								<td class="infoLabel" width="15%">
									Room
								</td>
								<td class="infoData" width="35%">
									<select id="room"></select>
								</td>
								<td class="infoLabel" width="15%">
									Patient No.
								</td>
								<td class="infoData" width="35%">
									<input name="patNo" type="textfield" value="<%=(patNo==null)?"":patNo %>" maxlength="20" size="50" />
								</td>
								<td>
									<button r class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" onclick="submitAction('search')">Search</button>	
								</td>
							</tr>
							<%--
							<tr class="smallText" style="width:100%">
								<td class="infoLabel" width="15%">
									Action
								</td>
								<td class="infoData" width="85%" colspan='4'>
									<button onclick="updateRemark();" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Update All Remarks</button>
								</td>
							</tr>
							--%>
							<tr class="smallText" style="width:100%">
								<td class="infoData" colspan='7'>
									<div style="float:left; width:20%">
										<div style="float:left; width:40%">
											<button disabled style="width:40px; height:30px" class = "npo ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											</button><br/><span>: NPO</span>
										</div>
										<div style="float:right; width:60%">
											<button disabled style="width:40px; height:30px" class = "discharge ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											</button><br/><span>: Discharge</span>
										</div>
									</div>
									<div style="float:right; width:80%">
										<div style="float:left; width:40%">
											<div style="float:left; width:55%">
												<button disabled style="width:40px; height:30px" class = "unable ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
												</button><br/><span>: Unable to Access</span>
											</div>
											<div style="float:right; width:45%">
												<button disabled style="width:40px; height:30px" class = "later ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
												</button><br/><span>: Order Later</span>
											</div>
										</div>
										<div style="float:right; width:60%">
											<div style="float:left; width:30%">
												<button disabled style="width:40px; height:30px" class = "noorder ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
												</button><br/><span>: No Order</span>
											</div>
											<div style="float:right; width:70%">
												<div style="float:left; width:35%">
													<button disabled style="width:40px; height:30px" class = "order ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
													</button><br/><span>: Ordered</span>
												</div>
												<div style="float:right; width:60%">
													<button disabled style="width:40px; height:30px" class = "ordered ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
													</button><br/><span>: Ordered within 2 hours</span>
												</div>
											</div>
										</div>
									</div>
								</td>
							</tr>
						</table>
						<input type="hidden" name="ward" value="<%=(ward==null)?"":ward%>">
						<input type="hidden" name="room" value="<%=(room==null)?"":room%>">
						<input type="hidden" name=accessWardList value="<%=(accessWardList==null)?"":accessWardList%>">
					</form>
					
					<input type="hidden" name="bed" value="<%=(bed==null)?"":bed%>">
					
					<display:table id="row" name="requestScope.patList" export="false" pagesize="999" class="tablesorter" sort="list">
						<display:column title="Ward" style="width:5%">
							<c:out value="${row.fields2}" />
						</display:column>
						<display:column title="Bed" style="width:5%">
							<c:out value="${row.fields3}" />
							<logic:equal name="row" property="fields18" value="U">
								(DC)
							</logic:equal>
							<logic:equal name="row" property="fields18" value="G">
								(DC)
							</logic:equal>
							<logic:equal name="row" property="fields18" value="M">
								(DC)
							</logic:equal>
							<div id="${row.fields3}"></div>
						</display:column>
						<display:column title="Patient No" style="width:5%">
							<c:out value="${row.fields7}" />
							<logic:equal name="row" property="fields47" value="Y">
								<p style="color:red;">*Isolate*</p>
							</logic:equal>
						</display:column>
						<display:column title="Patient Name" style="width:5%">
							<c:out value="${row.fields9}" />
						</display:column>
						<display:column title="Patient Chinese Name" style="width:5%">
							<c:out value="${row.fields10}" />
						</display:column>
						<display:column title="Age" style="width:5%">
							<c:out value="${row.fields11}" />
						</display:column>
						<display:column title="Sex" style="width:5%">
							<c:out value="${row.fields8}" />
						</display:column>
						<display:column title="Allergy" style="width:5%">
							<c:set var="patientNo" value="${row.fields7}"/>
							<%
								String patientNo = (String)pageContext.getAttribute("patientNo") ;
								String allergy = PatientDB.getInpatientAllergy(patientNo, null);
								allergy.replaceAll(",", ", ");
								pageContext.setAttribute("allergy", allergy);
							%>
							<div style="width:150px;">
								<c:out value="${allergy}" />
							</div>
							<!--  
							<br/>
							<form method="POST" target="_blank"
								action="http://160.100.3.22/AdaptationFrame/html/AdaptationFrame.jsp?sex=${row.fields8}&engSurName=${row.fields43}&engGivenName=${row.fields44}&mrnPatientIdentity=${row.fields7}&dob=${row.fields45}&doctype=ID&docnum=${row.fields46}&login=admin&loginName=FoodTW&userRight=A&userRank=720&userRankDesc=720&hospitalCode=AH&systemLogin=ALERT_ALLERGY&sourceSystem=CIS">
								<input type="hidden" name="chiName" value="${row.fields10}"/>
								<input type="submit" value="Structure Alert" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="font-size:10px;!important;width:130px;" >
							</form>
							-->
						</display:column>
						<display:column title="Action" style="width:10%">
							<button style="font-size:24px;" class = "goToOrderBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
								onclick='goToOrder("<c:out value="${row.fields7}" />",
														"<c:out value="${row.fields2}" />",
														"<c:out value="${row.fields4}" />",
														"<c:out value="${row.fields3}" />",
														"<c:out value="${row.fields9}" />",
														"<c:out value="${row.fields5}" />",
														"<%=(ward==null)?"ALL":ward%>",
														"<c:out value="${row.fields19}" />",
														"<c:out value="${row.fields6}"/>",
														"<c:out value="${row.fields18}"/>",
														"<c:out value="${row.fields1}"/>", this,
														"<%=(room==null)?"ALL":room%>",<%=isLCB %>,
														"<%=(accessWardList!=null || !"".equals(accessWardList))?accessWardList.replaceAll("'",""):""%>")' 
														psID="<c:out value="${row.fields18}"/>">
								Order
							</button>
						</display:column>
						<display:column title="History" style="width:10%">
							<button patno="<c:out value="${row.fields7}" />" style="font-size:24px;" class = "viewBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
								onclick='viewHistory("<c:out value="${row.fields7}" />",
														"<c:out value="${row.fields2}" />",
														"<c:out value="${row.fields4}" />",
														"<c:out value="${row.fields3}" />",
														"<c:out value="${row.fields9}" />",
														"<c:out value="${row.fields5}" />",
														"<%=(ward==null)?"ALL":ward%>",
														"<c:out value="${row.fields19}" />",
														"<c:out value="${row.fields6}"/>",
														"<c:out value="${row.fields18}"/>",
														"<c:out value="${row.fields1}"/>", this,
														"<%=(room==null)?"ALL":room%>")' remark="" psID="<c:out value="${row.fields18}"/>">
								View
							</button>
						</display:column>
						<display:column title="Remark" style="width:40%">
							<div class="remarkWidget" psID="<c:out value="${row.fields18}"/>" 
											patno="<c:out value="${row.fields7}"/>" 
											regID="<c:out value="${row.fields5}"/>" 
											regType="<c:out value="${row.fields6}"/>" 
											patName="<c:out value="${row.fields9}"/>" 
											wardCode="<c:out value="${row.fields1}"/>" 
											romCode="<c:out value="${row.fields4}"/>" 
											bedCode="<c:out value="${row.fields3}"/>" 
											status="<c:out value="${row.fields19}"/>">
								<input class="remarkDay" style='width:25px; height:25px;' name='remarkDay_<c:out value="${row.fields0}" />' type='radio' value='today' checked/><span style="font-size:18px!important;">Today</span>&nbsp;&nbsp;&nbsp;<br/><br/>
								<input class="remarkDay" style='width:25px; height:25px;' name='remarkDay_<c:out value="${row.fields0}" />' type='radio' value='tmr'/><span style="font-size:18px!important;">Tomorrow</span>
								<br/>
								<br/>
								<hr/>
								<input class='remarkStatus' style='width:25px; height:25px;' 
									name='remarkStatus_<c:out value="${row.fields0}" />' type='radio' value='NPO'/>NPO<br/>
								<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus_<c:out value="${row.fields0}" />' type='radio' value='Discharge'/>Discharge<br/>
								<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus_<c:out value="${row.fields0}" />' type='radio' value='Unable to Access'/>Unable to Access<br/>
								<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus_<c:out value="${row.fields0}" />' type='radio' value='Order Later'/>Order Later<br/>
								<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus_<c:out value="${row.fields0}" />' type='radio' value='No Order'/>No Order<br/>
								<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus_<c:out value="${row.fields0}" />' type='radio' value='Ordered'/>Ordered<br/>
								<input class='remarkStatus' style='width:25px; height:25px;' name='remarkStatus_<c:out value="${row.fields0}" />' type='radio' value='Normal'/>Normal
							</div>
						</display:column>
						<display:setProperty name="basic.msg.empty_list" value="Not found any item"/>
					</display:table>
				</DIV>
			</DIV>
		</DIV>
	</body>
</html:html>

<script type="text/javascript">
	function checkRemark() {
		$('div.remarkWidget').each(function(i, v) {
			var remark = $(this).attr('status');
			//alert(remark)
			if(remark && remark.length > 0) {
				$(this).find('input.remarkStatus').each(function(i, v) {
					if($(this).val().toUpperCase() == remark.toUpperCase()) {
						$(this).attr('checked', true);
					}
				});
			}
		});
	}
	
	function updateRemarkDiv(dom, values) {
		if(values && values.length > 0) {
			var temp = $.trim(values).split('_');
			dom.parent().attr('psID', temp[0]);
			//alert(temp[0])
			dom.parent().find('input.remarkStatus').each(function(i, v) {
				if($(this).val().toUpperCase() == temp[1].toUpperCase()) {
					$(this).attr('checked', true);
				}
			});
			//alert(temp[1])
			//alert(dom.parent().parent().parent().html())
			dom.parent().parent().parent()
				.find('button.goToOrderBtn').attr('psID', temp[0]);
			dom.parent().parent().parent()
				.find('button.viewBtn').attr('psID', temp[0]);
			dom.parent().parent().parent()
				.find('button.viewBtn').attr('remark', temp[1].toUpperCase());
		}
		else {
			dom.parent().attr('psID', '');
			dom.parent().parent().parent()
				.find('button.goToOrderBtn').attr('psID', '');
			dom.parent().parent().parent()
				.find('button.viewBtn').attr('psID', '');
			dom.parent().parent().parent()
				.find('button.viewBtn').attr('remark', '');
		}
	}
	
	function getRemark(all, dom, selection, patno, regID) {
		var data = "";
		if(all) {
			data = 'all='+all+'&today=Y';
		}
		else {
			data = 'today='+(selection=='today'?'Y':'N')+'&patNo='+patno+'&regID='+regID+'&all='+all;
		}
		
		$.ajax({
			url: 'getFsdOrderRemark.jsp',
			data: data,
			async: false,
			success: function(values){
				values = $.trim(values);
				//alert(values)
				if(all) {
					var cont = $.trim(values).split('|');
					$.each(cont, function(i, v) {
						if(v) {
							var detail = v.split('_');
							updateRemarkDiv($('input.remarkDay')
												.parent('[patno='+detail[2]+'][regID='+detail[3]+']')
													.find('input.remarkDay'), detail[0]+"_"+detail[1]);
						}
					});
				}
				else {
					updateRemarkDiv(dom, values);
				}
			},
			error: function() {
				alert('error');
			}
		});
	}
	
	function selectRemarkDateEvent() {
		$('input.remarkDay').click(function() {
			$(this).parent().find('input.remarkStatus:checked').attr('checked', false);
			var patno = $(this).parent().attr('patno');
			var regID = $(this).parent().attr('regID');
			var selection = $(this).val();
			var dom = $(this);
			
			getRemark(false, dom, selection, patno, regID);
		});
	}
	
	function updateRemark() {
		showLoadingBox('body', 500, $(window).scrollTop());
		$('div.remarkWidget').each(function(i, v) {
			var selectedStatus = $(this).find('input.remarkStatus:checked').val();
			var psID = $(this).attr('psID');
			var patno = $(this).attr('patno');
			var regID = $(this).attr('regID');
			var regType = $(this).attr('regType');
			var patName = $(this).attr('patName');
			var wardCode = $(this).attr('wardCode');
			var romCode = $(this).attr('romCode');
			var bedCode = $(this).attr('bedCode');
			var selection = $(this).parent().find('input.remarkDay:checked').val();
			
			if(selectedStatus) {
				$.ajax({
					url: '../foodtw/fsdOrderRemarkProcess.jsp?'+
							'psID='+psID+
							'&patNo='+patno+
							'&regID='+regID+
							'&regType='+regType+
							'&patName='+patName+
							'&wardCode='+wardCode+
							'&romCode='+romCode+
							'&bedCode='+bedCode+
							'&status='+selectedStatus+
							'&today='+(selection=='today'?'Y':'N')+
							'&reset=false',
					async: false,
					success: function(values){
						if(values) {
							if(values.indexOf('Fail') > -1) {
								alert("Fail to update of patient# "+patno);
							}
						}
					},
					error: function() {
						alert('error');
					}
				});
			}
		});
		location.reload(true);
	}
	
	function checkOrderStatus() {
		$('button.viewBtn').each(function(i, v) {
			var dom = $(this);
			var remark = dom.attr('remark');
			dom.removeClass('ordered');
			dom.removeClass('npo');
			dom.removeClass('discharge');
			dom.removeClass('unable');
			dom.removeClass('noorder');
			dom.removeClass('later');
			//alert(remark)
			if(remark && remark.length > 0) {
				if(remark.toUpperCase() == "NPO") {
					dom.addClass('npo');
				}
				else if(remark.toUpperCase() == "DISCHARGE") {
					dom.addClass('discharge');
				}
				else if(remark.toUpperCase() == "UNABLE TO ACCESS") {
					dom.addClass('unable');
				}
				else if(remark.toUpperCase() == "ORDER LATER") {
					dom.addClass('later');
				}
				else if(remark.toUpperCase() == "NO ORDER") {
					dom.addClass('noorder');
				}
				else if(remark.toUpperCase() == "ORDERED") {
					dom.addClass('order');
				}
				else {
					$.ajax({
						url: '../ui/fsdOrderStatus.jsp?patNo='+dom.attr('patno'),
						async: false,
						success: function(values){
							if(values.indexOf('true') > -1) {
								dom.addClass('ordered');
							}
							else {
								
							}
						},
						error: function() {
							alert('error');
						}
					});
				}
			}
			else {
				$.ajax({
					url: '../ui/fsdOrderStatus.jsp?patNo='+dom.attr('patno'),
					async: false,
					success: function(values){
						if(values.indexOf('true') > -1) {
							dom.addClass('ordered');
						}
						else {
							
						}
					},
					error: function() {
						alert('error');
					}
				});
			}
		});
	}

	function goToOrder(patNo, ward, room, bed, patName, regID, wardNo, remark, regType, 
						psID, wardCode, dom, romCode,isLCB,accessWardList) {
		showLoadingBox('body', 500, $(window).scrollTop());
		var patSerID = $(dom).attr('psID');

		window.open("foodService.jsp?patNo="+patNo+"&ward="+ward+"&room="+room+
				"&bed="+bed+"&patName="+patName+"&regID="+regID+"&wardNo="+wardNo+
				"&remark="+encodeURI(remark)+"&regType="+regType+"&psID="+patSerID+
				"&wardCode="+wardCode+"&romCode="+romCode+"&isLCB="+isLCB+(accessWardList != ""?("&accessWardList="+accessWardList):"")
				, "_self");
		hideLoadingBox('body', 500);
		return false;
	}
	
	function goToCustomOrder(wardNo, bed, room) {
		showLoadingBox('body', 500, $(window).scrollTop());
		window.open("foodService.jsp?custom=Y&wardNo="+wardNo+"&bed="+bed+"&romCode="+room, "_self");
		hideLoadingBox('body', 500);
		return false;
	}
	
	function submitAction(command) {
		if(command == 'search') {
			document.searchForm.submit();
		}
		
		return false;
	}
	
	function getWRB(type, val, selected) {
		$.ajax({
			url: (type=="Ward")?"../ui/ward_classCMB.jsp":"../ui/rm_bedCMB.jsp",
			async: false,
			data: "Type="+type+"&module=fstw&Value="+val+(selected?("&selected="+selected):"")+"&accessWard="+$('input[name=accessWardList]').val(),
			success: function(values){
				$('select#'+type.toLowerCase()).html((type == "Ward"?"":"<option value='ALL'>ALL</option>")+values);
				if(type == "Ward" || type == "Room") {
					selectWREvent(type, type == "Ward"?"Room":"Bed");
				}
				else {
					selectWREvent(type, type);
				}
			},
			error: function() {
				alert('error');
			}
		});
	}
	
	function selectWREvent(type, target, init) {
		$('select#'+type.toLowerCase()).change(function() {
			$('option:selected', this).each(function(){
				if(type.toLowerCase() == 'ward') {
					$('input[name=room]').val('');
				}
				$('input[name='+type.toLowerCase()+']').val(this.value);
				submitAction('search');
		    });
		});
	}
	
	function viewHistory(patNo, ward, room, bed, patName, regID, wardNo, remark, regType, psID,
							wardCode, dom, romCode) {
		var patSerID = $(dom).attr('psID');
		$('table#orderHistTable').html('');
		$.ajax({
			type: "GET",
			url: "../ui/fsdOrderHistory.jsp?patNo="+patNo,
			async: false,
			cache: false,
			success: function(values){
				$('table#orderHistTable').html(values);
				$('div#orderHistory').css('top', $(window).scrollTop());
				$('div#orderHistory').css('display', '');
				$('button#closeDetail').click(function() {
					$('div#orderHistory').css('display', 'none');
					$('table#orderHistTable').html('');
				});
				$('button.editOrder').click(function(){
					editOrder(patNo, ward, room, bed, patName, regID, $(this).attr('orderNo'), 
								wardNo, remark, regType, patSerID, wardCode, romCode);
				});
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				$('table#orderHistTable').html('');
				alert('Error in "viewHistory"');
			}
		});
	}
	
	function deleteOrder(orderNo, patNo) {
		$.ajax({
			url: "foodOrderAction.jsp?action=delete&orderNo="+orderNo,
			async: false,
			success: function(values){
				if(values.indexOf("true") > -1) {
					alert("Succeed to delete order.");
					viewHistory(patNo);
					checkOrderStatus();
				}
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "deleteOrder"');
			}
		});
	}
	
	function editOrder(patNo, ward, room, bed, patName, regID, orderNo, wardNo, remark,
			 			regType, psID, wardCode, romCode) {
		showLoadingBox('body', 500, $(window).scrollTop());
		window.open("foodService.jsp?patNo="+patNo+"&ward="+ward+"&room="+room+
				"&bed="+bed+"&patName="+patName+"&regID="+regID+"&edit=Y&orderNo="+orderNo+
				"&wardNo="+wardNo+"&remark="+encodeURI(remark)+
				"&regType="+regType+"&psID="+psID+"&wardCode="+wardCode+"&romCode="+romCode, "_self");
		hideLoadingBox('body', 500);
	}
	
	function goToRemarkList(ward) {
		window.open("summary.jsp?ward="+$('select#ward').find('option:selected').val(),"_blank");
	}
	
	function goToOrderingNoteList() {
		window.open("customList.jsp", "_blank");
	}
	
	function scrollEvent() {
		$(window).scroll(function () { 
				$('div.updateRmkBtn').css('left', 5);
				$('div.updateRmkBtn').css('top', $(window).scrollTop()+$(window).height()-$('div.updateRmkBtn').find('button').height()-30);
		   }).trigger('scroll');
	}
	
	function resetAllRemark() {
		var reset = confirm("Do you really want to reset it?");
		if(reset == true) {
			$.ajax({
				url: "../foodtw/fsdOrderRemarkProcess.jsp?reset=true",
				async: false,
				success: function(values){
					if(values) {
						if(values.indexOf('Fail') > -1) {
							alert("Fail to update all remarks");
						}
					}
				},
				error: function(x, q, r) {
					alert('error');
				}
			});
			
			location.reload(true);
		}
	}
	
	$(document).ready(function() {
		showLoadingBox('body', 500, $(window).scrollTop());
		getWRB('Ward', $('input[name=ward]').val());
		getWRB('Room', $('input[name=ward]').val(), $('input[name=room]').val());
		
		if($('input[name=accessWardList]').val().length > 0) {
			$('.nonLCBButton').css('display', 'none');
		} else {
			$('.nonLCBButton').css('display', '');
		}
		$('button.logout').click(function() {
			window.open('../foodtw/logout.jsp', '_self');
		});
		
		$('button.adlist').click(function() {
			window.open('../foodtw/admissionlist.jsp', '_blank');
		});
		
		selectRemarkDateEvent();
		getRemark(true);
		
		checkRemark();
		scrollEvent();
		checkOrderStatus();
		hideLoadingBox('body', 500);
		
		$('th').unbind('click');
		if($('input[name=bed]').val().length > 0) {
			$(window).scrollTop($('div#'+$('input[name=bed]').val()).parent().position().top);
		}
		$(window).trigger('scroll');
	});
</script>