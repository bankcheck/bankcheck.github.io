<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%
String command = ParserUtil.getParameter(request, "command");
String deptCode = ParserUtil.getParameter(request, "deptCode");
String fiscalYear = ParserUtil.getParameter(request, "fiscalYear_yy");
String planID = ParserUtil.getParameter(request, "planID");
String goalID = ParserUtil.getParameter(request, "goalID");

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

String keyID = fiscalYear + deptCode + planID;
String allowRemove = updateGoalAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
%>
	<!-- Attachment START -->
	<tr class="smallText">
		<td class="infoSubTitle6" colspan="2">Attach Documents</td>
	</tr>
<%	if (!createTaskAction && !updateTaskAction && !createEvaluationAction && !updateEvaluationAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">3 Goals</td>
		<td class="infoData" width="80%">
<%		if (updateGoalAction) { %>
			<input type="file" name="goalDoc" size="50" class="multi" maxlength="10">
<%		} %>
<span id="corporate.plan.goal_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="corporate.plan.goal" />
	<jsp:param name="keyID" value="<%=keyID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
</span>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Annual Plan</td>
		<td class="infoData" width="80%">
<%		if (updateGoalAction) { %>
		<input type="file" name="annualPlanDoc" size="50" class="multi" maxlength="10">
<%		} %>
<span id="corporate.plan.annual_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="corporate.plan.annual" />
	<jsp:param name="keyID" value="<%=keyID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
</span>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Budget / Capital Request</td>
		<td class="infoData" width="80%">
<%		if (updateGoalAction) { %>
			<input type="file" name="pastPerformanceDoc" size="50" class="multi" maxlength="10">
<%		} %>
<span id="corporate.plan.past_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="corporate.plan.past" />
	<jsp:param name="keyID" value="<%=keyID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
</span>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Others</td>
		<td class="infoData" width="80%">
<%		if (updateGoalAction) { %>
			<input type="file" name="otherDoc" size="50" class="multi" maxlength="10">
<%		} %>
<span id="corporate.plan.other_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="corporate.plan.other" />
	<jsp:param name="keyID" value="<%=keyID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
</span>
		</td>
	</tr>
<%	} %>
	<!-- Attachment (END) -->