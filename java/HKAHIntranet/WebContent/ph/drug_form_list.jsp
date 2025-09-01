<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.apache.commons.lang.time.DateUtils"%>
<%@ page import="net.sf.jasperreports.engine.*"%>
<%@ page import="net.sf.jasperreports.engine.util.*"%>
<%@ page import="net.sf.jasperreports.engine.export.*"%>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.servlet.HKAHInitServlet"%>
<%@ page import="net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter"%>
<%@ page import="com.hkah.web.db.PHDrugDB"%>

<%!
public class DrugDetails{
	String drugID;
	String classOne;
	String classTwo;
	String classThree;
	String classFour;
	String folder;
	String linkTable;
	String genName;
	String braName;
	String dosForm;
	String strength;
	String hkah;
	String twah;
	
	
	
	public DrugDetails(String drugID, String classOne, String classTwo, String classThree, String classFour,
						String folder, String linkTable, String genName, String braName, String dosForm,
						String strength, String hkah, String twah){
		this.drugID = drugID;
		this.classOne = classOne;
		this.classTwo = classTwo;
		this.classThree = classThree;
		this.classFour = classFour;
		this.folder = folder;
		this.linkTable = linkTable;
		this.genName = genName;
		this.braName = braName;
		this.dosForm = dosForm;
		this.strength = strength;
		this.hkah = hkah;
		this.twah = twah;
	}
}

private String generateDrugList(ArrayList<DrugDetails> listOfDrugDetails){
	StringBuffer listStr = new StringBuffer();

		
	for(DrugDetails d : listOfDrugDetails){
		
		if(d.classOne.length() > 0 && d.classTwo.length() == 0){
			
			if(d.linkTable != null && d.linkTable.length() > 0){	
				listStr.append("<li id='" + d.linkTable + "'>");
			} else {
				listStr.append("<li id='" + d.classOne + "' >");
			}
			
			listStr.append(d.classOne + "&nbsp;&nbsp;");
			listStr.append(d.genName);
			
			StringBuffer listStrTwo = new StringBuffer();
			int classTwoHaveValue = 0;
			for(DrugDetails d2 : listOfDrugDetails){				
				if(d2.classOne.equals(d.classOne)){
					if(d2.classTwo.length() > 0 && d2.classThree.length() == 0){						
						if(classTwoHaveValue == 0){
							listStrTwo.append("<ul>");	
						}
						classTwoHaveValue = 1;
						
						if(d2.linkTable != null && d2.linkTable.length() > 0){	
							listStrTwo.append("<li id='" + d2.linkTable + "'>");
						} else {
							listStrTwo.append("<li id='" + d2.classOne + "." + d2.classTwo + "'>");
						}
						listStrTwo.append(d2.classOne + "." + d2.classTwo + "&nbsp;&nbsp;");
						listStrTwo.append(d2.genName);
						
						
						StringBuffer listStrThree = new StringBuffer();
						int classThreeHaveValue = 0;
						for(DrugDetails d3 : listOfDrugDetails){				
							if(d3.classOne.equals(d.classOne) && d3.classTwo.equals(d2.classTwo)){
								if(d3.classThree.length() > 0 && d3.classFour.length() == 0){						
									if(classThreeHaveValue == 0){
										listStrThree.append("<ul>");	
									}
									classThreeHaveValue = 1;
									//listStrThree.append("<li id='" + d3.classOne + "." + d3.classTwo + "." + d3.classThree + "'>");
									if(d3.linkTable != null && d3.linkTable.length() > 0){	
										listStrThree.append("<li id='" + d3.linkTable + "'>");
									} else {
										listStrThree.append("<li id='" + d3.classOne + "." + d3.classTwo + "." + d3.classThree + "'>");
									}
									listStrThree.append(d3.classOne + "." + d3.classTwo +  "." + d3.classThree + "&nbsp;&nbsp;");
									listStrThree.append(d3.genName);
								
									
									StringBuffer listStrFour = new StringBuffer();
									int classFourHaveValue = 0;
									for(DrugDetails d4 : listOfDrugDetails){				
										if(d4.classOne.equals(d.classOne) && d4.classTwo.equals(d2.classTwo) && d4.classThree.equals(d3.classThree)){
											if(d4.classFour.length() > 0){						
												if(classFourHaveValue == 0){
													listStrFour.append("<ul>");	
												}
												classFourHaveValue = 1;
												if(d4.linkTable != null && d4.linkTable.length() > 0){	
													listStrFour.append("<li id='" + d4.linkTable + "'>");
												} else {
													listStrFour.append("<li id='" + d4.classOne + "." + d4.classTwo + "." + d4.classThree + "." + d4.classFour + "'>");
												}
												
												listStrFour.append(d4.classOne + "." + d4.classTwo +  "." + d4.classThree +  "." + d4.classFour  + "&nbsp;&nbsp;");
												listStrFour.append(d4.genName);
											
												listStrFour.append("</li>");
												
											}
										}
									}
									if(classFourHaveValue == 1){
										listStrFour.append("</ul>");
									}
									
									listStrThree.append(listStrFour.toString());
									listStrThree.append("</li>");
									
								}
							}
						}
						if(classThreeHaveValue == 1){
							listStrThree.append("</ul>");
						}
						
						listStrTwo.append(listStrThree.toString());
						listStrTwo.append("</li>");						
					}
				}
			}
			if(classTwoHaveValue == 1){
				listStrTwo.append("</ul>");
			}
			
			listStr.append(listStrTwo.toString());
			
			listStr.append("</li>");
		}
	}

	return listStr.toString();
}

