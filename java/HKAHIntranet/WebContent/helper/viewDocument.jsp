<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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
<%
String elearningID = request.getParameter("elearningID");
String moduleCode = request.getParameter("moduleCode");
String eventID = request.getParameter("eventID");
String enrollID = request.getParameter("enrollID");

ArrayList record = null;
if (elearningID != null) {
	record = DocumentDB.getELearningDoc(elearningID);
} else {
	record = DocumentDB.getEnrollDoc(moduleCode, eventID, enrollID);
}
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		char cnt = (char) (i + 97);
%>
<span style="position: relative; top: -2%; transform: translateY(-2%);"><%=cnt %>)</span>
<img src="../<%=IconSelector.selectIcon(row.getValue(2)) %>" width="24" height="24">
<button onclick="downloadFile('<%=row.getValue(0) %>');return false;"><bean:message key="button.view" /> <%=row.getValue(1) %></button><br><%
	}
} else {
%><bean:define id="functionLabel"><bean:message key="prompt.document" /></bean:define>
<bean:message key="message.notFound" arg0="<%=functionLabel %>" /><%
}
%>