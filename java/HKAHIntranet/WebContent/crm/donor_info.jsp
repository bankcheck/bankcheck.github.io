<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%!
public static String add(UserBean userBean,String lastName,String firstName,String chineseName,String street1,
		String street2,String street3,String street4,String homeNumber,String mobileNumber,String faxNumber,String officeNumber,
		String email,String acceptPromotion, String remarks, String photoName,String description,String organization,String salutation,String clientID) {

	// get next client ID
	clientID = getNextClientID();
		
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("INSERT INTO CRM_CLIENTS "); 
	sqlStr.append(" (CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME, ");
	sqlStr.append(" CRM_CHINESENAME, CRM_STREET1, CRM_STREET2, CRM_STREET3, CRM_STREET4, ");
	sqlStr.append(" CRM_HOME_NUMBER,CRM_MOBILE_NUMBER, CRM_FAX_NUMBER, CRM_OFFICE_NUMBER, ");
	sqlStr.append(" CRM_EMAIL, CRM_WILLING_PROMOTION, CRM_REMARKS, CRM_PHOTO_NAME, "); 
	sqlStr.append(" CRM_ORGANIZATION, CRM_SALUTATION, CRM_DESCRIPTION,CRM_DONOR, "); 
	sqlStr.append(" CRM_CREATED_USER, CRM_CREATED_SITE_CODE, CRM_CREATED_DEPARTMENT_CODE, CRM_MODIFIED_USER) ");
	sqlStr.append(" VALUES "); 
	sqlStr.append("('"+clientID+"','"+lastName+"','"+firstName+"','"+chineseName+"','"+street1+"', ");
	sqlStr.append("'"+street2+"','"+street3+"','"+street4+"','"+homeNumber+"','"+mobileNumber+"', ");
	sqlStr.append("'"+faxNumber+"', '"+officeNumber+"', '"+email+"', '"+acceptPromotion+"', '"+remarks+"', '"+photoName+"', ");
	sqlStr.append("'"+organization+"','"+salutation+"','"+description+"','Y', ");	
	sqlStr.append("'"+userBean.getLoginID()+"', ");
	sqlStr.append("'"+userBean.getSiteCode()+"','"+userBean.getDeptCode()+"','"+userBean.getLoginID()+"')");
	// try to insert a new record
		
	System.out.println(sqlStr.toString());
	
	if (UtilDBWeb.updateQueue(sqlStr.toString() )) {	
		return clientID;
	} else {
		return null;
	}
}

