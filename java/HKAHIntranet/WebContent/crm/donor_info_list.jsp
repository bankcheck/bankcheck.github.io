<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%!
public static ArrayList getList(String lastName,String firstName,String chineseName,String organization,
								String phoneNumber,String email) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME,  CRM_CHINESENAME,  ");	
	sqlStr.append("       CRM_ORGANIZATION, ");
	sqlStr.append("       CRM_MOBILE_NUMBER, CRM_OFFICE_NUMBER, CRM_EMAIL, ");	
	sqlStr.append("       CRM_REMARKS, decode(CRM_WILLING_PROMOTION,'Y','Yes','N','No') ");	
	sqlStr.append("FROM   CRM_CLIENTS ");
	sqlStr.append("WHERE  CRM_DONOR = 'Y' ");	
	sqlStr.append("AND    CRM_ENABLED = '1' ");	
	if (lastName != null && lastName.length() > 0) {
		sqlStr.append("AND    UPPER(CRM_LASTNAME) LIKE UPPER('%");
		sqlStr.append(lastName);
		sqlStr.append("%') ");
	}
	if (firstName != null && firstName.length() > 0) {
		sqlStr.append("AND    UPPER(CRM_FIRSTNAME) LIKE UPPER('%");
		sqlStr.append(firstName);
		sqlStr.append("%') ");
	}
	if (chineseName != null && chineseName.length() > 0) {
		sqlStr.append("AND    CRM_CHINESENAME LIKE '%");
		sqlStr.append(chineseName);
		sqlStr.append("%' ");
	}
	if (organization != null && organization.length() > 0) {
		sqlStr.append("AND    UPPER(CRM_ORGANIZATION) LIKE UPPER('%");
		sqlStr.append(organization);
		sqlStr.append("%') ");
	}
	if (phoneNumber != null && phoneNumber.length() > 0) {
		sqlStr.append("AND   (CRM_HOME_NUMBER LIKE '%");
		sqlStr.append(phoneNumber);
		sqlStr.append("%' OR CRM_MOBILE_NUMBER LIKE '%");
		sqlStr.append(phoneNumber);
		sqlStr.append("%' OR CRM_OFFICE_NUMBER LIKE '%");
		sqlStr.append(phoneNumber);
		sqlStr.append("%') ");
	}
	if (email != null && email.length() > 0) {
		sqlStr.append("AND    UPPER(CRM_EMAIL) LIKE UPPER('%");
		sqlStr.append(email);
		sqlStr.append("%') ");
	}
	sqlStr.append(" ORDER BY CRM_LASTNAME, CRM_FIRSTNAME, CRM_CLIENT_ID");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>

<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
boolean selectAction = "select".equals(command);
String lastName = TextUtil.parseStr(request.getParameter("lastName"));
String firstName = TextUtil.parseStr(request.getParameter("firstName"));
String chineseName = TextUtil.parseStrUTF8(request.getParameter("chineseName"));
String organization = TextUtil.parseStrUTF8(request.getParameter("organization"));
String phoneNumber = TextUtil.parseStrUTF8(request.getParameter("phoneNumber"));
String email = TextUtil.parseStrUTF8(request.getParameter("email"));
request.setAttribute("client_list", getList(lastName == null ? lastName : lastName.trim(), firstName == null ? firstName : firstName.trim(), chineseName == null ? chineseName : chineseName.trim(),
									organization,phoneNumber == null ? phoneNumber : phoneNumber.trim(),email));
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>
<div id=contentFrame>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.donor.list" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>

<form name="search_form" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	
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
		<td class="infoLabel" width="15%">Organization</td>
		<td class="infoData" width="35%">
			<input type="textfield" name="organization" value="<%=organization==null?"":organization %>" maxlength="20" size="25">
		</td>
		
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.homePhone" />/<br><bean:message key="prompt.mobilePhone" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="phoneNumber" value="<%=phoneNumber==null?"":phoneNumber %>" maxlength="20" size="25">
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.email" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="email" value="<%=email==null?"":email %>" maxlength="20" size="25">
		</td>
	</tr>
	
	<tr class="smallText">
		<td colspan="4" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
			<button type="reset"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<form name="form1" action="<html:rewrite page="/crm/donor_info.jsp" />" method="post">
<display:table id="row" name="requestScope.client_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Donor ID" style="width:5%"/>
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
	<display:column property="fields4" title="Organization" style="width:10%" />
	<display:column property="fields5" titleKey="prompt.mobilePhone" style="width:10%" />
	<display:column property="fields6" title="Telephone(Office)" style="width:10%" />
	<display:column property="fields7" titleKey="prompt.email" style="width:10%" />
	<display:column property="fields8" title="Remarks" style="width:15%" />
	<display:column property="fields9" title="Accept Promotion" style="width:5%" />
	
	<display:column titleKey="button.view" media="html" style="width:10%; text-align:center">
	<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />','','');">Info</button>
	<% if(!selectAction){%>		
		<!-- <button onclick="return viewInfo('relationship', '<c:out value="${row.fields0}" />');">Relationship</button> -->
		<button onclick="return viewInfo('transaction', '<c:out value="${row.fields0}" />');">Donation</button>
	<%}else{%>
		<button onclick="return submitAction('select', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields2}" />');">Select</button>
	<%}%>
	</display:column>
</display:table>

<table width="100%" border="0">
	<tr class="smallText">
	<% if(!selectAction){%>		
		<td align="center"><button onclick="return submitAction('create', '', '', '');"><bean:message key="function.donor.create" /></button></td>
	<% } %>
	</tr>
</table>
</form>
<script language="javascript">	
	function submitSearch() {
		document.search_form.submit();
		return false;
	}

	function submitAction(cmd, cid,name1,name2) {	
		if (cmd == 'select') {
			self.parent.tb_remove_4_search(cid, name1, name2);
		}else{
			callPopUpWindow(document.form1.action + "?command=" + cmd + "&clientID=" + cid);
		}
		return false;
	}
	
	function viewInfo(cmd, cid) {	
		if(cmd == 'relationship'){
			callPopUpWindow("donor_relative_list.jsp?command=" + cmd + "&clientID=" + cid);
		}else if(cmd == 'transaction'){
			callPopUpWindow("donor_transaction_list.jsp?command=" + cmd + "&clientID=" + cid);
		}
		return false;
	}

	function clearSearch() {		
		document.search_form.lastName.value = "";
		document.search_form.firstName.value = "";
		document.search_form.chineseName.value = "";
		document.search_form.organization.value = "";
		document.search_form.phoneNumber.value = "";
		document.search_form.email.value = "";
		return false;
	}

	
</script>
</div>
</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>