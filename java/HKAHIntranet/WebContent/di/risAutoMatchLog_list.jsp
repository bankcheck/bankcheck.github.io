<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.RISDB"%>
<%@ page import="java.util.*" %>
<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

List<String> statusList = null;
try {
	if ("1".equals(step)) {
		// actions
	}
	
	statusList = RISDB.getRisAutoMatchLogStatus();
} catch (Exception e) {
	e.printStackTrace();
	errorMessage = "Action fail.";
}

if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}
%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.di.risAutoMatchLog.list" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="mustLogin" value="Y" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">RIS Accession No</td>
		<td class="infoData" width="70%"><input type="text" name="accessno" value="" size="50" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Patient No.</td>
		<td class="infoData" width="70%"><input type="text" name="patno" value="" size="50" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Status</td>
		<td class="infoData" width="70%">
			<select name="status">
				<option value=""></option>
				<%
					for (int i = 0; i < statusList.size(); i++) {
				%>
					<option value="<%=statusList.get(i)%>"><%=statusList.get(i) %></option>
				<%
					}
				%>
			</select>
		
		</td>
	</tr>	
	<tr class="smallText">
		<td colspan="2" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
			<button type="reset"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<form name="form1" action="<html:rewrite page="/di/risAutoMatchLog_list.jsp" />" method="post">
<span id="risAutoMatchLog_list_result"></span>
<input type="hidden" name="command" /> 
<input type="hidden" name="step" />
<input type="hidden" name="logno" />
</form>
<script language="javascript">
	$(document).ready(function() {

	});

	// ajax
	var http = createRequestObject();

	function submitSearch() {
		var accessno = document.search_form.accessno.value;
		var patno = document.search_form.patno.value;
		var status = document.search_form.status.options[document.search_form.status.selectedIndex].value;
		
		//show loading image
		document.getElementById("risAutoMatchLog_list_result").innerHTML = '<img src="../images/wait30trans.gif">';

		//make a connection to the server ... specifying that you intend to make a GET request
		//to the server. Specifiy the page name and the URL parameters to send
		//http.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
		http.open('get', 'risAutoMatchLog_list_result.jsp?accessno=' + accessno + '&patno=' + patno + "&status=" + status + '&timestamp=' + new Date().getTime());

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function submitAction(cmd, stp, logno, accessno, status) {
		if (cmd = 'updateStatus') {
			showOverLay('body');
			showLoadingBox('body', 500);
			
			$.ajax({
				type: "POST",
				url: "risAutoMatchLogUpdate.jsp?command="+cmd+"&logno="+logno+"&accessno="+accessno+"&status="+status,
				async: true,
				cache: false,
				dataType: 'text',
				success: function(values){
					hideLoadingBox('body', 500);
					hideOverLay('body');
					
					alert(values.trim());
					submitSearch();
				},//success
				error: function(jqXHR, textStatus, errorThrown) {
					hideLoadingBox('body', 500);
					hideOverLay('body');
					
					alert('Update failed:' + textStatus);
				}
			});//$.ajax
		}
		return false;
	}

	function clearSearch() {
		document.search_form.accessno.value = "";
		document.search_form.patno.value = "";
		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){

			//read and assign the response from the server
			var response = http.responseText;

			//do additional parsing of the response, if needed

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("risAutoMatchLog_list_result").innerHTML = response;

			//If the server returned an error message like a 404 error, that message would be shown within the div tag!!.
			//So it may be worth doing some basic error before setting the contents of the <div>
		}
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>