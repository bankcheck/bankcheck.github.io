<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%
String businessType = request.getParameter("businessType");
String moduleCode = request.getParameter("moduleCode");
boolean isExternal = !"marketing".equals(moduleCode);
%>
<%if (!isExternal) { %>
    <option value=""<%="".equals(businessType)?" selected":"" %>></option>
	<option value="IP"<%="IP".equals(businessType)?" selected":"" %>>In-Patient</option>
	<option value="OP"<%="OP".equals(businessType)?" selected":"" %>>Out-Patient</option>
	<option value="Both"<%="Both".equals(businessType)?" selected":"" %>>InPatient & OutPatient</option>
	<option value="Dental"<%="Dental".equals(businessType)?" selected":"" %>>Dental</option>
<%} else if ("hkah".equals(ConstantsServerSide.SITE_CODE)) { %>
	<option value="Clinical Equipment  (New / Maintenance)"<%="Clinical Equipment  (New / Maintenance)".equals(businessType)?" selected":"" %>>Clinical Equipment  (New / Maintenance)</option>
	<option value="Clinical Professional Service (New / Maintenance)"<%="Clinical Professional Service (New / Maintenance)".equals(businessType)?" selected":"" %>>Clinical Professional Service (New / Maintenance)</option>
	<option value="Construction & Renovation (New / Maintenance)"<%="Construction & Renovation (New / Maintenance)".equals(businessType)?" selected":"" %>>Construction & Renovation (New / Maintenance)</option>
	<option value="Non-clinical Equipment  (New / Maintenance)"<%="Non-clinical Equipment  (New / Maintenance)".equals(businessType)?" selected":"" %>>Non-clinical Equipment  (New / Maintenance)</option>
	<option value="Non-clinical Professional Service  (New / Maintenance)"<%="Non-clinical Professional Service  (New / Maintenance)".equals(businessType)?" selected":"" %>>Non-clinical Professional Service  (New / Maintenance)</option>
	<option value="Software / Information System (New / Maintenance)"<%="Software / Information System (New / Maintenance)".equals(businessType)?" selected":"" %>>Software / Information System (New / Maintenance)</option>
	<option value="Subscription / Licenses  (New / Renewal)"<%="Subscription / Licenses  (New / Renewal)".equals(businessType)?" selected":"" %>>Subscription / Licenses  (New / Renewal)</option>
	<option value="Others"<%="Others".equals(businessType)?" selected":"" %>>Others</option>		
<%} else { %>
    <option value=""<%="".equals(businessType)?" selected":"" %>></option>
	<option value="Biokinetik Exercise Techinque"<%="Biokinetik Exercise Techinque".equals(businessType)?" selected":"" %>>Biokinetik Exercise Techinque</option>
	<option value="Cash collection"<%="Cash collection".equals(businessType)?" selected":"" %>>Cash collection</option>
	<option value="Disposal of clinical waste"<%="Disposal of clinical waste".equals(businessType)?" selected":"" %>>Disposal of clinical waste</option>
	<option value="Ditigal imaging & storage of medical records"<%="Ditigal imaging & storage of medical records".equals(businessType)?" selected":"" %>>Ditigal imaging & storage of medical records</option>
	<option value="Maintenance service"<%="Maintenance service".equals(businessType)?" selected":"" %>>Maintenance service</option>
	<option value="News clipping"<%="News clipping".equals(businessType)?" selected":"" %>>News clipping</option>
	<option value="Occupational Therapy"<%="Occupational Therapy".equals(businessType)?" selected":"" %>>Occupational Therapy</option>
	<option value="Others"<%="Others".equals(businessType)?" selected":"" %>>Others</option>
	<option value="Pest control service"<%="Pest control service".equals(businessType)?" selected":"" %>>Pest control service</option>
	<option value="Podiatry"<%="Podiatry".equals(businessType)?" selected":"" %>>Podiatry</option>
	<option value="Prosthetic and Orthotic"<%="Prosthetic and Orthotic".equals(businessType)?" selected":"" %>>Prosthetic and Orthotic</option>
	<option value="Provide histopathology services"<%="Provide histopathology services".equals(businessType)?" selected":"" %>>Provide histopathology services</option>
	<option value="Rental/laundry service"<%="Rental/laundry service".equals(businessType)?" selected":"" %>>Rental/laundry service</option>
	<option value="Scanning service"<%="Scanning service".equals(businessType)?" selected":"" %>>Scanning service</option>
	<option value="Search engine"<%="Search engine".equals(businessType)?" selected":"" %>>Search engine</option>
	<option value="Services"<%="Services".equals(businessType)?" selected":"" %>>Services</option>
	<option value="Sleep Study"<%="Sleep Study".equals(businessType)?" selected":"" %>>Sleep Study</option>
	<option value="Speech Therapy"<%="Speech Therapy".equals(businessType)?" selected":"" %>>Speech Therapy</option>
	<option value="Storage service"<%="Storage service".equals(businessType)?" selected":"" %>>Storage service</option>
	<option value="Subscription/Licenses Annual Renewal"<%="Subscription/Licenses Annual Renewal".equals(businessType)?" selected":"" %>>Subscription/Licenses Annual Renewal</option>
	<option value="Website maintenance"<%="Website maintenance".equals(businessType)?" selected":"" %>>Website maintenance</option>
<%} %>