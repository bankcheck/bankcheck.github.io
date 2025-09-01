<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.crm.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%!
private ArrayList getClientPastResult(String clientID) {	
	StringBuffer sqlStr = new StringBuffer();	
	
	sqlStr.append("SELECT DISTINCT CRM_QUESTIONAIRE_CAID ,CRM_CREATED_DATE ");
	sqlStr.append("FROM   CRM_QUESTIONAIRE_CLIENT_ANSWER ");	
	sqlStr.append("WHERE CRM_ENABLED = '1' ");	
	sqlStr.append("AND   CRM_CLIENT_ID = '"+clientID+"' ");
	sqlStr.append("ORDER BY CRM_CREATED_DATE DESC");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
public static ArrayList getClientInfo(String clientID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME,  P.CRM_GROUP_DESC ");
	sqlStr.append("FROM   CRM_CLIENTS C, CRM_GROUP P ");	
	sqlStr.append("WHERE  C.CRM_CLIENT_ID = '"+clientID+"' ");
	sqlStr.append("AND    C.CRM_GROUP_ID = P.CRM_GROUP_ID ");		
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String clientID = request.getParameter("clientID");
String groupID = request.getParameter("groupID");
if(clientID == null || (clientID != null && clientID.length()== 0)){
	clientID = "null";
}

request.setAttribute("elearning_list", EnrollmentDB.getCRMAttendedClass(CRMClientDB.getClientID(clientID)));

SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
request.setAttribute("client_answer_list", getClientPastResult(CRMClientDB.getClientID(clientID)));

request.setAttribute("enrolled_event_list", ScheduleDB.getUserEnrolledList("lmc.crm",null, null,null	, null,CRMClientDB.getClientID(clientID),"guest","y"));


ArrayList physicals = CRMPhysicalDB.getPhysicalList("9");
String selectedPhysical = request.getParameter("selectedPhysical");
%>
<%!

%>
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

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
	<style>

.dataSummary {
	border-left:1px solid #000; 
	border-top:1px solid #000; 
	border-right:1px solid #CCC; 
	border-bottom:1px solid #ccc;
	cursor: pointer;
	
}

.zero{background:#FF8C8C}
.one{background:#A0D7D7}
.two{background:#50D050}
.three{background:#E178E1}
.four{background:#DAB35F}
.five{background:#8C8CFF}

	body {
		font: 0.8em arial, helvetica, sans-serif;
	}
	
    #header ul {
		list-style: none;
		padding: 0;
		margin: 0;
    }
    
	#header li {
		float: left;
		border: 1px solid #bbb;
		border-bottom-width: 0;
		margin: 0;
    }
    
	#header a {
		text-decoration: none;
		display: block;
		background: #eee;
		padding: 0.24em 1em;
		color: #00c;
		width: 10em;
		text-align: center;
    }
	
	#header a:hover {
		background: #ddf;
	}
	
	#header .selected {
		border-color: black;
	}
	
	#header .selected a {
		position: relative;
		top: 1px;
		background: white;
		color: black;
		font-weight: bold;
	}
	
	.pageContent {		
		clear: both;
		width:100%;	
	}
	
	h1 {
		margin: 0;
		padding: 0 0 1em 0;
	}
</style>

<jsp:include page="header.jsp"/>
<body>
	<div id="indexWrapper" style='width:100%'>
		<div id="mainFrame" style='width:100%'>
			<div id="contentFrame" style='width:100%'>
				<jsp:include page="../../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="Summary" />
					<jsp:param name="category" value="group.crm" />
					<jsp:param name="keepReferer" value="N" />
					<jsp:param name="isHideTitle" value="Y" />
				</jsp:include>
				<jsp:include page="title.jsp">
					<jsp:param name="title" value="Summary"/>
				</jsp:include>


<%
if(clientID != null && clientID.length()>0 && !"null".equals(clientID)){
	ArrayList clientRecord = getClientInfo(CRMClientDB.getClientID(clientID));

	if(clientRecord.size() != 0){	
		ReportableListObject clientRow = (ReportableListObject)clientRecord.get(0);	
%>
<table cellpadding="0" width="100%" cellspacing="5"	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="16%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(1)%></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(2)%></td>
		<td class="infoLabel" width="16%">Team Name</td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(3)%></td>
	</tr>
	<tr></tr>
	<tr class="smallText">
		<td colspan = "6"  class="infoTitle" colspan="4">Relative List</td>
	</tr>
</table>		
<%
	}
}
%>



				<div id="header"> 
				</br>
				<ul>
					<li onclick="showPage('onlineCourse')" id="list-onlineCourse"><a href="#page-onlineCourse">Online Course</a></li>					
					<li onclick="showPage('newstart')" id="list-newstart"><a href="#page-newstart">Log Book</a></li>
					<li onclick="showPage('event')" id="list-event"><a href="#page-event">Event</a></li>	
					<li onclick="showPage('physical')" id="list-physical"><a href="#page-physical">Physical Information</a></li>				
								
				</ul>				
				</div>
				
				<div style="margin-left:10px;width:90%;display:none;" class="pageContent" id="page-onlineCourse" >
					<br/>
					<div class="crmField3">Online Course Result</div>
					
					<bean:define id="courseNotFoundMsg"><%="Cannot find any past online course results." %></bean:define>
					<display:table id="row" name="requestScope.elearning_list" export="false"  class="tablesorter">
						<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
						<display:column title="Course Name" style="width:25%">
							<c:out value="${row.fields3}" /> 
						</display:column>	
						<display:column title="Correct Answer" style="width:25%">
							<c:out value="${row.fields9}" /> / <c:out value="${row.fields10}" />
						</display:column>	
						<display:column titleKey="prompt.attendDate" style="width:10%">
							<c:out value="${row.fields7}" /> <c:out value="${row.fields8}" />
						</display:column>
						<display:setProperty name="basic.msg.empty_list" value="<%=courseNotFoundMsg %>"/>
					</display:table>								
				</div>
				
								
				<div style="margin-left:10px;width:90%;display:none;" class="pageContent" id="page-newstart" >
					<br/>
					<div class="crmField3">Log Book Result</div>
					
					<bean:define id="newstartFoundMsg"><%="Cannot find any past Log Book results." %></bean:define>						
					<display:table id="row" name="requestScope.client_answer_list" export="false"  class="tablesorter">
						<display:column title="&nbsp;" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
						
						<display:column title="Date" style="text-align:center">		
							<c:set var="tempDate" value="${row.fields1}"/>	
					<%						
						String tempDate = (String)pageContext.getAttribute("tempDate") ;
						Calendar clientDate = Calendar.getInstance();
						
						String[] date = tempDate.split(" ");
						String year = date[0].split("-")[0];
						String month = date[0].split("-")[1];
						String day = date[0].split("-")[2];
						clientDate.set(Integer.parseInt(year), Integer.parseInt(month)-1, Integer.parseInt(day));	
						
						//must have
						System.out.println(df.format(clientDate.getTime()));
						
						Calendar startOfWeekDate = (Calendar)clientDate.clone();
						startOfWeekDate.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
						
						Calendar endOfWeekDate = (Calendar)clientDate.clone();
						endOfWeekDate.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
					%>
						<c:out value='<%=df.format(startOfWeekDate.getTime())%>'/> - <c:out value='<%=df.format(endOfWeekDate.getTime())%>'/> 
						</display:column>
						
						<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">		
							<button onclick="return newstartRecord('view','<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><bean:message key="button.view" /></button>
						</display:column>
						<display:setProperty name="basic.msg.empty_list" value="<%=newstartFoundMsg %>"/>
					</display:table>	
				</div>
				
				
				
				<div style="margin-left:10px;width:90%;display:none;" class="pageContent" id="page-event" >
					<br/>
					<div class="crmField3">Enrolled Event</div>
					
					<bean:define id="eventNotFoundMsg"><%="Cannot find any enrolled event results." %></bean:define>
					<display:table id="row" name="requestScope.enrolled_event_list" export="false"  class="tablesorter">
						<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
						<display:column title="Start Date" style="width:20%">
							<c:out value="${row.fields8}" /> 
						</display:column>	
						<display:column title="Name" style="width:20%">
							<c:out value="${row.fields3}" />
						</display:column>	
						<display:column title="Size" style="width:15%">
							<c:out value="${row.fields14}" /> / <c:out value="${row.fields13}" />
						</display:column>						
						<display:column title="Status" style="width:15%">							
							<c:set var="tempStatus" value="${row.fields17}"/>	
							
<%						
			String tempStatus = (String)pageContext.getAttribute("tempStatus") ;
			String status = "";
			if("open".equals(tempStatus)){
				status = "Open";
			}else if ("close".equals(tempStatus)){
				status = "Close";
			}else if ("suspend".equals(tempStatus)){
				status = "Suspend";
			}else{
				status = tempStatus;
			}
%>
							<c:out value='<%=status%>'/>
						</display:column>
						<display:setProperty name="basic.msg.empty_list" value="<%=eventNotFoundMsg %>"/>
					</display:table>
												
				</div>
				
				<div style="margin-left:10px;width:90%;display:none;" class="pageContent" id="page-physical" >
				<br/>
					<div class="crmField3">Physical Information</div>
				
				<form name='physicalForm' action='physical_info.jsp'>
					<label>Physical Figure: </label>
					<select id='physicalList'>
<%
			ReportableListObject physical = null;
			for(int i = 0; i < physicals.size(); i++) {				
				physical = (ReportableListObject)physicals.get(i);
%>
					<option id="<%=physical.getValue(2) %>" measure="<%=(physical.getValue(4).length()>0?physical.getValue(4):(physical.getValue(5).length()>0?physical.getValue(5):"")) %>" 
							<%=(selectedPhysical!= null && selectedPhysical.equals(physical.getValue(2)))?"selected":"" %>>
						<%=physical.getValue(3) %>
					</option>
					
<%
			}
%>
					</select>
					<br/><br/>
					<div id='physicalDiv'>
					
					</div>
					<br/>
					<div id="chart-container" style="background-color:#e5e8eb;width:100%;padding:0 5px 5px 5px">
						<div id="chart-title" style="font-size:18px; font-weight:bold;color:white;background-color:#6fa1d3;padding:5px">
							
						</div>
						<div id="physicalChart" style="padding-right:50px;background-color:#b8dbff;">
						</div>
					</div>
					<input type="hidden" name="selectedPhysical" value=""/>
					<input type="hidden" name="command" value=""/>
					<input id="clientID" type="hidden" name="clientID" value="<%=clientID%>"/>
					</form>
				</div>
		
		
				<script language="javascript">
				var index;
				function showPage(id){
					$('.pageContent').hide();
					$('#page-'+id).show();
					$('li').attr('class','');
					$('#list-'+id).attr('class', 'selected');
					index = id;
					
					if(id=="physical"){
						$('#physicalList').trigger('change')
					}					
				}			
				
				function submitSearch() {
					document.search_form.submit();
				}
			
				function clearSearch() {
					$('input[name=userID]').val('');					
					$('select#groupID :nth-child(1)').attr('selected', 'selected');					
				}
			
				function newstartRecord(cmd,caid,date) {
					callPopUpWindow('../../crm/portal/newstart_test.jsp?command='+cmd+'&questionaireCAID='+caid+'&clientAnswerDate='+date);
					
					return false;
				}
			
							
				
				$(document).ready(function(){		
					showPage('onlineCourse');
					
					$(window).resize(function() {
						if($('#physicalChart').children().length > 0){
							graph.replot();
						}
					});
					$('#physicalList').change(function(){
						$('input[name=selectedPhysical]').val($(this).find('option:selected').attr('id'));
						displayPhysicalTable($(this).find('option:selected').attr('id'), $(this).find('option:selected').attr('measure'));
						displayPhysicalGraph($('select[id=physicalList] :selected').val(), $(this).find('option:selected').attr('measure'));
					});
				});
												
				var graph;						
				
				function displayPhysicalTable(figureID, measure){						
					var patNo = 'patNo=';
					$('#physicalDiv').html('');
					var baseUrl ='../../crm/portal/physical_table.jsp';
					var url = baseUrl  ;	
					
					$.ajax({
						url: url,
						async:false,
						cache:false,
						data: "figureID="+figureID+'&measure='+encodeURIComponent(measure)+'&clientID='+$('input[id=clientID]').val()+'&displayOnly=Y',
						success: function(values){							
							$('#physicalDiv').html(values);
						},
						error: function() {					
							alert('Error occured while creating table.');
						}
					});
				}
				
				function getPhysicalData() {
					var date = new Array();
					var value = new Array();
					var dataSet = new Array();

					$('.physical-data-date').each(function(i, v) {
						date.splice(date.length, 0, $(v).html());
					});
					
					$('.physical-data-value').each(function(i, v) {
						value.splice(value.length, 0, $(v).html());
					});
					
					for(var i = 0; i < date.length; i++) {
						dataSet.splice(dataSet.length, 0, [date[i], value[i]]);
					}
					return dataSet;
				}
				
				function displayPhysicalGraph(title, measure){		
					$('#chart-title').html(title);
					$('#physicalChart').width($('#chart-title').width()*0.97-5);
					if($('#physicalChart').children().length > 0){
						graph.destroy();
					}

					var yMin = 0;
					var yMax = 0;
				
					if(title == 'Height'){
						yMin = 30;
						yMax = 200;
					}else if(title == 'Blood Pressure diastolic'){
						yMin = 30;
						yMax = 200;
					}else if(title == 'BMI'){
						yMin = 0;
						yMax = 50;
					}else if(title == 'Waist'){
						yMin = 0;
						yMax = 60;
					}else if(title == 'Hip'){
						yMin = 0;
						yMax = 60;
					}else if(title == 'WHR'){
						yMin = 0.1;
						yMax = 3;
					}else if(title == 'Glucose'){
						yMin = 0;
						yMax = 20;
					}else if(title == 'Total Cholesterol'){
						yMin = 0;
						yMax = 15;
					}else if(title == 'HDL'){
						yMin = 0;
						yMax = 3;
					}else if(title == 'Triglycerides'){
						yMin = 0;
						yMax = 8;
					}else if(title == 'LDL'){
						yMin = 0;
						yMax = 7;
					}else if(title == 'Blood Pressure systolic'){
						yMin = 50;
						yMax = 250;
					}else if(title == 'Metabolic Age'){
						yMin = 10;
						yMax = 100;
					}else if(title == 'Body Fat'){
						yMin = 10;
						yMax = 50;
					}else if(title == 'Weight'){
						yMin = 0;
						yMax = 200;
					}
					          
					var line1 = getPhysicalData();
					var today = new Date();
					
					if(line1.length > 0) {
						graph = 
							$.jqplot('physicalChart', [line1], {
								 	seriesColors: ["#295c8e"],
								 	grid: {
							            background: '#c9c9c9',
							            drawBorder: false,
							            shadow: false,
							            gridLineColor: '#666666',
							            gridLineWidth: 2
							        },
									animate: true,
									animateReplot: true,
									axes:{
										xaxis:{
											renderer:$.jqplot.DateAxisRenderer,
											tickRenderer: $.jqplot.CanvasAxisTickRenderer,
											tickOptions:{
							        	  		fontSize:'13px',
							        	  		angle:30,
							        	  		formatString: "%b %e",
						        	  			textColor: '#000'
							         	 	},
							          		min: line1[0][0],
							          		tickInterval:'1 days',
							          		drawMajorGridlines: false,
							          		pad:1.1
							        	},
							        	yaxis:{
							        		tickRenderer: $.jqplot.CanvasAxisTickRenderer,
							        		//renderer: $.jqplot.LogAxisRenderer,
						        			tickOptions:{
							        	  		fontSize:'13px',
							        	  		angle:0,
						        	  			textColor: '#000',
						        	  			formatString:'%.2f'+measure+" "
						          			},
						          			min:yMin,
						          			max:yMax
							        	}
							      	},
							      	highlighter: {
							        	show: true,
							        	sizeAdjust: 7.5,
							        	useAxesFormatters: true
							      	},
							      	cursor: {
							        	show: false
							      	},
							      	axesDefaults: {
						            	rendererOptions: {
							                baselineWidth: 1.5,
							                baselineColor: '#444444',
							                drawBaseline: false
						            	}
						        	}
							    });
						
							$('.jqplot-highlighter-tooltip').addClass('ui-corner-all');
						}
					}
				</script>
			</div>
		</div>
	</div>
</body>
</html:html>