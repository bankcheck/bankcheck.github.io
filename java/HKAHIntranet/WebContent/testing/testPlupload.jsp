<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.UserBean"%>
<%
	UserBean userBean = new UserBean(request);
	if (userBean == null || !userBean.isAdmin()) {
%>
<jsp:forward page="" /> 
<%
	}
%>
<%
// Plupload
// http://www.plupload.com/

// Plupload upload each file per form submission
// use fileItem.getString() in HttpFileUpload to get the edited file name (if user changed file name)
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
			request,
			ConstantsServerSide.DOCUMENT_FOLDER,
			ConstantsServerSide.TEMP_FOLDER,
			ConstantsServerSide.UPLOAD_FOLDER
		);
	fileUpload = true;
}

System.out.println("[Test Plupload] fileUpload="+fileUpload);

if (fileUpload) {
	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null && fileList.length > 0) {
		for (String file : fileList) {
			System.out.println(" file="+file);
		}
	}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Test Plupload</title>

	<link type="text/css" rel="stylesheet" href="http://www.plupload.com/css/bootstrap.css" media="screen" />
<link type="text/css" rel="stylesheet" href="http://www.plupload.com/css/font-awesome.min.css" media="screen" />
<link type="text/css" rel="stylesheet" href="http://www.plupload.com/css/my.css" media="screen" />
<link type="text/css" rel="stylesheet" href="http://www.plupload.com/css/prettify.css" media="screen" />
<link type="text/css" rel="stylesheet" href="http://www.plupload.com/css/shCore.css" media="screen" />
<link type="text/css" rel="stylesheet" href="http://www.plupload.com/css/shCoreEclipse.css" media="screen" />
<link type="text/css" rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/themes/smoothness/jquery-ui.min.css" media="screen" />
<link type="text/css" rel="stylesheet" href="http://www.plupload.com/plupload/js/jquery.ui.plupload/css/jquery.ui.plupload.css" media="screen" />

   
    <!--[if lte IE 7]>
   	<link rel="stylesheet" type="text/css" href="http://www.plupload.com/css/my_ie_lte7.css" />
    <![endif]-->

	<link href="http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,400,600,700,300|Bree+Serif" rel="stylesheet" type="text/css">
	<!--[if IE]>
	<link href="http://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet" type="text/css">
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:300italic" rel="stylesheet" type="text/css">
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:400italic" rel="stylesheet" type="text/css">
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:600italic" rel="stylesheet" type="text/css">
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:700italic" rel="stylesheet" type="text/css">
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:300" rel="stylesheet" type="text/css">
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:400" rel="stylesheet" type="text/css">
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:600" rel="stylesheet" type="text/css">
	<link href="http://fonts.googleapis.com/css?family=Bree+Serif:400" rel="stylesheet" type="text/css">
	<![endif]-->

	    
    <!--[if IE 7]>
    	<link rel="stylesheet" href="http://www.plupload.com/css/font-awesome-ie7.min.css">
    <![endif]-->

    <!--[if lt IE 9]>
    <script src="http://www.plupload.com/js/html5shiv.js"></script>
    <![endif]-->

	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.js" charset="UTF-8"></script>

</head>

<body>


<div id="uploader">    
	<p>Your browser doesn't have Flash, Silverlight or HTML5 support.</p>
</div> 

<!-- 
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="../js/plupload/jquery.ui.plupload/jquery.ui.plupload.js" /></script>
<script type="text/javascript" src="../js/plupload/jquery.plupload.queue/jquery.plupload.queue.js" /></script>
<script type="text/javascript" src="../js/plupload/plupload.dev.js" /></script>
<script type="text/javascript" src="../js/plupload/moxie.js" /></script>
-->

<script type="text/javascript" src="http://www.plupload.com/js/bootstrap.js" charset="UTF-8"></script>
<script type="text/javascript" src="http://www.plupload.com/js/shCore.js" charset="UTF-8"></script>
<script type="text/javascript" src="http://www.plupload.com/js/shBrushPhp.js" charset="UTF-8"></script>
<script type="text/javascript" src="http://www.plupload.com/js/shBrushjScript.js" charset="UTF-8"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="http://www.plupload.com/plupload/js/plupload.full.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="http://www.plupload.com/plupload/js/jquery.ui.plupload/jquery.ui.plupload.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="http://www.plupload.com/js/themeswitcher.js" charset="UTF-8"></script>


<script type="text/javascript">
// Initialize the widget when the DOM is ready
$(function() {
	$("#uploader").plupload({
		// General settings
		runtimes : 'html5,flash,silverlight',
		url : "testPlupload.jsp",

		// Maximum file size
		max_file_size : '2mb',

		chunk_size: '1mb',

		// Resize images on clientside if we can
		resize : {
			width : 200, 
			height : 200, 
			quality : 90,
			crop: true // crop to exact dimensions
		},

		// Specify what files to browse for
		filters : [
			{title : "Documents", extensions : "doc,docx,xls,xlsx,ppt,pptx,pdf,txt"},
			{title : "Image files", extensions : "jpg,gif,png"},
			{title : "Zip files", extensions : "zip,avi"},
			{title : "All", extensions : "*"}
		],

		// Rename files by clicking on their titles
		rename: true,
		
		// Sort files
		sortable: false,

		// Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
		dragdrop: true,

		// Views to activate
		views: {
			list: true,
			thumbs: true, // Show thumbs
			active: 'thumbs'
		},

		// Flash settings
		flash_swf_url : 'Moxie.swf',
	
		// Silverlight settings
		silverlight_xap_url : 'Moxie.xap'
	});
});
</script>


</body>
</html>
