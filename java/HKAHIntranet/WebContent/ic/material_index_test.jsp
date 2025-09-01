<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.struts.Globals"%>
<%
UserBean userBean = new UserBean(request);
String siteCode = userBean.getSiteCode()==null?"twah":userBean.getSiteCode();

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
	<a href="../common/leftright_portal.jsp?category=ic" target="_content"><img src="../images/ic/icTitle_<%=siteCode %>.jpg"  width="800" height="120" border="0"/></a>
	</td>
</tr>
</table>

<table height="40" border=0 cellspacing=0 cellpadding=10 width="100%">
<tr>
	<td align="center">

		<div class="scrollBanner_<%=siteCode%>" style="position:relative;">
			<div class="scrollText">
			<font color="#FFFFFF">Infection Control Unit</font>
					<%
						ArrayList record_notification = ICPageDB.getByCategory("notification",5);
							if (record_notification.size() > 0) {
								ReportableListObject row = (ReportableListObject) record_notification.get(0);							
					%>
							<font color="#E7FF00"><%=row.getValue(0) %></font>					
							<% 		
							}
					%>				
			</div>
		</div>
	</td>
</tr>
</table>

<table width="100%" style="position:relative;">
<tr>
	<td style="valign:left;"width="	">
	<td width="25%" valign="middle" style="position:relative;">
	<table width="290" align="center" style="top:30px;background-color:white;position:relative;">
	<tr ><td width="290" height="31" background="../images/ic/<%=siteCode%>_calendar_header.gif"></td></tr>
	<tr><td>
	<div id="dates" style="padding:10px;"></div>
	</td></tr>
	
	</table>

	<table width="290" style="position:relative;top:80px;" align="center">
		<tr ><td width="290" height="31" background="../images/ic/<%=siteCode%>_news_header.gif" style="background-color:white;position:absolute;z-index:2"></td></tr>
		<tr >
			<td style="padding-bottom:8px;height:200px;">
				<div id="" style="z-index:1;">
				<marquee direction="up" onmouseover="this.stop()" scrollamount="2" onmouseout="this.start()" height="150px">
					<ul id="" style="padding:2px;">
					<%
						ArrayList record_news = ICPageDB.getByCategory("News",5);
							if (record_news.size() > 0) {
								for(int i=0;i<record_news.size();i++){
								ReportableListObject row = (ReportableListObject) record_news.get(i);							
					%>
									<li style="padding:2px;"><font size="1"><%=row.getValue(2) %>  <%=row.getValue(0) %></font></li>				
					<% 		
								}
							}
					%>
					</ul>
				</marquee>
				</div>
			</td>
		</tr>	 		
	</table>
	
	<table width="290" align="center" style="position:relative;top:30px;z-index:2;">
		<tr ><td width="290" height="31" background="../images/ic/<%=siteCode%>_hot_header.gif"></td></tr>
		<tr style="width:300px;background-color:white;">
			<td style="width:100%;top:410px;">
				<div style=" WIDTH: 290px; HEIGHT: 100px; position:relative;overflow: auto;">				
				<ul id="" style="width:100%;height:100%;padding-bottom:12px;z-index:5;">
								<%
					ArrayList record_hot= ICPageDB.getByCategory("Hot",5);
						if (record_hot.size() > 0) {	
							for(int i=0;i<record_hot.size();i++){
							ReportableListObject row = (ReportableListObject) record_hot.get(i);							
				%>
							<li style="list-style-image:url(../images/ic/animated_point.gif);padding:5px;">
								<div style="width:200px">
								<a href="<%=row.getValue(1) %>" target="_blank"><%=row.getValue(0) %></a>
								</div>
							</li>
				<% 		
							}
						}
				%>
			</ul>
			</div>
			</td>
		</tr>	 		
	</table>		
