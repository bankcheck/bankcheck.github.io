<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%
String patNo = request.getParameter("patNo");
String regId = request.getParameter("regId");
String testType = request.getParameter("testType");
String mode = request.getParameter("mode");
String showCloseBtn = request.getParameter("showCloseBtn");
showCloseBtn = "Y";
if(patNo == null) {
	patNo = ParserUtil.getParameter(request, "patno");
}
if(regId == null) {
	regId = ParserUtil.getParameter(request, "regid");
}

if(!"L".equals(mode)){
	if (regId != null && regId.length() > 0){
		mode = CMSDB.checkPatientType(regId);	
	}
}

boolean allowSelectDate = true;
if (regId != null && regId.length() > 0){
	allowSelectDate = false;
}

ArrayList dateList = null;
if (allowSelectDate) {
	dateList = CMSDB.getPatientRegDates(patNo, mode);
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
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CMS Image Viewer</title>
    <style type="text/css">
	    body {
			font-family: verdana,arial,helvetica,sans-serif;
			font-size: 12px;
		}
	   	h1 { font: 15px bold; }
	   	.no_image_content {
	   		font: 15px bold;
	   		width: 100%;
	   	}
   	
        /* jssor slider thumbnail navigator skin 11 css */
        /*
            .jssort11 .p            (normal)
            .jssort11 .p:hover      (normal mouseover)
            .jssort11 .pav          (active)
            .jssort11 .pav:hover    (active mouseover)
            .jssort11 .pdn          (mousedown)
            */
        .jssort11 {
            position: absolute;
            width: 200px;		/* nav content width original:200px */
            height: 300px;
            font-family: Arial, Helvetica, sans-serif;
            -moz-user-select: none;
            -webkit-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

            .jssort11 .p {
                position: absolute;
                width: 200px;		/* nav content width original:200px */
                height: 69px;
                background: #181818;
            }

            .jssort11 .tp {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border: none;
            }

            .jssort11 .i, .jssort11 .pav:hover .i {
                position: absolute;
                top: 3px;
                left: 3px;
                width: 60px;
                height: 30px;
                border: white 1px dashed;
            }

            * html .jssort11 .i {
                width /**/: 62px;
                height /**/: 32px;
            }

            .jssort11 .pav .i {
                border: white 1px solid;
            }

            .jssort11 .t, .jssort11 .pav:hover .t {
                position: absolute;
                top: 0px;
                left: 68px;
                width: 129px;
                height: 32px;
                line-height: 20px;
                text-align: center;
                color: #fc9835;
                font-size: 12px;
            }

            .jssort11 .pav .t, .jssort11 .p:hover .t {
                color: #fff;
            }

            .jssort11 .c, .jssort11 .pav:hover .c {
                position: absolute;
                top: 38px;
                left: 3px;
                width: 197px;
                height: 31px;
                line-height: 31px;
                color: #fff;
                font-size: 11px;
                font-weight: 400;
                overflow: hidden;
            }

            .jssort11 .pav .c, .jssort11 .p:hover .c {
                color: #fc9835;
            }

            .jssort11 .t, .jssort11 .c {
                transition: color 2s;
                -moz-transition: color 2s;
                -webkit-transition: color 2s;
                -o-transition: color 2s;
            }

            .jssort11 .p:hover .t, .jssort11 .pav:hover .t, .jssort11 .p:hover .c, .jssort11 .pav:hover .c {
                transition: none;
                -moz-transition: none;
                -webkit-transition: none;
                -o-transition: none;
            }

            .jssort11 .p:hover, .jssort11 .pav:hover {
                background: #333;
            }

            .jssort11 .pav, .jssort11 .p.pdn {
                background: #462300;
            }
			            
			#pager {
				font-size: 14px;
				text-align: center;
				margin-top: 20px;
				color: #666;
			}
			#pager a {
				color: #666;
				text-decoration: none;
				display: inline-block;
				padding: 0px 10px;
			}
			#pager a:hover {
				color: #333;
			}
			#pager a.selected {
				background-color: #333;
				color: #ccc;
			}


		/* jssor slider arrow navigator skin 05 css */
        /*
        .jssora05l                  (normal)
        .jssora05r                  (normal)
        .jssora05l:hover            (normal mouseover)
        .jssora05r:hover            (normal mouseover)
        .jssora05l.jssora05ldn      (mousedown)
        .jssora05r.jssora05rdn      (mousedown)
        .jssora05l.jssora05lds      (disabled)
        .jssora05r.jssora05rds      (disabled)
        */
        .jssora05l, .jssora05r {
            display: block;
            position: absolute;
            /* size of arrow element */
            width: 40px;
            height: 40px;
            cursor: pointer;
            background: url('../images/a17.png') no-repeat;
            overflow: hidden;
        }
        .jssora05l { background-position: -10px -40px; }
        .jssora05r { background-position: -70px -40px; }
        .jssora05l:hover { background-position: -130px -40px; }
        .jssora05r:hover { background-position: -190px -40px; }
        .jssora05l.jssora05ldn { background-position: -250px -40px; }
        .jssora05r.jssora05rdn { background-position: -310px -40px; }
        .jssora05l.jssora05lds { background-position: -10px -40px; opacity: .3; pointer-events: none; }
        .jssora05r.jssora05rds { background-position: -70px -40px; opacity: .3; pointer-events: none; }
		
		.jssora08l, .jssora08r {
			display: block;
			position: absolute;
			/* size of arrow element */
			width: 200px;
			height: 25px;
			cursor: pointer;
			background-color: #707070;
			overflow: hidden;
			text-align: center;
		}
        </style>
