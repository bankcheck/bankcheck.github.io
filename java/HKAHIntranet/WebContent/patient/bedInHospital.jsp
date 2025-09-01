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
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.bedInHospital.view" />
	<jsp:param name="displayTitle" value="No. of Beds in Hospital" />
	<jsp:param name="category" value="Report" />
</jsp:include>
<style>
</style>
<body style='font-size:15px'>
<table border='0'>
<tr><td colspan='2'  class="infoLabel"  ><div style='font-weight:bold' align='left'>In Patient Hospital Beds</div></td><td class="infoData">108</td></tr>
<tr><td width='100px'></td><td class="infoLabel" ><div align='left'>- U200</div></td><td class="infoData">16</td></tr>
<tr><td></td><td class="infoLabel" ><div align='left'>- SCU</div></td><td class="infoData">8</td></tr>
<tr><td></td><td class="infoLabel" ><div align='left'>- Pedi</div></td><td class="infoData">12</td></tr>
<tr><td></td><td class="infoLabel" ><div align='left'>- U300</div></td><td class="infoData">31</td></tr>
<tr><td></td><td class="infoLabel" ><div align='left'>- U500</div></td><td class="infoData">38</td></tr>
<tr><td></td><td class="infoLabel" ><div align='left'>- ICU</div></td><td class="infoData">6</td></tr>
<tr><td></td><td class="infoLabel" ><div align='left'>- I 131</div></td><td class="infoData">2</td></tr>
<tr><td colspan='2' class="infoLabel" ><div style='font-weight:bold'  align='left'>Maternity beds</div></td><td class="infoData">10</td></tr>
<tr><td colspan='2' class="infoLabel" ><div style='font-weight:bold'  align='left'>Baby cots</div></td><td class="infoData">12</td></tr>
<tr><td colspan='2' class="infoLabel" ><div style='font-weight:bold'  align='left'>Day beds</div></td><td class="infoData">21</td></tr>
<tr><td></td><td class="infoLabel" ><div align='left'>- Chemo</div></td><td class="infoData">5 + 1 (VIP)</td></tr>
<tr><td></td><td class="infoLabel" ><div align='left'>- SSU</div></td><td class="infoData">9</td></tr>
<tr><td></td><td class="infoLabel" ><div align='left'>- Hemo</div></td><td class="infoData">6</td></tr>
</table>
<script language="javascript">

</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>