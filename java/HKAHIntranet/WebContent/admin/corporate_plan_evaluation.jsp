<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
String deptCode = ParserUtil.getParameter(request, "deptCode");
String fiscalYear = ParserUtil.getParameter(request, "fiscalYear_yy");
String planID = ParserUtil.getParameter(request, "planID");
String goalID = ParserUtil.getParameter(request, "goalID");
String evaluationID = ParserUtil.getParameter(request, "evaluationID");
String tempEvaluationID = null;
String evaluationType = null;
String evaluationTypeOther = null;
String evaluationObjective = null;
String targetRevenue = null;
String targetCensus = null;
String actualRevenue = null;
String actualCensus = null;

boolean isCurrentEvaluation = false;
boolean isAllowUpdate = false;

boolean createAction = false;
boolean updateAction = false;
boolean updateGoalAction = false;
boolean createTaskAction = false;
boolean updateTaskAction = false;
boolean createEvaluationAction = false;
boolean updateEvaluationAction = false;
boolean deleteEvaluationAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("updateGoal".equals(command)) {
	updateGoalAction = true;
} else if ("createTask".equals(command)) {
	createTaskAction = true;
} else if ("updateTask".equals(command)) {
	updateTaskAction = true;
} else if ("createEvaluation".equals(command)) {
	createEvaluationAction = true;
} else if ("updateEvaluation".equals(command)) {
	updateEvaluationAction = true;
} else if ("deleteEvaluation".equals(command)) {
	deleteEvaluationAction = true;
}

Map<String, String> EvaluationMap = new HashMap<String, String>();
EvaluationMap.put("1", "Increase Revenue");
EvaluationMap.put("2", "Increase Census");
EvaluationMap.put("3", "Service Complete On Time");
EvaluationMap.put("4", "Others");

ArrayList record = CorporatePlanEvaluationDB.getList(userBean, fiscalYear, deptCode, planID, goalID);
ReportableListObject row = null;

Map<String, String> tooltipMap = new HashMap<String, String>();
tooltipMap.put("evaluationDesc","Describe how the department evaluate the outcome of the project and what the means and measures to evaluate the goals");
tooltipMap.put("userComment","Department can comment on the evaluation to have further description on the evaluation");
tooltipMap.put("adminComment","Administrator can comment on the evaluation ");
tooltipMap.put("saveEvaluation","click to save the evaluation");
tooltipMap.put("evaluationSelect", "Select the evaluation which fit the project, select[other] if fill in evaluation that can not be found in the list");
tooltipMap.put("moreEvaluation", "Click to add evaluation");
tooltipMap.put("updateEvaluation", "Click to update on different evaluation");
%>
	<tr class="smallText">
		<td title="<%=tooltipMap.get("evaluationDesc") %>" class="infoSubTitle3" colspan="2">Evaluation</td>
	</tr>
