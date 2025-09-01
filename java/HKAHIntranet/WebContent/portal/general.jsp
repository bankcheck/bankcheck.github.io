<%@ page import="jcifs.smb.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.cache.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.apache.commons.lang.*"%>
<%@ page import="com.hkah.convert.Converter"%>
<%!
	private String checkAccessible(UserBean userBean, String documentID, String labelTitle) {
		return checkAccessible(userBean, documentID, null, labelTitle, true);
	}

	private String checkAccessible(UserBean userBean, String documentID, String labelTitle, boolean requireLogin) {
		return checkAccessible(userBean, documentID, null, labelTitle, requireLogin);
	}

	private String checkAccessible(UserBean userBean, String documentID, String subfolder, String labelTitle) {
		return checkAccessible(userBean, documentID, subfolder, labelTitle, true);
	}

	private String checkAccessible(UserBean userBean, String documentID, String subfolder, String labelTitle, boolean requireLogin) {
		StringBuffer outputUrl = new StringBuffer();
		if ((!requireLogin || userBean.isLogin()) && DocumentDB.isAccessable(userBean, documentID)) {
			if (!labelTitle.endsWith(".db")){
				outputUrl.append("<a href=\"javascript:downloadFile('");
				outputUrl.append(documentID);
				outputUrl.append("', '");
				if (subfolder != null && subfolder.length() > 0) {
					outputUrl.append(StringEscapeUtils.escapeJavaScript(subfolder));
				}
				outputUrl.append("');\"");
				outputUrl.append(" class=\"topstoryblue\"><H1 id=\"TS\">");
				outputUrl.append(labelTitle);
				outputUrl.append("</H1></a>&nbsp;(Read Only)");

				String hyperlink = StringUtil.replaceSpecialChar4HTML(outputUrl.toString());
				outputUrl.setLength(0);
				outputUrl.append("<item im0=\"../word.gif\" text=\"");
				outputUrl.append(hyperlink);
				outputUrl.append("\" />");
			}
		}
		return outputUrl.toString();
	}

	private StringBuffer printDocumentList(UserBean userBean, String documentID) {
	  return printDocumentList(userBean,documentID,"");
	}
	private StringBuffer printDocumentList(UserBean userBean, String documentID,String category) {
		StringBuffer sb = new StringBuffer();
		ReportableListObject record = DocumentDB.getReportableListObject(documentID);
		if (record != null) {
			String path = record.getFields2();
			
			boolean useSamba = false;
			String[] children = null;
			SmbFile[] smbFiles = null;
			File[] files = null;
			
			try {
				if (ServerUtil.isUseSamba(path)) {
					useSamba = true;
					SmbFile smbFolder = new SmbFile("smb:" + path.replace("\\", "/"), 
							new NtlmPasswordAuthentication("",CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password")));
					smbFiles = smbFolder.listFiles();
					children = smbFolder.list();
				} else {
					File directory = new File(path);
					files = directory.listFiles();
					children = directory.list();
				}
				
				if (children != null && children.length > 0) {
					for (int i = 0; i < children.length; i++) {
						boolean isDirectory = useSamba ? smbFiles[i].isDirectory() : files[i].isDirectory();
						if (isDirectory) {
							String[] temp = children[i].split("-");
							sb.append("<item id=\""+temp[0]+"\" open=\"1\" text=\""+temp[0]+"\">");
							String[] subChildren = useSamba ? smbFiles[i].list() : files[i].list();
							if (subChildren != null && subChildren.length > 0 ) {
								for (int j = 0; j < subChildren.length; j++) {
									if ("nursingLibrary".equals(category)) {
										if (subChildren[j].indexOf("Thumbs")< 0&& subChildren[j].endsWith(record.getValue(6))) {
											sb.append(checkAccessible(userBean, documentID, "/" +children[i]+"/"+subChildren[j], subChildren[j]));
										}
									} else {
										sb.append(checkAccessible(userBean, documentID, "/" +children[i]+"/"+subChildren[j], subChildren[j]));
									}
								}
							}
							sb.append("</item>");
						} else {
							if ("nursingLibrary".equals(category)) {
								if (children[i].indexOf("Thumbs")< 0&&
										children[i].indexOf("Ewell OT")< 0&&
										children[i].indexOf("EwellOT")< 0&&
										children[i].indexOf("specimen taking")< 0&&
										children[i].endsWith(record.getValue(6))) {
									sb.append(checkAccessible(userBean, documentID, "/" + children[i], children[i]));
								}
							} else {
								sb.append(checkAccessible(userBean, documentID, "/" + children[i], children[i]));
							}
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return sb;
	}
	private StringBuffer printDocumentList361(UserBean userBean) {
		return printDocumentList361(userBean,null);
	}
	private StringBuffer printDocumentList361(UserBean userBean,String category) {
		String documentID = "361";
		StringBuffer sb = new StringBuffer();
		ReportableListObject record = DocumentDB.getReportableListObject(documentID);
		if (record != null) {
			String path = record.getFields2();

			File directory = new File(path);
			File newDirectory = null;

			String[] children = directory.list();
			File[] files = directory.listFiles();
			String[] newChildren = null;
			if (children != null && children.length > 0) {
				for (int i = 0; i < children.length; i++) {
					if ("ICA".equals(category)) {
						if (children[i].indexOf("Independent") > 0) {
							String[] subChildren = files[i].list();

							if (subChildren != null && subChildren.length > 0) {
								for (int j = 0; j < subChildren.length; j++) {
									sb.append(checkAccessible(userBean, documentID, "/" + children[i] + "/" + subChildren[j], subChildren[j]));
								}
							}
						}
					} else if (children[i].indexOf("In-House") == 0 ||
							children[i].indexOf("OPD Clinic Visiting Physicians") == 0 ||
							children[i].indexOf("Others") == 0) {
						if (files[i].isDirectory()) {
							String[] subChildren = files[i].list();

							if (subChildren != null && subChildren.length > 0) {
								for (int j = 0; j < subChildren.length; j++) {
									//System.out.println("DEBUG: subChildren["+j+"] = " + subChildren[j]);
									if ("4773".equals(userBean.getStaffID())) {
										if (children[i].indexOf("In-House") == 0 ) {
											sb.append(checkAccessible(userBean, documentID, "/" + children[i] + "/" + subChildren[j], subChildren[j]));
										}
									} else {
										sb.append(checkAccessible(userBean, documentID, "/" + children[i] + "/" + subChildren[j], subChildren[j]));
									}
								}
							}
						} else {
							//System.out.println("DEBUG: children["+i+"] = " + children[i]);
							if ("4773".equals(userBean.getStaffID())&& children[i].indexOf("In-House") == 0 ) {
								if (children[i].indexOf("In-House") == 0 ) {
									sb.append(checkAccessible(userBean, documentID, "/" + children[i], children[i]));
								}
							} else {
								sb.append(checkAccessible(userBean, documentID, "/" + children[i], children[i]));
							}
						}
					}
				}
			}
		}

		return sb;
	}
%>
<%
UserBean userBean = new UserBean(request);

boolean isACHSGuest = false;
if (userBean.isLogin() && "ACHS".equals(userBean.getStaffID())) {
	isACHSGuest = true;
}

String category = request.getParameter("category");
if (category != null) {
	session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY, category);
}
String action = request.getParameter("action");
String pageTitle = category.toUpperCase();
boolean skipNewsView = false;
HashMap<String, String> treeviewVector = new HashMap<String, String>();

String columnTitle = null;
if ("hr.calendar".equals(category)) {
	pageTitle = "Calendar";
} else if ("hr.benefits".equals(category)) {
	pageTitle = "Employee Benefits";
} else if ("hr.forms".equals(category)) {
	pageTitle = "Forms & Documents";
} else if ("hr.jobs".equals(category)) {
	pageTitle = "Jobs";
} else if ("hr.directory".equals(category)) {
	pageTitle = "Directory";
} else if ("hr.news".equals(category)) {
	pageTitle = "News & Events";
} else if ("hr.payroll".equals(category)) {
	pageTitle = "Payroll";
} else if ("hr.evaluation".equals(category)) {
	pageTitle = "Performance Evaluation";
} else if ("hr.policies".equals(category)) {
	pageTitle = "Policies";
} else if ("hr.training".equals(category)) {
	pageTitle = "Training & Development";
} else if ("hr.aboutHR".equals(category)) {
	pageTitle = "About HR";
} else if ("hr.contactHR".equals(category)) {
	pageTitle = "Contact HR";
} else if ("hr.userGuide".equals(category)) {
	pageTitle = "HR System User Guide";
} else if ("hr.conduct".equals(category)) {
	pageTitle = "Code of Professional Conduct";
} else if ("hr.handbook".equals(category)) {
	pageTitle = "Employee Handbook";
} else if ("hr.fidelity".equals(category)) {
	pageTitle = "Fidelity Member Briefing";
} else if ("hr.holiday".equals(category)) {
	pageTitle = "Hospital Holiday";
} else if ("hr.orientation".equals(category)) {
	pageTitle = "Orientation Schedule";
} else if ("hr.contactHR".equals(category)) {
	pageTitle = "Contact HR";
} else if ("hr.hris".equals(category)) {
	pageTitle = "HRIS";
} else if ("regulations".equals(category)) {
	pageTitle = "Regulation & Ordinance";
} else if ("policy".equals(category)) {
	pageTitle = "Policy and Resources";
} else if ("LMC".equals(category)) {
	pageTitle = "Lifestyle Management Center";
} else if ("education.powerpoint".equals(category)) {
	pageTitle = "Lecture PowerPoint";
} else if ("ba.minutes".equals(category)) {
	pageTitle = "Billing Agreement Minutes";
} else if ("education.compulsory.nursing".equals(category)) {
	pageTitle = "Compulsory and Nursing Orientation Schedule";
} else if ("education.seformdl".equals(category)) {
	pageTitle = "Useful Forms Download";
} else if ("nur".equals(category)) {
	pageTitle = "Patient and Family Education";
} else if ("nursingLibrary".equals(category)) {
	pageTitle = "Nursing Virtual Library";
} else if ("nursingSchool".equals(category)) {
	pageTitle = "Nursing School";
} else if ("pfeInfo".equals(category)) {
	pageTitle = "Patient & Family Education Information";
} else if ("pem".equals(category)) {
	pageTitle = "Patient Experience Model";
} else if ("chaplaincy".equals(category)) {
	pageTitle = "Chaplaincy Services";
} else if ("foodmenu".equals(category)) {
	pageTitle = "Daily Food Menu";
} else if ("FMInfo".equals(category)) {
	pageTitle = "FM Information";
} else if ("newAccRequest".equals(category)) {
	pageTitle = "New Account Request Form";
} else if ("pharm".equals(category)) {
	pageTitle = "Pharmacy";
} else if ("edu.poster".equals(category)) {
	pageTitle = "CNE Poster";
} else if ("dept.sharing".equals(category)) {
	pageTitle = "Departmental Sharing";
} else if ("fd.sharing".equals(category)) {
	pageTitle = "Foundation Sharing";
} else if ("bls".equals(category)) {
	pageTitle = "Basic Life Support Training Site";
} else if (pageTitle.indexOf(".") > 0) {
	pageTitle = TextUtil.replaceAll(pageTitle, ".", " ");
} else if ("osh documents".equals(category)) {
	pageTitle = "OSH";
}  else if ("usefullink".equals(category)) {
	pageTitle = "Useful Link";
} else if ("acmember".equals(category)) {
	pageTitle = "AC Members";
} else if ("bomMeeting".equals(category)) {
	pageTitle = "BOM Meeting";
} else if ("executiveMeeting".equals(category)) {
	pageTitle = "Executive Meeting";
} else if ("operationMeeting".equals(category)) {
	pageTitle = "Operation Meeting";
} else if ("boardmember".equals(category)) {
	pageTitle = "Board Member";
} else if ("boardInvitee".equals(category)) {
	pageTitle = "Board Member";
} else if ("financemember".equals(category)) {
	pageTitle = "Finance Member";
} else if ("committeememberComp".equals(category)) {
	pageTitle = "AHHK Compensation Review Committee";
} else if ("committeememberInvest".equals(category)) {
	pageTitle = "AHHK Investment Sub-Committee";
} else if ("committeememberRetire".equals(category)) {
	pageTitle = "AHHK Retirement Sub-Committee";
} else if ("committeememberAudit".equals(category)) {
	pageTitle = "Audit Committee";
} else if ("committeememberMedical".equals(category)) {
	pageTitle = "Medical Dental Executive Committee";
} else if ("committeememberStrat".equals(category)) {
	pageTitle = "Strategic Planning Committee";
} else if ("committeememberTWJoint".equals(category)) {
	pageTitle = "TW Joint Conference Committee";
} else if ("committeememberTender".equals(category)) {
	pageTitle = "Tender Process & Review Committee";
} else if ("ias".equals(category)) {
	pageTitle = "Internal Audit Service";
} else if ("foodEvent".equals(category)) {
	pageTitle = "Cook Better, Eat Better";
} 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements. See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License. You may obtain a copy of the License at

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
<body style="overflow-x:hidden;">
<form name="form1" method="post">
<table cellpadding="0" cellspacing="0" width="95%" height="100%" border="0" align="left" valign="top">
	<tr>
		<td valign="top">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="pageMap" value="N" />
</jsp:include>
<%	if ("achs".equals(category)) { %>
<div setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
	<jsp:include page="../portal/achs.file.jsp"/>
</div>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="pi.achs.link" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<%	} else if ("acmember".equals(category) || "executiveMeeting".equals(category) || "operationMeeting".equals(category) || "bomMeeting".equals(category)){%>
	<jsp:include page="../common/information_helper.jsp" flush="false">
			<jsp:param name="category" value="<%=category %>" />
			<jsp:param name="skipColumnTitle" value="Y" />
			<jsp:param name="mustLogin" value="Y" />
			<jsp:param name="oldTreeStyle" value="Y" />
	</jsp:include>
<%	} else if ("accreditation".equals(category)) { %>
	<table width="100%" valign="0">
	<tr><td valign="top" width="49%">
		<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="<%=category %>" />
		<jsp:param name="skipColumnTitle" value="Y" />
		<jsp:param name="mustLogin" value="N" />
		<jsp:param name="oldTreeStyle" value="Y" />
		</jsp:include>
	</td></tr>
	<tr><td valign="top" width="49%">
		<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="accreditation.hoklas" />
		<jsp:param name="columnTitle" value="HOKLAS" />
		<jsp:param name="mustLogin" value="N" />
		<jsp:param name="oldTreeStyle" value="N" />
		</jsp:include>
	</td></tr>
	<tr><td valign="top" width="49%">
		<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="accreditation.iso22000" />
		<jsp:param name="columnTitle" value="ISO Certification" />
		<jsp:param name="mustLogin" value="N" />
		<jsp:param name="oldTreeStyle" value="N" />
		</jsp:include>
	</td></tr>
	<tr><td valign="top" width="49%">
		<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="accreditation.hph" />
		<jsp:param name="columnTitle" value="Health Promoting Hospital" />
		<jsp:param name="mustLogin" value="N" />
		<jsp:param name="oldTreeStyle" value="N" />
		</jsp:include>
	</td></tr>
	<tr><td valign="top" width="49%">
		<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="accreditation.twmap" />
		<jsp:param name="columnTitle" value="Hong Kong Adventist Hospital - Tsuen Wan" />
		<jsp:param name="mustLogin" value="N" />
		<jsp:param name="oldTreeStyle" value="N" />
		</jsp:include>
	</td></tr>
	</table>
<%	} else if ("briefing room".equals(category)) { %>
			<table width="100%" valign="0">
			<%--
				<tr>
					<td valign="top" width="49%">

<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="briefRoom.minutes" />
	<jsp:param name="columnTitle" value="MINUTES" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="treeViewCategory" value="BriefRoomMinutes" />
</jsp:include>

<%	//treeviewVector.put("BriefRoomMinutes", "briefRoom.minutes"); %>
					</td>--%>
					<tr>
					<td valign="top" width="49%">
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="newsletter" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="treeViewCategory" value="Newsletter" />
</jsp:include>
<%	treeviewVector.put("Newsletter", "newsletter"); %>
					</td>
<% if (!isACHSGuest){ %>
					<td valign="top">
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="briefRoom.survey" />
	<jsp:param name="columnTitle" value="SURVEY / FEEDBACK" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="treeViewCategory" value="BriefRoomSurvey" />
</jsp:include>
<%	treeviewVector.put("BriefRoomSurvey", "briefRoom.survey"); %>
					</td>
				</tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr>

					<td>&nbsp;</td>
					<td valign="top">
<jsp:include page="../portal/news_helper.jsp" flush="false">
	<jsp:param name="category" value="executive order" />
	<jsp:param name="skipBrief" value="Y" />
</jsp:include>
					</td>
<%} %>
				</tr>
			</table>
<%	} else if ("nursingLibrary".equals(category)) {%>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td class="title"><span>Training<img src="../images/title_arrow.gif"></td></tr>
		<tr><td height="2" bgcolor="#840010"></td></tr>
	</table>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="3">
			<div style="margin: 20px;">
				<p>
					<video id="video1" width="960" controls autoplay>
					  <source src="" type="video/mp4">
					Your browser does not support the video tag. Please upgrade latest version of your browser.
					</video>
				</p>
			</div>
		</td></tr>
<%
String rootFolder = "\\\\www-server\\swf\\";
String locationPath = "AIS_Training";
%>	
<jsp:include page="../common/directory.jsp" flush="false">
	<jsp:param name="rootFolder" value="<%=rootFolder %>" />
	<jsp:param name="locationPath" value="<%=locationPath %>" />
	<jsp:param name="allowSelectFile" value="Y" />
	<jsp:param name="embedVideoYN" value="Y" />
</jsp:include>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td class="title"><span>Ewell Clinical Mobile Training Materials<img src="../images/title_arrow.gif"></td></tr>
		<tr><td height="2" bgcolor="#840010"></td></tr>
	</table>
	<div setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
	<xmp>
	  <item id="scl2" open="1" text="PowerPoint">
	  <%=printDocumentList(userBean, "533","nursingLibrary") %>
	  </item>
	</xmp>
	</div>
	<jsp:include page="../education/NSI_Popup.jsp" flush="false">
	<jsp:param name="module" value="MCS" />
	</jsp:include>
<%	} else if ("bls".equals(category)) { %>
<table width="960px" valign="0">
	<tr>
		<td width="300px" valign="top" colspan="3">
		<jsp:include page="../portal/general.about.jsp" flush="false">
		  	<jsp:param name="category" value="BLS" />
		</jsp:include>
		</td>
	</tr>
</table>
<%	} else if ("corporate".equals(category)) { %>
			<table width="960px" valign="0">
				<tr>
					<td width="300px" valign="top" colspan="3">
<jsp:include page="../portal/general.about.jsp" flush="false" />
						<br />
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
</jsp:include>

					</td>
					<td width="660px" valign="top" colspan="3">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td class="title"><span>Direction & Plans of <%=ConstantsServerSide.SITE_CODE.toUpperCase() %> <img src="../images/title_arrow.gif"></td></tr>
	<tr><td height="2" bgcolor="#840010"></td></tr>
	<tr><td height="10"></td></tr>
</table>
<%		if (userBean.isLogin() && userBean.isGroupID("senior.management")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.ldi.2012" />
	<jsp:param name="columnTitle" value="Leadership Development Institute (LDI) Program" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="LDI" />
</jsp:include>
<% 		} %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans.retreat.2012" />
	<jsp:param name="columnTitle" value="Department Head Retreat" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="2012Retreat" />
</jsp:include>
<!--
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans.meeting.2011" />
	<jsp:param name="columnTitle" value="2011 Long Range Meeting" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="2011Meeting" />
</jsp:include>
-->
<%		if (userBean.isLogin() && userBean.isGroupID("senior.management")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans.longRangeMeeting" />
	<jsp:param name="columnTitle" value="Long Range Planning Strategic Committee" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="LongRangeMeeting" />
</jsp:include>

<% // Archive 2007-2011 %>
<div id="treeboxbox_2007-2010" setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
	<xmp>
		<item id="tl0" text="2007 - 2010">
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans" />
	<jsp:param name="columnTitle" value="2010 Long Range Strategic Plan" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="2010Plan" />
	<jsp:param name="skipTreeview" value="Y" />
</jsp:include>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans.meeting" />
	<jsp:param name="columnTitle" value="2010 Long Range Meeting May 27" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="2010Meeting" />
	<jsp:param name="skipTreeview" value="Y" />
</jsp:include>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans.business" />
	<jsp:param name="columnTitle" value="2010 HKAH Business & Operation Plan" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="2010Business" />
	<jsp:param name="skipTreeview" value="Y" />
</jsp:include>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans.medical" />
	<jsp:param name="columnTitle" value="2010 HKAH Medical Program & Marketing Plan" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="2010Medical" />
	<jsp:param name="skipTreeview" value="Y" />
</jsp:include>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans.annual" />
	<jsp:param name="columnTitle" value="2010 Annual Plan (by Departments)" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="2010Annual" />
	<jsp:param name="skipTreeview" value="Y" />
</jsp:include>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans.2009" />
	<jsp:param name="columnTitle" value="2009" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="2009Plan" />
	<jsp:param name="skipTreeview" value="Y" />
</jsp:include>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans.2008" />
	<jsp:param name="columnTitle" value="2008" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="2008Plan" />
	<jsp:param name="skipTreeview" value="Y" />
</jsp:include>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.plans.2007" />
	<jsp:param name="columnTitle" value="2007" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="2007Plan" />
	<jsp:param name="skipTreeview" value="Y" />
</jsp:include>
		</item>
	</xmp>
</div>
<%
		}
%>
<%if (userBean.isLogin() && (userBean.isGroupID("senior.management") || userBean.isGroupID("department.head") || DepartmentDB.isDeptHead(userBean.getStaffID()))) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin.physician.kpi" />
	<jsp:param name="columnTitle" value="2017-2021 Key Performance Indicators (KPI)" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="kpi" />
</jsp:include>
<%	} %>
<%if (userBean.isLogin() &&
		(userBean.isGroupID("senior.management") || userBean.isGroupID("dh.meeting") || userBean.isGroupID("marketing.meeting"))) { %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td class="title"><span>Minutes <img src="../images/title_arrow.gif"></td></tr>
	<tr><td height="2" bgcolor="#840010"></td></tr>
	<tr><td height="10"></td></tr>
</table>
<% } %>

<%if (userBean.isLogin() && userBean.isGroupID("senior.management")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="corp.minutes.ac" />
	<jsp:param name="columnTitle" value="Administrative Council" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="treeViewCategory" value="administrativeCouncil" />
</jsp:include>
<%	treeviewVector.put("administrativeCouncil", "corp.minutes.ac"); %>
<% } %>

<%if (userBean.isLogin()&& userBean.isGroupID("dh.meeting")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="dh.meeting" />
	<jsp:param name="columnTitle" value="Department Head Meeting" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="treeViewCategory" value="dhMeeting" />
</jsp:include>
<%	treeviewVector.put("dhMeeting", "dh.meeting"); %>
<% } %>

<%if (userBean.isLogin()&& userBean.isGroupID("senior.management")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="corp.minutes" />
	<jsp:param name="columnTitle" value="Minutes" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="minutes" />
</jsp:include>
<%	treeviewVector.put("minutes", "corp.minutes"); %>
<%} %>

<%if (userBean.isLogin() && userBean.isAccessible("function.corp.minutes.mpw")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="corp.minutes.mpw" />
	<jsp:param name="columnTitle" value="Minutes" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="minutes" />
</jsp:include>
<%	treeviewVector.put("minutes", "corp.minutes.mpw"); %>
<%} %>

<%if (userBean.isLogin() && userBean.isGroupID("marketing.meeting")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="marketing.meeting" />
	<jsp:param name="columnTitle" value="Marketing Committee Meeting" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="treeViewCategory" value="marketingMeeting" />
</jsp:include>
<%	treeviewVector.put("marketingMeeting", "marketing.meeting"); %>
<% } %>

</br>
<%if (userBean.isLogin() && userBean.isGroupID("goals_round_prog.2013")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="goals_round_prog.2013" />
	<jsp:param name="columnTitle" value="3 Goals Rounding HSL Progress in 2013" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="goals_round_prog.2013" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("annual.plan")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="annual.plan" />
	<jsp:param name="columnTitle" value="Annual Plan" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="annual.plan" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("annual.rpt")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="annual.rpt" />
	<jsp:param name="columnTitle" value="Annual Reports" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="annual.rpt" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("board.meet.rpt")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="board.meet.rpt" />
	<jsp:param name="columnTitle" value="Board Meeting Reports" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="board.meet.rpt" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("chum.rpt")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="chum.rpt" />
	<jsp:param name="columnTitle" value="CHUM Reports" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="chum.rpt" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("admin.executive.office")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="coop.contracts" />
	<jsp:param name="columnTitle" value="Cooperation Contracts" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="coop.contracts" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("view.important.letter")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="view.important.doc.gov" />
	<jsp:param name="columnTitle" value="Important Documents (to Government)" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="view.important.doc.gov" />
</jsp:include>
<%}%>
<%if (userBean.isLogin() && userBean.isGroupID("view.important.letter")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="view.important.letter" />
	<jsp:param name="columnTitle" value="Important Incoming Documents" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="important.letter" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("view.marketing.doc")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="view.marketing.doc" />
	<jsp:param name="columnTitle" value="Marketing Documents (Final Version)" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="view.marketing.doc" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("view.marketing.doc.docLet")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="view.marketing.doc.docLet" />
	<jsp:param name="columnTitle" value="Marketing Documents - Doctor Letters" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="view.marketing.doc.docLet" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("view.marketing.doc.medEnq")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="view.marketing.doc.medEnq" />
	<jsp:param name="columnTitle" value="Marketing Documents - Media Enquiries" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="view.marketing.doc.medEnq" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("view.marketing.doc.eventCal")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="view.marketing.doc.eventCal" />
	<jsp:param name="columnTitle" value="Marketing Event Calendar" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="view.marketing.doc.eventCal" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("admin.executive.office")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="corp.stat" />
	<jsp:param name="columnTitle" value="Statistic" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="corp.stat" />
</jsp:include>
<%} %>
<%if (userBean.isLogin() && userBean.isGroupID("view.executive.meeting")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="executive.meeting" />
	<jsp:param name="columnTitle" value="Executive Meeting" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="executive.meeting" />
</jsp:include>
<%} %>
					</td>
				</tr>
			</table>
<%	} else if ("e-resource".equals(category)) { %>
<jsp:include page="../portal/news_view.jsp" flush="false">
	<jsp:param name="newsCategory" value="<%=category %>" />
	<jsp:param name="newsID" value="1" />
</jsp:include>
<%		skipNewsView = true; %>
<%	} else if (category.indexOf("hr.") == 0) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="columnTitle" value="<%=pageTitle %>" />
	<jsp:param name="adminStyle" value="N" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<%	} else if ("information sharing".equals(category)) { %>
			<table width="100%" valign="0">
				<tr>
					<td valign="top" width="49%">
						<table width="100%">
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="nursing" />
</jsp:include>
								</td>
							</tr>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="obbooking" />
	<jsp:param name="columnTitle" value="OB BOOKING" />
</jsp:include>
								</td>
							</tr>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="pbo" />
	<jsp:param name="columnTitle" value="PBO" />
</jsp:include>
								</td>
							</tr>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="cplab" />
	<jsp:param name="columnTitle" value="CP LAB" />
</jsp:include>
								</td>
							</tr>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="rehab" />
	<jsp:param name="columnTitle" value="Rehab" />
</jsp:include>
								</td>
							</tr>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="dental" />
	<jsp:param name="columnTitle" value="Dental" />
</jsp:include>
								</td>
							</tr>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="ha" />
	<jsp:param name="columnTitle" value="Health Assessment" />
</jsp:include>
								</td>
							</tr>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="pharmacy" />
	<jsp:param name="columnTitle" value="Pharmacy" />
</jsp:include>
								</td>
							</tr>
<%if (userBean.isLogin() && userBean.isGroupID("polyclinic")) { %>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="polyclinic" />
	<jsp:param name="columnTitle" value="HK Adventist Polyclinic" />
</jsp:include>
								</td>
							</tr>
<%} %>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="parking-info" />
	<jsp:param name="columnTitle" value="Parking Information" />
</jsp:include>
								</td>
							</tr>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="mr" />
	<jsp:param name="columnTitle" value="Medical Records" />
</jsp:include>
								</td>
							</tr>
							<tr>
								<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="guest_relation" />
	<jsp:param name="columnTitle" value="guest relation" />
</jsp:include>
								</td>
							</tr>

						</table>
					</td>
					<td rowspan="3">&nbsp;</td>
					<td valign="top" width="49%">
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="application" />
	<jsp:param name="columnTitle" value="BACK OFFICE APPLICATION" />
	<jsp:param name="mustLogin" value="N" />
</jsp:include>

<%if (userBean.isAdmin()
	||userBean.isAccessible("function.osh.allimmurecord.view")
	||userBean.isAccessible("function.osh.allimmurecord.viewall")) {%>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="osh_immu" />
	<jsp:param name="columnTitle" value="OSH Immunization List" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
</jsp:include>
<%}%>
					</td>
				</tr>
<%		if (userBean.isAdmin() || userBean.isGroupID("managerPortal.user")) { %>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td valign="top" colspan="3">
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="admin" />
</jsp:include>
					</td>
				</tr>
<%
		}
%>
			</table>
<%	} else if ("physician".equals(category)) {
		int currentYear = DateTimeUtil.getCurrentYear();
		int previousYear = currentYear - 1;
	if (!ConstantsServerSide.isHKAH()) {%>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="Physician" />
	<jsp:param name="category" value="physician" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%		treeviewVector.put("Physician", "Physician"); %>
<%	} else {
%>
			<div setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
			<xmp>
				<item id="t1" open="1" text="Summary">
<%=checkAccessible(userBean, "62", "In-house Physician Checklist") %>
				</item>
<%
		boolean doc59 = false;	// documents moved to ID 361
		boolean doc60 = false;	// documents moved to ID 361
		boolean doc61 = false;	// documents moved to ID 361
		boolean doc99 = userBean.isLogin() && DocumentDB.isAccessable(userBean, "99");
		boolean doc100 = userBean.isLogin() && DocumentDB.isAccessable(userBean, "100");
		boolean doc292 = false;	// documents moved to ID 361
		boolean doc293 = false;	// documents moved to ID 361
		boolean doc349 = false;	// documents moved to ID 361
		boolean doc350 = false;	// documents moved to ID 361
		boolean doc361 = userBean.isLogin() && DocumentDB.isAccessable(userBean, "361");
		boolean doc441 = userBean.isLogin() && DocumentDB.isAccessable(userBean, "441");
		String doc59Filename = null;
		String doc60Filename = null;
		String doc61Filename = null;
		ReportableListObject record = null;
		String path = null;

		if (doc59 || doc60 || doc61) {
			record = DocumentDB.getReportableListObject("59");
			if (record != null) {
				path = record.getFields2();

				File directory = new File(path);
				File newDirectory = null;

				String[] children = directory.list();
				String[] newChildren = null;
				if (children != null && children.length > 0) {
					for (int i = 0; i < children.length; i++) {
						if (children[i].indexOf("In-house") == 0 && !"In-house Physician - Checklist.xls".equals(children[i])) {
							newDirectory = new File(directory.toString() + "/" + children[i]);
							doc59Filename = null;
							doc60Filename = null;
							doc61Filename = null;

							if (newDirectory.exists()) {
								newChildren = newDirectory.list();
								for (int j = 0; j < newChildren.length; j++) {
									if (newChildren[j].indexOf("Tenancy Agreement") == 0) {
										doc59Filename = children[i] + "/" + newChildren[j];
									} else if (newChildren[j].indexOf("Contract - ") == 0) {
										doc60Filename = children[i] + "/" + newChildren[j];
									} else if (newChildren[j].indexOf("Clinic Schedule - ") == 0) {
										doc61Filename = children[i] + "/" + newChildren[j];
									}
								}
							}
%>
				<item id="p<%=i %>" open="1" text="<%=children[i] %>">
					<%if (doc59 && doc59Filename != null) { %><%=checkAccessible(userBean, "59", "/" + doc59Filename, "Tenancy agreement") %><%} %>
					<%if (doc60 && doc60Filename != null) { %><%=checkAccessible(userBean, "60", "/" + doc60Filename, "Contract") %><%} %>
					<%if (doc61 && doc61Filename != null) { %><%=checkAccessible(userBean, "61", "/" + doc61Filename, "OPD Schedule Checklist") %><%} %>
				</item>
<%
						}
					}
				}
			}
		}
		if (doc361) {
			String title = "ICA-Independent Contractor Agreement";

%>
				<item id="ica" open="1" text="<%=title %>">
				<%=printDocumentList361(userBean,"ICA") %>
				</item>
<%
		}
		if (doc99) {
			String title = "Set Up Doctor &amp; Clinic Schedule Check List " + currentYear;
%>
				<item id="scl2" open="1" text="<%=title %>">

					<%=printDocumentList(userBean, "99") %>
				</item>


<%
		}
		if (doc100) {
			String title = "Set Up Doctor &amp; Clinic Schedule Check List " + previousYear;
%>
				<item id="scl1" open="1" text="<%=title %>">
					<%=printDocumentList(userBean, "100") %>
				</item>
<%		}

		if (doc292 || doc293) {
%>
				<item id="opd2" open="1" text="OPD Privilege Doctors <%=currentYear %>">
<%			if (doc292) { %><%=printDocumentList(userBean, "292") %><%} %>
<%			if (doc293) { %><%=printDocumentList(userBean, "293") %><%} %>
				</item>
<%
		}

		if (doc349 || doc350) {
%>
				<item id="opd1" open="1" text="OPD Privilege Doctors <%=previousYear %>">
<%			if (doc349) { %><%=printDocumentList(userBean, "349") %><%} %>
<%			if (doc350) { %><%=printDocumentList(userBean, "350") %><%} %>
				</item>
<%
		}

		if (doc361) {
			String title = "OPD + Inhouse Privilege Doctors";

			%>
				<item id="opdec" open="1" text="<%=title %>">
<%=printDocumentList361(userBean) %>
				</item>
<%
		}
 		if (doc441) {%>
			<item id="opd1" open="1" text="Summary Memo">
			<%=printDocumentList(userBean, "441") %>
							</item>
			<%}%>
			</xmp>
			</div>
	  <%}%>
<%	} else if ("policy".equals(category)) { %>
<%		if (ConstantsServerSide.isTWAH()) { %>
			<ul id="browser" class="filetree">
<% 			if (userBean.isAccessible("function.policy_reminder.list")) { %>
				<li><img src="../images/sys.gif">&nbsp;<a href="../policy/policy_list.jsp" class="topstoryblue" href="javascript:void(0);"><H1 id="TS">Policy Reminder</H1></a></li>
<% 			} %>
				<li><span class="folder">Policy</span>
					<ul>
						<li>
							<span class="file">
								<a onclick=" downloadFile('451', ''); return false;" class="topstoryblue" href="javascript:void(0);">
									<H1 id="TS" class="labelColor1">Hospital Policy and Procedure Manuals</H1>
								</a>
							</span>
						</li>
						<li><span class="folder">Department Policy and Procedure Manuals</span>
							<ul id="policyContent" />
						</li>
					</ul>
				</li>
				<li><span class="folder">Department Resources</span>
					<ul>
						<li><span class="file"><a href="javascript:void(0);" onclick="downloadFile('702', ''); return false;" class="topstoryblue" target="_blank"><H1 id="TS">Performance Improvement</H1></a></span></li>
					</ul>
				</li>
			</ul>
<%		} else if (ConstantsServerSide.isHKAH()) { %>
			<ul id="browser" class="filetree">
<%			if (userBean.isAccessible("function.policy_reminder.list")) { %>
				<li><img src="../images/sys.gif">&nbsp;<a href="../policy/policy_list.jsp" class="topstoryblue" href="javascript:void(0);"><H1 id="TS">Policy Reminder</H1></a></li>
<%			}%>
				<li><span class="folder">Policy</span>
					<ul>
<%			if (userBean.isAccessible("function.policy.ViewDoc") || "870".equals(userBean.getDeptCode())){%>
						<li><span class="file"><a href="../documentManage/download.jsp?documentID=771" class="topstoryblue" target="content"><H1 id="TS" class="labelColor1">Hospital Policy and Procedure Manuals</H1></a>
<%				if (Converter.checkHospitalWideAccess(userBean) || userBean.isAdmin()) { %>
							<span style="font-style:italic; padding-left: 10px;">(<a href="javascript:convertPathFileToPdf()">Convert All Hospital-Wide Policy</a>)</span>
<%				} %>
						</span></li>
<%			} else if (Converter.checkPolicyAccess(userBean) || userBean.isAdmin()) { %>
						<li><span class="file"><a href="../documentManage/download.jsp?documentID=770" class="topstoryblue" target="_blank"><H1 id="TS" class="labelColor1">Hospital Policy and Procedure Manuals</H1></a>
<%				if (Converter.checkHospitalWideAccess(userBean) || userBean.isAdmin()) { %>
							<span style="font-style:italic; padding-left: 10px;">(<a href="javascript:convertPathFileToPdf()">Convert All Hospital-Wide Policy</a>)</span>
<%				} %>
						</span></li>
<%			} else if ("achs".equals(userBean.getLoginID())) { %>
						<li><span class="file"><a href="../documentManage/download.jsp?documentID=770" class="topstoryblue" target="content"><H1 id="TS" class="labelColor1">Hospital Policy and Procedure Manuals</H1></a></span></li>
<%			} else { %>
						<li><span class="file"><a href="../documentManage/download.jsp?documentID=770" class="topstoryblue" target="content"><H1 id="TS" class="labelColor1">Hospital Policy and Procedure Manuals</H1></a></span></li>
<%			} %>
						<li><span class="folder">Department Policy and Procedure Manuals (Web Version)</span>
							<ul id="policyContent" />
						</li>
					</ul>
				</li>
				
				<li><span class="folder"><H1 id="TS">Food Services</H1></span>
					<ul>
						<li><span class="file"><a href="../documentManage/download.jsp?documentID=66" class="topstoryblue" target="_blank"><H1 id="TS">Daily Menu</H1></a> (Read Only)</span></li>
						<li><span class="file"><a href="\\hkim\im\Intranet\Dept\FoodServices\Menu\DailyMenu.doc" class="topstoryblue" target="_blank"><H1 id="TS">Daily Menu</H1></a></span></li>
					</ul>
				</li>
				<!-- <li><span class="file"><a onclick=" downloadFile('529', ''); return false;" class="topstoryblue" href="javascript:void(0);"><H1 id="TS">Infection Control</H1></a></span></li> -->
				<li><span class="file"><a href="\\hkim\im\Intranet\Dept\PI\Current\1. Performance Improvement Index.docx" class="topstoryblue" target="_blank"><H1 id="TS">Performance Improvement Useful Information</H1></a></span></li>
				<li><span class="file"><a href="\\hkim\im\Intranet\Physician\main\intranet.html" class="topstoryblue" target="_blank"><H1 id="TS">Physician Service</H1></a></span></li>

				<li><span class="folder">Department Resources</span>

					<ul id="deptResourceContent" />
				</li>
			</ul>
<%		} %>
<%	} else if ("policyTest".equals(category)) {%>

<ul id="browser" class="filetree">
				<li><span class="folder">Policy</span>
					<ul>
<%		if (Converter.checkPolicyAccess(userBean)) { %>
	<li><span class="file"><a onclick="alert('<Ctrl> + Left mouse click on document name to view Policy');" href="../documentManage/download.jsp?locationPath=\\\\www-server\\policy\\hospital-wide_test\\INDEX.doc&dispositionType=inline&intranetPathYN=Y" class="topstoryblue" target="_blank"><H1 id="TS" class="labelColor1">Hospital Policy and Procedure Manuals</H1></a><span style="font-style:italic; padding-left: 10px;">(<a href="javascript:convertPathFileToPdf('policyTest')">Convert All Hospital-Wide Policy</a>)</span></span></li>
	<!-- <li><span class="file"><a href="\\www-server\policy\hospital-wide\INDEX.doc" class="topstoryblue" target="_blank"><H1 id="TS" class="labelColor1">Hospital Policy and Procedure Manuals</H1></a><span style="font-style:italic; padding-left: 10px;">(<a href="javascript:convertPathFileToPdf('policyTest')">Convert All Hospital-Wide Policy</a>)</span></span></li>-->
<%		} else { %>
	<li><span class="file"><a onclick="alert('<Ctrl> + Left mouse click on document name to view Policy');" href="../documentManage/download.jsp?locationPath=\\\\www-server\\policy\\hospital-wide_test\\INDEX_PDF.doc&dispositionType=inline&intranetPathYN=Y" class="topstoryblue" target="_blank"><H1 id="TS" class="labelColor1">Hospital Policy and Procedure Manuals(PDF)</H1></a></span></li>
	<!-- <li><span class="file"><a href="\\www-server\policy\hospital-wide\INDEX_PDF.doc" class="topstoryblue" target="_blank"><H1 id="TS" class="labelColor1">Hospital Policy and Procedure Manuals(PDF)</H1></a></span></li>-->
<%		} %>
						<li><span class="folder">Department Policy and Procedure Manuals (Web Version)</span>
							<ul id="policyContent" />
						</li>
					</ul>
				</li>
				<li><span class="folder">Department Resources</span>
					<ul>
						</li>
						<li class="closed"><span class="folder"><a href="\\hkim\im\Intranet\Dept\FoodServices\index.doc" class="topstoryblue" target="_blank"><H1 id="TS">Food Services</H1></a></span></li>
							<ul>
								<li><span class="file"><a href="../documentManage/download.jsp?documentID=66" class="topstoryblue" target="_blank"><H1 id="TS">Daily Menu</H1></a> (Read Only)</span></li>
								<li><span class="file"><a href="\\hkim\im\Intranet\Dept\FoodServices\Menu\DailyMenu.doc" class="topstoryblue" target="_blank"><H1 id="TS">Daily Menu</H1></a></span></li>
							</ul>
						</li>
						<li><span class="file"><a onclick=" downloadFile('529', ''); return false;" class="topstoryblue" href="javascript:void(0);"><H1 id="TS">Infection Control</H1></a></span></li>
						<li><span class="file"><a href="\\hkim\im\Intranet\Dept\PI\Content for PI.doc" class="topstoryblue" target="_blank"><H1 id="TS">Performance Improvement</H1></a></span></li>
						<li><span class="file"><a href="\\hkim\im\Intranet\Physician\main\intranet.html" class="topstoryblue" target="_blank"><H1 id="TS">Physician Service</H1></a></span></li>
					</ul>
				</li>
			</ul>

<%	} else if ("reference library".equals(category)) { %>
			<div setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
			<xmp>
				<item id="r0" open="1" text="Authentic Personnel">
					<item text="<%=StringUtil.replaceSpecialChar4HTML("<a href=\"\\\\hkim\\im\\Intranet\\Library\\Authentic Personnel\\Content for Committee Minutes.doc\" class=\"topstoryblue\" target=\"_blank\"><H1 id=\"TS\">Committe Minutes</H1></a>") %>" />
					<item text="<%=StringUtil.replaceSpecialChar4HTML("<a href=\"\\\\hkim\\im\\Common\\Statistics\\Statistical_Report_table_of_content_merge.xls\" class=\"topstoryblue\" target=\"_blank\"><H1 id=\"TS\">Statistical Reports</H1></a>") %>" />
				</item>
			</xmp>
			</div>
<%	} else if ("statistics".equals(category)) { %>
<% 		if (ConstantsServerSide.isTWAH()) {%>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="Report" />
	<jsp:param name="category" value="Report" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%			treeviewVector.put("Reports", "Reports"); %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="IN Patient" />
	<jsp:param name="category" value="InPatient" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%			treeviewVector.put("InPatient", "InPatient"); %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="OUT Patient" />
	<jsp:param name="category" value="OutPatient" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%			treeviewVector.put("OutPatient", "OutPatient"); %>
<% 		} else { %>
			<table width="100%" valign="0">
				<tr>
					<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="IN Patient" />
	<jsp:param name="category" value="InPatient" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%			treeviewVector.put("InPatient", "InPatient"); %>
					</td>
				</tr>
				<tr>
					<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="OUT Patient" />
	<jsp:param name="category" value="OutPatient" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%			treeviewVector.put("OutPatient", "OutPatient"); %>
					</td>
				</tr>
				<tr>
					<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="Others" />
	<jsp:param name="category" value="Others" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%			treeviewVector.put("Others", "Others"); %>
					</td>
				</tr>
				<tr>
					<td>
			<ul id="browser" class="filetree">
				<li><span class="folder closed">Foundation</span>
					<ul>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="Donation" />
	<jsp:param name="category" value="foundation.donation" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%			treeviewVector.put("foundation.donation", "foundation.donation"); %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="Beneficiary" />
	<jsp:param name="category" value="foundation.beneficiary" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%			treeviewVector.put("foundation.beneficiary", "foundation.beneficiary"); %>

					</ul>
				</li>
			</ul>
					</td>
				</tr>
<% if (DocumentDB.isAccessable(userBean, "28")) { %>
				<tr>
					<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="Monthly Departmental Report" />
	<jsp:param name="category" value="Departmental Report" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%			treeviewVector.put("DepartmentalReport", "Departmental Report"); %>
					</td>
				</tr>
<% } %>
				<tr>
					<td>
		<div id="treeboxbox_files" setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
			<xmp>
<%=checkAccessible(userBean, "28", "Monthly Departmental Report (Current)") %>
<%=checkAccessible(userBean, "55", "Key Performance Indicator") %>
<%=checkAccessible(userBean, "763", "SR KPI Worksheet") %>
			</xmp>
		</div>
					</td>
				</tr>
				<tr>
					<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="Health Assessment" />
	<jsp:param name="category" value="Health Assessment" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="HealthAssessment" />
</jsp:include>
<%			treeviewVector.put("HealthAssessment", "Health Assessment"); %>
					</td>
				</tr>
				<tr>
					<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="Report" />
	<jsp:param name="category" value="Report" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
<%			treeviewVector.put("Reports", "Reports"); %>
					</td>
				</tr>
<% if (DocumentDB.isAccessable(userBean, "688")) { %>
				<tr>
					<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="Statistic Information" />
	<jsp:param name="category" value="Health Ministries" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="HealthMinistries" />
</jsp:include>
<%			treeviewVector.put("HealthMinistries", "Health Ministries"); %>
					</td>
				</tr>
<% } %>
			</table>
<%		} %>
<%	} else if ("marketing".equals(category)) { %>
<%		if (ConstantsServerSide.isHKAH()) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td class="title"><span>HKAH Cardiologists at TVB Infotainment<img src="../images/title_arrow.gif"></td></tr>
		<tr><td height="2" bgcolor="#840010"></td></tr>
		<tr><td height="10"></td></tr>
	</table>
<jsp:include page="../education/NSI_Popup.jsp" flush="false">
	<jsp:param name="module" value="marketing" />
</jsp:include>
<%		} else { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<%	treeviewVector.put("MarketingDisplay", "marketing.display"); %>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td class="title">Video and audio clipping<img src="../images/title_arrow.gif"></td></tr>
			<tr><td height="2" bgcolor="#840010"></td></tr>
			<tr><td height="10"></td></tr>
			<tr><td>
			<jsp:include page="../education/NSI_Popup.jsp" flush="true">
			<jsp:param name="module" value="twah_cme" />
			</jsp:include>
			</td></tr>
		</table>
<%		} %>
<%  } else if ("pfeInfo".equals(category)){ %>
	<jsp:include page="../common/information_helper.jsp" flush="false">
			<jsp:param name="category" value="<%=category %>" />
			<jsp:param name="skipColumnTitle" value="Y" />
			<jsp:param name="mustLogin" value="Y" />
			<jsp:param name="oldTreeStyle" value="Y" />
	</jsp:include>
<%	} else if ("pem".equals(category)) { %>

<table width="100%" valign="0" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
<table width="100%" valign="0" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td class="title">Committee Meeting<img src="../images/title_arrow.gif"></td></tr>
			<tr><td height="2" bgcolor="#840010"></td></tr>
			<tr><td height="10"></td></tr>
		</table>
		<jsp:include page="../common/information_helper.jsp" flush="false">
			<jsp:param name="category" value="pem.PEM.comm" />
			<jsp:param name="skipColumnTitle" value="Y" />
			<jsp:param name="mustLogin" value="N" />
		</jsp:include>
	</td>
</tr>
<tr>
	<td valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td class="title">Customer Services Survey and Coaching Team<img src="../images/title_arrow.gif"></td></tr>
			<tr><td height="2" bgcolor="#840010"></td></tr>
			<tr><td height="10"></td></tr>
		</table>
		<jsp:include page="../common/information_helper.jsp" flush="false">
			<jsp:param name="category" value="pem.customerService" />
			<jsp:param name="skipColumnTitle" value="Y" />
			<jsp:param name="mustLogin" value="N" />
		</jsp:include>
	</td>
</tr>
<tr>
	<td valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td class="title">Reward & Recognition Team<img src="../images/title_arrow.gif"></td></tr>
			<tr><td height="2" bgcolor="#840010"></td></tr>
			<tr><td height="10"></td></tr>
		</table>
		<jsp:include page="../common/information_helper.jsp" flush="false">
			<jsp:param name="category" value="pem.RnR" />
			<jsp:param name="skipColumnTitle" value="Y" />
			<jsp:param name="mustLogin" value="N" />
		</jsp:include>
	</td>
</tr>
<tr>
	<td valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td class="title">Communication Team<img src="../images/title_arrow.gif"></td></tr>
			<tr><td height="2" bgcolor="#840010"></td></tr>
			<tr><td height="10"></td></tr>
		</table>
		<jsp:include page="../common/information_helper.jsp" flush="false">
			<jsp:param name="category" value="pem.comm" />
			<jsp:param name="skipColumnTitle" value="Y" />
			<jsp:param name="mustLogin" value="N" />
			<jsp:param name="treeViewCategory" value="pem.comm" />
		</jsp:include>
	</td>
</tr>
<tr>
	<td valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td class="title">LeaderShip Development Sub-Committees<img src="../images/title_arrow.gif"></td></tr>
			<tr><td height="2" bgcolor="#840010"></td></tr>
			<tr><td height="10"></td></tr>
		</table>
		<jsp:include page="../common/information_helper.jsp" flush="false">
			<jsp:param name="category" value="pem.ldsc" />
			<jsp:param name="skipColumnTitle" value="Y" />
			<jsp:param name="mustLogin" value="N" />
			<jsp:param name="treeViewCategory" value="pem.ldsc" />
		</jsp:include>
	</td>
</tr>
<tr>
	<td valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td class="title">Service Recovery Team<img src="../images/title_arrow.gif"></td></tr>
			<tr><td height="2" bgcolor="#840010"></td></tr>
			<tr><td height="10"></td></tr>
		</table>
		<jsp:include page="../common/information_helper.jsp" flush="false">
			<jsp:param name="category" value="pem.servRecov" />
			<jsp:param name="skipColumnTitle" value="Y" />
			<jsp:param name="mustLogin" value="N" />
			<jsp:param name="treeViewCategory" value="pem.servRecov" />
		</jsp:include>
	</td>
</tr>
<tr><td colspan="3">&nbsp;</td></tr>
<tr>
	<td valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td class="title">Training materials<img src="../images/title_arrow.gif"></td></tr>
			<tr><td height="2" bgcolor="#840010"></td></tr>
			<tr><td height="10"></td></tr>
		</table>
		<jsp:include page="../common/information_helper.jsp" flush="false">
			<jsp:param name="category" value="pem.relMtrl" />
			<jsp:param name="skipColumnTitle" value="Y" />
			<jsp:param name="mustLogin" value="N" />
			<jsp:param name="treeViewCategory" value="pem.relMtrl" />
		</jsp:include>
	</td>
</tr>
<tr>
	<td valign="top">
		<div  id="pemVideoOct" setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
		</div>
	</td>
</tr>
<tr>
	<td valign="top">
		<div  id="pemVideoMay" setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
		</div>
	</td>
</tr>
<%if (ConstantsServerSide.isTWAH() && userBean.isLogin() && userBean.isAccessible("function.pem.may.view")) {%>
<tr>
	<td valign="top">
		<div  id="pemVideoMayAIDET" setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
		</div>
	</td>
</tr>
<%}%>
<tr>
	<td valign="top">
		<div  id="pemVideoFeb" setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
		</div>
	</td>
</tr>
<tr><td colspan="3">&nbsp;</td></tr>
</table>
		</td>
		<td width="10px"></td>
		<td valign="top">
		<table style="width:400px">
			<tr><td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td class="title"><span>PEM Training Videos<img src="../images/title_arrow.gif"></td></tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td height="10"></td></tr>
			</table>
			<jsp:include page="../education/NSI_Popup.jsp" flush="true">
			<jsp:param name="module" value="PEM" />
			<jsp:param name="subModule" value="pem.relMtrl" />
			</jsp:include>
			</td></tr>
			<!--
			<tr><td>
				<div  id="pemVideoSharing" setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
				</div>
			</td></tr>
			<tr><td>
				<div  id="pemVideoTraining" setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
				</div>
			</td></tr>
			 -->
		</table>
		</td>
	</tr>

</table>
<%  } else if ("chaplaincy".equals(category)) { %>
<jsp:include page="../chaplaincy/index.jsp" flush="false"/>
<% } else if ("risk management".equals(category)) { %>
<%treeviewVector.put("Reports", "Reports"); %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<% } else if ("LMC".equals(category)) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<% } else if ("OSH".equals(category)) { %>
	<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="columnTitle" value="OSH" />
		<jsp:param name="category" value="OSH" />
		<jsp:param name="adminStyle" value="N" />
		<jsp:param name="skipColumnTitle" value="Y" />
		<jsp:param name="countHitRate" value="Y" />
	</jsp:include>
<%			treeviewVector.put("OSH", "OSH"); %>
<% } else if ("IC".equals(category)) { %>
	<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="columnTitle" value="IC" />
		<jsp:param name="category" value="IC" />
		<jsp:param name="adminStyle" value="N" />
		<jsp:param name="skipColumnTitle" value="Y" />
		<jsp:param name="countHitRate" value="Y" />
	</jsp:include>
<%			treeviewVector.put("IC", "IC"); %>
<%} else if ("foodmenu".equals(category)) {%>
	<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="foodmenu" />
		<jsp:param name="skipColumnTitle" value="Y" />
		<jsp:param name="mustLogin" value="N" />
		<jsp:param name="oldTreeStyle" value="Y" />
	</jsp:include>
<%			treeviewVector.put("foodmenu", "foodmenu"); %>
<%} else if ("nursing".equals(category)) {%>
	<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="nursing.link" />
		<jsp:param name="skipColumnTitle" value="Y" />
		<jsp:param name="mustLogin" value="Y" />
		<jsp:param name="oldTreeStyle" value="N" />
	</jsp:include>
<%			treeviewVector.put("nursingLink", "nursing.link"); %>
	<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="nursingpage" />
		<jsp:param name="skipColumnTitle" value="Y" />
		<jsp:param name="mustLogin" value="Y" />
		<jsp:param name="oldTreeStyle" value="Y" />
	</jsp:include>
<%			treeviewVector.put("nursingpage", "nursingpage"); %>
<%} else if ("FMInfo".equals(category)) {%>
	<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="FMInfo" />
		<jsp:param name="skipColumnTitle" value="Y" />
		<jsp:param name="mustLogin" value="Y" />
		<jsp:param name="oldTreeStyle" value="Y" />
	</jsp:include>
<%			treeviewVector.put("FMInfo", "FMInfo"); %>
<%} else if ("pharm".equals(category)) {%>
	<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="pharm" />
		<jsp:param name="skipColumnTitle" value="Y" />
		<jsp:param name="mustLogin" value="N" />
		<jsp:param name="oldTreeStyle" value="Y" />
	</jsp:include>
<%			treeviewVector.put("pharm", "pharm"); %>

<%	} else if ("roster".equals(category)) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<%	} else if ("forms and templates".equals(category)) {%>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<br/>
<jsp:include page="../portal/clinical_form.jsp" flush="false" />
<%	} else if ("education.powerpoint".equals(category)) {%>
	<!-- TEST -->
	<jsp:include page="../common/information_helper.jsp" flush="false">
		<jsp:param name="category" value="<%=category %>" />
		<jsp:param name="skipColumnTitle" value="Y" />
		<jsp:param name="mustLogin" value="N" />
		<jsp:param name="oldTreeStyle" value="Y" />
	</jsp:include>
<%	} else if ("dept.sharing".equals(category)) {%>
<%--
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="N" />
	<jsp:param name="columnTitle" value="Departmental Sharing" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
--%>
<br/>
<ul id="deptSharingContent">
	<li>
		<span class="folder">
			<a href="../documentManage/deptSharing.jsp?locationPath=\\Corporate" class="topstoryblue">
				<h1 id="TS">● Corporate</h1>
			</a>
		</span>
	</li>
	<li></li>
	<li>
		<span class="folder">
			<a href="../documentManage/deptSharing.jsp?locationPath=\\Administration" class="topstoryblue">
				<h1 id="TS">● Administration</h1>
			</a>
		</span>
	</li>
	<li></li>
	<li>
		<span class="folder">
			<a href="../documentManage/deptSharing.jsp?locationPath=\\Ancillary" class="topstoryblue">
				<h1 id="TS">● Ancillary</h1>
			</a>
		</span>
	</li>
	<li></li>
	<li>
		<span class="folder">
			<a href="../documentManage/deptSharing.jsp?locationPath=\\Nursing" class="topstoryblue">
				<h1 id="TS">● Nursing</h1>
			</a>
		</span>
	</li>
	<li></li>
	<li>
		<span class="folder">
			<a href="../documentManage/deptSharing.jsp?locationPath=\\Support" class="topstoryblue">
				<h1 id="TS">● Support</h1>
			</a>
		</span>
	</li>
	<li></li>
	<li>
		<span class="folder">
			<a href="../documentManage/deptSharing.jsp?locationPath=\\Template" class="topstoryblue">
				<h1 id="TS">● Template</h1>
			</a>
		</span>
	</li>
	<li></li>
	<%if (ConstantsServerSide.isHKAH()) { %>
		<li>
			<span class="folder">
				<a href="../documentManage/download.jsp?rootFolder=\\\\WWW-SERVER\\Departmental Sharing&locationPath=\\UserGuide\\User Guide.doc" class="topstoryblue">
				<%--  <a href="../documentManage/deptSharing.jsp?locationPath=\\UserGuide" class="topstoryblue">  --%>
					<h1 id="TS">● User Guide</h1>
				</a>
			</span>
		</li>
	<%} else if (ConstantsServerSide.isTWAH()) { %>
		<li>
			<span class="folder">
				<a href="../documentManage/download.jsp?rootFolder=\\\\IT-S20\\document\\Intranet\\Portal\\Departmental Sharing&locationPath=\\Departmental Sharing - User Guide.doc" class="topstoryblue">
					<h1 id="TS">● User Guide</h1>
				</a>
			</span>
		</li>
	<%} %>
</ul>
</br>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Maintenance Daily Schedule" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="pageMap" value="N" />
	<jsp:param name="mustLogin" value="Y" />
</jsp:include>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="dept.sharing.maintenance" />
	<jsp:param name="columnTitle" value="Maintenance Daily Schedule" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="dept" />
</jsp:include>
<%	treeviewVector.put("dept", "dept.sharing.maintenance"); %>
</br>
<% if (ConstantsServerSide.isHKAH() &&
		(userBean.isAdmin() || userBean.isAccessible("function.renov.upd.list"))) { // Development in progress %>
<!-- Renovation Update -->
<jsp:include page="../admin/news_list.jsp" flush="true">
	<jsp:param name="newsCategory" value="renov.upd" />
	<jsp:param name="skipHeader" value="Y" />
</jsp:include>
<% } %>
<%	} else if ("fd.sharing".equals(category)) {%>
<br/>
<ul id="fdSharingContent">
	<li>
		<span class="folder">
			<a href="../documentManage/fdSharing.jsp" class="topstoryblue">
				<h1 id="TS">Foundation Sharing</h1>
			</a>
		</span>
	</li>
</ul>
<%	} else if ("osh documents".equals(category)) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="osh.documents" />
	<jsp:param name="columnTitle" value="OSH" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="treeViewCategory" value="osh" />
