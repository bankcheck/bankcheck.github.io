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
int noOfCol = 8;//no of column in list
String haID = request.getParameter("haID");
String reqStatus = request.getParameter("reqStatus");
String amtID = request.getParameter("amtID");
ArrayList al_epo = EPORequestDB.getRequestDtl(haID);
request.setAttribute("EPO",al_epo);
int epoSize = al_epo.size();

if(epoSize>0){
	String lsItemSupplier = null;
	String lsItemDesc = null;
	for(int i=0;i<epoSize;i++) {
			ReportableListObject row = (ReportableListObject) al_epo.get(i);
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

<%--
<input type="checkbox" id="Handler"  onclick="javascript:invertSelected()"/>Select All&nbsp;
 --%>
 <%--
<%if("S".equals(reqStatus)||"H".equals(reqStatus)){ %>
	<select name="amountID" id="amountID">
	<%amtID = amtID == null ? "" : amtID; %>	
	<jsp:include page="../ui/approvalAmountCMB.jsp" flush="false">
		<jsp:param name="amountID" value="<%=amtID %>" />			
	</jsp:include>
	</select>
<%}else{ %>
	<select name="amountID" id="amountID" disabled="disabled">
	<%amtID = amtID == null ? "" : amtID; %>	
	<jsp:include page="../ui/approvalAmountCMB.jsp" flush="false">
		<jsp:param name="amountID" value="<%=amtID %>" />			
	</jsp:include>
	</select>
<%} %>
--%>
<%if(epoSize==0) { %>
<table id="resList" class="tablesorter">
<thead>
<tr>
<th></th>
<th></th>
<%--
<th class="sortable">Supplier Name</th>
<th class="sortable">Item Desc</th>
<th class="sortable">Unit</th>
<th class="sortable">Unit Price</th>
<th class="sortable">QTY</th>
<th class="sortable">Amount</th>
 --%>
<th>Description</th>
<th>Status</th>
<th>Delete</th>
<th></th></tr></thead>
<tbody>
<tr class="odd">
<td style="width:2%;">	   	 	
	<input onclick="onCheckRows(this,7);" type="checkbox" value ="1" name="checkEdit" checked="checked"/>												
</td>
<td style="width:1%">
	<div></div>
	<div style="display:none;">
		<input type="hidden" name="itemSeq[0].fields1"  
		value="" size="2" maxlength="2"/>	
	</div>
</td>
<td style="width:20%;">	
	<div></div>
	<div style="display:"";">		
		<input onchange="performChange(this, '0')" type="text" name="itemSupp[0].fields2"  
		value="" size="40" maxlength="100"/>					           											           	
	</div>
</td>
<td style="width:50%;">	
	<div></div>
	<div style="display:"";">
		<input type="radio" name="mn_p68" value="0" <%if ("0".equals("")) {%>checked<%} %>>&nbsp;Achieved 達到					           											           	
		<input type="radio" name="mn_p68" value="1" <%if ("1".equals("")) {%>checked<%} %>>&nbsp;Not achieved 未達到
		<input type="radio" name="mn_p68" value="2" <%if ("2".equals("")) {%>checked<%} %>>&nbsp;N/A不適用
	</div>
</td>
<td style="width:20%">
		<div><a href="javascript:deleteRow(1);"><img src="../images/delete1.png"/></a></div>
</td>
<td style="width:1%; ">	
	<div>			
		<input onchange="performChange(this, '0')" type="hidden" name="itemAmountHid[0]" value="0"/>
	</div>
</td>
</tr>
</tbody>
</table>
<%} else { %>		     
<display:table pagesize="" requestURI="" class="tablesorter" name="EPO" sort="page" id="resList">
	<display:column title="" style="width:2%;" >	   	 	
		<input onclick="onCheckRows(this,<%=noOfCol  %>);" type="checkbox" name="checkEdit" value="${EPO[resList_rowNum - 1].fields1}"/>												
	</display:column>	   
	<display:column style="width:1%">
		<div></div>
		<div style="display:none;">
			<input type="hidden" name="itemSeq[${resList_rowNum - 1}].fields1"  
			value="${EPO[resList_rowNum - 1].fields1}" size="2" maxlength="2"/>					           											
        </div>
    </display:column>
	<display:column style="width:20%;" title="Supplier Name">	
		<div>${EPO[resList_rowNum - 1].fields2}</div>
		<div style="display:none;">		
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name="itemSupp[${resList_rowNum - 1}].fields2"  
			value="${EPO[resList_rowNum - 1].fields2}" size="40" maxlength="100"/>					           											           	
        </div>
    </display:column>
	<display:column title="Delete" style="width:5%">
		<div><a href="javascript:deleteRow(${EPO[resList_rowNum - 1].fields1});"><img src="../images/delete1.png"/></a></div>
		<div style="display:none;"><a href="javascript:deleteRow(${EPO[resList_rowNum - 1].fields1});"><img src="../images/delete1.png"/></a></div>		
	</display:column>	
	<display:column title="" style="width:1%">
		<div>		
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="hidden" name="itemAmountHid[${resList_rowNum - 1}]"
			value="${EPO[resList_rowNum - 1].fields5}"/>					           											           	
       	</div>
	</display:column>	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>	           					            
	</display:table>
<%} %>	 
	<input type="button" value="add" onclick="javascript:addRow(<%=noOfCol %>)"/>
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
			document.getElementsByName("itemAmount["+index+"].fields5")[0].value = 0;
			document.getElementsByName("itemAmountHid["+index+"]")[0].value = 0;			
			inputObj.focus();
			inputObj.select();				
		}else{
			if(isNaN(objValue)){
				alert('Please enter valid Quality');
				inputObj.value=0;
				document.getElementsByName("itemAmount["+index+"].fields5")[0].value = 0;
				document.getElementsByName("itemAmountHid["+index+"]")[0].value = 0;				
				inputObj.focus();
				inputObj.select();						
			}else if(objValue=='0'){
				alert('No zero Quantity allow!');
				document.getElementsByName("itemAmount["+index+"].fields5")[0].value = 0;
				document.getElementsByName("itemAmountHid["+index+"]")[0].value = 0;				
				inputObj.focus();
				inputObj.select();				
			}else {
				var qty = objValue;				
				var price = document.getElementsByName("itemPrice["+index+"].fields6")[0].value;		
				var amount = qty * price;
				document.getElementsByName("itemAmount["+index+"].fields5")[0].value = amount;
				document.getElementsByName("itemAmountHid["+index+"]")[0].value = amount;				
			}
		}
		addTotalAmount(col,0);		
		break;
	case "itemPrice["+index+"].fields6":
		if(objValue==null||objValue==''){
			alert('Please enter valid Price');
			inputObj.value=0;
			document.getElementsByName("itemAmount["+index+"].fields5")[0].value = 0;
			document.getElementsByName("itemAmountHid["+index+"]")[0].value = 0;			
			inputObj.focus();
			inputObj.select();				
		}else{ 
			if(isNaN(objValue)){
				alert('Please enter valid Price');			
				inputObj.value=0;
				document.getElementsByName("itemAmount["+index+"].fields5")[0].value = 0;
				document.getElementsByName("itemAmountHid["+index+"]")[0].value = 0;				
				inputObj.focus();
				inputObj.select();		
			}else{
				var qty = document.getElementsByName("itemQty["+index+"].fields4")[0].value;
				var price = objValue;						
				var amount = qty * price;				
				document.getElementsByName("itemAmount["+index+"].fields5")[0].value = amount;
				document.getElementsByName("itemAmountHid["+index+"]")[0].value = amount;				
				document.getElementsByName("itemQty["+index+"].fields4")[0].focus();
				document.getElementsByName("itemQty["+index+"].fields4")[0].select();
			}
		}
		addTotalAmount(col,0);		
		break;
	case "itemSupp["+index+"].fields2":
		if(objValue.length>100){
			alert('Supplier name too long');			
			document.getElementsByName("itemSupp["+index+"].fields2")[0].focus();
			document.getElementsByName("itemSupp["+index+"].fields2")[0].select();			
		}else{
			var as_itemSupp = objValue.toUpperCase();
			inputObj.value = as_itemSupp;
		}

		break;
	case "itemDesc["+index+"].fields3":	
		var quoteFound = objValue.search("'");
		if(quoteFound>=0) {
			alert('Item description does not allow single quote');
			document.getElementsByName("itemDesc["+index+"].fields3")[0].focus();
			document.getElementsByName("itemDesc["+index+"].fields3")[0].select();			
		}
		
		if(objValue.length>100){
			alert('Item description too long');
			document.getElementsByName("itemDesc["+index+"].fields3")[0].focus();
			document.getElementsByName("itemDesc["+index+"].fields3")[0].select();			
		}
				
		break;		
	case "itemUnit["+index+"].fields7":
		var as_itemUnit = objValue.toUpperCase();
		inputObj.value = as_itemUnit;
		break;																
	}
	return false;
