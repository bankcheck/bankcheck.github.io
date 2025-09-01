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
<html>
<head>

<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />	
</jsp:include>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

<link rel="stylesheet"  href="bootstrap.min.css"/>
<link rel="stylesheet" href="../css/ic.css"/>
<link rel="stylesheet" href="navbar-fixed-left.min.css"/>
  
 <script src="jquery-3.2.1.min.js"></script>
 <script type="text/javascript" src="bootstrap.min.js"></script>
</head>
<body>
	<nav class="navbar navbar-inverse navbar-fixed-left">
	  <div class="container-fluid">
	    <div class="navbar-header">
	      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>                        
	      </button>
	      <a class="navbar-brand" href="javascript:void(0);" onclick="getICPageContent('Home','Home','');return false;">Infection Control <span class="glyphicon glyphicon-home"></span></a>
	      <%if (userBean.isAdmin()|| (userBean.isGroupID("icAdmin")&&ConstantsServerSide.isTWAH()) 
	      	|| ("4112".equals(userBean.getStaffID())&&ConstantsServerSide.isHKAH())) { %>
	      	<button class="btn btn-danger navbar-btn" id="adminBtn"><span class="glyphicon glyphicon-wrench"/>Admin</button>
	     <%} %> 
	<%if (ConstantsServerSide.isTWAH()) {%>
		    <div class="collapse navbar-collapse" id="myNavbar">
		      <ul class="nav navbar-nav">
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpScope','icSubPage','427');return false;">Scope of Service</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpDeptP','icSubPage','412');return false;">Department Policy</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icPrac','icSubPage','');return false;">Infection Control Practice</a></li>
				<li>
			     <a data-toggle="collapse" href="#collapse_icc">Infection Control Committee<b class="caret"></b></a>
			      <div id="collapse_icc" class="panel-collapse collapse">
			        <ul class="list-group">
			          <li class="list-group-item"><a href="javascript:void(0);" onclick="getICPageContent('icpCPOrgCht','icSubPage','417');return false;">Organisation Chart</a></li>
		              <li class="list-group-item"><a href="javascript:void(0);" onclick="getICPageContent('icpCPMin','icSubPage','416');return false;">Minutes</a></li>
			        </ul>
			       </div>
			     </li>	        
		        <li>
		        	<a data-toggle="collapse" href="#collapse_lnl">Link Nurse and Link Person<b class="caret"></b></a>
		        	<div id="collapse_lnl" class="panel-collapse collapse">
			        <ul class="list-group">
			          <li class="list-group-item"><a href="javascript:void(0);" onclick="getICPageContent('icpLOrgC','icSubPage','418');return false;">Organisation Chart</a></li>
			          <li class="list-group-item"><a href="javascript:void(0);" onclick="getICPageContent('icpLMin','icSubPage','419');return false;">Minutes</a></li>
			        </ul>
			       </div>
		        </li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpProg','icSubPage','423');return false;">Program</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpFit','icSubPage','426');return false;">Fit Test</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpAudit','icSubPage','413');return false;">Audit & Surveillance</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icVideo','icSubPage','768');return false;">Video</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpForm','icSubPage','420');return false;">Form</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpPoster','icSubPage','421');return false;">Poster</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpNewsletter','icSubPage','425');return false;">Newsletter</a></li>
		        
		      </ul>
		    </div>
	<%} else { %>
			<div class="collapse navbar-collapse" id="myNavbar">
		      <ul class="nav navbar-nav">
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpScope','icSubPage','743');return false;">Scope of Service</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpPolicy','icSubPage','740');return false;">Policy & Guideline</a></li>
				<li>
			     <a data-toggle="collapse" href="#collapse_icc">Infection Control Committee<b class="caret"></b></a>
			      <div id="collapse_icc" class="panel-collapse collapse">
			        <ul class="list-group">
			          <li class="list-group-item"><a href="javascript:void(0);" onclick="getICPageContent('icpCPOrgCht','icSubPage','745');return false;">Organisation Chart</a></li>
		              <li class="list-group-item"><a href="javascript:void(0);" onclick="getICPageContent('icpCPMin','icSubPage','744');return false;">Minutes</a></li>
			        </ul>
			       </div>
			     </li>	        
		        <li>
		        	<a data-toggle="collapse" href="#collapse_lnl">Link Nurse and Link Person<b class="caret"></b></a>
		        	<div id="collapse_lnl" class="panel-collapse collapse">
			        <ul class="list-group">
			          <li class="list-group-item"><a href="javascript:void(0);" onclick="getICPageContent('icpLOrgC','icSubPage','746');return false;">Organisation Chart</a></li>
			          <li class="list-group-item"><a href="javascript:void(0);" onclick="getICPageContent('icpLMin','icSubPage','747');return false;">Minutes</a></li>
			        </ul>
			       </div>
		        </li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpProg','icSubPage','751');return false;">Program</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpFit','icSubPage','754');return false;">Fit Test</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpAudit','icSubPage','741');return false;">Audit & Surveillance</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icVideo','icSubPage','769');return false;">Video</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpForm','icSubPage','748');return false;">Form</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpPoster','icSubPage','749');return false;">Poster</a></li>
		        <li><a href="javascript:void(0);" onclick="getICPageContent('icpNewsletter','icSubPage','752');return false;">Newsletter</a></li>
		      </ul>
		    </div>
	<%} %>	 
	  </div>
	 </div>
	</nav>
