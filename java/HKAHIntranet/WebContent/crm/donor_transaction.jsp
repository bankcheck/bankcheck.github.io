<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%!
public static boolean add(	String donationID, String clientID, String donationItem, String campaign, String event, 
							String lastName, String firstName, String chineseName, 
							String transactionDate, String donationType, String donationAmount,
							String donationMethod, 
							String cardType, String cardNo, String cardExpireDate_yy, String cardExpireDate_mm, String cardholderName, 
							String chequeNo, String bankinAccount, String receiptID, String remarks, UserBean userBean) {
	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("INSERT INTO CRM_CLIENTS_DONATION ");
	sqlStr.append("(CRM_DONATION_ID, CRM_CLIENT_ID, CRM_FUND_ID, CRM_CAMPAIGN_ID, CRM_EVENT_ID, ");
	sqlStr.append("CRM_LASTNAME, CRM_FIRSTNAME, CRM_CHINESENAME, ");
	sqlStr.append("CRM_DONATION_DATE, CRM_STATUS, CRM_PLEDGED_AMOUNT, ");
	sqlStr.append("CRM_DONATION_METHOD, CRM_REMARKS, ");
	sqlStr.append("CRM_CREDITCARD_TYPE, CRM_CREDITCARD_NUMBER, CRM_CREDITCARD_EXPIREDATE,  CRM_CREDITCARD_HOLDERNAME, ");
	sqlStr.append("CRM_CHEQUE_NUMBER, CRM_BANKIN_ACCOUNT, ");
	sqlStr.append("CRM_RECEIPT_ID, CRM_CREATED_USER, CRM_MODIFIED_USER ) ");
	sqlStr.append(" VALUES "); 
	sqlStr.append("('"+donationID+"', '"+clientID+"', '"+donationItem+"', '"+campaign+"', '"+event+"', ");
	sqlStr.append("'"+lastName+"','"+firstName+"','"+chineseName+"', ");
	sqlStr.append("TO_DATE('"+transactionDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),'"+donationType+"','"+donationAmount+"', ");
	sqlStr.append("'"+donationMethod+"', '"+remarks+"', ");
	if(donationMethod.equals("Credit Card")){
		sqlStr.append("'"+cardType+"','"+cardNo+"',TO_DATE('1/"+cardExpireDate_mm+"/"+cardExpireDate_yy+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),'"+cardholderName+"', ");
	}else{
		sqlStr.append("'','','','', ");
	}
	if(donationMethod.equals("Cheque")){
		sqlStr.append("'"+chequeNo+"',");
	}else{
		sqlStr.append("'',");
	}
	if(donationMethod.equals("Bank-in Account")){
		sqlStr.append("'"+bankinAccount+"',");
	}else{
		sqlStr.append("'',");
	}
	
	sqlStr.append("'"+receiptID+"','"+userBean.getLoginID()+"','"+userBean.getLoginID()+"') ");	
	
	//System.out.println(sqlStr.toString());
	if (UtilDBWeb.updateQueue(sqlStr.toString() )) {	
		return true;
	} else {
		return false;
	}
}

public static boolean addReceipt(UserBean userBean, String donationID, 
								String receiptID, String clientID, String lastName,
								String firstName, String donationAmount, String transactionDate,
								String fundType) {

	StringBuffer sqlStr = new StringBuffer();
		
	sqlStr.append("	INSERT INTO CRM_CLIENTS_DONATION_RECEIPT ");
	sqlStr.append("(CRM_RECEIPT_ID,CRM_CLIENT_ID,CRM_DONATION_ID,CRM_RECEIPT_LASTNAME,CRM_RECEIPT_FIRSTNAME, ");
	sqlStr.append("CRM_RECEIPT_AMOUNT,CRM_RECEIPT_DATE,CRM_CREATED_USER,CRM_MODIFIED_USER, CRM_RECEIPT_ITEM)  ");
	sqlStr.append("VALUES ");		
	sqlStr.append("('"+receiptID+"','"+clientID+"','"+donationID+"','"+lastName+"','"+firstName+"','"+
					donationAmount+"',TO_DATE('"+transactionDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),'"+
					userBean.getLoginID()+"','"+userBean.getLoginID()+"', '"+fundType+"') ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
	
}

private static String getNextDonationID() {
	String donationID = null;

	ArrayList result = UtilDBWeb.getReportableList(
			"SELECT MAX(CRM_DONATION_ID) + 1 FROM CRM_CLIENTS_DONATION");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		donationID = reportableListObject.getValue(0);

		// set 1 for initial
		if (donationID == null || donationID.length() == 0) return "1";
	}
	return donationID;
}

private static boolean checkReceiptID(String receiptID){
	boolean exist = false;
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CRM_RECEIPT_ID ");
	sqlStr.append("FROM CRM_CLIENTS_DONATION_RECEIPT ");
	sqlStr.append("WHERE CRM_RECEIPT_ID = '"+receiptID+"' ");
	
	ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
	if(record.size() > 0){
		exist = true;
	}
	
	return exist;
}

