package com.hkah.fop;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsVariable;
import com.hkah.web.common.ReportableListObject;

public class InPatientLetter {
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
		printWrite2XML.println("	<fo:wrapper  font-family=\"arialuni\" font-size=\"" + defaultFontSize + "pt\" text-align=\"left\">	");

		//-------------------------------------------------------------------------
		if (result.size() > 0) {
			ReportableListObject reportableListObject = null;
			for (int i = 0; i < result.size(); i++) {
				//-------------------------------------------------------------------
				reportableListObject = (ReportableListObject) result.get(i);

				String hospitalNo = replaceChar(reportableListObject.getValue(0));
				String clientLastName = replaceChar(reportableListObject.getValue(1));
				String clientFirstName = replaceChar(reportableListObject.getValue(2));
				String clientChineseName = reportableListObject.getValue(3);
				String clientName = null; 
				if (clientChineseName != null && clientChineseName.length() > 0) {
					clientName = clientChineseName; 
				} else {
					clientName = ConstantsVariable.EMPTY_VALUE;
					if (clientFirstName != null && clientFirstName.length() > 0) {
						clientName = clientFirstName;
					}						
					if (clientLastName != null && clientLastName.length() > 0) {
						if (clientName.length() > 0) {
							clientName += ConstantsVariable.SPACE_VALUE;
						}
						clientName += clientLastName;
					}						
				}
				String specialty = replaceChar(reportableListObject.getValue(9));
				String doctorName = replaceChar(reportableListObject.getValue(10));
				String printDate = replaceChar(reportableListObject.getValue(34));
				String appointmentDateTime = replaceChar(reportableListObject.getValue(16));
				String appointmentDate = null;
				String appointmentTime = null;
				if (appointmentDateTime != null && appointmentDateTime.length() > 11) {
					appointmentDate = appointmentDateTime.substring(0, 10);
					appointmentTime = appointmentDateTime.substring(11);
				} else {
					appointmentDate = "";
					appointmentTime = "";
				}
				String flightNo = replaceChar(reportableListObject.getValue(39));
				String transport = replaceChar(reportableListObject.getValue(40));
				String arrivalDateFrom = replaceChar(reportableListObject.getValue(38));
				String arrivalDateTo = replaceChar(reportableListObject.getValue(38));
				String pickupPlace = "";
				String pickupTelephone = "";

				boolean isOB = "ob".equals(specialty); 

				// only apply page break in between
				if (i > 0) printWrite2XML.println("		<fo:block break-after=\"page\"/>");

				printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
				printWrite2XML.println("			<fo:table width=\"198mm\" table-layout=\"fixed\">	");
				printWrite2XML.println("				<fo:table-column width=\"99mm\" />	");
				printWrite2XML.println("				<fo:table-column width=\"99mm\" />	");
				printWrite2XML.println("				<fo:table-body>	");
				printWrite2XML.println("					<fo:table-row>	");
				printWrite2XML.println("						<fo:table-cell padding=\"2pt\" ><fo:block text-align=\"left\">	");
				printWrite2XML.println("<fo:external-graphic src=\"file://www-server/document/Upload/GHC/hkah_logo.jpg\" content-height=\"scale-to-fit\" content-width=\"scale-to-fit\" height=\"2.2cm\" width=\"5.7cm\"/>	");
				printWrite2XML.println("						</fo:block></fo:table-cell>	");
				printWrite2XML.println("						<fo:table-cell padding=\"2pt\" ><fo:block text-align=\"right\">	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.hkah.address1"));
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.hkah.address1"));
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.hkah.address2"));
				printWrite2XML.println("						</fo:block></fo:table-cell>	");
				printWrite2XML.println("					</fo:table-row>");
				printWrite2XML.println("				</fo:table-body>	");
				printWrite2XML.println("			</fo:table>	");
				printWrite2XML.println("		</fo:block>");

				printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.date") + " " + MessageResources.getMessageEnglish("prompt.date") + ": " + printDate);
				printWrite2XML.println("		</fo:block>");

				printWrite2XML.println("		<fo:block text-align=\"center\" space-after.optimum=\"" + defaultSpace + "pt\">	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.title"));
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.confirmIP.title"));
				printWrite2XML.println("		</fo:block>");

				printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.welcome.message1"));
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.confirmIP.welcome.message1"));
				printWrite2XML.println("		</fo:block>");

				printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\">	");
				printWrite2XML.println("			<fo:table width=\"198mm\" table-layout=\"fixed\">	");
				printWrite2XML.println("				<fo:table-column width=\"99mm\" />	");
				printWrite2XML.println("				<fo:table-column width=\"99mm\" />	");
				printWrite2XML.println("				<fo:table-body>	");
				printWrite2XML.println("					<fo:table-row>	");
				printWrite2XML.println("						<fo:table-cell padding=\"2pt\" ><fo:block>	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.block.a") + " " + MessageResources.getMessageEnglish("prompt.confirmIP.block.a"));
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.patientName") + ": " + clientName);
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.patientName"));
				printWrite2XML.println("	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.appointmentDate") + ": " + appointmentDate);
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.appointmentDate"));
				printWrite2XML.println("	");
				if (isOB) {
					printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.doctor.ob") + ": " + doctorName);
					printWrite2XML.println(MessageResources.getMessageEnglish("prompt.doctor.ob"));
				} else {
					printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.doctor.surgical") + ": " + doctorName);
					printWrite2XML.println(MessageResources.getMessageEnglish("prompt.doctor.surgical"));
				}
				printWrite2XML.println("	");
				printWrite2XML.println("	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.block.b") + " " + MessageResources.getMessageEnglish("prompt.confirmIP.block.b"));
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.flightNo") + ": " + flightNo);
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.flightNo"));
				printWrite2XML.println("	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.transportation.arrivalStartTime") + ": " + arrivalDateFrom);
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.transportation.arrivalStartTime"));
				printWrite2XML.println("	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.pickup.location") + ": " + pickupPlace);
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.pickup.location"));
				printWrite2XML.println("						</fo:block></fo:table-cell>	");
				printWrite2XML.println("						<fo:table-cell padding=\"2pt\" ><fo:block>	");
				printWrite2XML.println("	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.hospitalNo") + ": " + hospitalNo);
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.hospitalNo"));
				printWrite2XML.println("	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.appointmentTime") + ": " + appointmentTime);
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.appointmentTime"));
				printWrite2XML.println("	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.registration.location") + ": " + MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.registration"));
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.registration.location") + ": " + MessageResources.getMessageEnglish("prompt.confirmIP.registration"));
				printWrite2XML.println("	");
				printWrite2XML.println("	");
				printWrite2XML.println("	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.transportation.other") + ": " + transport);
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.transportation.other"));
				printWrite2XML.println("	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.transportation.arrivalEndTime") + ": " + arrivalDateTo);
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.transportation.arrivalEndTime"));
				printWrite2XML.println("	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.pickup.telephone") + ": " + pickupTelephone);
				printWrite2XML.println(MessageResources.getMessageEnglish("prompt.pickup.telephone"));
				printWrite2XML.println("						</fo:block></fo:table-cell>	");
				printWrite2XML.println("					</fo:table-row>");
				printWrite2XML.println("				</fo:table-body>	");
				printWrite2XML.println("			</fo:table>	");
				printWrite2XML.println("		</fo:block>");

				printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\" font-size=\"" + smallFontSize + "pt\">	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.title") + " " + MessageResources.getMessageEnglish("prompt.confirmIP.important.title"));
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message1"));
				printWrite2XML.println("    " +MessageResources.getMessageEnglish("prompt.confirmIP.important.message1"));
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2"));
				printWrite2XML.println("    " +MessageResources.getMessageEnglish("prompt.confirmIP.important.message2"));
				printWrite2XML.println("    " +MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2.1") + " " + MessageResources.getMessageEnglish("prompt.confirmIP.important.message2.1"));
				printWrite2XML.println("    " +MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2.2") + " " + MessageResources.getMessageEnglish("prompt.confirmIP.important.message2.2"));
				printWrite2XML.println("    " +MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2.3") + " " + MessageResources.getMessageEnglish("prompt.confirmIP.important.message2.3"));
				printWrite2XML.println("    " +MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2.4") + " " + MessageResources.getMessageEnglish("prompt.confirmIP.important.message2.4"));
				printWrite2XML.println("    " +MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2.5") + " " + MessageResources.getMessageEnglish("prompt.confirmIP.important.message2.5"));
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message3"));
				printWrite2XML.println("    " +MessageResources.getMessageEnglish("prompt.confirmIP.important.message3"));
				printWrite2XML.println("		</fo:block>");

				printWrite2XML.println("		<fo:block text-align=\"left\" space-after.optimum=\"" + defaultSpace + "pt\" font-size=\"" + smallFontSize + "pt\">	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.remarks") + " " + MessageResources.getMessageEnglish("prompt.remarks") + ":");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.reminder.message1") + " " + MessageResources.getMessageEnglish("prompt.reminder.message1"));
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.reminder.message2") + " " + MessageResources.getMessageEnglish("prompt.reminder.message2"));
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.reminder.message3") + " " + MessageResources.getMessageEnglish("prompt.reminder.message3"));
				printWrite2XML.println("		</fo:block>");

				printWrite2XML.println("		<fo:block > </fo:block>");
				printWrite2XML.println("		<fo:block text-align=\"center\" space-after.optimum=\"" + (defaultSpace - 2) + "pt\" font-size=\"" + remarkFontSize + "pt\">	");
				printWrite2XML.println(MessageResources.getMessageSimplifiedChinese("prompt.computerCopyOnly") + " " + MessageResources.getMessageEnglish("prompt.computerCopyOnly"));
				printWrite2XML.println("		</fo:block>");
			}
		} else {
			printWrite2XML.println("		<fo:block font-size=\"" + remarkFontSize + "pt\" font-family=\"Courier\" >"+ "***There is no Record***" + "</fo:block>");
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