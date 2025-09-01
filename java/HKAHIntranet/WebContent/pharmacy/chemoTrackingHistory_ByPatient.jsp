<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="javax.servlet.*,java.text.*" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%!
	private ArrayList<ReportableListObject> getChemoList(String patno){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.PATNO, P.PATFNAME ||' '|| P.PATGNAME, ");
		sqlStr.append("LISTAGG(C.CHEMO_PKGCODE,',') WITHIN GROUP (ORDER BY C.CHEMO_PKGCODE) OVER (PARTITION BY C.PATNO) PKGCODE ");
		sqlStr.append("FROM CHEMOTRACK@IWEB C, PATIENT@IWEB P ");
		sqlStr.append("WHERE C.PATNO = P.PATNO ");
		sqlStr.append("AND C.ENABLED = 1 ");
		sqlStr.append("AND C.PATNO = '" + patno + "' ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> getTicket(String chemoPkgcode){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT C.CHEMO_PKGCODE, C.PATNO, P.PATFNAME ||' '|| P.PATGNAME, TO_CHAR(T.START_DATE, 'dd/MM/YYYY'), T.CHEMO_ITMCODE, I.CHEMO_PHARCODE, I.CHEMO_ITMNAME, T.DOSE, ");
		sqlStr.append("TO_CHAR(C.NEXT_DATE, 'dd/MM/YYYY'), C.HASCOUNSELING, TO_CHAR(C.COUNSELING_DATE, 'DD/MM/YYYY'), C.REMARK ");
		sqlStr.append("FROM CHEMOTRACK@IWEB C, CHEMOTX@IWEB T, CHEMOITEM@IWEB I, PATIENT@IWEB P  ");
		sqlStr.append("WHERE C.CHEMO_PKGCODE = T.CHEMO_PKGCODE ");
		sqlStr.append("AND T.CHEMO_ITMCODE = I.CHEMO_ITMCODE ");
		sqlStr.append("AND C.PATNO = P.PATNO ");
		sqlStr.append("AND T.CHEMO_STATUS != 0 ");
		sqlStr.append("AND C.ENABLED = 1 ");
		sqlStr.append("AND C.CHEMO_PKGCODE = '" + chemoPkgcode + "' ");
		sqlStr.append("GROUP BY C.CHEMO_PKGCODE, C.PATNO, P.PATFNAME ||' '|| P.PATGNAME, T.START_DATE, T.CHEMO_ITMCODE, I.CHEMO_PHARCODE, I.CHEMO_ITMNAME, T.DOSE, C.NEXT_DATE, C.HASCOUNSELING, C.COUNSELING_DATE, C.REMARK  ");
		sqlStr.append("ORDER BY TO_CHAR(T.START_DATE, 'dd/MM/YYYY') ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

%>
<%
UserBean userBean = new UserBean(request);
ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;


String patno = request.getParameter("patno");
String chemoPkgcode = request.getParameter("chemoPkgcode");
String patname = "";
String current_pkg = "";
String past_pkg = ""; 
String next_pkg = ""; 

record = getChemoList(patno);
String chemoPkg = "";
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	patname = row.getValue(1);
	chemoPkg = row.getValue(2);
	String[] chemoList = chemoPkg.split(",");
	if(chemoPkgcode != null && chemoPkgcode.length() > 0){
		current_pkg = chemoPkgcode;

	}else{
		//get last history
		current_pkg = chemoList[chemoList.length-1];
	}
	for(int i=0;i<chemoList.length;i++){
		if(chemoList[i].equals(current_pkg)){
			if(i+1 < chemoList.length){
				next_pkg = chemoList[i+1];
			}else{
				next_pkg = "-1";
			}
			if(i-1 >= 0){
				past_pkg = chemoList[i-1];
			}else{
				past_pkg = "-1";
			}
			if(next_pkg == "-1" && past_pkg != "-1"){
				next_pkg = past_pkg;
			}else if(past_pkg == "-1" && next_pkg != "-1"){
				past_pkg = next_pkg;
			}
		}
	}
%>
 	<div class="w3-modal-content">
    	<header class="w3-container ah-pink" style="background-color:#A86868;">
			<span id="closePopup" onclick="closePatHist()" class="w3-button w3-display-topright">&times;</span>
			<b><font face="AR PL SungtiL GB" size=6 >
				<span id="patHistoryTitle">Patient History - #<%=patno %></span>
			</font></b>
		</header>

		<div class="w3-container w3-display-container" id="" style="width:100%;background-color:#F0CECE;">
			<!-- Patient No.: <%=patno %><br/>
			Patient Name: <%=patname %> <br/> -->
			Package No.: <%=current_pkg %>
			<br/><br/>
			<table id="ChemoHistList" class="w3-table w3-bordered w3-small">
				<thead>
					<tr>
						<th style="width:5%; padding-left: 8px; background-color:#A86868;">Date</th>
						<th style="width:40%; background-color:#A86868;">Chemo Agent</th>
						<th style="width:55%; background-color:#A86868;">Dose</th>
					</tr>
				</thead>
				<tbody>
<%
			record = getTicket(current_pkg);
			row = null;
			String vNextDate = "";
			String vHasCounseling = "";
			String vCounselingDate = "";
			String vRemark = "";
			if (record.size() > 0) {
				for(int i=0; i<record.size(); i++){
					row = (ReportableListObject) record.get(i);
					String vChemoPkgcode = row.getValue(0);
					String vPatno = row.getValue(1);
					String vPatName = row.getValue(2);
					String vStartDate = row.getValue(3);
					String vChemoItmcode = row.getValue(4);
					String vChemoPharcode = row.getValue(5);
					String vChemoItmName = row.getValue(6);
					String vDose = row.getValue(7);
					vNextDate = row.getValue(8);
					vHasCounseling = row.getValue(9);
					vCounselingDate = row.getValue(10);
					vRemark = row.getValue(11);
					
%>
					<tr>
						<td style="width:5%; padding-left: 8px;"><%=vStartDate %></td>
						<td style="width:40%;">[<%=vChemoPharcode %>] <%=vChemoItmName %></td>
						<td style="width:55%;"><%=vDose %>
					</tr>
<%					
				}
%>
				
				</tbody>
			</table>
			<br/>
			Next Schedule: <%=vNextDate %><br/>
			1st Dose Chemo Counseling Date: 
				<input type="checkbox" name="allowCounseling" id="allowCounseling" disabled <%if ("Y".equals(vHasCounseling)) { %> checked <% }%>s/>
				<%=vCounselingDate %>
			<br/><br/>
			Remark <br/>
			<div style="background-color:#FFFFFF;border: 1px solid #ccc; height:55px;"><%=vRemark.length()>0?vRemark:"&nbsp;" %></div>
			<br/><br/><br/>
<%
			}
%>				
			<button id="appendButton" class="w3-button w3-round-large w3-display-bottomright button" onclick="appendToNewCase(<%=current_pkg%>)">Append to new case</button>
		</div>
		<div class="w3-display-container ah-pink" style="height:55px; background-color:#A86868;">
			 <button id="pastHist" class="w3-button w3-round-large w3-display-bottomleft button" onclick="getPastHistoryByPatient(<%=patno %>, <%=past_pkg%>)"><<</button>
			 <button id="nextHist" class="w3-button w3-round-large w3-display-bottomright button" onclick="getPastHistoryByPatient(<%=patno %>, <%=next_pkg%>)">>></button>
		</div>
  </div>
<%	
}else{
	System.out.println("No History.");
}
%>