public static ArrayList getDonationInfo(String donationID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CRM_DONATION_ID,CRM_CLIENT_ID,CRM_LASTNAME,CRM_FIRSTNAME,CRM_CHINESENAME,TO_CHAR(CRM_DONATION_DATE, 'DD/MM/YYYY'),CRM_STATUS,CRM_PLEDGED_AMOUNT,	 ");	
	sqlStr.append("CRM_DONATION_METHOD,CRM_CREDITCARD_TYPE,CRM_CREDITCARD_NUMBER,TO_CHAR(CRM_CREDITCARD_EXPIREDATE, 'MM/YYYY'),CRM_CREDITCARD_HOLDERNAME,  ");
	sqlStr.append("CRM_CHEQUE_NUMBER,CRM_BANKIN_ACCOUNT,CRM_RECEIPT_ID,  ");
	sqlStr.append("CRM_CAMPAIGN_ID, CRM_EVENT_ID, CRM_FUND_ID, CRM_ENABLED, CRM_REMARKS ");
	sqlStr.append("FROM CRM_CLIENTS_DONATION  ");	
	sqlStr.append("WHERE  CRM_DONATION_ID = '"+donationID+"' ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getReceipt(String receiptID){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CRM_RECEIPT_ITEM, CRM_PRINT_DATE ");
	sqlStr.append("FROM CRM_CLIENTS_DONATION_RECEIPT  ");	
	sqlStr.append("WHERE  CRM_RECEIPT_ID = '"+receiptID+"' ");
	
	return UtilDBWeb.getReportableList(sqlStr.toString()); 	
}

