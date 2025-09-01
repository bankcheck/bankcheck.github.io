<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%@ page language="java"
%><%@ page import="java.io.*"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ page import="com.hkah.convert.Converter"
%>
<%
UserBean userBean = new UserBean(request);

String policyType = TextUtil.parseStrUTF8(request.getParameter("policyType"));
String sourcePath = "";
if (request.getParameter("sourcePath") != null){
	sourcePath =TextUtil.parseStrUTF8(java.net.URLDecoder.decode(request.getParameter("sourcePath").replaceAll("%", "%25")));
}
String fileName = TextUtil.parseStrUTF8(request.getParameter("fileName"));

if(policyType != null) {
	if("H".equals(policyType.toUpperCase())){
		sourcePath = ConstantsServerSide.POLICY_FOLDER + "/hospital-wide/" + fileName ;	
	} else if ("H_TEST".equals(policyType.toUpperCase())){
		sourcePath = ConstantsServerSide.POLICY_FOLDER + "/hospital-wide_test/" + fileName ;
	} else if ("PS".equals(policyType.toUpperCase())){
		sourcePath = ConstantsServerSide.POLICY_FOLDER + "/departmental/Physician Service/1. Policy/" + fileName ;
	}
}

String outputPath = ConstantsServerSide.DOCUMENT_FOLDER + "/Intranet/Swf/tempPolicy";
//String outputPath = ConstantsServerSide.DOCUMENT_FOLDER + "/Swf/tempPolicy";		

System.out.println(sourcePath);
System.out.println(outputPath);
System.out.println(fileName);

String fileNameAfterCon = Converter.convertPDF2SWF(sourcePath, outputPath, fileName);
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

.swf-display {margin:10px 20px;}
</style>  
<body>
<% if ("h".equals(policyType)||"ps".equals(policyType)) { %>
<script type="text/javascript">
$(document).ready(function(){
	showPdfjs('<%=sourcePath.replaceAll("\\\\" , "/").replace("'", "\\'")%>', '', '_self');
});
</script>
<% } else if (fileNameAfterCon != null && fileNameAfterCon.length() > 0){ %>
<!-- 
	</br>
	<%= sourcePath%>
	</br>
	<%= outputPath%>
	</br>
	<%= fileNameAfterCon%>
	</br>
 -->	
 	<div id="myContent">
	      <p>Unable to display policy</p>
	</div> 
		
	 <script type="text/javascript">
	 var flashvars = {};
	 var params = { scale: "exactFit",
			 		wmode: "transparent",
			 		menu: "false"
			 		};
	 var attributes = {"class": "swf-display"};

	 swfobject.embedSWF("/swf/tempPolicy/<%=fileNameAfterCon + ".swf"%>", "myContent", "95%", "900", "9.0.0", "expressinstall.swf", flashvars, params, attributes);
	
	</script>
<% } else { %>
	<p>Unable to display policy</p>
<% } %>
<jsp:include page="../common/footer.jsp" flush="true" />
</body>
</html:html>