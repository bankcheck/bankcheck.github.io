package com.hkah.servlet;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hkah.web.db.HelpDeskDB;

public class NewUser extends HttpServlet {

	private String filePath;
	private File file;
	private File f;
	private String image;
	private String photoId;
	private String fileName;
	// user information
	private String userId;
	private String password;
	private String passwordPlain;
	private String nickname;
	private String firstName;
	private String lastName;
	private String userType;
	private String phone;
	private String deptcode;

	public void init() {
		// Get the file location to be stored
		filePath = "\\\\160.100.2.147\\public\\HelpDesk\\Main_app_images\\";
	}

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		service(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		service(request, response);
	}

	public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		image = request.getParameter("image");
		userId = request.getParameter("userId");
		password = request.getParameter("password");
		passwordPlain = request.getParameter("passwordPlain");

		nickname = request.getParameter("nickname");
		nickname = new String(nickname.getBytes("ISO-8859-1"), "UTF-8"); // for
																			// Chinese
		firstName = request.getParameter("firstName");
		firstName = new String(firstName.getBytes("ISO-8859-1"), "UTF-8"); // for
																			// Chinese
		lastName = request.getParameter("lastName");
		lastName = new String(lastName.getBytes("ISO-8859-1"), "UTF-8"); // for
																			// Chinese
		userType = request.getParameter("userType");
		phone = request.getParameter("phone");
		deptcode = request.getParameter("deptcode");

		// image Update
		file = new File(image);
		if (file.exists()) {
			fileName = HelpDeskDB.getDbUUID() + ".jpg";
			// Write File
			f = new File(filePath + fileName.trim());
			BufferedImage bufimage = ImageIO.read(file);
			try {
				ImageIO.write(bufimage, "png", f);
				// Update Photo DB
				photoId = HelpDeskDB.uploadPhoto(fileName);
			} catch (IOException e) {
				// System.out.println("ERROR:" + e);
			}
		}
		// userPhoto Update
		boolean update = HelpDeskDB.add(userId, firstName, lastName, nickname, passwordPlain, password, userType, phone, photoId, deptcode);
		// System.out.println("Updated: " + update);

		response.setContentType("text/html");
		PrintWriter pw = response.getWriter();
		pw.println("<html>");
		pw.println("<head>");
		pw.println("<script>window.location.reload(\"http://160.100.2.147:8080/HelpDeskWeb/um.html\")</script>");
		pw.println("</head>");
		pw.println("</html>");
	}
}