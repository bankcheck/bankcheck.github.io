package com.hkah.web.db;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class ELeaveDB {

	private static String sqlStr_insertLeave = null;
	private static String sqlStr_cancelLeave = null;
	private static String sqlStr_listLeave = null;
	private static String sqlStr_listAllLeave = null;

	private static String sqlStr_insertLeaveStaff = null;

	private static String sqlStr_insertLeaveApproval = null;
	private static String sqlStr_updateLeaveApproval = null;
	private static String sqlStr_updateLeaveApprovalToZero = null;
	private static String sqlStr_updateApprovalSpecific = null;
	private static String sqlStr_listLeaveApproval = null;
	private static String sqlStr_listTotalapprovedLeaveApproval = null;
	private static String sqlStr_chkValidApproval = null;
	private static String sqlStr_chkValidApprovalEl = null;
	private static String sqlStr_chkExistApprovalEl = null;
	public static final String NEW_STATUS = "O";
	public static final String PENDING_STATUS = "P";
	public static final String APPROVED_STATUS = "A";
	public static final String APPROVED_HR_STATUS = "H";
	public static final String CANCELED_STATUS = "C";
	public static final String CANCEL_APPROVED_STATUS = "CA";
	public static final String CANCEL_APPROVED_HR_STATUS = "CH";
	public static final String REJECTED_STATUS = "R";
	public static final String CANCEL_REJECTED_STATUS = "CR";

	private static String getNextELeaveID() {
		String eleaveID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(EL_ELEAVE_ID) + 1 FROM EL_ELEAVE");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			eleaveID = reportableListObject.getValue(0);

			// set 1 for initial
			if (eleaveID == null || eleaveID.length() == 0) return "1";
		}
		return eleaveID;
	}

	private static String getNextDetailID() {
		String detailsID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(EL_DETAILS_ID) + 1 FROM EL_DETAILS_VALUE");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			detailsID = reportableListObject.getValue(0);

			// set 1 for initial
			if (detailsID == null || detailsID.length() == 0) return "1";
		}
		return detailsID;
	}

	private static String getNextELeaveApprovalID(String eleaveID) {
		String eleaveApprovalID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(EL_ELEAVE_APPROVED_ID) + 1 FROM EL_ELEAVE_APPROVED WHERE EL_ELEAVE_ID = ?",
				new String[] { eleaveID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			eleaveApprovalID = reportableListObject.getValue(0);

			// set 1 for initial
			if (eleaveApprovalID == null || eleaveApprovalID.length() == 0) return "1";
		}
		return eleaveApprovalID;
	}

	public static String add(
			UserBean userBean, String staffID, String leaveType, String fromDate, String toDate,
			String appliedDate, String remarks) {
		return add(userBean,staffID, leaveType, fromDate, toDate, appliedDate, null, remarks,null,null,null);
	}

	public static String add(
			UserBean userBean, String staffID, String leaveType, String fromDate, String toDate,
			String appliedDate,String appliedHour,String remarks) {
		return add(userBean,staffID, leaveType, fromDate, toDate, appliedDate, appliedHour,remarks,null,null,null);
	}

	public static String add(
			UserBean userBean, String staffID, String leaveType, String fromDate, String toDate,
			String appliedDate, String appliedHour, String remarks,String parentID,Map detailMap,String publicHDate) {

		String eleaveID = getNextELeaveID();

		if (appliedHour == null) {
			appliedHour = ConstantsVariable.ZERO_VALUE;
		}
		String leaveAccrualType = leaveType.substring(0,1)+"A";
			// insert eleave record
		 if (isDoctor(staffID)) {
			if (UtilDBWeb.updateQueue(
					sqlStr_insertLeave,
					new String[] { eleaveID, staffID, leaveType,
							fromDate, toDate, appliedDate, appliedHour, remarks,
							userBean.getLoginID(), userBean.getLoginID() })) {

				// Insert/update balance
				if (isDoctor(staffID)) {
					// insert approval for doctor
					insertApproval(userBean, "eleave.d", eleaveID, null, staffID, "approve");

					String year = fromDate.substring(6, 10);
					float initBalance = 20;
					if (!isBalanceExist(staffID, year)) {
						// Insert
						float pendingBalance = initBalance - Float.parseFloat(appliedDate);
						addBalance(userBean, staffID, year, Float.toString(initBalance), Float.toString(pendingBalance));
					} else {
						// Update
						float balance[] = getBalance(staffID, year);
						float actualBalance = balance[0];
						float pendingBalance = balance[1] - Float.parseFloat(appliedDate);
						if (isDoctor(staffID)) {
						updateBalance(userBean, staffID, year, Float.toString(actualBalance), Float.toString(pendingBalance));
						} else {
						updateBalance(userBean, staffID, year, Float.toString(actualBalance), Float.toString(pendingBalance),leaveAccrualType);
						}
					}
				}

				// send email notify
				sendEmail(eleaveID, staffID, NEW_STATUS, remarks);

				return eleaveID;
			} else {
				return null;
			}
		} else {
			if (isBalanceExist(staffID,"9999",leaveAccrualType)) {
				float balance[] = getBalance(staffID, "9999",leaveAccrualType);
				StringBuffer sqlStr = new StringBuffer();
				sqlStr.append("INSERT INTO EL_ELEAVE (");
				sqlStr.append("EL_ELEAVE_ID, EL_SITE_CODE, EL_STAFF_ID, EL_LEAVE_TYPE, ");
				sqlStr.append("EL_FROM_DATE, EL_TO_DATE, EL_APPLIED_DAYS, EL_APPLIED_HOURS, EL_REQUEST_REMARKS, ");
				sqlStr.append("EL_CREATED_USER, EL_MODIFIED_USER ");
				if (parentID != null && !"".equals(parentID)) {
					sqlStr.append(",EL_PARENT_ID ");
				}
				sqlStr.append(" )");
				sqlStr.append("VALUES ");
				sqlStr.append("(?, '" + ConstantsServerSide.SITE_CODE + "', ?, ?, ");
				sqlStr.append("TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), TO_NUMBER(?), TO_NUMBER(?), ?, ");
				sqlStr.append("?, ? ");
				if (parentID != null && !"".equals(parentID)) {
					sqlStr.append(","+parentID);
				}
				sqlStr.append(" )");
				sqlStr_insertLeave = sqlStr.toString();
				if (balance[1]>0) {
					if ("BL".equals(leaveType)&& !checkBLApplication(userBean,fromDate)) {
						return null;
					}
					if (Float.parseFloat(appliedHour)>balance[1]) {
						return null;
					}
					if (UtilDBWeb.updateQueue(
							sqlStr_insertLeave,
							new String[] { eleaveID, staffID, leaveType,
									fromDate, toDate, appliedDate, appliedHour, remarks,
									userBean.getLoginID(), userBean.getLoginID() })) {
						insertApproval(userBean, "eleave.s", eleaveID, StaffDB.getDeptCode(staffID), staffID, "approve",leaveType);
						if (detailMap.size()>0) {
							Set s = detailMap.entrySet();
							Iterator it=s.iterator();
							while (it.hasNext()) {
								Map.Entry m =(Map.Entry)it.next();
								String detailsName=(String)m.getKey();
								String detailsValue=(String)m.getValue();
								Boolean b = insertDetails(userBean,detailsName,detailsValue,"",eleaveID);
							}
						}
						float actualBalance = balance[0];
						float pendingBalance = balance[1] - Float.parseFloat(appliedHour);
						updateBalance(userBean, staffID, "9999", Float.toString(actualBalance), Float.toString(pendingBalance),leaveAccrualType);
						sendEmail(eleaveID, staffID, NEW_STATUS, remarks);
						return eleaveID;
					} else {
						return null;
					}
				} else {
					return null;
				}
			} else {
				String[] returnResult = ELTypeConstraint.checkleaveType(userBean,eleaveID,leaveType,appliedHour,
						detailMap,fromDate,toDate,publicHDate);
				if ("Y".equals(returnResult[0])) {
					StringBuffer sqlStr = new StringBuffer();
					sqlStr.append("INSERT INTO EL_ELEAVE (");
					sqlStr.append("EL_ELEAVE_ID, EL_SITE_CODE, EL_STAFF_ID, EL_LEAVE_TYPE, ");
					sqlStr.append("EL_FROM_DATE, EL_TO_DATE, EL_APPLIED_DAYS, EL_APPLIED_HOURS, EL_REQUEST_REMARKS, ");
					if (publicHDate !=null && !"".equals(publicHDate)) {
						sqlStr.append("EL_PUBLIC_HOLIDAY, ");
					}
					sqlStr.append("EL_CREATED_USER, EL_MODIFIED_USER) ");
					sqlStr.append("VALUES ");
					sqlStr.append("(?, '" + ConstantsServerSide.SITE_CODE + "', ?, ?, ");
					sqlStr.append("TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), TO_NUMBER(?), TO_NUMBER(?), ?, ");
					if (publicHDate !=null && !"".equals(publicHDate)) {
						sqlStr.append(" TO_DATE('"+publicHDate+"','dd/mm/yyyy'), ");
					}
					sqlStr.append("?, ?)");
					if (UtilDBWeb.updateQueue(
							sqlStr.toString(),
							new String[] { eleaveID, staffID, leaveType,
								fromDate, toDate, appliedDate, appliedHour, remarks,
								userBean.getLoginID(), userBean.getLoginID() })) {
						insertApproval(userBean, "eleave.s", eleaveID, StaffDB.getDeptCode(staffID), staffID, "approve",leaveType);
						if (detailMap.size()>0) {
							Set s = detailMap.entrySet();
							Iterator it=s.iterator();
							while (it.hasNext()) {
								Map.Entry m =(Map.Entry)it.next();
								String detailsName=(String)m.getKey();
								String detailsValue=(String)m.getValue();
								Boolean b = insertDetails(userBean,detailsName,detailsValue,"",eleaveID);
							}
						}
					} else {
						return null;
					}
					sendEmail(eleaveID, staffID, NEW_STATUS, remarks);
					return eleaveID;
				} else {
					return null;
				}
			}
		}
	}

	public static boolean checkBLApplication(UserBean userBean,String fromDate) {

		ArrayList record = getELStaffInfo(userBean.getStaffID());
		if (record.size()>0) {
				ReportableListObject row = null;
				row = (ReportableListObject) record.get(0);
				String birthDate = row.getValue(6);
				SimpleDateFormat Format = new SimpleDateFormat("dd/MM");
				Calendar bdCalendar = Calendar.getInstance();
				Calendar ctCalendar = Calendar.getInstance();
				try{
					bdCalendar.setTime(Format.parse(birthDate));
					ctCalendar.setTime(Format.parse(fromDate));
				} catch(Exception e) {
					System.out.println(e);
				}

				if (ctCalendar.get(Calendar.MONTH)>=bdCalendar.get(Calendar.MONTH)) {

					if (ctCalendar.get(Calendar.MONTH)==bdCalendar.get(Calendar.MONTH)) {
						if (ctCalendar.get(Calendar.DAY_OF_MONTH)>=bdCalendar.get(Calendar.DAY_OF_MONTH)) {
							return true;
						} else {
							return false;
						}
					} else {
						return true;
					}
				} else {
					if (bdCalendar.get(Calendar.MONTH)==10 ||bdCalendar.get(Calendar.MONTH)==11) { //Nov or Dec
						if ((bdCalendar.get(Calendar.MONTH)==10)&&(bdCalendar.get(Calendar.DAY_OF_MONTH)>20)) {
							if (ctCalendar.get(Calendar.MONTH)==0 && ctCalendar.get(Calendar.DAY_OF_MONTH)<21) {
								return true;
							} else {
								return false;
							}
						} else if ((bdCalendar.get(Calendar.MONTH)==11)) {
							if (bdCalendar.get(Calendar.DAY_OF_MONTH)<21) {
								if (ctCalendar.get(Calendar.MONTH)==0 && ctCalendar.get(Calendar.DAY_OF_MONTH)<21) {
									return true;
								} else {
									return false;
								}
							} else {
								if (ctCalendar.get(Calendar.MONTH)<=1) {
									if (ctCalendar.get(Calendar.MONTH)==1) {
										return true;
									} else if (ctCalendar.get(Calendar.MONTH)==1 && ctCalendar.get(Calendar.DAY_OF_MONTH)<21) {
										return true;
									} else {
										return false;
									}
								} else {
									return false;
								}
							}
						}
					} else {
						return false;
					}
				}
				return false;
		} else {
			return false;
		}
	}

	public static ArrayList getELStaffInfo(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EL_DEPARTMENT_CODE, EL_DEPARTMENT_DESC, ");
		sqlStr.append(" EL_LASTNAME, EL_FIRSTNAME, EL_POSITION_CODE, EL_POSITION_DESC,TO_CHAR(EL_BIRTHDATE,'dd/mm'),EL_FTE, ");
		sqlStr.append(" TO_CHAR(EL_HIRE_DATE,'dd/mm/yyyy'),TO_CHAR(EL_TERMINATION_DATE,'dd/mm/yyyy'),EL_EMAIL ");
		sqlStr.append(" FROM EL_EMPLOYEE WHERE EL_STAFF_ID ='"+staffID+"' ");
		sqlStr.append(" AND EL_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString());

	}

	public static ArrayList getELStaffByDept(String deptCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EL_DEPARTMENT_CODE, EL_DEPARTMENT_DESC, ");
		sqlStr.append(" EL_STAFF_ID,EL_LASTNAME, EL_FIRSTNAME, EL_POSITION_CODE, EL_POSITION_DESC,TO_CHAR(EL_BIRTHDATE,'dd/mm'),EL_FTE, ");
		sqlStr.append(" TO_CHAR(EL_HIRE_DATE,'dd/mm/yyyy'),TO_CHAR(EL_TERMINATION_DATE,'dd/mm/yyyy'),EL_EMAIL ");
		sqlStr.append(" FROM EL_EMPLOYEE WHERE EL_DEPARTMENT_CODE ='"+deptCode+"' ");
		sqlStr.append(" AND EL_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString());

	}

	public static String  getELHireDate(String staffID) {
		ArrayList record = getELStaffInfo(staffID);
		String hireDate=null;
		if (record.size()>0) {
				ReportableListObject row = null;
				row = (ReportableListObject) record.get(0);
				hireDate = row.getValue(8);
		}

		return hireDate;

	}

	public static boolean checkAppliedDateForProbation(String siteCode,String staffID,String fromDate) {
		if (StaffDB.isInProbationForEL(siteCode,staffID)) {
			Date fromDateDate = DateTimeUtil.parseDate(fromDate);
			Date hireDate = DateTimeUtil.parseDate(ELeaveDB.getELHireDate(staffID));
			SimpleDateFormat Format = new SimpleDateFormat("dd/MM/yyyy");
			Calendar threeMonthCalendar = Calendar.getInstance();
			Calendar appliedMonthCalendar = Calendar.getInstance();
			appliedMonthCalendar.setTime(fromDateDate);
			threeMonthCalendar.setTime(hireDate);
			threeMonthCalendar.add(Calendar.MONTH,+3);
			if (appliedMonthCalendar.compareTo(threeMonthCalendar)<0) {
				return false;
			} else {
				return true;
			}
		}
		return true;
	}

	public static String  getELFTE(String staffID) {
		ArrayList record = getELStaffInfo(staffID);
		String FTE=null;
		if (record.size()>0) {
				ReportableListObject row = null;
				row = (ReportableListObject) record.get(0);
				FTE = row.getValue(7);
		}

		return FTE;
	}

	public static String  getELEmail(String staffID) {
		ArrayList record = getELStaffInfo(staffID);
		String email=null;
		if (record.size()>0) {
				ReportableListObject row = null;
				row = (ReportableListObject) record.get(0);
				email = row.getValue(10);
		}

		return email;

	}

	public static boolean update(
			UserBean userBean, String eleaveID, String appliedDate, String appliedHour,
			String eleaveStatus, String remarks) {
		return 	update(
				userBean,eleaveID,appliedDate,appliedHour,eleaveStatus,remarks,"");
	}

	public static boolean update(
			UserBean userBean, String eleaveID, String appliedDate, String appliedHour,
			String eleaveStatus, String remarks, String changeHour) {
		return 	update(
				userBean,eleaveID,appliedDate,appliedHour,eleaveStatus,remarks,"","");
	}

	public static boolean update(
			UserBean userBean, String eleaveID, String appliedDate, String appliedHour,
			String eleaveStatus, String remarks, String changeHour,String leaveType) {

		boolean verify = false;
		int approvalCount = 0;
		int totalapprovalCount = 0;

		String staffID = null, year = null;
		String balanceKeys[] = getBalanceKeys(eleaveID);  //get balance
		if (balanceKeys != null) {
			staffID = balanceKeys[0];
			year = balanceKeys[1];
		}

		// insert approval
		if (APPROVED_STATUS.equals(eleaveStatus)) {

			if (!isDoctor(staffID)) {
				totalapprovalCount = getTotalApprovalList(eleaveID).size();


			}

			verify = updateApproval(userBean, eleaveID);

			if (verify) {
				// get approval counter
				approvalCount = getApprovalList(eleaveID).size();

				if (isDoctor(staffID)) {
					if (approvalCount < 2) {
						// set status to pending
						eleaveStatus = "P";
					} else if (staffID != null && year != null) {
						// Subtract actual balance
						float balance[] = getBalance(staffID, year);
						float actualBalance = balance[0] - Float.parseFloat(appliedDate);
						float pendingBalance = balance[1];
						updateBalance(userBean, staffID, year,
								Float.toString(actualBalance), Float.toString(pendingBalance));
					}
				} else {
					if (approvalCount == totalapprovalCount) {
						// set status to pending
						eleaveStatus = "P";
					} else {
						eleaveStatus = "WN";
					}
						// insert approval
						//insertApproval(userBean, eleaveID, n ull, staffID, "verify");
					//} else if (approvalCount == 2) {
						// set status to pending
						//eleaveStatus = "V";

						// insert approval
						//insertApproval(userBean, eleaveID, null, staffID, "confirm");
					//} else if (approvalCount > 2) {
						// set status to pending
					//	eleaveStatus = "H";
					//}
				}
			}
		} else if ("R".equals(eleaveStatus)) { //reject
			leaveType = getLeaveTypeByEleaveID(eleaveID);
			String leaveAccrualType = leaveType.substring(0,1)+"A";
			if (balanceKeys != null) {
				float appliedDateforBal = getAppliedDate(eleaveID);
				if (("AL".equals(leaveType)|| "SL".equals(leaveType)|| "BL".equals(leaveType))) { //revert back those with balance
					if (appliedDateforBal > 0) {
						float balance[] = getBalance(staffID, year,isDoctor(staffID)?"":leaveAccrualType);
						float actualBalance = balance[0];
						float pendingBalance = balance[1] + appliedDateforBal;
						if (isDoctor(staffID)) {
						updateBalance(userBean, staffID, year, Float.toString(actualBalance), Float.toString(pendingBalance));
						} else {
							if ("AL".equals(leaveType)|| "SL".equals(leaveType)|| "BL".equals(leaveType)) {
								updateBalance(userBean, staffID, year, Float.toString(actualBalance), Float.toString(pendingBalance),leaveAccrualType);
							}
						}
						verify = true; //verify balance updated
					 }
				} else {
					verify = true; //those that dont have balance continue to update to reject status
				}
			}
		} else {
			verify = true;
		}

		if (verify) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE EL_ELEAVE ");
			sqlStr.append("SET    EL_LEAVE_STATUS = ?, EL_RESPONSE_REMARKS = ?, ");
			if (appliedDate != null && appliedDate.length() > 0) {
				sqlStr.append("       EL_APPLIED_DAYS = '");
				sqlStr.append(appliedDate);
				sqlStr.append("', ");
			}
			if (appliedHour != null && appliedHour.length() > 0) {
				sqlStr.append("       EL_APPLIED_HOURS = '");
				sqlStr.append(appliedHour);
				sqlStr.append("', ");
			}
			if (leaveType != null && leaveType.length() > 0) {
				sqlStr.append("       EL_LEAVE_TYPE = '");
				sqlStr.append(leaveType);
				sqlStr.append("', ");
			}
			sqlStr.append("       EL_MODIFIED_DATE = SYSDATE, EL_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  EL_ELEAVE_ID = ? AND EL_LEAVE_STATUS IN ('O', 'P', 'V','WN') AND EL_ENABLED = 1");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { eleaveStatus, remarks, userBean.getLoginID(), eleaveID} )) {

				if (isDoctor(staffID)) {
					// Update pending balance if applied date was changed
					float originalAppliedDate = getAppliedDate(eleaveID);
					if (balanceKeys != null && originalAppliedDate > 0) {
						float balance[] = getBalance(staffID, year);
						float actualBalance = balance[0];
						float pendingBalance = balance[1] + originalAppliedDate; // Restore to original
						if (!REJECTED_STATUS.equals(eleaveStatus)) {
							// Subtract updated applied date
							pendingBalance -= Float.parseFloat(appliedDate);
						}
						updateBalance(userBean, staffID, year,
								Float.toString(actualBalance), Float.toString(pendingBalance));
					}
				}
				// send email notify
				sendEmail(eleaveID, userBean.getStaffID(), eleaveStatus, remarks,(changeHour==null||changeHour=="")?"":changeHour);
				return true;
			}
		}
		return false;
	}

	public static String delete(UserBean userBean, String eleaveID) {
		return delete(userBean, eleaveID, null);
	}

	public static String delete(UserBean userBean, String eleaveID, String responseRemarks) {
		String leaveStatus = null;
		if ("CC".equals(responseRemarks)) {
			leaveStatus = "CC";
		} else {
			leaveStatus="O";
		}
		boolean verify = updateApprovalToZero(userBean, eleaveID);

		int approvalCount = getApprovalList(eleaveID).size();
		int totalapprovalCount = getTotalApprovalList(eleaveID).size();

		if (approvalCount>0) {
			return "2";

		} else {
			if (UtilDBWeb.updateQueue(
					sqlStr_cancelLeave,
					new String[] { userBean.getLoginID(), eleaveID,leaveStatus } ) ) {

				// Restore pending balance
				String balanceKeys[] = getBalanceKeys(eleaveID);
				String leaveType = getLeaveTypeByEleaveID(eleaveID);
				String leaveAccrualType = leaveType.substring(0,1)+"A";
				if (balanceKeys != null) {
					String staffID = balanceKeys[0];
					String year = balanceKeys[1];
					float appliedDate = getAppliedDate(eleaveID);
					if (appliedDate > 0) {
						float balance[] = getBalance(staffID, year,isDoctor(staffID)?leaveType:leaveAccrualType);
						float actualBalance = balance[0];
						float pendingBalance = balance[1] + appliedDate;
						if (isDoctor(staffID)) {
						updateBalance(userBean, staffID, year, Float.toString(actualBalance), Float.toString(pendingBalance));
						} else {
						updateBalance(userBean, staffID, year, Float.toString(actualBalance), Float.toString(pendingBalance),leaveAccrualType);
						}
					}
				}
				if ("CC".equals(responseRemarks)) {
					sendEmail(eleaveID, userBean.getStaffID(), "CC", "");
				}
				return "1";
			} else {
				return "0";
			}
		}

	}

	public static ArrayList get(String eleaveID) {
		return UtilDBWeb.getReportableList(sqlStr_listLeave, new String[] { eleaveID });
	}

	public static String  getELeaveProcessStatus(String eleaveID) {
		ArrayList record = ELeaveDB.get(eleaveID);
		if (record.size() > 0) {
			ReportableListObject row = null;
			row = (ReportableListObject) record.get(0);
			return row.getValue(12);
		} else {
			return "";
		}
	}

	public static String getLeaveTypeByEleaveID(String eleaveID) {
		ArrayList record =  UtilDBWeb.getReportableList(sqlStr_listAllLeave, new String[] { eleaveID });
		String leaveType = "";
		if (record.size() > 0) {
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(0);
				leaveType = row.getValue(3);
			}
			return leaveType;
		}
		return null;
	}

	public static ArrayList getDisabledLeave(String eleaveID) {
		ArrayList record =  UtilDBWeb.getReportableList(sqlStr_listAllLeave, new String[] { eleaveID });
		String leaveType = "";
		if (record.size() > 0) {
			return record;
		}
		return null;
	}

	private static void insertApproval(UserBean userBean, String moduleID, String eleaveID, String deptCode, String staffID, String approveType,String leaveType) {
		// insert approval
		ArrayList record = ApprovalUserDB.getApprovalUserList(moduleID, approveType, null, deptCode, staffID);
		if (record.size() > 0) {
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				addApproval(userBean, row.getValue(0), eleaveID);
			}
		}
		if (leaveType!=null && !"".equals(leaveType)) {
			if ("SL".equals(leaveType)) {
				ArrayList recordSick = ApprovalUserDB.getApprovalUserList(moduleID, "sick", null, "", staffID);
				if (recordSick.size()>0) {
					ReportableListObject row = null;
					for (int i = 0; i < recordSick.size(); i++) {
						row = (ReportableListObject) recordSick.get(i);
						addApproval(userBean, row.getValue(0), eleaveID);
				    }
			     }
			 }
		}
	}

	private static void insertApproval(UserBean userBean, String moduleID, String eleaveID, String deptCode, String staffID, String approveType) {
		insertApproval(userBean,moduleID,eleaveID,deptCode,staffID,approveType,"");
	}

	private static boolean checkDetailsExist(String detailsName,String leaveID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM ");
		sqlStr.append("  EL_DETAILS_VALUE ");
		sqlStr.append("	WHERE  EL_LEAVE_ID = '"+leaveID+"'");
		sqlStr.append(" AND EL_DETAILS_TYPE = '"+detailsName+"'");
		sqlStr.append("	AND    EL_ENABLED = 1");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size()>0) {
			return true;
		} else {
			return false;
		}
	}

	public static ArrayList getDetailsByID(String leaveID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT EL_DETAILS_TYPE, EL_DETAILS_VALUE, EL_DETAILS_DATATYPE ");
		sqlStr.append( "FROM EL_DETAILS_VALUE ");
		sqlStr.append(" WHERE EL_LEAVE_ID = '"+leaveID+"'");
		sqlStr.append(" AND EL_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private static boolean insertDetails(UserBean userBean,String detailsName, String detailsValue,String detailsDataType,String leaveID) {
		String detailsID = getNextDetailID();
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO EL_DETAILS_VALUE (");
		sqlStr.append("EL_SITE_CODE,EL_LEAVE_ID,EL_DETAILS_ID,EL_DETAILS_TYPE,EL_DETAILS_VALUE,EL_DETAILS_DATATYPE, ");
		sqlStr.append("EL_CREATED_USER,EL_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?,?, ?, ?, ");
		sqlStr.append("?, ?,?,? ) ");

		return UtilDBWeb.updateQueue(sqlStr.toString( ),
				new String[] { ConstantsServerSide.SITE_CODE,leaveID,detailsID, detailsName,
				detailsValue, detailsDataType,
				userBean.getLoginID(), userBean.getLoginID() });
	}

	private static boolean updateDetails(UserBean userBean,String detailsValue,String detailsDataType,String leaveID) {
		String detailsID = getNextDetailID();
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE EL_DETAILS_VALUE ");
		sqlStr.append("SET    EL_DETAILS_VALUE = ?, ");
		sqlStr.append("		  EL_DETAILS_DATATYPE = ?, ");
		sqlStr.append("       EL_MODIFIED_DATE = SYSDATE, EL_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EL_LEAVE_ID = ? ");
		sqlStr.append("AND    EL_DETAILS_TYPE = ? ");
		sqlStr.append("AND    EL_ENABLED = 1 ");

		return UtilDBWeb.updateQueue(sqlStr.toString( ),
				new String[] { detailsValue,detailsDataType, userBean.getLoginID(),
								leaveID, detailsDataType,
				userBean.getLoginID(), userBean.getLoginID() });
	}


	public static boolean checkValidApprove(String applyUser) {
		ArrayList record = UtilDBWeb.getReportableList(sqlStr_chkValidApproval,new String[] {applyUser} ) ;
		if (record.size() > 0) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean checkValidApproveEl(String eleaveID, String approveUser) {
		return checkValidApproveEl(eleaveID, approveUser, "approve");
	}

	public static boolean checkValidApproveEl(String eleaveID, String approveUser, String category) {
		ArrayList record = UtilDBWeb.getReportableList(sqlStr_chkValidApprovalEl,new String[] { eleaveID, ConstantsServerSide.SITE_CODE, approveUser, category} ) ;
		if (record.size() > 0) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean checkExistApproveEl(String eleaveID, String approveUser) {
		ArrayList record = UtilDBWeb.getReportableList(sqlStr_chkExistApprovalEl,new String[] { eleaveID, ConstantsServerSide.SITE_CODE, approveUser,"approve"} ) ;
		if (record.size() > 0) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean checkExistApproveEl(String eleaveID, String approveUser,String category) {
		ArrayList record = UtilDBWeb.getReportableList(sqlStr_chkExistApprovalEl,new String[] { eleaveID, ConstantsServerSide.SITE_CODE, approveUser,category} ) ;
		if (record.size() > 0) {
			return true;
		} else {
			return false;
		}
	}

	public static Integer getSumofDayOrHrByleaveTypeAndDetails(String leaveType,String staffID,String timeType,
			String detailsType,String detailsValue) {
		StringBuffer sqlStr = new StringBuffer();
		ArrayList record = new ArrayList();

		if ("hour".equals(timeType)) {
			sqlStr.append(" select decode(sum(e.el_applied_hours),null,0,sum(e.el_applied_hours))  from ");
		}
		if ("day".equals(timeType)) {
			sqlStr.append(" select decode(sum(e.EL_APPLIED_DAYS),null,0,sum(e.EL_APPLIED_DAYS)) from ");
		}
		sqlStr.append(" EL_ELEAVE e,EL_DETAILS_VALUE v ");
		sqlStr.append(" WHERE e.el_leave_type = '"+leaveType+"'");
		sqlStr.append(" and v.el_details_type='"+detailsType+"'");
		sqlStr.append(" and v.EL_DETAILS_VALUE='"+detailsValue+"'");
		sqlStr.append(" and E.El_Staff_Id = '"+staffID+"'");
		sqlStr.append(" and v.el_leave_id = e.el_eleave_id ");
		sqlStr.append(" and e.EL_ENABLED = 1");

		record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return Integer.parseInt(row.getValue(0));
		} else {
			return -1;
		}

	}
	public static Integer getSumofDayOrHrByDate(String leaveType,String timeType,String fieldName,String fieldValue) {
		StringBuffer sqlStr = new StringBuffer();
		ArrayList record = new ArrayList();

		if ("hour".equals(timeType)) {
			sqlStr.append(" select decode(sum(e.el_applied_hours),null,0,sum(e.el_applied_hours))  from ");
		}
		if ("day".equals(timeType)) {
			sqlStr.append(" select decode(sum(e.EL_APPLIED_DAYS),null,0,sum(e.EL_APPLIED_DAYS)) from ");
		}
		sqlStr.append(" EL_ELEAVE e");
		sqlStr.append(" WHERE e.el_leave_type = '"+leaveType+"'");
		sqlStr.append(" and e."+fieldName+"=to_date('"+fieldValue+"','dd/mm/yyyy') ");
		sqlStr.append(" and e.EL_ENABLED = 1");

		record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return Integer.parseInt(row.getValue(0));
		} else {
			return -1;
		}

	}

	public static ArrayList getHistory(String staffID, String fromDate, String toDate) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT L.EL_LEAVE_ID, L.EL_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("   TO_CHAR(L.EL_FROM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("   TO_CHAR(L.EL_TO_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("   (SELECT DISTINCT EL_LEAVE_TYPE_DESC FROM EL_EMPLOYEE_ELEAVE_TYPE WHERE EL_LEAVE_TYPE = L.EL_LEAVE_TYPE) as EL_LEAVE_TYPE, ");
		sqlStr.append("TO_CHAR(L.EL_APPLIED_DAYS,'90.99'), TO_CHAR(L.EL_APPLIED_HOURS,'90.99'),L.EL_REMARKS ");
		sqlStr.append("   FROM   EL_ELEAVE_HISTORY L, CO_STAFFS S ");
		sqlStr.append("WHERE  L.EL_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("	AND    L.EL_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("	AND    L.EL_ENABLED = 1 ");
		sqlStr.append("	AND    L.EL_STAFF_ID = '"+staffID+"' ");
		if (fromDate!= null && !"".equals(fromDate)) {
			sqlStr.append(" AND	   L.EL_FROM_DATE >= TO_DATE('"+fromDate+"','dd/mm/yyyy') ");
		}
		if (toDate!= null&& !"".equals(fromDate)) {
			sqlStr.append(" AND	   L.EL_TO_DATE <= TO_DATE('"+toDate+"','dd/mm/yyyy') ");
		}
		sqlStr.append("GROUP BY L.EL_LEAVE_ID, L.EL_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("L.EL_FROM_DATE,L.EL_TO_DATE, ");
		sqlStr.append("    L.EL_APPLIED_DAYS, L.EL_APPLIED_HOURS, ");
		sqlStr.append("	         L.EL_CREATED_USER, L.EL_CREATED_DATE, ");
		sqlStr.append("	         L.EL_MODIFIED_USER, L.EL_MODIFIED_DATE,L.EL_LEAVE_TYPE,L.EL_REMARKS");
		sqlStr.append(" ORDER BY EL_FROM_DATE DESC ");


		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getAsAtDate() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select to_char(EL_ASAT_DATE,'dd/mm/yyyy') AS FULL_ASAT_DATE, ");
		sqlStr.append(" TO_CHAR(el_asat_date,'mm')  AS asat_month ");
		sqlStr.append(" from el_eleave_balancedate order by el_baldate_id desc");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getAsAtDateToSysdateUsage(String staffID,String leaveType,String fromMonth) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT STAFFL.STAFFID, SUM(STAFFL.HR)AS USED_HOURS FROM ");
		sqlStr.append(" (SELECT L.EL_ELEAVE_ID, L.EL_STAFF_ID STAFFID, S.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_FROM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(L.EL_TO_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       L.EL_APPLIED_DAYS, L.EL_APPLIED_HOURS HR, L.EL_LEAVE_STATUS, ");
		sqlStr.append("       L.EL_CREATED_USER, S1.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_CREATED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       L.EL_MODIFIED_USER, S2.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   EL_ELEAVE L, CO_STAFFS S, ");
		sqlStr.append("       CO_USERS U1, CO_STAFFS S1, ");
		sqlStr.append("       CO_USERS U2, CO_STAFFS S2 ");
		sqlStr.append("WHERE  L.EL_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    L.EL_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("and    L.EL_LEAVE_STATUS <> 'R'");
		sqlStr.append("AND    L.EL_ENABLED = 1 ");
		sqlStr.append("AND    L.EL_CREATED_USER = U1.CO_USERNAME ");
		sqlStr.append("AND    U1.CO_STAFF_ID = S1.CO_STAFF_ID ");
		sqlStr.append("AND    L.EL_MODIFIED_USER = U2.CO_USERNAME ");
		sqlStr.append("AND    U2.CO_STAFF_ID = S2.CO_STAFF_ID ");
		sqlStr.append("AND   L.EL_LEAVE_TYPE = '"+leaveType+"' ");
		sqlStr.append("AND   L.EL_STAFF_ID = '");
		sqlStr.append(staffID+"'  ");
		sqlStr.append("	AND L.EL_CREATED_DATE > TO_DATE('20/"+fromMonth+"/2011','dd/mm/yyyy') ");
		sqlStr.append(" ) STAFFL GROUP BY STAFFL.STAFFID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getListwithSpecificDateAndStaff(String fromDate,String toDate,String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(EL_FROM_DATE, 'dd/MM/YYYY'),TO_CHAR(EL_TO_DATE, 'dd/MM/YYYY'),");
		sqlStr.append(" TO_CHAR(EL_APPLIED_DAYS,'90.99'), TO_CHAR(EL_APPLIED_HOURS,'990.99'),EL_LEAVE_TYPE ");
		sqlStr.append(" FROM EL_ELEAVE ");
		sqlStr.append(" WHERE EL_STAFF_ID='"+staffID+"' ");
		sqlStr.append(" And (El_From_Date Between To_Date('"+fromDate+"','dd/mm/yyyy') And To_Date('"+toDate+"','dd/mm/yyyy')Or ");
		sqlStr.append(" EL_TO_DATE Between To_Date('"+fromDate+"','dd/mm/yyyy') And To_Date('"+toDate+"','dd/mm/yyyy') ");
		sqlStr.append(" OR  (To_Date('"+fromDate+"','dd/mm/yyyy')>El_From_Date AND To_Date('"+toDate+"','dd/mm/yyyy')<EL_TO_DATE))");
		sqlStr.append(" AND EL_ENABLED=1 AND EL_LEAVE_STATUS NOT IN('R') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getList(UserBean userBean,String Type) {
		// fetch leave
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.EL_ELEAVE_ID, L.EL_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_FROM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(L.EL_TO_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(L.EL_APPLIED_DAYS,'90.99'), TO_CHAR(L.EL_APPLIED_HOURS,'990.99'), L.EL_LEAVE_STATUS, ");
		sqlStr.append("       L.EL_CREATED_USER, S1.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_CREATED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       L.EL_MODIFIED_USER, S2.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_MODIFIED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("  	  (SELECT DISTINCT EL_LEAVE_TYPE_DESC FROM EL_EMPLOYEE_ELEAVE_TYPE WHERE EL_LEAVE_TYPE = L.EL_LEAVE_TYPE) as EL_LEAVE_TYPE,L.EL_LEAVE_TYPE as EL_LEAVE_TYPE_CODE ");
		sqlStr.append("FROM   EL_ELEAVE L, CO_STAFFS S, ");
		sqlStr.append("       CO_USERS U1, CO_STAFFS S1, ");
		sqlStr.append("       CO_USERS U2, CO_STAFFS S2 ");
		sqlStr.append("WHERE  L.EL_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    L.EL_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    L.EL_ENABLED = 1 ");
		sqlStr.append("AND    L.EL_CREATED_USER = U1.CO_USERNAME ");
		sqlStr.append("AND    U1.CO_STAFF_ID = S1.CO_STAFF_ID ");
		sqlStr.append("AND    L.EL_MODIFIED_USER = U2.CO_USERNAME ");
		sqlStr.append("AND    U2.CO_STAFF_ID = S2.CO_STAFF_ID ");
		if ("HR".equals(Type)) {
			sqlStr.append("AND substr(EL_STAFF_ID,1,2) not in  'DR'	");
		} else {
			sqlStr.append("AND substr(EL_STAFF_ID,1,2) not in  'DR'	");
			sqlStr.append("AND   (L.EL_STAFF_ID = '");
			sqlStr.append(userBean.getStaffID());
			sqlStr.append("' OR L.EL_ELEAVE_ID IN (SELECT EL_ELEAVE_ID FROM EL_ELEAVE_APPROVED WHERE EL_APPROVAL_STAFF_ID = '");
			sqlStr.append(userBean.getStaffID());
			sqlStr.append("' )) ");
		}
		sqlStr.append("GROUP BY L.EL_ELEAVE_ID, L.EL_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("         L.EL_FROM_DATE,L.EL_TO_DATE, ");
		sqlStr.append("         L.EL_APPLIED_DAYS, L.EL_APPLIED_HOURS, L.EL_LEAVE_STATUS, ");
		sqlStr.append("         L.EL_CREATED_USER, S1.CO_STAFFNAME, L.EL_CREATED_DATE, ");
		sqlStr.append("         L.EL_MODIFIED_USER, S2.CO_STAFFNAME, L.EL_MODIFIED_DATE,L.EL_LEAVE_TYPE ");
		sqlStr.append("ORDER BY EL_FROM_DATE DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getList(UserBean userBean) {
		// fetch leave
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.EL_ELEAVE_ID, L.EL_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_FROM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(L.EL_TO_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       L.EL_APPLIED_DAYS, L.EL_APPLIED_HOURS, L.EL_LEAVE_STATUS, ");
		sqlStr.append("       L.EL_CREATED_USER, S1.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_CREATED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       L.EL_MODIFIED_USER, S2.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   EL_ELEAVE L, CO_STAFFS S, ");
		sqlStr.append("       CO_USERS U1, CO_STAFFS S1, ");
		sqlStr.append("       CO_USERS U2, CO_STAFFS S2 ");
		sqlStr.append("WHERE  L.EL_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    L.EL_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    L.EL_ENABLED = 1 ");
		sqlStr.append("AND    L.EL_CREATED_USER = U1.CO_USERNAME ");
		sqlStr.append("AND    U1.CO_STAFF_ID = S1.CO_STAFF_ID ");
		sqlStr.append("AND    L.EL_MODIFIED_USER = U2.CO_USERNAME ");
		sqlStr.append("AND    U2.CO_STAFF_ID = S2.CO_STAFF_ID ");
		sqlStr.append("AND   (L.EL_STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' OR L.EL_ELEAVE_ID IN (SELECT EL_ELEAVE_ID FROM EL_ELEAVE_APPROVED WHERE EL_APPROVAL_STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' )) ");
		sqlStr.append("GROUP BY L.EL_ELEAVE_ID, L.EL_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("         L.EL_FROM_DATE,L.EL_TO_DATE, ");
		sqlStr.append("         L.EL_APPLIED_DAYS, L.EL_APPLIED_HOURS, L.EL_LEAVE_STATUS, ");
		sqlStr.append("         L.EL_CREATED_USER, S1.CO_STAFFNAME, L.EL_CREATED_DATE, ");
		sqlStr.append("         L.EL_MODIFIED_USER, S2.CO_STAFFNAME, L.EL_MODIFIED_DATE ");
		sqlStr.append("ORDER BY EL_FROM_DATE DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean isExist(UserBean userBean, String fromDate, String toDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   EL_ELEAVE ");
		sqlStr.append("WHERE  EL_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    EL_STAFF_ID = ? ");
		sqlStr.append("AND    EL_FROM_DATE <= TO_DATE(?, 'dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    EL_TO_DATE >= TO_DATE(?, 'dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    EL_LEAVE_STATUS != 'R' ");
		sqlStr.append("AND    EL_ENABLED = 1 ");

		return UtilDBWeb.isExist(sqlStr.toString(),
				new String[] { userBean.getStaffID(), fromDate, toDate });
	}

	public static String addApproval(UserBean userBean, String eleaveID) {
		return addApproval(userBean, userBean.getStaffID(), eleaveID);
	}

	public static String addApproval(UserBean userBean, String staffID, String eleaveID) {
		String eleaveApprovalID = getNextELeaveApprovalID(eleaveID);

		// insert eleave record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertLeaveApproval,
				new String[] { eleaveID, eleaveApprovalID, staffID,
						userBean.getLoginID(), userBean.getLoginID() })) {

			return eleaveApprovalID;
		} else {
			return null;
		}
	}

	public static boolean updateApproval(UserBean userBean, String eleaveID) {
		// update eleave record
		return UtilDBWeb.updateQueue(
				sqlStr_updateLeaveApproval,
				new String[] { userBean.getLoginID(),
						eleaveID, userBean.getStaffID() });
	}

	public static boolean updateApprovalToZero(UserBean userBean, String eleaveID) {
		// update eleave record
		return UtilDBWeb.updateQueue(
				sqlStr_updateLeaveApprovalToZero,
				new String[] { userBean.getLoginID(),
						eleaveID, userBean.getStaffID() });
	}


	public static ArrayList getApprovalList(String eleaveID) {
		return UtilDBWeb.getReportableList(sqlStr_listLeaveApproval, new String[] { ConstantsServerSide.SITE_CODE, eleaveID });
	}

	public static ArrayList getTotalApprovalList(String eleaveID) {
		return UtilDBWeb.getReportableList(sqlStr_listTotalapprovedLeaveApproval, new String[] { ConstantsServerSide.SITE_CODE, eleaveID });
	}

	public static ArrayList getBalanceList(String staffID) {
		return getBalanceList(staffID, "9999","");
	}

	public static ArrayList getBalanceList(String staffID, String year) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EL_LEAVE_TYPE, EL_ACTUAL_BALANCE, EL_PENDING_BALANCE ");
		sqlStr.append("FROM   EL_ELEAVE_BALANCE ");
		sqlStr.append("WHERE  EL_STAFF_ID = ? ");
		sqlStr.append("AND    EL_YEAR = ? ");
		sqlStr.append("AND 	  EL_LEAVE_TYPE = 'AL' ");
		sqlStr.append("AND    EL_ENABLED = 1 ");
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID, year });
	}

		public static ArrayList getBalanceList(String staffID, String year,String leaveType) {
			StringBuffer sqlStr = new StringBuffer();
			leaveType = leaveType.substring(0,1)+"A";

			sqlStr.append("SELECT EL_LEAVE_TYPE, EL_ACTUAL_BALANCE, EL_PENDING_BALANCE,TO_CHAR(EL_MODIFIED_DATE,'dd/mm/yyyy') ");
			sqlStr.append("FROM   EL_ELEAVE_BALANCE ");
			sqlStr.append("WHERE  EL_STAFF_ID = ? ");
			sqlStr.append("AND    EL_YEAR = ? ");
			sqlStr.append("AND 	  EL_LEAVE_TYPE = '"+leaveType+"' ");
			sqlStr.append("AND    EL_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID, year });
	}

	public static float[] getBalance(String staffID, String year) {
		ArrayList record = getBalanceList(staffID, year);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return new float[] { Float.parseFloat(row.getValue(1)), Float.parseFloat(row.getValue(2)) };
		} else {
			return null;
		}
	}

	public static float[] getBalance(String staffID, String year,String leaveType) {
		ArrayList record = new ArrayList();
		if (leaveType == "" || leaveType == null) {
			record = getBalanceList(staffID, year);
		} else {
			record = getBalanceList(staffID, year,leaveType);
		}
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return new float[] { Float.parseFloat(row.getValue(1)), Float.parseFloat(row.getValue(2)) };
		} else {
			return null;
		}
	}

	public static boolean isBalanceExist(String staffID, String year) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   EL_ELEAVE_BALANCE ");
		sqlStr.append("WHERE  EL_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    EL_YEAR = ? ");
		sqlStr.append("AND    EL_STAFF_ID = ? ");

		return UtilDBWeb.isExist(sqlStr.toString(),
				new String[] { year, staffID });

	}

	public static boolean isBalanceExist(String staffID, String year,String leaveType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   EL_ELEAVE_BALANCE ");
		sqlStr.append("WHERE  EL_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    EL_YEAR = ? ");
		sqlStr.append("AND    EL_STAFF_ID = ? ");
		sqlStr.append("AND    EL_LEAVE_TYPE = ? ");

		return UtilDBWeb.isExist(sqlStr.toString(),
				new String[] { year, staffID,leaveType });

	}

	public static boolean addBalance(UserBean userBean, String year, String actualBalance, String pendingBalance) {
		return addBalance(userBean, userBean.getStaffID(), year, actualBalance, pendingBalance);
	}

	public static boolean addBalance(UserBean userBean, String staffID, String year, String actualBalance, String pendingBalance) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EL_ELEAVE_BALANCE (");
		sqlStr.append("EL_SITE_CODE, EL_YEAR, EL_STAFF_ID, ");
		sqlStr.append("EL_ACTUAL_BALANCE, EL_PENDING_BALANCE, ");
		sqlStr.append("EL_CREATED_USER, EL_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, TO_NUMBER(?), ?, ");
		sqlStr.append(" TO_NUMBER(?), TO_NUMBER(?), ?, ?) ");

		return UtilDBWeb.updateQueue(sqlStr.toString( ),
				new String[] { ConstantsServerSide.SITE_CODE, year, staffID,
				actualBalance, pendingBalance,
				userBean.getLoginID(), userBean.getLoginID() });
	}

	public static boolean addBalance(String staffId) {
		return addBalance(null, staffId);
	}

	public static boolean addBalance(String siteCode, String staffId) {
		if (siteCode == null) {
			siteCode = ConstantsServerSide.SITE_CODE;
		}
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EL_ELEAVE_BALANCE (");
		sqlStr.append("EL_SITE_CODE, EL_YEAR, EL_STAFF_ID, ");
		sqlStr.append("EL_ACTUAL_BALANCE, EL_PENDING_BALANCE) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, TO_CHAR(SYSDATE,'YYYY'), ?, ");
		sqlStr.append(" TO_NUMBER(?), TO_NUMBER(?)) ");

		String initBalance = "20";

		return UtilDBWeb.updateQueue(sqlStr.toString(),
				new String[] { siteCode, staffId,
				initBalance, initBalance });
	}

	public static boolean updateBalance(UserBean userBean, String staffID, String year, String actualBalance, String pendingBalance) {
		ArrayList record = getBalanceList(staffID, year);
		if (record.size() > 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE EL_ELEAVE_BALANCE ");
			sqlStr.append("SET    EL_ACTUAL_BALANCE = ?, EL_PENDING_BALANCE = ?, ");
			sqlStr.append("       EL_MODIFIED_DATE = SYSDATE, EL_MODIFIED_USER = ? ");
			sqlStr.append("WHERE EL_STAFF_ID = ? ");
			sqlStr.append("AND   EL_YEAR = ? ");

			return UtilDBWeb.updateQueue(sqlStr.toString(),
					new String[] {actualBalance, pendingBalance,userBean.getLoginID(),
					staffID,  year });
		} else {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("INSERT INTO EL_ELEAVE_BALANCE (");
			sqlStr.append("EL_SITE_CODE, EL_YEAR, EL_STAFF_ID, ");
			sqlStr.append("EL_ACTUAL_BALANCE, EL_PENDING_BALANCE, ");
			sqlStr.append("EL_CREATED_USER, EL_MODIFIED_USER) ");
			sqlStr.append("VALUES ");
			sqlStr.append("(?, TO_NUMBER(?), ?, ");
			sqlStr.append(" TO_NUMBER(?), TO_NUMBER(?), ?, ?) ");

			return UtilDBWeb.updateQueue(sqlStr.toString(),
					new String[] { ConstantsServerSide.SITE_CODE, year, staffID,
					actualBalance, pendingBalance,
					userBean.getLoginID(), userBean.getLoginID() });
		}
	}

	public static boolean updateBalance(UserBean userBean, String staffID, String year, String actualBalance, String pendingBalance,String leaveType) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE EL_ELEAVE_BALANCE ");
			sqlStr.append("SET    EL_ACTUAL_BALANCE = ?, EL_PENDING_BALANCE = ?, ");
			sqlStr.append("       EL_MODIFIED_DATE = SYSDATE, EL_MODIFIED_USER = ? ");
			sqlStr.append("WHERE EL_STAFF_ID = ? ");
			sqlStr.append("AND   EL_YEAR = ? ");
			sqlStr.append("AND   EL_LEAVE_TYPE = ? ");

			return UtilDBWeb.updateQueue(sqlStr.toString(),
					new String[] {actualBalance, pendingBalance,userBean.getLoginID(),
					staffID,  year,leaveType });
	}

	public static String[] getBalanceKeys(String eleaveID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EL_STAFF_ID, TO_CHAR(EL_FROM_DATE, 'YYYY') ");
		sqlStr.append("FROM   EL_ELEAVE ");
		sqlStr.append("WHERE  EL_ELEAVE_ID = ? ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(),
				new String[] {eleaveID });
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			if (isDoctor(row.getValue(0))) {
				return new String[] { row.getValue(0), row.getValue(1)};
			} else {
				return new String[] { row.getValue(0), "9999"};
			}
		} else {
			return null;
		}
	}

	public static float getAppliedDate(String eleaveID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EL_STAFF_ID, EL_APPLIED_DAYS, EL_APPLIED_HOURS ");
		sqlStr.append("FROM   EL_ELEAVE ");
		sqlStr.append("WHERE  EL_ELEAVE_ID = ? ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {eleaveID });
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			if (isDoctor(row.getValue(0))) {
				return Float.parseFloat(row.getValue(1));
			} else {
				return Float.parseFloat(row.getValue(2));
			}
		} else {
			return 0;
		}
	}

	public static ArrayList getInfoList(String staffID, String staffName, String startDateStr, String endDateStr,
			String interval, String[] filterStatus, String deptCode) {
		Date startDate, endDate;
		try {
			startDate = DateTimeUtil.parseDate(startDateStr);
			endDate = DateTimeUtil.parseDate(endDateStr);
		} catch (Exception e) {
			return null;
		}
		Calendar startCalendar = Calendar.getInstance();
		Calendar endCalendar = Calendar.getInstance();
		startCalendar.setTime(startDate);
		endCalendar.setTime(endDate);

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.CO_STAFFNAME, ");
		if ("year".equals(interval)) {
			sqlStr.append("TO_CHAR(E.EL_FROM_DATE,'YYYY'), 1, ");
		} else if ("month".equals(interval)) {
			sqlStr.append("TO_CHAR(E.EL_FROM_DATE,'YYYY'), TO_CHAR(E.EL_TO_DATE,'MM'), ");
		} else if ("day".equals(interval)) {
			sqlStr.append("TO_CHAR(E.EL_FROM_DATE,'DD/MM/YYYY'), TO_CHAR(E.EL_TO_DATE,'DD/MM/YYYY'), ");
		}
		sqlStr.append(" SUM(E.EL_APPLIED_DAYS), S.CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM EL_ELEAVE E, CO_STAFFS S ");
		sqlStr.append("WHERE E.EL_STAFF_ID = S.CO_STAFF_ID ");
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND   E.EL_STAFF_ID = '");
			sqlStr.append(staffID);
			sqlStr.append("' ");
		}
		if (staffName != null && staffName.length() > 0) {
			sqlStr.append("AND   UPPER(S.CO_STAFFNAME) LIKE '%");
			sqlStr.append(staffName.toUpperCase());
			sqlStr.append("%' ");
		}
		sqlStr.append("AND   E.EL_FROM_DATE ");
		sqlStr.append(" BETWEEN TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append(" AND TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND E.EL_ENABLED = 1 ");
		if (deptCode != null && !"".equals(deptCode)) {
			sqlStr.append("AND S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode.replace("'", ""));
			sqlStr.append("' ");
		}
		// Filter status
		sqlStr.append("AND E.EL_LEAVE_STATUS IN ( ");
		for (int i = 0; i < filterStatus.length; i++) {
			if (filterStatus[i] != null) {
				sqlStr.append("'");
				sqlStr.append(filterStatus[i].replace("'", ""));
				sqlStr.append("'");
			} else {
				sqlStr.append("null");
			}
			if (i < filterStatus.length - 1) {
				sqlStr.append(",");
			}
		}
		sqlStr.append(") ");

		if ("year".equals(interval)) {
			sqlStr.append("GROUP BY S.CO_STAFFNAME , S.CO_DEPARTMENT_DESC, TO_CHAR(E.EL_FROM_DATE,'YYYY') ");
			sqlStr.append("ORDER BY S.CO_STAFFNAME , TO_CHAR(E.EL_FROM_DATE,'YYYY') ");
		} else if ("month".equals(interval)) {
			sqlStr.append("GROUP BY S.CO_STAFFNAME, S.CO_DEPARTMENT_DESC, TO_CHAR(E.EL_FROM_DATE,'YYYY') , TO_CHAR(E.EL_TO_DATE,'MM') ");
			sqlStr.append("ORDER BY S.CO_STAFFNAME , TO_CHAR(E.EL_FROM_DATE,'YYYY') , TO_CHAR(E.EL_TO_DATE,'MM') ");
		} else if ("day".equals(interval)) {
			sqlStr.append("GROUP BY S.CO_STAFFNAME, S.CO_DEPARTMENT_DESC, TO_CHAR(E.EL_FROM_DATE,'DD/MM/YYYY'), TO_CHAR(E.EL_TO_DATE,'DD/MM/YYYY') ");
			sqlStr.append("ORDER BY S.CO_STAFFNAME , TO_CHAR(E.EL_FROM_DATE,'DD/MM/YYYY') ");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(),
				new String[] { startDateStr, endDateStr });
	}

	public static int checkSingleReturn(String staffID, String staffName, String startDateStr, String endDateStr,
			String interval, String[] filterStatus, String deptCode) {
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyy");
		Date startDate, endDate;
		try {
			startDate = format.parse(startDateStr);
			endDate = format.parse(endDateStr);
		} catch (Exception e) {
			return -1;
		}
		Calendar startCalendar = Calendar.getInstance();
		Calendar endCalendar = Calendar.getInstance();
		startCalendar.setTime(startDate);
		endCalendar.setTime(endDate);

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT S.CO_STAFF_ID ");
		sqlStr.append("FROM EL_ELEAVE E, CO_STAFFS S ");
		sqlStr.append("WHERE (E.EL_STAFF_ID = ? OR UPPER(S.CO_STAFFNAME) LIKE '%'||UPPER(TRIM(?))||'%') ");
		sqlStr.append("AND   E.EL_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND   E.EL_FROM_DATE ");
		sqlStr.append(" BETWEEN TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append(" AND TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND E.EL_ENABLED = 1 ");
		if (deptCode != null && !"".equals(deptCode)) {
			sqlStr.append("AND S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode.replace("'", ""));
			sqlStr.append("' ");
		}
		// Filter status
		sqlStr.append("AND E.EL_LEAVE_STATUS IN ( ");
		for (int i = 0; i < filterStatus.length; i++) {
			if (filterStatus[i] != null) {
				sqlStr.append("'");
				sqlStr.append(filterStatus[i].replace("'", ""));
				sqlStr.append("'");
			} else {
				sqlStr.append("null");
			}
			if (i < filterStatus.length - 1)
				sqlStr.append(",");
		}
		sqlStr.append("     ) ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(),
					new String[] { staffID , "".equals(staffID)?"%"+staffName+"%":"",
					startDateStr, endDateStr });
		if (result.size() == 1) {
			return 1;
		} else {
			return 0;
		}
	}

	public static String[] parseDateRange(String fromDateStr, String fromDateUnit, String toDateStr, String toDateUnit) {
		Date fromDate = DateTimeUtil.parseDate(fromDateStr);
		Date toDate = DateTimeUtil.parseDate(toDateStr);

		if (fromDate != null && toDate != null) {
			Calendar fromCalendar = Calendar.getInstance();
			fromCalendar.setTime(fromDate);
			if ("PM".equals(fromDateUnit)) {
				fromCalendar.set(Calendar.HOUR, 12);
			} else {
				fromCalendar.set(Calendar.HOUR, 00);
			}
			fromCalendar.set(Calendar.MINUTE, 00);
			fromCalendar.set(Calendar.SECOND, 00);
			Calendar toCalendar = Calendar.getInstance();
			toCalendar.setTime(toDate);
			if ("AM".equals(toDateUnit)) {
				toCalendar.set(Calendar.HOUR, 11);
			} else {
				toCalendar.set(Calendar.HOUR, 23);
			}
			toCalendar.set(Calendar.MINUTE, 59);
			toCalendar.set(Calendar.SECOND, 59);
			float appliedDate = toCalendar.getTime().getTime() - fromCalendar.getTime().getTime();
			appliedDate /= (1000 * 60 * 60 * 24);
			appliedDate *= 10 + 0.1;
			int appliedDateInt = (int) appliedDate;
//			(int)appliedDate = appliedDateInt;
			return new String[] {
					DateTimeUtil.formatDateTime(fromCalendar.getTime()),
					DateTimeUtil.formatDateTime(toCalendar.getTime()),
//					String.valueOf((int) (appliedDate / 10))
					String.valueOf((double)appliedDateInt / 10)
			};
		} else {
			return null;
		}
	}

	public static ArrayList getLeaveType(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EL_LEAVE_TYPE, EL_LEAVE_TYPE_DESC ");
		sqlStr.append("FROM   EL_EMPLOYEE_ELEAVE_TYPE ");
		sqlStr.append("WHERE  EL_STAFF_ID = ? ");
		sqlStr.append("ORDER BY EL_LEAVE_TYPE_DESC ");
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID });
	}

	public static ArrayList hasLeaveType(String staffID,String leaveType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EL_LEAVE_TYPE, EL_LEAVE_TYPE_DESC ");
		sqlStr.append("FROM   EL_EMPLOYEE_ELEAVE_TYPE ");
		sqlStr.append("WHERE  EL_STAFF_ID = ? ");
		sqlStr.append(" AND EL_LEAVE_TYPE like '%");
		sqlStr.append("ORDER BY EL_LEAVE_TYPE_DESC ");
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID });
	}

	public static String getLeaveTypeDesc(String leaveType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT EL_LEAVE_TYPE_DESC ");
		sqlStr.append("FROM   EL_EMPLOYEE_ELEAVE_TYPE ");
		sqlStr.append("WHERE  EL_LEAVE_TYPE = ? ");
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { leaveType });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return ConstantsVariable.EMPTY_VALUE;
		}
	}

	public static ArrayList getLeaveHoliday() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(EL_HOLIDAY, 'dd/MM/YYYY'), EL_DESC ");
		sqlStr.append("FROM   EL_PUBLIC_HOLIDAY ");
		sqlStr.append("WHERE  TO_CHAR(EL_HOLIDAY, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY') ");
		sqlStr.append("ORDER BY EL_HOLIDAY ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getLeaveHoliday(String startDate, String endDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(EL_HOLIDAY, 'dd/MM/YYYY'), EL_DESC ");
		sqlStr.append("FROM   EL_PUBLIC_HOLIDAY ");
		sqlStr.append("WHERE  EL_HOLIDAY >= TO_DATE('"+startDate+" 00:00:00', 'DDMMYYYY HH24:MI:SS') ");
		sqlStr.append("AND	  EL_HOLIDAY <= TO_DATE('"+endDate+" 23:59:59', 'DDMMYYYY HH24:MI:SS') ");
		sqlStr.append("ORDER BY EL_HOLIDAY ");

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static void  sendRemindNotificationEmail() {
		StringBuffer sqlStr = new StringBuffer();
		StringBuffer emailStr = new StringBuffer();
		String emailFrom = null;
		String topic = null;
		String emailTo = null;

		sqlStr.append(" SELECT  el_approval_staff_id,count(*) from el_eleave_approved ");
		sqlStr.append(" where el_enabled=0 and el_eleave_id in ");
		sqlStr.append(" (select el_eleave_id  from el_eleave where EL_STAFF_ID not like '%DR%' and EL_ENABLED = 1) ");
		sqlStr.append(" GROUP BY el_approval_staff_id ");
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			for(int i=0;i<record.size();i++) {
				ReportableListObject row = (ReportableListObject) record.get(i);
				emailTo = ELeaveDB.getELEmail(row.getValue(0));
				if (Integer.parseInt(row.getValue(1))>0) {
					ArrayList recordLeave = getListofUnapprovedLeaveOfApprover(row.getValue(0));
					if (recordLeave.size()>0) {
						emailStr.append("Please approve/reject the following leaves as soon as possible:<br>");
						for(int j=0;j<recordLeave.size();j++) {
							ReportableListObject rowLeave = (ReportableListObject) recordLeave.get(j);
							emailStr.append("Staff Name: "+rowLeave.getValue(6)+"<br>");
							emailStr.append("Leave Type: "+rowLeave.getValue(1)+"<br>");
							emailStr.append("Applied Date: "+rowLeave.getValue(2)+" - "+rowLeave.getValue(3)+"("+rowLeave.getValue(4)+"day(s)("+rowLeave.getValue(5)+"hour(s)) \n");
							emailStr.append(" <br>Please approve/reject the above leave application by clicking <a href=\"http://");
							emailStr.append(ConstantsServerSide.INTRANET_URL);
							emailStr.append("/intranet/eleave/");
							emailStr.append("applyStaff_list.jsp");
							emailStr.append("?command=view&eleaveID=");
							emailStr.append(rowLeave.getValue(0));
							emailStr.append("\">Intranet(on campus)</a> or <a href=\"https://");
							emailStr.append(ConstantsServerSide.OFFSITE_URL);
							emailStr.append("/intranet/eleave/");
							emailStr.append("applyStaff_list.jsp");
							emailStr.append("?command=view&eleaveID=");
							emailStr.append(rowLeave.getValue(0));
							emailStr.append("\">Offsite(off campus)</a>.<br><br>");

						}
						UtilMail.sendMail(
								ConstantsServerSide.MAIL_ALERT,
								new String[] { emailTo },
								null,
								new String[] {"cherry.wong@hkah.org.hk","mary.chu@hkah.org.hk" },
								"Leave waiting for Approval" + " (From Intranet Portal - E-Leave)",
								emailStr.toString());
					}
				}
			}
		}



	}

	public static ArrayList getListofUnapprovedLeaveOfApprover(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(" SELECT el_eleave_id,el_leave_type,TO_CHAR(EL_FROM_DATE,'dd/mm/yyyy'),TO_CHAR(el_to_date,'dd/mm/yyyy'), ");
		sqlStr.append(" TO_CHAR(el_applied_days,'90.99'),TO_CHAR(EL_APPLIED_HOURS,'990.99'), ");
		sqlStr.append(" (select CO_STAFFNAME from co_staffs where co_staff_id=EL_STAFF_ID)as staffName ");
		sqlStr.append(" FROM el_eleave ");
		sqlStr.append(" WHERE el_eleave_id IN ");
		sqlStr.append(" (SELECT el_eleave_id FROM el_eleave_approved  WHERE el_enabled=0 AND el_approval_staff_id='"+staffID+"')");
		sqlStr.append(" AND EL_ENABLED=1");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static void sendEmail(String eleaveID, String fromStaffID, String eleaveStatus, String remarks) {
		sendEmail(eleaveID,fromStaffID,eleaveStatus,remarks,"");
	}

	public static void sendEmail(String eleaveID, String fromStaffID, String eleaveStatus, String remarks,String changeHour) {
		String appliedStaffID = null;
		String appliedStaffName = null;
		String leaveType = null;
		String leaveTypeDesc = null;
		String appliedDateFrom = null;
		String appliedDateTo = null;
		String appliedDate = null;
		String appliedHour = null;
		String approvalStaffEmail = null;
		String jspName = null;

		String emailFrom = null;
		String topic = null;
		Vector emailToVector = new Vector();

		ArrayList record = get(eleaveID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			appliedStaffID = row.getValue(0);
			appliedStaffName = row.getValue(1);
			leaveType = row.getValue(3);
			appliedDateFrom = row.getValue(4);
			appliedDateTo = row.getValue(5);
			appliedDate = row.getValue(6);
			appliedHour = row.getValue(7);

			if (isDoctor(fromStaffID)) {
				jspName = "apply.jsp";

				// get approval list
				record = ApprovalUserDB.getApprovalUserList("eleave.d", "approve", null, null, appliedStaffID);
				if (record.size() > 0) {
					String priority = null;
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						priority = row.getValue(3);
						if ("1".equals(priority)) {
							approvalStaffEmail = row.getValue(2);
						}
						// put all the other approval email into bcc
						emailToVector.add(row.getValue(2));
					}
				}
			} else {
				jspName = "applyStaff_list.jsp";

				// if for staff, all forward to admin email
				//emailToVector.add(ConstantsServerSide.MAIL_ADMIN);
				leaveTypeDesc = getLeaveTypeDesc(leaveType);
			}

			// set default leave type description
			if (leaveTypeDesc == null) {
				if ("AL".equals(leaveType)) {
					leaveTypeDesc = "Annual Leave";
				} else if ("SL".equals(leaveType)) {
					leaveTypeDesc = "Sick Leave";
				} else {
					leaveTypeDesc = "Leave";
				}
			}

			if (NEW_STATUS.equals(eleaveStatus)) {
				// open status
				if (isDoctor(fromStaffID)) {
					emailFrom = UserDB.getUserEmail(null, appliedStaffID);
				} else {
					emailFrom =	("".equals(ELeaveDB.getELEmail(appliedStaffID))||ELeaveDB.getELEmail(appliedStaffID)==null)?
							UserDB.getUserEmail(null, appliedStaffID):
							ELeaveDB.getELEmail(appliedStaffID);
				}
				topic = appliedStaffName + " Apply " + leaveTypeDesc + ".";
				if (isDoctor(fromStaffID)) {
					record = ApprovalUserDB.getApprovalUserList("eleave.d", "approve", null, StaffDB.getDeptCode(appliedStaffID), appliedStaffID);
				} else {
					record = ApprovalUserDB.getApprovalUserListForEL("eleave.s", "approve", null, StaffDB.getDeptCode(appliedStaffID), appliedStaffID);
				}
				if (record.size() > 0) {
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						emailToVector.add(row.getValue(2));
					}
				}

			} else {
				if ("P".equals(eleaveStatus)) {
					if (isDoctor(fromStaffID)) {
						emailFrom = UserDB.getUserEmail(null, fromStaffID);
						emailToVector.add(UserDB.getUserEmail(null, appliedStaffID));
					} else {
						emailFrom =	("".equals(ELeaveDB.getELEmail(fromStaffID))||ELeaveDB.getELEmail(fromStaffID)==null)?
								UserDB.getUserEmail(null, fromStaffID):
								ELeaveDB.getELEmail(fromStaffID);

						emailToVector.add(("".equals(ELeaveDB.getELEmail(appliedStaffID))||ELeaveDB.getELEmail(appliedStaffID)==null)?
										UserDB.getUserEmail(null, appliedStaffID):
										ELeaveDB.getELEmail(appliedStaffID));
					}
					topic = appliedStaffName + " Apply " + leaveTypeDesc + " (Accepted).";
				} else if ("CC".equals(eleaveStatus)) {
					if (isDoctor(fromStaffID)) {
						emailFrom = UserDB.getUserEmail(null, fromStaffID);
						emailToVector.add(UserDB.getUserEmail(null, appliedStaffID));
					} else {
						emailFrom =	("".equals(ELeaveDB.getELEmail(fromStaffID))||ELeaveDB.getELEmail(fromStaffID)==null)?
								UserDB.getUserEmail(null, fromStaffID):
								ELeaveDB.getELEmail(fromStaffID);

						emailToVector.add(("".equals(ELeaveDB.getELEmail(appliedStaffID))||ELeaveDB.getELEmail(appliedStaffID)==null)?
								UserDB.getUserEmail(null, appliedStaffID):
								ELeaveDB.getELEmail(appliedStaffID));
					}
					topic = appliedStaffName + " Apply Cancellation for" + leaveTypeDesc + " (Accepted).";
				} else {
					// either accept or reject status
					if (isDoctor(fromStaffID)) {
						emailFrom = approvalStaffEmail;
						emailToVector.add(UserDB.getUserEmail(null, appliedStaffID));
					} else {
						emailFrom =	("".equals(ELeaveDB.getELEmail(fromStaffID))||ELeaveDB.getELEmail(fromStaffID)==null)?
								UserDB.getUserEmail(null, fromStaffID):
								ELeaveDB.getELEmail(fromStaffID);

						emailToVector.add(("".equals(ELeaveDB.getELEmail(appliedStaffID))||ELeaveDB.getELEmail(appliedStaffID)==null)?
								UserDB.getUserEmail(null, appliedStaffID):
								ELeaveDB.getELEmail(appliedStaffID));
					}
					if (APPROVED_STATUS.equals(eleaveStatus)) {
						topic = "Your " + leaveTypeDesc + " Request is Accepted.";
					} else if (REJECTED_STATUS.equals(eleaveStatus)) {
						topic = "Your " + leaveTypeDesc + " Request is Rejected.";
					}
				}
			}
		}

		// append url
		StringBuffer commentStr = new StringBuffer();
		commentStr.append("Employee Name: ");
		commentStr.append(appliedStaffName);

		commentStr.append("<br>");
		commentStr.append("Leave request from ");
		commentStr.append(appliedDateFrom);
		commentStr.append(" to ");
		commentStr.append(appliedDateTo);

		commentStr.append("<br>");
		commentStr.append("Total number of working day(s): ");
		commentStr.append(appliedDate);
		commentStr.append("<br>");
		commentStr.append("Total number of leave hour(s): ");
		commentStr.append(appliedHour);
		commentStr.append("<br>");
		commentStr.append("Type of leave: ");
		commentStr.append(leaveTypeDesc);

		if (remarks != null && remarks.length() > 0) {
			commentStr.append("<br>");
			commentStr.append("Remarks: ");
			commentStr.append(remarks);
		}
		if (changeHour != null && !"".equals(changeHour)) {
			commentStr.append("<br>");
			commentStr.append("Applied Hour(s) has/have been changed by Manager from ");
			commentStr.append(changeHour);
			commentStr.append(" to ");
			commentStr.append(appliedHour);
		}
		commentStr.append(" <br>Please "+(("P".equals(eleaveStatus)||"R".equals(eleaveStatus))?"view ":"approve ")+"the above leave application by clicking <a href=\"http://");
		commentStr.append(ConstantsServerSide.INTRANET_URL);
		commentStr.append("/intranet/eleave/");
		commentStr.append(jspName);
		commentStr.append("?command=view&eleaveID=");
		commentStr.append(eleaveID);
		commentStr.append("\">Intranet(on campus)</a> or <a href=\"https://");
		commentStr.append(ConstantsServerSide.OFFSITE_URL);
		commentStr.append("/intranet/eleave/");
		commentStr.append(jspName);
		commentStr.append("?command=view&eleaveID=");
		commentStr.append(eleaveID);
		commentStr.append("\">Offsite(off campus)</a>.");

		// send email
		UtilMail.sendMail(
			emailFrom,
			(String[]) emailToVector.toArray(new String[emailToVector.size()]),
			null,
			new String[] {"cherry.wong@hkah.org.hk" },
			topic + " (From Intranet Portal - E-Leave)",
			commentStr.toString());
	}

	private static boolean isDoctor(String staffID) {
		return staffID != null && staffID.indexOf("DR") >= 0;
	}

	private static String getStaffID(String eleaveID) {
		ArrayList record = get(eleaveID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		}
		return null;
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EL_ELEAVE (");
		sqlStr.append("EL_ELEAVE_ID, EL_SITE_CODE, EL_STAFF_ID, EL_LEAVE_TYPE, ");
		sqlStr.append("EL_FROM_DATE, EL_TO_DATE, EL_APPLIED_DAYS, EL_APPLIED_HOURS, EL_REQUEST_REMARKS, ");
		sqlStr.append("EL_CREATED_USER, EL_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, '" + ConstantsServerSide.SITE_CODE + "', ?, ?, ");
		sqlStr.append("TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), TO_NUMBER(?), TO_NUMBER(?), ?, ");
		sqlStr.append("?, ?)");
		sqlStr_insertLeave = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO EL_ELEAVE (");
		sqlStr.append("EL_ELEAVE_ID, EL_SITE_CODE, EL_STAFF_ID, EL_LEAVE_TYPE, ");
		sqlStr.append("EL_FROM_DATE, EL_TO_DATE, EL_APPLIED_DAYS, EL_APPLIED_HOURS, EL_REQUEST_REMARKS, ");
		sqlStr.append("EL_CREATED_USER, EL_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, '" + ConstantsServerSide.SITE_CODE + "', ?, ?, ");
		sqlStr.append("TO_DATE(?, 'dd/MM/YYYY'), TO_DATE(?, 'dd/MM/YYYY'), TO_NUMBER(?), TO_NUMBER(?), ?, ");
		sqlStr.append("?, ?)");
		sqlStr_insertLeaveStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE EL_ELEAVE ");
		sqlStr.append("SET    EL_ENABLED = 0, EL_MODIFIED_DATE = SYSDATE, EL_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EL_ELEAVE_ID = ? AND EL_LEAVE_STATUS = ? AND EL_ENABLED = 1");
		sqlStr_cancelLeave = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT L.EL_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("       D.CO_DEPARTMENT_DESC, L.EL_LEAVE_TYPE, ");
		sqlStr.append("       TO_CHAR(L.EL_FROM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(L.EL_TO_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(L.EL_APPLIED_DAYS,'90.99'), TO_CHAR(L.EL_APPLIED_HOURS,'990.99'), L.EL_REQUEST_REMARKS, EL_RESPONSE_REMARKS, L.EL_LEAVE_STATUS, ");
		sqlStr.append("       (select EL_DESC from EL_PUBLIC_HOLIDAY where EL_HOLIDAY = EL_PUBLIC_HOLIDAY)as publicHoliday,L.EL_STATUS, TO_CHAR(L.EL_MODIFIED_DATE,'DD/MM/YYYY'), L.EL_MODIFIED_USER,S.CO_DEPARTMENT_CODE ");
		sqlStr.append("FROM   EL_ELEAVE L, CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  L.EL_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    L.EL_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    L.EL_ENABLED = 1 ");
		sqlStr.append("AND    L.EL_ELEAVE_ID = ? ");
		sqlStr.append("ORDER BY EL_ELEAVE_ID");
		sqlStr_listLeave = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT L.EL_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("       D.CO_DEPARTMENT_DESC, L.EL_LEAVE_TYPE, ");
		sqlStr.append("       TO_CHAR(L.EL_FROM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(L.EL_TO_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       L.EL_APPLIED_DAYS, L.EL_APPLIED_HOURS, L.EL_REQUEST_REMARKS, EL_RESPONSE_REMARKS, L.EL_LEAVE_STATUS,TO_CHAR(L.EL_MODIFIED_DATE,'dd/mm/yyyy'),L.EL_MODIFIED_USER ");
		sqlStr.append("FROM   EL_ELEAVE L, CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  L.EL_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    L.EL_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    L.EL_ELEAVE_ID = ? ");
		sqlStr.append("ORDER BY EL_ELEAVE_ID");
		sqlStr_listAllLeave = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO EL_ELEAVE_APPROVED (");
		sqlStr.append("EL_ELEAVE_ID, EL_ELEAVE_APPROVED_ID, EL_SITE_CODE, EL_APPROVAL_STAFF_ID, ");
		sqlStr.append("EL_CREATED_USER, EL_MODIFIED_USER, EL_ENABLED) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, '" + ConstantsServerSide.SITE_CODE + "', ?, ");
		sqlStr.append("?, ?, 0)");
		sqlStr_insertLeaveApproval = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE EL_ELEAVE_APPROVED ");
		sqlStr.append("SET    EL_ENABLED = 1, ");
		sqlStr.append("       EL_MODIFIED_DATE = SYSDATE, EL_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EL_ELEAVE_ID = ? ");
		sqlStr.append("AND    EL_APPROVAL_STAFF_ID = ? ");
		sqlStr.append("AND    EL_ENABLED = 0 ");
		sqlStr_updateLeaveApproval = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE EL_ELEAVE_APPROVED ");
		sqlStr.append("SET    EL_ENABLED = 0, ");
		sqlStr.append("       EL_MODIFIED_DATE = SYSDATE, EL_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EL_ELEAVE_ID = ? ");
		sqlStr.append("AND    EL_APPROVAL_STAFF_ID = ? ");
		sqlStr.append("AND    EL_ENABLED = 1 ");
		sqlStr_updateLeaveApprovalToZero = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT L.EL_APPROVAL_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_MODIFIED_DATE, 'dd/MM/YYYY HH24:MI'), L.EL_ELEAVE_APPROVED_ID ");
		sqlStr.append("FROM   EL_ELEAVE_APPROVED L, CO_STAFFS S ");
		sqlStr.append("WHERE  L.EL_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    L.EL_APPROVAL_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    L.EL_SITE_CODE = ? ");
		sqlStr.append("AND    L.EL_ENABLED = 1 ");
		sqlStr.append("AND    L.EL_ELEAVE_ID = ? ");
		sqlStr.append("ORDER BY L.EL_ELEAVE_APPROVED_ID ");
		sqlStr_listLeaveApproval = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT L.EL_APPROVAL_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(L.EL_MODIFIED_DATE, 'dd/MM/YYYY HH24:MI'), L.EL_ELEAVE_APPROVED_ID ");
		sqlStr.append("FROM   EL_ELEAVE_APPROVED L, CO_STAFFS S ");
		sqlStr.append("WHERE  L.EL_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    L.EL_APPROVAL_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    L.EL_SITE_CODE = ? ");
		sqlStr.append("AND    L.EL_ELEAVE_ID = ? ");
		sqlStr.append("ORDER BY L.EL_ELEAVE_APPROVED_ID ");
		sqlStr_listTotalapprovedLeaveApproval = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_APPROVAL_USER_ID ");
		sqlStr.append("FROM   CO_APPROVAL_USER ");
		sqlStr.append("WHERE  CO_APPROVAL_USER_ID = ? ");
		sqlStr.append("AND    CO_REQUEST_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_CATEGORY = 'approve' ");
		sqlStr.append("AND    CO_MODULE_CODE IN ('eleave.d', 'eleave.s') ");
		sqlStr_chkValidApproval = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT EL_ELEAVE_ID FROM EL_ELEAVE_APPROVED ");
		sqlStr.append("WHERE  EL_ELEAVE_ID = ? ");
		sqlStr.append("AND    EL_APPROVAL_STAFF_ID = ( ");
		sqlStr.append("SELECT DISTINCT CO_APPROVAL_USER_ID ");
		sqlStr.append("FROM   CO_APPROVAL_USER ");
		sqlStr.append("WHERE  CO_REQUEST_SITE_CODE = ? ");
		sqlStr.append("AND    CO_APPROVAL_USER_ID = ? ");
		sqlStr.append("AND    CO_MODULE_CODE IN ('eleave.d', 'eleave.s') ");
		sqlStr.append("AND    CO_CATEGORY = ?) ");
		sqlStr.append("AND    EL_ENABLED = 0 ");
		sqlStr_chkValidApprovalEl = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT EL_ELEAVE_ID FROM EL_ELEAVE_APPROVED ");
		sqlStr.append("WHERE  EL_ELEAVE_ID = ? ");
		sqlStr.append("AND    EL_APPROVAL_STAFF_ID = ( ");
		sqlStr.append("SELECT DISTINCT CO_APPROVAL_USER_ID ");
		sqlStr.append("FROM   CO_APPROVAL_USER ");
		sqlStr.append("WHERE  CO_REQUEST_SITE_CODE = ? ");
		sqlStr.append("AND    CO_APPROVAL_USER_ID = ? ");
		sqlStr.append("AND    CO_MODULE_CODE IN ('eleave.d', 'eleave.s') ");
		sqlStr.append("AND    CO_CATEGORY = ?) ");
		sqlStr_chkExistApprovalEl = sqlStr.toString();
	}
}