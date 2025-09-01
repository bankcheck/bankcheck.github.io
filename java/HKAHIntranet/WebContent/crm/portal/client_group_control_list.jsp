<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
private ArrayList fetchClientGroup(String siteCode, String grpDesc) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CRM_SITE_CODE, CRM_GROUP_ID, CRM_GROUP_DESC, ");
	sqlStr.append("TO_CHAR(CRM_MODIFIED_DATE, 'DD/MM/YYYY') ");
	sqlStr.append("FROM CRM_GROUP ");
	sqlStr.append("WHERE  CRM_ENABLED = 1 ");
	if (siteCode != null && siteCode.length() > 0) {
		sqlStr.append("AND    CRM_SITE_CODE = '");
		sqlStr.append(siteCode);
		sqlStr.append("' ");
	}
	if (grpDesc != null && grpDesc.length() > 0) {
		sqlStr.append("AND    CRM_GROUP_DESC LIKE '%");
		sqlStr.append(grpDesc);
		sqlStr.append("%' ");
	}
	sqlStr.append("ORDER BY CRM_SITE_CODE, CRM_GROUP_DESC ");
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

String siteCode = request.getParameter("siteCode");
String grpDesc = request.getParameter("grpDesc");
request.setAttribute("client_group_list", fetchClientGroup(siteCode, grpDesc));

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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

<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	<body>
		<div id=indexWrapper>
			<div id=mainFrame>
				<div id=contentFrame>
					<jsp:include page="../../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="function.crm.group.control.list" />
						<jsp:param name="category" value="group.crm" />
						<jsp:param name="keepReferer" value="N" />
					</jsp:include>
					
					<font color="blue"><%=message %></font>
					<font color="red"><%=errorMessage %></font>
				
					<form name="search_form" action="client_group_control_list.jsp" method="post">
						<table cellpadding="0" cellspacing="5"
									class="contentFrameSearch" border="0">
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									<bean:message key="prompt.site" />
								</td>
								<td class="infoData" width="70%">
									<jsp:include page="../../ui/siteCodeRDB.jsp" flush="false">
										<jsp:param name="allowAll" value="Y" />
									</jsp:include>
								</td>
							</tr>
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									<bean:message key="prompt.crm.group" />
								</td>
								<td class="infoData" width="70%">
									<input type="textfield" name="grpDesc" value="<%=grpDesc==null?"":grpDesc %>" maxlength="100" size="50"> (<bean:message key="prompt.optional" />)
								</td>
							</tr>
							<tr class="smallText">
								<td colspan="2" align="center">
									<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
									<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
								</td>
							</tr>
						</table>
					</form>
					
					<bean:define id="functionLabel">
						<bean:message key="function.crm.group.list" />
					</bean:define>
					<bean:define id="notFoundMsg">
						<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
					</bean:define>
					
					<form name="form1"  action="client_group_control.jsp" method="post">
						<display:table id="row" name="requestScope.client_group_list" 
								export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" 
								class="tablesorter">
							<display:column title="" style="width:5%">
								<%=pageContext.getAttribute("row_rowNum")%>)
							</display:column>
							<display:column property="fields0" titleKey="prompt.site" class="smallText" style="width:25%" />
							<display:column property="fields2" titleKey="prompt.crm.group" class="smallText" style="width:30%" />
							<display:column property="fields3" titleKey="prompt.modifiedDate" class="smallText" style="width:30%" />
							<display:column titleKey="prompt.action" media="html" class="smallText" style="width:10%">
								<button onclick="return submitAction('view', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields1}" />');">
									<bean:message key="button.view" />
								</button>
	
							</display:column>
							<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
						</display:table>						
					</form>
					<script language="javascript">
						function submitSearch() {
							document.search_form.submit();
						}
					
						function clearSearch() {
							document.search_form.grpDesc.value = '';
						}
					
						function submitAction(cmd, groupDesc,groupID) {
							callPopUpWindow(document.form1.action + "?command=" + cmd + "&clientGroupDesc=" + groupDesc + "&clientGroupID=" + groupID);
							return false;
						}
					</script>
				</div>
			</div>
		</div>
		<jsp:include page="../../common/footer.jsp" flush="false" />
	</body>
</html:html>