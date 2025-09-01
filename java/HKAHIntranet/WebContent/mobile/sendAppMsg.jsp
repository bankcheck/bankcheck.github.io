<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%@
page import="org.json.simple.JSONObject" %><%@
page import="java.io.PrintWriter" %><%@
page import="com.hkah.web.mobile.*"%><%@
page import="java.text.SimpleDateFormat" %><%@
page import="com.spreada.utils.chinese.ZHConverter" %><%@
page import="java.text.ParseException" %><%@
page import="java.util.Calendar" %>
<%!
private String getHPStatus(String status, String key) {

	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT HPRMK FROM HPSTATUS@IWEB WHERE HPTYPE = 'MOBILEAPP' AND HPSTATUS = UPPER('");
	sqlStr.append(status);
	sqlStr.append("') AND  HPKEY = UPPER('");
	sqlStr.append(key);
	sqlStr.append("')");

	ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		return row.getValue(0);
	} else {
		return null;
	}
}

public static boolean saveMsgLog(String errMsg, String keyId, String type, String tempLang, String smcId, int success, String user) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("INSERT INTO SMS_LOG(");
	sqlStr.append("RES_MSG, SUCCESS, SEND_TIME, SENDER, ACT_TYPE, KEY_ID, TEMPLATE_LANG, SMCID, SMS_AC ) ");
	sqlStr.append("VALUES ('");
	sqlStr.append(errMsg);
	sqlStr.append("', '");
	sqlStr.append(success);
	sqlStr.append("', SYSDATE, '");
	sqlStr.append(user);
	sqlStr.append("', '");
	sqlStr.append(type);
	sqlStr.append("', '");
	sqlStr.append(keyId);
	sqlStr.append("', '");
	sqlStr.append(tempLang);
	sqlStr.append("', '");
	sqlStr.append(smcId);
	sqlStr.append("', 'MOBILE') ");

	return UtilDBWeb.updateQueue(sqlStr.toString());
}

private HashMap<String, String> getMsgContent(String id) {
	HashMap<String, String> msgMap = new HashMap<String, String>();
	ArrayList<ReportableListObject> record = 
		UtilDBWeb.getReportableListHATS("select LANGUAGE, DESCRIPTION from DESCRIPTION_MAPPING where TYPE = 'MOBILESMS' AND ID = '"+id.toUpperCase()+"' AND ENABLE = 1");
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			ReportableListObject row = (ReportableListObject) record.get(i);
			msgMap.put(row.getValue(0),row.getValue(1));
		}
	} 
	
	return msgMap;

}

/*
private boolean updatetoReady(String accessionNo) {
	StringBuffer sqlStr = new StringBuffer();

	return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {accessionNo} );
}
*/

private String getFoodOrderStatus(String orderId) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT STATUS FROM DIT_ORDER_HDR@FSD WHERE ORDER_NO = '");
	sqlStr.append(orderId);
	sqlStr.append("' AND UPDATE_USER != 'MOBILE' ");

	ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		return row.getValue(0);
	} else {
		return null;
	}
}

private String getFsMsg(String id, String lang) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT DESCRIPTION FROM DESCRIPTION_MAPPING@IWEB WHERE ID = '");
	sqlStr.append(id);
	sqlStr.append("' AND LANGUAGE = '");
	sqlStr.append(lang);
	sqlStr.append("' ");
	
	ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		return row.getValue(0);
	} else {
		return null;
	}
	
}
%><%
UserBean userBean = new UserBean(request);
String patNo = request.getParameter("patNo");
String type = request.getParameter("type");
String msgHK = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "msgHK"));
String msgCN = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "msgCN"));
String msgEN = request.getParameter("msgEN");
String bkgID = request.getParameter("bkgID");
String userID = request.getParameter("user");
String token = request.getParameter("token");
String orderType = request.getParameter("orderType");
String orderId = request.getParameter("orderId");
String billID = request.getParameter("billID");
Map<String, String>  msgMap = getMsgContent((billID != null && !"".equals(billID))?"bill":"APPOINTMENT");

boolean forward = false;

