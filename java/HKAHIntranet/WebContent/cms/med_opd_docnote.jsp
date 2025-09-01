<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="javax.servlet.*,java.text.*" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%!
private ArrayList<ReportableListObject> getDocNote(String regid){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT  	PATNO, REGID, CURR_CMPLT, PHY_EXAM, ");
	sqlStr.append("			PHY_CVS_FLAG, PHY_RES_FLAG, PHY_CNS_FLAG, PHY_ABD_FLAG, ");
	sqlStr.append("			IMP, PLAN, PHY_TARGET_EXAM ");
	sqlStr.append("FROM OPD_DOCNOTE ");
	sqlStr.append("WHERE REGID = ? ");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[]{regid});
}

%>
<%
String regid = request.getParameter("regid");
String regdate = request.getParameter("regdate");

ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;

record = getDocNote(regid);
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	//row.getValue(0)
%>
<span class="w3-large">Doctor Note</span><br/>
<div id="opDocNote" class="">
	Reg. Date: <span id="regdate"><%=regdate %></span><br/>
	<br/>
	<label style="font-weight: bold;">Chief Complaint / Present Illness / Past Health / Social and Family History: </label><br/>
		<textarea id="opCC" rows="4" readonly><%=row.getValue(2) %></textarea>
	<label style="font-weight: bold;">Physical Examination: </label><br/>
		<textarea id="opPhyExam" rows="3" readonly><%=row.getValue(3) %></textarea><br/> 
		<table>
			<tr>
				<td style="text-decoration: underline; width:25%;">CVS: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
				<td><input type="radio" id="" name="opcvs" value="-" disabled <%if("-".equals(row.getValue(4))){ %>checked<%} %>> Irrelevant </td>
<%	} %>				
				<td><input type="radio" id="" name="opcvs" value="N" disabled <%if("N".equals(row.getValue(4))){ %>checked<%} %>> No Significant Finding </td>
				<td><input type="radio" id="" name="opcvs" value="R" disabled <%if("R".equals(row.getValue(4))){ %>checked<%} %>> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
				<td><input type="radio" id="" name="opcvs" value="D" disabled <%if("D".equals(row.getValue(4))){ %>checked<%} %>> Decline </td>
			</tr>
			<tr>
				<td style="text-decoration: underline;">Respiratory: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
				<td><input type="radio" id="" name="opres" value="-" disabled <%if("-".equals(row.getValue(5))){ %>checked<%} %>> Irrelevant </td>
<%	} %>	
				<td><input type="radio" id="" name="opres" value="N" disabled <%if("N".equals(row.getValue(5))){ %>checked<%} %>> No Significant Finding </td>
				<td><input type="radio" id="" name="opres" value="R" disabled <%if("R".equals(row.getValue(5))){ %>checked<%} %>> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
				<td><input type="radio" id="" name="opres" value="D" disabled <%if("D".equals(row.getValue(5))){ %>checked<%} %>> Decline </td>
			</tr>
			<tr>
				<td style="text-decoration: underline;">CNS: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
				<td><input type="radio" id="" name="opcns" value="-" disabled <%if("-".equals(row.getValue(6))){ %>checked<%} %>> Irrelevant </td>
<%	} %>	
				<td><input type="radio" id="" name="opcns" value="N" disabled <%if("N".equals(row.getValue(6))){ %>checked<%} %>> No Significant Finding </td>
				<td><input type="radio" id="" name="opcns" value="R" disabled <%if("R".equals(row.getValue(6))){ %>checked<%} %>> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
				<td><input type="radio" id="" name="opcns" value="D" disabled <%if("D".equals(row.getValue(6))){ %>checked<%} %>> Decline </td>
			</tr>
