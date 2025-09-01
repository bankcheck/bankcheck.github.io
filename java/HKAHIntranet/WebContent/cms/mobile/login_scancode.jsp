<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.net.MalformedURLException"%>
<%@ page import="java.net.URL"%>
<%!
private String getTakePhotoHost(String scancodeHost) {
	String ret = null;
	if ("mail.hkah.org.hk".equals(scancodeHost) ||
			"160.100.2.6".equals(scancodeHost)) {
		ret = "160.100.2.80";
		//ret = "mail.hkah.org.hk";
	} else if ("mail.twah.org.hk".equals(scancodeHost) ||
			"192.168.0.10".equals(scancodeHost)) {
		ret = "192.168.0.20";	
	} else {
		ret = scancodeHost;
	}
	return ret;
}

private int getTakePhotoPort(String scancodeHost) {
	int ret = 8080;
	if ("mail.hkah.org.hk".equals(scancodeHost) ||
			"160.100.2.6".equals(scancodeHost) ||
			"www-server".equals(scancodeHost) ||
			"160.100.2.80".equals(scancodeHost)) {
		ret = 80;
	} else if ("mail.twah.org.hk".equals(scancodeHost) ||
			"192.168.0.10".equals(scancodeHost) ||
			"192.168.0.20".equals(scancodeHost)) {
		ret = 8000;	
	}
	return ret;
}

