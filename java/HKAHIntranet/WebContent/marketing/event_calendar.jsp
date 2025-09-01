<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>


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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>

<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/w3.hkah.css" />" />

  <link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/fullcalendar.min.css" />" />   
  <link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/fullcalendar.print.css" />" media="print" />
  <link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery-clockpicker.min.css" />" />    

 <script type="text/javascript" src="jquery-1.9.1.min.js"></script>
 <script type="text/javascript" src="<html:rewrite page="/js/jquery-ui.min.js" />"></script>
 <script type="text/javascript" src="<html:rewrite page="/js/jquery-migrate-1.4.1.js" />"></script>
 <script type="text/javascript" src="<html:rewrite page="/js/clockpicker.js" />"></script>

  <script type="text/javascript" src="<html:rewrite page="/js/moment.min.js" />" /></script>
  <script type="text/javascript" src="<html:rewrite page="/js/fullcalendar.min.js" />" /></script>
  <script type="text/javascript" src="<html:rewrite page="/js/jquery.form.js" />" /></script>
  <script type="text/javascript" src="<html:rewrite page="/js/ui.datepicker.js" />" /></script>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
UserBean userBean = new UserBean(request);
String commandType = request.getParameter("commandType");
	if (("".equals(commandType) || commandType == null) && !userBean.isAccessible("function.mkt.event.calendar.create")) {
		commandType = "view";
	}
	String title = null;
	// set submit label
	title = "Marketing Event ";
	
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.admin" />
	<jsp:param name="mustLogin" value="false" />
