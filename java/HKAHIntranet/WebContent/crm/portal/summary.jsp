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
<%
UserBean userBean = new UserBean(request);
String groupID = request.getParameter("groupID");
String userID = request.getParameter("userID");
String clientSummary = request.getParameter("clientSummary");
boolean isClientSummary = false;
if("Y".equals(clientSummary)){
	isClientSummary = true;
}


ArrayList physicalsSummary = CRMPhysicalDB.getPhysicalList("9");
String selectedPhysicalSummary = request.getParameter("selectedPhysicalSummary");
%>
<%!
private ArrayList getCRMClientNEWSTARTRecord(String userName, String groupID) {	
	StringBuffer sqlStr = new StringBuffer();
		
	sqlStr.append("SELECT   TRUNC((SUM(N.CRM_NS_TOTAL))/(COUNT(N.CRM_NS_TOTAL))) , TO_CHAR(N.CRM_NS_CREATED_DATE, 'YYYY-MM-DD')  , COUNT(DISTINCT(C.CRM_USERNAME)), TO_CHAR(N.CRM_NS_CREATED_DATE -1, 'YYYY-MM-DD') ");
	sqlStr.append("FROM CRM_CLIENTS C, CRM_CLIENTS_NEWSTART N ");	
	sqlStr.append("WHERE C.CRM_CLIENT_ID(+) = N.CRM_CLIENT_ID ");
	sqlStr.append("AND N.CRM_NS_LEVEL IS NULL ");
	if(userName != null && userName.length()>0){
		sqlStr.append("AND N.CRM_CLIENT_ID = "+CRMClientDB.getClientID(userName)+" ");
	}
	if(groupID != null && groupID.length()>0){
		sqlStr.append("AND C.CRM_GROUP_ID = '"+groupID+"' ");
	}
	sqlStr.append("GROUP BY TO_CHAR(N.CRM_NS_CREATED_DATE, 'YYYY-MM-DD') , TO_CHAR(N.CRM_NS_CREATED_DATE -1, 'YYYY-MM-DD') ");
	
	sqlStr.append("ORDER BY TO_CHAR(N.CRM_NS_CREATED_DATE, 'YYYY-MM-DD') ASC");	
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}


