<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)) {
	HttpFileUpload.toUploadFolder(request,
	ConstantsServerSide.DOCUMENT_FOLDER,
	ConstantsServerSide.TEMP_FOLDER,
	ConstantsServerSide.UPLOAD_FOLDER);
	fileUpload = true;
}

UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String planID = ParserUtil.getParameter(request, "planID");
String deptCode = ParserUtil.getParameter(request, "deptCode");
String deptDesc = ParserUtil.getParameter(request, "deptDesc");
String fiscalYear = ParserUtil.getParameter(request, "fiscalYear_yy");
String subject = ParserUtil.getParameter(request, "subject");
String modifiedUser = null;
String modifiedDate = null;
String allowAll = userBean.isOfficeAdministrator() ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;

// goal
String goalID = ParserUtil.getParameter(request, "goalID");
String goalDesc = ParserUtil.getParameter(request, "goalDesc");
String goalOrder = ParserUtil.getParameter(request, "goalOrder");

// corporate objective
String corporateObjective = ParserUtil.getParameter(request, "corporateObjective");
String corporateObjectiveOther = ParserUtil.getParameter(request, "corporateObjectiveOther");
String focus = ParserUtil.getParameter(request, "focus");
String focusOther = ParserUtil.getParameter(request, "focusOther");

// approval
String adminApprovedYN = ParserUtil.getParameter(request, "adminApprovedYN");
String adminApprovedDate = ParserUtil.getParameter(request, "adminApprovedDate");
String adminApprovedBy = ParserUtil.getParameter(request, "adminApprovedBy");

// setup cost
String setupCost = ParserUtil.getParameter(request, "setupCost");
String setupCostApproved = ParserUtil.getParameter(request, "setupCostApproved");
String setupCostApprovalUserName = null;
String setupCostApprovalDate = null;
String setupCostActual = ParserUtil.getParameter(request, "setupCostActual");
// equipment cost
String equipmentCost = ParserUtil.getParameter(request, "equipmentCost");
String equipmentCostApproved = ParserUtil.getParameter(request, "equipmentCostApproved");
String equipmentCostApprovalDate = null;
String equipmentCostApprovalUserName = null;
String equipmentCostActual = ParserUtil.getParameter(request, "equipmentCostActual");
//renovation cost
String renovationCost = ParserUtil.getParameter(request, "renovationCost");
String renovationCostApproved = ParserUtil.getParameter(request, "renovationCostApproved");
String renovationCostApprovalDate = null;
String renovationCostApprovalUserName = null;
String renovationCostActual = ParserUtil.getParameter(request, "renovationCostActual");
// recruitment cost
String recruitmentCost = ParserUtil.getParameter(request, "recruitmentCost");
String recruitmentCostApproved = ParserUtil.getParameter(request, "recruitmentCostApproved");
String recruitmentCostApprovalDate = null;
String recruitmentCostApprovalUserName = null;
String recruitmentCostActual = ParserUtil.getParameter(request, "recruitmentCostActual");
// FTE
String FTE = ParserUtil.getParameter(request, "FTE");
String FTEApproved = ParserUtil.getParameter(request, "FTEApproved");
String FTEApprovalDate = null;
String FTEApprovalUserName = null;
String FTEActual = ParserUtil.getParameter(request, "FTEActual");

String commentID = ParserUtil.getParameter(request, "commentID");
String selected_eID = ParserUtil.getParameter(request, "selected_eID");
String selected_cID = ParserUtil.getParameter(request, "selected_cID");

// Task
String taskID = ParserUtil.getParameter(request, "taskID");
String taskDesc = ParserUtil.getParameter(request, "taskDesc");
String taskEstimateCompleteDate = ParserUtil.getParameter(request, "taskEstimateCompleteDate");
String taskActualCompleteDate = ParserUtil.getParameter(request, "taskActualCompleteDate");
String[] taskResponsibleByDeptCode = (String[]) request.getAttribute("taskResponsibleByDeptCode_StringArray");
String[] taskResponsibleByStaffID = (String[]) request.getAttribute("taskResponsibleByStaffID_StringArray");
String taskOrder = ParserUtil.getParameter(request, "taskOrder");

// Evaluation
String evaluationID = ParserUtil.getParameter(request, "evaluationID");
String evaluationType = ParserUtil.getParameter(request, "evaluationType");
String evaluationTypeOther = ParserUtil.getParameter(request, "evaluationTypeOther");
String evaluationObjective = ParserUtil.getParameter(request, "evaluationObjective");
String targetRevenue = ParserUtil.getParameter(request, "targetRevenue");
String actualRevenue = ParserUtil.getParameter(request, "actualRevenue");
String targetCensus = ParserUtil.getParameter(request, "targetCensus");
String actualCensus = ParserUtil.getParameter(request, "actualCensus");

