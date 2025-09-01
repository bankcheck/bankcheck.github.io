<%@ page import="com.hkah.util.*"%>

<%@ page import="java.util.HashMap,
                 java.io.IOException,
                 com.chilibrain.unionpay.FrontEndService,
                 com.chilibrain.unionpay.UPOP,
                 com.chilibrain.unionpay.Util"%>

<%@ page import="java.util.List,
                 java.util.ArrayList,
                 java.util.Collections,
                 java.util.Iterator,
                 java.util.Enumeration,
                 java.security.MessageDigest,
                 java.util.Map,
                 java.net.URLEncoder,
                 java.util.HashMap,
                 java.util.Date,
                 java.text.SimpleDateFormat
                 "%>
                                  
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
	//System.out.println("[DEBUG] upop payment start");

	String patidno1 = TextUtil.parseStr(ParserUtil.getParameter(request, "patidno1")).toUpperCase();
	String patidno2 = TextUtil.parseStr(ParserUtil.getParameter(request, "patidno2")).toUpperCase();
	String roomType = ParserUtil.getParameter(request, "roomType");
	String admissionID = ParserUtil.getParameter(request, "admissionID");
	String vpc_Amount = ParserUtil.getParameter(request, "vpc_Amount");
	
	String language = ParserUtil.getParameter(request, "language");
		
//20180913 Arran add variables from sysparam
	String upop_mid = null;
	String upop_pfx = null;
	String upop_pw = null;
	String upop_env = null;
	String upop_ret = null;
	
	ArrayList record = AdmissionDB.getUpopParams();
	if (record != null && record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		upop_mid = row.getValue(0);
		upop_pfx = row.getValue(1);
		upop_pw = row.getValue(2);
		upop_env = row.getValue(3);
		upop_ret = row.getValue(4);
	}

		// Define the configuration 
		HashMap<String, Object> UPOPConfigs = new HashMap<String, Object>();

		//UPOPConfigs.put("mid", "598034459991031");
//20180913 Arran change to use sysparam		
		//UPOPConfigs.put("mid", "505034480624069");
		UPOPConfigs.put("mid", upop_mid);
		
//20180823 Arran change cert location
		//UPOPConfigs.put("pfx", "testing.pfx");
		//UPOPConfigs.put("pfx", "C:/cert/testing.pfx");
		UPOPConfigs.put("pfx", upop_pfx);
		
		
		//UPOPConfigs.put("notify_url", "http://client-projects.chilibrain.com/unionpay/php/sample_codes/v2/testing/notify.php");
		//UPOPConfigs.put("notify_url", "http://160.100.2.99:8080/intranet/UnionPayResServlet?admissionID=" + admissionID);
		//System.out.println("http://"+request.getLocalAddr()+":"+request.getLocalPort()+"/intranet/registration/admission_payment_return_upop.jsp?admissionID=" + admissionID  + "&language=" + language);		
		//UPOPConfigs.put("notify_url","http://160.100.2.99:8080/intranet/registration/admission_payment_return_upop.jsp?admissionID=" + admissionID + "&language=" + language) ;
		//UPOPConfigs.put("notify_url","http://"+request.getLocalAddr()+":"+request.getLocalPort()+"/intranet/registration/admission_payment_return_upop.jsp?admissionID=" + admissionID  + "&language=" + language) ;
		UPOPConfigs.put("notify_url", upop_ret + "?admissionID=" + admissionID  + "&language=" + language) ;
	
		//System.out.println("[DEBUG] notify_url: " + upop_ret + "?admissionID=" + admissionID  + "&language=" + language);
		
//20180913 Arran change to use sysparam		
		//UPOPConfigs.put("cert_password", "000000");
		//UPOPConfigs.put("cert_password", "88888888");
		UPOPConfigs.put("cert_password", upop_pw);
		
		// Initialize UPOP object
//20180913 Arran change to use sysparam		
		//UPOP.init("development", UPOPConfigs);
		UPOP.init(upop_env, UPOPConfigs);
		
		// define transaction value
		//String orderId = Util.getCurrentDateTime(); // random generate
//20190530 Arran change to 24HH
		Date now = new Date();
		SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddHHmmss");
		String orderId = ft.format(now);
		
		//System.out.print("Upop order ID : " + orderId);

//20180823 Arran convert amount to x100
		//long orderAmount = Long.parseLong(vpc_Amount);
		long orderAmount = 0;
		
		if (vpc_Amount != null)
			orderAmount = Long.parseLong(vpc_Amount) * 100;
		
		int currency = 344;
		
		// Initialize transaction object: FrontEnd
		FrontEndService fes = UPOP.initFrontEndService();
		
		// Set the purcase parameters
/*		
		System.out.print("Upop order ID : " + orderId);
		System.out.print("Upop order Amount : " + orderAmount);
		System.out.print("Upop order currency : " + currency);
*/
		System.out.println("[REG] UPOP order ID : " + orderId + " Amount : " + orderAmount);
		fes.purchase(orderId, orderAmount, currency);
		
		//response.sendRedirect(fes.getRequestUrl());
		
		// Or you may use below two method to build your own html form:
		//		fes.getRequestParamsOnly()
		//		fes.getRequestUrl()
		
		//String html = fes.createApiRequestFormOnly(); // It will print the html from for UnionPay Request

		
		String html = "<html>" ;
		html = html + "<head>" ;
		
		//html = html + "<script type='text/javascript' src='/intranet/js/jquery-1.5.1.min.js'></script>";
		//html = html + "<script src='https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js'></script>";
		//html = html + "<script type='text/javascript'> $(document).ready( function(){ alert($('form#pay_form').prop('name')) ; $('form#pay_form').submit() ; } );</script>" ;
		//html = html + "<script type='text/javascript'> $(document).ready( function(){ $('#unionpay-submit').click(); } );</script>" ;
		//html = html + "<script type='text/javascript'> $(document).ready( function(){ alert($('form#pay_form').action ); } );</script>" ;
		
		html = html + "</head>";
		html = html + "<body>";
		html = html + "<script language=\"javascript\"> window.onload=function(){document.pay_form.submit();}</script>\n" ;
		html = html + "You will be redirected to Unionpay gateway shortly.<br>"; 
		html = html + fes.createApiRequestFormOnly();
		// if below html element is exists, the forward action will become a popup and will be blocked by browser, so need to remove it
		html = html.replace("target=\"_blank\"","");
		//html = html + "<form id='pay_form' name='pay_form' action='http://www.oracle.com' method='get'></form>";
		html = html + "</body>";
		html = html + "</html>";
		
		response.setContentType("text/html;charset=UTF-8");   
		response.setCharacterEncoding("UTF-8");
		try {
			response.getWriter().write(html);
		} catch (IOException e) {
			
		}
		
		response.setStatus(HttpServletResponse.SC_OK);
		System.out.println("[REG] Union Payment started");	
%>