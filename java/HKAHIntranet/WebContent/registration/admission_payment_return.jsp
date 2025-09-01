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
	System.out.println("[REG] Visa/Master payment return");

	Map fields = new HashMap();
	for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
    	String fieldName = (String) e.nextElement();
    	String fieldValue = request.getParameter(fieldName);
    	if ((fieldValue != null) && (fieldValue.length() > 0)) {
        	fields.put(fieldName, fieldValue);
    	}
	}

    String title           = null2unknown((String)fields.get("Title"));
    String againLink       = null2unknown((String)fields.get("AgainLink"));
    String amount          = null2unknown((String)fields.get("vpc_Amount"));
//20180912 Arran /100 to round up to nearest dollar
	amount = amount.substring(0, amount.length() - 2);
    String locale          = null2unknown((String)fields.get("vpc_Locale"));
    String batchNo         = null2unknown((String)fields.get("vpc_BatchNo"));
    String command         = null2unknown((String)fields.get("vpc_Command"));
    String message         = null2unknown((String)fields.get("vpc_Message"));
    String version         = null2unknown((String)fields.get("vpc_Version"));
    String cardType        = null2unknown((String)fields.get("vpc_Card"));
    String orderInfo       = null2unknown((String)fields.get("vpc_OrderInfo"));
    String receiptNo       = null2unknown((String)fields.get("vpc_ReceiptNo"));
    String merchantID      = null2unknown((String)fields.get("vpc_Merchant"));
    // admissionId = merchTxnRef
    String merchTxnRef     = null2unknown((String)fields.get("vpc_MerchTxnRef"));
    String authorizeID     = null2unknown((String)fields.get("vpc_AuthorizeId"));
    String transactionNo   = null2unknown((String)fields.get("vpc_TransactionNo"));
    String acqResponseCode = null2unknown((String)fields.get("vpc_AcqResponseCode"));
    String txnResponseCode = null2unknown((String)fields.get("vpc_TxnResponseCode"));

    String paymentType   = null2unknown((String)fields.get("paymentType"));
    String paymentTypeOther   = null2unknown((String)fields.get("paymentTypeOther"));
    String creditCardType   = null2unknown((String)fields.get("creditCardType"));

 	// fix language isuue : add "?language="+language on redirect
    String language             = null2unknown((String)fields.get("language"));
    
    String cardTypeDisp = "unknow" ;
    if ( "MC".equals(cardType) ) {
    	//cardTypeDisp = "Master Card" ;
    	cardTypeDisp = "MasterCard" ;
    } else if ( "VC".equals(cardType) ) {
    	//cardTypeDisp = "Visa Card" ;
    	cardTypeDisp = "Visa" ;
    }
    
    boolean updatePaymentStatus = false;
    
	// update back payment success status to hat_patient table
	// stop at here
    //updatePaymentStatus = AdmissionDB.updatePaymentReturn( merchTxnRef, "Y", txnResponseCode, receiptNo ) ;
	updatePaymentStatus = AdmissionDB.updatePaymentReturn( merchTxnRef, "Y", txnResponseCode, receiptNo, cardTypeDisp, transactionNo, authorizeID, amount, "344" ) ;

    if ("0".equals(txnResponseCode) ) {
		//response.sendRedirect("admission_payment_receipt.jsp?admissionID=" + merchTxnRef + "&receiptNo=" + receiptNo + "&paymentType=" + cardTypeDisp + "&amount=" + amount) ;
		// instead of display payment receipt, receipt email is sent to client
		//20180918 Arran moved send email code to online_admission_submit.jsp
		//AdmissionDB.sendEmailAutoNotifyClientPayment( merchTxnRef, "in");
		response.sendRedirect("online_admission_submit.jsp" + "?language="+language + "&paymentType=VISA_MASTER" + "&admissionID=" + merchTxnRef );
	} else {	
		response.sendRedirect("admission_payment_error.jsp" + "?language="+language );
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