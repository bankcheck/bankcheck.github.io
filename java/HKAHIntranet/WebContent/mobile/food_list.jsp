<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
	private ArrayList<ReportableListObject> getMenuList() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CODE_NO, C.CODE_VALUE1, C.CODE_VALUE2 ");
		sqlStr.append("FROM AH_SYS_CODE C ");
		sqlStr.append("WHERE C.SYS_ID = 'DIT' ");
		sqlStr.append("AND C.CODE_TYPE = 'MENU_TYPE' ");
		sqlStr.append("AND C.STATUS <> 'X' ");
		sqlStr.append("ORDER BY C.CODE_VALUE1 ");
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> getlist(String menuType, String itemName) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  I.ITEM_CODE, I.ITEM_NAME1, I.ITEM_NAME2 ");
		sqlStr.append("FROM   DIT_MENU_ITEM I ");
		sqlStr.append("WHERE (SYSDATE BETWEEN I.EFFECTIVE_DATE AND NVL(I.EXPIRED_DATE, SYSDATE)) ");
		if(menuType != null && menuType.length()>0){
			sqlStr.append("AND I.MENU_TYPE = '" + menuType + "' ");	
		}
		if(itemName != null && itemName.length()>0){
			sqlStr.append("AND UPPER(I.ITEM_NAME1) LIKE UPPER('%" + itemName + "%') ");	
		}
		sqlStr.append("ORDER BY I.ITEM_NAME1 ");
		System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

String menuType = (request.getParameter("menuType")) == null?"":request.getParameter("menuType");
String itemName = request.getParameter("itemName");

ArrayList list = getlist(menuType, itemName);
request.setAttribute("list", list);



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
	<jsp:param name="pageTitle" value="Food List" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" id="search_form" action="food_list.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Menu Type</td>
		<td class="infoData" width="70%">
			<select name="menuType">
			<option></option>
<%
	ArrayList<ReportableListObject> record = getMenuList();
	ReportableListObject row1 = null;
	if (record.size() > 0) {
		for(int i=0; i < record.size(); i++){
			row1 = (ReportableListObject) record.get(i);
			%><option value="<%=row1.getValue(0) %>" <%=menuType.equals(row1.getValue(0))?" selected":"" %>><%=row1.getValue(1) %>[<%=row1.getValue(2) %>]</option> <%
		}
	}
%>			
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Item Name</td>
		<td class="infoData" width="70%"><input type="text" name="itemName" value="<%=itemName==null?"":itemName %>"/></td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<display:table id="row" name="requestScope.list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column property="fields0" title="Menu Code" style="width:10%"/>
	<display:column property="fields1" title="Menu Display Name (English)" style="width:40%"/>
	<display:column property="fields2" title="Menu Display Name (Chinese)" style="width:40%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('update', '<c:out value="${row.fields0}" />');"><bean:message key="button.update" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="No record"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<script language="javascript">

	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.inParam.value = "";
	}

	function submitAction(cmd, cid) {
		callPopUpWindow("food_detail.jsp?command=" + cmd + "&itmcode=" + cid);
		return false;
	}

</script>

</DIV>
</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>