<%@ page import="java.math.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String appointedRoomType = ParserUtil.getParameter(request, "appointedRoomType");
String attendingDoctor = ParserUtil.getParameter(request, "attendingDoctor");
String estimatedLengthOfStay = ParserUtil.getParameter(request, "estimatedLengthOfStay");

String surgeonFee = ParserUtil.getParameter(request, "surgeonFee");
String wardRoundFee = ParserUtil.getParameter(request, "wardRoundFee");
String anaesthetistFee = ParserUtil.getParameter(request, "anaesthetistFee");
String procedureFee = ParserUtil.getParameter(request, "procedureFee");
String procedureFeeAdditional = ParserUtil.getParameter(request, "procedureFeeAdditional");

String confirmPatient = ParserUtil.getParameter(request, "confirmPatient");

String remark_hkah1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah1"));
String remark_ghc1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc1"));

double dailyRoomRateDouble = 0.0;
if ("PRIVATE".equals(appointedRoomType)) {
	dailyRoomRateDouble = 2980;
} else if ("SEMI-PRIVATE".equals(appointedRoomType)) {
	dailyRoomRateDouble = 2980;
}

double totalWardRoundFeeDouble = 0.0;
double lengthOfStayDouble = 0.0;
try {
	lengthOfStayDouble = Double.parseDouble(estimatedLengthOfStay);
	double wardRoundFeeDouble = Double.parseDouble(wardRoundFee);
	totalWardRoundFeeDouble = lengthOfStayDouble * wardRoundFeeDouble;
} catch (Exception e) {
}

double doctorTotalDouble = 0.0;
double surgeonFeeDouble = 0.0;
try {
	surgeonFeeDouble = Double.parseDouble(surgeonFee);
	doctorTotalDouble = totalWardRoundFeeDouble + surgeonFeeDouble;
} catch (Exception e) {
}

double doctorEstimateDouble = 0.0;
try {
	double anaesthetistFeeDouble = Double.parseDouble(anaesthetistFee);
	doctorEstimateDouble = doctorTotalDouble + anaesthetistFeeDouble;
} catch (Exception e) {
}

double totalDailyRoomRateDouble = lengthOfStayDouble * dailyRoomRateDouble;
double procedureFeeDouble = 0.0;
double hospitalMarkupDouble = 0.0;
try {
	procedureFeeDouble = Double.parseDouble(procedureFee);
	BigDecimal temp = new BigDecimal((totalDailyRoomRateDouble + procedureFeeDouble) * 0.3);
	hospitalMarkupDouble = temp.setScale(2, BigDecimal.ROUND_HALF_DOWN).doubleValue();
} catch (Exception e) {
	e.printStackTrace();
}
double hospitalEstimateDouble = totalDailyRoomRateDouble + procedureFeeDouble + hospitalMarkupDouble;

double totalEstimateDouble = doctorEstimateDouble + hospitalEstimateDouble;
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="4">Doctor Portion</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">&nbsp;</td>
		<td class="infoLabel" width="30%">Days</td>
		<td class="infoLabel" width="20%">Amount</td>
		<td class="infoLabel" width="30%">Total</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel">Dr. <%=attendingDoctor == null ? "--" : attendingDoctor %></td>
		<td class="infoData" colspan="3">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Ward Round Fee (per day)</td>
		<td class="infoData" width="30%"><%=estimatedLengthOfStay == null ? "--" : estimatedLengthOfStay %></td>
		<td class="infoData" width="20%">$<%=wardRoundFee==null?"":wardRoundFee %></td>
		<td class="infoData" width="30%">$<%=totalWardRoundFeeDouble == 0 ? "--" : totalWardRoundFeeDouble %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Surgeon Fee</td>
		<td class="infoData" width="30%">&nbsp;</td>
		<td class="infoData" width="50%" colspan="2">$ <%=surgeonFeeDouble == 0 ? "--" : surgeonFeeDouble %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Total</td>
		<td class="infoData" width="50%" colspan="2">&nbsp;</td>
		<td class="infoData" width="30%">$ <b><%=doctorTotalDouble %></b></td>
	</tr>
	<tr class="smallText">
		<td class="infoData">&nbsp;</td>
		<td class="infoData" colspan="3"><HR></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Anaesthetist Fee</td>
		<td class="infoData" width="70%" colspan="3">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel">Dr.</td>
		<td class="infoData" colspan="3">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Total</td>
		<td class="infoData" width="30%">&nbsp;</td>
		<td class="infoData" width="20%">$ <%=anaesthetistFee==null?"":anaesthetistFee %></td>
		<td class="infoData" width="30%">$ <b><%=anaesthetistFee==null?"":anaesthetistFee %></b></td>
	</tr>
	<tr class="smallText">
		<td class="infoData">&nbsp;</td>
		<td class="infoData" colspan="3"><HR></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Doctor Estimate</td>
		<td class="infoData" width="50%" colspan="2">&nbsp;</td>
		<td class="infoData" width="30%">$
			<b><%=doctorEstimateDouble == 0 ? "--" : doctorEstimateDouble %></b>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle2" colspan="4">Hospital Portion</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">&nbsp;</td>
		<td class="infoLabel" width="30%">Days</td>
		<td class="infoLabel" width="20%">Amount</td>
		<td class="infoLabel" width="30%">Total</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Hospital Room Charge</td>
		<td class="infoData" width="30%"><%=estimatedLengthOfStay == null ? "--" : estimatedLengthOfStay %></td>
		<td class="infoData" width="20%">$ <%=dailyRoomRateDouble == 0 ? "--" : dailyRoomRateDouble %></td>
		<td class="infoData" width="30%">$ <b><%=totalDailyRoomRateDouble == 0 ? "--" : totalDailyRoomRateDouble %></b></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Hospital Fee</td>
		<td class="infoData" width="30%">&nbsp;</td>
		<td class="infoData" width="50%" colspan="2">$ <%=procedureFee==null?"":procedureFee %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="50%" colspan="2">Estimate cost as from the above 30% add on top of hospital estimate for all other ancillary charges</td>
		<td class="infoData" width="20%">$
			<b><%=hospitalMarkupDouble == 0 ? "--" : hospitalMarkupDouble %></b>
		</td>
		<td class="infoData" width="30%">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoData">&nbsp;</td>
		<td class="infoData" colspan="3"><HR></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Hospital Estimate</td>
		<td class="infoData" width="50%" colspan="2">&nbsp;</td>
		<td class="infoData" width="30%">$
			<b><%=hospitalEstimateDouble == 0 ? "--" : hospitalEstimateDouble %></b>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoData" colspan="4"><HR></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="50%" colspan="2">Total Estimation(Doctor Portion + Hospital Portion)</td>
		<td class="infoData" width="20%">&nbsp;</td>
		<td class="infoData" width="30%">$
			<b><%=totalEstimateDouble == 0 ? "--" : totalEstimateDouble %></b>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoData" colspan="4">
			Please note that the above cost is an estimation for reference only but not final amount due to the costs of any lab test, drug charges, diagnostic imaging charges and misc. charges are not foreseen.
		</td>
	</tr>