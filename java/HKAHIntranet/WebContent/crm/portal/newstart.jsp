<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.crm.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
UserBean userBean = new UserBean(request);
ArrayList crmTestRecord = getCRMClientDoneTodayTest(userBean.getUserName());
boolean clientTodayTestDone = false;
if(crmTestRecord.size()>0){
	clientTodayTestDone = true;
}
%>
<%!
private static String getCRMNewstartTotal(String userName) {
	ArrayList result = UtilDBWeb.getReportableList("SELECT CRM_NS_TOTAL FROM CRM_CLIENTS_NEWSTART WHERE CRM_USERNAME = '"+userName+"' AND CRM_NS_LEVEL IS NULL");
	String totalString = "尚未有任何記錄";
	String color = "<span style='font-weight:bold;color:red'>";
	if(result.size() > 0){
		int total = 0;
		int count = 0;
		for(int i = 0;i< result.size();i++){		
			ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
			total = total + Integer.parseInt(reportableListObject.getValue(0));		
			count++;		
		}	
	
		total = total / count;
		String status = "";
		if(total< 20){
			status = "有待改善";
			color="<span style='font-weight:bold;color:red'>";
		}else if(total < 26){
			status = "一般";
			color="<span style='font-weight:bold;color:#FFB163'>";
		}else if(total < 36){
			status = "好";
			color="<span style='font-weight:bold;color:#0AEB0A'>";
		}else if(total < 41){
			status = "非常好";
			color="<span style='font-weight:bold;color:green'>";
		}
		totalString = Integer.toString(total) +  " 個貨幣 ("+status+")";
	}
	return color + totalString + "</span>";
}

private ArrayList getCRMClientDoneTodayTest(String userName) {	
	ArrayList result = UtilDBWeb.getReportableList("SELECT * FROM CRM_CLIENTS_NEWSTART WHERE CRM_USERNAME = '"+userName+"'	AND TO_CHAR(CRM_NS_CREATED_DATE, 'DD/MM/YYYY') = TO_CHAR(SYSDATE, 'DD/MM/YYYY') AND CRM_NS_LEVEL IS NULL ");
	
	return result;
}

private ArrayList getCRMClientPastRecord(String userName) {	
	return UtilDBWeb.getReportableList("SELECT CRM_NS_TOTAL FROM CRM_CLIENTS_NEWSTART WHERE CRM_USERNAME = '"+userName+"' AND CRM_NS_LEVEL IS NULL ORDER BY CRM_NS_CREATED_DATE DESC");
}

