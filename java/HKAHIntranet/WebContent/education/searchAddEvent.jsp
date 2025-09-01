<%@ page import="com.hkah.util.TextUtil"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
	UserBean userBean = new UserBean(request);

	String moduleCode = request.getParameter("moduleCode");
	String deptCode = request.getParameter("deptCode");
	String eventCategory = request.getParameter("eventCategory");
	String eventType = request.getParameter("eventType");
	String eventType2 = request.getParameter("eventType2");
	String eventDesc = TextUtil.parseStrUTF8(request.getParameter("eventDesc"));
	boolean eventDescIgnoreCase = "Y".equals(request.getParameter("eventDescIgnoreCase"));
	String eventDetail = TextUtil.parseStrUTF8(request.getParameter("eventDetail"));
	
	String eventID = null;
	if (eventDesc != null) {
		eventDesc = eventDesc.trim();
		eventID = EventDB.getEventID(moduleCode, eventDesc, eventDescIgnoreCase, eventCategory, eventType);
		if (eventID == null) {	// event not exists
			eventID = EventDB.add(userBean, moduleCode, deptCode, eventCategory, eventType, eventType2, eventDesc, eventDetail);
		}
	}
	
	String selectName = request.getParameter("selectName");
	String selectId = request.getParameter("selectId");
	String selectClass = request.getParameter("selectClass");
	String selectStyle = request.getParameter("selectStyle");
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
<%
	String selectAttr = "";
	if (selectName != null) {
		selectAttr += " name=\"" + selectName + "\"";
	}
	if (selectId != null) {
		selectAttr += " id=\"" + selectId + "\"";
	}
	if (selectClass != null) {
		selectAttr += " class=\"" + selectClass + "\"";
	}
	if (selectStyle != null) {
		selectAttr += " style=\"" + selectStyle + "\"";
	}
%>
<select<%=selectAttr %>>
	<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
		<jsp:param name="moduleCode" value="<%=moduleCode %>" />
		<jsp:param name="eventType" value="<%=eventType %>" />
		<jsp:param name="eventID" value="<%=eventID %>" />
	</jsp:include>
</select>