// Remark
String totalCostRemark = ParserUtil.getParameter(request, "totalCostRemark");
String totalCostApprovedRemark = ParserUtil.getParameter(request, "totalCostApprovedRemark");
String totalCostActualRemark = ParserUtil.getParameter(request, "totalCostActualRemark");

String equipmentCostRemark = ParserUtil.getParameter(request, "equipmentCostRemark");
String equipmentCostApprovedRemark = ParserUtil.getParameter(request, "equipmentCostApprovedRemark");
String equipmentCostActualRemark = ParserUtil.getParameter(request, "equipmentCostActualRemark");

String recruitmentCostRemark = ParserUtil.getParameter(request, "recruitmentCostRemark");
String recruitmentCostApprovedRemark = ParserUtil.getParameter(request, "recruitmentCostApprovedRemark");
String recruitmentCostActualRemark = ParserUtil.getParameter(request, "recruitmentCostActualRemark");

String FTERemark = ParserUtil.getParameter(request, "FTERemark");
String FTEApprovedRemark = ParserUtil.getParameter(request, "FTEApprovedRemark");
String FTEActualRemark = ParserUtil.getParameter(request, "FTEActualRemark");

String renovationCostRemark = ParserUtil.getParameter(request, "renovationCostRemark");
String renovationCostApprovedRemark = ParserUtil.getParameter(request, "renovationCostApprovedRemark");
String renovationCostActualRemark = ParserUtil.getParameter(request, "renovationCostActualRemark");

String keyID = null;

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean createGoalAction = false;
boolean updateGoalAction = false;
boolean deleteGoalAction = false;
boolean approveGoalAction = false;
boolean rejectGoalAction = false;

boolean upGoalOrderAction = false;
boolean downGoalOrderAction = false;

boolean totalCostApprovalAction = false;
boolean equipmentCostApprovalAction = false;
boolean recruitmentCostApprovalAction = false;
boolean FTEApprovalAction = false;
boolean renovationCostApprovalAction = false;

boolean createTaskAction = false;
boolean updateTaskAction = false;
boolean deleteTaskAction = false;
boolean approveTaskAction = false;
boolean rejectTaskAction = false;

boolean upTaskOrderAction = false;
boolean downTaskOrderAction = false;

boolean createEvaluationAction = false;
boolean updateEvaluationAction = false;
boolean deleteEvaluationAction = false;

boolean createProgressAction = false;
boolean createAdminAction = false;
boolean createUserEvaluationAction = false;
boolean createAdminEvaluationAction = false;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("createGoal".equals(command)) {
	createGoalAction = true;
} else if ("updateGoal".equals(command)) {
	updateGoalAction = true;
} else if ("deleteGoal".equals(command)) {
	deleteGoalAction = true;
} else if ("approveGoal".equals(command)) {
	approveGoalAction = true;
} else if ("rejectGoal".equals(command)) {
	rejectGoalAction = true;
} else if ("approveTotalCost".equals(command)) {
	totalCostApprovalAction = true;
} else if ("approveEquipmentCost".equals(command)) {
	equipmentCostApprovalAction = true;
} else if ("approveRecruitmentCost".equals(command)) {
	recruitmentCostApprovalAction = true;
} else if ("approveFTE".equals(command)) {
	FTEApprovalAction = true;
} else if ("createTask".equals(command)) {
	createTaskAction = true;
} else if ("updateTask".equals(command)) {
	updateTaskAction = true;
} else if ("deleteTask".equals(command)) {
	deleteTaskAction = true;
} else if ("approveTask".equals(command)) {
	approveTaskAction = true;
} else if ("rejectTask".equals(command)) {
	rejectTaskAction = true;
} else if ("createEvaluation".equals(command)) {
	createEvaluationAction = true;
} else if ("updateEvaluation".equals(command)) {
	updateEvaluationAction = true;
} else if ("deleteEvaluation".equals(command)) {
	deleteEvaluationAction = true;
} else if ("createProgress".equals(command)) {
	createProgressAction = true;
} else if ("createAdmin".equals(command)) {
	createAdminAction = true;
} else if ("createUserEvaluation".equals(command)) {
	createUserEvaluationAction = true;
} else if ("createAdminEvaluation".equals(command)){
	createAdminEvaluationAction = true;
} else if ("upGoalOrder".equals(command)){
	upGoalOrderAction = true;
} else if ("downGoalOrder".equals(command)){
	downGoalOrderAction = true;
} else if ("upTaskOrder".equals(command)){
	upTaskOrderAction = true;
} else if ("downTaskOrder".equals(command)){
	downTaskOrderAction = true;
} else if ("approveRenovationCost".equals(command)){
	renovationCostApprovalAction = true;
}

