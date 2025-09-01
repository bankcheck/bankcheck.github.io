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
<%@ page import="javax.servlet.*,java.text.*" %>
<%!
	
	private ArrayList<ReportableListObject> fetchRecord(String searchDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	C.CHEMO_PKGCODE, T.CHEMO_ID, TO_CHAR(T.START_DATE, 'DD/MM'), C.PATNO, T.CHEMO_ITMCODE, I.CHEMO_ITMNAME, T.DOSE, ");
		sqlStr.append("			TO_CHAR(T.RECEIVE_DATE, 'DD/MM/YYYY HH24:MI'), RECEIVE_REMARK, ");//7
		sqlStr.append("			TO_CHAR(T.PREPARATION_DATE, 'DD/MM/YYYY HH24:MI'), PREPARATION_REMARK, ");//9
		sqlStr.append("			TO_CHAR(T.CHECKING_DATE, 'DD/MM/YYYY HH24:MI'), CHECKING_REMARK, ");//11
		sqlStr.append("			TO_CHAR(T.KARSON_INPUT_DATE, 'DD/MM/YYYY HH24:MI'), KARSON_INPUT_REMARK, ");//13
		sqlStr.append("			TO_CHAR(T.CLEAN_ROOM_DATE, 'DD/MM/YYYY HH24:MI'), CLEAN_ROOM_REMARK, ");//15
		sqlStr.append("			TO_CHAR(T.FINAL_CHECK_DATE, 'DD/MM/YYYY HH24:MI'), FINAL_CHECK_REMARK, ");//17
		sqlStr.append("			TO_CHAR(T.READY_DATE, 'DD/MM/YYYY HH24:MI'), READY_REMARK, ");//19
		sqlStr.append("			TO_CHAR(T.DELIVERY_DATE, 'DD/MM/YYYY HH24:MI'), DELIVERY_REMARK, ");//21
		sqlStr.append("			TO_CHAR(C.COUNSELING_DATE, 'DD/MM/YYYY'), C.HASCOUNSELING, ");//23
		sqlStr.append("			TO_CHAR(C.NEXT_DATE, 'DD/MM/YYYY'), T.CHEMO_STATUS, ");//25,26
		sqlStr.append("			CASE WHEN (T.CHEMO_STATUS = 9 AND T.KARSON_INPUT_DATE IS NOT NULL) THEN '1' ELSE '0' END AS COMPLETED, ");//27
		sqlStr.append("			T.FINAL_CHECK_USER ");//28
		sqlStr.append("FROM CHEMOTRACK@IWEB C, CHEMOTX@IWEB T, CHEMOITEM@IWEB I ");
		sqlStr.append("WHERE C.CHEMO_PKGCODE = T.CHEMO_PKGCODE ");
		sqlStr.append("AND T.CHEMO_ITMCODE = I.CHEMO_ITMCODE ");
		sqlStr.append("AND T.CHEMO_STATUS != 0 ");
		sqlStr.append("AND C.ENABLED = 1 ");
		sqlStr.append("AND ((T.START_DATE < TO_DATE('" + searchDate + "', 'DD/MM/YYYY') AND ");
		sqlStr.append("    	(	(T.DELIVERY_DATE IS NULL OR T.KARSON_INPUT_DATE IS NULL) OR ");
		sqlStr.append("			(TO_CHAR(T.KARSON_INPUT_DATE, 'DD/MM/YYYY') = '" + searchDate + "') OR ");
		sqlStr.append("			(TO_CHAR(T.DELIVERY_DATE, 'DD/MM/YYYY') = '" + searchDate + "'))) ");
		sqlStr.append("OR TO_CHAR(T.START_DATE, 'DD/MM/YYYY') = '" + searchDate + "') ");
		sqlStr.append("ORDER BY T.START_DATE, C.CHEMO_PKGCODE, T.CHEMO_ID ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> getPharmacist(){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_STAFF_ID, CO_STAFFNAME ");
		sqlStr.append("FROM CO_STAFFS ");
		sqlStr.append("WHERE CO_DEPARTMENT_CODE = '380' ");
		sqlStr.append("AND CO_POSITION_CODE IN ('P-305','P-137','P-138','P-139','P-195') ");
		sqlStr.append("AND CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY CO_STAFFNAME ");
	
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%><%
UserBean userBean = new UserBean(request);
boolean isPharManager = false;
if (userBean.isLogin() && userBean.isGroupID("pharManager") && !userBean.isAdmin()){
	isPharManager = true;
}

String status_Start = "1";
String status_Receive = "2";
String status_Preparation = "3";
String status_Checking = "4";
String status_KasonInput = "5";
String status_CleanRoom = "6";
String status_FinCheck = "7";
String status_Ready = "8";
String status_Delivery = "9";
String status_Counseling = "10";

String searchDate = request.getParameter("searchDate");
SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm");
SimpleDateFormat display = new SimpleDateFormat ("dd/MM/yyyy");
Date today = new Date();
Date tmr = new Date();
Date ytd = new Date();
Date sDate = display.parse(searchDate);
tmr = sDate;
tmr.setDate(tmr.getDate() + 1);
String tmrDate = display.format(tmr);
ytd = sDate;
ytd.setDate(ytd.getDate() - 2);
String ytdDate = display.format(ytd);

int ms = 60000; // *ms = *mins eg.5*ms = 5mins

ArrayList<ReportableListObject> record = fetchRecord(searchDate);
ReportableListObject row = null;
int count = record.size();
request.setAttribute("record_list", record);

String tempChemoPkgcode = "";
String tempChemoDate = "";
boolean showInfo = true;
if (count > 0) { 
	for(int i=0; i<count; i++){
		long diff2 = 0;
		long diff6 = 0;
		long diff8 = 0;
		
		row = (ReportableListObject) record.get(i);
		String vChemoPkgcode = row.getValue(0);
		String vChemoId = row.getValue(1);
		String vStartDate = row.getValue(2);
		String vPatno = row.getValue(3);
		String vChemoItmcode = row.getValue(4);
		String vChemoItmname = row.getValue(5);
		String vDose = row.getValue(6);
		String vReceiveDate = row.getValue(7);
		String vReceiveRemark = row.getValue(8);
		String vPreparationDate = row.getValue(9);
		String vPreparationRemark = row.getValue(10);
		String vCheckingDate = row.getValue(11);
		String vCheckingRemark = row.getValue(12);
		String vKasonInputDate = row.getValue(13);
		String vKasonInputRemark = row.getValue(14);
		String vCleanRoomDate = row.getValue(15);
		String vCleanRoomRemark = row.getValue(16);
		String vFinCheckDate = row.getValue(17);
		String vFinCheckRemark = row.getValue(18);
		String vReadyDate = row.getValue(19);
		String vReadyRemark = row.getValue(20);
		String vDeliveryDate = row.getValue(21);
		String vDeliveryRemark = row.getValue(22);
		String vCounselingDate = row.getValue(23);
		String vHasCounseling = row.getValue(24);
		String vNextDate = row.getValue(25);
		String vStatus = row.getValue(26);
		if (tempChemoPkgcode != null && tempChemoPkgcode.equals(vChemoPkgcode) && 
				tempChemoDate != null && tempChemoDate.equals(vStartDate)){
			showInfo = false;
		}else{
			showInfo = true;
			tempChemoPkgcode = vChemoPkgcode;
			tempChemoDate = vStartDate;
		}
		Boolean vCompleted = "1".equals(row.getValue(27))?true:false;
		String vFinCheckUser = row.getValue(28);
		Date dReceiveDate = new Date();
		Date dPreparationDate = new Date();
		Date dCheckingDate = new Date();
		Date dKasonInputDate = new Date();
		Date dCleanRoomDate = new Date();
		Date dFinCheckDate = new Date();
		Date dReadyDate = new Date();
		Date dDeliveryDate = new Date();
		
		long timespan = 0;
		
%>
		<tr class="<%if (vCompleted){%> completedRow <%}%>">
<%
		if(showInfo){
%>
			<td><%=vStartDate %></td>
			<td><span class="listPatno" ondblclick="showChemoPkgInfo('<%=vChemoPkgcode %>')" style="cursor: pointer;"><%=vPatno %></span></td>
<%		}else{ 
%>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
<%		}
%>
			<td><%=vChemoItmname %></td>
			<td><%=vDose %></td>
			<td>
<%		if(vReceiveDate == null || vReceiveDate.length()<=0){ %>
			<span id="<%=status_Receive %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this, '<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Receive %>', false)" >&nbsp;</span>
<%		} else { 
			dReceiveDate = format.parse(vReceiveDate);
			diff2 = today.getTime() - dReceiveDate.getTime();
%>		
			<span id="<%=status_Receive %>-<%=vChemoId %>" class="chemoProcess completedStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Receive %>', false)" onclick="selectStatus(this, '<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Receive %>', false)" >
				<%=vReceiveDate %>
				<% if(vReceiveRemark == null || vReceiveRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
			
<%		} %>
			</td>
			<td>
<%		if(vPreparationDate == null || vPreparationDate.length()<=0){
			if(diff2 < 20*ms){
%>
			<span id="<%=status_Preparation %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this, '<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Preparation %>', false)" >&nbsp;</span>
<%			}else { %>
			<span id="<%=status_Preparation %>-<%=vChemoId %>" class="chemoProcess alertStep" onclick="selectStatus(this, '<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Preparation %>', false)" >&nbsp;</span>
<%		
			}
		} else { 
			dPreparationDate = format.parse(vPreparationDate);
			timespan = dPreparationDate.getTime() - dReceiveDate.getTime(); 
%>		
			<span id="<%=status_Preparation %>-<%=vChemoId %>" class="chemoProcess <%if(timespan>20*ms){ %>completedLateStep<%}else{ %>completedStep<%} %>" 
					ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Preparation %>', false)" 
					onclick="selectStatus(this, '<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Preparation %>', true)" >
				<%=vPreparationDate %>
				<% if(vPreparationRemark == null || vPreparationRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%		} %>
			</td>
			<td>
<%		if(vCheckingDate == null || vCheckingDate.length()<=0){ 
			if(diff2 < 20*ms){
%>
			<span id="<%=status_Checking %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Checking %>', false)" >&nbsp;</span>
<%			}else { %>
			<span id="<%=status_Checking %>-<%=vChemoId %>" class="chemoProcess alertStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Checking %>', false)" >&nbsp;</span>
<%		
			}
		} else { 
			dCheckingDate = format.parse(vCheckingDate);
			timespan = dCheckingDate.getTime() - dReceiveDate.getTime(); 
%>		
			<span id="<%=status_Checking %>-<%=vChemoId %>" class="chemoProcess <%if(timespan>20*ms){ %>completedLateStep<%}else{ %>completedStep<%} %>" 
					ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Checking %>', false)" 
					onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Checking %>', true)" >
				<%=vCheckingDate %>
				<% if(vCheckingRemark == null || vCheckingRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%		} %>
			</td>
			<td>
<%		if(vKasonInputDate == null || vKasonInputDate.length()<=0){ 
			if(diff2 < 25*ms){
%>
			<span id="<%=status_KasonInput %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_KasonInput %>', true)" >&nbsp;</span>
<%			}else { %>
			<span id="<%=status_KasonInput %>-<%=vChemoId %>" class="chemoProcess alertStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_KasonInput %>', true)" >&nbsp;</span>
<%		
			}
		} else { 
			dKasonInputDate = format.parse(vKasonInputDate);
			timespan = dKasonInputDate.getTime() - dReceiveDate.getTime(); 
%>		
			<span id="<%=status_KasonInput %>-<%=vChemoId %>" class="chemoProcess <%if(timespan>25*ms){ %>completedLateStep<%}else{ %>completedStep<%} %>" 
					ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_KasonInput %>', false)" 
					onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_KasonInput %>', true)" >
				<%=vKasonInputDate %>
				<% if(vKasonInputRemark == null || vKasonInputRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%		} %>
			</td>
			<td class="finalColumn">
<%		if(vCleanRoomDate == null || vCleanRoomDate.length()<=0){ 
			if(diff2 < 25*ms){
%>
			<span id="<%=status_CleanRoom %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_CleanRoom %>', false)" >&nbsp;</span>
<%			}else { %>
			<span id="<%=status_CleanRoom %>-<%=vChemoId %>" class="chemoProcess alertStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_CleanRoom %>', false)" >&nbsp;</span>
<%		
			}
		} else {
			dCleanRoomDate = format.parse(vCleanRoomDate);
			diff6 = today.getTime() - dCleanRoomDate.getTime();
			timespan = dCleanRoomDate.getTime() - dReceiveDate.getTime(); 
%>		
			<span id="<%=status_CleanRoom %>-<%=vChemoId %>" class="chemoProcess <%if(timespan>25*ms){ %>completedLateStep<%}else{ %>completedStep<%} %>" 
					ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_CleanRoom %>', false)" 
					onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_CleanRoom %>', true)" >
					<%=vCleanRoomDate %>
					<% if(vCleanRoomRemark == null || vCleanRoomRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%		} %>
			</td>
			<td>
<%		if(vFinCheckDate == null || vFinCheckDate.length()<=0){ 
			if(diff6 < 30*ms){
%>
			<span id="<%=status_FinCheck %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_FinCheck %>', true)" >&nbsp;</span>
<%			}else { %>
			<span id="<%=status_FinCheck %>-<%=vChemoId %>" class="chemoProcess alertStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_FinCheck %>', true)" >&nbsp;</span>
<%		 	} %>			
			</td>
			<td>
				<span class="chemoProcess incompletedStep">&nbsp;</span>
<%		} else { 
			dFinCheckDate = format.parse(vFinCheckDate);
			timespan = dFinCheckDate.getTime() - dCleanRoomDate.getTime(); 
%>		
			<span id="<%=status_FinCheck %>-<%=vChemoId %>" class="chemoProcess <%if(timespan>30*ms){ %>completedLateStep<%}else{ %>completedStep<%} %>" 
					ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_FinCheck %>', false)" 
					onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_FinCheck %>', true)" >
				<%=vFinCheckDate %>
				<% if(vFinCheckRemark == null || vFinCheckRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
			</td>
			<td>
				<select class="<%if(vFinCheckUser == null || vFinCheckUser.length()<=0){%>emptyUser<%}else{ %>completedUser<%} %>" 
						id="finCheckUserID" name="finCheckUserID" onchange="updateCheckUser('<%=vChemoId %>')" 
						<%	if (vFinCheckUser.length()>0 && !isPharManager){%>disabled<%} %>>
					<option value=""></option>
					<%
					ArrayList<ReportableListObject> record1 = getPharmacist();
					ReportableListObject row1 = null;
					if (record1.size() > 0) {
						for (int j = 0; j < record1.size(); j++) {
							row1 = (ReportableListObject) record1.get(j);
					%>
							<option value='<%=row1.getValue(0)%>' 
							<%if(vFinCheckUser.equals(row1.getValue(0))){%>selected<%} %>> 
							<%=row1.getValue(1)%></option> 
					<%
						}
					}
					%>
				</select>
<%		} %>
			</td>
			<td class="finalColumn">
<%		if(vReadyDate == null || vReadyDate.length()<=0){ 
			if(diff6 < 30*ms){
%>
			<span id="<%=status_Ready %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Ready %>', true)" >&nbsp;</span>
<%			}else { %>
			<span id="<%=status_Ready %>-<%=vChemoId %>" class="chemoProcess alertStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Ready %>', true)" >&nbsp;</span>
<%		
			}
		} else { 
			dReadyDate = format.parse(vReadyDate);
			diff8 = today.getTime() - dReadyDate.getTime();
			timespan = dReadyDate.getTime() - dCleanRoomDate.getTime(); 
%>		
			<span id="<%=status_Ready %>-<%=vChemoId %>" class="chemoProcess <%if(timespan>30*ms){ %>completedLateStep<%}else{ %>completedStep<%} %>" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Ready %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Ready %>', true)" >
				<%=vReadyDate %>
				<% if(vReadyRemark == null || vReadyRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%		} %>
			</td>
			<td class="finalColumn">
<%		if(vDeliveryDate == null || vDeliveryDate.length()<=0){ 
			if(diff8 < 5*ms){
%>
			<span id="<%=status_Delivery %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Delivery %>', true)" >&nbsp;</span>
<%			}else { %>
			<span id="<%=status_Delivery %>-<%=vChemoId %>" class="chemoProcess alertStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Delivery %>', true)" >&nbsp;</span>
<%		
			}
		} else {
			dDeliveryDate = format.parse(vDeliveryDate);
			timespan = dDeliveryDate.getTime() - dReadyDate.getTime(); 
%>		
			<span id="<%=status_Delivery %>-<%=vChemoId %>" class="chemoProcess <%if(timespan>5*ms){ %>completedLateStep<%}else{ %>completedStep<%} %>" 
				ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Delivery %>', false)" 
				onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Delivery %>', true)" >
				<%=vDeliveryDate %>
				<% if(vDeliveryRemark == null || vDeliveryRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%		} %>
			</td>
			<td>
<%		if("Y".equals(vHasCounseling)){ 
			if(vCounselingDate == null || vCounselingDate.length()<=0){%>
			<span id="<%=status_Counseling %>-<%=vChemoId %>" class="chemoProcess incompletedStep">
				&nbsp;
			</span>
<%			}else{ %>			
			<span id="<%=status_Counseling %>-<%=vChemoId %>" class="chemoProcess incompletedStep">
				<%=vCounselingDate %>
			</span>
<%			}
		} else { %>		
			<span id="<%=status_Counseling %>-<%=vChemoId %>" class="chemoProcess graybox">
				&nbsp;
			</span>
<%		} %>
			</td>
<%
		if(showInfo){
%>
			<td><%=vNextDate %></td>
<%		}else{ 
%>
			<td>&nbsp;</td>
<%		}
%>
		<td class="hiddenC cps"><%=vStatus %></td>
		</tr>		
<%		
	}
%>
<script>
	updateCompleted();
	$("#ytdDate").val("<%=ytdDate %>");
	$("#tmrDate").val("<%=tmrDate %>");
</script>
<%} else { %>
	No Chemotherapy process.
	<script>
		$("#ytdDate").val("<%=ytdDate %>");
		$("#tmrDate").val("<%=tmrDate %>");
	</script>
<%} %>