private ArrayList getCRMClientEventRecord(String userName, String groupID) {	
	StringBuffer sqlStr = new StringBuffer();
		
	sqlStr.append("SELECT COUNT(E.CO_USER_ID),TO_CHAR(E.CO_CREATED_DATE, 'YYYY-MM-DD')  , COUNT(DISTINCT(E.CO_USER_ID)), TO_CHAR(E.CO_CREATED_DATE -1, 'YYYY-MM-DD') "); 
	sqlStr.append("FROM CO_ENROLLMENT E, CRM_CLIENTS C ");
	sqlStr.append("WHERE TO_CHAR(C.CRM_CLIENT_ID(+)) = E.CO_USER_ID ");
	sqlStr.append("AND E.CO_ATTEND_STATUS = 0 "); 
	sqlStr.append("AND E.CO_ENABLED = 1 "); 
	sqlStr.append("AND E.CO_MODULE_CODE = 'lmc.crm' ");
	if(userName!= null && userName.length()>0){
		sqlStr.append("AND E.CO_USER_ID = '"+CRMClientDB.getClientID(userName)+"' ");
	}
	if(groupID != null && groupID.length()>0){
		sqlStr.append("AND C.CRM_GROUP_ID = '"+groupID+"' ");
	}
	sqlStr.append("GROUP BY TO_CHAR(E.CO_CREATED_DATE, 'YYYY-MM-DD') , TO_CHAR(E.CO_CREATED_DATE -1, 'YYYY-MM-DD') "); 
	sqlStr.append("ORDER BY TO_CHAR(E.CO_CREATED_DATE, 'YYYY-MM-DD') ASC");	
		
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());

}

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
	
	.pageContentSummary {		
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
	<DIV id=contentFrame style="width:100%;height:100%">
			<%if(!isClientSummary){ %>
				<jsp:include page="../../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="Summary" />
					<jsp:param name="category" value="group.crm" />
					<jsp:param name="keepReferer" value="N" />
					<jsp:param name="isHideTitle" value="Y" />
				</jsp:include>
				<jsp:include page="title.jsp">
					<jsp:param name="title" value="Summary"/>
				</jsp:include>
				<form name="search_form" action="summary.jsp" method="post">
						<table cellpadding="0" cellspacing="5"
									class="contentFrameSearch" border="0">
									
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									User ID
								</td>
								<td class="infoData" width="70%">
									<input type="textfield" name="userID" value="<%=(userID==null?"":userID) %>" maxlength="100" size="50"> 
								</td>
							</tr>	
									
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									Client Group
								</td>
								<td class="infoData" width="70%">
								<select id="groupID" name="groupID">
									<jsp:include page="../../ui/clientGroupCMB.jsp" flush="false">
										<jsp:param name="groupID" value="<%=groupID %>" />
										<jsp:param name="allowEmpty" value="Y" />
									</jsp:include>
								</select>
								</td>
							</tr>
						
							<tr class="smallText">
								<td colspan="2" align="center">
									<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
									<button type="button" onclick="return clearSearch();"><bean:message key="button.clear" /></button>
								</td>
							</tr>
						</table>
				</form>
			<%} %>

				<table>
				<tr>
				<td>

				<div id="header"> 				
				
				<ul>
					<li name="summaryli" onclick="showPageSummary('newstartSummary')" id="list-newstartSummary"><a href="#page-newstartSummary">N.E.W.S.T.A.R.T</a></li>
					<li name="summaryli" onclick="showPageSummary('eventSummary')" id="list-eventSummary"><a href="#page-eventSummary">Event</a></li>
					<li name="summaryli" onclick="showPageSummary('physicalSummary')" id="list-physicalSummary"><a href="#page-physicalSummary">Physical Information</a></li>			
				</ul>								
				</div>
				</td>
				</tr>
				<tr>
				<td>
				<div style="margin-left:10px;width:90%;display:none;" class="pageContentSummary" id="page-newstartSummary" >
					
				</div>
				<div style="margin-left:10px;width:90%;display:none;" class="pageContentSummary" id="page-eventSummary" >
					
				</div>
				
				
				<div style="margin-left:10px;width:90%;display:none;" class="pageContentSummary" id="page-physicalSummary" >
					
					<form name='physicalForm' action='physical_info.jsp'>
					<label>Physical Figure: </label>
					<select id='physicalListSummary'>
<%

			ReportableListObject physicalSummary = null;
			for(int i = 0; i < physicalsSummary.size(); i++) {
				physicalSummary = (ReportableListObject)physicalsSummary.get(i);
%>
					<option id="<%=physicalSummary.getValue(2) %>" measure="<%=(physicalSummary.getValue(4).length()>0?physicalSummary.getValue(4):(physicalSummary.getValue(5).length()>0?physicalSummary.getValue(5):"")) %>" 
							<%=(selectedPhysicalSummary!= null && selectedPhysicalSummary.equals(physicalSummary.getValue(2)))?"selected":"" %>>
						<%=physicalSummary.getValue(3) %>
					</option>
					
<%
			}
%>
					</select>
					<br/><br/>
					<div id='physicalDivSummary'>
					
					</div>
					<br/>
					<div id="chartSummary-container" style="background-color:#e5e8eb;width:100%;padding:0 5px 5px 5px">
						<div id="chartSummary-title" style="font-size:18px; font-weight:bold;color:white;background-color:#6fa1d3;padding:5px">
							
						</div>
						<div id="physicalChartSummary" style="padding-right:50px;background-color:#b8dbff;">
						</div>
					</div>
					<input type="hidden" name="selectedPhysicalSummary" value=""/>
					<input type="hidden" name="command" value=""/>
					<input id="clientID" type="hidden" name="clientID" value="<%=userID%>"/>
					<input id="groupID" type="hidden" name="groupID" value="<%=groupID%>"/>
					</form>
					
					
				</div>
				</td>
				</tr>
				</table>
				
			
			</div>
</body>
</html:html>

<script language="javascript">
				var index;
				function showPageSummary(id){
					$('.pageContentSummary').hide();
					$('#page-'+id).show();
					
					$('li[name=summaryli]').attr('class','');
					$('#list-'+id).attr('class', 'selected');
					index = id;
				
					<%if((userID!= null && userID.length()>0) || (groupID != null && groupID.length()>0)){%>
					
					if(id=='newstartSummary'){						
						displayNEWSTARTGraph();
						
					}else if(id=='eventSummary'){	
						
						displayEventGraph();
						
					}else if(id=='physicalSummary'){
						$('input[name=selectedPhysicalSummary]').val('#physicalListSummary').find('option:selected').attr('id');
						displayPhysicalTableSummary($('#physicalListSummary').find('option:selected').attr('id'), $('#physicalListSummary').find('option:selected').attr('measure'));
						displayPhysicalGraphSummary($('select[id=physicalListSummary] :selected').val(), $('#physicalListSummary').find('option:selected').attr('measure'));
			
					}
					<%}%>
				}			
				
				
				function submitSearch() {
					document.search_form.submit();
				}
			
				function clearSearch() {
					$('input[name=userID]').val('');
					
					$('select#groupID :nth-child(1)').attr('selected', 'selected');
					
				}
			
				
				
				function displayNEWSTARTGraph(){				

					<%
					String minDate = "";
					int maxCount = 0;
					ArrayList pastNEWSTARTRecord = getCRMClientNEWSTARTRecord(userID,groupID);
				
					if(pastNEWSTARTRecord.size()>0){
					%>
						var line3=[
					<%
						
						for(int i=0;i<pastNEWSTARTRecord.size();i++){							
							ReportableListObject reportableListObject = (ReportableListObject) pastNEWSTARTRecord.get(i);
						
							if(pastNEWSTARTRecord.size() == 1 && i == 0){
					%>
								['<%=reportableListObject.getValue(3)%>',<%="0"%>],
					<%	
							}
							
							if(i==0)
								minDate = reportableListObject.getValue(1);
							if(i == pastNEWSTARTRecord.size()-1){							
					%>
								['<%=reportableListObject.getValue(1)%>',<%=reportableListObject.getValue(0)%>]			
					<%
							}else{
					%>
								['<%=reportableListObject.getValue(1)%>',<%=reportableListObject.getValue(0)%>],
					<%
							}
							
						}
					%>];
						
					<%if((groupID != null && groupID.length()>0)){%>
						var line4=[
						<%
							maxCount = 0;
							for(int i=0;i<pastNEWSTARTRecord.size();i++){							
								ReportableListObject reportableListObject = (ReportableListObject) pastNEWSTARTRecord.get(i);
								if(pastNEWSTARTRecord.size() == 1 && i == 0){
						 %>
							['<%=reportableListObject.getValue(3)%>',<%="0"%>],
						<%	
								}
										
								if(Integer.parseInt(reportableListObject.getValue(2)) > maxCount){
									maxCount = Integer.parseInt(reportableListObject.getValue(2));
								}
								if(i==0)
									minDate = reportableListObject.getValue(1);
								if(i == pastNEWSTARTRecord.size()-1){							
						%>
							['<%=reportableListObject.getValue(1)%>',<%=reportableListObject.getValue(2)%>]			
						<%
								}else{
						%>
							['<%=reportableListObject.getValue(1)%>',<%=reportableListObject.getValue(2)%>],
						<%
								}											
							}
							%>];
						<%}%>
					<%}else{%>return false;
					<%}%>		
				
					var plot2 = $.jqplot ('page-newstartSummary', [line3<%if((groupID != null && groupID.length()>0)){%>,line4<%}%>], {
					   
					      title: '健康貨幣記錄',
					      grid: {
					            drawBorder: false,
					            shadow: false,
					           
					        },
					      series: [					               
					               {
					                   color: 'rgba(44, 190, 160, 0.7)',					                  
					                   showMarker: true,
					                   showLine: true,
					                   fill: true,
					                   fillAndStroke: true,
					                   markerOptions: {
					                       style: 'filledCircle',
					                       size: 8,
					                       color: 'rgba(80,80,80,.6)'
					                   },
					                   rendererOptions: {
					                       smooth: true,					                      
					                   }						                  
					               }
					               <%if((groupID != null && groupID.length()>0)){%>
					               ,{yaxis:'y2axis'}
					               <%}%>
					           ],
					           
					      axes: {					      
					        xaxis: {
					          label: "日期",					         
					          pad: 0,
					          renderer:$.jqplot.DateAxisRenderer,
					          tickRenderer: $.jqplot.CanvasAxisTickRenderer,
					          numberTicks: <%=pastNEWSTARTRecord.size()>4?"5":pastNEWSTARTRecord.size() + 1%>,
					          tickOptions: {					        	 
				                   angle: 30,
				                   fontSize:'10pt',
				                    fontFamily:'Tahoma',
				                    showGridline: false
				                }
					         },
					      
					        yaxis: {
					          label: "健康貨幣",
					          max:40,
					          min:0
					        }
					        <%if((groupID != null && groupID.length()>0)){%>
					        ,
					        y2axis: {
					        	label: "參與人數",
						          max:<%=maxCount+4%>,
						          min:0					        
				            }
					        <%}%>
					      },
					      highlighter: {
					          show: true,
					          sizeAdjust: 7.5,
					          useAxesFormatters: true
					          		
					        },
					        cursor: {
					          show: false
					        }
						
					    });
					plot2.replot();
				}
				
				function displayEventGraph(){				

					<%
					minDate = "";
					int max = 0;
					
					ArrayList pastEventRecord = getCRMClientEventRecord(userID,groupID);
					
					if(pastEventRecord.size()>0){
					%>
						var line3=[
					<%
						
						for(int i=0;i<pastEventRecord.size();i++){							
							ReportableListObject reportableListObject = (ReportableListObject) pastEventRecord.get(i);
							if(pastEventRecord.size() == 1 && i == 0){
					%>
						['<%=reportableListObject.getValue(3)%>',<%="0"%>],
					<%	
							}
							
							if(Integer.parseInt(reportableListObject.getValue(0)) > max){
								max = Integer.parseInt(reportableListObject.getValue(0));
							}
							if(i==0)
								minDate = reportableListObject.getValue(1);
							if(i == pastEventRecord.size()-1){							
					%>
								['<%=reportableListObject.getValue(1)%>',<%=reportableListObject.getValue(0)%>]			
					<%
							}else{
					%>
								['<%=reportableListObject.getValue(1)%>',<%=reportableListObject.getValue(0)%>],
					<%
							}
							
						}
					%>];
						<%if((groupID != null && groupID.length()>0)){%>
						var line4=[
					<%
							maxCount = 0;
							for(int i=0;i<pastEventRecord.size();i++){							
							ReportableListObject reportableListObject = (ReportableListObject) pastEventRecord.get(i);
							if(pastEventRecord.size() == 1 && i == 0){
					%>
						['<%=reportableListObject.getValue(3)%>',<%="0"%>],
					<%	
							}
							if(Integer.parseInt(reportableListObject.getValue(2)) > maxCount){
								maxCount = Integer.parseInt(reportableListObject.getValue(2));
							}
							if(i==0)
								minDate = reportableListObject.getValue(1);
							if(i == pastEventRecord.size()-1){							
					%>
						['<%=reportableListObject.getValue(1)%>',<%=reportableListObject.getValue(2)%>]			
					<%
							}else{
					%>
						['<%=reportableListObject.getValue(1)%>',<%=reportableListObject.getValue(2)%>],
					<%
							}			
						}
					%>];
						<%}%>
					<%}else{%>
					return false;
					<%}%>		
				
					var plot2 = $.jqplot ('page-eventSummary', [line3<%if((groupID != null && groupID.length()>0)){%>,line4<%}%>], {
					      title: 'Event 記錄',
					      grid: {
					            drawBorder: false,
					            shadow: false,
					      },
					      series: [					               
					               {
					            	   color: 'rgba(44, 190, 160, 0.7)',					                  
					                   showMarker: true,
					                   showLine: true,
					                   fill: true,
					                   fillAndStroke: true,
					                   markerOptions: {
					                       style: 'filledCircle',
					                       size: 8,
					                       color: 'rgba(80,80,80,.6)'
					                   },
					                   rendererOptions: {
					                       smooth: true,					                      
					                   }						                  
					               }						               
					               <%if((groupID != null && groupID.length()>0)){%>
					               ,{yaxis:'y2axis'}
					               <%}%>
					               
					           ],		   
					      axes: {					      
					        xaxis: {
					          label: "日期",					         
					          pad: 0,
					        
					          renderer:$.jqplot.DateAxisRenderer,
					          tickRenderer: $.jqplot.CanvasAxisTickRenderer,
					          numberTicks: <%=pastEventRecord.size()>4?"5":pastEventRecord.size()+1%>,
					        		  
					          tickOptions: {					        	 
					        	  angle: 30,
				                   fontSize:'10pt',
				                    fontFamily:'Tahoma',
				                    showGridline: false
				                }		
					        
					        },
					        yaxis: {
					          label: "註冊數目",
					          max:<%=max + 2%>,
					          min:0,	
					        
					        }
					        <%if((groupID != null && groupID.length()>0)){%>
					        ,
					        y2axis: {
					        	label: "參與人數",
						          max:<%=maxCount+4%>,
						          min:0					        
				            }
					        <%}%>
					      },
					      
					      highlighter: {
					          show: true,
					          sizeAdjust: 7.5,
					          useAxesFormatters: true
					          		
					        },
					        cursor: {
					          show: false
					        }
					    });
					plot2.replot();
				}
							
				<%if(!isClientSummary){%>
				$(document).ready(function(){		
					showPageSummary('newstartSummary');
					
				});
				<%}%>
				
				
				
				
				
				
				
				
				

				$(document).ready(function(){		
					
					$('#physicalListSummary').change(function(){
						$('input[name=selectedPhysicalSummary]').val($(this).find('option:selected').attr('id'));
						displayPhysicalTableSummary($(this).find('option:selected').attr('id'), $(this).find('option:selected').attr('measure'));
						displayPhysicalGraphSummary($('select[id=physicalListSummary] :selected').val(), $(this).find('option:selected').attr('measure'));
					}).trigger('change');
					
					$(window).resize(function() {
						if($('#physicalChartSummary').children().length > 0){
							graphSummary.replot();
						}
					});
				});
												
				var graphSummary;						
				
				function displayPhysicalTableSummary(figureID, measure){
					var patNo = 'patNo=';
					$('#physicalDivSummary').html('');
					var baseUrl ='../../crm/portal/physical_table.jsp';
					var url = baseUrl  ;	
					
					$.ajax({
						url: url,
						async:false,
						cache:false,
						data: "figureID="+figureID+'&measure='+encodeURIComponent(measure)+'&clientID='+$('input[id=clientID]').val()+'&displayOnly=Y'+'&dataName=physicalSummary-data'+'&groupID='+$('input[id=groupID]').val(),
						success: function(values){				
							$('#physicalDivSummary').html(values);
						},
						error: function() {					
							alert('Error occured while creating table.');
						}
					});
				}
				
				function getPhysicalDataSummary() {
					var date = new Array();
					var value = new Array();
					var dataSet = new Array();

					$('.physicalSummary-data-date').each(function(i, v) {
						date.splice(date.length, 0, $(v).html());
					});
					
					$('.physicalSummary-data-value').each(function(i, v) {
						value.splice(value.length, 0, $(v).html());
					});
					
					for(var i = 0; i < date.length; i++) {
						dataSet.splice(dataSet.length, 0, [date[i], value[i]]);
					}
					return dataSet;
				}
				
				function displayPhysicalGraphSummary(title, measure){	
					
					$('#chartSummary-title').html(title);
					$('#physicalChartSummary').width($('#chartSummary-title').width()*0.97-5);
					if($('#physicalChartSummary').children().length > 0){
						graphSummary.destroy();
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
					
					
					var line1 = getPhysicalDataSummary();
					var today = new Date();
					
					if(line1.length > 0) {
						graphSummary = 
							$.jqplot('physicalChartSummary', [line1], {
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
