<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.HashMap.*" %>
<%!
	public ArrayList<ReportableListObject> getProjectList() {
		return UtilDBWeb.getReportableList("SELECT MODULE_CODE, DESCRIPTION FROM SSO_MODULE@SSO ORDER BY DESCRIPTION ");
	}

	public ArrayList<ReportableListObject> getStaffList(String deptCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DECODE(S.CO_DEPARTMENT_DESC, null, INITCAP(D.CO_DEPARTMENT_DESC), INITCAP(S.CO_DEPARTMENT_DESC)), ");
		sqlStr.append("       S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_DISPLAY_NAME ");
		sqlStr.append("FROM   CO_STAFFS S ");
		sqlStr.append("INNER JOIN CO_DEPARTMENTS D ON S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("WHERE  S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    S.CO_SITE_CODE = ? ");
		sqlStr.append("ORDER BY S.CO_STAFF_ID ");
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { deptCode,  ConstantsServerSide.SITE_CODE });
	}

	public ArrayList<ReportableListObject> getUserMappingList(String deptCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT M.MODULE_CODE, M.SSO_USER_ID ");
		sqlStr.append("FROM   CO_STAFFS S ");
		sqlStr.append("INNER JOIN SSO_USER_MAPPING@SSO M ON S.CO_STAFF_ID = M.SSO_USER_ID ");
		sqlStr.append("WHERE  S.CO_ENABLED = 1 ");
		sqlStr.append("AND    M.ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    M.MODULE_CODE NOT IN ('mcs', 'hk.portal') ");

		sqlStr.append("UNION ");

		sqlStr.append("SELECT 'hk.portal', S.CO_STAFF_ID ");
		sqlStr.append("FROM   CO_STAFFS S ");
		sqlStr.append("INNER JOIN CO_USERS U ON S.CO_STAFF_ID = U.CO_STAFF_ID ");
		sqlStr.append("WHERE  S.CO_ENABLED = 1 ");
		sqlStr.append("AND    U.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");

		sqlStr.append("UNION ");

		sqlStr.append("SELECT 'pacs.ris', S.CO_STAFF_ID ");
		sqlStr.append("FROM   CO_STAFFS S ");
		if (ConstantsServerSide.SITE_CODE_HKAH.equals("hkah")) {
			sqlStr.append("INNER JOIN Users@HKA_RADI M ON UPPER(SUBSTR(S.CO_LASTNAME, 1, 1) || S.CO_STAFF_ID) = UPPER(M.USERID) ");
		} else {
			sqlStr.append("INNER JOIN Users@TWA_RADI M ON S.CO_STAFF_ID = M.USERID ");
		}
		sqlStr.append("WHERE  S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");

		sqlStr.append("UNION ");

		sqlStr.append("SELECT 'mm', S.CO_STAFF_ID ");
		sqlStr.append("FROM   CO_STAFFS S ");
		sqlStr.append("WHERE  S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    S.CO_STAFF_ID IN (");
		sqlStr.append("SELECT AC_STAFF_ID FROM AC_FUNCTION_ACCESS WHERE AC_FUNCTION_ID LIKE 'function.ivs.%' AND AC_STAFF_ID != 'ALL' ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT AC_STAFF_ID FROM AC_USER_GROUPS WHERE AC_GROUP_ID IN (SELECT AC_GROUP_ID FROM AC_FUNCTION_ACCESS WHERE AC_FUNCTION_ID LIKE 'function.ivs.%' AND AC_STAFF_ID = 'ALL') ");
		sqlStr.append(") ");

		sqlStr.append("UNION ");

		sqlStr.append("SELECT 'irs', S.CO_STAFF_ID ");
		sqlStr.append("FROM   CO_STAFFS S ");
		sqlStr.append("WHERE  S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    S.CO_STAFF_ID IN (");
		sqlStr.append("SELECT AC_STAFF_ID FROM AC_FUNCTION_ACCESS WHERE AC_FUNCTION_ID LIKE 'function.ic.%' AND AC_STAFF_ID != 'ALL' ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT AC_STAFF_ID FROM AC_USER_GROUPS WHERE AC_GROUP_ID IN (SELECT AC_GROUP_ID FROM AC_FUNCTION_ACCESS WHERE AC_FUNCTION_ID LIKE 'function.ic.%' AND AC_STAFF_ID = 'ALL') ");
		sqlStr.append(") ");

		sqlStr.append("UNION ");

		sqlStr.append("SELECT 'cis', S.CO_STAFF_ID ");
		sqlStr.append("FROM   CO_STAFFS S ");
		sqlStr.append("INNER JOIN AH_SYS_USER@CIS C ON S.CO_STAFF_ID = C.USER_ID ");
		sqlStr.append("WHERE  S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND   (C.EXPIRED_DATE IS NULL OR C.EXPIRED_DATE > SYSDATE) ");

		sqlStr.append("UNION ");

		sqlStr.append("SELECT 'epr', S.CO_STAFF_ID ");
		sqlStr.append("FROM   CO_STAFFS S ");
		sqlStr.append("WHERE  S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    S.CO_STAFF_ID IN (");
		sqlStr.append("SELECT AC_STAFF_ID FROM AC_FUNCTION_ACCESS WHERE AC_FUNCTION_ID LIKE 'function.epo.%' AND AC_STAFF_ID != 'ALL' ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT AC_STAFF_ID FROM AC_USER_GROUPS WHERE AC_GROUP_ID IN (SELECT AC_GROUP_ID FROM AC_FUNCTION_ACCESS WHERE AC_FUNCTION_ID LIKE 'function.epo.%' AND AC_STAFF_ID = 'ALL') ");
		sqlStr.append(") ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { deptCode, deptCode, deptCode, deptCode, deptCode, deptCode, deptCode });
	}

	public ArrayList<ReportableListObject> getUserMappingList4Ewell(String deptCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 'mcs', d.STAFF_CODE ");
		sqlStr.append("FROM   mcs_sys_ward@EWELL a ");
		sqlStr.append("INNER JOIN mcs_sys_ward_role@EWELL b ON a.id = b.ward_id ");
		sqlStr.append("INNER JOIN MCS_SYS_USER_WARD_ROLE@EWELL c ON b.id = c.role_id ");
		sqlStr.append("INNER JOIN mcs_sys_user@EWELL d ON c.user_id = d.id ");
		sqlStr.append("INNER JOIN co_staffs@PORTAL s ON d.STAFF_CODE = s.CO_STAFF_ID ");
		sqlStr.append("WHERE  d.vflag = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");

		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] { deptCode });
	}
