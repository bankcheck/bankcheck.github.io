<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%!
	private String parseTextArea(String text) {
		if (text != null && text.length() > 0) {
			return text.replaceAll("(\r\n|\n)", "<br />");
		} else {
			return "";
		}
	}
%>
<%
String grpID = request.getParameter("grpID");
boolean subContent = "Y".equals(request.getParameter("subContent"));
String parentID = request.getParameter("parentID");
String parentCol = request.getParameter("col");
boolean template = "Y".equals(request.getParameter("template"));
String pirID = request.getParameter("pirID");
String action = request.getParameter("action");
boolean viewAction = "view".equals(action);
boolean editAction = "edit".equals(action);
String optionRemark = null;
String optionLabel1 = null;
String optionLabel2 = null;
String optionLabel3 = null;
boolean editHasValue = false;

String dataCol = "PI_VALUE";
if ("view2".equals(action))
	dataCol = "PI_VALUE2";

String suffix = "_flwUp";
		
ArrayList record = PiReportDB.fetchReportDetail(grpID, parentID, pirID, editAction, dataCol);
ReportableListObject row = null;

if (record.size() > 0) {
	String subContentSpace = "&nbsp;&nbsp;&nbsp;&nbsp;";
	int printCol = 0;
	int col = 0;
	int maxCol = 0;
	int currentGrpID = 1;

	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);	
		String optType = row.getValue(2);
		optionRemark = row.getValue(9);
		editHasValue = (editAction && (row.getValue(11).length() > 0));
		//System.out.println(row.getValue(3));
		if (!subContent && i == 0) {
			if (!template && (viewAction || editAction) && !row.getValue(12).equals("1")) {
				currentGrpID = Integer.parseInt(row.getValue(12));
			}
			if (editHasValue) {
				%>
					<div style='float:right;' id='removeImage'>
						<img src='../images/delete1.png' style='cursor:pointer' onclick='delPasteDom(this)'/>
					</div>
				<%
			}
			%>
				<table style='width:100%;' count='0' index='0' contentGrpID='<%=currentGrpID%>' grpID='<%=grpID%>'>
					<tbody>
			<%
		}
		else {
			if (viewAction || editAction) {
				if (!template && currentGrpID != Integer.parseInt(row.getValue(12)) && !row.getValue(12).equals("1") && !row.getValue(12).equals("0")) {

					currentGrpID = Integer.parseInt(row.getValue(12));
				%>
						</tbody>
					</table>
				<%
					if (editAction) {
						%>
							<div style='float:right;' id='removeImage'>
								<img src='../images/delete1.png' style='cursor:pointer' onclick='delPasteDom(this)'/>
							</div>
						<%
					}
				%>
					<table class="copy" style='width:100%;border-style:groove;border-color:gray;border-spacing:10px;' count='0' index='0' contentGrpID='<%=currentGrpID%>' grpID='<%=grpID%>'>
						<tbody>
				<%
				}
			}
		}

		if (viewAction) {
			if (row.getValue(7).equals("Y")) {
				if (!PiReportDB.isPrintable(grpID, row.getValue(0), pirID) && !(row.getValue(11).length() > 0)) {
					continue;
				}
			}
			else {
				if (!(row.getValue(11).length() > 0)) {
					continue;
				}
			}
		}

		if (printCol == 0) {
			if (parentCol != null)
				col = Integer.parseInt(parentCol);
			else
				col = Integer.parseInt(row.getValue(4));

			if (col > maxCol) {
				maxCol = col;
			}
			%><tr><%
		}

		if (optType.equals("title")) {
			if (parentCol != null)
				col = Integer.parseInt(parentCol);
			else
				col = Integer.parseInt(row.getValue(4));

			if (col > maxCol) {
				maxCol = col;
			}
			%><%-- <tr><td colspan='<%=maxCol %>' copyable='<%=row.getValue(6)%>'> --%><%

			// for medication report
			//if ("8".equals(PiReportDB.getIncidentType(pirID)) || "530".equals(PiReportDB.getIncidentType(pirID))) {
			if (PiReportDB.hasParentDesc(grpID) && editAction) {
				if (record.size() - i == 1 && maxCol - printCol > 1) {
					%><td copyable='<%=row.getValue(6)%>' colspan='<%=maxCol - printCol%>'><%
				}
				else {
					%><tr><td></td></tr><td copyable='<%=row.getValue(6)%>'><%
				}
			} else {
				if (record.size() - i == 1 && maxCol - printCol > 1) {
					%><td copyable='<%=row.getValue(6)%>' colspan='<%=maxCol - printCol%>'><%
				}
				else {
					%><td copyable='<%=row.getValue(6)%>'><%
				}
			}

			if (row.getValue(5).equals("Y")) {
				%><%=subContentSpace %><%
			}
			%><u><i><b><%=row.getValue(3) %></b></i></u></td><%
		}else if (optType.equals("title_no_bold")) {
				if (parentCol != null)
					col = Integer.parseInt(parentCol);
				else
					col = Integer.parseInt(row.getValue(4));

				if (col > maxCol) {
					maxCol = col;
				}
				%><%-- <tr><td colspan='<%=maxCol %>' copyable='<%=row.getValue(6)%>'> --%><%

						// for medication report
						//if ("8".equals(PiReportDB.getIncidentType(pirID)) || "530".equals(PiReportDB.getIncidentType(pirID))) {
						if (PiReportDB.hasParentDesc(grpID) && editAction) {
							if (record.size() - i == 1 && maxCol - printCol > 1) {
								%><td copyable='<%=row.getValue(6)%>' colspan='<%=maxCol - printCol%>'><%
							}
							else {
								%><tr><td></td></tr><td copyable='<%=row.getValue(6)%>'><%
							}
						} else {
							if (record.size() - i == 1 && maxCol - printCol > 1) {
								%><td copyable='<%=row.getValue(6)%>' colspan='<%=maxCol - printCol%>'><%
							}
							else {
								%><td copyable='<%=row.getValue(6)%>'><%
							}
						}

				if (row.getValue(5).equals("Y")) {
					%><%=subContentSpace %><%
				}
				%><%=row.getValue(3) %></td><%
		}else if (optType.equals("title_red")) {
				if (parentCol != null)
					col = Integer.parseInt(parentCol);
				else
					col = Integer.parseInt(row.getValue(4));

				if (col > maxCol) {
					maxCol = col;
				}
				%><%-- <tr><td colspan='<%=maxCol %>' copyable='<%=row.getValue(6)%>'> --%><%

						// for medication report
						//if ("8".equals(PiReportDB.getIncidentType(pirID)) || "530".equals(PiReportDB.getIncidentType(pirID))) {
						if (PiReportDB.hasParentDesc(grpID) && editAction) {
							if (record.size() - i == 1 && maxCol - printCol > 1) {
								%><td copyable='<%=row.getValue(6)%>' colspan='<%=maxCol - printCol%>'><%
							}
							else {
								%><tr><td></td></tr><td copyable='<%=row.getValue(6)%>'><%
							}
						} else {
							if (record.size() - i == 1 && maxCol - printCol > 1) {
								%><td copyable='<%=row.getValue(6)%>' colspan='<%=maxCol - printCol%>'><%
							}
							else {
								%><td copyable='<%=row.getValue(6)%>'><%
							}
						}

				if (row.getValue(5).equals("Y")) {
					%><%=subContentSpace %><%
				}
				%><b><font size="3" color="red"><%=row.getValue(3) %></font></b><%
		}else if (optType.equals("title_bold")) {
			if (parentCol != null)
				col = Integer.parseInt(parentCol);
			else
				col = Integer.parseInt(row.getValue(4));

			if (col > maxCol) {
				maxCol = col;
			}
			%><%-- <tr><td colspan='<%=maxCol %>' copyable='<%=row.getValue(6)%>'> --%><%

					// for medication report
					//if ("8".equals(PiReportDB.getIncidentType(pirID)) || "530".equals(PiReportDB.getIncidentType(pirID))) {
					if (PiReportDB.hasParentDesc(grpID) && editAction) {
						if (record.size() - i == 1 && maxCol - printCol > 1) {
							%><td copyable='<%=row.getValue(6)%>' colspan='<%=maxCol - printCol%>'><%
						}
						else {
							%><tr><td></td></tr><td copyable='<%=row.getValue(6)%>'><%
						}
					} else {
						if (record.size() - i == 1 && maxCol - printCol > 1) {
							%><td copyable='<%=row.getValue(6)%>' colspan='<%=maxCol - printCol%>'><%
						}
						else {
							%><td copyable='<%=row.getValue(6)%>'><%
						}
					}

			if (row.getValue(5).equals("Y")) {
				%><%=subContentSpace %><%
			}
			%><b><%=row.getValue(3) %></b><%
		}else {
			if (record.size() - i == 1 && maxCol - printCol > 1) {
				%><td copyable='<%=row.getValue(6)%>' colspan='<%=maxCol - printCol%>'><%
			}
			else {
				%><td copyable='<%=row.getValue(6)%>'><%
			}

			if (row.getValue(5).equals("Y")) {
				%><%=subContentSpace %><%
			}
			if (optType.equals("checkbox")) {
				if (viewAction) {
					if (row.getValue(11).length() > 0) {
				%>
					<img src='../images/tick_green_small.gif'/>
				<%
					}
				%>
					<span optType='checkbox' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(10)+suffix %>'>
						<%
						//if ("12".equals(row.getValue(1))) { ////for med disp desc 29112017
						if (PiReportDB.hasParentDesc(grpID)) {
						%>
						<%
							if (PiReportDB.getParentDesc(row.getValue(0)) != null) {
						%>
							<%=PiReportDB.getParentDesc(row.getValue(0))%>
						<%
							}
						%>
						<%}
						%>&nbsp;
						<%=row.getValue(3) %>
					</span></td>
				<%
				}
				else {
				%>
					<input optType='checkbox' type='checkbox' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(10)+suffix %>'
						value='<%=row.getValue(3) %>'
						<%=(editHasValue)?("checked contentId='"+row.getValue(13)+"'"):"" %>
						/>&nbsp;<%=row.getValue(3) %></td>
				<%
				}
			}
			else if (optType.equals("checkInput")) {
				if (viewAction) {
					if (row.getValue(11).length() > 0) {
				%>
					<img src='../images/tick_green_small.gif'/>
				<%
					}
				%>
					<span optType='checkInput' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(10)+suffix %>'>
						&nbsp;<b><%=row.getValue(3) %></b> <%=row.getValue(11) %>
					</span>
					</td>
				<%
				}else {
				%>
					<input optType='checkInput' type='checkbox' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(10)+suffix %>'
						<%=(editHasValue)?("checked contentId='"+row.getValue(13)+"'"):"" %>/>&nbsp;<%=row.getValue(3) %>
					<input type='text' name='<%=row.getValue(0)+suffix %>_Input' value='<%=(editHasValue)?row.getValue(11):"" %>' style='width:50%'/></td>
				<%
				}
			}
			else if (optType.equals("yesNo")) {

				if (optionRemark.equals(null) || optionRemark.equals("")){
					optionLabel1 = "Yes";
					optionLabel2 = "No";
				} else {
					optionLabel1 = optionRemark.substring(0, optionRemark.indexOf("~"));
					optionRemark = optionRemark.substring(optionRemark.indexOf("~")+1);
					optionLabel2 = optionRemark.substring(0, optionRemark.indexOf("~"));
					optionRemark = optionRemark.substring(optionRemark.indexOf("~")+1);
					optionLabel3 = optionRemark.substring(0, optionRemark.indexOf("~"));

					System.out.println("optionLabel1, optionLabel2, optionLabel3 : " + optionLabel1 + ", " + optionLabel2 + ", " + optionLabel3);
					//optionLabel3 = optionRemark.substring(optionRemark.indexOf("~")+1);
				}

				if (viewAction) {
				%>
					<b><%=row.getValue(3) %></b>&nbsp;<%=(row.getValue(11).equals("Y")?optionLabel1:(row.getValue(11).equals("N")?optionLabel2:"")) %>
					</td>
				<%
				}
				else {
				%>
						<b><%=row.getValue(3) %></b>
						&nbsp;<input optType='yesNo' type='radio' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(3)+suffix %>'
						parent='<%=row.getValue(10) %>' value='Y' <%=(editHasValue)?(row.getValue(11).equals("Y")?"checked contentId='"+row.getValue(13)+"'":""):"" %>/><%=optionLabel1%>
						&nbsp;<input optType='yesNo' type='radio' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(3)+suffix %>'
						parent='<%=row.getValue(10) %>' value='N' <%=(editHasValue)?(row.getValue(11).equals("N")?"checked contentId='"+row.getValue(13)+"'":""):"" %>/><%=optionLabel2%>
						</td>
				<%
				}
				printCol = col-1;
			}
		else if (optType.equals("sexMFU")) {

			if (optionRemark.equals(null) || optionRemark.equals("")){
				optionLabel1 = "Yes";
				optionLabel2 = "No";
			} else {
				optionLabel1 = optionRemark.substring(0, optionRemark.indexOf("~"));
				optionRemark = optionRemark.substring(optionRemark.indexOf("~")+1);
				optionLabel2 = optionRemark.substring(0, optionRemark.indexOf("~"));
				optionRemark = optionRemark.substring(optionRemark.indexOf("~")+1);
				optionLabel3 = optionRemark.substring(0, optionRemark.indexOf("~"));

				System.out.println("optionLabel1, optionLabel2, optionLabel3 : " + optionLabel1 + ", " + optionLabel2 + ", " + optionLabel3);
				//optionLabel3 = optionRemark.substring(optionRemark.indexOf("~")+1);
			}

			if (viewAction) {
			%>
				<b><%=row.getValue(3) %></b>&nbsp;<%=(row.getValue(11).equals("M")?optionLabel1:(row.getValue(11).equals("F")?optionLabel2:(row.getValue(11).equals("U")?optionLabel3:""))) %>
				</td>
			<%
			}
			else {
			%>
				<%
				if (optionRemark.equals(null) || optionRemark.equals("")){
				%>
					<b><%=row.getValue(3) %></b>
					&nbsp;<input optType='yesNo' type='radio' category='<%=row.getValue(1) %>'
					id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(3)+suffix %>'
					parent='<%=row.getValue(10) %>' value='Y' <%=(editHasValue)?(row.getValue(11).equals("Y")?"checked contentId='"+row.getValue(13)+"'":""):"" %>/><%=optionLabel1%>
					&nbsp;<input optType='yesNo' type='radio' category='<%=row.getValue(1) %>'
					id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(3)+suffix %>'
					parent='<%=row.getValue(10) %>' value='N' <%=(editHasValue)?(row.getValue(11).equals("N")?"checked contentId='"+row.getValue(13)+"'":""):"" %>/><%=optionLabel2%>
					</td>
				<%
				} else {
				%>
					<b><%=row.getValue(3) %></b>
					&nbsp;<input optType='yesNo' type='radio' category='<%=row.getValue(1) %>'
					id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(3)+suffix %>'
					parent='<%=row.getValue(10) %>' value='M' <%=(editHasValue)?(row.getValue(11).equals("Y")?"checked contentId='"+row.getValue(13)+"'":""):"" %>/><%=optionLabel1%>
					&nbsp;<input optType='yesNo' type='radio' category='<%=row.getValue(1) %>'
					id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(3)+suffix %>'
					parent='<%=row.getValue(10) %>' value='F' <%=(editHasValue)?(row.getValue(11).equals("N")?"checked contentId='"+row.getValue(13)+"'":""):"" %>/><%=optionLabel2%>
					&nbsp;<input optType='yesNo' type='radio' category='<%=row.getValue(1) %>'
					id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(3)+suffix %>'
					parent='<%=row.getValue(10) %>' value='U' <%=(editHasValue)?(row.getValue(11).equals("N")?"checked contentId='"+row.getValue(13)+"'":""):"" %>/><%=optionLabel3%>
					</td>
				<%
				}%>
			<%
			}
			printCol = col-1;
		}
		else if (optType.equals("input")) {
				%>
					<b><%=row.getValue(3) %></b><br/>
				<%
				if (row.getValue(5).equals("Y")) {
					%><%=subContentSpace %><%
				}
				if (viewAction) {
				%>
					<%=row.getValue(11)%></td>
				<%
				}
				else {
				%>
					<input optType='input' style='width:70%' type='text'
						category='<%=row.getValue(1) %>' id='<%=row.getValue(0)+suffix %>' <%=(editHasValue)?("contentId='"+row.getValue(13)+"'"):""%>
						parent='<%=row.getValue(10) %>' value='<%=(editHasValue)?row.getValue(11):"" %>'/></td>
				<%
				}
				printCol = col-1;
			}
			else if (optType.equals("input_notitle")) {
				if (row.getValue(5).equals("Y")) {
					%><%=subContentSpace %><%
				}
				if (viewAction) {
				%>
					<%=row.getValue(11)%></td>
				<%
				}
				else {
				%>
					<input optType='input' style='width:70%' type='text'
						category='<%=row.getValue(1) %>' id='<%=row.getValue(0)+suffix %>' <%=(editHasValue)?("contentId='"+row.getValue(13)+"'"):""%>
						parent='<%=row.getValue(10) %>' value='<%=(editHasValue)?row.getValue(11):"" %>'/></td>
				<%
				}
				printCol = col-1;
			}
			else if (optType.equals("textarea")) {
				if (viewAction) {
				%>
					<b><%=row.getValue(3) %></b><br/>
					<%
					String tmpValue = StringEscapeUtils.escapeHtml(row.getValue(11));
					%>
					<%
					if (PiReportDB.hasParentDesc(grpID)) {
					%>
					<%
						if (row.getValue(0) == null) {
					%>
						<%=tmpValue %></td>
					<%
						} else {
					%>
						<%=PiReportDB.getParentDesc(row.getValue(0))%>&nbsp;<%=tmpValue %></td>
					<%
						}
					%>
					<%
					} else {
					%>
						<%=parseTextArea(tmpValue) %></td>
					<%
					}
					%>
				<%
				}
				else {
				%>
					<b><%=row.getValue(3) %></b><br/>
					<textarea optType='textarea' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' parent='<%=row.getValue(10) %>' <%=(editHasValue)?("contentId='" + row.getValue(13) + "'"):""%>
						style='width:100%' rows='5' value=''><%=(editHasValue)?row.getValue(11):"" %></textarea></td>
				<%
				}
			}
			else if (optType.equals("upload")) {
				if (viewAction || editHasValue) {
				%>
					<div optType='upload' class='upload' id='<%=row.getValue(0)+suffix %>'
						parent='<%=row.getValue(10) %>' category='<%=row.getValue(1) %>'
						<%=(editHasValue)?("contentId = '"+row.getValue(13)+"' docIDs='"+row.getValue(11)+"'"):"" %>>
						<jsp:include page="../common/document_list.jsp">
							<jsp:param name="moduleCode" value="pireport" />
							<jsp:param name="keyID" value="<%=pirID%>" />
							<jsp:param name="docIDs" value="<%=row.getValue(11)%>" />
							<jsp:param name="separator" value="" />
						</jsp:include>
					</div>
					</td>
				<%
				}
				else {

				%>
					<div optType='upload' class='upload' id='<%=row.getValue(0)+suffix %>'
						parent='<%=row.getValue(10) %>' category='<%=row.getValue(1) %>'>
						<%=row.getValue(3) %>
						<input type='file' category='<%=row.getValue(1) %>' name='<%=row.getValue(0)+suffix %>'
						size='30' maxlength='5'/><br/>
					</div></td>
				<%
				}
			}
			else if (optType.equals("checkboxInput")) {
				String inputBefore = row.getValue(3).substring(0, row.getValue(3).indexOf("__"));
				String inputAfter = row.getValue(3).substring(row.getValue(3).indexOf("__"), row.getValue(3).length()).substring(2);

				if (viewAction) {
					if (row.getValue(11).length() > 0) {
				%>
					<img src='../images/tick_green_small.gif'/>
				<%
					}
				%>
					&nbsp;<%=inputBefore %>&nbsp;<b><%=row.getValue(11) %></b>&nbsp;<%=inputAfter %></td>
				<%
				}
				else {
				%>
					<input optType='checkboxInput' type='checkbox' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(10)+suffix %>' <%=(editHasValue)?("checked contentId='"+row.getValue(13)+"'"):"" %>/>&nbsp;<%=inputBefore %>
					<input style='width:20%' type='text' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' parent='<%=row.getValue(10) %>' value='<%=(editHasValue)?row.getValue(11):""%>'/><%=inputAfter %></td>
				<%
				}
			}
			else if (optType.equals("inputAfterTitle")) {
				String inputBefore = row.getValue(3).substring(0, row.getValue(3).indexOf("__"));
				String inputAfter = row.getValue(3).substring(row.getValue(3).indexOf("__"), row.getValue(3).length()).substring(2);

				%>
				<%--
					<b><%=row.getValue(3) %></b><br/>
				--%>
				<%
				if (row.getValue(5).equals("Y")) {
				%>
				<%--
					<%=subContentSpace %>
				--%>
				<%
				}
				if (viewAction) {
				%>
					<%--
					<%=row.getValue(11)%></td>
					--%>
					&nbsp;<%=inputBefore %>&nbsp;<b><%=row.getValue(11) %></b>&nbsp;<%=inputAfter%></td>
				<%
				}
				else {
				%>
					&nbsp;<%=inputBefore %>
					<input optType='input' style='width:10%' type='text'
						category='<%=row.getValue(1) %>' id='<%=row.getValue(0)+suffix %>' <%=(editHasValue)?("contentId='"+row.getValue(13)+"'"):""%>
						parent='<%=row.getValue(10) %>' value='<%=(editHasValue)?row.getValue(11):"" %>'/>
					<%=inputAfter %></td>

					<%--
					&nbsp;<%=inputBefore %>
					<input style='width:10%' type='text' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0) %>' parent='<%=row.getValue(10) %>' value='<%=(editHasValue)?row.getValue(11):""%>'/>
					<%=inputAfter %></td>
					--%>

				<%
				}
				printCol = col-1;
			}
			else if (optType.equals("remark")) {
				%>
					<b><i><%=row.getValue(3) %></i></b></td>
				<%
			}
			else if (optType.equals("radio")) {
				if (viewAction) {
					if (row.getValue(11).length() > 0) {
				%>
					<%=row.getValue(3) %></td>
				<%
					}
				}
				else {
				%>
					<input optType='radio' type='radio' category='<%=row.getValue(1) %>' id='<%=row.getValue(0)+suffix %>'
						name='<%=row.getValue(10)+suffix %>' <%=(editHasValue)?("checked contentId='"+row.getValue(13)+"'"):"" %>/>&nbsp;<%=row.getValue(3) %></td>
				<%
				}
			}
			else if (optType.equals("checkboxDate")) {
				if (viewAction) {
					if (row.getValue(11).length() > 0) {
				%>
					<img src='../images/tick_green_small.gif'/>
				<%
					}
				%>
					<span optType='checkboxDate' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(10)+suffix %>'>
						&nbsp;<%=row.getValue(3) %> <%=row.getValue(11) %>
					</span>
					</td>
				<%
				}else {
				%>
					<input optType='checkboxDate' type='checkbox' category='<%=row.getValue(1) %>'
						id='<%=row.getValue(0)+suffix %>' name='<%=row.getValue(10)+suffix %>'
						<%=(editHasValue)?("checked contentId='"+row.getValue(13)+"'"):"" %>/>&nbsp;<%=row.getValue(3) %>
					<input type='textfield' category='<%=row.getValue(1) %>' id='<%=row.getValue(0)+suffix %>'
						optid='<%=row.getValue(0)+suffix %>' class='datepickerfield' value='<%=(editHasValue)?row.getValue(11):""%>' maxlength='16' size='16'></td>
				<%
				}
			}
			else if (optType.equals("date")) {
				if (viewAction) {
					if (row.getValue(11).length() > 0) {
				%>
					<b><%=row.getValue(3) %></b>&nbsp;<%=row.getValue(11) %></td>
				<%
					}
				}
				else {
				%>
					<%=row.getValue(3) %>
					<input optType='date' type='textfield' category='<%=row.getValue(1) %>'
						optid='<%=row.getValue(0)+suffix %>' id='<%=row.getValue(0)+suffix %>' class='datepickerfield' <%=(editHasValue)?("contentId='"+row.getValue(13)+"'"):""%>
						parent='<%=row.getValue(10) %>' value='<%=(editHasValue)?row.getValue(11):""%>' maxlength='16' size='16'></td>
				<%
				}
			}
			else if (optType.equals("datetime")) {
				if (viewAction) {
					if (row.getValue(11).length() > 0) {
				%>
					<b><%=row.getValue(3) %></b>&nbsp;<%=row.getValue(11) %></td>
				<%
					}
				}
				else {
				%>
					<%=row.getValue(3) %>
					<input optType='datetime' type='textfield' category='<%=row.getValue(1) %>' id='<%=row.getValue(0)+suffix %>'
						optid='<%=row.getValue(0)+suffix %>' class='datepickerfield' parent='<%=row.getValue(10) %>' value='<%=(editHasValue)?row.getValue(11).split(" ")[0]:""%>'
						maxlength='16' size='16' <%=(editHasValue)?("contentId='"+row.getValue(13)+"'"):"" %>/>
					<jsp:include page='../ui/timeCMB.jsp' flush='false'>
						<jsp:param name='label' value='<%=row.getValue(0)+suffix %>' />
						<jsp:param name='time' value='<%=(row.getValue(11).length() > 0)?row.getValue(11).split(" ")[1]:""%>' />
						<jsp:param name='allowEmpty' value='N' />
					</jsp:include></td>
				<%
				}
			}
			else if (optType.equals("copy")) {
				%>
								</td>
							</tr>
						</tbody>
					</table>
				<%
				if (!viewAction) {
				%>
					<div style="float:left;" id="addImage">
						<img src="../images/add.jpg" style="cursor:pointer" onclick="copyAndPasteDom(this)"/>
						<div id='template<%=row.getValue(0)+suffix %>' style='display:none'>
							<table style='width:100%;border-style:groove;border-color:gray;border-spacing:10px;'
								count='0' index='0' contentGrpID='0'>
								<tbody>
				<%
					if (pirID != null) {
				%>
									<jsp:include page="../pi/report_details_flwUp.jsp" flush="false">
										<jsp:param name="subContent" value="Y" />
										<jsp:param name="parentID" value="<%=row.getValue(0)%>" />
										<jsp:param name="grpID" value="<%=grpID%>" />
										<jsp:param name="col" value="<%=col%>" />
										<jsp:param name="template" value="Y" />
										<jsp:param name="pirID" value="<%=pirID %>" />
										<jsp:param name="action" value="<%=action %>" />
									</jsp:include>
				<%
					}
					else {
				%>
									<jsp:include page="../pi/report_details_flwUp.jsp" flush="false">
										<jsp:param name="subContent" value="Y" />
										<jsp:param name="parentID" value="<%=row.getValue(0)%>" />
										<jsp:param name="grpID" value="<%=grpID%>" />
										<jsp:param name="col" value="<%=col%>" />
										<jsp:param name="template" value="Y" />
										<jsp:param name="pirID" value="" />
										<jsp:param name="action" value="" />
									</jsp:include>
				<%
					}
				%>
								</tbody>
							</table>
						</div>
					</div>
				<%
				}
				if (!template && (viewAction || editAction) && !row.getValue(12).equals("1")) {
					currentGrpID = Integer.parseInt(row.getValue(12));
				}
				if (editAction) {
					%>
						<div style='float:right;' id='removeImage'>
							<img src='../images/delete1.png' style='cursor:pointer' onclick='delPasteDom(this)'/>
						</div>
					<%
				}
				%>
					<table class="copy" style='width:100%;border-style:groove;border-color:gray;border-spacing:10px;' count='0' index='0' contentGrpID='<%=currentGrpID%>' grpID='<%=grpID%>'>
						<tbody>
				<%
				printCol--;
			}
		}
		printCol++;
		if (printCol == col) {
			printCol = 0;
			%>
				</tr>
			<%
		}
		if (row.getValue(7).equals("Y")) {
			%>
				<jsp:include page="../pi/report_details_flwUp.jsp" flush="false">
					<jsp:param name="subContent" value="Y" />
					<jsp:param name="parentID" value="<%=row.getValue(0)%>" />
					<jsp:param name="grpID" value="<%=grpID%>" />
					<jsp:param name="col" value="<%=col%>" />
					<jsp:param name="action" value="<%=action%>" />
				</jsp:include>
			<%
		}
	}

	if (!subContent) {
	%>
			</tbody>
		</table>
	<%
	}
}
%>