public static boolean update(UserBean userBean, String donationID, String receiptID,
							String lastName, String firstName, String chineseName,
							String donationType, String donationAmount, String campaign, String event, 
							String donationMethod, String cardType, String cardNo,
							String cardExpireDate_yy, String cardExpireDate_mm,
							String cardholderName, String chequeNo,
							String bankinAccount, String transactionDate, String donationItem, String remarks) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS_DONATION ");
	sqlStr.append("SET CRM_LASTNAME='"+lastName+"',CRM_FIRSTNAME='"+firstName+"',CRM_CHINESENAME='"+chineseName+"',CRM_DONATION_DATE = TO_DATE('"+transactionDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append(",CRM_STATUS='"+donationType+"',CRM_PLEDGED_AMOUNT = '"+donationAmount+"',CRM_FUND_ID='"+donationItem+"',CRM_CAMPAIGN_ID='"+campaign+"',CRM_EVENT_ID='"+event+"',CRM_DONATION_METHOD='"+donationMethod+"', ");
	sqlStr.append("CRM_REMARKS='"+remarks+"', ");
	
	if(donationMethod.equals("Credit Card")){
		sqlStr.append(" CRM_CREDITCARD_TYPE='"+cardType+"',CRM_CREDITCARD_NUMBER='"+cardNo+"',CRM_CREDITCARD_EXPIREDATE=TO_DATE('1/"+cardExpireDate_mm+"/"+cardExpireDate_yy+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),CRM_CREDITCARD_HOLDERNAME='"+cardholderName+"', ");
	}else{
		sqlStr.append("CRM_CREDITCARD_TYPE='',CRM_CREDITCARD_NUMBER='',CRM_CREDITCARD_EXPIREDATE='',CRM_CREDITCARD_HOLDERNAME='', ");
	}	
	if(donationMethod.equals("Cheque")){
		sqlStr.append("CRM_CHEQUE_NUMBER='"+chequeNo+"',");
	}else{
		sqlStr.append("CRM_CHEQUE_NUMBER='',");
	}
	if(donationMethod.equals("Bank-in Account")){
		sqlStr.append("CRM_BANKIN_ACCOUNT='"+bankinAccount+"',");
	}else{
		sqlStr.append("CRM_BANKIN_ACCOUNT='',");
	}		
	sqlStr.append("CRM_MODIFIED_DATE=SYSDATE,CRM_MODIFIED_USER='"+userBean.getLoginID()+"' ");	
	sqlStr.append("WHERE    CRM_DONATION_ID = '"+donationID+"'  ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean updateReceipt(UserBean userBean,String receiptID,String lastName,String firstName,String donationAmount,String transactionDate, String fundType) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("UPDATE CRM_CLIENTS_DONATION_RECEIPT ");
	sqlStr.append("SET CRM_RECEIPT_LASTNAME = '"+lastName+"', CRM_RECEIPT_FIRSTNAME = '"+firstName+"', ");
	sqlStr.append("CRM_RECEIPT_AMOUNT='"+donationAmount+"', ");
	sqlStr.append("CRM_RECEIPT_DATE = TO_DATE('"+transactionDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), ");
	sqlStr.append("CRM_MODIFIED_DATE=SYSDATE,CRM_MODIFIED_USER='"+userBean.getLoginID()+"', ");
	sqlStr.append("CRM_RECEIPT_ITEM = '"+fundType+"' ");
	sqlStr.append("WHERE  CRM_RECEIPT_ID = '"+receiptID+"' ");
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean delete(UserBean userBean, String donationID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS_DONATION  ");
	sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
	sqlStr.append("WHERE  CRM_ENABLED = 1 ");
	sqlStr.append("AND    CRM_DONATION_ID = '"+donationID+"' ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean deleteReceipt(UserBean userBean, String receiptID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS_DONATION_RECEIPT ");
	sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
	sqlStr.append("WHERE  CRM_ENABLED = 1 ");
	sqlStr.append("AND    CRM_RECEIPT_ID = '"+receiptID+"' ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static ArrayList getClientInfo(String clientID) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME,  CRM_CHINESENAME, CRM_STREET1, ");
	sqlStr.append("       CRM_STREET2, CRM_STREET3, CRM_STREET4, ");
	sqlStr.append("       CRM_HOME_NUMBER,CRM_MOBILE_NUMBER, CRM_FAX_NUMBER,  CRM_EMAIL, CRM_PHOTO_NAME, ");
	sqlStr.append("       CRM_ORGANIZATION, CRM_SALUTATION, ");
	sqlStr.append("       CRM_DESCRIPTION,CRM_DONOR,  CRM_CREATED_USER, CRM_CREATED_SITE_CODE, ");
	sqlStr.append("       CRM_CREATED_DEPARTMENT_CODE, CRM_MODIFIED_USER ");	
	sqlStr.append("FROM   CRM_CLIENTS ");
	sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientID+"' ");	
	sqlStr.append("AND    CRM_DONOR = 'Y' ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getClientPaymentInfo(String clientID) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("select  CRM_CLIENT_ID, CRM_CREDITCARD_NUMBER, CRM_CREDITCARD_TYPE, TO_CHAR(CRM_CREDITCARD_EXPIREDATE, 'MM/YYYY'), CRM_CREDITCARD_HOLDERNAME, CRM_BANKIN_ACCOUNT "); 
	sqlStr.append("from    CRM_CLIENTS_DONATION ");
	sqlStr.append("where   CRM_ENABLED  = 1 ");
	sqlStr.append("and     CRM_STATUS = 'client_info' ");
	sqlStr.append("AND     CRM_CLIENT_ID = '"+clientID+"' ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getCampaign(){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CRM_CAMPAIGN_ID, CRM_CAMPAIGN_DESC ");
	sqlStr.append("FROM CRM_CAMPAIGN ");
	sqlStr.append("WHERE CRM_ENABLED = 1 ");
	sqlStr.append("ORDER BY CRM_CAMPAIGN_DESC");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getEvent(String campaign) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CO_EVENT_ID, CO_EVENT_DESC, CRM_CAMPAIGN_ID ");	
	sqlStr.append("FROM CO_EVENT ");
	sqlStr.append("WHERE CRM_CAMPAIGN_ID = '" + campaign + "' ");
	sqlStr.append("AND CO_ENABLED = 1 ");
	sqlStr.append("ORDER BY CO_EVENT_DESC ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getFund() {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CRM_FUND_ID, CRM_FUND_DESC ");	
	sqlStr.append("FROM CRM_FUNDS ");
	sqlStr.append("WHERE CRM_ENABLED = 1 ");
	sqlStr.append("ORDER BY CRM_FUND_ID ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%

UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String message = TextUtil.parseStr(ParserUtil.getParameter(request, "message"));
String errorMessage = "";

String lastName = TextUtil.parseStr(ParserUtil.getParameter(request, "lastName")).toUpperCase();
String firstName = TextUtil.parseStr(ParserUtil.getParameter(request, "firstName")).toUpperCase();
String chineseName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "chineseName"));
String transactionDate = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "transactionDate"));
String donationType = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "donationType"));
String donationAmount = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "donationAmount"));
String donationMethod = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "donationMethod"));

String cardType = "";
String cardNo = "";
String cardExpireDate_yy = "";
String cardExpireDate_mm = "";
String cardholderName = "";

String chequeNo = "";

String bankinAccount= "";

String fundType = "";
String remarks = "";

String campaign = "";
ArrayList campaignID = new ArrayList();
ArrayList campaignDesc = new ArrayList();
String event = "";
ArrayList eventID = new ArrayList();
ArrayList eventDesc = new ArrayList();

String donationItem = "";
ArrayList itemID = new ArrayList();
ArrayList itemDesc = new ArrayList();

Boolean valid = true;
Boolean campaignSelected = true;
Boolean eventSelected = true;
Boolean itemSelected = true;

if("printed".equals(command)){
	valid=false;
}

String clientID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "clientID"));
String donationID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "donationID"));
String receiptID = "";

if("1".equals(step)){
	receiptID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "receiptID"));
	fundType = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "fundType"));
	donationItem = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "donationItem"));
	campaign = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "campaign"));
	event = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "event"));
	remarks = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remarks"));
	if("delete".equals(command)){
		
	}else{
		if(donationMethod.equals("Credit Card")){		
			cardType = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cardType"));
			cardNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cardNo"));
			cardExpireDate_yy = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cardExpireDate_yy"));
			cardExpireDate_mm = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cardExpireDate_mm"));
			cardholderName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cardholderName"));	
		}else if(donationMethod.equals("Cheque")){
			chequeNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "chequeNo"));
		}else if(donationMethod.equals("Bank-in Account")){
			bankinAccount = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bankinAccount"));
		}
	}
}

