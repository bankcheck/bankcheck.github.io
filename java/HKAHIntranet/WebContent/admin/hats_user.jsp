<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList fetchUserRole() {
		// fetch group
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ROLID, ROLDESC ");
		sqlStr.append("FROM   ROLE ");
		sqlStr.append("ORDER BY ROLDESC ");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}

	private ArrayList fetchUserRoleByUser(String userID) {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT R.ROLID, R.ROLDESC ");
		sqlStr.append("FROM   ROLE R, USRROLE UR ");
		sqlStr.append("WHERE  R.ROLID = UR.ROLID ");
		sqlStr.append("AND    UR.UsrID = ? ");
		sqlStr.append("ORDER BY R.ROLDESC");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { userID });
	}

	private ArrayList fetchFunction() {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT FSCID, FSCDESC ");
		sqlStr.append("FROM   FuncSec ");
		sqlStr.append("ORDER BY FSCDESC");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}

	private ArrayList fetchFunctionByUser(String userID) {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT FSCID, FSCDESC ");
		sqlStr.append("FROM   FuncSec ");
		sqlStr.append("WHERE  FscID IN ( ");
		sqlStr.append(" SELECT RFS.FscID ");
		sqlStr.append(" FROM   UsrRole UR, RoleFuncSec RFS ");
		sqlStr.append(" WHERE  UR.RolID = RFS.RolID ");
		sqlStr.append(" AND    UR.UsrID = ? ");
		sqlStr.append(" UNION ");
		sqlStr.append(" SELECT FscID ");
		sqlStr.append(" FROM   UsrFuncSec ");
		sqlStr.append(" WHERE  UsrID = ? ");
		sqlStr.append(") ");
		sqlStr.append("ORDER BY FSCDESC");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { userID, userID });
	}

	private ArrayList fetchFunctionByUserIndividual(String userID) {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT FSCID, FSCDESC ");
		sqlStr.append("FROM   FuncSec ");
		sqlStr.append("WHERE  FscID IN ( ");
		sqlStr.append(" SELECT FscID ");
		sqlStr.append(" FROM   UsrFuncSec ");
		sqlStr.append(" WHERE  UsrID = ? ");
		sqlStr.append(") ");
		sqlStr.append("ORDER BY FSCDESC");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { userID });
	}

	private ArrayList fetchCashier(String userID) {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CSHCODE ");
		sqlStr.append("FROM   Cashier ");
		sqlStr.append("WHERE  UsrID = ? ");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { userID });
	}

	private ArrayList fetchCashierByCode(String cshCode) {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CSHCODE ");
		sqlStr.append("FROM   Cashier ");
		sqlStr.append("WHERE  CSHCODE = ? ");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { cshCode });
	}

	private ArrayList fetchAppointmentAccessDoctor() {
		// fetch appointment by doctor
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE, DOCFNAME || ' ' || DOCGNAME || ' (' || DOCCODE || ')'");
		sqlStr.append("FROM   DOCTOR ");
		sqlStr.append("WHERE  DOCSTS = -1 ");
		sqlStr.append("ORDER BY DOCFNAME, DOCGNAME, DOCCODE ");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}

	private ArrayList fetchAppointmentAccessDoctorByUser(String userID) {
		// fetch appointment by doctor
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.DOCCODE, D.DOCFNAME || ' ' || D.DOCGNAME || ' (' || D.DOCCODE || ')'");
		sqlStr.append("FROM   DOCTOR D, USRACCESSDOC U ");
		sqlStr.append("WHERE  D.DOCCODE = U.DOCCODE ");
		sqlStr.append("AND    D.DOCSTS = -1 ");
		sqlStr.append("AND    U.SPCCODE = 'ALL' ");
		sqlStr.append("AND    U.UsrID = ? ");
		sqlStr.append("ORDER BY D.DOCFNAME, D.DOCGNAME, D.DOCCODE ");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { userID });
	}

	private ArrayList fetchAppointmentAccessSpecality() {
		// fetch appointment by specality
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT SPCCODE, SPCNAME ");
		sqlStr.append("FROM   SPEC ");
		sqlStr.append("ORDER BY SPCNAME ");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}

	private ArrayList fetchAppointmentAccessSpecalityByUser(String userID) {
		// fetch appointment by specality
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.SPCCODE, S.SPCNAME ");
		sqlStr.append("FROM   SPEC S, USRACCESSDOC U ");
		sqlStr.append("WHERE  S.SPCCODE = U.SPCCODE ");
		sqlStr.append("AND    U.DOCCODE = 'ALL' ");
		sqlStr.append("AND    U.UsrID = ? ");
		sqlStr.append("ORDER BY S.SPCNAME ");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { userID });
	}

	private ArrayList<ReportableListObject> getList(String userID) {
		return UtilDBWeb.getReportableListHATS("SELECT USRNAME, USRSTS, USRINP, USROUT, USRDAY, USRPBO FROM USR WHERE USRID = ?", new String[] { userID });
	}

	private boolean add(UserBean userBean, String userID, String userName, String status, String isInp, String isOut, String isDay, String isPbo) {
		if (UtilDBWeb.updateQueueHATS(
				"INSERT INTO USR(USRID, USRPWD, USRNAME, USRSTS, USRINP, USROUT, USRDAY, USRPBO) VALUES (?, 'PASSWORD', ?, ?, ?, ?, ?, ?)",
				new String[] { userID, userName, status, isInp, isOut, isDay, isPbo })) {
			return UtilDBWeb.updateQueueHATS(
				"INSERT INTO USERSITE(URSID, USRID, STECODE) VALUES ((SELECT MAX(URSID) + 1 FROM USERSITE), ?, CASE WHEN GET_CURRENT_STECODE = 'AMC2' THEN 'HKAH' ELSE GET_CURRENT_STECODE END)",
				new String[] { userID });
		} else {
			return false;
		}
	}

	private boolean update(UserBean userBean, String userID, String userName, String status, String isInp, String isOut, String isDay, String isPbo) {
		return UtilDBWeb.updateQueueHATS(
				"UPDATE USR SET USRNAME = ?, USRSTS = ?, USRINP = ?, USROUT = ?, USRDAY = ?, USRPBO = ? WHERE USRID = ?",
				new String[] { userName, status, isInp, isOut, isDay, isPbo, userID });
	}

	private boolean delete(UserBean userBean, String userID) {
		return UtilDBWeb.updateQueueHATS(
				"UPDATE USR SET USRSTS = 0 WHERE USRID = ?",
				new String[] { userID });
	}

	private boolean addCashierCode(UserBean userBean, String cshCode, String userID) {
		return UtilDBWeb.updateQueueHATS(
				"INSERT INTO CASHIER(CSHCODE, USRID, CSHSTS, CSHRCNT, CSHSID, STECODE, CSHADV, CSHPAYIN, CSHPAYOUT, CSHREC, CSHCHQ, CSHEPS, CSHCARD, CSHOTHER, CSHCRCNT, CSHVCNT, CSHATP, CSHATPOUT, CSHCHQOUT, CSHCARDOUT, CSHOCTOUT, CSHOCTIN, CSHCUPOUT, CSHCUPIN) VALUES (?, ?, 'C', 0, SEQ_CASHIER_SID.NEXTVAL, CASE WHEN GET_CURRENT_STECODE = 'AMC2' THEN 'HKAH' ELSE GET_CURRENT_STECODE END, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)",
				new String[] { cshCode.toUpperCase(), userID });
	}

	private boolean updateFunctionID(UserBean userBean, String userID, String[] functionID) {
		boolean success = true;
		// clear old function id
		success = UtilDBWeb.updateQueueHATS("DELETE USRFUNCSEC WHERE USRID = ?", new String[] { userID });

		// add function id
		if (functionID != null && functionID.length > 0) {
			for (int i = 0; i < functionID.length; i++) {
				UtilDBWeb.updateQueueHATS("INSERT INTO USRFUNCSEC (USRID, FSCID) VALUES (?, ?)", new String[] { userID, functionID[i] });
			}
		}

		return success;
	}

	private String getRoleSeq() {
		// fetch group
		ArrayList record = UtilDBWeb.getReportableListHATS("SELECT COUNT(1) FROM USRROLE");
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			if (ConstantsVariable.ZERO_VALUE.equals(row.getValue(0))) {
				return ConstantsVariable.ONE_VALUE;
			} else {
				record = UtilDBWeb.getReportableListHATS("SELECT MAX(UROID) + 1 FROM USRROLE");
				if (record.size() > 0) {
					row = (ReportableListObject) record.get(0);
					return row.getValue(0);
				}
			}
		}
		return null;
	}

	private boolean updateRole(UserBean userBean, String userID, String[] noLevelGroupID) {
		boolean success = true;
		// clear old role
		success = UtilDBWeb.updateQueueHATS("DELETE USRROLE WHERE USRID = ?", new String[] { userID });

		// add new role
		if (noLevelGroupID != null && noLevelGroupID.length > 0) {
			for (int i = 0; i < noLevelGroupID.length; i++) {
				UtilDBWeb.updateQueueHATS("INSERT INTO USRROLE (UROID, USRID, ROLID, STECODE) VALUES (?, ?, ?, CASE WHEN GET_CURRENT_STECODE = 'AMC2' THEN 'HKAH' ELSE GET_CURRENT_STECODE END)", new String[] { getRoleSeq(), userID, noLevelGroupID[i] });
			}
		}

		return success;
	}

	private boolean updateAppointmentAccessDoctor(UserBean userBean, String userID, String[] userAccessDocCode) {
		boolean success = true;
		// clear old doctor
		success = UtilDBWeb.updateQueueHATS("DELETE USRACCESSDOC WHERE USRID = ? AND SPCCODE = 'ALL'", new String[] { userID });

		// add new specailty
		if (userAccessDocCode != null && userAccessDocCode.length > 0) {
			for (int i = 0; i < userAccessDocCode.length; i++) {
				UtilDBWeb.updateQueueHATS("INSERT INTO USRACCESSDOC (USRID, DOCCODE, SPCCODE) VALUES (?, ?, 'ALL')", new String[] { userID, userAccessDocCode[i] });
			}
		}

		return success;
	}

	private boolean updateAppointmentAccessSpecality(UserBean userBean, String userID, String[] userAccessSpecCode) {
		boolean success = true;
		// clear old specailty
		success = UtilDBWeb.updateQueueHATS("DELETE USRACCESSDOC WHERE USRID = ? AND DOCCODE = 'ALL'", new String[] { userID });

		// add new specailty
		if (userAccessSpecCode != null && userAccessSpecCode.length > 0) {
			for (int i = 0; i < userAccessSpecCode.length; i++) {
				UtilDBWeb.updateQueueHATS("INSERT INTO USRACCESSDOC (USRID, DOCCODE, SPCCODE) VALUES (?, 'ALL', ?)", new String[] { userID, userAccessSpecCode[i] });
			}
		}

		return success;
	}
