<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.hibernate.*"%>
<%@ page import="org.apache.poi.ss.usermodel.*"%>
<%@ page import="org.apache.poi.ss.util.*"%>
<%@ page import="org.apache.poi.poifs.filesystem.*"%>
<%@ page import="org.apache.poi.xssf.usermodel.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>

<%@ page import="org.apache.poi.POIXMLDocument"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.openxml4j.exceptions.InvalidFormatException"%>
<%@ page import="org.apache.poi.openxml4j.opc.OPCPackage"%>

<%@ page import="org.apache.poi.hssf.record.crypto.Biff8EncryptionKey"%>



<%!
public class ImmuValue{
	String fluVacOrTetShot;
	String patientNo;
	String empNo;
	String name;
	String gender;
	String dept;
	String measlesHist;
	String mumpsHist;
	String rubHist;
	String chickenPoxHist;
	String measVac;
	String mumpsVac;
	String rubVac;
	String chickenPoxVac;
	String postVacCheck;
	String hepatB;
	String postVacCheckHepatB;
	String hbsAg;
	String hbsAb;
	String fluVacDate;
	String fluVacType;
	String tetShotDate;
	String tetShotDosage;
	String remark;
	
	public ImmuValue(String fluVacOrTetShot, String patientNo, String empNo, String name, String gender,
					 String dept, String measlesHist, String mumpsHist, String rubHist, String chickenPoxHist,
					 String measVac, String mumpsVac, String rubVac, String chickenPoxVac, String postVacCheck,
					 String hepatB, String postVacCheckHepatB, String hbsAg, String hbsAb, String fluVacDate,
					 String fluVacType, String tetShotDate, String tetShotDosage, String remark){
		this.fluVacOrTetShot = fluVacOrTetShot;
		this.patientNo = patientNo;
		this.empNo = empNo;
		this.name = name;
		this.gender = gender;
		this.dept = dept;
		this.measlesHist = measlesHist;
		this.mumpsHist = mumpsHist;
		this.rubHist = rubHist;
		this.chickenPoxHist = chickenPoxHist;
		this.measVac = measVac;
		this.mumpsVac = mumpsVac;
		this.rubVac = rubVac;
		this.chickenPoxVac = chickenPoxVac;
		this.postVacCheck = postVacCheck;
		this.hepatB = hepatB;
		this.postVacCheckHepatB = postVacCheckHepatB;
		this.hbsAg = hbsAg;
		this.hbsAb = hbsAb;
		this.fluVacDate = fluVacDate;
		this.fluVacType = fluVacType;
		this.tetShotDate = tetShotDate;
		this.tetShotDosage = tetShotDosage;
		this.remark = remark;
	}
}

public class DeptValue{
	String deptCode;
	String deptDesc;
	
	public DeptValue(String deptCode, String deptDesc){
		this.deptCode = deptCode;
		this.deptDesc = deptDesc;
	}
}

