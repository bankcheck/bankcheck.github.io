<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%
	UserBean userBean = new UserBean(request);
	String type = request.getParameter("type");
	String staffID = userBean.getStaffID();
	String loginID = userBean.getLoginID();
	
	System.out.println(new Date() + " [redirect_pharm.jsp] type="+type+", staffID="+staffID+", loginID="+loginID+", userName="+userBean.getUserName());
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%
if (loginID == null) {
%>
<html>
<head></head>
<body>
<script type="text/javascript">
	alert('Sorry, system cannot find your user info. Please try to logout and login Intranet Portal again.');
</script>
</body>
</html>
<%
} else {
	String URL = null;
	String host = null;
	if("moeDrug".equals(type)){
		if (ConstantsServerSide.isTWAH()) {
			host = ConstantsServerSide.DEBUG ? "192.168.0.50" : "192.168.0.80";
			URL = "http://" + host + "/moe_drug/Moe.jsp?"+
			  "login="+loginID+"&loginName="+userBean.getUserName()+	  
			  "&hospitalCode=&userRank=admin&userRankDesc=admin"+
			  "&systemLogin=MOE_DRUG_MAIN&hospitalName=Adventist Hospital";
		
		}else if (ConstantsServerSide.isHKAH()) {
			host = ConstantsServerSide.DEBUG ? "160.100.11.8" : "160.100.3.35";
			URL = "http://" + host + "/moe_drug/Moe.jsp?"+
			   "login="+loginID+"&loginName="+userBean.getUserName()+
			   "&hospitalCode=&userRank=admin"+
			   "&userRankDesc=admin&systemLogin=MOE_DRUG_MAIN&hospitalName=Adventist Hospital";	
		}
	}else if("favMaint".equals(type)){
	   if (ConstantsServerSide.isTWAH()) {
		   host = ConstantsServerSide.DEBUG ? "192.168.0.50" : "192.168.0.80";
			URL = "http://" + host + "/MyFavouriteMaintenance/html/index.jsp?"+
				  "engSurName=CHAN&engGivenName=TAI20MAN&"+"login="+loginID+
				  "&hospitalCode=AH&specialty=AH&isDepartment=Y"+"&loginName="+userBean.getUserName()+
				  "&userRank=Admin&userRankDesc=Admin";
			
			}
	}else if("favMaint2".equals(type)){
	   if (ConstantsServerSide.isTWAH()) {
		   host = ConstantsServerSide.DEBUG ? "192.168.0.50" : "192.168.0.80";
			URL = "http://" + host + "/MyFavouriteMaintenance/html/index.jsp?"+
				  "engSurName=Lee&engGivenName=Shuk%20Ching%20Suzanne&login="+loginID+
				  "&hospitalCode=AH&specialty=UC&isDepartment=Y&loginName="+userBean.getUserName()+
				  "&userRank=Admin&userRankDesc=Admin";
			
			}
	}
	
	System.out.println("[redirect_pharm.jsp] URL="+URL);
	response.sendRedirect(URL);
}

%>

