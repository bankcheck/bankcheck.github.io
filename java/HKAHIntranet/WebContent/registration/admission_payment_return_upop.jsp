<%@ page import="java.util.List,
                 java.util.ArrayList,
                 java.util.Collections,
                 java.util.Iterator,
                 java.util.Enumeration,
                 java.security.MessageDigest,
                 java.util.Map,
                 java.net.URLEncoder,
                 java.util.HashMap"%>

<%@ page import="com.hkah.web.db.*"%>

<%@ page import="com.chilibrain.unionpay.QueryService,
                 com.chilibrain.unionpay.UPOP,
                 com.chilibrain.unionpay.Util"%>

<%!
//  ----------------------------------------------------------------------------

   /*
    * This method takes a data String and returns a predefined value if empty
    * If data Sting is null, returns string "No Value Returned", else returns input
    *
    * @param in String containing the data String
    * @return String containing the output String
    */
    private static String null2unknown(String in) {
        if (in == null || in.length() == 0) {
            return "No Value Returned";
        } else {
            return in;
        }
    } // null2unknown()
    
//  ----------------------------------------------------------------------------
%> 
<%
	System.out.println("[REG] UPOP payment return");

	Map fields = new HashMap();
	for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
    	String fieldName = (String) e.nextElement();
    	String fieldValue = request.getParameter(fieldName);
    	if ((fieldValue != null) && (fieldValue.length() > 0)) {
        	fields.put(fieldName, fieldValue);
    	}
	}

    // admissionId = orderNumber
    String orderId              = null2unknown((String)fields.get("orderId"));
    String traceNo              = null2unknown((String)fields.get("traceNo"));
    String respCode       		= null2unknown((String)fields.get("respCode"));
    String certId               = null2unknown((String)fields.get("certId"));
    String settleAmt            = null2unknown((String)fields.get("settleAmt"));
    String settleCurrencyCode   = null2unknown((String)fields.get("settleCurrencyCode"));

    String admissionID = null2unknown((String)fields.get("admissionID"));
	// fix language isuue : add "?language="+language on redirect
    String language             = null2unknown((String)fields.get("language"));
    
    //20180912 Arran /100 to round up to nearest dollar
	settleAmt = settleAmt.substring(0, settleAmt.length() - 2);
    
    boolean updatePaymentStatus = false;
    
	// update back payment success status to hat_patient table
	// stop at here
    //updatePaymentStatus = AdmissionDB.updatePaymentReturn( admissionID, "Y", respCode, traceNumber ) ;
    //System.out.println("admission_payment_return_upop.jsp : admissionID, respCode, traceNumber, orderId, certId, settleAmt, settleCurrencyCode : " + admissionID + "," + respCode + "," + traceNo + "," + orderId + "," + certId + "," + settleAmt + "," + settleCurrencyCode);

	updatePaymentStatus = AdmissionDB.updatePaymentReturn( admissionID, "Y", respCode, traceNo, "UnionPay", orderId, certId, settleAmt, settleCurrencyCode ) ;

    if ("00".equals(respCode) ) {
/*20180913 Arran deleted unless code    	
    	// for UPOP query service test : begin
		HashMap<String, Object> UPOPConfigs = new HashMap<String, Object>();
		UPOPConfigs.put("mid", "505034480624069");
		// "notify_url" must be included according to Yan Jun [yanjun@unionpayintl.com]
		UPOPConfigs.put("notify_url", "http://client-projects.chilibrain.com/unionpay/php/sample_codes/v2/testing/notify.php");
		//UPOPConfigs.put("notify_url","http://"+request.getLocalAddr()+":"+request.getLocalPort()+"/intranet/registration/admission_payment_return_upop.jsp?admissionID=" + admissionID  + "&language=" + language) ;

		//
//2018023 Arran change cert location
		//UPOPConfigs.put("pfx", "testing.pfx");
		UPOPConfigs.put("pfx", "C:/cert/testing.pfx");
		//UPOPConfigs.put("pfx", "C:/PortalOnlinePayment/UPOP SDK 5.0/demo/java-sample_codes/testing.pfx");
		
		UPOPConfigs.put("cert_password", "000000");
		UPOP.init("development", UPOPConfigs);
		QueryService qs = UPOP.initQueryService();
		System.out.print("QueryService request: " + qs.findByOrderId( orderId ).getMessage()+"\n") ;
		System.out.print("QueryService Response: " + qs.findByOrderId( orderId ).getResponse()+"\n") ;
*/		
		//System.out.print("QueryService origRespCode: " + qs.findByOrderId( orderId ).getResponse().get("origRespCode")+"\n") ;
		// for UPOP query service test : end
		//response.sendRedirect("admission_payment_receipt.jsp?admissionID=" + admissionID + "&receiptNo=" + traceNumber + "&paymentType=Union Pay" + "&amount=" + orderAmount) ;
		// instead of display payment receipt, receipt email is sent to client
		//20180918 Arran moved send email code to online_admission_submit.jsp
		//AdmissionDB.sendEmailAutoNotifyClientPayment( admissionID, "in");
		response.sendRedirect("online_admission_submit.jsp" + "?language="+language + "&paymentType=UNION_PAY" + "&admissionID=" + admissionID );
	} else {
		response.sendRedirect("admission_payment_error.jsp"  + "?language="+language );
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>