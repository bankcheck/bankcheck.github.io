<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.common.ReportableListObject"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.awt.Color"%>
<%@ page import="java.awt.Graphics2D"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="com.hkah.web.db.CMSDB"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="com.google.zxing.BarcodeFormat"%>
<%@ page import="com.google.zxing.EncodeHintType"%>
<%@ page import="com.google.zxing.WriterException"%>
<%@ page import="com.google.zxing.common.BitMatrix"%>
<%@ page import="com.google.zxing.qrcode.QRCodeWriter"%>
<%@ page import="com.google.zxing.qrcode.decoder.ErrorCorrectionLevel"%>
<%@ page import="java.awt.MediaTracker"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="org.apache.commons.httpclient.util.URIUtil"%>
<%
String userID = ParserUtil.getParameter(request, "userID");
String patNo = ParserUtil.getParameter(request, "patNo");
if(patNo == null) {
	patNo = ParserUtil.getParameter(request, "patno");
}
String regId = ParserUtil.getParameter(request, "regId");
if(regId == null) {
	regId = ParserUtil.getParameter(request, "regid");
}
String testType = ParserUtil.getParameter(request, "testType");
String mode = ParserUtil.getParameter(request, "mode");
String ver = request.getParameter("ver");
String servletUrl = CMSDB.getServletUrl(ver);
String showCloseBtn = request.getParameter("showCloseBtn");
showCloseBtn = "Y";
//System.out.println(new Date() + "[DEBUG] mLogin.jsp userID="+userID+", patNo="+patNo+", regId="+regId+", testType="+testType+", mode="+mode+", ver="+ver);

if(!"L".equals(mode)){
	mode = CMSDB.checkPatientType(regId);
}

//TESTING ONLY
//servletUrl = "http://160.100.2.45:8080/intranet/CMSPhotoServlet";

String myCodeText = "<otp>2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824</otp>";
myCodeText += "<stecode>" + ConstantsServerSide.SITE_CODE.toLowerCase() + "</stecode>";
myCodeText += "<userID>" + (userID == null ? "" : userID) + "</userID>";
myCodeText += "<patNo>" + (patNo == null ? "" : patNo) + "</patNo>";
myCodeText += "<regId>" + (regId == null ? "" : regId) + "</regId>";
myCodeText += "<mode>" + (mode == null ? "" : mode) + "</mode>";
myCodeText += "<servletUrl>" + servletUrl + "</servletUrl>";
myCodeText += "<testType>" + (mode == null ? "" : testType) + "</testType>";

String appPath = CMSDB.getQRPath();
String filePath = appPath;
String fileName = (new Date()).getTime() + "_" + patNo + ".png";

int size = 600;
String fileType = "png";
String myFilePath = filePath +"\\" + fileName;
File myFile = new File(CMSDB.createDir(filePath) +"\\" + fileName);
try {
    Hashtable<EncodeHintType, ErrorCorrectionLevel> hintMap = new Hashtable<EncodeHintType, ErrorCorrectionLevel>();
    hintMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
    QRCodeWriter qrCodeWriter = new QRCodeWriter();
    BitMatrix byteMatrix = qrCodeWriter.encode(myCodeText,BarcodeFormat.QR_CODE, size, size, hintMap);
    int CrunchifyWidth = byteMatrix.getWidth();
    BufferedImage image = new BufferedImage(CrunchifyWidth, CrunchifyWidth,
            BufferedImage.TYPE_INT_RGB);
    image.createGraphics();

    Graphics2D graphics = (Graphics2D) image.getGraphics();
    graphics.setColor(Color.WHITE);
    graphics.fillRect(0, 0, CrunchifyWidth, CrunchifyWidth);
    graphics.setColor(Color.BLACK);

    for (int i = 0; i < CrunchifyWidth; i++) {
        for (int j = 0; j < CrunchifyWidth; j++) {
            if (byteMatrix.get(i, j)) {
                graphics.fillRect(i, j, 1, 1);
            }
        }
    }
    
	if (ServerUtil.isUseSamba(myFilePath)) {
		FileUtil.moveBinaryLinuxToWin(null, FileUtil.convertBufferedImageToByteA(image, fileType),
				myFilePath, CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password"), false);
	} else {
		ImageIO.write(image, fileType, myFile);
	}
    Thread.sleep(1500);  
    String redirectURL = "displayQrCode.jsp?showCloseBtn=" + showCloseBtn + "&fileName=" + URLEncoder.encode(fileName);
    
    if(ConstantsServerSide.DEBUG && !ConstantsServerSide.isAMC2()) {
    	redirectURL = URIUtil.encodeQuery(redirectURL + "&filePath=" + filePath);
    } 
    
    response.sendRedirect(redirectURL);
} catch (WriterException e) {
    e.printStackTrace();
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<html:html xhtml="true" lang="true">
</html:html>