package com.hkah.fop;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import com.hkah.web.common.ReportableListObject;

public class InvitationLetter {
	public static String toXMLfile(ArrayList result, String foFilePath) throws Exception {
		PrintWriter printWrite2XML = null;

		String defaultOrientation = "portrait";
		String defaultFontSize = "6";

		try {
			//---------------------------------------------------------------------
			printWrite2XML = new PrintWriter(foFilePath, "UTF-8");
		} catch (IOException e) {
			e.printStackTrace();
		}

		// -------------------------------------------------------------------
		// === Fo Page Config ====================================================================
		//-------------------------------------------------------------------------
		printWrite2XML.println("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
		printWrite2XML.println("<fo:root xmlns:fo=\"http://www.w3.org/1999/XSL/Format\">");

		//-------------------------------------------------------------------------
		printWrite2XML.println("<fo:layout-master-set>");

		// === Fo Portrait ========================================================================
		printWrite2XML.println("	<fo:simple-page-master	master-name=\"portrait\"");
		printWrite2XML.println("							page-height=\"29.7cm\"	");
		printWrite2XML.println("							page-width=\"21cm\"	");
		printWrite2XML.println("							margin-top=\"0.5cm\"	");
		printWrite2XML.println("							margin-bottom=\"0.5cm\"	");
		printWrite2XML.println("							margin-left=\"0.5cm\"	");
		printWrite2XML.println("							margin-right=\"0.5cm\"	>");
		printWrite2XML.println("		<fo:region-body margin-top=\"1cm\"/>	");
		printWrite2XML.println("		<fo:region-before extent=\"1cm\"/>	");
		printWrite2XML.println("		<fo:region-after extent=\"1cm\"/>	");
		printWrite2XML.println("	</fo:simple-page-master>	");

		// === Fo Landscape ========================================================================
		printWrite2XML.println("	<fo:simple-page-master 	master-name=\"landscape\"	");
		printWrite2XML.println("			           		page-height=\"21cm\"	");
		printWrite2XML.println("                 		    page-width=\"29.7cm\"	");
		printWrite2XML.println("							margin-top=\"0.5cm\"	");
		printWrite2XML.println("							margin-bottom=\"0.5cm\"	");
		printWrite2XML.println("							margin-left=\"0.5cm\"	");
		printWrite2XML.println("							margin-right=\"0.5cm\"	>");
		printWrite2XML.println("		<fo:region-body margin-top=\"1cm\"/>	");
		printWrite2XML.println("	   	<fo:region-before extent=\"1cm\"/>	");
		printWrite2XML.println("	   	<fo:region-after extent=\"1cm\"/>	");
		printWrite2XML.println("	</fo:simple-page-master>	");

		printWrite2XML.println("</fo:layout-master-set>	");

		// === Set Portrait / Landscape =============================================================
		printWrite2XML.println("<fo:page-sequence 	master-reference=\"" + defaultOrientation +"\"	");
		printWrite2XML.println("					initial-page-number=\"1\" >	");

		//-------------------------------------------------------------------------
		printWrite2XML.println("	<fo:flow flow-name=\"xsl-region-body\" white-space-collapse=\"false\">	");
		printWrite2XML.println("	<fo:wrapper  font-family=\"arialuni\" font-size=\"12pt\" text-align=\"left\">	");

		//-------------------------------------------------------------------------
		if (result.size() > 0) {
			ReportableListObject reportableListObject = null;
			for (int i = 0; i < result.size(); i++) {
				//-------------------------------------------------------------------
				reportableListObject = (ReportableListObject) result.get(i);
				String clientLastName = replaceChar(reportableListObject.getValue(1));
				String clientFirstName = replaceChar(reportableListObject.getValue(2));
				String address1 = replaceChar(reportableListObject.getValue(5));
				String address2 = replaceChar(reportableListObject.getValue(6));
				String address3 = replaceChar(reportableListObject.getValue(7));
				String address4 = replaceChar(reportableListObject.getValue(8));

				// only apply page break in between
				if (i > 0) printWrite2XML.println("		<fo:block break-after=\"page\"/>");

				printWrite2XML.println("		<fo:block text-align=\"right\" space-after.optimum=\"" + defaultFontSize + "pt\">	");
				printWrite2XML.println("Hong Kong Adventist Hospital Foundation");
				printWrite2XML.println("40 StubbsRoad, Hong Kong");
				printWrite2XML.println("Tel (852) 2835 0569");
				printWrite2XML.println("Fax (852) 3651 8865");
				printWrite2XML.println("");
				printWrite2XML.println("		</fo:block>");

				printWrite2XML.println("		<fo:block space-after.optimum=\"" + defaultFontSize + "pt\">	");
				printWrite2XML.println(address1);
				printWrite2XML.println(address2);
				printWrite2XML.println(address3);
				printWrite2XML.println(address4);
				printWrite2XML.println("");
				printWrite2XML.println("Dear " + clientFirstName + " " + clientLastName);
				printWrite2XML.println("");
				printWrite2XML.println("Thank you very much for your support and donation to the Hong Kong Adventist Hospital Foundation.");
				printWrite2XML.println("");
				printWrite2XML.println("Each year, the Hospital, in cooperation with its different fund established at the foundation, invites public participation in its charitable and medical service projects. Its success is the result of your largess. On behalf of the many beneficiaries of your donation, please accept our sincere and heart-felt appreciation.");
				printWrite2XML.println("");
				printWrite2XML.println("Again, thank you for your contribution and gift that will make the difference");
				printWrite2XML.println("");
				printWrite2XML.println("Sincerely");
				printWrite2XML.println("		</fo:block>	");

				printWrite2XML.println("		<fo:block > </fo:block>");
				printWrite2XML.println("		<fo:block text-align=\"center\" font-size=\"" + defaultFontSize + "pt\" font-family=\"Courier\">*** End of letter ***</fo:block>");
			}
		} else {
			printWrite2XML.println("		<fo:block font-size=\""+ defaultFontSize +"pt\" font-family=\"Courier\" >"+ "***There is no Record***" + "</fo:block>");
		}

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