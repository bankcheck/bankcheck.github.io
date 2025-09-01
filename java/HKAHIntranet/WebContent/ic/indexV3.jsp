<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
public String[] getImage() {
	String[] imageName = null;
	try {
		File directory = new File("//www-server/document/Upload/Infection Control/portal/Photos");
		if (ConstantsServerSide.isTWAH()) {
		 directory = new File("//192.168.0.20/document/Upload/Infection Control/Photo");
		}
		String[] children = directory.list();
		if (children.length > 0) {
			imageName = new String[children.length];
			for (int i = 0; i < children.length; i++) {
				if (children[i] != null && (children[i].toUpperCase().indexOf(".PNG") > 0 
						||children[i].toUpperCase().indexOf(".JPG") > 0
						|| children[i].toUpperCase().indexOf(".GIF") > 0 )) {
					imageName[i] = children[i];
				}
			}
		}
	} catch (Exception e) {
	}
	return imageName;
}
%>
<%	
UserBean userBean = new UserBean(request);
response.setHeader("Pragma","no-cache");
response.setHeader("Pragma-directive","no-cache");
response.setHeader("Cache-directive","no-cache");
response.setHeader("Cache-control","no-cache");
response.setHeader("Expires","0");
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
<head>

<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />	
</jsp:include>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<link rel="stylesheet" href="../css/w3.hkah.css"/>
<link rel="stylesheet" href="../css/fullcalendar.min.css"/>
<script type="text/javascript" src="jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<html:rewrite page="/js/moment.min.js" />"></script>
<script type="text/javascript" src="<html:rewrite page="/js/fullcalendar.min.js" />"></script>
	<style>
	html,body,h1,h2,h3,h4,h5 {font-family: "Raleway", sans-serif}
	.mySlides {display:none}
	.w3-left, .w3-right, .w3-badge {cursor:pointer}
	.w3-badge {height:13px;width:13px;padding:0}
	
/* 	#cal {
    width: 200px;
    margin: 0 auto;
    font-size: 10px;
	}
	.fc-header-title h2 {
	    font-size: .9em;
	    white-space: normal !important;
	}
	.fc-view-month .fc-event, .fc-view-agendaWeek .fc-event {
	    font-size: 0;
	    overflow: hidden;
	    height: 2px;
	}
	.fc-view-agendaWeek .fc-event-vert {
	    font-size: 0;
	    overflow: hidden;
	    width: 2px !important;
	}
	.fc-agenda-axis {
	    width: 20px !important;
	    font-size: .7em;
	}
	
	.fc-button-content {
	    padding: 0;
	} */
	
	video {
	  width: 100%;
	  height: auto;
	}
	</style>
</head>
<body class="w3-light-grey">	

<!-- Sidebar/menu -->
<nav class="w3-sidebar w3-bar-block w3-collapse ah-pink w3-animate-left w3-card " style="z-index:3;" id="mySidebar">
  <div class="w3-container w3-row">
    <div class="w3-col s12 w3-bar">
      <span>Welcome, <strong><%=userBean.getUserName() %></strong></span><br>
      <a href="#" class="w3-bar-item w3-button w3-black"><i class="fa fa-cog"></i>Admin Panel</a>
    </div>
  </div>
  <hr>
  
  <div class="w3-bar-block ah-pink">
    <a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-dark-grey w3-hover-black" onclick="w3_close()" title="close menu"><i class="fa fa-remove fa-fw"></i>  Close Menu</a>
    <a href="#" class="w3-bar-item w3-button w3-padding w3-blue"><i class="fa fa-users fa-fw"></i>  Overview</a>
    <a href="#" class="w3-bar-item w3-button w3-padding"><i class="fa fa-eye fa-fw"></i>  Views</a>
    <a href="#" class="w3-bar-item w3-button w3-padding"><i class="fa fa-users fa-fw"></i>  Traffic</a>
    <a href="#" class="w3-bar-item w3-button w3-padding"><i class="fa fa-bullseye fa-fw"></i>  Geo</a>
    <a href="#" class="w3-bar-item w3-button w3-padding"><i class="fa fa-diamond fa-fw"></i>  Orders</a>
    <a href="#" class="w3-bar-item w3-button w3-padding"><i class="fa fa-bell fa-fw"></i>  News</a>
    <a href="#" class="w3-bar-item w3-button w3-padding"><i class="fa fa-bank fa-fw"></i>  General</a>
    <a href="#" class="w3-bar-item w3-button w3-padding"><i class="fa fa-history fa-fw"></i>  History</a>
    <a href="#" class="w3-bar-item w3-button w3-padding"><i class="fa fa-cog fa-fw"></i>  Settings</a><br><br>
  </div>