<%	if (ConstantsServerSide.isTWAH()) { %>
			<tr>
				<td style="text-decoration: underline;">Abdomen: </td>
				<td><input type="radio" id="" name="opabd" value="N" disabled <%if("N".equals(row.getValue(7))){ %>checked<%} %>> No Significant Finding </td>
				<td><input type="radio" id="" name="opabd" value="R" disabled <%if("R".equals(row.getValue(7))){ %>checked<%} %>> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
				<td><input type="radio" id="" name="opabd" value="D" disabled <%if("D".equals(row.getValue(7))){ %>checked<%} %>> Decline </td>
			</tr>
<%	} %>
<%	if (ConstantsServerSide.isHKAH()) { %>	
			<tr>
				<td style="vertical-align: top;text-decoration: underline;">Targeted Examination: </td>
				<td colspan="3"><textarea id="opTargetExam" rows="2" readonly><%=row.getValue(10) %></textarea></td>
			</tr>
<%	} %>
		</table>
	<label style="font-weight: bold;">Impression / Diagnosis: </label><br/>
		<textarea id="opImp" rows="3" readonly><%=row.getValue(8) %></textarea>
	<label style="font-weight: bold;">Medical Care Plan: </label><br/>
		<textarea id="opPlan" rows="3" readonly><%=row.getValue(9) %></textarea>
</div>
<script>
	$("#appendToCurrentNote").removeAttr("disabled");
	$("#undo").removeAttr("disabled");
	$("#noDocNote").css("display","block");
</script>
<%
}else{
%>
<span class="w3-large">Doctor Note</span><br/>
<div id="opDocNoteNo" class="">
	Reg. Date: <span id="regdate"><%=regdate %></span><br/>
	<br/>
	<label style="font-weight: bold;">Chief Complaint / Present Illness / Past Health / Social and Family History: </label><br/>
		<textarea id="opCC" rows="4" readonly></textarea>
	<label style="font-weight: bold;">Physical Examination: </label><br/>
		<textarea id="opPhyExam" rows="3" readonly></textarea><br/> 
		<table>
			<tr>
				<td style="text-decoration: underline;">CVS: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
				<td><input type="radio" id="" name="opcvs" value="-" disabled> Irrelevant </td>
<%	} %>	
				<td><input type="radio" id="" name="opcvs" value="N" disabled> No Significant Finding </td>
				<td><input type="radio" id="" name="opcvs" value="R" disabled> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
				<td><input type="radio" id="" name="opcvs" value="D" disabled> Decline </td>
			</tr>
			<tr>
				<td style="text-decoration: underline;">Respiratory: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
				<td><input type="radio" id="" name="opres" value="-" disabled> Irrelevant </td>
<%	} %>	
				<td><input type="radio" id="" name="opres" value="N" disabled> No Significant Finding </td>
				<td><input type="radio" id="" name="opres" value="R" disabled> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
				<td><input type="radio" id="" name="opres" value="D" disabled> Decline </td>
			</tr>
			<tr>
				<td style="text-decoration: underline;">CNS: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
				<td><input type="radio" id="" name="opcns" value="-" disabled> Irrelevant </td>
<%	} %>	
				<td><input type="radio" id="" name="opcns" value="N" disabled> No Significant Finding </td>
				<td><input type="radio" id="" name="opcns" value="R" disabled> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
				<td><input type="radio" id="" name="opcns" value="D" disabled> Decline </td>
			</tr>
<%	if (ConstantsServerSide.isTWAH()) { %>
			<tr>
				<td style="text-decoration: underline;">Abdomen: </td>
				<td><input type="radio" id="" name="opabd" value="N" disabled> No Significant Finding </td>
				<td><input type="radio" id="" name="opabd" value="R" disabled> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
				<td><input type="radio" id="" name="opabd" value="D" disabled> Decline </td>
			</tr>
<%	} %>
<%	if (ConstantsServerSide.isHKAH()) { %>	
			<tr>
				<td style="vertical-align: top;text-decoration: underline;">Targeted Examination: </td>
				<td colspan="3"><textarea id="opTargetExam" rows="2" readonly></textarea></td>
			</tr>
<%	} %>
		</table>
	<label style="font-weight: bold;">Impression / Diagnosis: </label><br/>
		<textarea id="opImp" rows="3" readonly></textarea>
	<label style="font-weight: bold;">Medical Care Plan: </label><br/>
		<textarea id="opPlan" rows="3" readonly></textarea>
</div>
<div id="noDocNote" class="w3-container w3-card-4 w3-display-topmiddle w3-center ah-pink">
	<span class="w3-large">Doctor Note not found.</span>
</div>
<script>
	$("#appendToCurrentNote").attr("disabled","disabled");
	$("#undo").attr("disabled","disabled");
	$("#noDocNote").css("display","block");
</script>
<%
}
%>