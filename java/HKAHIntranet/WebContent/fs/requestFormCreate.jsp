<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.wsclient.lombardiWS.*"%>
<%@ page import="oracle.jdbc.*"%>
<%@ page import="oracle.sql.ArrayDescriptor"%>
<%@ page import="oracle.sql.ARRAY"%>
<%@ page import="oracle.sql.StructDescriptor"%>
<%@ page import="oracle.sql.STRUCT"%>
<%@ page import="oracle.jdbc.OracleTypes"%>
<%@ page import="java.sql.*"%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER,
		"UTF-8"
	);
	
	fileUpload = true;
}

UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String reqNo = ParserUtil.getParameter(request, "reqNo");
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");
String deptCode = userBean.getDeptCode();
String eventID = ParserUtil.getParameter(request, "eventID");
String serverSiteCode = ConstantsServerSide.SITE_CODE;
//if (eventID == null) {
//	eventID = "1301";
//}
String venue = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "venue"));
if(venue!=null){
	venue=venue.trim();
}
String mealID = ParserUtil.getParameter(request, "mealID");
String mealEvent = ParserUtil.getParameter(request, "mealEvent");
String reqByName = StaffDB.getStaffFullName2(userBean.getStaffID());
String reqSiteCode = ConstantsServerSide.SITE_CODE;
String requestType = ParserUtil.getParameter(request, "requestType");
String reqDept = ParserUtil.getParameter(request, "reqDept");
String chargeTo = ParserUtil.getParameter(request, "chargeTo");
String reqBy = userBean.getStaffID();
String reqDate = ParserUtil.getParameter(request, "reqDate");
String otherMeal = ParserUtil.getParameter(request, "otherMeal");
String contactTel = ParserUtil.getParameter(request, "contactTel");
String estAmount = ParserUtil.getParameter(request, "estAmount");

String servDate = ParserUtil.getParameter(request, "servDate");
String servDateStartTime = null;
String servDateEndTime = null;
String servDateStartDateTime = null; 

String servDateStartTime_hh = ParserUtil.getParameter(request, "servDateStartTime_hh");
String servDateStartTime_mi = ParserUtil.getParameter(request, "servDateStartTime_mi");
String servDateEndDateTime = null;
String servDateEndTime_hh = ParserUtil.getParameter(request, "servDateEndTime_hh");
String servDateEndTime_mi = ParserUtil.getParameter(request, "servDateEndTime_mi");

servDateStartTime = servDateStartTime_hh + ":" + servDateStartTime_mi + ":00";
servDateStartDateTime = servDate + " " + servDateStartTime;
servDateEndTime = servDateEndTime_hh + ":" + servDateEndTime_mi + ":00";
servDateEndDateTime = servDate + " " + 	servDateEndTime;
String noOfPerson = ParserUtil.getParameter(request, "noOfPerson");
String otherReq = ParserUtil.getParameter(request, "otherReq");
String otherChg = ParserUtil.getParameter(request, "otherChg");

if(noOfPerson==null){
	noOfPerson="0";
}else{
	noOfPerson=noOfPerson.trim();
}
if(estAmount==null){
	estAmount="0";
}else{
	estAmount=estAmount.trim();
}
String purpose = ParserUtil.getParameter(request, "purpose");
if(purpose!=null){
	purpose = purpose.replaceAll("'","''");	
	purpose=purpose.trim();
}
String specReq = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "specReq"));
if(specReq!=null){
	specReq = specReq.replaceAll("'","''");
	specReq=specReq.trim();
}
String sendAppTo = ParserUtil.getParameter(request, "sendAppTo");	
String selectedApprover = null;
String reqStatus = ParserUtil.getParameter(request, "reqStatus");
String deptHead = null;
String priceRange = ParserUtil.getParameter(request, "priceRange");
if(priceRange==null){
	priceRange="0";
}else{
	priceRange=priceRange.trim();
}
Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("ddMMyyyyHHmmss");
String sysDate = dateFmt.format(cal.getTime());
String chargeAmount = ParserUtil.getParameter(request, "chargeAmount");
String menu = null;

ArrayList record1 = null;
ArrayList recordMiscItem = null;

recordMiscItem = FsDB.getMiscItemDtl(null);
ReportableListObject rowMiscItem = null;
int miscItemArraySize = recordMiscItem.size();
String[] checkBox = new String[miscItemArraySize];
String[] checkNo = new String[miscItemArraySize];
String[] checkQTY = new String[miscItemArraySize];
String[] checkDesc = new String[miscItemArraySize];
String[] checkUnit = new String[miscItemArraySize];

boolean createAction = false;
boolean updateAction = false;
boolean viewAction = false;
boolean closeAction = false;
boolean successUpt = false;
boolean emailAction = false;
boolean cancelAction = false;
boolean isAdmin = false;

String secretaryOf = null;
String reqDeptName = null;				
String chargeToName = null;
String foodDeptHead = null;

String sentCount = null;


