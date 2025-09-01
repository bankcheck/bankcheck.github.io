<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%
UserBean userBean = new UserBean(request);

String lang = request.getParameter("lang");
String type = request.getParameter("type");

boolean displayChi = false;
boolean displayEng = false;

boolean isObService = false;
boolean isGeneralAdmission = false;

String documentTitle= "";
String audioSrc = "";
if("chi".equals(lang)){
	displayChi = true;	
}else{
	displayEng = true;
}
if("generalAdmission".equals(type)){
	isGeneralAdmission = true;
	documentTitle = "General Admission";
	type = "generalAdmission";
}else{
	isObService = true;
	documentTitle = "OB Admission";
	type = "obService";
}

if(displayChi){
	//audioSrc = "/upload/IPad/Service/Testing/Renovation Notice (Chi.).mp3";
	//lang = "chi";
}else if(displayEng){
	if(isGeneralAdmission){
		audioSrc = "/upload/IPad/Service/General Admission/general_admission_eng.mp3";
		lang = "eng";
	}else{
		audioSrc = "/upload/IPad/Service/OB Admission/ob_admission_eng.mp3";
		lang = "eng";
	}
}
%>
<!DOCTYPE html>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>

	<link rel="stylesheet" href="horizontalMenuFiles/style.css" type="text/css" /><style>._css3m{display:none}</style>
	
	<style>
		.audioTextHighlight{
			background-color: yellow;			
		}
		.audioButton {
			width:225px;
			height:40px;
			background-color:white;
			font-size:16px;
			font-weight:bold;
		}
		.selected {
			background: url("../images/ui-bg_highlight-soft_75_ffe45c_1x100.png") repeat-x scroll 50% 50% #F6F6F6 !important;
		}
	</style>
