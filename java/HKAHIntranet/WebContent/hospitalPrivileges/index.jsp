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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html>
<jsp:include page="../common/header.jsp"/>
<head>
<title>Hong Kong Adventist Hospital - Hospital Privileges</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<script language=JavaScript src="<html:rewrite page="/js/internet/common.js" />"></script>
<script language="JavaScript" src="<html:rewrite page="/js/internet/scroll.js" />"></script>
<script type="text/javascript" src="<html:rewrite page="/js/internet/objectSwap.js" />"></script>
<script type="text/javascript" src="<html:rewrite page="/js/internet/chanlang.js" />"></script>
<link rel="stylesheet" href="<html:rewrite page="/css/style_internet.css" />" type="text/css">
<style>
	body { background: #f5f1ee; }
	.acknowledgements { font-weight: bold; }
	li.list1 {
  		list-style-type: square;
	}
</style>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <table border="0" cellspacing="0" cellpadding="0" align="center">
    <tr align="left" valign="top">
      <td width="5"><img src="<html:rewrite page="/images/internet/box.gif" />" width="5" height="16"></td>
      <td width="780">&nbsp;</td>
      <td width="5"><img src="<html:rewrite page="/images/internet/box.gif" />" width="5" height="16"></td>
    </tr>

    <tr align="left" valign="top">
      <td width="5" background="<html:rewrite page="/images/internet/border_24.jpg" />"><img src="<html:rewrite page="/images/internet/border_03.jpg" />"></td>
      <td width="780">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="left" valign="top" background="<html:rewrite page="/images/internet/index_04.jpg" />">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top">
                  <td width="312"><a href="https://www.hkah.org.hk/en/main"><img src="<html:rewrite page="/images/internet/index_03.jpg" />" border="0"></a></td>
                  <td><!-- #BeginLibraryItem "/Library/eng_lang.lbi" --><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>

                      <td align="right" valign="top"><img src="<html:rewrite page="/images/internet/spacer.gif" />" width="20" height="20"></td>
                    </tr>
                    <tr>
                      <td align="right" valign="top">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="top">
        </tr>
      </table>
                      </td>

                    </tr>
                    <tr>
                      <td align="right" valign="top" height="50">&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right" valign="top"></td>
                    </tr>
                  </table><!-- #EndLibraryItem --></td>
                  <td width="21"><img src="<html:rewrite page="/images/internet/index_06.jpg" />"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td align="left" valign="top"><img src="<html:rewrite page="/images/internet/header_about_hkah2.jpg" />" border="0"></td>
          </tr>
          <tr>
            <td align="left" valign="top" background="<html:rewrite page="/images/internet/index_54.jpg" />">
              <table cellspacing="0" cellpadding="0" width="100%">
                <tr align="left" valign="top">
                  <td width="90"><img src="<html:rewrite page="/images/internet/spacer.gif" />" width="90" height="10"></td>
                  <td>
				  <table>
				   <tr>
				   	<td>
				  		<table>
				  			<tr>
				  				<td><b>1.Application Procedures</b></td>
				  			</tr>
							<tr>
								<td><br>&nbsp;&nbsp;1.1	Please submit the following documents with your application:</td>
							</tr>
							<tr>
								<td>
									<span style="position:relative;left:25;">
										<table>
											<tr><td valign="top">*</td><td>Completed application form</td></tr>
											<tr><td valign="top">*</td><td>Recent Photo</td></tr>
											<tr><td valign="top">*</td><td>Copies of certificates:  Medical / Dental School qualifications, Internship, Residencies, and Fellowships.</td></tr>
											<tr><td valign="top">*</td><td>Curriculum vitae</td></tr>
											<tr><td valign="top">*</td><td>A copy of your Hong Kong Medical Registration Certificate, and your current Annual Practicing Certificate for Hong Kong;</td></tr>
											<tr><td valign="top">*</td><td>A copy of your Specialist Registration Certificate, if applicable</td></tr>
											<tr><td valign="top">*</td><td>Malpractice Insurance Certificate and a current valid receipt from your insurer</td></tr>
											<tr><td valign="top">*</td><td>Signed reply slip of PHA Code of Practice</td></tr>
											<tr><td valign="top">*</td><td>Signed form for Release of Medical Protection Society Membership Information Pre- Authorization Letter</td></tr>
											<tr><td valign="top">*</td><td>The names of three Referees & Three Reference Forms</td></tr>
											<tr><td valign="top">*</td><td>If you are also applying for special procedure privileges, documentation of your experience in regard to the particular procedure must be provided</td></tr>
										</table>
									</span>
									<br>
								</td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;1.2	Professional References</td>
							</tr>
							<tr>
								<td>
									<span style="position:relative;left:30; line-height:150%;">
									The Hospital requires this Reference Form to be completed, together with the Reference Letter, as part of your application process.  This constitutes your authority to provide information about your character and professional abilities, favorable or otherwise, directly to Hong Kong Adventist Hospital.<br><br>
									Names of three Referees, together with their mailing addresses / Email addresses / FAX numbers are required.  One of the referees must be a physician who is practicing in the same specialty as the applicant.
									</span>
									<br><br>
								</td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;1.3	How to submit the documents to the Hospital</td>
							</tr>
							<tr>
								<td>
									<span style="position:relative;left:30; line-height:150%;">
									Please contact the Medical Affairs Office (Direct phone: 2835 0570) for a copy of the Application Form, or download the Application Form from the Hospital’s website
									(<a href="https://www.hkah.org.hk/en/main">Hong Kong Adventist Hospital - Stubbs Road</a>).
									<br><br>
									Completed Application Forms, together with all documents listed under paragraph 1.1 should be returned to the Hospital Medical Affairs Office at 4C, La Rue Building, Hong Kong Adventist Hospital - Stubbs Road, 40 Stubbs Road, Wanchai, Hong Kong.  (By FAX 2574 6001 or Email
									(<a href="mailto:medicalaffairs@hkah.org.hk">medicalaffairs@hkah.org.hk</a>)
									</span>
									<br><br>
								</td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;1.4	Application result notification</td>
							</tr>
							<tr>
								<td>
									<span style="position:relative;left:30; line-height:150%;">
									Application processing normally takes 8-10 weeks.  A letter will be sent by post to the applicant, informing them of the Hospital’s decision.
									</span>
								</td>
							</tr>
				  			<tr>
				  				<td><br><b>2.Updating of Doctor’s Information</b></td>
				  			</tr>
							<tr>
								<td>
									<span style="position:relative;left:10;line-height:150%;">
									Each doctor is required to send copies of their annual renewal Practicing Certificate and Malpractice Insurance Certificate to the Hospital, in order to update the Hospital’s Doctor Database.  The Hospital formally updates all doctor’s personal data every three years.  Doctors are also required to inform the Hospital in writing, whenever there is any change in their personal or professional data.
									</span>
								</td>
							</tr>
				  			<tr>
				  				<td><br><b>Doctors are advised to study the Hospital information & guidelines for applicants, prior to making application</b></td>
				  			</tr>
							<tr>
								<td>
									<span style="position:relative;left:20;">

									<ul class="filetree" style="list-style-type: none;">
									<li>Application Form Download { <a href="javascript:void(0);" onclick="downloadFile('353','Medical-Dental Staff Privilege Application Form (Oct 2010).pdf');return false;" target="_blank">pdf format</a> } { <a href="javascript:void(0);" onclick="downloadFile('353','Medical-Dental Staff Privilege Application Form (Oct 2010).doc');return false;" target="_blank">word format</a> }</li>
									<li>Medical Staff By-Laws, Rules and Regulations { <a href="javascript:void(0);" onclick="downloadFile('353','HKAH Medical-Dental Staff Rules and Regulations (April 2008).pdf');return false;" target="_blank">pdf format</a> } </li>
									<li>Code of Practice of PHA { <a href="javascript:void(0);" onclick="downloadFile('353','PHACode of Practice final version 20111103.pdf');return false;" target="_blank">pdf format</a> }</li>
									<li>Release of Medical Protection Society Membership Information Pre-Authorization Letter{ <a href="javascript:void(0);" onclick="downloadFile('353','MPS Pre-Authorization Release Form.pdf');return false;" target="_blank">pdf format</a> }</li>
									<li>Reference Form Download { <a href="javascript:void(0);" onclick="downloadFile('353','Reference Request Form.pdf');return false;" target="_blank">pdf format</a> } { <a href="javascript:void(0);" onclick="downloadFile('353','Reference Request Form.doc');return false;" target="_blank">word format</a> }</li>
									<li>Application Form Download (Laparoscopic / Endoscopic Surgery Application Form) { <a href="javascript:void(0);" onclick="downloadFile('353','Laparoscopic-Endoscopic Surgery Privilege (Jan 2011).pdf');return false;" target="_blank">pdf format</a> } </li>
									<li>Application Form Download (Gastrointestinal Endoscopy Application Form) { <a href="javascript:void(0);" onclick="downloadFile('353','Gastrointestinal Endoscopy Privilege.pdf');return false;" target="_blank">pdf format</a> }</li>
									<li><b>Guidelines for Robotic Surgery Privilege {</b>
									<a href="javascript:void(0);" onclick="downloadFile('353','Guidelines for Robotic Surgery Privilege (Jan 2013).pdf');return false;" target="_blank">pdf format</a> } 
									and Sample - Certificate(s) {  <a href="javascript:void(0);" onclick="downloadFile('353','Sample - Certificates.pdf');return false;" target="_blank">pdf format</a> }</li>
									<li>Application Form Download (Robotic Surgery Application Form) { <a href="javascript:void(0);" onclick="downloadFile('353','Application Form for Robotic Surgery Privilege (Jan 2013).pdf');return false;" target="_blank">pdf format</a> }</li>

									</ul>
									</span>
									<br>
								</td>
							</tr>
							<%--
				  			<tr>
				  				<td>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="hospital.privileges" />
	<jsp:param name="skipColumnTitle" value="Y" />
    <jsp:param name="mustLogin" value="N" />
    <jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
				  				</td>
				  			</tr>
							--%>
						</table>
				 	</td>
				    </tr>
				  </table>
                  </td>
                  <td valign="bottom" width="90"><img src="<html:rewrite page="/images/internet/service_15.jpg" />" width="90" height="29"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td align="left" valign="top" background="<html:rewrite page="/images/internet/index_54.jpg" />"><!-- #BeginLibraryItem "/Library/eng_footer.lbi" --><table width="100%" border="0" cellspacing="0" cellpadding="4">
              <tr align="left" valign="top">
                <td class="content9" width="10"><img src="<html:rewrite page="/images/internet/spacer.gif" />" width="10" height="5"></td>
                <td class="content9"></td>
    			<td align="right" class="content9"></td>
                <td class="content9" width="10" align="left" valign="top"><img src="<html:rewrite page="/images/internet/spacer.gif" />" width="10" height="5"></td>
              </tr>
            </table><!-- #EndLibraryItem --></td>
          </tr>
        </table>
      </td>
      <td background="<html:rewrite page="/images/internet/border_32.jpg" />" width="5"><img src="<html:rewrite page="/images/internet/border_08.jpg" />"></td>
    </tr>
    <tr align="left" valign="top">
      <td width="5"><img src="<html:rewrite page="/images/internet/border_61.jpg" />"></td>
      <td width="780"><img src="<html:rewrite page="/images/internet/index_55.jpg" />"></td>
      <td width="5"><img src="<html:rewrite page="/images/internet/border_63.jpg" />"></td>
    </tr>
    <tr align="left" valign="top">
      <td width="5">&nbsp;</td>
      <td width="780"></td>
      <td width="5">&nbsp;</td>
    </tr>
  </table>

  </form>
  <script type="text/javascript" src="<html:rewrite page="/js/menu.js" />"></script>
  <script type="text/javascript" src="<html:rewrite page="/js/tracking.js" />"></script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html>