boolean loginAction = false;
boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false; 
boolean closeAction = false;

if ("login".equals(command) && userBean.isAdmin()) {
	loginAction = true;
} else if ("create".equals(command) || !userBean.isLogin()) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("close".equals(command)) {
	closeAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {				
			donationID = getNextDonationID();		
			//receiptID = getNextReceiptID();
			boolean exist = false;
			if(receiptID  != null && receiptID.length() > 0){
				//check receipt exist or not
				exist = checkReceiptID(receiptID);
			}
			if(!exist){
				boolean createSuccess = add(donationID, clientID, donationItem, campaign, event,
											lastName, firstName, chineseName, 
											transactionDate, donationType, donationAmount,
											donationMethod,
											cardType, cardNo, cardExpireDate_yy, cardExpireDate_mm, cardholderName,
											chequeNo, bankinAccount, receiptID, remarks, userBean);
				if (createSuccess) {
					addReceipt(userBean,donationID,receiptID,clientID,lastName,firstName,donationAmount,
								transactionDate, fundType);
					message = "Donation created.";
					createAction = false;
					step = null;
				} else {
					errorMessage = "Donation create fail.";
				}
			}else{
				errorMessage = "Donation & Receipt create fail.";
			}
		} else if (updateAction) {
			if ( update(userBean,donationID,receiptID, lastName, firstName,chineseName,donationType,donationAmount,campaign,event,
					donationMethod,cardType,cardNo,cardExpireDate_yy,cardExpireDate_mm,cardholderName,
					chequeNo,bankinAccount,transactionDate,donationItem, remarks)) {
				updateReceipt(userBean,receiptID,lastName,firstName,donationAmount,transactionDate, fundType);
				message = "Donation updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "Donation update fail.";
			}
		}else if (deleteAction) {
			if (delete(userBean, donationID)) {
				deleteReceipt(userBean,receiptID);
				message = "Donation removed.";				
				step = null;
				closeAction = true;
			} else {
				errorMessage = "Donation remove fail.";
			}
		}
	} 
	
	if (donationID != null && donationID.length() > 0) {
		ArrayList record= getDonationInfo(donationID);		
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			lastName = row.getValue(2);
			firstName = row.getValue(3);
			chineseName = row.getValue(4);
			transactionDate = row.getValue(5);
			donationType = row.getValue(6);
			donationAmount = row.getValue(7);
			donationMethod = row.getValue(8);

			cardType = row.getValue(9);
			cardNo = row.getValue(10);
			
			if(row.getValue(11).contains("/")){
				cardExpireDate_yy = row.getValue(11).split("/")[1];
				cardExpireDate_mm = row.getValue(11).split("/")[0];
			}
			cardholderName = row.getValue(12);
			
			chequeNo = row.getValue(13);
			bankinAccount= row.getValue(14);
			 
			clientID = row.getValue(1);
			donationID = row.getValue(0);
			receiptID = row.getValue(15);
			campaign = row.getValue(16);
			event = row.getValue(17);
			donationItem = row.getValue(18);
			if(donationItem == null){
				itemSelected = false;
			}
			if("0".equals(row.getValue(19))){
				valid = false;
			}
			remarks = row.getValue(20);
			
			if(receiptID != null && receiptID.length() > 0){
				record = getReceipt(receiptID);
				if (record.size() > 0) {
					ReportableListObject row1 = (ReportableListObject) record.get(0);
					fundType = row1.getValue(0);
					if(row1.getValue(1) != null && row1.getValue(1).length() > 0){
						valid = false;
						receiptID += " (Printed)";
					}
				}else{
					
				}
			}
			if (campaignID.size() == 0){
				record = getCampaign();
				if (record.size() > 0) {
					for (int i=0; i<record.size();i++){
						ReportableListObject row2 = (ReportableListObject) record.get(i);
						campaignID.add(row2.getValue(0));
						campaignDesc.add(row2.getValue(1));
					}
				}
				
				if(campaign != null && campaign.length() > 0){
					record = getEvent(campaign);
					if (record.size() > 0) {
						for (int i=0; i<record.size();i++){
							ReportableListObject row3 = (ReportableListObject) record.get(i);
							eventID.add(row3.getValue(0));
							eventDesc.add(row3.getValue(1));
						}
						
					}
				}
			}
			if (itemID.size() == 0){
				record = getFund();
				if (record.size() > 0) {
					for (int i=0; i<record.size();i++){
						ReportableListObject row4 = (ReportableListObject) record.get(i);
						itemID.add(row4.getValue(0));
						itemDesc.add(row4.getValue(1));
					}
				}
			}
		} else {
			
		}
	}	
} catch (Exception e) {
	e.printStackTrace();
}