</jsp:include>
<div id="calendar"></div> 
  <div id="eventModal" class="w3-modal eventModal">
    <div class="w3-modal-content w3-card-4 w3-animate-zoom eventMContent " style="max-width:650px">
      <div class="w3-center ah-grey ">
        <span onclick="document.getElementById('eventModal').style.display='none'" style="max-height:36px;"class="w3-button  w3-hover-red w3-display-topright" title="Close Modal">&times;</span>
        <span class="eventAction w3-xlarge"/>
      </div>
      <% if ("view".equals(commandType)) { %>
	   <p class="w3-text-blue"><b>Type</b></p>
	   <p  id="viewType"/>
	   <p class="w3-text-blue"><b>Title</b></p>
	   <p  id="viewTitle"/>
	   	<p class="w3-text-blue"><b>Venue</b></p>
	   <p  id="viewVenue"/>
	   <p class="w3-text-blue"><b>Description</b></p>
	   <p  id="viewDesc"/>
	   <p class="w3-text-blue"><b>Date/Time</b></p>
	   <p  id="viewDate"/>
	   <p class="w3-text-blue"><b>Attachment</b></p>
	   <p  id="viewAttachment"/>
	<%} else { %> 
        <div class="w3-container">
        <label><b>Type</b></label>
	        <select class="w3-select w3-border" id="eventType">
				<jsp:include page="../ui/mktEventCMB.jsp" flush="false"/>
			</select>
          <label><b>Event title</b></label>
          <input class="w3-input w3-border w3-margin-bottom" type="text" placeholder="Please enter event title" id="eventTitle" />
           <label><b>Description</b></label>
           <textarea class="w3-input w3-border w3-padding" style="resize:none" id="eventDesc"></textarea>
           <span class="w3-container" style="padding-bottom: 10px;">
	           <label><b>Venue</b></label>
	           <select class="w3-select w3-border"  name="venue" id="venue">
					<option value="">----- Please select Venue -----</option>
						<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
							<jsp:param name="moduleCode" value="booking" />
						</jsp:include>
				</select>
			</span>
           <span class="w3-container  w3-padding" id="dateRange_indicator">
	           	<label><b>Date</b></label>			
				<input type="text"   name="eventDate" id="eventDate" class="datepickerfield " value="" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>	
			</span>
			<span class="w3-container"id="time_indicator">			
			<label><b>From</b></label>
			<span><input type="text" id="eventFromTime" value="" size="8" onkeyup="validTimeWithoutSec(this)" onblur="validTimeWithoutSec(this)"/>
	        <button type="button" class="input-group-addon dashicons-clock"><img src="../images/time.png" height="25" width="25"/></button></span>
<%-- 			<jsp:include page="../ui/timeCMB.jsp" flush="false">
				<jsp:param name="label" value="eventFrom" />
				<jsp:param name="time" value="<%=DateTimeUtil.getCurrentTime() %>" />
				<jsp:param name="interval" value="30" />
			</jsp:include> --%>
			<label><b>To</b></label>
			<span><input type="text" id="eventToTime" value="" size="8" onkeyup="validTimeWithoutSec(this)" onblur="validTimeWithoutSec(this)"/>
	        <button type="button" class="input-group-addon dashicons-clock"><img src="../images/time.png" height="25" width="25"/></button></span>
			<%-- <jsp:include page="../ui/timeCMB.jsp" flush="false">
			<jsp:param name="label" value="eventTo" />
				<jsp:param name="time" value="<%=DateTimeUtil.getCurrentTime() %>" />
				<jsp:param name="interval" value="30" />
			</jsp:include> --%>
			</span>
			<span id="updateFile"></span>			                  
			<form id="uploadFile"  action="fileUpload.jsp" method="post" enctype="multipart/form-data" style="display:none;">
			        <div id="upFButton">
			        <input type="file" class="fupload" name="upFile" id="upFile" size="30" />
			        <button class="w3-button w3-tiny w3-black fupload" id="upFileSub" name="upFileSub" type="submit">upload</button>
			        </div>
			        <input type="hidden" class="fupload" name="keyID" id="keyID" value=""/>
				        <div class="progress">
					        <div class="percent fupload">0%</div >
					    </div>
			</form>        
			
	<input type="hidden" id="enrollID"/>		 
	<input type="hidden" id="memEventID"/></br>
	<span class="w3-container" id="RecurContainer">
	</br>
		<input type="checkbox" id="isRecur" value="Y" style="display:none;" checked>Recurrence</input>
			<span class="recur" id="recurElement" >
		    <select id="recurType" >
		    	<option value=""></option> 
				<option value="A">Every</option> 
				<option value="0">First</option>
				<option value="1">Second</option>
				<option value="2">Thrid</option>
				<option value="3">Fourth</option>				
			</select>
		    <select id="recurWeekDay">
		    	<option value=""></option> 
				<option value="MONDAY">Monday</option> 
				<option value="TUESDAY">Tuesday</option>
				<option value="WEDNESDAY">Wednesday</option>
				<option value="THURSDAY">Thursday</option>
				<option value="FRIDAY">Friday</option>
			</select>
			to (DD/MM/YYYY)
			<input type="text" placeholder="Please enter End Day"  name="rEndDay" id="rEndDay" class="datepickerfield" value="" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
		</span>        
	</span>	
	<button class="w3-button w3-block w3-green w3-section w3-padding"  id="createEvent">Create Event</button> 	
  	<button class="w3-button  w3-orange w3-section w3-padding  w3-left" style="width:30%" id="updateEvent">Update Event</button>   
  	<button class="w3-button  w3-purple w3-section w3-padding  w3-right" style="width:20%" id="copyEvent">Copy Event</button>    
    </div>
      <div class="w3-container w3-border-top w3-padding-16 w3-light-grey">
        <button onclick="document.getElementById('eventModal').style.display='none'" type="button" class="w3-button w3-red w3-right cancelButton">Close</button>
      	<button class="w3-button  w3-red"  style="width:30%" id="deleteEvent">Delete Event</button>
      </div>
   	<%} %>
    </div>
  </div>

 <div id="confirmDialog" class="w3-modal" >
    <div class="w3-modal-content" style="max-width:300px; position: absolute;top: 30%;left: 40%;">
      <header class="w3-container w3-teal"> 
        <span onclick="document.getElementById('confirmDialog').style.display='none'" 
        class="w3-button w3-display-topright">&times;</span>
        <h6>Confirm?</h6>
      </header>
      <div class="w3-container">
        <h5><span id="actMsg" keyid="" docid=""/></h5>
      </div>
      <footer class="w3-container ">
        <p class="w3-padding">
        <button onclick="eventActionConfirm();" class="w3-button w3-pink w3-padding">Yes</button>
        <button id="confirmCancelButton" onclick="eventActionCancel();" class="w3-button w3-dark-grey w3-padding">No</button>
        </p>
      </footer>
    </div>
  </div>
  
