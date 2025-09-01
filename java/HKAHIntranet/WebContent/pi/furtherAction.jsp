<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private boolean isInteger(String i) {
		try {  
			Integer.parseInt(i);  
		    return true;  
		}  
		catch(Exception e)  
		{  
			return false;  
		}  
	} 

	private String getFlwReply(UserBean userBean, String pirID, String flwID, boolean complete) {
		StringBuffer contentStr = new StringBuffer();
		ReportableListObject row = null;
		
		ArrayList record = PiReportDB.fetchFlwUpReply(pirID, flwID);
		
		if(record.size() > 0) {
			for(int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				
				contentStr.append("<tr class='smallText' style='width:100%'>");
				contentStr.append("<td colspan='6'>");
				contentStr.append("<table flwid='"+flwID+"' replyid='"+row.getValue(2)+"' class='contentFrameMenu' cellpadding='0' cellspacing='5' border='0' width='100%'>");
				contentStr.append("<tr class='smallText'>");
				contentStr.append("<td colspan='10'></td>");
				contentStr.append("<td width='1%'></td>");
				contentStr.append("<td class='infoLabel' width='50%'>Reply Message</td>");
				contentStr.append("<td class='infoLabel' width='25%'>Attachment</td>");
				contentStr.append("<td class='infoLabel' width='15%'>Date</td>");
				contentStr.append("</tr>");
				contentStr.append("<tr class='smallText' style='width:100%'>");
				contentStr.append("<td colspan='10'></td>");
				contentStr.append("<td width='1%'></td>");
				contentStr.append("<td class='infoData' width='50%'><span style='width:100%'>"+row.getValue(3)+"<br/></span><textarea style='display:none' name='reply_message' style='width:100%' rows='3'>"+row.getValue(3)+"</textarea><br/>BY "+row.getValue(5)+"</td>");
				contentStr.append("<td class='infoData' width='25%'>");
				
				contentStr.append("<div class='includePage' page='../common/document_list.jsp' ");
				contentStr.append("flush='false'><div class='param' name='moduleCode' value='pireportReply'></div>");
				contentStr.append("<div class='param' name='keyID' value='"+row.getValue(2)+"'></div>");
				contentStr.append("</div>");
				
				contentStr.append("</td>");
				contentStr.append("<td class='infoData' width='15%'>"+row.getValue(4)+"</td>");
				contentStr.append("</tr>");
				contentStr.append("</table>");
				contentStr.append("</td>");
				contentStr.append("</tr>");
			}
		}
		
		if(!complete) {
			contentStr.append("<tr class='smallText'>");
			contentStr.append("<td colspan='6'>");
			contentStr.append("<table flwid='"+flwID+"' class='contentFrameMenu' cellpadding='0' cellspacing='5' border='0' width='100%'>");
			contentStr.append("<tr class='smallText'>");
			contentStr.append("<td colspan='10'></td>");
			contentStr.append("<td width='1%'></td>");
			contentStr.append("<td class='infoLabel' width='50%'>Reply Message</td>");
			contentStr.append("<td class='infoLabel' width='25%'>Attachment</td>");
			contentStr.append("<td class='infoLabel' width='15%'>Date</td>");
			contentStr.append("</tr>");
			contentStr.append("<tr class='smallText'>");
			contentStr.append("<td colspan='10'></td>");
			contentStr.append("<td width='1%'></td>");
			contentStr.append("<td class='infoData' width='50%'><textarea name='reply_message' style='width:100%' rows='3'></textarea><br/>BY "+userBean.getUserName()+"</td>");
			contentStr.append("<td class='infoData' width='25%'><input type='file' name='reply_attachment' onchange='addFile(this)'/><div class='uploadList'></div></td>");
			contentStr.append("<td class='infoData' width='15%'></td>");
			contentStr.append("</tr>");
			contentStr.append("</table>");
			contentStr.append("</td>");
			contentStr.append("</tr>");
		}
		
		return contentStr.toString();
	}

	private String getFlw(UserBean userBean, String pirID, boolean complete) {
		StringBuffer contentStr = new StringBuffer();
		ReportableListObject row = null;
		
		ArrayList record = PiReportDB.fetchReportFlwUp(pirID);
		if(record.size() > 0) {
			for(int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				
				contentStr.append("<table border='1' style='background-color:#FFF0FF' flwid='"+row.getValue(1)+"' class='content-table contentFrameMenu' cellpadding='0' cellspacing='5' border='0' width='100%'>");
				contentStr.append("<tr class='smallText'>");
				if(userBean.isAccessible("function.pi.report.admin") && !complete) { 
					contentStr.append("<td><img src='../images/add.jpg' class='addFlw'/></td>");
				}
				else {
					contentStr.append("<td></td>");
				}
				contentStr.append("<td class='infoLabel'>To</td>");
				contentStr.append("<td class='infoLabel'>Department</td>");
				contentStr.append("<td class='infoLabel'>Email</td>");
				contentStr.append("<td class='infoLabel'>Action</td>");
				contentStr.append("<td class='infoLabel'>Send Reminder(Auto)</td>");
				contentStr.append("</tr>");
				contentStr.append("<tr class='smallText'>");
				contentStr.append("<td></td>");
				if(userBean.isAccessible("function.pi.report.admin") && !complete) { 
					contentStr.append("<td class='infoData'><input style='width:100%' name='followUp_to' value='"+row.getValue(2)+"'/></td>");
					contentStr.append("<td class='infoData'>");
					contentStr.append("<div class='includePage' name='followUp_dept' style='width:100%' page='../ui/deptCodeCMB.jsp' ");
					contentStr.append("flush='false' style='width:100%'>");
					contentStr.append("<div class='param' name='deptCode' value='"+row.getValue(3)+"'></div>");
					contentStr.append("<div class='param' name='allowAll' value='Y'></div>");
					contentStr.append("</div>");
					contentStr.append("</td>");
					contentStr.append("<td class='infoData'><input style='width:100%' name='followUp_email' value='"+row.getValue(4)+"'/></td>");
					contentStr.append("<td class='infoData'><input style='width:100%' name='followUp_action' value='"+row.getValue(5)+"'/></td>");
					contentStr.append("<td class='infoData'>");
					contentStr.append("<input class='followUp_autoRemind' name='followUp_autoRemind_"+row.getValue(1)+"' type='radio' value='Y' "+(row.getValue(6).equals("1")?"checked":"")+"/>Yes");
					contentStr.append("<input class='followUp_autoRemind' name='followUp_autoRemind_"+row.getValue(1)+"' type='radio' value='N' "+(row.getValue(6).equals("0")?"checked":"")+"/>No");
					contentStr.append("</td>");
				}
				else {
					contentStr.append("<td class='infoData'><span>"+row.getValue(2)+"</span><input style='width:100%; display:none;' name='followUp_to' value='"+row.getValue(2)+"'/></td>");
					contentStr.append("<td class='infoData'>");
					contentStr.append("<span>"+row.getValue(7)+"</span>");
					contentStr.append("<div class='includePage' name='followUp_dept' style='width:100%; display:none;' page='../ui/deptCodeCMB.jsp' ");
					contentStr.append("flush='false' style='width:100%'>");
					contentStr.append("<div class='param' name='deptCode' value='"+row.getValue(3)+"'></div>");
					contentStr.append("<div class='param' name='allowAll' value='Y'></div>");
					contentStr.append("</div>");
					contentStr.append("</td>");
					contentStr.append("<td class='infoData'><span>"+row.getValue(4)+"</span><input style='width:100%; display:none;' name='followUp_email' value='"+row.getValue(4)+"'/></td>");
					contentStr.append("<td class='infoData'><span>"+row.getValue(5)+"</span><input style='width:100%; display:none;' name='followUp_action' value='"+row.getValue(5)+"'/></td>");
					contentStr.append("<td class='infoData'>");
					contentStr.append("<span>"+(row.getValue(6).equals("1")?"Yes":(row.getValue(6).equals("0")?"No":""))+"</span>");
					contentStr.append("<div style='display:none;'><input class='followUp_autoRemind' name='followUp_autoRemind_"+row.getValue(1)+"' type='radio' value='Y' "+(row.getValue(6).equals("1")?"checked":"")+"/>Yes</div>");
					contentStr.append("<div style='display:none;'><input class='followUp_autoRemind' name='followUp_autoRemind_"+row.getValue(1)+"' type='radio' value='N' "+(row.getValue(6).equals("0")?"checked":"")+"/>No</div>");
					contentStr.append("</td>");
				}
				contentStr.append("</tr>");
				contentStr.append(getFlwReply(userBean, pirID, row.getValue(1), complete));
				contentStr.append("</table>");
			}
		}
		else {
			contentStr.append("<table border='1' style='background-color:#FFF0FF' class='contentFrameMenu content-table' cellpadding='0' cellspacing='5' border='0' width='100%'>");
			contentStr.append("<tr class='smallText'>");
			if(userBean.isAccessible("function.pi.report.admin") && !complete) { 
				contentStr.append("<td><img src='../images/add.jpg' class='addFlw'/></td>");
			}
			else {
				contentStr.append("<td></td>");
			}
			contentStr.append("<td class='infoLabel'>To</td>");
			contentStr.append("<td class='infoLabel'>Department</td>");
			contentStr.append("<td class='infoLabel'>Email</td>");
			contentStr.append("<td class='infoLabel'>Action</td>");
			contentStr.append("<td class='infoLabel'>Send Reminder(Auto)</td>");
			contentStr.append("</tr>");
			if(userBean.isAccessible("function.pi.report.admin") && !complete) { 
				contentStr.append("<tr class='smallText'>");
				contentStr.append("<td></td>");
				contentStr.append("<td class='infoData'>");
				contentStr.append("<input style='width:100%' name='followUp_to' />");
				contentStr.append("</td>");
				
				contentStr.append("<td class='infoData'>");
				contentStr.append("<div class='includePage' name='followUp_dept' style='width:100%' page='../ui/deptCodeCMB.jsp' ");
				contentStr.append("flush='false' style='width:100%'>");
				contentStr.append("<div class='param' name='deptCode' value=''></div>");
				contentStr.append("<div class='param' name='allowAll' value='Y'></div>");
				contentStr.append("</div>");
				contentStr.append("</td>");
				
				contentStr.append("<td class='infoData'><input style='width:100%' name='followUp_email' /></td>");
				contentStr.append("<td class='infoData'><input style='width:100%' name='followUp_action' /></td>");
				contentStr.append("<td class='infoData'>");
				contentStr.append("<input class='followUp_autoRemind' name='followUp_autoRemind_temp_0' type='radio' value='Y'/>Yes");
				contentStr.append("<input class='followUp_autoRemind' name='followUp_autoRemind_temp_0' type='radio' value='N'/>No");
				contentStr.append("</td>");
				contentStr.append("</tr>");
				contentStr.append("<tr class='smallText'>");
				contentStr.append("<td colspan='6'>");
				contentStr.append("<table class='contentFrameMenu' cellpadding='0' cellspacing='5' border='0' width='100%'>");
				contentStr.append("<tr class='smallText'>");
				contentStr.append("<td colspan='10'></td>");
				contentStr.append("<td width='1%'></td>");
				contentStr.append("<td class='infoLabel' width='50%'>Reply Message</td>");
				contentStr.append("<td class='infoLabel' width='25%'>Attachment</td>");
				contentStr.append("<td class='infoLabel' width='15%'>Date</td>");
				contentStr.append("</tr>");
				contentStr.append("<tr class='smallText'>");
				contentStr.append("<td colspan='10'></td>");
				contentStr.append("<td width='1%'></td>");
				contentStr.append("<td class='infoData' width='50%'><textarea name='reply_message' style='width:100%' rows='3'></textarea><br/>BY "+userBean.getUserName()+"</td>");
				contentStr.append("<td class='infoData' width='25%'><input type='file' name='reply_attachment' onchange='addFile(this)'/><div class='uploadList'></div></td>");
				contentStr.append("<td class='infoData' width='15%'></td>");
				contentStr.append("</tr>");
				contentStr.append("</table>");
				contentStr.append("</td>");
				contentStr.append("</tr>");
			}
			contentStr.append("</table>");
		}
		
		return contentStr.toString();
	}