if("view".equals(command)){
	viewAction = true;
}else if ("edit".equals(command)) {
	if(reqNo != null && reqNo.length() > 0){
		updateAction = true;			
	}else{
		createAction = true;
	}
}else if ("email".equals(command)) {
	emailAction = true;
}else if ("cancel".equals(command)) {
	cancelAction = true;		
}else if ("submit".equals(command)) {
	if(reqNo != null && reqNo.length() > 0){
		updateAction = true;			
	}else{
		createAction = true;
	}
}
System.err.println("[requestFormCreate][command]:"+command);
try {
	ArrayList record = null;
	record = ApprovalUserDB.getDepartmentHead1(userBean.getStaffID());
	if(!record.isEmpty()){
		ReportableListObject row = (ReportableListObject) record.get(0);
		deptHead = row.getValue(0);
		if(!deptHead.equals(userBean.getStaffID())){
			deptHead = null;
		}					
	}
	
	ArrayList recordFoodDept = null;
	
	if("hkah".equals(serverSiteCode)){
		recordFoodDept = EPORequestDB.getDeptHeadList("300");
	}else if("twah".equals(serverSiteCode)){
		recordFoodDept = EPORequestDB.getDeptHeadList("FOOD");
	}else{
		recordFoodDept = EPORequestDB.getDeptHeadList("300");
	}
		
	if(recordFoodDept.size()>0){
		ReportableListObject rowFoodDept = (ReportableListObject) recordFoodDept.get(0);
		foodDeptHead = rowFoodDept.getValue(0);			
	}	

	isAdmin = FsDB.isApprover(userBean,"HKAH");
	
	if(sendAppTo!=null && sendAppTo.length()>0){
		secretaryOf = FsDB.checkSecretaryOf(sendAppTo,"HKAH");
	}else{
		if(isAdmin){
			sendAppTo = userBean.getStaffID();
		}
	}
	
	if(reqStatus==null){
		reqStatus="S";
	}	
	
	if(createAction){
		if("1".equals(requestType)){
			if(isAdmin){
				reqStatus = "A";
			}else{
				reqStatus = "S";
			}
		}else if("2".equals(requestType) && sendAppTo.equals(userBean.getStaffID())){
			reqStatus = "A";			
		}else{
			reqStatus = "S";			
		}
		
		System.err.println("[eventID]:"+eventID+";[sentCount]:"+sentCount);
		if("submit".equals(command)){
			sentCount = "1";
		}else{
			sentCount = "0";
		}	
	    reqNo = FsDB.addReqOrder(userBean,reqDate, servDateStartDateTime, servDateEndDateTime, reqSiteCode, reqDept, chargeTo, eventID, venue, purpose, noOfPerson, mealID, specReq, sendAppTo, reqStatus, priceRange, mealEvent, requestType, otherMeal, contactTel, estAmount, otherReq, otherChg, sentCount);
	    
	    if (reqNo!=null && reqNo.length()> 0){
	    	if("S".equals(reqStatus)){
	    		for(int i=0;i<miscItemArraySize;i++) {
	    			checkNo[i] = String.format("%02d", i+1);
	    			checkQTY[i] = ParserUtil.getParameter(request, "checkQTY"+String.format("%02d", i+1));
	    			checkQTY[0] = ParserUtil.getParameter(request, "checkQTY01");
	    			System.err.println("checkQTY"+i+":"+checkQTY[i]);
	    			if(checkQTY[i]!=null && checkQTY[i].length()>0 && "2".equals(requestType)){
			    		FsDB.addMiscItem(userBean,reqNo,checkNo[i],checkQTY[i]);	    				
	    			}else{
	    				FsDB.addMiscItem(userBean,reqNo,checkNo[i],"0");
	    			}

	    			System.err.println("checkQTY["+i+"]:"+checkQTY[i]);
	    		}	    		
	    		
	    		if("submit".equals(command)){
	    			System.err.println("Send[command]:"+command);
					if(FsDB.sendEmail(reqNo, userBean.getStaffID(), userBean.getStaffID(), sendAppTo, null, "S", null, "2", "1")){				
						if(secretaryOf!=null && secretaryOf.length()> 0 && "1".equals(requestType) && !secretaryOf.equals(userBean.getStaffID())){
							if(FsDB.sendEmail(reqNo, userBean.getStaffID(), userBean.getStaffID(), secretaryOf, null, "S", null, "2", "3")){
								message = "New Requisition added and mail sent to secretary success";							
							}else{
								message = "New Requisition added and mail sent to secretary failed(Counter Sent Mail)";		
							}									
						}else{
							message = "New Requisition added and mail sent success";
						}				
					}else{
						message = "New Requisition added but email sent failed";				
					}	    			
	    		}else{
	    			message = "New Requisition save success";	
	    		}	    		
	    	}else if("A".equals(reqStatus)){
	    		for(int i=0;i<miscItemArraySize;i++) {
	    			checkNo[i] = String.format("%02d", i+1);
	    			checkQTY[i] = ParserUtil.getParameter(request, "checkQTY"+String.format("%02d", i+1));
	    			checkQTY[0] = ParserUtil.getParameter(request, "checkQTY01");
	    			System.err.println("checkQTY"+i+":"+checkQTY[i]);
	    			if(checkQTY[i]!=null && checkQTY[i].length()>0 && "2".equals(requestType)){
			    		FsDB.addMiscItem(userBean,reqNo,checkNo[i],checkQTY[i]);	    				
	    			}else{
	    				FsDB.addMiscItem(userBean,reqNo,checkNo[i],"0");
	    			}

	    			System.err.println("checkQTY["+i+"]:"+checkQTY[i]);
	    		}	    		
	    		
				if(FsDB.sendEmail(reqNo, reqBy, userBean.getLoginID(), sendAppTo, null, "A", null, "2", "2")){				
					if(FsDB.sendEmail(reqNo, reqBy, userBean.getLoginID(), sendAppTo, null, "A", null, "2", "")){					
						message = "mail sent success";							
					}else{
						message = "mail sent failed(To Requestor)";		
					}
				}else{
					message = "mail sent failed";
				}
	    	}
	    		    	
			record1 = FsDB.getReqRecord(reqNo);
			ReportableListObject row1 = (ReportableListObject) record1.get(0);			
			
			reqNo = row1.getValue(0);
			reqDate = row1.getValue(1);
			reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
			servDate  = row1.getValue(3);
			servDateStartTime = row1.getValue(4);
			servDateEndTime = row1.getValue(5);
			reqSiteCode = row1.getValue(6);
			reqDept = row1.getValue(7);
			chargeTo = row1.getValue(8);
			eventID = row1.getValue(9);
			venue = row1.getValue(10);
			reqStatus = row1.getValue(11);
			purpose = row1.getValue(12);
			estAmount = row1.getValue(13);			
			noOfPerson = row1.getValue(14);
			mealID = row1.getValue(15);
			menu = row1.getValue(16);			
			specReq = row1.getValue(17);
			sendAppTo = row1.getValue(18);
			priceRange = row1.getValue(28);
			mealEvent = row1.getValue(29);
			requestType = row1.getValue(30);
			selectedApprover = sendAppTo;					
			reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
			chargeToName = DepartmentDB.getDeptDescWithCash(chargeTo);
			otherMeal = row1.getValue(31);
			contactTel = row1.getValue(32);
			chargeAmount = row1.getValue(33);
			otherReq = row1.getValue(34);
			otherChg = row1.getValue(35);
			
			recordMiscItem = FsDB.getMiscItemDtl(reqNo);
			for(int i=0;i<recordMiscItem.size();i++) {
				rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
				checkNo[i] = rowMiscItem.getValue(1);
				checkDesc[i] = rowMiscItem.getValue(2);
				checkQTY[i]= rowMiscItem.getValue(3);
				try {
					if(Integer.parseInt(checkQTY[i])>0){
						checkBox[i]="Y";
					}else{
						checkBox[i]="N";
					}			
				} catch (Exception e) {
					checkBox[i]="N";
				}
				checkUnit[i] = rowMiscItem.getValue(4);
			}			
			
			createAction = false;
	    }else{
			errorMessage = "Requisition insert fail.";
			createAction = false;
    	}
	}else if(viewAction){	
		record1 = FsDB.getReqRecord(reqNo);
		ReportableListObject row1 = (ReportableListObject) record1.get(0);
			
		reqNo = row1.getValue(0);
		reqDate = row1.getValue(1);
		reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
		servDate  = row1.getValue(3);
		servDateStartTime = row1.getValue(4);
		servDateEndTime = row1.getValue(5);
		reqSiteCode = row1.getValue(6);
		reqDept = row1.getValue(7);
		chargeTo = row1.getValue(8);
		eventID = row1.getValue(9);
		venue = row1.getValue(10);
		reqStatus = row1.getValue(11);
		purpose = row1.getValue(12);
		estAmount = row1.getValue(13);
		noOfPerson = row1.getValue(14);
		mealID = row1.getValue(15);
		menu = row1.getValue(16);
		specReq = row1.getValue(17);
		sendAppTo = row1.getValue(18);		
		priceRange = row1.getValue(28);
		mealEvent = row1.getValue(29);
		requestType = row1.getValue(30);
		selectedApprover = sendAppTo;
		reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
		chargeToName = DepartmentDB.getDeptDescWithCash(chargeTo);
		otherMeal = row1.getValue(31);
		contactTel = row1.getValue(32);
		chargeAmount = row1.getValue(33);
		otherReq = row1.getValue(34);
		otherChg = row1.getValue(35);
		sentCount =  row1.getValue(36);
		if(sentCount==null){
			sentCount = "0";
		}		
		System.err.println("[estAmount]:"+estAmount+";[sentCount]:"+sentCount);		
		if("2".equals(requestType)){
			recordMiscItem = FsDB.getMiscItemDtl(reqNo);
		}else{
			recordMiscItem = FsDB.getMiscItemDtl(null);
		}

		for(int i=0;i<recordMiscItem.size();i++) {
			rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
			checkNo[i] = rowMiscItem.getValue(1);
			checkDesc[i] = rowMiscItem.getValue(2);
			checkQTY[i]= rowMiscItem.getValue(3);
			try {
				if(Integer.parseInt(checkQTY[i])>0){
					checkBox[i]="Y";
				}else{
					checkBox[i]="N";
				}			
			} catch (Exception e) {
				checkBox[i]="N";
			}
			checkUnit[i] = rowMiscItem.getValue(4);
		}		
	}else if(updateAction){
		if("submit".equals(command)){
			sentCount = "1";
		}else{
			sentCount = "0";
		}		

		successUpt = FsDB.updateReqOrder(reqNo, servDateStartDateTime, servDateEndDateTime, reqDept, chargeTo, eventID, venue, purpose, noOfPerson, mealID, specReq, sendAppTo, priceRange, mealEvent, requestType, otherMeal, contactTel, estAmount, otherReq, otherChg, sentCount, userBean);
		
		for(int i=0;i<miscItemArraySize;i++) {
			checkNo[i] = String.format("%02d", i+1);
			checkQTY[i] = ParserUtil.getParameter(request, "checkQTY"+String.format("%02d", i+1));
			System.err.println("checkQTY"+i+":"+checkQTY[i]);
			if("2".equals(requestType)){
	    		FsDB.updateMiscItem(userBean,reqNo,checkNo[i],checkQTY[i]);
			}
		}
		
		if("submit".equals(command)){
			System.err.println("Send[updateAction][command]:"+command);
			if(FsDB.sendEmail(reqNo, userBean.getStaffID(), userBean.getStaffID(), sendAppTo, null, "S", null, "2", "1")){				
				if(secretaryOf!=null && secretaryOf.length()> 0 && "1".equals(requestType) && !secretaryOf.equals(userBean.getStaffID())){
					if(FsDB.sendEmail(reqNo, userBean.getStaffID(), userBean.getStaffID(), secretaryOf, null, "S", null, "2", "3")){
						message = "Requisition update and mail sent to secretary success";							
					}else{
						message = "Requisition update and mail sent to secretary failed(Counter Sent Mail)";		
					}									
				}else{
					message = "Requisition update and mail sent success";
				}				
			}else{
				message = "New Requisition added but email sent failed";				
			}	    			
		}else{
		    if (successUpt){
				message = "Requisition update success";
				updateAction = false;		    	    	
		    }else{
				errorMessage = "Requisition update fail.";
				updateAction = false;
		    }
		}		

		record1 = FsDB.getReqRecord(reqNo);
		ReportableListObject row1 = (ReportableListObject) record1.get(0);
			
		reqNo = row1.getValue(0);
		reqDate = row1.getValue(1);
		reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
		servDate  = row1.getValue(3);
		servDateStartTime = row1.getValue(4);
		servDateEndTime = row1.getValue(5);
		reqSiteCode = row1.getValue(6);
		reqDept = row1.getValue(7);
		chargeTo = row1.getValue(8);
		eventID = row1.getValue(9);
		venue = row1.getValue(10);
		reqStatus = row1.getValue(11);
		purpose = row1.getValue(12);
		estAmount = row1.getValue(13);
		noOfPerson = row1.getValue(14);
		mealID = row1.getValue(15);
		menu = row1.getValue(16);
		specReq = row1.getValue(17);
		sendAppTo = row1.getValue(18);
		priceRange = row1.getValue(28);
		mealEvent = row1.getValue(29);		
		requestType = row1.getValue(30);
		selectedApprover = sendAppTo;
		reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
		chargeToName = DepartmentDB.getDeptDescWithCash(chargeTo);
		otherMeal = row1.getValue(31);
		contactTel = row1.getValue(32);
		chargeAmount = row1.getValue(33);
		otherReq = row1.getValue(34);
		otherChg = row1.getValue(35);
		sentCount =  row1.getValue(36);
		if(sentCount==null){
			sentCount = "0";
		}
		
		recordMiscItem = FsDB.getMiscItemDtl(reqNo);
		for(int i=0;i<recordMiscItem.size();i++) {
			rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
			checkNo[i] = rowMiscItem.getValue(1);
			checkDesc[i] = rowMiscItem.getValue(2);
			checkQTY[i]= rowMiscItem.getValue(3);
			try {
				if(Integer.parseInt(checkQTY[i])>0){
					checkBox[i]="Y";
				}else{
					checkBox[i]="N";
				}			
			} catch (Exception e) {
				checkBox[i]="N";
			}			
			checkUnit[i] = rowMiscItem.getValue(4);
		}		
	}else if(emailAction){		
		if (reqNo != null && reqNo.length() > 0) {	
			record1 = FsDB.getReqRecord(reqNo);
			ReportableListObject row1 = (ReportableListObject) record1.get(0);
				
			reqNo = row1.getValue(0);
			reqDate = row1.getValue(1);
			reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
			servDate  = row1.getValue(3);
			servDateStartTime = row1.getValue(4);
			servDateEndTime = row1.getValue(5);
			reqSiteCode = row1.getValue(6);
			reqDept = row1.getValue(7);
			chargeTo = row1.getValue(8);
			eventID = row1.getValue(9);
			venue = row1.getValue(10);
			reqStatus = row1.getValue(11);
			purpose = row1.getValue(12);
			estAmount = row1.getValue(13);
			noOfPerson = row1.getValue(14);
			mealID = row1.getValue(15);
			menu = row1.getValue(16);
			specReq = row1.getValue(17);
			sendAppTo = row1.getValue(18);
			priceRange = row1.getValue(28);
			mealEvent = row1.getValue(29);		
			requestType = row1.getValue(30);
			selectedApprover = sendAppTo;
			reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
			chargeToName = DepartmentDB.getDeptDescWithCash(chargeTo);
			otherMeal = row1.getValue(31);
			contactTel = row1.getValue(32);
			chargeAmount = row1.getValue(33);
			otherReq = row1.getValue(34);
			otherChg = row1.getValue(35);
			sentCount =  row1.getValue(36);
			if(sentCount==null){
				sentCount = "0";
			}			
			
			recordMiscItem = FsDB.getMiscItemDtl(reqNo);
			for(int i=0;i<recordMiscItem.size();i++) {
				rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
				checkNo[i] = rowMiscItem.getValue(1);
				checkDesc[i] = rowMiscItem.getValue(2);
				checkQTY[i]= rowMiscItem.getValue(3);
				try {
					if(Integer.parseInt(checkQTY[i])>0){
						checkBox[i]="Y";
					}else{
						checkBox[i]="N";
					}			
				} catch (Exception e) {
					checkBox[i]="N";
				}			
				checkUnit[i] = rowMiscItem.getValue(4);
			}			
		}
				
		if(FsDB.sendEmail(reqNo, null, userBean.getStaffID(), sendAppTo, null, reqStatus, null, "E", "1")){
			message = "Mail resent success";
			emailAction = false;				
		}else{
			errorMessage = "Mail resent failed";
			emailAction = false;				
		}
			
		if("S".equals(reqStatus)){
			ArrayList record2 = EPORequestDB.getDeptHeadList(deptCode);
			if(record2.size()>0){
				ReportableListObject row = (ReportableListObject) record2.get(0);
				deptHead = row.getValue(0);			
			}
		}
	}else if(cancelAction){
		System.err.println("1[updateMenu]:"+"C"+";[reqNo]:"+reqNo);		
		successUpt = FsDB.updateMenu( reqNo, "C", null, specReq, null, null, null, null, null, null, null, null, null, null, null, null, userBean);
		System.err.println("1[successUpt]:"+successUpt);
	    if (successUpt){
			message = "Requisition cancel success";
			updateAction = false;		    	    	
	    }else{
			errorMessage = "Requisition cancel fail.";
			updateAction = false;
	    }		

		if (reqNo != null && reqNo.length() > 0) {	
			record1 = FsDB.getReqRecord(reqNo);
			ReportableListObject row1 = (ReportableListObject) record1.get(0);
				
			reqNo = row1.getValue(0);
			reqDate = row1.getValue(1);
			reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
			servDate  = row1.getValue(3);
			servDateStartTime = row1.getValue(4);
			servDateEndTime = row1.getValue(5);
			reqSiteCode = row1.getValue(6);
			reqDept = row1.getValue(7);
			chargeTo = row1.getValue(8);
			eventID = row1.getValue(9);
			venue = row1.getValue(10);
			reqStatus = row1.getValue(11);
			purpose = row1.getValue(12);
			estAmount = row1.getValue(13);
			noOfPerson = row1.getValue(14);
			mealID = row1.getValue(15);
			menu = row1.getValue(16);
			specReq = row1.getValue(17);
			sendAppTo = row1.getValue(18);
			priceRange = row1.getValue(28);
			mealEvent = row1.getValue(29);		
			requestType = row1.getValue(30);
			selectedApprover = sendAppTo;
			reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
			chargeToName = DepartmentDB.getDeptDescWithCash(chargeTo);
			otherMeal = row1.getValue(31);
			contactTel = row1.getValue(32);
			chargeAmount = row1.getValue(33);
			otherReq = row1.getValue(34);
			otherChg = row1.getValue(35);
			sentCount =  row1.getValue(36);
			if(sentCount==null){
				sentCount = "0";
			}			
			
			recordMiscItem = FsDB.getMiscItemDtl(reqNo);
			for(int i=0;i<recordMiscItem.size();i++) {
				rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
				checkNo[i] = rowMiscItem.getValue(1);
				checkDesc[i] = rowMiscItem.getValue(2);
				checkQTY[i]= rowMiscItem.getValue(3);
				try {
					if(Integer.parseInt(checkQTY[i])>0){
						checkBox[i]="Y";
					}else{
						checkBox[i]="N";
					}			
				} catch (Exception e) {
					checkBox[i]="N";
				}			
				checkUnit[i] = rowMiscItem.getValue(4);
			}			
		}					
	}else{
		Calendar calendar = Calendar.getInstance();	
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		reqDate = dateFormat.format(calendar.getTime());
	    calendar.set(Calendar.DAY_OF_YEAR,calendar.get(Calendar.DAY_OF_YEAR) + 3);
		servDate = dateFormat.format(calendar.getTime());
		
		recordMiscItem = FsDB.getMiscItemDtl(null);
		for(int i=0;i<recordMiscItem.size();i++) {
			rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
			checkNo[i] = rowMiscItem.getValue(1);
			checkDesc[i] = rowMiscItem.getValue(2);
			checkQTY[i]= rowMiscItem.getValue(3);
			checkUnit[i] = rowMiscItem.getValue(4);
		}	
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<style>
	TD,TH,A,SPAN,INPUT {
		font-size:16px !important;
	}
	.selected {
		background: url("../images/ui-bg_highlight-soft_75_ffe45c_1x100.png") repeat-x scroll 50% 50% #F6F6F6 !important;
	}		
</style>
<head>
<title>Insert title here</title>
</head>
<jsp:include page="../common/header.jsp"/>
<!-- 
<script type="text/javascript" src="<html:rewrite page="/js/jquery-1.2.6.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.meio.mask.js"/>" charset="utf-8" ></script>
 -->
<body>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<%
	String title = "function.dfsr.list"; 
	String suffix = "_2";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="suffix" value="<%=suffix %>" />	
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.dfsr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" id="form1" enctype="multipart/form-data" action="requestFormCreate.jsp" method=post >

<table cellpadding="0" cellspacing="5" class="contentFrameMenu1" border="0" id="caretrackingTable">
<tbody>
<tr>
	<td id="patientInfo">
	<table>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData2" width="30%">
			<b><%=reqNo==null?"":reqNo%></b>			
		</td>	
		<td class="infoLabel" width="20%"><bean:message key="prompt.siteCode" /></td>
		<td class="infoData2" width="30%">
			<input type="textfield" name="reqSiteCode" id="reqSiteCode" value="<%=reqSiteCode==null?"":reqSiteCode %>" maxlength="20" size="20" disabled="disabled">			
		</td>		
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.requestType" /></td>
		<td class="infoData2" width="80%"  colspan=3>
			<select name="requestType" onchange="return changeRequestType(this)">
			<%requestType = requestType==null?"":requestType; %>	
<jsp:include page="../ui/fsDCMB.jsp" flush="false">
	<jsp:param name="mealID" value="<%=requestType %>" />
	<jsp:param name="mealType" value="REQUEST" />	
</jsp:include>
			</select>
		</td>	
	</tr>	
		<%if("S".equals(reqStatus)){ %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.servDate" /></td>
		<td class="infoData2" width="30%" >
			<input type="textfield" name="servDate" id="servDate" class="datepickerfield" value="<%=servDate==null?"":servDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDate" /></td>
		<td class="infoData2" width="30%">			
			<input type="hidden" name="reqDate" value="<%=reqDate==null?"":reqDate %>" />
			<b><%=reqDate==null?"":reqDate %> (DD/MM/YYYY)</b>					
		</td>		
	</tr>			
	<tr class="smallText">
		<td class="infoLabel" width="20%">Start Time</td>
		<td class="infoData2" width="80%" colspan=3>
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="servDateStartTime" />
	<jsp:param name="time" value="<%=servDateStartTime %>" />
	<jsp:param name="interval" value="15" />
</jsp:include>
		(HH:MM)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">End Time</td>
		<td class="infoData2" width="80%" colspan=3>
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="servDateEndTime" />
	<jsp:param name="time" value="<%=servDateEndTime %>" />
	<jsp:param name="interval" value="15" />
</jsp:include>
		(HH:MM)</td>		
	</tr>
		<%}else{ %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDate" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="reqDate" id="reqDate" value="<%=reqDate==null?"":reqDate %>" maxlength="20" size="20" readonly="readonly"/> (DD/MM/YYYY)
		</td>			
	</tr>		
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.servDate" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="servDate" id="servDate" value="<%=servDate==null?"":servDate %>" maxlength="20" size="20" readonly="readonly"/> (DD/MM/YYYY)		
		</td>			
	</tr>			
	<tr class="smallText">
		<td class="infoLabel" width="20%">Start Time</td>
		<td class="infoData2" width="30%">
			<input type="textfield" name="servDateStartTime" id="servDateStartTime" value="<%=servDateStartTime==null?"":servDateStartTime %>" maxlength="20" size="20" readonly="readonly"/>(HH:MM)
		</td>	
		<td class="infoLabel" width="20%">End Time</td>
		<td class="infoData2" width="30%">
			<input type="textfield" name="servDateEndTime" id="servDateEndTime" value="<%=servDateEndTime==null?"":servDateEndTime %>" maxlength="20" size="20" readonly="readonly"/>(HH:MM)
		</td>		
	</tr>	
		<%} %>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDept" /></td>
		<td class="infoData2" width="30%">
		<%if("S".equals(reqStatus)){ %>
			<select name="reqDeptDD" onchange="return getChangeReqDeptHead(this)" disabled>
			<%reqDept = reqDept == null ? deptCode : reqDept; %>	
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=reqDept %>" />
				<jsp:param name="allowAll" value="Y" />	
				<jsp:param name="showDescWithCode" value="Y" />
			</jsp:include>
			</select>
			<input type="hidden" name="reqDept" value="<%=reqDept %>"/>	
		<%}else{ %>
			<input type="textfield" name="reqDept" value="<%=reqDeptName==null?"":reqDeptName %>" maxlength="40" size="40" readonly="readonly"/>
		<%} %>							
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBy" /></td>
		<td class="infoData2" width="30%" >
			<input type="textfield" name="reqBy" id="reqBy" value="<%=reqByName==null?"":reqByName %>" maxlength="20" size="20" readonly="readonly">			
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.otherReq" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="otherReq" value="<%=otherReq==null?"":otherReq %>" maxlength="150" size="120"/>
		</td>					
	</tr>		
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.chargeTo" /></td>
		<td class="infoData2" width="30%">
		<%if("S".equals(reqStatus)){ %>
			<select name="chargeTo" onchange="return getDeptHead(this)">
			<%chargeTo = chargeTo == null ? deptCode : chargeTo; %>	
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=chargeTo %>" />
				<jsp:param name="allowAll" value="Y" />
				<jsp:param name="category" value="cash" />
				<jsp:param name="showDescWithCode" value="Y" />				
			</jsp:include>
			</select>		
		<%}else{ %>
			<input type="textfield" name="chargeTo" value="<%=chargeToName==null?"":chargeToName %>" maxlength="40" size="40" readonly="readonly"/>
		<%} %>	
		</td>
		<td class="infoLabel" width="20%"><bean:message key="adm.contactTel" /></td>
		<td class="infoData2" width="30%" >
			<input type="textfield" name="contactTel" id="contactTel" value="<%=contactTel==null?"":contactTel %>" maxlength="20" size="20">			
		</td>			
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.otherReq" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="otherReq" value="<%=otherReq==null?"":otherReq %>" maxlength="150" size="120"/>
		</td>		
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.eventLocation" /></td>		
		<td class="infoData2" width="80%" colspan=3>
			<select name="eventID" onchange="return showVenue(this)">
			<%eventID = eventID==null?"":eventID; %>
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="foodOrder" />
	<jsp:param name="eventID" value="<%=eventID %>" />
	<jsp:param name="allowAll" value="Y" />	
</jsp:include>
			</select>
		</td>
	</tr>
	<tr id="show_answerField">	
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.eventMeeting" /></td>
		<td class="infoData2" width="30%" >
			<select name="mealEvent" onchange="return showEvent(this)">
			<%mealEvent = mealEvent==null?"":mealEvent; %>	
<jsp:include page="../ui/fsDCMB.jsp" flush="false">
	<jsp:param name="mealID" value="<%=mealEvent %>" />
	<jsp:param name="mealType" value="EVENT" />
	<jsp:param name="allowEmpty" value="Y" />
	<jsp:param name="emptyLabel" value="" />		
</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.estAmount" /></td>
		<td class="infoData2" width="30%" >
		<%if("S".equals(reqStatus)){ %>		
			<input type="textfield" name="estAmount" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=estAmount==null?"":estAmount %>" maxlength="4" size="4"/>
		<%}else{ %>
			<input type="textfield" name="estAmount" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=estAmount==null?"":estAmount %>" maxlength="4" size="4" readonly="readonly"/>		
		<%} %>							
		</td>						
	</tr>
	<tr id="show_answerField2">	
	</tr>		
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.typeOfMeal" /></td>
		<td class="infoData2" width="30%" >
			<select name="mealID" onchange="return showMeal(this)">
			<%mealID = mealID==null?"":mealID; %>	
<jsp:include page="../ui/fsDCMB.jsp" flush="false">
	<jsp:param name="mealID" value="<%=mealID %>" />
	<jsp:param name="mealType" value="TYPE" />
	<jsp:param name="allowEmpty" value="Y" />
	<jsp:param value="" name="emptyLabel"/>		
</jsp:include>
			</select>
		</td>	
		<td class="infoLabel" width="20%"><bean:message key="prompt.noOfPerson" /></td>
		<td class="infoData2" width="30%" >
		<%if("S".equals(reqStatus)){ %>		
			<input type="textfield" name="noOfPerson" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=noOfPerson==null?"":noOfPerson %>" maxlength="3" size="3"/>
		<%}else{ %>
			<input type="textfield" name="noOfPerson" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=noOfPerson==null?"":noOfPerson %>" maxlength="3" size="3" readonly="readonly"/>		
		<%} %>							
		</td>
	</tr>
	<tr id="show_answerField3">	
	</tr>
<%if(!("S".equals(reqStatus) || "C".equals(reqStatus) || "A".equals(reqStatus))){ %>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.menu" /></td>		
		<td class="infoData2" width="80%" colspan=3 readonly="readonly">
		<div style="border-width: 2px;background:#FFFFFF;height:100px;width:66.25%;position:relative;border-style: inset;">
		<%=menu==null?"":menu %>
		</div>										
		</td>				
	</tr>
<%} %>
	<tr>
		<td colspan="4"  style='text-align:center;  font-size:14px;'>
		<span style="color:green">
		-----------------------------------------------
			<button type="button" id='Patient_Contact_Info_Show' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:250px;text-align:left; height:30px; font-size:15px;'>
						Show Miscellaneous Item List
			</button>
			<button type="button" id='Patient_Contact_Info_Hide' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='display:none;width:250px;text-align:left; height:30px; font-size:15px;'>
						Hide Miscellaneous Item List
			</button>
		 ----------------------------------------------
		</span>
		</td>	
	</tr>
	<td colspan='4'>
	<div id='patientContactInfo' style="display:none;">
	<table>
		<tr class="smallText">
			<td width="100" >
				<input type="checkbox" id="selectAll" onclick="javascript:invertSelected(this)"/>&nbsp;Select all								
			</td>
		</tr>
	</table>
	<table border="1|0">
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[0] %>" value ="N" <%if ("Y".equals(checkBox[0])) {%> checked <% } %> class='chk-record'/><%=checkDesc[0]==null?"":checkDesc[0] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[0] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[0]==null?"":checkQTY[0] %>" maxlength="3" size="3"/><%=checkUnit[0]==null?"":checkUnit[0] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[1] %>" value ="N" <%if ("Y".equals(checkBox[1])) {%> checked <% } %> class='chk-record'/><%=checkDesc[1]==null?"":checkDesc[1] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[1] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[1]==null?"":checkQTY[1] %>" maxlength="3" size="3"/><%=checkUnit[1]==null?"":checkUnit[1] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[2] %>" value ="N" <%if ("Y".equals(checkBox[2])) {%> checked <% } %> class='chk-record'/><%=checkDesc[2]==null?"":checkDesc[2] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[2] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[2]==null?"":checkQTY[2] %>" maxlength="3" size="3"/><%=checkUnit[2]==null?"":checkUnit[2] %></input>																									
			</td>							
		</tr>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[3] %>" value ="N" <%if ("Y".equals(checkBox[3])) {%> checked <% } %> class='chk-record'/><%=checkDesc[3]==null?"":checkDesc[3] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[3] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[3]==null?"":checkQTY[3] %>" maxlength="3" size="3"/><%=checkUnit[3]==null?"":checkUnit[3] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[4] %>" value ="N" <%if ("Y".equals(checkBox[4])) {%> checked <% } %> class='chk-record'/><%=checkDesc[4]==null?"":checkDesc[4] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[4] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[4]==null?"":checkQTY[4] %>" maxlength="3" size="3"/><%=checkUnit[4]==null?"":checkUnit[4] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[5] %>" value ="N" <%if ("Y".equals(checkBox[5])) {%> checked <% } %> class='chk-record'/><%=checkDesc[5]==null?"":checkDesc[5] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[5] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[5]==null?"":checkQTY[5] %>" maxlength="3" size="3"/><%=checkUnit[5]==null?"":checkUnit[5] %></input>																									
			</td>							
		</tr>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[6] %>" value ="N" <%if ("Y".equals(checkBox[6])) {%> checked <% } %> class='chk-record'/><%=checkDesc[6]==null?"":checkDesc[6] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[6] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[6]==null?"":checkQTY[6] %>" maxlength="3" size="3"/><%=checkUnit[6]==null?"":checkUnit[6] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[7] %>" value ="N" <%if ("Y".equals(checkBox[7])) {%> checked <% } %> class='chk-record'/><%=checkDesc[7]==null?"":checkDesc[7] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[7] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[7]==null?"":checkQTY[7] %>" maxlength="3" size="3"/><%=checkUnit[7]==null?"":checkUnit[7] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[8] %>" value ="N" <%if ("Y".equals(checkBox[8])) {%> checked <% } %> class='chk-record'/><%=checkDesc[8]==null?"":checkDesc[8] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[8] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[8]==null?"":checkQTY[8] %>" maxlength="3" size="3"/><%=checkUnit[8]==null?"":checkUnit[8] %></input>																								
			</td>							
		</tr>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[9] %>" value ="N" <%if ("Y".equals(checkBox[9])) {%> checked <% } %> class='chk-record'/><%=checkDesc[9]==null?"":checkDesc[9] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[9] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[9]==null?"":checkQTY[9] %>" maxlength="3" size="3"/><%=checkUnit[9]==null?"":checkUnit[9] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[10] %>" value ="N" <%if ("Y".equals(checkBox[10])) {%> checked <% } %> class='chk-record'/><%=checkDesc[10]==null?"":checkDesc[10] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[10] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[10]==null?"":checkQTY[10] %>" maxlength="3" size="3"/><%=checkUnit[10]==null?"":checkUnit[10] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[11] %>" value ="N" <%if ("Y".equals(checkBox[11])) {%> checked <% } %> class='chk-record'/><%=checkDesc[11]==null?"":checkDesc[11] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[11] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[11]==null?"":checkQTY[11] %>" maxlength="3" size="3"/><%=checkUnit[11]==null?"":checkUnit[11] %></input>																									
			</td>							
		</tr>
		<% if("twah".equals(serverSiteCode)){%>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[12] %>" value ="N" <%if ("Y".equals(checkBox[12])) {%> checked <% } %> class='chk-record'/><%=checkDesc[12]==null?"":checkDesc[12] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[12] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[12]==null?"":checkQTY[12] %>" maxlength="3" size="3"/><%=checkUnit[12]==null?"":checkUnit[12] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[13] %>" value ="N" <%if ("Y".equals(checkBox[13])) {%> checked <% } %> class='chk-record'/><%=checkDesc[13]==null?"":checkDesc[13] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[13] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[13]==null?"":checkQTY[13] %>" maxlength="3" size="3"/><%=checkUnit[13]==null?"":checkUnit[13] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[14] %>" value ="N" <%if ("Y".equals(checkBox[14])) {%> checked <% } %> class='chk-record'/><%=checkDesc[14]==null?"":checkDesc[14] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[14] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[14]==null?"":checkQTY[14] %>" maxlength="3" size="3"/><%=checkUnit[14]==null?"":checkUnit[14] %></input>																									
			</td>							
		</tr>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[15] %>" value ="N" <%if ("Y".equals(checkBox[15])) {%> checked <% } %> class='chk-record'/><%=checkDesc[15]==null?"":checkDesc[15] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[15] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[15]==null?"":checkQTY[15] %>" maxlength="3" size="3"/><%=checkUnit[15]==null?"":checkUnit[15] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[16] %>" value ="N" <%if ("Y".equals(checkBox[16])) {%> checked <% } %> class='chk-record'/><%=checkDesc[16]==null?"":checkDesc[16] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[16] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[16]==null?"":checkQTY[16] %>" maxlength="3" size="3"/><%=checkUnit[16]==null?"":checkUnit[16] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[17] %>" value ="N" <%if ("Y".equals(checkBox[17])) {%> checked <% } %> class='chk-record'/><%=checkDesc[17]==null?"":checkDesc[17] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[17] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[17]==null?"":checkQTY[17] %>" maxlength="3" size="3"/><%=checkUnit[17]==null?"":checkUnit[17] %></input>																									
			</td>							
		</tr>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[18] %>" value ="N" <%if ("Y".equals(checkBox[18])) {%> checked <% } %> class='chk-record'/><%=checkDesc[18]==null?"":checkDesc[18] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[18] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[18]==null?"":checkQTY[18] %>" maxlength="3" size="3"/><%=checkUnit[18]==null?"":checkUnit[15] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[19] %>" value ="N" <%if ("Y".equals(checkBox[19])) {%> checked <% } %> class='chk-record'/><%=checkDesc[19]==null?"":checkDesc[19] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[19] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[19]==null?"":checkQTY[19] %>" maxlength="3" size="3"/><%=checkUnit[19]==null?"":checkUnit[19] %></input>																									
			</td>
			<td class="infoData2" width="18%">																											
			</td>
			<td class="infoData2" width="14%">																											
			</td>							
		</tr>							
		<% }%>											
	</table>
	<hr size="20">
	</div>
	</td>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.specialReq" /></td>	
		<td class="infoData2" width="80%" colspan=3>
			<div class=box>
		<%if("S".equals(reqStatus)){ %>
<!-- 			
			<textarea id="wysiwyg" name="specReq" rows="5" cols="100" align="left"><%=specReq==null?"":specReq %></textarea>
-->				
			<textarea name="specReq" rows="6" cols="113" style="font-size:18px;"><%=specReq==null?"":specReq %></textarea>
		<%}else if("C".equals(reqStatus)){ %>
			<textarea name="specReq" rows="6" cols="113" style="font-size:18px;" readonly><%=specReq==null?"":specReq %></textarea>				
		<%}else{ %> 		
			<textarea name="specReq" rows="5" cols="113" align="left" readonly="readonly"><%=specReq==null?"":specReq %></textarea>						
		<%} %>
			</div>																		
		</td>		
	</tr>
	<%if(!("S".equals(reqStatus) || "C".equals(reqStatus))){ %>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.menu" /></td>		
		<td class="infoData2" width="80%" colspan=3 readonly="readonly">
		<div style="border-width: 2px;background:#FFFFFF;height:100px;width:66.25%;position:relative;border-style: inset;">
		<%=menu==null?"":menu %>
		</div>										
		</td>				
	</tr>
	<%if("B".equals(reqStatus) || "P".equals(reqStatus)){ %>		
	<tr class="smallText">		
		<td class="infoLabel" width="20%"><bean:message key="prompt.chargeAmount" /></td>
		<td class="infoData2" width="80%" colspan=3>
			$&nbsp<%=chargeAmount==null?"0":chargeAmount%>	
		</td>	
	</tr>
	<%} %>	
	<%} %>		
	<tr class="smallText">
	<%if("S".equals(reqStatus) || "C".equals(reqStatus)){ %>
		<td class="infoLabel" width="20%"><bean:message key="prompt.approvalBy" />	</td>	
	<%} else {%>
		<td class="infoLabel" width="20%"><bean:message key="prompt.approvedBy" />	</td>		
	<%} %>	
		<td class="infoData2" width="80%" colspan=3>
		<span id="showStaffID_indicator">				
		<select name="sendAppTo" >
		<%if(sendAppTo == null||sendAppTo.length()==0){ %>
			<option value="" />	
		<%sendAppTo = "";} %>				
		<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">		
			<jsp:param name="reqStat" value="<%=reqStatus %>" />
			<jsp:param name="sendAppTo" value="<%=sendAppTo %>" />
			<jsp:param name="deptHead" value="<%=deptHead %>" />													
			<jsp:param name="category" value="fs" />
			<jsp:param name="showAll" value="Y" />
			<jsp:param name="requestType" value="<%=requestType %>" />											
		</jsp:include>			
		</select>
		</span>															
		</td>
	</tr>
<%if("B".equals(reqStatus)){ %>		
	<tr class="smallText">		
		<td class="infoLabel" width="20%"><bean:message key="prompt.chargeAmount" /></td>
		<td class="infoData2" width="80%" colspan=3>
		$&nbsp<%=chargeAmount==null?"0":chargeAmount%>		
		</td>	
	</tr>
<%} %>				
		
	</table>					
	</td>
</tr>
</tbody>	
</table>	
<hr noshade="noshade" />
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="right" width="50%">
			<% if(reqNo!=null&&reqNo.length()>0){%>
				<% if("S".equals(reqStatus)){%>						
					<button onclick="return submitAction('edit','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.save" /></button>
					<%if("0".equals(sentCount)){ %>
						<button onclick="return submitAction('submit','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.submit" /></button>
					<%} %>
					<button onclick="return resendEmail('email','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.resendMail" /></button>
					<button onclick="return submitAction('cancel','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.cancelOrder" /></button>									
				<%} %>														
			<%}else{ %>
				<%if (("hkah".equals(serverSiteCode) && ("300".equals(deptCode))) || (("twah".equals(serverSiteCode)) && ("FOOD".equals(deptCode)))) {%>
					<button onclick="return submitAction('edit','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.save" /></button>
				<%} %>			
				<button onclick="return submitAction('submit','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.submit" /></button>				
			<%} %>
		</td>
		<td align="left" width="50%">
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>			
		</td>			
	</tr>
</table>					
<input type="hidden" name="command" />
<input type="hidden" name="reqNo" />
<input type="hidden" name="reqStatus" value="<%=reqStatus==null?"":reqStatus %>"/>
<input type="hidden" name="selectedApprover" value="<%=selectedApprover==null?"":selectedApprover %>"/>
<input type="hidden" name="sentCount" value="<%=sentCount==null?"":sentCount %>"/>

</form>
<script language="javascript">
	$(document).ready(function() {
		showVenue(document.form1.eventID);
		showEvent(document.form1.mealEvent);
		showMeal(document.form1.mealID);
		selectRecordEvent();

		<%if("2".equals(requestType)){ %>		
			autoShowMisc(true);
		<%}else{ %>
			document.getElementById("Patient_Contact_Info_Show").disabled = true;
		<%} %>				

//		showOtherRequest(document.form1.reqDept);
//		showOtherCharge(document.form1.chargeTo);		
		
		<%if(!"S".equals(reqStatus)){ %>	
		$("input[name=specReq]").attr("readonly", "readonly");
		<%} %>
		
		$('th.header').unbind('click');
	});
	
	function closeAction() {
		window.close();
	}
	
	function autoShowMisc(showTrue) {
		if(showTrue){
		    document.getElementById("Patient_Contact_Info_Show").disabled = false;			
			document.form1.Patient_Contact_Info_Show.click();
		}else{
			document.form1.Patient_Contact_Info_Hide.click();			
		    document.getElementById("Patient_Contact_Info_Show").disabled = true;			
		};
	}	
	
	function resendEmail(cmd,reqNo) {
		var r=confirm("Resend alert email again?");
		if (r==true){
			document.form1.command.value = cmd;
			document.form1.reqNo.value = reqNo;			
			document.form1.submit();
			return false;	
		 }else{
			 return false;	
		 }				  
	}
		
	function submitAction(cmd,reqNo) {
		document.form1.reqNo.value = reqNo;
		var today = new Date();
		var validOrderDate = new Date();
		validOrderDate.setHours(0,0,0,0); //remove time
		var currDD = parseInt(today.getDate());
		var currMM = today.getMonth()+1;
		var currYYYY = today.getFullYear();
	
		var servDate = document.form1.servDate.value;
		var servDateYYYY = parseInt(servDate.substring(6,10));
		
		if(servDate.substring(3,5).substring(0,1)=='0'){
			var servDateMM = parseInt(servDate.substring(4,5))-1;			
		}else{
			var servDateMM = parseInt(servDate.substring(3,5))-1;
		}

		if(servDate.substring(0,2).substring(0,1)=='0'){
			var servDateDD = parseInt(servDate.substring(1,2));
		}else{
			var servDateDD = parseInt(servDate.substring(0,2));
		}
		
		var servDt = new Date(servDateYYYY, servDateMM, servDateDD);
	    // The number of milliseconds in one day
	    var ONE_DAY = 1000 * 60 * 60 * 24;
	    // Calculate the difference in milliseconds
//	    var difference_ms = Math.abs(servDt - validOrderDate);
	    var difference_ms = servDt - validOrderDate;	    
	    // Convert back to days and return
	    var dayDiff=Math.round(difference_ms/ONE_DAY);
		var r=null;
		var returnChecking = true;
		if(cmd=='submit'||cmd=='edit'){
			if(document.form1.requestType.value=='2'){
				var itemNo = null;
				var itemQTY = null;
				$('input.chk-record').each(function(i, v) {
					if(this.name!=null){
						if(this.name.substr(0, 5)=='check'){
							itemNo = this.name.substr(5, 2);
							itemQTY = $('input[name=checkQTY'+itemNo+']').val();
							if($(this).attr("checked")){
								if((itemQTY=='0')||itemQTY==null||itemQTY==''){
									$('input[name=checkQTY'+itemNo+']').focus();
									 $('input[name=checkQTY'+itemNo+']').focus(function() { $(this).select(); } );
									alert('Cannot order 0 QTY');
									returnChecking = false;
									return false;									
								}
							}
						}
					}
				});	
				if(!returnChecking){
					return false;
				}
			}			
			
			if (document.form1.reqDate.value == '') {
				alert('Please enter request date');
				document.form1.reqDate.focus();
				return false;
			}
			if (document.form1.servDate.value == '') {
				alert('Please enter serving date');
				document.form1.servDate.focus();
				return false;
			}else{
				if(document.form1.requestType.value=='1'){
					<%if ("hkah".equals(serverSiteCode)) {%>
						<%if(!("300".equals(deptCode))){%>						
							if(dayDiff<3){
								validOrderDate.setDate(today.getDate()+3);
								alert('Must apply at least 3 days before the serve date');
								document.form1.servDate.focus();
								return false;
							}
						<%}%>
					<%}else if ("twah".equals(serverSiteCode)) {%>
						<%if(!("FOOD".equals(deptCode))){%>
							if(dayDiff<3){
								validOrderDate.setDate(today.getDate()+3);
								alert('Must apply at least 3 days before the serve date');
								document.form1.servDate.focus();
								return false;
							}
						<%}%>
					<%}%>
				}else{
					<%if ("hkah".equals(serverSiteCode)) { System.err.println("3[serverSiteCode]:"+serverSiteCode);%>				
						<%if(!("300".equals(deptCode))){ System.err.println("1[deptCode]:"+deptCode);%>					
							if(dayDiff<0){
								validOrderDate.setDate(today.getDate());
								alert('Must apply at least 3 days before the serve date');
								document.form1.servDate.focus();
								return false;
							}
						<%}%>
					<%}else if ("twah".equals(serverSiteCode)) { System.err.println("4[serverSiteCode]:"+serverSiteCode);%>				
						<%if(!("FOOD".equals(deptCode))){ System.err.println("2[deptCode]:"+deptCode);%>
							if(dayDiff<0){
								validOrderDate.setDate(today.getDate());
								alert('Must apply at least 3 days before the serve date');
								document.form1.servDate.focus();
								return false;
							}
						<%}%>
					<%}%>
				}		
			}
			if (document.form1.mealEvent.value == '') {
				alert('Please select event type');
				document.form1.mealEvent.focus();
				return false;
			}
			if (document.form1.mealID.value == '') {
				alert('Please select meal type');
				document.form1.mealID.focus();
				return false;
			}			
			
			if (document.form1.noOfPerson.value == '') {
				alert('Please enter NO. of person');
				document.form1.noOfPerson.focus();
				return false;
			}else{
				if(isNaN(document.form1.noOfPerson.value)){
					alert('Please enter valid number');
					document.form1.noOfPerson.focus();
					document.form1.noOfPerson.select();
					return false;				
				}else if(document.form1.noOfPerson.value==0 && document.form1.requestType.value!='2'){
					alert('Cannot order 0 QTY');
					document.form1.noOfPerson.focus();
					document.form1.noOfPerson.select();
					return false;									
				}
			}	
			if (document.form1.sendAppTo.value == '') {
				alert('Please select send approval to person');
				document.form1.sendAppTo.focus();
				return false;
			}	
		}

		if(reqNo!=''){
			if(cmd=='cancel'){
				r = confirm("Confirm to cancel order?");	
			}else if(cmd=='edit'){
				r = confirm("Confirm to save?");				
			}else{
				r = confirm("Confirm to submit?");	
			}
		}else{
			if(cmd=='edit'){
				r = confirm("Confirm to save?");				
			}else{
				r = confirm("Confirm to submit?");	
			}			
		}
		
		if (r==true){
			document.form1.command.value = cmd;			
			document.form1.submit();		
			return false;	
		 }else{			 
			return false;	
		 }		  
	}
	
	function showVenue(inputObj) {
		var did = inputObj.value;

		if(did=='1306'){			
			$("#show_answerField").html('<td class="infoLabel" width="20%"><bean:message key="prompt.venue" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="venue" value="<%=venue==null?"":venue.replaceAll("'","\\\\'") %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField").html(""); 				
		}
	}
	
	function showEvent(inputObj) {
		var did = inputObj.value;

		if(did=='9'){			
			$("#show_answerField2").html('<td class="infoLabel" width="20%"><bean:message key="prompt.otherEvent" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="purpose" value="<%=purpose==null?"":purpose.replaceAll("'","\\\\'") %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField2").html(""); 				
		}
	}
	
	function showMeal(inputObj) {
		var did = inputObj.value;

		if(did=='9'){			
			$("#show_answerField3").html('<td class="infoLabel" width="20%"><bean:message key="prompt.otherMeal" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="otherMeal" value="<%=otherMeal==null?"":otherMeal.replaceAll("'","\\\\'") %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField3").html(""); 				
		}
	}	
	
	function showOtherRequest(inputObj) {
		var did = inputObj.value;

		if(did=='996'){	// department code		
			$("#show_answerField4").html('<td class="infoLabel" width="20%"><bean:message key="prompt.otherReq" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="otherReq" value="<%=otherReq==null?"":otherReq.replaceAll("'","\\\\'") %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField4").html(""); 				
		}
	}
	
	function showOtherCharge(inputObj) {
		var did = inputObj.value;

		if(did=='996'){	// department code		
			$("#show_answerField5").html('<td class="infoLabel" width="20%"><bean:message key="prompt.otherChg" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="otherChg" value="<%=otherChg==null?"":otherChg %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField5").html(""); 				
		}
	}
	
	function getCurrentDateDiff(servDate){
		var today = new Date();
		var validOrderDate = new Date();
		validOrderDate.setHours(0,0,0,0); //remove time
		var currDD = parseInt(today.getDate());
		var currMM = today.getMonth()+1;
		var currYYYY = today.getFullYear();
		var servDateYYYY = parseInt(servDate.substring(6,10));

		if(servDate.substring(3,5).substring(0,1)=='0'){
			var servDateMM = parseInt(servDate.substring(4,5))-1;			
		}else{
			var servDateMM = parseInt(servDate.substring(3,5))-1;
		}

		if(servDate.substring(0,2).substring(0,1)=='0'){
			var servDateDD = parseInt(servDate.substring(1,2));
		}else{
			var servDateDD = parseInt(servDate.substring(0,2));
		}

		var servDt = new Date(servDateYYYY, servDateMM, servDateDD);
	    // The number of milliseconds in one day
	    var ONE_DAY = 1000 * 60 * 60 * 24;
	    // Calculate the difference in milliseconds
//	    var difference_ms = Math.abs(servDt - validOrderDate);
	    var difference_ms = servDt - validOrderDate;	    
	    // Convert back to days and return
	    var dayDiff=Math.round(difference_ms/ONE_DAY);
		
		return dayDiff;
	}
	
	function changeRequestType(inputObj) {
		var did = inputObj.value;
		var chargeTo = document.form1.chargeTo.value;		
		var reqDept = document.form1.reqDept.value;
		var reqStatus = document.form1.reqStatus.value;
		var selectedApprover = document.form1.selectedApprover.value;
		var requestType = document.form1.requestType.value;
			    
		var servDate = document.form1.servDate.value;
		var dayDiff = getCurrentDateDiff(servDate);
		var siteCode = "<%=serverSiteCode%>";
	    
		if(did=='1'){
		    autoShowMisc(false);
			
			if(selectedApprover=''){				
				$.ajax({
					type: "POST",
					url: "../ui/approvalIDCMB.jsp",
					data: "reqStat=" + reqStatus + "&category=fs",
					success: function(values){
						if(values != '') {
							$("#showStaffID_indicator").html("<select name='sendAppTo'>" +	"<option value='' />" + values + "</select>");
						}//if
					}//success
				});//$.ajax				
			}else{				
				$.ajax({
					type: "POST",
					url: "../ui/approvalIDCMB.jsp",
					data: "reqStat=" + reqStatus + "&category=fs&sendAppTo=" + selectedApprover,					
					success: function(values){
						if(values != '') {
							$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
						}//if
					}//success
				});//$.ajax				
			}	    
		}else{
		    if(dayDiff<3){
		    	if(siteCode=='hkah' && reqDept == '300'){
		    		chargeTo = '300';
		    	}else if(siteCode=='twah' && reqDept == 'FOOD'){
		    		chargeTo = 'FOOD';
		    	}	    	
		    }
		    
		    if(did=='2'){
			    autoShowMisc(true);		    	
		    }else{
			    autoShowMisc(false);
		    }

			$.ajax({
				type: "POST",
				url: "../ui/approvalIDCMB.jsp",
				data: "reqDept=" + chargeTo + "&category=fs&requestType=" + requestType,
				success: function(values){
					if(values != '') {
						$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
					}//if
				}//success
			});//$.ajax
		}
	}
	
	function getDeptHead(inputObj) {
		var requestType = document.form1.requestType.value;
		showOtherRequest(inputObj);
		
		if(requestType!='2'){
			var siteCode = "<%=serverSiteCode%>";			
			var chargeTo = inputObj.value;
			var reqDept = document.form1.reqDept.value;
			var reqStatus = document.form1.reqStatus.value;
			var selectedApprover = document.form1.selectedApprover.value;
			var requestType = document.form1.requestType.value;
			
			var servDate = document.form1.servDate.value;
			var dayDiff = getCurrentDateDiff(servDate);
	
		    if(dayDiff<3){
		    	if(siteCode=='hkah' && reqDept == '300'){
		    		chargeTo = '300';
		    	}else if(siteCode=='twah' && reqDept == 'FOOD'){
		    		chargeTo = 'FOOD';
		    	}	    	
		    }

			$.ajax({
				type: "POST",
				url: "../ui/approvalIDCMB.jsp",
				data: "reqDept=" + chargeTo + "&category=fs&requestType=" + requestType,
				success: function(values){
					if(values != '') {
						$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
					}//if
				}//success
			});//$.ajax			
		}			
	}
	

	function getChangeReqDeptHead(inputObj) {
		var requestType = document.form1.requestType.value;
		showOtherRequest(inputObj);		
	
		if(requestType=='2'){
			var siteCode = "<%=serverSiteCode%>";
			var reqDept = inputObj.value;			
			var chargeTo = document.form1.chargeTo.value;
			var reqStatus = document.form1.reqStatus.value;
			var selectedApprover = document.form1.selectedApprover.value;
			var requestType = document.form1.requestType.value;
			
			var servDate = document.form1.servDate.value;
			var dayDiff = getCurrentDateDiff(servDate);

		    if(dayDiff<3){
		    	if(siteCode=='hkah' && reqDept == '300'){
		    		chargeTo = '300';
		    		
					$.ajax({
						type: "POST",
						url: "../ui/approvalIDCMB.jsp",
						data: "reqDept=" + chargeTo + "&category=fs&requestType=" + requestType,
						success: function(values){
							if(values != '') {
								$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
							}//if
						}//success
					});//$.ajax		
		    	}else if(siteCode=='twah' && reqDept == 'FOOD'){
		    		chargeTo = 'FOOD';
		    		
					$.ajax({
						type: "POST",
						url: "../ui/approvalIDCMB.jsp",
						data: "reqDept=" + chargeTo + "&category=fs&requestType=" + requestType,
						success: function(values){
							if(values != '') {
								$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
							}//if
						}//success
					});//$.ajax				    		
		    	}	    	
		    }else{
				$.ajax({
					type: "POST",
					url: "../ui/approvalIDCMB.jsp",
					data: "reqDept=" + chargeTo + "&category=fs&requestType=" + requestType,
					success: function(values){
						if(values != '') {
							$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
						}//if
					}//success
				});//$.ajax			    	
		    }	
		}			
	}	
	
	function numCheck(evt) {
		var theEvent = evt || window.event;
		var key = theEvent.keyCode || theEvent.which;
		key = String.fromCharCode( key );
		var regex = /[0-9]/;
		if( !regex.test(key) ) {
			theEvent.returnValue = false;
			if(theEvent.preventDefault) theEvent.preventDefault();
		}
	}
	
	function autoClick(inpObj){
		var qty = inpObj.value;
		if(inpObj.name.substr(0, 5)=='check'){
			itemNo = inpObj.name.substr(8, 2);	
			if(qty>0){
				$('input[name=check'+itemNo+']').attr("checked",true);
			}else if(qty==0){
				$('input[name=check'+itemNo+']').attr("checked",false);
			}		
		}		
	}	

	function selectRecordEvent() {		
		$('button.record').each(function(i, v) {
			if(this.id == 'Patient_Contact_Info_Show'){
				$(this).click(function() {	
					$('button#Patient_Contact_Info_Hide').addClass('selected');	
					$('button#Patient_Contact_Info_Hide').css('display', '');				
					$('div#patientContactInfo').css('display', '');
					$(this).css('display','none');
				});	
			}else if(this.id == 'Patient_Contact_Info_Hide'){
				$(this).click(function() {	
					$(this).removeClass('selected');
					$('div#patientContactInfo').css('display', 'none');
					$(this).css('display', 'none');
					$('button#Patient_Contact_Info_Show').css('display', '');
				});	
			}else{
				$(this).click(function() {				
					$(this).addClass('selected');	
					createPanel(this.id,'record');
				});
			}			
		});
	}
	
	function invertSelected(inputObj){
		var checkAll = false;
		if(inputObj.checked){
			checkAll = true;
		}else{
			checkAll = false;
		};
		$('input.chk-record').each(function(i, v) {
			if (checkAll) {
				$(this).attr("checked",true);
			}else{
				$(this).attr("checked",false);
			};
		});
	}	
</script>
</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>