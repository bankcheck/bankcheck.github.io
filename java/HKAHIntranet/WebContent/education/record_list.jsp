<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
String[] current_year = DateTimeUtil.getCurrentYearRange();
String date_from = request.getParameter("date_from");
if (date_from == null || date_from.length() == 0) {
	date_from = DateTimeUtil.getRollDate(current_year[0], 0, 0, 0);
}
String date_to = request.getParameter("date_to");
if (date_to == null || date_to.length() == 0) {
	date_to = current_year[1];
}
String[] current_month = DateTimeUtil.getCurrentMonthRange();
String curent_date = DateTimeUtil.getCurrentDate();

String exemptStaffID = request.getParameter("exemptStaffID");
String exemptCourseID = request.getParameter("exemptCourseID");
String command = request.getParameter("command");
String deptCode = request.getParameter("deptCode");
String staffID = request.getParameter("staffID");
String financialYear_yy = request.getParameter("financialYear_yy");
if (deptCode == null || "".equals(deptCode)) {
	deptCode = userBean.getDeptCode();
}
String allowAll = userBean.isSuperManager() || userBean.isEducationManager() ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
String passdate = DateTimeUtil.getCurrentDateTime().toString();

if ("exempt".equals(command)) {
	String enrollID = EnrollmentDB.add(userBean, "education", exemptCourseID, null, "staff", exemptStaffID, DateTimeUtil.getCurrentDateTime(),"Exemption",DateTimeUtil.getCurrentDateTime());
	if("6238".equals(exemptCourseID)||"6730".equals(exemptCourseID)){
		passdate = passdate.split(" ")[0];
		passdate = passdate.split("/")[0] + "/" + passdate.split("/")[1] + "/" +Integer.toString(Integer.parseInt(passdate.split("/")[2])+2);
	}

	Boolean tet = EnrollmentDB.passTest(userBean, "education", exemptCourseID, null, enrollID, passdate);
} else if ("delete".equals(command)) {
	Boolean cancelExemption = EnrollmentDB.deleteExemption(userBean,exemptStaffID,"education",exemptCourseID,"",date_from,date_to);
} else if ("deleteClass".equals(command)) {
	Boolean cancelExemption = EnrollmentDB.deleteClass(userBean,exemptStaffID,"education",exemptCourseID,"",date_from,date_to);
}

String courseList = request.getParameter("courseList");
if (courseList == null) {
	courseList = "all";
}

boolean isAll = "all".equals(courseList);
boolean isInservice = "inservice".equals(courseList);
boolean isOptional = "other".equals(courseList);
boolean isCNE = "CNE".equals(courseList);
boolean isMockCode = "mockCode".equals(courseList);
boolean isMockDrill = "mockDrill".equals(courseList);
boolean istND = "tND".equals(courseList);
boolean isJCI = "JCI".equals(courseList);

String recordName = request.getParameter("recordName");
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.educationRecord.list" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<form name="search_form" action="record_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
			<select name="deptCode">
<!-- Only Maggie can view all employees record -->
<%
if(userBean.isAccessible("function.staffEducation.view.all.dept") && !userBean.isAdmin()){ %>
				<option value="all"<%="all".equals(deptCode)?" selected":"" %>>--- All Department ---</option>
<% } %>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr id='recordNameRow' style="display:none" class="smallText">
		<td class="infoLabel" width="30%">Record Name</td>
		<td class="infoData" width="70%">
			<input name="recordName" type="textfield"  maxlength="30" size="30"
									 value="<%=(recordName==null)?"":TextUtil.parseStrUTF8(java.net.URLDecoder.decode(recordName)) %>"/>
		</td>
	</tr>
	<% if(userBean.isAdmin() || userBean.isGroupID("managerEducation")){ %>
		<tr class="smallText">
			<td class="infoLabel" width="30%">Emp No.</td>
			<td class="infoData" width="70%">
				<input name="staffID" type="textfield"  maxlength="30" size="30" value="<%=staffID == null?"":staffID %>"/>
			</td>
		</tr>
	<%} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Search Type</td>
		<td class="infoData" width="70%">
			<input type="radio" name="searchType" value="dateRange" onclick="javascript:setSearchType(1);" checked>Search by Date Range<br/>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Search by Date Range</td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfieldOverride" value="<%=date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			<input type="textfield" name="date_to" id="date_to" class="datepickerfieldOverride" value="<%=date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br>
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(1);"><bean:message key="label.today" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(2);"><bean:message key="label.thisMonth" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(3);" checked><bean:message key="label.thisYear" />
		</td>
	</tr>
	<tr class="smallText" style="display:none" >
		<td class="infoLabel" width="30%">Search by Financial Year</td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="financialYear" />
	<jsp:param name="isYearOnly" value="Y" />
