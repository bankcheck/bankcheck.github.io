<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%
UserBean userBean = new UserBean(request);
String staffID = userBean.getStaffID();
String siteCode = request.getParameter("siteCode");
String deptCode = request.getParameter("deptCode");
String deptHead = request.getParameter("deptHead");
String subHead = request.getParameter("subHead");
String staffNurse = request.getParameter("staffNurse");
String value = request.getParameter("value");
String category = request.getParameter("category");
String level = request.getParameter("level");

// parameters for option filtering
boolean isFilterValues = ConstantsVariable.YES_VALUE.equals(request.getParameter("isFilterValues"));
String[] filterValues = null;
if (isFilterValues) {
	filterValues = (String[]) request.getAttribute("staffIDCMB_filterValues");
}

boolean ignoreCurrentStaffID = ConstantsVariable.YES_VALUE.equals(request.getParameter("ignoreCurrentStaffID"));
boolean onlyCurrentStaffID = ConstantsVariable.YES_VALUE.equals(request.getParameter("onlyCurrentStaffID"));
boolean allowEmpty = ConstantsVariable.YES_VALUE.equals(request.getParameter("allowEmpty"));
boolean allowAll = ConstantsVariable.YES_VALUE.equals(request.getParameter("allowAll"));
boolean showDeptDesc = !ConstantsVariable.NO_VALUE.equals(request.getParameter("showDeptDesc"));
boolean showStaffID = ConstantsVariable.YES_VALUE.equals(request.getParameter("showStaffID"));
boolean showAdminOnly = ConstantsVariable.YES_VALUE.equals(request.getParameter("showAdminOnly"));
boolean showFT = ConstantsVariable.YES_VALUE.equals(request.getParameter("showFT"));
boolean showStaffName = ConstantsVariable.YES_VALUE.equals(request.getParameter("showStaffName"));
boolean isSilverStar = ConstantsVariable.YES_VALUE.equals(request.getParameter("isSilverStar"));
boolean hideVolunteer = ConstantsVariable.YES_VALUE.equals(request.getParameter("hideVolunteer"));
boolean hideDoctorForOutpatientNursing = ConstantsVariable.YES_VALUE.equals(request.getParameter("hideDoctorForOutpatientNursing"));
boolean hideDummyUser = ConstantsVariable.YES_VALUE.equals(request.getParameter("hideDummyUser"));
if (showAdminOnly) {
	// manager level
	level = ConstantsVariable.SIX_VALUE;
}

// set default dept code if empty
if ((deptCode == null || deptCode.length() == 0) && !allowAll && !userBean.isEducationManager()) {
	deptCode = userBean.getDeptCode();
}

if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Staff ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = null;
if ("nominee".equals(category)) {
	if (isSilverStar) {
		record = StaffDB.getList(siteCode, deptCode, null, null, level, 0, true);
	} else {
		record = EmployeeVoteDB.getNomineeList(deptCode);
	}
} else if ("eleave".equals(category)) {
	record = ELeaveDB.getELStaffByDept(deptCode);
} else if ("Y".equals(deptHead) && !"Y".equals(subHead)) {
	record = StaffDB.getdHeadList(siteCode, null, null, null, level, 0, true);
} else if ("Y".equals(deptHead) && "Y".equals(subHead)) {
	record = StaffDB.getdHeadSubHeadList(siteCode, null, null, null, level, 0, true);
} else if ("Y".equals(staffNurse)) {
	record = StaffDB.getStaffNurse(0);
} else {
	if (ConstantsServerSide.isTWAH()) {
		if (showStaffName) {
			record = StaffDB.getList(siteCode, deptCode, null, null, level, 3);
		} else {
			record = StaffDB.getList(siteCode, deptCode, null, null, level, 2);
		}
	} else if (showFT){
		record = StaffDB.getList(siteCode, deptCode, null, null, level, 2, showFT);
	} else {
		record = StaffDB.getList(siteCode, deptCode, level);
	}
}

ReportableListObject row = null;
String userID = null;
String userName = null;
String deptDesc = null;
String hireDate = null;
String email = null;
String displayPhoto = null;
if (record.size() > 0) {
	boolean showOption = false;
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		userID = row.getValue(2);
		if (ConstantsServerSide.isTWAH()) {
			userName = row.getValue(8);
		} else if ("eleave".equals(category)) {
			userID = row.getValue(2);
			userName = row.getValue(3)+" "+row.getValue(4);
			hireDate = row.getValue(9);
		} else {
			userName = row.getValue(3);
			hireDate = row.getValue(7);
			displayPhoto = row.getValue(9);
		}
		//if (row.getValue())
		deptDesc = row.getValue(1);

		// show the options that matche the values specified in the request string array
		if (isFilterValues)
			showOption = false;
		else
			showOption = true;

		if (isFilterValues && filterValues != null) {
			for (int j = 0; showOption == false && j < filterValues.length; j++) {
				if (userID != null && userID.equals(filterValues[j])) {
					showOption = true;
				}
			}
		}

		if (hideVolunteer) {
			if (userID != null && userID.startsWith("V")) {
				showOption = false;
			}
		}

		if (hideDoctorForOutpatientNursing) {
			if (deptCode != null && "370".equals(deptCode)) {
				if (userName != null && userName.toLowerCase().contains("dr.")) {
					showOption = false;
				}
			}
		}

		if (hideDummyUser) {
			if (userID != null &&
					(userID.startsWith("9") || "IPD".equals(userID) || "TWAH".equals(userID))) {
				System.out.println("showOption false");
				showOption = false;
			}
		}

		if (showOption && (!ignoreCurrentStaffID || !userID.equals(staffID)) && (!onlyCurrentStaffID || (onlyCurrentStaffID && userID.equals(staffID)))) {
			// select if staff id or department code is matched
%><option hireDate="<%=hireDate %>" FTE="<%=ELeaveDB.getELFTE(userID)%>" displayPhoto="<%=displayPhoto %>"
		value="<%=userID %>"<%=userID.equals(value)||row.getValue(2).equals(value)?" selected":"" %>
		<%if (!"nominee".equals(category)) {%>email="<%=row.getValue(9)%>"<%}%>>
	<%if (showStaffID) { %><%=userID %> - <% } %><%=userName %><%if (showDeptDesc) { %> (<%=deptDesc %>)<%} %>
</option><%
		}
	}
}
%>