public static boolean addAccountInfo(UserBean userBean,String donationID,String clientID,
		String cardType,String cardNo,String cardExpireDate_yy,String cardExpireDate_mm,String cardholderName
		,String bankinAccount) {

	StringBuffer sqlStr = new StringBuffer();
	
	
	sqlStr.append("INSERT INTO CRM_CLIENTS_DONATION ");  
	sqlStr.append("(CRM_DONATION_ID,CRM_CLIENT_ID,CRM_STATUS, "); 
	sqlStr.append("CRM_CREDITCARD_TYPE,CRM_CREDITCARD_NUMBER,CRM_CREDITCARD_EXPIREDATE,CRM_CREDITCARD_HOLDERNAME, "); 
	sqlStr.append("CRM_BANKIN_ACCOUNT, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
	sqlStr.append("VALUES "); 
	sqlStr.append("('"+donationID+"','"+clientID+"', ");
	sqlStr.append("'client_info', ");
	sqlStr.append("'"+cardType+"','"+cardNo+"', ");
	if(cardExpireDate_mm != null && cardExpireDate_mm.length() > 0 && cardExpireDate_yy != null && cardExpireDate_yy.length() > 0){
		sqlStr.append("TO_DATE('1/"+cardExpireDate_mm+"/"+cardExpireDate_yy+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), ");
	}else{
		sqlStr.append("'', ");
	}
	sqlStr.append("'"+cardholderName+"', ");
	sqlStr.append("'"+bankinAccount+"',");
	sqlStr.append("'"+userBean.getLoginID()+"','"+userBean.getLoginID()+"') ");	
		
	System.out.println(sqlStr.toString());
	
	if (UtilDBWeb.updateQueue(sqlStr.toString() )) {	
		return true;
	} else {
		return false;
	}
}

public static boolean editAccountInfo(UserBean userBean,String clientID,
		String cardType,String cardNo,String cardExpireDate_yy,String cardExpireDate_mm,String cardholderName
		,String bankinAccount){	
	StringBuffer sqlStr = new StringBuffer();

	
	sqlStr.append("UPDATE CRM_CLIENTS_DONATION ");
	sqlStr.append("SET ");
	
	sqlStr.append("CRM_CREDITCARD_TYPE='"+cardType+"',CRM_CREDITCARD_NUMBER='"+cardNo+"', ");
	if(cardExpireDate_mm != null && cardExpireDate_mm.length() > 0 && cardExpireDate_yy != null && cardExpireDate_yy.length() > 0){
		sqlStr.append("CRM_CREDITCARD_EXPIREDATE=TO_DATE('1/"+cardExpireDate_mm+"/"+cardExpireDate_yy+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), ");
	}else{
		sqlStr.append("CRM_CREDITCARD_EXPIREDATE='', ");
	}
    sqlStr.append("CRM_CREDITCARD_HOLDERNAME='"+cardholderName+"', ");
	sqlStr.append("CRM_BANKIN_ACCOUNT='"+bankinAccount+"',");			
	sqlStr.append("CRM_MODIFIED_DATE=SYSDATE,CRM_MODIFIED_USER='"+userBean.getLoginID()+"' ");	
	sqlStr.append("WHERE    CRM_CLIENT_ID = '"+clientID+"'  ");
	sqlStr.append("AND      CRM_STATUS LIKE ('client_info') ");
	sqlStr.append("AND      CRM_ENABLED ='1' ");	
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

private static String getNextClientID() {
	String clientID = null;

	// get next schedule id from db
	ArrayList result = UtilDBWeb.getReportableList(
			"SELECT MAX(CRM_CLIENT_ID) + 1 FROM CRM_CLIENTS");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		clientID = reportableListObject.getValue(0);

		// set 1 for initial
		if (clientID == null || clientID.length() == 0) return "1";
	}
	return clientID;
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

public static ArrayList checkAccountInfoExists(String clientID){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT CRM_DONATION_ID  ");	
	sqlStr.append("FROM   CRM_CLIENTS_DONATION ");
	sqlStr.append("WHERE  CRM_CLIENT_ID ='"+clientID+"' ");
	sqlStr.append("AND    CRM_STATUS LIKE ('client_info') ");
	sqlStr.append("AND    CRM_ENABLED ='1' ");	

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}


public static ArrayList getClientInfo(String clientID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME,  C.CRM_CHINESENAME, C.CRM_STREET1, ");   
	sqlStr.append("C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, C.CRM_HOME_NUMBER, C.CRM_MOBILE_NUMBER, "); 
	sqlStr.append("C.CRM_FAX_NUMBER,  C.CRM_EMAIL, C.CRM_PHOTO_NAME,        C.CRM_ORGANIZATION, CRM_SALUTATION, ");  
	sqlStr.append("C.CRM_DESCRIPTION,CRM_DONOR,  C.CRM_CREATED_USER, C.CRM_CREATED_SITE_CODE,      ");
	sqlStr.append("C.CRM_CREATED_DEPARTMENT_CODE, C.CRM_MODIFIED_USER, ");
	sqlStr.append("D.CRM_CREDITCARD_TYPE,CRM_CREDITCARD_NUMBER,TO_CHAR(D.CRM_CREDITCARD_EXPIREDATE, 'MM/YYYY'), ");
	sqlStr.append("D.CRM_CREDITCARD_HOLDERNAME,  ");
	sqlStr.append("D.CRM_BANKIN_ACCOUNT , C.CRM_OFFICE_NUMBER, C.CRM_WILLING_PROMOTION, C.CRM_REMARKS ");
	sqlStr.append("from   CRM_CLIENTS C, CRM_CLIENTS_DONATION D ");
	sqlStr.append("where  C.CRM_CLIENT_ID = '"+clientID+"'  ");
	sqlStr.append("and    C.CRM_CLIENT_ID = D.CRM_CLIENT_ID(+) ");
	sqlStr.append("and    D.CRM_STATUS(+) = 'client_info' ");
	sqlStr.append("AND    D.CRM_ENABLED(+) = 1 ");
		
	System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean update(UserBean userBean,String lastName,String firstName,String chineseName,String street1,
		String street2,String street3,String street4,String homeNumber,String mobileNumber,String faxNumber, String officeNumber, 
		String email, String acceptPromotion, String remarks, String photoName,String description,String organization,String salutation,String clientID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS ");
	sqlStr.append("SET CRM_LASTNAME = '"+lastName+"', CRM_FIRSTNAME = '"+firstName+"',  CRM_CHINESENAME = '"+chineseName+"', CRM_STREET1= '"+street1+"', ");
	sqlStr.append("CRM_STREET2 = '"+street2+"', CRM_STREET3 = '"+street3+"', CRM_STREET4 = '"+street4+"', ");
	sqlStr.append("CRM_HOME_NUMBER = '"+homeNumber+"',CRM_MOBILE_NUMBER = '"+mobileNumber+"', CRM_FAX_NUMBER = '"+faxNumber+"', CRM_OFFICE_NUMBER = '"+officeNumber+"', ");
	sqlStr.append("CRM_EMAIL = '"+email+"', CRM_WILLING_PROMOTION= '"+acceptPromotion+"', CRM_REMARKS ='"+remarks+"', CRM_PHOTO_NAME= '"+photoName+"', ");
	sqlStr.append("CRM_ORGANIZATION = '"+organization+"' , CRM_SALUTATION = '"+salutation+"', ");
	sqlStr.append("CRM_DESCRIPTION = '"+description+"', CRM_MODIFIED_USER = '"+userBean.getLoginID()+"',CRM_MODIFIED_DATE=SYSDATE ");
	sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientID+"' ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean delete(UserBean userBean, String clientID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS ");
	sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
	sqlStr.append("WHERE  CRM_ENABLED = 1 ");
	sqlStr.append("AND    CRM_CLIENT_ID = '"+clientID+"' ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}
%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = true;
}

UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String message = TextUtil.parseStr(ParserUtil.getParameter(request, "message"));
String errorMessage = "";

String lastName = TextUtil.parseStr(ParserUtil.getParameter(request, "lastName")).toUpperCase();
String firstName = TextUtil.parseStr(ParserUtil.getParameter(request, "firstName")).toUpperCase();
String chineseName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "chineseName"));
String organization = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "organization"));
String salutation = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "salutation"));
String homeNumber = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "homeNumber"));
String mobileNumber = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mobileNumber"));
String faxNumber = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "faxNumber"));
String officeNumber = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "officeNumber"));
String email = ParserUtil.getParameter(request, "email");
String street1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "street1"));
String street2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "street2"));
String street3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "street3"));
String street4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "street4"));
String description = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "description"));
String remarks = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remarks"));
String acceptPromotion = ParserUtil.getParameter(request, "acceptPromotion");

