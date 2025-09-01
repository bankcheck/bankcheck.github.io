<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.struts.Globals"%>

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
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<table border=0 cellspacing=0 cellpadding=0 width="100%">
<tr>
	<td align="center" style="padding:3px;">
	<a href="../common/leftright_portal.jsp?category=ic" target="_content"><img src="../images/ic/icTitle_hkah.jpg"  width="800" height="120" border="0"/></a>
	</td>
</tr>
</table>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
<tr>
	<td align="center">
		<div class="scrollBanner_hkah" align="justify">
			<div class="scrollText">
			<font color="#FFFFFF">Infection Control Unit</font>
			<font color="#E7FF00">Alert Response Level under the Government's Preparedness Plan 
			for Influenza Pandemic is activated	</font>
			</div>
		</div>
	</td>
</tr>
</table>

<table width="100%">
<tr>
<td width="40%" valign="top">
	<table width="290" align="center">
	<tr ><td width="290" height="31" background="../images/ic/hkah_calendar_header.gif"></td></tr>
	<tr><td>
	<div id="dates" style="padding:10px;"></div>
	</td></tr>
	
	</table>
	<table width="290" align="center">
		<tr ><td width="290" height="31" background="../images/ic/hkah_news_header.gif"></td></tr>
		<tr >
			<td style="padding:8px;">
				<ul id="" style="padding:2px">
				<%
					ArrayList record_news = ICPageDB.getByCategory("News",5);
						if (record_news.size() > 0) {
							for(int i=0;i<record_news.size();i++){
							ReportableListObject row = (ReportableListObject) record_news.get(i);							
				%>
								<li style="list-style-image: url(../images/ic/animated_point.gif);padding:2px;"><font size="1"><%=row.getValue(2) %>  <%=row.getValue(0) %></font></li>				
				<% 		
							}
						}
				%>
				<li style="list-style-image: url(../images/ic/animated_point.gif);padding:2px;"><font size="1">07/04/2011  World Health Day</font></li>
				<li style="list-style-image: url(../images/ic/animated_point.gif);padding:2px;"><font size="1">07/04/2011  Antibotic Stewardship Monitoring Program</font></li>
			</ul>
			</td>
		</tr>	 		
	</table>
	<table width="290" align="center">
		<tr ><td width="290" height="31" background="../images/ic/hkah_hot_header.gif"></td></tr>
		<tr >
			<td style="padding:10px;">
				<ul id="" style="padding:7px">
								<%
					ArrayList record_hot= ICPageDB.getByCategory("Hot",5);
						if (record_hot.size() > 0) {	
							for(int i=0;i<record_hot.size();i++){
							ReportableListObject row = (ReportableListObject) record_hot.get(i);							
				%>
							<li style="list-style-image: url(../images/ic/animated_point.gif);padding:5px;"><a href="<%=row.getValue(1) %>" target="_blank"><%=row.getValue(0) %></a></li>
				<% 		
							}
						}
				%>
			</ul>
			</td>
		</tr>	 		
	</table>
