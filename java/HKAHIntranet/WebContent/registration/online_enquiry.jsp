<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String step = request.getParameter("step");

String clientID = null;
String source = request.getParameter("source");
String lastName = TextUtil.parseStrUTF8(request.getParameter("lastName"));
String firstName = TextUtil.parseStrUTF8(request.getParameter("firstName"));
String title = request.getParameter("title");
String ageGroup = request.getParameter("ageGroup");
String mobilePhone = request.getParameter("mobilePhone");
String email = request.getParameter("email");
String plan = request.getParameter("plan");
String willingPromotion = request.getParameter("willingPromotion");
String eventID = request.getParameter("eventID");
if (willingPromotion == null) {
	willingPromotion = "N";
}
boolean success = false;
String errorMessage = "";

if ("1".equals(step) || lastName != null) {
	String scheduleID = "1";
	if ("Geobaby".equals(source)) {
		scheduleID = "1";
		eventID = "1147";
	} else if ("YWCA".equals(source)) {
		scheduleID = "2";
	} else if ("EDM".equals(source)) {
		scheduleID = "3";
		eventID = "1143";
	} else {
		scheduleID = "1";
		eventID = "1147";
		source = "Geobaby";
	}

	if (scheduleID != null) {
		clientID = CRMClientDB.add(lastName, firstName,
					null, title, null, null,
					null, null, null,
					null, null, null,
					ageGroup, null, null, null, null,
					null, null, null, null, null, null, null,
					null, null, null, mobilePhone, null,
					email, null, null, null,
					null, null, willingPromotion, null,
					new String[] {ConstantsServerSide.SITE_CODE + "-750"}, ConstantsServerSide.SITE_CODE, "750", source, null, null,false);

		if (clientID != null) {
			EnrollmentDB.enroll("crm", eventID, scheduleID, ConstantsVariable.ONE_VALUE, "patient", clientID, source, null, plan);
			// send email
			if (email != null && email.length() > 0) {
				UtilMail.sendMail(
					ConstantsServerSide.MAIL_ALERT,
					new String[] { email },
					null,
					null,
					"Notification from Hong Kong Adventist Hospital",
					"Thank you for your enquiry, we will contact you shortly to arrange an appointment");
			}

			StringBuffer commentStr = new StringBuffer();
			StringBuffer commentStrDental = new StringBuffer();
			if ("EDM".equals(source)) {
				commentStr.append("New Registration from EDM ");
			}
			if ("Geobaby".equals(source)) {
				commentStr.append("New Registration from Geobaby ");
				commentStrDental.append("New Registration from Geobaby ");
			}
			commentStr.append("<br>Please click <a href=\"http://");
			commentStr.append(ConstantsServerSide.INTRANET_URL);
			commentStr.append("/intranet/crm/client_info.jsp?command=view&clientID=");
			commentStr.append(clientID);
			commentStr.append("\">Intranet</a> or <a href=\"https://");
			commentStr.append(ConstantsServerSide.OFFSITE_URL);
			commentStr.append("/intranet/crm/client_info.jsp?command=view&clientID=");
			commentStr.append(clientID);
			commentStr.append("\">Offsite</a> to view the CRM.");

			String titleRepresent = null;
			if ("1".equals(title)) {
		      titleRepresent = "Mr.";
			} else if ("2".equals(title)) {
			  titleRepresent = "Miss.";
			} else if ("3".equals(title)) {
				titleRepresent = "Mrs.";
			}
			String ageRepresent = null;
			if ("1".equals(ageGroup)) {
				ageRepresent = "11 - 20 ";
			} else if ("2".equals(ageGroup)) {
				ageRepresent = "21 - 30 ";
			} else if ("3".equals(ageGroup)) {
				ageRepresent = "31 - 40 ";
			} else if ("4".equals(ageGroup)) {
				ageRepresent = "41 - 50 ";
			} else if ("5".equals(ageGroup)) {
				ageRepresent = "51 - 60 ";
			} else if ("6".equals(ageGroup)) {
				ageRepresent = "61 or above ";
			}
			commentStrDental.append("<br>The following is the information of patient registered for Dental Services: ");
			commentStrDental.append("<br>Patient Name: "+titleRepresent+ lastName.toUpperCase()+","+firstName);
			commentStrDental.append("<br>Age: "+ ageRepresent);
			commentStrDental.append("<br>Contact Number: "+ mobilePhone);
			commentStrDental.append("<br>E - Mail : "+ email);

			// notify marketing
			if ("Geobaby".equals(source)) {
				if ("1147".equals(eventID)) {
					UtilMail.sendMail(
							ConstantsServerSide.MAIL_ALERT,
							new String[] { "isabelle.leung@hkah.org.hk" },
							new String[] { "christine.chow@hkah.org.hk", "cordelia.ip@hkah.org.hk" },
							new String[] { ConstantsServerSide.MAIL_ADMIN },
							"New Registration (From Intranet Portal - CRM)",
							commentStr.toString());
				} else {
					UtilMail.sendMail(
							ConstantsServerSide.MAIL_ALERT,
							new String[] { "dental@hkah.org.hk" },
							new String[] { "christine.chow@hkah.org.hk", "cordelia.ip@hkah.org.hk" },
							new String[] { ConstantsServerSide.MAIL_ADMIN },
							"New Registration From Geobaby.com on Dental Services",
							commentStrDental.toString());
				}
			} else if ("EDM".equals(source)) {
				UtilMail.sendMail(
						ConstantsServerSide.MAIL_ALERT,
						new String[] { "Becky_Yau@hkah.org.hk" , "callcentre@hkah.org.hk" },
						new String[] { "christine.chow@hkah.org.hk", "cordelia.ip@hkah.org.hk" },
						new String[] { ConstantsServerSide.MAIL_ADMIN },
						"New Registration (From Intranet Portal - CRM)",
						commentStr.toString());
			} else {
				UtilMail.sendMail(
						ConstantsServerSide.MAIL_ALERT,
						new String[] { "Becky_Yau@hkah.org.hk" , "callcentre@hkah.org.hk" },
						new String[] { "christine.chow@hkah.org.hk", "cordelia.ip@hkah.org.hk" },
						new String[] { ConstantsServerSide.MAIL_ADMIN },
						"New Registration From Geobaby.com",
						commentStrDental.toString());
			}
			success = true;
			step = null;
		} else {
			errorMessage = "Fail to submit information. Please try again.";
		}
	} else {
		errorMessage = "Submit from unknown website. We accept the sumittion from Geobaby or YWCA only.";
	}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=big5" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<center>
<br /><br /><br />
<%if (success) { %>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center"><img src="../images/logo_hkah.gif" border="0" /></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="left"><strong><span class="enquiryLabel bigText">Thank you for your enquiry, we will contact you shortly to arrange an appointment.</span></strong></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
<%} else { %>
<form action="online_enquiry.jsp" method="post" name="registration">
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td align="center">
		<b class="b1_4"></b><b class="b2_4"></b><b class="b3_4"></b><b class="b4_4"></b>
		<div class="contentb">
			<font color="white"><%=errorMessage %></font>
			<table width="690" border="0" cellpadding="0" cellspacing="0" style="background-color:white;">
<tr>
    <td>
    <IMG src="../images/header.jpg" width=650 height=156>
    </td>
</tr>
<%if (!"Geobaby".equals(source) && !"1146".equals(eventID)) {%>
<tr align="left">
	<td>
		<span class="enquiryLabel middleText">
		Which package you would like to choose? (Plan A/ Plan B)?<br>
		</span>
	</td>
</tr>
<tr align="left">
	<td>
	<span class="enquiryLabel middleText">
	<br>
	<input name="plan" type="radio" value="Plan A" />Plan A &nbsp;&nbsp;
	<input name="plan" type="radio" value="Plan B" />Plan B &nbsp;&nbsp;
	</span>
<tr>
<%} %>
	<td><span><br>Please leave your contact information to us, and we will contact you<br></span>
	</td>
</tr>

<tr align="left">
	<td>
	 <table>
	<tr>
	<td>
	<br>
	  <span class="enquiryLabel middleText">Last Name
	  </span><br />
		<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName %>" maxlength="50" size="25">
	</td>
	<td width="30">&nbsp;</td>
								<td>
									<span class="enquiryLabel middleText">First Name</span><br />
									<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>" maxlength="50" size="25">
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr align="left">
					<td align="left height="40">
						<span class="enquiryLabel middleText">Title </span><br />
						&nbsp;&nbsp;&nbsp;
						<input name="title" type="radio" value="1" />Mr.
						<input name="title" type="radio" value="2" />Miss.
						<input name="title" type="radio" value="3" />Mrs.
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr align="left">
					<td height="40">
						<span class="enquiryLabel middleText">Age Group </span><br />
						&nbsp;&nbsp;&nbsp;
						<input name="ageGroup" type="radio" value="2" />11-20&nbsp;&nbsp;
						<input name="ageGroup" type="radio" value="3" />21-30&nbsp;&nbsp;
						<input name="ageGroup" type="radio" value="4" />31-40&nbsp;&nbsp;
						<input name="ageGroup" type="radio" value="5" />41-50&nbsp;&nbsp;
						<input name="ageGroup" type="radio" value="6" />51-60&nbsp;&nbsp;
						<input name="ageGroup" type="radio" value="7" />61 or above
						<span><br><span class="enquiryLabel middleText"></span></span>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr align="left">
					<td height="40">
						<span class="enquiryLabel middleText">Contact Number (Daytime) </span><br />
						<input type="textfield" name="mobilePhone" value="<%=mobilePhone==null?"":mobilePhone %>" maxlength="50" size="25">
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr align="left">
					<td><span class="enquiryLabel middleText">Email <br />
						<input type="textfield" name="email" value="<%=email==null?"":email %>" maxlength="50" size="25">
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>



				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr align="left">
					<td>
						Privacy Policy Statement <br />
						<input type="checkbox" name="willingPromotion" value="Y">
						Please be assured that your information will be kept highly confidential. However, the hospital may use your personal data for in-house direct mailing purpose. If you do not wish to be on our mailing list, please check this box.
						<BR>

					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0">
						<tr>
							<td width="10%">&nbsp;</td>
							<td width="80%" align="center">
								<a href="javascript:void(0);" onclick="submitAction();return false;"><img src="../images/submit.jpg"></a>
								<a href="javascript:void(0);" onclick="resetAction();"><img src="../images/reset.jpg"></a>
							</td>
							<td width="10%" align="right"><img src="../images/logo_hkah.gif" border="0" width="130" height="56" /></td>
						</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<b class="b4_4"></b><b class="b3_4"></b><b class="b2_4"></b><b class="b1_4"></b>
	</td>
</tr>
</table>
<input type="hidden" name="step" value="1">
<input type="hidden" name="source" value="<%=source==null?"":source %>">
</form>
<%} %>
</center>
<script language="javascript">
	function submitAction() {
		if (document.registration.lastName.value=="") {
			alert('Please provide your last name!');
			document.registration.lastName.focus();
			return false;
		}

		if (document.registration.firstName.value=="") {
			alert('Please provide your first Name!');
			document.registration.firstName.focus();
			return false;
		}
		if (document.registration.mobilePhone.value=="") {
			alert('Please provide your contact number!');
			document.registration.mobilePhone.focus();
			return false;
		}
		if (document.registration.email.value=="") {
			alert('Please provide your email!');
			document.registration.email.focus();
			return false;
		}

		document.registration.submit();
	}

	function resetAction() {
		document.registration.lastName.value="";
		document.registration.firstName.value="";
		document.registration.mobilePhone.value="";
		document.registration.email.value="";
	}
</script>
</body>
</html:html>