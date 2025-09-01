<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%!
	private ArrayList fetchPatientSlip(String slipNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.SLPNO, S.SLPCAMT, S.SLPDAMT, S.SLPPAMT, " +
						"S.SLPCAMT + S.SLPDAMT + S.SLPPAMT AS BALANCE, " +
						"P.PATNO, NVL(S.SLPFNAME, P.PATFNAME) AS PATFNAME, " +
						"NVL(S.SLPGNAME, P.PATGNAME) AS PATGNAME, " +
						"I.BEDCODE, TO_CHAR(R.REGDATE, 'dd/MM/YYYY HH24:MI:SS'), " +
						"I.ACMCODE, S.ARCCODE, S.ARLMTAMT, TO_CHAR(S.CVREDATE, 'dd/MM/YYYY') ");

		sqlStr.append("FROM ACM@IWEB A, BED@IWEB B, DOCTOR@IWEB D, INPAT@IWEB I, PATIENT@IWEB P, REG@IWEB R, SLIP@IWEB S, SPEC@IWEB SP ");

		sqlStr.append("WHERE S.REGID = R.REGID(+) AND S.PATNO = P.PATNO(+) AND R.INPID = I.INPID(+) " +
						"AND S.DOCCODE = D.DOCCODE AND D.SPCCODE = SP.SPCCODE AND I.BEDCODE = B.BEDCODE(+) "+
						"AND I.ACMCODE = A.ACMCODE(+) AND S.SLPNO = '"+slipNo+"' "+
						"AND I.INPDDATE IS NULL");
		
		//sqlStr.append("ORDER BY S.SLPNO DESC");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private String fetchARCName(String arcCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ARCNAME ");
		sqlStr.append("FROM ARCODE@IWEB ");
		sqlStr.append("WHERE ARCCODE = '"+arcCode+"' ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		
		if(record.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) record.get(0);
			
			if (!rlo.getValue(0).toUpperCase().startsWith("NC")) {
				return rlo.getValue(0);
			}
		}
		
		return "";
	}
	
	private String fetchAcmName(String acmCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select ACMNAME ");
		sqlStr.append("from ACM@IWEB ");
		sqlStr.append("WHERE  ACMCODE = '");
		sqlStr.append(acmCode.toUpperCase());
		sqlStr.append("'");
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			ReportableListObject row = null;
			row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		}
		
		return "";
	}
	
	private ArrayList fetchChargesDetail(String slipNo, String totalPayment, String balance) {
		StringBuffer sqlStr = new StringBuffer();
		/*sqlStr.append("SELECT SX.ITMTYPE, SX.STNNAMT, SX.STNSTS, SX.STNID ");
		sqlStr.append("FROM SLIPTX@IWEB SX, DOCTOR@IWEB D, SPEC@IWEB SP, ITEM@IWEB I, XREG@IWEB XR ");
		sqlStr.append("WHERE SX.ITMCODE = I.ITMCODE(+) AND SX.DOCCODE = D.DOCCODE "+
						"AND D.SPCCODE = SP.SPCCODE AND SX.DIXREF = XR.STNID(+) "+
						"AND SX.SLPNO = '"+slipNo+"' ");
		sqlStr.append("ORDER BY SX.STNID DESC ");
    	
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());*/
		
		ArrayList details = new ArrayList();
		int hospitalChg = 0;
		int doctorChg = 0;
		int specialChg = 0;
		int otherChg = 0;
		int refund = 0;
		/*
		if(record.size() > 0) {
			for(int i = 0; i < record.size(); i++) {
				ReportableListObject rlo = (ReportableListObject) record.get(i);
				
				if ("N".equals(rlo.getValue(2)) || "N".equals(rlo.getValue(2))) {
					// calculate amount with rounding
					if ("H".equals(rlo.getValue(0))) {
						hospitalChg += Integer.valueOf(rlo.getValue(1));
					} else if ("D".equals(rlo.getValue(0))) {
						doctorChg += Integer.valueOf(rlo.getValue(1));
					} else if ("S".equals(rlo.getValue(0))) {
						specialChg += Integer.valueOf(rlo.getValue(1));
					}
				}
			}
			
			if (Integer.valueOf(totalPayment) == 0) {
				refund = Integer.valueOf(balance) - hospitalChg - doctorChg - specialChg;
			} else {
				refund = Integer.valueOf(totalPayment) + hospitalChg + doctorChg + specialChg;
			}
		}
		*/
		sqlStr.append("SELECT ( ");
		sqlStr.append("    select NVL(SUM(STNBAMT),0) ");
		sqlStr.append("    from SLIPTX@IWEB ");
		sqlStr.append("    where SLPNO = S.SLPNO ");
		sqlStr.append("    and STNSTS in ('N', 'A') ");
		sqlStr.append("    and STNTYPE in ('D') ");
		sqlStr.append("    and ITMTYPE = 'H' ");
		sqlStr.append(") as HOSCHG, ");
		sqlStr.append("( ");
		sqlStr.append("    select NVL(SUM(STNBAMT),0) ");
		sqlStr.append("    from SLIPTX@IWEB ");
		sqlStr.append("    where SLPNO = S.SLPNO ");
		sqlStr.append("    and STNSTS in ('N', 'A') ");
		sqlStr.append("    and STNTYPE in ('D') ");
		sqlStr.append("    and ITMTYPE =  'D' ");
		sqlStr.append(") as DOCCHG, ");
		sqlStr.append("( ");
		sqlStr.append("    select NVL(SUM(STNBAMT),0) ");
		sqlStr.append("    from SLIPTX@IWEB ");
		sqlStr.append("    where SLPNO = S.SLPNO ");
		sqlStr.append("    and STNSTS in ('N', 'A') ");
		sqlStr.append("    and STNTYPE in ('D') ");
		sqlStr.append("    and ITMTYPE = 'O' ");
		sqlStr.append(") as OTHCHG, ");
		sqlStr.append("( ");
		sqlStr.append("    select NVL(SUM(STNBAMT),0) ");
		sqlStr.append("    from SLIPTX@IWEB ");
		sqlStr.append("    where SLPNO = S.SLPNO ");
		sqlStr.append("    and STNSTS in ('N', 'A') ");
		sqlStr.append("    and STNTYPE in ('D') ");
		sqlStr.append("    and ITMTYPE = 'S' ");
		sqlStr.append(") as SPECHG ");
		sqlStr.append("from SLIP@IWEB S ");
		sqlStr.append("where S.SLPNO = '"+slipNo+"' ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if(record.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) record.get(0);
			hospitalChg += Integer.valueOf(rlo.getValue(0));
			doctorChg += Integer.valueOf(rlo.getValue(1));
			specialChg += Integer.valueOf(rlo.getValue(3));
			otherChg += Integer.valueOf(rlo.getValue(2));
		}
		
		details.add(hospitalChg);
		details.add(doctorChg);
		details.add(specialChg);
		details.add(otherChg);
		//details.add(refund);
		
		return details;
	}
