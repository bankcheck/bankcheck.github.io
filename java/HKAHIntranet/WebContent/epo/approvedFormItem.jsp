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
int noOfCol = 8;//no of column in list
String reqNo = request.getParameter("reqNo");
String reqStatus = request.getParameter("reqStatus");
String amtID = request.getParameter("amtID");
ArrayList al_epo = EPORequestDB.getRequestDtl(reqNo);
request.setAttribute("EPO",al_epo);
int epoSize = al_epo.size();
String reqSiteCode = ConstantsServerSide.SITE_CODE;
String appGrp = request.getParameter("appGrp");
System.err.println("[approvedFormItem.jsp]");
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
<b>Requisition amount</b>&nbsp;
<select name="amountID" id="amountID" disabled="disabled">
<%amtID = amtID == null ? "" : amtID; %>
<jsp:include page="../ui/approvalAmountCMB.jsp" flush="false">
	<jsp:param name="amountID" value="<%=amtID %>" />
	<jsp:param name="appGrp" value="<%=appGrp %>"/>			
</jsp:include>
</select>
<display:table pagesize=""  requestURI="" class="tablesorter" name="EPO" sort="page" id="resList">	   
	<display:column style="width:5%">
		<div>			
			<input type="hidden" name="itemSeq[${resList_rowNum - 1}].fields1"
			value="${EPO[resList_rowNum - 1].fields1}" >
		</div>
    </display:column>
	<display:column style="width:20%;" title="Supplier Name">	
		<div>${EPO[resList_rowNum - 1].fields2}</div>
    </display:column>    				           	
    <display:column title="Item Desc" style="width:20%;">
		<div>${EPO[resList_rowNum - 1].fields3}</div>
	</display:column>
	<display:column style="width:8%;" title="Unit">	
		<div>${EPO[resList_rowNum - 1].fields7}</div>
    </display:column>
	<display:column style="width:8%; " title="Unit Price">	
		<div>			
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" onblur="checkNum(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name="itemPrice[${resList_rowNum - 1}].fields6"
			value="${EPO[resList_rowNum - 1].fields6}" size="10" maxlength="10" disabled="disabled">
		</div>
    </display:column>    	
	<display:column style="width:8%; " title="QTY">	
		<div style="display:"";">			
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name="itemQty[${resList_rowNum - 1}].fields4"
			value="${EPO[resList_rowNum - 1].fields4}"  size="5" maxlength="5" disabled="disabled">							           											           	
        </div>
    </display:column>
	<display:column style="width:8%; " title="Amount">	
		<div style="display:"";">		
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="text" name="itemAmount[${resList_rowNum - 1}].fields5"
			value="${EPO[resList_rowNum - 1].fields5}"  size="10" maxlength="10" disabled="disabled">					           											           	
        </div>
    </display:column>        
	<display:column title="Approve" style="width:5%">
		<div>
<%if("F".equals(reqStatus)){ %>
		<select name="itemApproval[${resList_rowNum - 1}].fields13" disabled="disabled">
			<option value="0"<c:if test="${EPO[resList_rowNum - 1].fields13 == '0'}">selected</c:if>>Waiting Approve</option>						
			<option value="1"<c:if test="${EPO[resList_rowNum - 1].fields13 == '1'}">selected</c:if>>1st Approved</option>
			<option value="-1"<c:if test="${EPO[resList_rowNum - 1].fields13 == '-1'}">selected</c:if>>Rejected</option>			
		</select>
<%}else{ %>
		<select name="itemApproval[${resList_rowNum - 1}].fields13" disabled="disabled">
			<option value="0"<c:if test="${EPO[resList_rowNum - 1].fields13 == '0'}">selected</c:if>>Waiting Approve</option>						
			<option value="1"<c:if test="${EPO[resList_rowNum - 1].fields13 == '1'}">selected</c:if>>Approved</option>
			<option value="-1"<c:if test="${EPO[resList_rowNum - 1].fields13 == '-1'}">selected</c:if>>Rejected</option>			
		</select>
<%} %>		
		</div>		
	</display:column>
	<display:column title="" style="width:1%">
		<div>		
			<input onchange="performChange(this, '<c:out value="${resList_rowNum - 1}" />')" type="hidden" name="itemAmountHid[${resList_rowNum - 1}]"
			value="${EPO[resList_rowNum - 1].fields5}">					           											           	
       	</div>
	</display:column>	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>	           					            
	</display:table>		
	<input type="hidden" name="lstRowIdx"/>	
</body>
</html:html>
<script type="text/javascript">
var totalAmtCnt = 0;
var col = 8;
var assumeMaxRow = 100;
var lstIdx = 0;

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
			}else{
				var qty = objValue;							
				var price = document.getElementsByName("itemPrice["+index+"].fields6")[0].value;		
				var amount = qty * price;
				document.getElementsByName("itemAmount["+index+"].fields5")[0].value = amount;
				document.getElementsByName("itemAmountHid["+index+"]")[0].value = amount;				
			}
		}
		addTotalAmount(col,0);		
		break;						
	}
