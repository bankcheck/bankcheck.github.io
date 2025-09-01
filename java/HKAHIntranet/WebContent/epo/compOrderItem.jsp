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
int noOfCol = 7;//no of column in list
String reqNo = request.getParameter("reqNo");
String reqStatus = request.getParameter("reqStatus");
ArrayList al_epo = EPORequestDB.getOrdedDtl(reqNo);
request.setAttribute("EPO",al_epo);
int epoSize = al_epo.size();

System.err.println("[compOrderItem.jsp]");
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
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
 
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<bean:define id="functionLabel"><bean:message key="function.epo.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>	     
<display:table  pagesize=""  requestURI="" class="tablesorter" name="EPO" sort="page" id="resList">	   
	<display:column style="width:1%">
		<div></div>
		<div style="display:none;">
			<input type="hidden" name='itemSeq[${resList_rowNum - 1}].fields1'  
			value="${EPO[resList_rowNum - 1].fields1}" size="2" maxlength="2"/>					           											
        </div>
    </display:column>
	<display:column style="width:20%; text-align:center" title="Supplier Name">	
		<div>${EPO[resList_rowNum - 1].fields2}</div>
    </display:column>    				           	
    <display:column  style="width:20%; text-align:center" title="Item Desc">
		<div>${EPO[resList_rowNum - 1].fields3}</div>
	</display:column>
	<display:column style="width:8%; text-align:center" title="Unit">	
		<div>${EPO[resList_rowNum - 1].fields7}</div>
    </display:column>
	<display:column style="width:8%; text-align:right" title="Unit Price">	
		<div>${EPO[resList_rowNum - 1].fields6}</div>
    </display:column>    	
	<display:column style="width:8%; text-align:right" title="Req QTY">	
		<div>${EPO[resList_rowNum - 1].fields4}</div>
    </display:column>
	<display:column style="width:8%; text-align:right" title="Amount" >	
		<div>${EPO[resList_rowNum - 1].fields5}</div>
    </display:column>            
	<display:column title="View" media="html" style="width:10%; text-align:center">
		<button onclick="return viewPoDetail('<%=reqNo %>','<c:out value="${resList.fields1}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:column title="Approve" style="width:5%">
		<div>
		<select name="itemApproval[${resList_rowNum - 1}].fields13" disabled="disabled">
			<option value="0"<c:if test="${EPO[resList_rowNum - 1].fields13 == '0'}">selected</c:if>>Waiting Approve</option>						
			<option value="1"<c:if test="${EPO[resList_rowNum - 1].fields13 == '1'}">selected</c:if>>Approved</option>
			<option value="-1"<c:if test="${EPO[resList_rowNum - 1].fields13 == '-1'}">selected</c:if>>Rejected</option>			
		</select>		
		</div>		
	</display:column>	
	<display:column title="" style="width:1%">
		<div>		
			<input type="hidden" name="itemAmountHid[${resList_rowNum - 1}]"
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
var col = 7;
var assumeMaxRow = 100;
var lstIdx = 0;

function viewPoDetail(reqNo, reqSeq){
	callPopUpWindow("../epo/poDetailList.jsp?reqNo="+reqNo+"&reqSeq="+reqSeq);
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
			objString = '<div style="display:none;text-align:right"></div>';
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
			objString = '<div style="text-align:right"></div>';			
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
				objString = "<input align='right' onchange='performChange(this, "+ newRowIndex +")"
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

function checkRowCnt(){
	for(var k = 0 ; k<=assumeMaxRow; k++){
		if(document.getElementsByName("itemAmountHid["+k+"]")[0]) {
	 		var lstRowIdx = k;
		}			 				
	}
	return lstRowIdx;
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