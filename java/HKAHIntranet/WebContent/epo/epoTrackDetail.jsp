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
ArrayList al_epo = EPORequestDB.getTrackDtl(reqNo);
request.setAttribute("EPO",al_epo);
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
<display:table id="resList" name="EPO" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">	     
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("resList_rowNum")%>)</display:column>	   
	<display:column style="width:15%; text-align:center" title="Item Desc.">	
		<div>${EPO[resList_rowNum - 1].fields0}</div>
    </display:column>    				           	
    <display:column  style="width:15%; text-align:left" title="Propose Supplier">
		<div>${EPO[resList_rowNum - 1].fields1}</div>
	</display:column>
    <display:column  style="width:5%; text-align:left" title="Req QTY">
		<div>${EPO[resList_rowNum - 1].fields2}</div>
	</display:column>	
	<display:column style="width:5%; text-align:center" title="Unit">	
		<div>${EPO[resList_rowNum - 1].fields3}</div>
    </display:column>
	<display:column style="width:8%; text-align:center" title="Req Item Price">	
		<div>${EPO[resList_rowNum - 1].fields4}</div>
    </display:column>    	
	<display:column style="width:8%; text-align:left" title="Req Item Amount">	
		<div>${EPO[resList_rowNum - 1].fields5}</div>
    </display:column>
    <display:column  style="width:8%; text-align:right" title="PO NO.">
		<div>${EPO[resList_rowNum - 1].fields6}</div>
	</display:column>
    <display:column  style="width:5%; text-align:right" title="Ord QTY">
		<div>${EPO[resList_rowNum - 1].fields7}</div>
	</display:column>
    <display:column  style="width:8%; text-align:right" title="Ord Price">
		<div>${EPO[resList_rowNum - 1].fields8}</div>
	</display:column>
    <display:column  style="width:8%; text-align:right" title="Net Amount">
		<div>${EPO[resList_rowNum - 1].fields13}</div>
	</display:column>
    <display:column  style="width:15%; text-align:center" title="Ord Supplier">
		<div>${EPO[resList_rowNum - 1].fields10}</div>
	</display:column>
    <display:column  style="width:1%;">
		<div>			
			<input type="hidden" name="itemSeq[${resList_rowNum - 1}].fields12"
			value="${EPO[resList_rowNum - 1].fields12}" />
		</div>
	</display:column>	
	<display:column title="View" media="html" style="width:10%; text-align:center">
		<button onclick="return viewReqItemStatus('<%=reqNo %>','<c:out value="${resList.fields12}" />');"><bean:message key="button.view" /></button>
	</display:column>										
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>	           					            
</display:table>
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

function viewReqItemStatus(reqNo, reqSeq){
	callPopUpWindow("../epo/epoTrackItemStatus.jsp?reqNo="+reqNo+"&reqSeq="+reqSeq);
	return false;
}
</script>