if(createAction || updateAction && !"1".equals(step)){	
	ArrayList record= getClientInfo(clientID);		
	
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		lastName = row.getValue(1);
		firstName = row.getValue(2);
		chineseName = row.getValue(3);
	}
	if (campaignID.size() == 0){
		record = getCampaign();
		if (record.size() > 0) {
			for (int i=0; i<record.size();i++){
				ReportableListObject row2 = (ReportableListObject) record.get(i);
				campaignID.add(row2.getValue(0));
				campaignDesc.add(row2.getValue(1));
			}
		}
		
		if(campaign != null && campaign.length() > 0){
			record = getEvent(campaign);
			if (record.size() > 0) {
				for (int i=0; i<record.size();i++){
					ReportableListObject row3 = (ReportableListObject) record.get(i);
					eventID.add(row3.getValue(0));
					eventDesc.add(row3.getValue(1));
				}
				
			}
		}
	}
	if (itemID.size() == 0){
		record = getFund();
		if (record.size() > 0) {
			for (int i=0; i<record.size();i++){
				ReportableListObject row4 = (ReportableListObject) record.get(i);
				itemID.add(row4.getValue(0));
				itemDesc.add(row4.getValue(1));
			}
		}
	}
		
	if(createAction){
		ArrayList paymentRecord= getClientPaymentInfo(clientID);
		if(paymentRecord.size() > 0){
			ReportableListObject paymentRow = (ReportableListObject) paymentRecord.get(0);
			cardType = paymentRow.getValue(2);
			cardNo = paymentRow.getValue(1);			
			if(paymentRow.getValue(3).contains("/")){
				cardExpireDate_yy = paymentRow.getValue(3).split("/")[1];
				cardExpireDate_mm = paymentRow.getValue(3).split("/")[0];
			}
			cardholderName = paymentRow.getValue(4);			
			bankinAccount= paymentRow.getValue(5);
		}		
	}
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
	Licensed to the Apache Software Foundation (ASF) under one or more
	contributor license agreements.  See the NOTICE file distributed with
	this work for additional information regarding copyright ownership.
	The ASF licenses this file to You under the Apache License, Version 2.0
	(the "License"); you may not use this file except in compliance with
	the License.  You may obtain a copy of the License at

		 http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>
		.hightLight {
				border: 2px solid #FF9696;
		}
		.doInfo{
				width:250px;
		}
</style>
<body>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper  style="width:100%">
<div id=mainFrame  style="width:100%">
<div id=contentFrame  style="width:100%">
<%

	String title = null;
	String commandType = null;

	if (createAction) {
		commandType = "create";	
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.donor.transaction." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<form name="form1" method="post" action="donor_transaction.jsp">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" style="width:100%">
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Donation Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Donor ID</td>
		<td class="infoData" width="35%">
			<%=clientID==null?"":clientID %>
			<input type="hidden" name="clientID" value="<%=clientID %>"/>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="35%">
			<%=lastName==null?"":lastName %>
			<input type="hidden" id="lastName" name="lastName" value="<%=lastName==null?"":lastName%>" />
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="35%">
			<%=firstName==null?"":firstName %>
			<input type="hidden" id="firstName" name="firstName" value="<%=firstName==null?"":firstName%>"/>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="35%">
			<%=chineseName==null?"":chineseName %>
			<input type="hidden" id="chineseName" name="chineseName" value="<%=chineseName==null?"":chineseName%>"/>
		</td>
		<td class="infoLabel" width="15%">Donation Date<font color="red">*</font></td>
		<td class="infoData" width="35%">
<%	if (createAction) {
	Calendar currentDate = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
			<input type="text" name="transactionDate" id="transactionDate" class="datepickerfield" value="<%=sdf.format(currentDate.getTime()) %>" maxlength="10" size="10"   onkeyup="validDate(this)" />			
<%	} else if(updateAction){ %>
			<input type="text" name="transactionDate" id="transactionDate" class="datepickerfield" value="<%=transactionDate %>" maxlength="10" size="10"   onkeyup="validDate(this)" />
<%	}else { %>
			<%=transactionDate==null?"":transactionDate %>
<%	} %>
		</td>
	</tr>	
	
	<tr class="smallText">
		<td class="infoLabel" width="15%">Donation Type</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="radio" name="donationType" <%=((donationType!=null&&donationType.equals("One-off")) || createAction?"checked":"") %>  value="One-off"> One-off
			<input type="radio" name="donationType" <%=((donationType!=null&&donationType.equals("Monthly"))?"checked":"") %>  value="Monthly">Monthly
<%	} else { %>
			<%=donationType==null?"":donationType %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Donation Amount ($)<font color="red">*</font></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" id="donationAmount" name="donationAmount" value="<%=donationAmount==null?"":donationAmount%>"  maxlength="30" size="25"/>
<%  } else {  %>
			<%=donationAmount==null?"":donationAmount %>
<%  } %>
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="15%">Type of Fund</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="fundType" class="doInfo">
				<option <%=((fundType!=null&&fundType.equals("hospital")) || createAction?"selected":"") %> value="hospital">Hospital Donation Receipt</option>
				<option <%=((fundType!=null&&fundType.equals("foundation"))?"selected":"") %> value="foundation">Foundation Donation Receipt</option>		
			</select>
