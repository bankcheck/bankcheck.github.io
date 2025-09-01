<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
	UserBean userBean = new UserBean(request);
	String action = request.getParameter("action");
	
	if(action != null && (action.equals("view") || action.equals("edit"))) {
		String pirID = request.getParameter("pirID");

		ArrayList record = PiReportDB.fetchReportInvlovePerson(pirID);
		if(record.size() > 0) {
			boolean patient = false;
			boolean staff = false;
			boolean visitor = false;
			boolean other = false;
			
			for(int i = 0; i < record.size(); i++) {
				ReportableListObject row = (ReportableListObject) record.get(i);
				
				if(action.equals("edit")) {
					if(row.getValue(2).equals("true") && !patient) {
						patient = true;
						%><div id="involvedPartyInfoPatient"><%
					}
					else if(row.getValue(3).equals("true") && !staff) {
						staff = true;
						if(patient) {
							%></div><div id="involvedPartyInfoStaff"><%
						}
						else {
							patient = true;
							%><div id="involvedPartyInfoPatient"></div><div id="involvedPartyInfoStaff"><%
						}
					}
					else if(row.getValue(4).equals("true") && !visitor) {
						visitor = true;
						if(staff) {
							%></div><div id="involvedPartyInfoVisitor"><%
						}
						else {
							staff = true;
							if(patient) {
								%></div><div id="involvedPartyInfoStaff"></div><div id="involvedPartyInfoVisitor"><%
							}
							else {
								%><div id="involvedPartyInfoPatient"></div><div id="involvedPartyInfoStaff"></div><div id="involvedPartyInfoVisitor"><%
							}
						}
					}
					else if(row.getValue(5).equals("true") && !other) {
						other = true;
						if(visitor) {
							%></div><div id="involvedPartyInfoOther"><%
						}
						else {
							visitor = true;
							if(staff) {
								%></div><div id="involvedPartyInfoVisitor"></div><div id="involvedPartyInfoOther"><%
							}
							else {
								if(patient) {
									%></div><div id="involvedPartyInfoStaff"></div><div id="involvedPartyInfoVisitor"></div><div id="involvedPartyInfoOther"><%
								}
								else {
									%><div id="involvedPartyInfoPatient"></div><div id="involvedPartyInfoStaff"></div><div id="involvedPartyInfoVisitor"></div><div id="involvedPartyInfoOther"><%
								}
							}
						}
					}
				}
				
				if(row.getValue(2).equals("true")) {
%>
		<div class="involvedPartyInfoPatient">
			<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%">
	 		<tr class="smallText">
				<td class="infoSubTitle11" colspan="6">Involving Person-Patient Info</td>
				<%if(action.equals("edit")) { %>
					<td>
						<img style="cursor: pointer" src="../images/remove-button.gif" alt="Delete" class="removeInvolvePatientInfo"/>
					</td>
				<%} %>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Hospital No</td>
				<td class="infoData" width="10%">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="patHosNo" value="<%=row.getValue(6) %>" maxlength="10" size="20" class="notEmpty referKey" keyType="patient"/>
					<%}else { %>
						<%=row.getValue(6) %>
					<%} %>
				</td>
				<td class="infoLabel" width="10%" colspan="2">Name</td>
				<td class="infoData" width="65%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="patName" value="<%=row.getValue(8) %>" maxlength="100" size="40" class=""/>
						<b><font color="red"><< Is the patient info. correct ?>></font></b>
					<%}else { %>
						<%=row.getValue(8) %>
					<%} %>				
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Sex</td>
				<td class="infoData" width="10%">
					<%if(action.equals("edit")) { %>
						<select name="patSex">
							<option value=""></option>
							<option value="M" <%=row.getValue(9).equals("Male")?"selected":"" %>>Male</option>
							<option value="F" <%=row.getValue(9).equals("Female")?"selected":"" %>>Female</option>
						</select>
					<%}else { %>
						<%=row.getValue(9) %>
					<%} %>
				</td>
				<td class="infoLabel" width="10%">Age</td>
				<td class="infoData" width="10%">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="patAge" value="<%=row.getValue(10) %>" maxlength="10" size="20" class=""/>
					<%}else { %>
						<%=row.getValue(10) %>
					<%} %>
				</td>
				<td class="infoLabel" width="10%">DOB</td>
				<td class="infoData" width="45%" colspan="">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="patDOB" class="datepickerfield" value="<%=row.getValue(11) %>" maxlength="10" size="16"/>
					<%}else { %>
						<%=row.getValue(11) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Doctor In Charge</td>
				<td class="infoData" width="85%" colspan="5">
					<%if(action.equals("edit")) { %>
						
						 
						<input type="textfield" name="attPhy" value="<%=row.getValue(21) %>" maxlength="100" size="100"/>					
						
						<%-- 
						<select name="attPhy">
							<option value="">--Select Doctor--</option>
							<option value="Other">--Others, Please Specify--</option>
							<%
								if ("0".equals(row.getValue(26))) {
							%>	
								<option value="<%=row.getValue(21) %>" selected><%=row.getValue(21) %></option>
							<%
								}
							%>									
								<jsp:include page="piDocCodeCMB.jsp" flush="false">
									<jsp:param name="allowAll" value="Y" />
									<jsp:param name="doccode" value="<%=row.getValue(21) %>" />
								</jsp:include>										
						</select>						
						<span id='freetextSpan'></span>	
						<input name="attPhyOther" value="<%=row.getValue(27) %>" type="hidden"/>
						--%>			 
					<%}else { %>
						<%="0".equals(row.getValue(26)) ? row.getValue(21) : row.getValue(25) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Diagnosis</td>
				<td class="infoData" width="85%" colspan="5">
					<%if(action.equals("edit")) { %>
						<textarea name="diagnosis" rows="3" style='width:100%' value="<%=row.getValue(22) %>" maxlength="300"><%=row.getValue(22) %></textarea>
					<%}else { %>
						<%=row.getValue(22) %>
					<%} %>
				</td>
				<%if(action.equals("edit")) { %>
					<td>
						<img style="cursor: pointer" src="../images/plus.gif" width="10" height="10" alt="Add" class="AddInvolvePatientInfo"/>
					</td>
				<%} %>
			</tr>
			<tr><td><input type="hidden" name="pir_ip_id" value="<%=row.getValue(1)%>"/></td></tr>
		</table>
	</div>
<%
				}
				else if(row.getValue(3).equals("true")) {
%>
	<div class="involvedPartyInfoStaff">
		<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%">
	 		<tr class="smallText">
				<td class="infoSubTitle11" colspan="6">Involving Person-Staff Info</td>
				<%if(action.equals("edit")) { %>
					<td>
						<img style="cursor: pointer" src="../images/remove-button.gif" alt="Delete" class="removeInvolvePatientInfo"/>
					</td>
				<%} %>
			</tr>
				<%if(action.equals("edit")) { %>
							<tr class="smallText">
								<td class="infoData" width="10%" colspan="6">
									<input type="checkbox" name="sameAsReport" value="patient" class="notEmpty referKeyChkBox" keyType="staff" <%=(row.getValue(15).equals("true")?"checked":"") %>/>Same as reporting Person
								</td>
							</tr>
				<%}else { %>
					<%if(row.getValue(15).equals("true")) { %>
						<tr class="smallText">
							<td class="infoData" width="10%" colspan="6">
								<img src="../images/tick_green_small.gif"/> Same as reporting Person
							</td>
						</tr>
					<%} %>
				<%} %>	
			<tr class="smallText">
				<td class="infoLabel" width="40%">Staff No</td>
				<td class="infoData" width="20%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveStaffNo" value="<%=row.getValue(7) %>" maxlength="10" size="20" class="notEmpty referKey" keyType="staff"/>
					<%}else { %>
						<%=row.getValue(7) %>
					<%} %>
				</td>
				<td class="infoLabel" width="10%">Hospital No</td>
				<td class="infoData" width="30%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involeStaffHosNo" value="<%=row.getValue(6) %>" maxlength="10" size="20" class="" keyType="patient"/>
					<%}else { %>
						<%=row.getValue(6) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Name</td>
				<td class="infoData" width="60%" colspan="5">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveStaffName" value="<%=row.getValue(8) %>" maxlength="100" size="20" class=""/>
					<%}else { %>
						<%=row.getValue(8) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Position</td>
				<td class="infoData" width="60%" colspan="5">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveStaffRank" value="<%=row.getValue(12) %>" maxlength="100" size="20"/>
					<%}else { %>
						<%=row.getValue(12) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Department</td>
				<td class="infoData" width="60%" colspan="5">
					<%if(action.equals("edit")) { %>
						<select name="involveStaffDept">
							<option value=""></option>
							<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
								<jsp:param name="deptCode" value="<%=row.getValue(20) %>" />
								<jsp:param name="includeAllDept" value="Y" />
								<jsp:param name="allowAll" value="Y" />
							</jsp:include>
						</select>
					<%}else { %>
						<%=row.getValue(13) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Sex</td>
				<td class="infoData" width="60%" colspan="5">
					<%if(action.equals("edit")) { %>
						<select name="involveStaffSex">
							<option value=""></option>
							<option value="M" <%=row.getValue(9).equals("Male")?"selected":"" %>>Male</option>
							<option value="F" <%=row.getValue(9).equals("Female")?"selected":"" %>>Female</option>
						</select>
					<%}else { %>
						<%=row.getValue(9) %>
					<%} %>
				</td>
				<%if(action.equals("edit")) { %>
					<td>
						<img style="cursor: pointer" src="../images/plus.gif" width="10" height="10" alt="Add" class="AddInvolveStaffInfo"/>
					</td>
				<%} %>
			</tr>
			<tr><td><input type="hidden" name="pir_ip_id" value="<%=row.getValue(1)%>"/></td></tr>
		</table>
	</div>
<%
				}
				else if(row.getValue(4).equals("true")) {
%>
	<div class="involvedPartyInfoVisitor">
		<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%">
	 		<tr class="smallText">
				<td class="infoSubTitle11" colspan="3">Involving Person- Visitor/Relatives Info</td>
				<%if(action.equals("edit")) { %>
					<td>
						<img style="cursor: pointer" src="../images/remove-button.gif" alt="Delete" class="removeInvolvePatientInfo"/>
					</td>
				<%} %>
			</tr>
			<tr class="smallText">
				<td class="infoData" width="20%">
					<%if(action.equals("edit")) { %>
						<input type="checkbox" name="visitorOfPat" value="patient" onclick="" <%=(row.getValue(17).equals("true")?"checked":"") %>/>Visitor/Relatives of Patient
					<%}else { %>
						<%if(row.getValue(17).equals("true")) { %>
							<img src="../images/tick_green_small.gif"/> Visitor/Relatives of Patient
						<%} %>
					<%} %>
				</td>
				
				<td class="infoLabel" width="10%">Patient No</td>
				<td class="infoData" width="70%">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveVisitPatNo" value="<%=row.getValue(6) %>" maxlength="10" size="20" class="referKey" keyType="patient"/>
					<%}else { %>
						<%=row.getValue(6) %>
					<%} %>
					<%if(action.equals("edit")) { %>
						<%--
						<input type="textfield" name="involveVisitorPatName" value="<%=row.getValue(8) %>" maxlength="100" size="20" class=""/>
						--%>
						<label name ="involveVisitorPatName"></label>
					<%}else { %>
						<%//=row.getValue(25) %>
					<%} %>					
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoData" width="20%">
					<%if(action.equals("edit")) { %>
						<input type="checkbox" name="visitorOfStaff" value="patient" onclick="" <%=(row.getValue(18).equals("true")?"checked":"") %>/>Visitor/Relatives of Staff
					<%}else { %>
						<%if(row.getValue(18).equals("true")) { %>
							<img src="../images/tick_green_small.gif"/> Visitor/Relatives of Staff
						<%} %>
					<%} %>
				</td>
				<td class="infoLabel" width="10%">Staff No</td>
				<td class="infoData" width="70%">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveVisitStaffNo" value="<%=row.getValue(7) %>" maxlength="10" size="20" class="referKey" keyType="staff"/>
					<%}else { %>
						<%=row.getValue(7) %>
					<%} %>
					<%if(action.equals("edit")) { %>
						<%--
						<input type="textfield" name="involveVisitorStaffName" value="<%=row.getValue(8) %>" maxlength="100" size="20" class=""/>
						--%>
						<label name ="involveVisitorStaffName"></label>
					<%}else { %>
						<%//=row.getValue(25) %>
					<%} %>					
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Visitor/Relatives Name</td>
				<td class="infoData" width="60%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveVisitorName" value="<%=row.getValue(8) %>" maxlength="100" size="70" class="notEmpty"/>
					<%}else { %>
						<%=row.getValue(8) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Relationship</td>
				<td class="infoData" width="60%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveVisitorRelationship" value="<%=row.getValue(16) %>" maxlength="20" size="70"/>
					<%}else { %>
						<%=row.getValue(16) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Contact Phone No.</td>
				<td class="infoData" width="60%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveVisitorTel" value="<%=row.getValue(23) %>" maxlength="20" size="50"/>
					<%}else { %>
						<%=row.getValue(23) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Contact Address</td>
				<td class="infoData" width="60%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveVisitorAddr" value="<%=row.getValue(24) %>" maxlength="100" size="100"/>
					<%}else { %>
						<%=row.getValue(24) %>
					<%} %>
				</td>
			</tr>

			<tr class="smallText">
				<td class="infoLabel" width="40%">Remark</td>
				<td class="infoData" width="60%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveVisitorRemark" value="<%=row.getValue(14) %>" maxlength="100" size="100"/>
					<%}else { %>
						<%=row.getValue(14) %>
					<%} %>
				</td>
				<%if(action.equals("edit")) { %>
					<td>
						<img style="cursor: pointer" src="../images/plus.gif" width="10" height="10" alt="Add" class="AddInvolveVisitorInfo"/>
					</td>
				<%} %>
			</tr>
			<tr><td><input type="hidden" name="pir_ip_id" value="<%=row.getValue(1)%>"/></td></tr>
		</table>
	</div>
