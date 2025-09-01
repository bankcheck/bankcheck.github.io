<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
String deptCode = ParserUtil.getParameter(request, "deptCode");
String fiscalYear = ParserUtil.getParameter(request, "fiscalYear_yy");
String planID = ParserUtil.getParameter(request, "planID");
String goalID = ParserUtil.getParameter(request, "goalID");
// total cost
String totalCost = null;
String totalCostApproved = null;
String totalCostApprovalDate = null;
String totalCostApprovalUserName = null;
String totalCostActual = null;

String totalCostRemark = null;
String totalCostApprovedRemark = null;
String totalCostActualRemark = null;
// equipment cost
String equipmentCost = null;
String equipmentCostApproved = null;
String equipmentCostApprovalDate = null;
String equipmentCostApprovalUserName = null;
String equipmentCostActual = null;

String equipmentCostRemark = null;
String equipmentCostApprovedRemark = null;
String equipmentCostActualRemark = null;

// recruitment cost
String recruitmentCost = null;
String recruitmentCostApproved = null;
String recruitmentCostApprovalDate = null;
String recruitmentCostApprovalUserName = null;
String recruitmentCostActual = null;

String recruitmentCostRemark = null;
String recruitmentCostApprovedRemark = null;
String recruitmentCostActualRemark = null;
// FTE
String FTE = null;
String FTEApproved = null;
String FTEApprovalDate = null;
String FTEApprovalUserName = null;
String FTEActual = null;

String FTERemark = null;
String FTEApprovedRemark = null;
String FTEActualRemark = null;

//renovation
String renovationCost = null;
String renovationCostApproved = null;
String renovationCostApprovalDate = null;
String renovationCostApprovalUserName = null;
String renovationCostActual = null;

String renovationCostRemark = null;
String renovationCostApprovedRemark = null;
String renovationCostActualRemark = null;

boolean updateGoalAction = false;
boolean createTaskAction = false;
boolean updateTaskAction = false;
boolean createEvaluationAction = false;
boolean updateEvaluationAction = false;

if ("updateGoal".equals(command)) {
	updateGoalAction = true;
} else if ("createTask".equals(command)) {
	createTaskAction = true;
} else if ("updateTask".equals(command)) {
	updateTaskAction = true;
} else if ("createEvaluation".equals(command)) {
	createEvaluationAction = true;
} else if ("updateEvaluation".equals(command)) {
	updateEvaluationAction = true;
}

ArrayList record = (ArrayList) request.getAttribute("plan_goal");
if (record != null && record.size() > 0) {
	ReportableListObject row = (ReportableListObject) record.get(0);
	// total cost
	totalCost = row.getValue(12);
	totalCostApproved = row.getValue(13);
	totalCostApprovalDate = row.getValue(14);
	totalCostApprovalUserName = row.getValue(15);
	totalCostActual = row.getValue(16);
	// equipment cost
	equipmentCost = row.getValue(17);
	equipmentCostApproved = row.getValue(18);
	equipmentCostApprovalDate = row.getValue(19);
	equipmentCostApprovalUserName = row.getValue(20);
	equipmentCostActual = row.getValue(21);
	// recruitment cost
	recruitmentCost = row.getValue(22);
	recruitmentCostApproved = row.getValue(23);
	recruitmentCostApprovalDate = row.getValue(24);
	recruitmentCostApprovalUserName = row.getValue(25);
	recruitmentCostActual = row.getValue(26);
	// FTE
	FTE = row.getValue(27);
	FTEApproved = row.getValue(28);
	FTEApprovalDate = row.getValue(29);
	FTEApprovalUserName = row.getValue(30);
	FTEActual = row.getValue(31);
	//REMARK
	totalCostRemark = row.getValue(32);
	totalCostApprovedRemark = row.getValue(33);
	totalCostActualRemark = row.getValue(34);
	
	equipmentCostRemark = row.getValue(35);
	equipmentCostApprovedRemark = row.getValue(36);
	equipmentCostActualRemark = row.getValue(37);
	
	recruitmentCostRemark = row.getValue(38);
	recruitmentCostApprovedRemark = row.getValue(39);
	recruitmentCostActualRemark = row.getValue(40);

	renovationCostRemark = row.getValue(41);
	renovationCostApprovedRemark = row.getValue(42);
	renovationCostActualRemark = row.getValue(43);

	renovationCost = row.getValue(44);
	renovationCostApproved = row.getValue(45);
	renovationCostApprovalDate = row.getValue(46);
	renovationCostApprovalUserName = row.getValue(47);
	renovationCostActual = row.getValue(48);
}

