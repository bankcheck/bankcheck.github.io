<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.web.common.*"%>
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

<html>
<meta http-equiv="refresh" content=1200>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<head>
<style>
	#logo {
		position:absolute; 
		left:20px; 
		top:10px; 
		width:28px; 
		height:28px; 
		background-image:url(../images/hkah_portal_logo.gif);
	}
	#title {
		position:absolute;
		left:60px; 
		top:10px;
		font-size:24px;
		font-weight:bold;
		color:#007662;
	}
	.changeMode {
		cursor:pointer;
	}
	#scheduleTable {
		position:absolute;
		top:50px;
		left:20px; 
		border-style:outset; 
		border-width:1px;
	}
	#scheduleTable tr td{
		font-family: "Arial", "Verdana", "sans-serif"; 
		font-size:12px; 
		width:170px;
		border-style:outset; 
		border-width:1px;
		background-color:#E3E3E3;
		valign:top;
	}
	#scheduleTable tr {
		height:50px;
	}
	.weekCol {
		width:80px!important;
		text-align:center;
		font-weight:bold;
	}
	.timeCol {
		width:40px!important;
		text-align:center;
		font-weight:bold;
	}
	.dayRow td{
		text-align:center;
		font-weight:bold;
		background-color:#FFB43B!important;
	}
	.dayRow {
		height:20px!important;
	}
	.schContent {
		line-height:150%;
		color:black!important;
	}
	.contentNum {
		font-weight:bold;
		color:#C31BCC;
	}
	.nextBtn {
		cursor:pointer;
	}
	.am {
		background-color:#FAD7D7!important;
	}
	.pm {
		background-color:#B6C6FA!important;
	}
	.today {
		background-color:#FAFF5C!important;
		border-style:outset; 
		border-width:1px;
	}
	.sunday {
		color:red;
	}
	.dateNum {
		font-size:16px!important;
	}
</style>
</head>
	<body>
		<div>
			<div id="logo"></div>
			<div id="title" class="changeMode">CCIC Schedule</div>
			<div style="position:absolute;left:250px;width:980px;">
				<table width="100%">
					<tbody>
						<tr>
							<td width="15%" align="left">
								<button type="button" onclick="prevMonth()" id="prevBtn" 
									class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
									<< Prev
								</button>
							</td>
							<td width="70%" align="center" class="today scheduleHead">
								&nbsp;
							</td>
							<td width="15%" align="right">
								<button type="button" onclick="nextMonth()" id="nextBtn" 
									class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
									Next >>
								</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div id="scheduleTable">
		</div>
		
		<script>
			var addMonth = 0;
			var defaultMode = 1;
			
			$(document).ready(function() {
				getSchedule();
				manageSchContent();
				nextBtnEvent();
				displayModeEvent();
			});
			
			function displayModeEvent() {
				$('.changeMode').unbind('click');
				$('.changeMode').click(function() {
					if (defaultMode) {
						$('.schContent').css('display', '');
						$('.contentControl').css('display', 'none');
						
						defaultMode = 0;
					}
					else {
						manageSchContent();
						$('.contentControl').css('display', '');
						
						defaultMode = 1;
					}
				});
			}
			
			function prevMonth() {
				addMonth--;
				getSchedule();
			}
			
			function nextMonth() {
				addMonth++;
				getSchedule();
			}
			
			function getSchedule() {
				if (addMonth == 0) {
					$('#prevBtn').css('display', 'none');
					$('#nextBtn').css('display', '');
				}
				else {
					$('#prevBtn').css('display', '');
					$('#nextBtn').css('display', 'none');
				}
				
				$.ajax({
					url: "ccic_schedule_data.jsp",
					data: "addMonth="+addMonth,
					async: false,
					cache: false,
					success: function(values){
						$('#scheduleTable').html(values);
						$('.scheduleHead').html($('#todayInfo').html());
						$('#todayInfo').remove();
						
						if (defaultMode) {
							manageSchContent();
						}
						else {
							$('.contentControl').css('display', 'none');
						}
						nextBtnEvent();
						displayModeEvent();
					}//success
				});//$.ajax
			}
			
			function manageSchContent() {
				$.each($("td.schContentCell"), function(i, v) {
					if ($(v).find('.schContent').length > 0) {
						$(v).find('.contentNum').html($(v).find('.schContent').length);
						$.each($(v).find('.schContent'), function(j, v2) {
							if (j !== 0) {
								$(v2).css('display', 'none');
							}
							else {
								$(v2).addClass('show');
							}
						});
					}
				});
			}
			
			function nextBtnEvent() {
				$('div.nextBtn').unbind('click');
				$('div.nextBtn').click(function() {
					var schContentCell = $(this).parent().parent();
					var target = schContentCell.find('.show').next();
					var displayedContent = schContentCell.find('.show');
					
					if (!target.hasClass('schContent')) {
						target = schContentCell.find('.schContent:first');
					}

					displayedContent.removeClass('show');
					displayedContent.css('display', 'none');
					
					target.addClass('show');
					target.css('display', '');
				});
			}
		</script>
	</body>
</html>
</html:html>