String clientID = ParserUtil.getParameter(request, "clientID");

String photoName= TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "photoName"));
String prevPhotoName= TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "prevPhotoName"));
String[] fileList = (String[]) request.getAttribute("filelist");


String cardType = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cardType"));
String cardNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cardNo"));
String cardExpireDate_yy = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cardExpireDate_yy"));
String cardExpireDate_mm = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cardExpireDate_mm"));
String cardholderName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cardholderName"));	

String bankinAccount = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bankinAccount"));


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

/*
if(createAction && !"1".equals(step)){
	clientID = getNextClientID() ;
}*/

if (fileList != null) {
	StringBuffer tempStrBuffer = new StringBuffer();

	tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append("crm");
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append(clientID);
	tempStrBuffer.append(File.separator);
	String baseUrl = tempStrBuffer.toString();
	tempStrBuffer.setLength(0);

	for (int i = 0; i < fileList.length; i++) {	
		//System.out.println(ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i]);
		//System.out.println(baseUrl + fileList[i]);
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
			baseUrl + fileList[i]
		);
	};
}

try {
	if ("1".equals(step)) {
		if (createAction) {	
			clientID = add(userBean, lastName, firstName, chineseName, street1,
					 street2, street3, street4, homeNumber, mobileNumber, faxNumber, officeNumber,
					 email, (acceptPromotion!=null&&acceptPromotion.length()>0?acceptPromotion:"Y"), remarks, photoName, description, organization, salutation, clientID);			
			if (clientID != null) {
				addAccountInfo(userBean,getNextDonationID(),clientID,
						cardType,cardNo,cardExpireDate_yy,cardExpireDate_mm,cardholderName
						,bankinAccount);
				
				message = "Client created.";
				createAction = false;
				step = null;
			} else {
				errorMessage = "Client create fail.";
			}
		} else if (updateAction) {
			if (update(userBean, lastName, firstName, chineseName, street1,
					 street2, street3, street4, homeNumber, mobileNumber, faxNumber, officeNumber, 
					 email,acceptPromotion, remarks, (photoName!=null&&photoName.length()>0?photoName:prevPhotoName),
					 description,organization,salutation,clientID)) {
				ArrayList accountInfoRecord = checkAccountInfoExists(clientID);	
				
				if(accountInfoRecord.size() == 0)	{
					addAccountInfo(userBean,getNextDonationID(),clientID,
							cardType,cardNo,cardExpireDate_yy,cardExpireDate_mm,cardholderName
							,bankinAccount);
				}else{
					editAccountInfo(userBean,clientID,
							cardType,cardNo,cardExpireDate_yy,cardExpireDate_mm,cardholderName
							,bankinAccount);
				}				
				
				message = "Client updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "Client update fail.";
			}
		}else if (deleteAction) {
			if (delete(userBean, clientID)) {
				message = "Client removed.";				
				step = null;
				closeAction = true;
			} else {
				errorMessage = "Client remove fail.";
			}
		}
	} 
	
	if (clientID != null && clientID.length() > 0) {
		ArrayList record= getClientInfo(clientID);		
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			
			lastName = row.getValue(1);
			firstName = row.getValue(2); 
			chineseName = row.getValue(3);
			organization = row.getValue(13);
			salutation = row.getValue(14);
			homeNumber = row.getValue(8);
			mobileNumber = row.getValue(9);
			faxNumber = row.getValue(10);
			officeNumber = row.getValue(26);
			email = row.getValue(11);
			acceptPromotion = row.getValue(27);
			remarks= row.getValue(28);
			street1 = row.getValue(4);
			street2 = row.getValue(5);
			street3 = row.getValue(6);
			street4 = row.getValue(7);
			description = row.getValue(15);
			clientID = row.getValue(0);
			photoName= row.getValue(12);
			
			
			cardType = row.getValue(21);
			cardNo = row.getValue(22);
			if(row.getValue(23).contains("/")){
				cardExpireDate_yy = row.getValue(23).split("/")[1];
				cardExpireDate_mm = row.getValue(23).split("/")[0];
			}			
			cardholderName = row.getValue(24);
			bankinAccount = row.getValue(25);

			
		} else {
			
		}
	}
} catch (Exception e) {
	e.printStackTrace();
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
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%}%>
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
	title = "function.donor." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1"  enctype="multipart/form-data" method="post" action="donor_info.jsp">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" style="width:100%">
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Donor Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName%>"  maxlength="30" size="25"/>
<%	} else { %>
			<%=lastName==null?"":lastName %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>"  maxlength="60" size="25"/>
<%	} else { %>
			<%=firstName==null?"":firstName %>
<%	} %>
		</td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="chineseName" value="<%=chineseName==null?"":chineseName %>" maxlength="20" size="25"/>