%>
<%
UserBean userBean = new UserBean(request);
String pirID = request.getParameter("pirID");
int status = Integer.parseInt(request.getParameter("status"));
String command = request.getParameter("command");
String fileUpload = request.getParameter("fileUpload");
String complete = ParserUtil.getParameter(request, "complete");
String reject = null;
String follow = null;
String message = null;
String errorMessage = null;
String actionCommand = null;
String flwContent = null;

if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = "true";
}


if(command.equals("view")) {
	if(status == 1) {
		reject = "N";
		follow = "";
		actionCommand = "viewUpdate";
	}
	else if(status == 2 || status == 3) {
		reject = "N";
		follow = "Y";
		if(status == 3) {
			complete = "Y";
		}
		actionCommand = "viewUpdate";
	}
	else if(status == 4) {
		reject = "Y";
		actionCommand = "viewUpdate";
	}
	else if(status == 5) {
		reject = "N";
		follow = "N";
		actionCommand = "viewUpdate";
	}
	else {
		actionCommand = "viewCreate";
	}
}
else if(command.equals("viewCreate")) {
	reject = ParserUtil.getParameter(request, "reject");
	follow = ParserUtil.getParameter(request, "follow");
	
	if(reject != null) {
		if(follow != null) {
			if(follow.equals("Y")) {
				if(PiReportDB.updatePIReportStatus(userBean, pirID, "2")) {
					if(complete != null && complete.equals("Y")) {
						if(PiReportDB.updatePIReportStatus(userBean, pirID, "3")) {
							message = "Succeed in updating status";
						}
						else {
							errorMessage = "Error in updating status";
						}
					}
					
					flwContent = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "flwContent"));
					
					if(flwContent != null) {
						String value[] = flwContent.split("&#");
						
						for(int i = 0; i < value.length; i++) {
							System.out.println(value[i]);
							String flwID = null;
							String replyID = null;
							String flwAndReply[] = value[i].toString().split("%#");
							String flwup = flwAndReply[0];
							String reply = flwAndReply[1];
							String flwField[] = flwup.split("@#");
							String replyRow[] = reply.split("-#");
							
							if(flwField[1].length() > 0 || flwField[3].length() > 0 
									|| flwField[4].length() > 0 || (flwField[5].length() > 0 && !flwField[5].equals("U"))) {
								if((flwID = PiReportDB.addFlwUp(userBean, pirID, flwField[1], flwField[2],
										flwField[3], flwField[4], (flwField[5].equals("Y")?"1":(flwField[5].equals("N")?"0":"")))) != null) {
									for(int j = 0; j < replyRow.length; j++) {
										String replyField[] = replyRow[j].split("@#");
										
										if(isInteger(replyField[0])) {
											
										}
										else {
											if(replyField.length > 1) {
												if((replyID = PiReportDB.addFlwUpReply(userBean, pirID, flwID, replyField[1])) != null) {
													if(replyField.length > 2) {
														if(fileUpload.equals("true")) {
															for(int k = 2; k < replyField.length; k++) {
																StringBuffer tempStrBuffer = new StringBuffer();
																tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
																tempStrBuffer.append(File.separator);
																tempStrBuffer.append("PIReport");
																tempStrBuffer.append(File.separator);
																tempStrBuffer.append("PIReportReply");
																tempStrBuffer.append(File.separator);
																tempStrBuffer.append(replyID);
																tempStrBuffer.append(File.separator);
																String baseUrl = tempStrBuffer.toString();
																
																tempStrBuffer.setLength(0);
																tempStrBuffer.append(File.separator);
																tempStrBuffer.append("upload");
																tempStrBuffer.append(File.separator);
																tempStrBuffer.append("PIReport");
																tempStrBuffer.append(File.separator);
																tempStrBuffer.append("PIReportReply");
																tempStrBuffer.append(File.separator);
																tempStrBuffer.append(replyID);
																String webUrl = tempStrBuffer.toString();
																
																FileUtil.moveFile(
																		ConstantsServerSide.UPLOAD_FOLDER + File.separator + replyField[k].substring(replyField[k].lastIndexOf("\\")+1, replyField[k].length()),
																		baseUrl + replyField[k].substring(replyField[k].lastIndexOf("\\")+1, replyField[k].length())
																	);
																String documentID = "";
																if((documentID = DocumentDB.add(ConstantsServerSide.SITE_CODE, 
																		userBean, "pireportReply", replyID, webUrl, replyField[k].substring(replyField[k].lastIndexOf("\\")+1, replyField[k].length()))) != null) {
																	message = "Succeed in updating status";
																}
																else {
																	errorMessage = "Error in upload document";
																}
															}
														}
													}
												}
												else {
													errorMessage = "Error in adding reply";
												}
											}
										}
									}
								}	
								else {
									errorMessage = "Error in adding follow up";
								}
							}
						}
					}
				}
				else {
					errorMessage = "Error in updating status";
				}
			}
			else {
				if(PiReportDB.updatePIReportStatus(userBean, pirID, "5")) {
					if(PiReportDB.deleteAllFlwUp(userBean, pirID)) {
						message = "Succeed in updating status";
					}
					else {
						errorMessage = "Error in deleting flwUp";
					}
				}
				else {
					errorMessage = "Error in updating status";
				}
			}
		}else {
			if(reject.equals("Y")) {
				if(PiReportDB.updatePIReportStatus(userBean, pirID, "4")) {
					if(PiReportDB.deleteAllFlwUp(userBean, pirID)) {
						message = "Succeed in updating status";
					}
					else {
						errorMessage = "Error in deleting flwUp";
					}
				}else {
					errorMessage = "Error in updating status";
				}
			}
			else {
				if(PiReportDB.updatePIReportStatus(userBean, pirID, "1")) {
					message = "Succeed in updating status";
				}
				else {
					errorMessage = "Error in updating status";
				}
			}
		}
	}
	
	if(errorMessage != null) {
		message = null;
	}
	else {
		message = "Succeed";
	}
	
	actionCommand = "viewUpdate";
}
else if(command.equals("viewUpdate")) {
	reject = ParserUtil.getParameter(request, "reject");
	follow = ParserUtil.getParameter(request, "follow");
	
	String curStatus = null;

	if(reject != null) {
		if(reject.equals("Y")) {
			curStatus = "4";
			if(PiReportDB.deleteAllFlwUp(userBean, pirID)) {
				message = "Succeed in deleting flwUp";
			}
			else {
				errorMessage = "Error in deleting flwUp";
			}
			complete = null;
			follow = null;
		}
		else {
			if(follow != null) {
				if(follow.equals("Y")) {
					curStatus = "2";
				}
				else {
					curStatus = "5";
					if(PiReportDB.deleteAllFlwUp(userBean, pirID)) {
						message = "Succeed in deleting flwUp";
					}
					else {
						errorMessage = "Error in deleting flwUp";
					}
					complete = null;
				}
			}
			else {
				curStatus = "1";
				follow = null;
				complete = null;
			}
		}
		
	}
	
	if(complete != null && complete.equals("Y")) {
		curStatus = "3";
	}
	
	if(curStatus != null) {
		if(!curStatus.equals(String.valueOf(status))) {
			if(PiReportDB.updatePIReportStatus(userBean, pirID, curStatus)) {
				status = Integer.parseInt(curStatus);
				message = "Succeed in updating status";
			}
			else {
				errorMessage = "Error in updating status";
			}
		}
	}
	
	if(curStatus != null && curStatus.equals("2")) {
		flwContent = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "flwContent"));
		
		if(flwContent != null) {
			String value[] = flwContent.split("&#");
			for(int i = 0; i < value.length; i++) {
				System.out.println(value[i]);
				String flwAndReply[] = value[i].toString().split("%#");
				String flwup = flwAndReply[0];
				String reply = flwAndReply[1];
				String flwField[] = flwup.split("@#");
				String replyRow[] = reply.split("-#");
				String replyID = null;
				
				if(isInteger(flwField[0])) {
					if(PiReportDB.updateFlwUp(userBean, pirID, flwField[0], 
							flwField[1], flwField[2], flwField[3], flwField[4], flwField[5].equals("Y")?"1":(flwField[5].equals("N")?"0":""))) {
						for(int j = 0; j < replyRow.length; j++) {
							String replyField[] = replyRow[j].split("@#");
							
							System.out.println(replyRow[j]);
							if(isInteger(replyField[0])) {
								/*if(PiReportDB.updateFlwUpReply(userBean, pirID, flwField[0], replyField[0], replyField[1])) {
									
								}
								else {
									//update error
								}*/
							}
							else {
								if(replyField.length > 1) {
									if((replyID = PiReportDB.addFlwUpReply(userBean, pirID, flwField[0], replyField[1])) != null) {
										if(replyField.length > 2) {
											if(fileUpload.equals("true")) {
												for(int k = 2; k < replyField.length; k++) {
													StringBuffer tempStrBuffer = new StringBuffer();
													tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
													tempStrBuffer.append(File.separator);
													tempStrBuffer.append("PIReport");
													tempStrBuffer.append(File.separator);
													tempStrBuffer.append("PIReportReply");
													tempStrBuffer.append(File.separator);
													tempStrBuffer.append(replyID);
													tempStrBuffer.append(File.separator);
													String baseUrl = tempStrBuffer.toString();
													
													tempStrBuffer.setLength(0);
													tempStrBuffer.append(File.separator);
													tempStrBuffer.append("upload");
													tempStrBuffer.append(File.separator);
													tempStrBuffer.append("PIReport");
													tempStrBuffer.append(File.separator);
													tempStrBuffer.append("PIReportReply");
													tempStrBuffer.append(File.separator);
													tempStrBuffer.append(replyID);
													String webUrl = tempStrBuffer.toString();
													
													FileUtil.moveFile(
															ConstantsServerSide.UPLOAD_FOLDER + File.separator + replyField[k].substring(replyField[k].lastIndexOf("\\")+1, replyField[k].length()),
															baseUrl + replyField[k].substring(replyField[k].lastIndexOf("\\")+1, replyField[k].length())
														);
													String documentID = "";
													if((documentID = DocumentDB.add(ConstantsServerSide.SITE_CODE, 
															userBean, "pireportReply", replyID, webUrl, replyField[k].substring(replyField[k].lastIndexOf("\\")+1, replyField[k].length()))) != null) {
														
													}
													else {
														errorMessage = "Error in upload document";
													}
												}
											}
										}
									}
									else {
										errorMessage = "Error in adding reply";
									}
								}
							}
						}
					}
					else {
						errorMessage = "Error in updating flwUp";
					}
				}
				else { 
					String flwID = null;
					
					if(flwField[1].length() > 0 || flwField[3].length() > 0 || 
							flwField[4].length() > 0 || (flwField[5].length() > 0 && !flwField[5].equals("U"))) {
						if((flwID = PiReportDB.addFlwUp(userBean, pirID, flwField[1], flwField[2],
								flwField[3], flwField[4], flwField[5].equals("Y")?"1":(flwField[5].equals("N")?"0":""))) != null) {
							for(int j = 0; j < replyRow.length; j++) {
								String replyField[] = replyRow[j].split("@#");
								
								if(isInteger(replyField[0])) {
									/*if(PiReportDB.updateFlwUpReply(userBean, pirID, flwID, replyField[0], replyField[1])) {
										
									}
									else {
										//update error
									}*/
								}
								else {
									if(replyField.length > 1) {
										if((replyID = PiReportDB.addFlwUpReply(userBean, pirID, flwID, replyField[1])) != null) {
											if(replyField.length > 2) {
												if(fileUpload.equals("true")) {
													for(int k = 2; k < replyField.length; k++) {
														StringBuffer tempStrBuffer = new StringBuffer();
														tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
														tempStrBuffer.append(File.separator);
														tempStrBuffer.append("PIReport");
														tempStrBuffer.append(File.separator);
														tempStrBuffer.append("PIReportReply");
														tempStrBuffer.append(File.separator);
														tempStrBuffer.append(replyID);
														tempStrBuffer.append(File.separator);
														String baseUrl = tempStrBuffer.toString();
														
														tempStrBuffer.setLength(0);
														tempStrBuffer.append(File.separator);
														tempStrBuffer.append("upload");
														tempStrBuffer.append(File.separator);
														tempStrBuffer.append("PIReport");
														tempStrBuffer.append(File.separator);
														tempStrBuffer.append("PIReportReply");
														tempStrBuffer.append(File.separator);
														tempStrBuffer.append(replyID);
														String webUrl = tempStrBuffer.toString();
														
														FileUtil.moveFile(
																ConstantsServerSide.UPLOAD_FOLDER + File.separator + replyField[k].substring(replyField[k].lastIndexOf("\\")+1, replyField[k].length()),
																baseUrl + replyField[k].substring(replyField[k].lastIndexOf("\\")+1, replyField[k].length())
															);
														String documentID = "";
														if((documentID = DocumentDB.add(ConstantsServerSide.SITE_CODE, 
																userBean, "pireportReply", replyID, webUrl, replyField[k].substring(replyField[k].lastIndexOf("\\")+1, replyField[k].length()))) != null) {
														}
														else {
															errorMessage = "Error in upload document";
														}
													}
												}
											}
										}
										else {
											errorMessage = "Error in adding reply";
										}
									}
								}
							}
						}
						else {
							errorMessage = "Error in adding flwUp";
						}
					}
				}
			}
		}
	}
	
	actionCommand = "viewUpdate";
	if(errorMessage != null) {
		message = null;
	}
	else {
		message = "Succeed";
	}
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="flwUpForm" enctype="multipart/form-data" action="incident_report.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%" style="<%=(userBean.isAccessible("function.pi.report.admin")?"":"display:none;")%>">
	<tr class="smallText">
		<td colspan="2" class="infoSubTitle5">Report Status</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Reject Incident?</td>
		<td class="infoData" width="70%">
	<%if(userBean.isAccessible("function.pi.report.admin")) { %>
			<input name="reject" type="radio" value="Y" <%=(reject!=null)?(reject.equals("Y")?"checked":""):"" %>/>Yes
			<input name="reject" type="radio" value="N" <%=(reject!=null)?(reject.equals("N")?"checked":""):"" %>/>No
	<%}else { %>
		<%=(reject!=null)?(reject.equals("Y")?"Yes":(reject.equals("N")?"No":"")):"" %>
		<div style="display:none;"><input name="reject" style="display:none;" type="radio" value="Y" <%=(reject!=null)?(reject.equals("Y")?"checked":""):"" %>/>Yes</div>
		<div style="display:none;"><input name="reject" style="display:none;" type="radio" value="N" <%=(reject!=null)?(reject.equals("N")?"checked":""):"" %>/>No</div>
	<%} %>                        
		</td>
	</tr>
	<tr id="followUp" class="smallText" style="display:none;">
		<td class="infoLabel" width="30%">Futher follow-up / notification required?</td>
		<td class="infoData" width="70%">
	<%if(userBean.isAccessible("function.pi.report.admin")) { %>
			<input name="follow" type="radio" value="Y" <%=(follow!=null)?(follow.equals("Y")?"checked":""):"" %>/>Yes
			<input name="follow" type="radio" value="N" <%=(follow!=null)?(follow.equals("N")?"checked":""):"" %>/>No
	<%}else { %>
		<%=(follow!=null)?(follow.equals("Y")?"Yes":(follow.equals("N")?"No":"")):"" %>
		<div style="display:none;"><input name="follow" type="radio" value="Y" <%=(follow!=null)?(follow.equals("Y")?"checked":""):"" %>/>Yes</div>
		<div style="display:none;"><input name="follow" type="radio" value="N" <%=(follow!=null)?(follow.equals("N")?"checked":""):"" %>/>No</div>
	<%} %> 
		</td>
	</tr>
