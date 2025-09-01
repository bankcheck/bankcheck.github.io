package com.hkah.servlet;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import javax.imageio.ImageIO;
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

public class NewSr extends HttpServlet {

	private String filePath;
	private File file;
	private File f;
	// sr information
	private String userId;

	private String realRequester;
	private String location;
	private String locationId;
	private String content;
	private String deptcode;
	private String srId;
	private String srLogId;
	private String stage;
	private String srCode;

	public void init() {
		// Get the file location to be stored
		filePath = HelpDeskDB.getDbConf("SH_UPLOAD_PATH");
		stage = "0";
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
		
		System.out.println("[HelpDesk NewSr] " + new Date());
		
		if (HttpFileUpload.isMultipartContent(request)){
			HttpFileUpload.toUploadFolder(
				request,
				ConstantsServerSide.DOCUMENT_FOLDER,
				ConstantsServerSide.TEMP_FOLDER,
				ConstantsServerSide.UPLOAD_FOLDER
			);
		}
		
		image = ParserUtil.getParameter(request, "image");
		userId = ParserUtil.getParameter(request, "userId");
		realRequester = ParserUtil.getParameter(request, "realRequester");
		realRequester = new String(realRequester.getBytes("ISO-8859-1"), "UTF-8"); // for
																					// Chinese
		location = ParserUtil.getParameter(request, "location");
		location = new String(location.getBytes("ISO-8859-1"), "UTF-8"); // for
																			// Chinese
		content = ParserUtil.getParameter(request, "content");
		content = new String(content.getBytes("ISO-8859-1"), "UTF-8"); // for
																		// Chinese
		deptcode = ParserUtil.getParameter(request, "deptCode");
		
		//System.out.println("image="+image);

		// get srId
		srId = HelpDeskDB.getDbUUID();
		srLogId = HelpDeskDB.getDbUUID();
		// get srCode
		srCode = HelpDeskDB.getNextSrCode();
		// get locationId
		locationId = HelpDeskDB.getLocationId(location);

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
				System.out.println("use photoId(upload)="+photoId);
			}
		}
		
		if (photoId == null) {
			photoId = HelpDeskDB.getPhotoPath("default_photo_id");
			System.out.println("use default photoId="+photoId);
		}		

		// Insert srDB
		boolean update = HelpDeskDB.addSr(srId, locationId, userId, stage, photoId, content, deptcode, realRequester, srCode);
		 System.out.println("Insert (addSr: " + srId + "): " + update);
		 
		if (update) {
			update = HelpDeskDB.addSrLog(srLogId, srId, HelpDeskDB.LOG_STATE_INIT, HelpDeskDB.LOG_STATE_CREATE, null, userId);
			System.out.println("Insert (addSrLog: " + srLogId + "): " + update);
		}

		response.setContentType("text/html");
		PrintWriter pw = response.getWriter();
		pw.println("<html>");
		pw.println("<head>");
		//pw.println("<script>window.location.reload(\"http://160.100.2.147:8080/HelpDeskWeb/sr.html\")</script>");
		pw.println("<script>alert('Upload success')</script>");
		pw.println("</head>");
		pw.println("</html>");
	}
}