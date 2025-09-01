<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.HashMap.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>

<%!
public class CourseDetails{
	String courseDESC;
	String courseSubDESC;
	String courseEventID;

	public CourseDetails(String courseDESC, String courseSubDESC, String courseEventID) {
		this.courseDESC = courseDESC;
		this.courseSubDESC = courseSubDESC;
		this.courseEventID = courseEventID;
	}
}

public class CourseEnlistedStaff{
	ArrayList<String> staffID = new ArrayList<String>();
	String courseDESC;
	String courseSubDESC;
	String courseEventID;

	public CourseEnlistedStaff(String courseDESC, String courseSubDESC, String courseEventID) {
		this.courseDESC = courseDESC;
		this.courseSubDESC = courseSubDESC;
		this.courseEventID = courseEventID;
	}
}

public static ArrayList getEnrolledCourseList(String courseEventID, String courseSubDESC, String staffID, String date_from, String date_to) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT EE.CO_USER_ID, EE.CO_EVENT_ID, EE.CO_SCHEDULE_ID, E.CO_EVENT_DESC, CS.CO_SCHEDULE_DESC, ");
	sqlStr.append("       TO_CHAR(EE.CO_ATTEND_DATE, 'dd/MM/yyyy'), E.CO_EVENT_CATEGORY, E.CO_EVENT_TYPE ");
	sqlStr.append("FROM   CO_EVENT E, CO_SCHEDULE CS, CO_ENROLLMENT EE ");
	sqlStr.append("WHERE  E.CO_SITE_CODE = EE.CO_SITE_CODE ");
	sqlStr.append("AND    E.CO_MODULE_CODE = EE.CO_MODULE_CODE ");
	sqlStr.append("AND    E.CO_EVENT_ID = EE.CO_EVENT_ID ");
	sqlStr.append("AND    EE.CO_SITE_CODE = CS.CO_SITE_CODE (+) ");
	sqlStr.append("AND    EE.CO_MODULE_CODE = CS.CO_MODULE_CODE (+) ");
	sqlStr.append("AND    EE.CO_EVENT_ID = CS.CO_EVENT_ID (+) ");
	sqlStr.append("AND    EE.CO_SCHEDULE_ID = CS.CO_SCHEDULE_ID (+) ");
	sqlStr.append("AND    EE.CO_MODULE_CODE = 'education' ");
	sqlStr.append("AND    EE.CO_USER_TYPE = 'staff' ");
	sqlStr.append("AND    EE.CO_ATTEND_STATUS = 1 ");
	sqlStr.append("AND    EE.CO_ENABLED = 1 ");
	sqlStr.append("AND    EE.CO_ATTEND_DATE >= TO_DATE('"+date_from+"', 'dd/mm/yyyy') ");
	sqlStr.append("AND    EE.CO_ATTEND_DATE < TO_DATE('"+date_to+"', 'dd/mm/yyyy') ");

	if (staffID != null && staffID.length() > 0 ) {
		sqlStr.append("AND    EE.CO_USER_ID = '"+staffID+"'  ");
	}
	if (courseEventID != null && courseEventID.length() > 0) {
		sqlStr.append("AND   EE.CO_EVENT_ID = '"+courseEventID+"' ");
	}
	if (courseSubDESC != null && courseSubDESC.length() > 0 ) {
		sqlStr.append("AND   CS.CO_SCHEDULE_DESC = '"+StringEscapeUtils.escapeSql(courseSubDESC)+"' ");
	}
	sqlStr.append("ORDER BY EE.CO_USER_ID ,CS.CO_SCHEDULE_ID DESC ");
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
String month_shortform[] = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };

UserBean userBean = new UserBean(request);

String deptCode = request.getParameter("deptCode");
String staffID = request.getParameter("staffID");
String eventID = request.getParameter("eventID");
String searchType = request.getParameter("searchType");
String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String financialYear = request.getParameter("financialYear");
String searchEnable = request.getParameter("searchEnable");
String courseList = request.getParameter("courseList");
String recordName = request.getParameter("recordName");

boolean isFinancialYear = false;

boolean showStaffDetail = true;

int courseSize = 0;
double cne = 0;
Map<String, String> cneMap = new HashMap<String, String>();

// set date range from financial year
String financialYearFrom = financialYear;
String financialYearTo = financialYear;

