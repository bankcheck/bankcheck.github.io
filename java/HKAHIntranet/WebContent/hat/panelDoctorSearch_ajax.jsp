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
<%
String action = request.getParameter("action");

String inARcode = request.getParameter("inArcode");
String inSPcode = request.getParameter("inSpcode");
String inDRcode = request.getParameter("inDrcode");

if("changeAR".equals(action)){
	ArrayList<ReportableListObject> record = PanelDoctorDB.getPanelAR(inARcode, inSPcode, inDRcode);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
			<li class="w3-small" value="<%=row.getValue(0) %>" onclick="updateList('ar', '<%=row.getValue(0) %>', this)">
			<%=row.getValue(1) %></li>
<%
		}
	} else { %>
			<li value="" ></li>
<%	} 
} else if("changeSP".equals(action)){
	ArrayList<ReportableListObject> record = PanelDoctorDB.getPanelSP(inARcode, inSPcode, inDRcode);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
			<li class="w3-small" value="<%=row.getValue(0) %>" onclick="updateList('sp', '<%=row.getValue(0) %>', this)">
			<%=row.getValue(1) %></li>
<%
		}
	} else { %>
			<li value="" ></li>
<%	} 
} else if ("changeDR".equals(action)){
	ArrayList<ReportableListObject> record = PanelDoctorDB.getPanelDoctor(inARcode, inSPcode, inDRcode);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
			<li class="w3-small" value="<%=row.getValue(0) %>" onclick="updateList('doc', '<%=row.getValue(0) %>', this)">
			<%=(row.getValue(1) == null ? "" : row.getValue(1) + ", ") + (row.getValue(2) == null ? "" : row.getValue(2)) %>
			</li>
<%
		}
	} else { %>
			<li value="" ></li>
<%	} 
} else if ("retrieve".equals(action)){
		ArrayList<ReportableListObject> record = PanelDoctorDB.retrieveRecord(inARcode, inSPcode, inDRcode);
		request.setAttribute("retrieve_list", record);
	%>
		<div class="w3-container w3-center w3-large" style="background:#DFDFDF;">Doctor List</div>
		<display:table id="row" name="retrieve_list" export="false"  class="tablesorter">
			<display:column property="fields1" title="Insurance Company" class="smallText" style="width:30%" />
			<display:column property="fields7" title="Specialty" class="smallText" style="width:30%"/>
			<display:column property="fields2" title="Doctor Code" class="smallText" style="width:10%"/>
			<display:column title="Doctor Name" class="smallText" style="width:30%">
				<c:out value="${row.fields3}"/>, <c:out value="${row.fields4}" />
			</display:column>
			<display:setProperty name="basic.msg.empty_list" value="No record found."/>
		</display:table>
	<%	
}
%>