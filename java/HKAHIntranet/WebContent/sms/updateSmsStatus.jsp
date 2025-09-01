<%@ page import="com.hkah.util.sms.UtilSMS"%>

<% 
UtilSMS.updateSmsStatus(UtilSMS.SMS_INPAT, null);
UtilSMS.updateSmsStatus(UtilSMS.SMS_OUTPAT, null);
UtilSMS.updateSmsStatus(UtilSMS.SMS_LMC, null);
UtilSMS.updateSmsStatus(UtilSMS.SMS_FOUNDATION, null);
UtilSMS.updateSmsStatus(UtilSMS.SMS_ONCOLOGY, null);
%>