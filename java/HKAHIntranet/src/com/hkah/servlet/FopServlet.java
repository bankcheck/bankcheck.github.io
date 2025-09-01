package com.hkah.servlet;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.fop.apps.Driver;
import org.apache.fop.apps.Options;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

/*
============================================================================
		   The Apache Software License, Version 1.1
============================================================================

   Copyright (C) 1999 The Apache Software Foundation. All rights reserved.

Redistribution and use in source and binary forms, with or without modifica-
tion, are permitted provided that the following conditions are met:

1. Redistributions of  source code must  retain the above copyright  notice,
   this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. The end-user documentation included with the redistribution, if any, must
   include  the following  acknowledgment:  "This product includes  software
   developed  by the  Apache Software Foundation  (http://www.apache.org/)."
   Alternately, this  acknowledgment may  appear in the software itself,  if
   and wherever such third-party acknowledgments normally appear.

4. The names "Fop" and  "Apache Software Foundation"  must not be used to
   endorse  or promote  products derived  from this  software without  prior
   written permission. For written permission, please contact
   apache@apache.org.

5. Products  derived from this software may not  be called "Apache", nor may
   "Apache" appear  in their name,  without prior written permission  of the
   Apache Software Foundation.

THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS  FOR A PARTICULAR  PURPOSE ARE  DISCLAIMED.  IN NO  EVENT SHALL  THE
APACHE SOFTWARE  FOUNDATION  OR ITS CONTRIBUTORS  BE LIABLE FOR  ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL  DAMAGES (INCLU-
DING, BUT NOT LIMITED TO, PROCUREMENT  OF SUBSTITUTE GOODS OR SERVICES; LOSS
OF USE, DATA, OR  PROFITS; OR BUSINESS  INTERRUPTION)  HOWEVER CAUSED AND ON
ANY  THEORY OF LIABILITY,  WHETHER  IN CONTRACT,  STRICT LIABILITY,  OR TORT
(INCLUDING  NEGLIGENCE OR  OTHERWISE) ARISING IN  ANY WAY OUT OF THE  USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This software  consists of voluntary contributions made  by many individuals
on  behalf of the Apache Software  Foundation and was  originally created by
James Tauber <jtauber@jtauber.com>. For more  information on the Apache
Software Foundation, please see <http://www.apache.org/>.

*/
public class FopServlet extends HttpServlet {
	public static final String FO_REQUEST_PARAM = "fo";

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException {
		try {
			if (request.getParameter(FO_REQUEST_PARAM) != null) {

				FileInputStream file = new FileInputStream(request
						.getParameter(FO_REQUEST_PARAM));

				renderFO(new InputSource(file), response);
			} else {
				PrintWriter out = response.getWriter();

				response.setContentType("text/html");

				out.println("<html><head><title>Error</title></head>\n"
						+ "<body><h1>FopServlet Error</h1><h3>No 'fo' "
						+ "request param given.</body></html>");
			}
		}
		// catch (ServletException ex) {
		// throw ex;
		// }
		catch (Exception ex) {
			throw new ServletException(ex);
		}
	}

	/**
	 * renders an FO inputsource into a PDF file which is rendered directly to
	 * the response object's OutputStream
	 */
	public void renderFO(InputSource foFile, HttpServletResponse response)
			throws ServletException {
		try {
			ByteArrayOutputStream out = new ByteArrayOutputStream();

			response.setContentType("application/pdf");

			// Create driver for PDF
			Driver driver = new Driver();
			driver.setInputSource(foFile);
			driver.setOutputStream(out);
			driver.setRenderer(Driver.RENDER_PDF);

			// Read configure file
			Options options = new Options(new File("/WebConfig/fop/userconfig.xml"));
			driver.run();

			byte[] content = out.toByteArray();
			response.setContentLength(content.length);
			response.getOutputStream().write(content);
			response.getOutputStream().flush();
//		} catch (ServletException ex) {
//			throw ex;
		} catch (Exception ex) {
			throw new ServletException(ex);
		}
	}

	/**
	 * creates a SAX parser, using the value of org.xml.sax.parser defaulting to
	 * org.apache.xerces.parsers.SAXParser
	 *
	 * @return the created SAX parser
	 */
	public static XMLReader createParser() throws ServletException {
		String parserClassName = System.getProperty("org.xml.sax.parser");
		if (parserClassName == null) {
			parserClassName = "org.apache.xerces.parsers.SAXParser";
		}

		try {
			return (XMLReader) Class.forName(parserClassName).newInstance();
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException {
		doGet(request, response);
	}
}