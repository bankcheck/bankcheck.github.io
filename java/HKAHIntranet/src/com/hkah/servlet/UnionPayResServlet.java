package com.hkah.servlet;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hkah.util.payment.UnionPayConf;
import com.hkah.web.db.AdmissionDB;

/**
 * Name:Payment Response Class
 * Function:Servlet model,It is suggested that the frontend and backend notification is implemented by two classes.
 * The fronted notification is used for browser skip and the backend notification is used for database process. 
 * Class attribute:Public Class
 * Version:1.0
 * Date:2011-03-11
 * Writer:UPOP Team
 * Copyright:UnionPay
 * Note:The following code is just a sample for testing,acquirer and merchant can coding by themselves on the basis of the interface specificationg.
 *       The code is just for reference.
 * */
public class UnionPayResServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -6247574514957274823L;

	public void init() {

	}

	// hi
	public void service(HttpServletRequest request, HttpServletResponse response) throws IOException {
		System.out.print("UnionPayResServlet started");
		try {
			request.setCharacterEncoding(UnionPayConf.charset);
		} catch (UnsupportedEncodingException e) {
		}
		
		//String[] resArr = new String[UnionPayConf.notifyVo.length]; 
		//for(int i=0;i<UnionPayConf.notifyVo.length;i++){
		//	resArr[i] = request.getParameter(UnionPayConf.notifyVo[i]);
		//}
		String orderNumber = request.getParameter("orderNumber");
		String respCode = request.getParameter("respCode");
		String traceNumber = request.getParameter("traceNumber");
		String orderAmount = request.getParameter("orderAmount");
		//
		
		String signature = request.getParameter(UnionPayConf.signature);
		String signMethod = request.getParameter(UnionPayConf.signMethod);
		
		// stand by variable , should be as same as parameter notifyVo [8] : orderNumber
		String admissionID = request.getParameter("admissionID");
		
		//response.setContentType("text/html;charset="+UnionPayConf.charset);   
		//response.setCharacterEncoding(UnionPayConf.charset);
	    /*
		try {
			Boolean signatureCheck = new UnionPayUtils().checkSign(resArr, signMethod, signature);
			response.getWriter()
			.append("If the signature is correct:"+ signatureCheck)
			.append("<br>If the   transaction is successful"+"00".equals(resArr[10]));
			if(!"00".equals(resArr[10])){
				response.getWriter().append("<br>Unsuccessful reasons:"+resArr[11]);
			}
		} catch (IOException e) {
			
		}
	
		response.setStatus(HttpServletResponse.SC_OK);
		*/

	    boolean updatePaymentStatus = false;

		// update back payment success status to hat_patient table
		// stop at here
	                                                          // orderNumber, 'Y', respCode, traceNumber ( unique for each transaction )
	    updatePaymentStatus = AdmissionDB.updatePaymentReturn( orderNumber, "Y", respCode, traceNumber, "UPOP", null, traceNumber, orderAmount, null ) ;
	    if ("00".equals( respCode ) ) {
			response.sendRedirect("admission_payment_receipt.jsp?admissionID=" + orderNumber + "&receiptNo=" + traceNumber + "&amount=" + orderAmount) ;
		} else {
			System.out.print("Upop return Error !");
			response.sendRedirect("admission_payment_error.jsp");
		}
		
	}

}
