package com.hkah.client.util;

import java.util.HashMap;
import java.util.Map;

import com.google.gwt.core.client.GWT;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.dialog.DlgBrowserPanel;
import com.hkah.client.layout.dialog.DlgPDFPanel;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.constants.ConstantsVariable;;


public class AppStmtUtil {
	
	static String returnStr = null;
	private static DlgPDFPanel viewPDFPanel = null;

	
	private static DlgPDFPanel getViewPDFPanel() {
		if(viewPDFPanel == null) {
			viewPDFPanel = new DlgPDFPanel();
			
		}
		return viewPDFPanel;
		
	}
	
	public static void createAppBill(boolean isCreateBill, final String remark, final String stmtType, String isDisablePayment, final String slpNo,
								final Map<String,String> map, final String patNo ) {
		if(isCreateBill) {
			QueryUtil.executeMasterAction(Factory.getInstance().getMainFrame().getUserInfo(), "APPBILL_SLIP", QueryUtil.ACTION_APPEND,
					new String[] {slpNo,stmtType, remark,isDisablePayment,  Factory.getInstance().getMainFrame().getUserInfo().getUserID()},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if("IR".equals(stmtType)) {
							//Factory.getInstance().addInformationMessage("Post Succeed.");
						}
						
						final String billID = mQueue.getReturnCode();
						if (stmtType.startsWith("I")) {
							AppStmtUtil.genIPStatement(slpNo, billID, patNo, remark, map);
						}


					} else {
						//Factory.getInstance().addErrorMessage(mQueue, getPkgCode());
					}
				}
			});
		}
	}
	
	
	public static void closeSlipRegen(final String patNo, final String slpNo, String billId) {
		QueryUtil.executeMasterBrowse(
				Factory.getInstance().getUserInfo(), "APPBILL", 
				new String[] {"bill", patNo, null, billId},
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if ("O".equals(mQueue.getContentField()[0])) {
								genOPStatement(slpNo, mQueue.getContentField()[1], mQueue.getContentField()[2], null, null);
							} else if ("I".equals(mQueue.getContentField()[0])) {
								genIPStatement(slpNo, mQueue.getContentField()[1], patNo, mQueue.getContentField()[2], null,"N");
							}
						}
					}
				});
	}
	
	public static String previewOPStatement(final String slip, final String remark, final Map<String,String>omap) {
		Report.print(Factory.getInstance().getUserInfo(),
				"OPStatementAPP", omap,
				new String[] {
					slip
				},
				new String[] {
						"SLPNO",
						"PATNO",
						"PATNAME",
						"PATCNAME",
						"DOCNAME",
						"DOCCNAME",
						"TITLE"
				},
				new boolean[] {
						false, false, false, false, false, false, false
				},
				new String[] {"OPSTATEMENT_SUB"},new String[][] { {ConstantsVariable.SINGLE_QUOTE_VALUE+slip+ConstantsVariable.SINGLE_QUOTE_VALUE}},
				new String[][] {
					{
						"STNTDATE",
						"AMOUNT",
						"DESCRIPTION",
						"QTY",
						"ITMFLAG",
						"CDESCCODE"
					}},
					new boolean[][] {
							{
								false,
								true,
								false,
								true,
								false,
								false
							}}, "", true, false, false, false, new CallbackListener() {
								@Override
								public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
									if(ret){
										getViewPDFPanel().showDialog( GWT.getModuleBaseURL().replace("hkahnhs/",result));
									}
								}
							}, null, "APPBILL", false);
		
		return returnStr;
	}

	public static void genOPStatement(final String slip, final String billID, final String remark, final Map<String,String>omap, final String patNo) {
		String slpno = ConstantsVariable.SINGLE_QUOTE_VALUE+slip+ConstantsVariable.SINGLE_QUOTE_VALUE;
		Map<String,String> map = new HashMap<String,String>();
		if (omap != null && omap.size() > 0) {
			map = omap;
		} else {
			map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
			map.put("P_SLPNO", slip );
			map.put("ISCOPY", "Y");
			map.put("RPTTYPE", "Statement");
			map.put("AppWatermark", CommonUtil.getReportImg("app_watermark.gif"));
			map.put("remark", remark);
		}

		Factory.getInstance().addRequiredReportDesc(map,
				new String[] {
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage","Maplanguage"
				},
				new String[] {
					"receipt", "offsta", "PatNo",
					"PatName", "TreDr", "BillNo",
					"Copy", "Page", "Date",
					"Item", "Amount", "HKD",
					"Signature","Diagnosis","OpTreDr"
				},
				(ConstantsVariable.HKAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())?"CTE":"CHT"));


		Report.print(Factory.getInstance().getUserInfo(),
				"OPStatementAPP", map,
				new String[] {
					slip
				},
				new String[] {
						"SLPNO",
						"PATNO",
						"PATNAME",
						"PATCNAME",
						"DOCNAME",
						"DOCCNAME",
						"TITLE"
				},
				new boolean[] {
						false, false, false, false, false, false, false
				},
				new String[] {"OPSTATEMENT_SUB"},new String[][] { {slpno}},
				new String[][] {
					{
						"STNTDATE",
						"AMOUNT",
						"DESCRIPTION",
						"QTY",
						"ITMFLAG",
						"CDESCCODE"
					}},
					new boolean[][] {
							{
								false,
								true,
								false,
								true,
								false,
								false
							}}, "", true, false, false, false, new CallbackListener() {
					@Override
					public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
						if(ret){
							DlgBrowserPanel browserPanel = new DlgBrowserPanel(Factory.getInstance().getMainFrame());
							//browserPanel.showDialog("http://localhost:8080/intranet/mobile/genPatientStmtV2.jsp?slpNo="
							browserPanel.showDialog(Factory.getInstance().getSysParameter("ABillPathW")+"?slpNo="
									+slip+"&patno="+patNo
									+"&baseURL="+GWT.getModuleBaseURL()+"&rptPath="+result
									+"&from=txnDetail&slpType=O&billID="+billID+"&lang="+(ConstantsVariable.HKAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())?"CTE":"CHT"));
							browserPanel.dispose();
						}
					}
				}, null, "APPBILL", false);
	}
	public static void genIPStatement(final String slip, final String billID, final String patNo, final String remark, final Map<String, String> imap) {
		genIPStatement(slip, billID, patNo, remark, imap, "Y");
	}
	
	public static void genIPStatement(final String slip, final String billID, final String patNo, final String remark, final Map<String, String> imap, final String isSendMsg) {
		Map<String,String> map = new HashMap<String,String>();
		if (imap != null && imap.size() > 0) {
			map = imap;
		} else {
			map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
			map.put("P_SLPNO", slip );
			map.put("ALLSLPNO", ConstantsVariable.SINGLE_QUOTE_VALUE+slip+ConstantsVariable.SINGLE_QUOTE_VALUE );
			map.put("ISCOPY", "Y");
			map.put("remark", remark);
		}	
		Factory.getInstance()
			.addRequiredReportDesc(map,
					   new String[] {
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage"
						},
					   new String[] {
								"StaOfAut", "AdmDtTime", "PatName", "DisDtTime",
								"TreDr", "BillNo", "PatNo", "BedNo", "Copy",
								"Page", "Date", "Item", "Amount", "TotChg",
								"TotRfd", "Balance", "patM", "patB", "BirthDt",
								"DelDr"
						},
						(ConstantsVariable.HKAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())?"CTE":"CHT"));

			//map.put("PRNRANGENOTE", "Note: Printing Sequence number "+null);

		map.put("watermark", CommonUtil.getReportImg("app_watermark.gif"));
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));

		Report.print(Factory.getInstance().getUserInfo(), "IPStatementAPP", map,
				new String[] { slip },
				new String[] {
						"PATNAME", "PATCNAME" ,"SLPNO", "PATNO",
						"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
						"INPDTIME", "DOCNAME", "DOCCNAME"
				},
				new boolean[] {
						false, false, false, false, false, false,
						false, false, false, false, false
				},
				new String[] {
						"IPStatement_Sub1",
						"IPStatement_Sub2"
				} ,
				new String[][] {
						{
							ConstantsVariable.SINGLE_QUOTE_VALUE+slip+ConstantsVariable.SINGLE_QUOTE_VALUE, ""
						},
						{
							ConstantsVariable.SINGLE_QUOTE_VALUE+slip+ConstantsVariable.SINGLE_QUOTE_VALUE, ""
						}
				},
				new String[][] {
						{
								"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY",
								"TOTALREFUND", "TOTALCHARGE", "CDESCCODE"
						},
						{
								"ARCCODE", "ARCNAME", "ATXAMT"
						}
				},
				new boolean[][] {
						{
								false, true, false, true, true, true, false
						},
						{
								false, false, true
						}
				}, "", true, false, false, false, new CallbackListener() {
			@Override
			public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
				if(ret){
					getAppChrgSmy(billID,result,slip, patNo, isSendMsg);
				}
			}
		}, null, "APPBILL", false);
	}
	
	private static void getAppChrgSmy(final String billID,final String ipStmtPath, final String slip, final String patNo){
		getAppChrgSmy(billID,ipStmtPath, slip, patNo, "Y");
	}
	
	private static void getAppChrgSmy(final String billID,final String ipStmtPath, final String slip, final String patNo, final String isSendMsg){
		final Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", ConstantsVariable.SINGLE_QUOTE_VALUE+slip+ConstantsVariable.SINGLE_QUOTE_VALUE );
		map.put("ALLSLPNO", ConstantsVariable.SINGLE_QUOTE_VALUE+slip+ConstantsVariable.SINGLE_QUOTE_VALUE );
		map.put("NEWACM", null);

		Factory.getInstance()
			.addRequiredReportDesc(map,
				new String[] {
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage"
				},
				new String[] {
						"TotChgTtl", "Copy", "BillNo", "BedNo", "DisDtTime",
						"PatName", "TreDr", "AdmDtTime", "PatNo", "Page",
						"SpecialFee", "DocCredit", "Credits", "HosCharge",
						"DocCharge", "HosCredit", "Charges", "Refund",
						"SpecialSrv", "Packages", "Balance"
				},
				(ConstantsVariable.HKAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())?"CTE":"CHT"));
		map.put("watermark", CommonUtil.getReportImg("app_watermark.gif"));

		Report.print(Factory.getInstance().getUserInfo(), "ChrgSmyAPP", map,
				 new String[] {
						slip
				 },
				 new String[] {
						"PATNAME", "PATCNAME", "SLPNO", "PATNO",
						"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
						"INPDTIME", "DOCNAME", "DOCCNAME"
				 },
				 new boolean[] {
						false, false, false, false, false, false,
						false, false, false, false, false
				 },
				 new String[] {
						"CHRGSMY_SUB"
				 } ,
				 new String[][] {
						{
							ConstantsVariable.SINGLE_QUOTE_VALUE+slip+ConstantsVariable.SINGLE_QUOTE_VALUE, ""
						}
				 },
				 new String[][] {
						{
								"DESCRIPTION" ,"QTY", "AMOUNT",
								"STNTYPE", "ITMTYPE", "DOCCODE",
								"DOCNAME", "DOCCNAME", "CDESCCODE"
						}
				 },
				 new boolean[][] {
						{
								false, true, false, false, false,
								false, false, false, false
						}
				 },  "", true, false, false, false, new CallbackListener() {
			@Override
			public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
				if(ret){
					DlgBrowserPanel browserPanel = new DlgBrowserPanel(Factory.getInstance().getMainFrame());
					//browserPanel.showDialog("http://localhost:8080/intranet/mobile/genPatientStmtV2.jsp?slpNo="
					browserPanel.showDialog(Factory.getInstance().getSysParameter("ABillPathW")+"?slpNo="
							+slip
							+"&patno="+patNo+"&baseURL="+GWT.getModuleBaseURL()+"&rptPath="+ipStmtPath
							+"&docPath="+result+"&isSendMsg="+isSendMsg
							+"&from=txnDetail&slpType=I&billID="+billID+"&lang="+(ConstantsVariable.HKAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())?"CTE":"CHT"));
					browserPanel.dispose();
				}
			}
		}, null, "APPBILL", false);
	}

}
