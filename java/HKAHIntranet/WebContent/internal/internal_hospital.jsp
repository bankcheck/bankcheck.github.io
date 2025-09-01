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
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Hospital Intranet" />
	<jsp:param name="translate" value="N" />
</jsp:include>
<table border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
<td align=center>
<br><br><br>
<p><img src="../images/list.jpg" border=0 width="536" height="137" usemap="#Map" />
  <map name="Map" id="Map">
    <area shape="rect" coords="3,4,127,131" href="dept_info.jsp" />
    <area shape="rect" coords="137,5,267,129" href="\\hkim\im\Intranet\hkah\hr_online.html" />
    <area shape="rect" coords="275,5,397,131" href="\\hkim\im\Intranet\hkah\news_info.html" />
    <area shape="rect" coords="413,3,529,132" href="\\hkim\im\Intranet\hkah\reflibrary.html" />
  </map>
</p>
<p>&nbsp;</p>
<br>
</td>
</tr>
</table>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>