if (fileUpload) {
	if (createAction && "1".equals(step)) {
		// get plan id with dummy data
		planID = CorporatePlanDB.add(userBean, fiscalYear, deptCode);
	}

	String[] fileList = (String[]) request.getAttribute("filelist");
	String[] goalDoc = (String[]) request.getAttribute("goalDoc_StringArray");
	String[] annualPlanDoc = (String[]) request.getAttribute("annualPlanDoc_StringArray");
	String[] pastPerformanceDoc = (String[]) request.getAttribute("pastPerformanceDoc_StringArray");
	String[] otherDoc = (String[]) request.getAttribute("otherDoc_StringArray");
	keyID = fiscalYear + deptCode + planID;

	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Corporate.Plan");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(fiscalYear);
		tempStrBuffer.append(deptCode);
		tempStrBuffer.append(planID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("upload");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Corporate.Plan");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(fiscalYear);
		tempStrBuffer.append(deptCode);
		tempStrBuffer.append(planID);
		String webUrl = tempStrBuffer.toString();

		if (goalDoc != null) {
			for (int i = 0; i < goalDoc.length; i++) {
				FileUtil.moveFile(
						ConstantsServerSide.UPLOAD_FOLDER + File.separator + goalDoc[i],
						baseUrl + "goal" + ConstantsVariable.DOT_VALUE + goalDoc[i]);
				DocumentDB.add(userBean, "corporate.plan.goal",
						keyID, webUrl, "goal" + ConstantsVariable.DOT_VALUE + goalDoc[i]);
			}
		}

		if (annualPlanDoc != null) {
			for (int i = 0; i < annualPlanDoc.length; i++) {
				FileUtil.moveFile(
						ConstantsServerSide.UPLOAD_FOLDER + File.separator + annualPlanDoc[i],
						baseUrl + "annual" + ConstantsVariable.DOT_VALUE + annualPlanDoc[i]);
				DocumentDB.add(userBean, "corporate.plan.annual",
						keyID, webUrl, "annual" + ConstantsVariable.DOT_VALUE + annualPlanDoc[i]);
			}
		}

		if (pastPerformanceDoc != null) {
			for (int i = 0; i < pastPerformanceDoc.length; i++) {
				FileUtil.moveFile(
						ConstantsServerSide.UPLOAD_FOLDER + File.separator + pastPerformanceDoc[i],
						baseUrl + "past" + ConstantsVariable.DOT_VALUE + pastPerformanceDoc[i]);
				DocumentDB.add(userBean, "corporate.plan.past",
						keyID, webUrl, "past" + ConstantsVariable.DOT_VALUE + pastPerformanceDoc[i]);
			}
		}

		if (otherDoc != null) {
			for (int i = 0; i < otherDoc.length; i++) {
				FileUtil.moveFile(
						ConstantsServerSide.UPLOAD_FOLDER + File.separator + otherDoc[i],
						baseUrl + "other" + ConstantsVariable.DOT_VALUE + otherDoc[i]);
				DocumentDB.add(userBean, "corporate.plan.other",
						keyID, webUrl, "other" + ConstantsVariable.DOT_VALUE + otherDoc[i]);
			}
		}
	}
}

