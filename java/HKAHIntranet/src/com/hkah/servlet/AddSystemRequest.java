package com.hkah.servlet;

//Import required java libraries
import java.io.*;
import java.util.ArrayList;

import javax.servlet.*;
import javax.servlet.http.*;


import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

//Extend HttpServlet class
public class AddSystemRequest extends HttpServlet {
	
	private String month;
	private int count;
	
	private static String sqlStr_insertRequest = null;
	private static String sqlStr_insertRequestExam = null;
	private static String sqlStr_insertRequestItem = null;
	
	StringBuffer sqlStr = new StringBuffer();

	public void init() throws ServletException {
	   // Do required initialization
		count = 0;
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_PHE_REQ ");
		sqlStr.append("(CO_REQ_NO, CO_STAFF_ID, CO_PATNO, ");
		sqlStr.append("CO_PATNAME, CO_PATCNAME, CO_REQ_DATE, ");
		sqlStr.append("CO_DEPT_CODE, CO_DEPT_DESC, CO_POSITION, ");
		sqlStr.append("CO_PATSEX, CO_PATAGE, CO_PATBDATE, ");
		sqlStr.append("CO_STATUS, CO_REQ_BY) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append("?, ?, SYSDATE, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?) "); 
	 	sqlStr_insertRequest = sqlStr.toString();
	 	
	 	sqlStr.setLength(0);
	 	sqlStr.append("INSERT INTO CO_PHE_REQ_EXM ");
	 	sqlStr.append("(CO_REQ_NO, CO_PHE_CODE, CO_OPTIONAL, CO_NEED_APPROVAL, CO_STATUS) ");
	 	sqlStr.append("VALUES ");
	 	sqlStr.append("(?, ?, 'N', 'N', 'APPROVED') ");
	 	sqlStr_insertRequestExam = sqlStr.toString();
	 	
	 	sqlStr.setLength(0);
	 	sqlStr.append("INSERT INTO CO_PHE_REQ_ITM ");
	 	sqlStr.append("(CO_REQ_NO, CO_PHE_CODE, CO_PKGCODE, CO_ITMCODE, CO_ITMNAME, CO_OPTIONAL, CO_DSCCODE) ");
	 	sqlStr.append("VALUES ");
	 	sqlStr.append("(?, ?, ?, ?, ?, 'N', ?) ");
	 	sqlStr_insertRequestItem = sqlStr.toString();
	}
	
