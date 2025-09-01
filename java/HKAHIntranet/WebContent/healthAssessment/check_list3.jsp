<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
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

<!-- 
<c:if test="${healthAssessment == null}">
	<c:redirect url="check_list3.htm" />
</c:if>
-->

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<body>
		<DIV id=indexWrapper>
			<DIV id=mainFrame>
				<DIV id=contentFrame>
					
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="function.haa.list" />
					</jsp:include>
					<c:set var="message" value="${healthAssessment.message}" />
					<jsp:useBean id="message" class="java.lang.String" />
					<c:set var="errorMessage" value="${healthAssessment.errorMessage}" />
					<jsp:useBean id="errorMessage" class="java.lang.String" />
					<jsp:include page="../common/message.jsp" flush="false">
						<jsp:param name="message" value="<%=message %>" />
						<jsp:param name="errorMessage" value="<%=errorMessage %>" />
					</jsp:include>
					<bean:define id="functionLabel1"><bean:message key="function.haa.list" /></bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel1 %>" /></bean:define>
					<form name="search_form" action="check_list3.htm" method="post"> 
						<table cellpadding="0" cellspacing="5"
							class="contentFrameSearch" border="0">
							<tr class="smallText">
								<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
								<td class="infoData" width="70%">
									<select name="enabled">
										<option value=""><bean:message key="label.all" /></option>
										<option value="1"<c:if test="${'1' == healthAssessment.enabled }"> selected</c:if>><bean:message key="label.normal" /></option>
										<option value="2"<c:if test="${'2' == healthAssessment.enabled }"> selected</c:if>><bean:message key="label.archive" /></option>
									</select>
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

					<bean:define id="functionLabel2"><bean:message key="function.haa.list" /></bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel2 %>" /></bean:define>
					
					<form name="form1" action="check_list3.htm" method="post">
						<c:catch var="catchNullException">
							<c:set var="pagesizeInt" value="${healthAssessment.userBean.noOfRecPerPage}"/>
						</c:catch>
						<c:if test = "${catchNullException != null}">
							<c:set var="pagesizeInt" value="1"/>
						</c:if>
						<jsp:useBean id="pagesizeInt" type="java.lang.Integer"/>
						<display:table id="row" name="requestScope.healthAssessment.table" export="true" 
								 pagesize="<%=pagesizeInt %>"
								 class="tablesorter" decorator="com.hkah.web.displaytag.HaaChecklistDecorator" requestURI="check_list3.htm">
							<display:column title="&nbsp;" media="html" style="width:5%"><c:out value="${row_rowNum}"/>)</display:column>
							<display:column property="haaCorpName" titleKey="prompt.corpName" style="width:20%"/>
							
							<display:column titleKey="prompt.busType" style="width:10%">
								<c:if test="${row.haaBusinessType != null}">
									<c:set var="haaBusinessType" value="${row.haaBusinessType }"/>
									<c:set var="haaBusinessTypeHashSet" value="${healthAssessment.haaBusinessTypeHashSet }"/>
									<jsp:useBean id="haaBusinessTypeHashSet" type="java.util.HashMap"/>
									<jsp:useBean id="haaBusinessType" type="java.lang.String"/>
									<%= haaBusinessTypeHashSet.get(haaBusinessType) == null ? "" : haaBusinessTypeHashSet.get(haaBusinessType) %> 
								</c:if>
							</display:column>
							
							<display:column property="haaContractDateRangeDisplay" titleKey="prompt.contractDate" style="width:10%"/>
							<display:column property="status" titleKey="prompt.status" style="width:10%"/>
							<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
								<button onclick="return submitAction('View', '<c:out value="${row.id.haaChecklistId}" />');"><bean:message key='button.view' /></button>
								<c:if test="${row.haaEnabled == 1 }">
									<button onclick="return submitAction('archive', '<c:out value="${row.id.haaChecklistId}" />');"><bean:message key='label.archive' /></button>
								</c:if>
							</display:column>
							<display:setProperty name="basic.msg.empty_list">
								<c:out value="${healthAssessment.notFoundMsg}"/>
							</display:setProperty>
						</display:table>
						<table width="100%" border="0">
							<tr class="smallText">
								<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.haa.create" /></button></td>
							</tr>
						</table>
						<input type="hidden" name="command" />
						<input type="hidden" name="HaaID" />
					</form>
					<script language="javascript">
						function submitSearch() {
							document.search_form.submit();
						}
					
						function clearSearch() {
						}
					
						function submitAction(cmd, haaid) {
							if (cmd == 'archive') {
								document.form1.command.value = cmd;
								document.form1.HaaID.value = haaid;
								document.form1.submit();
								return true;
							} else {
								// Testing
								document.form1.action = "checkitem3.htm";
								document.form1.command.value = cmd;
								document.form1.HaaID.value = haaid;
								document.form1.submit();
								return true;
								// Testing End
								
								// callPopUpWindow("checkitem3.htm?command=" + cmd + "&HaaID=" + haaid);
								// return false;
							}
						}
						
						function submitCommentAction(cmd, haaid, title) {
							callPopUpWindow("../discussionBoard/comment_list.htm?moduleCode=haa&recordId=" + haaid + "&recordTitle=" + title);
							return false;								
						}
						
						// customize table sort
						/*
						var ts = $.tablesorter;
						
						ts.addParser({
							id: "dateRange",
							is: function(s) {
								return false;
							},
							format: function(s,table) {
								var c = table.config;
								
								var dateSplit = s.split(' - ');
				                if(dateSplit && dateSplit.length > 0)
				                	s = dateSplit[0];
				                else
				                	s = "";
								
								s = s.replace(/\-/g,"/");
								if(c.dateFormat == "us") {
									// reformat the string in ISO format
									s = s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/, "$3/$1/$2");
								} else if(c.dateFormat == "uk") {
									//reformat the string in ISO format
									s = s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/, "$3/$2/$1");
								} else if(c.dateFormat == "dd/mm/yy" || c.dateFormat == "dd-mm-yy") {
									s = s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2})/, "$1/$2/$3");	
								}
								return $.tablesorter.formatFloat(new Date(s).getTime());
							},
							type: "numeric"
						});
						
						ts.addParser({
							id: "rowNum",
							is: function(s,table) {
								return false;
							},
							format: function(s) {
								s = s.replace(/\)/g,"");
								return $.tablesorter.formatFloat(s);
							},
							type: "numeric"
						});
						
						$(function() { 
					        $("table#row").tablesorter({ 
					            headers: {
					            	0: {
					            		sorter:'rowNum'
					            	} 
					                , 3: { 
					                    sorter:'dateRange'
					                }
					                , 5: {
					                	sorter: false
					                }
					            } 
					        }); 
					    }); 
					    */
					    
					</script>
				</DIV>
			</DIV>
		</DIV>
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>
