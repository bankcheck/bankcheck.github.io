package com.hkah.servlet;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
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
public class CMSPhotoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CMSPhotoServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
System.out.println("CMS PHOTO DO GET");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//System.out.println("CMS PHOTO DO POST");

//String fromClientphoto= request.getParameter("firstParam");
//System.out.println(fromClientphoto);


		ObjectInputStream resultStream = null;
		ObjectOutputStream sendStream = null;
		
		try {
			resultStream = new ObjectInputStream(request.getInputStream());
			byte [] results = (byte[]) resultStream.readObject();		
			String comment = (String) resultStream.readObject();
			String otp = (String) resultStream.readObject();
			String stecode = (String) resultStream.readObject();
			String patNo = (String) resultStream.readObject();
			String regId = (String) resultStream.readObject();
			String testType = (String) resultStream.readObject();
			String userId = (String) resultStream.readObject();
			String mode = (String) resultStream.readObject();
			String imagePath = Long.toString((new Date()).getTime()) + ".jpg";
			
System.out.println("Image = " + results);			
System.out.println("Comment = " + comment);			
System.out.println("OTP = " + otp);			
System.out.println("STECODE = " + stecode);			
System.out.println("PATNO = " + patNo);			
System.out.println("REGID = " + regId);
System.out.println("testno = " + testType);
System.out.println("USERID = " + userId);
System.out.println("MODE = " + mode);
			
			sendStream = new ObjectOutputStream(response.getOutputStream());
			sendStream.writeObject(String.valueOf("true"));
			sendStream.flush();

			BufferedImage img = ImageIO.read(new ByteArrayInputStream(results));
			File outputfile;
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
			
			if (ServerUtil.isUseSamba(outputfile.getAbsolutePath())) {
				FileUtil.moveBinaryLinuxToWin(null, results, outputfile.getAbsolutePath(), 
						CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password"), false);
			} else {
				ImageIO.write(img, "jpg", outputfile);
			}
	
			if (patNo != null && patNo.length() > 0 && regId != null && regId.length() > 0){
				CMSDB.addCMSMPhotoRecord(CMSDB.getNextCMSMID(), imagePath, comment, stecode, patNo, regId, testType, userId, mode);			
			}		
		} catch (IOException e) {
			e.printStackTrace(); 
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}  catch (Exception e) {
			e.printStackTrace(); 
		} finally {			
			 if (resultStream != null) {
                 try {
                	 resultStream.close();
                 } catch (IOException e) {
                 }
             }
             if (sendStream != null) {
                 try {
                	 sendStream.close();
                 } catch (IOException e) {
                 }
             }
		}
	}	
}