try {
	if ("1".equals(step)) {
		if (createAction || updateAction) {
			// get plan id with dummy data
			if (createAction && planID == null) {
				planID = CorporatePlanDB.add(userBean, fiscalYear,
						deptCode);
			}
			if (CorporatePlanDB.update(userBean,
					fiscalYear, deptCode, planID, subject)) {
				if (createAction) {
					message = "plan created.";
					createAction = false;
				} else {
					message = "plan updated.";
					updateAction = false;
				}
				command = null;
				step = null;
			} else {
				if (createAction) {
					errorMessage = "plan create fail.";
				} else {
					errorMessage = "plan update fail.";
				}
			}
		} else if (deleteAction) {
			if (CorporatePlanDB.delete(userBean, fiscalYear,
					deptCode, planID)) {
				message = "plan removed.";
				closeAction = true;
			} else {
				errorMessage = "plan remove fail.";
			}
		} else if (createGoalAction) {
			goalID = CorporatePlanGoalDB.add(userBean,
					fiscalYear, deptCode, planID,
					goalDesc,
					corporateObjective, corporateObjectiveOther, focus, focusOther,
					setupCost, equipmentCost, recruitmentCost, FTE);
			if (goalID != null) {
				message = "goal added.";
				command = null;
				step = null;
			} else {
				errorMessage = "goal add fail.";
			}
		} else if (updateGoalAction) {
			if (CorporatePlanGoalDB.update(userBean,
					fiscalYear, deptCode, planID, goalID,
					goalDesc,
					corporateObjective, corporateObjectiveOther, focus, focusOther,
					setupCost, equipmentCost, recruitmentCost, FTE,renovationCost,
					setupCostActual, equipmentCostActual, recruitmentCostActual, FTEActual,renovationCostActual,
					totalCostRemark, totalCostApprovedRemark, totalCostActualRemark,
					recruitmentCostRemark,recruitmentCostApprovedRemark,recruitmentCostActualRemark,
					FTERemark,FTEApprovedRemark,FTEActualRemark,
					equipmentCostRemark,equipmentCostApprovedRemark,equipmentCostActualRemark,
					renovationCostRemark,renovationCostApprovedRemark,renovationCostActualRemark)) {
				message = "goal updated.";
				command = null;
				step = null;
			} else {
				errorMessage = "goal update fail.";
			}
		} else if (deleteGoalAction) {
			if (CorporatePlanGoalDB.delete(userBean,
					fiscalYear, deptCode, planID, goalID)) {
				message = "goal removed.";
				command = null;
				step = null;
				goalID = null;
			} else {
				errorMessage = "goal remove fail.";
			}
		} else if (approveGoalAction) {
			if (CorporatePlanGoalDB.approve(userBean,
					fiscalYear, deptCode, planID, goalID)) {
				message = "goal approved.";
				command = null;
				step = null;
			} else {
				errorMessage = "goal already approved.";
			}
		} else if (rejectGoalAction) {
			if (CorporatePlanGoalDB.reject(userBean,
					fiscalYear, deptCode, planID, goalID)) {
				message = "goal rejected.";
				command = null;
				step = null;
			} else {
				errorMessage = "goal already rejected.";
			}
		} else if (upGoalOrderAction){
			CorporatePlanGoalDB.updateOrder(userBean,fiscalYear, deptCode, planID, "up",goalOrder);
			command = null;
			step = null;
		} else if (downGoalOrderAction){
			CorporatePlanGoalDB.updateOrder(userBean,fiscalYear, deptCode, planID, "down",goalOrder);
			command = null;
			step = null;
		} else if (totalCostApprovalAction) {
			if (CorporatePlanGoalDB.approveTotalCost(userBean,
					fiscalYear, deptCode, planID, goalID, setupCostApproved)) {
				message = "setup cost approved.";
				command = null;
				step = null;
			} else {
				errorMessage = "setup cost approve fail.";
			}
		} else if (equipmentCostApprovalAction) {
			if (CorporatePlanGoalDB.approveEquipmentCost(userBean,
					fiscalYear, deptCode, planID, goalID, equipmentCostApproved)) {
				message = "equipment cost approved.";
				command = null;
				step = null;
			} else {
				errorMessage = "equipment cost approve fail.";
			}
		} else if (recruitmentCostApprovalAction) {
			if (CorporatePlanGoalDB.approveRecruitmentCost(userBean,
					fiscalYear, deptCode, planID, goalID, recruitmentCostApproved)) {
				message = "recruitment cost approved.";
				command = null;
				step = null;
			} else {
				errorMessage = "recruitment cost approve fail.";
			}
		} else if (FTEApprovalAction) {
			if (CorporatePlanGoalDB.approveFTE(userBean,
					fiscalYear, deptCode, planID, goalID, FTEApproved)) {
				message = "FTE approved.";
				command = null;
				step = null;
			} else {
				errorMessage = "FTE approve fail.";
			}
		} else if (renovationCostApprovalAction) {
			if (CorporatePlanGoalDB.approveRenovationCost(userBean,
					fiscalYear, deptCode, planID, goalID, renovationCostApproved)) {
				message = "Renovation Cost approved.";
				command = null;
				step = null;
			} else {
				errorMessage = "Renovation Cost approve fail.";
			}
		} else if (createTaskAction) {
			taskID = CorporatePlanTaskDB.add(userBean,
					fiscalYear, deptCode, planID, goalID,
					taskDesc, taskEstimateCompleteDate, taskActualCompleteDate, taskResponsibleByDeptCode, taskResponsibleByStaffID);
			if (taskID != null) {
				message = "task added.";
				command = null;
				step = null;
			} else {
				errorMessage = "task add fail.";
			}
		} else if (updateTaskAction) {
			if (CorporatePlanTaskDB.update(userBean,
					fiscalYear, deptCode, planID, goalID, taskID,
					taskDesc, taskEstimateCompleteDate, taskActualCompleteDate, taskResponsibleByDeptCode, taskResponsibleByStaffID)) {
				message = "task updated.";
				command = null;
				step = null;
			} else {
				errorMessage = "task update fail.";
			}
		} else if (deleteTaskAction) {
			if (CorporatePlanTaskDB.delete(userBean,
					fiscalYear, deptCode, planID, goalID, taskID)) {
				message = "task removed.";
				command = null;
				step = null;
				taskID = null;
			} else {
				errorMessage = "task remove fail.";
			}
		} else if (approveTaskAction) {
			if (CorporatePlanTaskDB.approve(userBean,
					fiscalYear, deptCode, planID, goalID, taskID)) {
				message = "task approved.";
				command = null;
				step = null;
			} else {
				errorMessage = "task already approved.";
			}
		} else if (rejectTaskAction) {
			if (CorporatePlanTaskDB.reject(userBean,
					fiscalYear, deptCode, planID, goalID, taskID)) {
				message = "task rejected.";
				command = null;
				step = null;
			} else {
				errorMessage = "task already rejected.";
			}
		} else if (upTaskOrderAction){
			CorporatePlanTaskDB.updateOrder(userBean,fiscalYear, deptCode, planID,goalID,"up",taskOrder);
			command = null;
			step = null;
		} else if (downTaskOrderAction){
			CorporatePlanTaskDB.updateOrder(userBean,fiscalYear, deptCode, planID,goalID,"down",taskOrder);
			command = null;
			step = null;
		} else if (createEvaluationAction) {
			evaluationID = CorporatePlanEvaluationDB.add(userBean,
					fiscalYear, deptCode, planID, goalID,
					evaluationType, evaluationTypeOther, evaluationObjective, targetRevenue, actualRevenue, targetCensus, actualCensus);
			if (evaluationID != null) {
				message = "evaluation added.";
				command = null;
				step = null;
			} else {
				errorMessage = "evaluation add fail.";
			}
		} else if (updateEvaluationAction) {
			if (CorporatePlanEvaluationDB.update(userBean,
					fiscalYear, deptCode, planID, goalID, evaluationID,
					evaluationType, evaluationTypeOther, evaluationObjective, targetRevenue, actualRevenue, targetCensus, actualCensus)) {
				message = "evaluation updated.";
				command = null;
				step = null;
			} else {
				errorMessage = "evaluation update fail.";
			}
		} else if (deleteEvaluationAction) {
			if (CorporatePlanEvaluationDB.delete(userBean,
					fiscalYear, deptCode, planID, goalID, evaluationID)) {
				message = "evaluation removed.";
				command = null;
				step = null;
				evaluationID = null;
			} else {
				errorMessage = "evaluation remove fail.";
			}
		} else if (createProgressAction) {
			String progressStatus = ParserUtil.getParameter(request, "progressStatus" + taskID);
			String progressDesc = ParserUtil.getParameter(request, "progressDesc" + taskID);
			if (CorporatePlanCommentDB.add(userBean, deptCode, fiscalYear, planID, goalID, "progress", taskID, progressStatus, progressDesc)) {
				message = "progress added.";
				command = null;
				step = null;
			}
		} else if (createAdminAction) {
			String adminContent = ParserUtil.getParameter(request, "adminContent" + taskID);
			if (CorporatePlanCommentDB.add(userBean, deptCode,fiscalYear, planID, goalID, "admin.remark", taskID, null, adminContent)) {
				message = "admin comment added.";
				command = null;
				step = null;
			}
		} else if (createUserEvaluationAction) {
			String evaluationUserComment = ParserUtil.getParameter(request, "evaluationUserComment" + evaluationID);
			if (CorporatePlanCommentDB.add(userBean, deptCode, fiscalYear, planID, goalID, "user.evaluation", evaluationID, null, evaluationUserComment)) {
				message = "evaluation comment added.";
				command = null;
				step = null;
			}
		} else if (createAdminEvaluationAction){
			String evaluationAdminComment = ParserUtil.getParameter(request, "evaluationAdminComment" + evaluationID);
			if (CorporatePlanCommentDB.add(userBean, deptCode, fiscalYear, planID, goalID, "admin.evaluation", evaluationID, null, evaluationAdminComment)) {
				message = "evaluation comment added.";
				command = null;
				step = null;
			}
		}
	} else if (createAction) {
		planID = "";
		subject = "Annual Plan";
		deptCode = userBean.getDeptCode();
		modifiedUser = userBean.getUserName();
		modifiedDate = DateTimeUtil.getCurrentDateTime();
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (planID != null && planID.length() > 0) {
			ArrayList record = CorporatePlanDB.get(userBean, fiscalYear, deptCode, planID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				deptCode = row.getValue(0);
				deptDesc = row.getValue(1);
				fiscalYear = row.getValue(2);
				planID = row.getValue(3);
				subject = row.getValue(4);
				modifiedUser = row.getValue(5);
				modifiedDate = row.getValue(6);
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

String allowRemove = createAction || updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;

//handle empty
if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
if (goalID == null) { goalID = ConstantsVariable.EMPTY_VALUE; }
if (taskID == null) { taskID = ConstantsVariable.EMPTY_VALUE; }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
	Licensed to the Apache Software Foundation (ASF) under one or more
	contributor license agreements.  See the NOTICE file distributed with
	this work for additional information regarding copyright ownership.
	The ASF liCensus this file to You under the Apache License, Version 2.0
	(the "License"); you may not use this file except in compliance with
	the License.  You may obtain a copy of the License at

		 http://www.apache.org/liCensus/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<%	if (userBean.isLogin() && closeAction) { %>
<script type="text/javascript">window.close();</script>
<%	} else { %>
<style>
#rowTask td {
	vertical-align: text-top;
}
</style>
<body>
<jsp:include page="../common/banner2.jsp" />
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.corporate.plan." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="Corporate" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" enctype="multipart/form-data" action="corporate_plan.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu"
	border="0">
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="2">ID</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><font color="red">*</font>Subject</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="subject" value="<%=subject==null?"":subject %>" maxlength="100" size="50"> (max 100 characters)
<%	} else { %>
			<%=subject == null ? "" : subject.toUpperCase()%>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message
			key="prompt.fiscalYear" /></td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="fiscalYear" />
	<jsp:param name="day_yy" value="<%=fiscalYear %>" />
	<jsp:param name="yearRange" value="1" />
	<jsp:param name="isYearOnly" value="Y" />
	<jsp:param name="isYearOrderDesc" value="Y" />
</jsp:include>
<%	} else { %>
			<%=fiscalYear == null ? "" : fiscalYear.toUpperCase()%>
			<input type="hidden" name="fiscalYear_yy" value="<%=fiscalYear %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message
			key="prompt.department" /></td>
		<td class="infoData" width="70%">
<%	if (createAction) {	%>
			<select name="deptCode">
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="allowAll" value="<%=allowAll %>" />
</jsp:include>
			</select>
<% 	} else { %>
			<%=deptDesc == null ? "" : deptDesc%>
			<input type="hidden" name="deptCode" value="<%=deptCode %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Name</td>
		<td class="infoData" width="70%"><%=modifiedUser %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Submit Date</td>
		<td class="infoData" width="70%"><%=modifiedDate %></td>
	</tr>
<%	if (!createAction && !updateAction) { %>
<jsp:include page="corporate_plan_goal.jsp" flush="false">
	<jsp:param name="command" value="<%=command %>" />
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
	<jsp:param name="goalDesc" value="<%=goalDesc %>" />
</jsp:include>
<%	} %>
	<tr>
		<td colspan="2"><font color="red">*</font>Compulsory fields</td>
	</tr>
</table>
<%Map<String, String> tooltipMap = new HashMap<String, String>();
tooltipMap.put("planAction","Click [Update Corporate Direction and Strategies]to update the the subject of the Plan");
tooltipMap.put("planSave","Click save to save the plan");
%>
<%	if (!createGoalAction && (goalID == null || goalID.length() == 0)) { %>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center" title="<%=tooltipMap.get("planAction") %>">
<%		if (createAction || updateAction || deleteAction) { %>
			<button title="<%=tooltipMap.get("planSave") %>" onclick="return submitAction('<%=commandType %>', 1, '');" class="btn-click"><bean:message key="button.save" /> Plan</button>
			<button onclick="return submitAction('view', 0, '');" class="btn-click"><bean:message key="button.cancel" /> Plan</button>
<%		} else { %>
			<button onclick="return submitAction('update', 0, '');" class="btn-click"><bean:message key="function.corporate.plan.update" /></button>
			<button class="btn-delete"><bean:message key="function.corporate.plan.delete" /></button>
<%		} %>
		</td>
	</tr>
</table>
</div>
<%	} %>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="planID" value="<%=planID == null ? "" : planID %>">
<input type="hidden" name="goalID" value="<%=goalID == null ? "" : goalID %>">
<input type="hidden" name="taskID" value="<%=taskID == null ? "" : taskID %>">
<input type="hidden" name="evaluationID" value="<%=evaluationID == null ? "" : evaluationID %>">
<input type="hidden" name="deptDesc" value="<%=deptDesc == null ? "" : deptDesc %>">
<input type="hidden" name="goalOrder" value="<%=goalOrder == null ? "" : goalOrder %>">
<input type="hidden" name="taskOrder" value="<%=taskOrder == null ? "" : taskOrder %>">

</form>
<script language="javascript">
<!--//



$('td[title]').qtip({
	   content: $(this).attr('title'),
	   show: 'mouseover',
	   hide: 'mouseout',
	   position: { target: 'mouse' },
	   style: {
		      border: {
		         width: 3,
		         radius: 8,
		         color: '#6699CC',
		         tip: 'leftMiddle'
		      },
		      width: 200
		}
	});

$('button[title]').qtip({
	   content: $(this).attr('title'),
	   show: 'mouseover',
	   hide: 'mouseout',
	   position: { target: 'mouse' },
	   style: {
		      border: {
		         width: 3,
		         radius: 8,
		         color: '#6699CC',
		         tip: 'leftMiddle'
		      },
		      width: 200
		}
	});

$('select[title]').qtip({
	   content: $(this).attr('title'),
	   show: 'mouseover',
	   hide: 'mouseout',
	   position: { target: 'mouse' },
	   style: {
		      border: {
		         width: 3,
		         radius: 8,
		         color: '#6699CC',
		         tip: 'leftMiddle'
		      },
		      width: 200
		}
	});

$('a[title]').qtip({
	   content: $(this).attr('title'),
	   show: 'mouseover',
	   hide: 'mouseout',
	   position: { target: 'mouse' },
	   style: {
		      border: {
		         width: 3,
		         radius: 8,
		         color: '#6699CC',
		         tip: 'leftMiddle'
		      },
		      width: 200
		}
	});

$('table[title]').qtip({
	   content: $(this).attr('title'),
	   show: 'mouseover',
	   hide: 'mouseout',
	   position: { target: 'mouse' },
	   style: {
		      border: {
		         width: 3,
		         radius: 8,
		         color: '#6699CC',
		         tip: 'leftMiddle'
		      },
		      width: 200
		}
	});

	function changeCorporateObjectiveStyle() {
		var corporateObjective = document.forms["form1"].elements["corporateObjective"].value;
		var corporateObjectiveOther = document.forms["form1"].elements["corporateObjectiveOther"];

		if (corporateObjective == "Others"){
			corporateObjectiveOther.style.display = "block";
		} else {
			corporateObjectiveOther.style.display = "none";
			corporateObjectiveOther.value = '';
    	}
	}

	function changeFocusStyle() {
		var focus = document.forms["form1"].elements["focus"].value;
		var focusOther = document.forms["form1"].elements["focusOther"];

		if (focus == "Others"){
			focusOther.style.display = "block";
		} else {
			focusOther.style.display = "none";
			focusOther.value = '';
		}
	}

	function changeEvaluateDisplayStyle() {
		var evaluationType = document.forms["form1"].elements["evaluationType"].value;
		var evaluationTypeOther = document.forms["form1"].elements["evaluationTypeOther"];
		var targetRevenue = document.forms["form1"].elements["targetRevenue"];
		var actualRevenue = document.forms["form1"].elements["actualRevenue"];
		var targetCensus = document.forms["form1"].elements["targetCensus"];
		var actualCensus = document.forms["form1"].elements["actualCensus"];

		if (evaluationType == "Increase Revenue"){
			targetRevenue.style.display = "block";
			actualRevenue.style.display = "block";
		} else {
			targetRevenue.style.display = "none";
			actualRevenue.style.display = "none";
			targetRevenue.value = '';
			actualRevenue.value = '';
		}

		if (evaluationType == "Increase Census"){
			targetCensus.style.display = "block";
			actualCensus.style.display = "block";
		} else {
			targetCensus.style.display = "none";
			actualCensus.style.display = "none";
			targetCensus.value = '';
			actualCensus.value = '';
		}

		if (evaluationType == "Others"){
			evaluationTypeOther.style.display = "block";
		} else {
			evaluationTypeOther.style.display = "none";
			evaluationTypeOther.value = '';
		}
	}

	function submitAction(cmd, stp, id) {
		if (stp == 1 && (cmd == 'create' || cmd == 'update')) {
			if (document.form1.subject.value == '') {
				alert("Empty Plan Subject.");
				document.form1.subject.focus();
				return false;
			}
		} else if (cmd == 'createGoal' || cmd == 'updateGoal') {
			document.form1.goalID.value = id;
			if (stp == 1 && document.form1.skipGoalDesc.value == 'N') {
				if (document.form1.goalDesc.value == '') {
					alert("Empty Goal Description.");
					document.form1.goalDesc.focus();
					return false;
				} else if (document.form1.goalDesc.value.length > 300) {
					alert("Goal Description must be less than 300 characters.");
					document.form1.goalDesc.focus();
					return false;
				}
			}
		} else if (cmd == 'deleteGoal' || cmd == 'approveGoal' || cmd == 'rejectGoal') {
			document.form1.goalID.value = id;
		} else if (cmd == 'viewGoal') {
			document.form1.goalID.value = '';
		} else if (cmd == "upGoalOrder" || cmd=="downGoalOrder"){
			document.form1.goalOrder.value = id;
		} else if (cmd == "upTaskOrder" || cmd=="downTaskOrder"){
			document.form1.taskOrder.value = id;
		} else if (cmd == 'approveTotalCost' && document.form1.setupCostApproved.value == '') {
			alert("Empty Setup Cost Approved Budget.");
			document.form1.setupCostApproved.focus();
			return false;
		} else if (cmd == 'approveEquipmentCost' && document.form1.equipmentCostApproved.value == '') {
			alert("Empty Equipment Cost Approved Budget.");
			document.form1.equipmentCostApproved.focus();
			return false;
		} else if (cmd == 'approveRecruitmentCost' && document.form1.recruitmentCostApproved.value == '') {
			alert("Empty Recruitment Cost Approved Budget.");
			document.form1.recruitmentCostApproved.focus();
			return false;
		} else if (cmd == 'approveFTE' && document.form1.FTEApproved.value == '') {
			alert("Empty FTE Approved Budget.");
			document.form1.FTEApproved.focus();
			return false;
		} else if (cmd == 'createTask' || cmd == 'updateTask') {
			document.form1.taskID.value = id;
			if (stp == 1) {
				if (document.form1.taskDesc.value == '') {
					alert("Empty Task Description.");
					document.form1.taskDesc.focus();
					return false;
				} else if (document.form1.taskDesc.value.length > 300) {
					alert("Task Description must be less than 300 characters.");
					document.form1.taskDesc.focus();
					return false;
				}
			}
		} else if (cmd == 'approveTask' || cmd == 'rejectTask') {
			document.form1.taskID.value = id;
		} else if (cmd == 'createEvaluation' || cmd == 'updateEvaluation' || cmd == 'deleteEvaluation') {
			document.form1.evaluationID.value = id;
		} else if (cmd == 'createProgress') {
			document.form1.taskID.value = id;
			var progressDesc = eval('document.form1.progressDesc' + id);
			if (progressDesc.value == '') {
					alert("Progress Remarks Description.");
					progressDesc.focus();
					return false;
			} else if (progressDesc.value == '') {
				alert("Progress Remarks must be less than 300 characters.");
				progressDesc.focus();
				return false;
			}
		} else if (cmd == 'createAdmin') {
			document.form1.taskID.value = id;
			var adminContent = eval('document.form1.adminContent' + id);
			if (adminContent.value == '') {
					alert("Empty Admin Comment.");
					adminContent.focus();
					return false;
			} else if (adminContent.value == '') {
				alert("Admin Comment must be less than 300 characters.");
				adminContent.focus();
				return false;
			}
		} else if (cmd == 'createUserEvaluation') {
			document.form1.evaluationID.value = id;
			var evaluationUserComment = eval('document.form1.evaluationUserComment' + id);
			if (evaluationUserComment.value == '') {
					alert("Empty Department Comment.");
					evaluationUserComment.focus();
					return false;
			} else if (evaluationUserComment.value == '') {
				alert("Department Comment must be less than 300 characters.");
				evaluationUserComment.focus();
				return false;
			}
		} else if (cmd == 'createAdminEvaluation') {
			document.form1.evaluationID.value = id;
			var evaluationAdminComment = eval('document.form1.evaluationAdminComment' + id);
			if (evaluationAdminComment.value == '') {
					alert("Empty Admin Comment.");
					evaluationAdminComment.focus();
					return false;
			} else if (evaluationAdminComment.value == '') {
				alert("Admin Comment must be less than 300 characters.");
				evaluationAdminComment.focus();
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function removeDocument(mid, did) {
		http.open('get', '../common/document_list.jsp?command=delete&moduleCode=' + mid + '&keyID=<%=keyID %>&documentID=' + did + '&allowRemove=Y&timestamp=<%=(new java.util.Date()).getTime() %>');

		//store module code
		currModuleCode = mid;

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById(currModuleCode + '_indicator').innerHTML = response;
		}
	}

	function changeStaffID() {
		var deptCode = document.form1.selectedTaskResponsibleByDeptCode.value;
		$.ajax({
			type: "POST",
			url: "corporate_plan_task_response_by.jsp",
			data: "deptCode=" + deptCode,
			success: function(values){
			if(values != '') {
				$("#staff-container").html("<select name='selectedTaskResponsibleByStaffID'>" + values + "</select>");
			}//if
			}//success
		});//$.ajax
	}

	function addTaskResponsibleBy(field) {
		var deptCode = '';
		var staffID = '';
		if (field == 'deptCode') {
			deptCode = document.form1.selectedTaskResponsibleByDeptCode.value;
		} else if (field == 'staffID') {
			staffID = document.form1.selectedTaskResponsibleByStaffID.value;
		}
		$.ajax({
			type: "POST",
			url: "corporate_plan_task_response_list.jsp",
			data: "command=add&isAllowUpdateYN=Y&byDeptCode=" + deptCode + "&byStaffID=" + staffID,
			success: function(values){
			if(values != '') {
				$("#taskResponsibleBy-container").html(values);
			}//if
			}//success
		});//$.ajax
	}

	function removeTaskResponsibleBy(field, id) {
		var deptCode = '';
		var staffID = '';
		if (field == 'deptCode') {
			deptCode = id;
		} else if (field == 'staffID') {
			staffID = id;
		}
		$.ajax({
			type: "POST",
			url: "corporate_plan_task_response_list.jsp",
			data: "command=remove&isAllowUpdateYN=Y&byDeptCode=" + deptCode + "&byStaffID=" + staffID,
			success: function(values){
			if(values != '') {
				$("#taskResponsibleBy-container").html(values);
			}//if
			}//success
		});//$.ajax
	}
//-->
</script></DIV>

</DIV>
</DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%
	}
%>
</html:html>