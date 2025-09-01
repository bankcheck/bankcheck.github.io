<%@page import="org.apache.poi.POIXMLTextExtractor"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.servlet.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.hkah.servlet.*" %>
<%@ page import="java.io.*" %>  
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.file.*" %>
<%@ page import="javax.xml.transform.stream.StreamSource" %>
<%@ page import="javax.xml.transform.Transformer" %>
<%@ page import="javax.xml.transform.TransformerFactory" %>
<%@ page import="javax.xml.transform.stream.StreamResult" %>
<%@ page import="org.apache.fop.apps.FOUserAgent" %>
<%@ page import="org.apache.fop.apps.FopFactory" %>
<%@ page import="org.apache.fop.apps.MimeConstants" %>
<%@ page import="com.lowagie.text.pdf.PdfReader"%> 
<%@ page import="com.lowagie.text.pdf.PdfWriter"%>
<%@ page import=" com.lowagie.text.pdf.parser.PdfTextExtractor" %>

<%
String patNo = request.getParameter("patNo");
String accessionNo = request.getParameter("accessionNo");
String sql = null;
String sql1 = null;

ResultSet rs = null;
ResultSet rs1 = null;

byte[] buf = null;
Blob report = null;
String xmlText = new String();
Connection con = HKAHInitServlet.getDataSourcePACS().getConnection();
Statement stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
Statement stmt1 = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);

		sql = 	"SELECT REPORT_TEXT_BLOB FROM REPORT WHERE STUDY_KEY = "+
				"(SELECT STUDY_KEY FROM STUDY "+
				"WHERE ACCESS_NO = '"+accessionNo+"' "+
				"AND PATIENT_ID = '"+patNo+"' "+
				"AND ORDER_KEY IS NOT NULL) ";
		
		rs = stmt.executeQuery(sql);
					 
		sql1 = 	"SELECT EXAM_REPORT_PATH FROM SYSTEMLOG "+
		"WHERE ACCESSION_NO = '"+accessionNo+"' "+
		"AND PAT_PATNO = '"+patNo+"' ";
		
		rs1 = stmt1.executeQuery(sql1);
		if (rs1.next()) {
			  File xmlFile = new File(rs1.getString(1));
			  javax.xml.parsers.DocumentBuilderFactory dbf = javax.xml.parsers.DocumentBuilderFactory.newInstance();
			  javax.xml.parsers.DocumentBuilder db = dbf.newDocumentBuilder();
			  org.w3c.dom.Document doc = db.parse(xmlFile);
			  doc.getDocumentElement().normalize();
			  String pdfString = 
					  ((org.w3c.dom.Node)doc.getDocumentElement().getChildNodes()
					  .item(1).getChildNodes()
					  .item(1).getChildNodes()
					  .item(2).getChildNodes()
					  .item(0).getChildNodes()
					  .item(3).getChildNodes()
					  .item(3).getFirstChild()).getNodeValue();
			  sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
			  byte[] decodedBytes = decoder.decodeBuffer(pdfString);
			  File file = new File("\\\\192.168.0.20\\document\\Intranet\\Portal\\radiCompare\\xmlPdf\\"+accessionNo+"Xml.pdf");
				FileOutputStream fop = new FileOutputStream(file);
				fop.write(decodedBytes);
				fop.flush();
				fop.close();
		}
		if (rs.next()) {
			report = rs.getBlob(1);
		
			InputStream inStream = report.getBinaryStream();
			int length = -1;
			int size = (int)report.length();
			byte[] buffer = new byte[size];
			ByteArrayOutputStream outStream = new ByteArrayOutputStream();
			buf = org.apache.commons.io.IOUtils.toByteArray(inStream);
			while ((length = inStream.read(buffer)) != -1) {
					outStream.write(buffer, 0, length);
			        outStream.flush();
			    }
				
				inStream.close();
			    outStream.close(); 
					
					try {
						ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(buf);  
						File xsltfile = new File("\\\\192.168.0.20\\document\\Intranet\\Portal\\radiCompare\\xsl\\Word2FO.xsl");
						File pdffile = new File("\\\\192.168.0.20\\document\\Intranet\\Portal\\radiCompare\\wordPdf\\"+accessionNo+"Wd.pdf");
						OutputStream out1 = new java.io.FileOutputStream(pdffile,false);
							          out1 = new java.io.BufferedOutputStream(out1);
						 
						 StreamSource xsrc = new  StreamSource(byteArrayInputStream); 
						 FopFactory fopFactory = FopFactory.newInstance();
						 fopFactory.setStrictValidation(false);
						 FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
						 Transformer  trfmer;
						 org.apache.fop.apps.Fop fop = fopFactory.newFop("application/pdf",foUserAgent,out1);				
						 trfmer = TransformerFactory.newInstance().newTransformer(new StreamSource(xsltfile));
						 trfmer.setParameter("versionParam", "2.0");
						 javax.xml.transform.Result  result = new javax.xml.transform.sax.SAXResult(fop.getDefaultHandler());
						 trfmer.transform(xsrc,result);
						 out1.close();

						 PdfReader reader = new PdfReader("\\\\192.168.0.20\\document\\Intranet\\Portal\\radiCompare\\wordPdf\\"+accessionNo+"Wd.pdf");
				         int n = reader.getNumberOfPages(); 
				         PdfTextExtractor e = new PdfTextExtractor(reader);
				         String str = "";
				         for(int i=1;i<=n;i++){
				        	 str += e.getTextFromPage(i).replaceAll("\\s","").split("\\*DIAG-MOF01\\*6")[1].trim();
				         }
						 FileWriter outFile = new FileWriter("\\\\192.168.0.20\\document\\Intranet\\Portal\\radiCompare\\CompTxt\\"+accessionNo+"Rt.html",false);
						 PrintWriter  writer = new PrintWriter (outFile);
				         writer.println("<html><meta http-equiv=Content-Type content=\"text//html; charset=big5\">");
				         writer.println("<table border=\"1\" width=\"1000\" style=\"table-layout: fixed;\">");
				         writer.println("<tr><td>Word PDF Content</td><td>XML PDF Content</td></tr>");
				         writer.println("<tr><td width=\"500\"style=\"word-wrap:break-word;\">"+str);
				         writer.println("</td>");
				         
				         PdfReader reader1 = new PdfReader("\\\\192.168.0.20\\document\\Intranet\\Portal\\radiCompare\\xmlPdf\\"+accessionNo+"Xml.pdf");
				         int n1 = reader1.getNumberOfPages(); 
				         PdfTextExtractor e1 = new PdfTextExtractor(reader1);
				         String str1 = "";
				         for(int i=1;i<=n1;i++){
				        	 str1 += e1.getTextFromPage(i).replaceAll("\\s","").split("\\*DIAG-MOF01\\*6")[1].trim();
				         }
				         char[] wdCharArray = str.toCharArray();
				         char[] xmlCharArray = str1.toCharArray();
				         int minLength = Math.min(wdCharArray.length, xmlCharArray.length);
				         writer.println("<td width=\"500\" style=\"word-wrap:break-word;vertical-align:top;\">");
				         for(int i = 0; i < minLength; i++)
				         {
			                 if (wdCharArray[i] != xmlCharArray[i])
			                 {
			                	 writer.print("<font color=\"red\">"+xmlCharArray[i]+"</font>");
			                 }else{writer.print(xmlCharArray[i]);
							 }
				         }
				         //writer.println("<td width=\"200\" style=\"word-wrap:break-word;\">xml PDF: "+str1);
				         writer.println("<tr><td>Word PDF Length:"+str.length()+"</td><td>XML PDF length: "+str1.length()+"</td></tr>");
				         writer.println("</td></tr>");
				         writer.println("<tr><td colspan=\"2\">Comparison: "+(str.compareToIgnoreCase(str1)==0?"MATCHED":"UNMATCHED")+"</td></tr></table></html>");
				         writer.close();
				         String resultString = (str.compareToIgnoreCase(str1)==0?"MATCH":"UNMATCH");
				         %>
							<%=resultString %>
						<%
			 		
					}
					catch(Exception exep){System.out.println(exep);} 
					
				   
					
		}else {	
			%>
				<script>
					alert("Cannot find this document.");
				</script>
			<%
		}

%>