package com.hkah.fop;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.crm.ParameterHelper;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.CRMClientDB;

public class Label_L7160 {
	/* Avery L7160 */
	public static String toXMLfile(HttpSession session, ArrayList result, String foFilePath, String footer) throws Exception {
		PrintWriter printWrite2XML = null;

		String defaultOrientation = "portrait";
		int defaultFontSize = 2;

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
			printWrite2XML.println("							page-height=\"29.7cm\"	");
			printWrite2XML.println("							page-width=\"21cm\"	");
			printWrite2XML.println("							margin-top=\"1.5cm\"	");
			printWrite2XML.println("							margin-bottom=\"15mm\"	");
			printWrite2XML.println("							margin-left=\"11mm\"	");
			printWrite2XML.println("							margin-right=\"3mm\"	>");
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
			printWrite2XML.println("	<fo:wrapper  font-family=\"arialuni\" font-size=\"8pt\" text-align=\"left\">	");
			printWrite2XML.println("	<fo:table width=\"198mm\" table-layout=\"fixed\">	");
			printWrite2XML.println("		<fo:table-column width=\"66mm\" height=\"38mm\" />	");
			printWrite2XML.println("		<fo:table-column width=\"66mm\" height=\"38mm\" />	");
			printWrite2XML.println("		<fo:table-column width=\"66mm\" height=\"38mm\" />	");
			printWrite2XML.println("		<fo:table-body>	");
			printWrite2XML.println("			<fo:table-row height=\"38mm\">	");

			//-------------------------------------------------------------------------
			if (result.size() > 0) {
				ReportableListObject reportableListObject = null;
				String clientLastName = null;
				String clientFirstName = null;
				String clientChineseName = null;
				String clientName = null;
				String address1 = null;
				String address2 = null;
				String address3 = null;
				String address4 = null;
				String line[] = new String[5];
				String districtID = null;
				String districtDesc = null;
				String areaID = null;
				String areaDesc = null;
				String labelFooter = null;
				for (int i = 0; i < result.size(); i++) {
					//-------------------------------------------------------------------
					reportableListObject = (ReportableListObject) result.get(i);
					if (reportableListObject.getValue(0) != null && reportableListObject.getValue(0).length() > 0) {
						labelFooter = footer + ConstantsVariable.SPACE_VALUE + (i + 1);
					} else {
						labelFooter = null;
					}
					clientLastName = replaceChar(reportableListObject.getValue(1));
					clientFirstName = replaceChar(reportableListObject.getValue(2));
					clientChineseName = reportableListObject.getValue(3);
					if (clientChineseName != null && clientChineseName.length() > 0) {
						clientName = clientChineseName; 
					} else {
						clientName = CRMClientDB.getClientName(clientLastName, clientFirstName);						
					}
					address1 = replaceChar(reportableListObject.getValue(5));
					address2 = replaceChar(reportableListObject.getValue(6));
					address3 = replaceChar(reportableListObject.getValue(7));
					address4 = replaceChar(reportableListObject.getValue(8));
					districtID = replaceChar(reportableListObject.getValue(10));
					if (districtID != null && !"0".equals(districtID) && districtID.length() > 0) {
						districtDesc = ParameterHelper.getDistrictValue(session, districtID);
					} else {
						districtDesc = ConstantsVariable.EMPTY_VALUE;
					}
					areaID = replaceChar(reportableListObject.getValue(11));
					if (areaID != null && !"0".equals(areaID) && areaID.length() > 0) {
						areaDesc = ParameterHelper.getAreaValue(session, areaID);
					} else {
						areaDesc = ConstantsVariable.EMPTY_VALUE;
					}

					// create line 1 - line 5
					line[0] = address1;
					line[1] = address2;
					line[2] = address3;
					line[3] = address4;
					line[4] = districtDesc + ConstantsVariable.SPACE_VALUE + areaDesc;
					for (int j = 4; j > 0; j--) {
						if (line[j - 1] == null || line[j - 1].length() == 0) {
							line[j - 1] = line[j];
							line[j] = null;
						}
					}

					if (i > 0 && (i % 3 == 0)) {
						printWrite2XML.println("			</fo:table-row>");
						if (i > 0 && i % 21 == 0) {
							printWrite2XML.println("		</fo:table-body>	");
							printWrite2XML.println("	</fo:table>	");
							printWrite2XML.println("	<fo:block break-after=\"page\"/>");
							printWrite2XML.println("	<fo:table width=\"198mm\" table-layout=\"fixed\">	");
							printWrite2XML.println("		<fo:table-column width=\"66mm\" height=\"38mm\" />	");
							printWrite2XML.println("		<fo:table-column width=\"66mm\" height=\"38mm\" />	");
							printWrite2XML.println("		<fo:table-column width=\"66mm\" height=\"38mm\" />	");
							printWrite2XML.println("		<fo:table-body>	");
						}
						printWrite2XML.println("			<fo:table-row height=\"38mm\">	");
					}

					// only apply page break in between
					printWrite2XML.println("				<fo:table-cell ");
					if (ConstantsServerSide.DEBUG) {
						printWrite2XML.println("border-style=\"solid\" border-width=\"0.1pt\" ");
					}
					printWrite2XML.println("padding=\"2pt\" >	");
					if (labelFooter != null) {
						printWrite2XML.println("					<fo:block space-after.optimum=\"" + (defaultFontSize + 3) + "pt\">	</fo:block>	");
						printWrite2XML.println("					<fo:block space-after.optimum=\"" + (defaultFontSize + 1) + "pt\">" + clientName + "</fo:block>	");
						printWrite2XML.println("					<fo:block space-after.optimum=\"" + defaultFontSize + "pt\">" + (line[0]==null?ConstantsVariable.EMPTY_VALUE:line[0]) + "	</fo:block>	");
						printWrite2XML.println("					<fo:block space-after.optimum=\"" + defaultFontSize + "pt\">" + (line[1]==null?ConstantsVariable.EMPTY_VALUE:line[1]) + "	</fo:block>	");
						printWrite2XML.println("					<fo:block space-after.optimum=\"" + defaultFontSize + "pt\">" + (line[2]==null?ConstantsVariable.EMPTY_VALUE:line[2]) + "	</fo:block>	");
						printWrite2XML.println("					<fo:block space-after.optimum=\"" + defaultFontSize + "pt\">" + (line[3]==null?ConstantsVariable.EMPTY_VALUE:line[3]) + "	</fo:block>	");
						printWrite2XML.println("					<fo:block space-after.optimum=\"" + defaultFontSize + "pt\">" + (line[4]==null?ConstantsVariable.EMPTY_VALUE:line[4]) + "	</fo:block>	");
						printWrite2XML.println("					<fo:block space-after.optimum=\"" + defaultFontSize + "pt\" font-size=\"6pt\" text-align=\"center\">" + labelFooter + "	</fo:block>	");
						printWrite2XML.println("					<fo:block space-after.optimum=\"" + (defaultFontSize + 3) + "pt\">	</fo:block>	");
					} else {
						printWrite2XML.println("					<fo:block>	</fo:block>	");
						printWrite2XML.println("					<fo:block>	</fo:block>	");
						printWrite2XML.println("					<fo:block>	</fo:block>	");
						printWrite2XML.println("					<fo:block>	</fo:block>	");
						printWrite2XML.println("					<fo:block>	</fo:block>	");
						printWrite2XML.println("					<fo:block>	</fo:block>	");
						printWrite2XML.println("					<fo:block>	</fo:block>	");
						printWrite2XML.println("					<fo:block>	</fo:block>	");
						printWrite2XML.println("					<fo:block>	</fo:block>	");
						printWrite2XML.println("					<fo:block>	</fo:block>	");
						printWrite2XML.println("					<fo:block>	</fo:block>	");
					}
					printWrite2XML.println("				</fo:table-cell>	");
				}
			} else {
				printWrite2XML.println("		<fo:block font-size=\""+ defaultFontSize +"pt\" font-family=\"Courier\" >"+ "***There is no Record***" + "</fo:block>");
			}
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