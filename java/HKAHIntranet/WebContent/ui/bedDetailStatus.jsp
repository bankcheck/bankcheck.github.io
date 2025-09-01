<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@	page import="java.text.*"%>

<%!
	private ArrayList fetchWardBeds(String[] param) {
		return UtilDBWeb.getFunctionResults("HAT_WARD_STATUS", param);
	}

	private ArrayList<String> fetchAllWardCode() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT W.WRDCODE, WRDNAME ");
		sqlStr.append("FROM WARD@IWEB W ");
		sqlStr.append("WHERE W.WRDNAME not like '%CLOSED%' ");
		sqlStr.append("ORDER BY W.WRDCODE ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		ArrayList<String> wards = new ArrayList<String>();
		ReportableListObject row = null;
		
		if(record.size() > 0) {
			for(int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				wards.add(row.getValue(0)+"_"+row.getValue(1));
			}
		}
		
		return wards;
	}
	
	private ArrayList<String> fetchAllACMCode() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ACMCODE, ACMNAME ");
		sqlStr.append("FROM ACM@IWEB ");
		sqlStr.append("ORDER BY ACMCODE ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		ArrayList<String> acm = new ArrayList<String>();
		ReportableListObject row = null;
		
		if(record.size() > 0) {
			for(int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				acm.add(row.getValue(0)+"_"+row.getValue(1));
			}
		}
		
		return acm;
	}
%>

<%
String afterToday = request.getParameter("add");
String ward = request.getParameter("ward");

ArrayList<String> wards = fetchAllWardCode();
ArrayList<String> acm = fetchAllACMCode();
String[] units = new String[]{"ICU", "IU", "Medical", "OB", "Pediatric", "Surgical", "Specialty", "OT<br/>Cases", "CCIC<br/>Cases"};

ArrayList<String> vip = new ArrayList<String>();
ArrayList<String> pri = new ArrayList<String>();
ArrayList<String> semi_pri = new ArrayList<String>();
ArrayList<String> standard = new ArrayList<String>();
ArrayList<String> hasGenderRm = new ArrayList<String>();

Calendar cal = Calendar.getInstance();
cal.add(Calendar.DAY_OF_MONTH, Integer.parseInt(afterToday));
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
String date = sdf.format(cal.getTime());

ArrayList<ReportableListObject> record = fetchWardBeds(new String[]{date, ((String)wards.get(Integer.parseInt(ward))).split("_")[0]});
ReportableListObject row = null;

if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		
		if(row.getValue(2).equals("I")) {
			vip.add(row.getValue(2)+"_"+row.getValue(3)+"_"+row.getValue(4)+"_"+
						row.getValue(5)+"_"+row.getValue(6)+"_"+row.getValue(7)+"_"+
						row.getValue(8)+"_"+row.getValue(9));
		}
		else if(row.getValue(2).equals("P")) {
			pri.add(row.getValue(2)+"_"+row.getValue(3)+"_"+row.getValue(4)+"_"+
						row.getValue(5)+"_"+row.getValue(6)+"_"+row.getValue(7)+"_"+
						row.getValue(8)+"_"+row.getValue(9));
		}
		else if(row.getValue(2).equals("S")) {
			semi_pri.add(row.getValue(2)+"_"+row.getValue(3)+"_"+row.getValue(4)+"_"+
							row.getValue(5)+"_"+row.getValue(6)+"_"+row.getValue(7)+"_"+
							row.getValue(8)+"_"+row.getValue(9));
		}
		else if(row.getValue(2).equals("T")) {
			standard.add(row.getValue(2)+"_"+row.getValue(3)+"_"+row.getValue(4)+"_"+
							row.getValue(5)+"_"+row.getValue(6)+"_"+row.getValue(7)+"_"+
							row.getValue(8)+"_"+row.getValue(9));
		}
		
		if(!row.getValue(8).equals("")) {
			hasGenderRm.add(row.getValue(4)+"_"+row.getValue(5)+"_"+row.getValue(8));
			//System.out.println(row.getValue(4)+"_"+row.getValue(5)+"_"+row.getValue(8));
		}
	}
}

int totalRow = ((vip.size() > 0)?vip.size():1) + ((pri.size() > 0)?pri.size():1) +
				((semi_pri.size() > 0)?semi_pri.size():1) + ((standard.size() > 0)?standard.size():1) + 5;

//ui
%>
	<tr>
		<td rowspan="2">
<%
		for(int i = 0; i < 6; i++) {
%>
				<div style="float:left; width:100%;">
					<div style="float:left"><input index=<%=i %> name="ward" type="radio" value="<%=units[i]%>"/><label><%=units[i]%></label></div>
				</div>
<%		
		}
%>
		</td><td>&nbsp;</td><td colspan="7"><div id="targetWardLabel"></div></td></tr>
	<tr>
		<td><img class='prev_img' src='../images/arrow-left.png' title='prev' alt='prev' style='cursor:pointer; cursor:hand;'/></td>
		<td colspan='6' class="title" style="width:11%; border-style:outset; border-width:1px;">
			<span class="date"><%=date %></span>
		</td>
		<td><img class='next_img' src='../images/arrow-right.png' title='next' alt='next' style='cursor:pointer; cursor:hand;'/></td>
	</tr>
	
	<%--header --%>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">Specialty</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">Class</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">Room</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">Bed</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">is Bed</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">Status</td>
		<td style="width:10%; border-style:outset; border-width:1px; display:none;" class="booked">Patient<br/>Name</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">M</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">F</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">M/F</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">Total(Class)</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">Total(Specialty)</td>
	</tr>
	
	<tr>
		<td rowspan="<%=totalRow%>" class="available" style="border-style:outset; border-width:1px;">
			<%=((String)wards.get(Integer.parseInt(ward))).split("_")[1] %>
		</td>
