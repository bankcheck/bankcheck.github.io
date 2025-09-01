package com.hkah.web.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.ApprovalUserDB;
import com.hkah.web.db.CTS;

public class CTSController extends AbstractController  {

	protected final Log logger = LogFactory.getLog(getClass());
//	private static String serverSiteCode = ConstantsServerSide.SITE_CODE;

	private String requestName;

	public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

		if ("info_list".equals(getRequestName()) ) {
			return getInfoList(request, response);
		} else if ("info_newList".equals(getRequestName())) {
			return getInfoList(request, response);
		} else if ("waitApp_list".equals(getRequestName())) {
			return getWaitAppList(request, response);
		} else {
			return null;
		}
	}

	private ModelAndView getInfoList(HttpServletRequest request, HttpServletResponse response) {
//		HttpSession session = request.getSession();

		UserBean userBean = new UserBean(request);
//		String loginStaffID = userBean.getStaffID();
		String command = request.getParameter("command");
		String as_ctsNo = request.getParameter("ctsNo");
		String as_docNo = request.getParameter("docNo");
		String as_recType = request.getParameter("recType");
		String as_recStatus = request.getParameter("recStatus");
		String as_rdStatus = request.getParameter("rdStatus");
//		System.err.println("[as_rdStatus]:" + as_rdStatus);
//		System.err.println("[CTSController][as_recStatus]:" + as_recStatus);
		String as_docFname = request.getParameter("docfName");
		String as_docGname = request.getParameter("docgName");
		String search = request.getParameter("search");
//		String[] appCode = request.getParameterValues("sendAppTo");
		String assignDoc = request.getParameter("assignDoc");
		ArrayList tableList = null;
		String formId = "F0001";

		String pageName = request.getParameter("pageName");
//		System.err.println("1[pageName]:"+pageName+";[command]:"+command+";[search]:"+search);

//		String title = null;
//		String message = "";
		String errorMessage = "";

		if ("submit".equals(command)) {
			if ("cts/newRecordList".equals(pageName)) {
//				System.err.println("1.1[pageName]:"+pageName+";[as_ctsNo]:" + as_ctsNo+";[as_recStatus]:" + as_recStatus);

				if (CTS.updateNewCtsStatus(userBean, as_ctsNo, as_recStatus)) {
//					System.err.println("1.2[pageName]:"+pageName);
					tableList = CTS.getNewCTSRecord(as_docNo, as_recType, as_rdStatus, as_docFname, as_docGname);
					if ("X".equals(as_recStatus) || "Y".equals(as_recStatus) || "Z".equals(as_recStatus )||
							"I".equals(as_recStatus ) || "L".equals(as_recStatus ) || "K".equals(as_recStatus )) {
//						System.err.println("[as_ctsNo]:" + as_ctsNo+";[as_recStatus]:" + as_recStatus);
						ArrayList questList = CTS.getformQuest(formId,as_ctsNo);
						if (questList.size() == 0) {
							if (CTS.createFormQuestion(as_ctsNo)) {
								System.err.println("true" + as_ctsNo);
							} else {
								System.err.println("false" + as_ctsNo);
							}
						}

						if ("I".equals(as_recStatus ) || "L".equals(as_recStatus ) || "K".equals(as_recStatus )) {
							if (CTS.generateCoverLetter(userBean, as_ctsNo, "letter1")) {
								System.err.println("cover letter pdf generate success");
							} else {
								System.err.println("cover letter pdf generate fail");
							}
						} else if ("J".equals(as_recStatus )) {
							if (CTS.generateInactLetter(userBean, as_ctsNo, "letter2")) {
								System.err.println("inactive letter pdf generate success");
							} else {
								System.err.println("inactive letter pdf generate fail");
							}
						}
//            				} else if ("V".equals(as_recStatus) && "twah".equals(serverSiteCode)) {
					} else if ("V".equals(as_recStatus)) {
						if (CTS.createGrAppRecord(as_ctsNo)) {
							System.err.println("1[createGrAppRecord]" + as_ctsNo);
						} else {
							System.err.println("2[createGrAppRecord]" + as_ctsNo);
						}
					}
				} else {
					errorMessage = "Record update fail.";
				}
			} else {
				if (CTS.updateCtsRecordList(userBean, as_ctsNo, as_recStatus, null, null, null)) {
					tableList = CTS.getRecord(as_docNo, as_recType, as_rdStatus, as_docFname, as_docGname);
					if ("X".equals(as_recStatus) || "Y".equals(as_recStatus) || "Z".equals(as_recStatus )||
							"I".equals(as_recStatus ) || "L".equals(as_recStatus ) || "K".equals(as_recStatus )) {
//						System.err.println("[as_ctsNo]:" + as_ctsNo+";[as_recStatus]:" + as_recStatus);
						ArrayList questList = CTS.getformQuest(formId,as_ctsNo);
						if (questList.size() == 0) {
							if (CTS.createFormQuestion(as_ctsNo)) {
								System.err.println("true" + as_ctsNo);
							} else {
								System.err.println("false" + as_ctsNo);
							}
						}

						if ("I".equals(as_recStatus ) || "L".equals(as_recStatus ) || "K".equals(as_recStatus )) {
							if (CTS.generateCoverLetter(userBean, as_ctsNo, "letter1")) {
								System.err.println("cover letter pdf generate success");
							} else {
								System.err.println("cover letter pdf generate fail");
							}
						} else if ("J".equals(as_recStatus )) {
							if (CTS.generateInactLetter(userBean, as_ctsNo, "letter2")) {
								System.err.println("inactive letter pdf generate success");
							} else {
								System.err.println("inactive letter pdf generate fail");
							}
						}
//	            			} else if ("V".equals(as_recStatus) && "twah".equals(serverSiteCode)) {
					} else if ("V".equals(as_recStatus)) {
						if (CTS.createGrAppRecord(as_ctsNo)) {
							System.err.println("1[createGrAppRecord]" + as_ctsNo);
						} else {
							System.err.println("2[createGrAppRecord]" + as_ctsNo);
						}
					}
				} else {
					errorMessage = "Record update fail.";
				}
			}
		} else if ("genlist".equals(command)) {
			CTS.genRenewDocList("proc_getRenewDocList()");
			CTS.genRenewDocList("proc_getrenewdoclistmiss()");
			CTS.genRenewDocList("proc_get_inactive_list()");
			tableList = CTS.getRecord(as_docNo, as_recType, as_rdStatus, as_docFname, as_docGname);
		} else if ("pdf".equals(command)) {
			if (CTS.generateInactLetter(userBean, as_ctsNo, "letter2")) {
				System.err.println("pdf generate success");
			} else {
				System.err.println("pdf generate fail");
			}
		} else if ("urgent".equals(command)) {
			CTS.urgentSendMail();
		} else if ("assign".equals(command)) {
			if (CTS.ctsAssignDoc(as_ctsNo, assignDoc)) {
				System.err.println("Doctor assign success");

				CTS.ctsAssignDocReset(as_ctsNo);

				if ("ALL".equals(assignDoc)) {
					ArrayList record = ApprovalUserDB.getCtsApprover(null);
					ReportableListObject row = null;
					for (int i = 0 ; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						CTS.ctsAssignDocMultiple(as_ctsNo, row.getValue(0));
						CTS.notifyDoctorSendMail(row.getValue(0));
					}
				} else {
					CTS.notifyDoctorSendMail(assignDoc);
				}
			} else {
				System.err.println("Doctor assign fail");
			}
		}

		if (search != null) {
			if ("recordListTwah2".equals(pageName)) {
				tableList = CTS.getRecordWithApp(as_docNo, as_recType, as_rdStatus, as_docFname, as_docGname);
			} else if ("cts/newRecordList".equals(pageName)) {
				tableList = CTS.getNewCTSRecord(as_docNo, as_recType, as_rdStatus, as_docFname, as_docGname);
			} else {
				tableList = CTS.getRecord(as_docNo, as_recType, as_rdStatus, as_docFname, as_docGname);
			}
		}

		Map<String, Object> model = new HashMap<String, Object>();
		model.put("table", tableList);

		if (("recordListTwah".equals(pageName))) {
			pageName = "cts/recordListTwah";
		} else if (("recordListTwah2".equals(pageName))) {
			pageName = "cts/recordListTwah2";
		} else if (("cts/newRecordList".equals(pageName))) {
			pageName = "cts/newRecordList";
		} else {
			pageName = "cts/recordList2";
		}
		return new ModelAndView(pageName, "cts", model);
	}

	private ModelAndView getWaitAppList(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();

		UserBean userBean = new UserBean(request);
		String loginStaffID = userBean.getStaffID();
		String command = request.getParameter("command");
		String as_ctsNo = request.getParameter("ctsNo");
		String as_approver = request.getParameter("approver");
		String as_docNo = request.getParameter("docNo");
		String as_recType = request.getParameter("recType");
		String as_recStatus = request.getParameter("recStatus");
		String as_rdStatus = request.getParameter("rdStatus");
		String as_docFname = request.getParameter("docfName");
		String as_docGname = request.getParameter("docgName");
		String search = request.getParameter("search");
		String[] appCode = request.getParameterValues("sendAppTo");
		String assignDoc = request.getParameter("assignDoc");
		String remarks = request.getParameter("remarks");
		ArrayList tableList = null;

		String title = null;
		String message = "";
		String errorMessage = "";

		if ("approve".equals(command)) {
			if (CTS.approveCtsRecord(userBean, as_ctsNo, as_approver)) {
				System.err.println("Approve success of " + as_ctsNo);
			} else {
				System.err.println("Approve fail of" + as_ctsNo);
			}
		} else if ("reject".equals(command)) {
			if (CTS.rejectCtsRecord(userBean, as_ctsNo, as_approver, remarks)) {
				System.err.println("Reject success of " + as_ctsNo);
			} else {
				System.err.println("Reject fail of" + as_ctsNo);
			}
		} else if ("view".equals(command)) {
			tableList = CTS.getWaitAppDoc(as_approver, as_docNo, as_recType, as_rdStatus, as_docFname, as_docGname);
			ArrayList record = CTS.getDocList1(as_approver);
				ReportableListObject row = (ReportableListObject) record.get(0);
				as_docFname = row.getValue(1);
				as_docGname = row.getValue(2);
		}

		if (search != null) {
			tableList = CTS.getWaitAppDoc(as_approver, as_docNo, as_recType, as_rdStatus, as_docFname, as_docGname);
			ArrayList record = CTS.getDocList1(as_approver);
				ReportableListObject row = (ReportableListObject) record.get(0);
				as_docFname = row.getValue(1);
				as_docGname = row.getValue(2);
		}

		Map<String, Object> model = new HashMap<String, Object>();
		model.put("table", tableList);
		model.put("docFname", as_docFname);
		model.put("docGname", as_docGname);

		return new ModelAndView("cts/docAgnRecordList", "cts", model);
	}

	public String getRequestName() {
		return requestName;
	}

	public void setRequestName(String requestName) {
		this.requestName = requestName;
	}
}
