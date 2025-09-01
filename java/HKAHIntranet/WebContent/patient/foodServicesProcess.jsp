<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%!
	private ArrayList fetchMenuItem(String itemCode) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ITEM_CODE, ITEM_NAME1, ITEM_NAME2, CURRENCY, UNIT_PRICE, KITCHEN ");
		sqlStr.append("FROM   DIT_MENU_ITEM ");
		sqlStr.append("WHERE  ITEM_CODE = '");
		sqlStr.append(itemCode);
		sqlStr.append("' ");
		sqlStr.append("AND   (SYSDATE BETWEEN EFFECTIVE_DATE AND NVL(EXPIRED_DATE, SYSDATE) ) ");
		sqlStr.append("ORDER BY ITEM_CODE");
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> fetchItemOpt(String optCode) {
		// fetch fund
		String[] tmp = optCode.split("@");
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT OPT_CODE, OPT_NAME1, OPT_NAME2 ");
		sqlStr.append("FROM   DIT_ITEM_OPT ");
		sqlStr.append("WHERE  OPT_CODE = '");
		sqlStr.append(tmp[1]);
		sqlStr.append("' ");
		sqlStr.append("AND COMP_CODE = '");
		sqlStr.append(tmp[0]);
		sqlStr.append("' ");

		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}

	private String fetchExtraPrice(String itemCode) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT UNIT_PRICE ");
		sqlStr.append("FROM DIT_MENU_ITEM ");
		sqlStr.append("WHERE ITEM_CODE = '"+itemCode+"' ");
		sqlStr.append("AND   (SYSDATE BETWEEN EFFECTIVE_DATE AND NVL(EXPIRED_DATE, SYSDATE) ) ");

		ArrayList result = UtilDBWeb.getReportableListFSD(sqlStr.toString());

		if (result.size() > 0) {
			ReportableListObject row = null;
			row = (ReportableListObject)result.get(0);

			String extraPrice = row.getValue(0);

			if (extraPrice.length() > 0 && Double.parseDouble(extraPrice) < 0.0) {
				return extraPrice;
			} else {
				return "0";
			}
		} else {
			return "0";
		}
	}

	private int getOptCnt(String itemCode, String compCode) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT OPT_CNT ");
		sqlStr.append("FROM   DIT_ITEM_COMP ");
		sqlStr.append("WHERE  ITEM_CODE = '"+itemCode+"' ");
		sqlStr.append("AND COMP_CODE = '"+compCode+"' ");

		ArrayList result = UtilDBWeb.getReportableListFSD(sqlStr.toString());

		if (result.size() > 0) {
			ReportableListObject row = null;
			row = ( ReportableListObject) result.get(0);

			if (row.getValue(0).equals("") || row.getValue(0).length() <= 0) {
				return 999;
			} else {
				return Integer.parseInt(row.getValue(0));
			}
		} else {
			return 999;
		}
	}

	private ArrayList getExtraPriceOfOpt(String optCode) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT PRICE_WITHIN, PRICE_PLUS ");
		sqlStr.append("FROM   DIT_ITEM_OPT ");
		sqlStr.append("WHERE  OPT_CODE = '"+optCode+"' ");

		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
	
	public static boolean isLCBOrderExist(String isLCB, String regID, String serveType, String serveDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(*) FROM DIT_ORDER_HDR ");
		sqlStr.append("WHERE REGID='"+regID+"' ");
		sqlStr.append(" AND SERVE_DATE = TO_DATE('"+serveDate+"','dd/mm/yyyy')  ");
		sqlStr.append(" AND SERVE_TYPE IN ('B','D', 'L') AND SERVE_TYPE='"+serveType+"' ");
		String count = null;
		ArrayList result = UtilDBWeb.getReportableListFSD(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = null;
			row = ( ReportableListObject) result.get(0);
			count = row.getValue(0);
		}
		return ("true".equals(isLCB) && !"0".equals(count));
	}
%>
<%
//System.out.println("Ordering Food..............");

UserBean userBean = new UserBean(request);
boolean isTW = ConstantsServerSide.isTWAH();
if (userBean == null || !userBean.isLogin()) {
	if (isTW) {
		%>
		<script>
			window.open("../foodtw/index.jsp", "_self");
		</script>
		<%
	} else {
		%>
		<script>
			window.open("../patient/index.jsp", "_self");
		</script>
		<%
	}

	return;
}

