<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getItemCodeList() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT H.ITMCODE ");
		sqlStr.append("FROM ( ");
		sqlStr.append(" SELECT DECODE(INSTR(HPKEY, '-'), 0, HPKEY, SUBSTR(HPKEY, 0, INSTR(HPKEY, '-') - 1)) ITMCODE, DECODE(INSTR(HPKEY, '-'), 0, '', SUBSTR(HPKEY, INSTR(HPKEY, '-') + 1)) ACMCODE, HPKEY, HPSTATUS, HPRMK ");
		sqlStr.append(" FROM   HPSTATUS@IWEB ");
		sqlStr.append(" WHERE  HPTYPE = 'ROOMCHARGE' ");
		sqlStr.append(" AND    HPACTIVE = -1 ");
		sqlStr.append(") H LEFT JOIN ACM@IWEB A ON H.ACMCODE = A.ACMCODE ");
		sqlStr.append("GROUP BY H.ITMCODE ");
		sqlStr.append("ORDER BY H.ITMCODE ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getAcmCodeList() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ACMCODE, ACMNAME ");
		sqlStr.append("FROM   ACM@IWEB ");
		sqlStr.append("ORDER BY ACMCODE ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getBedCodeList() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT BEDCODE, BEDDESC ");
		sqlStr.append("FROM   BED@IWEB ");
		sqlStr.append("WHERE  BEDREMARK != 'Invalid Bed Code' ");
		sqlStr.append("ORDER BY BEDCODE ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getItemCode(String itmcode, String bedcode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT H.ITMCODE, H.ACMCODE, A.ACMNAME, H.HPRMK ");
		sqlStr.append("FROM ( ");
		sqlStr.append(" SELECT DECODE(INSTR(HPKEY, '-'), 0, HPKEY, SUBSTR(HPKEY, 0, INSTR(HPKEY, '-') - 1)) ITMCODE, DECODE(INSTR(HPKEY, '-'), 0, '', SUBSTR(HPKEY, INSTR(HPKEY, '-') + 1)) ACMCODE, HPKEY, HPSTATUS, HPRMK ");
		sqlStr.append(" FROM   HPSTATUS@IWEB ");
		sqlStr.append(" WHERE  HPTYPE = 'ROOMCHARGE' ");
		sqlStr.append(" AND    HPKEY = ? ");
		sqlStr.append(" AND    HPSTATUS = ? ");
		sqlStr.append(" AND    HPACTIVE = -1 ");
		sqlStr.append(") H LEFT JOIN ACM@IWEB A ON H.ACMCODE = A.ACMCODE ");
		sqlStr.append("ORDER BY H.ITMCODE, A.ACMNAME, H.HPSTATUS ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { itmcode, bedcode });
	}

	private String getHpKey(String itmcode, String acmcode) {
		if (acmcode != null && acmcode.length() > 0) {
			return itmcode + "-" + acmcode;
		} else {
			return itmcode;
		}
	}

	private boolean isExist(String hpkey, String bedcode) {
		return UtilDBWeb.isExist(
			"SELECT 1 FROM HPSTATUS@IWEB WHERE HPTYPE = 'ROOMCHARGE' AND HPKEY = ? AND HPSTATUS = ?",
			new String[]{ hpkey, bedcode });
	}

	private boolean addRoomCharge(UserBean userBean, String hpkey, String bedcode, String roomcharge) {
		if (isExist(hpkey, bedcode)) {
			return UtilDBWeb.updateQueue(
				"UPDATE HPSTATUS@IWEB SET HPRMK = ?, HPACTIVE = -1, HPMUSR = ?, HPMDATE = SYSDATE WHERE HPTYPE = 'ROOMCHARGE' AND HPKEY = ? AND HPSTATUS = ?",
				new String[] { roomcharge, userBean.getStaffID(), hpkey, bedcode } );
		} else {
			return UtilDBWeb.updateQueue(
				"INSERT INTO HPSTATUS@IWEB (HPTYPE, HPKEY, HPSTATUS, HPRMK, HPCUSR) VALUES ('ROOMCHARGE', ?, ?, ?, ?)",
				new String[] { hpkey, bedcode, roomcharge, userBean.getStaffID() } );
		}
	}

	private boolean updateRoomCharge(UserBean userBean, String hpkey, String bedcode, String roomcharge) {
		if (isExist(hpkey, bedcode)) {
			return UtilDBWeb.updateQueue(
				"UPDATE HPSTATUS@IWEB SET HPRMK = ?, HPMUSR = ?, HPMDATE = SYSDATE WHERE HPTYPE = 'ROOMCHARGE' AND HPKEY = ? AND HPSTATUS = ?",
				new String[] { roomcharge, userBean.getStaffID(), hpkey, bedcode } );
		} else {
			return false;
		}
	}

	private boolean deleteRoomCharge(UserBean userBean, String hpkey, String bedcode) {
		if (isExist(hpkey, bedcode)) {
			return UtilDBWeb.updateQueue(
				"UPDATE HPSTATUS@IWEB SET HPACTIVE = 0, HPMUSR = ?, HPMDATE = SYSDATE WHERE HPTYPE = 'ROOMCHARGE' AND HPKEY = ? AND HPSTATUS = ?",
				new String[] { userBean.getStaffID(), hpkey, bedcode } );
		} else {
			return false;
		}
	}