%>
<%
	String ward = request.getParameter("ward");
	String doctorCode = request.getParameter("doctorCode");
	String command = request.getParameter("command");

	ArrayList drugFolderList = PHDrugDB.getDrugFolder();
	ArrayList<DrugDetails> listOfDrugDetails = new ArrayList<DrugDetails>();

	if( drugFolderList.size() != 0){
		ReportableListObject drugFolderObject = null;
		for (int i = 0; i < drugFolderList.size(); i++) {
			drugFolderObject = (ReportableListObject) drugFolderList.get(i);
			
			listOfDrugDetails.add(new DrugDetails(drugFolderObject.getValue(0), drugFolderObject.getValue(1), drugFolderObject.getValue(2),
							drugFolderObject.getValue(3), drugFolderObject.getValue(4), drugFolderObject.getValue(5), 
							drugFolderObject.getValue(6), drugFolderObject.getValue(7), drugFolderObject.getValue(8),
							drugFolderObject.getValue(9), drugFolderObject.getValue(10), drugFolderObject.getValue(11),
							drugFolderObject.getValue(12)));
		}
	}
	
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />

<!-- <link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.drug.css" />" />  -->
<script type="text/javascript" src="<html:rewrite page="/js/jquery.drug.js"/>" /></script>
<script src="//code.jquery.com/ui/1.11.3/jquery-ui.js"></script>

<style>
#listContainer {
	margin-top: 15px;
}

#expList ul,li {
	list-style: none;
	margin: 0;
	padding: 0;
	cursor: pointer;
}

#expList p {
	margin: 0;
	display: block;
}

#expList p:hover {
	background-color: #121212;
}

#expList li {
	line-height: 140%;
	text-indent: 0px;
	background-position: 0px 2px;
	padding-left: 20px;
	background-repeat: no-repeat;
}

/* Collapsed state for list element */
#expList .collapsed {
	background-image: url(../images/tog_plus.gif);
}
/* Expanded state for list element
/* NOTE: This class must be located UNDER the collapsed one */
#expList .expanded {
	background-image: url(../images/tog_minus.gif);
}

.listControl{
	margin-bottom: 15px;
}
.listControl a {
    border: 1px solid #555555;
    color: #555555;
    cursor: pointer;
    height: 1.5em;
    line-height: 1.5em;
    margin-right: 5px;
    padding: 4px 10px;
}
.listControl a:hover {
    background-color:#555555;
    color:#222222; 
    font-weight:normal;
}


		
	.roundBorder {
	padding:5px;
    border: 1px solid #C73C3C;
    background: #C73C3C;
    color: white;
    }
    
    .roundDrugTableBorder {
    border: 1px solid #B7E2EB;
    padding: 10px 20px; 
    background: #B7E2EB;
    width: 100%;
    border-radius: 25px;
    margin-left: 25px;
    }
     
     .ui-autocomplete {
   height: 250px;
   width: 300px;
   overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
  }
 
.underline {
    cursor: pointer;
}
</style>
<body id='mainBody' style="height:100%;">
	<div id="indexWrapper"  style="height:100%;">
		<div id="mainFrame"  style="height:100%;">
			<div id="contentFrame" style="width:100%;height:100%;background-color:white;">
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="Electronic Drug Formulary" />
					<jsp:param name="mustLogin" value="N" />
					<jsp:param name="keepReferer" value="N" />
				</jsp:include>
				
