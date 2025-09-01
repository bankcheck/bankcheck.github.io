<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.json.*" %>
<%@ page import="java.io.PrintWriter" %>

<%!
private ArrayList getAllOrder(String orderNo) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT D.ITEM_TYPE, ");
	sqlStr.append("		D.ITEM_CODE||'_'||I.ITEM_NAME1||' '||I.ITEM_NAME2||' '||I.CURRENCY||' '||I.UNIT_PRICE, ");
	sqlStr.append("    	I.CURRENCY||' '||I.UNIT_PRICE , ");
	sqlStr.append("    	D.ITEM_OPT, ");
	sqlStr.append("    	D.ORDER_QTY, ");
	sqlStr.append("    	D.ITEM_CODE||'_'||I.ITEM_NAME1||' '||I.ITEM_NAME2, ");
	sqlStr.append("    	DECODE(H.SERVE_TIME, 'now', '', TO_CHAR(H.SERVE_DATE, 'DD/MM/YYYY')), ");
	sqlStr.append("    	H.SERVE_TIME, ");
	sqlStr.append("    	H.SERVE_TYPE, ");
	sqlStr.append("    	D.ITEM_SEQ, ");
	sqlStr.append("    	D.ITEM_CODE, ");
	sqlStr.append("    	H.ORDER_TYPE ");
	sqlStr.append("FROM DIT_ORDER_DTL D, DIT_ORDER_HDR H, DIT_MENU_ITEM I ");
	sqlStr.append("WHERE D.ORDER_NO = H.ORDER_NO ");
	sqlStr.append("AND   D.ORDER_NO = '"+orderNo+"' ");
	sqlStr.append("AND   I.ITEM_CODE = D.ITEM_CODE ");
	sqlStr.append("AND   (SYSDATE BETWEEN I.EFFECTIVE_DATE AND NVL(I.EXPIRED_DATE, SYSDATE)) ");
	sqlStr.append("ORDER BY ITEM_SEQ ");
	
	return UtilDBWeb.getReportableListFSD(sqlStr.toString());
}

private ArrayList getOrderOpt(String optCode, String itemCode) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.setLength(0);
	sqlStr.append("SELECT COMP_CODE FROM DIT_ITEM_COMP ");
	sqlStr.append("WHERE ITEM_CODE = '"+itemCode+"' ");
	
	ArrayList records = UtilDBWeb.getReportableListFSD(sqlStr.toString());
	
	if(records.size() < 2) {
		//System.out.println("----------first try-------------");
		sqlStr.setLength(0);
		sqlStr.append("SELECT O.COMP_CODE||'#'||C.OPT_CNT||'#'||O.COMP_CODE||'@'||O.OPT_CODE||'#'||O.OPT_NAME1||' '||O.OPT_NAME2||'#'||O.PRICE_WITHIN||'#'||O.PRICE_PLUS ");
		sqlStr.append("FROM DIT_ITEM_OPT O, DIT_ITEM_COMP C ");
		sqlStr.append("WHERE O.OPT_CODE = '"+optCode+"' ");
		sqlStr.append("AND O.COMP_CODE = (SELECT COMP_CODE FROM DIT_ITEM_COMP ");
		sqlStr.append("WHERE ITEM_CODE = '"+itemCode+"') ");
		sqlStr.append("AND C.COMP_CODE = O.COMP_CODE ");
		//System.out.println(sqlStr.toString());
		
		records = UtilDBWeb.getReportableListFSD(sqlStr.toString());
		
		if (records.size() > 0) {
			return records;
		}
		else {
			//System.out.println("----------second try-------------");
			sqlStr.setLength(0);
			sqlStr.append("SELECT O.COMP_CODE||'#'||C.OPT_CNT||'#'||O.COMP_CODE||'@'||O.OPT_CODE||'#'||O.OPT_NAME1||' '||O.OPT_NAME2||'#'||O.PRICE_WITHIN||'#'||O.PRICE_PLUS ");
			sqlStr.append("FROM DIT_ITEM_OPT O, DIT_ITEM_COMP C ");
			sqlStr.append("WHERE O.OPT_CODE = '"+optCode+"' ");
			sqlStr.append("AND C.COMP_CODE = O.COMP_CODE ");
			//System.out.println(sqlStr.toString());
			return UtilDBWeb.getReportableListFSD(sqlStr.toString());
		}
	}
	else {
		//System.out.println("----------second try-------------");
		sqlStr.setLength(0);
		sqlStr.append("SELECT O.COMP_CODE||'#'||C.OPT_CNT||'#'||O.COMP_CODE||'@'||O.OPT_CODE||'#'||O.OPT_NAME1||' '||O.OPT_NAME2||'#'||O.PRICE_WITHIN||'#'||O.PRICE_PLUS ");
		sqlStr.append("FROM DIT_ITEM_OPT O, DIT_ITEM_COMP C ");
		sqlStr.append("WHERE O.OPT_CODE = '"+optCode+"' ");
		sqlStr.append("AND C.COMP_CODE = O.COMP_CODE ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
}

private String fetchExtraPrice(String itemCode) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT UNIT_PRICE ");
	sqlStr.append("FROM DIT_MENU_ITEM ");
	sqlStr.append("WHERE ITEM_CODE = '"+itemCode+"' ");
	sqlStr.append("AND   (SYSDATE BETWEEN EFFECTIVE_DATE AND NVL(EXPIRED_DATE, SYSDATE) ) "); 
	
	ArrayList result = UtilDBWeb.getReportableListFSD(sqlStr.toString());
	
	if(result.size() > 0) {
		ReportableListObject row = null;
		row = (ReportableListObject)result.get(0);
		
		String extraPrice = row.getValue(0);
		
		if(extraPrice.length() > 0 && Double.parseDouble(extraPrice) < 0.0) {
			return extraPrice;
		}
		else {
			return "0";
		}
	}
	else {
		return "0";
	}
}
%>