</table>
<table class="assignFollow contentFrameMenu" cellpadding="0" cellspacing="5" border="0" width="100%" style="display:none;">
		<tr class="smallText">
			<td colspan="8" class="infoSubTitle5">Follow Up</td>
		</tr>
</table>

<div class="flwup-template" style="display:none">
	<table border='1' style="background-color:#FFF0FF" class="contentFrameMenu content-table" cellpadding="0" cellspacing="5" border="0" width="100%">
		<tr class="smallText">
			<td><img src="../images/add.jpg" class="addFlw"/></td>
			<td class="infoLabel">To</td>
			<td class="infoLabel">Department</td>
			<td class="infoLabel">Email</td>
			<td class="infoLabel">Action</td>
			<td class="infoLabel">Send Reminder(Auto)</td>
		</tr>
		<tr class="smallText">
			<td></td>
			<td class="infoData"><input style="width:100%" name="followUp_to" /></td>
			<td class="infoData">
				<select style="width:100%" name="followUp_dept">
					<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
						<jsp:param name="deptCode" value='' />
						<jsp:param name="allowAll" value="Y" />
					</jsp:include>
				</select>
			</td>
			<td class="infoData"><input style="width:100%" name="followUp_email" /></td>
			<td class="infoData"><input style="width:100%" name="followUp_action" /></td>
			<td class="infoData">
				<input class='followUp_autoRemind' name="followUp_autoRemind" type="radio" value="Y"/>Yes
				<input class='followUp_autoRemind' name="followUp_autoRemind" type="radio" value="N"/>No
			</td>
		</tr>
		<tr class="smallText">
			<td colspan="6">
				<table class="contentFrameMenu" cellpadding="0" cellspacing="5" border="0" width="100%">
					<tr class="smallText">
						<td colspan="10"></td>
						<td width="1%"></td>
						<td class="infoLabel" width="50%">Reply Message</td>
						<td class="infoLabel" width="25%">Attachment</td>
						<td class="infoLabel" width="15%">Date</td>
					</tr>
					<tr class="smallText">
						<td colspan="10"></td>
						<td width="1%"></td>
						<td class="infoData" width="50%"><textarea name="reply_message" style='width:100%' rows='3'></textarea><br/>BY <%=userBean.getUserName() %></td>
						<td class="infoData" width="25%"><input type='file' name="reply_attachment" onchange='addFile(this)'/><div class='uploadList'></div></td>
						<td class="infoData" width="15%"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<div class="assignFollow flwup-content" style='<%=(status == 2 || status == 3)?"":"display:none" %>'>
