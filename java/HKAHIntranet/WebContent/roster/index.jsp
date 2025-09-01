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
<%@ page language="java" contentType="text/html; charset=big5"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
boolean isDeptHead = StaffDB.isDeptHead(userBean.getStaffID(), userBean.getDeptCode());
%>
<html:html xhtml="true" lang="true">
<body>
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="function.roster.menu" />
		<jsp:param name="accessControl" value="N"/>
		<jsp:param name="isHideTitle" value="Y"/>
	</jsp:include>
	
	<jsp:forward page="rosterform.jsp">
		<jsp:param value="<%=isDeptHead %>" name="isDeptHead"/>
	</jsp:forward>
</body>
</html:html>
