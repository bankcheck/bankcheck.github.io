<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.ForwardScanningDB"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%
	StringBuffer strBuf = new StringBuffer();
	UserBean userBean = new UserBean(request);

	if (!userBean.isLogin()) {
		strBuf.append("Access Denied");
	}
	
	String action = ParserUtil.getParameter(request, "action");
	String patno = ParserUtil.getParameter(request, "fmPatno");
	
	Set<String> mergePatnos = null;
	
	if ("getToPatno".equals(action)) {
		mergePatnos = ForwardScanningDB.getPatMergeByFmPatno(patno);
		if (!mergePatnos.isEmpty()) {
			strBuf.append("<div id=\"alert\">");
			strBuf.append("Patient: ");
			strBuf.append(patno);
			strBuf.append(" has been merged to Patient: ");
			strBuf.append(StringUtils.join(mergePatnos, ", "));
			strBuf.append("</div>");
		}
	} else if ("getFmPatno".equals(action)) {
		mergePatnos = ForwardScanningDB.getPatMergeByToPatno(patno);
		if (!mergePatnos.isEmpty()) {
			strBuf.append("<div id=\"alert\">");
			strBuf.append("Patient: ");
			strBuf.append(patno);
			strBuf.append(" already include ");
			strBuf.append("Patient: ");
			strBuf.append(StringUtils.join(mergePatnos, ", "));
			strBuf.append("'s records ");
			strBuf.append("</div>");
		}
	} else if ("getBoth".equals(action)) {
			// From fmPatno to  toPatno
			// Patient: toPatno already included
			// Patient: fmPatno's records
	}
%>
<%=strBuf.toString() %>