<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="org.displaytag.tags.*"%>
<%@ page import="org.displaytag.util.*"%>
<%
UserBean userBean = new UserBean(request);
String listTablePageParaName = (new ParamEncoder("row").encodeParameterName(TableTagParameters.PARAMETER_PAGE));
String listTableCurPage = request.getParameter(listTablePageParaName);

String patno = request.getParameter("patno");
String lockBy = request.getParameter("lockBy");
String lockDateFrom = request.getParameter("lockDateFrom");
String lockDateTo = request.getParameter("lockDateTo");
String unlockBy = request.getParameter("unlockBy");
String unlockDateFrom = request.getParameter("unlockDateFrom");
String unlockDateTo = request.getParameter("unlockDateTo");
String reason = request.getParameter("reason");
String remarks = request.getParameter("remarks");

int current_yy = DateTimeUtil.getCurrentYear();
int current_mm = DateTimeUtil.getCurrentMonth();
int current_dd = DateTimeUtil.getCurrentDay();

request.setAttribute("lockList",
		PatientDB.getDmsPatLockList(patno, lockBy, lockDateFrom, lockDateTo, unlockBy, unlockDateFrom, unlockDateTo,
				reason, remarks));
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
					<jsp:param name="pageTitle" value="function.mr.emracc.list" />
					<jsp:param name="keepReferer" value="Y" />
					<jsp:param name="accessControl" value="Y"/>
				</jsp:include>
				
				<bean:define id="functionLabel"><bean:message key="function.mr.emracc.list" /></bean:define>
				<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
				
				<form name="searchform" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="30%">Patient No.</td>
							<td class="infoData" width="70%"><input type="textfield" name="patno" value="<%=patno==null?"":patno %>" maxlength="100" size="50"></td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="30%">Locked By</td>
							<td class="infoData" width="70%"><input type="textfield" name="lockBy" value="<%=lockBy==null?"":lockBy %>" maxlength="100" size="50"></td>
						</tr>	
						<tr>
							<td class="infoLabel" width="15%">
								Lock Date
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="lockDateFrom" id="lockDateFrom" 
									class="datepickerfield" value="<%=lockDateFrom==null?"":lockDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="lockDateTo" id="lockDateTo" 
									class="datepickerfield" value="<%=lockDateTo==null?"":lockDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="30%">Unlocked By</td>
							<td class="infoData" width="70%"><input type="textfield" name="unlockBy" value="<%=unlockBy==null?"":unlockBy %>" maxlength="100" size="50"></td>
						</tr>							
						<tr>
							<td class="infoLabel" width="15%">
								Unlock Date
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="unlockDateFrom" id="unlockDateFrom" 
									class="datepickerfield" value="<%=unlockDateFrom==null?"":unlockDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="unlockDateTo" id="unlockDateTo" 
									class="datepickerfield" value="<%=unlockDateTo==null?"":unlockDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>
						</tr>						
						<tr class="smallText">
							<td class="infoLabel" width="30%">Reason</td>
							<td class="infoData" width="70%"><input type="textfield" name="reason" value="<%=reason==null?"":reason %>" maxlength="100" size="100"></td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="30%">Remarks<br />(for internal use)</td>
							<td class="infoData" width="70%"><input type="textfield" name="remarks" value="<%=remarks==null?"":remarks %>" maxlength="100" size="100"></td>
						</tr>
						<tr class="smallText">
							<td colspan="2" align="center">
								<button onclick="return submitSearch()">
									<bean:message key="button.search" />
								</button>
								<button onclick="return clearSearch()">
									<bean:message key="button.clear" />
								</button>
								<input type="hidden" name="command" />
							</td>
						</tr>
					</table>
					<input type="hidden" name="<%=listTablePageParaName %>" />
				</form>
<%
				if(userBean.isAccessible("function.mr.emracc.create")) {
%>
					<table align="center">
						<tr class="smallText">
								<td colspan="2" align="center">
									<button onclick="submitAction('create', 0)">
										Create Lock
									</button>
								</td>
						</tr>
					</table>
<%
				}
%>
				<display:table id="row" name="requestScope.lockList" export="true" 
						pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">							
					<display:column property="fields0" title="Seq No." style="width:3%" />
					<display:column property="fields1" title="Patient No." style="width:8%" />
					<display:column title="Lock By"  style="width:10%">
						<c:set var="fields2" value="${row.fields2}"/>	
						<c:set var="fields10" value="${row.fields10}"/>	
						<% 
						String lockById = (String) pageContext.getAttribute("fields2");
						String lockByName = (String) pageContext.getAttribute("fields10");
						%>					
						<%=lockByName %> (<%=lockById%>)
					</display:column>
					<display:column property="fields3" title="Lock Date" style="width:8%" />
					<display:column title="Unlock By"  style="width:10%">
						<c:set var="fields4" value="${row.fields4}"/>	
						<c:set var="fields11" value="${row.fields11}"/>	
						<% 
						String unlockById = (String) pageContext.getAttribute("fields4");
						String unlockByName = (String) pageContext.getAttribute("fields11");
						%>					
						<%=unlockByName %><%=unlockById.isEmpty() ? "" : " (" + unlockById + ")" %>
					</display:column>					
					<display:column property="fields5" title="Unlock Date" style="width:8%" />				
					<display:column property="fields9" title="Last Update Date" style="width:8%" />
					<display:column titleKey="prompt.action" media="html" style="width:5%; text-align:center">
						<button onclick="submitAction('view', '0', '<c:out value="${row.fields0}" />')"><bean:message key='button.view' /></button>
					</display:column>
					<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
				</display:table>
				<script language="javascript">
					function submitSearch() {
						document.searchform.command.value = 'search';
						document.searchform.submit();
						return false;
					}
					
					function clearSearch() {
						document.searchform.patno.value="";
						document.searchform.lockBy.value="";
						document.searchform.lockDateFrom.value="";
						document.searchform.lockDateTo.value="";
						document.searchform.unlockBy.value="";
						document.searchform.unlockDateFrom.value="";
						document.searchform.unlockDateTo.value="";
						document.searchform.reason.value="";
						document.searchform.remarks.value="";
						return false;
					}
					
					function submitAction(cmd, step, keyId) {
						var url = "emr_access.jsp?command=" + cmd + "&listTablePageParaName=<%=listTablePageParaName %>&listTableCurPage=<%=listTableCurPage %>";
						if (cmd != 'view') {
							var patno = $("input[name=patno]").val();
							url = url + "&patno=" + patno;
						} else {
							url = url + "&seqno=" + keyId;
						}
						callPopUpWindow(url);
						return false;
					}
				</script>
			</div>
		</div>
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>