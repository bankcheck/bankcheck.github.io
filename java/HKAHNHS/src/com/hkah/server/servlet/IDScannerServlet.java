package com.hkah.server.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hkah.server.util.QueryUtil;

public class IDScannerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		this.doPost(req , resp) ;
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		String docType = request.getParameter("docType");
		String docID = request.getParameter("docID");
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String sex = request.getParameter("sex");
		String dob = request.getParameter("dob");
		String localip = request.getParameter("localip");

		QueryUtil.executeTx(null, "NHS", "ACT_PATIENT_IDSCANNER",
				new String[] {
						docType,
						docID,
						firstname,
						lastname,
						sex,
						dob,
						localip
				});
	}
}