</nav>


<!-- Overlay effect when opening sidebar on small screens -->
<div class="" onclick="w3_close()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>

<!-- !PAGE CONTENT! -->
<div class="w3-main" style="margin-left:200px;margin-top:10px;">


<div class="w3-row-padding w3-margin-bottom w3-hide-small">
 <div class="w3-twothird">
 	<div class="w3-row">
	  <div class="w3-col" style="width:90%">
		 <div class="w3-container">
			 <div class="w3-content w3-display-container" style="max-width:500px">
			 	<% String[] galleryImage = getImage();
					if (galleryImage.length > 0) {
						for (int i = 0; i< galleryImage.length; i++) { 
						  	if(galleryImage[i] != null ){
				%>
					 <img class="mySlides" src="<%=ConstantsServerSide.isHKAH()?"http://www-server/upload/Infection%20Control/portal/Photos/":"/upload/Infection%20Control/Photo/"%><%=galleryImage[i] %>" style="width:100%"></img>					
				<%}}} %>
				  <img class="mySlides" src="http://www-server/upload/Infection%20Control/portal/Photos/5Moments_Image.gif" style="width:100%"></img>
				  <img class="mySlides" src="http://www-server/upload/Infection%20Control/portal/Photos/Drill%201.jpg" style="width:100%"></img>
				  <img class="mySlides" src="http://www-server/upload/Infection%20Control/portal/Photos/HH%202.jpg" style="width:100%"></img>
			</div>
			<div class="w3-center">
			  <div class="w3-section">
			    <button class="w3-button w3-light-grey" onclick="plusDivs(-1)">❮ </button>
			    <button class="w3-button w3-light-grey" onclick="plusDivs(1)">❯</button>
			  </div>
			</div>
		</div>
      </div>
	</div>
    </div>
    <div class="w3-third">
		<div class="w3-card-4 w3-border-pale-red">
		
		<header class="w3-container ah-pink ">
		  <h4>COVID19 Vaccination Promotional Talk</h4>
		</header>
		
		<div class="w3-container" id="cal" >
		<video id="video1"  controls="" muted autoplay src="http://www-server/Swf/ic/COVID19%20Vaccination%20Promotional%20Talk%2017%20June%202021(Dr_%20Seto%20Wing%20Hong).mp4">
				  <source src="" type="video/mp4">
		</video>
		</div>
		
		</div>
    </div>
  </div>
    <div class="w3-row-padding" style="margin:0 2px">
      <div class="w3-third w3-margin-bottom">
        <ul class="w3-ul w3-border w3-white w3-center w3-opacity w3-hover-opacity-off">
          <li class="ah-pink w3-xlarge w3-padding-10">Alert <span class="glyphicon glyphicon-bell"/></li>
          <li class="w3-padding-5">Web Design</li>
          <li class="w3-padding-5">Photography</li>
          <li class="w3-padding-5">1GB Storage</li>
          <li class="w3-padding-5">Mail Support</li>

          <li class="w3-light-grey w3-padding-24">
            <button class="w3-button w3-teal w3-padding-large w3-hover-black">Sign Up</button>
          </li>
        </ul>
      </div>
      
      <div class="w3-third w3-margin-bottom">
        <ul class="w3-ul w3-border w3-white w3-center w3-opacity w3-hover-opacity-off">
          <li class="w3-black w3-xlarge w3-padding-10">Pro</li>
          <li class="w3-padding-5">Web Design</li>
          <li class="w3-padding-5">Photography</li>
          <li class="w3-padding-5">50GB Storage</li>
          <li class="w3-padding-5">Endless Support</li>

          <li class="w3-light-grey w3-padding-24">
            <button class="w3-button w3-teal w3-padding-large w3-hover-black">Sign Up</button>
          </li>
        </ul>
      </div>
      
      <div class="w3-third">
        <ul class="w3-ul w3-border w3-white w3-center w3-opacity w3-hover-opacity-off">
          <li class="w3-black w3-xlarge w3-padding-10">Premium</li>
          <li class="w3-padding-5">Web Design</li>
          <li class="w3-padding-5">Photography</li>
          <li class="w3-padding-5">Unlimited Storage</li>
          <li class="w3-padding-5">Endless Support</li>
          <li class="w3-light-grey w3-padding-24">
            <button class="w3-button w3-teal w3-padding-large w3-hover-black">Sign Up</button>
          </li>
        </ul>
      </div>
    </div>
  </div>


  <!-- End page content -->
