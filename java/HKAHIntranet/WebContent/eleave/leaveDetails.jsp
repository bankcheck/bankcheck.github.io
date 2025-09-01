<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.servlet.jsp.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.DecimalFormat" %>


<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">

<jsp:include page="../common/header.jsp"/>
<body>

	<table width="100%" border="0">

<%
String leaveType = ParserUtil.getParameter(request,"leaveType");
String EL_courseName = ParserUtil.getParameter(request,"EL_courseName");
String EL_admAction = ParserUtil.getParameter(request,"EL_admAction");
String ML_expectedDate = ParserUtil.getParameter(request,"ML_expectedDate");
String SL_diagnosis = ParserUtil.getParameter(request,"SL_diagnosis");
String SL_docName = ParserUtil.getParameter(request,"SL_docName");
String FL_relationship = ParserUtil.getParameter(request,"FL_relationship");
String command = ParserUtil.getParameter(request,"command");
String leaveID = ParserUtil.getParameter(request,"leaveID");
Map viewDetailsMap = new HashMap<String, String>();

boolean viewAction = false;

if ("view".equals(command)) {
	viewAction = true;
}
if(viewAction){
	  ArrayList recordDetails = ELeaveDB.getDetailsByID(leaveID);
	  if(recordDetails.size()>0){
		  for (int i = 0; i < recordDetails.size(); i++) {	
			  ReportableListObject row = (ReportableListObject) recordDetails.get(i);
			  viewDetailsMap.put(row.getValue(0),row.getValue(1));
		  }
	  }
}
%>