private String toInsecureSite(String url, boolean withFile) {
	String ret = null;
	if (url != null) {
		try {
			URL oldUrl = new URL(url);
			
			// [login_scancode] absolutePath=https://mail.hkah.org.hk/intranet/cms/mobile/login_scancode.jsp
			// mail.hkah.org.hk:443 > www-server
			// mail.twah.org.hk:443 > 192.168.0.20
			if ("https".equals(oldUrl.getProtocol())) {
				oldUrl.getHost();
				String relativePath = url.substring(url.indexOf("/", url.indexOf(oldUrl.getHost())));
				
				//System.out.println("[login_scancode] toInsecureSite relativePath1="+relativePath);
				relativePath = relativePath.substring(0, relativePath.lastIndexOf("/") + 1);
				
				//System.out.println("[login_scancode] toInsecureSite relativePath2="+relativePath);
				URL newUrl = new URL("http", getTakePhotoHost(oldUrl.getHost()), getTakePhotoPort(oldUrl.getHost()), relativePath);
				ret = newUrl.toString();
			} else {
				ret = url;
			}
			
			if (!withFile) {
				ret = ret.substring(0, ret.lastIndexOf("/") + 1);
			}
			System.out.println("[login_scancode] toInsecureSite ret="+ ret);
		} catch (MalformedURLException ex) {
			ex.printStackTrace();
		}
	}
	return ret;
}
%>
<%
String requestURL = request.getRequestURL().toString();
//System.out.println("[login_scancode] requestURL="+requestURL);
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
    	body,
		.wrapper {
		  /* Break the flow */
		  position: absolute;
		  top: 0px;
		
		  /* Give them all the available space */
		  width: 100%;
		  height: 100%;
		
		  /* Remove the margins if any */
		  margin: 0;
		
		  /* Allow them to scroll down the document */
		  overflow: hidden;
		}
		
		body {
		  /* Sending body at the bottom of the stack */
		  z-index: 1;
		  margin:0;background-color: #333;
		}
		
		.wrapper {
		  /* Making the wrapper stack above the body */
		  z-index: 2;
		}
    	
    	.wrapper { overscroll-behavior: none; }
		
    	title {
    	
    	}
    	
    	h1 {
    		margin: 5px;
    		display: inline;
    	}
    	
    	.navbar {
		  overflow: hidden;
		  background-color: #333;
		  color: #fff;
		  /* position: fixed; */
		  top: 0;
		  width: 100%;
		}
    	
    	button {
    		text-align: center;
    	}
    	
    	#resetButton {
    		float: right;
    	}
    	
    	#startButton {
			font-weight: bold;
			font-size: 100px;
			position: absolute;
			left: 0;
			width: 240px;
			height: 240px;
			border: 0px;
			background-image: url("qrcode_scanner_240.png");
			background-repeat: no-repeat;
			background-position: center;
    	}
    	
    	.video_box {
    		margin: 0 auto;
    		text-align: center;
    	}
    	
	    video {
		    /* object-fit: fill; %/
		    width: 100%;
		    height: 70%;
		}
		
		.container-credit {
			color: #fff;
		}
		
    </style>
</head>

<body>

    <main class="wrapper">

        <section class="container" id="demo-content">
        	<div class="navbar">
        		<h1>CMS Photo</h1>
        		<button class="button" id="resetButton">Cancel</button>
        	</div>

			<div class="scan-qrcode_box" style="position:relative;margin:0 auto;width: 240px;">
				<label class="scan-qrcode_cover">
					<button class="button" id="startButton"></button>
				</label>
			</div>

            <div class="video_box">
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
            
            <!-- <form id="takePhoto" action="http://mail.hkah.org.hk:8080/intranet/cms/mobile/takePhotoCanvas.jsp" method="post"> -->
            <form id="takePhoto" action="takePhotoCanvas.jsp" method="post">
            	<input type="hidden" name="params"></input>
            </form>

        </section>

        <footer class="footer">
            <section class="container-credit">
                <p>Powered by XZing</p>
            </section>
        </footer>

    </main>

	<script type="text/javascript" src="../resources/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="../resources/zxing-0.7.0-dev.058aea.index.min.js"></script>
    <script type="text/javascript">
	    (function($) {
	        $.fn.invisible = function() {
	            return this.each(function() {
	                $(this).css("visibility", "hidden");
	            });
	        };
	        $.fn.visible = function() {
	            return this.each(function() {
	                $(this).css("visibility", "visible");
	            });
	        };
	    }(jQuery));
	    
	    function insecureSite() {
	    	var action = $("#takePhoto").attr('action');
	    	$("#takePhoto").attr('action', '<%=toInsecureSite(requestURL, false) %>' + action);
	    	//alert('form action='+$("#takePhoto").attr('action'));
	    }
    
        window.addEventListener('load', function () {
        	$('#video').invisible();
        	$('#resetButton').hide();
        	//document.getElementById('resetButton').style.visibility = "hidden"	
            const codeReader = new ZXing.BrowserQRCodeReader()
            console.log('ZXing code reader initialized')
            
            codeReader.getVideoInputDevices()
                .then((videoInputDevices) => {
                    const sourceSelect = document.getElementById('sourceSelect')
                    const firstDeviceId = videoInputDevices[0].deviceId
                    const secondDeviceId = videoInputDevices[1].deviceId
                    
                    document.getElementById('noOfSource').textContent = videoInputDevices.length + 
                    	" ID [0]:" + firstDeviceId + 
                    	" ID [1]:" + secondDeviceId
                    
                    if (videoInputDevices.length > 1) {
                        videoInputDevices.forEach((element) => {
                            const sourceOption = document.createElement('option')
                            sourceOption.text = element.label
                            sourceOption.value = element.deviceId
                            sourceSelect.appendChild(sourceOption)
                        })
                        const sourceSelectPanel = document.getElementById('sourceSelectPanel')
                        //sourceSelectPanel.style.display = 'block'
                    }
                    document.getElementById('startButton').addEventListener('click', () => {
                    	console.log('startButton click.')
                    	
                        $('#startButton').hide();
                    	$('#resetButton').show();
                    	$('#video').visible();
                    	
                        codeReader.decodeFromInputVideoDevice(secondDeviceId, 'video').then((result) => {
                            console.log(result)
                            document.getElementById('result').textContent = result.text
                            
                            //goToTakePhoto(result.text)
                            //alert("result.text="+result.text);
                            document.querySelector("input[name=params]").value = result.text
                            insecureSite();
                            document.getElementById('takePhoto').submit()
                            

                        }).catch((err) => {
                            console.error(err)
                            document.getElementById('result').textContent = err
                        })
                        console.log('Started continous decode from camera with id ${secondDeviceId}')
                        
                    })
                    
                    document.getElementById('resetButton').addEventListener('click', () => {
                    	location.reload();
                        //codeReader.reset()
                        //console.log('Reset.')
                        //$('#startButton').show();
                    });

                    // Auto start scaning 
                    //alert("init codeReader="+codeReader);
                })
                .catch((err) => {
                    console.error(err)
                })
        })

    </script>

</body>

</html>