</td>
<td>
	<table>
	  <tr>
	  <td>
		<div>
		<table width="250" "="" border="0" cellpadding="4" cellspacing="0"  border-collapse:="" collapse="">
		<tr>
			<td height="18" align="center" background="../images/ic/hkah_titleFrame.gif" style="VERTICAL-ALIGN: top;padding:10px;"><font color="white"><b>Hand Hygiene</b></font></td>	
		</tr>
		<tr>
		<td height="180" align="center" background="../images/ic/contentFrame.gif" style="VERTICAL-ALIGN: center; padding:5px;">
			<div style=" WIDTH: 210px; HEIGHT: 140px; position:relative; top:2px; VERTICAL-ALIGN: center;">
		    	<table width="210" height="120" align="center" style="VERTICAL-ALIGN: center;">
		    		<tr align="center">
		    		<td width="100"><a href="javascript:void(0);" onclick="downloadFile('370','Hand Hygiene Day 5.6.07.ppt');return false;" target="_blank"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_01.gif"></a></td>
		    		<td width="100"><a href="javascript:void(0);" onclick="downloadFile('','');return false;" target="_blank"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_02.gif" alt=""></a></td>
		    		</tr>
		    		<tr align="center">
		    		<td width="100"><a href="javascript:void(0);" onclick="downloadFile('370','HH Day.ppt');return false;" target="_blank"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_03.gif" alt=""></a></td>
		    		<td width="100"><a href="javascript:void(0);" onclick="downloadFile('370','20091116162903776.pdf');return false;" target="_blank"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_04.gif" alt=""></a></td>
		    		</tr>
		    		<tr align="center">
		    		<td width="100"><a href="javascript:void(0);" onclick="downloadFile('','');return false;" target="_blank"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_05.gif" alt=""></a></td>
		    		<td width="100"><a href="material_content.jsp?category=Audit" target="_blank"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_06.gif" alt=""></a></td>
		    		</tr>
		    	</table>
			</div>
		</td>		
		</tr>
		<tr>
			<td style="padding:5px;">&nbsp;</td>		
		</tr>
		</table>
		</div>
	   </td>
	   </tr>
	   	  <tr>
	  <td>
		<div>
		<table width="250" "="" border="0" cellpadding="4" cellspacing="0" " border-collapse:="" collapse="">
		<tr>
			<td height="18" align="center" background="../images/ic/titleFrame.gif" style="VERTICAL-ALIGN: center;padding:10px;"><font color="white"><b>Surveillance</b></font></td>	
		</tr>
		<tr>
		<td height="180" align="center" background="../images/ic/contentFrame.gif" style="VERTICAL-ALIGN: center; padding:5px;">
			<div style=" WIDTH: 210px; HEIGHT: 140px; position:relative; top:3px;">
			<ul id="" style="padding:1px">
				<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">SSI</a></li>
				<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">GE</a></li>
				<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">Respiratory</a></li>
				<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">ICU</a></li>
				<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">MDRO</a></li>
				<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">Bld Culture</a></li>
				<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">Bloodborne Pathogen Exposure</a></li>
			</ul>
			</div>
		</td>		
		</tr>
		<tr>
			<td style="padding:5px;">&nbsp;</td>		
		</tr>
		</table>
		</div>
	   </td>
	   </tr>
    </table>
</td>
<td>
	<table>
	  <tr>
	  <td>
		<div>
		<table width="250" "="" border="0" cellpadding="4" cellspacing="0"  border-collapse:="" collapse="">
		<tr>
			<td height="18" align="center" background="../images/ic/titleFrame.gif" style="VERTICAL-ALIGN: center;padding:10px;"><font color="white"><b>Avian Influenza</b></font></td>	
		</tr>
		<tr>
		<td height="180" align="center" background="../images/ic/contentFrame.gif" style="VERTICAL-ALIGN: center; padding:5px;">
			<div style=" WIDTH: 210px; HEIGHT: 140px; position:relative; top:10px;">
  			<a href="http://icidportal.ha.org.hk/sites/en/webpages/avian%20influenza.aspx" >
  			<img style=" WIDTH: 210px; HEIGHT: 140px"  src="../images/ic/H1N1.jpg" alt=""></a></div>
			</div>
		</td>		
		</tr>
		<tr>
			<td style="padding:5px;">&nbsp;</td>		
		</tr>
		</table>
		</div>
	   </td>
	   </tr>
	   	  <tr>
	  <td>
		<div>
		<table width="250" "="" border="0" cellpadding="4" cellspacing="0"  border-collapse:="" collapse="">
		<tr>
			<td height="18" align="center" background="../images/ic/titleFrame.gif" style="VERTICAL-ALIGN: center;padding:10px;"><font color="white"><b>Isolation & Notification</b></font></td>	
		</tr>
		<tr>
		<td height="180" align="center" background="../images/ic/contentFrame.gif" style="VERTICAL-ALIGN: center; padding:5px;">
			<div style=" WIDTH: 210px; HEIGHT: 140px; position:relative; top:2px;">
		    	<table width="210" height="120" align="center">
		    		<tr align="center">
		    		<td width="100"><a href="javascript:void(0);" onclick="downloadFile('376','Isolation2007_appendixA.pdf');return false;" target="_blank"><img style=" WIDTH: 100; HEIGHT: 65"  src="../images/ic/IN_01.gif" alt=""></a></td>
		    		<td width="100"><a href="javascript:void(0);" onclick="downloadFile('377','SARS & Avian Flu assessment(IFN).doc');return false;" target="_blank"><img style=" WIDTH: 100; HEIGHT: 65"  src="../images/ic/IN_02.gif" alt=""></a></td>
		    		</tr>
		    		<tr align="center">
		    		<td width="100"><a href="javascript:void(0);" onclick="downloadFile('360','Laboratory Criteria on Reporting Notifiable Disease 2008.doc');return false;" target="_blank"><img style=" WIDTH: 100; HEIGHT: 65"  src="../images/ic/IN_03.gif" alt=""></a></td>
		    		<td width="100"><a href="javascript:void(0);" onclick="downloadFile('376','Report on poisoning or other speciifed communicable diseases.pdf');return false;" target="_blank"><img style=" WIDTH: 100; HEIGHT: 65"  src="../images/ic/IN_04.gif" alt=""></a></td>
		    		</tr>
		    	</table>
			</div>
		</td>		
		</tr>
		<tr>
			<td style="padding:5px;">&nbsp;</td>		
		</tr>
		</table>
		</div>
	   </td>
	   </tr>
    </table>
