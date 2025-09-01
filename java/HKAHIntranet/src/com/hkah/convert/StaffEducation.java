package com.hkah.convert;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.Vector;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EnrollmentDB;
import com.hkah.web.db.EventDB;
import com.hkah.web.db.Location;
import com.hkah.web.db.ScheduleDB;
import com.hkah.web.db.UserDB;

import au.com.bytecode.opencsv.CSVReader;

public class StaffEducation {

        private static HashMap monthHashMap = new HashMap();

        static {
                monthHashMap.put("Jan", "01");
                monthHashMap.put("Feb", "02");
                monthHashMap.put("Mar", "03");
                monthHashMap.put("Apr", "04");
                monthHashMap.put("May", "05");
                monthHashMap.put("Jun", "06");
                monthHashMap.put("Jul", "07");
                monthHashMap.put("Aug", "08");
                monthHashMap.put("Sep", "09");
                monthHashMap.put("Oct", "10");
                monthHashMap.put("Nov", "11");
                monthHashMap.put("Dec", "12");
        }

        public static void createUser() {
                File file = new File("C:\\Namelist for Mandatory Classes.csv");
                FileInputStream fis = null;
                BufferedInputStream bis = null;
                DataInputStream dis = null;

                int count_line = 0;
                int column = 0;
                String lineStr = null;
                StringTokenizer nextLine = null;
                int index = 0;

                String userName = null;
                String password = PasswordUtil.cisEncryption(UserDB.PASSWORD_DEFAULT);
                String staffID = null;
                String firstName = null;
                String lastName = null;
                String[] result = new String[17];

                try {
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
                                        nextLine = new StringTokenizer(lineStr, ",");
                                        column = 0;
                                        for (int i = 0; i < 17; i++) {
                                                result[i] = "";
                                        }
                                        while (nextLine.hasMoreTokens() && column < 17) {
                                                result[column++] = nextLine.nextToken();
                                        }
                                        staffID = result[1];
                                        firstName = result[3];
                                        lastName = result[2];
                                userName = firstName.trim().toLowerCase() + "." + lastName.trim().toLowerCase();
                                        // remove space inbetween username
                                        while ((index = userName.indexOf(" ")) >= 0) {
                                                userName = userName.substring(0, index) + userName.substring(index + 1);
                                        }

                                        if (!UtilDBWeb.updateQueue(
                                                        "INSERT INTO CO_USERS (CO_SITE_CODE, CO_USERNAME, CO_PASSWORD, " +
                                                        "                      CO_LASTNAME, CO_FIRSTNAME, CO_STAFF_YN, " +
                                                        "                      CO_STAFF_ID, CO_GROUP_ID) " +
                                                        "VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, 'Y', ?, 'staff')",
                                                        new String[] { userName, password, lastName, firstName, staffID } )) {
                                                System.err.println("[" + count_line + "] create user [" + userName + "] fail");
                                        }
                                }
                        }

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

        public static void mandatory(String fileName, String year, boolean testOnly) {
                helper(fileName, "compulsory", "class", year, testOnly);
        }

        public static void inservice(String fileName, String year, boolean testOnly) {
                helper(fileName, "inservice", "class", year, testOnly);
        }