<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../foodtw/index.jsp", "_self");
	</script>
	<%
	return;
}
String orderNo = request.getParameter("orderNo");

ArrayList record = getAllOrder(orderNo);
ReportableListObject row = null;
String serveDate = null;
String serveTime = null;
String serveType = null;
String orderType = null;

if(record.size() > 0) {
	JSONArray subItemArray = new JSONArray();
	JSONArray orderArray = new JSONArray(); 
	Double extra = 0.00;
	for(int i = 0; i < record.size(); i++) {
		row = (ReportableListObject)record.get(i);
		JSONObject orderJSON = new JSONObject();
		if(i == 0) {
			serveDate = row.getValue(6);
			serveTime = row.getValue(7);
			serveType = row.getValue(8);
			orderType = row.getValue(11);
		}
		
		String type = row.getValue(0);
		if(type.equals("M")) {
			orderJSON.put("itemMenuType", type);
			orderJSON.put("itemName", row.getValue(1));
			orderJSON.put("itemPrice", row.getValue(2));
			if(row.getValue(3).length() > 0) {
				//System.out.println("allOpt:" + row.getValue(3));
				String[] opt = row.getValue(3).split("\\.");
				String[] optArray = new String[opt.length];
				String remark = "";
				
				for(int j = 0; j < opt.length; j++) {
					//System.out.println("opt:"+opt[j]);
					ArrayList optList = getOrderOpt(opt[j], row.getValue(10));
					ReportableListObject optRow = null;
					
					if(optList.size() > 0) {
						optRow = (ReportableListObject)optList.get(0);
						optArray[j] = optRow.getValue(0);
					}
					else {
						remark += opt[j];
					}
				}
				orderJSON.put("itemOpt", optArray);
				orderJSON.put("itemRmk", remark);
			}
			orderJSON.put("amount", row.getValue(4));
		}
		else if(type.equals("S")) {
			orderJSON.put("itemMenuType", type);
			orderJSON.put("itemName", row.getValue(1));
			orderJSON.put("itemPrice", row.getValue(2));
			orderJSON.put("itemOpt", row.getValue(3));
			orderJSON.put("amount", row.getValue(4));
			
			
			if(subItemArray.length() > 0) {
				orderJSON.put("subItem", subItemArray);
				
				subItemArray = new JSONArray();
				extra = 0.00;
			}
		}
		else if(type.equals("I")) {
			JSONObject subItemJSON = new JSONObject();
			
			subItemJSON.put("itemMenuType", type);
			subItemJSON.put("itemName", row.getValue(5));
			subItemJSON.put("itemPrice", "HKD 0");
			if(row.getValue(3).length() > 0) {
				String[] opt = row.getValue(3).split("\\.");
				String[] optArray = new String[opt.length];
				String remark = "";
				
				for(int j = 0; j < opt.length; j++) {
					ArrayList optList = getOrderOpt(opt[j], row.getValue(10));
					ReportableListObject optRow = null;
					
					if(optList.size() > 0) {
						optRow = (ReportableListObject)optList.get(0);
						optArray[j] = optRow.getValue(0);
					}
					else {
						remark += opt[j];
					}
				}
				subItemJSON.put("itemOpt", optArray);
				subItemJSON.put("itemRmk", remark);
			}
			subItemJSON.put("amount", row.getValue(4));
			String itemCode = row.getValue(5).split("_")[0];
			
			if(fetchExtraPrice(itemCode) != "0") {
				//System.out.println(fetchExtraPrice(itemCode));
				subItemJSON.put("itemExtraCurr", "HKD");
				extra += Double.parseDouble(fetchExtraPrice(itemCode))*-1;
				subItemJSON.put("itemExtraPrice", Double.parseDouble(fetchExtraPrice(itemCode))*-1);
			}
			subItemArray.put(subItemJSON);
		}
		
		if(orderJSON.length() > 0) {
			orderArray.put(orderJSON);
		}
	}
	
	JSONObject orderJSON = new JSONObject();
	orderJSON.put("allOrder", orderArray);
	orderJSON.put("serveDate", serveDate);
	orderJSON.put("serveTime", serveTime);
	orderJSON.put("serveType", serveType);
	orderJSON.put("orderType", orderType);
	response.setContentType("text/javascript");
	PrintWriter writer = response.getWriter();
	writer.print(request.getParameter("callback")+"("+orderJSON.toString()+ ");");
	writer.close();
}
%>