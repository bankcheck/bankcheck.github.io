<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.crm.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

String command = request.getParameter("command");
String siteCode = request.getParameter("siteCode");
String deptCode = request.getParameter("deptCode");
String pid = request.getParameter("pid");
String lastName = TextUtil.parseStr(request.getParameter("lastName")).toUpperCase();
String firstName = TextUtil.parseStr(request.getParameter("firstName")).toUpperCase();
String chineseName = TextUtil.parseStrUTF8(request.getParameter("chineseName"));
String sex = request.getParameter("sex");
String phoneNumber = TextUtil.parseStrUTF8(request.getParameter("phoneNumber"));
String mobileNumber = TextUtil.parseStrUTF8(request.getParameter("mobileNumber"));
String id = TextUtil.parseStr(request.getParameter("id")).toUpperCase();

String module = request.getParameter("module");
boolean isLMCCRM = false;
if(module != null && module.equals("lmc.crm")){
	isLMCCRM= true;
}

boolean selectAction = "select".equals(command);
//cherry 20100713//
boolean addAction = "add".equals(command);
//cherry 20100713//
// set default value
if (siteCode == null) {
	siteCode = userBean.getSiteCode();
}
if (deptCode == null) {
	deptCode = userBean.getDeptCode();
}
if (lastName != null ) {
	request.setAttribute("client_list", CRMClientDB.getList(siteCode, deptCode, pid, lastName == null ? lastName : lastName.trim().toUpperCase(), firstName == null ? firstName : firstName.trim().toUpperCase(), chineseName == null ? chineseName : chineseName.trim().toUpperCase(), sex,
			phoneNumber == null ? phoneNumber : phoneNumber.trim(), id.trim(),isLMCCRM));
}
String message = TextUtil.parseStr(request.getParameter("message"));
String errorMessage = "";

String realUserID = "";
if(userBean.getLoginID()!=null&&userBean.getLoginID().length()>0){
	realUserID=userBean.getLoginID();
}else{
	realUserID=userBean.getUserName();
}
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>

<DIV id=contentFrame style="width:100%;height:100%">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.client.list" />
	<jsp:param name="category" value="group.crm" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="client_info_list.jsp" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