</div>
<script language="javascript">

$(document).ready(function() {
		$( "#calendar" ).fullCalendar({
	  		header: { 
	  			left: "prev,next today addEventButton todayEvent", 
	  			center: "title", 
	  			right: "agendaWeek,month,listMonth"
	  		},
	  		customButtons: {
	  		    addEventButton: {
	  		      text: 'Add Event',
	  		      click: function() {
	  		    	document.getElementById('uploadFile').style.display='none';	
	  		    	clear_form_elements('fupload');
	  		    	$('.percent').html('');
	  		    	
	  		    	setInputDisableSts(false,'eventModal');
	  		    	clear_form_elements('eventModal');
	  		    	$(".eventAction").html('Add Event');
	  		    	
	  		    	$("#deleteEvent").hide();
	  		    	$("#updateEvent").hide();
	  		    	$("#createEvent").show();
	  		    	/* $("#copyEvent").hide(); */
	  		    	
	  		    	$('#eventModal').show();
	  		    	$("#RecurContainer").show();
	          	  $('.eventMContent').draggable(); 
	  		      }
	  		    },
	  		    todayEvent: {
		  		      text: 'Today Event Page',
		  		      click: function() {
		  		    	window.open('todayEvent.html', '_blank');
		  		      }
		  		    }
	  		  },
	  		weekends: true, 
	  		editable: false,
	  		displayEventEnd:true,
	  		handleWindowResize:true,
	  		eventLimit: true, // for all non-TimeGrid views
	  	  views: {
	  		month: {
	  	      eventLimit: 3 
	  	    }
	  	  },
	  		 contentHeight: 700, 
	  		timeFormat: 'H:mm',
	        events: {
	            url: 'getEvent.jsp?callback=?',
	            method: 'POST',
	            extraParams: {
	              custom_param1: 'something',
	              custom_param2: 'somethingelse'
	            },
	            failure: function() {
	              alert('there was an error while fetching events!');
	            },
	          },
	          dayClick: function(date, jsEvent, view) {
				<% if (!"view".equals(commandType)) { %>
						document.getElementById('uploadFile').style.display='none';		
						clear_form_elements('fupload');
						clear_form_elements('recur');
						$('.percent').html('');
						
		        	    setInputDisableSts(false,'eventModal');
		  		    	clear_form_elements('eventModal');
		  		    	$(".eventAction").html('Add Event');
		  		    	var cview = $('#calendar').fullCalendar('getView');
		  		    	if (cview.name =='agendaWeek'){
		  		    		$("#eventFromTime").val(moment(date).format("kk:mm"));
							$("#eventToTime").val(moment(date).format("kk:mm"));
		  		    	}
						$("#eventDate").val(moment(date).format("DD/MM/YYYY"));

						$("#updateEvent").hide();
						$("#deleteEvent").hide();
						$("#createEvent").show();
						$("#RecurContainer").show();
						$("#copyEvent").hide();
						
						$('#eventModal').show();
		          	  	$('.eventMContent').draggable();
				<%}%>
	        	  },         
          eventClick: function(calEvent, jsEvent, view) {
        	  
        	  setInputDisableSts(false,'eventModal');
	        	  clear_form_elements('fupload');
	        	  $('.percent').html('');
        	  
				$(".eventAction").html('View Event');
				$( "#eventType").val(calEvent.typeID);
				$( "#memEventID").val(calEvent.typeID);
				
				$( "#viewType" ).text(calEvent.type);
				$( "#viewTitle" ).text(calEvent.title);
				$( "#viewDesc" ).text(calEvent.desc);
				$( "#viewDate" ).text(calEvent.eventDate);
				$( "#viewAttachment").html(calEvent.attachHtml);
				$( "#viewVenue" ).text(calEvent.locationDesc);
				
				$( "#updateFile").html(calEvent.updateHtml);
				<% if (!"view".equals(commandType)) { %>
					if (calEvent.updateHtml != undefined && calEvent.updateHtml != null) {
						document.getElementById('uploadFile').style.display='none';
						$("#keyID").val('');
					} else {
						document.getElementById('uploadFile').style.display='block';
						document.getElementById('upFButton').style.display='block';
						$("#keyID").val(calEvent.keyID);
					}
				<%}%>
				$( "#eventTitle" ).val(calEvent.title);
				$( "#eventDesc" ).val(calEvent.desc);
				$("#eventDate").val(calEvent.dateDD+"/"+calEvent.dateMM+"/"+calEvent.dateYYYY);
				$("#enrollID").val(calEvent.id);
				$("#eventFromTime").val(calEvent.fromHH+":"+calEvent.fromMI);
				$("#eventToTime").val(calEvent.toHH+":"+calEvent.toMI);
				$( "#venue").val(calEvent.locationID);
				
				$("#deleteEvent").attr("disabled", false);
				$("#updateEvent").attr("disabled", false);

				
        	  $("#createEvent").hide();
       	  	  $("#deleteEvent").show();
       	  	  $("#updateEvent").show();
       	  	  $("#RecurContainer").hide();
       	 	  $("#copyEvent").show();
			  
       	  	  $('#eventModal').show();
        	  $('.eventMContent').draggable(); 
				

        	  }, 
        	  eventRender: function(event, element) {
        		    element.find(".fc-title").remove();
        		    element.find(".fc-time").remove();
        		    var new_description =   
        		        moment(event.start).format("HH:mm") + '-'
        		        + moment(event.end).format("HH:mm") + '<br/>'
        		        +'<b><u>'+event.type + '</u></b><br/>'
        		        +event.title +((event.desc != '' && event.desc != null)? '('+event.desc + ')':'')
        		        +((event.updateHtml != undefined && event.updateHtml != null)?
        		        		"<img style=\"width:20px;height:20px;\" src=\"../images/attachment.png\" />":"")
        		    ;
        		    element.append(new_description);
        		    
        		},
	});
		
		
	$('#copyEvent').click(function() {
		$('#eventModal').hide();
		
		$(".eventAction").html('Copy Event');
		$("#eventDate").val("");
		$( "#memEventID").val("");
		$("#enrollID").val("");
		
		 $("#createEvent").show();
  	  	  $("#deleteEvent").hide();
  	  	  $("#updateEvent").hide();
  	  	$('#copyEvent').hide();
		
		$('#eventModal').show();
	});
		
	$('#createEvent').click(function() {
		
		$.ajax({
			type: "POST",
			url: "eventAction.jsp",
			data: 	"eventType="+$( "#eventType option:selected" ).val()
			+"&title=" + $( "#eventTitle" ).val()
			+"&desc="+$( "#eventDesc" ).val()
			+"&date="+$("#eventDate").val()
			+"&sTime="+$("#eventFromTime").val()
			+"&eTime="+$("#eventToTime").val()
			+"&isRecur="+$( "#isRecur" ).val()
			+"&recurWeekDay="+$( "#recurWeekDay option:selected" ).val()
			+"&rEndDay="+$( "#rEndDay" ).val()
			+"&recurType="+$( "#recurType option:selected" ).val()
			+"&venue="+((!$("#venue option:selected").length)?"":$( "#venue option:selected" ).val())
			+"&action=ADD",
			success: function(values) {				 
				$( "#calendar" ).fullCalendar( 'refetchEvents' );
				setInputDisableSts('true','eventModal');
				
				$('#actMsg').val('CONFATT');
				$("#keyID").val(values.trim());
				$('#actMsg').html('Do you want to add attachment?');
				$('#confirmDialog').show();
				
				/* document.getElementById('eventModal').style.display='none'; */
			},//success
			error: function() {
				alert('error');
			}
		});//$.ajax	
		/* clear_form_elements('eventModal'); */
		return false;
	});
	
	$('#deleteEvent').click(function() {
		$('#actMsg').val('DEL');
		$('#actMsg').html('delete the event?');
		$('#confirmDialog').show();
		return false;
	});
	
	$('#updateEvent').click(function() {
		$('#actMsg').val('MOD');
		$('#actMsg').html('update the event?');
		$('#confirmDialog').show();
		return false;
	}); 
	
	$("#isRecur").change(function() {
	    if(this.checked) {
	        $("#recurElement").css("display", "block");
	    } else {
	    	 $("#recurElement").css("display", "none");

	    }
	});
	
	var percent = $('.percent');
	var status = $('#status');
	   
	$('form').ajaxForm({
		resetForm: true,
		clearForm: true,
	    beforeSend: function() {
	        status.empty();
	        var percentVal = '';
	        percent.html(percentVal);
	    },
	    uploadProgress: function(event, position, total, percentComplete) {
	        var percentVal = percentComplete + '%';
	        percent.html(percentVal);
	    },
	    success: function() {
	        var percentVal = 'Uploaded';
			document.getElementById('upFButton').style.display='none';
	        $( "#calendar" ).fullCalendar( 'refetchEvents' );
	        percent.html(percentVal);
	    },
		complete: function(xhr) {
			status.html(xhr.responseText);
		}
	});
	<% if ("view".equals(commandType)) { %>
			$(".fc-addEventButton-button").css("display", "none");
			$(".fc-todayEvent-button").css("display", "none");
	<%}%>
	<% if (!userBean.isAccessible("function.mkt.event.todayEvent")) { %>
			$(".fc-todayEvent-button").css("display", "none");
	<%}%>
	
	$('input').filter('.datepickerfield').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });

	
	   jQuery('#eventFromTime').parent().clockpicker({
	        show24Hours: true,
	        spinnerImage: null,
	        immediateset: true,
	        placement: 'left',
	        donetext:'Done'
	    });
	   jQuery('#eventToTime').parent().clockpicker({
	        show24Hours: true,
	        spinnerImage: null,
	        immediateset: true,
	        placement: 'right',
	        donetext:'Done'
	    });
});