<body style="width:100%;height:100%;">
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="Service" />
		<jsp:param name="keepReferer" value="N" />
		<jsp:param name="mustLogin" value="N" />
		<jsp:param name="isHideTitle" value="Y" />
	</jsp:include>
	<div id="showContent" style="position:absolute;z-index:12;width:50%;" 
			class="ui-dialog ui-widget ui-widget-content ui-corner-all">
		<div class="ui-widget-header">
			<div id="renovationDiv">					
				<audio style="width:100%;height: 30px;vertical-align:middle;" id="renovationAudio" controls="controls"
				 ontimeupdate="displayAudioText(this,'<%=lang%>','<%=type%>')" 
				 onended="audioEnd()" preload="auto">
			 	 	<source height="100px" src="<%=audioSrc %>" autoplay="true" type="audio/mp3" />							
					<embed height="100" id="audioEmbed" controller="true" autoplay="true" autostart="True" src="<%=audioSrc %>" />						
				</audio>	
				<div style="padding-left:10px">
					<button onclick="audioControl('play', this);" id="play_btn" 
							class="ui-dialog ui-widget ui-widget-content ui-corner-all audioButton">
						Play
					</button>
					<button onclick="audioControl('pause', this);" 
							class="ui-dialog ui-widget ui-widget-content ui-corner-all audioButton">
						Pause
					</button>
					<%-- 
					<br/><br/>
					<div class="ui-widget" style="color:black;">
						<b>Volume: </b>
						<div id="volSlider">
						
						</div>
						0 
						<input type="range" min="0" max="100" value="60" step="10" style="width:55%"/> 100 
					</div>
					--%>
				</div> 	
				<br/>			
			</div>
			<div>
				<%--<span style="font-size:22px;"><b><u>Content</u></b></span> --%>
			</div>
		</div>
		<div style="background-color:#E8E8E8;height:500px">
			<div id="audioText" style="font-size:20px">
			</div>
		</div>
	</div>
	<form name="form1">
		<table border="0" style="width:100%;height:100%">	
		<!-- 				
			<tr style="width:100%;height:100%">					
				<td>
					<ul id="css3menu1" class="topmenu">						
						<li class="topfirst"><a href="#" style="height:18px;line-height:18px;"><span>Choose Language</span></a>
						<ul>
							<li><a href="index.jsp?lang=eng">English</a></li>
							<li><a href="index.jsp?lang=chi">Chinese</a></li>
							<li><a href="">Japanese</a></li>
						</ul></li>
						<li class="topmenu"><a href="" style="height:18px;line-height:18px;"><span>Choose Service</span></a>
						<ul>
							<li><a href=""><span>I. OB Service</span></a>
							<ul>
								<li><a href="">a. OB Registration (before advice explanation)</a></li>
								<li><a href="">b. OB Deposit (during advice explanation)</a></li>
								<li><a href="">c. OB Admission</a></li>
							</ul></li>
							<li><a href=""><span>II. Genral Service</span></a>
							<ul>
								<li><a href="">a. General Admission</a></li>
							</ul></li>
						</ul></li>
						<li class="toplast"><a href="" style="height:18px;line-height:18px;">Satisfaction Survey Questionaire</a></li>
					</ul>
				
				</td>
				
			</tr>
			<tr><td>&nbsp;</td></tr>
			 -->
			<tr align="center">
				<td>
					<label style="font-size:24px;color:#0033CC">
						<b>
							<u>Health Care Advisory</u>
						</b>
					</label>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>		
			<tr>
				<td>
					<div style="width:100%;height:100%;">
						<div style="width:50%;float:left;">
							<table style="width:100%;height:100%;">
								<tr>
							 		<td id="dynamicLoc">
							 		<%-- 
										<div id="renovationDiv">					
											<audio style="width:100%;vertical-align:middle;" id="renovationAudio" controls="controls"
											 ontimeupdate="displayAudioText(this,'<%=lang%>','<%=type%>')">
					   
										 	 	<source src="<%=audioSrc %>" autoplay="true" type="audio/mp3" />							
												<embed id="audioEmbed" controller="true" autoplay="true" autostart="True" src="<%=audioSrc %>" />						
											</audio>	
										--%>					
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div style="width:50%;float:right;background-color:#C0C0C0">
							<div style="background-color:white; padding:10px">
								<div id="audioText1" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" style="font-size:18px;text-align:center;border:2px outset;"><i><u><b>Health Care Advisory</b></u></i>
								<br> 	
									<u>This advisory is for the information of <b>ALL</b> patients who are hospitalized at Hong Kong 
									Adventist Hospital ("the Hospital"). <b>Please read this carefully BEFORE selecting your hospital room.</b></u>
								</div>
								<br>
								<div style="border:2px outset;" id="audioText2" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>Room Category:</b> In Hong Kong, most hospitals vary their <i><u><b>charges according to
									 Room Category</b></u></i> (Standard, Semi-Private, Private and VIP). <i><b>"Private Room" is any 
									 type of single occupancy room regardless of the number of beds.  The higher category room,
									  the higher the accompanying charges will be applied. Please check with your insurance
									   company to confirm which categories are covered.</b></i>
								</div>
								<br>
								<div style="border:2px outset;" id="audioText3" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>Room Rates:</b> The daily room charge <b>includes nursing care</b> but not meals, physician fees, 
									medication fees, diagnostic tests, laboratory, Operating Theatre charges and other
									 ancillary services.  
									<br><br>
									<u>For admissions to the General Unit (commences upon registration), a full-day rate is 
									charged for the first 24 hours or less.  Thereafter, if the subsequent stay is 
									less than 12 hours, a half-day rate will be charged otherwise a full-day rate will be applied.  (Not applicable to package)</u>
									<br><br>
									<u>For new admissions or each transfer to the Intensive Care Unit (ICU) / High Dependency Unit (HDU), the above rules will apply.</u>
									 If <u>Isolation</u> is necessary, an isolation charge will apply. 
									<br><br>
									<b>No allowance is given for leave from hospital taken at your convenience.</b>
								</div>
								<br>
								<div style="border:2px outset;" id="audioText4" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>Physician Fees:</b> Besides in-house General Practitioners, our hospital does not regulate physician fees
									 which may vary with each doctor and <u>usually according to the room category</u>.  You are advised to clarify
									  expected costs with your doctor(s) before admission.
									<br><br>
									Patients treated or admitted to the Hospital are under the direct care, supervision and 
									responsibility of their attending physician. In general, most physicians, specialists,
									 surgeons and independent contractors furnishing services to patients are not employees
									  or agents of the Hospital.  Please contact the Admission Office Staff for details.						
								</div>	
								<br>
								<div style="border:2px outset;" id="audioText5" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>Ancillary Charges:</b><u> Ancillary charges such as Operating Room, Cardiac Catheterization & Interventional Center
									 etc will vary according to the room category.</u> Surcharges apply for the weekend,
									 public holidays, non-office hours or non-scheduled time.
									  <b>Please refer to our Fee Schedule for details.</b><u> Hospital office hours are from 8:30a.m.
									   to 5 p.m. (Mondays to Fridays) and 8:30 a.m. to 12 noon (Sundays).</u> 
									<br><br>
									Diagnosis imaging, laboratory and physiotherapy procedures may include blood drawing,
									 medical or surgical treatment, and other Hospital’s services rendered under
									  the general/special instructions of the attending physician.						
								</div>
								<br>
								<div style="border:2px outset;" id="audioText6" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>Room Change:</b> <u>Room rates are subject to the highest room 
									category on the day of change.</u> If you want to change room/bed, please 
									make arrangements with nurses and verify all necessary charges and room
									 rate with Admission Office. <u>Most insurance companies do not cover the bed movement
									 charge.</u>  We will try every effort to accommodate your request depending on room
									 availability.  The hospital reserves the right to make changes of room/bed for 
									 patients as needed.						
								</div>
								<br>
								<div style="border:2px outset;"  id="audioText7" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>There is a 48 hours requirement notice for room category change following
									 non-packaged surgery.  Once a package has commenced, it cannot be down-graded
									 but can be upgraded. If an upgrade applies, the entire package will be charged
									  at the higher rate.</b>
								</div>
								<br>
								<div style="border:2px outset;" id="audioText8" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>Advance Payment:</b> Advance payment is required upon admission and may be
									 settled by cash, EPS, bank draft, Union Card or credit card.
								</div>
								<br>
								<div style="border:2px outset;" id="audioText9" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>Settlement of Hospital Accounts:</b> <u>Interim bills are issued every five days or 
									if the outstanding balance reaches HK$100,000 which is payable within two days
									 upon bills received.</u> All hospital accounts must be settled before discharge and a 
									 2% surcharge per month will be made on all accounts not settled within 30 days. 
									  <i><b>Kindly note that at least one hour is needed to process billing, discharge medication 
									  and other documentation.</b></i>
								</div>
								<br>
								<div style="border:2px outset;" id="audioText10" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>Valuables or Large Sum of Money:</b> We strongly advise you not to bring along valuables or
									 large sums of money to the hospital.  In case you are unable to leave valuables at home, 
									 you can put them into the safe provided by the hospital. <i><b>The hospital is not liable
									  for loss or damage to personal items of unusual or any value.</b></i>
								</div>
								<br>
								<div style="border:2px outset;" id="audioText11" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>If you have any questions regarding your hospital bills, please feel free to ask the
									 Admission Office staff. 
									A Fee Schedule is also available for your reference.</b>						
								</div>
								<br>
								<div style="border:2px outset;" id="audioText12" onClick="changeAudioTimer(this,'<%=lang%>','<%=type%>')" >
									<b>Thank you!</b>
								</div>
							</div>
						</div>
					</div>
				</td>
			</tr>	
		</table>
		<hr>
		<div style="text-align:center;width:100%">
			<button style="font-size:24px;" class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' onclick="return submitAction();">
				<img src="../images/undo2.gif"/>&nbsp;Back to Home
			</button>			
		</div>	
	</form>
