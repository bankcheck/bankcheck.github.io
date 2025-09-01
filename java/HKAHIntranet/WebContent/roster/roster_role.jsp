<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
public ArrayList getStaffList(String deptCode) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT DECODE(S.CO_STATUS, 'FT', '1', 'PT', '0.5', S.CO_STATUS), ");
	sqlStr.append("R.CO_STAFF_ROLE, S.CO_STAFF_ID, "); 
	sqlStr.append("DECODE(S.CO_STAFFNAME, NULL,S.CO_FIRSTNAME||' '||S.CO_LASTNAME, ");
	sqlStr.append("S.CO_STAFFNAME) ");
	sqlStr.append("FROM CO_STAFFS S, CO_STAFFS_ROSTER_POSITION R ");
	sqlStr.append("WHERE S.CO_STAFF_ID = R.CO_STAFF_ID(+) ");
	sqlStr.append("AND S.CO_ENABLED = '1' ");
	sqlStr.append("AND (R.CO_ENABLED = '1' OR R.CO_ENABLED IS NULL) ");
	sqlStr.append("AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	sqlStr.append("ORDER BY S.CO_STAFF_ID ");
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public boolean savePost(UserBean userBean, String staffID, String post) {
	StringBuffer sqlStr = new StringBuffer();
	StringBuffer checkSqlStr = new StringBuffer();
	checkSqlStr.append("SELECT 1 FROM CO_STAFFS_ROSTER_POSITION ");
	checkSqlStr.append("WHERE CO_STAFF_ID = '"+staffID+"' ");
	checkSqlStr.append("AND CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
	
	if (UtilDBWeb.isExist(checkSqlStr.toString())) {
		sqlStr.append("UPDATE CO_STAFFS_ROSTER_POSITION ");
		sqlStr.append("SET CO_STAFF_ROLE = '"+post+"', ");
		sqlStr.append("	   CO_MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("	   CO_MODIFIED_USER = '"+userBean.getStaffID()+"', ");
		sqlStr.append("	   CO_ENABLED = '1' ");
		sqlStr.append("WHERE CO_STAFF_ID = '"+staffID+"' ");
		sqlStr.append("AND CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
	}
	else {
		sqlStr.append("INSERT INTO CO_STAFFS_ROSTER_POSITION ");
		sqlStr.append("(CO_SITE_CODE, CO_STAFF_ID, CO_STAFF_ROLE, ");
		sqlStr.append("CO_DEPARTMENT_CODE, CO_INCHARGE, CO_CREATED_DATE, ");
		sqlStr.append("CO_CREATED_USER) ");
		sqlStr.append("VALUES ('"+ConstantsServerSide.SITE_CODE+"', '"+staffID+"', '"+post+"') ");
	}
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String msg = "";
String errorMsg = "";

if (command != null && command.equals("submit")) {
	for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
		String param = e.nextElement().toString();
		if(param.contains("_post")){
			String staffID = param.split("_")[0];
			String post = request.getParameter(param);
			
			if (post != null && post.length() > 0) {
				if (savePost(userBean, staffID, post)) {
					msg = "Save Successful";
				}
				else {
					msg = "Errors in saving";
				}
			}
		}
	}
	command = "";
}

ArrayList staffList = null;

if (userBean != null) {
	staffList = getStaffList(userBean.getDeptCode());
}
request.setAttribute("rosterStaffList", staffList);
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
	<DIV id=indexWrapper>
		<DIV id=mainFrame>
			<DIV id=contentFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.roster.role.edit" />
					<jsp:param name="accessControl" value="N"/>
				</jsp:include>
				<label style="color:blue"><%=msg %></label>
				<label style="color:red"><%=errorMsg %></label>
				<bean:define id="functionLabel"><bean:message key="function.roster.role.edit" /></bean:define>
				<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
				
				<form name="staffList" action="roster_role.jsp" method="post">
					<display:table id="row" name="requestScope.rosterStaffList" export="false" pagesize="200" class="generaltable">
						<display:column property="fields2" title="Staff ID" style="width:8%" />
						<display:column property="fields3" title="Staff Name" style="width:8%" />
						<display:column title="Post" style="width:8%" media="html">
							<input name="<c:out value="${row.fields2}" />_post" value="<c:out value="${row.fields1}" />" />
							<c:if test="${row.fields1 eq ''}">
								<span style="color:red">*Please fill it</span>
							</c:if>
						</display:column>
						<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
					</display:table>
					<input name="command" type="hidden" value="<%=command %>"/>
				</form>
				<br/>
				<table style="width:100%;">
					<tr>
						<td align="center">
							<button onclick="submit()">
								<bean:message key="button.submit" />
							</button>
						</td>
					</tr>
				</table>
				<script language="javascript">
					function submit() {
						document.staffList.command.value = 'submit';
						document.staffList.submit();
					}
				</script>
			</DIV>
		</DIV>
	</DIV>
	<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>