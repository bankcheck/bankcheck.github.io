<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>

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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	
	<body>
		<div id="index_content">
			<table style="width:100%;height:auto">
				<tr>
					<td colspan="2">
						<jsp:include page="main_banner.jsp" flush="false"/>
					</td>
				</tr>
				<tr>
					<td>
						<iframe name="main_content" src="main_content.jsp" 
								width="100%" height="800px" frameborder="0" scrolling="auto">
						</iframe>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="right">
						<jsp:include page="footer.jsp" flush="false"/>	
					</td>
				</tr>
			</table>
		</div>
		<br/>
	</body>
	<%-- 
	<frameset border="0" frameborder="0" framespacing="0" rows="100, *">
		<frame name="top" src="main_banner.jsp" noresize></frame>
		<frame name="bottom" src="main_content.jsp" noresize></frame>
		<noframes>
			<P>Please use Internet Explorer or Mozilla!
		</noframes>
	</frameset>
	--%>
</html:html>