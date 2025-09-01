<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%
String accessionNo = request.getParameter("accessionNo");

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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp" />
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/pro-bars.min.css" />" />
	<script type="text/javascript" src="<html:rewrite page="/js/visible.min.js"/>" /></script>
	<script type="text/javascript" src="<html:rewrite page="/js/pro-bars.js"/>" /></script>
	
<style>
div.link-list {
        width:28em;
        position:absolute;
        top:0;
        font-size:80%;
        padding-left:1%;
        padding-right:1%;
        margin-left:0;
        margin-right:0;
}
#main {
        margin-left:30em;
        margin-right:30em;
        font-size:80%;
        padding-left:1em;
        padding-right:1em;
}
#list1 {
        left:0;
}
#list2 {
        right:0;
}
</style>
	<body>
				<div id="main"><span id="case_indicator"></span></div>
				<div id="list2" class="link-list">
					<table>
					<tr><td><input type="text" name="accessionNoToSent" id="accessionNoToSent" style="height:50px;width:300px;"/></td></tr>
					<tr><td><button id="sdCase" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Send Case</button></td></tr>
					<tr><td><span id="sending_indicator"></span></td></tr>
					<tr><td><span id="result_indicator"></span></td></tr>
					</table>
				</div>
				<div id="list1" class="link-list">
					
					<table>
						<tr>
							<td>
							<table cellpadding="0" border="0">
										<tr >
											<td >
												patno: 
											</td>
											<td >
												<input type="text" name="patno" id="patno"/>
											</td>
										</tr>
										<tr >
											<td >
												accession Number: 
											</td>
											<td >
												<input type="text" name="accessionNo" id="accessionNo"/>
											</td>
										</tr>
		
										<tr>
											<td colspan="4" align="center">
												<button id="searchBtn">
													<bean:message key="button.search" />
												</button>
											</td>
										</tr>
									</table>
							</td>
						</tr>
					</table>
						<span id="search_indicator"></span>			

				</div>		
					<script language="javascript">
						function submitSearch() {						
								$("#search_indicator").html("");
						 		$.ajax({
									type: "POST",
									url: "testSearch.jsp",
									data: "accessionNo="+document.getElementById("accessionNo").value
									+"&patNo="+document.getElementById("patno").value,
									success: function(values) {
										if (values != '') {
											$("#search_indicator").html(values);
										} else {//if
										 	$("#search_indicator").html("");
										}
									}//success
							});//$.ajax 
							return false;
						}
						
						function viewCase(accessionNo) {
							$("#case_indicator").html("");
					 		$.ajax({
								type: "POST",
								url: "../testing/testCaseDetails.jsp",
								data: "accessionNo="+accessionNo,
								success: function(values) {
									if (values != '') {
										$("#case_indicator").html(values);
									} else {//if
									 	$("#case_indicator").html("");
									}
								}//success
						});//$.ajax 
						return false;
						}
					
						function addtoQueue(accessionNo) {
							document.getElementById("accessionNoToSent").value = 
								document.getElementById("accessionNoToSent").value+
								(document.getElementById("accessionNoToSent").value == ''? "":", ")
										+"'"+accessionNo+"'";
							
							$("#sending_indicator").append("<div class=\"caseSend\" id=\""+accessionNo+""+"\"> ");
								$("#sending_indicator").append("<a>"+accessionNo+"</a>");								
								$("#sending_indicator").append(
									"<div id=\""+accessionNo+"_status\" style=\"display:none\">Sending</div>");
							$("#sending_indicator").append("</div>");
							return false;
						}
						
						$(document).ready(function() {
							$('#searchBtn').click(function() {
								submitSearch();
							});
							$( document ).ajaxStart(function() {
								  $( "#loading" ).show();
							});
							
					   		$('#sdCase').click(function() {
					   			$(".caseSend").each(function() {
					   				var t = this.id+'_status';
								 		$.ajax({
											type: "POST",
											url: "../testing/testSendCase.jsp",
											data: "accessionNo="+this.id.trim(),
											beforeSend:function(){												
												$('#'+t).css('display', '');
											},
											success: function(values) {
												if (values != '') {
													alert(values);
													$('#'+t).html(values);
													//$("#result_indicator").html(values);
												} else {//if
													$('#'+t).html("");
												}
											}//success
									});//$.ajax 
					   			});
					   			
							return false;
						}); 
						});
					</script>
	</body>
</html:html>