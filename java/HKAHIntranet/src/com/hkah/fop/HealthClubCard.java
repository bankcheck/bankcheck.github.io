package com.hkah.fop;

import java.io.IOException;
import java.io.PrintWriter;

public class HealthClubCard {
	public static String toXMLfile(String name, String memberNo, String expiryDate, String foFilePath) throws Exception {
		PrintWriter printWrite2XML = null;

		String defaultOrientation = "portrait";
		int defaultFontSize = 1;

		try {
			//---------------------------------------------------------------------
			printWrite2XML = new PrintWriter(foFilePath, "UTF-8");

			// -------------------------------------------------------------------
			// === Fo Page Config ====================================================================
			//-------------------------------------------------------------------------
			printWrite2XML.println("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
			printWrite2XML.println("<fo:root xmlns:fo=\"http://www.w3.org/1999/XSL/Format\">");

			//-------------------------------------------------------------------------
			printWrite2XML.println("<fo:layout-master-set>");
			printWrite2XML.println("	<fo:simple-page-master	master-name=\"portrait\"");
			printWrite2XML.println("							page-height=\"5.4cm\"	");
			printWrite2XML.println("							page-width=\"8.55cm\"	");
			printWrite2XML.println("							margin-top=\"3.5cm\"	");
			printWrite2XML.println("							margin-bottom=\"0cm\"	");
			printWrite2XML.println("							margin-left=\"4.5cm\"	");
			printWrite2XML.println("							margin-right=\"0cm\"	>");
			printWrite2XML.println("		<fo:region-body margin-top=\"0cm\"/>	");
			printWrite2XML.println("		<fo:region-before extent=\"0cm\"/>	");
			printWrite2XML.println("		<fo:region-after extent=\"0cm\"/>	");
			printWrite2XML.println("	</fo:simple-page-master>	");
			printWrite2XML.println("</fo:layout-master-set>	");

			// === Set Portrait / Landscape =============================================================
			printWrite2XML.println("<fo:page-sequence 	master-reference=\"" + defaultOrientation +"\"	");
			printWrite2XML.println("					initial-page-number=\"1\" >	");

			//-------------------------------------------------------------------------
			printWrite2XML.println("	<fo:flow flow-name=\"xsl-region-body\" white-space-collapse=\"false\">	");
			printWrite2XML.println("	<fo:wrapper  font-family=\"arialuni\" font-size=\"9pt\" text-align=\"left\">	");
			printWrite2XML.println("	<fo:table width=\"4.05cm\" table-layout=\"fixed\">	");
			printWrite2XML.println("		<fo:table-column />	");
			printWrite2XML.println("		<fo:table-body>	");
			printWrite2XML.println("			<fo:table-row>	");

			//-------------------------------------------------------------------------
			printWrite2XML.println("						<fo:table-cell padding=\"2pt\" >	");
			printWrite2XML.println("							<fo:block text-align=\"left\">	");
			printWrite2XML.println(name);
			printWrite2XML.println("Member No : " + memberNo);
			printWrite2XML.println("Expiry Date : " + expiryDate);
			printWrite2XML.println("							</fo:block>	");
			printWrite2XML.println("						</fo:table-cell>	");

			//-------------------------------------------------------------------------
			printWrite2XML.println("			</fo:table-row>	");
			printWrite2XML.println("		</fo:table-body>	");
			printWrite2XML.println("	</fo:table>	");

			// === Fo flow ====================================================================================
			//-------------------------------------------------------------------------
			printWrite2XML.println(" 	</fo:wrapper>	");
			printWrite2XML.println(" 	</fo:flow>	");


			// === Fo page-sequenc Ending =====================================================================
			//-------------------------------------------------------------------------
			printWrite2XML.println("</fo:page-sequence> 	");
			printWrite2XML.println("</fo:root>	");

			// -------------------------------------------------------------------
			printWrite2XML.flush();
			printWrite2XML.close();

		} catch (IOException e) {
			e.printStackTrace();
		}

		return foFilePath;
	}

	private static String replaceChar(String inputStr) {
		String outputStr = replaceCharHelper(inputStr, "&", "&#38;");
		outputStr = replaceCharHelper(outputStr, "<", "&lt;");
		outputStr = replaceCharHelper(outputStr, ">", "&gt;");
		return outputStr;
	}

	private static String replaceCharHelper(String inputStr, String replaceFrom, String replaceTo) {
		int startPtr = 0;
		int endPtr = 0;
		StringBuffer tempBuffer = new StringBuffer();

		try	{
			if (inputStr.indexOf("&", startPtr) >= 0) {
				while ((endPtr = inputStr.indexOf("&", startPtr)) >= 0) {
					tempBuffer.append(inputStr.substring(startPtr, endPtr));
					tempBuffer.append("&#38;");
					startPtr = endPtr + 1;
				}
				tempBuffer.append(inputStr.substring(startPtr));
				return tempBuffer.toString();
			}
		} catch (Exception e) {
		}
		return inputStr;
	}
}