<%
				}
				else if(row.getValue(5).equals("true")) {
%>
	<div class="involvedPartyInfoOther">
		<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%">
	 		<tr class="smallText">
				<td class="infoSubTitle11" colspan="3">Involving Person- Others Info</td>
				<%if(action.equals("edit")) { %>
					<td>
						<img style="cursor: pointer" src="../images/remove-button.gif" alt="Delete" class="removeInvolvePatientInfo"/>
					</td>
				<%} %>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Status</td>
				<td class="infoData" width="60%" colspan="2">
					<%if(action.equals("edit")) { %>
						<select name="involveOthersStatus">
							<option value="doctor" <%=(row.getValue(19).equals("doctor")?"selected":"")%>>Doctor</option>
							<option value="volunteer" <%=(row.getValue(19).equals("volunteer")?"selected":"")%>>Volunteer</option>
							<option value="other" <%=(row.getValue(19).equals("other")?"selected":"")%>>Other</option>
						</select>
					<%}else { %>
						<%=row.getValue(19).toUpperCase() %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Name</td>
				<td class="infoData" width="60%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveOtherName" value="<%=row.getValue(8) %>" maxlength="100" size="70" class="notEmpty"/>
					<%}else { %>
						<%=row.getValue(8) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Contact Phone No.</td>
				<td class="infoData" width="60%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveOtherTel" value="<%=row.getValue(23) %>" maxlength="100" size="50"/>
					<%}else { %>
						<%=row.getValue(23) %>
					<%} %>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Contact Address</td>
				<td class="infoData" width="60%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveOtherAddr" value="<%=row.getValue(24) %>" maxlength="100" size="100"/>
					<%}else { %>
						<%=row.getValue(24) %>
					<%} %>
				</td>
			</tr>		
				
			<tr class="smallText">
				<td class="infoLabel" width="40%">Remark</td>
				<td class="infoData" width="60%" colspan="2">
					<%if(action.equals("edit")) { %>
						<input type="textfield" name="involveOtherRemark" value="<%=row.getValue(14) %>" maxlength="100" size="100"/>
					<%}else { %>
						<%=row.getValue(14) %>
					<%} %>
				</td>
				<%if(action.equals("edit")) { %>
					<td>
						<img style="cursor: pointer" src="../images/plus.gif" width="10" height="10" alt="Add" class="AddInvolveOthersInfo"/>
					</td>
				<%} %>
			</tr>						
			<tr><td><input type="hidden" name="pir_ip_id" value="<%=row.getValue(1)%>"/></td></tr>
		</table>
	</div>
