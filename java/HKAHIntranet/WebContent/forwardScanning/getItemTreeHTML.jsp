<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.helper.FsModelHelper"%>
<%@ page import="com.hkah.web.db.ForwardScanningDB"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%
String patno = request.getParameter("patno");
String viewMode = request.getParameter("viewMode");

List<FsCategory> tree = FsModelHelper.getFsCategoryTreeWithFiles(patno, viewMode);
String treeHtml = FsModelHelper.getFsItemTree(tree, viewMode, patno, "", "");
	if (treeHtml == null || "".equals(treeHtml)) {
%>
No patient chart.
<%
	} else {
%><%=treeHtml %><%
	}
%>