<%	} else { %>
			<%=chineseName==null?"":chineseName %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Organization</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="organization" value="<%=organization==null?"":organization%>"  maxlength="60" size="25"/>
<%	} else { %>
			<%=organization==null?"":organization %>
<%	} %>
		</td>	
	</tr>
	
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Contact Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.street" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="street1" value="<%=street1==null?"":street1%>" maxlength="50" size="25"/>
<%	} else { %>
			<%=street1==null?"":street1 %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.homePhone" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="homeNumber" value="<%=homeNumber==null?"":homeNumber%>" maxlength="20" size="25"/>
<%	} else { %>
			<%=homeNumber==null?"":homeNumber %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">&nbsp;</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="street2" value="<%=street2==null?"":street2%>" maxlength="50" size="25"/>
<%	} else { %>
			<%=street2==null?"":street2 %>
<%	} %>
		</td>		
		<td class="infoLabel" width="15%"><bean:message key="prompt.faxPhone" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="faxNumber" value="<%=faxNumber==null?"":faxNumber%>" maxlength="20" size="25"/>
<%	} else { %>
			<%=faxNumber==null?"":faxNumber %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">&nbsp;</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="street3" value="<%=street3==null?"":street3%>" maxlength="50" size="25"/>
<%	} else { %>
			<%=street3==null?"":street3 %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.mobilePhone" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="mobileNumber" value="<%=mobileNumber==null?"":mobileNumber%>" maxlength="20" size="25"/>
<%	} else { %>
			<%=mobileNumber==null?"":mobileNumber %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">&nbsp;</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="street4" value="<%=street4==null?"":street4%>" maxlength="50" size="25"/>
<%	} else { %>
			<%=street4==null?"":street4 %>
<%	} %>
		</td>		
		<td class="infoLabel" width="15%"><bean:message key="prompt.officePhone" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="officeNumber" value="<%=officeNumber==null?"":officeNumber%>" maxlength="30" size="25"/>
<%	} else { %>
			<%=officeNumber==null?"":officeNumber%>
<%	} %>
		</td>
	</tr>
	<tr>		
		<td class="infoLabel" width="15%"><bean:message key="prompt.email" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="email" value="<%=email==null?"":email%>" maxlength="30" size="25"/>