<%	} else { %>
			<%="hospital".equals(fundType)?"Hospital Donation Receipt":"foundation".equals(fundType)?"Foundation Donation Receipt":"" %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Donation Item</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select id="donationItemID" name="donationItemID" class="doInfo">
				<option value=""></option>
<% for(int c=0;c<itemID.size();c++){%>
				<option <%=((donationItem.equals(itemID.get(c)))?"selected":"") %> value="<%=itemID.get(c) %>"><%=itemDesc.get(c) %></option>
<%} %>
			</select>
			<input type="hidden" id="donationItem" name="donationItem" value="<%=donationItem==null?"":donationItem%>"  maxlength="30" size="25"/>
<%	} else { %>
			<%int index = itemID.indexOf( donationItem ); %>
			<%if (index == -1){}else{ %>
				<%=itemDesc.get(index) %>
			<%} %>

<%	} %>
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="15%">Campaign</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select id="campaignID" name="campaignID" class="doInfo">
				<option value=""></option>
<% for(int c=0;c<campaignID.size();c++){%>
				<option <%=((campaign.equals(campaignID.get(c)))?"selected":"") %> value="<%=campaignID.get(c) %>"><%=campaignDesc.get(c) %></option>
<%} %>
			</select>
			<input type="hidden" id="campaign" name="campaign" value="<%=campaign==null?"":campaign%>"  maxlength="30" size="25"/>
<%	} else { %>
			<%int index = campaignID.indexOf( campaign ); %>
			<%if (index == -1){}else{ %>
				<%=campaignDesc.get(index) %>
			<%} %>		
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Event</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select id="eventID" name="eventID" class="doInfo">
				<option value=""></option>
<% for(int e=0;e<eventID.size();e++){%>
				<option <%=((event.equals(eventID.get(e)))?"selected":"") %> value="<%=eventID.get(e) %>"><%=eventDesc.get(e) %></option>
<%} %>
			</select>
			<input type="hidden" id="event" name="event" value="<%=event==null?"":event%>"  maxlength="30" size="25"/>
<%	} else { %>
			<%int index = eventID.indexOf( event ); %>
			<%if (index == -1){}else{ %>
				<%=eventDesc.get(index) %>
			<%} %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Remarks</td>
		<td class="infoData" colspan="3">
<%	if (createAction || updateAction) { %>
			<textarea name = "remarks" style='height:50px;width:100%'><%=remarks==null?"":remarks%></textarea>
		 
<%	} else { %>
			<%=remarks==null?"":remarks %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Donation Method</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Donation Method</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="radio" name="donationMethod" onClick="changePayment('creditCard')" <%=((donationMethod!=null&&donationMethod.equals("Credit Card")) || createAction?"checked":"") %> value="Credit Card"> Credit Card
			<input type="radio" name="donationMethod" onClick="changePayment('cheque')" <%=((donationMethod!=null&&donationMethod.equals("Cheque"))?"checked":"")%> value="Cheque">Cheque
			<input type="radio" name="donationMethod" onClick="changePayment('bank-in')" <%=((donationMethod!=null&&donationMethod.equals("Bank-in Account"))?"checked":"")%> value="Bank-in Account">Bank-in Account
			<input type="radio" name="donationMethod" onClick="changePayment('payroll')" <%=((donationMethod!=null&&donationMethod.equals("Payroll"))?"checked":"")%> value="Payroll">Payroll
			<input type="radio" name="donationMethod" onClick="changePayment('cash')" <%=((donationMethod!=null&&donationMethod.equals("Cash"))?"checked":"")%> value="Cash">Cash
<%  } else { %>					
			<%=donationMethod%>			
<%  } %>
		</td>		
	</tr>
	
	
	<tr  class="smallText creditCardInput" style="display:none">
		<td class="infoLabel" width="15%">Card Type</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="cardType">
			<option <%=((cardType!=null&&cardType.equals("VISA")) || createAction?"selected":"") %> value="VISA">VISA</option>
			<option <%=((cardType!=null&&cardType.equals("MasterCard"))?"selected":"") %> value="MasterCard">MasterCard</option>		
			<option <%=((cardType!=null&&cardType.equals("JCB"))?"selected":"") %> value="JCB">JCB</option>		
			<option <%=((cardType!=null&&cardType.equals("Diners Club"))?"selected":"") %> value="Diners Club">Diners Club</option>		
			<option <%=((cardType!=null&&cardType.equals("American Express"))?"selected":"") %> value="American Express">American Express</option>		
			
			</select>
<%  } else {  %>
			<%=cardType==null?"":cardType %>
<%  } %>
		</td>
		<td class="infoLabel" width="15%">Card Number<font color="red">*</font></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" id="cardNo" name="cardNo" value="<%=cardNo==null?"":cardNo%>"  maxlength="30" size="25"/>
