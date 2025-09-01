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
	
	private ArrayList<ReportableListObject> fetchRecord(String locid) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	T.REGID, T.WRDCODE, T.BEDCODE, T.PATNO, P.PATFNAME, ");
		sqlStr.append("		TO_CHAR(T.START_DATE, 'DD/MM/YYYY HH24:MI'), "); // 5
		sqlStr.append("		TO_CHAR(T.TO_RX_DATE, 'DD/MM/YYYY HH24:MI'), T.TO_RX_DATE_REMARK, ");
		sqlStr.append("		TO_CHAR(T.RECEIVE_DATE, 'DD/MM/YYYY HH24:MI'), T.RECEIVE_DATE_REMARK, "); 
		sqlStr.append("		TO_CHAR(T.ENTRY_DATE, 'DD/MM/YYYY HH24:MI'), T.ENTRY_DATE_REMARK, ");
		sqlStr.append("		TO_CHAR(T.TO_PBO_DATE, 'DD/MM/YYYY HH24:MI'), T.TO_PBO_DATE_REMARK, ");
	//	sqlStr.append("		TO_CHAR(T.RECEIVE_FROM_RX_DATE, 'DD/MM/YYYY HH24:MI'), T.RECEIVE_FROM_RX_DATE_REMARK, ");
		sqlStr.append("		TO_CHAR(T.FINISH_BILLING_DATE, 'DD/MM/YYYY HH24:MI'), T.FINISH_BILLING_DATE_REMARK, ");
		sqlStr.append("		TO_CHAR(T.PAYMENT_SETTLEMENT_DATE, 'DD/MM/YYYY HH24:MI'), T.PAYMENT_SETTLEMENT_DATE_REMARK, ");
		sqlStr.append("		TO_CHAR(T.NO_RX_DISCHARGE_DATE, 'DD/MM/YYYY HH24:MI'), T.NO_RX_DISCHARGE_DATE_REMARK, ");
		sqlStr.append("		TO_CHAR(T.RX_BEDSIDE_DISCHARGE_DATE, 'DD/MM/YYYY HH24:MI'), T.BEDSIDE_DISCHARGE_DATE_REMARK, ");
		sqlStr.append("		TO_CHAR(T.DRUG_PICKING_DATE, 'DD/MM/YYYY HH24:MI'), T.DRUG_PICKING_DATE_REMARK, ");
		sqlStr.append("		TO_CHAR(T.MODIFIED_DATE, 'DD/MM/YYYY HH24:MI'), ");	
		sqlStr.append("		CASE WHEN   (T.STATUS IN (8,9,10) AND T.PAYMENT_SETTLEMENT_DATE IS NOT NULL) OR ");
		sqlStr.append("            (T.STATUS = 7 AND ");
		sqlStr.append("                (T.RX_BEDSIDE_DISCHARGE_DATE IS NOT NULL OR T.NO_RX_DISCHARGE_DATE IS NOT NULL OR T.DRUG_PICKING_DATE IS NOT NULL)) ");
		sqlStr.append("    	THEN '1' ELSE '0' END AS COMPLETED, ");
		sqlStr.append("		T.NO_MED ");
		sqlStr.append("FROM TICKET_QUEUE@IWEB T, PATIENT@IWEB P ");
		sqlStr.append("WHERE P.PATNO = T.PATNO ");
		sqlStr.append("AND	(T.STATUS NOT IN (7,8,9,10) OR ");
		sqlStr.append("		(T.STATUS = 7 AND ( ");
		sqlStr.append(" 		(T.RX_BEDSIDE_DISCHARGE_DATE IS NULL AND T.NO_RX_DISCHARGE_DATE IS NULL AND T.DRUG_PICKING_DATE IS NULL) OR ");
		sqlStr.append("     	((T.RX_BEDSIDE_DISCHARGE_DATE IS NOT NULL OR T.NO_RX_DISCHARGE_DATE IS NOT NULL OR T.DRUG_PICKING_DATE IS NOT NULL) ");
		sqlStr.append("				AND SYSDATE < T.PAYMENT_SETTLEMENT_DATE + 10/1440 ) ");
		sqlStr.append(" 		)) OR ");
		sqlStr.append("		(T.STATUS IN (8,9,10) AND T.PAYMENT_SETTLEMENT_DATE IS NULL) OR ");
		sqlStr.append("		(T.STATUS = 8 AND ");
		sqlStr.append("			(T.PAYMENT_SETTLEMENT_DATE IS NOT NULL ");
		sqlStr.append("				AND SYSDATE < T.NO_RX_DISCHARGE_DATE + 10/1440 ) ");
		sqlStr.append("		) OR ");
		sqlStr.append("		(T.STATUS = 9 AND ");
		sqlStr.append("			(T.PAYMENT_SETTLEMENT_DATE IS NOT NULL ");
		sqlStr.append("				AND SYSDATE < T.RX_BEDSIDE_DISCHARGE_DATE + 10/1440 ) ");
		sqlStr.append("		) OR ");
		sqlStr.append("		(T.STATUS = 10 AND ");
		sqlStr.append("			(T.PAYMENT_SETTLEMENT_DATE IS NOT NULL ");
		sqlStr.append("				AND SYSDATE < T.DRUG_PICKING_DATE + 10/1440 ) ");
		sqlStr.append("		) ");
		sqlStr.append("     ) ");
		sqlStr.append("AND T.START_DATE IS NOT NULL ");
		sqlStr.append("AND T.STATUS != 0 ");
		if(!"PBO".equals(locid)&&!"PHAR".equals(locid)&&!"allDept".equals(locid)){
			if("SC".equals(locid) || "MS".equals(locid)){
				sqlStr.append("AND T.WRDCODE IN ('SC','MS') ");
			}else{
				sqlStr.append("AND T.WRDCODE = UPPER('"+locid+"') ");
			}
		}
		sqlStr.append("AND T.ENABLED = '1' ");
		sqlStr.append("ORDER BY T.START_DATE DESC");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> fetchTmrDischarge(String locid){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(REGID) ");
		sqlStr.append("FROM TICKET_QUEUE@IWEB ");
		sqlStr.append("WHERE TO_CHAR(PLAN_DATE,'DD/MM/YYYY') = TO_CHAR(SYSDATE+1,'DD/MM/YYYY') ");
		sqlStr.append("AND START_DATE IS NULL ");
		if(!"PBO".equals(locid)&&!"PHAR".equals(locid)&&!"allDept".equals(locid)){
			sqlStr.append("AND WRDCODE = UPPER('"+locid+"') ");
		}
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

%><%
String locid = request.getParameter("locid");

ArrayList<ReportableListObject> record0 = fetchTmrDischarge(locid);
ReportableListObject row0 = null;
if (record0.size() > 0) {
	row0 = (ReportableListObject) record0.get(0);
%>
	<script>$("#tmrCount").html(<%=row0.getValue(0) %>);</script>
<%
}


ArrayList<ReportableListObject> record = fetchRecord(locid);
ReportableListObject row = null;
int count = record.size();
request.setAttribute("record_list", record);

String complete = "<img class=\"completeImg\" src=\"../images/ball-green.png\" width=\"35\" height=\"35\" border=\"0\" ></img>";
String incomplete = "<img src=\"../images/circle-green.png\" width=\"30\" height=\"30\" border=\"0\"></img>";
String incompleteAlert = "<img src=\"../images/Red-circle2.png\" width=\"33\" height=\"33\" border=\"0\"></img>";
String completeWithRemark = "<img class=\"completeImg\" src=\"../images/ball-green-remark.png\" width=\"35\" height=\"35\" border=\"0\"></img>";

if (count > 0) { %>

<display:table id="row1" name="requestScope.record_list"  export="false" class="generaltable ">
		
		<c:set var="ms" value="60000" /><!-- __*ms = __mins eg.5*ms = 5mins-->
		<jsp:useBean id="now" class="java.util.Date" />
		
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="startTime" 			value="${row1.fields5}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="toRxTime" 			value="${row1.fields6}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="receiveTime" 		value="${row1.fields8}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="entryTime" 			value="${row1.fields10}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="toPBOTime" 			value="${row1.fields12}" />

		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="finishBillingTime" 	value="${row1.fields14}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="paymentSettleTime" 	value="${row1.fields16}" />

		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="noDischargeTime" 	value="${row1.fields18}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="rxBedsideTime" 		value="${row1.fields20}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="drugPickTime" 		value="${row1.fields22}" />
		
	<display:column headerClass="hiddenC" class="hiddenC cps" property="fields25" title="" style="width:0%;"/>	
<%	if("PBO".equals(locid)||"PHAR".equals(locid)){ %>
	<display:column title="" style="width:1%; " >
		<img class="button" src="../images/print.jpg" width="25" height="25" border="0" onclick=reprint(<c:out value="${row1.fields0}" />) ></img>
	</display:column>
<%	} %>
	<display:column title="Start Time" style="width:6%; " >
		<c:set var="showDate" value="${fn:substring(row1.fields5, 0, 5)}"/>
		<c:set var="showTime" value="${fn:substring(row1.fields5, 11, 16)}"/>
		<c:choose>
		<c:when test="${now.date != startTime.date}">
					<c:out value='${showDate}'/>
		</c:when>
		</c:choose>
		<c:out value='${showTime}'/>
	</display:column>
	<display:column property="fields1" title="Ward" style="width:3%; "/>
	<display:column property="fields2" title="Bed#" style="width:5%; "/>
	<display:column property="fields3" title="Patient#" style="width:6.5%; "/>
	<display:column property="fields4" title="Last Name" style="width:16%; "/>
	<display:column property="fields26" title="No.Of Meds" style="width:4%; "/>
	<display:column headerClass="hiddenC" class="hiddenC regid" property="fields0" title="" style="width:0%;"/>
	<display:column title="Ward<br>Send to Pharmacy" class="w3-center wardList" headerClass="wardList" style="width:6.5%;">
	<c:choose>
		<c:when test="${not empty row1.fields6}">
			<c:set var="logDate" value="${fn:substring(row1.fields6, 0, 10)}"/>
			<c:set var="logTime" value="${fn:substring(row1.fields6, 11, 16)}"/>
			<span class="completedStep" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"2") >
				<c:out value='${logTime}'/><c:if test="${not empty row1.fields7}">*</c:if>
			</span>
		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${not empty row1.fields5 && (now.time - startTime.time > 15*ms)}">
					<span class="alertStep">&nbsp;</span>
				</c:when>
				<c:otherwise>
					<span class="incompletedStep">&nbsp;</span>
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>
	</display:column>
	<display:column title="Pharmacy<br>Received Order" class="w3-center pharList2" style="width:6.5%;" >
		<c:choose>
			<c:when test="${not empty row1.fields8}">
				<c:set var="logDate" value="${fn:substring(row1.fields8, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields8, 11, 16)}"/>
				<span class="completedStep" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"3") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields9}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test = "${not empty row1.fields6 && (now.time - toRxTime.time > 10*ms)}">
						<span class="alertStep">&nbsp;</span>
					</c:when>
					<c:otherwise>
						<span class="incompletedStep">&nbsp;</span>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Pharmacy<br>Completed Order" class="w3-center pharList2" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields10}">
				<c:set var="logDate" value="${fn:substring(row1.fields10, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields10, 11, 16)}"/>
				<span class="completedStep" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"4") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields11}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test = "${not empty row1.fields8 && (now.time - receiveTime.time > 33*ms)}">
						<span class="alertStep" >&nbsp;</span>
						<%	if("PHAR".equals(locid)){ %>
							<script>alertInCompleted(<c:out value="${row1.fields0}" />)</script>
						<%} %>					
						</c:when>
					<c:otherwise>
						<span class="incompletedStep">&nbsp;</span>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Pharmacy<br>Drop Off at PBO" class="w3-center pboList" headerClass="pboList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields12}" >
				<c:set var="logDate" value="${fn:substring(row1.fields12, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields12, 11, 16)}"/>
				<span class="completedStep" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"5") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields13}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test = "${not empty row1.fields8 && (now.time - receiveTime.time > 35*ms)}">
						<%	if("PHAR".equals(locid)){ %>
							<script>alertInCompleted(<c:out value="${row1.fields0}" />)</script>
						<%} %>
						<span class="alertStep">&nbsp;</span>
					</c:when>
					<c:otherwise>
						<span class="incompletedStep">&nbsp;</span>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="PBO<br>Finish Billing" class="w3-center pboList" headerClass="pboList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields14}" >
				<c:set var="logDate" value="${fn:substring(row1.fields14, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields14, 11, 16)}"/>
				<span class="completedStep" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"6") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields15}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test = "${not empty row1.fields12 && (now.time - toPBOTime.time > 20*ms)}">
						<span class="alertStep">&nbsp;</span>
					</c:when>
					<c:otherwise>
						<span class="incompletedStep">&nbsp;</span>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="PBO<br>Payment Settled" class="w3-center pboList" headerClass="pboList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields16}" >
				<c:set var="logDate" value="${fn:substring(row1.fields16, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields16, 11, 16)}"/>
				<span class="completedStep" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"7")>
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields17}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test = "${not empty row1.fields14 && (now.time - finishBillingTime.time > 180*ms)}">
						<span class="alertStep">&nbsp;</span>
					</c:when>
					<c:otherwise>
						<span class="incompletedStep">&nbsp;</span>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="No Discharge Med" class="w3-center pharList" headerClass="pharList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields18}" >
				<c:set var="logDate" value="${fn:substring(row1.fields18, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields18, 11, 16)}"/>
				<span class="completedStep" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"8") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields19}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test = "${not empty row1.fields8 && (now.time - receiveTime.time > 60*ms) && (empty row1.fields18 && empty row1.fields20 && empty row1.fields22)}">
						<span class="alertStep">&nbsp;</span>
					</c:when>
					<c:otherwise>
						<span class="incompletedStep">&nbsp;</span>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Pharmacy<br>Bedside Discharge" class="w3-center pharList" headerClass="pharList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields20}" >
				<c:set var="logDate" value="${fn:substring(row1.fields20, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields20, 11, 16)}"/>
				<span class="completedStep" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"9") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields21}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<c:choose>
						<c:when test = "${not empty row1.fields8 && (now.time - receiveTime.time > 60*ms) && (empty row1.fields18 && empty row1.fields20 && empty row1.fields22)}">
							<span class="alertStep">&nbsp;</span>
						<%	if("PHAR".equals(locid)){ %>
							<script>alertInCompleted(<c:out value="${row1.fields0}" />)</script>
						<%} %>							
						</c:when>
						<c:otherwise>
							<span class="incompletedStep">&nbsp;</span>
						</c:otherwise>
					</c:choose>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Drug picking by patient" class="w3-center pharList" headerClass="pharList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields22}" >
				<c:set var="logDate" value="${fn:substring(row1.fields22, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields22, 11, 16)}"/>
				<span class="completedStep" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"10") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields23}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<c:choose>
						<c:when test = "${not empty row1.fields8 && (now.time - receiveTime.time > 60*ms) && (empty row1.fields18 && empty row1.fields20 && empty row1.fields22)}">
							<span class="alertStep">&nbsp;</span>
						</c:when>
						<c:otherwise>
							<span class="incompletedStep">&nbsp;</span>
						</c:otherwise>
					</c:choose>
			</c:otherwise>
		</c:choose>
	</display:column>
	
</display:table>
<script>updateCompleted()</script>
<%} else { %>
	No discharge process.
<%} %>