<%	} else { %>
			<%=email==null?"":email%>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Allow Promotion</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="radio" name="acceptPromotion" value="Y" <%="Y".equals(acceptPromotion)?"checked":"" %> />Yes 
			<input type="radio" name="acceptPromotion" value="N" <%="N".equals(acceptPromotion)?"checked":"" %> />No
<%	} else { %>
			<%="Y".equals(acceptPromotion)?"Yes":"N".equals(acceptPromotion)?"No":"" %>
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
		<td class="infoTitle" colspan="4">Personal Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Salutation</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="salutation" value="<%=salutation==null?"":salutation%>" maxlength="20" size="25"/>
<%	} else { %>
			<%=salutation==null?"":salutation%>
<%	} %>
		</td>
		<td rowspan="2" class="infoLabel" width="15%">Description</td>
		<td  rowspan="2" class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<textarea name = "description" style='height:50px;width:100%'><%=description==null?"":description%></textarea>
		 
<%	} else { %>
			<%=description==null?"":description %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel">Photo</td>
		<td class="infoData" >
<%	if (createAction || updateAction) { %>
			<input type="file" name="photoName" size="50" class="multi" maxlength="1"/>
<%	} %>
<%	if (!updateAction && photoName != null && photoName.length() > 0 && !"null".equals(photoName)) { %>
			<img src="/upload/crm/<%=clientID %>/<%=photoName%>"/>
<%	} %>
			<br/>(Small Size < 100K)
		</td>						
	</tr>
	

	
	
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Credit Card Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Card Type</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="cardType">
			<option value=""></option>
			<option <%=((cardType!=null&&cardType.equals("VISA"))?"selected":"") %> value="VISA">VISA</option>
			<option <%=((cardType!=null&&cardType.equals("MasterCard"))?"selected":"") %> value="MasterCard">MasterCard</option>		
			<option <%=((cardType!=null&&cardType.equals("JCB"))?"selected":"") %> value="JCB">JCB</option>		
			<option <%=((cardType!=null&&cardType.equals("Diners Club"))?"selected":"") %> value="Diners Club">Diners Club</option>		
			<option <%=((cardType!=null&&cardType.equals("American Express"))?"selected":"") %> value="American Express">American Express</option>
			</select>
<%  } else {  %>
			<%=cardType==null?"":cardType %>
<%  } %>
		</td>
		<td class="infoLabel" width="15%">Card Number</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" id="cardNo" name="cardNo" value="<%=cardNo==null?"":cardNo%>"  maxlength="30" size="25"/>
<%  } else {  %>
			<%=cardNo==null?"":cardNo %>
<%  } %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Expire Date</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
				<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
					<jsp:param name="label" value="cardExpireDate" />		
					<jsp:param name="yearRange" value="10" />									
					<jsp:param name="allowEmpty" value="Y" />
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
		<td class="infoLabel" width="15%">Cardholder's Name</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" id="cardholderName" name="cardholderName" value="<%=cardholderName==null?"":cardholderName%>"  maxlength="30" size="25"/>
<%  } else {  %>
			<%=cardholderName==null?"":cardholderName %>
<%  } %>
		</td>
	</tr>
	
	
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Bank-in Account Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Bank-in Account</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
		<input type="textfield" id="bankinAccount" name="bankinAccount" value="<%=bankinAccount==null?"":bankinAccount%>"  maxlength="30" size="25"/>
<%  } else {  %>
			<%=bankinAccount==null?"":bankinAccount %>
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
			<%	if (createAction) { %>
				<button type="button" onclick="return submitAction('close', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
			
			<%  }else{ %>
				<button type="button" onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
			
			<%	} %>
		<% }else{ %>
			<button type="button" onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.donor.update" /></button>
			<button type="button" onclick="return deleteAction('delete', 1);" class="btn-click"><bean:message key="function.donor.delete" /></button>
			
		<% } %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command"/>
<input type="hidden" name="step"/>
<input type="hidden" name="prevPhotoName" value="<%=photoName %>"/>
<input type="hidden" name="clientID" value="<%=clientID %>"/>
</form>
<script language="javascript">	
	function deleteAction(cmd,stp){
		  var deleteRecord = confirm("Delete record ?");
		   if( deleteRecord == true ){
			   submitAction(cmd,stp);
		   }
	}


	function submitAction(cmd, stp) {	
		document.form1.command.value = cmd;
		document.form1.step.value = stp;			
		document.form1.submit();
	}
</script>
</div>
</div>
</div>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>