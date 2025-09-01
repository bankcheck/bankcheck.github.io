<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%
UserBean userBean = new UserBean(request);

ArrayList crmTestRecord = getCRMClientDoneTodayTest(userBean.getUserName());
boolean clientTodayTestDone = false;
if(crmTestRecord.size()>0){
	clientTodayTestDone = true;
}

if(clientTodayTestDone == false){
	String submitForm = request.getParameter("submitForm");
	boolean isSubmitForm = false;
	if(submitForm != null && submitForm.equals("y")){
		isSubmitForm = true;
	}
	
	String []nutrition = new String[5];
	for(int i = 0;i<5;i++){
		nutrition[i] = request.getParameter("n"+ (i+1)+"Hidden");
	}
	String []nutritionString = new String[5];
	nutritionString[0]= "早上吃豐富早餐";
	nutritionString[1]= "每日吃兩種以上的生果";
	nutritionString[2]= "每日吃三種以上的蔬菜";
	nutritionString[3]= "每餐１份含蛋白質主菜、２份蔬／果、３份全穀麥類";
	nutritionString[4]= "兩餐之間不吃零食";
	
	String []exercise = new String[5];
	for(int i = 0;i<5;i++){
		exercise[i] = request.getParameter("e"+ (i+1)+"Hidden");
	}
	String []exerciseString = new String[5];
	exerciseString[0]= "每日最少２０－３０分鐘以上運動／急步行";
	exerciseString[1]= "運動時穿合適運動／急步行的鞋";
	exerciseString[2]= "運動時心跳增加２０％";
	exerciseString[3]= "運動時有流汗";
	exerciseString[4]= "運動前後有做伸展運動各５－１０分鐘";
	
	
	String []water = new String[5];
	for(int i = 0;i<5;i++){
		water[i] = request.getParameter("w"+ (i+1)+"Hidden");
	}
	String []waterString = new String[5];
	waterString[0]= "早上起床飲清水１－２杯";
	waterString[1]= "早餐後約２小時飲清水１－２杯";
	waterString[2]= "午餐前約半小時飲清水１杯";
	waterString[3]= "午餐後約２小時飲清水１－２杯";
	waterString[4]= "晚餐前約半小時飲清水１杯";
	
	String []sunlight = new String[5];
	for(int i = 0;i<5;i++){
		sunlight[i] = request.getParameter("s"+ (i+1)+"Hidden");
	}
	String []sunlightString = new String[5];
	sunlightString[0]= "早上約１０時前曬陽光不少於５分鐘";
	sunlightString[1]= "下午約４時後曬陽光不少於５分鐘";
	sunlightString[2]= "曬太陽時，穿著棉質衣服";
	sunlightString[3]= "使用防紫外線護膚的裝備";
	sunlightString[4]= "使用防紫外線護眼的裝備";
	
	String []temperance = new String[5];
	for(int i = 0;i<5;i++){
		temperance[i] = request.getParameter("t"+ (i+1)+"Hidden");
	}
	String []temperanceString = new String[5];
	temperanceString[0]= "沒有吸煙";
	temperanceString[1]= "沒有飲酒";
	temperanceString[2]= "沒有濫用藥物";
	temperanceString[3]= "沒有飲濃茶或汽水";
	temperanceString[4]= "沒有飲含咖啡因成份之飲品";
	
	String []air = new String[5];
	for(int i = 0;i<5;i++){
		air[i] = request.getParameter("a"+ (i+1)+"Hidden");
	}
	String []airString = new String[5];
	airString[0]= "早上深呼吸１０次";
	airString[1]= "中午深呼吸１０次";
	airString[2]= "黃昏深呼吸１０次";
	airString[3]= "有日光時在樹下活動";
	airString[4]= "在山間／湖邊／海邊活動";
	
	String []rest = new String[5];
	for(int i = 0;i<5;i++){
		rest[i] = request.getParameter("r"+ (i+1)+"Hidden");
	}
	String []restString = new String[5];
	restString[0]= "每天約有３０分鐘培養嗜好";
	restString[1]= "每晚十一時前休息，有７－８小時睡眠";
	restString[2]= "每星期有一天放假";
	restString[3]= "每週一次參與社交／家庭活動";
	restString[4]= "每年有一次或以上的假期";
	
	String []trust = new String[5];
	for(int i = 0;i<5;i++){
		trust[i] = request.getParameter("tr"+ (i+1)+"Hidden");
	}
	String []trustString = new String[5];
	trustString[0]= "每天最少花五分鐘專心聆聽";
	trustString[1]= "每天最少一次讚許他人";
	trustString[2]= "培養承擔責任的觀念";
	trustString[3]= "彼此尊重信任";
	trustString[4]= "每週一次參與宗教活動";
	
	String pageNo = request.getParameter("pageNo");
	int pageNoInt = 0;
	try {
		pageNoInt = Integer.parseInt(pageNo);
	} catch (Exception e) {
		pageNoInt = 1;
	}
	String label1 = null; String color1 = null;
	String label2 = null; String color2 = null;
	String label3 = null; String color3 = null;
	String label4 = null; String color4 = null;
	String label5 = null; String color5 = null;
	String label6 = null; String color6 = null;
	String label7 = null; String color7 = null; 
	String label8 = null; String color8 = null;
	if (pageNoInt == 1) {
		label1 = "step1_1"; color1="#FFB163";
		label2 = "step1_2";
		label3 = "step1_2";
		label4 = "step1_3";
		label5 = "step1_2";
		label6 = "step1_2";
		label7 = "step1_2";
		label8 = "step1_3";
	} else if (pageNoInt == 2) {
		label1 = "step2_1";
		label2 = "step2_2"; color2="#FF5050";
		label3 = "step1_2";
		label4 = "step1_3";
		label5 = "step1_2";	
		label6 = "step1_2";	
		label7 = "step1_2";	
		label8 = "step1_3";
	} else if (pageNoInt == 3) {
		label1 = "step3_1";
		label2 = "step3_2";
		label3 = "step2_2"; color3="#1EA7EB";
		label4 = "step1_3";
		label5 = "step1_2";	
		label6 = "step1_2";	
		label7 = "step1_2";	
		label8 = "step1_3";
	} else if(pageNoInt == 4){
		label1 = "step3_1";
		label2 = "step3_1";
		label3 = "step3_2";
		label4 = "step3_3"; color4="#EEEE6E";
		label5 = "step1_2";	
		label6 = "step1_2";	
		label7 = "step1_2";	
		label8 = "step1_3";
	} else if(pageNoInt == 5){
		label1 = "step1_2";
		label2 = "step1_2";
		label3 = "step1_2";
		label4 = "step1_3";
		label5 = "step1_1"; color5="#FF9696";
		label6 = "step1_2";
		label7 = "step1_2";
		label8 = "step1_3";
	} else if(pageNoInt == 6){
		label1 = "step3_1";
		label2 = "step1_2";
		label3 = "step1_2";
		label4 = "step1_3";
		label5 = "step2_1";	
		label6 = "step2_2";	color6="#0AEB0A";
		label7 = "step1_2";	
		label8 = "step1_3";
	} else if(pageNoInt == 7){
		label1 = "step3_1";
		label2 = "step1_2";
		label3 = "step1_2";
		label4 = "step1_3";
		label5 = "step1_2";	
		label6 = "step3_2";	
		label7 = "step2_2";	color7="#D7A0D7";
		label8 = "step1_3";
	} else if(pageNoInt == 8){
		label1 = "step3_1";
		label2 = "step3_1";
		label3 = "step1_2";
		label4 = "step1_3";
		label5 = "step1_2";	
		label6 = "step1_2";	
		label7 = "step3_2";	
		label8 = "step3_3"; color8="#D2E1BD";
	}
	
	
	boolean submitFormSuccess = false;
	if(isSubmitForm){		
		submitFormSuccess = insertChaplainArea(userBean,nutrition,exercise,water,sunlight,temperance,air,rest,trust);
}
%>
<%!
public static boolean insertChaplainArea(UserBean userBean,String[]nutrition,String[]exercise,String[]water,String[]sunlight,String[]temperance
		,String[]air,String[]rest,String[]trust){
	StringBuffer sqlStr = new StringBuffer();
	int total = 0;
	sqlStr.append("INSERT INTO CRM_CLIENTS_NEWSTART(CRM_NS_ID,CRM_USERNAME,CRM_NS_NUTRITION,CRM_NS_EXERCISE,CRM_NS_WATER,CRM_NS_SUNLIGHT, ");
	sqlStr.append("CRM_NS_TEMPERANCE,CRM_NS_AIR,CRM_NS_REST,CRM_NS_TRUST,CRM_NS_TOTAL,CRM_NS_CREATED_USER,CRM_NS_MODIFIED_USER) ");
	sqlStr.append("VALUES("+getNextNSID()+" , '" + userBean.getUserName() +"', ");
	String nutritionStr = "";
	for(int i = 0; i<nutrition.length;i++){	
		if(!nutrition[i].equals("/")){
		nutritionStr = nutritionStr + nutrition[i]+ ",";
		total++;
		}
		
	}
	sqlStr.append("'"+nutritionStr+"', ");
	
	String exerciseStr = "";
	for(int i = 0; i<exercise.length;i++){		
		if(!exercise[i].equals("/")){
		exerciseStr = exerciseStr + exercise[i]+ ",";
		total++;
		}
	}
	sqlStr.append("'"+exerciseStr+"', ");
	
	String waterStr = "";
	for(int i = 0; i<water.length;i++){	
		if(!water[i].equals("/")){
		waterStr = waterStr + water[i]+ ",";
		total++;
		}
	}
	sqlStr.append("'"+waterStr+"', ");
	
	String sunlightStr = "";
	for(int i = 0; i<sunlight.length;i++){	
		if(!sunlight[i].equals("/")){
		sunlightStr = sunlightStr + sunlight[i]+ ",";
		total++;
		}
	}
	sqlStr.append("'"+sunlightStr+"', ");
	
	String temperanceStr = "";
	for(int i = 0; i<temperance.length;i++){	
		if(!temperance[i].equals("/")){
		temperanceStr = temperanceStr + temperance[i]+ ",";
		total++;
		}
	}
	sqlStr.append("'"+temperanceStr+"', ");
	
	String airStr = "";
	for(int i = 0; i<air.length;i++){
		if(!air[i].equals("/")){
		airStr = airStr + air[i]+ ",";
		total++;
		}
	}
	sqlStr.append("'"+airStr+"', ");
	
		
	String restStr = "";
	for(int i = 0; i<rest.length;i++){
		if(!rest[i].equals("/")){
		restStr = restStr + rest[i]+ ",";
		total++;
		}
	}
	sqlStr.append("'"+restStr+"', ");
	
	String trustStr = "";
	for(int i = 0; i<trust.length;i++){		
		if(!trust[i].equals("/")){
		trustStr = trustStr + trust[i]+ ",";
		total++;
		}
	}
	sqlStr.append("'"+trustStr+"', ");
			
	sqlStr.append("'"+total+"', '" +userBean.getUserName()+"' , '"+userBean.getUserName()+"' ");		
			
	sqlStr.append(") ");
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

private static String getNextNSID() {
	String nsID = null;
	
	ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CRM_NS_ID) + 1 FROM CRM_CLIENTS_NEWSTART");
	
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		nsID = reportableListObject.getValue(0);
		// set 1 for initial		
		
		if (nsID == null || nsID.length() == 0) return "1";
	}

	return nsID;
}

