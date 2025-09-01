package com.hkah.web.db;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Map;

import com.hkah.web.common.UserBean;

public class ELTypeConstraint {

	public static String[] checkleaveType(UserBean userBean,String leaveID,String leaveType,String appliedHour, 
			Map detailsMap,String fromDate,
										 String toDate,String publidHDate){
		if("FL".equals(leaveType)){
			return checkFLApplication(userBean,detailsMap.get("FL_relationship").toString(),leaveID,appliedHour);
		}else if ("ML".equals(leaveType)){
			return new String[]{"Y",""};
		}else if ("HL".equals(leaveType)){
			return checkHLApplication(userBean,fromDate,publidHDate,appliedHour );
		}else{
			return new String[]{"Y",""};
		}
	}
	private static String[] checkFLApplication(UserBean userBean,String relationship, String leaveID,String appliedHour ){
		
		if(((ELeaveDB.getSumofDayOrHrByleaveTypeAndDetails("FL",userBean.getStaffID(),
				"hour", "FL_relationship", relationship)+Double.parseDouble(appliedHour))<25)&&
				ELeaveDB.getSumofDayOrHrByleaveTypeAndDetails("FL",userBean.getStaffID(), "hour", "FL_relationship", relationship)>-1){
			return new String[]{"Y",""};
		}else{
			return new String[]{"N","Funeral Leave for one relatives should not be over 3 days"};
		}
	}
	private static String[] checkHLApplication(UserBean userBean,String fromDate, String PhDate,String appliedHour ){
		
		if(((ELeaveDB.getSumofDayOrHrByDate("HL", "hour", "EL_PUBLIC_HOLIDAY", PhDate)+Integer.parseInt(appliedHour))<9)
				&&(ELeaveDB.getSumofDayOrHrByDate("HL", "hour", "EL_PUBLIC_HOLIDAY", PhDate)+Integer.parseInt(appliedHour))>-1){
				SimpleDateFormat Format = new SimpleDateFormat("dd/MM/yyyy");  
				Calendar fromCalendar = Calendar.getInstance();
				Calendar PHCalendar = Calendar.getInstance();
				Calendar twoMonthCalendar = Calendar.getInstance();
				try{
					fromCalendar.setTime(Format.parse(fromDate));
					twoMonthCalendar.setTime(Format.parse(PhDate));
					PHCalendar.setTime(Format.parse(PhDate));			
					}catch(Exception e){
						System.out.println(e);
					}
					twoMonthCalendar.add(Calendar.MONTH,2);
			
				if(fromCalendar.after(PHCalendar) && fromCalendar.before(twoMonthCalendar)){	
					return new String[]{"Y",""};
				}else{
					if(fromCalendar.before(PHCalendar)){
						return new String[]{"N","Can not apply Holiday Leave before the holiday date"};
					}else{
						return new String[]{"N","Can not apply Holiday Leave two months after the holiday"};						
					}
				}
		}else{
			return new String[]{"N","This Public Holiday Leave has been applied before"};
		}
	}
	
	
	
	
}
