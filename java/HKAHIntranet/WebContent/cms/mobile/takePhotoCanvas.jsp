<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.ReportableListObject"%>
<%@ page import="com.hkah.web.db.CMSDB"%>
<%@ page import="java.awt.*"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.MalformedURLException"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="org.apache.commons.io.FilenameUtils"%>
<%@ page import="org.dom4j.Document"%>
<%@ page import="org.dom4j.DocumentException"%>
<%@ page import="org.dom4j.DocumentHelper"%>
<%@ page import="org.dom4j.Element"%>
<%@ page import="sun.misc.BASE64Decoder"%>

<%@ page import="java.util.Enumeration"%>

<%!
public static String getRegdate(String regId) {
	// fetch document
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT TO_CHAR(REGDATE, 'YYYY-MON-DD') ");
	sqlStr.append("FROM   REG@IWEB ");
	sqlStr.append("WHERE  REGID = ? ");
	
	String regDate = "";
	List<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{regId});
	if (result.size() > 0) {
		ReportableListObject rlo = (ReportableListObject) result.get(0);
		regDate = (String) rlo.getValue(0);
	}

	return regDate;
}

private boolean upload(Map<String, String> values, String imgBase64, String comment) {
	String mode = values.get("mode");
	String stecode = values.get("stecode");
	String patNo = values.get("patNo");
	String regId = values.get("regId");
	String testType = values.get("testType");
	String userID = values.get("userID");
	
	boolean result = false;
	String fileExt = "png";
	String fileName = Long.toString((new Date()).getTime()) + "." + fileExt;
	String dir = null;
	
	String path = CMSDB.getPhotoBasePath(mode);
	if (patNo != null && patNo.length() > 0){
		if(CMSDB.MODULE_CODE_LIS.equals(mode)){
			dir = path + patNo + "\\" + regId  + "\\" + testType +"\\" + fileName;
		} else {
			dir = path + patNo + "\\" + regId +"\\" + fileName;
		}
	} else {
		dir = path + fileName;
	}		
	
	System.out.println("[takePhotoCanvas] upload imgBase64 length="+imgBase64.length());
	
	if (uploadImg(imgBase64, dir, fileExt)) {
		// resize large photo
		int photoResizeWidth = 1536;	// default
		try {
			photoResizeWidth = Integer.parseInt(CMSDB.sysparams.get("PHOTO_RS_WIDTH"));
		} catch (Exception e) {
		}
		boolean isResized = saveScaledImage(dir, photoResizeWidth);
		System.out.println("[takePhotoCanvas] upload resize success="+isResized);
		
		if (patNo != null && patNo.length() > 0 && regId != null && regId.length() > 0){
			result = CMSDB.addCMSMPhotoRecord(CMSDB.getNextCMSMID(), fileName, comment, stecode, patNo, regId, testType, userID, mode);			
		}		
	}
	
	return result; 
}

private Map<String, String> readBarcode(String barcodeString) {
	Map<String, String> values = new HashMap<String, String>();
	barcodeString = "<root>" + barcodeString + "</root>";
	
	try {
		Document document = DocumentHelper.parseText(barcodeString);
		
	    Element root = document.getRootElement();

	    // iterate through child elements of root
	    for (Iterator<Element> it = root.elementIterator(); it.hasNext();) {
	        Element element = it.next();
	        String name = element.getName();
	        String value = element.getStringValue();
	        values.put(name, value);
	        
	        System.out.println("[takePhotoCanvas] name=<"+name+">, value=<"+value+">");
	    }
	} catch (DocumentException dex) {
		values.put("error", dex.getMessage());
		
		dex.printStackTrace();
	}
	return values;
}