<!-- overlay -->
					<div onclick='closeDrugDialogPanel()' id="overlay" class="ui-widget-overlay" style="display:none;"></div>
					<!-- dialog -->
					<div id="drugDialogPanel" style="width:910px; height:540px; display:none; position:absolute; z-index:12; "
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
						<table  border="1" id="drugDialogTable">
							<tbody>
								<tr>
									<td id='dDialogSection' class="ui-widget-header"style="width:100%;
											color:black; height:25px; font-size:16px; 
											font-weight:bold;">
									</td>
									<td class="ui-widget-header">
										<img src='../images/cross.jpg' style='float:right' onclick='closeDrugDialogPanel()'/>
									</td>
								</tr>																			
								<tr>								
									<td  colspan='2' style='border-width:1px; border-style:solid; '>
										<div id='scroll-pane' class='scroll-pane jspScrollable' style='overflow-x: hidden;overflow:scroll; padding: 0px; width: 100%; height:500px'>
											<div id='drugtableList'></div>
										</div>										
									</td>									
								</tr>							
							</tbody>
						</table>
					</div>
					
				<div class="roundBorder">
					<span style='font-weight:bold;font-size:120%;'>Legal Disclaimer:</span><br/><br/>
					The Pharmacy Department, Adventist Hospital is providing information and services as a 
					furtherance of its mission and purpose.	While the Pharmacy Department, Adventist Hospital
					has taken all reasonable steps to ensure the information and presentation of materials in
					this database is accurate, the Pharmacy Department, Adventist Hospital does not guarantee
					the accuracy and completeness of the materials. Information provided in this database
					is neither intended not implied to be a substitute for professional medical advice. 
					The Pharmacy Department, Adventist Hospital makes no representations about the suitability 
					of the information and services for any purpose. The materials available in the database are 
					provided with no warranty, expressed or implied, and all such warranties are hereby disclaimed.
				</div>
				<table>
					<tr>
						<td>
							<form name="search_form" action="drug_from_list.jsp"
								method="post"></form>
						</td>
					</tr>
				</table>
				
				<br/>
				
<table border='0' style="width:100%">
	<tr>
	<td>
		<input style="margin-left: 100px;" type="button" onclick="return showAppendix();" value="Useful Reference" /> 
		<!-- <a href="../documentManage/download.jsp?documentID=629">Useful Reference</a> --> 	
		</td>
	</tr>
	<tr>
	<td>&nbsp;
		</td>
	</tr>
	<tr>
		<td style="width:80%">
				<div  class="roundDrugTableBorder">
					<span style='font-size:120%;'>Search by Drug Name :</span> 
					<input id="drugName" style="width:300px;"/>
					<input type="submit" onclick="return submitSearch();" value="Search" />				
					<input type="button" onclick="return clearFields();" value="Clear" />
					
				</div>
		</td>		
	</tr>
	<tr>
		<td colspan='2'>
				<br/>		
				<span style='margin-left: 50px;'>OR</span>
		</td>				
	</tr>
<!-- <div class="listControl"><a id="expandList"></a>Expand All <a id="collapseList"></a>Collapse All</div>  -->
	<tr> 
		<td>				
				<div id="listContainer">
					<ul id="expList" class="roundDrugTableBorder" style="font-size:120%;">	
					
						<li>Select From List
							<ul >	
								<%=generateDrugList(listOfDrugDetails) %>
							</ul>
						</li>
					
					</ul>
				</div>
		</td>
	</tr>