</head>
<body>
<% if("Y".equals(showCloseBtn)){ %>
	<div align="right"><img src="../images/cross.jpg" onclick="windowClose();"></img></div>
<% } %>
<!-- <%=Long.toString((new Date()).getTime()) %> -->
<% if(allowSelectDate){ %>	
	<div id="pager">
		<strong>Choose Registration Date:</strong> &nbsp;
		<a href="#all" onclick="createSlider('<%=patNo%>', '', '<%=mode%>');">All</a>
<%		for (int i = 0; i < dateList.size(); i++) {
			ReportableListObject row = (ReportableListObject) dateList.get(i);
			String tempRegId = row.getValue(0);
			String tempRegDate = row.getValue(1);		
%>
			&bull;<a href="#<%=tempRegId%>" onclick="createSlider('<%=patNo%>', '<%=tempRegId%>', '<%=mode%>');"><%=tempRegDate%></a>			
<%		} %>
	</div>
<%	} %>
    <!-- it works the same with all jquery version from 1.x to 2.x -->
    <script type="text/javascript" src="resources/jquery-1.9.1.min.js"></script>
    <!-- use jssor.slider.mini.js (40KB) instead for release -->
    <!-- jssor.slider.mini.js = (jssor.js + jssor.slider.js) -->
    <!--<script type="text/javascript" src="resources/jssor.slider.min.js"></script> -->
    <script type="text/javascript" src="resources/jssor.js"></script>
    <script type="text/javascript" src="resources/jssor.slider.js"></script>
	<script type="text/javascript" src="resources/fc302dfabe.js"></script>
	<div  id='photoSliderContainer' style="width:100%">
	</div>
	
	 <script>
	 function windowClose() { 
		 window.open('','_parent',''); 
		 window.close();
	 } 
	 
<% 
if(allowSelectDate == false){ %>	 
		 $( document ).ready(function() {
			 createSlider('<%=patNo%>', '<%=regId%>', '<%=mode%>', '<%=testType%>');
	    });
<% } else { %>
		$( document ).ready(function() {
			 createSlider('<%=patNo%>', '', '<%=mode%>');
			 
			 var $pagers = $('#pager a');
			 $.each( $pagers, function( index, value ){
				   if ( index == 0){
					   $( this ).addClass( 'selected' );
				   }
				});
				 
		});
		
<% } %>		
	 
        $(function() {
        	var $pagers = $('#pager a');
        	$pagers.click(function( e ) {
        		e.preventDefault();           		
        		$pagers.removeClass('selected');         
        		$(this).addClass( 'selected' );
        	});
        });
        
        function createSlider(patNo, regId, mode, testType){      
        	var path = 'mobilePhotoSlider';
        	
        	$.ajax({	
				url: '../cms/' + path + '.jsp?patNo=' + patNo + '&regId=' + regId + '&mode=' + mode + '&testType=' + testType,				
				async: false,
				cache:false,
				success: function(values){	
					$('#photoSliderContainer').html(values);
				},
				error: function() {
					alert('error');
				}
			});
        }
    </script>
</body>
</html>