//	inputObj.parentNode.parentNode.childNodes[count].innerHTML=objValue;	
}

function checkRowValue(){
	var amountID = document.getElementById("amountID").value;		
	for(var i = 0 ; i<=assumeMaxRow; i++){
/*		
		if(document.getElementsByName("itemSupp["+i+"].fields2")[0]) { 
			var rowSupp = document.getElementsByName("itemSupp["+i+"].fields2")[0].value;
			if(rowSupp==''){
				alert('Please enter supplier name');				
				document.getElementsByName("itemSupp["+i+"].fields2")[0].focus();
				document.getElementsByName("itemSupp["+i+"].fields2")[0].select();
				return false;				
			}
		}
*/
		if(document.getElementsByName("itemDesc["+i+"].fields3")[0]) { 
			var rowDesc = document.getElementsByName("itemDesc["+i+"].fields3")[0].value;
			if(rowDesc==''){
				alert('Please enter item description');				
				document.getElementsByName("itemDesc["+i+"].fields3")[0].focus();
				document.getElementsByName("itemDesc["+i+"].fields3")[0].select();
				return false;				
			}				
		}
		if(document.getElementsByName("itemUnit["+i+"].fields7")[0]) { 
			var rowUnit = document.getElementsByName("itemUnit["+i+"].fields7")[0].value;
			if(rowUnit==''){
				alert('Please enter item unit');				
				document.getElementsByName("itemUnit["+i+"].fields7")[0].focus();
				document.getElementsByName("itemUnit["+i+"].fields7")[0].select();
				return false;				
			}						
		}
		if(document.getElementsByName("itemPrice["+i+"].fields6")[0]) { 
			var rowPrice = document.getElementsByName("itemPrice["+i+"].fields6")[0].value;
			if(rowPrice==''){
				alert('Please enter item price');				
				document.getElementsByName("itemPrice["+i+"].fields6")[0].focus();
				document.getElementsByName("itemPrice["+i+"].fields6")[0].select();
				return false;				
			}else if(rowPrice==0){
				alert('Item price cannot 0, please enter estimated price');				
				document.getElementsByName("itemPrice["+i+"].fields6")[0].focus();
				document.getElementsByName("itemPrice["+i+"].fields6")[0].select();
				return false;
			}				
		}		
		if(document.getElementsByName("itemQty["+i+"].fields4")[0]) { 
			var rowQty = document.getElementsByName("itemQty["+i+"].fields4")[0].value;

			if(rowQty==''){
				alert('Please enter item QTY');				
				document.getElementsByName("itemQty["+i+"].fields4")[0].value = 0;				
				document.getElementsByName("itemQty["+i+"].fields4")[0].focus();
				document.getElementsByName("itemQty["+i+"].fields4")[0].select();
				return false;								
			}else if(rowQty=='0'){
				alert('Please enter item QTY');				
				document.getElementsByName("itemQty["+i+"].fields4")[0].focus();
				document.getElementsByName("itemQty["+i+"].fields4")[0].select();
				return false;				
			}						
		}		
	}
	return true;
}