<%	if (!createTaskAction && !updateTaskAction) { %>
	<tr class="smallText">
		<td colspan="2">
<%		if (!createAction && !updateAction && !createEvaluationAction) { %>
			<a title="<%=tooltipMap.get("moreEvaluation") %>" href="javascript:void(0);" onclick="submitAction('createEvaluation', 0, '');return false;"><bean:message key="button.add" />Add Evaluation</a>
<%		} %>
		</td>
	</tr>
	<tr>
		<td colspan="2">
		<table id="EvaluationSelect" cellpadding="0" cellspacing="2"
			border="0" style="width: 100%">
			<tr class="smallText">
				<td class="infoLabe2" style="width: 40%">Outcome or Evaluation</td>
				<td class="infoLabe2" style="width: 30%">Department Comment</td>
				<td class="infoLabe2" style="width: 30%">Admin Comment</td>
			</tr>
<%
		for (int i = 0; i < record.size(); i++)
		{
			row = (ReportableListObject) record.get(i);
			tempEvaluationID = row.getValue(0);
			evaluationType = row.getValue(1);
			evaluationTypeOther = row.getValue(2);
			evaluationObjective = row.getValue(3);
			targetRevenue = row.getValue(4);
			actualRevenue = row.getValue(5);
			targetCensus = row.getValue(6);
			actualCensus = row.getValue(7);
			isCurrentEvaluation = tempEvaluationID.equals(evaluationID);
			isAllowUpdate = updateEvaluationAction&isCurrentEvaluation;
%>
			<tr class="smallText">
				<td class="infoData" width="40%" valign="top">
<%			if (isAllowUpdate) { %>
					<select  title="<%=tooltipMap.get("evaluationSelect") %>" name="evaluationType" onchange="return changeEvaluateDisplayStyle()">
						<option value="Increase Revenue"<%=evaluationType.equals(EvaluationMap.get("1"))?"selected":"" %>>Increase Revenue</option>
						<option value="Increase Census"<%=evaluationType.equals(EvaluationMap.get("2"))?"selected":"" %>>Increase Census</option>
						<option value="Service Complete On Time"<%=evaluationType.equals(EvaluationMap.get("3"))?"selected":"" %>>Service Complete On Time</option>
						<option value="Others"<%=evaluationType.equals(EvaluationMap.get("4"))?"selected":"" %>>Other</option>
					</select>
					<br/><input type="textfield" name="evaluationTypeOther" style="display: <%="Others".equals(evaluationType)?"block":"none" %>" id="evaluationTypeOther" value="<%=evaluationTypeOther==null?"":evaluationTypeOther %>" maxlength="100" size="30">
 					<br/>(max 100 characters)
<%			} else { %>
					<%="Others".equals(evaluationType) ? (evaluationTypeOther == null ? "" : evaluationTypeOther.toUpperCase()) : (evaluationType == null ? "" : evaluationType.toUpperCase()) %>
<%			} %>
<%			if (isAllowUpdate) { %>
					<br/>Objective: <input type="textfield" name="evaluationObjective" id="evaluationObjective" value="<%=evaluationObjective==null?"":evaluationObjective %>" maxlength="100" size="20">
<%			} else { %>
					<br/><%=evaluationObjective == null ? "" : evaluationObjective.toUpperCase() %>
<%			} %>
<%			if (isAllowUpdate) { %>
					<br/>Target Revenue: <input type="textfield" name="targetRevenue" style="display: block" id="targetRevenue" value="<%=targetRevenue==null?"":targetRevenue %>" maxlength="20" size="30">
					<br/>Actual Revenue: <input type="textfield" name="actualRevenue" style="display: none" id="actualRevenue" value="<%=actualRevenue==null?"":actualRevenue %>" maxlength="20" size="30">
					<br/>Target Census: <input type="textfield" name="targetCensus" style="display: block" id="targetCensus" value="<%=targetCensus==null?"":targetCensus %>" maxlength="20" size="30">
					<br/>Actual Census: <input type="textfield" name="actualCensus" style="display: none" id="actualCensus" value="<%=actualCensus==null?"":actualCensus %>" maxlength="20" size="30">
<%			} else { %>
<%				if (evaluationType.equals(EvaluationMap.get("1"))) { %>
					<br/>Target Revenue: <%=targetRevenue==null?"":targetRevenue %>
					<br/>Actual Revenue: <%=actualRevenue==null?"":actualRevenue %>
<%				} else if (evaluationType.equals(EvaluationMap.get("2"))) { %>
					<br/>Target Census: <%=targetCensus==null?"":targetCensus %>
					<br/>Actual Census: <%=actualCensus==null?"":actualCensus %>
<%				} %>
<%			} %>
<%			if (isAllowUpdate) { %>
					<button title="<%=tooltipMap.get("saveEvaluation") %>" onclick="submitAction('updateEvaluation', '1', '<%=tempEvaluationID %>');return false;" class="btn-click">Save</button>
					<button onclick="submitAction('view', '0', '');return false;" class="btn-click">Cancel</button>
<%			} else if (!createEvaluationAction && !updateEvaluationAction) { %>
					<button title="<%=tooltipMap.get("updateEvaluation") %>" onclick="submitAction('updateEvaluation', '0', '<%=tempEvaluationID %>');return false;" class="btn-click">Update</button>
					<button onclick="submitAction('deleteEvaluation', '1', '<%=tempEvaluationID %>');return false;" class="btn-click">Delete</button>

<%			} %>
				</td>
				<td  title="<%=tooltipMap.get("userComment") %>" class="infoData2" width="30%" valign="top">
<%			if (!createEvaluationAction && !updateEvaluationAction && !updateGoalAction) { %>
					<div class="box"><textarea name="evaluationUserComment<%=tempEvaluationID %>" class="comment" rows="3" cols="40"></textarea></div>
					<button onclick="submitAction('createUserEvaluation', 1, '<%=tempEvaluationID %>');return false;">Submit</button>
<%			} %>
					<table>
<jsp:include page="corporate_plan_comment.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
	<jsp:param name="objectType" value="user.evaluation" />
	<jsp:param name="objectID" value="<%=tempEvaluationID %>" />
</jsp:include>
					</table>
				</td>
				<td title="<%=tooltipMap.get("adminComment") %>" class="infoData2" width="30%" valign="top">
<%			if (!createEvaluationAction && !updateEvaluationAction && !updateGoalAction) { %>
					<div class="box"><textarea name="evaluationAdminComment<%=tempEvaluationID %>" class="comment" rows="3" cols="40"></textarea></div>
					<button onclick="submitAction('createAdminEvaluation', 1, '<%=tempEvaluationID %>');return false;">Submit</button>
<%			} %>
					<table>
<jsp:include page="corporate_plan_comment.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
	<jsp:param name="objectType" value="admin.evaluation" />
	<jsp:param name="objectID" value="<%=tempEvaluationID %>" />
</jsp:include>
					</table>
				</td>
			</tr>
<%
		} //for evaluation loop

		if (createEvaluationAction) {
%>
			<tr class="smallText">
				<td class="infoData" width="40%">
					<select title="<%=tooltipMap.get("evaluationSelect") %>" name="evaluationType" onchange="return changeEvaluateDisplayStyle()">
						<option value="Increase Revenue">Increase Revenue</option>
						<option value="Increase Census">Increase Census</option>
						<option value="Service Complete On Time">Service Complete On Time</option>
						<option value="Others">Other</option>
					</select>
					<br/><input type="textfield" name="evaluationTypeOther" style="display: none" id="evaluationTypeOther" value="" maxlength="100" size="30">
 					<br/>(max 100 characters)
					<br/>Objective: <input type="textfield" name="evaluationObjective" id="evaluationObjective" value="" maxlength="100" size="20">
					<br/>Target Revenue: <input type="textfield" name="targetRevenue" style="display: block" id="targetRevenue" value="" maxlength="20" size="30">
					<br/>Actual Revenue: <input type="textfield" name="actualRevenue" style="display: none" id="actualRevenue" value="" maxlength="20" size="30">
					<br/>Target Census: <input type="textfield" name="targetCensus" style="display: none" id="targetCensus" value="" maxlength="20" size="30">
					<br/>Actual Census: <input type="textfield" name="actualCensus" style="display: none" id="actualCensus" value="" maxlength="20" size="30">
					<button title="<%=tooltipMap.get("saveEvaluation") %>" onclick="submitAction('createEvaluation', '1', '');return false;" class="btn-click">Add</button>
					<button onclick="submitAction('view', '0', '');return false;" class="btn-click">Cancel</button>
			</td>
				<td class="infoData2" width="30%">&nbsp;</td>
				<td class="infoData2" width="30%">&nbsp;</td>
			</tr>
<%		} %>
		</table>
		</td>
	</tr>

	<tr class="smallText">
		<td colspan="2">
<%		if (!createAction && !updateAction && !createEvaluationAction) { %>
			<a title="<%=tooltipMap.get("moreEvaluation") %>" href="javascript:void(0);" onclick="submitAction('createEvaluation', 0, '');return false;"><bean:message key="button.add" />Add Evaluation</a>
<%		} %>
		</td>
	</tr>
<%	} %>