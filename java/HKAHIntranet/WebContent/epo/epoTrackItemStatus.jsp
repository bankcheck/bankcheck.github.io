<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="org.displaytag.decorator.*"%>
<%@ page import="org.displaytag.exception.DecoratorException"%>
<%@ page import="org.displaytag.properties.MediaTypeEnum"%>
<%
UserBean userBean = new UserBean(request);
int noOfCol = 7;//no of column in list
String reqNo = request.getParameter("reqNo");
String itemDesc = request.getParameter("itemDesc");
String reqSeq = request.getParameter("reqSeq");
ArrayList al_epo = EPORequestDB.getTrackItemStatus(reqNo, reqSeq);
ArrayList al_epoLog = EPORequestDB.getTrackItemLog(reqNo, reqSeq);
request.setAttribute("EPO",al_epo);
request.setAttribute("EPO1",al_epoLog);
int epoSize = al_epo.size();
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<bean:define id="functionLabel"><bean:message key="function.epo.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">		
	<tr class="smallText">
		<td class="infoSubTitle1"><label for="itemStatus">Item Status</label></td>
	</tr>	
</table>
<display:table id="resList" name="EPO"  class="tablesorter">	     
	<display:column title="&nbsp;" media="html" style="width:2%"></display:column>	   
	<display:column style="width:15%; text-align:center" title="Record Status">	
		<div>${EPO[resList_rowNum - 1].fields0}</div>
    </display:column>    				           	
    <display:column  style="width:15%; text-align:left" title="Update By">
		<div>${EPO[resList_rowNum - 1].fields1}</div>
	</display:column>
    <display:column  style="width:15%; text-align:left" title="Update Date">
		<div>${EPO[resList_rowNum - 1].fields2}</div>
	</display:column>	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>	           					            
</display:table>
&nbsp
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">		
	<tr class="smallText">
		<td class="infoSubTitle1"><label for="itemLog">Item Modify Log</label></td>
	</tr>	
</table>
<display:table id="resListLog" name="EPO1" class="tablesorter">	     
	<display:column title="&nbsp;" media="html" style="width:2%"></display:column>	   
	<display:column style="width:15%; text-align:center" title="Item Desc">	
		<div>${EPO1[resListLog_rowNum - 1].fields0}</div>
    </display:column>    				           	
    <display:column  style="width:15%; text-align:left" title="QTY">
		<div>${EPO1[resListLog_rowNum - 1].fields1}</div>
	</display:column>
    <display:column  style="width:15%; text-align:left" title="Price">
		<div>${EPO1[resListLog_rowNum - 1].fields2}</div>
	</display:column>
    <display:column  style="width:15%; text-align:left" title="Amount">
		<div>${EPO1[resListLog_rowNum - 1].fields3}</div>
	</display:column>
    <display:column  style="width:15%; text-align:left" title="Modify By">
		<div>${EPO1[resListLog_rowNum - 1].fields4}</div>
	</display:column>
    <display:column  style="width:15%; text-align:left" title="Modify Date">
		<div>${EPO1[resListLog_rowNum - 1].fields5}</div>
	</display:column>				
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>	           					            
</display:table>
&nbsp
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>			
		</td>			
	</tr>
</table>
</body>
</html:html>
<script type="text/javascript">
function closeAction() {
	window.close();
}
</script>