function addTotalAmount2(col,del){
	var list = document.getElementById('resList');
	var rowCount=list.rows.length;
	var rowAmount = 0;
	var totalAmt = 0;
	var newRowIndex = 0;
	var deleteRowIndex = 0;
	
	for(var i = 0 ; i<=assumeMaxRow; i++){
		if(document.getElementsByName("itemAmountHid["+i+"]")[0]) { 
			rowAmount = document.getElementsByName("itemAmountHid["+i+"]")[0].value;						
	 		totalAmt = parseFloat(totalAmt) + parseFloat(rowAmount);	 		
			newRowIndex = i + 1;
			deleteRowIndex = i + 2;			
		}
		if(del==0&&document.getElementsByName("itemTotalAmount["+ i +"].fields5")[0]){
			lastRowIndex = i;	
		}				 				 				
	}

	if(del==0){	
		document.getElementsByName("itemTotalAmount["+ lastRowIndex +"].fields5")[0].value = totalAmt;
		if(totalAmt>0){
			getTotalAmount(totalAmt);
		}
	} else if (del==1) {				
		if(list==null){
			alert("list==null");
		}
		var tableRowTmp = list.insertRow(-1);
			
		addRowStyle(tableRowTmp);	
		var newRowTmp = tableRowTmp.insertCell(-1);		
		var objString = 'DIV';
		var obj = null;
		var tagname = null;

		// fails in IE > 8 and other browsers
		try {	
			obj = document.createElement(objString);				
		} catch (err) {
			tagname = 'DIV';
			obj = createElementFromHTML(tagname,objString);	
		}		
		
		newRowTmp.appendChild(obj);
		tableRowTmp.appendChild(newRowTmp);		
	//		var size5 = new Array(1,20,15);		
		for(i = 0; i < col+1; i++){ 
			newRowTmp = tableRowTmp.insertCell(-1);
			//first div for display
			objString = '<div style="display:none;"></div>';
			// fails in IE > 8 and other browsers
			try {	
				obj = document.createElement(objString);			
			} catch (err) {
				tagname = 'DIV';
				obj = createElementFromHTML(tagname,objString)
			}			
				
			if(i==1||i==col){ 
				obj.innerHTML='';		
			}
			newRowTmp.appendChild(obj);						
			objString = '<div></div>';			
			// fails in IE > 8 and other browsers
			try {	
				obj = document.createElement(objString);			
			} catch (err) {
				tagname = 'DIV';
				obj = createElementFromHTML(tagname,objString)
			}
			if(i==0){
				objString = 'DIV';
				inputObj = document.createElement(objString);
				obj.appendChild(inputObj);
			} else if(i==1){
				objString = 'DIV';				
				inputObj = document.createElement(objString);				
				obj.appendChild(inputObj);
			} else if(i==2){			
				objString = 'DIV';
				inputObj = document.createElement(objString);
				obj.appendChild(inputObj);
			} else if(i==3){
				objString = 'DIV';
				inputObj = document.createElement(objString);
				obj.appendChild(inputObj);
			} else if(i==4){			
				objString = 'DIV';
				inputObj = document.createElement(objString);
				obj.appendChild(inputObj);
			} else if(i==5){
				objString = 'DIV';
				inputObj = document.createElement(objString);			
				obj.appendChild(inputObj);
			} else if(i==6){
				objString = "<input onchange='performChange(this, "+ newRowIndex +")"
				+ "' type='text' name='itemTotalAmount[" + newRowIndex + "].fields5"					
				+ "' value='"+totalAmt+"' size='10' maxlength='10' disabled='disabled'/>";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				
				obj.appendChild(inputObj);				
			} else if(i==7){ 
				objString = "<a href='javascript:deleteRow(" + deleteRowIndex + ");'" +	"></a>";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'A';
					inputObj = createElementFromHTML(tagname,objString)
				}				
								
				inputObj.innerHTML="";
				obj.appendChild(inputObj);
			} else if(i==8){
				objString = 'DIV';
				inputObj = document.createElement(objString);			
				obj.appendChild(inputObj);
			} 
			newRowTmp.appendChild(obj);
			tableRowTmp.appendChild(newRowTmp);
		}
	
		newRecordCnt++;
		lstIdx = newRowIndex;
		totalAmtCnt++;			
	}	
}