%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String step = request.getParameter("step");
String hpkey = request.getParameter("hpkey");
String itmcode = request.getParameter("itmcode");
String acmcode = request.getParameter("acmcode");
String acmname = null;
String bedcode = request.getParameter("bedcode");
String roomcharge = request.getParameter("roomcharge");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

ReportableListObject row = null;
ArrayList record = null;
try {
	if ("1".equals(step)) {
		if (createAction) {
			hpkey = getHpKey(itmcode, acmcode);
			if (addRoomCharge(userBean, hpkey, bedcode, roomcharge)) {
				message = "Room charge added.";
				createAction = false;
				step = "0";
			} else {
				errorMessage = "Room charge add fail.";
			}
		} else if (updateAction) {
			if (updateRoomCharge(userBean, hpkey, bedcode, roomcharge)) {
				message = "Room charge updated.";
				updateAction = false;
				step = "0";
			} else {
				errorMessage = "Room charge update fail.";
			}
		} else if (deleteAction) {
			if (deleteRoomCharge(userBean, hpkey, bedcode)) {
				message = "Room charge removed.";
				deleteAction = false;
				step = "0";
			} else {
				errorMessage = "Room charge remove fail.";
			}
		}
	} else if (createAction) {
		itmcode = "";
		acmcode = "";
		acmname = "";
		roomcharge = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (hpkey != null && hpkey.length() > 0) {
			record = getItemCode(hpkey, bedcode);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				itmcode = row.getValue(0);
				acmcode = row.getValue(1);
				acmname = row.getValue(2);
				roomcharge = row.getValue(3);
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
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.hats.roomCharge." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1" action="room_charge.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Item Code</td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<select name="itmcode"><%
			record = getItemCodeList();
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"><%=row.getValue(0) %></option><%
				}
			}
%></select>
<%	} else { %>
			<%=itmcode==null?"":itmcode %><input type="hidden" name="itmcode" value="<%=itmcode==null?"":itmcode %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Acm Code</td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<select name="acmcode"><%
			record = getAcmCodeList();
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"><%=row.getValue(1) %></option><%
				}
			}
%><option value=""></option></select>
<%	} else { %>
			<%=acmname==null?"":acmname %><input type="hidden" name="acmcode" value="<%=acmcode==null?"":acmcode %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Bed Code</td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<select name="bedcode"><%
			record = getBedCodeList();
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"><%=row.getValue(1) %></option><%
				}
			}
%></select>
<%	} else { %>
			<%=bedcode==null?"":bedcode %><input type="hidden" name="bedcode" value="<%=bedcode==null?"":bedcode %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Room Charge</td>
		<td class="infoData" width="70%">$
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="roomcharge" class="touppercase" value="<%=roomcharge==null?"":roomcharge %>" maxlength="10" size="25"">
<%	} else { %>
			<%=roomcharge==null?"":roomcharge %>
<%	} %>
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<%if (userBean.isAccessible("function.hats.roomCharge.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.hats.roomCharge.update" /></button><%} %>
			<%if (userBean.isAccessible("function.hats.roomCharge.delete")) { %><button class="btn-delete"><bean:message key="function.hats.roomCharge.delete" /></button><%} %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="hpkey" value="<%=hpkey==null?"":hpkey %>">
</form>
<script language="javascript">
<!--
	function submitAction(cmd, stp) {
		if (cmd == 'create') {
			if (document.form1.bedcode.value == '') {
				alert("Invalid Bed Code.");
				document.form1.bedcode.focus();
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>