String MenuType = request.getParameter("selectedMenuType");
String ItemCode = request.getParameter("selectedItemCode");
String OptCode = TextUtil.parseStrUTF8(java.net.URLDecoder.decode(ParserUtil.getParameter(request, "selectedOptCode")));
String ItemAmount = request.getParameter("selectedItemAmount");
String serveTime = request.getParameter("serveTime");
//System.out.println(serveTime);
String serveType = request.getParameter("serveType");
String orderType = request.getParameter("orderType");
String serveHour = request.getParameter("h");
String serveMin = request.getParameter("m");
String editOrderNo = request.getParameter("orderNo");
String custom = request.getParameter("custom");
String isLCB = request.getParameter("isLCB");
boolean customInput = custom != null && custom.length() > 0 && custom.equals("Y");
String patNo = null;
String romCode = null;
String bedCode = null;
String regID = null;
String ward = null;
String patName = null;
String allergy = null;

//String orderRmk = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "orderRmk"));

Calendar cal = Calendar.getInstance();
Calendar cal30 = Calendar.getInstance();
cal30.add(Calendar.MINUTE, 30);

SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy", Locale.ENGLISH);
SimpleDateFormat sdfTime = new SimpleDateFormat("hh:mm", Locale.ENGLISH);
SimpleDateFormat sdfTime24 = new SimpleDateFormat("HH:mm", Locale.ENGLISH);

String now30Time = sdfTime24.format(cal30.getTime());

/*
System.out.println("OptCode: "+OptCode);
System.out.println(MenuType);
System.out.println(ItemCode);
System.out.println(ItemAmount);
System.out.println(serveTime);
System.out.println(serveType);
System.out.println(serveHour);
System.out.println(serveMin);
System.out.println(sdf.format(cal.getTime()));
*/
String [] selectedMenuType = MenuType.split(",");
String [] selectedItemCode = ItemCode.split(",");
String [] selectedOptCode = OptCode.split(",");
String [] selectedItemAmount = ItemAmount.split(",");

if (isTW) {
	if (custom != null && custom.length() > 0 && custom.equals("Y")) {
		patNo = request.getParameter("patNo");
		romCode = request.getParameter("romCode");
		bedCode = request.getParameter("bedCode");
		ward = request.getParameter("ward");
		patName = request.getParameter("patName");
		allergy = request.getParameter("allergy");
	} else {
		patNo = request.getParameter("patNo");
		romCode = request.getParameter("romCode");
		bedCode = request.getParameter("bedCode");
		regID = request.getParameter("regID");
	}
} else {
	patNo = userBean.getLoginID();
	romCode = userBean.getRemark1();
	bedCode = userBean.getRemark2();
	regID = userBean.getRemark3();
}

boolean success = true;

ReportableListObject row = null;
String orderNo = null;

int itemSeq = 0;
double totalAmount = 0;
boolean edit = false;
String itemType = null;

//if (userBean == null || !userBean.isLogin()) {
	%><%-- <jsp:forward page="../patient/index.jsp" /> --%><%