</jsp:include>
<%	treeviewVector.put("osh", "osh.documents"); %>
<% } else if ("nursingSchool".equals(category)) {
	if (userBean.isLogin()) {
		boolean allowView = false;
		/*
		 try {
		 	if (((Integer.parseInt(userBean.getDeptCode()) >= 100 && Integer.parseInt(userBean.getDeptCode()) < 500 &&
		 			Integer.parseInt(userBean.getDeptCode()) != 300)
				||Integer.parseInt(userBean.getDeptCode()) == 770
				|| Integer.parseInt(userBean.getDeptCode()) == 780) && userBean.isManager()) {
					allowView = true;
			} else if (Integer.parseInt(userBean.getDeptCode()) == 675) {
				allowView = true;
			}
	    } catch(NumberFormatException e) {
		        allowView = false;
	    }
		if (!allowView) {
			try{
				if ((StaffDB.getPosition(userBean.getStaffID()).toLowerCase().contains("duty manager")||
				   StaffDB.getPosition(userBean.getStaffID()).toLowerCase().contains("manager")||
				   StaffDB.getPosition(userBean.getStaffID()).toLowerCase().contains("supervisor"))&&
				   ((Integer.parseInt(userBean.getDeptCode()) >= 100 && Integer.parseInt(userBean.getDeptCode()) < 500 &&
		 			Integer.parseInt(userBean.getDeptCode()) != 300)
					||Integer.parseInt(userBean.getDeptCode()) == 770
					|| Integer.parseInt(userBean.getDeptCode()) == 780)) {
					allowView = true;
				}
			 }catch (Exception e) {
				 allowView = false;
			 }
		}
		*/

		if (userBean.isAccessible("function.nursingSchool.managers.view")) {
			 allowView = true;
		}
		if (userBean.isAdmin()) {
			allowView = true;
		}
		if (allowView) {
		%>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="nursingSchool.managers" />
	<jsp:param name="columnTitle" value="For Nursing School managers" />
	<jsp:param name="skipColumnTitle" value="N" />
	<jsp:param name="mustLogin" value="Y" />
</jsp:include>
	<%} %>
<%
	allowView = false;
	if (userBean.isAccessible("function.nursingSchool.student.view")) {
			 allowView = true;
		}
		if (userBean.isAdmin()) {
			allowView = true;
		}
		if (allowView) {
		%>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="nursingSchool.student" />
	<jsp:param name="columnTitle" value="For Nursing School student" />
	<jsp:param name="skipColumnTitle" value="N" />
	<jsp:param name="mustLogin" value="Y" />
</jsp:include>
	<%} %>
<%}%>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="nursingSchool" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<% } else if ("medical affairs".equals(category)) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
<jsp:param name="category" value="<%=category %>" />
<jsp:param name="columnTitle" value="Medical Affairs" />
<jsp:param name="mustLogin" value="N" />
<jsp:param name="treeViewCategory" value="medical.affairs" />
</jsp:include>
<jsp:include page="../common/information_helper.jsp" flush="false">
<jsp:param name="category" value="medical.affairs.policy" />
<jsp:param name="columnTitle" value="Orientation Program for Doctors" />
<jsp:param name="mustLogin" value="N" />
<jsp:param name="treeViewCategory" value="medical.affairs.policy" />
</jsp:include>
<% } else if ("finance".equals(category)) { %>
<% 		if (userBean.isGroupID("finance.view")){ %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="columnTitle" value="Fee Schedule" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<%		} %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="AHHK Insurance Program" />
	<jsp:param name="columnTitle" value="AHHK Insurance Program" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<% } else if ("doctor".equals(category)){ %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="columnTitle" value="User Guide" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<% } else if ("financial.information".equals(category) && ConstantsServerSide.isHKAH()){ %>
	<% if (userBean.isAccessible("function.menu.financialInfo") || DocumentDB.isAccessable(userBean, "499")) { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
	<%} else { %>
		<div class="remarks_warning">
			Sorry, this page is updating.
		</div>
	<%	} %>
<%} else { %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<%	} %>
<%	if (!skipNewsView) { %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td height="7">&nbsp;</td></tr>
</table>
<jsp:include page="../portal/news_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="skipBrief" value="Y" />
</jsp:include>
<%	} %>

