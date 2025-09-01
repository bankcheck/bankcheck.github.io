<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="org.displaytag.decorator.*"%>
<%@ page import="org.displaytag.exception.DecoratorException"%>
<%@ page import="org.displaytag.properties.MediaTypeEnum"%>
<%
UserBean userBean = new UserBean(request);
int noOfCol = 4;//no of column in list
String reqNo = request.getParameter("reqNo");
String reqStatus = request.getParameter("reqStatus");
String amtID = request.getParameter("amtID");

ArrayList al_miscItem = FsDB.getMiscItemDtl(reqNo);
request.setAttribute("FS",al_miscItem);
int fsSize = al_miscItem.size();
String appGrp = request.getParameter("appGrp");

if(fsSize>0){
	String lsItemSupplier = null;
	String lsItemDesc = null;
	for(int i=0;i<fsSize;i++) {
			ReportableListObject row = (ReportableListObject) al_miscItem.get(i);
			lsItemSupplier = row.getValue(2);			
			row.setValue(2,lsItemSupplier.replaceAll("\"", "&quot;"));			
			lsItemDesc = row.getValue(3);		
			row.setValue(3,lsItemDesc.replaceAll("\"", "&quot;"));				
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<!-- 
<script type="text/javascript" src="<html:rewrite page="/js/jquery-1.2.6.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.meio.mask.js"/>" charset="utf-8" ></script>
 -->
<body>
<bean:define id="functionLabel"><bean:message key="function.epo.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<input type="checkbox" id="Handler"  onclick="javascript:invertSelected()"/>Select All&nbsp;
<%if(fsSize==0) { %>

<%} else { %>		     
<display:table pagesize="" requestURI="" class="tablesorter" name="FS" sort="page" id="resList">
	<display:column title="" style="width:2%;" >	   	 	
		<input onclick="onCheckRows(this,<%=noOfCol  %>);" type="checkbox" name="checkEdit" value="${FS[resList_rowNum - 1].fields1}"/>												
	</display:column>	   
	<display:column style="width:1%">
		<div></div>
		<div style="display:none;">
			<input type="hidden" name="itemNo[${resList_rowNum - 1}].fields1"  
			value="${FS[resList_rowNum - 1].fields1}" size="2" maxlength="2"/>					           											
        </div>
    </display:column>    				           	
    <display:column title="Item Desc" style="width:20%;">
		<div>${FS[resList_rowNum - 1].fields2}</div>
		<div style="display:none;">											
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name="itemDesc[${resList_rowNum - 1}].fields2"  
			value="${FS[resList_rowNum - 1].fields2}" size="40" maxlength="100"/>
		</div>
	</display:column>
	<display:column title="QTY" style="width:8%;">	
		<div>${FS[resList_rowNum - 1].fields3}</div>
		<div style="display:none;">		
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name="itemQty[${resList_rowNum - 1}].fields3"
			value="${FS[resList_rowNum - 1].fields3}"  size="5" maxlength="5"/>					           											           	
        </div>
    </display:column>	
	<display:column title="Unit" style="width:8%;">	
		<div>${FS[resList_rowNum - 1].fields4}</div>
		<div style="display:none;">		
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name="itemUnit[${resList_rowNum - 1}].fields4" 
			value="${FS[resList_rowNum - 1].fields4}" size="10" maxlength="50"/>					           											           	
        </div>
    </display:column>   	       	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>	           					            
	</display:table>
<%} %>
	<input type="hidden" name="lstRowIdx"/>
</body>
</html:html>
<script type="text/javascript">
var totalAmtCnt = 0;
var col = 8;
var assumeMaxRow = 100;
var lstIdx = 0;

function cUpper(inputObj) 
{
	inputObj.value = inputObj.value.toUpperCase();
}

function performChange(inputObj, index){	
	var count = 0;	
	if(inputObj.parentNode.parentNode.childNodes[count].nodeName=="#text")
	count++;

	var objName = inputObj.name;
	var objValue = inputObj.value;
	
	switch (objName){
	case "itemQty["+index+"].fields4":
		if(objValue==null||objValue==''){
			alert('Please enter valid Quality');
			inputObj.value=0;			
			inputObj.focus();
			inputObj.select();				
		}else{
			if(isNaN(objValue)){
				alert('Please enter valid Quality');
				inputObj.value=0;				
				inputObj.focus();
				inputObj.select();						
			}else if(objValue=='0'){
				alert('No zero Quantity allow!');			
				inputObj.focus();
				inputObj.select();				
			}else {
				var qty = objValue;								
			};
		};		
		break;															
	}
	return false;
//	inputObj.parentNode.parentNode.childNodes[count].innerHTML=objValue;	
}

function onCheckRows(checkBoxObj,noOfCol){		
	var rowObj = checkBoxObj.parentNode.parentNode;
	if(checkBoxObj.checked==true){		
		rowCheck(rowObj,"edit",noOfCol);
	}else{						
		rowCheck(rowObj,"view",noOfCol);
	};		 
}

function rowCheck(rowObj,value,noOfCol){		
	var j = 0;
	var count = 1;
alert('[noOfCol]:'+noOfCol);
	for(var i = 1 ; i<=noOfCol; i++){
		
		if(rowObj.cells[i].childNodes[j].nodeName=="#text"){		 
			j++;			
			count++; 
		}
		if(value=="edit"){
			alert('[value]:'+value+';[name]:'+rowObj.cells[i].childNodes[j].name);
			rowObj.cells[i].childNodes[j].style.display = "none";
			rowObj.cells[i].childNodes[j+count].style.display = "";
		}else{
			rowObj.cells[i].childNodes[j].style.display = "";
			rowObj.cells[i].childNodes[j+count].style.display = "none";
		};
	};
}

var preNum=new Array();	
var i=0;

function checkRowCnt(){
	var rowTotal = null;
	for(var k = 0 ; k<=assumeMaxRow; k++){
		if(document.getElementsByName("itemAmountHid["+k+"]")[0]) {
//			rowTotal = document.getElementsByName("itemAmountHid["+k+"]")[0].value;	
//			alert(k+'[itemAmount]'+rowTotal);
	 		var lstRowIdx = k;
		};			 				
	}
	return lstRowIdx;
}

function invertSelected(){ 	
	var handleEl = document.getElementById("Handler"); 
	var els = document.getElementsByName("checkEdit"); 
	for(i=0;i<els.length;i++){ 
	els[i].checked=handleEl.checked; 
		onCheckRows(els[i]);		 							
	};
}

var newRecordCnt = 0;

function createElementFromHTML(tagname,html) {
  var temp = document.createElement(tagname);
  temp.innerHTML = html;
  return temp.childNodes[0];
}
	
function trim(stringToTrim) {
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}
</script>