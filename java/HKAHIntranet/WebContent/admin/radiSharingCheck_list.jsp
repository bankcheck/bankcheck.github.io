<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>

<%!
	private ArrayList getList(UserBean userBean,String patNo, String ckRdyUnSent, String dateFrom) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select s.pat_patno, s.accession_no, to_char(s.exam_date,'dd/mm/yyyy'),s.exam_report_desc, ");
		sqlStr.append("Decode(Nvl(Exam_Image_Path,'N'),'N','No','Yes'), decode(NVL(Exam_Report_Path,'N'),'N','No','Yes'), ");
		sqlStr.append(" decode(Msg_Trans_Type,'R','Ready','P','Pending','D','Done'),S.Msg_Trans_Type,to_char(r.CREATED_DATE,'dd/mm/yyyy')  ");
		sqlStr.append(" ,  DECODE(SIGN(ROUND((s.SL_MODIFIED_DATE-r.CREATED_DATE)*24*60)),-1,'N/A',ROUND((s.SL_MODIFIED_DATE-r.CREATED_DATE)*24*60)) ");
		sqlStr.append("from systemlog@");
		if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
			sqlStr.append("HKA");
		}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
			sqlStr.append("TWA");
		}
		sqlStr.append("_RADI s, radi_act_log r ");
		sqlStr.append("where s.accession_no = r.accession_no(+)");
		
		if ("P".equals(ckRdyUnSent) && (patNo!=null && !"".equals(patNo))) {
			sqlStr.append(" AND s.pat_patno='");
			sqlStr.append(patNo);
			sqlStr.append("' ");
		}
		else if ("Y".equals(ckRdyUnSent) && (dateFrom!=null && !"".equals(dateFrom)||(patNo != null && !"".equals(patNo)))) {
			sqlStr.append(" AND r.accession_no is null ");
			sqlStr.append(" AND exam_date >= to_date('");
			sqlStr.append(dateFrom);
			sqlStr.append("','dd/mm/yyyy') ");
			sqlStr.append("and exam_image_path is not null and exam_report_path is not null ");
			sqlStr.append("and sl_status is null ");
			
			if (patNo != null && !"".equals(patNo)) {
				sqlStr.append(" AND s.pat_patno='");
				sqlStr.append(patNo);
				sqlStr.append("' ");
			}
			
		} else if ("D".equals(ckRdyUnSent) && (dateFrom!=null && !"".equals(dateFrom))) {
			sqlStr.append(" And R.Function_Id = 'SEND_CFMCASEANDSEND' ");
			sqlStr.append(" AND to_char(r.CREATED_DATE,'dd/mm/yyyy') = '");
			sqlStr.append(dateFrom);
			sqlStr.append("'");
		
		} else if ("N".equals(ckRdyUnSent) && ((patNo!=null && !"".equals(patNo)))||(dateFrom!=null && !"".equals(dateFrom))) {
			sqlStr.append(" And R.Function_Id = 'SEND_CFMCASEANDSEND' ");
			if (patNo != null && !"".equals(patNo)) {	
				sqlStr.append(" and r.PAT_PATNO ='");
				sqlStr.append(patNo);
				sqlStr.append("' ");
			}
			if (dateFrom!=null && !"".equals(dateFrom)) {
				sqlStr.append(" AND to_char(r.CREATED_DATE,'dd/mm/yyyy') = '");
				sqlStr.append(dateFrom);
				sqlStr.append("'");

			}
		} 
			
		
		sqlStr.append("order by exam_date ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private boolean updatetoReady(String accessionNo,UserBean userBean) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("Update SYSTEMLOG@ ");
		if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
			sqlStr.append("HKA");
		}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
			sqlStr.append("TWA");
		}
		sqlStr.append("_RADI Set Sl_Status = '', ");
		sqlStr.append("Msg_Trans_Type = 'R', ");
		sqlStr.append("Sl_Modified_User = 'SYSTEM' ");
		sqlStr.append("WHERE Accession_No =  ? ");


		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {accessionNo} );
	}

%>

<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String accessionNo = ParserUtil.getParameter(request, "accessionNo");
String patNo = request.getParameter("patNo");
String message = request.getParameter("message");