        private static void helper(String fileName, String eventCategory, String eventType, String year, boolean testOnly) {
                int count_line = 0;
                String lineStr = null;
                String[] nextLine = null;
                int userInfoColumnCount = 6;
                int courseColumnCount = 0;
                int index = 0;

                String[] courseID = null;

                String currentCourseName = null;
                String currentCourseID = null;
                String staffID = null;
                String attendDate = null;
                String newAttendDate = null;

                try {
                        CSVReader reader = new CSVReader(new FileReader(fileName));

                        // dis.available() returns 0 if the file does not have more lines.
                        while ((nextLine = reader.readNext()) != null) {
                                count_line++;

                                if (count_line == 1) {
                                        Vector courseIDVector = new Vector();
                                        for (int i = userInfoColumnCount; i < nextLine.length && nextLine[i].length() > 0; i++) {
                                                currentCourseName = nextLine[i].trim();
                                                if ("Share (1hr)".equals(currentCourseName)) {
                                                        currentCourseID = "1010";
                                                } else if ("Standard Precaution".equals(currentCourseName)) {
                                                        currentCourseID = "1020";
                                                } else if ("Manual Handling".equals(currentCourseName)) {
                                                        currentCourseID = "1030";
                                                } else if ("Fire Safety/Disaster".equals(currentCourseName)) {
                                                        currentCourseID = "1040";
                                                } else if ("CPR (Layman)".equals(currentCourseName)) {
                                                        currentCourseID = "1060";
                                                } else if ("ACHS Training Session".equals(currentCourseName)) {
                                                        currentCourseID = "6212";
                                                } else {
                                                        currentCourseID = EventDB.getEventID("education", currentCourseName);
                                                }
                                                if (currentCourseID == null) {
                                                        System.err.println("create course:[" + currentCourseName + "]");
                                                        currentCourseID = EventDB.add("education", null, eventCategory, eventType, currentCourseName, null, "SYSTEM");
                                                }
                                                courseIDVector.add(currentCourseID);
                                        }

                                        courseColumnCount = courseIDVector.size();
                                        courseID = (String []) courseIDVector.toArray(new String[courseColumnCount]);
                                } else if (count_line > 1 && nextLine.length > 2) {
                                        staffID = nextLine[1];
                                        for (int i = userInfoColumnCount; i < nextLine.length && i < userInfoColumnCount + courseColumnCount; i++) {
                                                currentCourseID = courseID[i - userInfoColumnCount];
                                                attendDate = nextLine[i].trim();
                                                if (attendDate.length() > 0) {
                                                        // may contain multidate
                                                        while ((index = attendDate.lastIndexOf(",")) > 0) {
                                                                newAttendDate = attendDate.substring(0, index).trim();
                                                                createEnrollmentHelper(count_line, i, currentCourseID, staffID, newAttendDate, year, testOnly);
                                                                attendDate = attendDate.substring(index + 1).trim();
                                                        }
                                                        while ((index = attendDate.lastIndexOf(";")) > 0) {
                                                                newAttendDate = attendDate.substring(0, index).trim();
                                                                createEnrollmentHelper(count_line, i, currentCourseID, staffID, newAttendDate, year, testOnly);
                                                                attendDate = attendDate.substring(index + 1).trim();
                                                        }
                                                        createEnrollmentHelper(count_line, i, currentCourseID, staffID, attendDate, year, testOnly);
                                                }
                                        }
                                }
                        }
                } catch (Exception e) {
                        e.printStackTrace();
                        System.err.println("error line2:[" + lineStr + "]");
                }
        }

        private static void createEnrollmentHelper(int row, int column, String courseID, String staffID, String attendDate, String year, boolean testOnly) {
                if (attendDate != null && attendDate.length() >= 5) {
                        // add zero in the front if the day is less than 10
                        if (attendDate.length() == 5) attendDate = "0" + attendDate;
                        attendDate = attendDate.substring(0, 2) + "/" + ((String) monthHashMap.get(attendDate.substring(3, 6))) + "/" + year;

                        if (!EnrollmentDB.isExist("education", courseID, "staff", staffID, attendDate)) {
                                if (!testOnly) {
                                        if (EnrollmentDB.updateAttendStatus("education", courseID, "staff", staffID, attendDate, "SYSTEM")) {
                                                System.out.println("[" + row + ":" + column + "] update enroll [" + courseID + "][" + staffID + "][" + attendDate + "] ok");
                                        } else if (EnrollmentDB.add("education", courseID, null, "staff", staffID, ConstantsVariable.ONE_VALUE, attendDate, null, "SYSTEM", null) != null) {
                                                System.out.println("[" + row + ":" + column + "] create enroll [" + courseID + "][" + staffID + "][" + attendDate + "] ok");
                                        } else {
                                                System.err.println("[" + row + ":" + column + "] create enroll [" + courseID + "][" + staffID + "][" + attendDate + "] fail");
                                        }
                                }
                        } else {
//                              System.err.println("[" + row + ":" + column + "] create enroll [" + courseID + "][" + staffID + "][" + attendDate + "] fail due to already existed");
                        }
                } else if (!"E".equals(attendDate) && !"C".equals(attendDate)) {
                        System.err.println("[" + row + ":" + column + "] create enroll [" + courseID + "][" + staffID + "][" + attendDate + "] fail due to too short");
                }
        }

