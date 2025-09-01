package com.hkah.servlet;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.util.Date;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hkah.util.FileUtil;
import com.hkah.util.ServerUtil;
import com.hkah.web.db.CMSDB;

/**
 * Servlet implementation class CMSPhotoServlet
 */
public class CMSPhotoServletWeb extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    // location to store file uploaded
    private static final String UPLOAD_DIRECTORY = "upload";
    
    // upload settings
    private static final int MEMORY_THRESHOLD   = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE      = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE   = 1024 * 1024 * 50; // 50MB
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CMSPhotoServletWeb() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println(new Date() + " [CMSPhotoServletWeb] doGet");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println(new Date() + " [CMSPhotoServletWeb] doPost");
		
		try {
			String comment = request.getParameter("Comment");
			String otp = request.getParameter("otp");
			String stecode = request.getParameter("stecode");
			String patNo = request.getParameter("patNo");
			String regId = request.getParameter("regId");
			String testType = request.getParameter("testType");
			String userId = request.getParameter("userId");
			String mode = request.getParameter("mode");
			
			String imageBodyB64 = request.getParameter("imageBodyB64");
			String imageName = request.getParameter("imageName");
			String imageType = request.getParameter("imageType");
			
			int contentLength = request.getContentLength();
			System.out.println("contentLength = " + contentLength);
			
			System.out.println("Comment = " + comment);			
			System.out.println("OTP = " + otp);			
			System.out.println("STECODE = " + stecode);			
			System.out.println("PATNO = " + patNo);			
			System.out.println("REGID = " + regId);
			System.out.println("testno = " + testType);
			System.out.println("USERID = " + userId);
			System.out.println("MODE = " + mode);
			
			System.out.println("imageBodyB64 = " + (imageBodyB64 == null ? "null" : imageBodyB64.substring(0, imageBodyB64.indexOf(",") + 10) + "..."));
			System.out.println("imageName = " + imageName);
			System.out.println("imageType = " + imageType);
			
        	String base64Image = imageBodyB64.split(",")[1];
        	byte[] imageBytes = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64Image);
        	BufferedImage img = ImageIO.read(new ByteArrayInputStream(imageBytes));
        	
			File outputfile;
			String imagePath = Long.toString((new Date()).getTime()) + "." + imageType;
			String path = CMSDB.getPhotoBasePath(mode);
			if (patNo != null && patNo.length() > 0){
				if(CMSDB.MODULE_CODE_LIS.equals(mode)){
					outputfile = new File(CMSDB.createDir(path + patNo + "\\" + regId  + "\\" + testType) +"\\" + imagePath);
				} else {
					outputfile = new File(CMSDB.createDir(path + patNo + "\\" + regId) +"\\" + imagePath);
				}
			} else {
				outputfile = new File(path + imagePath);
			}					
			System.out.println("outputfile path="+outputfile.getAbsolutePath());
			
			if (ServerUtil.isUseSamba(outputfile.getAbsolutePath())) {
				FileUtil.moveBinaryLinuxToWin(base64Image, null, outputfile.getAbsolutePath(), 
						CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password"), false);
			} else {
				ImageIO.write(img, imageType, outputfile);
			}

			if (patNo != null && patNo.length() > 0 && regId != null && regId.length() > 0){
				CMSDB.addCMSMPhotoRecord(CMSDB.getNextCMSMID(), imagePath, comment, stecode, patNo, regId, testType, userId, mode);			
			}	
		} catch (IOException e) {
			e.printStackTrace(); 
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.sendError(response.SC_BAD_REQUEST, "Failed to upload image.");
		} catch (NullPointerException e) {
			e.printStackTrace(); 
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.sendError(response.SC_BAD_REQUEST, "Missing parameters.");
		} catch (Exception e) {
			e.printStackTrace(); 
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.sendError(response.SC_BAD_REQUEST, "Unexpected server error.");
		} finally {			
		}
	}	
}