private boolean uploadImg(String imgBase64, String dir, String fileExt) {
	File f = null;
	boolean result = false;
	
	//String path = CMSDB.getPhotoBasePath(values.get("mode"));
	System.out.println("[takePhotoCanvas] uploadImg PhotoPath="+dir);
	
	BASE64Decoder decoder = new BASE64Decoder();
	try{
		byte[] decodedBytes = decoder.decodeBuffer(imgBase64.split("^data:image/(png|jpg|jpeg);base64,")[1]);
		BufferedImage image = ImageIO.read(new ByteArrayInputStream(decodedBytes));
	
		f = new File(dir);
		if (!f.exists()) {
			CMSDB.createDir(dir);
		}
		
		if (ServerUtil.isUseSamba(dir)) {
			FileUtil.moveBinaryLinuxToWin(null, decodedBytes, dir, 
					CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password"), false);
		} else {
			ImageIO.write(image, fileExt, f);
		}
		
		result = true;
		System.out.println("[takePhotoCanvas] uploadImg Complete");
	}catch(IOException e){
		System.out.println("[takePhotoCanvas] uploadImg IOERROR:" + e);
		e.printStackTrace();
	}catch(Exception e){
		System.out.println("[takePhotoCanvas] uploadImg ERROR:" + e);
		e.printStackTrace();
	}
	return result;
}

private boolean saveScaledImage(String originalFilePath, int width) {
    File input = new File(originalFilePath);
    int outputWidth = 0;
    boolean ret = false;
    String newFilePath = null;
    try {
        BufferedImage image = ImageIO.read(input);
        BufferedImage resized = resize(image, width, width * image.getHeight() / image.getWidth());
        newFilePath = originalFilePath;
        File output = new File(newFilePath);
        ImageIO.write(resized, FilenameUtils.getExtension(originalFilePath), output);
        ret = true;
    } catch (IOException e) {
        e.printStackTrace();
    }
    return ret;
}

private BufferedImage resize(BufferedImage img, int width, int height) {
    Image tmp = img.getScaledInstance(width, height, Image.SCALE_SMOOTH);
    BufferedImage resized = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
    Graphics2D g2d = resized.createGraphics();
    g2d.drawImage(tmp, 0, 0, null);
    g2d.dispose();
    return resized;
}

private String getScancodeHost(String scancodeHost) {
	String ret = null;
	
	//System.out.println("[takePhotoCanvas] getScancodeHost scancodeHost="+scancodeHost);
	
	if ("www-server".equals(scancodeHost) ||
			"160.100.2.80".equals(scancodeHost)) {
		//ret = "160.100.2.80";
		ret = "mail.hkah.org.hk";
	} else if ("192.168.0.20".equals(scancodeHost)) {
		ret = "mail.twah.org.hk";	
	} else {
		ret = scancodeHost;
	}
	return ret;
}

private String toSecureSite(String url, boolean withFile) {
	String ret = null;
	if (url != null) {
		try {
			URL oldUrl = new URL(url);
			
			if ("http".equals(oldUrl.getProtocol())) {
				oldUrl.getHost();
				String relativePath = url.substring(url.indexOf("/", url.indexOf(oldUrl.getHost())));
				
				//System.out.println("[login_scancode] toInsecureSite relativePath1="+relativePath);
				relativePath = relativePath.substring(0, relativePath.lastIndexOf("/") + 1);
				
				//System.out.println("[login_scancode] toInsecureSite relativePath2="+relativePath);
				int port = 443;
				try {
					port = Integer.parseInt(ConstantsServerSide.SECURE_PORT);
				} catch (Exception ex) {}
				URL newUrl = new URL("https", getScancodeHost(oldUrl.getHost()), port, relativePath);
				ret = newUrl.toString();
			} else {
				ret = url;
			}
			
			if (!withFile) {
				ret = ret.substring(0, ret.lastIndexOf("/") + 1);
			}
			System.out.println("[takePhotoCanvas] toSecureSite ret="+ ret);
		} catch (MalformedURLException ex) {
			ex.printStackTrace();
		}
	}
	return ret;
}
%>
<%
String requestURL = request.getRequestURL().toString();
String params = ParserUtil.getParameter(request, "params");
String mode = request.getParameter("mode");
String comment = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "comment"));
String imgPath = ParserUtil.getParameter(request, "imgPath");
boolean uploadResult = false;

if (ConstantsServerSide.DEBUG) {
	System.out.println("[takePhotoCanvas] content-length="+request.getHeader("content-length"));
	
	System.out.println("[takePhotoCanvas] param list:");
	Enumeration e = request.getParameterNames();
	while (e.hasMoreElements()) {
	    String param = (String) e.nextElement();
	    System.out.println(" p="+param);
	}
	
	System.out.println("[takePhotoCanvas] attribute list:");
	e = request.getAttributeNames();
	while (e.hasMoreElements()) {
	    String param = (String) e.nextElement();
	    System.out.println(" a="+param);
	}
}

//System.out.println("[DEBUG] takePhotoCanvas params="+params);
Map<String, String> paramsMap = readBarcode(params);
if ("upload".equals(mode)) {
	String fileName = "Test_upload_pic_" + Calendar.getInstance().getTimeInMillis();
	//uploadResult = uploadImg(imgPath, fileName);
	uploadResult = upload(paramsMap, imgPath, comment);
}
String patNo = paramsMap.get("patNo");
String regId = paramsMap.get("regId");
String regDate = getRegdate(regId);