</body>
	<jsp:include page="../common/footer.jsp" flush="false" />
</html:html>

<script type="text/javascript"> 
var scrollAudio, scrollNote;
var player = document.getElementById('renovationAudio');

$(document).ready(function() {
	$('div#showContent').css('top', $('#dynamicLoc').position().top+$('#dynamicLoc').height());
	$('div#showContent').css('width', $('#dynamicLoc').parent().parent().width());
	$('div#showContent').css('left', $('#dynamicLoc').parent().parent().position().left);
	
	
	$(window).scroll(function () { 
			if ($(window).scrollTop() > $('#dynamicLoc').position().top+$('#dynamicLoc').height()) {
				$('div#showContent').css('top', $(window).scrollTop()+10);
			}
			else {
				$('div#showContent').css('top', $('#dynamicLoc').position().top+$('#dynamicLoc').height());
			}
   		}).trigger('scroll');
	
	//volController();
	//$('input[type=range]').change(function() {
	//	document.getElementById('renovationAudio').volume = $(this).val()/100;
	//});	
});

function audioEnd() {
	$('body').scrollTop(0).trigger('scroll');
}
/*
function volController() {
	$( "div#volSlider" ).slider({
	    min: 0,
	    max: 1,
		animate: true,
		range: 'min',
	    step: 0.1,
	    value: player.volume,
	    slide: function( event, ui ) {
	    	player.volume = ui.value;
	    }
	});
}
*/
function audioControl(command, source) {
	if (command == 'play') {
		document.getElementById('renovationAudio').play();
		$('.selected').removeClass('selected');
		$(source).addClass('selected');
	}
	else if (command == 'pause') {
		document.getElementById('renovationAudio').pause();
		$('.selected').removeClass('selected');
		$(source).addClass('selected');
	}
}