private ArrayList getCRMClientDoneTodayTest(String userName) {	
	ArrayList result = UtilDBWeb.getReportableList("SELECT * FROM CRM_CLIENTS_NEWSTART WHERE CRM_USERNAME = '"+userName+"'	AND TO_CHAR(CRM_NS_CREATED_DATE, 'DD/MM/YYYY') = TO_CHAR(SYSDATE, 'DD/MM/YYYY') AND CRM_NS_LEVEL IS NULL ");
	
	return result;
}
%>
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
<style>
		.food{
		background-color:#FFB163;	
		}
		.temperance{
		background-color:#FF9696;	
		}
		.exercise{
		background-color:#FF5050;		
		}
		.air{
		background-color:#0AEB0A;		
		}
		.water{
		background-color:#1EA7EB;	
		}
		.rest{
		background-color:#D7A0D7;	
		}
		.sunlight{
		background-color:#EEEE6E;	
		}
		.trust{
		background-color:#D2E1BD;	
		}
	</style>

<jsp:include page="../../common/header.jsp"/>
<body>
<center>
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td align="left"><img src="../../images/logo_hkah.gif" border="0" width="261" height="113" /></td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td align="center">
		<b class="b1"></b><b class="b2"></b><b class="b3"></b><b class="b4"></b>
		<div class="contentb">
