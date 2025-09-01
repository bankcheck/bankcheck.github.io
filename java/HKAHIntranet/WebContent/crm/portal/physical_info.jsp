<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%
UserBean userBean = new UserBean(request);
ArrayList physicals = CRMPhysicalDB.getPhysicalList("9");

String selectedPhysical = request.getParameter("selectedPhysical");
String command = request.getParameter("command");

String msg = "";

if(command != null && command.equals("add")) {
	String value = request.getParameter("phyValue");
	String phyDate = request.getParameter("phyDate");			
	if(CRMClientPhysical.addByClient(userBean, CRMClientDB.getClientID(userBean.getLoginID()),
						"2", "1", selectedPhysical, value,phyDate)) {
		msg = "Save Successfully.";
	}
	else {
		msg = "Error in saving.";
	}
}else if(command != null && command.equals("delete")){
	String eventID = request.getParameter("eventID");
	String scheduleID = request.getParameter("scheduleID");
	String userType = request.getParameter("userType");
	String userID = request.getParameter("userID");
	String figureID = request.getParameter("figureID");
	String recordCount = request.getParameter("recordCount");
	
	if(CRMClientPhysical.deleteByClient(userBean, eventID,scheduleID,figureID,userType,userID,recordCount)) {
		msg = "Delete Successfully.";
	}
	else {
		msg = "Error in deleting.";
	}
}

%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.jqplot.css" />"/>
	<body>
	<DIV id=contentFrame style="width:100%;height:100%">
		<jsp:include page="title.jsp" flush="false">
			<jsp:param name="title" value="Physical Information" />
		</jsp:include>
		
		<div style="background-color:blue;width:20%;">
			<font style="color:yellow;font-weight:bold;"><%=msg %></font>
		</div>
		<br/>
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
			<div id="chart-container" style="background-color:#e5e8eb;width:97%;padding:0 5px 5px 5px">
				<div id="chart-title" style="font-size:18px; font-weight:bold;color:white;background-color:#6fa1d3;padding:5px">
					
				</div>
				<div id="physicalChart" style="padding-right:50px;background-color:#b8dbff">
				</div>
			</div>
			<input type="hidden" name="selectedPhysical" value=""/>
			<input type="hidden" name="command" value=""/>
			
			<input type="hidden" name="eventID" value=""/>
			<input type="hidden" name="scheduleID" value=""/>
			<input type="hidden" name="userType" value=""/>
			<input type="hidden" name="userID" value=""/>
			<input type="hidden" name="figureID" value=""/>
			<input type="hidden" name="recordCount" value=""/>
		</form>
		</DIV>
	</body>

	<script>
	var graph;
	$(document).ready(function(){
		$('#physicalList').change(function(){
			$('input[name=selectedPhysical]').val($(this).find('option:selected').attr('id'));
			displayPhysicalTable($(this).find('option:selected').attr('id'), $(this).find('option:selected').attr('measure'));
			displayPhysicalGraph($('select[id=physicalList] :selected').val(), $(this).find('option:selected').attr('measure'));
		}).trigger('change');
		
		$(window).resize(function() {
			if($('#physicalChart').children().length > 0){
				graph.replot();
			}
		});
		
		
		initScroll('.scroll-pane');
	});
	
	function submitAction(command) {
		
		$('input[name=command]').val(command);	
		
		if (!validDate(document.physicalForm.phyDate)) {
			alert('Invalid Date. (Format:DD/MM/YYYY)');
			
			return false;
		}
		$('form[name=physicalForm]').submit();
		
	}
	
	function displayPhysicalTable(figureID, measure){
		var patNo = 'patNo=';
		$('#physicalDiv').html('');
		var baseUrl ='../../crm/portal/physical_table.jsp';
		var url = baseUrl  ;	
		
		$.ajax({
			url: url,
			async:false,
			cache:false,
			data: "figureID="+figureID+'&measure='+encodeURIComponent(measure),
			success: function(values){				
				$('#physicalDiv').html(values);
			},
			error: function() {					
				alert('Error occured while creating table.');
			}
		});
		
		$('input').filter('.datepickerfield').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../../images/calendar.jpg" });
		
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
	
	function removePhydata(obj){
	  var removePhydata = confirm("Delete record?");
		if( removePhydata == true ){	
			$('input[name=command]').val('delete');		
			$('input[name=eventID]').val($(obj).attr('eventID'));		
			$('input[name=scheduleID]').val($(obj).attr('scheduleID'));		
			$('input[name=userType]').val($(obj).attr('userType'));
			$('input[name=userID]').val($(obj).attr('userID'));
			$('input[name=figureID]').val($(obj).attr('figureID'));
			$('input[name=recordCount]').val($(obj).attr('recordCount'));		
			$('form[name=physicalForm]').submit();
		}
	}
	</script>
</html:html>