</td>
	<td style="" width="15%">
		<table>
		  <tr>
		  <td>
			<div style="position:relative;top:3px;">
			<table width="250"  border="0" cellpadding="4" cellspacing="0"  border-collapse:="" collapse="">
			<tr>
				<td align="center" width="290" height="23" background="../images/ic/<%=siteCode%>_infoHeader.gif" style="VERTICAL-ALIGN: center;padding-top:10px;"></td>	
			</tr>
			<tr>
			<td height="180" align="center" background="../images/ic/<%=siteCode%>_contentFrame.gif" style="VERTICAL-ALIGN: center; padding:5px;">
				<div style=" WIDTH: 210px; HEIGHT: 140px; position:relative; top:2px; VERTICAL-ALIGN: center;">
			    	<table width="210" height="120" align="center" style="VERTICAL-ALIGN: center;">
			    		<tr align="center">
			    		<td width="100"><a href="material_content.jsp?category=	am" target="content"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_01.gif"></a></td>
			    		<td width="100"><a href="material_content.jsp?category=Video" target="content"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_02.gif" alt=""></a></td>
			    		</tr>
			    		<tr align="center">
			    		<td width="100"><a href="material_content.jsp?category=Poster" target="content"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_03.gif" alt=""></a></td>
			    		<td width="100"><a href="material_content.jsp?category=Form" target="content"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_04.gif" alt=""></a></td>
			    		</tr>
			    		<tr align="center">
			    		<td width="100"><a href="material_content.jsp?category=Audit" target="content"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_05.gif" alt=""></a></td>
			    		<td width="100"><a href="http://www.chp.gov.hk/en/links/15.html" target="_blank"><img style=" WIDTH: 100; HEIGHT: 40"  src="../images/ic/hh_06.gif" alt=""></a></td>
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
			<div style="position:relative;">
			<table width="250" "="" border="0" cellpadding="4" cellspacing="0" " border-collapse:="" collapse="">
			<tr>
				<td width="290" height="23" align="center" background="../images/ic/<%=siteCode%>_survHeader.gif" style="VERTICAL-ALIGN: center;padding-top:10px;"></td>	
			</tr>
			<tr>
			<td height="180" align="left" background="../images/ic/<%=siteCode%>_contentFrame.gif" style="VERTICAL-ALIGN: center;">
				<div style=" WIDTH: 210px; HEIGHT: 140px; position:relative; top:3px;">
				<ul id="" style="padding:25px">
				<%if("twah".equals(siteCode)){ %>
								<%
					ArrayList record_sur= ICPageDB.getByCategory("Surveilance",1);
						if (record_sur.size() > 0) {	
							ReportableListObject row = (ReportableListObject) record_sur.get(0);
							String survImage = row.getValue(0);
							String survLink = row.getValue(1);
							
				%>
						<div style=" WIDTH: 210px; HEIGHT: 140px; position:relative; top:3px;">
							<a href="<%=survLink %>" target="_blank" >
								<img style=" WIDTH: 210px; HEIGHT: 140px"  src="/upload/Infection Control/Surveilance_corner/<%=survImage %>" alt="">
							</a>
						</div>
				<% 		

						}
				%>
				<%}else{ %>
					<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank"><font >SSI</font></a></li>
					<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">GE</a></li>
					<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">Respiratory</a></li>
					<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">ICU</a></li>
					<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">MDRO</a></li>
					<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">Bld Culture</a></li>
					<li style="list-style-image: url(../images/ic/animated_point.gif)"><a href="material_content.jsp?category=Audit" target="_blank">Bloodborne Pathogen Exposure</a></li>
				<%} %>
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
	<td style=""width="25%">
		<table>
		  <tr>
		  <td>
			<div style="position:relative;top:3px;">
			<table style="background-color:F" width="250" "="" border="0" cellpadding="4" cellspacing="0"  border-collapse:="" collapse="">
			<tr>
				<td width="290" height="23" align="center" background="../images/ic/<%=siteCode%>_diseaseHeader.gif" style="VERTICAL-ALIGN: center;padding-top:10px;"></td>	
			</tr>
			<tr>
			<td height="180" align="left" background="../images/ic/<%=siteCode%>_contentFrame.gif" style="VERTICAL-ALIGN: center; padding:5px;">
				<div style=" WIDTH: 245px; HEIGHT: 140px; position:relative; top:10px;overflow: auto;">
				<%if("hkah".equals(siteCode)){ %>
	  			<a href="http://icidportal.ha.org.hk/sites/en/webpages/avian%20influenza.aspx" >
	  			<img style=" WIDTH: 210px; HEIGHT: 140px"  src="../images/ic/H1N1.jpg" alt=""></a>
	  			<%}else{ %>
				<ul id="" style="width:100%;height:100%;padding-bottom:12px;padding-left:25px;z-index:5;">
								<%
					ArrayList record_dis= ICPageDB.getByCategory("Disease",10);
						if (record_dis.size() > 0) {	
							for(int i=0;i<record_dis.size();i++){
							ReportableListObject row = (ReportableListObject) record_dis.get(i);							
				%>
							<li style="list-style-image:url(../images/ic/animated_point.gif);padding:5px;">
								<div style="width:200px">
								<a href="<%=row.getValue(1) %>" target="_blank"><%=row.getValue(0) %></a>
								</div>
							</li>
				<% 		
							}
						}
				%>
			</ul>	  			
	  			<%} %>
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
				<td  width="290" height="23" align="center" background="../images/ic/<%=siteCode%>_isolateHeader.gif" style="VERTICAL-ALIGN: center;padding-top:10px;"></td>	
			</tr>
			<tr>
			<td height="180" align="center" background="../images/ic/<%=siteCode%>_contentFrame.gif" style="VERTICAL-ALIGN: center; padding:5px;">
				<div style=" WIDTH: 210px; HEIGHT: 140px; position:relative; top:2px;">
			    	<table width="210" height="120" align="center">
			    		<tr align="center">
			    		<td width="100"><a href="javascript:downloadFile('433','/CDC Isolation Guidelines 2007.pdf');">
			    		<img style=" WIDTH: 100; HEIGHT: 65"  src="../images/ic/IN_01.gif" alt=""></a></td>
			    		<td width="100"><a href="javascript:downloadFile('433','/INFC-MBDA06 Triage Risk Assessment _Eng_ rev.pdf');">
			    		<img style=" WIDTH: 100; HEIGHT: 65"  src="../images/ic/IN_02.gif" alt=""></a></td>
			    		</tr>
			    		<tr align="center">
			    		<td width="100"><a href="https://ceno.chp.gov.hk/casedef/casedef.pdf" target="_blank">
			    		<img style=" WIDTH: 100; HEIGHT: 65"  src="../images/ic/IN_03.gif" alt=""></a></td>
			    		<td width="100"><a href="http://www.chp.gov.hk/en/notification/13/33.html" target="_blank"><img style=" WIDTH: 100; HEIGHT: 65"  src="../images/ic/IN_04.gif" alt=""></a></td>
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
	<td style=""width="10%">
	</td>