%>
<%
UserBean userBean = new UserBean(request);

String command = (String) request.getAttribute("command");
if (command == null) {
	command = request.getParameter("command");
}
String step = (String) request.getParameter("step");
if (step == null) {
	step = request.getParameter("step");
}
String userID = request.getParameter("userID");
String userName = request.getParameter("userName");
String status = request.getParameter("status");
String isInp = request.getParameter("isInp");
String isOut = request.getParameter("isOut");
String isDay = request.getParameter("isDay");
String isPbo = request.getParameter("isPbo");
String cshCode = request.getParameter("cshCode");

String functionID[] = request.getParameterValues("functionID");
String functionIDDesc[] = null;
String functionIDAvailable[] = null;
String functionIDDescAvailable[] = null;

String noLevelGroupID[] = request.getParameterValues("noLevelGroupID");
String noLevelGroupDesc[] = null;
String noLevelGroupIDAvailable[] = null;
String noLevelGroupDescAvailable[] = null;

String userAccessDocCode[] = request.getParameterValues("userAccessDocCode");
String userAccessDocDesc[] = null;
String userAccessDocCodeAvailable[] = null;
String userAccessDocDescAvailable[] = null;

String userAccessSpecCode[] = request.getParameterValues("userAccessSpecCode");
String userAccessSpecDesc[] = null;
String userAccessSpecCodeAvailable[] = null;
String userAccessSpecDescAvailable[] = null;

