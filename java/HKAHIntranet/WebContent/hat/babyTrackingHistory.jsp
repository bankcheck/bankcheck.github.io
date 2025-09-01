<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.net.MalformedURLException"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> getOBlocation(){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT LISTAGG(BEDCODE,',')WITHIN GROUP (ORDER BY BEDCODE) ");
		sqlStr.append("FROM BED ");
		sqlStr.append("WHERE BEDOFF = '-1' ");
		sqlStr.append("AND BEDCODE LIKE '6%' ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> getBabyHistory(String patno, String locid, Boolean displayAll){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT B.TRACKID, B.PATNO, P.PATFNAME || ' ' || P.PATGNAME, B.BEDCODE, B.ENTRYUSER, S.CO_STAFFNAME, TO_CHAR(B.ENTRYDATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("B.RETURNUSER, R.CO_STAFFNAME, TO_CHAR(B.RETURNDATE, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM BABYTRACKING@IWEB B, PATIENT@IWEB P, CO_STAFFS S ");
		sqlStr.append(", (	SELECT B.TRACKID, B.RETURNUSER, S.CO_STAFFNAME, TO_CHAR(B.RETURNDATE, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("		FROM BABYTRACKING@IWEB B, CO_STAFFS S ");
		sqlStr.append("		WHERE B.RETURNUSER = S.CO_STAFF_ID) R ");
		sqlStr.append("WHERE B.PATNO = P.PATNO ");
		sqlStr.append("AND B.ENTRYUSER = S.CO_STAFF_ID ");
		sqlStr.append("AND B.TRACKID = R.TRACKID (+) ");
		if (patno != null && patno.length()>0 ){ 
			sqlStr.append("AND B.PATNO = '"+patno+"' ");
		}
		if (locid != null && locid.length()>0 ){ 
			sqlStr.append("AND B.BEDCODE LIKE '"+locid+"%' ");
		}
		if (!displayAll){
			sqlStr.append("AND B.RETURNDATE IS NULL ");	
			sqlStr.append("AND B.ENABLED = '1' ");
		}
		sqlStr.append("ORDER BY B.ENTRYDATE DESC ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> getNurseryBaby(){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT PATNO ");
		sqlStr.append("FROM BABYTRACKING@IWEB ");
		sqlStr.append("WHERE ENABLED = '1' ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String obLocid = "";
/*ArrayList<ReportableListObject> record = getOBlocation();
ReportableListObject row = null;
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	obLocid = row.getValue(0);
}*/
obLocid = "608,609A,609B,609C,610A,610B,611,612,613,615,Nursery";

String patno = request.getParameter("patno");
String locid = request.getParameter("locid");
boolean displayAll = "Y".equals(request.getParameter("displayAll"))?true:false;
boolean showNoBaby = false;

ArrayList<ReportableListObject> record = getBabyHistory(patno, locid, displayAll);
int count = record.size();
request.setAttribute("record_list", record);

ArrayList<ReportableListObject> record1 = getNurseryBaby();
int noNurseyBaby = record1.size() - count;
if(("".equals(patno) || patno == null) && ("".equals(locid) || locid == null) && noNurseyBaby >= 0){
	showNoBaby = true;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
	 "http://www.w3.org/TR/html4/frameset.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script type="text/javascript" src="../js/html5-qrcode.min.js"></script>
    <script type="text/javascript"	src="../js/jquery.cookie.js"></script>
	<script type="text/javascript"	src="../js/jquery.dcdrilldown.1.2.min.js"></script>
	<script type="text/javascript"	src="../js/filterlist.js"></script>
	<link rel="stylesheet" type="text/css"	href="../css/w3.hkah.css" />
	<link rel="shortcut icon" href="../images/baby-logos.ico" type="image/x-icon" />
    <title>Baby Tracking History</title>
    <style>
	.selected{
		border: 2px solid red;
	}
	.leftalign{
	text-align: left;
	}
    </style>

</head>

<body>
	<div class="w3-container w3-center ah-pink w3-display-top" onclick="resetData()">
		<span class="w3-xxlarge bold ">Baby Tracking History</span> 
	</div>
	<div class="w3-container">&nbsp;&nbsp;</div>
	<form name="search_form" action="babyTrackingHistory.jsp" method="post">
		<div class="w3-container w3-row">
			<div class="w3-container w3-col s5">
				Patient Number:
				<input class="w3-input w3-round" id="patno" name="patno" type="text" value="<%=patno == null?"":patno %>"/>
			</div>
			<div class="w3-container w3-col s5">
				Location:
				<input class="w3-input w3-round" id="locid" name="locid" type="text" value="<%=locid == null?"":locid %>"/>
			</div>
			<div class="w3-container w3-col s2">
				Display All Record:
				<input class="w3-input " id="displayAll" name="displayAll" type="checkbox" value="Y" <%=displayAll?" checked":"" %> style="left: 20%;"/>
			</div>
			<div class="w3-container">&nbsp;&nbsp;</div>
			<button class="w3-right" id="submitAction" style="width:15%" onclick="submitAction()">Search</button>
		</div>
	</form>	
	<div class="w3-container">&nbsp;&nbsp;</div>
	<div class="w3-container" id="info" <%=showNoBaby?"":"style='display:none;'" %>>No. of Baby in Nursery:<span id="babyNursery"><%=noNurseyBaby %></span></div>

<display:table id="row1" name="requestScope.record_list"  export="false" class="generaltable">
	<display:setProperty name="basic.msg.empty_list" value="" />
	<display:column property="fields1" title="Pat. No" style="width:10%; " headerClass="leftalign"/>
	<display:column property="fields2" title="Pat. Name" style="width:40%; " headerClass="leftalign"/>
	<display:column property="fields3" title="Current Location" style="width:10%; " headerClass="leftalign"/>
	<%if(displayAll){ %>
		<display:column property="fields6" title="Entry Date / Time" style="width:10%; " headerClass="leftalign"/>
		<display:column property="fields5" title="Entry User" style="width:10%; " headerClass="leftalign"/>
		<display:column property="fields9" title="Return Date / Time" style="width:10%; " headerClass="leftalign"/>
		<display:column property="fields8" title="Return User" style="width:10%; " headerClass="leftalign"/>
	<%}else{ %>
		<display:column property="fields6" title="Entry Date / Time" style="width:20%; " headerClass="leftalign"/>
		<display:column property="fields5" title="User" style="width:20%; " headerClass="leftalign"/>
	<%} %>
</display:table>
</body>
<script type="text/javascript">
	function resetData(element){
		$("input").val("");
		$("input[type='checkbox']").attr('checked', false);
	}
	
	function submitAction(){
		document.search_form.submit();
	}

	
</script>
</html:html>