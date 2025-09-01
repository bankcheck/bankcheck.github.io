<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%!
private ArrayList<ReportableListObject> fetchOrderHistory(String patNo, String regID) {
	//String date = getRegDate(patNo);

	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT * ");
	sqlStr.append("FROM (SELECT H.ORDER_NO, H.STATUS, TO_CHAR(H.SERVE_DATE, 'DD/MM/YYYY HH24:MI:SS'), H.SERVE_TIME, H.SLPAMT, ");
	sqlStr.append("H.CREATE_USER, H.UPDATE_USER, TO_CHAR(H.CREATE_DATE, 'DD/MM/YYYY HH24:MI'), H.PATNO, ");
	sqlStr.append("H.SERVE_TYPE ");
	sqlStr.append("FROM DIT_ORDER_HDR H ");
	sqlStr.append("WHERE H.PATNO = '"+patNo+"' ");
	sqlStr.append("AND H.REGID = '"+regID+"' ");
	//sqlStr.append("AND D.ORDER_NO = H.ORDER_NO ");
	sqlStr.append("AND H.SERVE_DATE >= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND H.SERVE_DATE <= TO_DATE(TO_CHAR(SYSDATE+1, 'DD/MM/YYYY')||' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	//if(date != null) {
	//	sqlStr.append("AND CREATE_DATE >= TO_DATE('"+date+"', 'DD/MM/YYYY HH24:MI:SS') ");
	//}
	sqlStr.append("ORDER BY H.ORDER_NO DESC) ");
	
	return UtilDBWeb.getReportableListFSD(sqlStr.toString());
}

private String fetchOrderDetail(String orderNo) {
	StringBuffer sqlStr = new StringBuffer();
	String content = "";
	
	sqlStr.append("SELECT ORDER_NO, ITEM_SEQ, ITEM_TYPE, ITEM_CODE, ITEM_OPT, ");
	sqlStr.append("ITEM_NAME1, ITEM_NAME2, REMARKS, ORDER_QTY, CURRENCY, AMOUNT, ");
	sqlStr.append("BILLAMT, KITCHEN ");
	sqlStr.append("FROM DIT_ORDER_DTL ");
	sqlStr.append("WHERE ORDER_NO = '"+orderNo+"' ");
	sqlStr.append("ORDER BY ITEM_SEQ ");
	
	ArrayList record = UtilDBWeb.getReportableListFSD(sqlStr.toString());
	if(record.size() > 0) {
		ReportableListObject row = null;
		String firstType = "";
		String subItem = "";
		int seq = 1;
		for(int i = 0; i < record.size(); i++) {
			row = (ReportableListObject)record.get(i);
			
			if(firstType.length() == 0) {
				if(!row.getValue(2).equals("M")) {
					firstType = row.getValue(2);
				}
			}
			
			if(row.getValue(2).equals("M")) {
				content += seq + ". " + row.getValue(5) + " X " + row.getValue(8) + "<br/>";
				seq++;
			}
			else if(row.getValue(2).equals("S")) {
				content += seq + ". " + row.getValue(5) + " X " + row.getValue(8) + "<br/>";
				seq++;
				if(firstType.equals("I")) {
					content += subItem;
					subItem = "";
				}
			}
			else if(row.getValue(2).equals("I")) {
				subItem += "&nbsp;&nbsp;&nbsp;&nbsp;" + row.getValue(5) + "<br/>";
				if(firstType.equals("S")) {
					content += "&nbsp;&nbsp;&nbsp;&nbsp;" + row.getValue(5) + "<br/>";
				}
			}
		}
	}
	
	return content;
}

public void addDetailList(ArrayList originalList, ArrayList dateList,
							Date contDate, String content) {
	int addIndex = dateList.size();
	
	if(dateList.size() > 0) {
		for(int j = 0; j < dateList.size(); j++) {
			int result = contDate.compareTo((Date)dateList.get(j));
			if(result < 0) {
				addIndex = j;
				break;
			}
		}
	}
	
	dateList.add(addIndex, contDate);
	originalList.add(addIndex, content);
}
%>

<%
UserBean userBean = new UserBean(request);

String patNo = request.getParameter("patNo");
String regID = request.getParameter("regID");

ArrayList patSerList = null;
ArrayList foodOrderList = null;
ArrayList dateList = new ArrayList();
ArrayList detailList = new ArrayList();

if (userBean != null && userBean.isLogin()) {
	patSerList = PatientDB.getFoodServiceList(patNo, regID, true, true, "0", "I", "1");
	foodOrderList = fetchOrderHistory(patNo, regID);
	
	ReportableListObject patSerRow = null;
	ReportableListObject foodOrderRow = null;
	
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
	
	if(patSerList.size() > 0) {
		for(int i = 0; i < patSerList.size(); i++) {
			patSerRow = (ReportableListObject)patSerList.get(i);
			Date today = new Date();
			
			if(patSerRow.getValue(20).equals("1")) {
				addDetailList(detailList, dateList, 
						sdf.parse(patSerRow.getValue(15)), 
						"<label style='color:blue'><b><u>"+patSerRow.getValue(15)+"</u></b></label><br/>"
						+"Remark: "+patSerRow.getValue(13)+
						(patSerRow.getValue(20).equals("1")&&
								(today.getDate()==Integer.parseInt(patSerRow.getValue(15).substring(0, 2)))?"(effective)":""));
			}
			//System.out.println("patSerList:");
			//System.out.println("STATUS: "+patSerRow.getValue(13));
			//System.out.println("EFFECTIVE_DATE: "+patSerRow.getValue(15));
		}
	}
	
	if(foodOrderList.size() > 0) {
		Date serDate = new Date();
		String content = "";
		String orderNo = "";
		
		for(int i = 0; i < foodOrderList.size(); i++) {
			foodOrderRow = (ReportableListObject)foodOrderList.get(i);
			
			if(foodOrderRow.getValue(1).equals("X") && !foodOrderRow.getValue(6).toUpperCase().equals("WEB")) {
					continue;
			}
			
			if(foodOrderRow.getValue(3).equals("now")) {
				serDate = sdf.parse(foodOrderRow.getValue(7));
			}
			else {
				serDate = sdf.parse(foodOrderRow.getValue(2));
				serDate.setHours(Integer.parseInt(foodOrderRow.getValue(3).split(":")[0]));
				serDate.setMinutes(Integer.parseInt(foodOrderRow.getValue(3).split(":")[1]));
			}
			
			content = "<label style='color:blue'><b><u>"+sdf.format(serDate)+
							"</u></b></label><br>Serve Type: "+((foodOrderRow.getValue(9).equals("B")?"Breakfast":
								(foodOrderRow.getValue(9).equals("L")?"Lunch":
									(foodOrderRow.getValue(9).equals("S")?"Snack":
									(foodOrderRow.getValue(9).equals("D")?"Dinner":"")))))+
							"<br>Order:<br/> "+fetchOrderDetail(foodOrderRow.getValue(0));
			
			//System.out.println(content);
							
			addDetailList(detailList, dateList, serDate, content);
		}
	}
	
	if(detailList.size() > 0) {
		for(int i = 0; i < detailList.size(); i++) {
			//System.out.println(detailList.get(i));
%>
			<%=detailList.get(i) %><br/>
<%
		}
	}
}
else {
	%>
	<script>
		window.open("../foodtw/index.jsp", "_self");
	</script>
	<%
	return;
}
%>