ArrayList record = null;
ReportableListObject row = null;

boolean loginAction = false;
boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean cashierAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command) || !userBean.isLogin()) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("cashierCode".equals(command)) {
	cashierAction = true;
}

try {
	if ("1".equals(step)) {
		boolean found = false;
		if (userID != null && userID.length() > 0) {
			userID = userID.toUpperCase();
			userName = userName == null ? null : userName.toUpperCase();
			
			record = getList(userID);
			found = record.size() > 0;
		}

		if (createAction) {
			if (found) {
				errorMessage = "HATS user create fail due to already exists.";
			} else if (add(userBean, userID, userName, status, isInp, isOut, isDay, isPbo)) {
				message = "HATS user is created.";
				createAction = false;
				step = "0";
			} else {
				errorMessage = "HATS user fail to create.";
			}
		} else if (updateAction) {
			if (!found) {
				errorMessage = "HATS user update fail due to not exists.";
			} else if (update(userBean, userID, userName, status, isInp, isOut, isDay, isPbo)) {
				updateFunctionID(userBean, userID, functionID);
				updateRole(userBean, userID, noLevelGroupID);
				updateAppointmentAccessDoctor(userBean, userID, userAccessDocCode);
				updateAppointmentAccessSpecality(userBean, userID, userAccessSpecCode);

				message = "HATS user is updated.";
				updateAction = false;
				step = "0";
			} else {
				errorMessage = "HATS user fail to update.";
			}
		} else if (deleteAction) {
			if (!found) {
				errorMessage = "HATS user fail to update due to not exists.";
			} else if (delete(userBean, userID)) {
				message = "HATS user removed.";
				closeAction = true;
			} else {
				errorMessage = "HATS user fail to remove.";
			}
		} else if (cashierAction) {
			if (cshCode != null && cshCode.length() > 0) {
				// load cashier
				record = fetchCashier(userID);
				if (record.size() == 0) {
					record = fetchCashierByCode(cshCode);
					if (record.size() == 0) {
						if (addCashierCode(userBean, cshCode, userID)) {
							message = "Cashier code is added.";
							cashierAction = false;
							step = "0";
						} else {
							errorMessage = "Cashier code fail to update.";
						}
					} else {
						errorMessage = "New cashier code - " + cshCode + " is not available.";
					}
				}
			} else {
				errorMessage = "HATS user update fail.";
			}
		}
	} else if (createAction) {
		userID = "";
		userName = "";
		status = "0";
		isInp = "0";
		isOut = "0";
		isDay = "0";
		isPbo = "0";
		cshCode = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		// change login id
		if (userID != null && userID.length() > 0) {
			record = getList(userID);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				userName = row.getValue(0);
				status = row.getValue(1);
				isInp = row.getValue(2);
				isOut = row.getValue(3);
				isDay = row.getValue(4);
				isPbo = row.getValue(5);

				// load cashier
				record = fetchCashier(userID);
				if (record.size() > 0) {
					row = (ReportableListObject) record.get(0);
					cshCode = row.getValue(0);
				} else {
					cshCode = "";
				}

				// load access function
				if (createAction || updateAction || cashierAction) {
					record = fetchFunctionByUserIndividual(userID);
				} else {
					record = fetchFunctionByUser(userID);
				}
				if (record.size() > 0) {
					functionID = new String[record.size()];
					functionIDDesc = new String[record.size()];
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						functionID[i] = row.getValue(0);
						functionIDDesc[i] = row.getValue(1);
					}
				} else {
					functionID = null;
					functionIDDesc = null;
				}

				record = fetchUserRoleByUser(userID);
				if (record.size() > 0) {
					noLevelGroupID = new String[record.size()];
					noLevelGroupDesc = new String[record.size()];
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						noLevelGroupID[i] = row.getValue(0);
						noLevelGroupDesc[i] = row.getValue(1);
					}
				} else {
					noLevelGroupID = null;
					noLevelGroupDesc = null;
				}

				// load appointment by doctor
				record = fetchAppointmentAccessDoctorByUser(userID);
				if (record.size() > 0) {
					userAccessDocCode = new String[record.size()];
					userAccessDocDesc = new String[record.size()];
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						userAccessDocCode[i] = row.getValue(0);
						userAccessDocDesc[i] = row.getValue(1);
					}
				} else {
					userAccessDocCode = null;
					userAccessDocDesc = null;
				}

				// load appointment by specality
				record = fetchAppointmentAccessSpecalityByUser(userID);
				if (record.size() > 0) {
					userAccessSpecCode = new String[record.size()];
					userAccessSpecDesc = new String[record.size()];
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						userAccessSpecCode[i] = row.getValue(0);
						userAccessSpecDesc[i] = row.getValue(1);
					}
				} else {
					userAccessSpecCode = null;
					userAccessSpecDesc = null;
				}
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}

	if (createAction || updateAction || cashierAction) {
		record = fetchFunction();
		if (record.size() > 0) {
			functionIDAvailable = new String[record.size()];
			functionIDDescAvailable = new String[record.size()];
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				functionIDAvailable[i] = row.getValue(0);
				functionIDDescAvailable[i] = row.getValue(1);
			}
		} else {
			functionIDAvailable = null;
			functionIDDescAvailable = null;
		}

		record = fetchUserRole();
		if (record.size() > 0) {
			noLevelGroupIDAvailable = new String[record.size()];
			noLevelGroupDescAvailable = new String[record.size()];
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				noLevelGroupIDAvailable[i] = row.getValue(0);
				noLevelGroupDescAvailable[i] = row.getValue(1);
			}
		} else {
			noLevelGroupIDAvailable = null;
		}

		record = fetchAppointmentAccessDoctor();
		if (record.size() > 0) {
			userAccessDocCodeAvailable = new String[record.size()];
			userAccessDocDescAvailable = new String[record.size()];
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				userAccessDocCodeAvailable[i] = row.getValue(0);
				userAccessDocDescAvailable[i] = row.getValue(1);
			}
		} else {
			userAccessDocCodeAvailable = null;
		}

		record = fetchAppointmentAccessSpecality();
		if (record.size() > 0) {
			userAccessSpecCodeAvailable = new String[record.size()];
			userAccessSpecDescAvailable = new String[record.size()];
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				userAccessSpecCodeAvailable[i] = row.getValue(0);
				userAccessSpecDescAvailable[i] = row.getValue(1);
			}
		} else {
			userAccessSpecCodeAvailable = null;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}
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
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction || cashierAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.user." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1" action="hats_user.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.data.login" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.loginID" /></td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<html:text style="text-transform: uppercase" property="userID" value="<%=userID%>" maxlength="10" size="50" />
<%	} else { %>
			<%=userID %><input type="hidden" name="userID" value="<%=userID %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.data.user" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.Name" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<html:text style="text-transform: uppercase" property="userName" value="<%=userName%>" maxlength="30" size="50" />
<%	} else { %>
			<%=userName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="status">
				<option value="-1"<%=("-1".equals(status)?" selected":"")%>>Active</option>
				<option value="0"<%=("0".equals(status)?" selected":"")%>>Inactive</option>
			</select>
<%	} else { %>
			<%="-1".equals(status)?"<font color='green'>Active</font>":"<font color='red'>Inactive</font>" %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">In-Patient</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="isInp">
				<option value="-1"<%=("-1".equals(isInp)?" selected":"")%>>Active</option>
				<option value="0"<%=("0".equals(isInp)?" selected":"")%>>Inactive</option>
			</select>
<%	} else { %>
			<%="-1".equals(isInp)?"<font color='green'>Active</font>":"<font color='red'>Inactive</font>" %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Out-Patient</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="isOut">
				<option value="-1"<%=("-1".equals(isOut)?" selected":"")%>>Active</option>
				<option value="0"<%=("0".equals(isOut)?" selected":"")%>>Inactive</option>
			</select>
<%	} else { %>
			<%="-1".equals(isOut)?"<font color='green'>Active</font>":"<font color='red'>Inactive</font>" %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Day Case</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="isDay">
				<option value="-1"<%=("-1".equals(isDay)?" selected":"")%>>Active</option>
				<option value="0"<%=("0".equals(isDay)?" selected":"")%>>Inactive</option>
			</select>
<%	} else { %>
			<%="-1".equals(isDay)?"<font color='green'>Active</font>":"<font color='red'>Inactive</font>" %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">PBO User</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="isPbo">
				<option value="-1"<%=("-1".equals(isPbo)?" selected":"")%>>Active</option>
				<option value="0"<%=("0".equals(isPbo)?" selected":"")%>>Inactive</option>
			</select>
<%	} else { %>
			<%="-1".equals(isPbo)?"<font color='green'>Active</font>":"<font color='red'>Inactive</font>" %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Cashier</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Cashier Code</td>
		<td class="infoData" width="70%">
<%	if (cshCode != null && cshCode.length() > 0) { %>
		<%=cshCode %>
<%	} else if (cashierAction) { %>
			<html:text style="text-transform: uppercase" property="cshCode" value="" maxlength="3" size="50" />
<%	} %>
		</td>
	</tr>
<%	if (userBean.isAccessible("function.accessControl.view") && !createAction) { %>
	<input type="hidden" name="hasFunctionID" value="Y">
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.access" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.function" /></td>
		<td class="infoData" width="70%">
<%			if (userBean.isAccessible("function.accessControl.update") && (createAction || updateAction)) { %>
			<table border="0">
				<tr>
					<td><bean:message key="prompt.functionAvailable" /></td>
					<td>&nbsp;</td>
					<td><bean:message key="prompt.functionSelected" /></td>
				</tr>
				<tr>
					<td>
						<select name="functionIDAvailable" size="10" multiple id="select1">
<%				if (functionIDAvailable != null) {
					for (int i = 0; i < functionIDAvailable.length; i++) {
%><option value="<%=functionIDAvailable[i] %>"><%=functionIDDescAvailable[i] %></option><%
					}
				} %>
						</select>
					</td>
					<td>
						<button id="add"><bean:message key="button.add" /> >></button><br>
						<button id="remove"><< <bean:message key="button.delete" /></button>
					</td>
					<td>
						<select name="functionID" size="10" multiple id="select2">
<%				if (functionID != null) {
					for (int i = 0; i < functionID.length; i++) {
%><option value="<%=functionID[i] %>"><%=functionIDDesc[i] %></option><%
					}
				} %>
						</select>
					</td>
				</tr>
			</table>
			<font color="red">*</front> Individual right for single user only
<%			} else {
				if (functionID != null) {
					for (int i = 0; i < functionID.length; i++) {
%><%=functionIDDesc[i] %><br/><%
					}
				}
			} %>
		</td>
	</tr>
<%		if (createAction || updateAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.groups" /></td>
		<td class="infoData" width="70%">
<%			if (userBean.isAccessible("function.accessControl.update") && (createAction || updateAction)) { %>
			<table border="0">
				<tr>
					<td><bean:message key="prompt.groupsAvailable" /></td>
					<td>&nbsp;</td>
					<td><bean:message key="prompt.groupsSelected" /></td>
				</tr>
				<tr>
					<td>
						<select name="noLevelGroupIDAvailable" size="10" multiple id="noLevelGroupIDSelect1">
<%				if (noLevelGroupIDAvailable != null) {
					for (int i = 0; i < noLevelGroupIDAvailable.length; i++) {
%>
							<option value="<%=noLevelGroupIDAvailable[i] %>">
<%
						try {
%><bean:message key="<%=noLevelGroupDescAvailable[i] %>" /><%
						} catch (Exception e) {
%><%=noLevelGroupDescAvailable[i] %><%
						}
%>
							</option>
<%
					}
				} %>
						</select>
					</td>
					<td>
						<button id="add2"><bean:message key="button.add" /> &gt;&gt;</button><br>
						<button id="remove2">&lt;&lt; <bean:message key="button.delete" /></button>
					</td>
					<td>
						<select name="noLevelGroupID" size="10" multiple id="noLevelGroupIDSelect2">
<%				if (noLevelGroupID != null) {
					for (int i = 0; i < noLevelGroupID.length; i++) {
%>
							<option value="<%=noLevelGroupID[i] %>">
<%
						try {
%><bean:message key="<%=noLevelGroupDesc[i] %>" /><%
						} catch (Exception e) {
%><%=noLevelGroupDesc[i] %><%
						}
%>
							</option>
<%
					}
				}
				%>
						</select>
					</td>
				</tr>
			</table>
<%			} else {
				if (noLevelGroupID != null) {
					for (int i = 0; i < noLevelGroupID.length; i++) {
%><%=noLevelGroupDesc[i] %><br/><%
					}
				}
			} %>
		</td>
	</tr>
<%		} %>
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.appointmentType" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="group.doctorList" /></td>
		<td class="infoData" width="70%">
<%			if (userBean.isAccessible("function.accessControl.update") && (createAction || updateAction)) { %>
			<table border="0">
				<tr>
					<td><bean:message key="group.doctorList" /></td>
					<td>&nbsp;</td>
					<td>Selected <bean:message key="group.doctorList" /></td>
				</tr>
				<tr>
					<td>
						<select name="userAccessDocCodeAvailable" size="10" multiple id="userAccessDocCodeSelect1">
<%				if (userAccessDocCodeAvailable != null) {
					for (int i = 0; i < userAccessDocCodeAvailable.length; i++) {
%>
							<option value="<%=userAccessDocCodeAvailable[i] %>">
<%
						try {
%><bean:message key="<%=userAccessDocDescAvailable[i] %>" /><%
						} catch (Exception e) {
%><%=userAccessDocDescAvailable[i] %><%
						}
%>
							</option>
<%
					}
				} %>
						</select>
					</td>
					<td>
						<button id="add3"><bean:message key="button.add" /> &gt;&gt;</button><br>
						<button id="remove3">&lt;&lt; <bean:message key="button.delete" /></button>
					</td>
					<td>
						<select name="userAccessDocCode" size="10" multiple id="userAccessDocCodeSelect2">
<%				if (userAccessDocCode != null) {
					for (int i = 0; i < userAccessDocCode.length; i++) {
%>
							<option value="<%=userAccessDocCode[i] %>">
<%
						try {
%><bean:message key="<%=userAccessDocDesc[i] %>" /><%
						} catch (Exception e) {
%><%=userAccessDocDesc[i] %><%
						}
%>
							</option>
<%
					}
				}
				%>
						</select>
					</td>
				</tr>
			</table>
<%			} else {
				if (userAccessDocCode != null) {
					for (int i = 0; i < userAccessDocCode.length; i++) {
%><%=userAccessDocDesc[i] %><br/><%
					}
				}
			} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.specialty" /></td>
		<td class="infoData" width="70%">
<%			if (userBean.isAccessible("function.accessControl.update") && (createAction || updateAction)) { %>
			<table border="0">
				<tr>
					<td><bean:message key="prompt.specialty" /></td>
					<td>&nbsp;</td>
					<td>Selected <bean:message key="prompt.specialty" /></td>
				</tr>
				<tr>
					<td>
						<select name="userAccessSpecCodeAvailable" size="10" multiple id="userAccessSpecCodeSelect1">
<%				if (userAccessSpecCodeAvailable != null) {
					for (int i = 0; i < userAccessSpecCodeAvailable.length; i++) {
%>
							<option value="<%=userAccessSpecCodeAvailable[i] %>">
<%
						try {
%><bean:message key="<%=userAccessSpecDescAvailable[i] %>" /><%
						} catch (Exception e) {
%><%=userAccessSpecDescAvailable[i] %><%
						}
%>
							</option>
<%
					}
				} %>
						</select>
					</td>
					<td>
						<button id="add4"><bean:message key="button.add" /> &gt;&gt;</button><br>
						<button id="remove4">&lt;&lt; <bean:message key="button.delete" /></button>
					</td>
					<td>
						<select name="userAccessSpecCode" size="10" multiple id="userAccessSpecCodeSelect2">
<%				if (userAccessSpecCode != null) {
					for (int i = 0; i < userAccessSpecCode.length; i++) {
%>
							<option value="<%=userAccessSpecCode[i] %>">
<%
						try {
%><bean:message key="<%=userAccessSpecDesc[i] %>" /><%
						} catch (Exception e) {
%><%=userAccessSpecDesc[i] %><%
						}
%>
							</option>
<%
					}
				}
				%>
						</select>
					</td>
				</tr>
			</table>
<%			} else {
				if (userAccessSpecCode != null) {
					for (int i = 0; i < userAccessSpecCode.length; i++) {
%><%=userAccessSpecDesc[i] %><br/><%
					}
				}
			} %>
		</td>
	</tr>
<%	} %>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction || cashierAction) { %>
<%		if (cashierAction) { %>
			<button onclick="return submitAction('cashierCode', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
<%		} else { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
<%		} %>
<%		if (updateAction || deleteAction || cashierAction) { %>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} %>
<%	} else { %>
<%		if (userBean.isAccessible("function.user.update")) { %>
<%			if (cshCode == null || cshCode.length() == 0) { %>
			<button onclick="return submitAction('cashierCode', 0);" class="btn-click">Add Cashier Code</button>
<%			} %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.user.update" /></button>
<%		} %>
			<%if (userBean.isAccessible("function.user.delete")) { %><button class="btn-delete"><bean:message key="function.user.delete" /></button><%} %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
</form>
<bean:define id="loginIDLabel"><bean:message key="prompt.loginID" /></bean:define>
<bean:define id="lastNameLabel"><bean:message key="prompt.lastName" /></bean:define>
<bean:define id="firstNameLabel"><bean:message key="prompt.firstName" /></bean:define>
<script language="javascript">
	$().ready(function() {
		$('#add').click(function() {
			return !$('#select1 option:selected').appendTo('#select2');
		});
		$('#remove').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});

		$('#add2').click(function() {
			return !$('#noLevelGroupIDSelect1 option:selected').appendTo('#noLevelGroupIDSelect2');
		});
		$('#remove2').click(function() {
			return !$('#noLevelGroupIDSelect2 option:selected').appendTo('#noLevelGroupIDSelect1');
		});

		$('#add3').click(function() {
			return !$('#userAccessDocCodeSelect1 option:selected').appendTo('#userAccessDocCodeSelect2');
		});
		$('#remove3').click(function() {
			return !$('#userAccessDocCodeSelect2 option:selected').appendTo('#userAccessDocCodeSelect1');
		});

		$('#add4').click(function() {
			return !$('#userAccessSpecCodeSelect1 option:selected').appendTo('#userAccessSpecCodeSelect2');
		});
		$('#remove4').click(function() {
			return !$('#userAccessSpecCodeSelect2 option:selected').appendTo('#userAccessSpecCodeSelect1');
		});
<%	if (updateAction) { %>

		removeDuplicateItem('form1', 'functionIDAvailable', 'functionID');
		removeDuplicateItem('form1', 'noLevelGroupIDAvailable', 'noLevelGroupID');
		removeDuplicateItem('form1', 'userAccessDocCodeAvailable', 'userAccessDocCode');
		removeDuplicateItem('form1', 'userAccessSpecCodeAvailable', 'userAccessSpecCode');
<%	} %>
	});

	$('.input_capital').on('input', function(evt) {
		$(this).val(function(_, val) {
			return val.toUpperCase();
		});
	});

	function submitAction(cmd, stp) {
		if (cmd == 'cashierCode') {
<%	if (cashierAction) { %>
				if (document.form1.cshCode.value == '') {
					alert("Empty cashier code.");
					document.form1.cshCode.focus();
					return false;
				}
<%	} %>
		} else {
			if (cmd == 'create' || cmd == 'update') {
<%	if (createAction) { %>
				if (document.form1.userID.value == '') {
					alert("<bean:message key="error.loginID.required" />.");
					document.form1.userID.focus();
					return false;
				}
<%	} %>
<%	if (createAction || updateAction) { %>
				if (document.form1.userName.value == '') {
					alert("<bean:message key="error.staffName.required" />.");
					document.form1.userName.focus();
					return false;
				}
<%	} %>
			}

			$('#select2 option').each(function(i) {
				$(this).attr("selected", "selected");
			});

			$('#noLevelGroupIDSelect2 option').each(function(i) {
				$(this).attr("selected", "selected");
			});

			$('#userAccessDocCodeSelect2 option').each(function(i) {
				$(this).attr("selected", "selected");
			});

			$('#userAccessSpecCodeSelect2 option').each(function(i) {
				$(this).attr("selected", "selected");
			});
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
</script>
<%if (!userBean.isAdmin()) { %>
<br/>
<a class="button" href="<html:rewrite page="/index.jsp" />" onclick="this.blur();"><span><bean:message key="prompt.backTo" /> <bean:message key="prompt.loginPage" /></span></a>
<%} %>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp"/>
</body>
<%} %>
</html:html>