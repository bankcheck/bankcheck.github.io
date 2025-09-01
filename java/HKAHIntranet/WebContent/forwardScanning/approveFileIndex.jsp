<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.ForwardScanningDB"%>
<%
	UserBean userBean = new UserBean(request);
	if (userBean.isAccessible("function.fs.file.approve")) {
		String command = ParserUtil.getParameter(request, "command");
		String keyId = ParserUtil.getParameter(request, "keyId");
		String message = request.getParameter("message");
		
		boolean batchApproveAction = false;
		boolean approveAction = false;
		if ("batchApprove".equals(command)) {
			 batchApproveAction = true;
		} else if ("approve".equals(command)) {
			approveAction = true;
		}
		boolean success = false;
		
		try {
			if (batchApproveAction) {
				success = false;
				message = "Batch approve fail.";
				batchApproveAction = false;
			} else if (approveAction) {
				success = ForwardScanningDB.approveFileIndex(userBean, new String[]{keyId});
				if (success) {
					message = "OK";
				} else {
					message = "Approve fail.";
				}
				approveAction = false;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		out.print(message);
	} else {
		out.print("Access Denied.");	
	}
%>