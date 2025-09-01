<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.constant.*"%>
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
int noOfCol = 9;//no of column in list
String reqNo = request.getParameter("reqNo");
String reqStatus = request.getParameter("reqStatus");
ArrayList<ReportableListObject> al_epo = new ArrayList<ReportableListObject>();
al_epo = EPORequestDB.getApprRequestDtl(reqNo);
request.setAttribute("EPO",al_epo);
int epoSize = al_epo.size();

String lsItemSupplier = null;
String lsItemDesc = null;
for(int i=0;i<epoSize;i++) {
		ReportableListObject row = (ReportableListObject) al_epo.get(i);
		lsItemSupplier = row.getValue(2);			
		row.setValue(2,lsItemSupplier.replaceAll("\"", "&quot;"));			
		lsItemDesc = row.getValue(3);		
		row.setValue(3,lsItemDesc.replaceAll("\"", "&quot;"));				
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
<body>
<bean:define id="functionLabel"><bean:message key="function.epo.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>	     
<display:table pagesize=""  requestURI="" class="tablesorter" name="EPO" sort="page" id="resList">
	<display:column title="" style="width:2%;" >	   	 	
		<input type="checkbox" name="checkOrder[${resList_rowNum - 1}]" checked="checked"/>													
	</display:column>	   
	<display:column style="width:1%">
		<div>			
			<input type="hidden" name="itemSeq[${resList_rowNum - 1}].fields1"
			value="${EPO[resList_rowNum - 1].fields1}" />
		</div>
    </display:column>
	<display:column style="width:8%;" title="PO NO.">	
		<div style="display:"";">
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name='itemPO[${resList_rowNum - 1}]'  
			value="" size="8" maxlength="8"/>								           											           	
        </div>
    </display:column>    
	<display:column style="width:22%;" title="Supplier Name">	
		<div style="display:"";">
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name='itemSupp[${resList_rowNum - 1}].fields2'  
			value="${EPO[resList_rowNum - 1].fields2}" size="40" maxlength="100"/>											           											           	
        </div>
    </display:column>   
    <display:column style="width:22%;" title="Item Desc" >
		<div style="display:"";">
			${EPO[resList_rowNum - 1].fields3}			
			<input type="hidden" name="itemDesc[${resList_rowNum - 1}].fields3" value="${EPO[resList_rowNum - 1].fields3}" size="40" maxlength="100"/>					
		</div>
	</display:column>
	<display:column style="width:8%; " title="Req QTY">	
		<div style="display:"";">
			${EPO[resList_rowNum - 1].fields4}
			<input type="hidden" name="itemQty[${resList_rowNum - 1}].fields4" value="${EPO[resList_rowNum - 1].fields4}" />		
        </div>
    </display:column>
	<display:column style="width:8%; " title="Ord QTY">	
		<div style="display:"";">
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name="poQty[${resList_rowNum - 1}]"
			value="${EPO[resList_rowNum - 1].fields16}"  size="6" maxlength="6" />								           											           	
        </div>
    </display:column>    
	<display:column style="width:8%;" title="Unit">	
			${EPO[resList_rowNum - 1].fields7}
			<input type="hidden" name="itemUnit[${resList_rowNum - 1}].fields7" value="${EPO[resList_rowNum - 1].fields7}" />
    </display:column>
	<display:column style="width:10%; " title="Unit Price">	
		<div>			
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name="itemPrice[${resList_rowNum - 1}].fields6"
			value="${EPO[resList_rowNum - 1].fields6}" size="10" maxlength="10" />
		</div>
    </display:column>    	
	<display:column style="width:10%; " title="Amount">	
		<div style="display:"";">		
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name="itemAmount[${resList_rowNum - 1}].fields5"
			value="${EPO[resList_rowNum - 1].fields5}"  size="10" maxlength="10" disabled="disabled"/>					           											           	
        </div>
    </display:column>
	<display:column style="width:8%;" title="Net Amt">	
		<div style="display:"";">
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name='netAmt[${resList_rowNum - 1}]'  
			value="${EPO[resList_rowNum - 1].fields5}" size="10" maxlength="10"/>								           											           	
        </div>
    </display:column>     
	<display:column title="" style="width:1%">
		<div>		
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="hidden" name="itemAmountHid[${resList_rowNum - 1}]"
			value="${EPO[resList_rowNum - 1].fields5}" />					           											           	
       	</div>
	</display:column>	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>	           					            
	</display:table>		
	<input type="hidden" name="lstRowIdx"/>	
</body>
</html:html>
<script type="text/javascript">
var totalAmtCnt = 0;
var col = 10;
var assumeMaxRow = 100;
var lstIdx = 0;

function cUpper(cObj) 
{
	cObj.value=cObj.value.toUpperCase();
}

function performChange(inputObj, index){
	var count = 0;	
	if(inputObj.parentNode.parentNode.childNodes[count].nodeName=="#text")
	count++;

	var objName = inputObj.name;
	var objValue = inputObj.value;

	switch (objName){
	case "poQty["+index+"]":
		if(objValue==null||objValue==''){
			alert('Please enter valid Quality');
			inputObj.value=0;
			document.getElementsByName("itemAmount["+index+"].fields5")[0].value = 0;
			document.getElementsByName("itemAmountHid["+index+"]")[0].value = 0;
			document.getElementsByName("netAmt["+index+"]")[0].value = 0;						
			inputObj.focus();
			inputObj.select();				
		}else{
			if(isNaN(objValue)){
				alert('Please enter valid Quality');
				inputObj.value=0;
				document.getElementsByName("itemAmount["+index+"].fields5")[0].value = 0;
				document.getElementsByName("itemAmountHid["+index+"]")[0].value = 0;
				document.getElementsByName("netAmt["+index+"]")[0].value = 0;								
				inputObj.focus();
				inputObj.select();						
			}else{
				var qty = objValue;							
				var price = document.getElementsByName("itemPrice["+index+"].fields6")[0].value;		
				var amount = qty * price;
				document.getElementsByName("itemAmount["+index+"].fields5")[0].value = amount;
				document.getElementsByName("itemAmountHid["+index+"]")[0].value = amount;
				document.getElementsByName("netAmt["+index+"]")[0].value = amount;				
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
			document.getElementsByName("netAmt["+index+"]")[0].value = 0;						
			inputObj.focus();
			inputObj.select();				
		}else{ 
			if(isNaN(objValue)){
				alert('Please enter valid Price');			
				inputObj.value=0;
				document.getElementsByName("itemAmount["+index+"].fields5")[0].value = 0;
				document.getElementsByName("itemAmountHid["+index+"]")[0].value = 0;
				document.getElementsByName("netAmt["+index+"]")[0].value = 0;									
				inputObj.focus();
				inputObj.select();		
			}else{
				var qty = document.getElementsByName("poQty["+index+"]")[0].value;
				var price = objValue;						
				var amount = qty * price;				
				document.getElementsByName("itemAmount["+index+"].fields5")[0].value = amount;
				document.getElementsByName("itemAmountHid["+index+"]")[0].value = amount;
				document.getElementsByName("netAmt["+index+"]")[0].value = amount;					
				document.getElementsByName("poQty["+index+"]")[0].focus();
				document.getElementsByName("poQty["+index+"]")[0].select();
			}
		}		
		addTotalAmount(col,0);		
		break;
	case "itemPO["+index+"]":
		var as_po = objValue.toUpperCase();
		inputObj.value = as_po;

		if(as_po!='CASH'&&as_po!='NA'&&as_po!='CANCEL'&&as_po!='GIFT'){
			$.ajax({
				type: "POST",
				url: "epo_hidden.jsp",
				data: 'p1=1&p2=' + as_po,	
				success: function(values){
				if(values != '') {
					if(values.substring(0, 1) == 1) {
						alert('Alert: PO NO. is existing in database.');
//						inputObj.focus();
//						inputObj.select();
						return false;										
					}
				}else{
					alert('Please enter PO NO.');			
					inputObj.focus();
					inputObj.select();					
				}//if
				}//success
			});//$.ajax	
		}
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
	case "netAmt["+index+"]":
		if(objValue==null||objValue==''){
			alert('Please enter valid net amount');
			inputObj.value=0;		
			inputObj.focus();
			inputObj.select();				
		}else{
			if(isNaN(objValue)){
				alert('Please enter valid net amount');
				inputObj.value=0;			
				inputObj.focus();
				inputObj.select();						
			}
		}
		addTotalAmount(col,0);		
		break;		
	}
	return false;
//	inputObj.parentNode.parentNode.childNodes[count].innerHTML=objValue;	
}

function checkRowValue(){
	var rowPo = null;
	var rowSupp = null;
	var rowQty = null;
	var rowPrice = null;	
	var j = 0;
	
	for(var i = 0 ; i<=assumeMaxRow; i++){
		if(document.getElementsByName("checkOrder["+i+"]")[0] && document.getElementsByName("checkOrder["+i+"]")[0].checked){
			if(document.getElementsByName("itemPO["+i+"]")[0]) {
				rowPo = document.getElementsByName("itemPO["+i+"]")[0].value;
							
				if(rowPo==''){
					alert('Please enter PO number');				
					document.getElementsByName("itemPO["+i+"]")[0].focus();
					document.getElementsByName("itemPO["+i+"]")[0].select();
					return -1;	
				}else{
					j++;
				}
			}
			
			if(document.getElementsByName("itemSupp["+i+"].fields2")[0]) {
				rowSupp = document.getElementsByName("itemSupp["+i+"].fields2")[0].value;
				
				if(rowSupp==''){
					alert('Please enter supplier name');				
					document.getElementsByName("itemSupp["+i+"].fields2")[0].focus();
					document.getElementsByName("itemSupp["+i+"].fields2")[0].select();
					return -1;				
				}else{
					j++;
				}
			}
	
			if(document.getElementsByName("poQty["+i+"]")[0]) { 
				rowQty = document.getElementsByName("poQty["+i+"]")[0].value;
				
				if(rowQty==''||rowQty==0){
					alert('Please enter item QTY');				
					document.getElementsByName("poQty["+i+"]")[0].focus();
					document.getElementsByName("poQty["+i+"]")[0].select();
					return -1;								
				}else{
					j++;
				}						
			}

			if(document.getElementsByName("itemPrice["+i+"].fields6")[0]) { 
				rowPrice = document.getElementsByName("itemPrice["+i+"].fields6")[0].value;
				
				if(rowPrice==''){
					alert('Please enter price');				
					document.getElementsByName("itemPrice["+i+"].fields6")[0].focus();
					document.getElementsByName("itemPrice["+i+"].fields6")[0].select();
					return -1;
				}else if(rowPrice==0){
					var r=confirm("Confirm enter 0 price?");
					if (r==false){			
						document.getElementsByName("itemPrice["+i+"].fields6")[0].focus();
						document.getElementsByName("itemPrice["+i+"].fields6")[0].select();		
						return -1;	
					 }			
				}else{
					j++;
				}						
			}

			if(document.getElementsByName("netAmt["+i+"]")[0]) { 
				rowPrice = document.getElementsByName("netAmt["+i+"]")[0].value;
				
				if(rowPrice==''){
					alert('Please enter net amount');				
					document.getElementsByName("netAmt["+i+"]")[0].focus();
					document.getElementsByName("netAmt["+i+"]")[0].select();
					return -1;
				}else if(rowPrice==0){
					var r=confirm("Confirm enter 0 price?");
					if (r==false){			
						document.getElementsByName("itemPrice["+i+"].fields6")[0].focus();
						document.getElementsByName("itemPrice["+i+"].fields6")[0].select();		
						return -1;	
					 }					
				}else{
					j++;
				}						
			}						
		}
	}
	return j;
}

function createElementFromHTML(tagname,html) {
	  var temp = document.createElement(tagname);
	  temp.innerHTML = html;
	  return temp.childNodes[0];
	}

function addTotalAmount(col,del){	
	var list = document.getElementById('resList');
	var rowCount=list.rows.length;
	var rowAmount = 0;
	var totalAmt = 0;
	var newRowIndex = 0;
	var deleteRowIndex = 0;
	
	for(var i = 0 ; i<=assumeMaxRow; i++){ 
		if(document.getElementsByName("netAmt["+i+"]")[0]) { 
			rowAmount = document.getElementsByName("netAmt["+i+"]")[0].value;						
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
	} else if (del==1) {				
		if(list==null){
			alert("list==null");
		}
		var tableRowTmp = list.insertRow(-1);
		var tagname = null;
			
		addRowStyle(tableRowTmp);	
		
		for(i = 0; i < col+1; i++){ 
			newRowTmp = tableRowTmp.insertCell(-1);
			//first div for display
			objString = '<div style="display:none;"></div>';
			
			// fails in IE > 8 and other browsers
			try {	
				obj = document.createElement(objString);
			} catch (err) {
				tagname = 'DIV';
				obj = createElementFromHTML(tagname,objString);	
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
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}				
				
				obj.appendChild(inputObj);
			} else if(i==1){
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}				
				obj.appendChild(inputObj);
			} else if(i==2){			
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}
				obj.appendChild(inputObj);
			} else if(i==3){
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}
				obj.appendChild(inputObj);
			} else if(i==4){			
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}
				obj.appendChild(inputObj);
			} else if(i==5){
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}			
				obj.appendChild(inputObj);
			} else if(i==6){
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}			
				obj.appendChild(inputObj);				
			} else if(i==7){
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}
				inputObj.innerHTML="";
				obj.appendChild(inputObj);
			} else if(i==8){
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}
				inputObj.innerHTML="";
				obj.appendChild(inputObj);
			} else if(i==9){
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}
				inputObj.innerHTML="";
				obj.appendChild(inputObj);
			} else if(i==10){
				objString = "<input onchange='performChange(this, "+ newRowIndex +")"
				+ "' type='text' name='itemTotalAmount[" + newRowIndex + "].fields5"					
				+ "' value='"+totalAmt+"' size='10' maxlength='10' disabled='disabled'/>";					

				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);					
				} catch (err) {
					tagname = 'INPUT';
					inputObj = createElementFromHTML(tagname,objString);	
				}				
				obj.appendChild(inputObj);				
			} else if(i==11){
				objString = "DIV";
				// fails in IE > 8 and other browsers
				try {	
					inputObj = document.createElement(objString);
				} catch (err) {
					tagname = 'DIV';
					inputObj = createElementFromHTML(tagname,objString);	
				}			
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
}

function checkRowCnt(){
	for(var k = 0 ; k<=assumeMaxRow; k++){
		if(document.getElementsByName("itemAmountHid["+k+"]")[0]) {
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

var newRecordCnt = 0;
	
function addRowStyle(rowObj){
	if(rowObj.rowIndex % 2 == 1){
		rowObj.setAttribute("className", "");
	}else{
		rowObj.setAttribute("className", "even");
	}
}

</script>