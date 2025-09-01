<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

// For admin ONLY
if (userBean == null || !userBean.isAdmin()) {
	return;
}

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");

String moduleCode = ParserUtil.getParameter(request, "moduleCode");
String baID = ParserUtil.getParameter(request, "baID");
String renewID = ParserUtil.getParameter(request, "renewID");
String dept = ParserUtil.getParameter(request, "dept");
String deptCodeRequest = ParserUtil.getParameter(request, "deptCodeRequest");
String deptDescRequest = null;
String deptCodeResponse = ParserUtil.getParameter(request, "deptCodeResponse");
String deptDescResponse = null;
String corporationName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "corporationName"));
String businessType = ParserUtil.getParameter(request, "businessType");
String businessNature = ParserUtil.getParameter(request, "businessNature");
String businessInfo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "businessInfo"));
String contractDateFrom = ParserUtil.getParameter(request, "contractDateFrom");
String contractDateTo = ParserUtil.getParameter(request, "contractDateTo");
String optCurrency = ParserUtil.getParameter(request, "optCurrency");
String optAmount = ParserUtil.getParameter(request, "optAmount");
String optUnit = ParserUtil.getParameter(request, "optUnit");
String status = ParserUtil.getParameter(request, "status");
String corporationCode = ParserUtil.getParameter(request, "corporationCode");
String contractRemark = ParserUtil.getParameter(request, "contractRemark");
if ("Write a comment...".equals(contractRemark)) {
	contractRemark = "";
}

String deptTemp = null;
String firstContactDate = ParserUtil.getParameter(request, "firstContactDate");
String updateDate = ParserUtil.getParameter(request, "updateDate");
String progress = ParserUtil.getParameter(request,"progress");

String contingency = ParserUtil.getParameter(request, "contingency");
String[] assoDeptCodeRequestId = (String[]) request.getAttribute("assoDeptCodeRequestId_StringArray");
String[] assoDeptCodeRequest = (String[]) request.getAttribute("assoDeptCodeRequest_StringArray");

String relatedHAAID = ParserUtil.getParameter(request, "relatedHAAID");
String oldStatus = null;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");



ArrayList record = BillingAgreementDB.get(userBean, moduleCode, baID);
if (record.size() > 0) {
	ReportableListObject row = (ReportableListObject) record.get(0);
	corporationName = row.getValue(1);
	businessType = row.getValue(2);
	businessNature = row.getValue(3);
	contractDateFrom = row.getValue(4);
	contractDateTo = row.getValue(5);
	status = row.getValue(6);
	corporationCode = row.getValue(8);
	contractRemark = row.getValue(9);
	deptCodeRequest = row.getValue(10);
	deptDescRequest = row.getValue(11);
	deptCodeResponse = row.getValue(12);
	deptDescResponse = row.getValue(13);
	businessInfo = row.getValue(14);
	optCurrency = row.getValue(15);
	optAmount = row.getValue(16);
	optUnit = row.getValue(17);
	contingency = row.getValue(18);
	
	
	oldStatus = status;
	// update status only
	status = ParserUtil.getParameter(request, "status");


	boolean isExternal = false;
	String docCode = null;
	if ("marketing".equals(moduleCode)) {
		isExternal = false;
		docCode = "bam";
	} else {
		isExternal = true;
		docCode = "bae";
	}
	String docID = "";
	
	
	boolean updateAction = false;
	
	if ("update".equals(command)) {
		updateAction = true;
	}
	
	try {
		if ("1".equals(step)) {
			if (updateAction) {
				System.out.println("[ba] batch_update_status.jsp baID="+baID+", updateAction="+updateAction+",moduleCode="+moduleCode+", isExternal=" + isExternal + ", oldStatus="+oldStatus+", status="+status);
				
				// call db update corporation name, business type
				if (BillingAgreementDB.update(userBean, moduleCode, baID,
						deptCodeRequest, deptCodeResponse, corporationName,
						businessType, businessNature, businessInfo,
						contractDateFrom, contractDateTo,
						optCurrency, optAmount, optUnit,
						status, corporationCode, contractRemark,contingency==null?"":contingency)) {
	
					// delete all first
					BillingAgreementDB.deleteAllChild(userBean, moduleCode, baID);
	
					// save associate request department
					if (assoDeptCodeRequest != null) {
						for (int i = 0; i < assoDeptCodeRequest.length; i++) {
							if (assoDeptCodeRequestId != null &&
									assoDeptCodeRequestId[i] != null && !assoDeptCodeRequestId[i].isEmpty()) {
								// update
								BillingAgreementDB.updateAssoDept(userBean, moduleCode,
										assoDeptCodeRequestId[i], baID, assoDeptCodeRequest[i]);
							} else {
								// create
								assoDeptCodeRequestId[i] = BillingAgreementDB.insertAssoDept(userBean, moduleCode, baID, assoDeptCodeRequest[i]);
							}
						}
					}
	
					if (isExternal) {
						BillingAgreementDB.updateApproval(userBean, moduleCode, baID,
								deptCodeRequest, businessInfo, optCurrency, optAmount,
								optUnit, contractRemark, assoDeptCodeRequest, assoDeptCodeRequestId, renewID,
								contractDateFrom, contractDateTo, true);
						//BillingAgreementDB.sendEMail(userBean, moduleCode, baID, "Update Agreement");
					}
					message = "Billing agreement updated.";
					updateAction = false;
				} else {
					errorMessage = "Billing agreement update fail.";
				}
			}
			step = null;
	
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
} else {
	errorMessage = "No record for site:" + ConstantsServerSide.SITE_CODE + ", moduleCode:" + moduleCode + ", baID:" + baID;
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<h1>Update BA status</h1>
<hr />
<div>
command=<%=command %><br />
step=<%=step %><br />
moduleCode=<%=moduleCode %><br />
baID=<%=baID %><br />
update status from <%=oldStatus %> to <%=status %>
<hr />
message=<%=message %><br />
errorMessage=<%=errorMessage %>
</div>
</html:html>