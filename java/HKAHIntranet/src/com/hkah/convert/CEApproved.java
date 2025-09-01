package com.hkah.convert;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.StringTokenizer;

import com.hkah.util.db.UtilDBWeb;
public class CEApproved {


	public void convert() {

		File file = new File("C:\\ce_trans08_09.txt");
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		DataInputStream dis = null;

		int count_line = 0;
		int column = 0;
		String lineStr = null;
		StringTokenizer lineToken = null;
		int size=12;


		String transID=null;
		String siteCode=null;
		String approvedDate=null;
		String category=null;
		String deptName=null;
		String staffID = null;
		String amount= null;
		String hours=null;
		String actionNo=null;
		String attendingDate=null;
		String courseName=null;
		String hrRemark=null;
		String[] result = new String[size];


		try {
			StringBuffer sqlStr = new StringBuffer();

			sqlStr.append("INSERT INTO CE_APPROVED_TRANS (CE_APPROVED_TRANS_ID, CE_SITE_CODE,CE_APPROVED_DATE, ");
			sqlStr.append("CE_CATEGORY,CE_DEPT_NAME, CE_STAFF_ID, CE_AMOUNT,CE_HOURS,CE_ACTION_NO, ");
			sqlStr.append("CE_ATTENDING_DATE,CE_COURSE_NAME,CE_HR_REMARK ) ");
			sqlStr.append("VALUES (?,?,TO_DATE(?, 'dd/MM/YYYY'),?,?,?,?,?,?,?,?,?)");
			fis = new FileInputStream(file);

		// Here BufferedInputStream is added for fast reading.
			bis = new BufferedInputStream(fis);
			dis = new DataInputStream(bis);

			// dis.available() returns 0 if the file does not have more lines.
			while (dis.available() != 0) {
				count_line++;
				lineStr = dis.readLine();
				// this statement reads the line from the file and print it to
				// the console.
				if (count_line > 1) {
					lineToken = new StringTokenizer(lineStr, "|");
					column = 0;
					for (int i = 0; i < size; i++) {
						result[i] = "";
					}
						while (lineToken.hasMoreTokens() && column < size) {
						result[column++] = lineToken.nextToken();
					}
				}
				hrRemark=null;
				transID=result[0];
				siteCode=result[1];
				approvedDate=result[2];
				category=result[3];
				deptName=result[4];
				staffID=result[5];
				amount=result[6];
				hours=result[7];
				actionNo=result[8];
				attendingDate=result[9];
				courseName=result[10];
				if(column>11)hrRemark=result[11];

				//insert ce_approved_trans
				if ( count_line!=1 ){
					if(UtilDBWeb.updateQueue(
						sqlStr.toString(),
						new String[] { transID, siteCode, approvedDate,category,deptName, staffID, amount, hours, actionNo, attendingDate,courseName,hrRemark} )) {
					} else {
						for (int i=0; i< result.length; i++){
						}
					}

				}}

			// dispose all the resources after using them.
			fis.close();
			bis.close();
			dis.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}