<%	if (userBean.isLogin() && "hr.benefits".equals(category)) { %>
<%		if ("CE".equals(action)) { %>
<jsp:include page="../education/ce_record_list.jsp" flush="false" />
<%		} else if ("PE".equals(action)) { %>
<jsp:include page="../education/physical_exam.jsp" flush="false" />
<%		} %>
<%	} else if ("hr.news".equals(category) && "710".equals(userBean.getDeptCode())) { %>
		Staff Newsletter Counter: <%=DocumentDB.showHitRate("132") %>
<%	} else if ("hr.aboutHR".equals(category)) { %>
<jsp:include page="../hr/aboutHR.jsp" flush="false" />
<%	} else if ("hr.hris".equals(category)) { %>
<jsp:include page="../documentManage/download2.jsp?embedVideoYN=Y&documentID=3" flush="true" />
<%	} else if ("foodEvent".equals(category)) { %>
<jsp:include page="../documentManage/download2.jsp?embedVideoYN=Y&documentID=784" flush="true" />
<%	} %>

		</td>
	</tr>
</table>
<input type="hidden" name="newsCategory" />
<input type="hidden" name="newsID" />
<input type="hidden" name="category"/>
</form>
<script language="javascript">
<!--//
<%	if ("policy".equals(category)) { %>
<%		if (ConstantsServerSide.isHKAH()) { %>
	var pyID = ["Bio-Medical Engineering", "C P LAB", "CCIC", "Chaplaincy", "Clinical Laboratory",
	            "CSRU", "Diagnostic Imaging", "Endoscopy", "Food %26 Dietetic",
	            "General Nursing", "Haemodialysis", "Heart Centre", "Housekeeping", "HR",
	            "ICUCCU", "Infection Control", "Information Management", "Information Systems & Technology", "LMC", "Marketing",
	            "Material Management", "Medical Record", "Nursing Administration", "OB UNIT", "OPD UC",
	            "Operating Room", "PBO", "Pediatric Unit", "Performance Improvement", "Pharmacy", "Physician Service", "Rehabilitation Center",
	            "Sleep Center","SCU", "SSU" ];

	var pyCont = ["Bio-Medical Engineering", "C P LAB", "Cardiac Catheterization Intervention Centre", "Chaplaincy", "Clinical Laboratory",
	              "CSRU", "Diagnostic Imaging", "Endoscopy", "Food & Dietetic",
	              "General Nursing", "Haemodialysis", "Heart Centre", "Housekeeping", "Human Resources",
	              "ICU/CCU", "Infection Control", "Information Management", "Information Systems & Technology", "Lifestyle Management Center", "Marketing",
	              "Material Management", "Medical Record", "Nursing Administration", "OB UNIT", "OPD / UC",
	              "Operating Room", "PBO", "Pediatric Unit", "Performance Improvement", "Pharmacy", "Physician Service", "Rehabilitation Center",
	              "Sleep Center","Special Care Unit", "SSU"];
<%		} else { %>
	var pyID = ["Chaplaincy", "Clinical Laboratory", "Dental", "Diagnostic Imaging",
	            "Food %26 Dietetic", "Housekeeping", "Information Systems & Technology", "Lifestyle Management Center",
	            "Marketing", "Maintenance", "Materials Management", "Medical Records", "Nursing", "OSH", "Patient Business",
	            "Pharmacy", "Rehabilitation" ];

	var pyCont = ["Chaplaincy", "Clinical Laboratory", "Dental", "Diagnostic Imaging",
	            "Food & Dietetic", "Housekeeping", "Information Systems & Technology", "Lifestyle Management Center",
	            "Marketing", "Maintenance", "Materials Management", "Medical Records", "Nursing", "OSH", "Patient Business",
	            "Pharmacy", "Rehabilitation" ];
<%		} %>

	$(document).ready(function() {
		$("#tab").tabs();

//		pyID.sort();
//		pyCont.sort();

		var content="";
		var rContent="";

		$.each(pyID, function(i, val) {
			val = val.replace("&", "%26");

			if (val == 'Infection Control') {
		/*		content +='<li><span class="file">' +
						  '<a onclick=" downloadFile(\'529\', \'\');return false;" href="javascript:void(0);">'+
						  '<H1 id="TS">Infection Control (Please refer to Policy Section in the Document) </H1></a></span></li>';*/
			} else {
				content += '<li><span class="file">' +
						'<a href="../documentManage/policy.jsp?locationPath=\\'+val+
						'" class="topstoryblue"><H1 id="TS">'+pyCont[i]+'</H1></a></span></li>';

				rContent += '<li><span class="file">' +
					'<a href="../documentManage/deptResource.jsp?locationPath=\\'+val+
					'" class="topstoryblue"><H1 id="TS">'+pyCont[i]+'</H1></a></span></li>';
		    }
		});

		$('ul#policyContent').html(content);
		$('ul#deptResourceContent').html(rContent);
	});
<%	} %>