%>

<%
String slipNo = request.getParameter("slipNo");

boolean printed = false;
ArrayList record = fetchPatientSlip(slipNo);

for(int counter = 0; counter < record.size(); counter++) {
	ReportableListObject rlo = (ReportableListObject) record.get(counter);
	if(true/*!rlo.getValue(4).equals("0") /*|| (record.size() - counter == 1 && !printed)*/) {
		printed = true;
%>
	<table class="ui-button ui-widget-content ui-corner-all" style="width:95%;height:auto">
		<tr class="ui-widget-header" style="color:black; height:25px;">
			<td colspan='4'><label><strong><bean:message key="prompt.billNo"/>: </strong></label><label id="slipNo_<%=rlo.getValue(0) %>"><%=rlo.getValue(0) %></label><img src='../images/cross.jpg' style='float:right' onclick='closePanel()'/></td>
		</tr>
		<tr>
			<td><label><bean:message key="prompt.patientNo"/>: </label></td>
			<td><label id="patNo_<%=rlo.getValue(0) %>"><%=rlo.getValue(5) %></label></td>
			<td><label><bean:message key="prompt.admissionDate"/>: </label></td>
			<td><label id="adDate_<%=rlo.getValue(0) %>"><%=rlo.getValue(9) %></label></td>
		</tr>
		<tr>
			<td><label><bean:message key="prompt.patientName"/>: </label></td>
			<td><label id="patName_<%=rlo.getValue(0) %>"><%=rlo.getValue(6) %> <%=rlo.getValue(7) %></label></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td><label><bean:message key="prompt.bedCode"/>: </label></td>
			<td><label id="bedCode_<%=rlo.getValue(0) %>"><%=rlo.getValue(8) %></label></td>
			<td><label><bean:message key="prompt.acmName"/>: </label></td>
			<td><label id="acmCode__<%=rlo.getValue(0) %>"><%=fetchAcmName(rlo.getValue(10)) %></label></td>
		</tr>
		<tr>
			<td><label>AR Company: </label></td>
			<td><label id="arc_<%=rlo.getValue(0) %>"><%=fetchARCName(rlo.getValue(11)) %></label></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td><label>Limit Amount: </label></td>
			<td><label id="limit_<%=rlo.getValue(0) %>"><%=rlo.getValue(11).length()>0?rlo.getValue(12):"" %></label></td>
			<td><label>Cvr. End Date: </label></td>
			<td><label id="cvr_<%=rlo.getValue(0) %>"><%=rlo.getValue(13) %></label></td>
		</tr>
		<tr><td colspan='4'><HR></td></tr>
		<%
		ArrayList totalDetail = fetchChargesDetail(rlo.getValue(0), rlo.getValue(3), rlo.getValue(4));
		%>
		<tr>
			<td><label><bean:message key="prompt.totalHospCharges"/>: </label></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><label id="thc_<%=rlo.getValue(0) %>"><%=totalDetail.get(0) %></label></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><label><bean:message key="prompt.totalDocCharges"/>: </label></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><label id="tdc_<%=rlo.getValue(0) %>"><%=totalDetail.get(1) %></label></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><label><bean:message key="prompt.totalSpecCharges"/>: </label></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><label id="tsc_<%=rlo.getValue(0) %>"><%=totalDetail.get(2) %></label></td>
		</tr>
		<tr><td>&nbsp;</td></tr>		
		<tr><td colspan='4'><HR></td></tr>
		<tr>
			<td><label><bean:message key="prompt.totalCharge"/>: </label></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><label id="tCharges_<%=rlo.getValue(0) %>"><%=rlo.getValue(2) %></label></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><label><bean:message key="prompt.totalCredit"/>: </label></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><label id="tCredit_<%=rlo.getValue(0) %>"><%=rlo.getValue(1) %></label></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><label><bean:message key="prompt.totalPayment"/>: </label></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><label id="tPayment_<%=rlo.getValue(0) %>"><%=rlo.getValue(3) %></label></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><label><bean:message key="prompt.balance"/>: </label></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><label id="balance_<%=rlo.getValue(0) %>"><%=rlo.getValue(4) %></label></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan='4'><HR></td></tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" align="center">
				<button id="summary_<%=rlo.getValue(0) %>" class = 'summary ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>
					<label><bean:message key="prompt.summary"/></label>
				</button>
			</td>
			<td>&nbsp;</td>
		</tr>
	</table>
	<br/>
	<br/>
<%
	}
	else if(record.size() - counter == 1 && !printed) {
%>
	<table class="ui-button ui-widget-content ui-corner-all" style="width:40%">
		<tr class="ui-widget-header" style="color:black; height:50px;" align="center">
			<td colspan='4'><label style="font-size:22px;">
				<strong>
					<bean:define id="functionLabel"><bean:message key="prompt.billNo"/></bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
					<%=notFoundMsg %>
				</strong></label>
			</td>
		</tr>
	</table>
<%
	}
}
%>