</table>					
				</br>
				<div id="drugTableResult">
				
				</div>	
								
				<br/><br/><br/>
				
				
				<script language="javascript">
					function clearFields(){
						document.getElementById('drugName').value = '';
						 return false;
					}
				
					function submitSearch() {
//showLoadingBox('body', 500, $(window).scrollTop());
						var url = "getDrugTable.jsp?drugName="+encodeURIComponent(document.getElementById('drugName').value);
						$.ajax({
							url: url,
							async: false,
							cache:false,
							success: function(values){
								if(values) {							
									if(values != '') {																							
										$('#drugTableResult').hide().html(values).fadeIn('fast');
										createClickableRow();
									}
									else {
										alert('Error occured while searching record.');
									}
								}
//hideLoadingBox('body', 500);
							},
							error: function() {
								alert('Error occured while searching record.');
							}
						});
					}

					function prepareList() {
						$('#expList').find('li:has(ul)').click(function(event) {
							if (this == event.target) {
								$(this).toggleClass('expanded');
								$(this).children('ul').toggle('medium');
							}
							return false;
						}).addClass('collapsed').children('ul').hide();
					};

					$(document).ready(function() {
						prepareList();						
					});
						
					$("#expList li").click(function(){
						getTableData($(this));
			            
					}).children().click(function(e) {
					  return false;
					});
					
					function getTableData(ev) {
						var $this   = ev;
			            	//alert($this.attr('id'))
//showLoadingBox('body', 500, $(window).scrollTop());
							var url = "getDrugTable.jsp?drugClass="+$this.attr('id');
							$.ajax({
								url: url,
								async: false,
								cache:false,
								success: function(values){
									if(values) {
										if(values.indexOf("Not record found in Drug List") != -1) {
								            if($this.children().length == 0){
								            	$('#drugTableResult').hide().html(values).fadeIn('fast');
												createClickableRow();
												 
												 var element_to_scroll_to = document.getElementById('availableList');
											element_to_scroll_to.scrollIntoView({block: "start", behavior: "smooth"});
								            }
								          
										} else {											
											$('#drugTableResult').hide().html(values).fadeIn('fast');
											createClickableRow();
											
											if($this.children().length == 0){
												var element_to_scroll_to = document.getElementById('availableList');
												element_to_scroll_to.scrollIntoView({block: "start", behavior: "smooth"});
											}
										}
									}
//hideLoadingBox('body', 500);
								},
								error: function() {
									alert('Error occured while searching record.');
								}
							});
			            
					}
					
					 $('#expandList')
					    .unbind('click')
					    .click( function() {
					        $('.collapsed').addClass('expanded');
					        $('.collapsed').children().show('medium');
					    })
					    $('#collapseList')
					    .unbind('click')
					    .click( function() {
					        $('.collapsed').removeClass('expanded');
					        $('.collapsed').children().hide('medium');
					    })
					    
					    
					    $(function() { 
						    $( "#drugName" ).autocomplete({
						      source: function( request, response ) {
						        $.ajax({
						          url: "searchFieldResult.jsp?callback=?",
						          //url: "http://gd.geobytes.com/AutoCompleteCity",
						          dataType: "jsonp",
						          cache: false,
						          data: "drugName=" + encodeURIComponent(document.getElementById('drugName').value),
						          success: function( data ) {        	  
						        	  response( data );						        	
						          }         
						        });
						      },
						      minLength: 2,
						      select: function( event, ui ) {
						      
						      },
						      open: function() {
						        $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
						      },
						      close: function() {
						        $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
						      }
						    });
						  });
					 					
					 function createClickableRow(){		
							$('#row td.1').each(function(i,v) {	
								$(this).click(function(){
									
									
									
									$('div#overlay').css('height', $(document).height());
									$('div#overlay').css('width', $(document).width());
									$('div#overlay').css('display', '');
									$('div#overlay').css('z-index', '12');
									
									$('div#drugDialogPanel').css('top',document.body.scrollTop + 5);
									$('div#drugDialogPanel').css('left', 5);
									$('div#drugDialogPanel').fadeIn('fast');
									
									var element_to_scroll_to = document.getElementById('drugDialogPanel');
									element_to_scroll_to.scrollIntoView({block: "start", behavior: "smooth"});
									
									$('#dDialogSection').html($.trim( $(this).parent('tr').find("td").eq(0).html()));
									
									var url = "getDrugTable.jsp?drugClass="+$.trim( $(this).parent('tr').find("td").eq(0).html())+"&type=subtable";
									$.ajax({
										url: url,
										async: false,
										cache:false,
										success: function(values){
											if(values) {							
												if(values != '') {
													$('#drugtableList').html(values);
												}
												else {
													alert('Error occured while searching record.');
												}
											}
										},
										error: function() {
											alert('Error occured while searching record.');
										}
									});														
								});
							});
							
							$('#row td.1').each(function(i,v) {	
								$(this).addClass("underline");
								//$(this).css("color", "#0C4790");
								$(this).css("text-decoration", "underline");
								$(this).hover(function(){
									$(this).css("color", "#0C4790");
								    //$(this).css("text-decoration", "underline");
									
							    }, function(){
							    	$(this).css("color", "black");
							  	  	//$(this).css("text-decoration", "none");
							    	
								});
							});
						}
					 
					 function closeDrugDialogPanel() {
						$('div#drugDialogPanel').css('display', 'none');
						$('div#overlay').css('display', 'none');	
						$('#drugtableList').html('');
					}
					 
					 function showAppendix(){
						 callPopUpWindow("../ph/appendix_main.jsp");
					 }
				</script>
			</div>
		</div>
	</div>
</body>
</html:html>