<div id="icHome">
	<div class="container" >
	<div class="row">	
	  <div class="col-md-8">  
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
		<% String[] galleryImage = getImage();
			if (galleryImage.length > 0) {
		%>
			  <ol class="carousel-indicators">
				  <%for (int i = 0; i< galleryImage.length; i++) { 
				  	if(galleryImage[i] != null ){ %>
				  	  <li data-target="#myCarousel" data-slide-to="<%=i%>" class="<%=i == 0?"active":"" %>"></li> 
				  <%}} %>
			  </ol>
			
			  <!-- Wrapper for slides -->
			  <div class="carousel-inner<%=ConstantsServerSide.isHKAH()?" hkah":" twah"%>" role="listbox">
			  	<%for (int i = 0; i< galleryImage.length; i++) {
			  		if(galleryImage[i] != null){%>
			  		<div class="item <%=i == 0?"active":"" %>">
			  			
			  			<img class="img-responsive" src="<%=ConstantsServerSide.isHKAH()?"/upload/Infection%20Control/portal/Photos/":"/upload/Infection%20Control/Photo/"%><%=galleryImage[i] %>" alt="IC"/>
			            <div class="carousel-caption">
				        <h1></h1>
				      </div>
			    	</div>
			  	<%}} %>
			  </div>		
		<%	} %>
		  <!-- Left and right controls -->
		  <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev"	>
		    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
		    <span class="sr-only">Previous</span>
		  </a>
		  <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
		    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
		    <span class="sr-only">Next</span>
		  </a>
		</div>
	  </div>
	  <div class="col-md-4">
	       <!-- Fluid width widget -->        
	    	<div class="panel panel-danger">
	           <div class="panel-heading">
	               <h3 class="panel-title">
	                   <span class="glyphicon glyphicon-calendar"></span> 
	                   Upcoming Events
	               </h3>
	           </div>
	           <div class="panel-body" id="icCalendar">
	           </div>
	       </div>
	  </div>
	</div>
	</div>
	<div class="container">   
	<%if (ConstantsServerSide.isTWAH()) {%> 
		    <div class="row">
				<div class="col-md-3">
					<div class="panel panel-danger">
						<div class="panel-heading">
							<h3 class="panel-title">Information</h3>
						</div>
						<div class="panel-body" id="icInform"></div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="panel panel-danger">
						<div class="panel-heading">
							<h3 class="panel-title">Infectious Disease</h3>
						</div>
						<div class="panel-body" id="icDis"></div>
				</div>
				</div>
				<div class="col-md-3">
					<div class="panel panel-danger">
						<div class="panel-heading">
							<h3 class="panel-title">Centre for Health Protection</h3>
						</div>
						<div class="panel-body">
						<a href="http://www.chp.gov.hk/en/index.html" target="_blank">
					    		<img class="img-responsive" src="../images/ic/5Moments_Image.gif"/></a>
						</div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="panel panel-danger">
						<div class="panel-heading">
							<h3 class="panel-title">Isolation & Notification</h3>
						</div>
						<div class="panel-body" id="icIsolate"></div>
					</div>
				</div>		
				</div>
	<%} else { %>
		    <div class="row">
				<div class="col-md-4">
				
					<div class="panel panel-danger">
						<div class="panel-heading">
							<h3 class="panel-title">Alert <span class="glyphicon glyphicon-bell"/></h3>	
						</div>
						<div class="panel-body" id="icInform"></div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="panel panel-danger">
						<div class="panel-heading">
							<h3 class="panel-title">News Update <span class="glyphicon glyphicon-globe"/></h3>
						</div>
						<div class="panel-body" id="icDis"></div>
				</div>
				</div>
				<div class="col-md-4">
					<div class="panel panel-danger">
						<div class="panel-heading">
							<h3 class="panel-title">Isolation Precautions  <span class="glyphicon glyphicon-alert"/></h3>
						</div>
						<div class="panel-body" id="icIsolate"></div>
					</div>
				</div>		
				</div>	
	<%} %>
</div>
</div>
<div id="icSubPage" style="display:none;"></div>
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document" >
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel"></h5>
      </div>
      <div class="modal-body">
      	<div class="embed-responsive embed-responsive-16by9">
	      	<video id="icVideo" class="embed-responsive-item">
			    <source src="" type="video/mp4">
			</video>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" id="closeVideo">Close</button>
      </div>
    </div>
  </div>
</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html>

<script type="text/javascript">
$(document).ready(function() { 
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