<%
String sessionKey = request.getParameter("session");
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<body>
		<center>
			<table width="700" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align="left"><img src="../images/hkah_portal_logo.gif" border="0" width="261" height="113" /></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
			<table width="700" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center">
						<b class="b1"></b><b class="b2"></b><b class="b3"></b><b class="b4"></b>
						<div class="contentb">
							<table width="690" border="0" cellpadding="0" cellspacing="0" style="background-color:white;">
								<tr>
									<td rowspan="2" width="10">&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2">
										<div style="font-size:22px; text-align:left; color:#FF2626">
											Please pay attention. 
										</div>
										<br/>
										<div style="font-size:22px; text-align:left; color:#FF2626">
											If you browse this web page through your mobile phone, your telecommunications service provider may charge a fee for data usage.   Please also note that data roaming charges may apply for overseas access, for details kindly contact your telecommunications service provider.
										</div>
										<br/><br/>
										<div style="font-size:22px; text-align:left; color:#C30000;">
											閣下 如使用手提電話瀏覽此網頁，電話網絡供應商可能就數據用量而收取費用。  尤其是海外使用量的收費，詳情請與您的電訊服務供應商聯繫，敬請留意。
										</div>
										<br/><br/>
									</td>
								</tr>
								<tr>
									<td rowspan="2" width="10">&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2">
										<div class="pane">
											<table>
												<tr>
													<td>
														<form name="form1" action="../registration/intro.jsp" method="post">
															<button onclick="submitAction();" class="btn-click">Online check-in 網上登記入院</button>
															<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
														</form>
													</td>
												</tr>
											</table>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<b class="b4"></b><b class="b3"></b><b class="b2"></b><b class="b1"></b>
					</td>
				</tr>
			</table>
		</center>
		<script language="javascript">
			function submitAction() {
				document.form1.submit();
			}
		</script>
	</body>
</html:html>