</tr>
</table>
<script>

(function($){
	$.fn.extend({
	        Scroll:function(opt,callback){
	                //参数初始化
	                if(!opt) var opt={};
	                var _this=this.eq(0).find("ul:first");
	                var        lineH=_this.find("li:first").height(), //获取行高
	                        line=opt.line?parseInt(opt.line,10):parseInt(this.height()/lineH,10), //每次滚动的行数，默认为一屏，即父容器高度
	                        speed=opt.speed?parseInt(opt.speed,10):5000, //卷动速度，数值越大，速度越慢（毫秒）
	                        timer=opt.timer?parseInt(opt.timer,10):3000; //滚动的时间间隔（毫秒）
	                if(line==0) line=1;
	                var upHeight=-400-line*lineH;
	                //滚动函数
	                scrollUp=function(){
	                        _this.animate({
	                                marginTop:upHeight
	                        },speed,function(){
	                                //for(i=1;i<=line;i++){
	                                //        _this.find("li:first").appendTo(_this);
	                                //}
	                                _this.hide();
	                                _this.css({marginTop:-1});
	                                _this.show();
	                        });
	                }
	                timerID=setInterval("scrollUp()",timer);
	                _this.mouseover(function(){
	                        clearInterval(timerID);
	                });
	                _this.mouseleave(function(){
	                	timerID=setInterval("scrollUp()",timer);
                	});
	        }        
			})
			})(jQuery);

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
	
	$("#scrollNew").Scroll({line:4,speed:5500,timer:6000});
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
		ob.animate({ right: ww }, 40000, 'linear', function() {
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