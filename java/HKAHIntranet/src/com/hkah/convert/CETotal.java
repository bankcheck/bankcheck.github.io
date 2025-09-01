package com.hkah.convert;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.StringTokenizer;

import com.hkah.util.db.UtilDBWeb;
public class CETotal {


	public void convert() {

		File file = new File("C:\\ce_totals08_09.csv");
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		DataInputStream dis = null;

		int count_line = 0;
		int column = 0;
		String lineStr = null;
		StringTokenizer lineToken = null;

		int size=14;

		String ID=null;
		String siteCode=null;
		String dept=null;
		String position=null;
		String hiredDate=null;
		String posCode=null;
		String rate=null;
		String staffID = null;
		String cbYear=null;
		String cbHrs=null;
		String cbAmount=null;
		String blHrs=null;
		String blAmount= null;
		String remark=null;

		String[] result = new String[size];
	try {
			StringBuffer sqlStr = new StringBuffer();

			sqlStr.append("INSERT INTO CE_TOTAL (CE_TOTAL_ID, CE_SITE_CODE,CE_DEPT_DESC, ");
			sqlStr.append("CE_POSITION_DESC,CE_HIRE_DATE, CE_POSITION_CODE, CE_RATE,CE_STAFF_ID, ");
			sqlStr.append("CE_B_YEAR,CE_BY_HOURS, CE_BY_AMOUNT, CE_BL_HOURS, CE_BL_AMOUNT, CE_REMARK) ");
			sqlStr.append("VALUES (?,?,?,?,TO_DATE(?, 'dd/MM/YYYY'),?,?,?,TO_DATE(?, 'YYYY'),?,?,?,?,?)");
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
					lineToken = new StringTokenizer(lineStr, ",");
					column = 0;
					for (int i = 0; i < size; i++) {
						result[i] = "";
					}
						while (lineToken.hasMoreTokens() && column < size) {
						result[column++] = lineToken.nextToken();
					}
				}
				remark=null;
				ID=result[0];
				siteCode=result[1];
				dept=result[2];
				position=result[3];
				hiredDate=result[4];
				posCode=result[5];
				rate=result[6];
				staffID=result[7];
				cbYear=result[8];
				cbHrs=result[9];
				cbAmount=result[10];
				blHrs=result[11];
				blAmount=result[12];
				if(column>13) remark=result[13];

				//insert ce_total
				if ( count_line!=1 ){
					if(UtilDBWeb.updateQueue(
						sqlStr.toString(),
						new String[] { ID, siteCode, dept,position,hiredDate,posCode, rate,staffID,cbYear,cbHrs,cbAmount, blHrs,blAmount,remark} )) {
					} else {
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