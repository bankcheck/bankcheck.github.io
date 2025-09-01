<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%


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
<style>
.td_details{
padding: 5px; font-size:10pt"
}
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Hospital & Nursing Orientation Schedule" />
	<jsp:param name="translate" value="N" />
	
	<jsp:param name="category" value="title.education" />
</jsp:include>
<table border = "1" style="text-align:center;width:100%;border-collapse: collapse;">
<tr >
	<td class="labelColor8" style="font-weight:bold; padding: 5px; font-size:11pt">
		Nursing Orientation 0800-1200 (4 hrs)
		<br/>
		醫院迎新課程 0800-1200 (4小時)
		<br/>
		(New Staff 新入職員工)
	</td>
	<td class="labelColor8" style="font-weight:bold; padding: 5px;font-size:11pt">
		Hospital Orientation 1300-1700 (4 hrs)
		<br/>
		醫院迎新課程 1300-1700 (4小時)
		<br/>
		(New Staff 新入職員工)
	</td>
</tr>
<tr>
	<td  style="padding: 5px; font-size:10pt">
		2015-08-17 (Monday) (星期一)
	</td>
	<td style="padding: 5px; font-size:10pt"">
		2015-08-17 (Monday) (星期一)
	</td>
</tr>
<tr>
	<td style="padding: 5px; font-size:10pt"">
		2015-09-21 (Monday) (星期一)
	</td>
	<td style="padding: 5px; font-size:10pt"">
		2015-09-21 (Monday) (星期一)
	</td>
</tr>
<tr>
	<td style="padding: 5px; font-size:10pt"">
		2015-10-19 (Monday) (星期一)
	</td>
	<td style="padding: 5px; font-size:10pt"">
		2015-10-19 (Monday) (星期一)
	</td>
</tr>
<tr>
	<td style="padding: 5px; font-size:10pt"">
		2015-11-16 (Monday) (星期一)
	</td>
	<td style="padding: 5px; font-size:10pt"">
		2015-11-16 (Monday) (星期一)
	</td>
</tr>
<tr>
	<td style="padding: 5px; font-size:10pt"">
		2015-12-21 (Monday) (星期一)
	</td>
	<td style="padding: 5px; font-size:10pt"">
		2015-12-21 (Monday) (星期一)
	</td>
</tr>
</table>
<br/>
<table style="font-size:11pt" border=0>
	<tr>
		<td style="width:75px">Venue:</td>
		<td>Room 101, 1/F, Staff Quarter, HKAH-TW</td>
	</tr>
	<tr>
		<td>RN/EN:</td>
		<td>Attend 0800-1200 (4 hours) and 1300-1700 (4 hours)</td>
	</tr>
	<tr>
		<td>Lunch:</td>
		<td>1200-1300 (will be provided by Nursing Admin. Dept.)</td>		
	</tr>
</table>
</DIV>

</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>