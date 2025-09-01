<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%
UserBean userBean = new UserBean(request);

boolean isAllow = true;
if(ConstantsServerSide.isHKAH()) {
	isAllow = XmasGatheringDB.isAllow(userBean.getStaffID()) || XmasGatheringDB.isAllowSpecial(userBean.getStaffID());
}else if(ConstantsServerSide.isTWAH()) {
	isAllow = true;
}
String groupWaitingID = null;
boolean success = false;

if (isAllow) {
	String command = request.getParameter("command");
	String eventID = request.getParameter("eventID");
	String scheduleID = request.getParameter("scheduleID");
	//System.out.println(command);
	//System.out.println(eventID);
	//System.out.println(scheduleID);
	ArrayList groupRecord = XmasGatheringDB.getGroupWaitingCancelID(eventID);
	if(groupRecord.size()>0){
		for(int i = 0; i < 2; i++) {
			ReportableListObject groupRow = (ReportableListObject) groupRecord.get(i);	
			if(i == 0){
				groupWaitingID = groupRow.getValue(1);
			}
		}
	}
	
	String enrollID = null;
	
	if (command.equals("add")) {
		enrollID = XmasGatheringDB.getEnrollID(userBean, eventID, groupWaitingID);
		int result = XmasGatheringDB.withdraw(userBean, eventID, groupWaitingID, 
							enrollID, userBean.getStaffID());
		if (result == -2) {
			//error
			XmasGatheringDB.enroll(userBean, eventID, groupWaitingID, "1",
														userBean.getStaffID());			
			success = false;
		}
		else {
			String enrollNo = request.getParameter("totalParticipant");
			//System.out.println(enrollNo);
			result = XmasGatheringDB.enroll(userBean, eventID, scheduleID, 
									enrollNo, userBean.getStaffID());
			enrollID = XmasGatheringDB.getEnrollID(userBean, eventID, scheduleID);
			String staffMealType = request.getParameter("staffMealType");
			String busToRestType = request.getParameter("busToRestType");
			String busToHospType = request.getParameter("busToHospType");			
			XmasGatheringDB.updateMealType(userBean, eventID, scheduleID, enrollID, staffMealType, busToRestType, busToHospType);			
			if (result == 0) {
				//enroll family
				for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
					String param = e.nextElement().toString();
					if(param.contains("familyType")){
						String familyOccupy = request.getParameter(param);
						String familyTypeID = param.replace("familyType","");
						String familyNames = request.getParameter("familyNames"+familyTypeID);
						String mealType = request.getParameter("mealType"+familyTypeID);
						result = XmasGatheringDB.enrollFamily(userBean, eventID, 
									scheduleID, enrollID, familyTypeID, familyOccupy,(familyNames==null?"":familyNames), mealType);
						
						if (result != 0) {
							break;
						}
					}
				}
				
				if (result == 0) {
					//success
					success = true;
				}
				else {
					//error
					XmasGatheringDB.withdrawFamily(userBean, eventID, 
							scheduleID, enrollID);
					XmasGatheringDB.withdraw(userBean, eventID, scheduleID, 
							enrollID, userBean.getStaffID());
					XmasGatheringDB.enroll(userBean, eventID, "1", 
							groupWaitingID, userBean.getStaffID());
					success = false;
				}
			}
			else {
				//error
				XmasGatheringDB.enroll(userBean, eventID, groupWaitingID, "1",
														userBean.getStaffID());
				success = false;
			}
		}
	}
	else if (command.equals("edit")) {
		String enrollNo = request.getParameter("totalParticipant");
		enrollID = XmasGatheringDB.getEnrollID(userBean, eventID, scheduleID);
		int result = 0;
		
		if (XmasGatheringDB.update(userBean, eventID, scheduleID, enrollID, enrollNo)) {
			XmasGatheringDB.withdrawFamily(userBean, eventID, 
												scheduleID, enrollID);
			for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
				String param = e.nextElement().toString();
				if(param.contains("familyType")){
					String familyOccupy = request.getParameter(param);
					String familyTypeID = param.replace("familyType","");						
					String familyNames = request.getParameter("familyNames"+familyTypeID);
					String mealType = request.getParameter("mealType"+familyTypeID);
					
					result = XmasGatheringDB.enrollFamily(userBean, eventID, 
								scheduleID, enrollID, familyTypeID, familyOccupy,(familyNames==null?"":familyNames), mealType);
					
					if (result != 0) {
						break;
					}
				}
			}
			if (result == 0) {
				//success
				success = true;
			}
			else {
				//error
				XmasGatheringDB.withdrawFamily(userBean, eventID, 
						scheduleID, enrollID);
				XmasGatheringDB.update(userBean, eventID, scheduleID, enrollID,
						"1");
				success = false;
			}
		}
		else {
			//error
			success = false;
		}
	}
}
%>
<%=success%>