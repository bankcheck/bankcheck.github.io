<%@ page import="java.util.*"%><%@ 
page import="com.hkah.util.*"%><%@ 
page import="com.hkah.web.common.*"%><%@ 
page import="com.hkah.web.db.*"%><%

int chk =  Integer.parseInt(request.getParameter("p1")) ;
String ctsNo = null;
String password = null;
String docCode = null;
String ctsStatus = null;
String assignDoc = null;
int rowCnt = 0;
String rtnFlag = null;
String hkmclicno = null;
System.err.println("[chk]:"+chk);
switch(chk) 
{ 
case 1:
	ctsNo = request.getParameter("p2");
	password = request.getParameter("p3");
	docCode = CTS.checkRenewRecord(ctsNo,password);
	ctsStatus = CTS.getRecordStatus(ctsNo);
	
	if (docCode!=null && docCode.length()>0) {
		if ("S".equals(ctsStatus)||"X".equals(ctsStatus)||"Y".equals(ctsStatus)||"Z".equals(ctsStatus)||
				"I".equals(ctsStatus)||"L".equals(ctsStatus)||"K".equals(ctsStatus)) {
			rtnFlag = "1"; // valid status and correct password
		}else{
			rtnFlag = "2"; // invalid status
		}	
	}else{
		rtnFlag = "0"; // invalid password		
	}

	break;
case 2:
	ctsNo = request.getParameter("p2");
	password = request.getParameter("p3");
	ArrayList record = CTS.getRecord(ctsNo);
	ReportableListObject row = (ReportableListObject) record.get(0);
	assignDoc = row.getValue(13);
		
	if(assignDoc!=null && assignDoc.length()>0){
		rtnFlag = "1"; // valid
	} else {
		rtnFlag = "0"; // invalid		
	}

	break;
case 3:
	ctsNo = request.getParameter("p2");
//	rtnFlag = CTS.docUploadCount(ctsNo);
	
	break;
case 4:
	hkmclicno = request.getParameter("p2");
	
	System.err.println("[hidden][hkmclicno]:"+hkmclicno);
	ArrayList record1 = CTS.checkNewDocExisting(hkmclicno);
	ReportableListObject row1 = (ReportableListObject) record1.get(0);
	try {
		rowCnt = Integer.parseInt(row1.getValue(0));
	}
	catch (Exception ex) {
		rowCnt = 0;
	}
		
	if(rowCnt>0){
		rtnFlag = Integer.toString(rowCnt);		
	}else{
		rtnFlag = "0";
	}
	System.err.println("[rtnFlag]:"+rtnFlag);	
	break;
case 5:
	docCode = request.getParameter("p2");
	
	System.err.println("[hidden][docCode]:"+docCode);
	ArrayList record2 = CTS.checkDoctorCodeInHATS(docCode);
	ReportableListObject row2 = (ReportableListObject) record2.get(0);
	System.err.println("[row2.getValue(0)]:"+row2.getValue(0));
	try {
		rowCnt = Integer.parseInt(row2.getValue(0));
	}
	catch (Exception ex) {
		rowCnt = 0;
	}
		
	if(rowCnt>0){
		rtnFlag = Integer.toString(rowCnt);		
	}else{
		rtnFlag = "0";
	}
	System.err.println("[rtnFlag]:"+rtnFlag);	
	break;
case 6:
	ctsNo = request.getParameter("p2");
	password = request.getParameter("p3");
	ctsStatus = CTS.checkNewDocRecord(ctsNo,password);
	
	if (ctsStatus!=null && ctsStatus.length()>0) {
		if ("S".equals(ctsStatus)||"X".equals(ctsStatus)||"Y".equals(ctsStatus)||"Z".equals(ctsStatus)||
				"I".equals(ctsStatus)||"L".equals(ctsStatus)||"K".equals(ctsStatus)) {
			if(CTS.updateCTSRecordLock(ctsNo,"1")){
				rtnFlag = "1"; // valid status and correct password				
			}else{
				rtnFlag = "3"; // update record_lock fail				
			}
		}else{
			rtnFlag = "2"; // invalid status
		}	
	}else{
		rtnFlag = "0"; // invalid password		
	}
	System.err.println("[rtnFlag]:"+rtnFlag);
	break;	
}

%><%@ page language="java" contentType="text/html; charset=big5" %><%=rtnFlag != null ? rtnFlag : "0" %>

