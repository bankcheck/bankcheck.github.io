<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%
	String eventType = request.getParameter("eventType");
	String eventCategory = request.getParameter("eventCategory");
	if (ConstantsServerSide.isHKAH()){
		eventCategory = eventCategory + "','JCI";
	}
	String pageTitle = null;
	String category = "title.education";
	if ("inservice".equals(eventCategory)) {
		pageTitle = "function.staffEducation.education.other_is";
	} else if ("class".equals(eventType)) {
		pageTitle = "prompt.mandatoryClassSitIn";
	} else {
		pageTitle = "prompt.mandatoryClassOnline";
	}

	UserBean userBean = new UserBean(request);

	ArrayList<ReportableListObject> elearning_list = ELearning.getList((eventType != null ? new String[]{ eventType } : null), (eventCategory != null ? new String[]{ eventCategory } : null));
//	boolean isClincial = DepartmentDB.isClincialStaff(userBean);

	// special logic (departmetn_code = 360, but they belong to House Keeping)
//	if ("3254".equals(userBean.getStaffID()) ||
//			"3668".equals(userBean.getStaffID()) ||
//					"3763".equals(userBean.getStaffID()) ||
//							"3951".equals(userBean.getStaffID())) {
//		isClincial = false;
//	}

	String message = request.getParameter("message");
	if (message == null) {
		message = "";
	}
	String errorMessage = "";
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
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="accessControl" value="N" />
</jsp:include>
<table><!-- dummy --></table>
<form name="form1" action="elearning_test.jsp" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
<%	if (elearning_list != null) {
		ReportableListObject reportableListObject = null;
		String elearningID = null;
		String topic = null;
		String topicZh = null;
		String bgColor = null;
		String description = null;
		for (Iterator<ReportableListObject> itr = elearning_list.iterator() ; itr.hasNext();) {
			reportableListObject = (ReportableListObject) itr.next();
			elearningID = reportableListObject.getValue(0);
			topic = reportableListObject.getValue(1);
			topicZh = reportableListObject.getValue(7);
			bgColor = reportableListObject.getValue(8);
			description = reportableListObject.getValue(9);			
			if(userBean.isStudentUser() && !ConstantsServerSide.isTWAH() && ("11".equals(elearningID) || "7".equals(elearningID) || "5".equals(elearningID) || "9".equals(elearningID))){
				continue;
			}
%>
<%			if (!ConstantsServerSide.isTWAH() || !"class".equals(eventType) || !("12".equals(elearningID) || "13".equals(elearningID))) { %>
	<tr class="bigText">
		<td align="left"><span style="color: #<%=bgColor %>"><b><%=topic %><br /><%=topicZh %></b></span></td>
		<td align="center">
<%				if (ConstantsServerSide.isTWAH()) { %>
<%					if (!"15".equals(elearningID) && !"16".equals(elearningID)) { %>
<%						if ("12".equals(elearningID)){ %>
			<button onclick="return submitAction('test', '17');"><span class="labelColor5">View the slides<br />參閱投影片</span></button>
<%						} else if("13".equals(elearningID)){ %>
			<button onclick="return submitAction('test', '18');"><span class="labelColor5">View the slides<br />參閱投影片</span></button>
<%						} else { %>
			<button onclick="return submitAction('test', '<%=elearningID %>');"><span class="labelColor5">View the slides<br />參閱投影片</span></button>
<%						} %>
<%					} %>
<%				} else { %>
			<button onclick="return submitAction('test', '<%=elearningID %>');">Take the test</button>
<%				} %>
		</td>
	</tr>
<%			} %>
<%			if (!StringUtils.isEmpty(description)) { %>
	<tr class="middleText">
		<td align="left" colspan="2"><p style="padding: 5px 0 5px 10px;"><%=description %></p></td>
	</tr>
<%			} %>
<%			if (itr.hasNext()) { %>
	<tr>
		<td align="center" colspan="2"><hr></td>
	</tr>
<%			} %>
<%		} %>
<%	} %>
</table>
</form>
<script language="javascript">
	function submitAction(cmd, eid) {
		if (cmd != '') {
			callPopUpWindow(document.form1.action + "?from=edu&command=&elearningID=" + eid);
		}
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>