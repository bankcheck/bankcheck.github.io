<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	<body>
		<div id="indexWrapper">
			<div id="mainFrame">
				<div id="contentFrame">
					<jsp:include page="title.jsp">
						<jsp:param name="title" value="Corporate Health Management Plan"/>
					</jsp:include>
					<table>
						<tr>
							<td>
								<div class="infoBox">
									<div class="infoHead2">
										<h3>
											甚麼是–「企業健康管理計劃」(Corporate Health Management Plan)
										</h3>
									</div>
									<div class="infoContent3">
										<div class="content">
											<p>
												一般健康促進活動，如健康講座、工作坊和體檢，只能提高員工對健康的認知
												水平 (Health Awareness Level)。「企業健康管理計劃」讓員工實行健康生
												活模式，著重執行和養成健康生活的習慣。本計劃內容包括基本身體檢查、專
												業分析、建立員工個人健康資料檔案、安排各項改善健康狀況的活動、跟進員
												工的健康生治改進情況、定期作健康評估報告。
											</p>
										</div>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="infoBox">
									<div class="infoHead2">
										<h3>計劃目的及內容</h3>
									</div>
									<div class="infoContent3">
										<div class="content">
											<h6>目的:</h6>
											<p>
												 協助企業公司員工實行健康生活模式，並持之以恆。
											</p>
											<br/><br/>
											<h6>內容：</h6>
											<label>第一階段 - 基礎理論課程 (為期1個月)</label>
											<ul style="list-style-type:disc;padding-left:20px;">
												<li>企業健康管理計劃介紹講座</li>
												<li>基本健康檢查(初期)</li>
												<li>個人身心評估報告(初期)</li>
												<li>新起點網上學習課程</li>
												<li>自我學習課程</li>
												<li>建立個人健康檔案</li>
											</ul>
											<br/>
											<label>第二階段 - 進階實習課程 (為期2個月)</label>
											<ul style="list-style-type:disc;padding-left:20px;">
												<li>烹飪工作坊</li>
												<li>運動工作坊</li>
												<li>健康日營</li>
											</ul>
											<br/>
											<label>第三階段 - 深造實習課程 (為期3個月)</label>
											<ul style="list-style-type:disc;padding-left:20px;">
												<li>新起點5日4夜實習營; 或</li>
												<li>新起點2日1夜實習營x 3</li>
												<li>基本健康檢查(中期)</li>
												<li>個人身心評估報告(中期)</li>
											</ul>
											<br/>
											<label>第四階段 – 生活實踐課程 (為期6個月)</label>
											<ul style="list-style-type:disc;padding-left:20px;">
												<li>專人跟進及指導</li>
												<li>健康評估報告</li>
											</ul>
										</div>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="infoBox">
									<div class="infoHead2">
										<h3>價目表Price list</h3>
									</div>
									<div class="infoContent3">
										<div class="content">
											<ol style="list-style-type:upper-roman; padding-left:30px;">
												<li>
													企業健康管理計劃
													<br/>
													<label>每人只需</label>
													<label style="font-size:26px;"><b>$1,428</b></label>
													<label style="font-size:12px;">起/月</label>
													<label>便可享有1年的跟進服務</label>
													<br/>
													<ul style="list-style-type:disc;padding-left:20px;">
														<li>計劃包括奉送：企業健康管理計劃介紹講座、網上學習課程 及 健康評估報告</li>
													</ul>
													<br/><br/>
												</li>
												<li>
													其他選擇性服務 Selective service
													<table border="1">
														<tr>
															<td colspan="3">
																<label>A. 上門健康檢查服務*</label>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<label>基本項目：</label>
															</td>
															<td align="center">
																<label>單價(港元)</label>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<ol style="list-style-type:decimal; padding-left:30px;">
																	<li><label>血壓量度</label></li>
																	<li>
																		<label>身體成份</label>
																		<ul style="list-style-type:square;padding-left:20px;">
																			<li><label>體重</label></li>
																			<li><label>身高</label></li>
																			<li><label>脂肪百分比</label></li>
																			<li><label>脂肪淨重量</label></li>
																			<li><label>肌肉淨重量</label></li>
																			<li><label>身體總水量</label></li>
																			<li><label>骨骼淨重量</label></li>
																			<li><label>新陳代謝率</label></li>
																			<li><label>代謝歲數</label></li>
																			<li><label>身體質量指數</label></li>
																		</ul>
																	</li>
																	<li><label>基本血糖量度</label></li>
																	<li><label>基本總膽固醇量度</label></li>
																	<li><label>一氧化碳量度</label></li>
																</ol>
															</td>
															<td align="center" valign="middle">
																<label>$ 380/位</label>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<label>增值項目：</label>
															</td>
															<td align="center">
																<label></label>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<ol style="list-style-type:decimal; padding-left:30px;">
																	<li><label>Hgb A1C</label></li>
																	<li><label>Lipid Profile</label></li>
																	<li><label>個人身心健康評估</label></li>
																</ol>
															</td>
															<td align="center" valign="middle">
																<ul style="list-style:none">
																	<li><label>$ 170/位</label></li>
																	<li><label>$ 50/位</label></li>
																	<li><label>$ 100/位</label></li>
																</ul>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<label>B. 其他項目：</label>
															</td>
															<td align="center">
																<label></label>
															</td>
														</tr>
														<tr>
															<td>
																<ol style="list-style-type:decimal; padding-left:30px;">
																	<li><label>度身設計健康工作坊</label></li>
																	<li><label>健康講座(指定題目)</label></li>
																	<li><label>健康講座(非指定題目)</label></li>
																	<li><label>度身設計健康日營*</label></li>
																</ol>
															</td>
															<td>
																<ul style="list-style:none">
																	<li><label>[約1.5小時長]</label></li>
																	<li><label>[約1小時長]</label></li>
																	<li><label>[約1小時長]</label></li>
																	<li><label>&nbsp;</label></li>
																</ul>
															</td>
															<td align="center" valign="middle">
																<ul style="list-style:none">
																	<li><label>$ 3,500</label></li>
																	<li><label>$ 2,000</label></li>
																	<li><label>$ 2,000</label></li>
																	<li><label>$ 1,431/位</label></li>
																</ul>
															</td>
														</tr>
													</table>
													<label>* = 參加人數每次最少30人</label>
												</li>
											</ol>
										</div>
									</div>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</body>
</html:html>