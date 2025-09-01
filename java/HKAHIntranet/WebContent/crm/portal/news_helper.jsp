<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements. See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License. You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
	UserBean userBean = new UserBean(request);

	String category = request.getParameter("category");
	String type = request.getParameter("type");
	String newsType_prev = null;
	ArrayList result = null;

	if("news".equals(type)){
		result = NewsDB.getList(userBean, category, null, null, -1, -1, -1);
	}else if("events".equals(type)){
		result =  ScheduleDB.getListByDateWithUserID(category, null, null, null, null, userBean.getLoginID(), "guest");
	}
	ReportableListObject row = null;
	String newsCategory = null;
	String newsType = null;
	String newsID = null;
	String title = null;
	//String titleUrl = null;
	//String titleImage = null;
	String modifiedDate = null;

	if (result.size() > 0) {
%>
			<table width="100%" border="0" cellspacing="4" cellpadding="0">
<%
		for (int i = 0; i < result.size() ; i++) {
			row = (ReportableListObject) result.get(i);
			if ("news".equals(type)){
				newsID = row.getValue(0);
				newsCategory = row.getValue(1);
				newsType = row.getValue(2);
				title = row.getValue(3);
				//titleUrl = row.getValue(4);
				//titleImage = row.getValue(5);
				modifiedDate = row.getValue(6);
			} else if ("events".equals(type)){

				title = row.getValue(3);
				String tempDate = row.getValue(8);
				String tempTime = row.getValue(9);
				modifiedDate = tempDate + " " + tempTime;

			}
		 %>

					<% if(i==0){%>
						<tr>
							<td ><span  style="color:#545454;padding-bottom:0px;margin-bottom:0px;width:60px;font-size:10px;">Date Posted</span></td>
						</tr>

					<% }	%>
						<tr>
						<%
						String tempWidth = "10%";
						if("news".equals(type)){
							tempWidth = "10%";
						 }else if("events".equals(type)){
							 tempWidth = "23%";
						} %>
							<td valign="top" class="h1_margin" style="width:<%=tempWidth%>">
								<span class="reported_quote">
								<%if("news".equals(type)){ %>
									<%=modifiedDate.split(" ")[0] %>
								<% }else if("events".equals(type)){ %>
									<%=modifiedDate%>
								<%} %>
								</span>
							</td>
							<td class="h1_margin">
							<% if("news".equals(type)){ %>
								<a   target="login_content" class="topstoryblue" href="../../portal/news_view.jsp?command=view&newsCategory=<%=newsCategory %>&newsID=<%=newsID %>">
							<%} %>
								<%=title%>...
		<%

		String [] date = modifiedDate.split(" ");
		String day = date[0].split("/")[0];
		String month = date[0].split("/")[1];
		String year = date[0].split("/")[2];

		String hour = date[1].split(":")[0];
		String minute = date[1].split(":")[1];
		Calendar newsDate = Calendar.getInstance();
		Calendar currentDate = Calendar.getInstance();
		newsDate.set( Integer.parseInt(year),  Integer.parseInt(month)-1,  Integer.parseInt(day),
				 Integer.parseInt(hour),  Integer.parseInt(minute)) ;
		newsDate.add(Calendar.DATE,3);

		if(!newsDate.before(currentDate)){
		%>
								  <img src="../../images/crm_news_btn.jpg"/>
		<%}%>
						</a>
		<%				if (userBean.isLogin() && "news".equals(type)&& userBean.isAccessible("function.news.type." + newsCategory)) { %>
								[ <a   target="login_content" href="../../admin/news.jsp?command=view&newsCategory=<%=newsCategory %>&newsID=<%=newsID %>">Edit</a> ]
		<%				} %>
							</td>
						</tr>
		<%
					// keep previous news type
					newsType_prev = newsType;
				}
%>
			</table>
<%
}
%>

<script language="javascript">
		$(document).ready(function() {
			$('#xmas').click(function() {
				window.open('../../xmas/confirmation.jsp', '_blank');
				//window.open('../xmas/xmas_reg.jsp', '_blank');
			});
		});

		$(document).find('.addHitRate').each(function(i, v){
			$(v).click(function(){
				$.ajax({
						type: "POST",
						url: "../../ui/docHitRateCMB.jsp",
						data: "docID=" + this.getAttribute("docID")+"&module=PEM",
					success: function(values){
						if(values != '') {
						}//if
					}//success
				});//$.ajax
			});
		});
</script>