package com.hkah.servlet;

import java.io.*;
import java.util.Date;
import java.util.Properties;

import javax.imageio.ImageIO;

import java.awt.image.BufferedImage;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.FileUtil;
import com.hkah.util.ParserUtil;
import com.hkah.util.upload.HttpFileUpload;
import com.hkah.web.db.HelpDeskDB;

public class SrUpdate extends HttpServlet{

	private static final String DEFAULT_CONFIG = "/WebConfig/db.conf"; //configuration file name
	
	private String msg;
	private String errmsg;
	private String filePath;
	
	private static Properties readProperties(String fileName) {
		try {
			Properties properties = new Properties();
			properties.load(new FileInputStream(new File(fileName)));
			return properties;
		} catch (Exception e) {
			return null;
		}
	}

	public void init(){
		msg = "Service Request have been saved.";
		errmsg = "Error! \\n Service Request not update. \\n Please try again later.";
		// Get the file location to be stored
		filePath = HelpDeskDB.getDbConf("SH_UPLOAD_PATH");
		System.out.println("filePath = " + filePath);
	}
	
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		service(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		service(request, response);
	}
	
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String image = null;
		String content = null;
		String photoId = null;
		String fileName = null;
		String srId = null;
		
		System.out.println("[HelpDesk SrUpdate] " + new Date());
		
		if (HttpFileUpload.isMultipartContent(request)){
			HttpFileUpload.toUploadFolder(
				request,
				ConstantsServerSide.DOCUMENT_FOLDER,
				ConstantsServerSide.TEMP_FOLDER,
				ConstantsServerSide.UPLOAD_FOLDER
			);
		}
		
		image = ParserUtil.getParameter(request, "image");
		content = ParserUtil.getParameter(request, "content");
		content = new String(content.getBytes("ISO-8859-1"), "UTF-8"); // for the content with Chinese
		srId = ParserUtil.getParameter(request, "srId");

		// image Update
		String[] fileList = (String[]) request.getAttribute("filelist");
		if (fileList != null) {
			StringBuffer tempStrBuffer = new StringBuffer();

			tempStrBuffer.append(filePath);
			String baseUrl = tempStrBuffer.toString();

			tempStrBuffer.setLength(0);
			tempStrBuffer.append(content);

			for (int i = 0; i < fileList.length; i++) {
				String ext = FilenameUtils.getExtension(fileList[i]);
				fileName = HelpDeskDB.getDbUUID() + "." + ext;
				
				System.out.println("image fileName="+fileName);

				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
					baseUrl + java.io.File.separator + fileName
				);

				photoId = HelpDeskDB.uploadPhoto(fileName);
				System.out.println("photoId="+photoId);
			}
		}
	
	//DB Update
		System.out.println("srId="+srId+", image="+image+", photoId="+photoId+",content="+content);
		
		boolean update = HelpDeskDB.updateSr(srId, content);
		if (photoId != null) {
			update = HelpDeskDB.updateSrPhoto(srId, photoId);
		}
		System.out.println("update="+update);
		
		response.setContentType("text/html");
		
		   // Actual logic goes here.
		   PrintWriter out = response.getWriter();
		   out.println("<html>");
		   out.println("<head>");
		   out.println("<style>");
		   out.println("body{");
		   out.println("	text-align: center;");
		   out.println("	font-family: \"Times New Roman\", Times, serif;");
		   out.println("}");
		   out.println("</style>");
		   out.println("<script>");
		   out.println("window.onload = setTimeout(function(){");
		if (update){
			out.println("	window.close();");
			out.println("}, 3000);");
		} else {
			out.println("	alert(\"" + errmsg + "\");");
			out.println("	window.close();");
			out.println("}, 1000);");
		}
		   out.println("</script>");
		   out.println("</head>");
		if (update){
			out.println("<body>");
			out.println("<h1>Success!</h1>");
			out.println("<h3>" + msg + "</h3>");
			out.println("</body>");
		}
		   out.println("</html>");
	}
}