</td>
</tr>
</table>
<script>
var Event = function(text, className) {
    this.text = text;
    this.className = className;
};

var events = {};

<%
	Integer currentMonth = DateTimeUtil.getCurrentMonth();
	Integer currentYear = DateTimeUtil.getCurrentYear();
	ArrayList record = ICPageDB.getEvent(currentMonth,currentYear); 
	if (record.size() > 0) {
		for(int i=0;i<record.size();i++){
		ReportableListObject row = (ReportableListObject) record.get(i);
%>
		events[new Date("<%=row.getValue(1)%>")] = new Event("<%=row.getValue(0)%>", "infoData3");
<%
		}
	 }
%> 


$(document).ready(function() {
	
	
	$("#dates").datepicker({
		
	    beforeShowDay: function(date) {
	    	
			
	        var event = events[date];
	        if (event && event.className) {
	            return [false, event.className, event.text];
	        }
	        else {
	            return [false, '', ''];
	        }	       
	    },
	    
	    
		onChangeMonthYear: function(year, month, inst) { 
			
			
			var curYear = month.selectedYear;
			var month = month.selectedMonth+1;
			
			$.ajax({		
				type: "POST",
				url: "../ui/ICCalendarCMB.jsp",
				async:false,
				data: "Month=" + month +"&Year="+curYear,
				success: function(values){
					var value1 = values.split("[s]");
					for(var j=0;j<value1.length;j++){
						var value2 = null;
						value2 = value1[j].split("[e]");
						events[new Date(value2[0])] = new Event(value2[1], "infoData3");
					}					
				}
			});
			
		    setTimeout(function() {
		    
		    	 
		    	$('td[title]').each(function(){
		    		var tempTitle = $(this).attr('title');
		    		
		    		$(this).attr('title','');
		    		$(this).qtip({
		    			   content: tempTitle,
		    			   show: 'mouseover',
		    			   hide: 'mouseout',
		    			   position: { target: 'mouse' },
		    			   style: {
		    				      border: {
		    				         width: 1,
		    				         radius: 8,
		    				         color: '#6699CC',
		    				         tip: 'leftMiddle'
		    				      },
		    				      width: 200
		    				}
		    			});
		    	});
		    	
		    }, 0);
		}
	});
	

	
	$('.scrollText').bind('marquee', function() {
		var ob = $(this);
		var tw = ob.width();
		var ww = ob.parent().width();
		ob.css({ right: -tw });
		ob.animate({ right: ww }, 20000, 'linear', function() {
			ob.trigger('marquee');
		});
	}).trigger('marquee');
	


	$('td[title]').each(function(){
		var tempTitle = $(this).attr('title');
		$(this).attr('title','');
		$(this).qtip({
			   content: tempTitle,
			   show: 'mouseover',
			   hide: 'mouseout',
			   position: { target: 'mouse' },
			   style: {
				      border: {
				         width: 1,
				         radius: 8,
				         color: '#6699CC',
				         tip: 'leftMiddle'
				      },
				      width: 200
				}
			});
	});
	
	
});



</script>

</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>