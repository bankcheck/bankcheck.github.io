<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%
	UserBean userBean = new UserBean(request);
	if (!userBean.isLogin() || !userBean.isAccessible("function.fs.import.list"))
		return;
	
	String fileName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "fileName"));
	List<String> existBatchNo = FsModelHelper.duplicateBatchs(fileName);
	
	StringBuffer strBuf = new StringBuffer();
	if (existBatchNo != null) {
		int noOfBatches = existBatchNo.size();
		if (noOfBatches > 0) {
			strBuf.append("<div id=\"alert_batches\">");
			strBuf.append("There ");
			strBuf.append(noOfBatches == 1 ? "is " : "are ");
			strBuf.append(noOfBatches == 1 ? "an upload " : noOfBatches + " uploads ");
			strBuf.append("with the SAME index file name (");
			strBuf.append(fileName);
			strBuf.append("). Make sure the current upload is not redundancy:");
			strBuf.append("</div>");
			strBuf.append("<div id=\"existing_batches\">");
			for (int i = 0; i < noOfBatches; i++) {
				strBuf.append("<a href=\"javascript:void(0);\" onclick=\"openImportLogList('" + existBatchNo.get(i) + "');\">");
				strBuf.append("Batch " + existBatchNo.get(i));
				strBuf.append("</a><br />");
			}
			strBuf.append("</div>");
		}
		
	}
%>
<%=strBuf.toString() %>