if (forward) {
	try {
		if (ConstantsServerSide.SITE_CODE_HKAH.equals("hkah")) {
			%><%=ServerUtil.connectServer("http://160.100.2.80/intranet/mobile/sendAppMsg.jsp", "user=MOBILEAPP&type=sendMsg&patNo=" + patNo + "&bkgID=" + bkgID) %><%
		} else {
			%><%=ServerUtil.connectServer("http://192.168.0.20/intranet/mobile/sendAppMsg.jsp", "user=MOBILEAPP&type=sendMsg&patNo=" + patNo + "&bkgID=" + bkgID) %><%
		}
	} catch (Exception e) {}
} else {
	if (userID == null || "".equals(userID)) {
		userID = userBean.getStaffID();
	}

	org.json.JSONObject resultJSON = new  org.json.JSONObject();

	//ArrayList<ReportableListObject> record = getList(userBean,patNo, ckRdyUnSent, dateFrom);

	ReportableListObject row = null;
	ArrayList<ReportableListObject> record = null;
	if ("getToken".equals(type)) {
		token = NotifyService.getToken(
				getHPStatus("token", "target"),
				getHPStatus("token", "path"),
				getHPStatus("token", "OCPKEY"),
				getHPStatus("token", "AUTH"),
				getHPStatus("token", "USERNAME"),
				getHPStatus("token", "PASSWORD"));

		if (token != null && !"".equals(token)) {
			%><%=token %><%
		} else {
			%><%="-999" %><%
		}
	} else if ("sendMsg".equals(type)) {
		if (token == null || "".equals(token)) {
			token = NotifyService.getToken(
					getHPStatus("token", "target"),
					getHPStatus("token", "path"),
					getHPStatus("token", "OCPKEY"),
					getHPStatus("token", "AUTH"),
					getHPStatus("token", "USERNAME"),
					getHPStatus("token", "PASSWORD"));
	 	}

		if (token != null && !"".equals(token)) {
			String msgResult = null;
			if ((msgEN != null && msgHK != null && msgCN != null) || msgMap.size() > 0) {
				if(bkgID != null && !"".equals(bkgID)) {
					msgResult = NotifyService.sendMsg(
							getHPStatus("INAPPMSG_BK", "TARGET"),
							getHPStatus("INAPPMSG_BK", "PATH"),
							token,
							NotifyService.getMsgJSONString(patNo, bkgID, msgEN, msgHK, msgCN));
				} else if(billID != null && !"".equals(billID)) {
					msgResult = NotifyService.sendMsg(
							getHPStatus("INAPPMSG_BK", "TARGET"),
							getHPStatus("INAPPMSG_BILL", "PATH"),
							token,
							NotifyService.getMsgJSONStringBill(patNo, billID, msgMap.get("en"), msgMap.get("zh-HK"), msgMap.get("zh-CN")));
				}
			}

			if (msgResult != null && msgResult.length() > 0) {
				resultJSON = new org.json.JSONObject(msgResult);
				boolean isSuccess = false;
				if (resultJSON.has("success")) {
					isSuccess = (Boolean) resultJSON.get("success");
				} else {
					isSuccess = false;
				}

				saveMsgLog((String)resultJSON.get("status"), patNo,
						"mobile", "", "",isSuccess?1:0, (userID == null || "".equals(userID)?"SYSTEM":userID));
				%>
				<%=isSuccess?"Success":"Fail" %>
			<%}
		}
	} else if ("sendFsMsg".equals(type)) {
		if (token == null || "".equals(token)) {
			token = NotifyService.getToken(
					getHPStatus("token", "target"),
					getHPStatus("token", "path"),
					getHPStatus("token", "OCPKEY"),
					getHPStatus("token", "AUTH"),
					getHPStatus("token", "USERNAME"),
					getHPStatus("token", "PASSWORD"));
	 	}

		if (token != null && !"".equals(token)) {
			//get food order status
			String status = getFoodOrderStatus(orderId);
			if (status != null && !"".equals(status)){
				// get msg
				if("A".equals(status)){
					orderType = "confirm";
					msgEN = getFsMsg("FoodOrderConfirmed","en");
					msgCN = getFsMsg("FoodOrderConfirmed","zh-CN");
					msgHK = getFsMsg("FoodOrderConfirmed","zh-HK");
				}else{
					orderType = "cancel";
					msgEN = getFsMsg("FoodOrderCancelled","en");
					msgCN = getFsMsg("FoodOrderCancelled","zh-CN");
					msgHK = getFsMsg("FoodOrderCancelled","zh-HK");
				}
				//non update to food order
				String msgResult = null;
				if (msgEN != null && msgHK != null && msgCN != null) {
					msgResult = NotifyService.sendMsg(
							getHPStatus("INAPPMSG_BK", "TARGET"), 	//https://c1cmsuat.twah.org.hk
							getHPStatus("INAPPMSG_FS", "PATH"), 	//hkah/api/v1/FoodOrder
							token,
							NotifyService.getMsgJSONStringFs(patNo, orderType, orderId, msgEN, msgHK, msgCN));
				}
	
				if (msgResult != null && msgResult.length() > 0) {
					resultJSON = new org.json.JSONObject(msgResult);
					boolean isSuccess = false;
					if (resultJSON.has("success")) {
						isSuccess = (Boolean) resultJSON.get("success");
					} else {
						isSuccess = false;
					}
	
					saveMsgLog((String)resultJSON.get("status"), patNo,
							"mobile", "", "",isSuccess?1:0, (userID == null || "".equals(userID)?"SYSTEM":userID));
					%>
					<%=isSuccess?"Success":"Fail" %>
				<%}
			}
		}
	}
}
%>