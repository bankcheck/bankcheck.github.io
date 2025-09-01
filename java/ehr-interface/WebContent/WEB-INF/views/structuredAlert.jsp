<%--
	The parameter listed according to the "Interface Specification for Structured Alert Adaptation Module",
	version 0.09 March 2012 by Hospital Authority Electronic Health Record Project Management Office (HA eHR PMO) 
	
	Updated (30 March 2017): "Interface Specification for Structured Alert Adaptation Module", version 1.0.8
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
 	<title>HA Structured Alert Adaption Module Client</title>
 	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.5.1.min.js" /></script>
  </head>
  <body>
  </body>
 		<script type="text/javascript">
 		$(document).ready(function(){
			var myKey = [];
			// a list of parameters to be passed to the module
			function goMapping() {
				// Service Information
				myKey["systemLogin"] = "${systemLogin}";
				myKey["sourceSystem"] = "${sourceSystem}";
				
				// User Information
				myKey["login"] = "${login}";
				myKey["loginName"] = "${loginName}";
				myKey["userRank"] = "${userRank}";
				myKey["userRankDesc"] = "${userRankDesc}";
				myKey["userRight"] = "${userRight}";
				myKey["hospitalCode"] = "${hospitalCode}";
				myKey["hospitalName"] = "${hospitalName}";
				myKey["actionCode"] = "${actionCode}";
				
				// Patient Information
				myKey["mrnDisplayLabelP"] = "${mrnDisplayLabelP}";
				myKey["mrnDisplayLabelE"] = "${mrnDisplayLabelE}";
				myKey["mrnDisplayType"] = "${mrnDisplayType}";
				myKey["hkid"] = "${hkid}";
				myKey["mrnPatientIdentity"] = "${mrnPatientIdentity}";
				myKey["mrnPatientEncounterNo"] = "${mrnPatientEncounterNo}";
				myKey["patientEhrNo"] = "${patientEhrNo}";
				myKey["doctype"] = "${doctype}";
				myKey["docnum"] = "${docnum}";
				myKey["nation"] = "${nation}";
				myKey["engSurName"] = "${engSurName}";
				myKey["engGivenName"] = "${engGivenName}";
				myKey["chiName"] = "${chiName}";
				myKey["oname"] = "${oname}";
				myKey["sex"] = "${sex}";
				myKey["dob"] = "${dob}";
				myKey["age"] = "${age}";
				myKey["deathDate"] = "${deathDate}";
				myKey["marital"] = "${marital}";
				myKey["religion"] = "${religion}";
				myKey["phoneH"] = "${phoneH}";
				myKey["phoneM"] = "${phoneM}";
				myKey["phoneOf"] = "${phoneOf}";
				myKey["phoneOt"] = "${phoneOt}";
				myKey["residentialAddress"] = "${residentialAddress}";
				myKey["photoContent"] = "${photoContent}";
				myKey["photoContentType"] = "${photoContentType}";
				
				// Patient Admission Information
				myKey["admD"] = "${admD}";
				myKey["disD"] = "${disD}";
				myKey["attdoc"] = "${attdoc}";
				myKey["condoc"] = "${condoc}";
				myKey["spec"] = "${spec}";
				myKey["classNum"] = "${classNum}";
				myKey["ward"] = "${ward}";
				myKey["bed"] = "${bed}";
				myKey["details"] = "${details}";
				
				post(myKey);
			}
			// POST function to the target URL of the module
			function post(myKey) {
				// Create the form object
				var form = document.createElement("form");
				form.setAttribute("method", "post");
				//URL of the module
				var url = "${url}";
				form.setAttribute("action", url);
				// For each key-value pair
				for (key in myKey) {
					var hiddenField = document.createElement("input");
					hiddenField.setAttribute("type", "hidden");
					hiddenField.setAttribute("name", key);
					hiddenField.setAttribute("value", myKey[key]);
					form.appendChild(hiddenField); // append the newly created control to the form
				}
				document.body.appendChild(form); // inject the form object into the body section
				//configure the new browser size and action properties of the new window
				form.submit() ;
			}
			
			goMapping(); 
 		});
	</script>
</html>