<%
	if("EL".equals(leaveType)){
%>
			<%	if (viewAction) { %>
				<tr class="smallText">
					<td class="infoLabel" width="20%">Course Name</td>
					<td class="infoData" width="30%"><b><%=viewDetailsMap.get("EL_courseName")==null?"":viewDetailsMap.get("EL_courseName") %></b></td>
					<td class="infoLabel"width="20%">Adm Council Action#(if applicable)</td>
					<td class="infoData" width="30%"><b><%=viewDetailsMap.get("EL_admAction")==null?"":viewDetailsMap.get("EL_admAction") %></b></td>				
				</tr>
			<%} else{%>
				<tr class="smallText">
					<td class="infoLabel" width="20%">Course Name</td>
					<td class="infoData"width="30%"><input type="textfield" name="EL_courseName" class="leaveDetails" value="<%=EL_courseName==null?"":EL_courseName %>" maxlength="100" size="70"></td>
					<td class="infoLabel"width="20%">Adm Council Action#(if applicable)</td>
					<td class="infoData"width="30%"><input type="textfield" name="EL_admAction" class="leaveDetails" value="<%=EL_admAction==null?"":EL_admAction %>" maxlength="100" size="20"></td>
				</tr>
			<%} %>

	<%}if("FL".equals(leaveType)){
%>
			<%	if (viewAction) { %>
				<tr class="smallText">
					<td class="infoLabel" width="20%">Relationship</td>
					<td class="infoData" width="80%" colspan="3">
						<select name="" class="leaveDetails" disabled="disabled">
							<option value="" <%="".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>></option>						
							<option value="legalSpouse" <%="legalSpouse".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>Legal Spouse</option>
							<option value="children"<%="children".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>Children</option>		
							<option value="father"<%="father".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>Father</option>		
							<option value="mother"<%="mother".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>mother</option>			
							<option value="fatherInLaw"<%="fatherInLaw".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>Father-In-Law</option>				
							<option value="motherInLaw"<%="motherInLaw".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>Mother-In-Law</option>											
							<option value="fosterFather"<%="fosterFather".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>Foster Father</option>											
							<option value="fosterMother"<%="fosterMother".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>Foster Mother</option>											
							<option value="brother"<%="brother".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>Brother</option>											
							<option value="Sister"<%="Sister".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>Sister</option>											
							<option value="legalGuardian"<%="legalGuardian".equals(viewDetailsMap.get("FL_relationship"))?" selected":"" %>>Legal Guardian</option>											
						</select>					
					</td>
		
				</tr>
			<%} else{%>		
				<tr class="smallText">
					<td class="infoLabel" width="20%">Relationship</td>
					<td class="infoData"width="80%" colspan="3">
						<select name="FL_relationship" class="leaveDetails">
							<option value="legalSpouse">Legal Spouse</option>
							<option value="children">Children</option>		
							<option value="father">Father</option>		
							<option value="mother">mother</option>			
							<option value="fatherInLaw">Father-In-Law</option>				
							<option value="motherInLaw">Mother-In-Law</option>											
							<option value="fosterFather">Foster Father</option>											
							<option value="fosterMother">Foster Mother</option>											
							<option value="brother">Brother</option>											
							<option value="Sister">Sister</option>											
							<option value="legalGua	rdian">Legal Guardian</option>											
						</select>
					</td>
				</tr>
			<%} %>
	
	<%}if("ML".equals(leaveType)){%>
			<%	if (viewAction) { %>
				<tr class="smallText">
					<td class="infoLabel" width="20%">Expected Date of Confinement</td>
					<td class="infoData" width="80%" colspan="3"><b><%=viewDetailsMap.get("ML_expectedDate")==null?"":viewDetailsMap.get("ML_expectedDate") %></b></td>
		
				</tr>
			<%}else{ %>		
					<tr class="smallText">
						<td class="infoLabel" width="20%">Expected Date of Confinement</td>
						<td class="infoData"width="80%" colspan="3">
							<input type="textfield" name="ML_expectedDate" id="ML_expectedDate" class="datepickerfield" value="<%=ML_expectedDate==null?"":ML_expectedDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">						
						</td>
					</tr>
			<%} %>
	
	<%}if("SL".equals(leaveType)){%>
				<%	if (viewAction) { %>
				<tr class="smallText">
					<td class="infoLabel" width="20%">Diagnosis</td>
					<td class="infoData" width="30%">
							<select name="SL_diagnosis" class="leaveDetails" disabled="disabled">
								<option value="" <%="".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>></option>
								<option value="accInjury" <%="accInjury".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Accident Injury 意外受傷</option>
								<option value="arthritis" <%="arthritis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Arthritis 關節炎</option>		
								<option value="bronchitis"<%="bronchitis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Bronchitis 氣管炎</option>		
								<option value="conjunctivitis"<%="conjunctivitis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Conjunctivitis 眼結膜炎</option>			
								<option value="cystitis"<%="cystitis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Cystitis/Urethritis 膀胱炎/尿道炎</option>				
								<option value="dermatitis"<%="dermatitis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Dermatitis 皮膚炎</option>											
								<option value="gastrtis"<%="gastrtis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Gastritis/Ulcer Pain 胃炎</option>											
								<option value="gastroenteritis"<%="gastroenteritis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Gastroenteritis 腸胃炎</option>		
								<option value="gynOb"<%="gynOb".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Gynaecological/Obstetrical Disease 婦科/產科病症</option>
								<option value="boneAche"<%="boneAche".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Bone Ache/Joint Pain 骨痛</option>		
								<option value="skinLesion"<%="skinLesion".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Skin Lesion 皮膚病</option>		
								<option value="eyeLesion"<%="eyeLesion".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Eye Lesion 眼病</option>	
								<option value="influenza"<%="influenza".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Influenza/Common Cold 感冒/傷風</option>	
								<option value="meniereDisease"<%="meniereDisease".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Meniere's Disease 耳眩病/耳性眩暈症</option>	
								<option value="neuritis"<%="neuritis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Neuritis/Migraine 神經炎/偏頭痛</option>	
								<option value="pharyngitis"<%="pharyngitis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Pharyngitis/Laryngitis 咽喉炎/聲帶炎</option>	
								<option value="premenSynd"<%="premenSynd".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Premenstrual Synd 經前綜合症</option>	
								<option value="rhinitis"<%="rhinitis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Rhinitis/Sinusitis 鼻炎/鼻竇炎</option>	
								<option value="stomatitis"<%="stomatitis".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>Stomatitis/Tonsillitis 口腔炎/扁桃腺炎</option>	
								<option value="urti"<%="urti".equals(viewDetailsMap.get("SL_diagnosis"))?" selected":"" %>>U.R.T.I 上呼吸道感染</option>																																											
							</select>
					
					</td>
					<td class="infoLabel"width="20%">Doctor Name</td>
					<td class="infoData" width="30%"><%=viewDetailsMap.get("SL_docName")==null?"":viewDetailsMap.get("SL_docName") %></td>				
				</tr>
				<%}else{ %>	
					<tr class="smallText">
						<td class="infoLabel" width="20%">Diagnosis</td>
						<td class="infoData"width="30%">
							<select name="SL_diagnosis" class="leaveDetails">
								<option value="accInjury">Accident Injury 意外受傷</option>
								<option value="arthritis">Arthritis 關節炎</option>		
								<option value="bronchitis">Bronchitis 氣管炎</option>		
								<option value="conjunctivitis">Conjunctivitis 眼結膜炎</option>			
								<option value="cystitis">Cystitis/Urethritis 膀胱炎/尿道炎</option>				
								<option value="dermatitis">Dermatitis 皮膚炎</option>											
								<option value="gastrtis">Gastritis/Ulcer Pain 胃炎</option>											
								<option value="gastroenteritis">Gastroenteritis 腸胃炎</option>		
								<option value="gynOb">Gynaecological/Obstetrical Disease 婦科/產科病症</option>
								<option value="boneAche">Bone Ache/Joint Pain 骨痛</option>		
								<option value="skinLesion">Skin Lesion 皮膚病</option>		
								<option value="eyeLesion">Eye Lesion 眼病</option>	
								<option value="influenza">Influenza/Common Cold 感冒/傷風</option>	
								<option value="meniereDisease">Meniere's Disease 耳眩病/耳性眩暈症</option>	
								<option value="neuritis">Neuritis/Migraine 神經炎/偏頭痛</option>	
								<option value="pharyngitis">Pharyngitis/Laryngitis 咽喉炎/聲帶炎</option>	
								<option value="premenSynd">Premenstrual Synd 經前綜合症</option>	
								<option value="rhinitis">Rhinitis/Sinusitis 鼻炎/鼻竇炎</option>	
								<option value="stomatitis">Stomatitis/Tonsillitis 口腔炎/扁桃腺炎</option>	
								<option value="urti">U.R.T.I 上呼吸道感染</option>																																											
							</select>
						<td class="infoLabel"width="20%">Doctor Name</td>
						<td class="infoData"width="30%"><input type="textfield" name="SL_docName" class="leaveDetails" value="<%=SL_docName==null?"":SL_docName %>" maxlength="100" size="50"></td>
									
						</td>
					</tr>
				<%} %>
			
	<%}%>
		</table>
</html:html>