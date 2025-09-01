<%
String mn_p49 = request.getParameter("mn_p49");
String mn_p79 = request.getParameter("mn_p79");
String mn_p50 = request.getParameter("mn_p50");
String mn_p51 = request.getParameter("mn_p51");
String mn_p52 = request.getParameter("mn_p52");
String mn_p53 = request.getParameter("mn_p53");
String mn_p54 = request.getParameter("mn_p54");
String mn_p55 = request.getParameter("mn_p55");
%>
	
	
	 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p49" value="1" <%if ("1".equals(mn_p49)) {%>checked<%} %>/>&nbsp;Arrange 安排/  
 														<input type="checkbox" name="mn_p79" value="1" <%if ("1".equals(mn_p79)) {%>checked<%} %>/>&nbsp;continue 繼續
 	taxi / rehab taxi / rehab bus for transport to exercise training centre                   
			/的士 / 復康的士 / 復康巴士 往返 復康訓練中心 / 香港港安醫院 - 荃灣 / 肺塵埃沉着病判傷委員會</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p50" value="1" <%if ("1".equals(mn_p50)) {%>checked<%} %>/>&nbsp;Refresher training on inhaler & spacer technique 進修培訓有關吸入器及儲霧罐的技巧</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p51" value="1" <%if ("1".equals(mn_p51)) {%>checked<%} %>/>&nbsp;Encourage participation in patient support group 鼓勵參加病人互助小組</td>
 	</tr>
	
	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p52" value="1" <%if ("1".equals(mn_p52)) {%>checked<%} %>/>&nbsp;Referral to 轉介到:
 		<input type="text" name="mn_p53" value="<%=mn_p53%>" size=100></input>
 	</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p54" value="1" <%if ("1".equals(mn_p54)) {%>checked<%} %>/>&nbsp;Refresher training on breathing technique and dyspnea management 進修培訓有關呼吸技巧及呼吸困難的管理</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p55" value="1" <%if ("1".equals(mn_p55)) {%>checked<%} %>/>&nbsp;Advise to take Ventolin inhaler immediately before exercise training 建議在運動訓練前立即使用泛得林定量噴霧劑</td>
 	</tr>
