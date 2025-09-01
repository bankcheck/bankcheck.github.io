<%@ page import="java.util.*"
%><%@ page import="org.apache.struts.*"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.servlet.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%!
	private ArrayList fetchPatientInfo(String patno,String patIDNo) {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT P.PATFNAME || ', ' || P.PATGNAME, B.ROMCODE, I.BEDCODE, R.REGID, M.WRDCODE, W.WRDNAME ");
		sqlStr.append(", P.PATNO, DECODE(P.PATIDNO, ?, 1, 0) ");
		sqlStr.append("FROM   PATIENT@IWEB P, REG@IWEB R, INPAT@IWEB I, BED@IWEB B, ROOM@IWEB M, WARD@IWEB W ");
		//sqlStr.append("FROM   PATIENT P, REG R, INPAT I, BED B, ROOM M, WARD W ");
		sqlStr.append("WHERE  P.PATNO = R.PATNO ");
		sqlStr.append("AND    R.INPID = I.INPID ");
		sqlStr.append("AND    I.BEDCODE = B.BEDCODE ");
		sqlStr.append("AND    B.ROMCODE = M.ROMCODE ");
		sqlStr.append("AND    M.WRDCODE = W.WRDCODE ");	
		sqlStr.append("AND    P.PATNO = ? ");
		sqlStr.append("AND    R.REGTYPE = 'I' ");
		sqlStr.append("AND    I.INPDDATE IS NULL ");
		sqlStr.append("AND    P.PATIDNO IS NOT NULL ");
		
		//System.out.println(sqlStr.toString());
			
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {patIDNo,patno});
		
	}
%>
<%
String loginID = request.getParameter("loginID");
String loginPwd = request.getParameter("loginPwd");

try {
	if (loginID == null || loginID.length() == 0) {
		%><bean:message key="error.patientNo.required" /><%
		return;
	} else if (loginPwd == null || loginPwd.length() == 0) {
		%><bean:message key="error.loginPwd.required" /><%
		return;
	} 

	ArrayList record = fetchPatientInfo(loginID, loginPwd);	
	if (record.size() > 0) {
		ReportableListObject rlo = (ReportableListObject) record.get(0);
		if (rlo.getValue(7).equals("1")) {
			UserBean userBean = new UserBean();
			userBean.setSiteCode(ConstantsServerSide.SITE_CODE);
			
			userBean.setLoginID(rlo.getValue(6));			
			userBean.setUserName(rlo.getValue(0));
			userBean.setStaffCategory("patient");
			userBean.setRemark1(rlo.getValue(1));
			userBean.setRemark2(rlo.getValue(2));
			userBean.setRemark3(rlo.getValue(3));
			userBean.setDeptCode(rlo.getValue(4));
			userBean.setDeptDesc(rlo.getValue(5));
			userBean.writeToSession(request);
			%>OK<%
		}
		else {
			%><bean:message key="error.loginPwd.invalid"/><%
		}
	} else {
		// invalid password
		%><bean:message key="prompt.onlyInpatient"/><%
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>