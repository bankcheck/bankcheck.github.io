<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String deptDesc = userBean.getDeptDesc();
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<style>
		.wrapper {
			position:absolute; 
			z-index:12;
		}
	</style>
	<body>
		<div id="alertDialog" style="width:300px; height:auto; position:absolute; z-index:105; display:none;"
				class="ui-dialog ui-widget ui-widget-content ui-corner-all">
			<div align="left" class = "ui-widget-header"><label>Information</label></div>
			<div align="left"><label id="alertMsg"></label></div>
			<div>&nbsp;</div>
			<div align="right">
				<button id="closeAlert" class="ui-button ui-widget ui-state-default ui-corner-all cancelDialogBtn">
					<label>Close</label>
				</button>
			</div>
		</div>
		
		<div id="deleteDialog" style="width:300px; height:auto; position:absolute; z-index:105; display:none;"
				class="ui-dialog ui-widget ui-widget-content ui-corner-all">
			<div align="left" class = "ui-widget-header"><label>Delete</label></div>
			<div align="left"><label id="deletePrompt">Delete selected record?</label></div>
			<div>&nbsp;</div>
			<div align="right">
				<button id="submitDelete" class="ui-button ui-widget ui-state-default ui-corner-all submitDialogBtn">
					<label>Delete</label>
				</button>
				<button id="cancelDelete" class="ui-button ui-widget ui-state-default ui-corner-all cancelDialogBtn">
					<label>Cancel</label>
				</button>
			</div>
		</div>
		
		<div id="addDialog" style="width:300px; height:auto; position:absolute; z-index:105; display:none;"
			class="ui-dialog ui-widget ui-widget-content ui-corner-all">
			<div align="left" class = "ui-widget-header"><label>Add</label></div>
			
			<div align="left">
				<table>
					<tr>
						<td><label id="staffIDLabel">Staff ID:&nbsp;</label></td>
						<td><input type="text" id="addStaffID" value=""/></td>
					</tr>
					<tr>
						<td><label id="staffNameLabel">Staff Name:&nbsp;</label></td>
						<td><label id="staffNameValue"></label></td>
					</tr>
					<tr>
						<td><label id="deptLabel">Dept:&nbsp;</label></td>
						<td><label id="deptValue"></label></td>
					</tr>
					<tr>
						<td><label id="postLabel">Post:&nbsp;</label></td>
						<td><input type="text" value="" id="postValue"></input></td>
					</tr>
					<tr>
						<td><label id="inchargeLabel">In-Charge:&nbsp;</label></td>
						<td><input type="checkbox" value="" id="inchargeValue"></input></td>
					</tr>
				</table>
			</div>
			
			<div>&nbsp;</div>
			<div align="right">
				<button id="submitAdd" 
						class="ui-button ui-widget ui-state-default ui-corner-all submitDialogBtn">
					<label>Submit</label>
				</button>
				<button id="cancelAdd" 
						class="ui-button ui-widget ui-state-default ui-corner-all cancelDialogBtn">
					<label>Cancel</label>
				</button>
			</div>
		</div>
		
		<div id="rosterStaffWrapper" class="wrapper">
			<table id="rosterStaffGrid">
			</table>
			<div id="rosterStaffPager"></div>
		</div>
	</body>
	<script type="text/javascript">
		var deptDesc = '<%=deptDesc%>';
	</script>
	<script type="text/javascript" src="<html:rewrite page="/roster/roster.staffList.js" />"></script>
</html:html>