</jsp:include>
		</td>
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="30%">Search by Active/Inactive Staff</td>
		<td class="infoData" width="70%">
			<input type="radio" name="coEnable" value="1" checked>Active Record<br/>
			<input type="radio" name="coEnable" value="0" >Inactive Record<br/>
		</td>
	</tr>

	<tr id="courseListRow" style="display:none" class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseCategory" /></td>
		<td class="infoData" width="70%">
			<input type="radio" name="courseList" value="all"<%=isAll?" checked":"" %>><label id="allLabel">All</label>
			<input type="radio" name="courseList" value="inservice"<%=isInservice?" checked":"" %>><bean:message key="label.inservice" />
			<input type="radio" name="courseList" value="other"<%=isOptional?" checked":"" %>><bean:message key="label.optional" />
			<input type="radio" name="courseList" value="CNE"<%=isCNE?" checked":"" %>><label id="CNELabel" style="font-size:10px"width="5%">CNE</label>
			<input type="radio" name="courseList" value="mockCode"<%=isMockCode?" checked":"" %>><label id="mockCodeLabel" style="font-size:10px"width="5%">Mock Code</label>
			<input type="radio" name="courseList" value="mockDrill"<%=isMockDrill?" checked":"" %>><label id="mockDrillLabel" style="font-size:10px"width="5%">Drill</label>
			<input type="radio" name="courseList" value="tND"<%=istND?" checked":"" %>><label id="tNDLabel" style="font-size:10px"width="5%">T&D</label>
			<input type="radio" name="courseList" value="CJI"<%=isJCI?" checked":"" %>><label id="JCILabel" style="font-size:10px"width="5%">JCI</label>
		</td>
	</tr>

	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<%	if (ConstantsServerSide.isHKAH()) { %>
<font color="red">*</font>Please refer to <a href="../documentManage/download.jsp?documentID=53" class="topstoryblue">Other Education Records</a> for sit-in classes records.
<%	} %>
<table width="100%">
	<tr>
		<td>
			<ul id="tabList">
			<li><a href="javascript:submitAction('compulsory');" tabId="tab1" id="tab1" class="linkUnSelected"><span><bean:message key="label.compulsory" /></span></a></li>
			<li><a href="javascript:submitAction('inservice');" tabId="tab2" id="tab2" class="linkUnSelected"><span><bean:message key="label.inservice" /></span></a></li>
			<li><a href="javascript:submitAction('CNE');" tabId="tab3" id="tab3" class="linkUnSelected"><span>CNE/ CME</span></a></li>
			<li><a href="javascript:submitAction('mockCode');" tabId="tab4" id="tab4" class="linkUnSelected"><span><%=(ConstantsServerSide.isTWAH()?"Code Blue Drill" : "Mock Code") %></span></a></li>
			<li><a href="javascript:submitAction('mockDrill');" tabId="tab5" id="tab5" class="linkUnSelected"><span><%=(ConstantsServerSide.isTWAH()?"Other Drill" : "Drill") %></span></a></li>

<%	if (ConstantsServerSide.isHKAH()) { %>
			<li><a href="javascript:submitAction('other');" tabId="tab6" id="tab6" class="linkUnSelected"><span>Other Education Records</span></a></li>
			<li><a href="javascript:submitAction('tND');" tabId="tab7" id="tab7" class="linkUnSelected"><span>T&D</span></a></li>
<% } %>
			<li><a href="javascript:submitAction('JCI');" tabId="tab8" id="tab8" class="linkUnSelected"><span>JCI</span></a></li>
			<!--li><a href="javascript:submitAction('ce');" tabId="tab5" id="tab5" class="linkUnSelected"><span><bean:message key="label.continuousEducation" /></span></a></li-->
			</ul>
		</td>
	</tr>
