<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.PHDrugDB"%>
<%
String type = request.getParameter("type");
String drugClass = request.getParameter("drugClass");
String drugName =  "";

if(	request.getParameter("drugName") != null ){
	drugName = TextUtil.parseStrUTF8(java.net.URLDecoder.decode(request.getParameter("drugName").replaceAll("%", "%25")));
}

if("subtable".equals(type)){
	if(drugClass != null && drugClass.length() > 0){
		drugClass = drugClass.split(" ")[0];
	}
}
ArrayList record = PHDrugDB.getDrugFolder(drugClass, drugName);
request.setAttribute("drug_list", record);
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
<div id='availableList' style=" min-height: 0;background-color:#0070C0;color:white;font-weight:bold;font-size:16px;padding:2px;">Available Drugs</div>
<bean:define id="functionLabel">Drug List</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table export="false" id="row" name="requestScope.drug_list" pagesize="5000" class="generaltable">	

<c:set var="dClassOne" value="${row.fields1}"/>
<c:set var="dClassTwo" value="${row.fields2}"/>
<c:set var="dClassThree" value="${row.fields3}"/>
<c:set var="dClassFour" value="${row.fields4}"/>
<%
String dClassOne = (String)pageContext.getAttribute("dClassOne") ;
String dClassTwo = (String)pageContext.getAttribute("dClassTwo") ;
String dClassThree = (String)pageContext.getAttribute("dClassThree") ;
String dClassFour = (String)pageContext.getAttribute("dClassFour") ;
%>
	<display:column class='1' title="Section Name"  style="width:25%" >			
		<%=PHDrugDB.getDrugClassName(dClassOne, dClassTwo, dClassThree, dClassFour) %>
	</display:column>
<c:set var="dGenName" value="${row.fields7}"/>
<c:set var="dBraName" value="${row.fields8}"/>
<%
	
	String dGenName = (String)pageContext.getAttribute("dGenName") ;
	String dBraName = (String)pageContext.getAttribute("dBraName") ;
	 if ("twah".toUpperCase().equals(ConstantsServerSide.SITE_CODE.toUpperCase())){ 
		if(dGenName != null && dGenName.length() > 0){		
			if(dGenName.trim().endsWith("*")){
				dGenName = "<font style='text-decoration: line-through;'>" + dGenName + "</font>"; 
			}
		}
		if(dBraName != null && dBraName.length() > 0){
			if(dBraName.trim().endsWith("*")){
				dBraName = "<font style='text-decoration: line-through;'>" + dBraName + "</font>"; 
			}
		}	
	 }
	if(drugName != null && drugName.length() > 0){
		String tempDrugName = drugName.toUpperCase().trim();
		if(tempDrugName.contains("(") || tempDrugName.contains(")")){
			
		} else {			
			if(dGenName != null && dGenName.length() > 0){		
				dGenName =dGenName.toUpperCase().trim().replaceAll(tempDrugName, "<span style='background-color:yellow;'>" + tempDrugName + "</span>");	
			}
			if(dBraName != null && dBraName.length() > 0){				
				dBraName = dBraName.toUpperCase().trim().replaceAll(tempDrugName, "<span style='background-color:yellow;'>" + tempDrugName + "</span>");
			}
		}
	}
%>
	<display:column title="Generic Name" style="width:25%">
		<%=dGenName %>
	</display:column>
	<display:column title="Brand Name" style="width:20%">
		<%=dBraName %> 
	</display:column>	
	<display:column title="Dosage Form" style="width:10%">
		<c:out value="${row.fields9}" /> 
	</display:column>	
	<display:column title="Strength" style="width:10%">
		<c:out value="${row.fields10}" /> 
	</display:column>	
<% if ("twah".toUpperCase().equals(ConstantsServerSide.SITE_CODE.toUpperCase())){ %>
	<display:column title="Remark" style="width:10%">
		<c:out value="${row.fields13}" /> 
	</display:column>
<% } %>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>

</html:html>