Map<String, String> tooltipMap = new HashMap<String, String>();
tooltipMap.put("resourceDesc","The resources required to achieve these goals");
tooltipMap.put("resourceRemark","the remark on different resource");
tooltipMap.put("requestBudget","the budget department requested on the project");
tooltipMap.put("approvedBudget","Fill in the amount  and click approve, the person who approve the budget will be show on the field");
%>
	<tr class="smallText">
		<td  title="<%=tooltipMap.get("resourceDesc") %>" class="infoSubTitle4" colspan="2">Resources</td>
	</tr>
<%	if (!createTaskAction && !updateTaskAction && !createEvaluationAction && !updateEvaluationAction) { %>
	<tr>
		<td colspan="2">
			<table id="Budget" cellpadding="0" cellspacing="2" border="0" style="width: 100%">
				<tr class="smallText">
					<td class="infoLabe2" style="width: 15%">Budget</td>
					<td title="<%=tooltipMap.get("requestBudget") %>" class="infoLabe2" style="width: 15%">Requested Budget</td>
					<td title="<%=tooltipMap.get("resourceRemark") %>" class="infoLabe2" style="width: 15%">Remarks</td>
					<td title="<%=tooltipMap.get("approvedBudget") %>" class="infoLabe2" style="width: 25%">Approved Budget</td>
					<td title="<%=tooltipMap.get("resourceRemark") %>" class="infoLabe2" style="width: 15%">Remarks</td>
					<td class="infoLabe2" style="width: 15%">Actual Usage</td>
					<td title="<%=tooltipMap.get("resourceRemark") %>" class="infoLabe2" style="width: 15%">Remarks</td>
				</tr>
				
				<!---------total------------------------------------------------------------->
				<tr class="smallText">
					<td class="infoLabel" width="15%">total Cost Budget</td>
					
					<!-----requested--------------------------------------------------------->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction && (totalCostApprovalDate == null || totalCostApprovalDate.length() == 0)) { %>
						$ <input type="textfield" name="totalCost" value="<%=totalCost==null?"":totalCost %>" maxlength="100" size="20">
<%		} else { %>
						$ <%=totalCost == null ? "" : totalCost.toUpperCase()%>
<%		} %>
					</td>
					<!-- ---------remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="totalCostRemark" value="<%=totalCostRemark==null?"":totalCostRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=totalCostRemark == null ? "" : totalCostRemark.toUpperCase()%>
<%		} %>
					</td>					
					<!-----approved---------------------------------------------------------->
					<td class="infoData" style="width: 25%">
<%		if (totalCostApprovalDate != null && totalCostApprovalDate.length() > 0) { %>
						$ <%=totalCostApproved == null ? "" : totalCostApproved.toUpperCase()%><br>
						(BY: <%=totalCostApprovalUserName == null ? "" : totalCostApprovalUserName %>)
<%		} else if (!updateGoalAction && (totalCost != null && totalCost.length() > 0)) { %>
						$ <input type="textfield" name="totalCostApproved" value="<%=totalCostApproved==null?"":totalCostApproved %>" maxlength="100" size="20">
						<button onclick="submitAction('approveTotalCost', 1, '');return false;">Approve</button>
<%		} %>
					</td>
					<!-- ---------approved remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="totalCostApprovedRemark" value="<%=totalCostApprovedRemark==null?"":totalCostApprovedRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=totalCostApprovedRemark == null ? "" : totalCostApprovedRemark.toUpperCase()%>
