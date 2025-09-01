<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList getIPDStaff() {
		StringBuffer sqlStr = new StringBuffer();	
		sqlStr.append("SELECT S.CO_STAFF_ID, ");
		sqlStr.append("DECODE(TRIM(S.CO_FIRSTNAME||' '||S.CO_LASTNAME), '', S.CO_STAFFNAME, S.CO_FIRSTNAME||' '||S.CO_LASTNAME) AS STAFFNAME, ");
		sqlStr.append("SUBSTR(DECODE(TRIM(S.CO_FIRSTNAME||' '||S.CO_LASTNAME), '', S.CO_STAFFNAME, S.CO_FIRSTNAME||' '||S.CO_LASTNAME), 0, 1) ");
		sqlStr.append("FROM CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND D.CO_DEPARTMENT_CODE = '820' ");
		sqlStr.append("AND S.CO_ENABLED = '1' ");
		sqlStr.append("AND S.CO_STAFF_ID <> '4347' ");
		sqlStr.append("AND S.CO_STAFF_ID <> '4316' ");
		sqlStr.append("AND S.CO_STAFF_ID <> '3308' ");
		sqlStr.append("AND S.CO_STAFF_ID <> '4326' ");
		sqlStr.append("AND S.CO_STAFF_ID <> '3960' ");
		sqlStr.append("AND S.CO_STAFF_ID <> '2075' ");
		sqlStr.append("AND S.CO_STAFF_ID <> '3822' ");
		sqlStr.append("ORDER BY STAFFNAME ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>

<%
ArrayList result = getIPDStaff();
String curCategory = "";
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include> 
<jsp:include page="header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include> 
	<body>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="4" style="background-color:#757575;color:white;font-weight:bold;font-size:16px">
					IPD Staff
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		<%
		int printedCol = 0;
		
		for (int i = 0; i < result.size(); i++) { 
			ReportableListObject row = (ReportableListObject) result.get(i);
			if (!curCategory.equals(row.getValue(2))) {
				curCategory = row.getValue(2);
				//printedCol = 0;
		%>
		<%-- 
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="4" style="background-color:#757575;color:white;font-weight:bold;font-size:16px">
						<%=curCategory %>
					</td>
				</tr>
		--%>
		<%
			}
			if (printedCol == 0) {
		%>
				<tr>
		<%
			}
		%>
					<td>
						<button style="font-size:20px;" 
								class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' 
								onclick="submitAction('<%=row.getValue(0)%>')">
							<%
							int firstSpace = row.getValue(1).indexOf(' ');
							int secondSpace = row.getValue(1).indexOf(' ', firstSpace+1);
							int finalIndex = -1;
							if (secondSpace == -1) {
								finalIndex = row.getValue(1).length();
							}
							else {
								finalIndex = secondSpace;
							}
							%>
							<%=row.getValue(1).substring(0, finalIndex) %>
						</button>
					</td>
		<%
			printedCol++;
			if (printedCol == 4) {
				printedCol = 0;
		%>
				</tr>
		<%
			}
			if (printedCol == 0) {
		%>
				<tr><td>&nbsp;</td></tr>
		<%
			}
		} 
		%>
		</table>
	</body>
<jsp:include page="../common/footer.jsp" flush="false" />
</html:html>
<script>
	function submitAction(staffID) {
		$.ajax({
			type: "POST",
			url: "setSession.jsp",
			data: "sessionName=staffID&directTo=main&sessionValue="+staffID,
			async: false,
			cache: false,
			success: function(values){
				//window.location = "../patient/main_develop.jsp";
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "setSession"');
			}
		});
	}
</script>