	private static String getNextReqNo() {
		String reqNo = null;
	
		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT seq_phe_req.nextval FROM DUAL");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			reqNo = reportableListObject.getValue(0);
	
			// set 1 for initial
			if (reqNo == null || reqNo.length() == 0) return "1";
		}
		return reqNo;
	}
	
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		service(request, response);
	}
	
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		service(request, response);
	}
	
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		month = request.getParameter("month");
		
		//add staff List
		ArrayList staffID = new ArrayList();
		
		// get staffID 
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  PA.CO_STAFF_ID ");
		sqlStr.append("FROM CO_PHE_ANNUAL PA ");
		sqlStr.append("WHERE CO_CHECK_MONTH = '"+ month + "'");
		
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			for (int i=0; i<result.size(); i++){
				ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
				staffID.add(reportableListObject.getValue(0));
			}
		}

		for(int i=0;i<staffID.size();i++){
			String currentStaffID = staffID.get(i).toString();
			//check staff list in phe list
			sqlStr.setLength(0);
			sqlStr.append("SELECT CO_REQ_NO ");
			sqlStr.append("FROM CO_PHE_REQ ");
			sqlStr.append("WHERE CO_STAFF_ID = '"+currentStaffID+"' ");
			sqlStr.append("AND CO_REQ_BY = 'SYSTEM' ");
			sqlStr.append("AND CO_STATUS != 'COMPLETED' ");
			result = UtilDBWeb.getReportableList(sqlStr.toString());
			if (result.size() > 0) {
			}else{
				// get next record ID
				String reqNo = null;
				reqNo = getNextReqNo();
				
				String patno = null;
				String patname = null;
				String patcname = null;
				String deptCode = null;
				String deptDesc = null;
				String position = null;
				String patsex = null;
				String patage = null;
				String patbdate = null;
				
				//get staffInfo
				sqlStr.setLength(0);
				sqlStr.append("SELECT  S.CO_STAFF_ID, ");
				sqlStr.append("        P.PATNO, DECODE( p.patfname, null, null, p.patfname || ' ') || p.patgname PATNAME, ");
				sqlStr.append("        P.PATCNAME, S.CO_DEPARTMENT_CODE, S.CO_DEPARTMENT_DESC, ");
				sqlStr.append("        TRIM(s.co_position_1 || ' ' || s.co_position_2) CO_POSITION, P.PATSEX, ");
				sqlStr.append("        ROUND( ( sysdate - p.patbdate )/ 365.25 ) PATAGE, TO_CHAR(p.patbdate,'DD-MM-YYYY') PATBDATE ");
				sqlStr.append("FROM CO_STAFFS S ");
				sqlStr.append("JOIN PATIENT@IWEB P ");
				sqlStr.append("  ON P.PATNO = S.CO_HOSP_NO ");
				sqlStr.append("WHERE S.CO_ENABLED = 1 ");
				sqlStr.append("AND S.CO_STAFF_ID = '" + currentStaffID + "' ");
				
				result = UtilDBWeb.getReportableList(sqlStr.toString());
				if (result.size() > 0) {
					ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
					patno = reportableListObject.getValue(1);
					patname = reportableListObject.getValue(2);
					patcname = reportableListObject.getValue(3);
					deptCode = reportableListObject.getValue(4);
					deptDesc = reportableListObject.getValue(5);
					position = reportableListObject.getValue(6);
					patsex = reportableListObject.getValue(7);
					patage = reportableListObject.getValue(8);
					patbdate = reportableListObject.getValue(9);
				}
				
				//get staff phe
				ArrayList pheExam = new ArrayList();
				ArrayList pkgCode = new ArrayList();
				ArrayList itmCode = new ArrayList();
				String status = "RECEIVED";
				String reqBy = "SYSTEM";
				sqlStr.setLength(0);
				sqlStr.append("SELECT CO_PHE_CODE, CO_PKGCODE, CO_ITMCODE ");
				sqlStr.append("FROM CO_PHE_EXAM ");
				sqlStr.append("WHERE CO_DEPT_CODE LIKE '%" + deptCode + "%'");
				
				result = UtilDBWeb.getReportableList(sqlStr.toString());
				if (result.size() > 0) {
					for (int j=0; j<result.size(); j++){
						ReportableListObject reportableListObject = (ReportableListObject) result.get(j);
						pheExam.add(reportableListObject.getValue(0));
						pkgCode.add(reportableListObject.getValue(1));
						itmCode.add(reportableListObject.getValue(2));
					}
				}
				
				// try to insert a new record
				Boolean success = UtilDBWeb.updateQueue(
					sqlStr_insertRequest,
					new String[] {
							reqNo, currentStaffID, patno, patname, patcname, deptCode, deptDesc, position, patsex, patage, patbdate, status, reqBy
								});
				// insert new req_exm
				for(int j=0;j<pheExam.size();j++){
					String currentPheExam = pheExam.get(j).toString();
					String currentPkgCode = pkgCode.get(j).toString();
					String currentItmCode = itmCode.get(j).toString();
					
					success = UtilDBWeb.updateQueue(
							sqlStr_insertRequestExam,
							new String[] {
									reqNo, currentPheExam
										});
					
					String itmName = null;
					String dsccode = null;
					//get itm info
					sqlStr.setLength(0);
					sqlStr.append("SELECT ITMCODE, ITMNAME, DSCCODE ");
					sqlStr.append("FROM item@iweb ");
					sqlStr.append("WHERE ITMCODE = '" + currentItmCode + "'");
					result = UtilDBWeb.getReportableList(sqlStr.toString());
					if (result.size() > 0) {
						ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
						itmName = reportableListObject.getValue(1);
						dsccode = reportableListObject.getValue(2);
					}
					
					// insert new req_itm
					success = UtilDBWeb.updateQueue(
							sqlStr_insertRequestItem,
							new String[] {
									reqNo, currentPheExam, currentPkgCode, currentItmCode, itmName, dsccode
										});
				}

				if (success){
					count++;
				}
			}

		}

		response.setContentType("text/html");
		PrintWriter pw = response.getWriter();
		pw.print(count);
	
		destroy();
	}
	
	public void destroy() {
		count = 0;
	}
	

	

	
}