<%@ page language="java"%>
<%
String basePath = request.getParameter("basePath");
String deptCode = request.getParameter("deptCode");
String directoryTitle = null;
String locationPath = null;

if (deptCode == null) {
	directoryTitle = "Department Information";
} else if ("BME".equals(deptCode)) {
	directoryTitle = "Bio-Medical Engineering";
	locationPath = "/Intranet/Dept/BME";
} else if ("DENTAL".equals(deptCode)) {
	directoryTitle = "Dental Policies";
	locationPath = "/Intranet/Dept/Dental";
} else if ("DI".equals(deptCode)) {
	directoryTitle = "Diagnostic Imaging";
	locationPath = "/Intranet/Dept/Diagnostic%20Imaging";
} else if ("FMS".equals(deptCode)) {
	directoryTitle = "Facility Management Service";
	locationPath = "/Intranet/Dept/FacilityMS";
} else if ("FS".equals(deptCode)) {
	directoryTitle = "Nutrition Guidelines";
	locationPath = "/Intranet/Dept/FoodServices";
} else if ("IC".equals(deptCode)) {
	directoryTitle = "Infection Control";
	locationPath = "/Intranet/Dept/Infection%20Control";
} else if ("LAB".equals(deptCode)) {
	directoryTitle = "Laboratory";
	locationPath = "/Intranet/Dept/Laboratory";
} else if ("MM".equals(deptCode)) {
	directoryTitle = "Materials Management";
	locationPath = "/Intranet/Dept/Materials%20Management";
} else if ("CSR".equals(deptCode)) {
	directoryTitle = "CSR";
	locationPath = "/Intranet/Dept/Nursing/CSR";
} else if ("DAY_CASE".equals(deptCode)) {
	directoryTitle = "CSR";
	locationPath = "/Intranet/Dept/Nursing/DayCase";
} else if ("GENERAL_NURSING".equals(deptCode)) {
	directoryTitle = "CSR";
	locationPath = "/Intranet/Dept/Nursing/General%20nursing";
} else if ("HEMO".equals(deptCode)) {
	directoryTitle = "CSR";
	locationPath = "/Intranet/Dept/Nursing/Hemo";
} else if ("ICU".equals(deptCode)) {
	directoryTitle = "CSR";
	locationPath = "/Intranet/Dept/Nursing/ICU";
} else if ("NURSING_ADMIN".equals(deptCode)) {
	directoryTitle = "Nusing Administration";
	locationPath = "/Intranet/Dept/Nursing/Nursing%20Administration";
} else if ("OB".equals(deptCode)) {
	directoryTitle = "OB";
	locationPath = "/Intranet/Dept/Nursing/OB";
} else if ("OPD".equals(deptCode)) {
	directoryTitle = "OPD";
	locationPath = "/Intranet/Dept/Nursing/OPD";
} else if ("OT".equals(deptCode)) {
	directoryTitle = "OT";
	locationPath = "/Intranet/Dept/Nursing/OT";
} else if ("PEDIATRIC".equals(deptCode)) {
	directoryTitle = "Pediatric";
	locationPath = "/Intranet/Dept/Nursing/Pediatric";
} else if ("OSH".equals(deptCode)) {
	directoryTitle = "OSH";
	locationPath = "/Intranet/Dept/OSH";
} else if ("PI".equals(deptCode)) {
	directoryTitle = "Performance Improvement";
	locationPath = "/Intranet/Dept/PI";
} else if ("PHARMACY".equals(deptCode)) {
	directoryTitle = "Pharmacy";
	locationPath = "/Intranet/Dept/Pharmacy";
} else if ("PHYSICIAN".equals(deptCode)) {
	directoryTitle = null;
	locationPath = "../internal/internal_physician.jsp";
} else if ("REHABILITATION".equals(deptCode)) {
	directoryTitle = "Rehabilitation";
	locationPath = "/Intranet/Dept/Rehabilitation";
} else if ("STAFF_EDUCATION".equals(deptCode)) {
	directoryTitle = "Staff Education";
	locationPath = "/Intranet/Dept/Staff%20Education";
}

if (directoryTitle != null) {
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=directoryTitle %>" />
	<jsp:param name="translate" value="N" />
</jsp:include>
<form name="form1" action="dept_info.jsp" method="post">
<%
	if (deptCode != null) {
%>
<jsp:include page="../common/directory.jsp" flush="false">
	<jsp:param name="basePath" value="<%=basePath %>" />
	<jsp:param name="locationPath" value="<%=locationPath %>" />
	<jsp:param name="allowSelectFile" value="Y" />
	<jsp:param name="showSubFolder" value="Y" />
	<jsp:param name="showSubFolderLevel" value="0" />
</jsp:include>
<%
	} else {
%><jsp:include page="../common/dept_directory.jsp" flush="false" /><%
	}
%>
<input type="hidden" name="deptCode">
</form>
<script language="javascript">
	function deptDirectory(dc) {
		document.form1.action = "dept_info.jsp";
		document.form1.deptCode.value = dc;
		document.form1.submit();
	}

	function moveDirectory(file) {
		document.form1.action = "dept_info.jsp";
		document.form1.locationPath.value = file;
		document.form1.submit();
	}

	function downloadFile(file) {
		document.form1.action = "../documentManage/download.jsp";
		document.form1.locationPath.value = file;
		document.form1.submit();
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
<%} else { %>
	<jsp:forward page="<%=locationPath %>" />
<%} %>