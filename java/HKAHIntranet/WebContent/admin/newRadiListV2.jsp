<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
public static ArrayList getServer() {
	StringBuffer sqlStr = new StringBuffer();
	
	ArrayList record = UtilDBWeb.getFunctionResults("NHS_GET_RADISHARING",
			new String[]{""});
	
	if(record.size() > 0) {
		return record;
	}else {
		return null;
	}
}
%>
<%
String reportServer = null;
String imgServer = null;
String imgPort = null;
String imgAET = null;


ArrayList record = getServer();
	if(record.size() > 0) {
		ReportableListObject row = (ReportableListObject)record.get(0);
		reportServer = row.getValue(2);
		imgServer = row.getValue(0);
		imgPort = row.getValue(5);
		imgAET = row.getValue(1);
			
	} 
	
//testing 
/* reportServer = "https://eai-igw-hkp.ha.org.hk:32262/eai_reverseproxy/eai_common_receiver/receiver/cidhl7eai/upload";
imgServer = "ehrrispp-fps-gw1.ha.org.hk";
imgPort = "11112";
imgAET = "DC4MIDAP01"; */
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>

<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/w3.hkah.css" />" />

 <script type="text/javascript" src="jquery-ui.min.js"></script>
 
<style>
html,body,h1,h2,h3,h4,h5 {font-family: "RobotoDraft", "Roboto", sans-serif;}
.w3-bar-block .w3-bar-item{padding:16px}
.progress {
  position: relative;
  width: 100%;
  height: 30px;
  background-color: #ddd;
}

.bar {
  position: absolute;
  width: 10%;
  height: 100%;
  background-color: #4CAF50;
}

.plabel {
  text-align: center;
  line-height: 30px;
  color: white;
}

