<%
String command = "create";
String ls_recipt = null;
String ls_rmkPbo = null;
String ls_rmkNrs = null;
String ls_flwUpStatus = null;
String ls_flwUpDate_dmy = null;
String ls_flwUpDate_ymd = null;
String ls_cbSucess = null;
String ls_cfmApptDate_ymd = null;
String ls_cfmApptDate_dmy = null;
String ls_uptDate = null;

boolean createAction = false;
boolean updateAction = false;

command = request.getParameter("as_command");
ls_recipt = request.getParameter("ls_patName");
ls_cbSucess = request.getParameter("as_cbSucess");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	ls_recipt = request.getParameter("as_recipt");
	ls_rmkPbo = request.getParameter("as_rmkPbo");
	ls_rmkNrs = request.getParameter("as_rmkNrs");
	ls_flwUpStatus = request.getParameter("as_flwUpStatus");
	ls_flwUpDate_ymd = request.getParameter("as_flwUpDate");
	if (ls_flwUpDate_ymd != null && ls_flwUpDate_ymd.length()>0 ) {
		ls_flwUpDate_dmy = ls_flwUpDate_ymd.substring(8,10) + "/" + ls_flwUpDate_ymd.substring(5,7) + "/" + ls_flwUpDate_ymd.substring(0,4);
	} else {
		ls_flwUpDate_dmy = "";
	}


	ls_cfmApptDate_ymd = request.getParameter("as_cfmApptDate");
	if (ls_cfmApptDate_ymd != null && ls_cfmApptDate_ymd.length()>0 ) {
		ls_cfmApptDate_dmy = ls_cfmApptDate_ymd.substring(8,10) + "/" + ls_cfmApptDate_ymd.substring(5,7) + "/" + ls_cfmApptDate_ymd.substring(0,4);
	} else {
		ls_cfmApptDate_dmy = "";
	}
	ls_uptDate = request.getParameter("as_updateDate");

	updateAction = true;
}
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
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.patientName" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="recipt" value="<%=ls_recipt==null?"":ls_recipt %>" maxlength="145" size="100">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.rmkPbo" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="rmkPbo" value="<%=ls_rmkPbo==null?"":ls_rmkPbo %>" maxlength="145" size="100">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.rmkNrs" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="rmkNrs" value="<%=ls_rmkNrs==null?"":ls_rmkNrs %>" maxlength="145" size="100">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.followUpStatus" /></td>
		<td class="infoData2" width="30%">
			<select name="flwUpStatus">
				<option value="">
				<option value="0"<%="0".equals(ls_flwUpStatus)?" selected":""%>>Completed</option>
				<option value="1"<%="1".equals(ls_flwUpStatus)?" selected":""%>>Follow up by PBO</option>
				<option value="2"<%="2".equals(ls_flwUpStatus)?" selected":""%>>Follow up by nurse</option>

			</select>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.followUpDate" /></td>
		<td class="infoData2" width="30%" valign="top">
			<input type="textfield" name="flwUpDate" id="flwUpDate" value="<%=ls_flwUpDate_dmy==null?"":ls_flwUpDate_dmy %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"> </br>(DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.cbSuccess" /></td>
		<td class="infoData2" width="30%" valign="top">
			<select name="cbSucess">
				<option value="">
				<option value="3"<%="3".equals(ls_cbSucess)?" selected":""%>>Previous Booked</option>
				<option value="1"<%="1".equals(ls_cbSucess)?" selected":""%>>Success</option>
				<option value="2"<%="2".equals(ls_cbSucess)?" selected":""%>>Not Success</option>
			</select>
		</td>
		<td class="infoLabel" width="20%">Appointment Confirmed Date</td>
		<td class="infoData2" width="30%" valign="top">
			<input type="textfield" name="cfmApptDate" id="cfmApptDate" value="<%=ls_cfmApptDate_dmy==null?"":ls_cfmApptDate_dmy %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"> </br>(DD/MM/YYYY)
		</td>
	</tr>
	<tr class="largeText">
		<td width="100%" align="center" colspan=4>
<%	if (createAction) { %>
			<button onclick="return submitAction('create');" class="btn-click"> <bean:message key="button.add" /> </button>
<%	} else if (updateAction) { %>
			<button onclick="return submitAction('update');" class="btn-click"> <bean:message key="button.save" /> </button>
			<button onclick="return submitAction('view');" class="btn-click">Clear</button>
<%  } else { %>
			<button onclick="return submitAction('create');" class="btn-click"> <bean:message key="button.add" /> </button>
<%	} %>
		</td>
	</tr>
</table>
<input type="hidden" name="uptDate" value="<%=ls_uptDate %>" />