String ckRdyUnSent = ParserUtil.getParameter(request, "ckRdyUnSent");
if (ckRdyUnSent == null || ckRdyUnSent.length() == 0) {
	ckRdyUnSent = "Y";
}
String dateFrom = request.getParameter("date_from");
if (dateFrom == null || dateFrom.length() == 0) {
	dateFrom = DateTimeUtil.getCurrentDate();
}

if("updateToReady".equals(command) && !"".equals(accessionNo)) {
	if (updatetoReady(accessionNo,userBean)){
		message = accessionNo + "updated to Ready!";
	}
}

request.setAttribute("radiSharingCheck_list", getList(userBean,patNo, ckRdyUnSent, dateFrom));

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
	<jsp:param name="pageTitle" value="RadiSharing Checking List" />
</jsp:include>
<<form name="search_form" action="radiSharingCheck_list.jsp" method="post">
  <table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Patient Number</td>
		<td class="infoData" width="70%">
			<input type="textfield" name="patNo" value="<%=patNo==null?"":patNo %>" maxlength="30" size="50">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">is Ready but not Sent</td>
		<td class="infoData" width="70%">
			<input type="radio" name="ckRdyUnSent" value="Y"<%="Y".equals(ckRdyUnSent)?" checked":"" %>>is Ready but not Sent
			<input type="radio" name="ckRdyUnSent" value="N"<%="N".equals(ckRdyUnSent)?" checked":"" %>>Check Sent
			<input type="radio" name="ckRdyUnSent" value="P"<%="P".equals(ckRdyUnSent)?" checked":"" %>>Check Patient		
			<input type="radio" name="ckRdyUnSent" value="D"<%="D".equals(ckRdyUnSent)?" checked":"" %>>Check Date History			
	</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=dateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			<button id="logOpen">Open RadiSharing Project Page</button>
		</td>
	</tr>	
  </table>
  <table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>

<form name="form1"  action="radiSharingCheck_list.jsp" method="post">
<bean:define id="functionLabel"><bean:message key="function.classEnrollment.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.radiSharingCheck_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column property="fields0" title="Patient Number" style="width:5%"/>
	<display:column property="fields1" title="Accession No" style="width:10%"/>
	<display:column property="fields2" title="Exam Date" style="width:5%"/>
	<display:column property="fields3" title="Exam Description" style="width:10%"/>
	<display:column property="fields4" title="Image Exist?" style="width:5%"/>
	<display:column property="fields5" title="Report Exist?" style="width:5%"/>
	<display:column property="fields6" title="Pending" style="width:5%"/>
	<display:column property="fields8" title="Sent Date" style="width:5%"/>
	<display:column property="fields9" title="Minutes" style="width:5%"/>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<logic:equal name="row" property="fields7" value="P">
			<button onclick="return submitAction('updateToReady', '<c:out value="${row.fields1}" />');">Update to Ready</button>
		</logic:equal>
	</display:column>
</display:table>

<input type="hidden" name="command">
<input type="hidden" name="accessionNo" value="<%=accessionNo %>">
<input type="hidden" name="dateFrom" value="<%=dateFrom %>">
<input type="hidden" name="ckRdyUnSent" value="<%=ckRdyUnSent %>">

</form>
<div id="dialog-message"   title="Send Case"/>

<script language="javascript">

$( "#dialog-message" ).dialog({ autoOpen: false,height: 700, width: 600, position: [300,100]});


$( "#logOpen" ).click(function() {
	$("#dialog-message").draggable({ disabled: true });
	$( "#dialog-message" ).dialog( "open" );
	 $.ajax({
			type: "GET",
			url: "../common/radi2portal.jsp",
			data: "moduleCode=radi",
			async: false,
			success: function(values){
				$( "#dialog-message" ).html(values);
			}
		});//$.ajax
	 return false;
	});
	


function submitSearch() {
	document.search_form.submit();
}

function submitAction(cmd, eid,aid) {
	document.form1.command.value = cmd;
	document.form1.accessionNo.value = eid;
	document.form1.submit();
}


</script>
</DIV></DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>