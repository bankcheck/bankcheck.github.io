<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.crm.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb" %>
<%@ page import="org.apache.struts.Globals" %>
<%!
public static ArrayList getTeamName(String teamID) {
	StringBuffer sqlStr = new StringBuffer();
			
	sqlStr.append("SELECT CRM_GROUP_DESC ");
	sqlStr.append("FROM   CRM_GROUP ");
	sqlStr.append("WHERE  CRM_GROUP_ID = '"+teamID+"' ");
	sqlStr.append("AND    	CRM_ENABLED = 1 ");	

	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getTeamCaseManagerOrLeader(String teamID,String type) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select     C.CRM_LASTNAME||','||C.CRM_FIRSTNAME , GC.CRM_GROUP_ID, GC.CRM_ENABLED ");
	sqlStr.append("from       CRM_CLIENTS C , CRM_GROUP_COMMITTEE GC ");
	sqlStr.append("where      GC.CRM_GROUP_POSITION = '"+type+"' ");
	sqlStr.append("and        GC.CRM_ENABLED = '1' ");
	sqlStr.append("and        C.CRM_ENABLED = '1' ");
	sqlStr.append("and        C.CRM_CLIENT_ID = GC.CRM_CLIENT_ID ");
	sqlStr.append("AND        GC.CRM_GROUP_ID = '"+teamID+"' ");
			
	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getClientCaseManagerGroups(String clientID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select CRM_GROUP_ID ");
	sqlStr.append("from   CRM_GROUP_COMMITTEE ");
	sqlStr.append("where  CRM_ENABLED = 1 ");
	sqlStr.append("and    CRM_GROUP_POSITION = 'case_manager' ");
	sqlStr.append("AND    CRM_CLIENT_ID = '"+clientID+"' ");
	sqlStr.append("Order By CRM_GROUP_ID ");
	
	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}



public static ArrayList getTeamMember(String teamID) {
	StringBuffer sqlStr = new StringBuffer();
			
	sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME ");
	sqlStr.append("FROM   CRM_CLIENTS ");
	sqlStr.append("WHERE  CRM_GROUP_ID = '"+teamID+"' ");
	sqlStr.append("AND    	CRM_ENABLED = 1 ");
	sqlStr.append("ORDER BY CRM_LASTNAME, CRM_FIRSTNAME");

	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

ArrayList physicals = CRMPhysicalDB.getPhysicalList("9");
ArrayList record = CRMClientDB.get(null, userBean.getLoginID());
String lastName = "";
String firstName = "";
String chineseName = "";
String title = "";
String sex = "";
String dob_yy = "";
String dob_mm = "";
String dob_dd = "";
String ageGroup = "";
String hkid = "";
String clientPhoto = "";
ArrayList<String> groupID = new ArrayList<String>();
Locale locale = (Locale) session.getAttribute(Globals.LOCALE_KEY);

if (record.size() > 0) {
	ReportableListObject row = (ReportableListObject) record.get(0);
	lastName = row.getValue(0);
	firstName = row.getValue(1);
	chineseName = row.getValue(2);
	title = row.getValue(3);
	sex = row.getValue(5);

	dob_yy = row.getValue(6);
	dob_mm = row.getValue(7);
	dob_dd = row.getValue(8);
	ageGroup = row.getValue(12);	
	hkid = row.getValue(15);
	clientPhoto = row.getValue(48);	
	
	groupID.add(row.getValue(44));
}
String clientID = CRMClientDB.getClientID(userBean.getLoginID());

ArrayList clientIDGroupRecord = getClientCaseManagerGroups(clientID);
if (clientIDGroupRecord.size() > 0) {
	for(int i = 0; i < clientIDGroupRecord.size();i++){
		ReportableListObject row = (ReportableListObject) clientIDGroupRecord.get(i);
		if(!groupID.contains(row.getValue(0))){
			groupID.add(row.getValue(0));
		}
	}
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

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="header.jsp"/>
<head>
<style>
* {
	margin:0;
	padding:0;
}

body {
	background:url(../../images/background.png) top left;
	font: .8em "Lucida Sans Unicode", "Lucida Grande", sans-serif;
}

h2{ 
	margin-bottom:10px;
}

#wrapper{
	width:720px;
	
}

#wrapper h1{
	color:#FFF;
	text-align:center;
	margin-bottom:20px;
}

.tabs{
	height:30px;
}

.tabs > ul{
	font-size: 1em;
	list-style:none;
}

.tabs > ul > li{
	margin:0 2px 0 0;
	padding:7px 10px;
	display:block;
	float:left;
	color:#FFF;
	-webkit-user-select: none;
	-moz-user-select: none;
	user-select: none;
	-moz-border-radius-topleft: 4px;
	-moz-border-radius-topright: 4px;
	-moz-border-radius-bottomright: 0px;
	-moz-border-radius-bottomleft: 0px;
	border-top-left-radius:4px;
	border-top-right-radius: 4px;
	border-bottom-right-radius: 0px;
	border-bottom-left-radius: 0px; 
	background: #C9C9C9; /* old browsers */
	background: -moz-linear-gradient(top, #0C91EC 0%, #257AB6 100%); /* firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#0C91EC), color-stop(100%,#257AB6)); /* webkit */
}

.tabs > ul > li:hover{
	background: #FFFFFF; /* old browsers */
	background: -moz-linear-gradient(top, #FFFFFF 0%, #F3F3F3 10%, #F3F3F3 50%, #FFFFFF 100%); /* firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFFFFF), color-stop(10%,#F3F3F3), color-stop(50%,#F3F3F3), color-stop(100%,#FFFFFF)); /* webkit */
	cursor:pointer;
	color: #333;
}

.tabs > ul > li.tabActiveHeader{
	background: #FFFFFF; /* old browsers */
	background: -moz-linear-gradient(top, #FFFFFF 0%, #F3F3F3 10%, #F3F3F3 50%, #FFFFFF 100%); /* firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFFFFF), color-stop(10%,#F3F3F3), color-stop(50%,#F3F3F3), color-stop(100%,#FFFFFF)); /* webkit */
	cursor:pointer;
	color: #333;
}

.tabscontent {
	-moz-border-radius-topleft: 0px;
	-moz-border-radius-topright: 4px;
	-moz-border-radius-bottomright: 4px;
	-moz-border-radius-bottomleft: 4px;
	border-top-left-radius: 0px;
	
	background: -moz-linear-gradient(top, #FFFFFF 0%, #FFFFFF 90%, #e4e9ed 100%); /* firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFFFFF), color-stop(90%,#FFFFFF), color-stop(100%,#e4e9ed)); /* webkit */
	margin:0;
	color:#333;
}
</style>
</head>
<body>
<DIV id=contentFrame style="width:100%;height:100%">
<table>
<%if(groupID.size() > 0){ %>
	<tr>
	<td>
	<div id="wrapper" style="width:100%">
  <div id="tabContainer">
    <div class="tabs">
      <ul>
<%for(int i = 0;i < groupID.size(); i++){ 
	ArrayList teamNameRecord = getTeamName(groupID.get(i));
	String teamName = "";
	if (teamNameRecord.size() > 0) {
			ReportableListObject row = (ReportableListObject) teamNameRecord.get(0);
			teamName = row.getValue(0);
	}
%>
        <li id="tabHeader_<%=i%>"><%=teamName %></li>
<%} %>
        
        
        
      </ul>
    </div>
    <div class="tabscontent">
 
 <%for(int j = 0;j < groupID.size(); j++){ %>
      <div class="tabpage" id="tabpage_<%=j%>">
       <div class="infoBox">
				<div class="infoContent2">
					<table>
						<tr>
							<td colspan="4" class="crmTitle"><bean:message key="label.crm.team.teamProfile"/>
							<!-- <button  onclick='editLeadership("<%=groupID.get(j) %>")' type="button" style="vertical-align:middle;width:110px; height:20px;float:right" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Edit Info</button>-->
							<!-- <button  onclick='parent.parent.location.reload()' type="button" style="vertical-align:middle;width:110px; height:20px;float:right" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Edit Info</button>-->
							</td>
						</tr>
						<tr>
							<td class="crmField1">
								<bean:message key="label.crm.team.teamName"/>
							</td>
<%
ArrayList teamNameRecord = getTeamName(groupID.get(j));
String teamName = "";
if (teamNameRecord.size() > 0) {
		ReportableListObject row = (ReportableListObject) teamNameRecord.get(0);
		teamName = row.getValue(0);
}
%>
							<td class="crmData1">
								<%=teamName %>
							</td>
							<td class="crmField1">
								<bean:message key="label.crm.team.caseManager"/>
							</td>
							<td class="crmData1">
							<table>
<%
ArrayList teamCaseManagerRecord = getTeamCaseManagerOrLeader(groupID.get(j),"case_manager");
String teamManagerName = "";
if (teamCaseManagerRecord.size() > 0) {
	for(int k = 0; k < teamCaseManagerRecord.size() ; k ++){
		ReportableListObject row = (ReportableListObject) teamCaseManagerRecord.get(k);
		teamManagerName = row.getValue(0);
if(k%2==0){
	%>
									<tr>
										<td>
										<%=teamManagerName %>
										</td>
										
	<%
				}else{
	%>
										<td>
										<%=teamManagerName %>
										</td>
									</tr>
	<%
				}
	}
}
%>										
							</table>
							</td>
						</tr>
						<tr>
							<td class="crmField1">
								<bean:message key="label.crm.team.teamLeader"/>
							</td>
							<td class="crmData1" colspan="3">
		<table>
<%
ArrayList teamLeaderRecord = getTeamCaseManagerOrLeader(groupID.get(j),"team_leader");
String teamLeaderName = "";
if (teamLeaderRecord.size() > 0) {
	for(int k = 0; k < teamLeaderRecord.size() ; k ++){
		ReportableListObject row = (ReportableListObject) teamLeaderRecord.get(k);
		teamLeaderName = row.getValue(0);
if(k%2==0){
	%>
									<tr>
										<td>
										<%=teamLeaderName %>
										</td>
										
	<%
				}else{
	%>
										<td>
										<%=teamLeaderName %>
										</td>
									</tr>
	<%
				}
	}
}
%>										
							</table>						
							</td>
						</tr>
						<tr>
							<td valign="top" class="crmField1">
								<bean:message key="label.crm.team.teamMember"/>
							</td>
							<td class="crmData1" colspan="3">
								<table>
<%
if(groupID.get(j) != null && groupID.get(j).length()>0){
	ArrayList teamMemeberRecord = getTeamMember(groupID.get(j));	
	boolean isCaseManager = CRMClientDB.isCaseManager(clientID,groupID.get(j));
	if (teamMemeberRecord.size() > 0) {
		for(int i = 0;i<teamMemeberRecord.size();i++){
			ReportableListObject row = (ReportableListObject) teamMemeberRecord.get(i);			
			if(i%2==0){
%>
								<tr>
									<td><%=row.getValue(1)+ " , " + row.getValue(2)%>								
										<%=(isCaseManager?"<a style='text-transform: lowercase;' href='' onclick=\"return viewTeamMemberAction('view', '"+row.getValue(0)+"');\" >[edit]</a>":"") %>
									</td>
									
<%
			}else{
%>
									<td><%=row.getValue(1)+ " , " + row.getValue(2)%>
									<%=(isCaseManager?"<a style='text-transform: lowercase;' href=''onclick=\"return viewTeamMemberAction('view', '"+row.getValue(0)+"');\" >[edit]</a>":"") %>
									</td>
								</tr>
<%
			}
		}
	}
}

%>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</div>
      </div>
<%} %>
    </div>
  </div>
 </div>
	</td>
	</tr>

	<tr><td>&nbsp;</td></tr>
<%} %>
	<tr>
		<td>
			<div class="infoBox">
				<div class="infoContent2">
					<table>
						<tr>
							<td style="width:15%;">
								<div>
									<div class="photo">
										<img src="/upload/CRM/client_photo/<%=userBean.getUserName() %>/<%=clientPhoto%>" style="height:150px;"/>
									</div>
								</div>
							</td>
							<td valign="top">
								<div class="simpleInfo">
									<table style="width:100%;height:150px;">			
										<tr>
											<td colspan="4" class="crmTitle"><bean:message key="label.crm.client.clientProfile"/></td>
										</tr>				
										<tr>
											<td class="crmField1"><bean:message key="label.crm.lastName" /></td>
											<td id="lastName_field" class="crmData1">
												<%=lastName%>
											</td>
											<td class="crmField1"><bean:message key="label.crm.firstName" /></td>
											<td class="crmData1">
												<%=firstName%>
											</td>
										</tr>
										<tr>
											<td class="crmField1"><bean:message key="label.crm.chineseName" /></td>
											<td class="crmData1">
												<%=chineseName %>
											</td>
											<td class="crmField1"><bean:message key="adm.title" /></td>
											<td class="crmData1">
												<%=ParameterHelper.getTitleValue(session, title) %>
											</td>
										</tr>
										<tr>
											<td class="crmField1"><bean:message key="prompt.dateOfBirth" /> (DD/MM/YYYY)</td>
											<td id="dob_field" class="crmData1">
												<%=dob_dd==null||dob_dd.length()==0?"--":dob_dd %>/<%=dob_mm==null||dob_mm.length()==0?"--":dob_mm %>/<%=dob_yy==null||dob_yy.length()==0?"----":dob_yy %>
											</td>
											<td class="crmField1"><bean:message key="prompt.sex" /></td>
											<td class="crmData1">
												<%if ("M".equals(sex)) { %><bean:message key="label.male" /><%} else if ("F".equals(sex)) { %><bean:message key="label.female" /><%} else { %><bean:message key="label.unknown" /><%} %>
											</td>		
										</tr>
										<tr>
											<td class="crmField1"><bean:message key="prompt.ageGroup" /></td>
											<td class="crmData1">
												<%=ParameterHelper.getAgeGroupValue(session, ageGroup) %>
											</td>
											<td class="crmField1"><bean:message key="prompt.hkid" /></td>
											<td id="hkid_field" class="crmData1">
												<%=hkid==null?"":hkid %>
											</td>		
										</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</td>
	</tr>
	
	<tr><td>&nbsp;</td></tr>
	
	<tr>
		<td>
			<table>
				<tr>
					<td>
						<div class="infoBox">
							<div class="infoContent2">
								<table>
									<tr>
										<td colspan="4" class="crmTitle"><bean:message key="label.crm.summary" /></td>
									</tr>
									<tr>
										<td>
											<select id="summaryChoice">
<%
												ReportableListObject physical = null;
												for(int i = 0; i < physicals.size(); i++) {
													physical = (ReportableListObject)physicals.get(i);
%>
												<option id="<%=physical.getValue(2) %>" 
														measure="<%=(physical.getValue(4).length()>0?physical.getValue(4):(physical.getValue(5).length()>0?physical.getValue(5):"")) %>">
													
<%												if(Locale.TRADITIONAL_CHINESE.equals(locale)){%>
														<%=(physical.getValue(6) != null && physical.getValue(6).length() > 0 ? physical.getValue(6) : physical.getValue(3))  %>
<%													}else{%>
														<%=physical.getValue(3) %>
<%													} %>
															
												</option>								
<%
												}
%>
											</select>
											<div id="summayChart">
											
											</div>
										</td>
									</tr>
								</table>
							</div>
						</div>
					</td>
					<td>
						<div class="infoBox">
							<div class="infoContent2">
								<table>
									<tr>
										<td colspan="4" class="crmTitle">Processing</td>
									</tr>
									<tr>
										<td>
											
										</td>
									</tr>
								</table>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>



<%if(!userBean.isAccessible("function.crm.portal.admin")) {%>

<%} %>

<jsp:include page="../../common/footer.jsp" flush="false" />
</DIV>
</body>
</html:html>

<script language="javascript">
	var graph;
	
	function getSummaryData(figureID, measure) {
		var dataSet = new Array();
		
		$.ajax({
			type:"GET",
			url:"physicalData.jsp?callback=?",
			data:"figureID="+figureID+"&measure="+encodeURIComponent(measure),
			dataType:"jsonp",
			cache:false,
			async:false,
			success: function(values){
				$.each(values, function(i, v) {
					var date = v.date;
					var value = v.value;
					dataSet.splice(dataSet.length, 0, [date, value]);
				});
			},
			error: function(e) {
				alert("Fetch Data Error.");
			}
		});
		
		return dataSet;
	}
	
	function generateSummaryChart(figureID, measure) {
		if($('#summayChart').children().length > 0){
			graph.destroy();
		}
		
		var data = getSummaryData(figureID, measure);
		var today = new Date();
		
		var yMin = 0;
		var yMax = 0;
		
		if(figureID == '70'){
			yMin = 30;
			yMax = 200;
		}else if(figureID == '85'){
			yMin = 30;
			yMax = 200;
		}else if(figureID == '72'){
			yMin = 0;
			yMax = 50;
		}else if(figureID == '73'){
			yMin = 0;
			yMax = 60;
		}else if(figureID == '74'){
			yMin = 0;
			yMax = 60;
		}else if(figureID == '75'){
			yMin = 0.1;
			yMax = 3;
		}else if(figureID == '76'){
			yMin = 0;
			yMax = 20;
		}else if(figureID == '77'){
			yMin = 0;
			yMax = 15;
		}else if(figureID == '78'){
			yMin = 0;
			yMax = 3;
		}else if(figureID == '79'){
			yMin = 0;
			yMax = 8;
		}else if(figureID == '80'){
			yMin = 0;
			yMax = 7;
		}else if(figureID == '81'){
			yMin = 50;
			yMax = 250;
		}else if(figureID == '82'){
			yMin = 10;
			yMax = 100;
		}else if(figureID == '84'){
			yMin = 10;
			yMax = 50;
		}else if(figureID == '71'){
			yMin = 0;
			yMax = 200;
		}
		
		if(data.length > 0) {
			graph = 
				$.jqplot('summayChart', 
						[data],
						{
							seriesColors: ["#295c8e"],
							animate: true,
							animateReplot: true,
							autoscale: true,
						 	axes:{
						        xaxis:{
						          	renderer:$.jqplot.DateAxisRenderer,
						          	rendererOptions:{
					                    tickRenderer:$.jqplot.CanvasAxisTickRenderer,
					                },
						          	tickOptions:{
						        	  	fontSize:'13px',
						        	  	formatString:'%b %d',
						        	  	angle:-20
						         	},
					                min: (parseInt(today.getMonth()))+'/'+(parseInt(today.getDate()))+'/'+today.getFullYear(),
					          		tickInterval:'1 weeks'
						        },
						        yaxis:{
						        	//renderer: $.jqplot.LogAxisRenderer,
						        	rendererOptions:{
				                    	tickRenderer:$.jqplot.CanvasAxisTickRenderer,
				                    },
			                    	tickOptions:{
			                       		fontSize:'13px', 
			                       		formatString:'%.2f '+measure+' '
			                   	 	},
			                   		min:yMin,
				          			max:yMax
						        }
					      	},
					      	series:[{ lineWidth:4, markerOptions:{ style:'square' } }],
					      	highlighter: {
					        	show: true,
					        	sizeAdjust: 7.5,
					        	useAxesFormatters: true
					      	},
					      	cursor: {
					        	show: false
					      	}
						});
			
			$('.jqplot-highlighter-tooltip').addClass('ui-corner-all');
		}
	}
	
	function selectSummaryEvent() {
		$('select#summaryChoice').change(function() {
			generateSummaryChart($(this).find("option:selected").attr('id'),
									$(this).find("option:selected").attr('measure'));
		}).trigger('change');
	}

	function getClientCalendar(year,month){
		var select_year = 'select_year='  + year;
		var select_month = 'select_month=' + month;		
		var baseUrl ='client_calendar.jsp?' + select_year + '&' + select_month;	
		var url = baseUrl;
		
		$.ajax({
			url: url,
			async: true,
			cache:false,
			success: function(values){				
				if(values) {						
						$('#clientCalendar').html(values);						
				}
			},
			error: function() {
				alert('Error occured while creating client calendar.');
			}
		});		
	}
	
	function readNews(cid, nid) {
		document.form1.action = "../../portal/news_view.jsp";
		document.form1.newsCategory.value = cid;
		document.form1.newsID.value = nid;
		document.form1.submit();
		return true;
	}


	function switchDate(year, month) {
		document.form_calendar.select_year.value = year;
		document.form_calendar.select_month.value = month;
		getClientCalendar(year,month);
	}
	
	function enrollEvent(action,courseID,scheduleID,loginStaffID,enrollID) {
		var enrollEvent = false;
			if(action =='enroll'){
				enrollEvent = confirm("Enroll event?");
			}else if(action == 'withdraw'){
				enrollEvent = confirm("Withdraw from event?");
			}
			
			if(enrollEvent == true){				
			  var baseUrl ='../../crm/portal/calendar_event_enrollment.jsp?action='+action;		
				var url = baseUrl + '&courseID=' + courseID + '&scheduleID=' + scheduleID + '&loginStaffID=' + loginStaffID + '&enrollID=' + enrollID;	
				$.ajax({
					url: url,
					async: false,
					cache:false,
					success: function(values){
						if(values) {							
							alert($.trim(values));
							getClientCalendar($("input[name=select_year]").val(),$("input[name=select_month]").val());
						}else {
							alert('Error occured while enrolling event.');
						}
					},
					error: function() {
						alert('Error occured while enrolling event.');
					}
				});
				
			
		   }else{		      			
		   }
	}
	
	function editLeadership(grpID){
		callPopUpWindow("client_group.jsp?command=view&grpID=" + grpID +"&isClient=Y");
		return false;
	}
	
	function viewTeamMemberAction(cmd, cid) {			
		callPopUpWindow("basic_info.jsp?command=" + cmd + "&clientID=" + cid + "&useClientID=Y");
		return false;
	}
	
	$(document).ready(function() {	
		selectSummaryEvent();
		//getClientCalendar();
	});
	
	window.onload=function() {

		  // get tab container
		  var container = document.getElementById("tabContainer");
		    // set current tab
		    var navitem = container.querySelector(".tabs ul li");
		    //store which tab we are on
		    var ident = navitem.id.split("_")[1];
		    navitem.parentNode.setAttribute("data-current",ident);
		    //set current tab with class of activetabheader
		    navitem.setAttribute("class","tabActiveHeader");

		    //hide two tab contents we don't need
		    var pages = container.querySelectorAll(".tabpage");
		    for (var i = 1; i < pages.length; i++) {
		      pages[i].style.display="none";
		    }

		    //this adds click event to tabs
		    var tabs = container.querySelectorAll(".tabs ul li");
		    for (var i = 0; i < tabs.length; i++) {
		      tabs[i].onclick=displayPage;
		    }
		}

		// on click of one of tabs
		function displayPage() {
		  var current = this.parentNode.getAttribute("data-current");
		  //remove class of activetabheader and hide old contents
		  document.getElementById("tabHeader_" + current).removeAttribute("class");
		  document.getElementById("tabpage_" + current).style.display="none";

		  var ident = this.id.split("_")[1];
		  //add class of activetabheader to new active tab and show contents
		  this.setAttribute("class","tabActiveHeader");
		  document.getElementById("tabpage_" + ident).style.display="block";
		  this.parentNode.setAttribute("data-current",ident);
		}
	
</script>