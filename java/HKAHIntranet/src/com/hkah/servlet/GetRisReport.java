package com.hkah.servlet;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class GetRisPeport
 */
public class GetRisReport extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetRisReport() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter pw = null;
		try{
			pw = response.getWriter();

			ByteArrayOutputStream ba= loadPdf(request.getParameter("url"));
			System.out.println("debug GetRisReport : url = " + request.getParameter("url") ) ;
			//ByteArrayOutputStream ba= loadPdf("//IM-AP01/RisReport/HKADI1400050588L/1.2.410.200010.1144110.5766.7275932.8056629_46474_A.pdf");

			//Converting byte[] to base64 string 
			//NOTE: Always remember to encode your base 64 string in utf8 format other wise you may always get problems on browser.

			String pdfBase64String = new String(org.apache.commons.codec.binary.Base64.encodeBase64(ba.toByteArray()), "UTF-8");

			//wrting json response to browser

			/*
			pw.println("{");
			pw.println("\"successful\": true,");
			pw.println("\"pdf\": \""+pdfBase64String+"\"");
			pw.println("}");
			*/
			pw.println(pdfBase64String);
			return;
		} catch (Exception ex) {
			pw.println("{");
			pw.println("\"successful\": false,");
			pw.println("\"message\": \""+ex.getMessage()+"\",");
			pw.println("}");
			return;
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	private ByteArrayOutputStream loadPdf(String fileName) throws FileNotFoundException
	{
		File file = new File(fileName);
		FileInputStream fis = null;
		ByteArrayOutputStream bos = null ;
		try {
			fis = new FileInputStream(file);
			bos = new ByteArrayOutputStream();

			byte[] buf = new byte[1024];
			try {
				for (int readNum; (readNum = fis.read(buf)) != -1;) {
					bos.write(buf, 0, readNum); //no doubt here is 0
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		} catch (IOException e) {
			System.out.print("debug : GetRisReport, " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (fis != null)
					fis.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		return bos;
	}
	
}