<%		} %>
					</td>				
					<!-----actual------------------------------------------------------------>
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction && (totalCostApprovalDate != null && totalCostApprovalDate.length() > 0)) { %>
						$ <input type="textfield" name="totalCostActual" value="<%=totalCostActual==null?"":totalCostActual %>" maxlength="100" size="20">
<%		} else { %>
						$ <%=totalCostActual == null ? "" : totalCostActual.toUpperCase()%>
<%		} %>
					</td>
					<!-- ---------ACTUAL remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="totalCostActualRemark" value="<%=totalCostActualRemark==null?"":totalCostActualRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=totalCostActualRemark == null ? "" : totalCostActualRemark.toUpperCase()%>
<%		} %>
					</td>						
				</tr>
				<!---------equipment--------------------------------------------------------->
				<tr class="smallText">
					<td class="infoLabel" width="15%">Equipment Cost Budget</td>
					<!-----requested--------------------------------------------------------->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction && (equipmentCostApprovalDate == null || equipmentCostApprovalDate.length() == 0)) { %>
						$ <input type="textfield" name="equipmentCost" value="<%=equipmentCost==null?"":equipmentCost %>" maxlength="100" size="20">
<%		} else { %>
						$ <%=equipmentCost == null ? "" : equipmentCost.toUpperCase()%>
<%		} %>
					</td>
					<!-- ---------remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="equipmentCostRemark" value="<%=equipmentCostRemark==null?"":equipmentCostRemark %>" maxlength="100" size="20">
<%		} else { %>
						 <%=equipmentCostRemark == null ? "" : equipmentCostRemark.toUpperCase()%>
<%		} %>
					</td>					
					<!-----approved---------------------------------------------------------->
					<td class="infoData" style="width: 25%">
<%		if (equipmentCostApprovalDate != null && equipmentCostApprovalDate.length() > 0) { %>
						$ <%=equipmentCostApproved == null ? "" : equipmentCostApproved.toUpperCase()%><br>
						(BY: <%=equipmentCostApprovalUserName == null ? "" : equipmentCostApprovalUserName %>)
<%		} else if (!updateGoalAction && (equipmentCost != null && equipmentCost.length() > 0)) { %>
						$ <input type="textfield" name="equipmentCostApproved" value="<%=equipmentCostApproved==null?"":equipmentCostApproved %>" maxlength="100" size="20">
						<button onclick="submitAction('approveEquipmentCost', 1, '');return false;">Approve</button>
<%		} %>
					</td>
				<!-- ---------approved remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="equipmentCostApprovedRemark" value="<%=equipmentCostApprovedRemark==null?"":equipmentCostApprovedRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=equipmentCostApprovedRemark == null ? "" : equipmentCostApprovedRemark.toUpperCase()%>
<%		} %>
					</td>						
					<!-----actual------------------------------------------------------------>
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction && (equipmentCostApprovalDate != null && equipmentCostApprovalDate.length() > 0)) { %>
						$ <input type="textfield" name="equipmentCostActual" value="<%=equipmentCostActual==null?"":equipmentCostActual %>" maxlength="100" size="20">
<%		} else { %>
						$ <%=equipmentCostActual == null ? "" : equipmentCostActual.toUpperCase()%>
<%		} %>
					</td>
				<!-- ---------ACTUAL remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction) { %>
						 <input type="textfield" name="equipmentCostActualRemark" value="<%=equipmentCostActualRemark==null?"":equipmentCostActualRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=equipmentCostActualRemark == null ? "" : equipmentCostActualRemark.toUpperCase()%>
<%		} %>
					</td>						
				</tr>
				<!---------recruitment------------------------------------------------------->
				<tr class="smallText">
					<td class="infoLabel" width="15%">Recruitment Cost Budget</td>
										
					<!-----requested--------------------------------------------------------->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction && (recruitmentCostApprovalDate == null || recruitmentCostApprovalDate.length() == 0)) { %>
						$ <input type="textfield" name="recruitmentCost" value="<%=recruitmentCost==null?"":recruitmentCost %>" maxlength="100" size="20">
<%		} else { %>
						$ <%=recruitmentCost == null ? "" : recruitmentCost.toUpperCase()%>
<%		} %>
					</td>
					<!-- ---------remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="recruitmentCostRemark" value="<%=recruitmentCostRemark==null?"":recruitmentCostRemark %>" maxlength="100" size="20">