public static ArrayList getAllDepartmentDesc(){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select CO_DEPARTMENT_CODE2 , CO_DEPARTMENT_DESC ");
	sqlStr.append("from   CO_DEPARTMENT_MAPPING CM, CO_DEPARTMENTS CD ");
	sqlStr.append("where  CM.CO_DEPARTMENT_CODE1 = CD.CO_DEPARTMENT_CODE ");
	sqlStr.append("and    CD.CO_ENABLED = 1 ");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

String listLabel = "function.osh.list";
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

// constant
String documentID = "549";

ArrayList record_real = new ArrayList();
String location = null;
String filePath = null;

// get document url
ReportableListObject row = DocumentDB.getReportableListObject(documentID);
if (row != null) {
	location = row.getValue(2);
	if (ConstantsVariable.YES_VALUE.equals(row.getValue(3))) {
		filePath = ConstantsServerSide.DOCUMENT_FOLDER + File.separator + location;
	} else {
		filePath = location;
	}	
	filePath += "/Immunization rec_sharefolder_2013.xls";
}

//filePath = ConstantsServerSide.DOCUMENT_FOLDER + File.separator  + "/Immunization rec_sharefolder_2013.xls";
//filePath = ConstantsServerSide.DOCUMENT_FOLDER + File.separator + "/Immunization Rec_sharefolder_2013.xlsx";

POIFSFileSystem filesystem = new POIFSFileSystem(new FileInputStream(filePath)); 
Biff8EncryptionKey.setCurrentUserPassword("8848");
HSSFWorkbook book = new HSSFWorkbook(filesystem); 
 
if (filePath == null || filePath.isEmpty()) {
	errorMessage = "No document found.";
} else {	
	Sheet sheet =  book.getSheetAt(0);	
	Iterator<Row> rowIterator = sheet.iterator();
	
	DecimalFormat df = new DecimalFormat("###.#");
	
	ArrayList<ImmuValue> immuValueList = new ArrayList<ImmuValue>();
	while(rowIterator.hasNext()) {
		Row row2 = rowIterator.next();		
		Iterator<Cell> cellIterator = row2.cellIterator();
		
		String value = "";		
		int i = 0;
		String tempRemark = "";
		ArrayList<String> tempValue = new ArrayList<String>();
		
		boolean isAllEmpty = true;
		while(cellIterator.hasNext()) {		
			
			Cell cell = cellIterator.next();	
			switch(cell.getCellType()) {
				case Cell.CELL_TYPE_BOOLEAN:					
					value =  Boolean.toString(cell.getBooleanCellValue());
					break;
				case Cell.CELL_TYPE_NUMERIC:
					value = df.format(cell.getNumericCellValue());
					break;
				case Cell.CELL_TYPE_STRING:
					value = cell.getStringCellValue();
					break;
				case Cell.CELL_TYPE_BLANK:
					value = cell.getStringCellValue();
					break;				
			}			
			
			if(i>=23){
				tempRemark = tempRemark + " " + value.replaceAll("\\s+","");
			}else{
				tempValue.add(value);
			}
			if(value!=null && value.length() > 0){
				isAllEmpty = false;
			}
			i++;
		}
		tempValue.add(tempRemark);
		
		if(isAllEmpty == false){
			immuValueList.add(new ImmuValue(tempValue.get(0), tempValue.get(1), tempValue.get(2), tempValue.get(3),
					tempValue.get(4), tempValue.get(5), tempValue.get(6), tempValue.get(7), tempValue.get(8), 
					tempValue.get(9), tempValue.get(10), tempValue.get(11), tempValue.get(12), tempValue.get(13),
					tempValue.get(14), tempValue.get(15), tempValue.get(16), tempValue.get(17), tempValue.get(18),
					tempValue.get(19), tempValue.get(20), tempValue.get(21), tempValue.get(22), tempValue.get(23)));
		}
	}
	
	
	ArrayList managerListRecord = StaffDB.getOSHList(userBean);
	ArrayList<String> listOfStaffs = new ArrayList();
	if (managerListRecord.size() > 0) {
		for (int i = 0; i < managerListRecord.size(); i++) {
			ReportableListObject managerListRow= (ReportableListObject) managerListRecord.get(i);
			listOfStaffs.add(managerListRow.getValue(2));
		}
	}
	
	ArrayList deptListRecord = getAllDepartmentDesc();
	ArrayList<DeptValue> listOfDept = new ArrayList();
	if (deptListRecord.size() > 0) {
		for (int i = 0; i < deptListRecord.size(); i++) {
			ReportableListObject deptListRow= (ReportableListObject) deptListRecord.get(i);
			listOfDept.add(new DeptValue(deptListRow.getValue(0),deptListRow.getValue(1)));
		}
	}
	
	for(ImmuValue im : immuValueList){
		ReportableListObject row_real = new ReportableListObject(24);				
		if("Emp#".equals(im.empNo)){
			continue;
		}
		
		boolean empFound = false;
		for(String s : listOfStaffs){
			if(s.equals(im.empNo)){
				empFound = true;
			}
		}
		if(empFound == false){
			continue;
		}
		
		row_real.setValue(0, im.fluVacOrTetShot);
		row_real.setValue(1, im.patientNo);
		row_real.setValue(2, im.empNo);
		row_real.setValue(3, im.name);		
		row_real.setValue(4, im.gender);
		
		String tempDept = im.dept;
		for(DeptValue d : listOfDept){
			if(d.deptCode.equals(im.dept)){
				tempDept = d.deptDesc;
				break;
			}
		}
		row_real.setValue(5, tempDept);
		row_real.setValue(6, im.measlesHist);
		row_real.setValue(7, im.mumpsHist);
		row_real.setValue(8, im.rubHist);
		row_real.setValue(9, im.chickenPoxHist);
		row_real.setValue(10, im.measVac);
		row_real.setValue(11, im.mumpsVac);
		row_real.setValue(12, im.rubVac);
		row_real.setValue(13, im.chickenPoxVac);
		row_real.setValue(14, im.postVacCheck);
		row_real.setValue(15, im.hepatB);
		row_real.setValue(16, im.postVacCheckHepatB);
		row_real.setValue(17, im.hbsAg);
		row_real.setValue(18, im.hbsAb);
		row_real.setValue(19, im.fluVacDate);
		row_real.setValue(20, im.fluVacType);
		row_real.setValue(21, im.tetShotDate);
		row_real.setValue(22, im.tetShotDosage);
		row_real.setValue(23, im.remark);
				
		record_real.add(row_real);
	}
			
	request.setAttribute("record_list", record_real);	
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" width="100%">
	<tr class="bigText">
		<td class="infoLabel" width="35%"><bean:message key="prompt.title" /></td>
		<td class="infoData" width="65%">OSH Immunization List</td>
	</tr>
</table>
<bean:define id="functionLabel"><bean:message key="<%=listLabel %>" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row_ce" name="requestScope.record_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><c:out value="${row_ce_rowNum}"/>)</display:column>
	<display:column property="fields0" title="*Flu Vaccination/ **Tetanus Shot" />
	<display:column property="fields1" title="Patient No" />
	<display:column property="fields2" title="Emp#" />
	<display:column property="fields3" title="Name" />
	<display:column property="fields4" title="Gender" />
	<display:column property="fields5" title="Department" />
	<display:column property="fields6" title="Measles History" />
	<display:column property="fields7" title="Mumps History" />
	<display:column property="fields8" title="Rubella History" />
	<display:column property="fields9" title="Chicken Pox History" />
	<display:column property="fields10" title="Measles Vaccination" />
	<display:column property="fields11" title="Mumps Vaccination" />
	<display:column property="fields12" title="Rubella Vaccination" />
	<display:column property="fields13" title="Chicken Pox Vaccination" />
	<display:column property="fields14" title="Post Vaccine Antibody Check (Chicken Pox)" />
	<display:column property="fields15" title="Hepatitis B three doses completed" />
	<display:column property="fields16" title="Post Vaccine Antibody Check (Hepatitis B)" />
	<display:column property="fields17" title="Hbs Ag" />
	<display:column property="fields18" title="Hbs Ab" />
	<display:column property="fields19" title="Flu Vaccination Date" />
	<display:column property="fields20" title="Flu Vaccination Type" />
	<display:column property="fields21" title="Tetanus Shot Date" />
	<display:column property="fields22" title="Tetanus Shot Dosage" />
	<display:column property="fields23" title="Remark" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>" />
</display:table>
<br/><p/><br/>

<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>