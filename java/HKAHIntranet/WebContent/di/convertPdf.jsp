<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.math.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.convert.*"%>
<%@ page import="java.io.*"%>
<%!
%>
<%	
UserBean userBean = new UserBean(request);
response.setHeader("Pragma","no-cache");
response.setHeader("Pragma-directive","no-cache");
response.setHeader("Cache-directive","no-cache");
response.setHeader("Cache-control","no-cache");
response.setHeader("Expires","0");


String rptLogID = ParserUtil.getParameter(request, "rptLogID");
String accessionNo = "";
String destinationDir = "";

String sLoginID = RISDB.getDocLoginID(rptLogID);
ArrayList<String> imageName = new ArrayList<String>();
boolean allowReadDoc = false;

ArrayList rptLogList = RISDB.getRptLogDetail(rptLogID);
for (int i = 0; i < rptLogList.size(); i++) {			
	ReportableListObject row = (ReportableListObject) rptLogList.get(0);
	accessionNo = row.getValue(0);	
}
if (userBean.isLogin()) {
	if(accessionNo != null && accessionNo.length() > 0){
		if(RISDB.allowReadDoc(userBean, rptLogID) || userBean.isAdmin() || userBean.isAccessible("function.di.document.view")){
			allowReadDoc = true;
		}
	}
	if(allowReadDoc){
		RISDB.updateReadDoc(userBean, rptLogID);
		if(ConstantsServerSide.DEBUG) {
			destinationDir = RISDB.getDIReportImagePath(); // converted images from pdf document are saved here	
		}

		File folder = new File(RISDB.getDIReportImagePath() + accessionNo + "\\" );
		if (folder != null){
			File[] listOfFiles = folder.listFiles();			
			for (int i = 0; i < listOfFiles.length; i++) {
			  if (listOfFiles[i].isFile()) {    
			    imageName.add(listOfFiles[i].getName());
			  } 
			}
		}
		Collections.sort(imageName, new Comparator<String>() {
	        public int compare(String s1, String s2) {
	        	  try {
	                  int i1 = Integer.parseInt(s1.split(".png")[0]);
	                  int i2 = Integer.parseInt(s2.split(".png")[0]);
	                  return i1 - i2;
	              } catch(NumberFormatException e) {
	                  throw new AssertionError(e);
	              }
	        }
	    });		
	} else {

%>		
		<script language="javascript">parent.location.href = "../common/access_deny.jsp";</script>
<%

	}
}

%>
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="DI Report" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="sLoginID" value="<%=sLoginID %>" />
</jsp:include>
<style>
</style>
<body style="width:100%">
<% 
if(RISDB.checkReportAvailable(accessionNo)){		
	if(allowReadDoc && imageName != null && imageName.size() > 0) {
		String avoidCache = String.valueOf(new Date().getTime());
 	 	for(String s : imageName){
 			if(destinationDir != null && destinationDir.length() > 0){ %>	
				<img style="width:100%" src="<%=destinationDir + accessionNo + "\\" + s%>?<%=avoidCache%>"/>
				<hr style="background: black; border: none; height: 5px;" />
<%			} else { %>
				<img width='100%' src="/cms/DITempImage/<%=accessionNo + "/" + s%>?<%=avoidCache%>"/>
				<hr style="background: black; border: none; height: 5px;" />
<%		 	} %>
<% 	   	} %>
<%	 } else { %>
		<div style='font-size:190%'>DI report cannot be found.</div>
<% 	} %>
<% } else { %>
		<div style='font-size:190%'>The result is pending, please call DI if required.</div>
<% } %>
<script type="text/javascript" language="JavaScript">
var idleTime = 0;
$(document).ready(function() {
	var idleInterval = setInterval(timerIncrement, 60000); // 1 minute

    //Zero the idle timer on mouse movement.
    $(this).mousemove(function (e) {
        idleTime = 0;
    });
    $(this).keypress(function (e) {
        idleTime = 0;
    });	
});
 
function timerIncrement() {
	 idleTime = idleTime + 1;
    if (idleTime > 9) { // 10 minutes logout
		window.location="../Logoff.do";
    }
}
</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>