<%if(epoSize>=0) { %>
	addTotalAmount(col,1);
<%}%>

function onCheckRows(checkBoxObj,noOfCol){		
	var rowObj = checkBoxObj.parentNode.parentNode;
	if(checkBoxObj.checked==true){		
		rowCheck(rowObj,"edit",noOfCol);
	}else{						
		rowCheck(rowObj,"view",noOfCol);
	}		 
}

function rowCheck(rowObj,value,noOfCol){		
	var j = 0;
	var count = 1;

	for(var i = 1 ; i<=noOfCol; i++){			
		if(rowObj.cells[i].childNodes[j].nodeName=="#text"){		 
			j++;			
			count++; 
		}
		if(value=="edit"){
			rowObj.cells[i].childNodes[j].style.display = "none";
			rowObj.cells[i].childNodes[j+count].style.display = "";
		}else{
			rowObj.cells[i].childNodes[j].style.display = "";
			rowObj.cells[i].childNodes[j+count].style.display = "none";
		}
	}
}

var preNum=new Array();	
var i=0;
function deleteRow(num){
	var count=0;
	var list = document.getElementById('resList');
	var rowCount = list.rows.length;
	var lastRowIndex = rowCount - 1;
	var noOfExistRow = 0;
	var actualRowNo = 0;

	for(var k = 0 ; k<=assumeMaxRow; k++){
		if(document.getElementsByName("itemAmountHid["+k+"]")[0]) {
	 		noOfExistRow++;
	 		if((k+1)==num){actualRowNo=noOfExistRow;}	 		
		}			 				
	}
		
	document.getElementById('resList').deleteRow(actualRowNo);
	if(noOfExistRow==1){			
		addRow(col);
	}				 
	if(deleteTotal()){
		addTotalAmount(col,1);
	}				

/*	
	if(i==0){		
		document.getElementById('resList').deleteRow(num);
		alert('[actualRowNo]'+actualRowNo+';[num]:'+(num));				 
		preNum[i++]=num;	  	 	  
		count++;
		if(totalAmtCnt>0){
			if(deleteTotal()){
				addTotalAmount(col,1);
			}				
		}		
	}else{
	 	for(var j=0;j<i;j++){  
	   		if(preNum[j]<num){	   
	   			count++; 			
	   		} 		
		}
		document.getElementById('resList').deleteRow(num-count);
		alert('[actualRowNo]'+actualRowNo+';[num-count]:'+(num-count));			
		if((num-count)==1){
// reset count when delete the last row			
			preNum = [];
			i = 0;
			newRecordCnt = 0;
		}
		if(noOfExistRow==1){
			addRow(col);
		}else{
			if(totalAmtCnt>0&&deleteTotal()){			
				addTotalAmount(col,1);
			}
		 	preNum[i++]=num;			
		}
	 }
*/
}

