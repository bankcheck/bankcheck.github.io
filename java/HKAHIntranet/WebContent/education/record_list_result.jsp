<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.HashMap.*" %>
<%
String month_shortform[] = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };

UserBean userBean = new UserBean(request);
String deptCode = request.getParameter("deptCode");
String staffID = request.getParameter("staffID");
String courseCategory = request.getParameter("courseCategory");
// set default course category to [C]ompulsory
if (courseCategory == null) {
	courseCategory = "compulsory";
}
String searchType = request.getParameter("searchType");
String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String financialYear = request.getParameter("financialYear");
String searchEnable = request.getParameter("searchEnable");
boolean isFinancialYear = false;
boolean isContinuous = "ce".equals(courseCategory);
boolean showStaffDetail = true;

// get column list
Vector courseIDVector = new Vector();
Vector courseDescVector = new Vector();
Vector courseTypeVector = new Vector();
int courseSize = 0;
double cne = 0;
Map<String, String> cneMap = new HashMap<String, String>();


// set date range from financial year
String financialYearFrom = financialYear;
String financialYearTo = financialYear;
if ("financialYear".equals(searchType)) {
	try {
		financialYearFrom = String.valueOf(Integer.parseInt(financialYear) - 1);
	} catch (Exception e) {
	}
	date_from = "01/01/" + financialYearFrom;
	date_to = "01/01/" + financialYearTo;
	isFinancialYear = true;
}

try {
	ReportableListObject row = null;
	String courseDesc = null;
	String courseType = null;
	String requireAssessmentPass = null;

	// get all course list
	ArrayList record = EventDB.getEducationRecord(courseCategory, date_from, date_to);
	courseSize = record.size();
	if (courseSize > 0) {
		for (int i = 0; i < courseSize; i++) {
			row = (ReportableListObject) record.get(i);
			courseIDVector.add(row.getValue(0));
			courseDesc = row.getValue(2);
			if (courseDesc == null || courseDesc.length() == 0) {
				courseDesc = row.getValue(1);
			}
			courseDescVector.add(courseDesc);
			courseTypeVector.add(row.getValue(4));
		}
	}

	if (!"other".equals(courseCategory) && !"tND".equals(courseCategory) && !"JCI".equals(courseCategory)){
		if (ConstantsServerSide.isHKAH()) {
			courseIDVector.add("6307");
			courseDescVector.add("ivtherapy");
			courseTypeVector.add("online");
			courseSize+=1;
		}
	}

	request.setAttribute("columnNames", courseIDVector);
} catch (Exception e) {
	e.printStackTrace();
}