<%=getFlw(userBean, pirID, (complete != null && complete.equals("Y"))) %>
</div>
<br/>
<%if(userBean.isAccessible("function.pi.report.admin")) { %>
<table class="assignFollow contentFrameMenu" cellpadding="0" cellspacing="5" border="0" width="100%" style="display:none;">
	<tr class="smallText">
		<td colspan="2" class="infoSubTitle5">Follow Up Status</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Completed?</td>
		<td class="infoData" width="70%">
			<input name="complete" type="radio" value="Y" <%=(complete!=null)?(complete.equals("Y")?"checked":""):"" %>/>Yes
			<input name="complete" type="radio" value="N" <%=(complete!=null)?(complete.equals("Y")?"":"checked"):"checked" %>/>No
		</td>
	</tr>
</table>
<%}else { %>
	<div style="display:none;"><input name="complete" type="radio" value="Y" <%=(complete!=null)?(complete.equals("Y")?"checked":""):"" %>/>Yes
		<input name="complete" type="radio" value="N" <%=(complete!=null)?(complete.equals("Y")?"":"checked"):"checked" %>/>No
	</div>
<%} %>  
<input name="flwStatus" type="hidden" value="<%=status %>"/>
<input name="flwContent" type="hidden" value=""/>
<button onclick="return submitAction('<%=actionCommand%>');">Submit</button>
</form>