</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>

<script type="text/javascript">
$(document).ready(function() { 
	
/* 	 $('#cal').fullCalendar({
		 theme: true,
	        header: {
	            left: 'prev,next today',
	            center: 'title',
	            right: 'month,agendaWeek,agendaDay'
	        },
	        editable: true
	    }); */
	    carousel();

	getICPageContent('disease','icDis','');
	getICPageContent('information','icInform','');
	getICPageContent('isolation','icIsolate','768');
	getICPageContent('calendar','icCalendar','');
	
	$('#adminBtn').click(function() {
		window.open('../ic/webinfo_list.jsp', '_blank');
	});
	
	$('#exampleModal').on('show.bs.modal', function (event) {
		  var button = $(event.relatedTarget); // Button that triggered the modal
		  var recipient = button.data('title'); // Extract info from data-* attributes
		  var videourl = button.data('video');
		  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
		  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
		  var modal = $(this);
		  modal.find('.modal-title').text(recipient);
		  <% if (ConstantsServerSide.isTWAH()) {%>
		  	$('#exampleModal video source').attr('src', "http://192.168.0.20/upload/Infection%20Control/Video/"+videourl);
		  <% } else { %>
		  	$('#exampleModal video source').attr('src', "http://160.100.2.80/upload/Infection%20Control/portal/Video/"+videourl);
		  <% } %>
		  $("#exampleModal video")[0].controls = true;
		  $("#exampleModal video")[0].load();
		  $("#exampleModal video")[0].play();
		});
	
	
	$('#closeVideo').on('click', function(event) {
		$('video').trigger('pause');
	});

});

//Get the Sidebar
var mySidebar = document.getElementById("mySidebar");

// Get the DIV with overlay effect
var overlayBg = document.getElementById("myOverlay");

// Toggle between showing and hiding the sidebar, and add overlay effect
function w3_open() {
  if (mySidebar.style.display === 'block') {
    mySidebar.style.display = 'none';
    overlayBg.style.display = "none";
  } else {
    mySidebar.style.display = 'block';
    overlayBg.style.display = "block";
  }
}

// Close the sidebar with the close button
function w3_close() {
  mySidebar.style.display = "none";
  overlayBg.style.display = "none";
}

// Slideshow
var slideIndex = 1;
showDivs(slideIndex);

function plusDivs(n) {
  showDivs(slideIndex += n);
}

function currentDiv(n) {
  showDivs(slideIndex = n);
}
function showDivs(n) {
	  var i;
	  var x = document.getElementsByClassName("mySlides");
	  if (n > x.length) {slideIndex = 1}
	  if (n < 1) {slideIndex = x.length}
	  for (i = 0; i < x.length; i++) {
	    x[i].style.display = "none";  
	  }

	  x[slideIndex-1].style.display = "block";  
}

function carousel() {
	  var i;
	  var x = document.getElementsByClassName("mySlides");
	  for (i = 0; i < x.length; i++) {
	    x[i].style.display = "none";  
	  }
	  slideIndex++;
	  if (slideIndex > x.length) {slideIndex = 1}    
	  x[slideIndex-1].style.display = "block";  
	  setTimeout(carousel, 2000); // Change image every 2 seconds
	}

function myAccFunc() {
	  var x = document.getElementById("demoAcc");
	  if (x.className.indexOf("w3-show") == -1) {
	    x.className += " w3-show";
	    x.previousElementSibling.className += " w3-green";
	  } else { 
	    x.className = x.className.replace(" w3-show", "");
	    x.previousElementSibling.className = 
	    x.previousElementSibling.className.replace(" w3-green", "");
	  }
	}

function w3_open() {
	  document.getElementById("mySidebar").style.display = "block";
	}

	function w3_close() {
	  document.getElementById("mySidebar").style.display = "none";
	}

function getICPageContent(category,id,docID) {
	$.ajax({
		url:   "../ic/testNewContent.jsp",
		async: false,
		data: "Category="+category+"&docID="+docID+"&timestamp="+<%=(new java.util.Date()).getTime() %>,
		success: function(values){
			if (id == 'icSubPage') {
				$('div#icHome').css('display', 'none');
				$('div#'+id).html(values);
				$('div#'+id).css('display', 'block');
			} else if (category == 'Home') {
				$('div#icSubPage').css('display', 'none');
				$('div#icHome').css('display', 'block');
				$('div#icSubPage').html('');
			} else {
			$('div#'+id).html(values);
			}
		},
		error: function() {
			alert('error');
		}
	});
}

</script>