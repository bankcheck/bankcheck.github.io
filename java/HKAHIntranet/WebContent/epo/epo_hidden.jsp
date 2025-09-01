<%@ page import="java.util.*"%><%@ 
page import="com.hkah.util.*"%><%@ 
page import="com.hkah.web.common.*"%><%@ 
page import="com.hkah.web.db.*"%><%

ArrayList record = null; 
int chk =  Integer.parseInt(request.getParameter("p1")) ;
String rtnFlag = null;
int alreadyOrder = 0;
String poNo = null;
String reqNo = null;
String totalAmt = null;
String amountRange = null;
String reqApprCode = null;
String validID = null;
String staffId = null;
String appGrp = null;
String isExistApprovlGroup=null;
String isExistApprovlGroupByReqNO=null;
String type = null;
String code = null;
String reqDept = null;
String reqDate = null;
int noOfReq = 0;

System.out.println("[epo_hidden] p1="+request.getParameter("p1")+", p2="+request.getParameter("p2")+", p3="+request.getParameter("p3")+", p4="+request.getParameter("p4")+", p5="+request.getParameter("p5")+", p6="+request.getParameter("p6"));

switch(chk) 
{ 
case 1:
	poNo = request.getParameter("p2");
	ArrayList poList = EPORequestDB.existPoListByPo(poNo);
	alreadyOrder = 0;	
	alreadyOrder = poList.size();
	
	if("PC".equals(poNo.toUpperCase())){
		rtnFlag = "2"; // valid	
	}else{
		if (alreadyOrder>0) {
			rtnFlag = "1"; // exist PO
		}else{
			rtnFlag = "2"; // valid
		}		
	}

	break; 
case 2:	
	totalAmt = request.getParameter("p2");
	amountRange = request.getParameter("p3");
	validID = EPORequestDB.checkValidAmtID(amountRange,totalAmt);

	if ("1".equals(validID)) {
		rtnFlag = "1"; // valid range
	}else{
		rtnFlag = "2"; // valid
	}
	break;
case 3:
	totalAmt = request.getParameter("p2");
	amountRange = request.getParameter("p3");
	validID = EPORequestDB.checkValidAmt(amountRange,totalAmt);
		
	if ("1".equals(validID)) {
		rtnFlag = "1"; // valid range
	}else{
		rtnFlag = "2"; // valid
	}
	break;	
case 4:
	totalAmt = request.getParameter("p2");
	appGrp = request.getParameter("p3");	
	amountRange = EPORequestDB.checkAmtId(totalAmt,appGrp);
	
	if(amountRange!=null && amountRange.length()>0){
		rtnFlag = amountRange;
	}else{
		rtnFlag = null;
	}
	break;
case 5:
	amountRange = request.getParameter("p2");
	reqApprCode = EPORequestDB.getApprovalCode(amountRange);
	
	if(reqApprCode!=null && reqApprCode.length()>0){
		rtnFlag = reqApprCode;
	}else{
		rtnFlag = null;
	}
	break;
case 6:
	amountRange = request.getParameter("p2");
	record = EPORequestDB.getRequestHdr(reqNo.toUpperCase());
	noOfReq = record.size();
		
	if(noOfReq>0){
		rtnFlag = Integer.toString(noOfReq);
	}else{
		rtnFlag = "0";
	}
	break;
case 7:
	amountRange = request.getParameter("p2");
	staffId = request.getParameter("p3");
	appGrp = request.getParameter("p4");
	System.err.println("[epohidden][amountRange]:"+amountRange+";[staffId]:"+staffId+";[appGrp]:"+appGrp);
	isExistApprovlGroup = EPORequestDB.isExistApprovlGroup(amountRange,staffId,appGrp);
	
	if(isExistApprovlGroup.equals("1")){
		rtnFlag = isExistApprovlGroup;
	}else{
		rtnFlag = "0";
	}
	break;
case 8:
	reqNo = request.getParameter("p2");
	staffId = request.getParameter("p3");
	appGrp = request.getParameter("p4");
	System.err.println("[epohidden][reqNo]:"+reqNo+";[staffId]:"+staffId+";[appGrp]:"+appGrp);
	isExistApprovlGroupByReqNO = EPORequestDB.isExistApprovlGroupByReqNO(reqNo,staffId,appGrp);
	
	if(isExistApprovlGroupByReqNO.equals("1")){
		rtnFlag = isExistApprovlGroupByReqNO;
	}else{
		rtnFlag = "0";
	}
	break;
case 9:
	reqNo = request.getParameter("p2");	
	record = EPORequestDB.getRequestHdr(reqNo.toUpperCase());
	noOfReq = record.size();	
	if(noOfReq>0){
		ReportableListObject row = (ReportableListObject) record.get(0);		
		rtnFlag = row.getValue(9); 		
	}else{		
		rtnFlag = "0";		
	}
	break;
case 10:
	type = request.getParameter("p2");	
	code = request.getParameter("p3");
	reqNo = request.getParameter("p4");
	reqDept = request.getParameter("p5");	
	reqDate = request.getParameter("p6");
	System.err.println("[reqNo]:"+reqNo+", [reqDate]:"+reqDate);	
	record = EPORequestDB.getBudgetRemain(type, code, reqNo, reqDept, reqDate);
	noOfReq = record.size();	
	if(noOfReq>0){
		ReportableListObject row = (ReportableListObject) record.get(0);		
		rtnFlag = row.getValue(3); 		
	}else{		
		rtnFlag = "F";		
	}
	System.err.println("[rtnFlag]:"+rtnFlag);
	break;
case 11:	
	type = request.getParameter("p2");	
	code = request.getParameter("p3");	
	reqDept = request.getParameter("p4");
	reqDate = request.getParameter("p6");
	System.err.println("[code]:"+code+";[reqDept]:"+reqDept+", [reqDate]:"+reqDate);	
	record = EPORequestDB.getBudgetDesc(type, code, reqDept, reqDate);
	noOfReq = record.size();	
	if(noOfReq>0){
		ReportableListObject row = (ReportableListObject) record.get(0);		
		rtnFlag = row.getValue(0); 		
	}else{		
		rtnFlag = "-1";		
	}
	System.err.println("[rtnFlag]:"+rtnFlag);
	break;	
}

%><%@ page language="java" contentType="text/html; charset=big5" %><%=rtnFlag != null ? rtnFlag : "0" %>