</table>
<input type="hidden" name="courseCategory" value="">
<input type="hidden" name="exemptStaffID" value="">
<input type="hidden" name="exemptCourseID" value="">
<input type="hidden" name="command" value="">
<input type="hidden" name="eventID" value="">
</form>
<span id="record_list_result" />
<script language="javascript">

	function submitSearch() {
		var radioLength = document.search_form.searchType.length;
		var searchType;
		var searchEnable;
		for (var i = 0; i < document.search_form.coEnable.length;i++) {
			if (document.search_form.coEnable[i].checked) {
				searchEnable = document.search_form.coEnable[i].value;
			}
		}

		for (var i = 0; i < radioLength; i++) {
			if (document.search_form.searchType[i].checked) {
				searchType = document.search_form.searchType[i].value;
			}
		}

		if (searchType == 'dateRange') {
			if (document.search_form.date_from.value == "") {
				alert("<bean:message key="error.date.required" />.");
				document.search_form.date_from.focus();
				return false;
			}
			if (document.search_form.date_to.value == "") {
				alert("<bean:message key="error.date.required" />.");
				document.search_form.date_to.focus();
				return false;
			}
		}

		var deptCode, date_from, date_to, financialYear_yy, courseCategory, eventID, staffID;
		var deptCode = document.search_form.deptCode.options[document.search_form.deptCode.selectedIndex].value;
	<% if(userBean.isAdmin() || userBean.isGroupID("managerEducation")){ %>
		staffID = document.search_form.staffID.value;
		if(staffID != '') deptCode = "all";
	<%}else{ %>
		staffID = '';
	<%}%>
		date_from = document.search_form.date_from.value;
		date_to = document.search_form.date_to.value;
		date_to = document.search_form.date_to.value;
		financialYear_yy = document.search_form.financialYear_yy.value;
		courseCategory = document.search_form.courseCategory.value;
		eventID = document.search_form.eventID.value;

		if (courseCategory == '') {
			// set default value
			courseCategory = 'compulsory';
			document.getElementById('tab1').className = 'linkSelected';
		}

		var courseList = $('input[name=courseList]:checked').val();
		var recordName = $('input[name=recordName]').val();

		//show loading image
		document.getElementById("record_list_result").innerHTML = '<img src="../images/wait30trans.gif">';

		var tempURL;
<%	if (ConstantsServerSide.isHKAH()) { %>
		if (courseCategory == 'inservice' || courseCategory == 'CNE'|| courseCategory == 'mockCode'|| courseCategory == 'mockDrill') {
			tempURL = 'inservice_record_list_result.jsp';
		} else {
			tempURL = 'record_list_result.jsp';
		}
<%	} else { %>
		if (courseCategory == 'mockCode'|| courseCategory == 'mockDrill') {
			tempURL = 'inservice_record_list_result.jsp';
		} else {
			tempURL = 'record_list_result.jsp';
		}
<%  } %>

		$.ajax({
			type: "POST",
			url: tempURL,
			data: "searchType=" + searchType + "&date_from=" + date_from + "&date_to=" + date_to + "&financialYear=" + financialYear_yy + "&searchEnable=" + searchEnable + "&deptCode=" + deptCode + "&eventID=" + eventID + "&courseCategory=" + courseCategory + "&courseList=" + courseList  + "&recordName=" + recordName + "&staffID=" + staffID,
			success: function(values) {
			if (values != '') {
				document.getElementById("record_list_result").innerHTML = values;
			}//if
			},//success
			timeout: 60000
		});//$.ajax

		return false;
	}

	function setDateRange(select) {
		if (select == 1) {
			document.search_form.date_from.value = '<%=curent_date %>';
			document.search_form.date_to.value = '<%=curent_date %>';
		} else if (select == 2) {
			document.search_form.date_from.value = '<%=current_month[0] %>';
			document.search_form.date_to.value = '<%=current_month[1] %>';
		} else if (select == 3) {
			document.search_form.date_from.value = '<%=current_year[0] %>';
			document.search_form.date_to.value = '<%=current_year[1] %>';
		}
	}

	function exemption(courseID,staffID) {
		document.search_form.exemptStaffID.value = staffID;
		document.search_form.exemptCourseID.value = courseID;
		document.search_form.command.value = "exempt";
		document.search_form.submit();
	}


	function cancelClass(courseID,staffID) {
		document.search_form.exemptStaffID.value = staffID;
		document.search_form.exemptCourseID.value = courseID;
		document.search_form.command.value = "deleteClass";
		document.search_form.submit();
	}

	function cancelExemption(courseID,staffID) {
		document.search_form.exemptStaffID.value = staffID;
		document.search_form.exemptCourseID.value = courseID;
		document.search_form.command.value = "delete";
		document.search_form.submit();
	}

	function setSearchType(select) {
		if (select == 1) {
			document.getElementById("date_from").disabled = false;
			document.getElementById("date_to").disabled = false;
			document.getElementById("financialYear_yy").disabled = true;
		} else if (select == 2) {
			document.getElementById("date_from").disabled = true;
			document.getElementById("date_to").disabled = false;
			document.getElementById("financialYear_yy").disabled = false;
		}
	}

	function clearSearch() {
		document.search_form.staffID.value = '';
	}

	function submitAction(c) {
		// reset tab
		document.getElementById('tab1').className = 'linkUnSelected';
		document.getElementById('tab2').className = 'linkUnSelected';
<%	if ((ConstantsServerSide.isHKAH()) ||
		(ConstantsServerSide.isTWAH() && (userBean.isAdmin() || userBean.isEducationManager()))) { %>
		document.getElementById('tab3').className = 'linkUnSelected';
		document.getElementById('tab4').className = 'linkUnSelected';
		document.getElementById('tab5').className = 'linkUnSelected';
		document.getElementById('tab8').className = 'linkUnSelected';
<%		if (ConstantsServerSide.isHKAH()) { %>
			document.getElementById('tab6').className = 'linkUnSelected';
			document.getElementById('tab7').className = 'linkUnSelected';
<%		}
	}
%>
		document.search_form.courseCategory.value = c;
		if (c == 'compulsory') {
			document.getElementById('tab1').className = 'linkSelected';
			$("#courseListRow").hide();
			$("#recordNameRow").hide();
			document.search_form.eventID.value = "";
		} else if (c == 'inservice') {
			document.getElementById('tab2').className = 'linkSelected';
			$("#courseListRow").show();
			$("#recordNameRow").show();
			document.search_form.eventID.value = "";
			$("input[name=courseList][value=CNE]").attr('style', 'display:none;');
			$("input[name=courseList][value=inservice]").attr('checked', 'checked');
			$("#CNELabel").attr('style','display:none;');
			$("#mockCodeLabel").attr('style','display:none;');
			$("#mockDrillLabel").attr('style','display:none;');
			$("input[name=courseList][value=all]").attr('style', 'display:none;');
			$("input[name=courseList][value=mockCode]").attr('style', 'display:none;');
			$("input[name=courseList][value=mockDrill]").attr('style', 'display:none;');
			$("#allLabel").attr('style','display:none;');
<%	if (ConstantsServerSide.isHKAH()) { %>
		} else if (c == 'CNE') {
			document.getElementById('tab3').className = 'linkSelected';
			$("#recordNameRow").show();
			$("#courseListRow").hide();
			$("input[name=courseList][value=CNE]").attr('checked', 'checked');
		} else if (c == 'mockCode') {
			document.getElementById('tab4').className = 'linkSelected';
			$("#recordNameRow").hide();
			$("input[name=courseList][value=mockCode]").attr('checked', 'checked');
			$("#courseListRow").hide();
			document.search_form.eventID.value = "";
		} else if (c == 'mockDrill') {
			document.getElementById('tab5').className = 'linkSelected';
			$("#recordNameRow").hide();
			$("input[name=courseList][value=mockDrill]").attr('checked', 'checked');
			$("#courseListRow").hide();
			document.search_form.eventID.value = "";
		} else if (c == 'other') {
			document.getElementById('tab6').className = 'linkSelected';
			$("#courseListRow").hide();
			$("#recordNameRow").hide();
			document.search_form.eventID.value = "";
		} else if (c == 'tND') {
			document.getElementById('tab7').className = 'linkSelected';
			$("#courseListRow").hide();
			$("#recordNameRow").hide();
			document.search_form.eventID.value = "";
<%	} else  { %>
		} else if (c == 'CNE') {
			document.getElementById('tab3').className = 'linkSelected';
			$("#recordNameRow").show();
			$("#courseListRow").hide();
			$("input[name=courseList][value=CNE]").attr('checked', 'checked');
		} else if (c == 'mockCode') {
			document.getElementById('tab4').className = 'linkSelected';
			$("#recordNameRow").hide();
			$("input[name=courseList][value=all]").attr('checked', 'checked');
			$("#courseListRow").hide();
			document.search_form.eventID.value = "2010";
		} else if (c == 'mockDrill') {
			document.getElementById('tab5').className = 'linkSelected';
			$("#recordNameRow").hide();
			$("input[name=courseList][value=all]").attr('checked', 'checked');
			$("#courseListRow").hide();
			document.search_form.eventID.value = "6128";
<%  } %>
		} else if (c == 'JCI') {
			document.getElementById('tab8').className = 'linkSelected';
			$("#courseListRow").hide();
			$("#recordNameRow").hide();
			document.search_form.eventID.value = "";
//		} else if (c == 'ce') {
//			document.getElementById('tab5').className = 'linkSelected';
		}
		submitSearch();
	}

	function showStaff(uid) {
		callPopUpWindow("../admin/staff.jsp?command=view&enabled=1&staffID=" + uid);
		return false;
	}

	$(document).ready(function() {
		$('input').filter('.datepickerfieldOverride').datepicker({
			 showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg",
		    beforeShow: function(input, inst)
		    {
		        inst.dpDiv.css({marginTop: '-95px', marginLeft: '105px'});
		    }
		});
	});

	// set default loading
	submitAction('compulsory');

	// disable search financial year
	document.getElementById("financialYear_yy").disabled = true;
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>