ArrayList<CourseDetails> listOfCourse = null;
ArrayList<CourseEnlistedStaff> listOfEnlistedStaff = null;
if ("financialYear".equals(searchType)) {
	try {
		financialYearFrom = String.valueOf(Integer.parseInt(financialYear) - 1);
	} catch (Exception e) {
	}
	date_from = "01/01/" + financialYearFrom;
	date_to = "01/01/" + financialYearTo;
	isFinancialYear = true;
}

// get data
try {
	int noOfUserInfoColumn = 5;
	if (ConstantsServerSide.isTWAH()) {
	  noOfUserInfoColumn +=3;
	}
	ArrayList record = StaffDB.getEducationList(userBean, deptCode, searchEnable, staffID);
	ArrayList record2 = null;
	ArrayList record_real = new ArrayList();
	ReportableListObject row = null;
	ReportableListObject row2 = null;
	ReportableListObject row_real = null;
	boolean isUpdated = false;

	String annualIncr = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			// copy to new reportable list object
			row_real = new ReportableListObject(courseSize + noOfUserInfoColumn);
			for (int j = 0; j < noOfUserInfoColumn; j++) {
				row_real.setValue(j, row.getValue(j + 1));
			}

			// initial value
			for (int j = noOfUserInfoColumn; j < courseSize + noOfUserInfoColumn; j++) {
				row_real.setValue(j, ConstantsVariable.EMPTY_VALUE);
			}

			// special handle for financial year
			if (isFinancialYear) {
				annualIncr = row.getValue(5);
				date_from = "01/" + annualIncr + "/" + financialYearFrom;
				date_to = "01/" + annualIncr + "/" + financialYearTo;
				date_to = DateTimeUtil.getRollDate(date_to, -1, 0, 0);
			}

			// append other value
			if ("CNE".equals(courseList)){
				record2 = EnrollmentDB.getAttendedClass("education", null, courseList, "staff", row.getValue(2), date_from, date_to);
				if(record2.size() > 0){
					for (int j = 0; j < record2.size(); j++) {
						row2 = (ReportableListObject) record2.get(j);
						if(Double.parseDouble(row2.getValue(14))>=1){
							cne += Double.parseDouble(row2.getValue(14));
						}
					}
				}
			}
			cneMap.put(row.getValue(2), Double.toString(cne));
			cne = 0;
			record_real.add(row_real);
		} 
	}
	request.setAttribute("record_list", record_real);

	listOfCourse = new ArrayList<CourseDetails>();
	ArrayList courseRecord;
	ArrayList onlineinservCourseRecord = null;


	onlineinservCourseRecord = EventDB.getList("education",null,null,"inservice","online");
	if (courseList.equals("all")) {
		if(eventID!=null || !"".equals(eventID)){
			courseRecord = ScheduleDB.getListByDateAndDisplayTest("education",eventID, recordName, "compulsory" , null,"class", date_from, date_to, true, false);	    	   
	    }else{
			courseRecord = ScheduleDB.getListByDateAndDisplayTest("education", recordName, null, "compulsory" ,"class", date_from, date_to, true, true);	    	   
	    }
	} else {
		courseRecord = ScheduleDB.getListByDateAndDisplayTest("education", recordName, courseList, null,"class", date_from, date_to, true, false);
	}
	
	if (courseRecord.size() > 0) {
		for(int i = 0;i<courseRecord.size();i++) {
			ReportableListObject courseRow =  (ReportableListObject)courseRecord.get(i) ;
			CourseDetails tempCourse = new CourseDetails(courseRow.getValue(3),courseRow.getValue(4),courseRow.getValue(2));

			boolean courseExists = false;
			for(CourseDetails c : listOfCourse) {
				if (tempCourse.courseDESC.equals(c.courseDESC) && tempCourse.courseSubDESC.equals(c.courseSubDESC)) {
					courseExists = true;
				}
			}

			if (courseExists == false) {
				listOfCourse.add(tempCourse);
			}
		}
	}
	
	if(onlineinservCourseRecord.size() > 0 && "inservice".equals(courseList)){
		for(int i = 0;i<onlineinservCourseRecord.size();i++) {
			ReportableListObject insvcourseRow =  (ReportableListObject)onlineinservCourseRecord.get(i) ;
			CourseDetails tempCourse = new CourseDetails(insvcourseRow.getValue(1),"",insvcourseRow.getValue(0));

				listOfCourse.add(tempCourse);
		}
	}

	listOfEnlistedStaff = new ArrayList<CourseEnlistedStaff>();
	for(CourseDetails c : listOfCourse) {
		int j = 0;
		ArrayList class_enrollment = getEnrolledCourseList(c.courseEventID,c.courseSubDESC,null,date_from,date_to);
		if (class_enrollment != null && class_enrollment.size() > 0) {
			CourseEnlistedStaff tempEnlistedStaff = null;
			for(int i = 0;i<class_enrollment.size();i++) {
				ReportableListObject classRow =  (ReportableListObject)class_enrollment.get(i) ;

				if (j == 0) {
					 tempEnlistedStaff = new CourseEnlistedStaff(classRow.getValue(3),classRow.getValue(4),classRow.getValue(1));
					tempEnlistedStaff.staffID.add(classRow.getValue(0));
					j++;
				} else {
					tempEnlistedStaff.staffID.add(classRow.getValue(0));
				}
			}
			listOfEnlistedStaff.add(tempEnlistedStaff);
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>

<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<jsp:include page="../common/header.jsp"/>

<bean:define id="functionLabel"><bean:message key="function.staff.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<div id="tbl-container" style="height: 680px">
<%
String style = null;
if (ConstantsServerSide.isTWAH()) {
	style = "dataTable";
} else {
	style = "dataTable";
}%>
<display:table id="row" name="requestScope.record_list" export="true" class="<%=style%>" >
	<display:column headerClass="locked" class="locked" title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column headerClass="locked" class="locked" property="fields0" titleKey="prompt.department" />
	<display:column headerClass="locked" class="locked" property="fields1" titleKey="prompt.staffID" />
	<display:column headerClass="locked" class="locked" titleKey="prompt.name" media="html">
<%	if (showStaffDetail) { %>
			<button onclick="return showStaff('<c:out value="${row.fields1}" />');"><c:out value="${row.fields2}" /></button>
<%	} else { %>
			<c:out value="${row.fields2}" />
<%	} %>
	</display:column>
	<display:column titleKey="prompt.name" media="csv excel xml pdf">
		<c:out value="${row.fields2}" />
	</display:column>
<%if (ConstantsServerSide.isTWAH()) {
	if ("21033".equals(userBean.getLoginID())) {%>
	<display:column titleKey="prompt.positionCode">
	<c:out value="${row.fields5}" />
	</display:column>
	<%} %>
	<display:column titleKey="prompt.positionDesc">
	<c:out value="${row.fields6}" />
		</display:column>
<%} %>

<%if (ConstantsServerSide.isTWAH()) { %>
	<display:column titleKey="prompt.empdate">
	<%if (ConstantsServerSide.isTWAH()) { %>
		<c:out value="${row.fields7}" />
	<%} else {%>
		<%=month_shortform[Integer.parseInt(((ReportableListObject)pageContext.getAttribute("row")).getValue(4)) - 1] %>
	<%} %>
	</display:column>
	<%} %>
<%	
	if ("CNE".equals(courseList)) { %>
		<display:column title="CNE Points">
			<%=cneMap.get((((ReportableListObject)pageContext.getAttribute("row")).getValue(1))) %>
		</display:column>	
<%	} 

for(CourseDetails c : listOfCourse) {
	String courseName = c.courseDESC + "\n" +  (c.courseSubDESC.length() > 0?"("+ c.courseSubDESC +")":"");
%>
			<display:column title="<%=courseName %>" media="html csv excel xml pdf" class="flow_online">
			 <c:set var="courseStaffID" value="${row.fields1}"/>

<%
	String courseStaffID = (String)pageContext.getAttribute("courseStaffID");

	outerloop:
	for(CourseEnlistedStaff cs : listOfEnlistedStaff) {
		if (cs.courseEventID.equals(c.courseEventID) && cs.courseSubDESC.equals(c.courseSubDESC)) {
			for(String s : cs.staffID) {
				if (courseStaffID.equals(s)) {
					ArrayList class_enrollment = getEnrolledCourseList(cs.courseEventID,cs.courseSubDESC,s,date_from,date_to);
					String courseTime = "";
					if (class_enrollment.size() > 0) {
						ReportableListObject classRow =  (ReportableListObject)class_enrollment.get(0) ;
						courseTime = classRow.getValue(5) ;

					} else {
						courseTime = "";
					}
%>
					<c:out value="<%=courseTime%>" />
<%
				break outerloop;
				}
			}
		}
	}
%>
			</display:column>
<%
}
%>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</div>