<%		} else { %>
						 <%=recruitmentCostRemark == null ? "" : recruitmentCostRemark.toUpperCase()%>
<%		} %>
					</td>										
					<!-----approved---------------------------------------------------------->
					<td class="infoData" style="width: 25%">
<%		if (recruitmentCostApprovalDate != null && recruitmentCostApprovalDate.length() > 0) { %>
						$ <%=recruitmentCostApproved == null ? "" : recruitmentCostApproved.toUpperCase()%><br>
						(BY: <%=recruitmentCostApprovalUserName == null ? "" : recruitmentCostApprovalUserName %>)
<%		} else if (!updateGoalAction && (recruitmentCost != null && recruitmentCost.length() > 0)) { %>
						$ <input type="textfield" name="recruitmentCostApproved" value="<%=recruitmentCostApproved==null?"":recruitmentCostApproved %>" maxlength="100" size="20">
						<button onclick="submitAction('approveRecruitmentCost', 1, '');return false;">Approve</button>
<%		} %>
					</td>
				<!-- ---------approved remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="recruitmentCostApprovedRemark" value="<%=recruitmentCostApprovedRemark==null?"":recruitmentCostApprovedRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=recruitmentCostApprovedRemark == null ? "" : recruitmentCostApprovedRemark.toUpperCase()%>
<%		} %>
					</td>						
					<!-----actual------------------------------------------------------------>
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction && (recruitmentCostApprovalDate != null && recruitmentCostApprovalDate.length() > 0)) { %>
						$ <input type="textfield" name="recruitmentCostActual" value="<%=recruitmentCostActual==null?"":recruitmentCostActual %>" maxlength="100" size="20">
<% 		} else { %>
						$ <%=recruitmentCostActual == null ? "" : recruitmentCostActual.toUpperCase()%>
<%		} %>
					</td>
				<!-- ---------ACTUAL remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="recruitmentCostActualRemark" value="<%=recruitmentCostActualRemark==null?"":recruitmentCostActualRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=recruitmentCostActualRemark == null ? "" : recruitmentCostActualRemark.toUpperCase()%>
<%		} %>
					</td>						
				</tr>
				<!---------FTE--------------------------------------------------------------->
				<tr class="smallText">
					<td class="infoLabel" width="15%">FTE Budget</td>

					<!-----requested--------------------------------------------------------->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction && (FTEApprovalDate == null || FTEApprovalDate.length() == 0)) { %>
						<input type="textfield" name="FTE" value="<%=FTE==null?"":FTE %>" maxlength="100" size="20">
<%		} else { %>
						<%=FTE == null ? "" : FTE.toUpperCase()%>
<%		} %>
					</td>
					<!-- ---------remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="FTERemark" value="<%=FTERemark==null?"":FTERemark %>" maxlength="100" size="20">
<%		} else { %>
						 <%=FTERemark == null ? "" : FTERemark.toUpperCase()%>
<%		} %>
					</td>
																			
					<!-----approved---------------------------------------------------------->
					<td class="infoData" style="width: 25%">
<%		if (FTEApprovalDate != null && FTEApprovalDate.length() > 0) { %>
						<%=FTEApproved == null ? "" : FTEApproved.toUpperCase()%><br>
						(BY: <%=FTEApprovalUserName == null ? "" : FTEApprovalUserName %>)
<%		} else if (!updateGoalAction && (FTE != null && FTE.length() > 0)) { %>
						<input type="textfield" name="FTEApproved" value="<%=FTEApproved==null?"":FTEApproved %>" maxlength="100" size="20">
						<button onclick="submitAction('approveFTE', 1, '');return false;">Approve</button>
<%		} %>
					</td>
					<!-- ---------approved remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="FTEApprovedRemark" value="<%=FTEApprovedRemark==null?"":FTEApprovedRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=FTEApprovedRemark == null ? "" : FTEApprovedRemark.toUpperCase()%>
