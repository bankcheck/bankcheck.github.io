<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.awt.Color"%>
<%@ page import="java.awt.Graphics2D"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="java.io.*"%>
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
<%@ page import="com.google.zxing.client.j2se.MatrixToImageWriter"%>
<%@ page import="java.awt.MediaTracker"%>
<%@ page import="java.net.URLEncoder"%>

<%
String command = ParserUtil.getParameter(request, "command");
String staffID = ParserUtil.getParameter(request, "staffID");
String patNo = ParserUtil.getParameter(request, "patNo");
String regID = ParserUtil.getParameter(request, "regID");
String seqNo = ParserUtil.getParameter(request, "seqNo");
String formType = ParserUtil.getParameter(request, "formType");
String site = ConstantsServerSide.SITE_CODE;
String serverIP = "";
System.out.println("site : " + site);
if ("hkah".equals(site)) {
	serverIP = "160.100.2.80";
} else {
	serverIP = "192.168.0.20";
}
//TESTING ONLY
//servletUrl = "http://160.100.2.45:8080/intranet/CMSPhotoServlet";
//160.100.2.80  www-server
String myCodeText = "http://" + serverIP + "/intranet/healthAssessment/health_assess_form.jsp?command=" + command + "&staffID=" + staffID + "&patNo=" + patNo + "&regID=" + regID + "&seqNo=" + seqNo +  "&formType=" + formType;
//String myCodeText = "http://www.google.com";
String appPath = CMSDB.getQRPath();
String filePath = appPath;
String fileName = (new Date()).getTime() + "PATIENT_REG.png";

int size = 250;
String fileType = "png";

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
    ImageIO.write(image, fileType, myFile);
    Thread.sleep(1500);   
    
    String redirectURL = "displayQrCode.jsp?fileName=" + URLEncoder.encode(fileName);
    if(ConstantsServerSide.DEBUG) {
    	redirectURL = redirectURL + "&filePath=" + filePath;
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