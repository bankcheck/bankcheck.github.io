<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.net.MalformedURLException"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> getOBlocation(){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT LISTAGG(BEDCODE,',')WITHIN GROUP (ORDER BY BEDCODE) ");
		sqlStr.append("FROM BED ");
		sqlStr.append("WHERE BEDOFF = '-1' ");
		sqlStr.append("AND BEDCODE LIKE '6%' ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}

%>
<%
String obLocid = "";
/*ArrayList<ReportableListObject> record = getOBlocation();
ReportableListObject row = null;
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	obLocid = row.getValue(0);
}*/
obLocid = "608,609A,609B,609C,610A,610B,611,612,613,615,Nursery,Discharge,L1,L2";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
	 "http://www.w3.org/TR/html4/frameset.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="../images/baby-logos.ico" type="image/x-icon" />
    <title>Baby Tracking System</title>
    <style>
	.selected{
		border: 2px solid red;
	}
	#checkingMotherQRcord{
		display: none;
		position: absolute; 
		z-index: 10; /* Sit on top */
		width: 80%;
		overflow: auto; /* Enable scroll if needed */
		background-color: #FFFFFF;
		margin: auto;
		border: 1px solid #888;
	}
	#locid1{
		display: none;
	}
	.mismatch{
		background-color: #FF7A7A;
		animation: flash 2s;
		animation-iteration-count: infinite;
	}
	@keyframes flash
	{
	0% { 	border-color: #FF0000;background-color: #FF7A7A;}
	50% {	border-color: #FFFFFF;background-color: #FFFFFF;}
	100% {	border-color: #FF0000;background-color: #FF7A7A;}
	}
    </style>
    <script type="text/javascript" src="../js/html5-qrcode.min.js"></script>
    <script type="text/javascript"	src="../js/jquery.cookie.js"></script>
	<script type="text/javascript"	src="../js/jquery.dcdrilldown.1.2.min.js"></script>
	<script type="text/javascript"	src="../js/filterlist.js"></script>
	<link rel="stylesheet" type="text/css"	href="../css/w3.hkah.css" />
</head>

<body>
	<div class="w3-container w3-center ah-pink w3-display-top " >
		<div class="w3-container w3-right">
			<button class="" id="newBorn" >New Born</button>
			<button class="" id="discharge" >Discharge</button>
		</div>
		<div class="w3-container">
			<span class="w3-xxlarge bold " onclick="location.reload();">Baby Tracking System</span>
		</div> 

	</div>
	<div class="w3-container">&nbsp;&nbsp;</div>
		<div class="w3-container w3-row">
			<div class="w3-col" style="width:15%"><button class="w3-left" id="startIn" style="width:100%">IN</button></div>
			<div class="w3-col" style="width:15%">&nbsp;</div>
			<div class="w3-col" style="width:40%"><button id="submitAction" style="width:100%" onclick="submitAction()">Save Record</button></div>
			<div class="w3-col" style="width:15%">&nbsp;</div>
			<div class="w3-col" style="width:15%"><button class="w3-right" id="startOut" style="width:100%">OUT</button></div>
		</div>
		<div class="w3-container">
			<input id="mode" type="hidden" placeholder="" class="w3-input w3-round"/>
			Patient Number:
			<input id="patno" type="text" placeholder="" class="w3-input w3-round"/>
			User:
			<input id="userid" type="text" placeholder="" class="w3-input w3-round"/>
			Location:
			<input id="locid" type="text" placeholder="" class="w3-input w3-round"/>
			<input id="locid1" type="text" placeholder="" class="w3-input w3-round" readonly/>
		</div>
	<div class="w3-container">&nbsp;&nbsp;</div>
	<div class="w3-container" id="info" >&nbsp;&nbsp;</div>
	<div id="reader" width="600px"></div>
	
	<div id="checkingMotherQRcord" class="w3-container w3-card-2 w3-display-topmiddle w3-center">
		<span class="w3-container w3-large bold ">Double checking Patient QR code...</span>
		<span id="matching" class="w3-container w3-xlarge bold ">&nbsp;</span>
	</div>
</body>
<script>
   var cameraId;
   Html5Qrcode.getCameras().then(devices => {
 	  /**
 	   * devices would be an array of objects of type:
 	   * { id: "id", label: "label" }
 	   */
		if (devices && devices.length) {
 	    	cameraId = devices[1].id;

			//console.log("cameraId:"+cameraId);
 	   		const html5QrCode = new Html5Qrcode("reader");
 	   	
 	   	
	 	   	//main scan start (IN) 
			document.getElementById('startIn').addEventListener('click', () => {
				resetData("IN");
				$("#info").html(" Scanning Baby QR Code ...");
	  			html5QrCode.start( /*patno*/
	       			cameraId,     
	         		{
			           fps: 20,    
			           qrbox: 250  
	         		},
	         		qrCodeMessage1 => {
	         			if(checkPatno(qrCodeMessage1)){
							html5QrCode.stop().then(ignore => {
								insertPatno(qrCodeMessage1);
		
								$("#info").html(" Scanning Staff QR Code ...");
								html5QrCode.start( /*userid*/
				        			cameraId,
				          			{
							            fps: 20,
							            qrbox: 250
			          				},
				          			qrCodeMessage2 => {
										if(qrCodeMessage2!==qrCodeMessage1){
											if(checkUserId(qrCodeMessage2)){
												html5QrCode.stop().then(ignore => {
													insertUserId(qrCodeMessage2);
													
													$("#info").html(" Scanning Location QR Code ...");
													html5QrCode.start( /*locid*/
										        			cameraId,
										          			{
													            fps: 20,
													            qrbox: 250
									          				},
										          			qrCodeMessage3 => {
										          				console.log("qrCodeMessage2"+qrCodeMessage2);
										          				console.log("qrCodeMessage3"+qrCodeMessage3);
																if(qrCodeMessage3!==qrCodeMessage2){
																	if(checkLocid(qrCodeMessage3)){
																		html5QrCode.stop().then(ignore => {
																			insertLocation(qrCodeMessage3);
																			/*check mother barcode*/
																			$("#info").html(" Scanning Mother's Baby QR Code ...");
																			document.getElementById("checkingMotherQRcord").style.display = "block";
																  			html5QrCode.start( /*patno*/
																       			cameraId,     
																         		{
																		           fps: 20,    
																		           qrbox: 250  
																         		},
																         		qrCodeMessage4 => {
																					if(qrCodeMessage4 == qrCodeMessage1){
																						html5QrCode.stop().then(ignore => {
																							//baby mother match
																							matchAction();
																						}).catch(err => {
																						  // Stop failed, handle it.
																						});
																					}else{
																						//keep scanning
																						$("#matching").html("MISMATCH");
																						$("#checkingMotherQRcord").addClass(" mismatch");
																					}
																					
																         		},
																		        errorMessage => {
																		           // parse error, ideally ignore it. For example:
																		           //console.log("QR Code no longer in front of camera.");
																		        })
																	       .catch(err => {
																	         	console.log("Unable to start scanning, error: "+err);
																	       });
																  			/*check mother barcode*/
																		}).catch(err => {
																		});
																	}
																}
										         			 },
													         errorMessage => {
													            // parse error, ideally ignore it. For example:
													            //console.log("QR Code no longer in front of camera.");
													         })
												        .catch(err => {
												          // Start failed, handle it. For example,
												          console.log("Unable to start scanning, error: "+err);
												        });
												}).catch(err => {
												});
											}
										}
				         			 },
							         errorMessage => {
							            // parse error, ideally ignore it. For example:
							            //console.log("QR Code no longer in front of camera.");
							         })
						        .catch(err => {
						          // Start failed, handle it. For example,
						          console.log("Unable to start scanning, error: "+err);
						        });
							}).catch(err => {
							  // Stop failed, handle it.
							});
	         			}
	         		},
			        errorMessage => {
			           // parse error, ideally ignore it. For example:
			           //console.log("QR Code no longer in front of camera.");
			        })
		       .catch(err => {
		         	console.log("Unable to start scanning, error: "+err);
		       });
			});
 	   	
			//main scan start (OUT) 
			document.getElementById('startOut').addEventListener('click', () => {
				resetData("OUT");
				insertLocation("Nursery"); // default location
				
				$("#info").html(" Scanning Baby QR Code ...");
	  			html5QrCode.start( /*patno*/
	       			cameraId,     
	         		{
			           fps: 20,    
			           qrbox: 250  
	         		},
	         		qrCodeMessage1 => {
	         			if(checkPatno(qrCodeMessage1)){
							html5QrCode.stop().then(ignore => {
								insertPatno(qrCodeMessage1);
		
								$("#info").html(" Scanning Staff QR Code ...");
								html5QrCode.start( /*userid*/
				        			cameraId,
				          			{
							            fps: 20,
							            qrbox: 250
			          				},
				          			qrCodeMessage2 => {
										if(qrCodeMessage2!==qrCodeMessage1){
											if(checkUserId(qrCodeMessage2)){
												html5QrCode.stop().then(ignore => {
													insertUserId(qrCodeMessage2);
												}).catch(err => {
													// Stop failed, handle it.
												});
											}
										}
				         			 },
							         errorMessage => {
							            // parse error, ideally ignore it. For example:
							            //console.log("QR Code no longer in front of camera.");
							         })
						        .catch(err => {
						          // Start failed, handle it. For example,
						          console.log("Unable to start scanning, error: "+err);
						        });
							}).catch(err => {
							  // Stop failed, handle it.
							});
	         			}
	         		},
			        errorMessage => {
			           // parse error, ideally ignore it. For example:
			           //console.log("QR Code no longer in front of camera.");
			        })
		       .catch(err => {
		         	console.log("Unable to start scanning, error: "+err);
		       });
			});
			
			//main scan start (NEW BORN) 
			document.getElementById('newBorn').addEventListener('click', () => {
				resetData("newBorn");
				insertLocation("Nursery"); // default location
				
				$("#info").html(" Scanning Baby QR Code ...");
	  			html5QrCode.start( /*patno*/
	       			cameraId,     
	         		{
			           fps: 20,    
			           qrbox: 250  
	         		},
	         		qrCodeMessage1 => {
	         			if(checkPatno(qrCodeMessage1)){
							html5QrCode.stop().then(ignore => {
								insertPatno(qrCodeMessage1);
		
								$("#info").html(" Scanning Staff QR Code ...");
								html5QrCode.start( /*userid*/
				        			cameraId,
				          			{
							            fps: 20,
							            qrbox: 250
			          				},
				          			qrCodeMessage2 => {
										if(qrCodeMessage2!==qrCodeMessage1){
											if(checkUserId(qrCodeMessage2)){
												html5QrCode.stop().then(ignore => {
													insertUserId(qrCodeMessage2);
												}).catch(err => {
													// Stop failed, handle it.
												});
											}
										}
				         			 },
							         errorMessage => {
							            // parse error, ideally ignore it. For example:
							            //console.log("QR Code no longer in front of camera.");
							         })
						        .catch(err => {
						          // Start failed, handle it. For example,
						          console.log("Unable to start scanning, error: "+err);
						        });
							}).catch(err => {
							  // Stop failed, handle it.
							});
	         			}
	         		},
			        errorMessage => {
			           // parse error, ideally ignore it. For example:
			           //console.log("QR Code no longer in front of camera.");
			        })
		       .catch(err => {
		         	console.log("Unable to start scanning, error: "+err);
		       });
			});
			
			//main scan start (discharge) 
			document.getElementById('discharge').addEventListener('click', () => {
				resetData("discharge");
				insertLocation("Discharge"); // default location
				
				$("#info").html(" Scanning Baby QR Code ...");
	  			html5QrCode.start( /*patno*/
	       			cameraId,     
	         		{
			           fps: 20,    
			           qrbox: 250  
	         		},
	         		qrCodeMessage1 => {
	         			if(checkPatno(qrCodeMessage1)){
		         			html5QrCode.stop().then(ignore => {
								insertPatno(qrCodeMessage1);
		
								$("#info").html(" Scanning Staff QR Code ...");
								html5QrCode.start( /*userid*/
				        			cameraId,
				          			{
							            fps: 20,
							            qrbox: 250
			          				},
				          			qrCodeMessage2 => {
										if(qrCodeMessage2!==qrCodeMessage1){
											if(checkUserId(qrCodeMessage2)){
												html5QrCode.stop().then(ignore => {
													insertUserId(qrCodeMessage2);
												}).catch(err => {
													// Stop failed, handle it.
												});
											}
										}
				         			 },
							         errorMessage => {
							            // parse error, ideally ignore it. For example:
							            //console.log("QR Code no longer in front of camera.");
							         })
						        .catch(err => {
						          // Start failed, handle it. For example,
						          console.log("Unable to start scanning, error: "+err);
						        });
							}).catch(err => {
							  // Stop failed, handle it.
							});
	         			}
	         		},
			        errorMessage => {
			           // parse error, ideally ignore it. For example:
			           //console.log("QR Code no longer in front of camera.");
			        })
		       .catch(err => {
		         	console.log("Unable to start scanning, error: "+err);
		       });
			});
 	   	
			//scan patno
			document.getElementById('patno').addEventListener('click', () => {
				$("#info").html(" Scanning Baby QR Code ...");
	  			html5QrCode.start( /*patno*/
	       			cameraId,     
	         		{
			           fps: 20,    
			           qrbox: 250  
	         		},
	         		qrCodeMessage1 => {
						if(checkPatno(qrCodeMessage1)){
		         			html5QrCode.stop().then(ignore => {
								insertPatno(qrCodeMessage1);
							}).catch(err => {
							  // Stop failed, handle it.
							});
						}
	         		},
			        errorMessage => {
			           // parse error, ideally ignore it. For example:
			           //console.log("QR Code no longer in front of camera.");
			        })
		       .catch(err => {
		         	console.log("Unable to start scanning, error: "+err);
		       });
			});
			
			//scan userid
			document.getElementById('userid').addEventListener('click', () => {
				$("#info").html(" Scanning Staff QR Code ...");
	  			html5QrCode.start( 
	       			cameraId,     
	         		{
			           fps: 20,    
			           qrbox: 250  
	         		},
	         		qrCodeMessage1 => {
						if(checkUserId(qrCodeMessage1)){
							html5QrCode.stop().then(ignore => {
								insertUserId(qrCodeMessage1);
							}).catch(err => {
							  // Stop failed, handle it.
							});
						}
	         		},
			        errorMessage => {
			           // parse error, ideally ignore it. For example:
			           //console.log("QR Code no longer in front of camera.");
			        })
		       .catch(err => {
		         	console.log("Unable to start scanning, error: "+err);
		       });
			});
			
			//scan locid
			document.getElementById('locid').addEventListener('click', () => {
				$("#info").html(" Scanning Location QR Code ...");
	  			html5QrCode.start( 
	       			cameraId,     
	         		{
			           fps: 20,    
			           qrbox: 250  
	         		},
	         		qrCodeMessage1 => {
						if(checkLocid(qrCodeMessage1)){
							html5QrCode.stop().then(ignore => {
								insertLocation(qrCodeMessage1);
							}).catch(err => {
							  // Stop failed, handle it.
							});
						}
	         		},
			        errorMessage => {
			           // parse error, ideally ignore it. For example:
			           //console.log("QR Code no longer in front of camera.");
			        })
		       .catch(err => {
		         	console.log("Unable to start scanning, error: "+err);
		       });
			});
		
		}
	}).catch(err => {
	  // handle err
	});
   
	function checkPatno(msg){
		if(msg.includes("<PID>")){
			return true;
		}else{
			//alert("Error staff id input.");
			return false;
		}
	}
   
	function insertPatno(msg){
		var startIndex = msg.search("<PID>");
		var endIndex= msg.search("</PID>");
		var patno="";
		patno = msg.substring(startIndex+5,endIndex);
		$("#patno").val(patno);
		$("#info").html("");
	}
	
	function checkUserId(msg){
		if(msg.includes("<ID>")){
			return true;
		}else{
			//alert("Error staff id input.");
			return false;
		}
	}
   
	function insertUserId(msg){
		var startIndex = msg.search("<ID>");
		var endIndex= msg.search("</ID>");
		var userid="";
		if(msg.substring(startIndex+4,startIndex+5) == "0"){
			userid = msg.substring(startIndex+5,endIndex);
		}else{
			userid = msg.substring(startIndex+4,endIndex);
		}
		$("#userid").val(userid);
		$("#info").html("");
	}
	
	function checkLocid(msg){
		var oblocid = "<%=obLocid %>";
		if(oblocid.includes(msg)){
			return true;
		}else{
			//alert("Error location input.");
			return false;
		}
	}
	
	function insertLocation(msg){
		$("#locid").val(msg);
		$("#locid1").val(msg);
		$("#info").html("");
	}
	
	function matchAction(){
		$("#matching").html("MATCH");
		$("#checkingMotherQRcord").removeClass(" mismatch");
		document.getElementById("checkingMotherQRcord").style.display = "none";
		$("#info").html("");
	}
	
	function resetData(element){
		if(element=="IN"){
			$("#startIn").addClass("selected");
			$("#startOut").removeClass("selected");
			$("#newBorn").removeClass("selected");
			$("#discharge").removeClass("selected");
			document.getElementById("locid").style.display = "block";
			document.getElementById("locid1").style.display = "none";
		}else if(element=="OUT"){
			$("#startIn").removeClass("selected");
			$("#startOut").addClass("selected");
			$("#newBorn").removeClass("selected");
			$("#discharge").removeClass("selected");
			document.getElementById("locid").style.display = "none";
			document.getElementById("locid1").style.display = "block";
		}else if(element=="newBorn"){
			$("#startIn").removeClass("selected");
			$("#startOut").removeClass("selected");
			$("#newBorn").addClass("selected");
			$("#discharge").removeClass("selected");
			document.getElementById("locid").style.display = "none";
			document.getElementById("locid1").style.display = "block";
		}else if(element=="discharge"){
			$("#startIn").removeClass("selected");
			$("#startOut").removeClass("selected");
			$("#newBorn").removeClass("selected");
			$("#discharge").addClass("selected");
			document.getElementById("locid").style.display = "none";
			document.getElementById("locid1").style.display = "block";
		}
		$("input").val("");
		$("#mode").val(element);
		$("#info").html("");
	}
	
	function submitAction(){
		if($("#patno").val().length == 0 || $("#locid").val().length == 0 || $("#userid").val().length == 0 ){
			alert("Please fill-in all the fields.");
			return;
		}
		
		$.ajax({
			url : "babyTracking_ajax.jsp",
			data : {
				"mode" : $("#mode").val(),
				"patno" : $("#patno").val(),
				"locid" : $("#locid").val(),
				"userid" : $("#userid").val(),
			},
			type : 'POST',
			dataType : 'html',
			cache : false,
			success : function(data) {
				alert($.trim(data));
				location.reload();
			},
			error : function(data) {
				alert($.trim(data));
			}
		});
	}
</script>
</html:html>