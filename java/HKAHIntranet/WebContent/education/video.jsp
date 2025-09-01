<%@ page import="com.hkah.constant.*"%>
<%
	String category = "title.education";
%>
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
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Video" />
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="mustLogin" value="N" />
</jsp:include>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<br>
			<div id="player">
				<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/Hospital Fire Drill.flv" width="640" height="480">
					<param name="movie" value="../swf/flvplayer.swf?file=/swf/video/Hospital Fire Drill.flv" />
				</object>
			</div>
			<ul>
				<li>SIRT Training<ul>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/SIRT(CHI)A.flv','vga');"><H1 id="TS">CHI Part 1</H1></a><a href="javascript:void(0);" onclick="playMovie('/swf/SIRT(CHI)B.flv','vga');"><H1 id="TS"> Part 2</H1></a></li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/SIRT(CHI)A.flv','vga');"><H1 id="TS">ENG Part 1</H1></a><a href="javascript:void(0);" onclick="playMovie('/swf/SIRT(ENG)B.flv','vga');"><H1 id="TS"> Part 2</H1></a></li>
				</ul></li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/李德印24式太極拳背面分解教學.flv');">李德印24式太極拳背面分解教學</a></li>
				<!-- <li><a href="javascript:void(0);" onclick="playMovie('/swf/video/Hospital Fire Drill.flv');">Hospital Fire Drill</a></li>-->
				<li>
					<br /><a href="javascript:void(0);" onclick="playMovie('/swf/video/medicalGasDrill_6F.flv');">2014/02/24 Medical Gas Failure Drill in 6/F New OB Unit</a>
					<br /><a href="javascript:void(0);" onclick="playMovie('/swf/video/electricityfailuredrill20140224.flv');">2014/02/24 Electricity Failure Drill in 6/F New OB Unit</a>
					<br /><a href="javascript:void(0);" onclick="playMovie('/swf/video/20130912_fire drill debriefing by FSD.flv');">2013/09/12 Fire Drill Debriefing by FSD</a>
				<% if (!ConstantsServerSide.SECURE_SERVER) { %>
					<br /><a href="\\hkim\im\Common\Staff Education\20130912_fire drill debriefing by FSD.mp4"> [For better quality, click here to play original video]</a>
				<% } %>
				</li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/Fire Drill 2010 May.flv');">Hospital Fire Drill PPT</a></li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/Chemical Drill Report.flv');">Chemical Drill Report</a></li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/First Aid Items.flv');">First Aid Items</a></li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/NSI Prevention - Episode 1 (IV Cannulation).flv');">NSI Prevention - Episode 1 (IV Cannulation)</a></li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/NSI Prevention - Trailer.flv');">NSI Prevention - Trailer</a></li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/Demonstration on IQ medical oxygen cylinder.flv');">Demonstration on IQ medical oxygen cylinder</a></li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/Back Pain and Muscle Strengthening - Back_muscles stretching 背部伸展 26_7_2016.flv');">Back Pain and Muscle Strengthening - Back_muscles stretching 背部伸展</a></li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/Back Pain and Muscle Strengthening - Chest muscles streching 胸肌伸展 26_7_2016.flv');">Back Pain and Muscle Strengthening - Chest muscles streching 胸肌伸展 </a></li>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/Back Pain and Muscle Strengthening - Shoulder_neck stretching 肩頸伸展 26_7_2016.flv');">Back Pain and Muscle Strengthening - Shoulder_neck stretching 肩頸伸展</a></li>
			</ul>
		</td>
	</tr>
</table>
<script language="javascript">
<!--
	function playMovie(file) {
		var FO = {
			movie:"../swf/flvplayer.swf",
			width:"640px",
			height:"480px",
			majorversion:"7",
			build:"0",
			flashvars:"file="+file+"&autoStart=true&repeat=true"
		};

		UFO.create(FO, 'player');
	}

<%
	String videoName = request.getParameter("fn");
	if ("NSI Prevention - Episode 1 (IV Cannulation)".equals(videoName)) {
		out.println("playMovie('/swf/video/NSI Prevention - Episode 1 (IV Cannulation).flv')");
	} else if ("NSI Prevention - Trailer".equals(videoName)) {
		out.println("playMovie('/swf/video/NSI Prevention - Trailer.flv')");
	}
%>
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>