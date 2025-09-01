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

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="function.cs.service" />
		<jsp:param name="isHideTitle" value="Y" />
	</jsp:include>
	
	<body>
	<div style="margin:auto; display:block;">
	<table cellpadding="0" cellspacing="5" border="0" style="width:100%">
		<tr style="width:100%"><td>&nbsp;</td></tr>							
		<tr>
			<td align="center">
				<button type="button" onclick="openLink('patlist')" style="text-decoration:none;font-size:30px;width:400px;height:100px;"class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Patient List</button>
			</td>
		</tr>	
		<tr style="width:100%"><td>&nbsp;</td></tr>			
		<tr>
			<td align="center">
				<button type="button" onclick="openLink('staffList')" style="text-decoration:none;font-size:30px;width:400px;height:100px;"class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Staff List</button>
			</td>
		</tr>
		<tr style="width:100%"><td>&nbsp;</td></tr>				
		<tr>
			<td align="center">
				<button type="button" onclick="openLink('report')" style="text-decoration:none;font-size:30px;width:400px;height:100px;"class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Caretracking Report</button>
			</td>
		</tr>					
	
	
	</table>	
	
	</div>			
							
	</body>
</html:html>

<script>
function openLink(type) {
	if(type == 'patlist') {
		window.open('../chaplaincy/patlist.jsp', '_blank');
	}
	else if(type == 'report') {
		window.open('../chaplaincy/ccreport.jsp', '_blank');
	}
	else if(type == 'staffList') {
		window.open('../chaplaincy/stafflist.jsp', '_blank');
	}
}
</script>