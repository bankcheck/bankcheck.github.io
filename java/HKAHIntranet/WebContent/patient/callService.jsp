<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	<jsp:include page="header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	<style>
	#title {
		font-size:28px;
		font-weight:bold;
	}
	.content {
		font-size:16px;
		text-align:justify;
		width:100%;
	}
	.subTitle {
		font-size:20px;
		font-weight:bold;
	}
	</style>
	<body>
		<%-- 
		<jsp:include page="../patient/checkSession.jsp" />
		--%>
		<form name="form1">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tbody>
					<%--<jsp:include page="../patient/patientInfo.jsp" /> --%>
					<tr><td>&nbsp;</td></tr>
					<tr id="eng_content" style="display:none;">
						<td align="center">
							<div style="width:70%;" align="left">
								<h1 id="title">International Call Service</h1>
				
								<p class="content">For International calls, there are various options:</p>
								
								<h2 class="subTitle">1.	BBG Services</h2>
						
								<p class="content">BBG is an external long distance call service provider that connects your long 
									distance calls and will directly charge you via your credit card according to 
									their company’s price schedule. For BBG services and price schedule, please 
									dial *88 and follow the instruction.</p>
						
								<h2 class="subTitle">2.	IDD Password</h2>
						
								<p class="content">Our In-patient Department may provide you with an IDD password that enables long 
									distance phone calls to be made at your own convenience using the in-room extension 
									line. Password may be requested upon admission or any time during your stay. Call 
									charges will be forwarded to your bills at the end of each call. Please feel free 
									to come to the Admission Office for password application.</p>
						
								<h2 class="subTitle">3.	Operator Services</h2>
						
								<p class="content">We may also connect your long distance calls whenever needed. Please call Information 
									Desk at ext. 1300 for operator assistance.</p>
						
								<p class="content">To receive incoming calls, the caller can telephone the hospital (3651-8888) and 
									request your room number and bed number.  The operator will then make the requested 
									connection.</p>
									
								<br/>
								<br/>
								<table style="width:100%; border-width:1px; border-style:double;">
									<tr>
										<td style="border-width:1px; padding:1px; border-style:double;">
											<p class="subTitle">Remark:</p>
										</td>
									</tr>
									<tr>
										<td style="border-width:1px; padding:1px; border-style:double;">
											<p class="subTitle">IDD country and area code:</p>
											<br/>
											<p class="content">Please call 9 + 1000 or 
												<a class="subTitle" target="_blank" href="http://www.pccw.com/Customer+Service/Directory+Inquiries/International+Telephone+Numbers/IDD+Codes+%26+Local+Times+Worldwide?language=en_US" >Click here</a>
											</p>
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
					
					<tr id="chi_content" style="display:none;">
						<td align="center">
							<div style="width:70%;" align="left">
								<h1 id="title">國際長途電話服務</h1>
				
								<p class="content">如欲撥打海外電話，可選擇以下三種方法：</p>
								
								<h2 class="subTitle">1.	BBG服務</h2>
						
								<p class="content">BBG是一個長途電話服務供應商。當您誘過BBG撥打海外電話
								時，費用將直接以閣下的信用卡繳付，而通話收費則由供應商訂定。如欲查詢BBG服
								務及其收費詳情，請致電*88。</p>
						
								<h2 class="subTitle">2.	IDD密碼</h2>
						
								<p class="content">我們的住院服務部可為您提供一個IDD密碼，讓您可隨時使用
								病房的電話致電海外親友。電話收費會記錄在住院賬單之上。如有需要，您可到本院
								的入院部辦公室申請密碼。</p>
						
								<h2 class="subTitle">3.	長途電話接駁服務</h2>
						
								<p class="content">如有需要，本院亦可提供長途電話接駁服務。請致電內線1300
								向本院詢問處查詢有關服務詳情。</p>
						
								<p class="content">如欲接聽海外親友的電話，請提醒他們先致電本院電話總機
								(3651-8888)，索取您的房號及床號。接線的職員會進行轉駁。</p>
								
								<br/>
								<br/>
								<table style="width:100%; border-width:1px; border-style:double;">
									<tr>
										<td style="border-width:1px; padding:1px; border-style:double;">
											<p class="subTitle">備註:</p>
										</td>
									</tr>
									<tr>
										<td style="border-width:1px; padding:1px; border-style:double;">
											<p class="subTitle">國家編號及地區字頭:</p>
											<br/>
											<p class="content">請先按9再致電1000   或  
												<a class="subTitle" target="_blank" href="http://www.pccw.com/Customer+Service/Directory+Inquiries/International+Telephone+Numbers/IDD+Codes+%26+Local+Times+Worldwide?language=zh_HK" >請按此處</a>
												。
											</p>
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<script language="javascript">
			var lang = '<%=session.getAttribute(Globals.LOCALE_KEY).toString()%>';
			
			function submitAction() {
				showLoadingBox();
				document.form1.action = "../patient/";
				document.form1.submit();
				hideLoadingBox();
			}
			
			$(document).ready(function() {
				if(lang == "zh_TW" || lang == "zh_CN") {
					$('#chi_content').css('display', '');
				}else {
					$('#eng_content').css('display', '');
				}
			});
		</script>
		<jsp:include page="footer.jsp" flush="false" />
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>