function getDate(){
	return $( "select[name='eventDate_dd'] option:selected" ).val()+"/"+$( "select[name='eventDate_mm'] option:selected" ).val()+"/"+$( "select[name='eventDate_yy'] option:selected" ).val();
}

function getTimeFrom(){
	return $( "select[name='eventFrom_hh'] option:selected" ).val()+":"+$( "select[name='eventFrom_mi'] option:selected" ).val()+":00";
}

function getTimeTo(){
	return $( "select[name='eventTo_hh'] option:selected" ).val()+":"+$( "select[name='eventTo_mi'] option:selected" ).val()+":00";
}

function setInputDisableSts(sts,class_name){
	$("."+class_name).find(':input').each(function() {
		if(this.type != 'button') {
			$(this).prop("disabled", sts);
		 }
	  });
}

function eventActionCancel(){
var action = $('#actMsg').val();
	if (action == 'CONFATT'){
		$( "#calendar" ).fullCalendar( 'refetchEvents' );
		$('#confirmDialog').hide();
		$('#eventModal').hide();
	} else {
		document.getElementById('confirmDialog').style.display='none';
	}
}
function eventActionConfirm(){
	var action = $('#actMsg').val();
	if (action == 'DEL'){
		$.ajax({
			type: "POST",
			url: "eventAction.jsp",
			data: 	"eventType="+$( "#eventType option:selected" ).val()
			+"&enrollID="+$("#enrollID").val()
			+"&memEventID="+$("#memEventID").val()
			+"&action=DEL",
			success: function(values) {
				$( "#calendar" ).fullCalendar( 'refetchEvents' );
				$('#confirmDialog').hide();
				$('#eventModal').hide();
			},//success
			error: function() {
				alert('error');
			}
		});//$.ajax	
		clear_form_elements('eventModal');
	} else if (action == 'MOD') {
		$.ajax({
			type: "POST",
			url: "eventAction.jsp",
			data: 	"eventType="+$( "#eventType option:selected" ).val()
			+"&title=" + $( "#eventTitle" ).val()
			+"&desc="+$( "#eventDesc" ).val()
			+"&date="+$("#eventDate").val()
			+"&sTime="+$("#eventFromTime").val()
			+"&eTime="+$("#eventToTime").val()
			+"&enrollID="+$("#enrollID").val()
			+"&memEventID="+$("#memEventID").val()
			+"&venue="+((!$("#venue option:selected").length)?"":$( "#venue option:selected" ).val())
			+"&action=MOD",
			success: function(values) {			
				$( "#calendar" ).fullCalendar( 'refetchEvents' );
				$('#confirmDialog').hide();
				$('#eventModal').hide();
			},//success
			error: function() {
				alert('error');
			}
		});//$.ajax	
		clear_form_elements('eventModal');
	} else if (action =='CONFATT') {
		$( "#upFile" ).prop("disabled", false); 
		$( "#upFileSub" ).prop("disabled", false);
		$( "#keyID" ).prop("disabled", false); 
		document.getElementById('uploadFile').style.display='block';
		$('#confirmDialog').hide();
	} else if (action=='DELATT') {
		$.ajax({
			type: "POST",
			url: "fileDelete.jsp",
			data: 	"keyID="+$('#actMsg').attr( "keyid" )
			+"&docID=" + $('#actMsg').attr( "docid" ),
			success: function(values) {
				$( "#updateFile").html('');
				$('#confirmDialog').hide();
				$("#keyID").val($('#actMsg').attr( "keyid" ));
				document.getElementById('uploadFile').style.display='block';
				document.getElementById('upFButton').style.display='block';
				$( "#calendar" ).fullCalendar( 'refetchEvents' );
				
			},//success
			error: function() {
				alert('error');
			}
		});//$.ajax	
	}
}

