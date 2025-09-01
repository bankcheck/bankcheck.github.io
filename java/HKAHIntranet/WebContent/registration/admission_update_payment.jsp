<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
	boolean fileUpload = false;
	if (HttpFileUpload.isMultipartContent(request)){
		HttpFileUpload.toUploadFolder(
			request,
			ConstantsServerSide.DOCUMENT_FOLDER,
			ConstantsServerSide.TEMP_FOLDER,
			ConstantsServerSide.UPLOAD_FOLDER
		);
		fileUpload = true;
	}
	UserBean userBean = new UserBean(request);
	
	String language = ParserUtil.getParameter(request, "language");

	String admissionID = ParserUtil.getParameter(request, "admissionID");
	String paymentType = ParserUtil.getParameter(request, "paymentType");
	String paymentTypeOther = ParserUtil.getParameter(request, "paymentTypeOther");
	String creditCardType = ParserUtil.getParameter(request, "creditCardType");
	String vpc_Amount = ParserUtil.getParameter(request, "vpc_Amount");
	String insuranceRemarks = ParserUtil.getParameter(request, "insuranceRemarks");
	String paymentDeclare = ParserUtil.getParameter(request, "paymentDeclare");

	String patidno1 = TextUtil.parseStr(ParserUtil.getParameter(request, "patidno1")).toUpperCase();
	String patidno2 = TextUtil.parseStr(ParserUtil.getParameter(request, "patidno2")).toUpperCase();
	String roomType = ParserUtil.getParameter(request, "roomType");

	// Upload file : begin
    //System.out.println("debug before, language : " + language) ;
    //System.out.println("debug before, request.language : " + request.getAttribute("language")) ;
    //System.out.println("debug before, paymentType : " + paymentType) ;
    //System.out.println("debug before, request.paymentType : " + request.getAttribute("paymentType")) ;

    String patidno = null;
	String patpassport = TextUtil.parseStr(request.getParameter("patpassport")).toUpperCase();
	//if (HttpFileUpload.isMultipartContent(request)){
	if (fileUpload) {
		// following part must be executed first, otherwise will get null parmeters
		//HttpFileUpload.toUploadFolder(
		//	request,
		//	ConstantsServerSide.DOCUMENT_FOLDER,
		//	ConstantsServerSide.TEMP_FOLDER,
		//	ConstantsServerSide.UPLOAD_FOLDER
		//);
		
		patidno = patpassport;
		if (patidno.length() == 0) {
			patidno = patidno1 + patidno2;
		}
		//System.out.println("debug patidno : " + patidno ) ;
		StringBuffer tempStrBuffer = new StringBuffer();
		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Admission at ward");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(admissionID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		// upload from admission page
		String[] fileList = (String[]) request.getAttribute("filelist");
		if (fileList != null && fileList.length > 0) {
			for (int i = 0; i < fileList.length; i++) {
				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
					baseUrl + fileList[i]
				);
				AdmissionDB.insertDocument(userBean, admissionID, fileList[i]);
			}
		}
	}
    //System.out.println("debug after, language : " + language) ;
    //System.out.println("debug after, request.language : " + request.getAttribute("language")) ;
    //System.out.println("debug after, paymentType : " + paymentType) ;
    //System.out.println("debug after, request.paymentType : " + request.getAttribute("paymentType")) ;
    //System.out.println("debug after, ParserUtil.getParameter/paymentType : " + ParserUtil.getParameter(request, "paymentType")) ;
	// upload file : end
	
	// save to db
	//paymentDeclare = "1";
    
    if (paymentDeclare == null) {
    	paymentDeclare = "0";
    }
	
    AdmissionDB.updatePaymentMethod(admissionID, paymentType, paymentTypeOther, creditCardType, vpc_Amount, insuranceRemarks, paymentDeclare) ;
	// send email to PBO
	// please un-comment below code when deploy to production
	//AdmissionDB.sendEmailNotifyStaff(admissionID,"in");
	//
	String action = null ;
	//if ( "Visa/Master".equals( creditCardType )  ) {
	if ( "VISA_MASTER".equals( paymentType )  ) {
		action = "admission_vpc_serverhost_DO.jsp";
		//response.sendRedirect( action + "?admissionID=" + admissionID + "&vpc_Amount=" + vpc_Amount + "&language=" + language );

		request.setAttribute("admissionID", admissionID);
		request.setAttribute("vpc_Amount", vpc_Amount);
		request.setAttribute("language", language);
		request.getRequestDispatcher(action).forward(request, response);
	} else if ( "UNION_PAY".equals( paymentType ) ) {
		// production, sdk version 1.0
		//action = "../UnionPayServlet"  ;
		// sdk version 5.0
		// testing
		//action = "admission_payment_return_upop.jsp?orderNumber=" + admissionID + "&orderAmount=" + vpc_Amount + "&traceNumber=TEST_TRACE_NUM_12345&respCode=00" ;
		//response.sendRedirect( action );
		action = "admission_upop_payment.jsp"  ;
		//response.sendRedirect( action + "?admissionID=" + admissionID + "&vpc_Amount=" + vpc_Amount + "&language=" + language );
		//System.out.println("[DEBUG] action:" + action);
		
		request.setAttribute("admissionID", admissionID);
		request.setAttribute("vpc_Amount", vpc_Amount);
		request.setAttribute("language", language);
		request.getRequestDispatcher(action).forward(request, response);
	} else if ( "INSURANCE".equals( paymentType ) ) {
		//AdmissionDB.sendEmailAutoNotifyClientPayment( admissionID, "in") ;
		request.setAttribute("admissionID", admissionID);
		request.setAttribute("patpassport", patpassport);
		request.setAttribute("patidno1", patidno1);
		request.setAttribute("patidno2", patidno2);
		request.setAttribute("roomType", roomType);
		
		//response.sendRedirect( "online_admission_insurance_note.jsp?admissionID="+admissionID+"&patidno1="+patidno1+"&roomType="+roomType+"&language="+language );
		request.getRequestDispatcher("online_admission_insurance_note.jsp").forward(request, response);
	//} else if ( "CASH".equals( paymentType ) || "EPS".equals( paymentType ) ) {
//20180910 Arran change CASH_EPS to UPON_ARRIVAL		
	} else if ( "UPON_ARRIVAL".equals( paymentType ) ) {
		//AdmissionDB.sendEmailAutoNotifyClientPayment( admissionID, "in") ;
		//AdmissionDB.sendEmailNotifyStaff( admissionID, "in" );
		//AdmissionDB.sendEmailNotifyClient(userBean, null);
		//AdmissionDB.sendEmailAutoNotifyClient(admissionID, "in");
		//AdmissionDB.sendEmailConfirmClient(userBean, admissionID, "in");
		request.setAttribute("admissionID", admissionID);
		request.setAttribute("patpassport", patpassport);
		request.setAttribute("patidno1", patidno1);
		request.setAttribute("patidno2", patidno2);
		request.setAttribute("roomType", roomType);
		
		//response.sendRedirect( "online_admission_cash_eps_note.jsp?admissionID="+admissionID+"&patidno1="+patidno1+"&roomType="+roomType+"&language="+language );
		request.getRequestDispatcher("online_admission_cash_eps_note.jsp").forward(request, response);
	} else {
		//AdmissionDB.sendEmailAutoNotifyClientPayment( admissionID, "in") ;
		action = "online_admission_submit.jsp";
		response.sendRedirect( action + "?language=" + language );
	}
%>