@media (min-width:993px)
{
.w3-modal-content{
width: 700px;
}

/* Tooltip container */
.tooltip {
  position: relative;
  display: inline-block;
}

/* Tooltip text */
.tooltip .tooltiptext {
  visibility: hidden;
  width: 180px;
  background-color: black;
  color: #fff;
  text-align: center;
  padding: 2px 2px;
  border-radius: 6px;
 
  /* Position the tooltip text - see examples below! */
 position: absolute;
  z-index: 1;
  left: 50%;
  margin-left: -90px;
}

/* Show the tooltip text when you mouse over the tooltip container */
.tooltip:hover .tooltiptext {
  visibility: visible;
}
</style>
<body>
<!-- Side Navigation -->
<div class="w3-container">
<nav class="w3-sidebar w3-bar-block w3-white  w3-card" style="z-index:3;width:70%;" id="mySidebar">
  <div id="Demo1" class="w3-show">
  <div class="w3-container ah-pink">
  <h4>Radisharing</h4>
</div>
<div class="w3-row-padding">
		<label><b>Rpt Server</b></label>
		  <input type="text" id="rptServer"  value="<%=reportServer %>" size="100" readonly></input>
		<label ><b>Img Server</b></label>
		  <input type="text" id="imgServer"  value="<%=imgServer %>" size="50" readonly></input>
		 <input type="hidden" id="imgAET" value="<%=imgAET%>"/>
		 <input type="hidden" id="imgPort" value="<%=imgPort%>"/>
</div>
<div class="w3-row-padding">
  <div class="w3-third">
  <label class="w3-text-teal"><b>Pat No.</b></label>
  <input id="patNo" class="w3-input w3-border w3-light-grey" type="text"></input>
  </div>
  <div class="w3-third">
  <label class="w3-text-teal"><b>Date</b></label>
  <input class="w3-input w3-border w3-light-grey" type="text" id="datepicker" value=""></input>
  </div>
  <div class="w3-third">
  <label class="w3-text-teal"><b>Sender</b></label>
  <input class="w3-input w3-border w3-light-grey" type="text" id="sender" value=""></input>
  </div>
</div>
<div  class="w3-row-padding-large">
	<input class="w3-radio" type="radio" name="ckRdyUnSent" id="ckRdyUnSent" value="Y" >is Ready but not Sent</input>
	<input class="w3-radio" type="radio" name="ckRdyUnSent" id="ckRdyUnSent" value="P" checked>Check Patient</input>		
	<input class="w3-radio"  type="radio" name="ckRdyUnSent" id="ckRdyUnSent" value="D">Check History</input>
</div>
<div class="w3-row-padding">
  <div class=" w3-padding-large">
      <button class="w3-btn searchBtn w3-indigo">Search</button>
      <button class="w3-btn clearBtn w3-indigo">clear</button>
	  <button class="w3-btn emailBtn w3-blue">get Email content</button>
  </div>
</div>
  </div>
<div class="w3-container w3-padding" id="rTable""/>
</nav>
</div>
<!-- Page content -->
<div class="w3-container sendingCase w3-padding" style="margin-left:71%;">
  <div class="w3-container w3-teal">
  <h4>Sending <button class="w3-btn clearSendingBtn w3-indigo">clear</button></h4>
	</div>
</div>

<div id="id2" class="w3-modal">
  <div class="w3-modal-content">
    <div class="w3-container">
      <span onclick="document.getElementById('id2').style.display='none'"
      class="w3-button w3-display-topright">&times;</span>
		<div  id="id2table" class="w3-panel w3-border w3-light-grey w3-round-large w3-margin">
		  <p>Some text in the Modal..</p>
		  <p>Some text in the Modal..</p>
		 </div>
    </div>
  </div>
</div>
 
<div id="id01" class="w3-modal" >
<span onclick="document.getElementById('id2').style.display='none'"
      class="w3-button w3-display-topright">&times;</span>
  <div class="w3-modal-content">

    <header class="w3-container w3-blue-grey ">
      <span onclick="document.getElementById('id01').style.display='none'"
      class="w3-button w3-display-topright">&times;</span>
      <h6>Case Details</h6>
    </header>
	<div class="w3-panel w3-border w3-light-grey w3-round-large w3-margin">
		<label class="w3-text-blue"><b>Case Information in Message</b></label>
		<div class="w3-row-padding">
		  <div class="w3-half">
		    <label class="w3-text-blue"><b>Accession No</b></label><p id="caseANo"></p>
		  </div>
		  <div class="w3-half">
		    <label class="w3-text-blue"><b>HKID</b></label><p id="caseHKID"></p>
		  </div>
		</div>
		<div class="w3-row-padding">
		  <div class="w3-half">
			  	<label class="w3-text-blue"><b>Name</b></label><p id="casePName"></p>
		  </div>
		  <div class="w3-half">
			  	<label class="w3-text-blue"><b>DOB</b></label><p id="caseDOB"></p>
		  </div>
		</div>	 	  	  	
	</div>	
		<div class="w3-panel w3-border w3-light-grey w3-round-large w3-margin">
		<label class="w3-text-blue"><b>File Information</b></label>
		<div class="w3-row-padding">
		  <div class="w3-half">
		    <label class="w3-text-blue"><b>Image Count</b></label><p id="caseImgNo"></p>
		  </div>
		  <div class="w3-half">
		    <label class="w3-text-blue"><b>Report Status</b></label><p id="caseRptSts"></p>
		    <button class="w3-btn w3-indigo updateInsertButton" style="display:none;" onclick="">Update to Insert</button>
			<button class="w3-btn w3-indigo insertToUpdateButton" style="display:none;" onclick="">Insert to Update</button>
		  </div>
		</div>	  	  	
	</div>	
    <div class="w3-container" style="height: 400px;"id="rpt"></div>
    
	<footer class="w3-container w3-blue-grey">
   	      <button class="w3-btn w3-indigo confirmSendBtn" onclick="">Send</button>
    </footer>
  </div>
</div>

<script language="javascript">
 window.onbeforeunload = function() {
        return "Are you sure you want to leave? ";
    }
$(document).ready(function() {
    $( "#datepicker" ).datepicker();
    $( "#datepicker" ).val();
    
	
	$(".searchBtn").click(function() {
		showLoadingBox('body', 500, $(window).scrollTop());
		$.ajax({
			type: "POST",
			url: "radi_ajaxV2.jsp",
			data: 	"patNo="+$( "#patNo" ).val()
			+"&date_from="+$("#datepicker").val()
			+"&ckRdyUnSent="+$('input[name=ckRdyUnSent]:checked').val(),
			success: function(values) {
				hideLoadingBox('body', 500);
				$( "#rTable" ).html(values);
			},//success
			error: function() {
				hideLoadingBox('body', 500);
				alert('error');
			}
		});//$.ajax	
		return false;
	}); 
	
		$(".emailBtn").click(function() {
		showLoadingBox('body', 500, $(window).scrollTop());
		$.ajax({
			type: "POST",
			url: "radi_ajaxV2.jsp",
			data: 	"patNo="+$( "#patNo" ).val()
			+"&date_from="+$("#datepicker").val()
			+"&ckRdyUnSent=P&command=email"+"&sender="+$( "#sender" ).val(),
			success: function(values) {
				hideLoadingBox('body', 500);
				$( "#id2table" ).html(values);
				document.getElementById('id2').style.display='block';
			},//success
			error: function() {
				hideLoadingBox('body', 500);
				alert('error');
			}
		});//$.ajax	
		return false;
	}); 
	
	$(".confirmSendBtn").click(function() {
		if($(this).attr("accessionNo") != '') {
			//sendCase($(this).attr("accessionNo"));
				
		//alert($("div[status='S']:first").attr('accessionno'));
		
		$('.sendingCase').append('<div accessionNo="'+$(this).attr("accessionNo")+'" class="w3-card-4 w3-padding case" id="case'+$(this).attr("accessionNo")+'">'+
										'<p>Accession No:'+$(this).attr("accessionNo")+'</p>'+
										'<div class="progress" id="prog'+$(this).attr("accessionNo")+'" >'+
										'<div class="bar" pid="" id="bar'+$(this).attr("accessionNo")+'">'+
										'<div class="plabel" id="label'+$(this).attr("accessionNo")+'"></div>'+
										'<div><div><div>'
										);
			if ($("div.case[status='S']").length > 2) {
				$("#case" + $(this).attr("accessionNo")).attr("status","W");	
				$( "#"+'bar'+$(this).attr("accessionNo")).text('Waiting to Send....');
				$( "#"+'bar'+$(this).attr("accessionNo")).css("background-color", "#69D5DE");
				$( "#"+'bar'+$(this).attr("accessionNo")).css("width", "100%");

			} else {
				sendCase($(this).attr("accessionNo"));
			}
			document.getElementById('id01').style.display='none';
		}
			return false;
	});
	
	$(".updateInsertButton").click(function() {
		if($(this).attr("accessionNo") != '') {
			updateToinsert($(this).attr("accessionNo"));
		}
			return false;
	});
	
	$(".insertToUpdateButton").click(function() {
		if($(this).attr("accessionNo") != '') {
			insertToUpdate($(this).attr("accessionNo"));
		}
			return false;
	});
	
	$(".clearSendingBtn").click(function() {
		$('.case').remove();
	});
	
	
	
	$(".clearBtn").click(function() {
		$( "#patNo" ).val('');
		$("#datepicker").val('');
		return false;
	}); 
});


function updateR(accessionNo,patno) {
	showLoadingBox('body', 500, $(window).scrollTop());
 		$.ajax({
			type: "POST",
			url: "radi_ajaxV2.jsp",
			data: 	"accessionNo="+accessionNo.trim()
			+"&date_from="+$("#datepicker").val()
			+"&patNo="+patno.trim()
			+"&command=updateToReady"
			+"&ckRdyUnSent="+$('input[name=ckRdyUnSent]:checked').val(),
			success: function(values) {
				hideLoadingBox('body', 500);
				$( "#rTable" ).html(values);
				$(".searchBtn").click();
			},//success
			error: function() {
				hideLoadingBox('body', 500);
				alert('error');
			}
		});//$.ajax	 
    return false;
};

function insertToUpdate(accessionNo) {
 		$.ajax({
			type: "POST",
			url: "radi_ajaxV2.jsp",
			data: 	"accessionNo="+accessionNo.trim()
			+"&command=insertToUpdate",
			success: function(values) {
				$("#caseRptSts").text(values);
				$('.insertToUpdateButton').hide();
			},//success
			error: function() {
			}
		});//$.ajax	 
    return false;
};

function updateToinsert(accessionNo) {
 		$.ajax({
			type: "POST",
			url: "radi_ajaxV2.jsp",
			data: 	"accessionNo="+accessionNo.trim()
			+"&command=updateToinsert",
			success: function(values) {
				$("#caseRptSts").text(values);
				$("#caseRptSts").css("color", "black");
				$('.updateInsertButton').hide();
			},//success
			error: function() {
			}
		});//$.ajax	 
    return false;
};
function sendBtnAction(accessionNo) {
	clearSendDlg(); 
		
	$.ajax({
			type: "POST",
			url: "radi_ajaxV2.jsp",
			data: 	"accessionNo="+accessionNo.trim()
			+"&command=getCaseDetail",									
			dataType: "jsonp",
			    success: function (data, textStatus, jqXHR) {
			    	$("#caseANo").text(data['accessionNo']);
			    	$("#caseHKID").text(data['hkid']);
			    	$("#casePName").text(data['pName']);
			    	$("#caseDOB").text(data['dob']);
			    	$("#caseImgNo").text(data['imgCount']);
			    	$("#caseRptSts").text(data['rptSts']);
					$("#caseRptSts").css("color", "black");
			    	if (data['rptSts'] == 'UPDATE') {
						$("#caseRptSts").css("color", "red");
			    		$('.updateInsertButton').show();
						$('.insertToUpdateButton').hide();
			    		$('.updateInsertButton').attr('accessionNo', data['reportPath']);
					} else if (data['rptSts'] == 'INSERT') {
			    		$('.insertToUpdateButton').show();
						$('.updateInsertButton').hide();
			    		$('.insertToUpdateButton').attr('accessionNo', data['reportPath']);
			    	} else {
			    		$('.updateInsertButton').hide();
						$('.insertToUpdateButton').hide();
			    	}
			    	$('#rpt').html('<object width="100%" height="90%" data="http://192.168.0.20/intranet/documentManage/pdfjs/web/viewer.jsp?'+
							'file='+data['pdfPath']+
							'&allowPresentationMode=Y&allowOpenFile=N&allowPrint=N&allowDownload=N" />');
			    	$('.confirmSendBtn').attr('accessionNo', data['accessionNo']);
			    },
			    error: function(x, s, e) {
				}
		});
	document.getElementById('id01').style.display='block';
	
	return false;
}

function clearSendDlg(){
	$("#caseANo").text('');
	$("#caseHKID").text('');
	$("#casePName").text('');
	$("#caseDOB").text('');
	$("#caseImgNo").text('');
	$("#caseRptSts").text('');
	$('#rpt').html('');
	$('.confirmSendBtn').attr('accessionNo', '');
	$('.updateInsertButton').attr('accessionNo','');
	$('.updateInsertButton').hide();
	
	return false;

}

function sendCase(accessionNo) {
		if($("#case" + accessionNo).length > 0) {
			  if ($("#case" + accessionNo).attr('status') == 'S'){
				  alert("this case is sending");
				  return;
			  } else if ($("#case" + accessionNo).attr('status') == 'F'){
				  $('#case'+accessionNo).remove();
			  } else if ($("#case" + accessionNo).attr('status') == 'C'){
				  alert("this case has already complete sending");
				  return;
			  }
		}			
	
			 $.ajax({
					type: "POST",
					url: "radi_ajaxV2.jsp",
					data: {accessionNo: accessionNo.trim(), 
							command: "sendRpt",
							reportServer: $("#rptServer").val()
					 	},
					
					dataType: "jsonp",
					 beforeSend: function() {
						 $("#case" + accessionNo).attr("status","S");	
						 /* sendingCase.set(accessionNo,'S'); */
						 $( "#"+'bar'+accessionNo ).text('Sending Report...');
						 $( "#"+'bar'+accessionNo ).css("background-color", "#4CAF50");
						 $( "#"+'bar'+accessionNo ).attr("pid",move(accessionNo));
					    },
					    success: function (data, textStatus, jqXHR) {
						/* $( "#"+accessionNo+'_rsts' ).text(data['sendRptResult']); */
						$( "#"+'label'+accessionNo ).text(data['sendRptResult']);
						if (data['sendRptResult'] == 'false') {
							$("#case" + accessionNo).attr("status","F");
							
						}
						if (data['sendRptResult'] == 'true') {
							$( "#"+'bar'+accessionNo ).text('Sending Images...');
					 		$.ajax({
								type: "POST",
								url: "radi_ajaxV2.jsp",
								data: {accessionNo: accessionNo.trim(), 
									command: "sendImg",
									imgPath: data['imgPath'],
									imgServer: $("#imgServer").val(),
									imgAET: $("#imgAET").val(),
									imgPort: $("#imgPort").val()
									
							 	},
								beforeSend: function() {
									$( "#"+'bar'+accessionNo ).text('Sending Images...');
								    },
								success: function(values) {
									$("#case" + accessionNo).attr("status","C");
									/* sendingCase.set(accessionNo,'C'); */
									$( "#"+'bar'+accessionNo ).text('Report:'+data['sendRptResult']+' Images:'+values);
										$.ajax({
											type: "POST",
											url: "radi_ajaxV2.jsp",
											data: {accessionNo: accessionNo.trim(), 
												command: "saveSendLog",
												result:'Report:'+data['sendRptResult']+' Images:'+values
													},
											success: function(values) {
											},//success
											error: function() {
											}
										});
										$.ajax({
											type: "POST",
											url: "radi_ajaxV2.jsp",
											data: {accessionNo: accessionNo.trim(), 
												command: "updateCaseSts"
													},
											success: function(values) {
											},//success
											error: function() {
											}
										});
									stop($( "#"+'bar'+accessionNo ).attr("pid"),accessionNo);
									
									if ($("div.case[status='W']").length > 0) {
										sendCase($("div.case[status='W']:first").attr('accessionno'));
									}
									
								},//success
								error: function() {
									/* sendingCase.delete(accessionNo); */
									$( "#"+'bar'+accessionNo ).text('Report:'+data['sendRptResult']+' Images:'+values);
									$.ajax({
										type: "POST",
										url: "radi_ajaxV2.jsp",
										data: {accessionNo: accessionNo.trim(), 
											command: "saveSendLog",
											result:'Report:'+data['sendRptResult']+' Images:'+values
												},
										success: function(values) {
										},//success
										error: function() {
										}
									});
									stop($( "#"+'bar'+accessionNo ).attr("pid"),accessionNo);
									
									if ($("div.case[status='W']").length > 0) {
										sendCase($("div.case[status='W']:first").attr('accessionno'));
									}
								}
							});//$.ajax	
							
							
						} else {
							$( "#"+'bar'+accessionNo ).text('Report:'+data['sendRptResult']);
							$.ajax({
								type: "POST",
								url: "radi_ajaxV2.jsp",
								data: {accessionNo: accessionNo.trim(), 
									command: "saveSendLog",
									result:'Report:'+data['sendRptResult']
										},
								success: function(values) {
								},//success
								error: function() {
								}
							});
							stop($( "#"+'bar'+accessionNo ).attr("pid"),accessionNo);
							if ($("div.case[status='W']").length > 0) {
								sendCase($("div.case[status='W']:first").attr('accessionno'));
							}
						}
						/* stop($( "#"+'bar'+accessionNo ).attr("pid"),accessionNo); */
					},//success
					error: function(x, s, e) {
						alert('error');
					}
		});//$.ajax	
    return false;
};

function showLoadingBox(target, time, top) {
	if($('div#loadingBox').length  <= 0) {
		var imgPath;
		if(window.location.href.indexOf('crm/portal') > -1) {
			imgPath = "../../images/";
		}
		else {
			imgPath = "../images/";
		}
		$('<div id="loadingBox" class="loading">'+'<strong>Loading...</strong><br/><img src="'+imgPath+'loadingAnimation.gif"/></div>')
			.appendTo(target);
	}

	$(target).find('div#loadingBox').css('left', $(window).width()/2-$('div#loadingBox').width()/2);//$(target).position().left
	if (top) {
		$(target).find('div#loadingBox').css('top', top);//(top?top:$(target).position().top)
	}
	else {
		$(target).find('div#loadingBox').css('top', $(window).height()/2-$('div#loadingBox').height()/2);//(top?top:$(target).position().top)
	}
	$(target).find('div#loadingBox').fadeIn(time);
}

function hideLoadingBox(target, time) {
	$(target).find('div#loadingBox').fadeOut(time);
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
	}
	
function move(key) {
  var elem = document.getElementById("bar"+key);   
  var width = 26;
  var id = setInterval(frame, 40);
  function frame() {
    if (width >= 100) {
      elem.style.width = 26;
      width = 26;
    } else {
      width++; 
      elem.style.width = width + '%'; 
      /* document.getElementById("label"+key).innerHTML = initialText; */
      /* document.getElementById("bar"+key).innerText = initialText; */
    }
  }
  return id;
}

function stop(id,key){
	var elem = document.getElementById("bar"+key);
	elem.style.width = '100%';
	clearInterval(id);
}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>