function elementInViewport(el) {
  var top = el.offsetTop;
  var left = el.offsetLeft;
  var width = el.offsetWidth;
  var height = el.offsetHeight;

  while(el.offsetParent) {
    el = el.offsetParent;
    top += el.offsetTop;
    left += el.offsetLeft;
  }

  return (
    top >= window.pageYOffset &&
   
    (top + height) <= (window.pageYOffset + window.innerHeight)
  );
}

function displayAudioText(obj,lang,type){
	var audioTime = obj.currentTime;
	var curTextPosition;
	
	if(type == 'generalAdmission'){
		if(lang == 'eng'){
			if(audioTime>0 && audioTime<4){			 
				$("#audioText1").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText1').html());	
				if(elementInViewport(document.getElementById("audioText1")) == false){
					curTextPosition = $("#audioText1").position().top;
				}
			}else if(audioTime>4 && audioTime<15){
				$("#audioText2").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText2').html());
				if(elementInViewport(document.getElementById("audioText2")) == false){
					curTextPosition = $("#audioText2").position().top;
				}
			}else if(audioTime>15 && audioTime<65){
				$("#audioText3").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText3').html());
				if(elementInViewport(document.getElementById("audioText3")) == false){
					curTextPosition = $("#audioText3").position().top;
				}
			}else if(audioTime>65 && audioTime<86){
				$("#audioText4").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText4').html());
				if(elementInViewport(document.getElementById("audioText4")) == false){
					curTextPosition = $("#audioText4").position().top;
				}
			}else if(audioTime>86 && audioTime<112){
				$("#audioText5").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText5').html());
				if(elementInViewport(document.getElementById("audioText5")) == false){
					curTextPosition = $("#audioText5").position().top;
				}
			}else if(audioTime>112 && audioTime<134){
				$("#audioText6").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText6').html());
				if(elementInViewport(document.getElementById("audioText6")) == false){
					curTextPosition = $("#audioText6").position().top;
				}
			}else if(audioTime>134 && audioTime<163){
				$("#audioText7").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText7').html());
				if(elementInViewport(document.getElementById("audioText7")) == false){
					curTextPosition = $("#audioText7").position().top;
				}
			}else if(audioTime>163 && audioTime<178){
				$("#audioText8").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText8').html());
				if(elementInViewport(document.getElementById("audioText8")) == false){
					curTextPosition = $("#audioText8").position().top;
				}
			}else if(audioTime>178 && audioTime<207){
				$("#audioText9").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText9').html());
				if(elementInViewport(document.getElementById("audioText9")) == false){
					curTextPosition = $("#audioText9").position().top;
				}
			}else if(audioTime>207 && audioTime<217){
				$("#audioText10").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText10').html());
				if(elementInViewport(document.getElementById("audioText10")) == false){
					curTextPosition = $("#audioText10").position().top;
				}
			}else if(audioTime>217 && audioTime<228){
				$("#audioText11").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText11').html());
				if(elementInViewport(document.getElementById("audioText11")) == false){
					curTextPosition = $("#audioText11").position().top;
				}
			}else if(audioTime>228 && audioTime<232){
				$("#audioText12").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText12').html());
				if(elementInViewport(document.getElementById("audioText12")) == false){
					curTextPosition = $("#audioText12").position().top;
				}
			}else{
				//$(".audioTextHighlight").removeClass("audioTextHighlight");
				//$('#audioText').html('&nbsp;');
				//curTextPosition = 0;
			}
		}	
	}else if(type=='obService'){
		if(lang == 'eng'){
			if(audioTime>0 && audioTime<4){			 
				$("#audioText1").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText1').html());				
				if(elementInViewport(document.getElementById("audioText1")) == false){
					curTextPosition = $("#audioText1").position().top;					
				}
			}else if(audioTime>4 && audioTime<15){
				$("#audioText2").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText2').html());
				if(elementInViewport(document.getElementById("audioText2")) == false){
					curTextPosition = $("#audioText2").position().top;					
				}
			}else if(audioTime>15 && audioTime<59){
				$("#audioText3").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText3').html());
				if(elementInViewport(document.getElementById("audioText3")) == false){
					curTextPosition = $("#audioText3").position().top;
				}
			}else if(audioTime>59 && audioTime<80){
				$("#audioText4").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText4').html());
				if(elementInViewport(document.getElementById("audioText4")) == false){
					curTextPosition = $("#audioText4").position().top;
				}
			}else if(audioTime>80 && audioTime<106){
				$("#audioText5").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText5').html());
				if(elementInViewport(document.getElementById("audioText5")) == false){
					curTextPosition = $("#audioText5").position().top;
				}
			}else if(audioTime>106 && audioTime<127){
				$("#audioText6").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText6').html());
				if(elementInViewport(document.getElementById("audioText6")) == false){
					curTextPosition = $("#audioText6").position().top;
				}
			}else if(audioTime>127 && audioTime<138){
				$("#audioText7").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText7').html());
				if(elementInViewport(document.getElementById("audioText7")) == false){
					curTextPosition = $("#audioText7").position().top;
				}
			}else if(audioTime>138 && audioTime<152){
				$("#audioText8").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText8').html());
				if(elementInViewport(document.getElementById("audioText8")) == false){
					curTextPosition = $("#audioText8").position().top;
				}
			}else if(audioTime>152 && audioTime<183){
				$("#audioText9").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText9').html());
				if(elementInViewport(document.getElementById("audioText9")) == false){
					curTextPosition = $("#audioText9").position().top;
				}
			}else if(audioTime>183 && audioTime<192){
				$("#audioText10").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText10').html());
				if(elementInViewport(document.getElementById("audioText10")) == false){
					curTextPosition = $("#audioText10").position().top;
				}
			}else if(audioTime>192 && audioTime<203){
				$("#audioText11").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText11').html());
				if(elementInViewport(document.getElementById("audioText11")) == false){
					curTextPosition = $("#audioText11").position().top;
				}
			}else if(audioTime>203 && audioTime<207){
				$("#audioText12").addClass("audioTextHighlight").siblings().removeClass('audioTextHighlight');
				$('#audioText').html($('#audioText12').html());
				if(elementInViewport(document.getElementById("audioText12")) == false){
					curTextPosition = $("#audioText12").position().top;
				}
			}else{
				//$(".audioTextHighlight").removeClass("audioTextHighlight");
				//$('#audioText').html('&nbsp;');
				//curTextPosition = 0;
			}
		}
	}
	
	$("body").scrollTop(curTextPosition).trigger('scroll');
}