        public static void calendar(String fileName, boolean testOnly) {
                int count_line = 0;
                String lineStr = null;
                String[] nextLine = null;

                HashMap allCourse = new HashMap();
                HashMap allLocation = new HashMap();

                String scheduleID = null;
                String calendarDate = null;
                String currentCourseID = null;
                String currentCourseName = null;
                String details = null;
                String lecturer = null;
                String locationID = null;
                String locationDesc = null;
                String startTime = null;
                Date startTimeDate = null;
                String endTime = null;
                Date endTimeDate = null;
                double duration = 0;
                String classSize = null;
                int classSizeInt = 0;
                String remark = null;

                try {
                        CSVReader reader = new CSVReader(new FileReader(fileName));

                        // dis.available() returns 0 if the file does not have more lines.
                        while ((nextLine = reader.readNext()) != null) {
                                count_line++;

                                if (count_line == 1) {
                                        ArrayList result = EventDB.getList("education", null, null, null, null);
                                        ReportableListObject rlo = null;
                                        if (result.size() > 0) {
                                                for (int i = 0; i < result.size(); i++) {
                                                        rlo = (ReportableListObject) result.get(i);
                                                        allCourse.put(rlo.getFields1().toUpperCase(), rlo.getFields0());
                                                }
                                        }
                                        result = Location.getList();
                                        if (result.size() > 0) {
                                                for (int i = 0; i < result.size(); i++) {
                                                        rlo = (ReportableListObject) result.get(i);
                                                        allLocation.put(rlo.getFields1().toUpperCase(), rlo.getFields0());
                                                }
                                        }
                                } else if (count_line > 1) {
                                        calendarDate = (nextLine[2].length()<2?"0":"") + nextLine[2] + "/" + (nextLine[1].length()<2?"0":"") + nextLine[1] + "/" + nextLine[0];
                                        currentCourseName = nextLine[3];
                                        currentCourseID = (String) allCourse.get(currentCourseName.toUpperCase());
                                        details = nextLine.length >= 5 ? nextLine[4] : null;
                                        lecturer = nextLine.length >= 6 ? nextLine[5] : null;
                                        locationID = null;
                                        locationDesc = nextLine.length >= 7 ? nextLine[6] : null;
                                        if (allLocation.containsKey(locationDesc)) {
                                                locationID = (String) allLocation.get(locationDesc);
                                                locationDesc = null;
                                        }

                                        startTime = nextLine.length >= 8 ? nextLine[7] : null;
                                        endTime = nextLine.length >= 9 ? nextLine[8] : null;
                                        if (startTime != null && startTime.length() >= 5) {
                                                startTimeDate = DateTimeUtil.parseDateTime(calendarDate + " " +  startTime + ":00");
                                        } else {
                                                startTimeDate = DateTimeUtil.parseDateTime(calendarDate + " 00:00:00");
                                        }
                                        startTime = DateTimeUtil.formatDateTime(startTimeDate);
                                        if (endTime != null && endTime.length() >= 5) {
                                                endTimeDate = DateTimeUtil.parseDateTime(calendarDate + " " +  endTime + ":00");
                                                endTime = DateTimeUtil.formatDateTime(endTimeDate);
                                        } else {
                                                endTime = null;
                                        }
                                        duration = 0;
                                        if (startTimeDate != null && endTimeDate != null && startTimeDate.getTime() != endTimeDate.getTime()) {
                                                duration = (endTimeDate.getTime() - startTimeDate.getTime()) / 1000;
                                                // divided by one hour
                                                duration /= 3600;
                                        }
                                        classSize = nextLine.length >= 10 ? nextLine[9] : null;
                                        try {
                                                classSizeInt = Integer.parseInt(classSize);
                                        } catch (Exception e) {
                                                classSizeInt = 0;
                                        }
                                        remark = nextLine.length >= 11 ? nextLine[10] : null;

                                        // create course if not exist
                                        if (currentCourseID == null) {
                                                System.err.println("create course:[" + currentCourseName + "]");
                                                if (!testOnly) {
                                                        currentCourseID = EventDB.add("education", null, classSizeInt>0?"inservice":"other", "class", currentCourseName, remark, "SYSTEM");
                                                }
                                                allCourse.put(currentCourseName.toUpperCase(), currentCourseID);
                                        }
                                        scheduleID = ScheduleDB.getScheduleIDByDateTime("education", currentCourseID,
                                                        startTime, endTime);
                                        if (!testOnly && (scheduleID == null || scheduleID.length() == 0)) {
                                                scheduleID = ScheduleDB.add("education", currentCourseID, details,
                                                                startTime, endTime,
                                                                String.valueOf(duration), locationID, locationDesc, lecturer,
                                                                String.valueOf(classSizeInt), "open", "SYSTEM");
                                                System.err.println("create schedule[" + currentCourseID + "][" + scheduleID + "]");
                                        }
                                }
                        }
                } catch (Exception e) {
                        e.printStackTrace();
                        System.err.println("error line2:[" + lineStr + "]");
                }
        }
}