<%
	int hasGenderListPos = 0;
	boolean found = false; 
	
	for(int counter = 0; counter < acm.size(); counter++) {
		ArrayList<String> curList = new ArrayList<String>();
		
		String style = null;
		String curRm = "first";
		String curStyle = "_odd";
		
		if(counter == 0) {
			curList = vip;
			style = "vip";
		}
		else if(counter == 1) {
			curList = pri;
			style = "private";
		}
		else if(counter == 2) {
			curList = semi_pri;
			style = "semi-private";
		}
		else if(counter == 3) {
			curList = standard;
			style = "standard";
			//System.out.println("standard");
		}
			
		for(int i = 0; i < curList.size(); i++) {
			//System.out.println(curList.get(i));
			String[] info = curList.get(i).split("_");
			if(counter != 0) {
%>
				<tr>
<%
			}

			if(i == 0) {
				curStyle = "_odd";
			}
			
			int male;
			int female;
			int unknown;
			
			if((found && !curRm.equals(info[2])) || (found && curRm.equals(info[2]) && info[4].length() > 0)) {
				hasGenderListPos++;
			}
			
			if(hasGenderListPos < hasGenderRm.size()) {
				//System.out.println(hasGenderListPos+"---------------------");
				//System.out.println(hasGenderRm.get(hasGenderListPos));
				//System.out.println(info[2]);
			}
			
			if(hasGenderListPos < hasGenderRm.size() && hasGenderRm.get(hasGenderListPos).split("_")[0].equals(info[2])) {
				
				if(hasGenderRm.get(hasGenderListPos).split("_")[1].equals(info[3])) {
					male = 0;
					female = 0;
					unknown = 0;
					found = true;
				}else {
					if(hasGenderRm.get(hasGenderListPos).split("_")[2].equals("Male")) {
						male = 1;
						female = 0;
						unknown = 0;
					}else if(hasGenderRm.get(hasGenderListPos).split("_")[2].equals("Female")) {
						male = 0;
						female = 1;
						unknown = 0;
					}else {
						male = 0;
						female = 0;
						unknown = 1;
					}
					if(!curRm.equals(info[2]))
						found = false;
				}
			}else {
				male = 0;
				female = 0;
				unknown = 1;
				found = false;
			}
			
			if(!curRm.equals(info[2])) {
				if(curStyle.equals("_odd")) {
					curStyle = "_even";
				}
				else {
					curStyle = "_odd";
				}
			}
			
			curRm = info[2];
			
%>
			<td class="<%=style+curStyle%> acm"><%=info[1] %></td>
			<td class="<%=style+curStyle%> room"><%=info[2] %></td>
			<td class="<%=style+curStyle%> bed"><%=info[3] %></td>
			<td class="<%=style+curStyle%> <%=info[7].equals("0")?"unable":"enable" %>" acm="<%=info[1] %>" room="<%=info[2] %>" 
				ward="<%=((String)wards.get(Integer.parseInt(ward))).split("_")[0]%>" 
				bed="<%=info[3] %>" enable="<%=info[7] %>"><%=info[7].equals("0")?"Block":"" %>&nbsp;&nbsp;&nbsp;&nbsp;<img src="../images/bed_icon.jpg" style="width:20px; height:20px; cursor:pointer;" class="edit_Bed"/></td>
			<td class="<%=style+curStyle%> detail_<%=info[4].toLowerCase() %>"><%=info[4] %></td>
			<td class="<%=style+curStyle%> " style="display:none;"><%=info[5] %></td>
			<td class="<%=style+curStyle%> <%=(male==1)?"detail_male":"" %>"><%=male %></td>
			<td class="<%=style+curStyle%> <%=(female==1)?"detail_female":"" %>"><%=female %></td>
			<td class="<%=style+curStyle%> <%=(unknown==1)?"detail_unknown":""%>"><%=unknown %></td>
			<td></td>
			<td></td></tr>
<%
		}
	
		if(curList.size() == 0) {
			if(counter != 0) {
%>
				<tr>
<%
			}
%>
			<td class="<%=style+curStyle%>"><%=acm.get(counter).split("_")[1] %></td>
			<td class="<%=style+curStyle%>"></td>
			<td class="<%=style+curStyle%>"></td>
			<td class="<%=style+curStyle%>"></td>
			<td class="<%=style+curStyle%>"></td>
			<td class="<%=style+curStyle%>" style="display:none;"></td>
			<td class="<%=style+curStyle%>"></td>
			<td class="<%=style+curStyle%>"></td>
			<td class="<%=style+curStyle%>"></td>
			<td></td>
			<td></td></tr>
<%
		}
%>
			<tr><td></td><td></td><td></td><td></td><td></td><td style="display:none;"></td><td></td><td></td><td></td><td class="total"><%=curList.size() %></td><td></td></tr>
<%
	}
%>
	<tr><td></td><td></td><td></td><td></td><td></td><td style="display:none;"></td><td></td><td></td><td></td><td></td><td class="totalWard"><%=vip.size()+pri.size()+semi_pri.size()+standard.size() %></td></tr>