//	inputObj.parentNode.parentNode.childNodes[count].innerHTML=objValue;	
}

function checkRowValue(){	
	for(var i = 0 ; i<=assumeMaxRow; i++){		
		if(document.getElementsByName("itemQty["+i+"].fields4")[0]) { 
			var rowQty = document.getElementsByName("itemQty["+i+"].fields4")[0].value;
			if(rowQty==''||rowQty==0){
				alert('Please enter item QTY');				
				document.getElementsByName("itemQty["+i+"].fields4")[0].focus();
				document.getElementsByName("itemQty["+i+"].fields4")[0].select();
				return false;								
			}						
		}		
	}
	return true;
}

function changeAllReject(){
	for(var i = 0 ; i<=assumeMaxRow; i++){
		if(document.getElementsByName("itemApproval["+i+"].fields13")[0]) { 
			document.getElementsByName("itemApproval["+i+"].fields13")[0].value = "-1";
		}
	}	
}

function checkRowApproval(approveFlag){
	var itemApprove = null;
	var price = 0;
	var r = 0;
	var x = 0;
	var y = 0;
	var z = 0;	
	var ax=new Array();
	var ay=new Array();
	var az=new Array();

	for(var i = 0 ; i<=assumeMaxRow; i++){
		if(document.getElementsByName("itemApproval["+i+"].fields13")[0]) { 
			itemApprove = document.getElementsByName("itemApproval["+i+"].fields13")[0].value;
			r++;
			switch (itemApprove){
			case "0":
				ax[i]=1;
				ay[i]=0;
				az[i]=0;				
				x++;		
				break;
			case "1":				
				ax[i]=0;
				ay[i]=1;
				az[i]=0;						
				y++;		
				break;									
			case "-1":				
				ax[i]=0;
				ay[i]=0;
				az[i]=1;								
				z++;		
				break;				
			}					 				 				
		}
	}

	switch (approveFlag){
	case "A":
		if(x>0){
			var c=confirm(x+" item(s) waiting approve, do you want to approve all?");			
			if (c==true){					
				for(var j = 0 ; j<=ax.length; j++){
					if(ax[j]==1){
						document.getElementsByName("itemApproval["+j+"].fields13")[0].value = '1';
					}
				}
				return true;	
			 }else{
				return false;	
			 }
		}else if(r==z){
			var c=confirm(z+" item(s) select rejected, do you want to change to approve status?");			
			if (c==true){					
				for(var j = 0 ; j<=az.length; j++){
					if(az[j]==1){
						document.getElementsByName("itemApproval["+j+"].fields13")[0].value = '1';
					}
				}
				return true;	
			 }else{
				return false;	
			 }			
		}else{
			return true;
		}				
		break;
	case "F":
		if(x>0){
			var c=confirm(x+" item(s) waiting approve, do you want to approve all?");			
			if (c==true){					
				for(var j = 0 ; j<=ax.length; j++){
					if(ax[j]==1){
						document.getElementsByName("itemApproval["+j+"].fields13")[0].value = '1';
					}
				}
				return true;	
			 }else{
				return false;	
			 }
		}else{
			return true;
		}							
		break;									
	case "R":
		if(x>0||y>0){
			var c=confirm('All items will rejected, do you want to continue?');			
			if (c==true){					
				changeAllReject();
				return true;	
			 }else{
				return false;	
			 }
		}else{
			return true;
		}
		break;				
	}
	return false;
}

function createElementFromHTML(tagname,html) {
	  var temp = document.createElement(tagname);
	  temp.innerHTML = html;
	  return temp.childNodes[0];
	}

function addTotalAmount(col,del){	
	var list = document.getElementById('resList');
	var rowCount=list.rows.length;
	var lastRowIndex = rowCount - 1;	
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
	} else if (del==1) {				
		if(list==null){
			alert("list==null");
		}
		var tableRowTmp = list.insertRow(-1);
			
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
			obj = document.createElement(objString);
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