function checkRowCnt(){
	var rowTotal = null;
	for(var k = 0 ; k<=assumeMaxRow; k++){
		if(document.getElementsByName("itemAmountHid["+k+"]")[0]) {
//			rowTotal = document.getElementsByName("itemAmountHid["+k+"]")[0].value;	
//			alert(k+'[itemAmount]'+rowTotal);
	 		var lstRowIdx = k;
		}			 				
	}
	return lstRowIdx;
}

function deleteTotal(){
	var count=0;
	var list = document.getElementById('resList');
	var rowCount = list.rows.length;
	var lastRowIndex = rowCount - 1;
		
	if(totalAmtCnt>0){			
		document.getElementById('resList').deleteRow(lastRowIndex);
	 	return true;
	}		
}	

function invertSelected(){ 	
	var handleEl = document.getElementById("Handler"); 
	var els = document.getElementsByName("checkEdit"); 
	for(i=0;i<els.length;i++){ 
	els[i].checked=handleEl.checked; 
		onCheckRows(els[i]);		 							
	}
}

var newRecordCnt = 0;

function createElementFromHTML(tagname,html) {
  var temp = document.createElement(tagname);
  temp.innerHTML = html;
  return temp.childNodes[0];
}

function addRow(col){
	if (totalAmtCnt==0){
//				alert('abc');
// without total amount					
		var tabel=document.getElementById('resList');
		var rowCount=tabel.rows.length;
		var newRowIndex = rowCount - 1;
		
		if(tabel==null){
			alert("tabel==null");
		}
		var tableRowTmp = tabel.insertRow(-1);
			
		addRowStyle(tableRowTmp);	
		var newRowTmp = tableRowTmp.insertCell(-1);		
		var objString = '<input name="checkEdit" onclick="onCheckRows(this,'+col+');" type="checkbox" checked="true">';
		var obj = null;
		var tagname = null;				
		
		// fails in IE > 8 and other browsers
		try {	
			obj = document.createElement(objString);			
			newRowTmp.appendChild(obj);	
		} catch (err) {
			tagname = 'INPUT';
			obj = createElementFromHTML(tagname,objString);	
		}
		newRowTmp.appendChild(obj);
		tableRowTmp.appendChild(newRowTmp);		
		
		for(i = 0; i < col+1; i++){ 
			newRowTmp = tableRowTmp.insertCell(-1);
			//first div for display
			objString = '<div style="display:none;"></div>';			
			// fails in IE > 8 and other browsers
			try {	
				obj = document.createElement(objString);			
			} catch (err) {
				tagname = 'DIV';
				obj = createElementFromHTML(tagname,objString)
			}

			if(i==1||i==col){ 
				obj.innerHTML='';		
			}
			newRowTmp.appendChild(obj);						
			objString = '<div></div>';			
			// fails in IE > 8 and other browsers
			try {	
				obj = document.createElement(objString);			
			} catch (err) {
				tagname = 'DIV';
				obj = createElementFromHTML(tagname,objString);
			}
			
			if(i==0){
				inputObj = document.createElement('DIV');
				obj.appendChild(inputObj);
			} else if(i==1){
				// fails in IE > 8 and other browsers
				try {	
					if (newRecordCnt=0||prvSupplier==null||prvSupplier==''){
						objString = "<input onchange='performChange(this, "+ newRowIndex +")"
						+ "' type='text' name='itemSupp[" + newRowIndex + "].fields2"					
						+ "' value=\"\" size='40' maxlength='100' />";				
					}
					inputObj = document.createElement(objString);
					obj.appendChild(inputObj);			
				} catch (err) {
					if (newRecordCnt=0||prvSupplier==null||prvSupplier==''){
						objString = "<input onchange='performChange(this, "+ newRowIndex +")"
						+ "' type='text' name='itemSupp[" + newRowIndex + "].fields2"					
						+ "' value=\"\" size='40' maxlength='100' />";	
						tagname = 'INPUT';						
					}
					inputObj = createElementFromHTML(tagname,objString);
					obj.appendChild(inputObj);
				}
			} else if(i==2){			
				objString = "<input onchange='performChange(this, "+ newRowIndex +")"
				+ "' type='radio' name='itemDesc[" + newRowIndex + "].fields3"					
				+ "' value=\"\" size='40' maxlength='100' />";
				
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				
				obj.appendChild(inputObj);
			} else if(i==3){
			} else if(i==4){			
			} else if(i==5){
			} else if(i==6){
			} else if(i==7){ 
				objString = "<a href='javascript:deleteRow(" + rowCount + ");'" +	"></a>";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'A';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				
	       		inputObj.innerHTML='<img src="../images/delete1.png">';	       		
				obj.appendChild(inputObj);
			} else if(i==8){
				objString = "<input onchange='performChange(this, "+ newRowIndex +")"
				+ "' type='hidden' name='itemAmountHid[" + newRowIndex + "]"					
				+ "' value='0' />";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				
				obj.appendChild(inputObj);				
			}				

			newRowTmp.appendChild(obj);
			tableRowTmp.appendChild(newRowTmp);
		}			
	
		newRecordCnt++;			
		addTotalAmount(col,1);					
	} else {
// with total amount	
		var tabel = document.getElementById('resList');
		var preRowCount = tabel.rows.length;
		var aftDelTolRowCnt = 0;
		var newRowIndex = 0;
		var newDelIndex = 1;
		var prvRowIndex = 0;
		
		if(deleteTotal()){
			tabel = document.getElementById('resList');			
//			aftDelTolRowCnt = tabel.rows.length;

			for(var i = 0 ; i<=assumeMaxRow; i++){
				if(document.getElementsByName("itemAmountHid["+i+"]")[0]) {
					prvRowIndex = i;
					newRowIndex = i + 1;
					newDelIndex = i + 2;
				}			 				 				
			}		
		}
		
		if(tabel==null){
			alert("tabel==null");
		}
		
		var tableRowTmp = tabel.insertRow(-1);
			
		addRowStyle(tableRowTmp);	
		var newRowTmp = tableRowTmp.insertCell(-1);		
		var objString = '<input name="checkEdit" onclick="onCheckRows(this,'+col+');" type="checkbox" checked="true">';
//		var obj = document.createElement(objString);
//		newRowTmp.appendChild(obj);
//		tableRowTmp.appendChild(newRowTmp);

		var obj = null;
		var tagname = null;				
		
		// fails in IE > 8 and other browsers
		try {	
			obj = document.createElement(objString);			
			newRowTmp.appendChild(obj);	
		} catch (err) {
			tagname = 'INPUT';
			obj = createElementFromHTML(tagname,objString);	
		}
		newRowTmp.appendChild(obj)
		tableRowTmp.appendChild(newRowTmp);	

		
//			var size5 = new Array(1,20,15);		
		for(i = 0; i < col+1; i++){ 
			newRowTmp = tableRowTmp.insertCell(-1);
			//first div for display
			objString = '<div style="display:none;"></div>';
			// fails in IE > 8 and other browsers
			try {	
				obj = document.createElement(objString);			
			} catch (err) {
				tagname = 'DIV';
				obj = createElementFromHTML(tagname,objString)
			}
			
				
			if(i==1||i==col){ 
				obj.innerHTML='';
			}
			newRowTmp.appendChild(obj);
			objString = '<div></div>';									
						
			// fails in IE > 8 and other browsers
			try {	
				obj = document.createElement(objString);			
			} catch (err) {
				tagname = 'DIV';
				obj = createElementFromHTML(tagname,objString)
			}

			if(i==0){
				objString = "<input type='hidden' name='itemSeq[" + newRowIndex + "].fields1"					
				+ "' value='' size='2' maxlength='2' />";
				
				// fails in IE > 8 and other browsers				
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				obj.appendChild(inputObj);
				
			} else if(i==1){
				if(prvRowIndex>=0){
					if(document.getElementsByName("itemSupp[" + prvRowIndex + "].fields2")[0]){											
						var prvSupplier = document.getElementsByName("itemSupp[" + prvRowIndex + "].fields2")[0].value;
						prvSupplier = prvSupplier.replace(/\"/g, '&quot;');																				
					}				
				}
				if (newRecordCnt=0||prvSupplier==null||prvSupplier==''){
					objString = "<input onchange='performChange(this, "+ newRowIndex +")"
					+ "' type='text' name='itemSupp[" + newRowIndex + "].fields2"					
					+ "' value=\"\" size='40' maxlength='100' />";				
				} else {
					objString = "<input onchange='performChange(this, "+ newRowIndex +")"
					+ "' type=\"text\" name='itemSupp[" + newRowIndex + "].fields2"					
					+ "' value=\"" + prvSupplier + "\" size=\"40\" maxlength=\"100\" />";				
				}
				
				// fails in IE > 8 and other browsers				
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				obj.appendChild(inputObj);
				
			} else if(i==2){			
				objString = "<input onchange='performChange(this, "+ newRowIndex +")"
				+ "' type='text' name='itemDesc[" + newRowIndex + "].fields3"					
				+ "' value=\"\" size='40' maxlength='100' />";
				
				// fails in IE > 8 and other browsers				
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				obj.appendChild(inputObj);
				
			} else if(i==3){
				objString = "<input onchange='performChange(this, "+ newRowIndex +")"
				+ "' type='text' name='itemUnit[" + newRowIndex + "].fields7"					
				+ "' value='' size='10' maxlength='50' />";
				
				// fails in IE > 8 and other browsers				
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				obj.appendChild(inputObj);			
			} else if(i==4){			
				objString = "<input onchange='performChange(this, "+ newRowIndex +")"
				+ "' type='text' name='itemPrice[" + newRowIndex + "].fields6"					
				+ "' value='0' size='10' maxlength='10' />";
				
				// fails in IE > 8 and other browsers				
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				obj.appendChild(inputObj);				
			} else if(i==5){
				objString = "<input onchange='performChange(this, "+ newRowIndex +")"
				+ "' type='text' name='itemQty[" + newRowIndex + "].fields4"					
				+ "' value='0' size='5' maxlength='5' />";
				
				// fails in IE > 8 and other browsers				
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				obj.appendChild(inputObj);					
			} else if(i==6){
				objString = "<input onchange='performChange(this, "+ newRowIndex +")"
				+ "' type='text' name='itemAmount[" + newRowIndex + "].fields5"					
				+ "' value='0' size='10' maxlength='10' disabled='disabled'/>";
				
				// fails in IE > 8 and other browsers				
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				obj.appendChild(inputObj);				
			} else if(i==7){ 
				objString = "<a href='javascript:deleteRow(" + newDelIndex + ");'" +	"></a>";
				
				// fails in IE > 8 and other browsers				
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'A';
					inputObj = createElementFromHTML(tagname,objString)
				}				

	       		inputObj.innerHTML="<img src='../images/delete1.png'>";	       		
				obj.appendChild(inputObj);				
			} else if(i==8){
				objString = "<input onchange='performChange(this, "+ newRowIndex +")"
				+ "' type='hidden' name='itemAmountHid[" + newRowIndex + "]"					
				+ "' value='0'/>";
				
				// fails in IE > 8 and other browsers				
				try {	
					inputObj = document.createElement(objString);			
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString)
				}				
				obj.appendChild(inputObj);
			}
			
			newRowTmp.appendChild(obj);
			tableRowTmp.appendChild(newRowTmp);

		}		
		newRecordCnt++;
		addTotalAmount(col,1);		
	}
}


