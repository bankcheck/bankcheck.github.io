<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<%!
public class ChaplainValues{
	String chapID;
	String[] values;
	public ChaplainValues(String chapID,String[] values){
		this.chapID = chapID;
		this.values = values;
	}
}

public class ChaplainDetailedValues{
	String chapID;
	public ArrayList<String> patNo = new ArrayList<String>();
	public ChaplainDetailedValues(String chapID){
		this.chapID = chapID;
		}
}


public static ArrayList getChapArea(String type){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT CHAPID,"+type+" ");	
	sqlStr.append("FROM CHAP_AREA ");
	sqlStr.append("WHERE ENABLE ='1' ");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public boolean checkSelected(String value,ArrayList<ChaplainValues>listOfChaplain,String chaplainID){
	for(ChaplainValues v:listOfChaplain){	
		
		if(v.chapID.equals(chaplainID))
		{		
			for(String s:v.values){			
				if(s.equals(value)){
					return  true;
				}
			}
		}
	}	
	return false;
}

%>


<%
UserBean userBean = new UserBean(request);
if (userBean != null || userBean.isLogin()) {
	
}else {

}

ArrayList chapWardRecord = getChapArea("WRD_CODE");
ArrayList<ChaplainValues> listOfChaplainWard = new ArrayList<ChaplainValues>();

if(chapWardRecord.size() != 0){
	for(int i =0;i<chapWardRecord.size();i++){
		 ChaplainValues tempChaplainWard;
		ReportableListObject chapWard = (ReportableListObject)chapWardRecord.get(i);
		tempChaplainWard = new ChaplainValues(chapWard.getValue(0),chapWard.getValue(1).split(","));
		listOfChaplainWard.add(tempChaplainWard);
	}
}

ArrayList chapLanguageRecord = getChapArea("MOTH_CODE");
ArrayList<ChaplainValues> listOfChaplainLanguage = new ArrayList<ChaplainValues>();

if(chapLanguageRecord.size() != 0){
	for(int i =0;i<chapLanguageRecord.size();i++){
		 ChaplainValues tempChaplainLanguage;
		ReportableListObject chapLanguage = (ReportableListObject)chapLanguageRecord.get(i);
		tempChaplainLanguage = new ChaplainValues(chapLanguage.getValue(0),chapLanguage.getValue(1).split(","));
		listOfChaplainLanguage.add(tempChaplainLanguage);
	}
}

ArrayList chapReligionRecord = getChapArea("RELCODE");
ArrayList<ChaplainValues> listOfChaplainReligion = new ArrayList<ChaplainValues>();

if(chapReligionRecord.size() != 0){
	for(int i =0;i<chapReligionRecord.size();i++){
		 ChaplainValues tempChaplainReligion;
		ReportableListObject chapReligion = (ReportableListObject)chapReligionRecord.get(i);
		tempChaplainReligion = new ChaplainValues(chapReligion.getValue(0),chapReligion.getValue(1).split(","));
		listOfChaplainReligion.add(tempChaplainReligion);
	}
}

ArrayList chapOtherRecord = getChapArea("Other");
ArrayList<ChaplainDetailedValues> listOfChaplainOther = new ArrayList<ChaplainDetailedValues>();
if(chapOtherRecord.size() != 0){
	for(int i =0;i<chapOtherRecord.size();i++){
		ChaplainDetailedValues tempChaplainOther;
		ReportableListObject chapOther = (ReportableListObject)chapOtherRecord.get(i);
			
		tempChaplainOther = new ChaplainDetailedValues(chapOther.getValue(0));
		String[] tempPatNo = chapOther.getValue(1).split(",");
		ArrayList<String> patNo = new ArrayList<String>();
		for(String s : tempPatNo){
			if(s.contains("patNo")){
				tempChaplainOther.patNo.add(s.split("-")[1]);
			}
		}
		listOfChaplainOther.add(tempChaplainOther);
	}
}

%>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>

.dataSummary {
	border-left:1px solid #000; 
	border-top:1px solid #000; 
	border-right:1px solid #CCC; 
	border-bottom:1px solid #ccc;
	cursor: pointer;
	
}

.zero{background:#FF8C8C}
.one{background:#A0D7D7}
.two{background:#50D050}
.three{background:#E178E1}
.four{background:#DAB35F}
.five{background:#8C8CFF}

	body {
		font: 0.8em arial, helvetica, sans-serif;
	}
	
    #header ul {
		list-style: none;
		padding: 0;
		margin: 0;
    }
    
	#header li {
		float: left;
		border: 1px solid #bbb;
		border-bottom-width: 0;
		margin: 0;
    }
    
	#header a {
		text-decoration: none;
		display: block;
		background: #eee;
		padding: 0.24em 1em;
		color: #00c;
		width: 8em;
		text-align: center;
    }
	
	#header a:hover {
		background: #ddf;
	}
	
	#header .selected {
		border-color: black;
	}
	
	#header .selected a {
		position: relative;
		top: 1px;
		background: white;
		color: black;
		font-weight: bold;
	}
	
	.pageContent {
		border: 1px solid black;
		clear: both;
		width:100%;	
	}
	
	h1 {
		margin: 0;
		padding: 0 0 1em 0;
	}
</style>
<body>
<DIV id=indexWrapper style="width:100%">
<DIV id=mainFrame style="width:100%">
<DIV id=contentFrame style="width:100%">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Chaplain's Supervised Area" />
	<jsp:param name="category" value="Chaplaincy" />
</jsp:include>


<div id="header"> 

<br>
<ul>
	<li onclick="showPage('wards')" id="list-wards"><a href="#page-wards">Ward</a></li>
	<li onclick="showPage('languages')" id="list-languages"><a href="#page-languages">Language</a></li>
	<li onclick="showPage('religions')" id="list-religions"><a href="#page-religions">Religion</a></li>
	<li onclick="showPage('other')" id="list-other"><a href="#page-other">Other</a></li>
</ul>

</div>


<div style="display:none" class="pageContent" id="page-wards" >   
<table cellpadding="0" class="contentFrameSearch" border="0" style="width:100%">
<%
ArrayList wardRecord = UtilDBWeb.getReportableList("SELECT WRDCODE,WRDNAME FROM WARD@IWEB ORDER BY WRDCODE");
%>
	<tr>
		<th></th>
<%
if(wardRecord.size() != 0){
	for(int j =1;j<wardRecord.size();j++){
		ReportableListObject ward = (ReportableListObject)wardRecord.get(j);
%>
		<th><%=ward.getValue(1)%></th>
<%
	}
}
%>
	</tr>

<%
	
ArrayList chaplainRecord ;
if (ConstantsServerSide.isTWAH()){
	chaplainRecord = StaffDB.getList(null, "CHAP", null, null, null, 2);	
} else {
	chaplainRecord =  StaffDB.getList(null,"660", null, null, null, 2,true);	
}


if(chaplainRecord.size() != 0 ){	
	for(int i =0;i<chaplainRecord.size();i++){
		ReportableListObject chaplain = (ReportableListObject)chaplainRecord.get(i);
	
%>
		<tr class="smallText" >
			<td name="<%=chaplain.getValue(2) %>_<%=i %>" style="text-align: center" ><%=chaplain.getValue(3)%></td>
			
			
			<%
if(wardRecord.size() != 0){
	for(int j =1;j<wardRecord.size();j++){
		ReportableListObject ward = (ReportableListObject)wardRecord.get(j);	
%>

		<td id = "<%=chaplain.getValue(2) %>_<%=ward.getValue(0) %>_<%=i %>" style="text-align: center" >
<%

boolean wardFound = checkSelected(ward.getValue(0),listOfChaplainWard,chaplain.getValue(2));

%>
				<input <%=(wardFound==true)?"CHECKED":""%> onclick="checkColor('<%=chaplain.getValue(2) %>_<%=ward.getValue(0) %>_<%=i %>')" area="wards" name="<%=chaplain.getValue(2) %>_<%=ward.getValue(0) %>_<%=i %>" type='checkbox' style='width:25px; height:25px;'/>
			</td>
<%
	}
}
%>
		</tr>
<%
		
	}
}
%>	
	
	
</table>
</div>

<div style="display:none" class="pageContent" id="page-languages">

<table cellpadding="0" class="contentFrameSearch" border="0" style="width:100%">
<%
ArrayList languageRecord = UtilDBWeb.getReportableList("SELECT MOTHCODE, MOTHDESC FROM MOTHERLANG@IWEB");
%>
	<tr>
	<th  style="font-size:12px;"></th>
<%
if(languageRecord.size() != 0){
	for(int j =1;j<languageRecord.size();j++){
		ReportableListObject language = (ReportableListObject)languageRecord.get(j);
%>
		<th style="font-size:12px;"><%=language.getValue(1)%></th>
<%
	}
}
%>
	</tr>
<%
if(chaplainRecord.size() != 0 ){	
	for(int i =0;i<chaplainRecord.size();i++){
		ReportableListObject chaplain = (ReportableListObject)chaplainRecord.get(i);	
%>
		<tr class="smallText" >
			<td name="<%=chaplain.getValue(2) %>_<%=i %>_L" style="text-align: center" ><%=chaplain.getValue(3)%></td>
			
			
			<%
if(languageRecord.size() != 0){
	for(int j =1;j<languageRecord.size();j++){
		ReportableListObject language = (ReportableListObject)languageRecord.get(j);	
%>

		<td id = "<%=chaplain.getValue(2) %>_<%=language.getValue(0) %>_<%=i %>_L" style="text-align: center" >
<%
boolean languageFound = checkSelected(language.getValue(0),listOfChaplainLanguage,chaplain.getValue(2));
%>
		
				<input <%=(languageFound==true)?"CHECKED":""%> onclick="checkColor('<%=chaplain.getValue(2) %>_<%=language.getValue(0) %>_<%=i %>_L')"  area="languages" name="<%=chaplain.getValue(2) %>_<%=language.getValue(0) %>_<%=i %>_L" type='checkbox' style='width:25px; height:25px;'/>
			</td>
<%
	}
}
%>
		</tr>
<%
		
	}
}
%>
	
	
	
</table>
</div>

<div style="display:none" class="pageContent" id="page-religions">
<table cellpadding="0" class="contentFrameSearch" border="0" style="width:100%">
	<%
ArrayList religionRecord = UtilDBWeb.getReportableList("SELECT RELCODE, RELDESC FROM RELIGIOUS@IWEB");
%>
	<tr>
		<th></th>
<%
if(religionRecord.size() != 0){
	for(int j =1;j<religionRecord.size();j++){
		ReportableListObject religion = (ReportableListObject)religionRecord.get(j);
%>
		<th><%=religion.getValue(1)%></th>
<%
	}
}
%>
	</tr>

<%
if(chaplainRecord.size() != 0 ){	
	for(int i =0;i<chaplainRecord.size();i++){
		ReportableListObject chaplain = (ReportableListObject)chaplainRecord.get(i);	
%>
		<tr class="smallText" >
			<td name="<%=chaplain.getValue(2) %>_<%=i %>_R" style="text-align: center" ><%=chaplain.getValue(3)%></td>
			
			
<%
if(religionRecord.size() != 0){
	for(int j =1;j<religionRecord.size();j++){
		ReportableListObject religion = (ReportableListObject)religionRecord.get(j);	
%>

		<td id = "<%=chaplain.getValue(2) %>_<%=religion.getValue(0) %>_<%=i %>_R" style="text-align: center" >
<%
boolean religionFound = checkSelected(religion.getValue(0),listOfChaplainReligion,chaplain.getValue(2));
%>
		
				<input <%=(religionFound==true)?"CHECKED":""%> onclick="checkColor('<%=chaplain.getValue(2) %>_<%=religion.getValue(0) %>_<%=i %>_R')"  area="religions" name="<%=chaplain.getValue(2) %>_<%=religion.getValue(0) %>_<%=i %>_R" type='checkbox' style='width:25px; height:25px;'/>
			</td>
<%
	}
}
%>
		</tr>
<%
		
	}
}
%>
</table>
</div>

<div style="display:none" class="pageContent" id="page-other">
    <table  cellpadding="0" class="contentFrameSearch" border="0" style="width:100%">
    <tr>
		<td style = "vertical-align:middle;"width="5%" class="infoLabel">
			Staff :								
		</td>								
		<td width="25%" class="infoData">
		<select name="chapStaffID" id="chapStaffID">
			<jsp:include page="../ui/staffIDCMB.jsp">
			<jsp:param value='<%=ConstantsServerSide.isHKAH()?"660":"CHAP" %>' name="deptCode"/>
					<jsp:param value="Y" name="showFT"/>
			<jsp:param value="Y" name="allowEmpty"/>
			<jsp:param value="" name="emptyLabel"/>
											</jsp:include>
									</select>	
		</td>
		
		<td style = "vertical-align:middle;"width="5%" class="infoLabel">
			Type :								
		</td>		
		<td width="10%" class="infoData">
		<select id="other_val" onchange="selectType()">
			<option value=""></option>
			<option value="patNo">Patient No.</option>
			<!-- <option value="doctor">Doctor</option>-->
			
		</select>
		</td>
		<td  class="infoData" id="other_content">
			
		</td>
		
		<td width="5%" style="text-align:right">
		<button type="button" onclick="insertIntoChap()" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Add</button>									 
			
		</td>
		
	</tr>
	
	<tr>
		<td colspan="5">
		<table>		
		<tr>
			<th></th>
			<th>Patient Number</th>
		</tr>
<%
if(chaplainRecord.size() != 0 ){	
	for(int i =0;i<chaplainRecord.size();i++){
		ReportableListObject chaplain = (ReportableListObject)chaplainRecord.get(i);	
%>
		<tr  style="text-align: center" class="smallText" >
			<td  style = "vertical-align:top;" type="patNo" name="<%=chaplain.getValue(2) %>_<%=i %>" style="text-align: center" ><%=chaplain.getValue(3)%></td>
			<td  id="other_patNo_<%=chaplain.getValue(2) %>"  class="infoData" >
<%
for(ChaplainDetailedValues c : listOfChaplainOther){
	if(c.chapID.equals(chaplain.getValue(2))){
		for(String s : c.patNo){
			%>
			<div style="font-size:16px" id="patNo_<%=chaplain.getValue(2) %>_<%=s %>" name="other_patNo_content" patno="<%=s %>" staffid="<%=chaplain.getValue(2)%>">
<img name="remove" id="img_patNo_<%=chaplain.getValue(2) %>_<%=s %>" src="../images/cross_red_small.gif">&nbsp;<%=s %>
<br>
</div>
			<%
		}
	}
}
%>
			</td>
		</tr>
<%		
	}
}
%>
		</table>
		</td>	
	</tr>
</table>
</div>

<table cellpadding="0" class="contentFrameSearch" border="0" style="width:100%">
	<tr>		
		<td align="center" colspan="19">
			<button type="button" onclick="submitAll()" style="font-size:22px;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Save</button>									 
			<button type="button" onclick="clearAllCheckBox()" style="font-size:22px;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Clear All</button>									 
	
		</td>
	</tr>

</table>

</DIV>
</DIV>
</DIV>

<script language="javascript">	
	var index;
	
	function checkIt(evt) {
	    evt = (evt) ? evt : window.event
	    var charCode = (evt.which) ? evt.which : evt.keyCode
	    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
	        status = "This field accepts numbers only."
	        return false
	    }
	    status = ""
	    return true
	}
	
	function insertIntoChap(){
		var type = $('#other_val').val();
		if(type == "patNo"){			
			var staffID = $('#chapStaffID').val();		
			var patNo = $('input[name=patNo]').val().replace(/\s/g, ""); 

			var divID = 'patNo_'+staffID+'_'+patNo;
			
			if($('input[name=patNo]').val().length > 0 && staffID.length > 0){
				if(checkIDExists(divID) == false ){			
				
					$('#other_patNo_'+staffID).append('<div style="font-size:16px" staffid='+staffID+' patNo='+patNo+' name="other_patNo_content" id = "'+divID+'"><img id ="img_'+divID+'" name="remove" src="../images/cross_red_small.gif"/>&nbsp;' + patNo + '<br></div>');
					assignImgFunction(divID);
					$('input[name=patNo]').val('');
				}else{
					alert('Patient number '+ $('input[name=patNo]').val() + ' already exists for '+$.trim($('#chapStaffID option:selected').text().split('(')[0]));
				}
			}
		}
	}
	
	function checkIDExists(divID){
	 if($("#" + divID).length == 0) {
		return false;
    } else {
	    return true;
	  }
	}
	
	function assignImgFunction(divID){	
		$("#img_"+divID).click(function() {		
			 var clear = confirm("Removes patient number "+$('div[id='+divID+']').attr('patNo')+"?");			 
			  if( clear == true ){	
				$('div[id='+divID+']').remove();
			  }
		});
	}
	
	function assignAllImgFunction(){
		$('img[name=remove]').each(function(i, v) {
			var myCars=$(this).attr('id').split('_')
			assignImgFunction(myCars[1]+'_'+myCars[2]+'_'+myCars[3]);
		});
	}
		
	
	function showPage(id){
		$('.pageContent').hide();
		$('#page-'+id).show();
		$('li').attr('class','');
		$('#list-'+id).attr('class', 'selected');
		index = id;
	}
	
	function setUpLoadPage(){
		$('#page-wards').show();
		$('li').attr('class','');
		$('#list-wards').attr('class', 'selected');
		index = 'wards';
	}
	
	function selectType(){
		$('#other_content').html('');
		var url = '';
		var doAjax = false;
		type = $('#other_val').val();
		if(type == 'patNo'){
			$('#other_content').html('');
			$('#other_content').append('<input  onKeyPress="return checkIt(event)" name="patNo" type="textfield" maxlength="30"  size="40" />');
		
		}
		if(type == 'doctor'){
			url = '../ui/docCodeCMB.jsp';
			doAjax = true;
		}
			
		if(doAjax == true){
			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values){
					$('#other_content').append("<select id='other_type'></select>")				
					$('#other_type').append(values);
									
				},
				error: function() {
					alert('error');
				}
			});
		}
	
		
	}

	function colorChapName(){
		$('table tbody tr').each(function() {
			
				var wardColor;
			   var id = $('td:first-child', this).attr('name');
			   if(typeof(id) !== 'undefined'){
			   var tempArray = new Array();
			  
				tempArray = id.split("_");
				
				if(tempArray[1] ==0){
					wardColor = 'zero';				
				}else if(tempArray[1] ==1){
					wardColor = 'one';
				}else if(tempArray[1] ==2){
					wardColor = 'two';
				}else if(tempArray[1] ==3){
					wardColor = 'three';
				}else if(tempArray[1] ==4){
					wardColor = 'four';
				}else if(tempArray[1] ==5){
					wardColor = 'five';
				}
			   
			   if(wardColor != null){
				   $('td[name='+id+']').attr('class',wardColor);
			   }
			   }
			});

	}
	
	function submitAll(){		
		submit(index);
	}
	
	function submit(type){	
		
			var parameters='';	
			if(type =='other'){
				$('td[type=patNo]').each(function(i, v) {
					var staffID = $(this).attr("name").split('_')[0];
					parameters = parameters + '&' + staffID + '=';		
				});
				$('div[name=other_patNo_content]').each(function(i, v) {
					var staffID = $(this).attr("staffid");
					var patNo = $(this).attr("patNo");
					var subType = "patNo";
					
					parameters = parameters + '&' + staffID + '='+ subType + "-" + patNo;		
				});
			}else{
				$('input[area='+type+']').each(function(i, v) {			
					var tempArray = new Array();
					tempArray = $(this).attr('name').split("_");
					if($(this).is(':checked') == true){			
						parameters = parameters + '&' + tempArray[0] + '='+ tempArray[1];		
					}else{
						parameters = parameters + '&' + tempArray[0] + '=';
					}
					j++;
				});
			}
			
			var action = 'action='+type;
			var baseUrl ='../chaplaincy/submitChapArea.jsp?';	
			var url = baseUrl ;	
		
			$.ajax({			
				url: url,
				type: 'POST',
				data: action+parameters,
				async: true,
				cache:false,
				success: function(values){				
					if(values.indexOf('false') > -1){
						alert("Error occured while saving chaplain's "+type+".")
					}else {					
						alert("Chaplain's "+type+" saved successfully.")
					}
				},
				error: function() {
					alert('error');
				}
			});
		
	}
	
	function clearAllCheckBox(){	
			clearCheckBox(index);
	
	}
	
	function clearCheckBox(type){
		if(type == "other"){
			 var clear = confirm("Clear all cells?");
			 if( clear == true ){	
				$('div[name=other_patNo_content]').remove();	
		    }
		}else{
		 var clear = confirm("Clear all "+type+" checkboxes?");
		   if( clear == true ){	
			$('input[area='+type+']').each(function(i, v) {
				$(this).attr('checked', false);
			});
			checkAllColor();	
		   }
		}
	}
	
	function checkColor(id) {
		var selected = $('input[name='+id+']').is(':checked');
		
		if(selected == true){		
			
			var color;
			var tempArray = new Array();
			tempArray = id.split("_");
			
			if(tempArray[2] ==0){
				color = 'zero';				
			}else if(tempArray[2] ==1){
				color = 'one';
			}else if(tempArray[2] ==2){
				color = 'two';
			}else if(tempArray[2] ==3){
				color = 'three';
			}else if(tempArray[2] ==4){
				color = 'four';
			}else if(tempArray[2] ==5){
				color = 'five';
			}
			
			
			$('#'+ id).attr('class', color);
			
		}else{
			$('#'+ id).attr('class', 'infoData');
			
		}
		
	}
	
	function checkAllColor() {
		
		$('input[type=checkbox]').each(function(i, v) {
			 checkColor($(this).attr('name')) 
		});
	}
		
	$(document).ready(function() {	
		colorChapName();
		checkAllColor();
		setUpLoadPage();
		assignAllImgFunction();
		$('select#other_val :nth-child(1)').attr('selected', 'selected');
		$('select#chapStaffID :nth-child(1)').attr('selected', 'selected');
	});	
		
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>


