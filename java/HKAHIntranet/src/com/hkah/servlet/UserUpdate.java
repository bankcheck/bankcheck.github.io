package com.hkah.servlet;

import java.io.*;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hkah.web.db.HelpDeskDB;

public class UserUpdate extends HttpServlet{

	private String msg;
	private String errmsg;
	private boolean update;
	private String filePath;
	private File file;
	private File f;
	private String image;
	private String photoId;
	private String fileName;
	//user information
	private String userId;
	private String nickname;
	private String firstName;
	private String lastName;
	private String phone;
	private String deptcode;
	private String adminUpdate;

	public void init(){
		msg = "Your change have been saved.";
		errmsg = "Error! \\n User cannot update. \\n Please try again later.";
		// Get the file location to be stored
		filePath = "\\\\160.100.2.147\\public\\HelpDesk\\Main_app_images\\";
		adminUpdate = "";
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

		image = request.getParameter("image");
		photoId = request.getParameter("photoId");
		userId = request.getParameter("userId");
		
		adminUpdate = request.getParameter("adminUpdate");
		if (adminUpdate != null){
			nickname = request.getParameter("nickname");
			nickname = new String(nickname.getBytes("ISO-8859-1"), "UTF-8"); // for Chinese
			firstName = request.getParameter("firstName");
			firstName = new String(firstName.getBytes("ISO-8859-1"), "UTF-8"); // for Chinese
			lastName = request.getParameter("lastName");
			lastName = new String(lastName.getBytes("ISO-8859-1"), "UTF-8"); // for Chinese
			phone = request.getParameter("phone");
			deptcode = request.getParameter("deptcode");
		}
	//image Update	
		file = new File(image);
		if (file.exists()) {
			fileName = HelpDeskDB.getDbUUID() + ".jpg";
			if (!("true".equals(adminUpdate))){
				photoId = HelpDeskDB.getDbUUID();
			}
			// Write File
			f = new File (filePath + fileName.trim());
			BufferedImage bufimage = ImageIO.read(file);
			
			try{
				ImageIO.write(bufimage, "png", f);
			}catch(IOException e){
				//System.out.println("ERROR:" + e);
			}
		}
		
		if ("true".equals(adminUpdate)){
			if (file.exists()) {
				// Update Photo DB
				photoId = HelpDeskDB.uploadPhoto(fileName);
			}
			// Update USER DB (admin)
			update = HelpDeskDB.adminUpdate(userId, firstName, lastName, nickname, phone, photoId, deptcode);
			//System.out.println("Updated: " + update);
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
		}else{
			// Update USER DB (user)
			update = HelpDeskDB.updatePhoto(userId, photoId, fileName);
			//System.out.println("Updated: " + update);
			
			response.setContentType("text/html");
			PrintWriter pw = response.getWriter();
			pw.println("<html>");
			pw.println("<head>");
			pw.println("<script>window.location.reload(\"http://160.100.2.147:8080/HelpDeskWeb/profile.html\");</script>");
			pw.println("</head>");
			pw.println("</html>");
		}
	}
	
	
}