<%	if (ConstantsServerSide.DEBUG) { %>
	<tr class="smallText">
		<td class="infoLabel" width="15%">PID</td>
		<td class="infoData" width="35%" colspan="3">
			<input type="textfield" name="pid" value="<%=pid==null?"":pid %>" maxlength="10" size="25">
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName %>" maxlength="30" size="25">
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>" maxlength="60" size="25">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="chineseName" value="<%=chineseName==null?"":chineseName %>" maxlength="20" size="25">
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.sex" /></td>
		<td class="infoData" width="35%">
			<input type="radio" name="sex" value="M"<%="M".equals(sex)?" checked":"" %>><bean:message key="label.male" />
			<input type="radio" name="sex" value="F"<%="F".equals(sex)?" checked":"" %>><bean:message key="label.female" />
			<input type="radio" name="sex" value=""<%=!"M".equals(sex)&&!"F".equals(sex)?" checked":"" %>><bean:message key="label.all" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.homePhone" />/<br><bean:message key="prompt.mobilePhone" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="phoneNumber" value="<%=phoneNumber==null?"":phoneNumber %>" maxlength="20" size="25">
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.hkid" />/<br><bean:message key="prompt.passport" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="id" value="<%=id==null?"":id %>" maxlength="20" size="25">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.ownerSite" /></td>
		<td class="infoData" width="35%">
			<input type="radio" name="siteCode" value="" checked><bean:message key="label.all" /><BR>
			<input type="radio" name="siteCode" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>"<%=ConstantsServerSide.SITE_CODE_HKAH.equals(siteCode)?" checked":"" %>><bean:message key="label.hkah" /><BR>
			<input type="radio" name="siteCode" value="<%=ConstantsServerSide.SITE_CODE_TWAH %>"<%=ConstantsServerSide.SITE_CODE_TWAH.equals(siteCode)?" checked":"" %>><bean:message key="label.twah" />
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.ownerDepartment" /></td>
		<td class="infoData" width="35%">
			<input type="radio" name="deptCode" value="" checked><bean:message key="label.all" /><BR>
			<input type="radio" name="deptCode" value="520"<%="520".equals(deptCode)?" checked":"" %>><bean:message key="department.520" /><BR>
			<input type="radio" name="deptCode" value="660"<%="660".equals(deptCode)?" checked":"" %>><bean:message key="department.660" /><BR>
			<input type="radio" name="deptCode" value="670"<%="670".equals(deptCode)?" checked":"" %>><bean:message key="department.670" /><BR>
			<input type="radio" name="deptCode" value="750"<%="750".equals(deptCode)?" checked":"" %>><bean:message key="department.750" />
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="4" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
			<button type="reset"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<input type="hidden" id="module" name="module" value="<%=(isLMCCRM==true)?"lmc.crm":"" %>">		
</form>
<form name="form1" action="client_info.jsp" method="post">
<%if (lastName != null) { %>
<bean:define id="functionLabel"><bean:message key="function.client.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.client_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.name" style="width:10%">
		<logic:equal name="row" property="fields1" value="">
			<c:out value="${row.fields2}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields1" value="">
			<logic:equal name="row" property="fields2" value="">
				<c:out value="${row.fields1}" />
			</logic:equal>
			<logic:notEqual name="row" property="fields2" value="">
				<c:out value="${row.fields1}" />, <c:out value="${row.fields2}" />
			</logic:notEqual>
		</logic:notEqual>
	</display:column>
	<display:column property="fields3" titleKey="prompt.chineseName" style="width:10%" />
	<display:column property="fields4" titleKey="prompt.hkid" style="width:10%" />
	<display:column titleKey="prompt.street" style="width:15%">
		<c:out value="${row.fields5}" /> <c:out value="${row.fields6}" /> <c:out value="${row.fields7}" /> <c:out value="${row.fields8}" />
	</display:column>
	<display:column property="fields9" titleKey="prompt.mobilePhone" style="width:10%" />
	<display:column property="fields12" titleKey="prompt.email" style="width:10%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
	<% if (addAction){ %>
		<button onclick="return returnclient('<c:out value="${row.fields0}" />');"> Add</button>
<%} else { %>
	<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />','','');"><bean:message key="button.view" /></button>
<%	}if (selectAction) { %>
		<button onclick="return submitAction('select', '<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />','<c:out value="${row.fields2}" />');"><bean:message key="button.select" /></button>
<%	} %>
	<%if(isLMCCRM) { %>
		<logic:empty name="row" property="fields14">
				<button onclick="return submitAction('loginID','<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />','<c:out value="${row.fields2}" />','<c:out value="${row.fields12}" />')">Create Login ID</button>
		</logic:empty>
		<logic:notEmpty name="row" property="fields14">
				<button onclick="return changeLoginID('login','<c:out value="${row.fields14}" />','<%=realUserID%>')">Login</button>
		</logic:notEmpty>
	<%} %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%} %>
<%if (!selectAction) { %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '', '', '');"><bean:message key="function.client.create" /></button></td>
	</tr>
</table>
<%} %>
		
<input type="hidden" id="module" name="module" value="<%=(isLMCCRM==true)?"lmc.crm":"" %>">			
</form>

<form target="_blank" name="changeLoginIDForm" action="portal/index.jsp" method="post">
<input type="hidden" name="command"/>
<input type="hidden" name="clientID"/>
<input type="hidden" name="realUserID"/>
</form>

<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function changeLoginID(cmd,cid,rid){		
		if( cid.length === 0 ) {
			alert('Unable to login without Login ID.');
		}else{
			document.changeLoginIDForm.command.value = cmd;
			document.changeLoginIDForm.clientID.value = cid;
			document.changeLoginIDForm.realUserID.value = rid;
			document.changeLoginIDForm.submit();
		}
		return false;
	}
	
function returnclient(client){
 window.opener.document.getElementById("clientSelect").value = client;
 return false;
}
	function clearSearch() {
		document.search_form.lastName.value = "";
		document.search_form.firstName.value = "";
		document.search_form.chineseName.value = "";
		document.search_form.phoneNumber.value = "";
		document.search_form.id.value = "";
		return false;
	}

	function submitAction(cmd, cid, name1, name2,email) {
		if (cmd == 'select') {
			self.parent.tb_remove_4_search(cid, name1, name2);
		}else if(cmd == 'loginID'){
			
			callPopUpWindow("../crm/portal/user.jsp" + "?command=create" + "&lastName=" +name1+ "&firstName=" +name2
					+ "&email=" +email + "&clientID=" + cid);
			
		}else {
			callPopUpWindow(document.form1.action + "?command=" + cmd + "&clientID=" + cid +
					
				"&lastName=" + document.search_form.lastName.value +
				"&firstName=" + document.search_form.firstName.value +
				"&mobileNumber=" + document.search_form.phoneNumber.value +
				"&hkid=" + document.search_form.id.value	+
				"&module=" + $("#module").val()	
			);
		}
		return false;
	}
</script>

</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>