<script language="javascript">
	function deleteFile(dom) {
		$(dom).parent().parent().find('input[filename='+$(dom).prev().html().replace(".", "")+']').remove();
		$(dom).prev().remove();
		$(dom).next().remove();
		$(dom).remove();
	}
	
	function addFile(dom) {
		var filePath = $(dom).val();
		var fileName = $(dom).val().substr($(dom).val().lastIndexOf('\\')+1);
		
		$(dom).parent()
			.find('.uploadList')
				.append('<span path='+filePath+'>'+fileName+'</span> <img style="cursor:pointer" src="../images/delete4.png" onclick="deleteFile(this)"/><br/>');
		
		$(dom).after('<input type="file" name="reply_attachment" onchange="addFile(this)"/>');
		$(dom).css('display', 'none').attr('filename', fileName.replace(".", ""));
	}
	
	function handleFlwContent() {
		var flwContent = $('div.flwup-content');
		var hiddenInput = $('input[name=flwContent]');
		var hiddenInputVal = hiddenInput.val();
		
		flwContent.find('table.content-table').each(function(i, v) {
			hiddenInputVal += $(this).attr('flwid')+'@#'+
								$(this).find('input[name=followUp_to]').val()+'@#'+
								$(this).find('select[name=followUp_dept] option:selected').val()+'@#'+
								$(this).find('input[name=followUp_email]').val()+'@#'+
								$(this).find('input[name=followUp_action]').val()+'@#'+
								(($(this).find('input.followUp_autoRemind:checked').val())?$(this).find('input.followUp_autoRemind:checked').val():"U")+'%#';
			$(this).find('table').each(function(index, value) {
				hiddenInputVal += $(this).attr('replyid')+'@#'+
									$(this).find('textarea[name=reply_message]').val()+'@#';
				$(this).find('.uploadList').find('span').each(function() {
					hiddenInputVal += $(this).attr('path')+'@#';
				});
				hiddenInputVal += '-#';
			});
			hiddenInputVal += '&#';
		});
		hiddenInput.val(hiddenInputVal);
	}

	function addFlwContentEvt() {
		$('img.addFlw').unbind('click');
		$('img.addFlw').click(function() {
			var temp = $('div.flwup-content').find('table.content-table:last')
							.find('input.followUp_autoRemind').attr('name');
			
			if(temp.indexOf('temp') > -1) {
				temp = temp.split('temp_')[1];
			}
			else {
				temp = "0";
			}
			
			$('div.flwup-content').append($('div.flwup-template').html());
			$('div.flwup-content')
					.find('table.content-table:last')
					.find('input.followUp_autoRemind').attr('name', "followUp_autoRemind_temp_"+(parseInt(temp)+1));
		});
	}
	
	function init() {
		$('input[name=reject]').click(function() {
			if($(this).val() == "N") {
				$('tr#followUp').css('display', '');
			}
			else {
				$('tr#followUp').css('display', 'none');
				$('.assignFollow').css('display', 'none');
			}
		});
		
		$('input[name=follow]').click(function() {
			if($(this).val() == "Y") {
				$('.assignFollow').css('display', '');
				addFlwContentEvt();
			}else {
				$('.assignFollow').css('display', 'none');
			}
		});
	}
	
	$(document).ready(function() {
		init();
		handleIncludePage();
		
		$('div.flwup-content').find('input[name=followUp_autoRemind]').each(function(i, v) {
				$(this).attr('id', i);
		});
		
		if($('input[name=flwStatus]').val().length > 0) {
			$('input[name=reject]:checked').trigger('click');
			$('input[name=follow]:checked').trigger('click');
		}
	});
</script>