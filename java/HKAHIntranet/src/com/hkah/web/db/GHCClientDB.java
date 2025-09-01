package com.hkah.web.db;

import java.util.ArrayList;
import java.util.Vector;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.fop.AppointmentLetter;
import com.hkah.fop.InPatientLetter;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class GHCClientDB {
	private static String sqlStr_insertClient = null;
	private static String sqlStr_deleteClient = null;

	private static String sqlStr_insertRejectDate = null;
	private static String sqlStr_getClient = null;
	private static String sqlStr_getClientWithDoctorName = null;

	private static String sqlStr_insertComment = null;
	private static String sqlStr_getCommentList = null;
	private static String sqlStr_getCommentList4GHC = null;

	private static String sqlStr_acknowledgementClient = null;
	private static String sqlStr_approvalClient = null;

	private static String getNextClientID() {
		String clientID = null;

		// get next client id from db
		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
			"SELECT MAX(GHC_CLIENT_ID) + 1 FROM GHC_CLIENTS");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			clientID = reportableListObject.getValue(0);

			// set 1 for initial
			if (clientID == null || clientID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return clientID;
	}

	private static String getNextCommentID(String clientID) {
		String commentID = null;

		// get next comment id from db
		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
			"SELECT MAX(GHC_COMMENT_ID) + 1 FROM GHC_COMMENTS WHERE GHC_CLIENT_ID = ? ", new String [] { clientID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			commentID = reportableListObject.getValue(0);

			// set 1 for initial
			if (commentID == null || commentID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return commentID;
	}

	/**
	 * Add a client
	 */
	public static String add(UserBean userBean) {

		// get next client ID
		String clientID = getNextClientID();

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertClient,
				new String[] {
						clientID,
						userBean.getLoginID(), userBean.getLoginID() })) {
			return clientID;
		} else {
			return null;
		}
	}

	/**
	 * Modify a client
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String clientID, String specialtyCode, String patientID,
			String lastName, String firstName, String chineseName,
			String email, String DOBDate, String travelDocNo,
			String kinLastName, String kinFirstName, String kinChineseName,
			String kinEmail, String kinDOBDate, String kinTravelDocNo,
			String homePhone, String mobilePhone, String attendingDoctor, String expectedDeliveryDate,
			String requestAppointmentDate1, String requestAppointmentDate2,
			String requestAppointmentDate3, String requestAppointmentDate4,
			String selectAnotherAppointmentDate,
			String confirmAppointmentDate1, String confirmAppointmentDate2,
			String confirmAppointmentDate3, String confirmAppointmentDate4,
			String acceptAppointmentDate1, String acceptAppointmentDate2,
			String acceptAppointmentDate3, String acceptAppointmentDate4,
			String acknowledgeAppointmentDate1, String acknowledgeAppointmentDate2,
			String acknowledgeAppointmentDate3, String acknowledgeAppointmentDate4,
			String patientArrivalDate1, String flightInfo1, String transportMethod1, String transportArrangeBy1, String hotalInfo1, String hotalArrangeBy1,
			String patientReminderDate1, String patientReminderMethod1, String patientReminderRemark1,
			String patientArrivalDate2, String flightInfo2, String transportMethod2, String transportArrangeBy2, String hotalInfo2, String hotalArrangeBy2,
			String patientReminderDate2, String patientReminderMethod2, String patientReminderRemark2,
			String confirmDeliveryDate, String prebookingConfirmNo, String paySlipNo, String paySlipDate, String certIssueDate,
			String insuranceYN, String insuranceCompanyID, String insuranceCompanyName, String insurancePolicyNo,
			String insurancePolicyHolderName, String insurancePolicyGroup, String insuranceValidThru,
			String appointedRoomType, String admissionDate, String surgeryInfo, String typeOfDiagnosis, String typeOfAnaesthesia,
			String nameOfProcedure, String onsetDateOfSymptoms, String treatmentPlan, String estimatedLengthOfStay,
			String surgeonFee, String wardRoundFee, String anaesthetistFee, String procedureFee, String procedureFeeAdditional,
			String confirmPatient, String confirmedRoomType,
			String remark_hkah1, String remark_ghc1,
			String remark_hkah2, String remark_ghc2,
			String remark_hkah3, String remark_ghc3,
			String remark_hkah4, String remark_ghc4,
			String remark_hkah5, String remark_ghc5,
			String stage, String conf) {

		String status = null;

		// jump to next step
		int stageInt = 0;
		boolean rollback = false;
		boolean fail = false;
		boolean clearRequestAppointmentDate1 = false;
		boolean clearRequestAppointmentDate2 = false;
		boolean clearRequestAppointmentDate3 = false;
		boolean clearRequestAppointmentDate4 = false;
		if (ConstantsVariable.ONE_VALUE.equals(conf) || "-1".equals(conf)) {
			// do rollback
			if ("-1".equals(conf)) {
				rollback = true;
			}

			// check appointment date
			if (ConstantsVariable.YES_VALUE.equals(selectAnotherAppointmentDate) || rollback) {
				// retreive request appointment date if empty
				if (requestAppointmentDate1 != null
						&& requestAppointmentDate2 != null
						&& requestAppointmentDate3 != null
						&& requestAppointmentDate4 != null) {
					ArrayList<ReportableListObject> result = get(userBean, clientID);
					if (result.size() > 0) {
						ReportableListObject row = (ReportableListObject) result.get(0);
						requestAppointmentDate1 = row.getValue(12);
						requestAppointmentDate2 = row.getValue(13);
						requestAppointmentDate3 = row.getValue(14);
						requestAppointmentDate4 = row.getValue(15);
					}
				}

				if (requestAppointmentDate1 != null && requestAppointmentDate1.length() > 0) {
					addRejectDate(userBean, clientID, requestAppointmentDate1);
					clearRequestAppointmentDate1 = true;
					requestAppointmentDate1 = "";
					rollback = true;
				}
				if (requestAppointmentDate2 != null && requestAppointmentDate2.length() > 0) {
					addRejectDate(userBean, clientID, requestAppointmentDate2);
					clearRequestAppointmentDate2 = true;
					requestAppointmentDate2 = "";
					rollback = true;
				}
				if (requestAppointmentDate3 != null && requestAppointmentDate3.length() > 0) {
					addRejectDate(userBean, clientID, requestAppointmentDate3);
					clearRequestAppointmentDate3 = true;
					requestAppointmentDate3 = "";
					rollback = true;
				}
				if (requestAppointmentDate4 != null && requestAppointmentDate4.length() > 0) {
					addRejectDate(userBean, clientID, requestAppointmentDate4);
					clearRequestAppointmentDate4 = true;
					requestAppointmentDate4 = "";
					rollback = true;
				}
			}

			if (ConstantsVariable.NO_VALUE.equals(acceptAppointmentDate1) || ConstantsVariable.NO_VALUE.equals(acceptAppointmentDate2)
					|| ConstantsVariable.NO_VALUE.equals(acceptAppointmentDate3) || ConstantsVariable.NO_VALUE.equals(acceptAppointmentDate4)) {
				rollback = true;
			}

			// rollback if empty confirm appointment date in OB
			try {
				stageInt = Integer.parseInt(stage);
				if (stageInt == 2 && "ob".equals(specialtyCode) && (confirmAppointmentDate1 == null || confirmAppointmentDate1.length() == 0)) {
					rollback = true;
				}

				// skip forward if not confirmed with patient
//				if (stageInt == 1 && "surgical".equals(specialtyCode) && !ConstantsVariable.YES_VALUE.equals(confirmPatient)) {
//					stageInt = 1;
//					stage = ConstantsVariable.ONE_VALUE;
//				} else {
					stage = String.valueOf(stageInt + (rollback?-1:1));
//				}
			} catch (Exception e) {}

			// update status
			if (rollback) {
				status = "reject";
			} else if (fail) {
				status = "fail";
			} else {
				status = "submit";
			}
		}

		// try to update selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE GHC_CLIENTS ");
		sqlStr.append("SET    GHC_MODIFIED_DATE = SYSDATE, ");
		updateSQLHelper(sqlStr, "GHC_PATIENT_ID", patientID);
		updateSQLHelper(sqlStr, "GHC_LASTNAME", lastName);
		updateSQLHelper(sqlStr, "GHC_FIRSTNAME", firstName);
		updateSQLHelper(sqlStr, "GHC_CHINESENAME", chineseName);
		updateSQLHelper(sqlStr, "GHC_EMAIL", email);
		updateSQLHelper(sqlStr, "GHC_DOB", DOBDate, true);
		updateSQLHelper(sqlStr, "GHC_TRAVEL_NO", travelDocNo);

		updateSQLHelper(sqlStr, "GHC_KIN_LASTNAME", kinLastName);
		updateSQLHelper(sqlStr, "GHC_KIN_FIRSTNAME", kinFirstName);
		updateSQLHelper(sqlStr, "GHC_KIN_CHINESENAME", kinChineseName);
		updateSQLHelper(sqlStr, "GHC_KIN_EMAIL", kinEmail);
		updateSQLHelper(sqlStr, "GHC_KIN_DOB", kinDOBDate, true);
		updateSQLHelper(sqlStr, "GHC_KIN_TRAVEL_NO", kinTravelDocNo);

		updateSQLHelper(sqlStr, "GHC_HOME_NUMBER", homePhone);
		updateSQLHelper(sqlStr, "GHC_MOBILE_NUMBER", mobilePhone);
		updateSQLHelper(sqlStr, "GHC_SPECIALTY", specialtyCode);
		updateSQLHelper(sqlStr, "GHC_ATTENDING_DOCTOR", attendingDoctor);
		updateSQLHelper(sqlStr, "GHC_EXPECTED_DELIVERYDATE", expectedDeliveryDate, true);
		if (clearRequestAppointmentDate1) {
			updateSQLHelper(sqlStr, "GHC_REQUEST_APPOINTDATE1", ConstantsVariable.EMPTY_VALUE, true);
		} else {
			updateSQLHelper(sqlStr, "GHC_REQUEST_APPOINTDATE1", requestAppointmentDate1, true);
		}
		if (clearRequestAppointmentDate2) {
			updateSQLHelper(sqlStr, "GHC_REQUEST_APPOINTDATE2", ConstantsVariable.EMPTY_VALUE, true);
		} else {
			updateSQLHelper(sqlStr, "GHC_REQUEST_APPOINTDATE2", requestAppointmentDate2, true);
		}
		if (clearRequestAppointmentDate3) {
			updateSQLHelper(sqlStr, "GHC_REQUEST_APPOINTDATE3", ConstantsVariable.EMPTY_VALUE, true);
		} else {
			updateSQLHelper(sqlStr, "GHC_REQUEST_APPOINTDATE3", requestAppointmentDate3, true);
		}
		if (clearRequestAppointmentDate4) {
			updateSQLHelper(sqlStr, "GHC_REQUEST_APPOINTDATE4", ConstantsVariable.EMPTY_VALUE, true);
		} else {
			updateSQLHelper(sqlStr, "GHC_REQUEST_APPOINTDATE4", requestAppointmentDate4, true);
		}
		updateSQLHelper(sqlStr, "GHC_CONFIRM_APPOINTDATE1", confirmAppointmentDate1, true);
		updateSQLHelper(sqlStr, "GHC_CONFIRM_APPOINTDATE2", confirmAppointmentDate2, true);
		updateSQLHelper(sqlStr, "GHC_CONFIRM_APPOINTDATE3", confirmAppointmentDate3, true);
		updateSQLHelper(sqlStr, "GHC_CONFIRM_APPOINTDATE4", confirmAppointmentDate4, true);
		updateSQLHelper(sqlStr, "GHC_ACCEPT_APPOINTDATE1", acceptAppointmentDate1);
		updateSQLHelper(sqlStr, "GHC_ACCEPT_APPOINTDATE2", acceptAppointmentDate2);
		updateSQLHelper(sqlStr, "GHC_ACCEPT_APPOINTDATE3", acceptAppointmentDate3);
		updateSQLHelper(sqlStr, "GHC_ACCEPT_APPOINTDATE4", acceptAppointmentDate4);
		updateSQLHelper(sqlStr, "GHC_ACKNOWLEDGE_APPOINTDATE1", acknowledgeAppointmentDate1);
		updateSQLHelper(sqlStr, "GHC_ACKNOWLEDGE_APPOINTDATE2", acknowledgeAppointmentDate2);
		updateSQLHelper(sqlStr, "GHC_ACKNOWLEDGE_APPOINTDATE3", acknowledgeAppointmentDate3);
		updateSQLHelper(sqlStr, "GHC_ACKNOWLEDGE_APPOINTDATE4", acknowledgeAppointmentDate4);
		updateSQLHelper(sqlStr, "GHC_ARRIVAL_DATE1", patientArrivalDate1, true);
		updateSQLHelper(sqlStr, "GHC_FLIGHT_INFO1", flightInfo1);
		updateSQLHelper(sqlStr, "GHC_TRANSPORT_METHOD1", transportMethod1);
		updateSQLHelper(sqlStr, "GHC_TRANSPORT_ARRANGEBY1", transportArrangeBy1);
		updateSQLHelper(sqlStr, "GHC_HOTAL_INFO1", hotalInfo1);
		updateSQLHelper(sqlStr, "GHC_HOTAL_ARRANGEBY1", hotalArrangeBy1);
		updateSQLHelper(sqlStr, "GHC_REMINDER_DATE1", patientReminderDate1, true);
		updateSQLHelper(sqlStr, "GHC_REMINDER_METHOD1", patientReminderMethod1);
		updateSQLHelper(sqlStr, "GHC_REMINDER_REMARK1", patientReminderRemark1);
		updateSQLHelper(sqlStr, "GHC_ARRIVAL_DATE2", patientArrivalDate2, true);
		updateSQLHelper(sqlStr, "GHC_FLIGHT_INFO2", flightInfo2);
		updateSQLHelper(sqlStr, "GHC_TRANSPORT_METHOD2", transportMethod2);
		updateSQLHelper(sqlStr, "GHC_TRANSPORT_ARRANGEBY2", transportArrangeBy2);
		updateSQLHelper(sqlStr, "GHC_HOTAL_INFO2", hotalInfo2);
		updateSQLHelper(sqlStr, "GHC_HOTAL_ARRANGEBY2", hotalArrangeBy2);
		updateSQLHelper(sqlStr, "GHC_REMINDER_DATE2", patientReminderDate2, true);
		updateSQLHelper(sqlStr, "GHC_REMINDER_METHOD2", patientReminderMethod2);
		updateSQLHelper(sqlStr, "GHC_REMINDER_REMARK2", patientReminderRemark2);
		updateSQLHelper(sqlStr, "GHC_CONFIRM_DELIVERY_DATE", confirmDeliveryDate, true);
		updateSQLHelper(sqlStr, "GHC_PREBOOKING_CONFIRM_NO", prebookingConfirmNo);
		updateSQLHelper(sqlStr, "GHC_PAY_SLIP_NO", paySlipNo);
		updateSQLHelper(sqlStr, "GHC_PAY_SLIP_DATE", paySlipDate, true);
		updateSQLHelper(sqlStr, "GHC_CERT_ISSUE_DATE", certIssueDate, true);

		updateSQLHelper(sqlStr, "GHC_INSURANCE_YN", insuranceYN);
		updateSQLHelper(sqlStr, "GHC_INSURANCE_COMPANY_ID", insuranceCompanyID);
		updateSQLHelper(sqlStr, "GHC_INSURANCE_COMPANY_NAME", insuranceCompanyName);
		updateSQLHelper(sqlStr, "GHC_INSURANCE_POLICY_NO", insurancePolicyNo);
		updateSQLHelper(sqlStr, "GHC_INSURANCE_POLICYHOLDERNAME", insurancePolicyHolderName);
		updateSQLHelper(sqlStr, "GHC_INSURANCE_POLICY_GROUP", insurancePolicyGroup);
		updateSQLHelper(sqlStr, "GHC_INSURANCE_VALID_THRU", insuranceValidThru);
		updateSQLHelper(sqlStr, "GHC_APPOINTED_CLASS", appointedRoomType);
		updateSQLHelper(sqlStr, "GHC_ADMISSION_DATE", admissionDate, true);
		updateSQLHelper(sqlStr, "GHC_SURGERY_INFO", surgeryInfo);
		updateSQLHelper(sqlStr, "GHC_TYPE_OF_DIAGNOSIS", typeOfDiagnosis);
		updateSQLHelper(sqlStr, "GHC_TYPE_OF_ANAESTHESIA", typeOfAnaesthesia);
		updateSQLHelper(sqlStr, "GHC_NAME_OF_PROCEDURE", nameOfProcedure);
		updateSQLHelper(sqlStr, "GHC_ONSETDATE_OF_SYMPTOMS", onsetDateOfSymptoms, true);
		updateSQLHelper(sqlStr, "GHC_TREATMENT_PLAN", treatmentPlan);
		updateSQLHelper(sqlStr, "GHC_ESTIMATED_LENGTH_OF_STAY", estimatedLengthOfStay);
		updateSQLHelper(sqlStr, "GHC_SURGEON_FEE", surgeonFee);
		updateSQLHelper(sqlStr, "GHC_WARD_ROUND_FEE", wardRoundFee);
		updateSQLHelper(sqlStr, "GHC_ANAESTHETIST_FEE", anaesthetistFee);
		updateSQLHelper(sqlStr, "GHC_PROCEDURE_FEE", procedureFee);
		updateSQLHelper(sqlStr, "GHC_PROCEDURE_FEE_ADDITIONAL", procedureFeeAdditional);
		updateSQLHelper(sqlStr, "GHC_CONFIRM_PATIENT", confirmPatient);
		updateSQLHelper(sqlStr, "GHC_CONFIRMED_CLASS", confirmedRoomType);

		updateSQLHelper(sqlStr, "GHC_REMARK_HKAH1", remark_hkah1);
		updateSQLHelper(sqlStr, "GHC_REMARK_HKAH2", remark_hkah2);
		updateSQLHelper(sqlStr, "GHC_REMARK_HKAH3", remark_hkah3);
		updateSQLHelper(sqlStr, "GHC_REMARK_HKAH4", remark_hkah4);
		updateSQLHelper(sqlStr, "GHC_REMARK_HKAH5", remark_hkah5);
		updateSQLHelper(sqlStr, "GHC_REMARK_GHC1", remark_ghc1);
		updateSQLHelper(sqlStr, "GHC_REMARK_GHC2", remark_ghc2);
		updateSQLHelper(sqlStr, "GHC_REMARK_GHC3", remark_ghc3);
		updateSQLHelper(sqlStr, "GHC_REMARK_GHC4", remark_ghc4);
		updateSQLHelper(sqlStr, "GHC_REMARK_GHC5", remark_ghc5);
		updateSQLHelper(sqlStr, "GHC_STATUS", status);
		sqlStr.append("       GHC_STAGE = ?, ");
		sqlStr.append("       GHC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		sqlStr.append("AND    GHC_CLIENT_ID = ? ");

		// special handle for doctor
		if (userBean.getRemark1() != null && userBean.getRemark1().length() > 0) {
			sqlStr.append("AND   GHC_ATTENDING_DOCTOR = '");
			sqlStr.append(userBean.getRemark1());
			sqlStr.append("' ");
		}

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { stage, userBean.getLoginID(), clientID})) {
			if (stageInt > 0) {
				sendEmail(userBean, clientID, specialtyCode, stageInt, rollback);
			}
			return true;
		} else {
			return false;
		}
	}

	private static void updateSQLHelper(StringBuffer sqlStr, String fieldName, String fieldValue) {
		updateSQLHelper(sqlStr, fieldName, fieldValue, false);
	}

	private static void updateSQLHelper(StringBuffer sqlStr, String fieldName, String fieldValue, boolean isDate) {
		if (isDate) {
			updateDateSQLHelper(sqlStr, fieldName, fieldValue);
		} else {
			updateStrSQLHelper(sqlStr, fieldName, fieldValue);
		}
	}

	private static void updateStrSQLHelper(StringBuffer sqlStr, String fieldName, String fieldValue) {
		if (fieldValue != null) {
			sqlStr.append(ConstantsVariable.SPACE_VALUE);
			sqlStr.append(fieldName);
			sqlStr.append(" = '");
			sqlStr.append(fieldValue);
			sqlStr.append("', ");
		}
	}

	private static void updateDateSQLHelper(StringBuffer sqlStr, String fieldName, String fieldValue) {
		if (fieldValue != null) {
			sqlStr.append(ConstantsVariable.SPACE_VALUE);
			sqlStr.append(fieldName);
			sqlStr.append(" = TO_DATE('");
			sqlStr.append(fieldValue);
			sqlStr.append("', 'DD/MM/YYYY");

			// add time if necessary
			if (fieldValue != null && fieldValue.length() == 16) {
				sqlStr.append(" HH24:MI");
			}
			sqlStr.append("'), ");
		}
	}

	public static boolean delete(UserBean userBean,
			String clientID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteClient,
				new String[] { userBean.getLoginID(), clientID } );
	}

	public static ArrayList<ReportableListObject> get(UserBean userBean, String clientID) {
		// special handle for doctor
		if (userBean.getRemark1() != null && userBean.getRemark1().length() > 0) {
			return UtilDBWeb.getReportableList(sqlStr_getClientWithDoctorName, new String[] { clientID, userBean.getRemark1() });
		} else {
			return UtilDBWeb.getReportableList(sqlStr_getClient, new String[] { clientID });
		}
	}

	public static ArrayList<ReportableListObject> getList(UserBean userBean, String specialtyCode) {
		// fetch client
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT GHC_CLIENT_ID, GHC_PATIENT_ID, ");
		sqlStr.append("       GHC_LASTNAME, GHC_FIRSTNAME, GHC_CHINESENAME, ");
		sqlStr.append("       GHC_ATTENDING_DOCTOR, GHC_SPECIALTY, ");
		sqlStr.append("       GHC_STAGE, GHC_STATUS, ");
		sqlStr.append("       TO_CHAR(GHC_ACKNOWLEDGE_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(GHC_APPROVAL_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(GHC_CREATED_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(GHC_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM   GHC_CLIENTS ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		if (specialtyCode != null && specialtyCode.length() > 0) {
			sqlStr.append("AND   GHC_SPECIALTY = '");
			sqlStr.append(specialtyCode);
			sqlStr.append("' ");
		}
		// special handle for doctor
		if (userBean.getRemark1() != null && userBean.getRemark1().length() > 0) {
			sqlStr.append("AND   GHC_ATTENDING_DOCTOR = '");
			sqlStr.append(userBean.getRemark1());
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY GHC_MODIFIED_DATE DESC, GHC_CREATED_DATE DESC, GHC_CLIENT_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	/**
	 * Add reject date
	 */
	public static String addRejectDate(UserBean userBean,
			String clientID, String requestAppointmentDate) {

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertRejectDate,
				new String[] {
						clientID,
						requestAppointmentDate,
						userBean.getLoginID(), userBean.getLoginID() })) {
			return clientID;
		} else {
			return null;
		}
	}

	public static ArrayList<ReportableListObject> getRejectDateList(String clientID) {
		// fetch client
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(GHC_REQUEST_APPOINTDATE, 'DD/MM/YYYY') ");
		sqlStr.append("FROM   GHC_CLIENT_REJECTDATE ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		sqlStr.append("AND    GHC_CLIENT_ID = ? ");
		sqlStr.append("ORDER BY GHC_REQUEST_APPOINTDATE");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID });
	}

	public static boolean updateLetter1(UserBean userBean, String clientID) {
		// update letter 1
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE GHC_CLIENTS ");
		sqlStr.append("SET    GHC_REMINDER_LETTER_DATE1 = SYSDATE, GHC_MODIFIED_DATE = SYSDATE, GHC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		sqlStr.append("AND    GHC_CLIENT_ID = ? ");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), clientID});
	}

	public static boolean updateLetter2(UserBean userBean, String clientID) {
		// update letter 1
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE GHC_CLIENTS ");
		sqlStr.append("SET    GHC_REMINDER_LETTER_DATE2 = SYSDATE, GHC_MODIFIED_DATE = SYSDATE, GHC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		sqlStr.append("AND    GHC_CLIENT_ID = ? ");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), clientID});
	}

	public static boolean generateAppointmentLetter(UserBean userBean, String clientID, String filename) {
		// generate pdf
		try {
			AppointmentLetter.toXMLfile(
					get(userBean, clientID),
					ConstantsServerSide.UPLOAD_WEB_FOLDER + "/GHC/" + clientID + "/" + filename + ".fo");
			return true;
		} catch (Exception e) {}
		return false;
	}

	public static boolean generateInPatientEmail(UserBean userBean, String clientID) {
		ArrayList<ReportableListObject> result = get(userBean,clientID);
		System.out.println(result.size());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = null;
			for (int i = 0; i < result.size(); i++) {
				reportableListObject = (ReportableListObject) result.get(0);
				String hospitalNo = reportableListObject.getValue(0);
				String clientLastName = reportableListObject.getValue(1);
				String clientFirstName = reportableListObject.getValue(2);
				String clientChineseName = reportableListObject.getValue(3);
				String clientName = null;
				if (clientChineseName != null && clientChineseName.length() > 0) {
					clientName = clientChineseName;
				} else {
					clientName = ConstantsVariable.EMPTY_VALUE;
					if (clientFirstName != null && clientFirstName.length() > 0) {
						clientName = clientFirstName;
					}
					if (clientLastName != null && clientLastName.length() > 0) {
						if (clientName.length() > 0) {
							clientName += ConstantsVariable.SPACE_VALUE;
						}
						clientName += clientLastName;
					}
				}
				String specialty = reportableListObject.getValue(9);
				String doctorName = reportableListObject.getValue(10);
				String printDate = reportableListObject.getValue(34);
				String appointmentDateTime = reportableListObject.getValue(16);
				String appointmentDate = null;
				String appointmentTime = null;
				if (appointmentDateTime != null && appointmentDateTime.length() > 11) {
					appointmentDate = appointmentDateTime.substring(0, 10);
					appointmentTime = appointmentDateTime.substring(11);
				} else {
					appointmentDate = "";
					appointmentTime = "";
				}
				String flightNo = reportableListObject.getValue(39);
				String transport = reportableListObject.getValue(40);
				String arrivalDateFrom = reportableListObject.getValue(38);
				String arrivalDateTo = reportableListObject.getValue(38);
				String pickupPlace = "";
				String pickupTelephone = "";

				StringBuffer commentStr = new StringBuffer();
				boolean isOB = "ob".equals(specialty);

				commentStr.append("<table ><tr><td width=\"700\"><img src=\"file://www-server/document/Upload/GHC/hkah_logo.jpg\" " +
								   "alt=\"Hong Kong Adventist Hospital\"");
				commentStr.append(">");
				commentStr.append("</td><td align=\"right\">");
				commentStr.append(MessageResources.getMessageSimplifiedChinese("prompt.hkah.address1"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.hkah.address1"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageSimplifiedChinese("prompt.hkah.address2"));
				commentStr.append("</td></tr>");
				commentStr.append("<tr><td>");
				commentStr.append(MessageResources.getMessageSimplifiedChinese("prompt.date")+" ");
				commentStr.append(MessageResources.getMessageEnglish("prompt.date") + ":" + printDate);
				commentStr.append("</td></tr></table>");
				commentStr.append("<table><tr><td width=\"450\"></td>");
				commentStr.append("<td>"+"&nbsp;&nbsp;&nbsp;"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.title"));
				commentStr.append("</td>");
				commentStr.append("<tr><td width=\"450\"></td><td>"+MessageResources.getMessageEnglish("prompt.confirmIP.title"));
				commentStr.append("</td></tr></table><table>");
				commentStr.append("<tr><td><br>"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.welcome.message1"));
				commentStr.append("<br>"+MessageResources.getMessageEnglish("prompt.confirmIP.welcome.message1")+"<br><br></td></tr></table>");
				commentStr.append("<table><tr><td><b>"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.block.a")+" "+MessageResources.getMessageEnglish("prompt.confirmIP.block.a")+"</b></td>");
				commentStr.append("</table>");
				commentStr.append("<table><tr><td>"+MessageResources.getMessageSimplifiedChinese("prompt.patientName") + ": " +"<br>"+MessageResources.getMessageEnglish("prompt.patientName")+"</td><td width=\"300\">"+clientName+"</td>");
				commentStr.append("<td>"+MessageResources.getMessageSimplifiedChinese("prompt.hospitalNo") + ": " +"<br>"+MessageResources.getMessageEnglish("prompt.hospitalNo")+"</td>"+"<td width=\"300\">"+hospitalNo+"</td>");
				commentStr.append("</tr>");
				commentStr.append("<tr><td>"+MessageResources.getMessageSimplifiedChinese("prompt.appointmentDate") + ": ");
				commentStr.append("<br>"+MessageResources.getMessageEnglish("prompt.appointmentDate")+"</td>"+"<td width=\"300\">"+appointmentDate+"</td>");
				commentStr.append("<td>"+MessageResources.getMessageSimplifiedChinese("prompt.appointmentTime") + ": "+"<br>"+MessageResources.getMessageEnglish("prompt.appointmentTime") +"</td>");
				commentStr.append("<td width=\"300\">" + appointmentTime +"</td>");
				commentStr.append("</tr>");
				if (isOB) {
					commentStr.append("<tr valign=\"top\">");
					commentStr.append("<td>"+MessageResources.getMessageSimplifiedChinese("prompt.doctor.ob") + ": "+"<br>"+MessageResources.getMessageEnglish("prompt.doctor.ob")+"</td>");
					commentStr.append("<td width=\"300\">"+doctorName+"</td>");
				} else {
					commentStr.append("<tr valign=\"top\">");
					commentStr.append("<td>"+MessageResources.getMessageSimplifiedChinese("prompt.doctor.surgical") + ": "+"<br>"+MessageResources.getMessageEnglish("prompt.doctor.surgical")+"</td>");
					commentStr.append("<td width=\"300\">"+doctorName+"</td>");
				}
				commentStr.append("<td>"+MessageResources.getMessageSimplifiedChinese("prompt.registration.location") + ": "+"<br>"+MessageResources.getMessageEnglish("prompt.registration.location")+"</td>");
				commentStr.append("<td width=\"300\">"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.registration")+"<br>"+MessageResources.getMessageEnglish("prompt.confirmIP.registration")+"</td>");
				commentStr.append("</tr>");
				commentStr.append("<br></table>");
				commentStr.append("<table><tr><td><b>"+" "+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.block.b")+ " " + MessageResources.getMessageEnglish("prompt.confirmIP.block.b")+"</b></td></tr></table>");
				commentStr.append("<table><tr><td>"+MessageResources.getMessageSimplifiedChinese("prompt.flightNo") + ": "+"<br>"+MessageResources.getMessageEnglish("prompt.flightNo")+"</td>");
				commentStr.append("<td width=\"190\">"+flightNo+"</td>");
				commentStr.append("<td>"+MessageResources.getMessageSimplifiedChinese("prompt.transportation.other") + ": "+"<br>"+MessageResources.getMessageEnglish("prompt.transportation.other")+"</td>");
				commentStr.append("<td width=\"190\">"+transport+"</td></tr>");

				commentStr.append("<tr><td>"+MessageResources.getMessageSimplifiedChinese("prompt.transportation.arrivalStartTime") + ": "+"<br>"+MessageResources.getMessageEnglish("prompt.transportation.arrivalStartTime")+"</td>");
				commentStr.append("<td width=\"190\">"+arrivalDateFrom+"</td>");
				commentStr.append("<td>"+MessageResources.getMessageSimplifiedChinese("prompt.transportation.arrivalEndTime") + ": "+"<br>"+MessageResources.getMessageEnglish("prompt.transportation.arrivalEndTime")+"</td>");
				commentStr.append("<td width=\"190\">"+arrivalDateTo+"</td></tr>");

				commentStr.append("<tr><td>"+MessageResources.getMessageSimplifiedChinese("prompt.pickup.location") + ": "+"<br>"+MessageResources.getMessageEnglish("prompt.pickup.location")+"</td>");
				commentStr.append("<td width=\"190\">"+pickupPlace+"</td>");
				commentStr.append("<td>"+MessageResources.getMessageSimplifiedChinese( "prompt.pickup.telephone") + ": "+"<br>"+MessageResources.getMessageEnglish( "prompt.pickup.telephone")+"</td>");
				commentStr.append("<td width=\"190\">"+pickupTelephone+"</td></tr>");
				commentStr.append("</table><table><tr><td><br><b>"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.title")+ " " + MessageResources.getMessageEnglish("prompt.confirmIP.important.title")+"</b></td></tr>");
				commentStr.append("<tr><td>"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message1")+ "<br>&nbsp;&nbsp;&nbsp;" + MessageResources.getMessageEnglish("prompt.confirmIP.important.message1")+"</b></td></tr>");
				commentStr.append("<tr><td>"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2")+ "&nbsp;&nbsp;" + MessageResources.getMessageEnglish("prompt.confirmIP.important.message2")+"</b></td></tr>");
				commentStr.append("<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2.1")+ MessageResources.getMessageEnglish("prompt.confirmIP.important.message2.1")+"</b></td></tr>");
				commentStr.append("<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2.2")+ MessageResources.getMessageEnglish("prompt.confirmIP.important.message2.2")+"</b></td></tr>");
				commentStr.append("<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2.3")+ MessageResources.getMessageEnglish("prompt.confirmIP.important.message2.3")+"</b></td></tr>");
				commentStr.append("<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2.4")+ MessageResources.getMessageEnglish("prompt.confirmIP.important.message2.4")+"</b></td></tr>");
				commentStr.append("<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message2.5")+ MessageResources.getMessageEnglish("prompt.confirmIP.important.message2.5")+"</b></td></tr>");
				commentStr.append("<tr><td>"+MessageResources.getMessageSimplifiedChinese("prompt.confirmIP.important.message3")+ "&nbsp;&nbsp;" + MessageResources.getMessageEnglish("prompt.confirmIP.important.message3")+"</b></td></tr>");
				commentStr.append("<tr><td><br><b>"+MessageResources.getMessageSimplifiedChinese("prompt.remarks")+" "+MessageResources.getMessageEnglish("prompt.remarks")+": "+"</b>");
				commentStr.append("<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+MessageResources.getMessageSimplifiedChinese("prompt.reminder.message1")+" "+ MessageResources.getMessageEnglish("prompt.reminder.message1")+"</b></td></tr>");
				commentStr.append("<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+MessageResources.getMessageSimplifiedChinese("prompt.reminder.message2")+" "+ MessageResources.getMessageEnglish("prompt.reminder.message2")+"</b></td></tr>");
				commentStr.append("<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+MessageResources.getMessageSimplifiedChinese("prompt.reminder.message3")+" "+ MessageResources.getMessageEnglish("prompt.reminder.message3")+"</b></td></tr>");
				commentStr.append("<tr><td><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+MessageResources.getMessageSimplifiedChinese("prompt.computerCopyOnly")+" "+ MessageResources.getMessageEnglish("prompt.computerCopyOnly")+"</b></td></tr>");
				commentStr.append("</table><br>");
				commentStr.append("<li>Important Information<ul><li>"+ MessageResources.getMessageEnglish("label.registration.form")+MessageResources.getMessageTraditionalChinese("label.registration.form") +"(<a href=\"file://hkim/im/Patients Accounts/Staff share/PBO/External Form/Registration Form/Registration Form.pdf \" target=\"_blank\">"+
									MessageResources.getMessageEnglish("label.click.here")+MessageResources.getMessageTraditionalChinese("label.click.here")+"</a>)</li>");
				commentStr.append("<li>"+MessageResources.getMessageEnglish("label.patient.admission")+MessageResources.getMessageTraditionalChinese("label.patient.admission")+"(<a href=\"javascript:void(0);\" onclick=\"downloadFile('76');return false;\" target=\"_blank\">"+
									MessageResources.getMessageEnglish("label.click.here") + MessageResources.getMessageTraditionalChinese("label.click.here")+"</a>)</li>");
				commentStr.append("<li>"+MessageResources.getMessageEnglish("label.patients.charter")+MessageResources.getMessageTraditionalChinese("label.patients.charter")+"(<a href=\"http://www.hkah.org.hk/new/eng/download/Patient_Charter.pdf\" target=\"_blank\">"+
									MessageResources.getMessageEnglish("label.click.here")+ MessageResources.getMessageTraditionalChinese("label.click.here")+"</a>)</li>");
				commentStr.append("<li>"+MessageResources.getMessageEnglish("label.why.vegetarian.diet")+MessageResources.getMessageTraditionalChinese("label.why.vegetarian.diet")+"(<a href=\"http://www.hkah.org.hk/new/eng/download/Why_Vegetarian_Diet.pdf\" target=\"_blank\">"+
									MessageResources.getMessageEnglish("label.click.here")+ MessageResources.getMessageTraditionalChinese("label.click.here")+"</a>)</li>");
				commentStr.append("<li>"+MessageResources.getMessageEnglish("label.health.care.advisory")+MessageResources.getMessageTraditionalChinese("label.health.care.advisory")+"(<a href=\"\" target=\"_blank\">"+
									MessageResources.getMessageEnglish("label.click.here")+ MessageResources.getMessageTraditionalChinese("label.click.here")+"</a>)</li>");
				commentStr.append("<li>"+MessageResources.getMessageEnglish("label.daily.room.rate")+MessageResources.getMessageTraditionalChinese("label.daily.room.rate")+
									"<a href=\"http://www.hkah.org.hk/new/eng/hospitalization_fi.htm\" target=\"_blank\">("+MessageResources.getMessageEnglish("label.english.version")+
									MessageResources.getMessageTraditionalChinese("label.english.version")+"</a>"+MessageResources.getMessageEnglish("label.or")+MessageResources.getMessageTraditionalChinese("label.or")+
									"<a href=\"http://www.hkah.org.hk/new/chi/hospitalization_fi.htm\" target=\"_blank\">"+MessageResources.getMessageEnglish("label.chinese.version")+
									MessageResources.getMessageTraditionalChinese("label.chinese.version")+")</a></li>");
				commentStr.append("<li>"+MessageResources.getMessageEnglish("label.pre-anaesthesia.questionnaire")+MessageResources.getMessageTraditionalChinese("label.pre-anaesthesia.questionnaire")+"(<a href=\"\" target=\"_blank\">"+
									MessageResources.getMessageEnglish("label.click.here")+ MessageResources.getMessageTraditionalChinese("label.click.here")+"</a>)</li>");
				commentStr.append("<li>"+MessageResources.getMessageEnglish("label.renovation.letter")+MessageResources.getMessageTraditionalChinese("label.renovation.letter")+
						"<a href=\"\"_blank\">("+MessageResources.getMessageEnglish("label.english.version")+
						MessageResources.getMessageTraditionalChinese("label.english.version")+"</a>"+MessageResources.getMessageEnglish("label.or")+MessageResources.getMessageTraditionalChinese("label.or")+
						"<a href=\"\" target=\"_blank\">"+MessageResources.getMessageEnglish("label.chinese.version")+
						MessageResources.getMessageTraditionalChinese("label.chinese.version")+")</a></li>");
				UtilMail.sendMail(
						"admission@hkah.org.hk",
						new String[] { ""},
						null,
						null,
						"testing",
						commentStr.toString());
			}
		}
		return true;
	}

	public static boolean generateInPatientLetter(UserBean userBean, String clientID, String filename) {
		// generate pdf
		try {
			InPatientLetter.toXMLfile(
					get(userBean, clientID),
					ConstantsServerSide.UPLOAD_WEB_FOLDER + "/GHC/" + clientID + "/" + filename + ".fo");
			return true;
		} catch (Exception e) {}
		return false;
	}

	private static String getEmailComment(String clientID, String comment) {
		// append url
		StringBuffer commentStr = new StringBuffer();
		if (comment != null && comment.length() > 0) {
			commentStr.append(comment);
			commentStr.append("<br>");
		}
		commentStr.append("<br>Please click <a href=\"http://");
		commentStr.append(ConstantsServerSide.INTRANET_URL);
		commentStr.append("/intranet/ghc/apply.jsp?command=view&clientID=");
		commentStr.append(clientID);
		commentStr.append("\">Intranet</a> or <a href=\"https://");
		commentStr.append(ConstantsServerSide.OFFSITE_URL);
		commentStr.append("/intranet/pmp/summary.jsp?command=view&clientID=");
		commentStr.append(clientID);
		commentStr.append("\">Offsite</a> to view the summary.");

		return commentStr.toString();
	}

	private static String getModuleCode(String specialtyCode, int stage) {
		StringBuffer moduleCodeStr = new StringBuffer();
		moduleCodeStr.append("ghc.");
		if (stage >= 0) {
			moduleCodeStr.append(specialtyCode);
			moduleCodeStr.append(ConstantsVariable.MINUS_VALUE);
			moduleCodeStr.append(stage);
		} else {
			moduleCodeStr.append("acknowledge");
		}
		return moduleCodeStr.toString();
	}

	private static void sendEmail(UserBean userBean, String clientID, String title, int stage) {
		String clientName = null;
		String specialtyCode = null;

		ArrayList<ReportableListObject> record = get(userBean, clientID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			clientName = row.getValue(1) + " " + row.getValue(2);
			specialtyCode = row.getValue(15);
		}
		if (clientName == null) {
			clientName = "anonymous";
		}

		String topic =  "[GHC Client] Update (" + clientName + ") " + title + " by Rachel";

		sendEmail(clientID, getModuleCode(specialtyCode, stage), topic);
	}

	private static void sendEmail(UserBean userBean, String clientID, String specialtyCode, int stage, boolean rollback) {
		String clientName = null;
		String ackDate = null;
		String approvalUser = null;

		ArrayList<ReportableListObject> record = get(userBean, clientID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			clientName = row.getValue(1) + " " + row.getValue(2);
			ackDate = row.getValue(99);
			approvalUser = row.getValue(97);
			if (ackDate == null || ackDate.length() == 0
					|| approvalUser == null || approvalUser.length() == 0) {
				// if not approval, stage is zero
				stage = 0;
			}
		}
		if (clientName == null) {
			clientName = "anonymous";
		}

		String status = null;
		if (rollback) {
			status = "reject";
		} else {
			status = "submit";
		}
		String topic =  "[GHC Client] Update (" + clientName + ") " + status + " in step " + stage;

		sendEmail(clientID, getModuleCode(specialtyCode, stage), topic);
	}

	private static void sendEmail(String clientID, String moduleCode, String topic) {
		EmailAlertDB.sendEmail(moduleCode, topic, getEmailComment(clientID, null));
	}

	private static void sendEmail(UserBean userBean, String clientID, String topicDesc, String requestTo, String comment, String skipGHC) {
		// append url
		comment = getEmailComment(clientID, comment);

		String emailFrom = "alert@hkah.org.hk";
		String[] emailCC = null;
		String[] emailBCC = new String [] { ConstantsServerSide.MAIL_ADMIN };

		ArrayList<ReportableListObject> record = get(userBean, clientID);
		String specialtyCode = null;
		String attendingDoctor = null;
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			specialtyCode = row.getValue(8);
			attendingDoctor = row.getValue(9);
		}

		boolean sendToAllGroup = "hkah".equals(requestTo) || "ghc".equals(requestTo);

		Vector emailToVector = new Vector();
		if (sendToAllGroup) {
			emailToVector.add("rachel.yeung@hkah.org.hk");
			emailToVector.add("brenda_mak@hkah.org.hk");
			if (!ConstantsVariable.YES_VALUE.equals(skipGHC)) {
				emailToVector.add("susan.wang@ghcchina.com");
			}
		}

		if ((sendToAllGroup && "ob".equals(specialtyCode)) || (!sendToAllGroup && "ob".equals(requestTo))) {
			emailToVector.add("angela.chan@hkah.org.hk");
			emailToVector.add("Becky_Yau@hkah.org.hk");
			emailToVector.add("isabelle.leung@hkah.org.hk");
		} else if ((sendToAllGroup && "surgical".equals(specialtyCode)) || (!sendToAllGroup && "surgical".equals(requestTo))) {
			emailToVector.add("clara.leung@hkah.org.hk");
			emailToVector.add("Becky_Yau@hkah.org.hk");
			emailToVector.add("isabelle.leung@hkah.org.hk");
			if ("DR. KWOK, PO YIN SAMUEL".equals(attendingDoctor)) {
				emailToVector.add("pa1@pedderclinic.hk");
			}
		} else if ((sendToAllGroup && "ha".equals(specialtyCode)) || (!sendToAllGroup && "ha".equals(requestTo))) {
			emailToVector.add("barbara.lam@hkah.org.hk");
			emailToVector.add("Becky_Yau@hkah.org.hk");
			emailToVector.add("isabelle.leung@hkah.org.hk");
		} else if ((sendToAllGroup && "cardiac".equals(specialtyCode)) || (!sendToAllGroup && "cardiac".equals(requestTo))) {
			emailToVector.add("maggie.wong@hkah.org.hk");
			emailToVector.add("camille.ho@hkah.org.hk");
		} else if ((sendToAllGroup && "oncology".equals(specialtyCode)) || (!sendToAllGroup && "oncology".equals(requestTo))) {
			emailToVector.add("mri@hkah.org.hk");
		} else if (!sendToAllGroup) {
			emailToVector.add(requestTo);
		}

		String[] emailTo = (String[]) emailToVector.toArray(new String[emailToVector.size()]);

		// send email for alert
		UtilMail.sendMail(
				emailFrom,
				emailTo,
				emailCC,
				emailBCC,
				"[GHC Client] " + topicDesc,
				comment);
	}

	public static boolean insertComment(UserBean userBean, String clientID, String topicDesc, String requestTo, String comment, String skipGHC) {
		// get next client ID
		String commentID = getNextCommentID(clientID);

		// set default to N if empty
		if (skipGHC == null || skipGHC.length() == 0) {
			skipGHC = ConstantsVariable.NO_VALUE;
		}

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertComment,
				new String[] {
						clientID, commentID, topicDesc, comment,
						requestTo, skipGHC, userBean.getLoginID(), userBean.getLoginID() })) {
			sendEmail(userBean, clientID, topicDesc, requestTo, comment, skipGHC);
		}
		return true;
	}

	public static ArrayList<ReportableListObject> getCommentList(UserBean userBean, String clientID) {
		if (userBean.isAccessible("function.ghc.client.create")) {
			return UtilDBWeb.getReportableList(sqlStr_getCommentList4GHC, new String[] { clientID });
		} else {
			return UtilDBWeb.getReportableList(sqlStr_getCommentList, new String[] { clientID });
		}
	}

	public static boolean acknowledgement(UserBean userBean, String clientID) {
		// approval client
		if (UtilDBWeb.updateQueue(
				sqlStr_acknowledgementClient,
				new String[] { userBean.getLoginID(), clientID } )) {
			sendEmail(userBean, clientID, "Acknowledged", -1);
			return true;
		} else {
			return false;
		}
	}

	public static boolean approval(UserBean userBean, String clientID) {
		// approval client
		if (UtilDBWeb.updateQueue(
				sqlStr_approvalClient,
				new String[] { userBean.getLoginID(), clientID } )) {
			sendEmail(userBean, clientID, "Approved", 1);
			return true;
		} else {
			return false;
		}
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO GHC_CLIENTS ");
		sqlStr.append("(GHC_CLIENT_ID, ");
		sqlStr.append(" GHC_CREATED_USER, GHC_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ");
		sqlStr.append(" ?, ?)");
		sqlStr_insertClient = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE GHC_CLIENTS ");
		sqlStr.append("SET    GHC_ENABLED = 0, GHC_MODIFIED_DATE = SYSDATE, GHC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		sqlStr.append("AND    GHC_CLIENT_ID = ?");
		sqlStr_deleteClient = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO GHC_CLIENT_REJECTDATE ");
		sqlStr.append("(GHC_CLIENT_ID, ");
		sqlStr.append(" GHC_REQUEST_APPOINTDATE, ");
		sqlStr.append(" GHC_CREATED_USER, GHC_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ");
		sqlStr.append(" TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" ?, ?)");
		sqlStr_insertRejectDate = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT GHC_PATIENT_ID, ");
		sqlStr.append("       GHC_LASTNAME, GHC_FIRSTNAME, GHC_CHINESENAME, ");
		sqlStr.append("       GHC_EMAIL, TO_CHAR(GHC_DOB, 'DD/MM/YYYY'), GHC_TRAVEL_NO, ");
		sqlStr.append("       GHC_KIN_LASTNAME, GHC_KIN_FIRSTNAME, GHC_KIN_CHINESENAME, ");
		sqlStr.append("       GHC_KIN_EMAIL, TO_CHAR(GHC_KIN_DOB, 'DD/MM/YYYY'), GHC_KIN_TRAVEL_NO, ");
		sqlStr.append("       GHC_HOME_NUMBER, GHC_MOBILE_NUMBER, GHC_SPECIALTY, GHC_ATTENDING_DOCTOR, ");
		sqlStr.append("       TO_CHAR(GHC_EXPECTED_DELIVERYDATE, 'DD/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(GHC_REQUEST_APPOINTDATE1, 'DD/MM/YYYY'), TO_CHAR(GHC_REQUEST_APPOINTDATE2, 'DD/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(GHC_REQUEST_APPOINTDATE3, 'DD/MM/YYYY'), TO_CHAR(GHC_REQUEST_APPOINTDATE4, 'DD/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(GHC_CONFIRM_APPOINTDATE1, 'DD/MM/YYYY HH24:MI'), TO_CHAR(GHC_CONFIRM_APPOINTDATE2, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(GHC_CONFIRM_APPOINTDATE3, 'DD/MM/YYYY HH24:MI'), TO_CHAR(GHC_CONFIRM_APPOINTDATE4, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("       GHC_ACCEPT_APPOINTDATE1, GHC_ACCEPT_APPOINTDATE2, ");
		sqlStr.append("       GHC_ACCEPT_APPOINTDATE3, GHC_ACCEPT_APPOINTDATE4, ");
		sqlStr.append("       GHC_ACKNOWLEDGE_APPOINTDATE1, GHC_ACKNOWLEDGE_APPOINTDATE2, ");
		sqlStr.append("       GHC_ACKNOWLEDGE_APPOINTDATE3, GHC_ACKNOWLEDGE_APPOINTDATE4, ");
		sqlStr.append("       TO_CHAR(GHC_ARRIVAL_DATE1, 'DD/MM/YYYY'), GHC_FLIGHT_INFO1, ");
		sqlStr.append("       GHC_TRANSPORT_METHOD1, GHC_TRANSPORT_ARRANGEBY1, GHC_HOTAL_INFO1, GHC_HOTAL_ARRANGEBY1, ");
		sqlStr.append("       TO_CHAR(GHC_REMINDER_LETTER_DATE1, 'DD/MM/YYYY'), TO_CHAR(GHC_REMINDER_DATE1, 'DD/MM/YYYY'), GHC_REMINDER_METHOD1, GHC_REMINDER_REMARK1, ");
		sqlStr.append("       TO_CHAR(GHC_ARRIVAL_DATE2, 'DD/MM/YYYY'), GHC_FLIGHT_INFO2, ");
		sqlStr.append("       GHC_TRANSPORT_METHOD2, GHC_TRANSPORT_ARRANGEBY2, GHC_HOTAL_INFO2, GHC_HOTAL_ARRANGEBY2, ");
		sqlStr.append("       TO_CHAR(GHC_REMINDER_LETTER_DATE2, 'DD/MM/YYYY'), TO_CHAR(GHC_REMINDER_DATE2, 'DD/MM/YYYY'), GHC_REMINDER_METHOD2, GHC_REMINDER_REMARK2, ");
		sqlStr.append("       TO_CHAR(GHC_CONFIRM_DELIVERY_DATE, 'DD/MM/YYYY'), GHC_PREBOOKING_CONFIRM_NO, ");
		sqlStr.append("       GHC_PAY_SLIP_NO, TO_CHAR(GHC_PAY_SLIP_DATE, 'DD/MM/YYYY'), TO_CHAR(GHC_CERT_ISSUE_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("       GHC_INSURANCE_YN, GHC_INSURANCE_COMPANY_ID, GHC_INSURANCE_COMPANY_NAME, GHC_INSURANCE_POLICY_NO, GHC_INSURANCE_POLICYHOLDERNAME, GHC_INSURANCE_POLICY_GROUP, GHC_INSURANCE_VALID_THRU, ");
		sqlStr.append("       GHC_APPOINTED_CLASS, TO_CHAR(GHC_ADMISSION_DATE, 'DD/MM/YYYY HH24:MI'), GHC_SURGERY_INFO, GHC_TYPE_OF_DIAGNOSIS, GHC_TYPE_OF_ANAESTHESIA, GHC_NAME_OF_PROCEDURE, TO_CHAR(GHC_ONSETDATE_OF_SYMPTOMS, 'DD/MM/YYYY'), GHC_TREATMENT_PLAN, GHC_ESTIMATED_LENGTH_OF_STAY, ");
		sqlStr.append("       GHC_SURGEON_FEE, GHC_WARD_ROUND_FEE, GHC_ANAESTHETIST_FEE, GHC_PROCEDURE_FEE, GHC_PROCEDURE_FEE_ADDITIONAL, ");
		sqlStr.append("       GHC_CONFIRM_PATIENT, GHC_CONFIRMED_CLASS, ");
		sqlStr.append("       GHC_REMARK_HKAH1, GHC_REMARK_HKAH2, GHC_REMARK_HKAH3, GHC_REMARK_HKAH4, GHC_REMARK_HKAH5, ");
		sqlStr.append("       GHC_REMARK_GHC1, GHC_REMARK_GHC2, GHC_REMARK_GHC3, GHC_REMARK_GHC4, GHC_REMARK_GHC5, ");
		sqlStr.append("       GHC_STAGE, GHC_STATUS, ");
		sqlStr.append("       TO_CHAR(GHC_ACKNOWLEDGE_DATE, 'DD/MM/YYYY HH24:MI'), GHC_ACKNOWLEDGE_USER, ");
		sqlStr.append("       TO_CHAR(GHC_APPROVAL_DATE, 'DD/MM/YYYY HH24:MI'), GHC_APPROVAL_USER, ");
		sqlStr.append("       TO_CHAR(GHC_CREATED_DATE, 'DD/MM/YYYY HH24:MI'), GHC_CREATED_USER, ");
		sqlStr.append("       TO_CHAR(GHC_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI'), GHC_MODIFIED_USER ");
		sqlStr.append("FROM   GHC_CLIENTS ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		sqlStr.append("AND    GHC_CLIENT_ID = ? ");
		sqlStr_getClient = sqlStr.toString();

		sqlStr.append("AND    GHC_ATTENDING_DOCTOR = ? ");
		sqlStr_getClientWithDoctorName = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO GHC_COMMENTS ");
		sqlStr.append("(GHC_CLIENT_ID, GHC_COMMENT_ID, GHC_TOPIC_DESC, GHC_COMMENT_DESC, ");
		sqlStr.append(" GHC_INVOLVE_USER_ID, GHC_SKIP, GHC_CREATED_USER, GHC_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ");
		sqlStr.append(" ?, ?, ?, ?)");
		sqlStr_insertComment = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT GHC_COMMENT_ID, GHC_TOPIC_DESC, GHC_COMMENT_DESC, GHC_INVOLVE_USER_ID, ");
		sqlStr.append("       TO_CHAR(GHC_CREATED_DATE, 'DD/MM/YYYY HH24:MI'), GHC_CREATED_USER, ");
		sqlStr.append("       TO_CHAR(GHC_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI'), GHC_MODIFIED_USER ");
		sqlStr.append("FROM   GHC_COMMENTS ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		sqlStr.append("AND    GHC_CLIENT_ID = ? ");
		sqlStr.append("ORDER BY GHC_COMMENT_ID DESC ");
		sqlStr_getCommentList = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT GHC_COMMENT_ID, GHC_TOPIC_DESC, GHC_COMMENT_DESC, GHC_INVOLVE_USER_ID, ");
		sqlStr.append("       TO_CHAR(GHC_CREATED_DATE, 'DD/MM/YYYY HH24:MI'), GHC_CREATED_USER, ");
		sqlStr.append("       TO_CHAR(GHC_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI'), GHC_MODIFIED_USER ");
		sqlStr.append("FROM   GHC_COMMENTS ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		sqlStr.append("AND    GHC_CLIENT_ID = ? ");
		sqlStr.append("AND    GHC_SKIP = 'N' ");
		sqlStr.append("ORDER BY GHC_COMMENT_ID DESC ");
		sqlStr_getCommentList4GHC = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE GHC_CLIENTS ");
		sqlStr.append("SET    GHC_ACKNOWLEDGE_DATE = SYSDATE, GHC_ACKNOWLEDGE_USER = ? ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		sqlStr.append("AND    GHC_CLIENT_ID = ? ");
		sqlStr.append("AND    GHC_ACKNOWLEDGE_DATE IS NULL");
		sqlStr_acknowledgementClient = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE GHC_CLIENTS ");
		sqlStr.append("SET    GHC_APPROVAL_DATE = SYSDATE, GHC_APPROVAL_USER = ? ");
		sqlStr.append("WHERE  GHC_ENABLED = 1 ");
		sqlStr.append("AND    GHC_CLIENT_ID = ? ");
		sqlStr.append("AND    GHC_APPROVAL_DATE IS NULL");
		sqlStr_approvalClient = sqlStr.toString();
	}
}