function changeAudioTimer(obj,lang,type){	
	var id = $(obj).attr('id');	
	var audio = document.getElementById("renovationAudio");
	if(type == 'generalAdmission'){
		if(lang == 'eng'){
			if(id == 'audioText1'){
				audio.currentTime = 0;
			}else if(id == 'audioText2'){
				audio.currentTime = 4;
			}else if(id == 'audioText3'){
				audio.currentTime = 15;
			}else if(id == 'audioText4'){
				audio.currentTime = 65;
			}else if(id == 'audioText5'){
				audio.currentTime = 86;
			}else if(id == 'audioText6'){
				audio.currentTime = 112;
			}else if(id == 'audioText7'){
				audio.currentTime = 134;
			}else if(id == 'audioText8'){
				audio.currentTime = 163;
			}else if(id == 'audioText9'){
				audio.currentTime = 178;
			}else if(id == 'audioText10'){
				audio.currentTime = 207;
			}else if(id == 'audioText11'){
				audio.currentTime = 217;
			}else if(id == 'audioText12'){
				audio.currentTime = 228;
			}
		}	
	}else if(type=='obService'){
		if(lang == 'eng'){
			if(id == 'audioText1'){
				audio.currentTime = 0;
			}else if(id == 'audioText2'){
				audio.currentTime = 4;
			}else if(id == 'audioText3'){
				audio.currentTime = 15;
			}else if(id == 'audioText4'){
				audio.currentTime = 59;
			}else if(id == 'audioText5'){
				audio.currentTime = 80;
			}else if(id == 'audioText6'){
				audio.currentTime = 106;
			}else if(id == 'audioText7'){
				audio.currentTime = 127;
			}else if(id == 'audioText8'){
				audio.currentTime = 138;
			}else if(id == 'audioText9'){
				audio.currentTime = 152;
			}else if(id == 'audioText10'){
				audio.currentTime = 183;
			}else if(id == 'audioText11'){
				audio.currentTime = 192;
			}else if(id == 'audioText12'){
				audio.currentTime = 203;
			}
		}
	}
}

function submitAction() {
	showLoadingBox();
	document.form1.action = "../patient/";
	document.form1.submit();
	hideLoadingBox();
}
</script> 


