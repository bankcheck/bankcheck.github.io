<%@ page import="com.hkah.web.common.UserBean"%>
<%@ page import="com.hkah.web.db.helper.FsModelHelper"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.imageio.ImageIO"%>

<%
	UserBean userBean = new UserBean(request);
	if (!userBean.isLogin() || !userBean.isAccessible("function.fs.file.view")) {
		return;
	}
	
	String imagePath = request.getParameter("imagePath");
	String path = request.getParameter("path");
	
	if (imagePath != null) {
		imagePath = imagePath.replaceFirst("file:", "");
		if ("part".equalsIgnoreCase(path)) {
			imagePath = FsModelHelper.getFullPdfToImagePath(imagePath);
		}
		
		//System.out.println("DEBUG: imagePath="+imagePath);
		BufferedImage img = null;
		try {
		    img = ImageIO.read(new File(imagePath));
		} catch (Exception e) {
			System.err.println("portal pdfPreview.jsp Cannot read image file:" + imagePath);
		}
		// display the image
	    response.setContentType("image/" + FsModelHelper.DOC_IMAGE_TYPE);
	    ImageIO.write(img, "PNG", response.getOutputStream());
	} else {
		return;
	}
%>
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