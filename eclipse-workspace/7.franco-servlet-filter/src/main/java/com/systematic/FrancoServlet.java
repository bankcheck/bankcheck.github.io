package com.systematic;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(value = "/francoservlet")
public class FrancoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L; // Declare serialVersionUID

	public FrancoServlet() {
		System.out.println("Franco Servlet Class");
	}

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Franco Servlet Method");

		// Set response content type
		response.setContentType("text/plain");

		// Get the PrintWriter object to write the response
		PrintWriter out = response.getWriter();

		// Print "Hello World" to the response
		out.println("Hello World From Franco Servlet");
	}
}
