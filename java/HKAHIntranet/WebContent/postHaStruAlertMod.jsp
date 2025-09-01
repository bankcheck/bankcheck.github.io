<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.util.TextUtil"%>
<%@ page import="com.hkah.web.common.UserBean"%>
<%
	UserBean userBean = (UserBean) session.getAttribute("userInfo");
	String contextPath = request.getContextPath();
	String queryString = request.getQueryString();
	
	// System.out.println("DEBUG: postHaStruAlertMod.jsp queryString="+queryString);
	String hkid = request.getParameter("hkid");
	String patNo = request.getParameter("patNo");
	String engSurName = request.getParameter("engSurName");
	String engGivenName = request.getParameter("engGivenName");
	String chiName = TextUtil.parseStrUTF8(request.getParameter("chiName"));
	String sex = request.getParameter("sex");
	String dob = request.getParameter("dob");
	
	// HKAH
	String actionPath = "http://160.100.3.22/AdaptationFrame/html/AdaptationFrame.jsp";
%>
<html>
  <head>
 	<title>HA Structured Alert Adaption Module Client</title>
 	<script type="text/javascript" src="js/jquery-1.5.1.min.js" /></script>
  </head>
  <body>
  </body>
 		<script type="text/javascript">
 		$(document).ready(function(){
			var myKey = [];
			// a list of parameters to be passed to the module
			function goMapping() {
				myKey["systemLogin"] = "ALERT_ALLERGY";
				myKey["login"] = "user01";
				myKey["loginName"] = "User 01";
				myKey["sourceSystem"] = "WEBCl";
				myKey["userRank"] = "MO";
				myKey["userRankDesc"] = "Medical Officer";
				myKey["userRight"] = "A";
				myKey["hospitalCode"] = "AH";
				myKey["mrnPatientIdentity"] = "<%=hkid %>";
				myKey["engSurName"] = "<%=engSurName %>";
				myKey["engGivenName"] = "<%=engGivenName %>";
				myKey["chiName"] = "<%=chiName %>";
				myKey["hkid"] = "<%=hkid %>";
				myKey["dob"] = "<%=dob %>";
				myKey["sex"] = "<%=sex %>";
				
				post(myKey);
			}
			// POST function to the target URL of the module
			function post(myKey) {
				// Create the form object
				var form = document.createElement("form");
				form.setAttribute("method", "post");
				//URL of the module
				var url = "<%=actionPath %>";
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