function test(){
	var test = document.getElementById("amountID").value;
	chkAmountId(test);
	return true;
}	

function chkAmountId(amtID){
	var rowAmount = 0;
	var totalAmt = 0;
	var countZero = 0;
	var rtnVal = false;

	if(amtID!='0'){
		for(var k = 0 ; k<=assumeMaxRow; k++){
			if(document.getElementsByName("itemAmountHid["+k+"]")[0]) { 
				rowAmount = document.getElementsByName("itemAmountHid["+k+"]")[0].value;			
				if(parseFloat(rowAmount)==0){
					countZero++;
				}			
		 		totalAmt = parseFloat(totalAmt) + parseFloat(rowAmount);
			}			 				
		}
		if(countZero>0){
			$.ajax({
				type: "POST",
				url: "epo_hidden.jsp",
				data: 'p1=3&p2=' + totalAmt + '&p3=' + amtID,
				async: false,				
				success: function(values){
				if(values != '') {
					if(values.substring(0, 1) == 1) {
						rtnVal = true;			
					}else{
						alert('Please select correct amount range');
						document.getElementById("amountID").focus();
						rtnVal = false;						
						return false;							
					}										
				}//if
				}//success
			});//$.ajax		
		}else{
			$.ajax({
				type: "POST",
				url: "epo_hidden.jsp",
				data: 'p1=2&p2=' + totalAmt + '&p3=' + amtID,
				async: false,
				success: function(values){
				if(values != '') {
					if(values.substring(0, 1) == 1) {
						rtnVal = true;					
					}else{
						alert('Please select correct amount range');
						document.getElementById("amountID").focus();
						rtnVal = false;
						return false;							
					}										
				}//if
				}//success
			});//$.ajax				
		}
	}else{
		for(var j = 0 ; j<=assumeMaxRow; j++){
			if(document.getElementsByName("itemAmountHid["+j+"]")[0]) { 
				rowAmount = document.getElementsByName("itemAmountHid["+j+"]")[0].value;
				if(parseFloat(rowAmount)==0){
					countZero++;
				}			
		 		totalAmt = parseFloat(totalAmt) + parseFloat(rowAmount);
			}			 				
		}
		
		if(countZero>0){
			alert('Please select amount range');
			document.getElementById("amountID").focus();
			rtnVal = false;			
			return false;					
		}else{
			getTotalAmount(totalAmt);
			rtnVal = true;
		}			
	}
	return rtnVal;	
}


function getTotalAmount(totalAmt){	
	$.ajax({
		type: "POST",
		url: "epo_hidden.jsp",
		data: 'p1=4&p2=' + totalAmt,
		async: false,
		success: function(values){			
			if(values != null) {
				document.getElementById("amountID").value = trim(values);
			}else{	
				document.getElementById("amountID").value = '0';					
			}				
		}//success
	});//$.ajax					
}

	
function addRowStyle(rowObj){
	if(rowObj.rowIndex % 2 == 1){
		rowObj.setAttribute("className", "");
	}else{
		rowObj.setAttribute("className", "even");
	}
}



function trim(stringToTrim) {
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}
</script>