%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>HKAHCMS Take Photo</title>
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
		  overflow-y: hidden;
		  
		  font-family: Arial;
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
		
		.topnav-ctrl {
			float: right;
			display: none;
		}
		
		.patInfo {
			display: inline;
		}
		
		.navbar .controlBtn {
			align: right;
		}
    	
    	button {
    		text-align: center;
    	}
    	
    	.btn-text {
    		color: #fff;
    		font-size: 25px;
    		border: 0px;
    		margin: 0 5px;
    	}
    	.btn-icon {
    		float: left;
    		width: 30px;
    	}
    	
    	.btn-icon2 {
	    	width: 30px;
		    float: left;
		    margin: 5px;
    	}
    	
    	#export {
			float: right;
			height: 40px;
    		width: 16%;
    		width: calc(20% - 20px);
    		width: -webkit-calc(20% - 20px);
			max-width: 150px;
			background-image: linear-gradient(-90deg, rgb(255, 157, 216) 0%, rgb(155, 0, 87) 100%);
			box-shadow: rgba(0, 0, 0, 0.35) 0px 15px 40px 0px;
    	}
    	
    	div#canvas {
    		text-align:center;
			
    	}
    	
    	.palette {
    		overflow: hidden;
    		float: left;
    	}
    	
    	.canvas-editor {
    		position: absolute;
    		width: 100%;
    	}
    	
    	.palette-color {
    		float: left;
    		width: 40px;
    		height: 40px;
    		border-width: 2px;
    		border-radius: 10%;
    		margin: 0 5px;
    	}
    	
    	.palette-widget {
    		float: left;
    		width: 40px;
    		height: 40px;
    		margin: 0 5px;
    		border-radius: 10%;
    		background: #fff;
    	}
    	
    	.palette-range {
    		float: left;
    	}
    	
    	.range {
    		width: 45px;
    	}
    	
    	.slider {
		  -webkit-appearance: none;
		  margin: 20px 10px;
		  height: 5px;
		  background: #d3d3d3;
		  border-radius: 5px;
		  outline: none;
		  opacity: 0.7;
		  -webkit-transition: .2s;
		  transition: opacity .2s;
		}
		
		.slider:hover {
		  opacity: 1;
		}
		
		.slider::-webkit-slider-thumb {
		  -webkit-appearance: none;
		  appearance: none;
		  border-radius: 10px;
		  width: 20px;
		  height: 20px;
		  background: #ffffff;
		  cursor: pointer;
		}
		
		.slider::-moz-range-thumb {
		  border-radius: 10px;
		  width: 20px;
		  height: 20px;
		  background: #ffffff;
		  cursor: pointer;
		}
		
		.comment-box {
    		float: left;
    		width:100%;
    	}
    	
    	#comment {
    		height: 34px;
    		font-size: 25px;
    		width: 78%;
    		width: calc(80% - 5px);
    		width: -webkit-calc(80% - 5px);
    		margin: 0 5px;
    	}
		
		/*
		#can {
			background-image: url("btn_camera_blue_148.png");
			background-repeat: no-repeat;
			background-position: center;
		}
		*/
		
		.take-picture_cover {
			width: 148px;
			height: 148px;
			text-align: center;
			cursor: pointer;
			
			font-style: normal;
		    font-variant-ligatures: normal;
		    font-variant-caps: normal;
		    font-variant-numeric: normal;
		    font-variant-east-asian: normal;
		    font-weight: 400;
		    font-stretch: normal;
		    font-size: 13.3333px;
		    line-height: normal;
		    font-family: Arial;
		}
		
		#take-picture, #take-picture3 {
			display: none;
		}
		
		.take-picture_icon {
			font-weight: bold;
			font-size: 100px;
			position: absolute;
			left: 0;
			width: 148px;
			height: 148px;
			background-image: url("btn_camera_blue_148.png");
			background-repeat: no-repeat;
			background-position: center;
		}
		
		.uploaded_box {
			position:relative;
			margin:0 auto;
			width: 300px;
			height: 150px;
			background: #fff;
			
		    font-size: 18px;
		    text-align: center;
		    padding: 10px 0;
		}
		
		.uploaded_box button {
		    display: block;
		    margin: 10px auto;
		    width: 200px;
			height: 40px;
			background-image: linear-gradient(-90deg, rgb(255, 157, 216) 0%, rgb(155, 0, 87) 100%);
			box-shadow: rgba(0, 0, 0, 0.35) 0px 15px 40px 0px;
		}
		
		.input-take_picture {
		    display: block;
		    margin: 10px auto;
		    width: 200px;
			height: 40px;
			background-image: linear-gradient(-90deg, rgb(255, 157, 216) 0%, rgb(155, 0, 87) 100%);
			box-shadow: rgba(0, 0, 0, 0.35) 0px 15px 40px 0px;
		}
		
		.disclaimer {
			display: hidden;
		}
		
		.lds-ring {
		  display: inline-block;
		  position: relative;
		  width: 64px;
		  height: 64px;
		}
		.lds-ring div {
		  box-sizing: border-box;
		  display: block;
		  position: absolute;
		  width: 51px;
		  height: 51px;
		  margin: 6px;
		  border: 6px solid #fff;
		  border-radius: 50%;
		  animation: lds-ring 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
		  border-color: #fff transparent transparent transparent;
		}
		.lds-ring div:nth-child(1) {
		  animation-delay: -0.45s;
		}
		.lds-ring div:nth-child(2) {
		  animation-delay: -0.3s;
		}
		.lds-ring div:nth-child(3) {
		  animation-delay: -0.15s;
		}
		@keyframes lds-ring {
		  0% {
		    transform: rotate(0deg);
		  }
		  100% {
		    transform: rotate(360deg);
		  }
		}
    </style>