<%  } else {  %>
			<%=cardNo==null?"":cardNo %>
<%  } %>
		</td>
	</tr>
	
	<tr class="smallText creditCardInput" style="display:none">
		<td class="infoLabel" width="15%">Expire Date</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
				<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
					<jsp:param name="label" value="cardExpireDate" />		
					<jsp:param name="yearRange" value="10" />									
					
					<jsp:param name="day_yy" value="<%=cardExpireDate_yy %>" />
					<jsp:param name="day_mm" value="<%=cardExpireDate_mm %>" />
					<jsp:param name="defaultValue" value="N" />
					<jsp:param name="showTime" value="N" />
					<jsp:param name="YearAndMonth" value="Y" />
					<jsp:param name="isObBkUse" value="Y"/>
				</jsp:include>
<%  } else {  %>
			<%=cardExpireDate_mm==null?"":cardExpireDate_mm %> / <%=cardExpireDate_yy==null?"":cardExpireDate_yy %>
<%  } %>
		</td>
		<td class="infoLabel" width="15%">Cardholder's Name<font color="red">*</font></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" id="cardholderName" name="cardholderName" value="<%=cardholderName==null?"":cardholderName%>"  maxlength="30" size="25"/>
<%  } else {  %>
			<%=cardholderName==null?"":cardholderName %>
<%  } %>
		</td>
	</tr>
	
	<tr style="display:none" class="smallText chequeInput">
		<td class="infoLabel" width="15%">Cheque Number<font color="red">*</font></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
		<input type="textfield" id="chequeNo" name="chequeNo" value="<%=chequeNo==null?"":chequeNo%>"  maxlength="30" size="25"/>
<%  } else {  %>
			<%=chequeNo==null?"":chequeNo %>
<%  } %>
		</td>		
	</tr>
	
	
	<tr style="display:none" class="smallText bank-inInput">
		<td class="infoLabel" width="15%">Bank-in account<font color="red">*</font></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
		<input type="textfield" id="bankinAccount" name="bankinAccount" value="<%=bankinAccount==null?"":bankinAccount%>"  maxlength="30" size="25"/>
<%  } else {  %>
			<%=bankinAccount==null?"":bankinAccount %>
<%  } %>
		</td>		
	</tr>
	
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Receipt Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Receipt ID</td>
		<td class="infoData" width="35%">
<%	if (createAction) { %>
		<input type="textfield" id="receiptID" name="receiptID" value="<%=receiptID==null?"":receiptID%>"  maxlength="30" size="25"/>
<%  } else {  %>
			<%=receiptID==null?"":receiptID %>
			<input type="hidden" id="receiptID" name="receiptID" value="<%=receiptID==null?"":receiptID%>"  maxlength="30" size="25"/>
<%  } %>
		</td>
	</tr>
	
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
		<%	if (createAction || updateAction) { %>
			<button type="button" onclick="return submitAction('<%=commandType %>', 1);"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
		<% }else{ %>
			<button type="button" onclick="return submitAction('update', 0);" class="btn-click" <% if(valid){}else{%>disabled<%} %>><bean:message key="function.donation.update" /></button>
			<button type="button" onclick="return deleteAction('delete', 1);" class="btn-click" <% if(valid){}else{%>disabled<%} %>><bean:message key="function.donation.delete" /></button>
			<button type="button" onclick="return printReceipt();" class="btn-click" <% if(valid && receiptID.length()!=0){}else{%>disabled<%} %>><bean:message key="function.donation.print" /></button>
		<% } %>
		<button type="button" onclick="return returnRelativeList();" class="btn-click"><bean:message key="button.close" /> - <bean:message key="<%=title %>" /></button>
			
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command"/>
<input type="hidden" name="step"/>
<input type="hidden" id="donationID" name="donationID" value="<%=donationID %>"/>

