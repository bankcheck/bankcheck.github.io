<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%
String formURL = null;
//formURL = "tui/takePhotoEditor3.jsp";
formURL = "takePhotoCanvas.jsp";

%>
<!doctype html>
<html lang="en">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="ZXing for JS">
	<link rel="manifest" href="manifest.json">
    <title>HKAHCMS Login</title>

    <!-- <link rel="preload" as="style" onload="this.rel='stylesheet';this.onload=null" href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic">-->
    <!-- <link rel="preload" as="style" onload="this.rel='stylesheet';this.onload=null" href="https://unpkg.com/normalize.css@8.0.0/normalize.css">-->
    <!-- <link rel="preload" as="style" onload="this.rel='stylesheet';this.onload=null" href="https://unpkg.com/milligram@1.3.0/dist/milligram.min.css">-->
    <style>
    	title {
    	
    	}
    	
    	button {
    		text-align: center;
    	}
    	
    	div {
    		text-align:center;
    	}
    	
	    video {
		    object-fit: fill;
		    width: 100%;
		    border: 2px solid green
		}
		/*
		div {
			border: 1px solid gray;
		}
		*/
		
    </style>
</head>

<body>

    <main class="wrapper">

        <section class="container" id="demo-content">
            <h1 class="title">CMS Mobile - Login</h1>

            <div>
                <button class="button" id="startButton">Scan QR Code</button>
                <!-- <button class="button" id="resetButton">Reset</button>-->
            </div>

            <div>
                <video id="video"></video>
            </div>

            <div id="sourceSelectPanel" style="display:none">
                <label for="sourceSelect">Change video source:</label>
                <select id="sourceSelect" style="max-width:400px">
                </select>
            </div>
            
            <div id="noOfSourcePanel" style="display:none">
                No Of Source: <p id="noOfSource"></p>
            </div>

            <div id="resultPanel" style="display:none">
	            <label>Result:</label>
	            <blockquote>
	                <p id="result"></p>
	            </blockquote>
            </div>
            
            <form id="takePhoto" action="<%=formURL %>" method="post">
            	<input type="hidden" name="params"></input>
            </form>

        </section>

        <footer class="footer">
            <section class="container">
                <p>Powered by XZing</p>
            </section>
        </footer>

    </main>

    <script type="text/javascript" src="https://unpkg.com/@zxing/library@dev"></script>
    <!-- <script type="text/javascript" src="../resources/index.min.js"> -->
    <script type="text/javascript">
        window.addEventListener('load', function () {
        	// local
        	var text = '<otp>2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824</otp><stecode>hkah</stecode><userID>admin</userID><patNo>455737</patNo><regId>2046086</regId><mode>O</mode><servletUrl>http://localhost:8080/intranet/CMSPhotoServletWeb</servletUrl><testType>null</testType>';
        	
        	// mail hkah
        	//var text = '<otp>2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824</otp><stecode>hkah</stecode><userID>admin</userID><patNo>455737</patNo><regId>2046086</regId><mode>O</mode><servletUrl>https://mail.hkah.org.hk/intranet/CMSPhotoServletWeb</servletUrl><testType>null</testType>';
            document.querySelector("input[name=params]").value = text;
            document.getElementById('takePhoto').submit();
        })

    </script>

</body>

</html>