<%	if ("policyTest".equals(category)) { %>
<%		if (ConstantsServerSide.isHKAH()) { %>
	var pyID = ["Bio-Medical Engineering", "C P LAB", "CCIC", "Chaplaincy", "Clinical Laboratory",
	            "CSRU", "Diagnostic Imaging", "Endoscopy", "Food %26 Dietetic",
	            "General Nursing", "Haemodialysis", "Heart Centre", "Housekeeping", "HR",
	            "ICUCCU", "Infection Control", "Information Management", "Information Systems & Technology", "LMC", "Marketing",
	            "Material Management", "Medical Record", "Nursing Administration", "OB UNIT", "OPD UC",
	            "Operating Room", "OSH", "PBO", "Pediatric Unit", "Pharmacy", "Rehabilitation Center",
	            "Sleep Center","SCU", "SSU","Staff Education" ];

	var pyCont = ["Bio-Medical Engineering", "C P LAB", "Cardiac Catheterization Intervention Centre", "Chaplaincy", "Clinical Laboratory",
	              "CSRU", "Diagnostic Imaging", "Endoscopy", "Food & Dietetic",
	              "General Nursing", "Haemodialysis", "Heart Centre", "Housekeeping", "Human Resources",
	              "ICU/CCU", "Infection Control", "Information Management", "Information Systems & Technology", "Lifestyle Management Center", "Marketing",
	              "Material Management", "Medical Record", "Nursing Administration", "OB UNIT", "OPD / UC",
	              "Operating Room", "OSH", "PBO", "Pediatric Unit", "Pharmacy", "Rehabilitation Center",
	              "Sleep Center","Special Care Unit", "SSU","Staff Education" ];
<%		} else { %>
	var pyID = ["Chaplaincy", "Clinical Laboratory", "Diagnostic Imaging",
	            "Food %26 Dietetic", "Housekeeping", "Information Systems & Technology", "Lifestyle Management Center",
	            "Marketing", "Maintenance", "Materials Management", "Medical Records", "Nursing", "Patient Business",
	            "Pharmacy", "Rehabilitation" ];

	var pyCont = ["Chaplaincy", "Clinical Laboratory", "Diagnostic Imaging",
	            "Food & Dietetic", "Housekeeping", "Information Management", "Information Systems & Technology", "Lifestyle Management Center",
	            "Marketing", "Maintenance", "Materials Management", "Medical Records", "Nursing", "Patient Business",
	            "Pharmacy", "Rehabilitation" ];
<%		} %>

	$(document).ready(function() {
		$("#tab").tabs();

//		pyID.sort();
//		pyCont.sort();

		var content="";

		$.each(pyID, function(i, val) {
			if (val == 'Infection Control') {
				content +='<li><span class="file">' +
						  '<a onclick=" downloadFile(\'529\', \'\');return false;" href="javascript:void(0);">'+
						  '<H1 id="TS">Infection Control (Please refer to Policy Section in the Document) </H1></a></span></li>';
			} else {
			 content += '<li><span class="file">' +
						'<a href="../documentManage/policyTest.jsp?locationPath=\\'+val+
						'" class="topstoryblue"><H1 id="TS">'+pyCont[i]+'</H1></a></span></li>';
		    }
		});

		$('ul#policyContent').html(content);
	});
<%	} %>

