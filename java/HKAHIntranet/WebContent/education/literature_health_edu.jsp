<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<%!
private ArrayList getSubMenuModuleInfo(String subModule) {
	StringBuffer sqlStr = new StringBuffer();		
	sqlStr.append("select  EE_MENU_CONTENT_ID, EE_MODULE_CODE, EE_DESCRIPTION_EN, EE_DESCRIPTION_ZH ");
	sqlStr.append("from    EE_MENU_CONTENT ");
	sqlStr.append("WHERE   EE_ENABLED = 1 ");
	sqlStr.append("and     EE_MODULE_CODE = '"+subModule+"' ");
	sqlStr.append("and     EE_PARENT_MENU_CONTENT_ID IS null ");
	sqlStr.append("Order By EE_SORT_ORDER, EE_MENU_CONTENT_ID ");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getSubMenuModuleTopic(String subModule) {
	StringBuffer sqlStr = new StringBuffer();		
	sqlStr.append("select  EE_MENU_CONTENT_ID, EE_MODULE_CODE, EE_DESCRIPTION_EN, EE_DESCRIPTION_ZH ");
	sqlStr.append("from    EE_MENU_CONTENT ");
	sqlStr.append("WHERE   EE_ENABLED = 1 ");
	sqlStr.append("and     EE_MODULE_CODE LIKE '"+subModule+"%' ");
	sqlStr.append("and     EE_TYPE = 'topic' ");
	sqlStr.append("Order By EE_SORT_ORDER, EE_MENU_CONTENT_ID ");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}


private ArrayList getSubMenuContents(String subModule, String eeMenuParentID) {
	StringBuffer sqlStr = new StringBuffer();	
	sqlStr.append("select  EE_MENU_CONTENT_ID, EE_MODULE_CODE, EE_DESCRIPTION_EN, EE_DESCRIPTION_ZH,EE_TYPE "); 
	sqlStr.append("from    EE_MENU_CONTENT ");
	sqlStr.append("where   EE_ENABLED = 1 ");
	sqlStr.append("and     EE_MODULE_CODE = '"+subModule+"' ");
	sqlStr.append("and     EE_PARENT_MENU_CONTENT_ID = '"+eeMenuParentID+"' ");
	sqlStr.append("Order By EE_SORT_ORDER , EE_MENU_CONTENT_ID ");
	
	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getMenuDocument(String eeMenuID) {
	StringBuffer sqlStr = new StringBuffer();	
	sqlStr.append("select EE_MENU_CONTENT_ID, EE_URL, EE_IS_URL, EE_DOCUMENT_ID "); 
	sqlStr.append("from   EE_MENU_DOCUMENT ");
	sqlStr.append("where  EE_ENABLED = 1 ");
	sqlStr.append("AND    EE_MENU_CONTENT_ID = '"+eeMenuID+"' ");
	
	//System.out.println(sqlStr.toString());		
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%

UserBean userBean = new UserBean(request);
String subModule = request.getParameter("subModule");

ArrayList record = null;
if(subModule != null && subModule.length() > 0){
	record = getSubMenuModuleInfo(subModule);
}
ReportableListObject row = null;

String eeDescriptionEn = "";
String eeMenuParentID = "";
if (record != null && record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		eeMenuParentID = row.getValue(0);
		eeDescriptionEn = row.getValue(2);
}

ArrayList subMenuTopicRecord = null;
if(eeMenuParentID != null && eeMenuParentID.length() > 0){
	subMenuTopicRecord = getSubMenuModuleTopic(subModule);
}
ReportableListObject subMenuTopicRow = null;

%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>
<div id=contentFrame>
<jsp:useBean id="pageTitle" class="java.lang.String" />
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="keepReferer" value="Y" />
</jsp:include>
<style>
ul.level1 h4 { font-size: 140%; font-weight: bold; margin: 5px 0; }
ul.level2 { list-style: none;  margin-left: 20px; }
ul.level2 li { margin: 5px 0; }
ul.level3 { list-style: none;  margin: 0 10px 10px 20px; }  	
ul.level3 li { margin: 5px 0; }
</style>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>
<div style='background-image: url(../images/pink_effect_fill.png);background-size:auto'>
<form name="form1" method="post">
	<table border="0" style="width:100%">
		<tr style="text-align: right;">
				<td colspan="2"><a  href="reminder.jsp"><b>Staff Education Home</b></a></td>
			</tr>
			<tr style="font-size:150%" bgcolor="rgb(216, 174, 91)">
				<td style="color:rgb(0, 51, 204)" colspan="2" class="bold">
					<%=pageTitle %>&nbsp;<%=eeDescriptionEn %>
				</td>
		</tr>	
		<tr ><td>
	<div id="staffEducationWrapper" style="width:100%">
			<div id="contentPage" style="width:100%">			
			<p style="color:rgb(0, 51, 204)"><b>Different sources of professional healthcare information through internet links are available for staff to review, promote, manage and evaluate our clients' health status.</b></p>
			
			<table border="0" style="width:100%">
			<tr>
			<%if(subMenuTopicRecord != null && subMenuTopicRecord.size() > 0){
				for(int j = 0; j < subMenuTopicRecord.size(); j++){
					subMenuTopicRow = (ReportableListObject) subMenuTopicRecord.get(j);
					String menuTopicModule = subMenuTopicRow.getValue(1);
					String menuTopic = subMenuTopicRow.getValue(2);
			%>			
					<td>			
						<div style="text-align:center;height:100%;width:100%;background-color:#FF69B4;">			
							<font style="font-size:150%;color:rgb(0, 51, 204)" class="bold"><%=menuTopic %></font>				
							<ul style="text-align:left;" class="level1">			
							<%

							ArrayList subMenuRecord = null;
							if(eeMenuParentID != null && eeMenuParentID.length() > 0){
								subMenuRecord = getSubMenuContents(menuTopicModule, eeMenuParentID);
							}
							ReportableListObject subMenuRow = null;


							
							if (subMenuRecord != null && subMenuRecord.size() > 0) {
								for(int i = 0; i < subMenuRecord.size(); i ++){
									subMenuRow = (ReportableListObject) subMenuRecord.get(i);
								%>
								<li>
								<%
									String subMenuID = subMenuRow.getValue(0);
									String subMenuDescriptionEn = subMenuRow.getValue(2);
									String subMenuNewPage = subMenuRow.getValue(4);
									String aTarget = "_blank";
									if(subMenuNewPage != null && subMenuNewPage.equals("ownpage")){
										aTarget = "";
									}
									ArrayList docRecord =  getMenuDocument(subMenuID);
									if(docRecord != null && docRecord.size() > 0){
										ReportableListObject docRow = (ReportableListObject) docRecord.get(0);
										String eeUrl = docRow.getValue(1);
										String eeIsUrl = docRow.getValue(2);	
										String docID = docRow.getValue(3);
										if(eeIsUrl.equals("Y")){%>
											<a href="<%=eeUrl %>" target="<%=aTarget%>">
															<h4>
																<font color="white"><%=subMenuDescriptionEn %></font>
															</h4>
														</a>
										<%}else{%>
												<a href="javascript:void(0);" onclick="return downloadDocument('<%=subMenuID%>', '<%=docID %>')">
															<h4>
																<font color="white"><%=subMenuDescriptionEn %></font>
															</h4>
														</a>
										<%}
									}else{%>
										<h4><font color="red"><%=subMenuDescriptionEn %></font></h4>
									<%}%>
									</li>
									<%
								}
							}
							
							%>
							</ul>
						</div>						
					</td>				
			<%}
			}%>		
			</tr>
			</table>
			<p class="bold"style="font-size:150%;color:red;text-align:left;">Note: Red colored parts being under constructed ...</p>
		</div>
	</div>
	<input type="hidden" name="documentID" />
	<input type="hidden" name="moduleCode" value="<%=subModule %>" />
	<input type="hidden" name="keyID" />
	</td></tr></table>
	
</form>

<div style="margin: 10px 0;">
	<p class="mottoText">TWAH Staff Education</p>
	<p class="mottoText">AHHKLSA Health Education & Research</p>
</div>
<p style="text-align:right">2013-07-01 Update</p>
</div>
</div>
</div>
</div>
<script language="javascript">
<!--
	function downloadDocument(keyID, documentID) {
		document.forms["form1"].action = "../documentManage/download.jsp";
		document.forms["form1"].elements["keyID"].value = keyID;
		document.forms["form1"].elements["documentID"].value = documentID;
		document.forms["form1"].submit();
		return false;
	}
	
	function submitAction(cmd, level) {
		var moduleCode = document.forms["form1"].elements["moduleCode"].value;
		callPopUpWindow("menu_list.htm?moduleCode=" + moduleCode + "&command=" + cmd + "&level=" + level);
		return false;
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>