<%if(!isSubmitForm){ %>
		<form name="form1" action="newstart_record.jsp" method="post">
			<table width="690" border="1" cellpadding="0" cellspacing="0" style="background-color:white;">
				<tr>
					<td colspan="2">
						<span class="admissionLabel mediumText">
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr valign="center">
									<td style="text-align:left;color:<%=color1 %>" class="<%=label1 %>" width="25%"><p>(N) 飲食貨幣</p></td>
									<td style="text-align:left;color:<%=color2 %>" class="<%=label2 %>" width="25%"><p>(E) 運動貨幣</p></td>
									<td style="text-align:left;color:<%=color3 %>" class="<%=label3 %>" width="25%"><p>(W) 飲水貨幣</td>
									<td style="text-align:left;color:<%=color4 %>" class="<%=label4 %>" width="25%"><p>(S) 陽光貨幣</p></td>
									
								</tr>
								<tr>
									<td style="text-align:left;color:<%=color5 %>" class="<%=label5 %>" width="25%"><p>(T) 節制貨幣 </p></td>
									<td style="text-align:left;color:<%=color6 %>" class="<%=label6 %>" width="25%"><p>(A) 空氣貨幣</p></td>
									<td style="text-align:left;color:<%=color7 %>" class="<%=label7 %>" width="25%"><p>(R) 休息貨幣</p></td>
									<td style="text-align:left;color:<%=color8 %>" class="<%=label8 %>" width="25%"><p>(T) 信靠貨幣</p></td>
								</tr>
							</table>
						</span>
					</td>
				</tr>
			
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="top" align="left">
<%if (pageNoInt == 1) { %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr class=food><td style="font-weight:bold;width:20%;font-size:180%" >(N) 飲食貨幣</td><td><img width="32" height = "32" src='../../images/coin03.gif'/></td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-weight:bold;font-size:120%"colspan = "2">民以食為天，香港更有美食天堂之稱號。有益的食物就是能提供身體營養、能量及生長的食物。食物營養種類：碳水化合物（提供能量）、蛋白質（修補）
										、脂肪（保護）、維他命（免疫）、礦物質（免疫）、纖維（排毒）、植物化合物（防病）、抗氧化物（防老）、水份（滋潤）。食物經過消化作用後分解成營養，再由
										血管送入細胞。</td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:110%">食物貨幣計分法：</td></tr>
										<tr>
											<td style="font-size:110%" colspan = "2">
											<%for(int i = 0;i<5;i++){ %>
												<%=nutritionString[i] %> : <input type="checkbox" <%=(nutrition[i]!=null && nutrition[i].equals("n"+(i+1)))?"checked":"" %> onclick="saveCheckBoxSelection('n<%=i+1%>')" name="n<%=i+1%>" value="n<%=i+1%>"> １個  
												 <img width="18" height = "18" src='../../images/coin03.gif'/> </br></input>
												
											<%} %>
											</td>
										</tr>	
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:80%" colspan = "2">健康啟示：「人如其食」－ Victor Lindlahar</td></tr>	
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:80%" colspan = "2">人身體的好與壞有賴於我們所吃的食物!</td></tr>					
									</table>
									 <img style="position:absolute; TOP:320px; LEFT:720px;" width="120" height = "120" src='../../images/mixed_fruit_.jpg'/> 
																														
<%} else if (pageNoInt == 2) { %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr class=exercise><td style="font-weight:bold;width:20%;font-size:180%" >(E) 運動貨幣</td><td><img width="32" height = "32" src='../../images/coin03.gif'/></td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-weight:bold;font-size:120%"colspan = "2">我們常被邀請去參加「活動」，對嗎？其實，若我們要「活」，就要「動」了！人體的構造是讓人可以作出高技能的運動，看看世界上的運動健將，
										就明白人體在足夠運動下，能作出高水準的表現。每日的活動所需的能量是經由食物消化後而來的，這就是所謂「有入有出」！若只有進食，而能量消耗少，就變成肥胖；但若只有活動而進食少，
										就變得瘦弱了。所以，進食量與活動量必須要平衡。</td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:110%">運動貨幣計分法：</td></tr>
										<tr>
											<td style="font-size:110%" colspan = "2">
											<%for(int i = 0;i<5;i++){ %>
												<%=exerciseString[i] %> : <input type="checkbox" <%=(exercise[i]!=null && exercise[i].equals("e"+(i+1)))?"checked":"" %> onclick="saveCheckBoxSelection('e<%=i+1%>')" name="e<%=i+1%>" value="e<%=i+1%>"> １個   
												<img width="18" height = "18" src='../../images/coin03.gif'/></br></input>											
											<%} %>
											</td>
										</tr>	
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:80%" colspan = "2">健康啟示：持久運動，能促進血液循環。</td></tr>
									</table>		
									 <img style="position:absolute; TOP:320px; LEFT:720px;" width="99" height = "150" src='../../images/exercise.jpg'/> 
										
<%} else if (pageNoInt == 3) { %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr class=water><td style="font-weight:bold;width:20%;font-size:180%" >(W) 飲水貨幣</td><td><img width="32" height = "32" src='../../images/coin03.gif'/></td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-weight:bold;font-size:120%"colspan = "2">中國人有云：健康就是財富，水為財也！事實上，水與健康真是有很大關係的。水份佔體重的７０％，腦部的水份是８５％！所以，人不喝水，影響最大是腦部
										（人體運作總台）健康。人若缺水，影響健康！</td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:110%">水份貨幣計分法：</td></tr>
										<tr>
											<td style="font-size:110%" colspan = "2">
											<%for(int i = 0;i<5;i++){ %>
												<%=waterString[i] %> : <input type="checkbox" <%=(water[i]!=null && water[i].equals("w"+(i+1)))?"checked":"" %> onclick="saveCheckBoxSelection('w<%=i+1%>')" name="w<%=i+1%>" value="w<%=i+1%>"> １個   
												<img width="18" height = "18" src='../../images/coin03.gif'/></br></input>											
											<%} %>
											</td>
										</tr>	
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:80%" colspan = "2">健康啟示：水是天賜的恩澤，能洗滌身心靈。</td></tr>
									</table>	
									<img style="position:absolute; TOP:320px; LEFT:720px;" width="120" height = "120" src='../../images/water.jpg'/> 
										
<%} else if (pageNoInt == 4) { %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr class=sunlight><td style="font-weight:bold;width:20%;font-size:180%" >(S) 陽光貨幣</td><td><img width="32" height = "32" src='../../images/coin03.gif'/></td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-weight:bold;font-size:120%"colspan = "2">今日的香港人，大部份曬光管而一曬陽光，失去由曬陽光帶來的益處。每天曬陽光１０－１５分鐘，能增強免疫功能，減低３０－４０％患感冒的機會；降膽固醇；
										適量的陽光照射皮膚，有助身體製造維他命D，吸收鈣質，強壯骨骼；有助減低血糖指數。</td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:110%">陽光貨幣計分法：</td></tr>
										<tr>
											<td style="font-size:110%" colspan = "2">
											<%for(int i = 0;i<5;i++){ %>
												<%=sunlightString[i] %> : <input type="checkbox" <%=(sunlight[i]!=null && sunlight[i].equals("s"+(i+1)))?"checked":"" %> onclick="saveCheckBoxSelection('s<%=i+1%>')" name="s<%=i+1%>" value="s<%=i+1%>"> １個   
												<img width="18" height = "18" src='../../images/coin03.gif'/></br></input>											
											<%} %>
											</td>
										</tr>	
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:80%" colspan = "2">健康啟示：陽光具有醫治之能力</td></tr>	
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:80%" colspan = "2">生命是依賴太陽的溫暖滋養而存活。</td></tr>
									</table>	
									 <img style="position:absolute; TOP:320px; LEFT:720px;" width="120" height = "120" src='../../images/sun.jpg'/> 
																					
<%} else if (pageNoInt == 5) { %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr class=temperance><td style="font-weight:bold;width:20%;font-size:180%" >(T) 節制貨幣</td><td><img width="32" height = "32" src='../../images/coin03.gif'/></td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-weight:bold;font-size:120%"colspan = "2">中國人特別重視德行，其中一種為自己並為國家利益的德行就是「節制」：即適量地進行一切有益健康的事情，包括飲食、睡眠、電腦上網、運動及工作等，並且摒棄一切有害的生活習慣。
										所以，要禁絕一切刺激品，如：咖啡因、茶鹼、汽水、毒品及煙酒等。其中煙酒實乃毒品的踏腳石，青少年若吸煙，不能掉以輕心！</td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:110%">節制貨幣計分法：</td></tr>
										<tr>
											<td style="font-size:110%" colspan = "2">
											<%for(int i = 0;i<5;i++){ %>
												<%=temperanceString[i] %> : <input type="checkbox" <%=(temperance[i]!=null && temperance[i].equals("t"+(i+1)))?"checked":"" %> onclick="saveCheckBoxSelection('t<%=i+1%>')" name="t<%=i+1%>" value="t<%=i+1%>"> １個   
												<img width="18" height = "18" src='../../images/coin03.gif'/></br></input>											
											<%} %>
											</td>
										</tr>	
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:80%" colspan = "2">健康啟示：良好的生活，必需有節制，禁絕一切有害身體的事物。</td></tr>
									</table>
									<img style="position:absolute; TOP:320px; LEFT:720px;" width="120" height = "120" src='../../images/temperance.jpg'/> 
																			
<%} else if (pageNoInt == 6) { %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr class=air><td style="font-weight:bold;width:20%;font-size:180%" >(A) 空氣貨幣</td><td><img width="32" height = "32" src='../../images/coin03.gif'/></td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-weight:bold;font-size:120%"colspan = "2">中國人有云：生生猛猛，即代表活活潑潑！有生氣才有生命，沒有氣，
										氣斷了，生命就終結。大自然裡的空氣含氧量為２１％，人體的肺部，經過呼吸作用，將戶外的空氣氧份吸入體內，以供身體使用。
										如何有效地使氧氣進入體內？藉「深呼吸運動」。</td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:110%">空氣貨幣計分法：</td></tr>
										<tr>
											<td style="font-size:110%" colspan = "2">
											<%for(int i = 0;i<5;i++){ %>
												<%=airString[i] %> : <input type="checkbox" <%=(air[i]!=null && air[i].equals("a"+(i+1)))?"checked":"" %> onclick="saveCheckBoxSelection('a<%=i+1%>')" name="a<%=i+1%>" value="a<%=i+1%>"> １個   
												<img width="18" height = "18" src='../../images/coin03.gif'/></br></input>											
											<%} %>
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:80%" colspan = "2">健康啟示：清新空氣能活化細胞，並改善身體機能。</td></tr>	
										
									</table>	
									<img style="position:absolute; TOP:320px; LEFT:720px;" width="150" height = "99" src='../../images/air.jpg'/> 
																						
<%} else if (pageNoInt == 7) { %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr class=rest><td style="font-weight:bold;width:20%;font-size:180%" >(R) 休息貨幣</td><td><img width="32" height = "32" src='../../images/coin03.gif'/></td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-weight:bold;font-size:120%"colspan = "2">休息是為了走更遠的路！身體的器官需要休息，例如：長時間不歇用腦思考，可引發情緒病
										；腸胃不歇地長期做消化工作，會導致胃病；血管長期被緊張影響受壓，將造成心臟病；手部或足部過度勞損，會導致骨腱問題；眼睛長期在電腦面前工作，可引起眼疾等等。
										所以，休息實在是生理健康的需要，不是可有可無的。為您的身體和心靈健康，請安排一個規律的休息時間！</td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:110%">休息貨幣計分法：</td></tr>
										<tr>
											<td style="font-size:110%" colspan = "2">
											<%for(int i = 0;i<5;i++){ %>
												<%=restString[i] %> : <input type="checkbox" <%=(rest[i]!=null && rest[i].equals("r"+(i+1)))?"checked":"" %> onclick="saveCheckBoxSelection('r<%=i+1%>')" name="r<%=i+1%>" value="r<%=i+1%>"> １個   
												<img width="18" height = "18" src='../../images/coin03.gif'/></br></input>											
											<%} %>
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:80%" colspan = "2">健康啟示：身心休息，能修復受損細胞。</td></tr>	
									</table>	
										<img style="position:absolute; TOP:340px; LEFT:720px;" width="132" height = "95" src='../../images/sleep.jpg'/> 
																		
<%} else if (pageNoInt == 8) { %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr class=trust><td style="font-weight:bold;width:20%;font-size:180%" >(T) 信靠貨幣</td><td><img width="32" height = "32" src='../../images/coin03.gif'/></td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-weight:bold;font-size:120%"colspan = "2">No man is an island！沒有人是孤島！香港人煙稠密，
										更需要培養待人之道。人際關係包括人與家人、
										親戚、朋友及社會人士。良好的人際關係需要尊重、信任與體諒。建立及享受可信賴的人際關係，加上有信仰的生活，充實過每一天，為永恆作投資。</td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:110%">信靠貨幣計分法：</td></tr>
										<tr>
											<td style="font-size:110%" colspan = "2">
											<%for(int i = 0;i<5;i++){ %>
												<%=trustString[i] %> : <input type="checkbox" <%=(trust[i]!=null && trust[i].equals("tr"+(i+1)))?"checked":"" %> onclick="saveCheckBoxSelection('tr<%=i+1%>')" name="tr<%=i+1%>" value="tr<%=i+1%>"> １個   
												<img width="18" height = "18" src='../../images/coin03.gif'/></br></input>											
											<%} %>
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td style="font-size:80%" colspan = "2">健康啟示：信心不是知道明天如何，而是知道誰帶來明天。</td></tr>	
									</table>		
									<img style="position:absolute; TOP:320px; LEFT:720px;" width="150" height = "99" src='../../images/trust.jpg'/> 
																				
<%}%>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>					
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="pane">
							<table>
								<tr>
									<td>
										
<%	if (pageNoInt > 1) { %>
										<button onclick="pageAction('<%=pageNoInt - 1 %>');return false;"  class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">上一步</button>
<%	} %>
<%	if (pageNoInt <= 7) { %>
										<button onclick="pageAction('<%=pageNoInt + 1 %>');return false;"  class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">&nbsp;&nbsp;下一步&nbsp;&nbsp;</button>
<%	} %>
																				
									</td>	
									<td>
									
<%	if (pageNoInt >= 8) { %>
										<button onclick="submitAction();return false;" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">提交</button>
										<input type="hidden" name="submitForm" value="y" />
<%	} %>																				
									</td>				
								</tr>
							</table>
						</div>
					</td>
				</tr>			
			</table>
			
			<input type="hidden" name="pageNo" />
			<%for(int i = 0;i<5;i++){ %>
				<input type="hidden" name="n<%=i+1 %>Hidden" value=<%=nutrition[i]==null?"":nutrition[i] %> />
			<%} %>
			
			<%for(int i = 0;i<5;i++){ %>
				<input type="hidden" name="e<%=i+1 %>Hidden" value=<%=exercise[i]==null?"":exercise[i] %> />
			<%} %>
			
			<%for(int i = 0;i<5;i++){ %>
				<input type="hidden" name="w<%=i+1 %>Hidden" value=<%=water[i]==null?"":water[i] %> />
			<%} %>
			
			<%for(int i = 0;i<5;i++){ %>
				<input type="hidden" name="s<%=i+1 %>Hidden" value=<%=sunlight[i]==null?"":sunlight[i] %> />
			<%} %>
			
			<%for(int i = 0;i<5;i++){ %>
				<input type="hidden" name="t<%=i+1 %>Hidden" value=<%=temperance[i]==null?"":temperance[i] %> />
			<%} %>
			
			<%for(int i = 0;i<5;i++){ %>
				<input type="hidden" name="a<%=i+1 %>Hidden" value=<%=air[i]==null?"":air[i] %> />
			<%} %>
			
			<%for(int i = 0;i<5;i++){ %>
				<input type="hidden" name="r<%=i+1 %>Hidden" value=<%=rest[i]==null?"":rest[i] %> />
			<%} %>
			
			<%for(int i = 0;i<5;i++){ %>
				<input type="hidden" name="tr<%=i+1 %>Hidden" value=<%=trust[i]==null?"":trust[i] %> />
			<%} %>
			</form>
		<%}else{ %>	
		<%} %>
		</div>
		<b class="b4"></b><b class="b3"></b><b class="b2"></b><b class="b1"></b>
	</td>
</tr>
</table>
</center>
<script language="javascript">

	function pageAction(pno) {		
		document.form1.pageNo.value = pno;		
		 $('input[name=submitForm]').val('n');
		document.form1.submit();
	}

	function saveCheckBoxSelection(id){		
		if($('input[name='+id+']').is(':checked')){
			 $('input[name='+id+'Hidden]').val(id);
		}else{
			$('input[name='+id+'Hidden]').val('');
		}		
	}
	
	function submitAction() {	
		document.form1.submit();
	}
	
	$(document).ready(function() {			
		<% if(isSubmitForm){%>
			<%if(submitFormSuccess){%>
				alert('提交成功');
				window.close();
			<%}else{%>
				alert('提交失敗');		
				window.close();
		<%	 }
			}
		%>
	});

</script>
</body>
</html:html>
<%}else{
%>
<script type="text/javascript">
alert('已完成今天健康測試');
window.close();
</script>
<%
}
%>
