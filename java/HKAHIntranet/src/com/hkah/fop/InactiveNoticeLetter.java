package com.hkah.fop;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import com.hkah.config.MessageResources;
import com.hkah.web.common.ReportableListObject;

public class InactiveNoticeLetter {
	public static String toXMLfile(ArrayList result, String foFilePath) throws Exception {
		PrintWriter printWrite2XML = null;

		String defaultOrientation = "portrait";
		int defaultSpace = 1;
		int defaultFontSize = 11;
		int smallFontSize = 9;
		int remarkFontSize = 7;

		try {
			//---------------------------------------------------------------------
			// create folder if necessary
			File file = new File(foFilePath);
			if (!file.getParentFile().exists()) {
				file.getParentFile().mkdir();
			}

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
		printWrite2XML.println("							margin-left=\"2cm\"	");
		printWrite2XML.println("							margin-right=\"2cm\"	>");
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
		printWrite2XML.println("	<fo:wrapper  font-family=\"arialuni\" font-size=\"" + defaultFontSize + "pt\" text-align=\"left\">	");

		//-------------------------------------------------------------------------
		
		if (result.size() > 0) {
			ReportableListObject reportableListObject = null;			
			DateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy", Locale.ENGLISH);
			Calendar cal = Calendar.getInstance();			
			   
			//get current date time with Date()
			Date currentDate = cal.getTime();
				
			reportableListObject = (ReportableListObject) result.get(0);
			String docFName = replaceChar(reportableListObject.getValue(1));				
			String docGName = replaceChar(reportableListObject.getValue(2));
			String docAddr1 = replaceChar(reportableListObject.getValue(11));
			String docAddr2 = replaceChar(reportableListObject.getValue(12));
			String docAddr3 = replaceChar(reportableListObject.getValue(13));
			String docAddr4 = replaceChar(reportableListObject.getValue(14));
	
			printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
			printWrite2XML.println("	");
			printWrite2XML.println("	");
			printWrite2XML.println("	");
			printWrite2XML.println("	");				
			printWrite2XML.println("		</fo:block>");

			printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
			printWrite2XML.println(MessageResources.getMessageEnglish(dateFormat.format(currentDate)));
			printWrite2XML.println("	");
			printWrite2XML.println(MessageResources.getMessageEnglish(docAddr1));
			printWrite2XML.println(MessageResources.getMessageEnglish(docAddr2));	
			printWrite2XML.println(MessageResources.getMessageEnglish(docAddr3));
			printWrite2XML.println(MessageResources.getMessageEnglish(docAddr4));
			printWrite2XML.println("		</fo:block>");
			
			printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
			printWrite2XML.println(MessageResources.getMessageSimplifiedChinese(""));
			printWrite2XML.println(MessageResources.getMessageEnglish("prompt.inactNotice.content1"));
			printWrite2XML.println("		</fo:block>");			
			
			printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");			
			printWrite2XML.println(MessageResources.getMessageEnglish("Dear Dr. " + docFName + ", " + docGName));
			printWrite2XML.println("		</fo:block>");
				

			printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
			printWrite2XML.println(MessageResources.getMessageSimplifiedChinese(""));
			printWrite2XML.println(MessageResources.getMessageEnglish("prompt.inactNotice.content2"));
			printWrite2XML.println("		</fo:block>");
			
			printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
			printWrite2XML.println(MessageResources.getMessageSimplifiedChinese(""));
			printWrite2XML.println(MessageResources.getMessageEnglish("prompt.inactNotice.content3"));
			printWrite2XML.println("		</fo:block>");			
			
			printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
			printWrite2XML.println(MessageResources.getMessageSimplifiedChinese(""));
			printWrite2XML.println(MessageResources.getMessageEnglish("prompt.inactNotice.content4"));
			printWrite2XML.println("		</fo:block>");
			
			printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
			printWrite2XML.println(MessageResources.getMessageSimplifiedChinese(""));
			printWrite2XML.println(MessageResources.getMessageEnglish("prompt.inactNotice.content5"));
			printWrite2XML.println("		</fo:block>");			

			printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
			printWrite2XML.println("			<fo:table width=\"198mm\" table-layout=\"fixed\">	");
			printWrite2XML.println("				<fo:table-column width=\"99mm\" />	");
			printWrite2XML.println("				<fo:table-column width=\"99mm\" />	");
			printWrite2XML.println("				<fo:table-body>	");
			printWrite2XML.println("					<fo:table-row>	");
			printWrite2XML.println("						<fo:table-cell padding=\"2pt\" ><fo:block>	");
			printWrite2XML.println(MessageResources.getMessageEnglish("prompt.reappform.approveStaff1"));
			printWrite2XML.println(MessageResources.getMessageEnglish("prompt.reappform.content5"));
			printWrite2XML.println("						</fo:block></fo:table-cell>	");
			printWrite2XML.println("						<fo:table-cell padding=\"2pt\" ><fo:block>	");
			printWrite2XML.println(MessageResources.getMessageEnglish("prompt.reappform.approveStaff2"));
			printWrite2XML.println(MessageResources.getMessageEnglish("prompt.reappform.content6"));				printWrite2XML.println("						</fo:block></fo:table-cell>	");
			printWrite2XML.println("					</fo:table-row>");
			printWrite2XML.println("				</fo:table-body>	");
			printWrite2XML.println("			</fo:table>	");
			printWrite2XML.println("		</fo:block>");

			printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
			printWrite2XML.println(MessageResources.getMessageSimplifiedChinese(""));
			printWrite2XML.println(MessageResources.getMessageEnglish("prompt.reappform.content7"));
			printWrite2XML.println("		</fo:block>");					
		}
//		} else {
//			printWrite2XML.println("		<fo:block font-size=\"" + remarkFontSize + "pt\" font-family=\"Courier\" >"+ "***There is no Record***" + "</fo:block>");
//		}

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