private String getCRMNewstartLevel(String userName) {		
	ArrayList levelRecord = UtilDBWeb.getReportableList("SELECT CRM_NS_LEVEL FROM CRM_CLIENTS_NEWSTART WHERE CRM_USERNAME = '"+userName+"' AND CRM_NS_LEVEL IS NOT NULL ");
	String level;
	if (levelRecord.size() > 0) {				
		ReportableListObject row = (ReportableListObject) levelRecord.get(0);
		level = row.getValue(0);				
	}else{
		level = "0";
	}
	return level;
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
	<style>
		.food{
		background-color:#FFB163;
		text-align:right;
		}
		.temperance{
		background-color:#FF9696;
		text-align:right;
		}
		.exercise{
		background-color:#FF5050;
		text-align:right;
		}
		.air{
		background-color:#0AEB0A;
		text-align:right;
		}
		.water{
		background-color:#1EA7EB;
		text-align:right;
		}
		.rest{
		background-color:#D7A0D7;
		text-align:right;
		}
		.sunlight{
		background-color:#EEEE6E;
		text-align:right;
		}
		.trust{
		background-color:#D2E1BD;
		text-align:right;
		}
	</style>

<jsp:include page="header.jsp"/>
<body>
	<div id="indexWrapper" style='width:100%'>
		<div id="mainFrame" style='width:100%'>
			<div id="contentFrame" style='width:100%'>
				<jsp:include page="../../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="N.E.W.S.T.A.R.T" />
					<jsp:param name="category" value="group.crm" />
					<jsp:param name="keepReferer" value="N" />
					<jsp:param name="isHideTitle" value="Y" />
				</jsp:include>
				<jsp:include page="title.jsp">
					<jsp:param name="title" value="N.E.W.S.T.A.R.T"/>
				</jsp:include>
			
				<table border='0' width="100%">
				<tr>
					<td style="background-color:#E0E0E0;font-size:180%;font-weight:bold"colspan='6'>
					健康銀行向您提供八種儲蓄健康的貨幣以供選擇，分別是：
					</td>							
				</tr>
				<tr>
					
					<td class="food" width="15%">飲食貨幣  (Nutrition)&nbsp;</td>
					<td class="infoData" width="35%">另類飲食實踐</td>			
					
					<td class="temperance" width="15%">節制貨幣 (Temperance)&nbsp;</td>
					<td class="infoData" width="35%">擁有能掌控生活的態度</td>	
				</tr>
				<tr>
					
					<td class="exercise">運動貨幣 (Exercise)&nbsp;</td>
					<td class="infoData">持久運動，促進血液循環</td>			
					<td class="air">空氣貨幣 (Air)&nbsp;</td>
					<td class="infoData">能活化細胞改善身體機能</td>	
				</tr>
				<tr>				
					<td class="water">飲水貨幣 (Water)&nbsp;</td>
					<td class="infoData">洗滌身心靈</td>			
			
					<td class="rest">休息貨幣 (Rest)&nbsp;</td>
					<td class="infoData">能修復受損的細胞</td>	
				</tr>
				<tr>
				
					<td class="sunlight">陽光貨幣 (Sunlight)&nbsp;</td>
					<td class="infoData">減輕憂鬱並強化骨骼</td>			
				
					<td class="trust">信靠貨幣 (Trust)&nbsp;</td>
					<td class="infoData">為永恆作投資</td>	
				</tr>
				<tr><td>&nbsp;</td></tr>				
				<tr>
					<td colspan="2" >
						<table border="0">
							<tr>
								<td style="background-color:#E0E0E0;font-weight:bold" colspan="4">你所實踐的健康生活模式總額為：</td>
							</tr>
							<tr>
								<td style="text-align:center;background-color:#E0E0E0">40 – 36 個貨幣</td>
								<td style="text-align:center;background-color:#E0E0E0">35 - 26 個貨幣</td>
								<td style="text-align:center;background-color:#E0E0E0">25 – 20 個貨幣</td>
								<td style="text-align:center;background-color:#E0E0E0">20 – 0 個貨幣</td>
							</tr>
							<tr>
								<td style="text-align:center;background-color:#F7ECEC;color:green">非常好</td>
								<td style="text-align:center;background-color:#F7ECEC;color:#0AEB0A">好</td>
								<td style="text-align:center;background-color:#F7ECEC;color:#FFB163">一般</td>
								<td style="text-align:center;background-color:#F7ECEC;color:red">有待改善</td>
							</tr>
							<tr>
								<td style="text-align:right"colspan="4">(以每日平均累積貨幣計算)</td>
							</tr>
						</table>
					</td>					
				</tr>
					
				<tr>
					<td colspan="3">
				<%if(clientTodayTestDone){ %>
					<div style="color:green;font-weight:bold">[ 已完成今天健康測試 ]</div>
				<%}else{ %>		
					<button  onclick="elearningTest()" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
													尚未完成今天健康測試
					</button>
				<%} %>
					</td>
					
				</tr>
				<tr>
					<td colspan="2">
						<table border="0">
							<tr>
								<td width="30%"style="background-color:#E0E0E0;text-align:center" width="30%">你的健康貨幣總額為&nbsp;</td>							
								<td width="30%"style="background-color:#F7ECEC;text-align:center"><%=getCRMNewstartTotal(userBean.getUserName()) %></td>
								<td width="40%">&nbsp;</td>
							</tr>
						</table>
					</td>
					
					<td  colspan="2">
						<table border="0">					
							<tr>
								<td width="60%">&nbsp;</td>
								<td width="20%"style="background-color:#E0E0E0;text-align:center" width="">Level&nbsp;</td>			
								<td width="20%"style="background-color:#F7ECEC;text-align:center;font-weight:bold"><%=getCRMNewstartLevel(userBean.getUserName()) %></td>
							</tr>
						</table>
					</td>
				</tr>
				</table>
				<div style="margin-left:10px;width:50%" id="chart3" >
					
					</div>
				
				<script language="javascript">
				function elearningTest(eid) {
					callPopUpWindow('../../crm/portal/newstart_record.jsp');
					/*
					$.ajax({
						url:'../../crm/portal/newstart_record.jsp',
						async: false,
						cache: false,
						success: function(value) {
							$('div#newstart_record').html(value);
						},
						error: function() {
							alert("Error: get page of newstart record.");
						}
					});
					*/
				}
				

				function displayPhysicalGraph(){
				
					<%
					ArrayList pastNEWSTARTRecord = getCRMClientPastRecord(userBean.getUserName());
					if(pastNEWSTARTRecord.size()>0){
					%>
						var line3=[[0,0],
					<%
						ArrayList<String>total = new ArrayList<String>();					
						for(int i=0;i<pastNEWSTARTRecord.size();i++){							
							ReportableListObject reportableListObject = (ReportableListObject) pastNEWSTARTRecord.get(i);
							total.add(reportableListObject.getValue(0));
							
							if(i == 6){
								break;
							}
						}
						
						for(int i = 0;i < total.size();i++){
							if(i == pastNEWSTARTRecord.size()-1){							
					%>
								[<%=i+1%>,<%=total.get(total.size()-1-i)%>]			
					<%
							}else{
					%>
								[<%=i+1%>,<%=total.get(total.size()-1-i)%>],
					<%
							}
							
						}
					%>];<%
					}else{					
					%>return false;<%
					}
					%>					
						
				
					var plot2 = $.jqplot ('chart3', [line3], {
					   
					      title: '健康貨幣記錄 (顯示最新的 7 個記錄)',
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
					           ],		   
					      axes: {					      
					        xaxis: {
					          label: "記錄",					         
					          pad: 0,
					          max:7,
					          tickOptions: {
				                  showGridline: false
				                }				              
					        },
					        yaxis: {
					          label: "健康貨幣",
					          max:40
					        }
					      },
					      highlighter: {
					          show: true,
					          sizeAdjust: 7.5,
					          formatString:'<table border="0" style="width:50px" class="jqplot-highlighter"><tr><td>記錄:</td><td>%s</td></tr><tr><td>貨幣:</td><td>%s</td></tr></table>'
					        },
					        cursor: {
					          show: false
					        }
						
					    });
				}
				
				$(document).ready(function(){				
					displayPhysicalGraph();
					
					});
				
				</script>
			</div>
		</div>
	</div>
</body>
</html:html>