</head>
<body>
	<main class="wrapper">
	        <section class="container" id="demo-content">
	        	<div class="navbar">
	        		<h1>CMS Photo</h1>
	        		<div class="patInfo">
	        			Patient No.: <%=patNo == null ? "" : patNo %>  Adm: <%=regDate == null ? "" : regDate %>
	        		</div>
	        		<span class="topnav-ctrl">
		        		<input type="file" id="take-picture2" accept="image/*">
	        		</span>
	        	</div>
	        	<!-- <p>
                    <img src="about:blank" alt="" id="show-picture">
                </p>
                -->
				<div class="take-picture_box" style="position:relative;margin:0 auto;width: 148px;">
					<label class="take-picture_cover">
						<input type="file" id="take-picture" accept="image/*" capture>
						<span class="take-picture_icon"></span>
					</label>
				</div>
				<div class="uploaded_box">
					<%if (uploadResult) { %>
						<div>Upload Success</div>
					<% } else { %>
						<div>Upload fail. Please contact IT support.</div>
					<% } %>
					<label class="take-picture_cover">
						<input type="file" id="take-picture3" accept="image/*" capture>
						<span class="input-take_picture btn-text"><img style="width: 30px" class="btn-icon2" src="btn_camera_blue_148.png"></img>Take photo</span>
					</label>
					<button class="btn-text btn-scancode"><img class="btn-icon" src="qrcode_scanner_96.png"></img>Another case</button>
					<button class="btn-text btn-exit"><img class="btn-icon" src="btn_exit.png"></img>Close</button>
				</div>				
	          	<div id="canvas">
	          		<canvas id="can"></canvas>
					<!-- <canvas id="exportCan" display: none;"></canvas>-->
				</div>
				<div class="canvas-editor">
					<div class="palette">
						<div class="palette-color" style="background: white" id="white" onclick="color(this)"></div>
						<div class="palette-color" style="background: yellow" id="yellow" onclick="color(this)"></div>
						<div class="palette-color" style="background: red" id="red" onclick="color(this)"></div>
						<div class="palette-color" style="background: green" id="green" onclick="color(this)"></div>
						<div class="palette-color" style="background: blue" id="blue" onclick="color(this)"></div>
						<div class="palette-color" style="background: purple" id="purple" onclick="color(this)"></div>
						<div class="palette-color" style="background: gray" id="gray" onclick="color(this)"></div>
						<div class="palette-color" style="background: black" id="black" onclick="color(this)"></div>
						<svg class="palette-widget" id="erase" onclick="color(this)" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
							 viewBox="0 0 480.001 480.001" style="enable-background:new 0 0 480.001 480.001;" xml:space="preserve">
							<g><g><path d="M333.142,350.846c0.115-0.115,0.215-0.239,0.323-0.357l129.681-129.706c10.878-10.878,16.864-25.368,16.855-40.8
									c-0.01-15.409-5.999-29.865-16.854-40.694l-97.844-97.874c-10.853-10.845-25.326-16.817-40.75-16.817
									c-15.426,0-29.895,5.974-40.741,16.82L16.855,308.329C5.974,319.21-0.012,333.713,0,349.168
									c0.013,15.425,6.002,29.884,16.854,40.7l62.592,62.606c0.061,0.061,0.127,0.112,0.188,0.171c0.174,0.165,0.349,0.331,0.534,0.483
									c0.082,0.067,0.171,0.126,0.255,0.19c0.175,0.135,0.349,0.271,0.532,0.395c0.07,0.047,0.145,0.085,0.215,0.13
									c0.205,0.131,0.412,0.26,0.627,0.376c0.051,0.026,0.103,0.048,0.154,0.074c0.239,0.123,0.482,0.241,0.732,0.346
									c0.033,0.014,0.067,0.024,0.101,0.037c0.269,0.108,0.54,0.208,0.819,0.293c0.034,0.011,0.07,0.017,0.104,0.027
									c0.276,0.081,0.556,0.154,0.841,0.211c0.082,0.017,0.165,0.023,0.247,0.038c0.239,0.041,0.479,0.084,0.724,0.107
									c0.33,0.033,0.663,0.051,0.998,0.051h137.91h159.308c5.522,0,10-4.478,10-10c0-5.522-4.478-10-10-10H248.566l84.22-84.236
									C332.904,351.06,333.027,350.96,333.142,350.846z M220.285,435.404H90.66l-59.675-59.689
									c-7.076-7.054-10.977-16.487-10.985-26.563c-0.008-10.106,3.897-19.582,10.996-26.681l129.825-129.803l151.091,151.091
									L220.285,435.404z M174.965,178.527L297.953,55.56c7.069-7.069,16.516-10.963,26.6-10.963c10.085,0,19.536,3.895,26.609,10.962
									l97.85,97.88c7.08,7.063,10.982,16.493,10.989,26.557c0.006,10.085-3.899,19.547-10.998,26.645l-122.95,122.974L174.965,178.527z"
									/></g></g>
						</svg>
						<div class="palette-range"><input type="range" min="1" max="20" value="5" class="slider" id="strokeWidth-range"></div>
						<!-- <input type="button" value="Rotate" id="palette-rotate" onclick="rotateCanvas()"></input>-->	
						<svg class="palette-widget" id="palette-undo" onclick="cUndo()"  x="0px" y="0px" style="enable-background:new 0 0 512 512;" version="1.1" viewBox="0 0 512 512" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g><path d="M447.9,368.2c0-16.8,3.6-83.1-48.7-135.7c-35.2-35.4-80.3-53.4-143.3-56.2V96L64,224l192,128v-79.8   c40,1.1,62.4,9.1,86.7,20c30.9,13.8,55.3,44,75.8,76.6l19.2,31.2H448C448,389.9,447.9,377.1,447.9,368.2z M432.2,361.4   C384.6,280.6,331,256,240,256v64.8L91.9,224.1L240,127.3V192C441,192,432.2,361.4,432.2,361.4z"/></g></svg>
						<svg class="palette-widget" id="palette-redo" onclick="cRedo()"  x="0px" y="0px" style="enable-background:new 0 0 512 512;" version="1.1" viewBox="0 0 512 512" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g><path d="M64,400h10.3l19.2-31.2c20.5-32.7,44.9-62.8,75.8-76.6c24.4-10.9,46.7-18.9,86.7-20V352l192-128L256,96v80.3   c-63,2.8-108.1,20.7-143.3,56.2c-52.3,52.7-48.7,119-48.7,135.7C64.1,377.1,64,389.9,64,400z M272,192v-64.7l148.1,96.8L272,320.8   V256c-91,0-144.6,24.6-192.2,105.4C79.8,361.4,71,192,272,192z"/></g></svg>
						<svg id="clr" onclick="erase()" class="palette-widget" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg"><path d="M0 0h48v48h-48z" fill="none"/><path d="M39.62 29.98l2.38-1.85-2.85-2.85-2.38 1.85 2.85 2.85zm-.89-9.43l3.27-2.55-18-14-5.83 4.53 15.75 15.75 4.81-3.73zm-32.18-18.55l-2.55 2.55 8.44 8.44-6.44 5.01 3.26 2.53 14.74 11.47 4.19-3.26 2.85 2.85-7.06 5.49-14.74-11.47-3.24 2.52 18 14 9.89-7.7 7.57 7.57 2.54-2.55-37.45-37.45z"/></svg>
						<svg class="palette-widget" id="palette-trash" onclick="cRemove()" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><title/><g id="Fill"><rect height="12" width="2" x="15" y="12"/><rect height="12" width="2" x="19" y="12"/><rect height="12" width="2" x="11" y="12"/><path d="M20,6V5a3,3,0,0,0-3-3H15a3,3,0,0,0-3,3V6H4V8H6V27a3,3,0,0,0,3,3H23a3,3,0,0,0,3-3V8h2V6ZM14,5a1,1,0,0,1,1-1h2a1,1,0,0,1,1,1V6H14ZM24,27a1,1,0,0,1-1,1H9a1,1,0,0,1-1-1V8H24Z"/></g></svg>
					</div>
					<div class="comment-box" style="float: left;">
						<input type="text" id="comment" name="comment" value="" maxlength="200" placeholder="Remark" />
						<input type="button" value="Upload" id="export" class="btn-text" onclick="save()">
					</div>
				</div>
				<!-- <div class="lds-ring"><div></div><div></div><div></div><div></div></div>-->
				<form id="uploadPhoto" name="uploadPhoto" action="takePhotoCanvas.jsp" method="post">
					<input type="hidden" name="mode" id="mode" /> 
					<input type="hidden" name="imgPath" id="imgPath"/>
					<input type="hidden" name="comment" />
					<input type="hidden" name="params" id="params" value="<%=params %>" /> 
				</form>
	        </section>
	        
	        <footer class="footer">
            <section class="container disclaimer">
                <p>Powered by HKAH</p>
            </section>
        </footer>
	</main>
	
	<script src="../resources/jquery-3.2.1.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
	   	    var takePicture = document.querySelector("#take-picture"),
        	//	showPicture = document.querySelector("#show-picture");
        		takePicture2 = document.querySelector("#take-picture2"),
        		takePicture3 = document.querySelector("#take-picture3");
	    
			takePicture.onchange = function (event) {
				loadPicture(event);
			};
			
			takePicture2.onchange = function (event) {
				loadPicture(event);
			};
			
			takePicture3.onchange = function (event) {
				loadPicture(event);
			}
			
			$(".btn-take_picture").click(function() {
				//takePictureMode();
			});
			
			$(".btn-scancode").click(function() {
				window.location.href = "<%=toSecureSite(requestURL, false) %>" + "login_scancode.jsp";
			});
			
			$(".btn-exit").click(function() {
				window.location.href="about:blank";
				window.close();
			});
			$(".btn-exit").hide();
			
    		<% if ("upload".equals(mode)) { %>
    			postUploadMode();
			<% } else { %>
				takePictureMode();
			<% } %>
			
			var slider = document.getElementById("myRange");
			slider.oninput = function() {
				y = this.value;
			}
		});
		
		function overlayOn() {
			document.getElementById("overlay").style.display = "block";
		}

		function overlayOff() {
			document.getElementById("overlay").style.display = "none";
		}
		
		function loadPicture(event) {
		    var files = event.target.files,
	        	file;
	    
		    if (files && files.length > 0) {
		        file = files[0];
		        
	            try {
	                // Get window.URL object
	                var URL = window.URL || window.webkitURL;
	
	                // Create ObjectURL
	                var imgURL = URL.createObjectURL(file);
	                
	                console.log('imgURL=' + imgURL);
	                
	                init(imgURL);                    
	            }
	            catch (e) {
	            	
	                try {
	                    // Fallback if createObjectURL is not supported
	                    var fileReader = new FileReader();
	                    fileReader.onload = function (event) {
	                        //showPicture.src = event.target.result;
	                    };
	                    fileReader.readAsDataURL(file);
	                }
	                catch (e) {
	                    //
	                    var error = document.querySelector("#error");
	                    if (error) {
	                        error.innerHTML = "Neither createObjectURL or FileReader are supported";
	                    }
	                }
	            }
		    }
		}
	
		// Adding canvas setting for new entry only
		var value = "";
		var canvas, ctx, flag = false, prevX = 0, currX = 0, prevY = 0, currY = 0, dot_flag = false;
		var x = "red", y = 2;
		var picW, picH;
		var maxCanvasW, maxCanvasH;
		var background;
		var footerH = 115;
	
		function init(imgURL) {
			console.log('init imgURL='+imgURL);
			
			canvas = document.getElementById('can');
			//console.log('canvas='+canvas);
			canvasJ = $("#can");
			canvasJ.css("background-image", 'url(' + imgURL + ')');
			canvasJ.css("background-size", 'contain');
			canvasJ.css("background-repeat", 'no-repeat');

			ctx = canvas.getContext("2d");
			//console.log('ctx canvas.getContext ctx='+ctx);
			
			w = canvas.width;
			h = canvas.height;
			
			maxCanvasW = document.body.clientWidth - 4;
			maxCanvasH = document.body.clientHeight - footerH - 4;	// should calculate screen height - navbar - footer - canvas border
	
			background = new Image();
			background.src = imgURL;
			background.onload = function() {
				console.log('bg width - ' + background.naturalWidth);
				console.log('bg height - ' + background.naturalHeight);
				
				resizeToBg(canvas, background);
				postBgLoad();
				
				picW = background.naturalWidth;
				picH = background.naturalHeight;
			}
			
			canvas.addEventListener("mousemove", function(e) {
				//console.log('mouse move evt');
				findxy('move', e);
			}, false);
			canvas.addEventListener("mousedown", function(e) {
				//console.log('mouse down evt');
				findxy('down', e);
			}, false);
			canvas.addEventListener("mouseup", function(e) {
				//console.log('mouse up evt');
				findxy('up', e);
				
				cPush();
			}, false);
			canvas.addEventListener("mouseout", function(e) {
				//console.log('mouse out evt');
				findxy('out', e);
			}, false);
			
			
			canvas.addEventListener("touchmove", function(e) {
				//console.log('touchmove evt');
				findxy('move', e);
			}, false);
			canvas.addEventListener("touchstart", function(e) {
				//console.log('touchstart evt');
				findxy('down', e);
			}, false);
			canvas.addEventListener("touchend", function(e) {
				//console.log('touchend evt');
				findxy('up', e);
				
				cPush();
			}, false);
			canvas.addEventListener("touchcancel", function(e) {
				//console.log('touchcancel evt');
				findxy('out', e);
			}, false);
		}
	
		function color(obj) {
			x = obj.id;
			if (x == "erase") {
				y = 14;
				ctx.globalCompositeOperation = 'destination-out';
			} else {
				y = document.getElementById("strokeWidth-range").value;
				ctx.globalCompositeOperation = 'source-over';
			}
		}
	
		function draw() {
			y = document.getElementById("strokeWidth-range").value;
			
			ctx.beginPath();
			ctx.moveTo(prevX, prevY);
			ctx.lineTo(currX, currY);
			ctx.strokeStyle = x;
			//ctx.globalAlpha = 0.6;
			ctx.lineCap = "round";
			ctx.lineWidth = y;
			ctx.stroke();
			ctx.closePath();
		}
	
		function erase() {
			var m = confirm("Clear all drawings?");
			if (m) {
				ctx.clearRect(0, 0, canvas.width, canvas.height);
			}
		}
		
		var cPushArray = new Array();
		var cStep = -1;
		// var ctx;
		// ctx = document.getElementById('myCanvas').getContext("2d");
			
		function cPush() {
		    cStep++;
		    
		    console.log('cPush cStep='+cStep+', cPushArray.length=' +cPushArray.length);
		    
		    if (cStep < cPushArray.length) { cPushArray.length = cStep; }
		    cPushArray.push(canvas.toDataURL());
		}
		
		function cUndo() {
			console.log('[cUndo] cStep='+cStep);
		    if (cStep > 0) {
		        cStep--;
		        var canvasPic = new Image();
		        canvasPic.src = cPushArray[cStep];
		        canvasPic.onload = function () { ctx.clearRect(0, 0, canvas.width, canvas.height); ctx.drawImage(canvasPic, 0, 0); }
		    }
		}
		
		function cRedo() {
		    if (cStep < cPushArray.length-1) {
		        cStep++;
		        var canvasPic = new Image();
		        canvasPic.src = cPushArray[cStep];
		        canvasPic.onload = function () { ctx.clearRect(0, 0, canvas.width, canvas.height); ctx.drawImage(canvasPic, 0, 0); }
		    }
		}
		
		function cRemove() {
			var m = confirm("Remove this picture?");
			if (m) {
				takePictureMode();
			}
		}
		
		function takePictureMode() {
			$(".canvas-editor").hide();
			$("#canvas").hide();
			$(".uploaded_box").hide();
			$(".take-picture_box").show();
		}
		
		function postBgLoad() {
			$(".take-picture_box").hide();
			$(".uploaded_box").hide();
			$("#canvas").show();
			$(".canvas-editor").show();
		}
		
		function postUploadMode() {
			$(".take-picture_box").hide();
			$(".canvas-editor").hide();
			$("#canvas").hide();
			$(".uploaded_box").show();
		}
	
		function save() {
			console.log('save');
			
			$(".lds-ring div").css("border-color", "#aaa");
			
			//var exportCanvas = document.getElementById('exportCan');
			//var exportCtx = exportCanvas.getContext("2d");
			
			var exportCanvas=document.createElement("canvas");
			$(exportCanvas).hide();
			var exportCtx=exportCanvas.getContext("2d");

			exportCanvas.width  = picW;
			exportCanvas.height = picH;
			
			console.log('  picW='+picW + ', picH='+picH);
			console.log('  exportCtxW='+exportCanvas.width + ', exportCtxH='+exportCanvas.height);
			
			exportCtx.drawImage(background, 0, 0);
			
			resizeToPic(canvas);
			
			exportCtx.drawImage(canvas, 0, 0);
			//$("#canvasimg").show();
			//var canvasimg = document.getElementById("canvasimg");
			
			console.log(' 2 exportCtxW='+exportCanvas.width + ', exportCtxH='+exportCanvas.height);
			
			//var dataURL = exportCanvas.toDataURL();
			var dataURL = exportCanvas.toDataURL('image/jpeg');
			$("#imgPath").val(dataURL);
			
			console.log('dataURL='+dataURL);
			
			submitAction('upload');
		}
		
		function resizeToBg(c, bg){
			var bgWidth = background.naturalWidth;
			var bgHeight = background.naturalHeight;
			
			var dimRatioW = maxCanvasW / bgWidth;
			var dimRatioH = maxCanvasH / bgHeight;
			
			// if dimenished to max width
			if (bgHeight*dimRatioW > maxCanvasH) {
				// limited by max height
				c.width = bgWidth * dimRatioH;
				c.height = bgHeight * dimRatioH;
			} else {
				// limited by max width
				c.width = bgWidth * dimRatioW;
				c.height = bgHeight * dimRatioW;
			}
		}
		
		function resizeToPic(canvas){
			var tempCanvas=document.createElement("canvas");
			var tctx=tempCanvas.getContext("2d");
			var cw=canvas.width;
			var ch=canvas.height;
			var pct = picW / cw;
			
			console.log('picW='+picW+', cw='+cw+', pct='+pct);
			
			tempCanvas.width=cw;
			tempCanvas.height=ch;
			tctx.drawImage(canvas,0,0);
			canvas.width*=pct;
			canvas.height*=pct;
			var ctx2=canvas.getContext('2d');
			ctx2.drawImage(tempCanvas,0,0,cw,ch,0,0,cw*pct,ch*pct);
		}
		
		function rotateCanvas() {
			//var tempCanvas=document.createElement("canvas");
			//var ctx = c.getContext("2d");
			var ctx2=canvas.getContext('2d');
			ctx2.rotate(90 * Math.PI / 180);
			
		}
	
		function findxy(res, e) {
			var rect = canvas.getBoundingClientRect();
			var clientX, clientY;
			//console.log('  findxy e.changedTouches='+e.changedTouches); 
					
			if (e.changedTouches) {
				var touch = e.changedTouches[0];
				clientX = touch.clientX;
				clientY = touch.clientY;
			} else {
				clientX = e.clientX;
				clientY = e.clientY;
			}
			//console.log('  e.clientX='+e.clientX+', e.clientY='+e.clientY+', rect.left='+rect.left+', rect.top='+rect.top);
			if (res == 'down') {
				prevX = currX;
				prevY = currY;
				currX = clientX - rect.left;
				currY = clientY - rect.top;	
				flag = true;
				dot_flag = true;
				if (dot_flag) {
					ctx.beginPath();
					ctx.fillStyle = x;
					ctx.fillRect(currX, currY, 2, 2);
					ctx.closePath();
					dot_flag = false;
				}
			}
			if (res == 'up' || res == "out") {
				flag = false;
			}
			if (res == 'move') {
				if (flag) {
					prevX = currX;
					prevY = currY;
					currX = clientX - rect.left;
					currY = clientY - rect.top;
					draw();
				}
			}
		}	
		//end of canvas	
	 
		function submitAction(cmd) {
			console.log("submitAction cmd="+cmd);
			document.uploadPhoto.mode.value = cmd;
			document.uploadPhoto.comment.value = $("#comment").val();
			document.uploadPhoto.submit();
		}
    </script>
</body>
</html>