<%		} %>
					</td>						
					<!-----actual------------------------------------------------------------>
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction && (FTEApprovalDate != null && FTEApprovalDate.length() > 0)) { %>
						<input type="textfield" name="FTEActual" value="<%=FTEActual==null?"":FTEActual %>" maxlength="100" size="20">
<%		} else { %>
						<%=FTEActual == null ? "" : FTEActual.toUpperCase()%>
<%		} %>
					</td>
				<!-- ---------ACTUAL remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="FTEActualRemark" value="<%=FTEActualRemark==null?"":FTEActualRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=FTEActualRemark == null ? "" : FTEActualRemark.toUpperCase()%>
<%		} %>
					</td>						
				</tr>
				<!---------renovation------------------------------------------------------------->
				<tr class="smallText">
					<td class="infoLabel" width="15%">Renovation Cost Budget</td>
								
					<!-----requested--------------------------------------------------------->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction && (renovationCostApprovalDate == null || renovationCostApprovalDate.length() == 0)) { %>
						$ <input type="textfield" name="renovationCost" value="<%=renovationCost==null?"":renovationCost %>" maxlength="100" size="20">
<%		} else { %>
						$ <%=renovationCost == null ? "" : renovationCost.toUpperCase()%>
<%		} %>
					</td>
					<!-- ---------remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="renovationCostRemark" value="<%=renovationCostRemark==null?"":renovationCostRemark %>" maxlength="100" size="20">
<%		} else { %>
						 <%=renovationCostRemark == null ? "" : renovationCostRemark.toUpperCase()%>
<%		} %>
					</td>					
					<!-----approved---------------------------------------------------------->
					<td class="infoData" style="width: 25%">
<%		if (renovationCostApprovalDate != null && renovationCostApprovalDate.length() > 0) { %>
						$ <%=renovationCostApproved == null ? "" : renovationCostApproved.toUpperCase()%><br>
						(BY: <%=renovationCostApprovalUserName == null ? "" : renovationCostApprovalUserName %>)
<%		} else if (!updateGoalAction && (renovationCost != null && renovationCost.length() > 0)) { %>
						$ <input type="textfield" name="renovationCostApproved" value="<%=renovationCostApproved==null?"":renovationCostApproved %>" maxlength="100" size="20">
						<button onclick="submitAction('approveRenovationCost', 1, '');return false;">Approve</button>
<%		} %>
					</td>
					<!-- ---------approved remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="renovationCostApprovedRemark" value="<%=renovationCostApprovedRemark==null?"":renovationCostApprovedRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=renovationCostApprovedRemark == null ? "" : renovationCostApprovedRemark.toUpperCase()%>
<%		} %>
					</td>					
					<!-----actual------------------------------------------------------------>
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction && (renovationCostApprovalDate != null && renovationCostApprovalDate.length() > 0)) { %>
						$ <input type="textfield" name="renovationCostActual" value="<%=renovationCostActual==null?"":renovationCostActual %>" maxlength="100" size="20">
<%		} else { %>
						$ <%=renovationCostActual == null ? "" : renovationCostActual.toUpperCase()%>
<%		} %>
					</td>
		<!-- ---------ACTUAL remarks------------------------------- -->
					<td class="infoData" style="width: 15%">
<%		if (updateGoalAction ) { %>
						 <input type="textfield" name="FTEActualRemark" value="<%=FTEActualRemark==null?"":FTEActualRemark %>" maxlength="30" size="30">
<%		} else { %>
						 <%=renovationCostActualRemark == null ? "" : renovationCostActualRemark.toUpperCase()%>
<%		} %>
					</td>						
				</tr>				
			</table>
<%	} %>