<%
				}
			}
			if(action.equals("edit")) {
				if(other) {
					%></div><%
				}
				else{
					if(visitor) {
						%></div><div id="involvedPartyInfoOther"></div><%
					}
					else{
						if(staff) {
							%></div><div id="involvedPartyInfoVisitor"></div><div id="involvedPartyInfoOther"></div><%
						}
						else {
							if(patient) {
								%></div><div id="involvedPartyInfoStaff"></div><div id="involvedPartyInfoVisitor"></div><div id="involvedPartyInfoOther"></div><%
							}
							else {
								%><div id="involvedPartyInfoPatient"></div><div id="involvedPartyInfoStaff"></div><div id="involvedPartyInfoVisitor"></div><div id="involvedPartyInfoOther"></div><%
							}
						}
					}
				}
			}
		}
		else {
%>
			<div id="involvedPartyInfoPatient">
			</div>
			<div id="involvedPartyInfoStaff">
			</div>
			<div id="involvedPartyInfoVisitor">
			</div>
			<div id="involvedPartyInfoOther">
			</div>
<%
		}
	}else {
%>
	<div id="hiddenInvolvePatientInfo" style="display:none;">
		<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%">
	 		<tr class="smallText">
				<td class="infoSubTitle11" colspan="6">Involving Person-Patient Info</td>
				<td>
					<img style="cursor: pointer" src="../images/remove-button.gif" alt="Delete" class="removeInvolvePatientInfo"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Hospital No</td>
				<td class="infoData" width="10%">
					<input type="textfield" name="patHosNo" value="" maxlength="10" size="20" class="notEmpty referKey" keyType="patient"/>
				</td>
				<td class="infoLabel" width="10%" colspan="2">Name</td>
				<td class="infoData" width="65%" colspan="2">
					<input type="textfield" name="patName" value="" maxlength="100" size="40" class=""/>
					<b><font color="red"><< Is the patient info. correct ?>></font></b>
				</td>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Sex</td>
				<td class="infoData" width="10%">
					<select name="patSex">
						<option value=""></option>
						<option value="M">Male</option>
						<option value="F">Female</option>
					</select>
				</td>
				<td class="infoLabel" width="10%">Age</td>
				<td class="infoData" width="10%">
					<input type="textfield" name="patAge" value="" maxlength="10" size="20" class=""/>
				</td>
				<td class="infoLabel" width="10%">DOB</td>
				<td class="infoData" width="45%">
					<input type="textfield" name="patDOB" class="datepickerfield" value="" maxlength="10" size="16"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Doctor In Charge</td>
				<td class="infoData" width="85%" colspan="5">					
											
					<input type="textfield" name="attPhy" value="" maxlength="100" size="100"/>					
					
					
					<%--
							<jsp:include page="piDocCodeCMB.jsp" flush="false">
								<jsp:param name="allowAll" value="Y" />							
								
									<jsp:param name="value" value="" />
									<jsp:param name="allowEmpty" value="Y" />
									<jsp:param name="selectName" value="docCode" />
									<jsp:param name="selectClass" value="" />
									<jsp:param name="inputValue" value="" />
												
							</jsp:include>							
					For Doctor NOT in List: 
					<input name="otherDocCode" value="" type="text" size=60/>
					 --%>
										
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Diagnosis</td>
				<td class="infoData" width="85%" colspan="5">
					<textarea name="diagnosis" rows="3" style='width:100%' maxlength="300"></textarea>
				</td>
				<td>
					<img style="cursor: pointer" src="../images/plus.gif" width="10" height="10" alt="Add" class="AddInvolvePatientInfo"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="hiddenInvolveStaffInfo" style="display:none;">
		<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%">
	 		<tr class="smallText">
				<td class="infoSubTitle11" colspan="6">Involving Person-Staff Info</td>
				<td>
					<img style="cursor: pointer" src="../images/remove-button.gif" alt="Delete" class="removeInvolvePatientInfo"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoData" width="10%" colspan="6">
					<input type="checkbox" name="sameAsReport" value="patient" class="notEmpty referKeyChkBox" keyType="staff"/>Same as reporting Person
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Staff No</td>
				<td class="infoData" width="20%" colspan="2">
					<input type="textfield" name="involveStaffNo" value="" maxlength="10" size="20" class="notEmpty referKey" keyType="staff"/>
				</td>
				<td class="infoLabel" width="10%">Hospital No</td>
				<td class="infoData" width="30%" colspan="2">
					<input type="textfield" name="involeStaffHosNo" value="" maxlength="10" size="20" class="" keyType="patient"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Name</td>
				<td class="infoData" width="60%" colspan="5">
					<input type="textfield" name="involveStaffName" value="" maxlength="100" size="20" class=""/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Position</td>
				<td class="infoData" width="60%" colspan="5">
					<input type="textfield" name="involveStaffRank" value="" maxlength="100" size="20"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Department</td>
				<td class="infoData" width="60%" colspan="5">
					<select name="involveStaffDept">
					<option value=""></option>
						<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
							<jsp:param name="deptCode" value="" />
							<jsp:param name="includeAllDept" value="Y" />
							<jsp:param name="allowAll" value="Y" />
						</jsp:include>
					</select>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Sex</td>
				<td class="infoData" width="60%" colspan="5">
					<select name="involveStaffSex">
						<option value=""></option>
						<option value="M">Male</option>
						<option value="F">Female</option>
					</select>
				</td>
				<td>
					<img style="cursor: pointer" src="../images/plus.gif" width="10" height="10" alt="Add" class="AddInvolveStaffInfo"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="hiddenInvolveVisitorInfo" style="display:none;">
		<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%">
	 		<tr class="smallText">
				<td class="infoSubTitle11" colspan="3">Involving Person- Visitor/Relatives Info</td>
				<td>
					<img style="cursor: pointer" src="../images/remove-button.gif" alt="Delete" class="removeInvolvePatientInfo"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoData" width="20%">
					<input type="checkbox" name="visitorOfPat" value="patient" onclick=""/>Visitor/Relatives of Patient
				</td>
				<td class="infoLabel" width="10%">Patient No</td>
				<td class="infoData" width="70%">
					<input type="textfield" name="involveVisitPatNo" value="" maxlength="10" size="20" keyType="patient" class="referKey"/>
					<%--
					<input type="textfield" name="involveVisitorPatName" value="" maxlength="100" size="40" class=""/>
					 --%>					
					 <label name ="involveVisitorPatName"></label>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoData" width="20%">
					<input type="checkbox" name="visitorOfStaff" value="patient" onclick=""/>Visitor/Relatives of Staff
				</td>
				<td class="infoLabel" width="10%">Staff No</td>
				<td class="infoData" width="70%">
					<input type="textfield" name="involveVisitStaffNo" value="" maxlength="10" size="20" keyType="staff" class="referKey"/>
					<%--
					<input type="textfield" name="involveVisitorStaffName" value="" maxlength="100" size="40" class=""/>
					 --%>
					<label name ="involveVisitorStaffName"></label>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Visitor/Relatives Name</td>
				<td class="infoData" width="60%" colspan="2">
					<input type="textfield" name="involveVisitorName" value="" maxlength="100" size="70" class="notEmpty"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Relationship</td>
				<td class="infoData" width="60%" colspan="2">
					<input type="textfield" name="involveVisitorRelationship" value="" maxlength="20" size="70"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Contact Phone No.</td>
				<td class="infoData" width="60%" colspan="2">
					<input type="textfield" name="involveVisitorTel" value="" maxlength="20" size="50"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Contact Address</td>
				<td class="infoData" width="60%" colspan="2">
					<input type="textfield" name="involveVisitorAddr" value="" maxlength="100" size="100"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Remark</td>
				<td class="infoData" width="60%" colspan="2">
					<input type="textfield" name="involveVisitorRemark" value="" maxlength="100" size="100"/>
				</td>
				<td>
					<img style="cursor: pointer" src="../images/plus.gif" width="10" height="10" alt="Add" class="AddInvolveVisitorInfo"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="hiddenInvolveOthersInfo" style="display:none;">
		<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%">
	 		<tr class="smallText">
			<td class="infoSubTitle11" colspan="3">Involving Person- Others Info</td>
			<td>
				<img style="cursor: pointer" src="../images/remove-button.gif" alt="Delete" class="removeInvolvePatientInfo"/>
			</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Status</td>
				<td class="infoData" width="60%" colspan="2">
					<select name="involveOthersStatus">
						<option value="doctor">Doctor</option>
						<option value="volunteer">Volunteer</option>
						<option value="other">Other</option>
					</select>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Name</td>
				<td class="infoData" width="60%" colspan="2">
					<input type="textfield" name="involveOtherName" value="" maxlength="100" size="70" class="notEmpty"/>
				</td>
			</tr>

			<tr class="smallText">
				<td class="infoLabel" width="40%">Contact Phone No.</td>
				<td class="infoData" width="60%" colspan="2">
					<input type="textfield" name="involveOtherTel" value="" maxlength="100" size="50"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Contact Address</td>
				<td class="infoData" width="60%" colspan="2">
					<input type="textfield" name="involveOtherAddr" value="" maxlength="100" size="100"/>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="40%">Remark</td>
				<td class="infoData" width="60%" colspan="2">
					<input type="textfield" name="involveOtherRemark" value="" maxlength="100" size="100"/>
				</td>
				<td>
					<img style="cursor: pointer" src="../images/plus.gif" width="10" height="10" alt="Add" class="AddInvolveOthersInfo"/>
				</td>
			</tr>
		</table>
	</div>
<%	} %>


<script>
var selectNamePhyOther = $('input[name=attPhyOther]').val();
$('select[name=docode]').change(function() {
	//var freetext = $(this).find(":selected").attr('freetext');
	var freetextValue = ($(this).find(":selected").attr('freetextValue'));
	$('#freetextSpan').html('');
	if(freetext == 'Other'){
		$('#freetextSpan').append('<input name="'+selectName+'_freetext" type="textfield" value="'+freetextValue+'" style="width:250px;"></input>');
	}else{
		$('#freetextSpan').html('');
	}
});

$(document).ready(function() {
	$('select[name=docode]').change();
});
</script>