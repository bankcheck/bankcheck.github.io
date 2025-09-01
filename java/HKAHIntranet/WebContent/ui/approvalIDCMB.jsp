<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String staffID = userBean.getStaffID();
String loginID = userBean.getStaffID();
String category = request.getParameter("category");
String value = request.getParameter("value");
String reqStatus = request.getParameter("reqStat");	
String sendAppTo = request.getParameter("sendAppTo");
String deptHead = request.getParameter("deptHead");
String reqDept = request.getParameter("reqDept");
String reqNo = request.getParameter("reqNo");
String requestType = request.getParameter("requestType");
String showAll = request.getParameter("showAll");
String appGrp = request.getParameter("appGrp");
String amtID = request.getParameter("amtID");
String isExistApprovlGroup = null;
System.err.println("[sendAppTo]:"+sendAppTo);
if("null".equals(deptHead) || deptHead==null || deptHead.length()==0 ){
	deptHead = "";
}

ArrayList record = null;
boolean ignoreCurrentStaffID = "Y".equals(request.getParameter("ignoreCurrentStaffID"));

if("epo".equals(category)){
	if("S".equals(reqStatus)){
		if(sendAppTo==null || sendAppTo.length()==0){
			sendAppTo = "";			
		}
	}
	
	if(!(deptHead!=null && deptHead.length()>0) && "HKIOC".equals(appGrp)){
		ArrayList record1 = EPORequestDB.getDeptHeadList(reqDept);
		if(record1.size()>0){
			ReportableListObject row = (ReportableListObject) record1.get(0);
			deptHead = row.getValue(0);
		}		
	}
	System.err.println("0[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus+";[sendAppTo]:"+sendAppTo);		
		if(deptHead!=null && deptHead.length()>0){
		System.err.println("1.1[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus);
		if(("S".equals(reqStatus) || "H".equals(reqStatus)) && deptHead.equals(loginID)){
			isExistApprovlGroup = EPORequestDB.isExistApprovlGroup(amtID,deptHead,appGrp);
			System.err.println("1.2[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus);
			if("HKIOC".equals(appGrp) && isExistApprovlGroup.equals("1")){
				if("S".equals(reqStatus)){
					record = EPORequestDB.getDeptHeadList(reqDept);					
				}else if("H".equals(reqStatus)){
					record = ApprovalUserDB.getEpoAppUserList("1", "1", deptHead, loginID, appGrp);
				}
			}else{
				appGrp = "HKAH";
				System.err.println("2[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus);
				if("S".equals(reqStatus)){
					if("HKAH".equals(appGrp) && "1".equals(amtID)){
						record = EPORequestDB.getDeptHeadList(reqDept);				
					}else{
						record = ApprovalUserDB.getEpoAppUserList("1", "1", null, loginID, appGrp);				
					}
				}else if("H".equals(reqStatus)){
					if(isExistApprovlGroup.equals("1")){
						record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, appGrp);						
					}else if(sendAppTo!=null){
						record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, appGrp);						
					}else{
						record = ApprovalUserDB.getEpoAppUserList("1", "1", null, loginID, appGrp);						
					}
				}
			}
		}else if("O".equals(reqStatus) || "P".equals(reqStatus) || "F".equals(reqStatus) || "A".equals(reqStatus) || "Z".equals(reqStatus)){
			System.err.println("2.1[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus);
			record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, reqStatus, appGrp);			
		}else{
			System.err.println("3[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus);
			if("S".equals(reqStatus)){
				record = ApprovalUserDB.getDepartmentHead(loginID);				
			}else if("H".equals(reqStatus)){
				System.err.println("3.1[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus);
				appGrp = "HKAH";				
				record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, appGrp);					
			}else{
				System.err.println("4[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus);
				record = ApprovalUserDB.getDepartmentHead(deptHead);				
			}
		}		
	}else if(reqDept!=null && reqDept.length()>0){		
		System.err.println("6[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus+";[reqNo]:"+reqNo);
		if("S".equals(reqStatus)){
			String deptSRN = EPORequestDB.getDeptSRNList(reqDept); 
			System.err.println("[deptSRN]:"+deptSRN);			
			ArrayList record2 = EPORequestDB.getDeptHeadList(reqDept);
			if(record2.size()>0){
				ReportableListObject row2 = (ReportableListObject) record2.get(0);
				deptHead = row2.getValue(0);
			}
			if(deptHead.equals(loginID)||deptSRN.equals(loginID)){
				if("HKAH".equals(appGrp) && "1".equals(amtID)){
					record = EPORequestDB.getDeptHeadList(reqDept);				
				}else{
					record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, appGrp);				
				}				
			}else{				
				record = ApprovalUserDB.getDepartmentHead(deptHead);
			}	
		}else if("H".equals(reqStatus)){
			if("HKAH".equals(appGrp) && "1".equals(amtID) && reqNo==null){
				record = EPORequestDB.getDeptHeadList(reqDept);				
			}else{
				record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, appGrp);				
			}			
		}else{
			if("HKAH".equals(appGrp) && "1".equals(amtID) && sendAppTo!=null){
				record = EPORequestDB.getDeptHeadList(reqDept);				
			}else{
				record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, appGrp);				
			}			
		}	
	}else{
		System.err.println("7.0[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus+";[sendAppTo]:"+sendAppTo+";[appGrp]:"+appGrp);
		if("O".equals(reqStatus) || "P".equals(reqStatus) || "F".equals(reqStatus) || "A".equals(reqStatus) || "Z".equals(reqStatus)){		
			System.err.println("7.1[amtID]:"+amtID+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept+";[deptHead]:"+deptHead+";[loginID]:"+loginID+";[reqStatus]:"+reqStatus+";[sendAppTo]:"+sendAppTo+";[appGrp]:"+appGrp);			
			record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, reqStatus, appGrp);
		}else if("S".equals(reqStatus)){
			if(reqNo!=null && reqNo.length()>0){				
				if((deptHead!=null && deptHead.length()>0)){
					record = ApprovalUserDB.getDepartmentHead(deptHead);
				}else if((sendAppTo!=null && sendAppTo.length()>0)){
					record = ApprovalUserDB.getDepartmentHead(sendAppTo);
				}else{
					record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, "HKAH");
				}
			}else{				
				record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, "HKAH");
			}
		}else{
			record = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, loginID, appGrp);
		}				
	}
}else if("fs".equals(category)){
	if("1".equals(requestType)){
		if(sendAppTo!=null && sendAppTo.length()>0){
			if("Y".equals(showAll)){
				record = ApprovalUserDB.getEpoAppUserList("2", "1", null, null, "HKAH");
			}else{
				record = ApprovalUserDB.getEpoAppUserList("2", "1", sendAppTo, null, "HKAH");
			}			
		}else{
			record = ApprovalUserDB.getEpoAppUserList("2", "1", null, loginID, "HKAH");
		}			
	}else if("2".equals(requestType)){
		if(reqDept!=null && reqDept.length()>0){
			record = EPORequestDB.getDeptHeadList(reqDept);	
		}else{			
			record = ApprovalUserDB.getDepartmentHead(sendAppTo);
		}
	}else if("3".equals(requestType)||"4".equals(requestType)||"5".equals(requestType)||"6".equals(requestType)){
		if(reqDept!=null && reqDept.length()>0){
			record = EPORequestDB.getDeptHeadList(reqDept);	
		}else{			
			record = ApprovalUserDB.getDepartmentHead(sendAppTo);
		}
	}else{		
		record = ApprovalUserDB.getEpoAppUserList("2", "1", sendAppTo, loginID, "HKAH");		
	}
}else if("cts".equals(category)){
	record = ApprovalUserDB.getCtsApprover(sendAppTo);
	value = sendAppTo;	
}else{
	record = ApprovalUserDB.getApprovalUserList("eleave", "approve", null, null, staffID);	
}

ReportableListObject row = null;
String userID = null;
String userName = null;

if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);

		userID = row.getValue(0);
		userName = row.getValue(1);
		System.err.println("["+i+"][userID]:"+userID+";[userName]:"+userName);
		if (!ignoreCurrentStaffID || !userID.equals(staffID)) {						
			// select if staff id or department code is matched
			if("fs".equals(category)){
				%><option value="<%=userID %>"<%=userID.equals(sendAppTo)?" selected":"" %>><%=userName %></option><%				
			}else{
				%><option value="<%=userID %>"<%=userID.equals(value)||row.getValue(2).equals(value)?" selected":"" %>><%=userName %></option><%				
			}
		}
	}
}
%>