%>
<%
UserBean userBean = new UserBean(request);
String deptCode = request.getParameter("deptCode");

// get column list
Vector<String> projectIDVector = new Vector<String>();
Vector<String> projectDescVector = new Vector<String>();
HashSet projectRights = new HashSet();

ArrayList record = null;
ArrayList record_real = null;
ReportableListObject row2 = null;
ReportableListObject row_real = null;

int noOfUserInfoColumn = 3;
int projectSize = 0;

try {
	// get all course list
	record = getProjectList();
	projectSize = record.size();
	if (projectSize > 0) {
		for (int i = 0; i < projectSize; i++) {
			row2 = (ReportableListObject) record.get(i);
			projectIDVector.add(row2.getValue(0));
			projectDescVector.add(row2.getValue(1));
		}
	}

	request.setAttribute("columnNames", projectIDVector);
} catch (Exception e) {
	e.printStackTrace();
}

try {
	// get data by project
	record = getUserMappingList(deptCode);
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row2 = (ReportableListObject) record.get(i);
			projectRights.add(row2.getValue(0) + "-" + row2.getValue(1));
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

try {
	// get data by ewell
	record = getUserMappingList4Ewell(deptCode);
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row2 = (ReportableListObject) record.get(i);
			projectRights.add(row2.getValue(0) + "-" + row2.getValue(1));
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}


try {
	// get data by user
	record = getStaffList(deptCode);
	record_real = new ArrayList();
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row2 = (ReportableListObject) record.get(i);
			// copy to new reportable list object
			row_real = new ReportableListObject(projectSize + noOfUserInfoColumn);
			for (int j = 0; j < noOfUserInfoColumn; j++) {
				row_real.setValue(j, row2.getValue(j));
			}

			// initial value
			for (int j = noOfUserInfoColumn; j < projectSize + noOfUserInfoColumn; j++) {
				if ("irs".equals(projectIDVector.get(j - noOfUserInfoColumn))
					|| projectRights.contains(projectIDVector.get(j - noOfUserInfoColumn) + "-" + row2.getValue(1))) {
					row_real.setValue(j, "YES");
				} else {
					row_real.setValue(j, ConstantsVariable.EMPTY_VALUE);
				}
			}

			// append other value
			record_real.add(row_real);
		}
	}
	request.setAttribute("record_list", record_real);
} catch (Exception e) {
	e.printStackTrace();
}
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<jsp:include page="../common/header.jsp"/>

<bean:define id="functionLabel"><bean:message key="function.staff.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<div id="tbl-container" style="height: 380px">
<display:table id="row" name="requestScope.record_list" export="true" class="dataTable" >
	<display:column headerClass="locked" class="locked" title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column headerClass="locked" class="locked" property="fields0" titleKey="prompt.department" />
	<display:column headerClass="locked" class="locked" property="fields1" titleKey="prompt.staffID" />
	<display:column headerClass="locked" class="locked" property="fields2" titleKey="prompt.name" />
	<c:forEach var="column" varStatus="status" items="${requestScope.columnNames}">
		<bean:define id="statusCount"><c:out value="${status.count}"/></bean:define>
		<display:column title="<%=(String) projectDescVector.get(Integer.parseInt(statusCount) - 1) %>">
			<%=((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) - 1 + noOfUserInfoColumn) %>
		</display:column>
	</c:forEach>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</div>