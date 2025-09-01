<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> fetchCategory(String eqDept){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT C.EQCATCODE, C.EQCATEGORY ");
		sqlStr.append("FROM EQITEM@IWEB I, EQCATEGORY@IWEB C ");
		sqlStr.append("WHERE C.EQCATCODE = I.EQCATCODE ");
		sqlStr.append("AND I.EQDPTCODE = '"+eqDept+"' ");
		sqlStr.append("ORDER BY C.EQCATEGORY ");
		
		//System.out.println("[consignmentTracking_ajax.jsp] fetchCategory sql=" + sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> fetchCompany(String eqCategory, String eqDept){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT C.EQCOMCODE, C.EQCOMDESC  ");
		sqlStr.append("FROM EQITEM@IWEB I, EQCOMPANY@IWEB C ");
		sqlStr.append("WHERE I.EQCOMCODE = C.EQCOMCODE ");
		if (eqCategory != null && !eqCategory.isEmpty()) {
			sqlStr.append("AND I.EQCATCODE = '"+eqCategory+"' ");
		}
		sqlStr.append("AND I.EQDPTCODE = '"+eqDept+"' ");
		sqlStr.append("ORDER BY C.EQCOMDESC ");
		
		//System.out.println("[consignmentTracking_ajax.jsp] fetchCompany sql=" + sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> fetchItem(String eqCategory, String eqCompany, String eqDept){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EQITMCODE, EQCOMCODE, MODEL, EQREF ");
		sqlStr.append("FROM EQITEM@IWEB ");
		sqlStr.append("WHERE EQCOMCODE = '"+eqCompany+"' ");
		if (eqCategory != null && !eqCategory.isEmpty()) {
			sqlStr.append("AND EQCATCODE= '"+eqCategory+"' ");
		}
		sqlStr.append("AND EQDPTCODE = '"+eqDept+"' ");
		
		//System.out.println("[consignmentTracking_ajax.jsp] fetchItem sql=" + sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> searchByItem(String searchText){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EQITMCODE, EQCOMCODE, MODEL, EQREF ");
		sqlStr.append("FROM EQITEM@IWEB ");
		sqlStr.append("WHERE MODEL LIKE ('%"+searchText+"%') ");
		sqlStr.append("OR EQREF LIKE ('%"+searchText+"%') ");
		
		//System.out.println("[consignmentTracking_ajax.jsp] searchByItem sql=" + sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> searchItemDetail(String searchText){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT I.EQITMCODE, I.EQCOMCODE, C.EQCOMDESC, I.MODEL, I.EQREF, I.EQCATCODE, CAT.EQCATEGORY, I.EQDPTCODE, D.DPTNAME ");
		sqlStr.append("FROM EQITEM@IWEB I, EQCOMPANY@IWEB C, EQCATEGORY@IWEB CAT, DEPT@IWEB D ");
		sqlStr.append("WHERE I.EQCOMCODE = C.EQCOMCODE ");
		sqlStr.append("AND I.EQCATCODE = CAT.EQCATCODE ");
		sqlStr.append("AND I.EQDPTCODE = D.DPTCODE ");
		sqlStr.append("AND I.EQITMCODE = '"+searchText+"' ");
		
		//System.out.println("[consignmentTracking_ajax.jsp] searchItemDetail sql=" + sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private static String saveImplant(String source, String patno, String regid, String otlid, String userid, String selectItem){
		ArrayList<ReportableListObject> record = new ArrayList();
		record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_IMPLANT_LOG", new String[] {"ADD", source, patno, regid, otlid, userid, selectItem});
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			patno = row.getValue(0);
		}
		return patno;
	}
	
	private ArrayList<ReportableListObject> retrieveItem(String dept, String category, String company, String item){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT I.EQITMCODE, I.EQCOMCODE, C.EQCOMDESC, I.MODEL, I.EQREF, CA.EQCATEGORY ");
		sqlStr.append("FROM EQITEM@IWEB I, EQCOMPANY@IWEB C, EQCATEGORY@IWEB CA ");
		sqlStr.append("WHERE I.EQCOMCODE = C.EQCOMCODE ");
		sqlStr.append("AND I.EQCATCODE = CA.EQCATCODE ");
		sqlStr.append("AND UPPER(CA.EQCATEGORY) LIKE UPPER('%"+category+"%') ");
		sqlStr.append("AND UPPER(C.EQCOMDESC) LIKE UPPER('%"+company+"%') ");
		sqlStr.append("AND UPPER(I.EQDPTCODE) LIKE UPPER('%"+dept+"%') ");
		sqlStr.append("AND UPPER(I.MODEL || ' [REF:' || I.EQREF || ']') LIKE UPPER('%"+item+"%') ");
		
		//System.out.println("[consignmentTracking_ajax.jsp] retrieveItem sql=" + sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> retrieveRecord(String patno, String regid, String eqItmcode, String eqDept, String eqCategory, String eqCompany, String eqItem, String eqLot){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ER.CREATEDATE, ER.REGID, ER.PATNO, P.PATFNAME, ER.DPTCODE, D.DPTNAME, ER.EQITMCODE, I.MODEL, I.EQREF, ER.LOTCODE, ER.UNIT ");
		sqlStr.append("FROM EQREG@IWEB ER, PATIENT@IWEB P, EQITEM@IWEB I, DEPT@IWEB D, EQCOMPANY@IWEB C, EQCATEGORY@IWEB CA ");
		sqlStr.append("WHERE ER.PATNO = P.PATNO ");
		sqlStr.append("AND ER.EQITMCODE = I.EQITMCODE ");
		sqlStr.append("AND C.EQCOMCODE = I.EQCOMCODE ");
		sqlStr.append("AND ER.DPTCODE = D.DPTCODE ");
		sqlStr.append("AND I.EQCATCODE = CA.EQCATCODE ");
		if(patno != null && !"".equals(patno)){
			sqlStr.append("AND ER.PATNO = '"+patno+"' ");
		}
		if(eqItmcode != null && !"".equals(eqItmcode)){
			sqlStr.append("AND ER.EQITMCODE = '"+eqItmcode+"' ");
		}
		if(eqDept != null && !"".equals(eqDept)){
			sqlStr.append("AND UPPER(D.DPTNAME) LIKE UPPER('%"+eqDept+"%') ");
		}
		if(eqCategory != null && !"".equals(eqCategory)){
			sqlStr.append("AND UPPER(CA.EQCATEGORY) LIKE UPPER('%"+eqCategory+"%') ");
		}
		if(eqCompany != null && !"".equals(eqCompany)){
			sqlStr.append("AND UPPER(C.EQCOMDESC) LIKE UPPER('%"+eqCompany+"%') ");
		}
		if(eqItem != null && !"".equals(eqItem)){
			sqlStr.append("AND UPPER(I.MODEL || ' [REF:' || I.EQREF || ']') LIKE UPPER('%"+eqItem+"%') ");
		}
		if(eqLot != null && !"".equals(eqLot)){
			sqlStr.append("AND UPPER(ER.LOTCODE) LIKE UPPER('%"+eqLot+"%') ");
		}
		sqlStr.append("ORDER BY ER.CREATEDATE DESC, I.MODEL, I.EQREF ");
		
		//System.out.println("[consignmentTracking_ajax.jsp] retrieveRecord sql=" + sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%><%
String action = request.getParameter("action");
String eqDept = request.getParameter("eqDept");
String eqCategory = request.getParameter("eqCategory");
String eqCompany = request.getParameter("eqCompany");
String eqItem = request.getParameter("eqItem");
String eqItmcode = request.getParameter("eqItmcode");

String eqLot = request.getParameter("eqLot");
String searchText = request.getParameter("searchText");
String source = request.getParameter("source");
String patno = request.getParameter("patno");
String regid = request.getParameter("regid");
String otlid = request.getParameter("otlid");
String userid = request.getParameter("userid");
String selectItem = request.getParameter("selectItem");

if("changeCategory".equals(action)){
	ArrayList<ReportableListObject> record = fetchCategory(eqDept);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
			<li class="w3-small" value="<%=row.getValue(0) %>" onclick="changeCompanyList(this)">
			<%=row.getValue(1) %></li>
<%
		}
	} else { %>
			<li value="" ></li>
<%	} 
} else if("changeCompany".equals(action)){
	ArrayList<ReportableListObject> record = fetchCompany(eqCategory, eqDept);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
			<li class="w3-small" value="<%=row.getValue(0) %>" onclick="changeItemList(this)">
			<%=row.getValue(1) %></li>
<%
		}
	} else { %>
			<li value="" ></li>
<%	} 
} else if ("changeItem".equals(action)){
	ArrayList<ReportableListObject> record = fetchItem(eqCategory, eqCompany, eqDept);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%><li class="w3-small" value="<%=row.getValue(0) %>" onclick="updateByItem(this)"><%=row.getValue(2) %> [REF:<%=row.getValue(3) %>]</li><%
		}
	} else { %>
			<li value="" ></li>
<%	} 
} else if ("searchItem".equals(action)){
	ArrayList<ReportableListObject> record = searchByItem(searchText);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
			<li class="w3-small" value="<%=row.getValue(0) %>" onclick="updateByItem(this)">
			<%=row.getValue(2) %> [REF:<%=row.getValue(3) %>]</li>
<%
		}
	} else { %>
			<li value="" ></li>
<%	} 
} else if ("searchItemDetail".equals(action)){
	ArrayList<ReportableListObject> record = searchItemDetail(searchText);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			String itmName = row.getValue(3).replace("\"", "\\\"");
%>
			<script>
			$("#deptInput").val("<%=row.getValue(8) %>");
			$("#deptCodeInput").val("<%=row.getValue(7) %>");
			$("#companyInput").val("<%=row.getValue(2) %>");
			$("#companyCodeInput").val("<%=row.getValue(1) %>");
			$("#categoryInput").val("<%=row.getValue(6) %>");
			$("#categoryCodeInput").val("<%=row.getValue(5) %>");
			$("#itemInput").val("<%=itmName%> [REF:<%=row.getValue(4) %>]");
			$("#itemCodeInput").val("<%=row.getValue(0) %>");
			</script>
<%
		}
	} 
} else if ("saveImplant".equals(action)){
	patno = saveImplant(source, patno, regid, otlid, userid, selectItem);
%>
	<%=patno %>
<%
} else if ("retrieve".equals(action)){
		
	if (	patno != null && !"".equals(patno) || 
			regid != null && !"".equals(regid) || 
			eqItmcode != null && !"".equals(eqItmcode) ||
			eqLot != null && !"".equals(eqLot) ){
		ArrayList<ReportableListObject> record = retrieveRecord(patno, regid, eqItmcode, eqDept, eqCategory, eqCompany, eqItem, eqLot);
		request.setAttribute("retrieveItem_list", record);
	%>
		<div class="w3-container w3-center w3-large" style="background:#DFDFDF;">Registration List</div>
		<display:table id="row" name="requestScope.retrieveItem_list" export="false"  class="tablesorter">
			<display:column property="fields0" title="Log Date" class="smallText" style="width:10%" />
			<display:column property="fields2" title="Patient No." class="smallText" style="width:10%"/>
			<display:column property="fields3" title="First Name" class="smallText" style="width:16%"/>
			<display:column property="fields5" title="Department" class="smallText" style="width:15%"/>
			<display:column property="fields7" title="Model" class="smallText" style="width:24%"/>
			<display:column property="fields8" title="Ref#" class="smallText" style="width:10%"/>
			<display:column property="fields9" title="Lot#" class="smallText" style="width:10%"/>
			<display:column property="fields10" title="Unit" class="smallText" style="width:5%"/>
			<display:setProperty name="basic.msg.empty_list" value="No record found."/>
		</display:table>
	<%	
	}else{
		ArrayList<ReportableListObject> record = retrieveItem(eqDept, eqCategory, eqCompany, eqItem);
		request.setAttribute("retrieveItem_list", record);
%>
	<div class="w3-container w3-center w3-large" style="background:#DFDFDF;">Item List</div>
	<display:table id="row" name="requestScope.retrieveItem_list" export="false"  class="tablesorter">
		<display:column property="fields0" title="Itmcode" class="smallText hiddenField" headerClass="hiddenField" style="width:0%" />
		<display:column property="fields5" title="Category" class="smallText" style="width:20%"/>
		<display:column property="fields2" title="Company" class="smallText" style="width:20%"/>
		<display:column title="Model" class="" style="width:50%"><span style="cursor: pointer;"onclick="searchByItem('<c:out value="${row.fields0}" />');"><c:out value="${row.fields3}" /></span></display:column>
		<display:column property="fields4" title="Ref#" class="smallText" style="width:10%"/>
		
		<display:setProperty name="basic.msg.empty_list" value="No record found."/>
	</display:table>
<%		
	}
}
%>