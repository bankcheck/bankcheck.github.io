package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class ICPageDB {
	
	private static String sqlStr_getEvent = null;

	public static ArrayList getList(String Category){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT IC_PAGE_DESC, IC_PAGE_LINK, TO_CHAR(IC_EVENT_DATE,'dd/mm/yyyy'),IC_INFORMATION_ID ");
		sqlStr.append(" FROM IC_INFORMATION_PAGE ");
		sqlStr.append(" WHERE IC_PAGE_CATEGORY = '"+Category+"' ");
		sqlStr.append(" AND IC_ENABLED = 1  ");
		sqlStr.append(" ORDER BY IC_INFORMATION_ID desc");
		
		return UtilDBWeb.getReportableList(
				sqlStr.toString());
	}
	
	public static ArrayList get(String infoID){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT IC_PAGE_CATEGORY,IC_PAGE_DESC, IC_PAGE_LINK, TO_CHAR(IC_EVENT_DATE,'dd/mm/yyyy') ");
		sqlStr.append(" FROM IC_INFORMATION_PAGE ");
		sqlStr.append(" WHERE IC_INFORMATION_ID = "+infoID);
		sqlStr.append(" AND IC_ENABLED = 1  ");
		
		return UtilDBWeb.getReportableList(
				sqlStr.toString());
	}
	
	public static ArrayList getByCategory(String infoCategory, Integer noOfEntry){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT IC_PAGE_DESC, IC_PAGE_LINK, TO_CHAR(IC_EVENT_DATE,'dd/mm/yyyy'),IC_ISEXTERNAL,IC_DOCUMENTID ");
		sqlStr.append(" FROM IC_INFORMATION_PAGE ");
		sqlStr.append(" WHERE IC_PAGE_CATEGORY = '"+infoCategory+"' ");
		sqlStr.append(" AND IC_ENABLED = 1  ");
		
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),noOfEntry);
	}
	
	public static ArrayList getEvent(Integer currentMonth,Integer currentYear){
		Integer nextMonth =0;
		Integer NextYear = 0;
		if(currentMonth == 12){
			nextMonth = 01;
			NextYear =currentYear+1;
		}else{
			nextMonth = currentMonth+1;
			NextYear = currentYear;
		}
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT IC_PAGE_DESC, TO_CHAR(IC_EVENT_DATE,'mm/dd/yyyy'), ");
		sqlStr.append("TO_CHAR(IC_EVENT_DATE,'MON'), TO_CHAR(IC_EVENT_DATE,'DD') ");
		sqlStr.append(" FROM IC_INFORMATION_PAGE ");
		sqlStr.append(" WHERE IC_PAGE_CATEGORY = 'Calendar' ");
		sqlStr.append(" and IC_EVENT_DATE >= sysdate ");
		//sqlStr.append(" and IC_EVENT_DATE < to_date('01/"+nextMonth+"/"+NextYear+"','dd/mm/yyyy')  ");
		sqlStr.append(" and IC_ENABLED = 1 ORDER BY IC_EVENT_DATE ");
		
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),3);
	}
	public static String getNextInfoID() {
		// fetch news list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MAX(IC_INFORMATION_ID)+1 ");
		sqlStr.append("FROM   IC_INFORMATION_PAGE ");


		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			if(!"".equals(row.getValue(0))){
			return row.getValue(0);
			}else{
				return "1";
			}
		}else{
			return null;
		}
	}
	
	public static String add(UserBean userBean, String infoCategory) {
			
		String infoID = getNextInfoID();
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO IC_INFORMATION_PAGE (");
		sqlStr.append("IC_INFORMATION_ID,IC_PAGE_CATEGORY, IC_CREATED_USER, IC_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('" + infoID + "','"+infoCategory+"',?, ?)");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {userBean.getLoginID(), userBean.getLoginID() })) {
					return infoID;
			}else{
			return null;
		}
	}
	
	public static boolean update(UserBean userBean, String infoID, String infoCategory, String infoDesc, String infoDate, String infoLink) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE IC_INFORMATION_PAGE ");
		sqlStr.append("SET    IC_PAGE_CATEGORY ='"+infoCategory+"',");
		if(infoDate != null){
		sqlStr.append("       IC_EVENT_DATE = TO_DATE('"+infoDate+"', 'dd/MM/YYYY'), ");
		}
		if(infoLink != null){
		sqlStr.append("       IC_PAGE_LINK = '"+infoLink+"', ");
		}
		sqlStr.append("		  IC_PAGE_DESC = '"+infoDesc+"' ");
		sqlStr.append("		  WHERE IC_INFORMATION_ID = "+infoID+" ");
		sqlStr.append("		  AND IC_ENABLED = 1 ");
		
		return UtilDBWeb.updateQueue(
				sqlStr.toString() );
	}
	
	public static boolean delete(UserBean userBean, String infoID) {
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE IC_INFORMATION_PAGE ");
		sqlStr.append("SET    IC_ENABLED = 0, ");
		sqlStr.append("       IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
		sqlStr.append("		  WHERE IC_INFORMATION_ID = "+infoID+" ");
		
		return UtilDBWeb.updateQueue(
				sqlStr.toString());
	}
	
}