// get data
ArrayList record_real = new ArrayList();
try {
	int noOfUserInfoColumn = 7;
	if (ConstantsServerSide.isTWAH()) {
	  	noOfUserInfoColumn +=1;
	}
	ArrayList record = StaffDB.getEducationList(userBean, deptCode, searchEnable, staffID);
	ArrayList record2 = null;
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
			record2 = EnrollmentDB.getAttendedClass("education", null, ("CNE".equals(courseCategory)?courseCategory:null), "staff", row.getValue(2), date_from, date_to);
			if (record2.size() > 0) {
				for (int j = 0; j < record2.size(); j++) {
					row2 = (ReportableListObject) record2.get(j);
					isUpdated = false;
					for (int k = 0; !isUpdated && k < courseSize; k++) {
						if (courseIDVector != null && courseIDVector.size() > k &&
								courseIDVector.get(k) != null &&
								courseIDVector.get(k).equals(row2.getValue(1))) {
							if(EventDB.isOutsideCourse(row2.getValue(1))){					
								row_real.setValue( noOfUserInfoColumn + k, row2.getValue(12) + (row2.getValue(13).length() > 0 ? "</br>(" + row2.getValue(13) + ")" : ""));
							} else {
								row_real.setValue( noOfUserInfoColumn + k, row2.getValue(12));
							}
							isUpdated = true;
							if ("CNE".equals(courseCategory)){
								if(Double.parseDouble(row2.getValue(14))>=1){
									cne += Double.parseDouble(row2.getValue(14));
								}
							}
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
<div id="tbl-container" style="height: 380px">
<%
String style = null;
if (ConstantsServerSide.isTWAH()) {
	style = "dataTable";
} else {
	style = "dataTable";
}
%>
<% if (record_real.isEmpty()) { %>
No record found.
<% } else { %>
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
<%	if (ConstantsServerSide.isTWAH()) {
		if ("21033".equals(userBean.getLoginID())) {%>
	<display:column titleKey="prompt.positionCode">
		<c:out value="${row.fields5}" />
	</display:column>
<%		} %>
<%	} %>
	<display:column titleKey="prompt.positionDesc">
		<c:out value="${row.fields6}" />
	</display:column>
	<display:column property="fields3" titleKey="prompt.status"/>
<%	if (!ConstantsServerSide.isTWAH()) {%>	
	<display:column title="Category">
	 	<%=StaffDB.getEduCategory(((ReportableListObject)pageContext.getAttribute("row")).getValue(1)) %>
	</display:column>
	<display:column titleKey="prompt.empdate">
		<%=((ReportableListObject)pageContext.getAttribute("row")).getValue(5) %>
	</display:column>
<%	}else{ %>	
	<display:column titleKey="prompt.empdate">
		<%=((ReportableListObject)pageContext.getAttribute("row")).getValue(7) %>
	</display:column>
<%	} %>

<%
	if (ConstantsServerSide.isTWAH() && !"JCI".equals(courseCategory)) {
		Calendar getYear = Calendar.getInstance();
		getYear.setTime(DateTimeUtil.parseDate(date_from));
		String searchYear = Integer.toString(getYear.get(Calendar.YEAR));

		Boolean checkCompletion = false;
		checkCompletion = EnrollmentDB.checkCompletion((((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), searchYear);
		String completionTitle = MessageResources.getMessage(session, "prompt.completion", searchYear);
		%><display:column title="<%=completionTitle %>" style="width:10%"><%
		if ("compulsory".equals(courseCategory)) {
			if ("FTW".equals(((ReportableListObject)pageContext.getAttribute("row")).getValue(3)) || "PTW".equals(((ReportableListObject)pageContext.getAttribute("row")).getValue(3))
					|| "FT".equals(((ReportableListObject)pageContext.getAttribute("row")).getValue(3)) || "PT".equals(((ReportableListObject)pageContext.getAttribute("row")).getValue(3))) {
				if (checkCompletion) {
					%>Completed<%
				} else {
					%>Incomplete <%
				}
			}
		} else {
			%>N/A<%
		}
		%></display:column>
<%	}
	if ("CNE".equals(courseCategory)) { %>
	<display:column title="CNE Points">
				<%=cneMap.get((((ReportableListObject)pageContext.getAttribute("row")).getValue(1))) %>
	</display:column>	
<%	} 

	String courseNameOrgDesc = null;
	String courseName = null;
	String courseNameDesc = null;
	String className = null;
	Boolean checkSitinExist = false;
	String remark = null;
	ArrayList recordTemp = null;

	HashMap<String, String> courseIDMap = new HashMap<String,String>();
		  courseIDMap.put("prompt.shareReview","6015");
		  courseIDMap.put("prompt.infectionControlNormal","6016");
		  courseIDMap.put("prompt.infectionControlAncillary","6017");
		  courseIDMap.put("prompt.manualHandlingNursing","6018");
		  courseIDMap.put("prompt.manualHandlingClinical","6019");
		  courseIDMap.put("prompt.medicalGasSafetyNursing","6020");
%>
	<c:forEach var="column" varStatus="status" items="${requestScope.columnNames}">
		<bean:define id="statusCount"><c:out value="${status.count}"/></bean:define>
<%
		courseNameOrgDesc = (String) courseDescVector.get(Integer.parseInt(statusCount) - 1);
		courseName = (("prompt." + courseNameOrgDesc).replace(" ","")).trim();
		courseName = ((courseName.replace("(","")).replace("/","")).replace(")", "");
		courseNameDesc = MessageResources.getMessage(session, courseName);
		if (courseNameDesc.equals(courseName)) {
			courseNameDesc = courseNameOrgDesc;
		}

		className = "flow_"+(String)courseTypeVector.get(Integer.parseInt(statusCount) - 1);

		checkSitinExist = false;
%>
		<display:column title="<%=courseNameDesc %>" media="html" class="<%=className%>">
			<bean:define id="classStyle" value="title"/>

<%
		if (ConstantsServerSide.isTWAH()) {
			remark = EnrollmentDB.getenrollRemark(courseIDVector.get(Integer.parseInt(statusCount) - 1).toString(), (((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), date_from,date_to);
			if("6238".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))||"6730".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))){ 	
				String startdate = date_from.split("/")[0] + "/" + date_from.split("/")[1] + "/" +Integer.toString(Integer.parseInt(date_from.split("/")[2])-2);
				recordTemp = EnrollmentDB.getExpireDate("education", courseIDVector.get(Integer.parseInt(statusCount) - 1).toString(), (((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), startdate, date_to);
				if (recordTemp.size() > 0) {
					ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
					if("EXPIRED".equals(rowTemp.getValue(12))){%>
						<b style="color:red">EXPIRED<br/>(<%=rowTemp.getValue(7) %>)</b>
<% 					}else{%>
						<%=rowTemp.getValue(13) %><br/>(<%=rowTemp.getValue(7) %>)
<% 					}
				}
			}else{
%>
				<%=((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 7) %>
<%				
			}
			if ((!"".equals(((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 7)))) {
				checkSitinExist = true;
			}
			if ("Exemption".equals(remark)) {
				%>(E)<a href="javascript:void(0);"  onclick="return cancelExemption('<%=courseIDVector.get(Integer.parseInt(statusCount) - 1) %>', '<%=(((ReportableListObject)pageContext.getAttribute("row")).getValue(1)) %>');return false;"><img src="<html:rewrite page="/images/delete4.png" />"   alt="delete" /></a><%
			} else if ("1042".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1)) || "1041".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))||"1045".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1)) || "1040".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))) {
				if (!"".equals(((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 7))) {
					%><a href="javascript:void(0);"  onclick="return cancelClass('<%=courseIDVector.get(Integer.parseInt(statusCount) - 1) %>', '<%=(((ReportableListObject)pageContext.getAttribute("row")).getValue(1)) %>');return false;"><img src="<html:rewrite page="/images/delete4.png" />"   alt="delete" /></a><%
				}
			}
			for (Iterator<String> i=courseIDMap.keySet().iterator(); i.hasNext();) {
				String courseTemp = i.next();
				String idTemp = courseIDMap.get(courseTemp);
				if (courseTemp.equals(courseName)) {
					recordTemp = EnrollmentDB.getAttendedClass("education",idTemp, courseCategory, "staff", (((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), date_from, date_to);
						if (recordTemp.size() > 0) {
							ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
							%><span class="flow_class"><%=rowTemp.getValue(7) %></span><%
							checkSitinExist = true;
 						} else if (("".equals(((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 7)))) {
 							checkSitinExist = false;
 						}
				 }
			}
			if("6238".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))||"6730".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))){ 	
				String startdate = date_from.split("/")[0] + "/" + date_from.split("/")[1] + "/" +Integer.toString(Integer.parseInt(date_from.split("/")[2])-2);
				recordTemp = EnrollmentDB.getExpireDate("education", courseIDVector.get(Integer.parseInt(statusCount) - 1).toString(), (((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), startdate, date_to);
				if (recordTemp.size() > 0) {
					ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
						checkSitinExist = true;
					} else {
						checkSitinExist = false;
					}
			}
			if (userBean.isEducationManager()) {
			 	if (checkSitinExist == false) {
			 		%><button onclick="return exemption('<%=courseIDVector.get(Integer.parseInt(statusCount) - 1) %>', '<%=(((ReportableListObject)pageContext.getAttribute("row")).getValue(1)) %>');return false;" class="btn-click">E</button><%
			 	}
			}
		} else {
			if("1140".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))){
				String date = ((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 6).trim();
				if("".equals(date) || date.length() == 0){
					recordTemp = EnrollmentDB.getAttendedClass("education", "7429", null,"staff",(((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), date_from, date_to);
					if (recordTemp.size() > 0) {
						ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
						date = rowTemp.getValue(7);
					}else{
						recordTemp = EnrollmentDB.getAttendedClass("education", "7428", null,"staff",(((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), date_from, date_to);
						if (recordTemp.size() > 0) {
							ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
							date = rowTemp.getValue(7);
						}
					}
				}
				%><%=date%><%
			}else if("1110".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))){
				String date = ((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 6).trim();
				if("".equals(date) || date.length() == 0){
					recordTemp = EnrollmentDB.getAttendedClass("education", "7427", null,"staff",(((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), date_from, date_to);
					if (recordTemp.size() > 0) {
						ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
						date = rowTemp.getValue(7);
					}
				}
				%><%=date%><%
			}else{
			%><%=((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 6) %><%
			}
		}
%>
		</display:column>
		<display:column title="<%=courseNameDesc %>" media="csv excel xml pdf">
<%
		if (ConstantsServerSide.isTWAH()) {
			remark = EnrollmentDB.getenrollRemark(courseIDVector.get(Integer.parseInt(statusCount) - 1).toString(), (((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), date_from,date_to);
			if("6238".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))||"6730".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))){ 	
				String startdate = date_from.split("/")[0] + "/" + date_from.split("/")[1] + "/" +Integer.toString(Integer.parseInt(date_from.split("/")[2])-2);
				recordTemp = EnrollmentDB.getExpireDate("education", courseIDVector.get(Integer.parseInt(statusCount) - 1).toString(), (((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), startdate, date_to);
				if (recordTemp.size() > 0) {
					ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
					if("EXPIRED".equals(rowTemp.getValue(12))){%>
						EXPIRED (<%=rowTemp.getValue(7) %>)
<% 					}else{%>
						<%=rowTemp.getValue(13) %> (<%=rowTemp.getValue(7) %>)
<% 					}
				}
			}else{
%>
				<%=((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 7) %>
<%				
			}
			if ("Exemption".equals(remark)) {
				%>(E)<%
			}

			for (Iterator<String> i=courseIDMap.keySet().iterator(); i.hasNext(); ) {
				String courseTemp = i.next();
				String idTemp = courseIDMap.get(courseTemp);
				if (courseTemp.equals(courseName)) {
					recordTemp = EnrollmentDB.getAttendedClass("education",idTemp, courseCategory, "staff", (((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), date_from, date_to);
					if (recordTemp.size() > 0) {
						ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
						%><%=rowTemp.getValue(7) %><%
						checkSitinExist = true;
					} else if (("".equals(((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 7)))) {
						 checkSitinExist = false;
					}
			 	}
			}
		} else {
			if("1140".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))){
				String date = ((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 6).trim();
				if("".equals(date) || date.length() == 0){
					recordTemp = EnrollmentDB.getAttendedClass("education", "7429", null,"staff",(((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), date_from, date_to);
					if (recordTemp.size() > 0) {
						ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
						date = rowTemp.getValue(7);
					}else{
						recordTemp = EnrollmentDB.getAttendedClass("education", "7428", null,"staff",(((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), date_from, date_to);
						if (recordTemp.size() > 0) {
							ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
							date = rowTemp.getValue(7);
						}
					}
				}
				%><%=date%><%
			}else if("1110".equals(courseIDVector.get(Integer.parseInt(statusCount) - 1))){
				String date = ((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 6).trim();
				if("".equals(date) || date.length() == 0){
					recordTemp = EnrollmentDB.getAttendedClass("education", "7427", null,"staff",(((ReportableListObject)pageContext.getAttribute("row")).getValue(1)), date_from, date_to);
					if (recordTemp.size() > 0) {
						ReportableListObject rowTemp = (ReportableListObject) recordTemp.get(0);
						date = rowTemp.getValue(7);
					}
				}
				%><%=date%><%
			}else{
			%><%=((ReportableListObject)pageContext.getAttribute("row")).getValue(Integer.parseInt(statusCount) + 6) %><%
			}
		}
%>
	</display:column>
	</c:forEach>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<% } %>
</div>
<%if (isContinuous) { %>
<jsp:include page="ce.jsp" flush="false">
	<jsp:param name="command" value="create" />
	<jsp:param name="show_header" value="N" />
</jsp:include>
<%} %>