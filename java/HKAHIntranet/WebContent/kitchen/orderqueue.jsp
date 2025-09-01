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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">

<html>
<meta http-equiv="refresh" content=1200>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<head>
	<style>
		TABLE {
			border-width:1px;
			border-spacing:2px;
			border-style:outset;
			border-color:gray;
			border-collapse:separate;
			background-color:white;
		}
		TD {
			border-width:1px;
			padding:1px;
			border-style:inset;
			border-color:gray;
			background-color:white;
			-moz-border-radius:3px;
		}
		LABEL {
			font-size:24px;
		}
	</style>
</head>

<body>

<div id="foodOrderList">
	<table style="width:100%;">
		<tr>
			<td style="width:20%;"><label>Time</label></td>
			<td style="width:70%;"><label>Name</label></td>
			<td style="width:10%;"><label>Qty</label></td>
		</tr>
		<tr>
			<td><label>7:30</label><br/><label>Breakfast</label></td>
			<td><label>Testing1</label></td>
			<td><label>1</label></td>
		</tr>
		<tr>
			<td><label>8:30</label><br/><label>Breakfast</label></td>
			<td><label>Testing2</label></td>
			<td><label>1</label></td>
		</tr>
		<tr>
			<td><label>8:30</label><br/><label>Breakfast</label></td>
			<td><label>Testing2</label></td>
			<td><label>1</label></td>
		</tr>
		<tr>
			<td><label>8:30</label><br/><label>Breakfast</label></td>
			<td><label>Testing2</label></td>
			<td><label>1</label></td>
		</tr>
		<tr>
			<td><label>8:30</label><br/><label>Breakfast</label></td>
			<td><label>Testing2</label></td>
			<td><label>1</label></td>
		</tr>
	</table>
</div>

</body>
</html:html>

<script>
	var counter = 0;
	
	function getOrder() {
		if($('label#reset').html() == "true") {
			counter = 0;	
		}
		
		$.ajax({
			type: "GET",
			url: "../ui/foodOrderCMB.jsp",
			data: "count="+counter,
			async: false,
			success: function(values){
				$('div#foodOrderList').html(values);
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getOrder"');
			}
		});
		counter+=5;
	}
	
	function scheduleJob() {
		$('div#foodOrderList').reschedule("5s", function (x) {
			alert(1)
			$('div#foodOrderList').html('');
			getOrder();
        });
	}
	
	$(document).ready(function() {
		getOrder();
		//scheduleJob();
		setInterval(getOrder, 5000);
	});
</script>