</form>
<script language="javascript">	
	function deleteAction(cmd,stp){
		  var deleteRecord = confirm("Delete record ?");
		   if( deleteRecord == true ){
			   submitAction(cmd,stp);
		   }
	}

	function submitAction(cmd, stp) {
		var success = true;
		var msg = '';	
		var count = 1;
		$(".hightLight").removeClass();
			
		if(stp==1 ){
			if(cmd!='delete'){		
				
				if($.trim($('#transactionDate').val()) == ''){
					msg = msg + (count++) + '. ';
					msg = msg + 'Donation Date.\n';
					$('#transactionDate').addClass("hightLight");
					success = false;
				}
				if(!validDate(document.form1.transactionDate)){
					msg = msg + (count++) + '. ';
					msg = msg + 'Invalid Donation Date.\n';
					$('#transactionDate').addClass("hightLight");
					success = false;
				}
				if($.trim($('#donationAmount').val()) == ''){
					msg = msg + (count++) + '. ';
					msg = msg + 'Donation Amount.\n';
					$('#donationAmount').addClass("hightLight");
					success = false;
				}
				if(($("input[name=donationMethod]:checked").val()=='Credit Card')){
					if($.trim($('#cardNo').val()) == ''){
						msg = msg + (count++) + '. ';
						msg = msg + 'Card Number.\n';
						$('#cardNo').addClass("hightLight");
						success = false;
					}
					if($.trim($('#cardholderName').val()) == ''){
						msg = msg + (count++) + '. ';
						msg = msg + 'Cardholder\'s Name.\n';
						$('#cardholderName').addClass("hightLight");
						success = false;
					}
				}else if(($("input[name=donationMethod]:checked").val()=='Cheque')){
					if($.trim($('#chequeNo').val()) == ''){
						msg = msg + (count++) + '. ';
						msg = msg + 'Cheque Number.\n';
						$('#chequeNo').addClass("hightLight");
						success = false;
					}					
				}else if(($("input[name=donationMethod]:checked").val()=='Bank-in Account')){
					if($.trim($('#bankinAccount').val()) == ''){
						msg = msg + (count++) + '. ';
						msg = msg + 'Bank-in Account.\n';
						$('#bankinAccount').addClass("hightLight");
						success = false;
					}				
				}
			}
		}
		
		if(success==false){
			msg = 'The following fields are missing or invalid. Please choose or enter:\n' + msg + '\n';
			alert(msg);
			return false;
		}
		
		var itemSeleted = $('#donationItemID option:selected' ).val();
		$('#donationItem').val(itemSeleted);
		var campaignSeleted = $('#campaignID option:selected' ).val();
		$('#campaign').val(campaignSeleted);
		var eventSeleted = $('#eventID option:selected' ).val();
		$('#event').val(eventSeleted);
		
		if($.trim($('#receiptID').val()) == '' && cmd == "create"){
			var action = confirm("Receipt ID cannot be add / update after save. \nDo you want to save donation with no receipt?");
			if(action == true){
				document.form1.command.value = cmd;
				document.form1.step.value = stp;			
				document.form1.submit();
			}else{
				return false;
			}
		}else{
			document.form1.command.value = cmd;
			document.form1.step.value = stp;			
			document.form1.submit();
		}
	}
	
	function returnRelativeList(cid) {
		document.form1.action = "donor_transaction_list.jsp";		
		document.form1.submit();
	}
	
	function changePayment(id) {
		if(id=='creditCard'){			
			$('.creditCardInput').show();
			$('.chequeInput').hide();
			$('.bank-inInput').hide();
		}else if (id=='cheque'){
			$('.creditCardInput').hide();
			$('.chequeInput').show();
			$('.bank-inInput').hide();
			
		}else if (id=='bank-in'){
			$('.creditCardInput').hide();
			$('.chequeInput').hide();
			$('.bank-inInput').show();
			
		}else if (id=='payroll'){
			$('.creditCardInput').hide();
			$('.chequeInput').hide();
			$('.bank-inInput').hide();
			
		}else if (id=='cash'){
			$('.creditCardInput').hide();
			$('.chequeInput').hide();
			$('.bank-inInput').hide();
		}
	}
	
	
	
	$(document).ready(function() {			
	<%if (closeAction) { %>
		returnRelativeList('<%=clientID%>');
	<%}%>
	
	<%if(createAction){%>
		changePayment('creditCard');

	<%}%>
	
	<%if(donationMethod != null && donationMethod.equals("Credit Card")){%>
		changePayment('creditCard');
	<%}else if(donationMethod != null && donationMethod.equals("Cheque")){%>
		changePayment('cheque');
	<%}else if(donationMethod != null && donationMethod.equals("Bank-in Account")){%>
		changePayment('bank-in');
	<%}else if(donationMethod != null && donationMethod.equals("Payroll")){%>
		changePayment('payroll');
	<%}else if(donationMethod != null && donationMethod.equals("Cash")){%>
		changePayment('cash');
	<%}%>
	
	$("#donationAmount").keypress(function (e) {	     
	    return checkTextBoxIsDigit(e);
	   });
		
	});
	
	function checkTextBoxIsDigit(e){
		if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
	         return false;
	    }
	}
	
	function printReceipt(){
		var donationID = $('#donationID').val();
		var receiptID = $('#receiptID').val();
		var w = 1100;
		var h = 900;
		var t = 0;
		var l = 0;
		var props = "channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,";
		props += "scrollbars=yes,status=no,titlebar=no,toolbar=no,";
		props += "top=" + t + ",left=" + l + ",height=" + h + ",width=" + w;

		win = window.open("", "_blank", props, false);
		win.location.href = "print_donation_receipt.jsp?donationID="+donationID+"&receiptID="+receiptID;
		document.form1.command.value = "printed";
		document.form1.submit();
	}
	
	$( "#campaignID" )
	  .change(function() {
	    var campaignSeleted = $('#campaignID option:selected' ).val();
	    $.ajax({
	        url: "/intranet/crm/getEventList.jsp",
	        data: {"campaign" : campaignSeleted },
	        type: 'POST',
	        dataType: 'html',
			cache: false,
	        success: function(data){
	        	$( "#eventID" ).html( data );
	        },
	       	error: function(data){
	       		console.log("error");
	       	}
	    });
	  })
</script>
</div>
</div>
</div>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>