//} else {

	StringBuffer message = new StringBuffer();
	String items = "";
	if (!isLCBOrderExist(isLCB,regID,serveType,(serveTime.equals("now")?sdf.format(cal.getTime()):serveTime))){
	
			ArrayList result = UtilDBWeb.getReportableListFSD(
					"SELECT LPAD((SEQ_NO + 1), 8, '0') FROM AH_SYS_SEQ WHERE SYS_ID = 'DIT' AND SEQ_CODE = 'OrderNo'");
			if (result.size() > 0) {
				row = (ReportableListObject) result.get(0);
				if (!customInput) {
					if (editOrderNo != null && editOrderNo.length() > 0) {
						orderNo = editOrderNo;
		
						UtilDBWeb.updateQueueFSD(
								"DELETE FROM DIT_ORDER_DTL WHERE ORDER_NO = ? ",
										new String[] {orderNo});
						edit = true;
					} else {
						orderNo = row.getValue(0);
						// update seq
						UtilDBWeb.updateQueueFSD(
								"UPDATE AH_SYS_SEQ SET SEQ_NO = ?, UPDATE_DATE = SYSDATE WHERE SYS_ID='DIT' AND SEQ_CODE = 'OrderNo'",
								new String[] { orderNo} );
					}
				}
		
				message.append("<table><tr align='center'><td colspan='2'>Order Summary</td></tr><tr><td colspan='2'><HR></td></tr>");
				message.append("<tr><td>Patient: <b>");
				message.append(userBean.getUserName());
				message.append("</b></td><td>Rm: <b>");
				message.append(userBean.getDeptCode());
				message.append("</b></td></tr><tr><td>HN: <b>");
				message.append(userBean.getStaffID());
				message.append("</b></td><td>Server Time: <b>"+(serveTime.equals("now")?
						"Now":(serveTime.equals("now30")?"NOW+30":
							"TO_DATE('"+serveTime+"', 'DD-MM-YYYY')")+"</b></td></tr>"));
		
				// calculate amount
				for (int i = 0; i < selectedItemCode.length; i++) {
					result = fetchMenuItem(selectedItemCode[i]);
					String itemCode = null;
					String itemName1 = null;
					String itemName2 = null;
					String currency = null;
					String unitPrice = null;
					String kitchen = null;
					StringBuffer itemOpt = new StringBuffer();
					String amount = null;
					StringBuffer itemOptName1 = new StringBuffer();
					StringBuffer itemOptName2 = new StringBuffer();
					Double extraPrice = 0.0;
					Double optExtraPrice = 0.0;
		
					if (result.size() > 0) {
						row = (ReportableListObject) result.get(0);
						itemCode = selectedItemCode[i];
						itemName1 = row.getValue(1);
						itemName2 = row.getValue(2);
						currency = row.getValue(3);
						unitPrice = row.getValue(4);
						kitchen = row.getValue(5);
						amount = selectedItemAmount[i];
						itemType = selectedMenuType[i];
		
						StringBuffer eng = new StringBuffer();
		
						itemOptName1.append(itemName1);
						itemOptName1.append("\r\n");
						itemOptName1.append(itemName2);
						itemOptName2.append(itemName2);
						eng.append(itemName1);
		
						if (itemType.equals("I"))
							unitPrice = null;
		
						if (itemType.equals("S")) {
							itemOptName2.append(itemName1);
							if (!selectedOptCode[i].equals("null")) {
								itemOpt.append(selectedOptCode[i].replaceAll(" ", ConstantsVariable.PLUS_VALUE));
		
								String item[] = selectedOptCode[i].split(" ");
		
								for (int c = 0; c < item.length; c++) {
									String curItem = item[c];
									String curItemInfo[]= curItem.split("\\.");
		
									if (curItem.indexOf(".") > -1) {
										curItem = curItem.split("\\.")[0];
									}
									//System.out.println(curItem);
									extraPrice += Double.parseDouble(fetchExtraPrice(curItem))*-1;
								}
							}
						} else {
							if (!selectedOptCode[i].equals("null")) {
								String temp = selectedOptCode[i].toString();
								String[] tempOpt = new String[99];
								int counter = 0;
		
								while(temp.indexOf(".") > -1) {
									tempOpt[counter] = temp.substring(0, temp.indexOf("."));
									temp = temp.substring(temp.indexOf(".")+1);
									counter++;
								}
								tempOpt[counter] = temp;
		
								//System.out.println(temp);
								//System.out.println(tempOpt.length);
		
								if (itemType.equals("M")) {
									String curCompCode = "";
									int maxChoice = 0;
									int curSelect = 0;
		
									for (int c = 0; c < counter+1; c++) {
										//System.out.println(tempOpt[c]);
										String information[] = tempOpt[c].split("@");
										if (information.length > 1) {
											if (!information[0].equals(curCompCode)) {
												curCompCode = information[0];
												maxChoice = getOptCnt(selectedItemCode[i], curCompCode);
												curSelect = 0;
											}
		
											curSelect++;
											ArrayList optPrice = getExtraPriceOfOpt(information[1]);
											if (optPrice.size() > 0) {
												ReportableListObject optPriceRow = null;
												optPriceRow = (ReportableListObject)optPrice.get(0);
		
												if (curSelect <= maxChoice) {
													optExtraPrice += Double.parseDouble(optPriceRow.getValue(0));
												} else {
													optExtraPrice += Double.parseDouble(optPriceRow.getValue(1));
												}
											}
										}
									}
								}
		
								for (int c = 0; c < counter+1; c++) {
									itemOptName1.append(ConstantsVariable.SPACE_VALUE);
									itemOptName1.append("\r\n");
									itemOptName1.append(ConstantsVariable.PLUS_VALUE);
									itemOptName2.append(ConstantsVariable.PLUS_VALUE);
		
									if (tempOpt[c].indexOf("@") > -1) {
										itemOpt.append(tempOpt[c].split("@")[1]+".");
										result = fetchItemOpt(tempOpt[c]);
		
										if (result.size() > 0) {
											row = (ReportableListObject) result.get(0);
											itemOptName1.append(row.getValue(1));
											itemOptName1.append(" (");
											itemOptName1.append(row.getValue(2));
											itemOptName1.append(")");
											itemOptName2.append(row.getValue(2));
											eng.append(ConstantsVariable.PLUS_VALUE);
											eng.append(row.getValue(1));
										}
									} else {
										itemOpt.append(tempOpt[c]+".");
										itemOptName1.append(tempOpt[c]);
										itemOptName2.append(tempOpt[c]);
										eng.append(ConstantsVariable.PLUS_VALUE);
										eng.append(tempOpt[c]);
									}
								}
								itemOptName2.append("\r\n");
								itemOptName2.append(eng);
		
								String tmpOpt = itemOpt.toString().substring(0, itemOpt.length()-1);
								itemOpt = new StringBuffer();
								itemOpt.append(tmpOpt);
		
							} else {
								itemOptName2.append("\r\n");
								itemOptName2.append(itemName1);
							}
						}
					}
					// append item information
					message.append("<tr><td><b>");
					message.append(itemName1);
					message.append("<BR/>");
					message.append(itemName2);
					message.append("</b> x "+amount+" </td><td>");
					message.append(currency);
					message.append(unitPrice);
					message.append("</td></tr>");
		
					if (unitPrice != null)
						totalAmount += (Double.parseDouble(unitPrice)+extraPrice+optExtraPrice) * Integer.parseInt(amount);
		
					//System.out.println("patNo: "+patNo);
					//System.out.println("romCode: "+romCode);
					//System.out.println("bedCode: "+bedCode);
					//System.out.println("regID: "+regID);
					//System.out.println("itemType: "+itemType);
					//System.out.println("itemCode: "+itemCode);
					//System.out.println("itemOpt: "+itemOpt.toString());
					//System.out.println("itemOptName1: "+itemOptName1.toString());
					//System.out.println("itemOptName2: "+itemOptName2.toString());
					//System.out.println("amount: "+amount);
					//System.out.println("currency: "+currency);
					//System.out.println("AMOUNT: "+unitPrice);
					//System.out.println("BILLAMT: "+unitPrice);
		//			System.out.println("kitchen: "+kitchen);
		
					String price = null;
					String bill = null;
					if (unitPrice != null) {
						price = String.valueOf((Double.parseDouble(unitPrice)+optExtraPrice) * Integer.parseInt(amount));
						bill = String.valueOf((Double.parseDouble(unitPrice)+extraPrice+optExtraPrice) * Integer.parseInt(amount));
					}
					
					if (orderType.equals("P")) {
						bill = "0";
					}
					if (orderType.equals("L")) {
						bill = String.valueOf(Math.round(Double.parseDouble(bill) / 2.0));
					}
					
					// insert order dtl table
					if (isTW) {
						if (customInput) {
							items += (itemType.equals("M")?(itemCode+"."+itemOpt.toString()):(itemCode+"+"+itemOpt.toString()))+
										(items.length() > 0?", ":"");
						} else {
							UtilDBWeb.updateQueueFSD(
								"INSERT INTO DIT_ORDER_DTL (ORDER_NO, ITEM_SEQ, ITEM_TYPE, ITEM_CODE, ITEM_OPT, ITEM_NAME1, ITEM_NAME2, ORDER_QTY, CURRENCY, AMOUNT, BILLAMT, KITCHEN, READY_QTY, UPDATE_USER, UPDATE_DATE )" +
								"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, SYSDATE)",
								new String[] { orderNo, String.valueOf(i+1), itemType, itemCode, itemOpt.toString(), itemOptName1.toString(), itemOptName2.toString(),  amount, currency, price, bill, kitchen, "WEB" } );
						}
					} else {
						/*
						UtilDBWeb.updateQueueFSD(
								"INSERT INTO DIT_ORDER_DTL (ORDER_NO, ITEM_SEQ, ITEM_TYPE, ITEM_CODE, ITEM_OPT, ITEM_NAME1, ITEM_NAME2, ORDER_QTY, CURRENCY, AMOUNT, BILLAMT, KITCHEN, READY_QTY, UPDATE_USER, UPDATE_DATE )" +
								"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, SYSDATE)",
								new String[] { orderNo, String.valueOf(i+1), itemType, itemCode, itemOpt.toString(), itemOptName1.toString(), itemOptName2.toString(),  amount, currency, price, price, kitchen, "patient" } );
						*/
					}
				}
		
				//message.append("<tr><td>Remark: </td><td>"+orderRmk+"</td></tr>");
				message.append("<tr><td colspan='2'>&nbsp;</td></tr>");
				message.append("<tr><td>&nbsp;</td><td>Total: <b>");
				message.append(totalAmount<0?0:totalAmount);
				message.append("</b></td></tr>");
				message.append("<tr><td>&nbsp;</td><td>Order: <b>");
				message.append(orderNo);
				message.append("</b></td></tr>");
		
				//System.out.println("totalAmount: "+totalAmount);
				//System.out.println("orderNo: "+orderNo);
				//System.out.println("SERVE TIME: "+(serveTime.equals("now")?"TO_DATE('"+sdf.format(cal.getTime())+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS')":"TO_DATE('"+serveTime+"', 'DD-MM-YYYY')"));
				// insert order hdr table
		
				try {
					if (isTW) {
						if (customInput) {
							 PatientDB.addTempFoodOrder(userBean, patNo, patName, orderType, ward,
									romCode, bedCode, allergy,
									serveType+": "+items+"<br/>Serve Date: "+(serveTime.equals("now")?sdf.format(cal.getTime()):serveTime)+
									"<br/>Serve Time: "+(serveTime.equals("now")?sdfTime.format(cal.getTime()):" "+(serveHour+":"+serveMin)),
									(serveTime.equals("now")?sdf.format(cal.getTime()):serveTime)); 
						} else {
							if (edit) {
								//System.out.println(serveType);
								
								UtilDBWeb.updateQueueFSD(
										"UPDATE DIT_ORDER_HDR " +
										" SET SERVE_DATE = " 
										+ (serveTime.equals("now")?
												"SYSDATE":
												(serveTime.equals("now30")?"SYSDATE":	
													("TO_DATE('"+serveTime+"', 'DD-MM-YYYY')")) 
										   ) 
										+", "+
										" SERVE_TIME = '"+
										(serveTime.equals("now")?serveTime:
											(serveTime.equals("now30")?now30Time:(serveHour+":"+serveMin))
										)
										+"', "+
										" SERVE_TYPE = '"+serveType+"', "+
										" STATUS = 'X', "+
										" CREATE_DATE = SYSDATE, "+
										" DITCODE = '"+PatientDB.getInpatientAllergy(patNo, null)+"', "+
										" UPDATE_DATE = SYSDATE, "+
										" ORDER_TYPE = '" + orderType + "', "+
										" CREATE_USER = '"+userBean.getLoginID()+"', "+
										" UPDATE_USER = 'WEB' "+
										//" SLPAMT = '"+String.valueOf(totalAmount)+"' "+
										" WHERE ORDER_NO = '" + orderNo +"'");
								
							} else {
								UtilDBWeb.updateQueueFSD(
										"INSERT INTO DIT_ORDER_HDR (ORDER_NO, ORDER_TYPE, STATUS, PATNO, SERVE_DATE, SERVE_TYPE, SERVE_TIME, ROMCODE, BEDCODE, DITCODE, CREATE_USER, CREATE_DATE, UPDATE_USER, UPDATE_DATE, REGID, SLPAMT)" +
										"VALUES (?, ?, 'X', ?, SYSDATE, ?, ?, ?, ?, ?, ?, SYSDATE, ?, SYSDATE, ?, ?)",
										new String[]
										 { orderNo,
											orderType,
											patNo,
											//(serveTime.equals("now")?"TO_DATE('"+sdf.format(cal.getTime())+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS')":"TO_DATE('"+serveTime+"', 'DD-MM-YYYY')"),
											serveType,
											(serveTime.equals("now")?serveTime:
												(serveTime.equals("now30")?now30Time:
												(serveHour+":"+serveMin))	
											),
											romCode,
											bedCode,
											PatientDB.getInpatientAllergy(patNo, null),
											userBean.getLoginID(),
											"WEB",
											regID,
											""} );
		
								UtilDBWeb.updateQueueFSD(
														"UPDATE DIT_ORDER_HDR " +
														" SET SERVE_DATE = " + 
														(serveTime.equals("now")?
																"TO_DATE('"+sdf.format(cal.getTime())+"', 'DD-MM-YYYY')":
																(serveTime.equals("now30")?
																"TO_DATE(SYSDATE + (.000694 * 31)) "
																:("TO_DATE('"+serveTime+"', 'DD-MM-YYYY')"))	
														) +
														" WHERE ORDER_NO = '" + orderNo +"'");
							}
		
							UtilDBWeb.updateQueueFSD(
									"INSERT INTO AH_SYS_LOG (SYS_ID, SYS_TIME, USER_ID, USER_DEPT, USER_TEAM, KEYWORD, DESCRIPTION, PCNAME) "+
									"VALUES ('WEB', SYSDATE, ?, ?, 'USR', 'WEB', ?, 'WEB')",
									new String[]
							           {
											userBean.getStaffID(),
											userBean.getDeptCode(),
											"Order No: "+orderNo+" Create: "+!edit+" Edit: "+edit+" ("+userBean.getUserName()+")"+" Serve Date:"+serveTime
											+" Serve Time:"
											+(serveTime.equals("now")?serveTime:
												(serveTime.equals("now30")?"TO_DATE(SYSDATE + (.000694 * 31)) ":(serveHour+":"+serveMin))
											  )
							           });
						}
					} else {
						/*
						UtilDBWeb.updateQueueFSD(
								"INSERT INTO DIT_ORDER_HDR (ORDER_NO, ORDER_TYPE, STATUS, PATNO, SERVE_DATE, SERVE_TYPE, SERVE_TIME, ROMCODE, BEDCODE, CREATE_USER, CREATE_DATE, UPDATE_USER, UPDATE_DATE, REGID, SLPAMT)" +
								"VALUES (?, 'I', 'X', ?, SYSDATE, ?, ?, ?, ?, 'WEB', SYSDATE, 'WEB', SYSDATE, ?, ?)",
								new String[]
								 { orderNo,
									patNo,
									//(serveTime.equals("now")?"TO_DATE('"+sdf.format(cal.getTime())+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS')":"TO_DATE('"+serveTime+"', 'DD-MM-YYYY')"),
									serveType,
									(serveTime.equals("now")?serveTime:(serveHour+":"+serveMin)),
									romCode,
									bedCode,
									regID,
									String.valueOf(totalAmount)} );
		
						UtilDBWeb.updateQueueFSD(
												"UPDATE DIT_ORDER_HDR " +
												" SET SERVE_DATE = " + (serveTime.equals("now")?"TO_DATE('"+sdf.format(cal.getTime())+"', 'DD-MM-YYYY')":"TO_DATE('"+serveTime+"', 'DD-MM-YYYY')") +
												" WHERE ORDER_NO = '" + orderNo +"'");
						*/
					}
				}
				catch(Exception e) {
					success = false;
				}
		
				message.append("</table>");
				/*
				try {
					UtilMail.sendMail(
							ConstantsServerSide.MAIL_ALERT,
							isTW?"andrew.lau@twah.org.hk":"andrew.lau@hkah.org.hk",
							"Food Services Order from Patient " + userBean.getUserName() + " (" + userBean.getLoginID() + ")",
							"customInput:"+customInput+"<br/>"+"edit:"+edit+"<br/>"+message.toString());
				} catch(Exception e) {
					success = false;
				}
				*/
			}
		} else {
			success = false;
		}
//}
%>
<% if (success) {%>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>
		<div id="orderSuccess" style="display:none"><%=success %></div>
		<label class="text"><b>&nbsp;Order:&nbsp;<%=(orderNo!=null && orderNo.length()>0)?orderNo:"" %></b></label>
	</td>
</tr>
<% } else {
		if("true".equals(isLCB)) {%>
			<%="LCB"+success%>				
<%		} else {%>

			<%=success %>
	
<% 		}
	}%>
<%--
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>

<%--
<%@ page language="java" contentType="text/html; charset=big5"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<body>
<jsp:include page="../patient/checkSession.jsp" />
<form name="form1">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td></tr>
<jsp:include page="../patient/patientInfo.jsp" />
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><img src="../images/food.jpg"><br/><span class="enquiryLabel extraBigText">Food Services</span></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><span class="bigText"><%=message %></span></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><b>Thank you for your order. Out staff will contact you shortly.</b></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><button onclick="return submitAction();"><img src="../images/undo2.gif">&nbsp;Back to Patient Menu</button></td></tr>
</table>
</form>
<script language="javascript">
	function submitAction() {
		document.form1.action = "../patient/main.jsp";
		document.form1.submit();
	}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
 --%>