<%@ page import="com.hkah.web.common.UserBean"
%><%@ page import="com.hkah.util.ParserUtil"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ page import="com.hkah.util.mail.UtilMail"
%><%@ page import="com.hkah.util.sms.UtilSMS"
%><%@ page import="com.hkah.constant.ConstantsServerSide"
%><%@ page import="com.hkah.web.common.ReportableListObject"
%><%@ page import="com.hkah.config.MessageResources"
%><%
UserBean userBean = new UserBean(request);
boolean success = true;

String as_mode = request.getParameter("mode");
String as_ctsNo = request.getParameter("ctsNo");
String as_docCode = request.getParameter("docCode");
String as_recStatus = request.getParameter("recStatus");

String formId = "F0001";

if ("DOCTOR".equals(as_mode)) {
	if ("A".equals(as_recStatus)) {
		success = CTS.approveCtsRecord(userBean, as_ctsNo, as_docCode);
	} else if ("R".equals(as_recStatus)) {
		success = CTS.rejectCtsRecord(userBean, as_ctsNo, as_docCode, null);
	}
} else if ("VPMA".equals(as_mode) && CTS.updateCtsRecordList(userBean, as_ctsNo, as_recStatus, null, null, null)) {
	if ("X".equals(as_recStatus) ||
			"Y".equals(as_recStatus) ||
			"Z".equals(as_recStatus ) ||
			"I".equals(as_recStatus ) ||
			"L".equals(as_recStatus ) ||
			"K".equals(as_recStatus )) {
		ArrayList questList = CTS.getformQuest(formId, as_ctsNo);
		if (questList.size() == 0) {
			if (!CTS.createFormQuestion(as_ctsNo)) {
				success = false;
			}
		}

		if ("I".equals(as_recStatus ) || "L".equals(as_recStatus ) || "K".equals(as_recStatus )) {
			if (!CTS.generateCoverLetter(userBean, as_ctsNo, "letter1")) {
				success = false;
			}
		} else if ("J".equals(as_recStatus )) {
			if (!CTS.generateInactLetter(userBean, as_ctsNo, "letter2")) {
				success = false;
			}
		}
	}
} else {
	success = false;
}
%><%=success%>