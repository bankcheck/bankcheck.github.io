<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@	page import="java.text.*"%>

<%!
	String units[];

	private ArrayList<ReportableListObject> fetchBedOverviewStatus(String[] param) {
		return UtilDBWeb.getFunctionResults("HAT_BED_STATUS", param);
	}

	private ArrayList<ReportableListObject> fetchBedOverviewStatus(String startDate, String endDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT HAT_PERIOD, HAT_ACMCODE, HAT_WRDCODE, HAT_TOTAL, HAT_BOOKED, HAT_OCCUPIED, HAT_AVAILABLE ");
		sqlStr.append("FROM   HAT_BED_STAT ");
		sqlStr.append("WHERE  HAT_PERIOD >= TO_DATE('");
		sqlStr.append(startDate);
		sqlStr.append(" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') AND ");
		sqlStr.append("HAT_PERIOD <= TO_DATE('");
		sqlStr.append(endDate);
		sqlStr.append(" 23:59:59', 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("ORDER BY HAT_PERIOD, HAT_WRDCODE, HAT_ACMCODE");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
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
	
	private String fetchWardName(String wrdCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select WRDNAME ");
		sqlStr.append("from WARD@IWEB ");
		sqlStr.append("WHERE  WRDCODE = '");
		sqlStr.append(wrdCode);
		sqlStr.append("'");
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			ReportableListObject row = null;
			row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		}
		
		return "";
	}
	
	private void calcSpecialty(ArrayList<String> currentList, boolean today, ArrayList<String> booked_detail) {
		String curClass = null;
		int curClassTotal = 0;
		int newRecord = 0;
		
		for(int i = 0; i < currentList.size() - newRecord; i++) {
			//System.out.println("i: "+String.valueOf(i)+" currentList.size() - newRecord: "+ String.valueOf(currentList.size() - newRecord));
			String tmp[] = currentList.get(i).split("_");
			
			if(curClass == null) {
				curClass = tmp[0];
				if(today) {
					if(!fetchWardName(tmp[1]).equals(""))
						curClassTotal += Integer.parseInt(tmp[2]);
					else
						curClassTotal = 0;
				}else
					curClassTotal += Integer.parseInt(tmp[2]);
			}
			else if(curClass.equals(tmp[0])) {
				if(today) {
					if(!fetchWardName(tmp[1]).equals(""))
						curClassTotal += Integer.parseInt(tmp[2]);
				}else
					curClassTotal += Integer.parseInt(tmp[2]);
			}
			else if(!curClass.equals(tmp[0])) {
				if(today) {
					if(booked_detail != null)
						booked_detail.add(i-2, "-_-_-");
					currentList.add(i-2, curClass+'_'+units[7]+'_'+curClassTotal);
					i++;
				}
				else {
					currentList.add(currentList.size(), curClass+'_'+tmp[1]+'_'+curClassTotal);
					newRecord++;
				}
				curClass = tmp[0];
				curClassTotal = Integer.parseInt(tmp[2]);
			}
			
			if(currentList.size() - i - newRecord == 1) {
				if(today) {
					if(booked_detail != null)
						booked_detail.add(currentList.size()-2, "-_-_-");
					currentList.add(currentList.size()-2, curClass+'_'+units[7]+'_'+curClassTotal);
				}else {
					currentList.add(currentList.size(), curClass+'_'+tmp[1]+'_'+curClassTotal);
					newRecord++;
				}
				i++;
			}
		}
	}
	
	private int getDiffBetweenSun() {
		Calendar cal = Calendar.getInstance();
		
		SimpleDateFormat sdf = new SimpleDateFormat("E", Locale.ENGLISH);
		String theDay = sdf.format(cal.getTime());
		if(theDay.equals("Sun")) {
			return 0;
		}
		if(theDay.equals("Mon")) {
			return 1;
		}
		if(theDay.equals("Tue")) {
			return 2;
		}
		if(theDay.equals("Wed")) {
			return 3;
		}
		if(theDay.equals("Thu")) {
			return 4;
		}
		if(theDay.equals("Fri")) {
			return 5;
		}
		if(theDay.equals("Sat")) {
			return 6;
		}
		return 0;
	}
%>

<%
String today = request.getParameter("today");
String avail = request.getParameter("available");
String afterToday = request.getParameter("add");
String ward = request.getParameter("ward");
String showAll = request.getParameter("showAll");
String showTotal = request.getParameter("showTotal");
String sex = request.getParameter("sex");

int showDays = 4;
int DiffBetweenSun = getDiffBetweenSun();
String classes[] = {"VIP", "Private", "Semi-Private", "Standard", "Total"};
units = new String[]{"ICU", "IU", "Medical", "OB", "Pediatric", "Short Stay", "Surgical", "Specialty", "OT<br/>Cases", "CCIC<br/>Cases"};
String types[] = {"Available", "Booked", "Occupied", "Total"};
String gender[] = {"M/F", "M", "F"};

ArrayList<String> available = new ArrayList<String>();
ArrayList<String> booked = new ArrayList<String>();
ArrayList<String> occupied = new ArrayList<String>();
ArrayList<String> vip = new ArrayList<String>();
ArrayList<String> pri = new ArrayList<String>();
ArrayList<String> semi_pri = new ArrayList<String>();
ArrayList<String> standard = new ArrayList<String>();
ArrayList<String> total = new ArrayList<String>();
ArrayList<String> booked_detail = new ArrayList<String>();

int totalAvailable[][] = new int[units.length-2][8];

//System.out.println("------------------------------------------------------------------");
//System.out.println("Start processing: "+ new Date());
if(today.equals("true") && avail.equals("false")) {// bed overview by date
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH, Integer.parseInt(afterToday));
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
	String date = sdf.format(cal.getTime());
%>
	<tr style="height:46px">
		<td colspan="2">
			<div style="float:left; width:100%;">
				<div style="float:left"><input id="showAllCol" type="checkbox"/ <%=showAll.equals("true")?"checked":"" %>><label>OB & Pediatric</label></div>
			</div>
			<div style="float:left; width:100%;">
				<div style="float:left"><input id="showTotal" type="checkbox"/ <%=showTotal.equals("true")?"checked":"" %>><label>Total</label></div>
			</div>
		</td>
		<td class="changeCol" style="font-weight:bold; background-color:#FFCBB3; width:11%; border-style:outset; border-width:1px;" colspan='<%=units.length-2%>'>Wards</td>
		<td></td>
		<td style="font-weight:bold; background-color:#CDCD9A; width:11%; border-style:outset; border-width:1px;" colspan='2'>Booked Cases</td>
		<td></td>
	</tr>
	<tr>
		<td style="width:150px;"></td>
		<%-- 
		<td><img class='edit_img' src='../images/edit.gif' title='edit' alt='edit' style='cursor:pointer; cursor:hand;'/></td>
		--%> 
		<td><img class='prev_img' src='../images/arrow-left.png' title='prev' alt='prev' style='cursor:pointer; cursor:hand;'/></td>
<%
	for(String unit: units) {
		if(unit.indexOf("OT") > -1) {
%>
			<td></td>
<%
		}
		if(true) {//!unit.equals("Specialty")
			if(showAll.equals("true")) {
%>
				<td class="title <%=unit.equals("Specialty")?"specialty":"" %> <%=(unit.indexOf("OT") > -1)?"ot":"" %> <%=(unit.indexOf("CCIC") > -1)?"ccic":"" %>" style="width:11%; border-style:outset; border-width:1px;"><%=unit %></td>
<%
			}else {
%>
				<td class="title <%=unit.equals("Specialty")?"specialty":"" %> <%=(unit.indexOf("OT") > -1)?"ot":"" %> <%=(unit.indexOf("CCIC") > -1)?"ccic":"" %>" style="width:11%; border-style:outset; border-width:1px; <%=(unit.equals("OB") || unit.equals("Pediatric"))?"display:none":""%>"><%=unit %></td>
<%			
			}
		}else {
%>
			<td class="title <%=(unit.indexOf("OT") > -1)?"ot":"" %> <%=(unit.indexOf("CCIC") > -1)?"ccic":"" %>" style="width:11%; border-style:outset; border-width:1px; display:none;"><%=unit %></td>
<%
		}
	}

%>
		<td><img class='next_img' src='../images/arrow-right.png' title='next' alt='next' style='cursor:pointer; cursor:hand;'/></td>
	</tr>
	<tr>
		<td style="width:150px;">&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan='<%=units.length+1 %>' class="changeCol title" style="width:11%; border-style:outset; border-width:1px;">
			<span class="date"><%=date %></span><button id="edit_<%=date %>" class = "edit_Btn ui-button ui-widget ui-state-default ui-corner-all">edit</button>
		</td>
	</tr>
<%
	String param[] = {date, "1"};
	//System.out.println("Before call DB: "+ new Date());
	ArrayList<ReportableListObject> record = fetchBedOverviewStatus(param);
	//System.out.println("After call DB: "+ new Date());
	ReportableListObject row = null;
	sdf = new SimpleDateFormat("yyyy/MM/dd", Locale.ENGLISH);
	date = sdf.format(cal.getTime());
	//System.out.println("Before construct data: "+ new Date());
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			//if(row.getValue(0).toString().replaceAll("-", "/").indexOf(date) > -1){
				total.add(fetchAcmName(row.getValue(1))+"_"+row.getValue(2)+"_"+row.getValue(3));
				booked.add(fetchAcmName(row.getValue(1))+"_"+row.getValue(2)+"_"+row.getValue(4));
				occupied.add(fetchAcmName(row.getValue(1))+"_"+row.getValue(2)+"_"+row.getValue(8));
				available.add(fetchAcmName(row.getValue(1))+"_"+row.getValue(2)+"_"+row.getValue(9));
				booked_detail.add(row.getValue(5)+"_"+row.getValue(6)+"_"+row.getValue(7));
			//}
			//else {
			//	break;
			//}
		}
	}
	
	//System.out.println("After Contruct data: "+ new Date());
	//System.out.println("-------------TOTAL-----------------");
	for(int j = 0; j < total.size(); j++) {
		//System.out.println(total.get(j));
	}
	//System.out.println("-------------BOOKED-----------------");
	for(int j = 0; j < booked.size(); j++) {
		//System.out.println(booked.get(j));
	}
	//System.out.println("-------------OCCUPIED-----------------");
	for(int j = 0; j < occupied.size(); j++) {
		//System.out.println(occupied.get(j));
	}
	//System.out.println("-------------AVAILABLE-----------------");
	for(int j = 0; j < available.size(); j++) {
		//System.out.println(available.get(j));
	}
	//System.out.println("-------------Booked Details-----------------"+booked_detail.size());
	for(int j = 0; j < booked_detail.size(); j++) {
		//System.out.println(booked_detail.get(j));
	}
}
else if(today.equals("false") && avail.equals("false")) {// bed overview by specialty
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdf;
	DiffBetweenSun = 0;
%>
	<tr>
		<td rowspan="2">
				<div style="float:left; width:100%;">
					<div style="float:left"><input name="ward" type="radio" value="All"/><label>All</label></div>
				</div>
<%		
			for(int i = 0; i < 6; i++) {
%>
				<div style="float:left; width:100%;">
					<div style="float:left"><input index='<%=i %>' name="ward" type="radio" value="<%=units[i]%>"/><label><%=units[i]%></label></div>
				</div>
<%		
			}
%>
		</td><td>&nbsp;</td><td colspan="7"><div id="targetWardLabel"></div></td></tr>
	<tr>
		<%-- 
		<td><img class='edit_img' src='../images/edit.gif' title='edit' alt='edit' style='cursor:pointer; cursor:hand;'/></td>
		--%>
		<td><img class='prev_img' src='../images/arrow-left.png' title='prev' alt='prev' style='cursor:pointer; cursor:hand;'/></td>
<%
	for(int day = 0; day < showDays; day++) {
		cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_MONTH, day + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
		sdf = new SimpleDateFormat("E", Locale.ENGLISH);
		String theDay = sdf.format(cal.getTime());
%>
		<td class="title" style="width:11%; border-style:outset; border-width:1px;"><%=theDay %></td>
<%
	}
%>
	<td><img class='next_img' src='../images/arrow-right.png' title='next' alt='next' style='cursor:pointer; cursor:hand;'/></td></tr>
	<tr><td>&nbsp;</td><td>&nbsp;</td>
<%
	for(int day = 0; day < showDays; day++) {
		cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_MONTH, day + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
		sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		String date = sdf.format(cal.getTime());
%>
		<td class="title" style="width:11%; border-style:outset; border-width:1px;">
			<span class="dateHeader" add="<%=day + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun %>"><%=date %></span><button id="edit_<%=date %>" class = "edit_Btn ui-button ui-widget ui-state-default ui-corner-all">edit</button>
		</td>
<%
	}
%>
	</tr>
<%
	cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH, (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
	
	sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
	String date = sdf.format(cal.getTime());
	
    String param[] = {date, String.valueOf(showDays)};
    //System.out.println("Before call DB: "+ new Date());
	ArrayList<ReportableListObject> record = fetchBedOverviewStatus(param);
	//System.out.println("After call DB: "+ new Date());
	ReportableListObject row = null;
	
	sdf = new SimpleDateFormat("yyyy/MM/dd", Locale.ENGLISH);
	
	if(ward.indexOf("ICU") > -1)
		ward = "CARE";
	else if(ward.indexOf("OB") > -1)
		ward = "OBSTETRIC";
	else if(ward.indexOf("IU") > -1)
		ward = "INTEGRATED";
	
	int distance = 1;
	//System.out.println("Before construct data: "+ new Date());
	if (record.size() > 0) {
		ArrayList<String> tempTotal = new ArrayList<String>();
		ArrayList<String> tempBooked = new ArrayList<String>();
		ArrayList<String> tempOcc = new ArrayList<String>();
		ArrayList<String> tempAvail = new ArrayList<String>();
		
		for (int i = 0, day = 0; i < record.size(); i++) {
			cal = Calendar.getInstance();
			cal.add(Calendar.DAY_OF_MONTH, day + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
			date = sdf.format(cal.getTime());
			
			row = (ReportableListObject) record.get(i);
			if(row.getValue(0).toString().replaceAll("-", "/").indexOf(date) > -1){
				SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
				String date2 = sdf2.format(cal.getTime());

				if((ward.toUpperCase().equals("ALL") || fetchWardName(row.getValue(2)).indexOf(ward.toUpperCase()) > -1) 
						&& !fetchWardName(row.getValue(2)).equals("")) {
					tempTotal.add(fetchAcmName(row.getValue(1))+"_"+date2+"_"+row.getValue(3));
					tempBooked.add(fetchAcmName(row.getValue(1))+"_"+date2+"_"+row.getValue(4));
					tempOcc.add(fetchAcmName(row.getValue(1))+"_"+date2+"_"+row.getValue(8));
					tempAvail.add(fetchAcmName(row.getValue(1))+"_"+date2+"_"+row.getValue(9));
				}
			}
			else {
				calcSpecialty(tempTotal, today.equals("true"), null);
				calcSpecialty(tempBooked, today.equals("true"), null);
				calcSpecialty(tempOcc, today.equals("true"), null);
				calcSpecialty(tempAvail, today.equals("true"), null);
				
				for(int j = tempTotal.size() - 4, k = 0; j < tempTotal.size(); j++, k++)
					total.add((distance-1) + k * distance, tempTotal.get(j));
				for(int j = tempBooked.size() - 4, k = 0; j < tempBooked.size(); j++, k++)
					booked.add((distance-1) + k * distance, tempBooked.get(j));
				for(int j = tempOcc.size() - 4, k = 0; j < tempOcc.size(); j++, k++)
					occupied.add((distance-1) + k * distance, tempOcc.get(j));
				for(int j = tempAvail.size() - 4, k = 0; j < tempAvail.size(); j++, k++)
					available.add((distance-1) + k * distance, tempAvail.get(j));
				
				tempTotal = new ArrayList<String>();
				tempBooked = new ArrayList<String>();
				tempOcc = new ArrayList<String>();
				tempAvail = new ArrayList<String>();
				distance++;
				day++;
				i--;
			}
		}
		
		calcSpecialty(tempTotal, today.equals("true"), null);
		calcSpecialty(tempBooked, today.equals("true"), null);
		calcSpecialty(tempOcc, today.equals("true"), null);
		calcSpecialty(tempAvail, today.equals("true"), null);
		
		for(int j = tempTotal.size() - 4, k = 0; j < tempTotal.size(); j++, k++)
			total.add((distance-1) + k * distance, tempTotal.get(j));
		for(int j = tempBooked.size() - 4, k = 0; j < tempBooked.size(); j++, k++)
			booked.add((distance-1) + k * distance, tempBooked.get(j));
		for(int j = tempOcc.size() - 4, k = 0; j < tempOcc.size(); j++, k++)
			occupied.add((distance-1) + k * distance, tempOcc.get(j));
		for(int j = tempAvail.size() - 4, k = 0; j < tempAvail.size(); j++, k++)
			available.add((distance-1) + k * distance, tempAvail.get(j));
		//System.out.println("After construct data: "+ new Date());
	}
	//System.out.println("-------------TOTAL-----------------");
	for(int j = 0; j < total.size(); j++) {
		//System.out.println(total.get(j));
	}
	//System.out.println("-------------BOOKED-----------------");
	for(int j = 0; j < booked.size(); j++) {
		//System.out.println(booked.get(j));
	}
	//System.out.println("-------------OCCUPIED-----------------");
	for(int j = 0; j < occupied.size(); j++) {
		//System.out.println(occupied.get(j));
	}
	//System.out.println("-------------AVAILABLE-----------------");
	for(int j = 0; j < available.size(); j++) {
		//System.out.println(available.get(j));
	}
}
else if(today.equals("false") && avail.equals("true") && sex.equals("false")){// available bed
	for(int i = 0; i < units.length-2; i++) {
		for(int j = 0; j < 8; j++) {
			totalAvailable[i][j] = 0;
		}
	}
	Calendar cal;
	SimpleDateFormat sdf;
	DiffBetweenSun = 0;
%>
	<tr>
		<td>&nbsp;</td>
		<%-- 
		<td><img class='edit_img' src='../images/edit.gif' title='edit' alt='edit' style='cursor:pointer; cursor:hand;'/></td>
		--%>
		<td><img class='prev_img' src='../images/arrow-left.png' title='prev' alt='prev' style='cursor:pointer; cursor:hand;'/></td>
<%
	for(int day = 0; day < showDays; day++) {
		cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_MONTH, day + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
		sdf = new SimpleDateFormat("E", Locale.ENGLISH);
		String theDay = sdf.format(cal.getTime());
%>
		<td class="title" style="width:11%; border-style:outset; border-width:1px;"><%=theDay %></td>
<%
	}
%>
	<td><img class='next_img' src='../images/arrow-right.png' title='next' alt='next' style='cursor:pointer; cursor:hand;'/></td></tr>
	<tr><td>&nbsp;</td><td>&nbsp;</td>
<%
	for(int day = 0; day < showDays; day++) {
		cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_MONTH, day + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
		sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		String date = sdf.format(cal.getTime());
%>
		<td class="title" style="width:11%; border-style:outset; border-width:1px;">
			<%=date %>
			<%--<button id="edit_<%=date %>" class = "edit_Btn ui-button ui-widget ui-state-default ui-corner-all">edit</button> --%>
		</td>
<%
	}
%>
	</tr>
<%
	cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH, (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
	sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
	String date1 = sdf.format(cal.getTime());
	cal.add(Calendar.DAY_OF_MONTH, 4);
	String date2 = sdf.format(cal.getTime());
	
	String param[] = {date1, String.valueOf(showDays)};
	//System.out.println("Before call DB: "+ new Date());
	ArrayList<ReportableListObject> record = fetchBedOverviewStatus(param);
	//System.out.println("After call DB: "+ new Date());
	ReportableListObject row = null;
	ArrayList<String> wardName = new ArrayList<String>();
	
	sdf = new SimpleDateFormat("yyyy/MM/dd", Locale.ENGLISH);
	ArrayList<String> tempVip = new ArrayList<String>();
	ArrayList<String> tempPri = new ArrayList<String>();
	ArrayList<String> tempSemi = new ArrayList<String>();
	ArrayList<String> tempStand = new ArrayList<String>();
	int day = 0;
	//System.out.println("Before construct data: "+ new Date());
	if (record.size() > 0) {
		String date;
		for (int i = 0; i < record.size(); i++) {
			cal = Calendar.getInstance();
			cal.add(Calendar.DAY_OF_MONTH, day + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
			date = sdf.format(cal.getTime());
			
			row = (ReportableListObject) record.get(i);
			//System.out.println(row.getValue(0)+" "+row.getValue(1)+" "+row.getValue(2));
			
			if(row.getValue(0).toString().replaceAll("-", "/").indexOf(date) > -1){
				//System.out.println("ADD");
				SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
				String date3 = sdf2.format(cal.getTime());

				if(!fetchWardName(row.getValue(2)).equals("")) {
					if(wardName.indexOf(row.getValue(2)) == -1)
						wardName.add(row.getValue(2));
					
					if(fetchAcmName(row.getValue(1)).equals("VIP")) {
						tempVip.add(row.getValue(2)+"_"+date3+"_"+row.getValue(9));
					}
					if(fetchAcmName(row.getValue(1)).equals("PRIVATE")) {
						tempPri.add(row.getValue(2)+"_"+date3+"_"+row.getValue(9));
					}
					if(fetchAcmName(row.getValue(1)).equals("SEMI-PRIVATE")) {
						tempSemi.add(row.getValue(2)+"_"+date3+"_"+row.getValue(9));
					}
					if(fetchAcmName(row.getValue(1)).equals("STANDARD")) {
						tempStand.add(row.getValue(2)+"_"+date3+"_"+row.getValue(9));
					}
				}
			}
			else {
				//System.out.println("NOT ADD");
				for(int j = tempVip.size() - (units.length - 3), k = 0; j < tempVip.size(); j++, k++)
					totalAvailable[k][day] += Integer.parseInt(tempVip.get(j).split("_")[2]);
				for(int j = tempPri.size() - (units.length - 3), k = 0; j < tempPri.size(); j++, k++)
					totalAvailable[k][day] += Integer.parseInt(tempPri.get(j).split("_")[2]);
				for(int j = tempSemi.size() - (units.length - 3), k = 0; j < tempSemi.size(); j++, k++)
					totalAvailable[k][day] += Integer.parseInt(tempSemi.get(j).split("_")[2]);
				for(int j = tempStand.size() - (units.length - 3), k = 0; j < tempStand.size(); j++, k++)
					totalAvailable[k][day] += Integer.parseInt(tempStand.get(j).split("_")[2]);
				day++;
				i--;
			}
		}
	}
	
	//System.out.println("totalAvailable");
	for(int j = tempVip.size() - (units.length - 3), k = 0; j < tempVip.size(); j++, k++)
		totalAvailable[k][day] += Integer.parseInt(tempVip.get(j).split("_")[2]);
	for(int j = tempPri.size() - (units.length - 3), k = 0; j < tempPri.size(); j++, k++)
		totalAvailable[k][day] += Integer.parseInt(tempPri.get(j).split("_")[2]);
	for(int j = tempSemi.size() - (units.length - 3), k = 0; j < tempSemi.size(); j++, k++)
		totalAvailable[k][day] += Integer.parseInt(tempSemi.get(j).split("_")[2]);
	for(int j = tempStand.size() - (units.length - 3), k = 0; j < tempStand.size(); j++, k++)
		totalAvailable[k][day] += Integer.parseInt(tempStand.get(j).split("_")[2]);
	
	//System.out.println("total");
	for(int i = 0; i < wardName.size(); i++) {
		for(int day1 = 0; day1 < showDays; day1++) {
			cal = Calendar.getInstance();
			cal.add(Calendar.DAY_OF_MONTH, day1 + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
			sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
			String date = sdf.format(cal.getTime());
			
			total.add(wardName.get(i)+"_"+date+"_"+totalAvailable[i][day1]);
		}
	}
	//System.out.println("-----------------------Total-----------------------");
	for(int i = 0; i < total.size(); i++) {
		//System.out.println(String.valueOf(i)+": "+total.get(i));
	}
	
	//System.out.println("move");
	for(int i = 0, distance = 1, counter = 0; i < tempPri.size(); i++) {
		//System.out.println("i: "+i);
		vip.add((distance-1) + counter * distance, tempVip.get(i));
		pri.add((distance-1) + counter * distance, tempPri.get(i));
		semi_pri.add((distance-1) + counter * distance, tempSemi.get(i));
		standard.add((distance-1) + counter * distance, tempStand.get(i));
		
		counter = (i+1)%(units.length-3);
		if((i+1)%(units.length-3) == 0)
			distance++;
	}
	//System.out.println("After construct data: "+ new Date());
	//System.out.println("-----------------------Ward Name-----------------------");
	for(int i = 0; i < wardName.size(); i++) {
		//System.out.println(wardName.get(i));
	}
	//System.out.println("-----------------------Vip-----------------------");
	for(int i = 0; i < vip.size(); i++) {
		//System.out.println(String.valueOf(i)+": "+vip.get(i));
	}
	//System.out.println("-----------------------Private-----------------------");
	for(int i = 0; i < pri.size(); i++) {
		//System.out.println(String.valueOf(i)+": "+pri.get(i));
	}
	//System.out.println("-----------------------Semi-----------------------");
	for(int i = 0; i < semi_pri.size(); i++) {
		//System.out.println(String.valueOf(i)+": "+semi_pri.get(i));
	}
	//System.out.println("-----------------------Standard-----------------------");
	for(int i = 0; i < standard.size(); i++) {
		//System.out.println(String.valueOf(i)+": "+standard.get(i));
	}
	//System.out.println("-----------------------Total-----------------------");
	for(int i = 0; i < total.size(); i++) {
		//System.out.println(String.valueOf(i)+": "+total.get(i));
	}
}
else if(today.equals("false") && avail.equals("true") && sex.equals("true")) {
	Calendar cal;
	SimpleDateFormat sdf;
	DiffBetweenSun = 0;
%>
	<tr>
		<td rowspan="2">
<%		
			for(int i = 0; i < 6; i++) {
%>
				<div style="float:left; width:100%;">
					<div style="float:left"><input index="<%=i %>" name="ward" type="radio" value="<%=units[i]%>"/><label><%=units[i]%></label></div>
				</div>
<%		
			}
%>
		</td><td>&nbsp;</td><td colspan="7"><div id="targetWardLabel"></div></td></tr>
	
	<tr>
		<%-- 
		<td><img class='edit_img' src='../images/edit.gif' title='edit' alt='edit' style='cursor:pointer; cursor:hand;'/></td>
		--%>
		<td><img class='prev_img' src='../images/arrow-left.png' title='prev' alt='prev' style='cursor:pointer; cursor:hand;'/></td>
<%
	for(int day = 0; day < showDays; day++) {
		cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_MONTH, day + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
		sdf = new SimpleDateFormat("E", Locale.ENGLISH);
		String theDay = sdf.format(cal.getTime());
%>
		<td class="title" style="width:11%; border-style:outset; border-width:1px;"><%=theDay %></td>
<%
	}
%>
	<td><img class='next_img' src='../images/arrow-right.png' title='next' alt='next' style='cursor:pointer; cursor:hand;'/></td></tr>
	<tr><td>&nbsp;</td><td>&nbsp;</td>
<%
	for(int day = 0; day < showDays; day++) {
		cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_MONTH, day + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
		sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		String date = sdf.format(cal.getTime());
%>
		<td class="title" style="width:11%; border-style:outset; border-width:1px;">
			<%=date %>
			<%--<button id="edit_<%=date %>" class = "edit_Btn ui-button ui-widget ui-state-default ui-corner-all">edit</button> --%>
		</td>
<%
	}
%>
	</tr>
<%
	cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH, (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
	sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
	String date = sdf.format(cal.getTime());
	
	String param[] = {date, String.valueOf(showDays)};
	//System.out.println("Before call DB: "+ new Date());
	ArrayList<ReportableListObject> record = fetchBedOverviewStatus(param);
	//System.out.println("After call DB: "+ new Date());
	ReportableListObject row = null;
	ArrayList<String> wardName = new ArrayList<String>();
	
	sdf = new SimpleDateFormat("yyyy/MM/dd", Locale.ENGLISH);
	
	if(ward.indexOf("ICU") > -1)
		ward = "CARE";
	else if(ward.indexOf("OB") > -1)
		ward = "OBSTETRIC";
	else if(ward.indexOf("IU") > -1)
		ward = "INTEGRATED";
	
	//System.out.println("Before construct data: "+ new Date());
	if (record.size() > 0) {
		ArrayList<String> tempVip = new ArrayList<String>();
		ArrayList<String> tempPri = new ArrayList<String>();
		ArrayList<String> tempSemi = new ArrayList<String>();
		ArrayList<String> tempStand = new ArrayList<String>();
		
		for (int i = 0, day = 0; i < record.size(); i++) {
			cal = Calendar.getInstance();
			cal.add(Calendar.DAY_OF_MONTH, day + (Integer.parseInt(afterToday) * showDays) - DiffBetweenSun);
			date = sdf.format(cal.getTime());
			//System.out.println("date: "+date);
			
			
			row = (ReportableListObject) record.get(i);
			
			//System.out.println("row: "+row.getValue(0).toString().replaceAll("-", "/"));
			if(row.getValue(0).toString().replaceAll("-", "/").indexOf(date) > -1){
				SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
				String date2 = sdf2.format(cal.getTime());
				//System.out.println("date2: "+date2);
				if((fetchWardName(row.getValue(2)).indexOf(ward.toUpperCase()) > -1) 
						&& !fetchWardName(row.getValue(2)).equals("")) {
					
					if(fetchAcmName(row.getValue(1)).equals("VIP")) {
						tempVip.add(gender[0]+"_"+date2+"_"+row.getValue(10));
						tempVip.add(gender[1]+"_"+date2+"_"+row.getValue(11));
						tempVip.add(gender[2]+"_"+date2+"_"+row.getValue(12));
					}
					if(fetchAcmName(row.getValue(1)).equals("PRIVATE")) {
						tempPri.add(gender[0]+"_"+date2+"_"+row.getValue(10));
						tempPri.add(gender[1]+"_"+date2+"_"+row.getValue(11));
						tempPri.add(gender[2]+"_"+date2+"_"+row.getValue(12));
					}
					if(fetchAcmName(row.getValue(1)).equals("SEMI-PRIVATE")) {
						tempSemi.add(gender[0]+"_"+date2+"_"+row.getValue(10));
						tempSemi.add(gender[1]+"_"+date2+"_"+row.getValue(11));
						tempSemi.add(gender[2]+"_"+date2+"_"+row.getValue(12));
					}
					if(fetchAcmName(row.getValue(1)).equals("STANDARD")) {
						tempStand.add(gender[0]+"_"+date2+"_"+row.getValue(10));
						tempStand.add(gender[1]+"_"+date2+"_"+row.getValue(11));
						tempStand.add(gender[2]+"_"+date2+"_"+row.getValue(12));
					}
				}
			}
			else {
				day++;
				i--;
			}
		}
		
		for(int i = 0, distance = 1, counter = 0; i < tempPri.size(); i++) {
			vip.add((distance-1) + counter * distance, tempVip.get(i));
			pri.add((distance-1) + counter * distance, tempPri.get(i));
			semi_pri.add((distance-1) + counter * distance, tempSemi.get(i));
			standard.add((distance-1) + counter * distance, tempStand.get(i));
			
			counter = (i+1)%3;
			if((i+1)%3 == 0)
				distance++;
		}
		
		//System.out.println("-----------------------Vip-----------------------");
		for(int i = 0; i < vip.size(); i++) {
			//System.out.println(String.valueOf(i)+": "+vip.get(i));
		}
		//System.out.println("-----------------------Private-----------------------");
		for(int i = 0; i < pri.size(); i++) {
			//System.out.println(String.valueOf(i)+": "+pri.get(i));
		}
		//System.out.println("-----------------------Semi-----------------------");
		for(int i = 0; i < semi_pri.size(); i++) {
			//System.out.println(String.valueOf(i)+": "+semi_pri.get(i));
		}
		//System.out.println("-----------------------Standard-----------------------");
		for(int i = 0; i < standard.size(); i++) {
			//System.out.println(String.valueOf(i)+": "+standard.get(i));
		}
		//System.out.println("-----------------------Total-----------------------");
		for(int i = 0; i < total.size(); i++) {
			//System.out.println(String.valueOf(i)+": "+total.get(i));
		}
	}
}

//print ui
if(avail.equals("false")) {
	//System.out.println("Before generate ui: "+ new Date());
	for(String type: types) {
		ArrayList<String> currentList = null;
		int[] sum = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
		int[] totalSum = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
		int stepOver = (today.equals("true"))?units.length:showDays;
		DecimalFormat twoDigit = new DecimalFormat("#,##0");
		
		if(type.equals("Available"))
			currentList = available;
		else if(type.equals("Booked"))
			currentList = booked;
		else if(type.equals("Occupied"))
			currentList = occupied;
		else if(type.equals("Total")) {
			currentList = total;
		}

		//calc specialty
		if(today.equals("true") && !type.equals("Total")) {
			if(type.equals("Booked"))
				calcSpecialty(currentList, today.equals("true"), booked_detail);
			else
				calcSpecialty(currentList, today.equals("true"), null);
			
			if(type.equals("Occupied"))
				calcSpecialty(total, today.equals("true"), null);
		}
		
		//System.out.println(type);
		for(int i = 0; i < currentList.size(); i++) {
			//System.out.println(currentList.get(i));
		}
		//System.out.println(type);
		if(booked_detail!= null) {
			for(int i = 0; i < booked_detail.size(); i++) {
				//System.out.println(booked_detail.get(i));
			}
		}
	
	%>
			<tr><td style="width:150px;">&nbsp;</td><td style='border-style:none; border-width:1px;'></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
	<%
		
		for(int i = 0; i < currentList.size(); i+=stepOver) {
				//System.out.println("i: "+i);
				if(i == 0) {
		%>
					<tr><td class='<%=type.toLowerCase()%>' rowspan='5' style='width:150px; border-style:outset; border-width:1px;'><%=type %><%=(today.equals("true")&&type.equals("Booked"))?"*<br/><br/>* : Others + OT + CCIC":"" %></td>
		<%
				}else {
		%>	
					<tr>
		<%
				}
			
			for(int j = i, count = 0; j < stepOver + i; j++, count++) {
				//System.out.println("j: "+j);
					String tmp[] = currentList.get(j).split("_");
					//System.out.println(currentList.get(j));
					sum[count] += Integer.parseInt(tmp[2]);
					
					if(type.equals("Occupied")) {
						String totalDetail[] = total.get(j).split("_");
						totalSum[count] += Integer.parseInt(totalDetail[2]);
					}
					
					
					if(j == i) {
		%>
						<td class='<%=type.toLowerCase()%>' style='border-style:outset; border-width:1px;'><%=tmp[0]%></td>
		<%
					}
					if(true) {//!tmp[1].toLowerCase().replaceAll("/", "-").equals("specialty")
						if(tmp[1].toLowerCase().replaceAll("/", "-").equals("ot") ||
								tmp[1].toLowerCase().replaceAll("/", "-").equals("ccic")) {
							if(!type.equals("Booked")) {
								tmp[2] = "";
							}
						}
						if(tmp[1].toLowerCase().replaceAll("/", "-").equals("ot")) {
							//System.out.println("Empty");
		%>
							<td class = "empty"></td>
		<%					
						}
						if(showAll.equals("true")) {
							//System.out.println("showAll");
							if(type.equals("Booked")) {
								//System.out.println("Booked");
								if(today.equals("true")) {
									//System.out.println("today");
									if(tmp[1].toLowerCase().replaceAll("/", "-").equals("ot") ||
											tmp[1].toLowerCase().replaceAll("/", "-").equals("ccic") ||
											tmp[1].toLowerCase().replaceAll("/", "-").equals("specialty")) {
		%>
										<td class="<%=tmp[1].toLowerCase().replaceAll("/", "-")%> <%=type.toLowerCase()%>" id='<%=type.toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase().replaceAll("/", "-")%>' ><%=tmp[2]%></td>
		<%
									} else {
										String detail[] = booked_detail.get(j).split("_");
		%>
										<td class="detail <%=tmp[1].toLowerCase().replaceAll("/", "-")%> <%=type.toLowerCase()%>" id='<%=type.toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase().replaceAll("/", "-")%>' ><%=detail[0]%> + <%=detail[1]%> + <%=detail[2]%></td>
		<%
									}
								}
								else {
									//System.out.println("not today");
		%>
									<td class="<%=type.toLowerCase()%> <%=tmp[1].toLowerCase().replaceAll("/", "-")%>" id='<%=type.toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase().replaceAll("/", "-")%>' ><%=tmp[2]%></td>
		<%							
								}
							}else {
								//System.out.println("not Booked");
								if(type.equals("Occupied")) {
									//System.out.println("Occupied");
									String totalDetail[] = total.get(j).split("_");
									double usage;
									if(Integer.parseInt(totalDetail[2]) == 0)
										usage = 0.00;
									else
										usage = (Integer.parseInt(tmp[2])*100.0/Integer.parseInt(totalDetail[2]));
		%>
									<td class="detail <%=type.toLowerCase()%> <%=tmp[2].equals("")?"empty":tmp[1].toLowerCase().replaceAll("/", "-")%>" id='<%=type.toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase().replaceAll("/", "-")%>' ><%=tmp[2].equals("")?tmp[2]:(tmp[2]+"/"+totalDetail[2]+" ("+twoDigit.format(usage)+"%)")%></td>
		<%					
								}else {
									//System.out.println("not Occupied");
		%>
									<td class="<%=type.toLowerCase()%> <%=tmp[2].equals("")?"empty":tmp[1].toLowerCase().replaceAll("/", "-")%>" id='<%=type.toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase().replaceAll("/", "-")%>' ><%=tmp[2]%></td>
		<%
								}
							}
						}
						else {
							//System.out.println("not showAll");
							if(type.equals("Booked")) {
								//System.out.println("Booked");
								if(today.equals("true")) {
									//System.out.println("today");
									if(tmp[1].toLowerCase().replaceAll("/", "-").equals("ot") ||
											tmp[1].toLowerCase().replaceAll("/", "-").equals("ccic") ||
											tmp[1].toLowerCase().replaceAll("/", "-").equals("specialty")) {
			%>
										<td class="<%=type.toLowerCase()%> <%=tmp[1].toLowerCase().replaceAll("/", "-")%>" id='<%=type.toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase().replaceAll("/", "-")%>' 
											style = '<%=(!tmp[1].toLowerCase().replaceAll("/", "-").equals("ob") && !tmp[1].toLowerCase().replaceAll("/", "-").equals("pd"))?"":"display:none"%>'><%=tmp[2]%></td>
			<%
									} else {
										String detail[] = booked_detail.get(j).split("_");
		%>
										<td class="detail <%=type.toLowerCase()%> <%=tmp[1].toLowerCase().replaceAll("/", "-")%>" id='<%=type.toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase().replaceAll("/", "-")%>' 
											style = '<%=(!tmp[1].toLowerCase().replaceAll("/", "-").equals("ob") && !tmp[1].toLowerCase().replaceAll("/", "-").equals("pd"))?"":"display:none"%>'><%=detail[0]%> + <%=detail[1]%> + <%=detail[2]%></td>
		<%
									}
								}
								else {
									//System.out.println("not today");
			%>
									<td class="<%=type.toLowerCase()%> <%=tmp[1].toLowerCase().replaceAll("/", "-")%>" id='<%=type.toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase().replaceAll("/", "-")%>' 
										style = '<%=(!tmp[1].toLowerCase().replaceAll("/", "-").equals("ob") && !tmp[1].toLowerCase().replaceAll("/", "-").equals("pd"))?"":"display:none"%>'><%=tmp[2]%></td>
			<%
								}
							}
							else {
								//System.out.println("not Booked");
								if(type.equals("Occupied")) {
									//System.out.println("Occupied");
									String totalDetail[] = total.get(j).split("_");
									double usage;
									
									if(Integer.parseInt(totalDetail[2]) == 0)
										usage = 0.00;
									else
										usage = (Integer.parseInt(tmp[2])*100.0/Integer.parseInt(totalDetail[2]));
		%>
									<td class="detail <%=type.toLowerCase()%> <%=tmp[2].equals("")?"empty":tmp[1].toLowerCase().replaceAll("/", "-")%>" id='<%=type.toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase().replaceAll("/", "-")%>' 
										style = '<%=(!tmp[1].toLowerCase().replaceAll("/", "-").equals("ob") && !tmp[1].toLowerCase().replaceAll("/", "-").equals("pd"))?"":"display:none"%>'><%=tmp[2].equals("")?tmp[2]:(tmp[2]+"/"+totalDetail[2]+" ("+twoDigit.format(usage)+"%)")%></td>
		<%
								}else {
									//System.out.println("not Occupied");
		%>
									<td class="<%=type.toLowerCase()%> <%=tmp[2].equals("")?"empty":tmp[1].toLowerCase().replaceAll("/", "-")%>" id='<%=type.toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase().replaceAll("/", "-")%>' 
										style = '<%=(!tmp[1].toLowerCase().replaceAll("/", "-").equals("ob") && !tmp[1].toLowerCase().replaceAll("/", "-").equals("pd"))?"":"display:none"%>'><%=tmp[2]%></td>
		<%
								}
							}
						}
					}
			}
	%>		
			</tr>
	<%	
		}
	
		%>
			<tr>
				<td class='<%=type.toLowerCase()%>' style='border-style:outset; border-width:1px;'>Total</td>
				<td class='<%=type.toLowerCase()%>'><%=(type.equals("Occupied"))?(String.valueOf(sum[0])+"/"+String.valueOf(totalSum[0])+" (")+((totalSum[0] == 0)?"0":twoDigit.format((sum[0]*100.0/totalSum[0])))+"%)":sum[0]%></td>
				<td class='<%=type.toLowerCase()%>'><%=(type.equals("Occupied"))?(String.valueOf(sum[1])+"/"+String.valueOf(totalSum[1])+" (")+((totalSum[1] == 0)?"0":twoDigit.format((sum[1]*100.0/totalSum[1])))+"%)":sum[1]%></td>
				<td class='<%=type.toLowerCase()%>'><%=(type.equals("Occupied"))?(String.valueOf(sum[2])+"/"+String.valueOf(totalSum[2])+" (")+((totalSum[2] == 0)?"0":twoDigit.format((sum[2]*100.0/totalSum[2])))+"%)":sum[2]%></td>
		<% 
				if(!today.equals("true")) {
		%>
					<td class='<%=type.toLowerCase()%>'><%=(type.equals("Occupied"))?(String.valueOf(sum[3])+"/"+String.valueOf(totalSum[3])+" (")+((totalSum[3] == 0)?"0":twoDigit.format((sum[3]*100.0/totalSum[3])))+"%)":sum[3]%></td>
		<% 
				}else {
		%>
					<td class='<%=type.toLowerCase()%>' style = '<%=today.equals("true")?(showAll.equals("true")?"":"display:none"):""%>'><%=(type.equals("Occupied"))?(String.valueOf(sum[3])+"/"+String.valueOf(totalSum[3])+" (")+((totalSum[3] == 0)?"0":twoDigit.format((sum[3]*100.0/totalSum[3])))+"%)":sum[3]%></td>
					<td class='<%=type.toLowerCase()%>' style = '<%=today.equals("true")?(showAll.equals("true")?"":"display:none"):""%>'><%=(type.equals("Occupied"))?(String.valueOf(sum[4])+"/"+String.valueOf(totalSum[4])+" (")+((totalSum[4] == 0)?"0":twoDigit.format((sum[4]*100.0/totalSum[4])))+"%)":sum[4]%></td>
					<td class='<%=type.toLowerCase()%>'><%=(type.equals("Occupied"))?(String.valueOf(sum[5])+"/"+String.valueOf(totalSum[5])+" (")+((totalSum[5] == 0)?"0":twoDigit.format((sum[5]*100.0/totalSum[5])))+"%)":sum[5]%></td>
					<td class='<%=type.toLowerCase()%>'><%=(type.equals("Occupied"))?(String.valueOf(sum[6])+"/"+String.valueOf(totalSum[6])+" (")+((totalSum[6] == 0)?"0":twoDigit.format((sum[6]*100.0/totalSum[6])))+"%)":sum[6]%></td>
					<td class="specialty <%=type.toLowerCase()%>"><%=(type.equals("Occupied"))?(String.valueOf(sum[7])+"/"+String.valueOf(totalSum[7])+" (")+((totalSum[7] == 0)?"0":twoDigit.format((sum[7]*100.0/totalSum[7])))+"%)":sum[7]%></td>
					<td class = "empty" style="width:3%"></td>
					<td class="<%=(type.equals("Booked")?"ot":"empty")%>" ><%=(!type.equals("Booked"))?"":sum[8]%></td>
					<td class="<%=(type.equals("Booked")?"ccic":"empty")%>" ><%=(!type.equals("Booked"))?"":sum[9]%></td>
		<%
				}
		%>	
			</tr>
	<%
	}
	if(today.equals("true")) {
%>
	<%-- 	<tr><td colspan="3"><div style="float:left">* : Others + OT + CCIC</div></td></tr>--%>
<%		
	}
	//System.out.println("After generate ui: "+ new Date());
}else if(sex.equals("false")){
	//System.out.println("Before generate ui: "+ new Date());
	for(int c = 0; c < classes.length; c++) {
		ArrayList<String> currentList = null;
		int[] sum = {0, 0, 0, 0, 0, 0, 0};
		
		if(classes[c].equals("VIP"))
			currentList = vip;
		if(classes[c].equals("Private"))
			currentList = pri;
		else if(classes[c].equals("Semi-Private"))
			currentList = semi_pri;
		else if(classes[c].equals("Standard"))
			currentList = standard;
		else if(classes[c].equals("Total"))
			currentList = total;
		
		for(int i = 0; i < currentList.size(); i+=showDays) {
			if(i == 0) {
	%>
				<tr class='<%=classes[c].toLowerCase()%>'><td rowspan='<%=units.length-2 %>' style='border-style:outset; border-width:1px;'><%=classes[c]%></td>
	<%
			}else {
	%>	
				<tr class='<%=classes[c].toLowerCase()%>'>
	<%
			}
			for(int j = i, count = 0; j < showDays + i; j++, count++) {
				String tmp[] = currentList.get(j).split("_");
				sum[count] += Integer.parseInt(tmp[2]);
				String name = fetchWardName(tmp[0]);
				if(j == i) {
	%>
					<td style='border-style:outset; border-width:1px;'><%=name %></td>
	<%
				}
	%>
				<td id='<%=classes[c].toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase()%>'><%=tmp[2]%></td>
	<%
			}
	%>		
			</tr>
	<%		
		}
	%>
		<tr class='<%=classes[c].toLowerCase()%>'>
			<td style='border-style:outset; border-width:1px;'>TOTAL</td>
			<td><%=sum[0] %></td>
			<td><%=sum[1] %></td>
			<td><%=sum[2] %></td>
			<td><%=sum[3] %></td>
		</tr>
		<tr><td colspan='9'>&nbsp;</td></tr>
	<%
	}

	//System.out.println("After generate ui: "+ new Date());
	//System.out.println("------------------------------------------------------------------");

}
else if(sex.equals("true")) {
	for(int c = 0; c < classes.length; c++) {
		ArrayList<String> currentList = null;
		
		if(classes[c].equals("VIP"))
			currentList = vip;
		if(classes[c].equals("Private"))
			currentList = pri;
		else if(classes[c].equals("Semi-Private"))
			currentList = semi_pri;
		else if(classes[c].equals("Standard"))
			currentList = standard;
		else if(classes[c].equals("Total"))
			return;
		
		for(int i = 0; i < currentList.size(); i+=showDays) {
			if(i == 0) {
	%>
				<tr class='<%=classes[c].toLowerCase()%>'><td rowspan='3' style='border-style:outset; border-width:1px;'><%=classes[c]%></td>
	<%
			}else {
	%>	
				<tr class='<%=classes[c].toLowerCase()%>'>
	<%
			}
			for(int j = i, count = 0; j < showDays + i; j++, count++) {
				String tmp[] = currentList.get(j).split("_");
				//sum[count] += Integer.parseInt(tmp[2]);
				//String name = fetchWardName(tmp[0]);
				if(j == i) {
	%>
					<td style='border-style:outset; border-width:1px;'><%=tmp[0] %></td>
	<%
				}
	%>
				<td id='<%=classes[c].toLowerCase()%>_<%=tmp[0].toLowerCase()%>_<%=tmp[1].toLowerCase()%>'><%=tmp[2]%></td>
	<%
			}
	%>		
			</tr>
	<%		
		}
	%>
		<tr><td colspan='9'>&nbsp;</td></tr>
	<%
	}
}
%>