$(document).ready(function() {
	$("#pemVideoFeb").html($("#pem_febVideo").html());
	$("#pemVideoMay").html($("#pem_mayVideo").html());
	$("#pemVideoMayAIDET").html($("#pem_mayAIDETVideo").html());
	$("#pemVideoOct").html($("#pem_octVideo").html());
	$("#pemVideoSharing").html($("#pem_sharingVideo").html());
	$("#pemVideoTraining").html($("#pem_trainingVideo").html());
});
<%	if (treeviewVector.size() > 0) {
		String treeviewKey = null;
		String treeviewValue = null;
		for (Iterator i = treeviewVector.keySet().iterator(); i.hasNext();) {
			treeviewKey = (String) i.next();
			treeviewValue = (String) treeviewVector.get(treeviewKey);
%>
	function show<%=treeviewKey %>Tree() {
		document.getElementById("treeboxbox_<%=treeviewKey %>").innerHTML = '';
		tree = new dhtmlXTreeObject("treeboxbox_<%=treeviewKey %>", "100%", "100%", 0);
		tree.setImagePath("../images/dhtmlxTree/");
		tree.loadXML("../common/information_helper_xml.jsp?category=<%=treeviewValue %>");
	}
<%
		}
	} %>

	function readNews(cid, nid) {
		document.form1.action = "../portal/news_view.jsp";
		document.form1.newsCategory.value = cid;
		document.form1.newsID.value = nid;
		document.form1.submit();
		return true;
	}

	function changeUrl(aid, cid) {
		if (aid != '') {
			document.form1.action = aid;
			document.form1.category.value = cid;
			document.form1.submit();
		} else {
			alert("Under Construction");
		}
	}

	function openDhtmlxTreeNode(category) {
		var timeout = false;
		while (!timeout) {
			if (dhtmlxTree_policy && dhtmlxTree_policy.openAllItems) {
				// alert("DEBUG: tree object is ready");
				timeout = true;
			}
			window.setTimeout("void(0)", 10);
		}
		if (category == "policy") {
			dhtmlxTree_policy.openAllItems(0);
			dhtmlxTree_policy.closeAllItems("policy_dr_mf");
		}
	}

	function changeHitRate(isLink,docID) {
		if (isLink =='false') {
		downloadFile(docID);
		}
		$('#'+docID).load('../ui/docHitRateCMB.jsp?docID='+docID,new Date());
		return false;
	}

	function likeMe(category, id, act) {
		$.ajax({
			type: "POST",
			url: "../portal/news_like_helper.jsp",
			data: "action=" + act + "&newsCategory=" + category + "&newsID=" + id,
			success: function(values) {
			if (values != '') {
				$("#" + category + "_" + id).html(values);
			}//if
			}//success
		});//$.ajax
		return false;
	};

	function playMovie(file, resolution, module, title) {
		var width = "640px";
		var height = "480px";
		if (resolution == 'hvga') {
			width = "480px";
			height = "320px";
		}
		var FO = {
			movie:"../swf/flvplayer.swf",
			width:width,
			height:height,
			majorversion:"7",
			build:"0",
			flashvars:"file="+file+"&autoStart=true&repeat=true"
		};

		if (module != 'pem') {
			UFO.create(FO, 'player');
		}

		var videoName = title;
		if (title == '' || title == null) {
			var s = file.lastIndexOf("/");
			if (s < 0 ) {
				s = 0;
			}
			var e = file.lastIndexOf(".");
			if (e < 0 ) {
				e = file.length;
			}
			videoName = file.substring(s+1,e);
		}
		$('#nsi_video_title').html(videoName);

	}

	function convertPathFileToPdf(policyTest) {
		var convert = confirm("Convert all Hospital-Wide Policy?");
		if ( convert == true ){
			showLoadingBox('body', 500, $(window).scrollTop());
			$.ajax({
				url: '../common/convertPathFileToPdf.jsp?type=hospital&isTest='+policyTest,
				async: true,
				cache:false,
				success: function(values){
					alert('Finish converting policy.')
					hideLoadingBox('body', 500);
				},
				error: function() {
					alert('Error occured while converting policy.');
					hideLoadingBox('body', 500);
				}
			});
		}
	}
	
	function playVideo(url) {
		   var video = document.getElementById('video1');
		   var staffID = "<%=userBean.getStaffID() %>";

		   if (url.lastIndexOf('\\', 0) !== 0) {
			   url = '/Swf/' + url;
		   }
		   
		   if (staffID != '' && staffID != 'null' ) {
			   $.ajax({
					type: "POST",
					url: "videoLog.jsp",
					data: 	"url="+url
					+"&staffID=" + '<%=userBean.getStaffID()%>',
					success: function(values) {				 

					},//success
					error: function() {
						alert('logging failed');
					}
				});//$.ajax
		   }

		   if (url.lastIndexOf('160.100.2.80', 0) > 0) {
				url = url.replace('\\\\160.100.2.80\\document\\Intranet\\Portal', '');
				url = 'http://205.0.1.41' + url;
		   }
		   
		   video.src = url;
		   video.play();
	}
//-->
</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>