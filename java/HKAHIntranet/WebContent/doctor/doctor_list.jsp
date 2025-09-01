<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="java.util.*"%>
<%!
public ArrayList getDoctorList(String docCode, String docName) {
	StringBuffer sb = new StringBuffer();
	sb.append("SELECT DOCCODE, DOCFNAME || ' ' || DOCGNAME, ");
	sb.append("SUBSTR(DOCGNAME, 1, 1)||SUBSTR(DOCFNAME, 1, 1)||'@'||LOWER(SUBSTR(DOCIDNO, 1, 1))||SUBSTR(DOCIDNO, 2, 4) ");
	sb.append("FROM DOCTOR@IWEB ");
	sb.append("WHERE DOCSTS = '-1' ");
	if (docCode != null && docCode.length() > 0) {
		sb.append("AND DOCCODE = '"+docCode+"' ");
	}
	if (docName != null && docName.length() > 0) {
		sb.append("AND UPPER(DOCFNAME || ' ' || DOCGNAME) LIKE '%"+docName.toUpperCase()+"%' ");
	}
	//System.out.println(sb.toString());
	
	return UtilDBWeb.getReportableList(sb.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String docName = request.getParameter("docName");
String docCode = request.getParameter("docCode");

ArrayList record = getDoctorList(docCode, docName);
	
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

request.setAttribute("doctorList", record);
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
		<div id=indexWrapper>
			<div id=mainFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.doctorList.title" />
					<jsp:param name="category" value="group.doctorList" />
				</jsp:include>
				
				<font color="blue"><%=message %></font>
				<font color="red"><%=errorMessage %></font>
				
				<form name="searchDoctorForm" action="doctor_list.jsp" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="25%">
								Doctor Code
							</td>
							<td class="infoData" width="55%">
								<input type="textfield" name="docCode" value="<%=docCode==null?"":docCode %>" maxlength="50" size="50" />
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="25%">
								DR Name
							</td>
							<td class="infoData" width="55%">
								<input type="textfield" name="docName" value="<%=docName==null?"":docName %>" maxlength="50" size="50" />
							</td>
						</tr>
						<tr class="smallText">
							<td colspan="2" align="center">
								<button onclick="return submitSearch();">
									<bean:message key="button.search" />
								</button>
								<button onclick="return clearSearch();">
									<bean:message key="button.clear" />
								</button>
							</td>
						</tr>		
					</table>
				</form>
				
				<bean:define id="functionLabel">
					<bean:message key="function.doctorList.title" />
				</bean:define>
				<bean:define id="notFoundMsg">
					<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
				</bean:define>		
				
				<display:table id="row" name="requestScope.doctorList" export="false" 
							pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">
					<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
					<display:column property="fields0" title="Doctor Code" style="width:10%" />
					<display:column property="fields1" title="Doctor Name" style="width:40%" />
					<display:column property="fields2" title="Password" style="width:20%" />
					<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
				</display:table>
				
				<input type="hidden" name="docCode" value="<%=docCode==null?"":docCode %>"/>
				<input type="hidden" name="docName" value="<%=docName==null?"":docName %>"/>
				
				<script language="javascript">
					function submitSearch() {
						showOverLay('body');
						showLoadingBox('body', 100, 350);
						
						document.searchDoctorForm.submit();
					}
					
					function clearSearch() {
						document.searchDoctorForm.docCode.value="";
						document.searchDoctorForm.docName.value="";
					}
				</script>
			</div>
		</div>
		
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>		