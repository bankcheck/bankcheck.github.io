<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getSlipDetail(String startDate, String endDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select typedesc, refcode, procdesc, slpno, patno, doccode ");
		sqlStr.append("from   ( ");
		sqlStr.append("	select t.typedesc, c.refcode, p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	from   fin_proc@IWEB p, fin_code@IWEB c, fin_type@IWEB t, sliptx@IWEB st, slip@IWEB s ");
		sqlStr.append("	where  c.proccode = p.proccode ");
		sqlStr.append("	and    p.typecode = t.typecode ");
		sqlStr.append("	and    p.procdesc not like '%ackage%' ");
		sqlStr.append("	and    c.refcode = st.itmcode ");
		sqlStr.append("	and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	and    st.slpno in ( ");
		sqlStr.append("	  select s.slpno ");
		sqlStr.append("	  from   slip@IWEB s, sliptx@IWEB st, fin_est_hosp@IWEB fe ");
		sqlStr.append("	  where  s.slpno = st.slpno ");
		sqlStr.append("	  and    s.slpno = fe.slpno ");
		sqlStr.append("	  and   (s.slpremark like '%*BE%' or s.slpremark like '%* BE%' or fe.osb_be = -1) ");
		sqlStr.append("	  and    s.slpno >= TO_CHAR(TO_DATE('");
		sqlStr.append(startDate);
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '0000' ");
		sqlStr.append("	  and    s.slpno <= TO_CHAR(TO_DATE('");
		sqlStr.append(endDate );
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '9999' ");
		sqlStr.append("	  and    st.itmcode in (select refcode from fin_code@IWEB) ");
		sqlStr.append("	  and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	  group by s.slpno ");
		sqlStr.append("	  having count(1) = 1 ");
		sqlStr.append("	) ");
		sqlStr.append("	and    st.slpno = s.slpno ");
		sqlStr.append("	group by t.typedesc, c.refcode, p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	union ");
		sqlStr.append("	select t.typedesc, c.refcode, p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	from   fin_proc@IWEB p, fin_code@IWEB c, fin_type@IWEB t, sliptx@IWEB st, slip@IWEB s ");
		sqlStr.append("	where  c.proccode = p.proccode ");
		sqlStr.append("	and    p.typecode = t.typecode ");
		sqlStr.append("	and    p.procdesc not like '%ackage%' ");
		sqlStr.append("	and    c.refcode = st.pkgcode ");
		// special handle for ob package code
		sqlStr.append("	and    c.refcode in ('PON3', 'PON4', 'POCP5', 'POCP5LO', 'POCEELN') ");
		sqlStr.append("	and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	and    st.slpno in ( ");
		sqlStr.append("	  select s.slpno ");
		sqlStr.append("	  from   slip@IWEB s, sliptx@IWEB st, fin_est_hosp@IWEB fe ");
		sqlStr.append("	  where  s.slpno = st.slpno ");
		sqlStr.append("	  and    s.slpno = fe.slpno ");
		sqlStr.append("	  and   (s.slpremark like '%*BE%' or s.slpremark like '%* BE%' or fe.osb_be = -1) ");
		sqlStr.append("	  and    s.slpno >= TO_CHAR(TO_DATE('");
		sqlStr.append(startDate);
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '0000' ");
		sqlStr.append("	  and    s.slpno <= TO_CHAR(TO_DATE('");
		sqlStr.append(endDate );
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '9999' ");
		sqlStr.append("	  and    st.pkgcode in (select refcode from fin_code@IWEB) ");
		sqlStr.append("	  and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	  group by s.slpno ");
		sqlStr.append("	) ");
		sqlStr.append("	and    st.slpno = s.slpno ");
		sqlStr.append("	group by t.typedesc, c.refcode, p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	union ");
		sqlStr.append("	select t.typedesc, 'E0001E0004' refcode, p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	from   fin_proc@IWEB p, fin_code@IWEB c, fin_type@IWEB t, sliptx@IWEB st, slip@IWEB s ");
		sqlStr.append("	where  c.proccode = p.proccode ");
		sqlStr.append("	and    p.typecode = t.typecode ");
		sqlStr.append("	and    p.procdesc not like '%ackage%' ");
		sqlStr.append("	and    c.refcode = st.itmcode ");
		sqlStr.append("	and    st.itmcode in ('E0001') ");
		sqlStr.append("	and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	and    st.slpno in ( ");
		sqlStr.append("	  select s.slpno ");
		sqlStr.append("	  from   slip@IWEB s, sliptx@IWEB st, fin_est_hosp@IWEB fe ");
		sqlStr.append("	  where  s.slpno = st.slpno ");
		sqlStr.append("	  and    s.slpno = fe.slpno ");
		sqlStr.append("	  and   (s.slpremark like '%*BE%' or s.slpremark like '%* BE%' or fe.osb_be = -1) ");
		sqlStr.append("	  and    s.slpno >= TO_CHAR(TO_DATE('");
		sqlStr.append(startDate);
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '0000' ");
		sqlStr.append("	  and    s.slpno <= TO_CHAR(TO_DATE('");
		sqlStr.append(endDate );
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '9999' ");
		sqlStr.append("	  and    st.ITMCODE in (select refcode from fin_code@IWEB) ");
		sqlStr.append("	  and    st.itmcode in ('E0001', 'E0004') ");
		sqlStr.append("	  and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	  group by s.slpno ");
		sqlStr.append("	  having count(1) = 2 ");
		sqlStr.append("	) ");
		sqlStr.append("	and    st.slpno = s.slpno ");
		sqlStr.append("	group by t.typedesc, p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	union ");
		sqlStr.append("	select t.typedesc, 'E0001E0007', p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	from   fin_proc@IWEB p, fin_code@IWEB c, fin_type@IWEB t, sliptx@IWEB st, slip@IWEB s ");
		sqlStr.append("	where  c.proccode = p.proccode ");
		sqlStr.append("	and    p.typecode = t.typecode ");
		sqlStr.append("	and    p.procdesc not like '%ackage%' ");
		sqlStr.append("	and    c.refcode = st.itmcode ");
		sqlStr.append("	and    st.itmcode in ('E0001') ");
		sqlStr.append("	and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	and    st.slpno in ( ");
		sqlStr.append("	  select s.slpno ");
		sqlStr.append("	  from   slip@IWEB s, sliptx@IWEB st, fin_est_hosp@IWEB fe ");
		sqlStr.append("	  where  s.slpno = st.slpno ");
		sqlStr.append("	  and    s.slpno = fe.slpno ");
		sqlStr.append("	  and   (s.slpremark like '%*BE%' or s.slpremark like '%* BE%' or fe.osb_be = -1) ");
		sqlStr.append("	  and    s.slpno >= TO_CHAR(TO_DATE('");
		sqlStr.append(startDate);
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '0000' ");
		sqlStr.append("	  and    s.slpno <= TO_CHAR(TO_DATE('");
		sqlStr.append(endDate );
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '9999' ");
		sqlStr.append("	  and    st.ITMCODE in (select refcode from fin_code@IWEB) ");
		sqlStr.append("	  and    st.itmcode in ('E0001', 'E0007') ");
		sqlStr.append("	  and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	  group by s.slpno ");
		sqlStr.append("	  having count(1) = 2 ");
		sqlStr.append("	) ");
		sqlStr.append("	and    st.slpno = s.slpno ");
		sqlStr.append("	group by t.typedesc, p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	union ");
		sqlStr.append("	select t.typedesc, 'E0004E0007', p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	from   fin_proc@IWEB p, fin_code@IWEB c, fin_type@IWEB t, sliptx@IWEB st, slip@IWEB s ");
		sqlStr.append("	where  c.proccode = p.proccode ");
		sqlStr.append("	and    p.typecode = t.typecode ");
		sqlStr.append("	and    p.procdesc not like '%ackage%' ");
		sqlStr.append("	and    c.refcode = st.itmcode ");
		sqlStr.append("	and    st.itmcode in ('E0004') ");
		sqlStr.append("	and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	and    st.slpno in ( ");
		sqlStr.append("	  select s.slpno ");
		sqlStr.append("	  from   slip@IWEB s, sliptx@IWEB st, fin_est_hosp@IWEB fe ");
		sqlStr.append("	  where  s.slpno = st.slpno ");
		sqlStr.append("	  and    s.slpno = fe.slpno ");
		sqlStr.append("	  and   (s.slpremark like '%*BE%' or s.slpremark like '%* BE%' or fe.osb_be = -1) ");
		sqlStr.append("	  and    s.slpno >= TO_CHAR(TO_DATE('");
		sqlStr.append(startDate);
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '0000' ");
		sqlStr.append("	  and    s.slpno <= TO_CHAR(TO_DATE('");
		sqlStr.append(endDate );
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '9999' ");
		sqlStr.append("	  and    st.ITMCODE in (select refcode from fin_code@IWEB) ");
		sqlStr.append("	  and    st.itmcode in ('E0004', 'E0007') ");
		sqlStr.append("	  and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	  group by s.slpno ");
		sqlStr.append("	  having count(1) = 2 ");
		sqlStr.append("	) ");
		sqlStr.append("	and    st.slpno = s.slpno ");
		sqlStr.append("	group by t.typedesc, p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	union ");
		sqlStr.append("	select t.typedesc, 'E0001E0004E0007', p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append("	from   fin_proc@IWEB p, fin_code@IWEB c, fin_type@IWEB t, sliptx@IWEB st, slip@IWEB s ");
		sqlStr.append("	where  c.proccode = p.proccode ");
		sqlStr.append("	and    p.typecode = t.typecode ");
		sqlStr.append("	and    p.procdesc not like '%ackage%' ");
		sqlStr.append("	and    c.refcode = st.itmcode ");
		sqlStr.append("	and    st.itmcode in ('E0001') ");
		sqlStr.append("	and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	and    st.slpno in ( ");
		sqlStr.append("	  select s.slpno ");
		sqlStr.append("	  from   slip@IWEB s, sliptx@IWEB st, fin_est_hosp@IWEB fe ");
		sqlStr.append("	  where  s.slpno = st.slpno ");
		sqlStr.append("	  and    s.slpno = fe.slpno ");
		sqlStr.append("	  and   (s.slpremark like '%*BE%' or s.slpremark like '%* BE%' or fe.osb_be = -1) ");
		sqlStr.append("	  and    s.slpno >= TO_CHAR(TO_DATE('");
		sqlStr.append(startDate);
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '0000' ");
		sqlStr.append("	  and    s.slpno <= TO_CHAR(TO_DATE('");
		sqlStr.append(endDate );
		sqlStr.append("', 'DD/MM/YYYY'), 'YYYYDDD') || '9999' ");
		sqlStr.append("	  and    st.ITMCODE in (select refcode from fin_code@IWEB) ");
		sqlStr.append("	  and    st.itmcode in ('E0001', 'E0004', 'E0007') ");
		sqlStr.append("	  and    st.stnsts in ('A', 'N') ");
		sqlStr.append("	  group by s.slpno ");
		sqlStr.append("	  having count(1) = 3 ");
		sqlStr.append("	) ");
		sqlStr.append("	and    st.slpno = s.slpno ");
		sqlStr.append("	group by t.typedesc, p.procdesc, st.slpno, s.patno, s.doccode ");
		sqlStr.append(") ");
		sqlStr.append("order by typedesc, refcode, procdesc, slpno, patno, doccode ");

System.out.println(sqlStr);
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);

String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");

if (startDate != null && endDate != null) {
	request.setAttribute("pharmacyTicket_list", getSlipDetail(startDate, endDate));
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
<%@ page language="java" contentType="text/html; charset=big5" %>
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
	<jsp:param name="pageTitle" value="function.financialEstimation.statistic" />
	<jsp:param name="displayTitle" value="Budget Estimation Statistic" />
	<jsp:param name="category" value="Report" />
</jsp:include>
<form name="search_form" action="financial_estimation_statistic.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Search Date Range</td>
		<td class="infoData" width="70%">
			<input type="text" name="startDate" id="startDate" class="datepickerfield" value="<%=startDate == null ? "" : startDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> to
			<input type="text" name="endDate" id="endDate" class="datepickerfield" value="<%=endDate == null ? "" : endDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
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
<% if (startDate != null && endDate != null) { %>
<bean:define id="functionLabel">Financial Estimation Statistic</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Type" style="width:10%" />
	<display:column property="fields1" title="Ref Code" style="width:20%" />
	<display:column property="fields2" title="Procedure Code" style="width:25%" />
	<display:column property="fields3" title="Slip No." style="width:15%" />
	<display:column property="fields4" title="Pat No." style="width:15%" />
	<display:column property="fields5" title="DocCode" style="width:15%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<% } %>
</DIV>

</DIV></DIV>

<script language="javascript">
<!--
	function submitSearch() {
		showLoadingBox('body', 500, $(window).scrollTop());
		document.search_form.submit();
		return true;
	}

	function clearSearch() {
		document.search_form.startDate.value = "";
		document.search_form.endDate.value = "";
		return false;
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>