function deleteAttach(keyID,docID) {
	$('#actMsg').val('DELATT');
	$('#actMsg').html('delete this attachment?');
	$('#actMsg').attr("keyid", keyID);
	$('#actMsg').attr("docid", docID);
	$('#confirmDialog').show();

}

function clear_form_elements(class_name) {
	  $("."+class_name).find(':input').each(function() {
	    switch(this.type) {
	        case 'password':
	        case 'text':
	        case 'textarea':
	        case 'file':
	        case 'select-one':
	        case 'select-multiple':
	        case 'date':
	        case 'number':
	        case 'tel':
	        case 'hidden':
	        case 'email':
	            $(this).val('');
	            break;
	        case 'checkbox':
	        case 'radio':
	            this.checked = false;
	            break;
	    }
	  });
	  $("#updateFile").html('');
	}
	
function validTimeWithoutSec(obj) {
	time=obj.value
	if (/^\d{2}$/.test(time)) {
		obj.value=obj.value+':';
		return;
	}
	if (/^\d{2}\:\d{2}$/.test(time)) {
		obj.value=obj.value;
		return;
	}
	if (!/^\d{1,2}\:\d{2}\:\d{2}$/.test(time)) {
		return;
	}
	test1=(/^\d{1,2}\:?\d{2}\:\d{2}$/.test(time))
	time=time.split(':')
	test2=(1*time[0]< 24 && 1*time[1]< 60 && 1*time[2]< 60)
	if (test1 && test2) return true;
	obj.select();
	obj.focus();
	return false;
}
</script>

</DIV>

</DIV></DIV>
<style>
.fc-day-header { 
background-color:#AA0066; 
color:white;
}
.fc-day {
background-color:white;
}
.fc-typeText{
text-decoration: underline;
font-weight: bold;
}
.ui-dialog{
z-index:1000;
}

.input-group-addon {
    cursor:pointer;
    font-family:dashicons;
    padding:0;
    vertical-align:top;
}
p span {
    display:inline-block;
}
</style>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>