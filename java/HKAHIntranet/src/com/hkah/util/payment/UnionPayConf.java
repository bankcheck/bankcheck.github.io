package com.hkah.util.payment;

/**
 * Name: payment Configuration Class
 * Function: configuration Class 
 * Class: attribute public Class
 * Version: 1.0
 * Date:2011-03-11
 * Writer:UPOP Team
 * Copyright: UnionPay
 * Note: The following code is just a sample for testing,acquirer and merchant can coding by themselves on the basis of the interface specificationg.
 *       The code is just for reference.
 * */

public class UnionPayConf {

	// Version
	public final static String version = "1.0.0";

	// Character Conding
	public final static String charset = "UTF-8";

	// Basic Url(Please modify correspondingly)

	/* System link environment*/
	//private final static String UPOP_BASE_URL = "http://222.66.233.201/UpopWeb/api/";
	//private final static String UPOP_BASE_URL = "http://58.246.226.99/UpopWeb/api/";

	/* Testing environment */
	//private final static String UPOP_BASE_URL = "https://101.231.204.80:5000/gateway/api/frontTransReq.do";
	private final static String UPOP_BASE_URL = "https://202.101.25.184/UpopWeb/api/";
	//private final static String UPOP_BASE_URL = "https://www.epay.lxdns.com/UpopWeb/api/";

	/* Online environment */
	//private final static String UPOP_BASE_URL = "https://unionpaysecure.com/api/";

	// Purchase and Pre-authorization Transaction URL
	public final static String gateWay = UPOP_BASE_URL + "Pay.action";

	// Refund, Purchase cancellation, Pre-authorization cancellation, Pre-authorization completion and Pre-authorization completion cancellation Transaction URL
	public final static String backStagegateWay = UPOP_BASE_URL + "BSPay.action";

	// Inquiry URL
	public final static String queryUrl = UPOP_BASE_URL + "Query.action";

	// Merchant Code
	public final static String merCode = "505034480624069";
	//public final static String merCode = "105550149170027";
	//public final static String merCode = "TESTHASEMIGS";
	//public final static String merCode = "D0E9C019";  

	// Merchant Name
	//public final static String merName = "Name of user shop";
	public final static String merName = "SEVENTH-DAY ADVENTIST CORP(HK)";

	public final static String merFrontEndUrl = "https://www.hkah.org.hk/";

	public final static String merBackEndUrl = "https://www.hkah.org.hk/";

	// Encryption mode 
	public final static String signType = "MD5";
	public final static String signType_SHA1withRSA = "SHA1withRSA";

	// Shop key, required to have the same configuration as  that on the UnionPay merchant manage website 
	public final static String securityKey = "88888888";
	//public final static String securityKey = "625817C6765F0EE7AE968D523A7B41B5";
	// MD5( "625817C6765F0EE7AE968D523A7B41B5" ) ;
	//public final static String securityKey = "c212989189c03c8e329811d2c53db3c4" ;

	// Signature 
	public final static String signature = "signature";
	public final static String signMethod = "signMethod";

	//Assemble the purchase request packet 
	public final static String[] reqVo = new String[]{
			"version",
            "charset",
            "transType",
            "origQid",
            "merId",
            "merAbbr",
            "acqCode",
            "merCode",
            "commodityUrl",
            "commodityName",
            "commodityUnitPrice",
            "commodityQuantity",
            "commodityDiscount",
            "transferFee",
            "orderNumber",
            "orderAmount",
            "orderCurrency",
            "orderTime",
            "customerIp",
            "customerName",
            "defaultPayType",
            "defaultBankNumber",
            "transTimeout",
            "frontEndUrl",
            "backEndUrl",
            "merReserved"
	};

	public final static String[] notifyVo = new String[]{
            "charset",
            "cupReserved",
            "exchangeDate",
            "exchangeRate",
            "merAbbr",
            "merId",
            "orderAmount",
            "orderCurrency",
            "orderNumber",
            "qid",
            "respCode",
            "respMsg",
            "respTime",
            "settleAmount",
            "settleCurrency",
            "settleDate",
            "traceNumber",
            "traceTime",
            "transType",
            "version"
	};

	public final static String[] queryVo = new String[]{
		"version",
		"charset",
		"transType",
		"merId",
		"orderNumber",
		"orderTime",
		"merReserved"
	};


}
