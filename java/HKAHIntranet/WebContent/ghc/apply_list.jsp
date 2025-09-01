<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String specialtyCode = request.getParameter("specialtyCode");
if (specialtyCode != null) {
	request.setAttribute("apply_list", GHCClientDB.getList(userBean, specialtyCode));
}

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

// set next parties
String[] partySurgery = new String[] { "GHC", "Physician", "HKAH", "GHC" };
String[] partyOthers = new String[] { "GHC", "HKAH", "GHC", "HKAH", "GHC" };
String[] partyCurrent = null;

int stageInt = 0;
String nextParty = null;
String currentParty = null;
String prevParty = null;
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
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.ghc.client.list" />
	<jsp:param name="category" value="group.ghc" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="apply_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.specialty" /></td>
		<td class="infoData" width="80%">
			<select name="specialtyCode">
				<option value=""><bean:message key="label.all" /></option>
<jsp:include page="../ui/specialtyCMB.jsp" flush="false">
	<jsp:param name="specialtyCode" value="<%=specialtyCode %>" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<form name="form1" action="apply.jsp" method="post">
<%	if (specialtyCode != null) { %>
<bean:define id="functionLabel"><bean:message key="function.ghc.client.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.apply_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.name" style="width:15%">
		<c:out value="${row.fields2}" /> <c:out value="${row.fields3}" />
		<logic:notEqual name="row" property="fields4" value="">
			<c:out value="${row.fields4}" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields5" titleKey="prompt.attendingDoctor" style="width:15%" />
	<display:column titleKey="prompt.specialty" style="width:10%">
<%		partyCurrent = partyOthers; %>
		<logic:equal name="row" property="fields6" value="ob">
			<bean:message key="label.ob" />
		</logic:equal>
		<logic:equal name="row" property="fields6" value="surgical">
			<bean:message key="label.surgical" />
<%		partyCurrent = partySurgery; %>
		</logic:equal>
		<logic:equal name="row" property="fields6" value="ha">
			<bean:message key="label.ha" />
		</logic:equal>
		<logic:equal name="row" property="fields6" value="cardiac">
			<bean:message key="label.cardiac" />
		</logic:equal>
	</display:column>
	<display:column title="Step" style="width:15%">
		<logic:equal name="row" property="fields9" value="">
			Waiting for Acknowledgement
		</logic:equal>
		<logic:notEqual name="row" property="fields9" value="">
			<logic:equal name="row" property="fields10" value="">
				Waiting for Approval
			</logic:equal>
			<logic:notEqual name="row" property="fields10" value="">
				Step <c:out value="${row.fields7}" />
<%
				stageInt = -1;
				try { stageInt = Integer.parseInt(((ReportableListObject)pageContext.getAttribute("row")).getFields7()); } catch (Exception e) {}
				try { nextParty = partyCurrent[stageInt]; } catch (Exception e) {}
				try { currentParty = partyCurrent[stageInt - 1]; } catch (Exception e) {}
				try { prevParty = partyCurrent[stageInt - 2]; } catch (Exception e) {}
%>
				Pending in <%=currentParty %>
				<logic:equal name="row" property="fields8" value="reject">
<%			if (nextParty != null) { %>
					(Reject from <%=nextParty %>)
<%			} %>
				</logic:equal>
				<logic:notEqual name="row" property="fields8" value="reject">
<%			if (prevParty != null) { %>
					(Submit from <%=prevParty %>)
<%			} %>
				</logic:notEqual>
			</logic:notEqual>
		</logic:notEqual>
	</display:column>
	<display:column property="fields11" titleKey="prompt.createdDate" style="width:10%" />
	<display:column property="fields12" titleKey="prompt.modifiedDate" style="width:10%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key='button.view' /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} %>
<%	if (userBean.isAccessible("function.ghc.client.create")) { %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.ghc.client.create" /></button></td>
	</tr>
</table>
<%	} %>
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}

	function submitAction(cmd, cid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&clientID=" + cid);
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>