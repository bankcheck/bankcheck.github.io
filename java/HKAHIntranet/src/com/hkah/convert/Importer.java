package com.hkah.convert;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.StringTokenizer;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

public class Importer {

	public String fetchValue(String sqlStr,String fetchItem) {
		// fetch course
		String str=null;		
		sqlStr=sqlStr+"=lower('"+fetchItem+"') ";
		ArrayList record = UtilDBWeb.getReportableList(sqlStr);
		ReportableListObject row = null;
		if (record.size() > 0) {
			row =(ReportableListObject) record.get(0);
			str=row.getFields0();			 
		}
		return str;
	}
	
	String sql_courseID="SELECT EE_COURSE_ID FROM EE_COURSE WHERE LOWER(EE_COURSE_DESC)";
	//String sql_locationID="SELECT LOCATION_ID FROM CO_LOCATION WHERE LOWER(EE_DESCRIPTION)";
	
	public void convert() {

		File file = new File("C:\\ec.csv");
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		DataInputStream dis = null;

		int count_line = 0;
		int column = 0;
		String lineStr = null;
		StringTokenizer lineToken = null;
		StringTokenizer wordToken=null;
		int index = 0;
		int size=13;
		
	

		String courseID = null;
		String[] result = new String[size];
		String courseDesc= null;
		String courseDetail=null;
		String CourseCategory=null;
		String courseTye=null;
		String lectureName=null;
		String classID="12";
		try {
			StringBuffer sqlStr = new StringBuffer();
			
			sqlStr.append("INSERT INTO CO_SCHEDULE (CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID,  ");
			sqlStr.append("           CO_SCHEDULE_ID, CO_SCHEDULE_START, CO_SCHEDULE_END, "); 
			sqlStr.append("		      CO_SCHEDULE_DURATION, CO_SCHEDULE_SIZE,");
			sqlStr.append("			  CO_LOCATION_DESC, CO_LECTURE_DESC) ");
			sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', 'education' , ?, ?, TO_DATE(?,'dd/mm/yyyy HH24:MI:SS'),");  
			sqlStr.append("         TO_DATE(?,'dd/mm/yyyy HH24:MI:SS'), ?, ?, ?, ?)");
			fis = new FileInputStream(file);

		// Here BufferedInputStream is added for fast reading.
			bis = new BufferedInputStream(fis);
			dis = new DataInputStream(bis);

			// dis.available() returns 0 if the file does not have more lines.
			while (dis.available() != 0) {
				boolean foundCourseID=true;
				boolean foundLocationID=true;
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
					System.err.println("line # "+count_line);
					
					while (lineToken.hasMoreTokens() && column < size) {
						result[column] = lineToken.nextToken();
//						if(column==3){
							
							//To check [course description] whether exist or not in ee_course table						
//						if (UtilDBWeb.isExist("select 1 from ee_course where lower(ee_course_desc)=lower(?)",
//									new String[] { result[3] })) {
//								System.err.println(result[3]+" is existed!");
//								
//								courseID=fetchValue(sql_courseID,result[3]); 
//								//locationID=fetchValue(sql_locationID,result[6]); 
//								System.err.println("courseID is "+courseID);
//							
//								//XXXXXX get ee.course_id
						//		CourseID="unkown";
								//XXx classId = max(classID)+1 where courseID=result[3])
								//							if(true){
//							} else {
//							//to create new course
//								foundCourseID=false;
//								courseID="1";
//								System.err.println(result[3]+" isnot existed!");
//							}										
//						}										
						System.err.println("*** column"+column+" "+result[column]);
						column++;
					}
				}
				courseID=result[3];
				courseDesc=result[3];
				courseDetail=result[4];			
				lectureName=result[5];
				String locationID=result[6]; 	
				String classStart=result[2]+"/"+result[1]+"/"+result[0]+" "+result[7]+":00";
				String   classEnd=result[2]+"/"+result[1]+"/"+result[0]+" "+result[8]+":00";	
				String duration=result[9];  
				String scheduleRemark=result[10];
				String course_Category=result[11];
				String courseType=result[12];
				String classSize="10";
				
				//	insert course
				StringBuffer sqlStr2=null;
//				if(!foundCourseID){
//					sqlStr2 = new StringBuffer();
//						sqlStr.append("INSERT INTO EE_COURSE (EE_SITE_CODE, EE_COURSE_ID, EE_DEPARTMENT_CODE, EE_COURSE_DESC,  "); 
//						sqlStr.append("		       EE_COURSE_DETAIL, EE_COURSE_CATEGORY, EE_COURSE_TYPE) ");
//						sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "',SELECT MAX(EE_COURSE_ID) + 1 FROM EE_COURSE, NULL,?, ?, ?, ?)");
//						System.err.println(sqlStr2); 
//						if (UtilDBWeb.updateQueue(
//								sqlStr2.toString(),
//								new String[] {courseDesc, courseDetail, CourseCategory, courseTye} )) {
//							System.err.println("Course ["+courseDesc+"]created.");
//						} else {
//							System.err.println("Course ["+courseDesc+"]create fail.");
//						}
//				}					
				
				//insert class_schedule		
				if ( count_line!=1){
					System.err.println(">>inside line_count is "+count_line);
					if(UtilDBWeb.updateQueue(
						sqlStr.toString(),
						new String[] { courseID, classID, classStart,classEnd, duration, locationID, lectureName, classSize} )) {
						System.err.println("[" + count_line + "] create CLASS_SCHEDULE +[" + result + "] ok");
					} else {
						System.err.println("[" + count_line + "] [create CLASS_SCHEDULE]  fail");
						for (int i=0; i< result.length; i++){
							System.err.println("["+i+ "] "+ result[i]); 						
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