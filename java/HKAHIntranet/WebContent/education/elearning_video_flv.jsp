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
<%
	String vPath = request.getParameter("vPath");
	System.out.println("[DEBUG] vPath="+vPath);
%>
<html>
<body>
<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=<%=vPath %>" width="640" height="480">
	<param name="movie" value="../swf/flvplayer.swf?file=<%=vPath %>" />
	<param name="play" value="true" />
	<param name="menu" value="true" />
</object>
</body>
</html>	