package com.hkah.client.tx.transaction;

import java.util.LinkedList;
import java.util.List;

import com.extjs.gxt.ui.client.Style.Scroll;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.DateField;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.google.gwt.dom.client.Element;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.Resources;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboPkgJoined;
import com.hkah.client.layout.dialog.DlgAgreeRate;
import com.hkah.client.layout.dialogsearch.DlgPackageSearch;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextItemCodeSearch;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsProperties;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class ChargeCapture extends ActionPanel {

//	private boolean HasChanged = false;
	private String memTransactionMode = null;
	private boolean Searching = false;
	private String memSLPNO = null;
	private String memSlpType = null;
	private String memAcmCode = null;
//	private String memStnRlvl = null;
//	private String memCode = null;	// Item Code or Package Code
//	private String memDefaultRate = null;	// Default Rate
//	private String memSecondRate = null;	// Second Rate

//	private String memDocCode = null;
//	private String memBedCode = null;
//	private String memSpcName = null;
	private String memSlpHDisc = null;
	private String memSlpDDisc = null;
	private String memSlpSDisc = null;
	private String memStnTDate = null;
	private String memItmCat = null;

//	private boolean SaveBtnClick = false;
//	private boolean MessageShown = false;
//	private int GRIDPREVIOUSROW = 0;
//	private String gs_from = null;
	private String uni = null;
	private String Cpsid = "";
	private boolean flagToDi = false;
//	private boolean systemNegotiate = false;
	private String strScanMsg = null;
	private boolean blnScanMsg = false;
//	private String memLabNum = null;
	private Double TmpAmount = 0.0;
	private int lastListCount = 0;
	private LinkedList<Integer> editGridColIdx = null;

	private DlgAgreeRate dlgAgreeRate = null;

	public final static int DOCTOR_STATUS_ACTIVE = -1;
	public final static int IDX_PKGCODE = 0;
	public final static int IDX_ITMCODE = 1;
	public final static int IDX_ITMCAT = 2;
	public final static int IDX_ORGAMT = 3;
	public final static int IDX_AMOUNT = 4;
	public final static int IDX_DISCOUNT = 5;
	public final static int IDX_TXDATE = 6;
	public final static int IDX_DOCCODE = 7;
	public final static int IDX_DOCNAME = 8;
	public final static int IDX_DESCRIPTION = 9;
	public final static int IDX_ACM = 10;
	public final static int IDX_TODI = 11;
	public final static int IDX_CPS = 12;
	public final static int IDX_UNIT = 13;
	public final static int IDX_DESCRIPTION1 = 14;
	public final static int IDX_IREF = 15;
	public final static int IDX_ITMLVL = 16;
	public final static int IDX_ITMTYPE = 17;
	public final static int IDX_TOTALNO = 19;
	public final static String ITMTYPE_DOCTOR = "D";
	public final static String ITMTYPE_DOCTOR_CLASS = "cell-border-alert1";

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.CHARGECAPTURE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		if (ConstantsTransaction.TXN_CREDITITEMPER_MODE.equals(getParameter("TransactionMode"))) {
			return ConstantsTx.CREDITITEMCHARGE_TITLE;
		} else {
			return ConstantsTx.CHARGECAPTURE_TITLE;
		}
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Pkg Code",             // 00
				"Item Code",            // 01
				"ItemCat",              // 02
				"OrgAmt",               // 03
				"Amt",                  // 04
				"Discount %",           // 05
				"Trans. Date",          // 06
				"Doc Code",             // 07
				"Doc Name",             // 08
				"Description",          // 09
				"Acm",                  // 10
				"To Di",                // 11
				"CPS",                  // 12
				"UNIT",                 // 13
				"Description1",         // 14
				"I-Ref",                // 15
				"itmrlvl",              // 16
				"itmtype"               // 17
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				60,			// 00
				60,                     // 01
				0,                      // 02
				0,                      // 03
				55,                     // 04
				!ConstantsTransaction.TXN_CREDITITEMPER_MODE.equals(getParameter("TransactionMode"))?65:0, // 05
				90,                     // 06
				70,                     // 07
				100,                    // 08
				150,                    // 09
				40,                     // 10
				50,                     // 11
				ConstantsProperties.Enhancement_01 == 1?40:0,	// 12
				ConstantsProperties.OT == 1?40:0,	// 13
				100,                    // 14
				60,                     // 15
				0,                      // 16
				0                       // 17
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel actionPanel = null;
	private BasePanel paraPanel1 = null;
	private LabelBase slipNoDesc = null;
	private TextReadOnly slipNo = null;
	private LabelBase patientDesc = null;
	private TextReadOnly patNo;
	private TextReadOnly patName;
	private LabelBase bedCodeDesc = null;
	private TextReadOnly bedCode = null;
	private LabelBase admissionDateDesc = null;
	private TextReadOnly admissionDate = null;
	private LabelBase doctorDesc = null;
	private TextReadOnly docCode = null;
	private TextReadOnly docName = null;
	private LabelBase acmCodeDesc1 = null;
	private TextReadOnly acmCode1 = null;

	private BasePanel paraPanel2 = null;
	private LabelBase standardRateDesc = null;
	private CheckBoxBase standardRate = null;
	private LabelBase acmCodeDesc2 = null;
	private ComboACMCode acmCode2 = null;
	private LabelBase itmpkgCodeDesc = null;
	private TextItemCodeSearch itmpkgCodeDebit = null;
	private TextItemCodeSearch itmpkgCodeCredit = null;
	private ButtonBase btnPkgCode;
	private DlgPackageSearch dlgPackageSearch = null;
	private LabelBase transactionDateDesc = null;
	private TextDate transactionDate = null;
	private LabelBase packageJoinedDesc = null;
	private ComboPkgJoined packageJoined = null;
	private LabelBase unitDesc = null;
	private TextNum unit = null;

	private ButtonBase deptRegular = null;
	private ButtonBase deptSurcharge = null;
	private LabelBase countDesc = null;
	private TextReadOnly count = null;
	private LabelBase amtBfdiscDesc = null;
	private TextReadOnly amtBfdisc = null;

//	private JScrollPane JScrollPane = null;
	private BasePanel ListPanel = null;

	private JScrollPane editGridScrollPane = null;
	private EditorTableList editGridList = null;

	private boolean bAmount = false;
//	private boolean bStopCalculateTotal = false;

//	private String memSlpCpsid = null;

	/**
	 * This method initializes
	 *
	 */
	public ChargeCapture() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		formInitiliaze();
		if (ConstantsProperties.OT == 1) {
			if ("OT_LOG".equals(getParameter("FROM"))) {
				memSLPNO = getParameter("SlpNo");
				retrieve_Basic_Slip(memSLPNO);
			}

			getUnit().setVisible(true);
			getUnitDesc().setVisible(true);
			getDeptRegular().setVisible(true);
			getDeptSurcharge().setVisible(true);
			getAmtBfdisc().setVisible(true);
			getAmtBfdiscDesc().setVisible(true);
			getCount().setVisible(true);
			getCountDesc().setVisible(true);
			getDeptRegular().setEnabled(true);
			getDeptSurcharge().setEnabled(true);
			getStandardRate().setSelected(true);
			getStandardRate().setSelected(true);
			bAmount = false;
			getPkgCode().setVisible(YES_VALUE.equalsIgnoreCase(getSysParameter("PKGSHBTN")));

		} else {
			getUnit().setVisible(false);
			getUnitDesc().setVisible(false);
			getDeptRegular().setVisible(false);
			getDeptSurcharge().setVisible(false);
			getAmtBfdisc().setVisible(false);
			getAmtBfdiscDesc().setVisible(false);
			getCount().setVisible(false);
			getCountDesc().setVisible(false);
		}

//		bStopCalculateTotal = false;

		if (getParameter("SlpNo") != null && getParameter("SlpNo").length() > 0) {
			getSlipNo().setText(getParameter("SlpNo"));
			getAcmCode1().setText(getParameter("AcmCode"));
			getDocCode().setText(getParameter("DocCode"));
			getDocName().setText(getParameter("DocName"));
			getBedCode().setText(getParameter("BedCode"));
			getPatNo().setText(getParameter("PatNo"));
			getPatName().setText(getParameter("PatName"));
			getAdmissionDate().setText(getParameter("RegDate"));
			getStandardRate().setSelected(true);
			getTransactionDate().setText(getMainFrame().getServerDate());
		}

		String itmCode = getParameter("itmCode1");
		// skip empty item code
		if (itmCode != null && itmCode.length() > 0) {
			// call database to retrieve item code
			appendItemPkg(itmCode, getAcmCode1().getText(), ConstantsVariable.ONE_VALUE, null, null);
		}
		resetParameter("itmCode1");

//		gs_from = getParameter("FROM");
		if (!Searching) {
			setTextField();

			if (!ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(memSlpType)) {
				// empty
				getAcmCode2().resetText();
				getAcmCode2().setEnabled(false);
			}
			getAcmCode2().setText(memAcmCode);
		} else if (Searching) {
			if (!ConstantsVariable.EMPTY_VALUE.equals(getParameter("ItmCode"))) {
//				memCode = getParameter("ItmCode");
				getItmpkgCode().resetText();
			}
		}

		// set button status
		if (ConstantsProperties.OT == 1) {
			fromOT(getParameter("FromWhere"));
		}

		memItmCat = getParameter("ItmCat");

		// inital comobobox
		getPackageJoined().initContent(getSlipNo().getText());

		enableButton();

		// tab index
		int i = 0;
		getItmpkgCodeCredit().setTabIndex(i++);
		getItmpkgCodeDebit().setTabIndex(i++);
		getUnit().setTabIndex(i++);
		getTransactionDate().setTabIndex(i++);
		getPackageJoined().setTabIndex(i++);
		getAcmCode2().setTabIndex(i++);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextItemCodeSearch getDefaultFocusComponent() {
		return getItmpkgCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] {
				selectedContent[0]
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getSaveButton().isEnabled() && getEditGridList().getRowCount() > 0) {
			getSaveButton().setEnabled(false);
			getMainFrame().setLoading(true);

			boolean validate = true;
			String[] s = null;
			int iChgAmt = 0;
			double iDiscount = 0;

			for (int i = 0; validate && i < getEditGridList().getRowCount(); i++) {
				s = getUpdatedContent(i);
				iChgAmt = 0;
				try {
					iChgAmt = Integer.parseInt( s[IDX_AMOUNT] );
				} catch ( Exception e) {
					if ("C".equals(memItmCat)) {
						addErrorMessage(MSG_NEGATIVE_AMOUNT);
					} else {
						addErrorMessage(MSG_POSITIVE_AMOUNT);
					}
					getEditGridList().setSelectRow(i);
					validate = false;
				}

				if (validate) {
					if ("C".equals(memItmCat)) {
						if (iChgAmt > 0) {
							addErrorMessage(MSG_NEGATIVE_AMOUNT);
							getEditGridList().setSelectRow(i);
							validate = false;
						}
					} else {
						if (iChgAmt < 0) {
							addErrorMessage(MSG_POSITIVE_AMOUNT);
							getEditGridList().setSelectRow(i);
							validate = false;
						}
					}
				}

				iDiscount = 0.0;
				try {
					iDiscount = Double.parseDouble(s[IDX_DISCOUNT]);
				} catch ( Exception e) {
					addErrorMessage(MSG_NUMERIC_DISCOUNT);
					getEditGridList().setSelectRow(i);
					validate = false;
				}
				if (iDiscount < 0) {
					addErrorMessage(MSG_NUMERIC_DISCOUNT);
					getEditGridList().setSelectRow(i);
					validate = false;
				} else if (iDiscount > 100) {
					addErrorMessage(MSG_NUMERIC_DISCOUNTOFF);
					getEditGridList().setSelectRow(i);
					validate = false;
				}
			}

			if (validate) {
				String rowTransDate = getEditGridList().getValueAt(0, IDX_TXDATE);
				bCheckGridTransDate(rowTransDate, 0);
			} else {
				actionValidationReady(actionType, false);
			}
		}

		//actionValidationReady(actionType, true);
	}

	/***************************************************************************
	 * EditGrid Method
	 **************************************************************************/

	private JScrollPane getEditGridScrollPane() {
		if (editGridScrollPane == null) {
			editGridScrollPane = new JScrollPane();
			if ("AMC2".equals(Factory.getInstance().getClientConfigObject().getSiteCode())
					|| "TWAH".equals(Factory.getInstance().getClientConfigObject().getSiteCode()) ) {
				editGridScrollPane.setBorders(true);
				editGridScrollPane.setScrollMode(Scroll.AUTO);
				editGridScrollPane.add(getEditGridList());
				editGridScrollPane.setBounds(1, 1, 757, 296);
			} else {
				editGridScrollPane.setViewportView(getEditGridList());
				editGridScrollPane.setBounds(1, 1, 753, 296);
			}
		}
		return editGridScrollPane;
	}

	private EditorTableList getEditGridList() {
		if (editGridList == null) {
			editGridList = new EditorTableList(getColumnNames(), getColumnWidths(), editGridListEditor(),false) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode,
						String rtnMsg) {
					if (success) {
						getEditGridList().removeAllRow();
						enableButton();
					}
				}

				protected void columnKeyDownHandler(FieldEvent be, int editingCol) {
					if (be.getSource() instanceof DateField) {
						if (be.getKeyCode() == 8 || be.getKeyCode() == 46) {
							return;
						}

						if (be.getKeyCode() == KeyCodes.KEY_TAB || be.getKeyCode() == 113) {
							final TextDate f = (TextDate) be.getField();
							validateTranDate(f.getText(), getAdmissionDate().getText(), getEditGridList().getSelectedRow());
						}
					}

					handleArrowKey(be.getKeyCode(), editingCol);
					if (!(be.getSource() instanceof CheckBoxBase)) {
						tableFieldHelper(be, editingCol);
					}
				}
			};
			editGridList.addListener(Events.AfterEdit, new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
					if (be.getColIndex() == 4) {
						updateCount();
					}
					setBackgroundColorToView();
				}
			});
		}
		// UAT only
		if ("AMC2".equals(Factory.getInstance().getClientConfigObject().getSiteCode())
				 || "TWAH".equals(Factory.getInstance().getClientConfigObject().getSiteCode()) ) {
			editGridList.setAutoHeight(true);
		}
		return editGridList;
	}

	private Field<? extends Object>[] editGridListEditor() {
		Field<? extends Object>[] editors = new Field<?>[IDX_TOTALNO];
//		TextNum discount = new TextNum(4, 2);

		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = null;
		editors[4] = getAmount();	// new TextAmount(10, true);
		editors[5] = getDiscount();	// !Transactions.TXN_CREDITITEMPER_MODE.equals(memTransactionMode)?discount:null;
		editors[6] = getTransactionDateField();	// new TextDate();
		editors[7] = getTextDoctorSearch();
		editors[8] = null;
		editors[9] = null;
		editors[10] = null;
		editors[11] = new CheckBoxBase() {
			/*
			@Override
			protected void onKeyDown(FieldEvent fe) {
				super.onKeyDown(fe);
				handleArrowKey(fe.getKeyCode(), IDX_TODI);
			}
			*/
		};
		editors[12] = null;
		editors[13] = null;
		editors[14] = getTextString(80, false, IDX_DESCRIPTION1);
		editors[15] = getTextString(90, true, IDX_IREF);
		editors[16] = null;
		editors[17] = null;
		editors[18] = null;
		return editors;
	}

	private LinkedList<Integer> getEditGridColIdx() {
		if (editGridColIdx == null) {
			editGridColIdx = new LinkedList<Integer>();
			Field<? extends Object>[] list = editGridListEditor();
			for (int i = 0; i < list.length; i++) {
				if (list[i] != null) {
					editGridColIdx.add(i);
				}
			}
		}
		return editGridColIdx;
	}

	private void setBackgroundColorToView() {
		if ("Y".equals(Factory.getInstance().getSysParameter("BoldDrChg"))) {
			Element cell = null;
			for (int j = 0; j < getEditGridList().getRowCount(); j++) {
				// highlight doctor charge item
				String itmType = getEditGridList().getValueAt(j, IDX_ITMTYPE);
				if (ITMTYPE_DOCTOR.equals(itmType)) {
					cell = getEditGridList().getView().getCell(j, IDX_DOCCODE);
					if (cell != null) {
						cell.addClassName(ITMTYPE_DOCTOR_CLASS);
					}
				}
			}
		}
	}

	protected String[] getUpdatedContent(int rowIndex) {
		String[] row = new String[IDX_TOTALNO];
		getEditGridList().getView().ensureVisible(rowIndex, 0, true);
		for (int i = 0; i < IDX_TOTALNO; i++) {
			row[i] = getEditGridList().getValueAt( rowIndex, i ) ;
		}
		return row;
	}

	private TextAmount getAmount() {
		TextAmount amt = new TextAmount(true);

		amt.addListener(Events.OnFocus, new Listener<FieldEvent>() {
			@Override
			public void handleEvent(FieldEvent be) {
				int selRow = getEditGridList().getSelectedRow();
				ListStore<TableData> store = getEditGridList().getStore();
				TableData rowData = store.getAt(selRow);
				String stnCpsFlag = rowData.get(TableUtil.getName2ID("CPS")).toString();
				if (ConstantsTransaction.SLIPTX_CPS_STD_FIX.equals(stnCpsFlag) ||
						ConstantsTransaction.SLIPTX_CPS_STA_FIX.equals(stnCpsFlag)) {
					getEditGridList().stopEditing(true);
				}
			}
		});
/*
		amt.addListener(Events.KeyDown, new Listener<FieldEvent>() {
			@Override
			public void handleEvent(FieldEvent be) {
				handleArrowKey(be.getKeyCode(), IDX_AMOUNT);
				tableFieldHelper(be, IDX_AMOUNT);
			}
		});
*/
		return amt;
	}

	private TextNum getDiscount() {
		TextNum discount = new TextNum(4, 2);

		if (!ConstantsTransaction.TXN_CREDITITEMPER_MODE.equals(memTransactionMode)) {
			discount.addListener(Events.OnFocus, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					int selRow = getEditGridList().getSelectedRow();
					ListStore<TableData> store = getEditGridList().getStore();
					TableData rowData = store.getAt(selRow);
					String stnCpsFlag = rowData.get(TableUtil.getName2ID("CPS")).toString();
					if (ConstantsTransaction.SLIPTX_CPS_STD_FIX.equals(stnCpsFlag) ||
							ConstantsTransaction.SLIPTX_CPS_STA_FIX.equals(stnCpsFlag) ||
							ConstantsTransaction.SLIPTX_CPS_STD_PCT.equals(stnCpsFlag) ||
							ConstantsTransaction.SLIPTX_CPS_STA_PCT.equals(stnCpsFlag)) {
						getEditGridList().stopEditing(true);
					}
				}
			});
/*
			discount.addListener(Events.KeyDown, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					tableFieldHelper(be, IDX_DISCOUNT);
					handleArrowKey(be.getKeyCode(), IDX_DISCOUNT);
				}
			});
*/
			discount.addListener(Events.OnBlur, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					String discount = getEditGridList().getValueAt(getEditGridList().getSelectedRow(), IDX_DISCOUNT);
					if (discount == null || discount.trim().length() == 0) {
						getEditGridList().setValueAt(ZERO_VALUE, getEditGridList().getSelectedRow(), IDX_DISCOUNT);
					}
				}
			});
			return discount;
		} else {
			return null;
		}
	}

	private TextDate getTransactionDateField() {
		TextDate transactionDate = new TextDate();
/*
		transactionDate.addListener(Events.KeyDown, new Listener<FieldEvent>() {
			@Override
			public void handleEvent(FieldEvent be) {
				if (be.getKeyCode() == 8 || be.getKeyCode() == 46) {
					return;
				}

				if (be.getKeyCode() == KeyCodes.KEY_TAB || be.getKeyCode() == 113) {
					final TextDate f = (TextDate) be.getField();
					validateTranDate(f.getText(), getAdmissionDate().getText(), getEditGridList().getSelectedRow());
				}

				tableFieldHelper(be, IDX_TXDATE);
				handleArrowKey(be.getKeyCode(), IDX_TXDATE);
			}
		});
*/
		if (!Factory.getInstance().getSysParameter("HLTXNDT").equals("Y")) {
			transactionDate.addListener(Events.OnFocus, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					((TextDate)be.getField()).select(0, 0);
				}
			});
		}

		transactionDate.addListener(Events.OnBlur, new Listener<FieldEvent>() {
			@Override
			public void handleEvent(FieldEvent be) {
				if (be.getKeyCode() == 8 || be.getKeyCode() == 46) {
					return;
				}

				final TextDate f = (TextDate) be.getField();
				validateTranDate(f.getText(), getAdmissionDate().getText(), getEditGridList().getSelectedRow());
			}
		});

		return transactionDate;
	}

	private TextDoctorSearch getTextDoctorSearch() {
		TextDoctorSearch textDoctorSearch = new TextDoctorSearch() {
			@Override
			public void onTextSet() {
				getEditGridList().setValueAt(getText(), getEditGridList().getSelectedRow(), IDX_DOCCODE);
			}
/*
			@Override
			protected void onKeyDown(FieldEvent fe) {
				super.onKeyDown(fe);
				handleArrowKey(fe.getKeyCode(), IDX_DOCCODE);
				tableFieldHelper(fe, IDX_DOCCODE);
			}
*/
			private void checkDoctorCode() {
				if (getText().length() > 0) {
					QueryUtil.executeMasterFetch(
							getUserInfo(),
							ConstantsTx.DOCTOR_ACTIVE_TXCODE,
							new String[] { getText() },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getEditGridList().setValueAt(mQueue.getContentField()[0], getEditGridList().getSelectedRow(), IDX_DOCNAME);
							} else {
								addErrorMessage(ConstantsMessage.MSG_DOCTOR_CODE, getDocCode());
							}
						}
					});
				}
			}

			@Override
			public void onEnter() {
				checkDoctorCode();
			}

			@Override
			public void onTab() {
				checkDoctorCode();
			}
		};

		return textDoctorSearch;
	}

	private TextString getTextString(int length, final boolean tab2Unit, final int col) {
		TextString textString = new TextString(90, false);
/*
		textString.addListener(Events.KeyDown, new Listener<FieldEvent>() {
			@Override
			public void handleEvent(FieldEvent be) {
				handleArrowKey(be.getKeyCode(), col);
				tableFieldHelper(be, col);
			}
		});
*/
		return textString;
	}

	private void tableFieldHelper(FieldEvent be, int editingCol) {
		if (be.getKeyCode() == 112) { //F1
			if (be.getSource() instanceof SearchTriggerField) {
				((SearchTriggerField)be.getSource()).showSearchPanel();
			}
		} else if (be.getKeyCode() == 113) {	// F2
			if (getAppendButton().isEnabled()) {
				getEditGridList().stopEditing(false);
				appendAction();
			}
		} else if (be.getKeyCode() == 116) {	// F5
			if (getDeleteButton().isEnabled()) {
				be.preventDefault();
				getEditGridList().stopEditing(true);
				deleteAction();
			}
		} else if (be.getKeyCode() == 117) { //F6
			if (getSaveButton().isEnabled()) {
				be.preventDefault();
				getEditGridList().stopEditing(false);
				saveAction();
			}
		} else if (be.getKeyCode() == 119) { //F8
			if (getCancelButton().isEnabled()) {
				be.preventDefault();
				getEditGridList().stopEditing(true);
				cancelAction();
			}
		} else if (be.getKeyCode() == KeyCodes.KEY_TAB) {
			int idx = getEditGridColIdx().indexOf(editingCol) + (be.isShiftKey() ? -1 : 1);

			if (idx < 0) {
				be.preventDefault();
				getEditGridList().stopEditing(false);
				getItmpkgCode().requestFocus();
			} else if (idx >= getEditGridColIdx().size()) {
				be.preventDefault();
				getEditGridList().stopEditing(false);
				getUnit().requestFocus();
			}
		}
	}

	private void handleArrowKey(int keyCode, int editColumn) {
		if (keyCode == 38) {	// arrow_up
			moveToNextRowField(true, false, editColumn);
		} else if (keyCode == 40) {	// arrow_down
			moveToNextRowField(false, true, editColumn);
		}
	}

	private void moveToNextRowField(boolean up, boolean down, int editColumn) {
		int editRow = getEditGridList().getActiveEditor().row;
		int nextRow = up ? editRow - 1 : editRow + 1;

		if (nextRow >= 0 && nextRow < getEditGridList().getRowCount()) {
			getEditGridList().stopEditing();
			getEditGridList().setSelectRow(nextRow);
			getEditGridList().startEditing(nextRow, editColumn);
		}
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void appendAction() {
		appendAction(null, null);
	}

	private void appendAction(String sIRefNo, CallbackListener callback) {
		if (!getTransactionDate().isValid()) {
			addErrorMessage(ConstantsMessage.MSG_TRANSACTION_DATE_FORMAT, getTransactionDate());
		} else if (!getAdmissionDate().isEmpty() && DateTimeUtil.compareTo(getTransactionDate().getText(), getAdmissionDate().getText().substring(0, 10)) < 0) {
			addErrorMessage("The Transaction Date is older than Registration Date", getTransactionDate());
		} else if (!getItmpkgCode().isEmpty() && getAppendButton().isEnabled()) {
			appendItemPkg(getItmpkgCode().getText().trim(),
					getAcmCode2().getText().trim(),
					getUnit().getText().trim(), sIRefNo, callback);
			getItmpkgCode().resetText();
			getUnit().resetText();
		} else {
			getItmpkgCode().requestFocus();
		}
	}

	@Override
	public void deleteAction() {
		if (getDeleteButton().isEnabled()) {
			getEditGridList().stopEditing(true);

			int selRow = getEditGridList().getSelectedRow();
			if (selRow != -1) {
				getEditGridList().removeRow(getEditGridList().getSelectedRow());
				enableButton();
				if (selRow >= 0) {
					getEditGridList().setSelectRow(selRow);
					getItmpkgCode().focus();
				}
			}
		}
	}
/*
	private boolean checkDoctorCode() {
		for (int i = 0; i < getEditGridList().getRowCount(); i++) {
			String docCode = getUpdatedContent(i)[IDX_DOCCODE];

			if (docCode == null || docCode.length() == 0) {
				return false;
			}

			QueryUtil.executeMasterFetch(
				getUserInfo(),
				ConstantsTx.DOCTOR_ACTIVE_TXCODE,
				new String[] {
					getDocCode().getText().trim()
				},
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getDocName().setText(mQueue.getContentField()[0]);
						} else {
							addErrorMessage(ConstantsMessage.MSG_DOCTOR_CODE, getDocCode());
//							docCode.resetText();
							getDocName().resetText();
						}
					}
				});

		}
		return true;
	}
*/
	@Override
	public void cancelYesAction() {
		// reset table value
		if (getEditGridList().getRowCount() > 0) {
			getEditGridList().removeAllRow();
		}
		enableButton();
	}

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();
//		getSearchButton().setEnabled(true);
		getAppendButton().setEnabled(true);
		if (getEditGridList() != null && getEditGridList().getRowCount() > 0) {
			getSaveButton().setEnabled(true);
			getDeleteButton().setEnabled(true);
			getCancelButton().setEnabled(true);
		} else {
			getSaveButton().setEnabled(false);
			getDeleteButton().setEnabled(false);
			getCancelButton().setEnabled(false);
		}
		updateCount();
	}

	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			// PostTransaction
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"Slip, Arcode", "Cpsid", "Slip.Arccode = Arcode.Arccode AND Slip.Slpno ='" + getSlipNo().getText() + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					Cpsid = "";
					flagToDi = false;

					if (mQueue.success()) {
						Cpsid = mQueue.getContentField()[0];
					}

					// preAddEntry
					getAddEntryTable().removeAllRow();
					if (ConstantsTransaction.TXN_CREDITITEMPER_MODE.equals(memTransactionMode)) {
						preAddEntryCreditMode();
					} else {//TransactionMode = TXN_ADD_MODE
						preAddEntryAddModeR(0, getEditGridList().getRowCount());
					}
				}

				public void onComplete() {
					super.onComplete();
					getMainFrame().setLoading(false);
				}
			});
		} else {
			getSaveButton().setEnabled(true);
			getMainFrame().setLoading(false);
		}
	}

	@Override
	protected void postSaveAddEntryTable(boolean success, Integer rtnCode, String rtnMsg) {
		if (success) {
			getEditGridList().removeAllRow();
			enableButton();

			getDefaultFocusComponent().requestFocus();
		} else {
			addErrorMessage(rtnMsg);
		}
	}

	public void AddDepositReady(String deposit, String[] s, int idx, int total) {
		if ("-1".equals(deposit)) {
			postSaveAddEntryTable(false, null, "<html>Add Deposit Item Failed<br>Transaction cancelled</html>");
		} else {
			String RtnRefID = deposit;
			String tmpAcmCode = null;

			flagToDi = YES_VALUE.equals(s[IDX_TODI]);

			if (ConstantsProperties.Enhancement_01 == 1) {
				tmpAcmCode = s[IDX_ACM];
			} else {
				tmpAcmCode = memAcmCode;
			}

			// add to saveTable
			getAddEntryTable().addRow(new String[]{
					getSlipNo().getText(),
					s[IDX_ITMCODE],
					s[IDX_ITMTYPE],
					ConstantsTransaction.SLIPTX_TYPE_DEPOSIT_O,
					s[IDX_ORGAMT],
					s[IDX_AMOUNT],
					s[IDX_DOCCODE],
					s[IDX_ITMLVL],
					tmpAcmCode,
					s[IDX_DISCOUNT],
					s[IDX_PKGCODE],
					getMainFrame().getServerDateTime(),
					s[IDX_TXDATE],
					s[IDX_DESCRIPTION],
					"",
					"",
					RtnRefID,
					ZERO_VALUE, // false
					getBedCode().getText(),
					"",
					flagToDi?MINUS_ONE_VALUE:ZERO_VALUE,	// false
					s[IDX_CPS],
					Cpsid,
					s[IDX_UNIT],
					s[IDX_DESCRIPTION1],
					s[IDX_IREF]
			});
			preAddEntryAddModeR(idx + 1, total);
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void fromOT(String OT) {
		String sFromWhere = OT;
		if (ConstantsGlobal.OT_EMERGENCY.equals(sFromWhere)) {
			getStandardRate().setSelected(false);
		} else {
			getStandardRate().setSelected(true);
		}

		if (ConstantsGlobal.OT_EMERGENCY.equals(sFromWhere) ||
				ConstantsGlobal.OT_NOT_EMERGENCY.equals(sFromWhere)) {
			getDeptRegular().setEnabled(true);
			getDeptSurcharge().setEnabled(true);
		} else {
			getDeptRegular().setEnabled(false);
			getDeptSurcharge().setEnabled(false);
		}
	}

	private void formInitiliaze() {
//		HasChanged = false;
		memTransactionMode = getParameter("TransactionMode");
		Searching = false;
		memSLPNO = ConstantsVariable.EMPTY_VALUE;
		memSlpType = ConstantsVariable.EMPTY_VALUE;
		memAcmCode = ConstantsVariable.EMPTY_VALUE;
//		memStnRlvl = "-1";
//		memCode = ConstantsVariable.EMPTY_VALUE;
//		memDefaultRate = ConstantsVariable.EMPTY_VALUE;
//		memSecondRate = ConstantsVariable.EMPTY_VALUE;
		memBedCode = ConstantsVariable.EMPTY_VALUE;
//		memDocCode = ConstantsVariable.EMPTY_VALUE;
//		memSpcName = ConstantsVariable.EMPTY_VALUE;
		memSlpHDisc = ConstantsVariable.EMPTY_VALUE;
		memSlpDDisc = ConstantsVariable.EMPTY_VALUE;
		memSlpSDisc = ConstantsVariable.EMPTY_VALUE;
		memStnTDate = ConstantsVariable.EMPTY_VALUE;
//		SaveBtnClick = false;
//		MessageShown = false;
//		GRIDPREVIOUSROW = 0;
	}

	private void setTextField() {
		memSLPNO = getParameter("SlpNo");
		memAcmCode = getParameter("AcmCode");
//		memStnRlvl = getParameter("StnRlvl");
//		memDocCode = getParameter("DocCode");
		memBedCode = getParameter("BedCode");
		memSlpHDisc = getParameter("SlpHDisc");
		memSlpDDisc = getParameter("SlpDDisc");
		memSlpSDisc = getParameter("SlpSDisc");
//		memSpcName = getParameter("SpcName");
		memSlpType = getParameter("SlpType");

		memStnTDate = getMainFrame().getServerDate();

//		getAdmissionDate().setText(memStnTDate);
	}

	private void retrieve_Basic_Slip(final String slpno) {
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.SLIPSEARCH_TXCODE,
				new String[] { null,slpno, null, null, null, null, null, null },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getPatNo().setText(mQueue.getContentField()[3]);
					getPatName().setText(mQueue.getContentField()[4] + " " + mQueue.getContentField()[5]);
					getDocCode().setText(mQueue.getContentField()[6]);
					getDocName().setText(mQueue.getContentField()[7] + " " + mQueue.getContentField()[8]);
					getBedCode().setText(mQueue.getContentField()[12]);
					getSlipNo().setText(mQueue.getContentField()[0]);
					getAcmCode1().setText(mQueue.getContentField()[13]);
					getAdmissionDate().setText(mQueue.getContentField()[14]);
					getPackageJoined().initContent(slpno);

					setParameter("SlpNo", getSlipNo().getText());
					setParameter("AcmCode", getAcmCode1().getText());
					resetParameter("StnRlvl");
					setParameter("DocCode", getDocCode().getText());
					setParameter("BedCode", getBedCode().getText());
					setParameter("SlpHDisc", ConstantsVariable.ZERO_VALUE);
					setParameter("SlpDDisc", ConstantsVariable.ZERO_VALUE);
					setParameter("SlpSDisc", ConstantsVariable.ZERO_VALUE);
					resetParameter("SpcName");
					setParameter("SlpType", "I");
					setParameter("TransactionMode", ConstantsTransaction.TXN_ADD_MODE);
				}
			}
		});
	}

	private void appendItemPkgReady(boolean ready, String itmCode, CallbackListener afterAppendListener) {
		getMainFrame().setLoading(false);

		boolean showErrorMsg = false;

		if (ready) {
			/*if ("HKAH".equals(Factory.getInstance().getClientConfigObject().getSiteCode()) && !ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(memSlpType)) {
				if ("FLUM".equals(itmCode)) {
					Factory.getInstance().addErrorMessage("Please add discount in FLUM package:<br> RX001:<b>61.11%</b><br> NP105:<b>75%</b><br> Balance should be <font color=\"blue\">$360</font>");
				} else if ("FLU".equals(itmCode)) {
					Factory.getInstance().addErrorMessage("Please add discount in FLU package:<br> RX001:<b>22.22%</b><br> Balance should be <font color=\"blue\">$420</font>");
				}
			}*/
			QueryUtil.executeMasterFetch(getUserInfo(), "CHECKCHGALERTMSG",
					new String[] {
						itmCode.toUpperCase(),
						memSlpType.toUpperCase()
					},
					new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								String itmAlert = mQueue.getContentField()[0];
								if (itmAlert != null && itmAlert.length() > 0) {
									addErrorMessage(itmAlert);
								}
							}
						}
					}
				);
		} else {
			if (blnScanMsg) {
				strScanMsg = "INVALID_ITMCHARGE_RATE";
			} else {
				showErrorMsg = true;
			}
		}

		if ("HKAH".equals(Factory.getInstance().getClientConfigObject().getSiteCode())) {
			/*if ("DFUC1".equals(itmCode)) {
				Factory.getInstance().addErrorMessage("For package only/Invalid Individual Consultation Code");
			} else if ("DFUC2".equals(itmCode)) {
				Factory.getInstance().addErrorMessage("Invalid Package Code - Please use RE70RXD");
			} else if ("DFGCF".equals(itmCode)) {
				Factory.getInstance().addErrorMessage("Invalid Code - Please use RERXP for GP/SP or RE03RX for <font color=\"blue\">Drug Therapy - Clinical Oncology</font>");
			} else if (showErrorMsg) {
				addErrorMessage(ConstantsMessage.MSG_ITMCHARGE_RATE, getItmpkgCode());
			}*/
			
			 if (showErrorMsg) {
					addErrorMessage(ConstantsMessage.MSG_ITMCHARGE_RATE, getItmpkgCode());
			 }
		} else if (showErrorMsg) {
			addErrorMessage(ConstantsMessage.MSG_ITMCHARGE_RATE, getItmpkgCode());
		}

		enableButton();
		defaultFocus();
		setBackgroundColorToView();

		if (afterAppendListener != null) {
			afterAppendListener.handleRetBool(ready, null, null);
		}
	}

	private void appendItemPkg(final String itmCode, final String acmCode, String unit, String iRefNo,
			final CallbackListener afterAppendListener) {
		getAppendButton().setEnabled(false);
		getMainFrame().setLoading(true);

		// set default value for unit
		if (unit == null || unit.length() == 0) {
			uni = ConstantsVariable.ONE_VALUE;
		} else {
			uni = unit;
		};

		QueryUtil.executeMasterFetch(getUserInfo(), getTxCode(),
			new String[] {
				memTransactionMode,
				memSLPNO,
				memSlpType,
				getTransactionDate().getText(),
				itmCode.toUpperCase(),
				getDocCode().getText(),
				acmCode,
				uni,
				memSlpHDisc,
				memSlpDDisc,
				memSlpSDisc,
				getStandardRate().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE,
				getUserInfo().getUserID(),
				bAmount?YES_VALUE:NO_VALUE,
				TmpAmount.toString(),
				iRefNo
			},
			new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getEditGridList().appendListTableContent(mQueue);
						getEditGridList().setSelectRow(getEditGridList().getRowCount() - 1);

						// check pkg alert
						QueryUtil.executeMasterFetch(getUserInfo(), "PackageAlert",
							new String[] {
								memTransactionMode,
								itmCode.toUpperCase()
							},
							new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										String packageAlert = mQueue.getContentField()[0];
										if (packageAlert != null && packageAlert.length() > 0) {
											addErrorMessage(packageAlert, getItmpkgCode());
										}
									}
								}
							}
						);

						appendItemPkgReady(true, itmCode, afterAppendListener);
					} else {
						appendItemPkgReady(false, itmCode, afterAppendListener);
					}
				}

				@Override
				public void onFailure(Throwable caught) {
					super.onFailure(caught);
					appendItemPkgReady(false, itmCode, afterAppendListener);
				}
			}
		);
	}

	private void updateCount() {
//		bStopCalculateTotal = true;

		int count = getEditGridList().getRowCount();
		int total = 0;
		getCount().setText(String.valueOf(count));
		int tmpSelectedRow = getEditGridList().getSelectedRow();

		try {
			for (int i = 0; i < count; i++) {
				getEditGridList().setSelectRow(i);
				total += Integer.parseInt(getEditGridList().getValueAt(i, IDX_AMOUNT));
			}
		} catch (Exception e) {}
		getAmtBfdisc().setText(String.valueOf(total));
		getEditGridList().setSelectRow(tmpSelectedRow);
//		bStopCalculateTotal = false;

		if (total != 0) {
			setActionType(QueryUtil.ACTION_APPEND);
		} else {
			setActionType(null);
		}
	}

	private void preAddEntryCreditMode() {
		// [20130402] ck.
		//final String[] s = getEditGridList().getRowContent(i);
		String[] s = null;
		String RtnRefID = null;
		for (int i = 0; i < getEditGridList().getRowCount(); i++) {
			s = getUpdatedContent(i);
			RtnRefID = EMPTY_VALUE;
			flagToDi = YES_VALUE.equals(s[IDX_TODI]);
//			if (ConstantsProperties.Enhancement_01 == 1) {
//				tmpAcmCode = s[IDX_ACM];
//			} else {
//				tmpAcmCode = memAcmCode;
//			}

			getAddEntryTable().addRow(new String[]{
					getSlipNo().getText(),
					s[IDX_ITMCODE],
					s[IDX_ITMTYPE],
					ConstantsTransaction.SLIPTX_TYPE_CREDIT,
					s[IDX_ORGAMT],
					s[IDX_AMOUNT],
					s[IDX_DOCCODE],
					s[IDX_ITMLVL],
					s[IDX_ACM],
					s[IDX_DISCOUNT],
					s[IDX_PKGCODE],
					getMainFrame().getServerDateTime(),
					s[IDX_TXDATE],
					s[IDX_DESCRIPTION],
					"",
					"",
					RtnRefID,
					ZERO_VALUE, // false
					getBedCode().getText(),
					"",
					ZERO_VALUE,	// false
					s[IDX_CPS],
					Cpsid,
					s[IDX_UNIT],
					s[IDX_DESCRIPTION1],
					s[IDX_IREF]
			});
		}
		addEntrySTAction();
	}

	private void preAddEntryAddModeR(final int idx, final int total) {
		if (idx >= total) {
			// exit
			addEntrySTAction();
		} else {
			final String[] s = getUpdatedContent(idx);

			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"item", "Itmcode", "itmcat = '" + ConstantsTransaction.ITEM_CATEGORY_DEPOSIT+ "' and itmcode ='" + s[IDX_ITMCODE] + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					String tempResult="";
					String RtnRefID="";
					String tmpAcmCode = null;

					if (mQueue.success()) {
						tempResult = mQueue.getContentField()[0];
					}

					if (ConstantsTransaction.ITEM_CATEGORY_DEPOSIT.equals(s[IDX_ITMCAT]) || s[IDX_ITMCODE].equals(tempResult)) {
						try {
							AddDeposit(s, getSlipNo().getText(), getMainFrame().getServerDateTime(),
									idx, total);
						} catch (Exception e) {
							postSaveAddEntryTable(false, null, "<html>Add Deposit Item Failed<br>Transaction cancelled</html>");
						}
					} else {
						flagToDi = YES_VALUE.equals(s[IDX_TODI]);

						if (ConstantsProperties.Enhancement_01 == 1) {
							tmpAcmCode = s[IDX_ACM];
						} else {
							tmpAcmCode = memAcmCode;
						}

						getAddEntryTable().addRow(new String[]{
								getSlipNo().getText(),
								s[IDX_ITMCODE],
								s[IDX_ITMTYPE],
								ConstantsTransaction.SLIPTX_TYPE_DEBIT,
								String.valueOf(Integer.valueOf(s[IDX_ORGAMT])/Integer.valueOf(s[IDX_UNIT])),
								s[IDX_AMOUNT],
								s[IDX_DOCCODE],
								s[IDX_ITMLVL],
								tmpAcmCode,
								s[IDX_DISCOUNT],
								s[IDX_PKGCODE],
								getMainFrame().getServerDateTime(),
								s[IDX_TXDATE],
								s[IDX_DESCRIPTION],
								"",
								"",
								RtnRefID,
								ZERO_VALUE, // false
								getBedCode().getText(),
								"",
								flagToDi?MINUS_ONE_VALUE:ZERO_VALUE,	// false
								s[IDX_CPS],
								Cpsid,
								s[IDX_UNIT],
								s[IDX_DESCRIPTION1],
								s[IDX_IREF]
						});
						preAddEntryAddModeR(idx + 1, total);
					}
				}
			});
		}
	}

	private void addEntrySTAction() {
		if ("N".equals(Factory.getInstance().getSysParameter("SAVECRG"))) {
			Factory.getInstance().addInformationMessage(
					"[Debug mode] ADDENTRYST No. of row to be saved: " +
					getAddEntryTable().getRowCount() + " (remove sysparam SAVECRG to exit debug mode)");
		} else if (getAddEntryTable().getRowCount() > 0) {
/*
			QueryUtil.executeMasterAction(getUserInfo(),
					"ARDRCHG_LST", QueryUtil.ACTION_MODIFY,
					new String[]{getUserInfo().getUserID()},
					"TEMPLATE_OBJ", getAddEntryTable().getTableValues2("TEMPLATE_OBJ",
							getAddEntryTable().getStore().getModifiedRecords()),
					new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.getReturnCode().indexOf("<F/>") > 0) {
								getDlgAgreeRate().showDialog(mQueue.getReturnCode());
							}

						}

				});
*/
			// save > postSaveAddEntryTable
			getAddEntryTable().saveTable(
					"ADDENTRYST",
					new String[]{getUserInfo().getUserID()},
					false,
					false,
					false,
					null);
		}
	}
/*
	private List<TableData> getDrChgDoctorTable(String[] content) {
		List<TableData> TableData = new ArrayList<TableData>();
		String[] values2 = new String[colLen2];
		blankDVATableData.add(new TableData(getDVATableColumnNames(tabNo), values2));
	}
*/
	private void getNodeValueFromStr(final String strXML, String RefField) {
		String[] result = TextUtil.split(RefField, ",");
		String strBarcodeType = null;
		String strPatNo = null;
		String strLabNum = null;
		String xmlValue = null;

		if (result.length == 3) {
			for (int n = 0; n < result.length; n++) {
				xmlValue = getResponeData(strXML, result[n]);
				if ("BT".equals(result[n])) {
					strBarcodeType = xmlValue;
				} else if ("PID".equals(result[n])) {
					strPatNo = xmlValue;
				} else if ("LABN".equals(result[n])) {
					strLabNum =	xmlValue;
				}
			}
		}

		final String labNum = strLabNum;

		if (!"LABC".equals(strBarcodeType)) {
			getItmpkgCode().focus();
		} else {
			if (!strPatNo.equals(getPatNo().getText())) {
				addErrorMessage("bar code's patient number does not match with slip's patient number", getItmpkgCode());
				getItmpkgCode().resetText();
			} else {
				// check synonyms HAT_GETLABCHARGES exist or not (faster)
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {"ALL_SYNONYMS SYN, ALL_OBJECTS OBJ",
							"COUNT(1)","SYN.TABLE_NAME = OBJ.OBJECT_NAME " +
							"AND SYN.SYNONYM_NAME = 'HAT_GETLABCHARGES' " +
							"AND OBJ.STATUS = 'VALID'"},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if (Integer.parseInt(mQueue.getContentField()[0]) > 0) {
								QueryUtil.executeMasterBrowse(getUserInfo(), "HAT_GETLABCHARGES",
										new String[] { labNum, getDocCode().getText() },
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											int index = mQueue.getContentAsArray().size();
											getLabCharge(mQueue.getContentAsArray(), labNum, 0, index, null,
													getStandardRate().isSelected());
										} else {
											addErrorMessage("No records of [Lab Number " + labNum + "]  is found.", getItmpkgCode());
											getItmpkgCode().resetText();
										}
									}
								});
							} else {
								addErrorMessage("Hat_GetLabCharges does not exist, please contact administrator.", getItmpkgCode());
								getItmpkgCode().resetText();
							}
						} else {
							addErrorMessage("Hat_GetLabCharges does not exist, please contact administrator.", getItmpkgCode());
							getItmpkgCode().resetText();
						}
					}
				});
			}
		}
	}

	private void getLabCharge(final List<String[]> results,
			final String strLabNum, final int index, final int totalNum,
			String sChargeCodes, final boolean originalChkRateVal) {
		blnScanMsg = true;
//		memLabNum = strLabNum;
		strScanMsg = null;

//		System.err.println("{DEBUG] getLabCharge index="+index+", totalNum="+totalNum);

		if (index >= totalNum) {
			// end the iteration
			postGetLabCharge(originalChkRateVal);
			return;
		}

		String sLab_PatNo = results.get(index)[0];
		String sChargeCode = results.get(index)[2];
		String sStat = results.get(index)[4];
		String sDocCode = results.get(index)[6];
		String sActDocCode = results.get(index)[7];
		String sIRefNo = results.get(index)[5];
		String Amount = results.get(index)[3];
		int chgAmt = 0;
		String chrgType = null;

		if (getStandardRate().isSelected()) {
			chrgType = "R";
		}

		if (!sLab_PatNo.equals(getPatNo().getText())) {
			addErrorMessage("Slip's patient number does not match with Test Number of [Lab Number "+
					strLabNum+"] "+sChargeCode+"'s patient number.<br />Please contact Lab Dept."+
					(sChargeCodes != null?"Test Number: "+sChargeCodes+" are added.":""),
					getItmpkgCode());
		} else {
			try {
				if (Amount != null && !Amount.isEmpty()) {
					chgAmt = Integer.parseInt(Amount);
				} else {
					chgAmt = 0;
				}

				if (chgAmt < 0) {
					addErrorMessage("Test Number of [Lab Number " + strLabNum+"] "
							+ sChargeCode + "'s amount is negative, please contact Lab Dept." +
							(sChargeCodes != null?"Test Number: " + sChargeCodes+" are added." : null),
							getItmpkgCode());
				} else {
					if (sActDocCode != null && sActDocCode.length() > 0) {
						System.err.println("set sChargeCode=" + sChargeCode + " to getItmpkgCod");
						getItmpkgCode().setText(sChargeCode);

						if (!"Y".equals(sStat)) {
							getStandardRate().setSelected(true);
						} else {
							getStandardRate().setSelected(false);
						}

//--------------------------------- Copy from systemNegotiate --------------------------------------------
						if (!getTransactionDate().isValid()) {
							addErrorMessage(ConstantsMessage.MSG_TRANSACTION_DATE_FORMAT, getTransactionDate());
							return;
						}

						if (ConstantsProperties.OT == 1) {
							if (ConstantsVariable.EMPTY_VALUE.equals(getUnit().getText().trim())) {
								getUnit().setText("1");
							}
						}

//						if (getEditGridList().getRowCount()==0 ||
//							fieldValidate()) {
							itmPkgCodeValidate(memTransactionMode, memSLPNO,
									memSlpType, memStnTDate, chrgType,
									sChargeCode, sDocCode, memAcmCode,
									getUnit().getText(), Amount,
									memSlpHDisc, memSlpDDisc, memSlpSDisc,
									getUserInfo().getUserID(), results,
									strLabNum, sIRefNo, sChargeCodes, index, totalNum,
									originalChkRateVal);
//						}
					} else {
						addErrorMessage("Test Number of [Lab Number " + strLabNum + "] "+
								sChargeCode + "'s Doctor Code is not available, please contact Lab Dept." +
								(sChargeCodes != null ? "Test Number: " + sChargeCodes + " are added." : null),
								getItmpkgCode());
					}
				}
			} catch ( Exception e) {
				addErrorMessage(MSG_NUMERIC_DISCOUNT);
			}
//		} else {
//			// append fail: next GetLabCharge row
//			getLabCharge(results, strLabNum, index+1, totalNum, null, originalChkRateVal);
		}
	}

	private void postGetLabCharge(boolean originalChkRateVal) {
		calculateTotal();
		blnScanMsg = false;
		getStandardRate().setSelected(originalChkRateVal);
		getItmpkgCode().focus();
	}

	private String getResponeData(String respone, String key) {
		if (respone.indexOf("</"+key+">") > -1) {
			return respone.substring(respone.indexOf("<"+key+">")+("<"+key+">").length(),
					respone.indexOf("</"+key+">")).replaceAll("'", "''").trim();
		} else {
			return "";
		}
	}
/*
	private void getSearchParameter(String searchField) {
//		gs_from = getParameter("FROM");
		if (!Searching) {
			memTransactionMode = getParameter("TransactionMode");
			setTextField();

			getPackageJoined().initContent(memSLPNO);
			String[] para = null;

			if (!Transactions.SLIP_TYPE_INPATIENT.equals(memSlpType)) {
				// empty
				getAcmCode2().ressetText();
				getAcmCode2().setEnabled(false);
			}
			getAcmCode2().setText(memAcmCode);

			if (ConstantsProperties.Enhancement_01 == 1) {
				if (Transactions.SLIP_TYPE_INPATIENT.equals(memSlpType)) {
					para = new String[] {"acm","acmcode","1=1"};
					getAcmCode2().setEnabled(true);
				} else {
					para = new String[] {"acm","acmcode","1=2"};
					getAcmCode2().setEnabled(false);
				}

				getAcmCode2().setText(memAcmCode);

				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						para, new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							memSlpCpsid = mQueue.getContentField()[0];
						}
					}
				});
			}
		} else if (Searching) {
			if ("getItmpkgCode".equals(searchField)) {
				if (!ConstantsVariable.EMPTY_VALUE.equals(getParameter("ItmCode"))) {
					memCode = getParameter("ItmCode");
					String chrgType = null;
					if (getStandardRate().isSelected()) {
						chrgType = "R";
					}
					itemChargeValidate(getParameter("ItemCategory"), getParameter("ItmType"), memTransactionMode, memSLPNO, memCode, memSlpType, chrgType, getAcmCode2().getText(),
							null, null, memSlpHDisc, memSlpDDisc, memSlpSDisc);
					getItmpkgCode().resetText();
				}
			}
		} else {
			if (!ConstantsVariable.EMPTY_VALUE.equals(getParameter("DocCode"))) {
				int addRowNum = getEditGridList().getRowCount()-1;
				ListStore<TableData> store = getEditGridList().getStore();
				TableData rowData = store.getAt(addRowNum);

				rowData.set(TableUtil.getName2ID("DocCode"),getParameter("DocCode"));
				memDocCode = rowData.get(TableUtil.getName2ID("DocCode")).toString();
//				rowData.set(TableUtil.getName2ID("SpcName"),getParameter("SpcName")); // no "SpcName" this column then grid
			}
		}
		Searching = false;
	}

	private void itemChargeValidate(String itmCat, String itmType, String transactionMode, String slpNo, String itmCode, String slpType, String chrgType, String acmCode,
			String unit, String amount, String slpHDisc, String slpDDisc, String slpSDisc) {
		QueryUtil.executeMasterBrowse(getUserInfo(), "ITEMCHARGEVALIDATE",
				new String[] {
					itmCat,
					itmType,
					transactionMode,
					slpNo,
					itmCode,
					slpType,
					chrgType,
					acmCode,
					unit,
					amount,
					slpHDisc,
					slpDDisc,
					slpSDisc},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				getEditGridList().addRow(mQueue.getContentField());

				int addRowNum = getEditGridList().getRowCount()-1;
				ListStore<TableData> store = getEditGridList().getStore();
				TableData rowData = store.getAt(addRowNum);

				rowData.set(TableUtil.getName2ID("Description"),getParameter("ItmName"));
				rowData.set(TableUtil.getName2ID("Trans. Date"),memStnTDate);
				getEditGridList().setSelectRow(addRowNum);
			}
		});
	}

	private void callSearchEngine(String activeControl) {
		Searching = true;
		int selRow = getEditGridList().getSelectedRow();
		ListStore<TableData> store = getEditGridList().getStore();
		TableData rowData = store.getAt(selRow);
		if ("getEditGridList".equals(activeControl)) {
			setParameter("DocCode", rowData.get(TableUtil.getName2ID("DocCode")).toString());
			getPackageJoined().focus();
//			searchAction(); no sure
		} else if ("getItmpkgCode()".equals(activeControl)) {
			setParameter("ItmCode", getItmpkgCode().getText());
			setParameter("DocCode", getUserInfo().getDeptCode());
			if (Transactions.TXN_ADD_MODE.equals(memTransactionMode)) {
				setParameter("ItemCategory", " and ItmCat <> "+Transactions.ITEM_CATEGORY_CREDIT+" ");
			} else {
				setParameter("ItemCategory", " and ItmCat <> "+Transactions.ITEM_CATEGORY_DEBIT+" ");
			}
//			searchAction(); no sure
		}
	}
*/
	private void itmPkgCodeValidate(String transactionMode, String slpNo,
			String slpType, String transDate, String chrgType,
			final String sChargeCode, final String sDocCode,
			String acmCode, String unit, final String amount,
			String slpHDisc, String slpDDisc, String slpSDisc,
			String userID, final List<String[]> results, final String strLabNum, final String sIRefNo,
			final String sChargeCodes, final int index, final int totalNum,
			final boolean originalChkRateVal) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.ITMPKGCODEVALIDATE_TXCODE,
				new String[] {
					transactionMode,
					slpNo,
					slpType,
					transDate,
					chrgType,
					sChargeCode,
					sDocCode,
					acmCode,
					unit,
					amount,
					slpHDisc,
					slpDDisc,
					slpSDisc,
					userID},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					appendAction(sIRefNo, new CallbackListener() {
						@Override
						public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
//							System.err.println("after appendAction CallbackListener ret="+ret);
							if (ret) {
								afterGetLabChargeAppend(results, sChargeCode,
										sDocCode, amount, sChargeCodes, strLabNum, sIRefNo,
										index, totalNum, originalChkRateVal);
							} else {
								getItmpkgCode().focus();
							}

							if (ConstantsProperties.OT == 1) {
								getUnit().setText(EMPTY_VALUE);
							}
						}
					});
				}
			}
		});
	}

	private void afterGetLabChargeAppend(List<String[]> results, String sChargeCode,
			String sChargeCodes, String sDocCode, String amount, String strLabNum, String sIRefNo,
			int index, int totalNum, boolean originalChkRateVal) {
		if (strScanMsg != null && strScanMsg.length() > 0) {
			String strOutputMsg = null;

			if (sChargeCodes != null && sChargeCodes.length() > 0) {
				strOutputMsg = "Test Number: " + sChargeCodes + " are added.";
			}

			if ("INVALID_ITMCHARGE_RATE".equals(strScanMsg)) {
				if (strOutputMsg != null && strOutputMsg.length()>0) {
					strOutputMsg = strOutputMsg + " " + "Test Number of [Lab Number " + strLabNum + "] " + sChargeCode + ": " + ConstantsMessage.MSG_ITMCHARGE_RATE;
				} else {
					strOutputMsg = "Test Number of [Lab Number " + strLabNum + "] " + sChargeCode + ": " + ConstantsMessage.MSG_ITMCHARGE_RATE;
				}
			} else if ("INVALID_ITMPKG_CODE".equals(strScanMsg)) {
				if (strOutputMsg != null && strOutputMsg.length()>0) {
					strOutputMsg = strOutputMsg + " " + "Test Number of [Lab Number " + strLabNum + "] " + sChargeCode + " does not exist. Please contact Lab Dept. ";
				} else {
					strOutputMsg = "Test Number of [Lab Number " + strLabNum + "] " + sChargeCode + " does not exist. Please contact Lab Dept. ";
				}
			}

			addErrorMessage(strOutputMsg, getItmpkgCode());
			getItmpkgCode().resetText();
		} else {
			int addRowNum = getEditGridList().getRowCount() - 1;
			ListStore<TableData> store = getEditGridList().getStore();
			TableData rowData = store.getAt(addRowNum);

			rowData.set(TableUtil.getName2ID("DocCode"), sDocCode);
			rowData.set(TableUtil.getName2ID("I-Ref"), sIRefNo);

			if (amount != null && amount.length() > 0) {
				rowData.set(TableUtil.getName2ID("Amt"), amount);
			}

			getEditGridList().setSelectRow(addRowNum);
			//validate = true;
		}

		// next GetLabCharge row
		getLabCharge(results, strLabNum, index+1, totalNum, null, originalChkRateVal);
	}
/*
	private boolean fieldValidate() {
		boolean fieldValidate = false;
		if (validateAmount()) {
			lookUpDocCodeSingle();
			if (memDocCode != null && memDocCode.length()>0) {
				int selRow = getEditGridList().getSelectedRow();
				ListStore<TableData> store = getEditGridList().getStore();
				TableData rowData = store.getAt(selRow);
				if (validateTranDate(rowData.get(TableUtil.getName2ID("Trans. Date")).toString(),getAdmissionDate().getText(),selRow)) {
					if (validateDiscount()) {
						fieldValidate = true;
					}
				}
			}
		} else if (getEditGridList().getRowCount() == 1) {
			fieldValidate = true;
		}
		return fieldValidate;
	}

	private boolean validateAmount() {
		boolean validateAmount = true;
		int selRow = getEditGridList().getSelectedRow();
		ListStore<TableData> store = getEditGridList().getStore();
		TableData rowData = store.getAt(selRow);

		int amt = 0;
		try {
			amt = Integer.parseInt((String) rowData.get(TableUtil.getName2ID("Amt")));
			if (Transactions.TXN_ADD_MODE.equals(memTransactionMode)) {
				if (amt < 0) {
					validateAmount = false;
					addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT);
					rowData.set(TableUtil.getName2ID("Amt"), ConstantsVariable.EMPTY_VALUE);
					getEditGridList().setSelectRow(selRow);
				}
			} else {
				if (amt > 0) {
					validateAmount = false;
					addErrorMessage(ConstantsMessage.MSG_NEGATIVE_AMOUNT);
					rowData.set(TableUtil.getName2ID("Amt"), ConstantsVariable.EMPTY_VALUE);
					getEditGridList().setSelectRow(selRow);
				}
			}
		} catch (Exception e) {
			validateAmount = false;
			if (rowData.get(TableUtil.getName2ID("Amt")) != null && rowData.get(TableUtil.getName2ID("Amt")).toString().length()>0) {
				if (Transactions.TXN_ADD_MODE.equals(memTransactionMode)) {
					addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT);
					getEditGridList().setSelectRow(selRow);
				} else {
					addErrorMessage(ConstantsMessage.MSG_NEGATIVE_AMOUNT);
					getEditGridList().setSelectRow(selRow);
				}

			}
		}
		return validateAmount;
	}
*/
	private boolean validateTranDate(String transDate, String admissionDate, final int rownum) {
		boolean validateTranDate = true;
		if (!DateTimeUtil.isValidDate(transDate)) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_TRANSACTION_DATE,
				new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(
							MessageBoxEvent be) {
						getEditGridList().focus();
						getEditGridList().startEditing(rownum, IDX_TXDATE);
					}
			});
			validateTranDate = false;
		} else if (admissionDate != null && admissionDate.length() > 0) {
			String admissionDate1 = null;
			if (admissionDate.length() > 10) {
				admissionDate1 = admissionDate.substring(0, 10);
			} else {
				admissionDate1 = admissionDate;
			}
			if (DateTimeUtil.compareTo(transDate, admissionDate1) < 0) {
				Factory.getInstance().addErrorMessage("The Transaction Date is older than Registration Date.",
					new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							getEditGridList().focus();
							getEditGridList().startEditing(rownum, IDX_TXDATE);
						}
				});
				validateTranDate = false;
			}
		}
		return validateTranDate;
	}
/*
	private boolean validateDiscount() {
		boolean validateDiscount = false;
		return validateDiscount;
	}

	private void lookUpDocCodeSingle() {
		if (getEditGridList().getRowCount()>0 && ConstantsVariable.EMPTY_VALUE.equals(memDocCode)) {
			int selRow = getEditGridList().getSelectedRow();
			ListStore<TableData> st = getEditGridList().getStore();
			final TableData rowData = st.getAt(selRow);

			String docCode = rowData.get(TableUtil.getName2ID("docCode")).toString();
			String sqlWhere = "d.SpcCode=s.SpcCode and d.DocCode="+rowData.get(TableUtil.getName2ID("docCode")).toString();
			if (!docCode.toUpperCase().equals(getDocCode().getText().toUpperCase())) {
				sqlWhere = sqlWhere + " and docsts=" +DOCTOR_STATUS_ACTIVE;
			}

			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"Doctor d, Spec s", "DocCode", sqlWhere},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					String docCode = null;
					if (mQueue.success()) {
						docCode = mQueue.getContentField()[0];
						if (docCode != null && docCode.length() > 0) {
							rowData.set(TableUtil.getName2ID("DocCode"),docCode);
							memDocCode = docCode;
						}
					} else {
						addErrorMessage(ConstantsMessage.MSG_DOCTOR_CODE);
						getEditGridList().focus();
					}
				}
			});
		}
	}
*/
	private void calculateTotal() {
//		bStopCalculateTotal = true;

		long iCount = 0;
		long iTotal = 0;

		List<TableData> tableList = getEditGridList().getStore().getModels();
		int iCurrent = tableList.size();
		final ListStore<TableData> store = getEditGridList().getStore();

		for (int i = 0; i < iCurrent; i++) {
			final TableData rowData = store.getAt(i);
			int qty = 0;
			try {
				qty = Integer.parseInt((String) rowData.get(TableUtil.getName2ID("Amt")));
				iTotal = iTotal + qty;
			} catch ( Exception e) {
				qty = 0;
			}
			iCount = iCount + 1;
		}

		if (iCount == 0) {
			getCount().setText(ZERO_VALUE);
		} else {
			getCount().setText(Long.toString((iCount)));
		}

		getAmtBfdisc().setText(Long.toString(iTotal));

//		bStopCalculateTotal = false;
	}

	private void bCheckGridTransDate(final String transDate, final int index) {
		String currentdate = getMainFrame().getServerDateTime();
		final int totalRow = getEditGridList().getRowCount();
		if (!getAdmissionDate().isEmpty() && DateTimeUtil.compareTo(transDate, getAdmissionDate().getText().substring(0, 10)) < 0) {
			Factory.getInstance().addErrorMessage("The Transaction Date is older than Registration Date.",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					getEditGridList().focus();
					getEditGridList().setSelectRow(index);
					getEditGridList().startEditing(index, IDX_TXDATE);
				}
			});
			actionValidationReady(null, false);
		} else if (DateTimeUtil.compareTo(transDate, currentdate.substring(0, 10)) > 0) {
			Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]","The Transaction Date is greater than today. Do you want to proceed?", new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					String rowTransDate = getEditGridList().getValueAt(index + 1, IDX_TXDATE);
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						if (index + 1 < totalRow) {
							bCheckGridTransDate(rowTransDate, index + 1);
						} else {
							String rowDocCode = getEditGridList().getValueAt(0, IDX_DOCCODE);
							bCheckGridDoctor(rowDocCode, 0);
						}
					} else {
						getEditGridList().focus();
						getEditGridList().setSelectRow(index);
						getEditGridList().startEditing(index, IDX_TXDATE);
						actionValidationReady(null, false);
					}
				}
			});
		} else {
			String rowTransDate = getEditGridList().getValueAt(index + 1, IDX_TXDATE);
			String rowDocCode = getEditGridList().getValueAt(0, IDX_DOCCODE);
			if (index + 1 < totalRow) {
				bCheckGridTransDate(rowTransDate, index + 1);
			} else {
				bCheckGridDoctor(rowDocCode, 0);
			}
		}
	}

	private void bCheckGridDoctor(final String docCode, final int index) {
		final int totalRow = getEditGridList().getRowCount();

		QueryUtil.executeMasterFetch(
				getUserInfo(),
				ConstantsTx.DOCTOR_ACTIVE_TXCODE,
				new String[] { docCode },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (index + 1 < totalRow) {
						if (mQueue.getContentField()[0] != null && mQueue.getContentField()[0].length() > 0) {
							String rowDocCode = getEditGridList().getValueAt(index + 1, IDX_DOCCODE);
							bCheckGridDoctor(rowDocCode, index + 1);
						} else {
							QueryUtil.executeMasterFetch(
									getUserInfo(),
									ConstantsTx.DOCTOR_TXCODE,
									new String[] { docCode },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									String sMsg = "Inactive Doctor. Doctor Code: " + mQueue.getContentField()[0] + "; Row" + (index + 1);
									if (mQueue.success()) {
										sMsg += "<br/>Admission Expiry Date: " + mQueue.getContentField()[21];
									} else {
										sMsg += "<br/>Cannot get Admission Expiry Date";
									}

									getEditGridList().setSelectRow(index);
									Factory.getInstance().addErrorMessage(sMsg, "PBA-[" + getTitle() + "]");
									actionValidationReady(null, false);
									getEditGridList().focus();
									getEditGridList().setSelectRow(index);
									getEditGridList().startEditing(index, IDX_DOCCODE);
								}
							});
						}
					} else {
						actionValidationReady(null, true);
					}
				} else {
					QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR",
							new String[] {
								docCode
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							String sMsg = "Inactive Doctor. Doctor Code: " + mQueue.getContentField()[0] + "; Row" + (index + 1);
							if (mQueue.success()) {
								sMsg += "<br/>Admission Expiry Date: " + mQueue.getContentField()[21];
							} else {
								sMsg += "<br/>Cannot get Admission Expiry Date";
							}

							getEditGridList().setSelectRow(index);
							Factory.getInstance().addErrorMessage(sMsg, "PBA-[" + getTitle() + "]");
							actionValidationReady(null, false);
							getEditGridList().focus();
							getEditGridList().setSelectRow(index);
							getEditGridList().startEditing(index, IDX_DOCCODE);
						}
					});
				}
			}
		});
	}

	/***************************************************************************
	 * Add Deposit Method
	 **************************************************************************/
/*
	public void AddDepositReady(String deposit, String[] s, int idx, int total) {
		if ("-1".equals(deposit)) {
			Factory.getInstance().addErrorMessage("Add Deposit Item Failed"+"\n"+"Transaction cancelled");
		}
	};
*/
	public void AddDeposit(final String[] s, String SlipNo, String capturedate) {
		AddDeposit(s, SlipNo, capturedate, -1, -1);
	}

	public void AddDeposit(final String[] s, String SlipNo, String capturedate,
			final int idx, final int total) {
		String txCode = "ADDDEPOSIT";
		String[] para = new String[] {s[IDX_AMOUNT], SlipNo, s[1], capturedate, s[IDX_TXDATE]};

		QueryUtil.executeMasterAction(getUserInfo(), txCode, QueryUtil.ACTION_APPEND, para,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					AddDepositReady(mQueue.getReturnCode(), s, idx, total);
				} else {
					AddDepositReady("-1", s, idx, total);
				}
			}
		});
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(779, 528);
			actionPanel.add(getListPanel(), null);
			actionPanel.add(getParaPanel1(), null);
			actionPanel.add(getParaPanel2(), null);
			actionPanel.add(getDeptRegular(), null);
			actionPanel.add(getDeptSurcharge(), null);
			actionPanel.add(getCountDesc(), null);
			actionPanel.add(getCount(), null);
			actionPanel.add(getAmtBfdiscDesc(), null);
			actionPanel.add(getAmtBfdisc(), null);
		}
		return actionPanel;
	}

	public BasePanel getParaPanel1() {
		if (paraPanel1 == null) {
			paraPanel1 = new BasePanel();
			paraPanel1.setBounds(5, 5, 757, 60);
			paraPanel1.setBorders(true);
			paraPanel1.add(getSlipNoDesc(), null);
			paraPanel1.add(getSlipNo(), null);
			paraPanel1.add(getPatientDesc(), null);
			paraPanel1.add(getPatNo(), null);
			paraPanel1.add(getPatName(), null);
			paraPanel1.add(getBedCodeDesc(), null);
			paraPanel1.add(getBedCode(), null);
			paraPanel1.add(getAdmissionDateDesc(), null);
			paraPanel1.add(getAdmissionDate(), null);
			paraPanel1.add(getDoctorDesc(), null);
			paraPanel1.add(getDocCode(), null);
			paraPanel1.add(getDocName(), null);
			paraPanel1.add(getAcmCodeDesc1(), null);
			paraPanel1.add(getAcmCode1(), null);
		}
		return paraPanel1;
	}

	public BasePanel getParaPanel2() {
		if (paraPanel2 == null) {
			paraPanel2 = new BasePanel();
			paraPanel2.setBounds(5, 75, 757, 60);
			paraPanel2.setBorders(true);
			paraPanel2.add(getStandardRateDesc(), null);
			paraPanel2.add(getStandardRate(), null);
			paraPanel2.add(getAcmCodeDesc2(), null);
			paraPanel2.add(getAcmCode2(), null);
			paraPanel2.add(getItmpkgCodeDesc(), null);
			paraPanel2.add(getItmpkgCode(), null);
			paraPanel2.add(getPkgCode(),null);
			paraPanel2.add(getTransactionDateDesc(), null);
			paraPanel2.add(getTransactionDate(), null);
			paraPanel2.add(getPackageJoinedDesc(), null);
			paraPanel2.add(getPackageJoined(), null);
			paraPanel2.add(getUnitDesc(), null);
			paraPanel2.add(getUnit(), null);
		}
		return paraPanel2;
	}


	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setEtchedBorder();
			ListPanel.setBounds(5, 150, 757, 300);
			ListPanel.add(getEditGridScrollPane());
		}
		return ListPanel;
	}

	public LabelBase getSlipNoDesc() {
		if (slipNoDesc == null) {
			slipNoDesc = new LabelBase();
			slipNoDesc.setText("Slip Number");
			slipNoDesc.setBounds(5, 5, 80, 20);
		}
		return slipNoDesc;
	}

	public TextReadOnly getSlipNo() {
		if (slipNo == null) {
			slipNo = new TextReadOnly();
			slipNo.setBounds(100, 5, 120, 20);
			slipNo.setWidth(125);
		}
		return slipNo;
	}

	public LabelBase getPatientDesc() {
		if (patientDesc == null) {
			patientDesc = new LabelBase();
			patientDesc.setText("Patient");
			patientDesc.setBounds(237, 5, 60, 20);
		}
		return patientDesc;
	}

	public TextReadOnly getPatNo() {
		if (patNo == null) {
			patNo = new TextReadOnly();
			patNo.setBounds(301, 5, 69, 20);
		}
		return patNo;
	}

	public TextReadOnly getPatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(374, 5, 190, 20);
		}
		return patName;
	}

	public LabelBase getBedCodeDesc() {
		if (bedCodeDesc == null) {
			bedCodeDesc = new LabelBase();
			bedCodeDesc.setText("Bed Code");
			bedCodeDesc.setBounds(575, 5, 78, 20);
		}
		return bedCodeDesc;
	}

	public TextReadOnly getBedCode() {
		if (bedCode == null) {
			bedCode = new TextReadOnly();
			bedCode.setBounds(650, 5, 99, 20);
		}
		return bedCode;
	}

	public LabelBase getAdmissionDateDesc() {
		if (admissionDateDesc == null) {
			admissionDateDesc = new LabelBase();
			admissionDateDesc.setText("Admission Date");
			admissionDateDesc.setBounds(5, 30, 90, 20);
		}
		return admissionDateDesc;
	}

	public TextReadOnly getAdmissionDate() {
		if (admissionDate == null) {
			admissionDate = new TextReadOnly();
			admissionDate.setBounds(100, 30, 120, 20);
			admissionDate.setWidth(125);
		}
		return admissionDate;
	}

	public LabelBase getDoctorDesc() {
		if (doctorDesc == null) {
			doctorDesc = new LabelBase();
			doctorDesc.setText("Doctor");
			doctorDesc.setBounds(237, 30, 60, 20);
		}
		return doctorDesc;
	}

	public TextReadOnly getDocCode() {
		if (docCode == null) {
			docCode = new TextReadOnly();
			docCode.setBounds(301, 30, 69, 20);
		}
		return docCode;
	}

	public TextReadOnly getDocName() {
		if (docName == null) {
			docName = new TextReadOnly();
			docName.setBounds(374, 30, 190, 20);
		}
		return docName;
	}

	public LabelBase getAcmCodeDesc1() {
		if (acmCodeDesc1 == null) {
			acmCodeDesc1 = new LabelBase();
			acmCodeDesc1.setText("Acm Code");
			acmCodeDesc1.setBounds(575, 30, 78, 20);
		}
		return acmCodeDesc1;
	}

	public TextReadOnly getAcmCode1() {
		if (acmCode1 == null) {
			acmCode1 = new TextReadOnly();
			acmCode1.setBounds(650, 30, 99, 20);
		}
		return acmCode1;
	}

	public LabelBase getStandardRateDesc() {
		if (standardRateDesc == null) {
			standardRateDesc = new LabelBase();
			standardRateDesc.setText("Standard Rate");
			standardRateDesc.setBounds(5, 5, 90, 20);
		}
		return standardRateDesc;
	}

	public CheckBoxBase getStandardRate() {
		if (standardRate == null) {
			standardRate = new CheckBoxBase();
			standardRate.setBounds(60, 5, 120, 20);
		}
		return standardRate;
	}

	public LabelBase getAcmCodeDesc2() {
		if (acmCodeDesc2 == null) {
			acmCodeDesc2 = new LabelBase();
			acmCodeDesc2.setText("Acm Code");
			acmCodeDesc2.setBounds(215, 5, 95, 20);
		}
		return acmCodeDesc2;
	}

	public ComboACMCode getAcmCode2() {
		if (acmCode2 == null) {
			acmCode2 = new ComboACMCode();
			acmCode2.setBounds(300, 5, 150, 20);
		}
		return acmCode2;
	}

	public LabelBase getItmpkgCodeDesc() {
		if (itmpkgCodeDesc == null) {
			itmpkgCodeDesc = new LabelBase();
			itmpkgCodeDesc.setText("Item/Pkg Code");
			itmpkgCodeDesc.setBounds(455, 5, 100, 20);
		}
		return itmpkgCodeDesc;
	}

	public TextItemCodeSearch getItmpkgCode() {
		if (ConstantsTransaction.TXN_CREDITITEMPER_MODE.equals(getParameter("TransactionMode"))) {
			return getItmpkgCodeCredit();
		} else {
			return getItmpkgCodeDebit();
		}
	}

	public TextItemCodeSearch getItmpkgCodeCredit() {
		if (itmpkgCodeCredit == null) {
			setParameter("itemCategoryExcl", ConstantsTransaction.ITEM_CATEGORY_DEBIT);

			itmpkgCodeCredit = new TextItemCodeSearch(ConstantsTransaction.ITEM_CATEGORY_DEBIT);
			itmpkgCodeCredit.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyDown(ComponentEvent event) {
					if (event.getKeyCode() == KeyCodes.KEY_TAB) {
						if (getEditGridList().getRowCount() > 0) {
							int selRow = lastListCount > 0 && lastListCount < getEditGridList().getRowCount() ? lastListCount : 0;
							getEditGridList().setSelectRow(selRow);
							getEditGridList().startEditing(selRow, IDX_AMOUNT);
						}
					}
				}

				@Override
				public void componentKeyPress(ComponentEvent event) {
					if (event.getKeyCode() == 13 && getItmpkgCode().getText().length() > 5) {
						getNodeValueFromStr(getItmpkgCode().getText(), "BT,PID,LABN");
					}
				}
			});

			itmpkgCodeCredit.setBounds(545, 5, 130, 20);
		}
		return itmpkgCodeCredit;
	}

	public TextItemCodeSearch getItmpkgCodeDebit() {
		if (itmpkgCodeDebit == null) {
			setParameter("itemCategoryExcl", ConstantsTransaction.ITEM_CATEGORY_CREDIT);

			itmpkgCodeDebit = new TextItemCodeSearch(ConstantsTransaction.ITEM_CATEGORY_CREDIT);
			itmpkgCodeDebit.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyDown(ComponentEvent event) {
					if (event.getKeyCode() == KeyCodes.KEY_TAB) {
						if (getEditGridList().getRowCount() > 0) {
							if (!(getEditGridList().getSelectedRow() >= 0)) {
								getEditGridList().setSelectRow(0);
							}
							getEditGridList().startEditing(getEditGridList().getSelectedRow(), IDX_AMOUNT);
						}
					}
				}

				@Override
				public void componentKeyPress(ComponentEvent event) {
					if (event.getKeyCode() == 13 && getItmpkgCode().getText().length() > 5) {
						getNodeValueFromStr(getItmpkgCode().getText(), "BT,PID,LABN");
					}
				}
			});

			itmpkgCodeDebit.setBounds(545, 5, 130, 20);
		}
		return itmpkgCodeDebit;
	}

	private ButtonBase getPkgCode() {
		if(btnPkgCode == null){
			btnPkgCode = new ButtonBase("Search Pkg", Resources.ICONS.search(), null){
				@Override
				public void onClick() {
					getDlgPackageSearch().showPanel();
					getDlgPackageSearch().getPackageCode().focus();
				}
			};
			btnPkgCode.setBounds(675, 5, 80, 25);

		}
		return btnPkgCode;
	}

	private DlgPackageSearch getDlgPackageSearch() {
		if (dlgPackageSearch == null) {
			dlgPackageSearch = new DlgPackageSearch(getItmpkgCode());
		}
		return dlgPackageSearch;
	}

	public LabelBase getTransactionDateDesc() {
		if (transactionDateDesc == null) {
			transactionDateDesc = new LabelBase();
			transactionDateDesc.setText("Transaction Date");
			transactionDateDesc.setBounds(5, 30, 100, 20);
		}
		return transactionDateDesc;
	}

	public TextDate getTransactionDate() {
		if (transactionDate == null) {
			transactionDate = new TextDate();
			transactionDate.setBounds(110, 30, 100, 20);
		}
		return transactionDate;
	}

	public LabelBase getPackageJoinedDesc() {
		if (packageJoinedDesc == null) {
			packageJoinedDesc = new LabelBase();
			packageJoinedDesc.setText("Pkg Joined");
			packageJoinedDesc.setBounds(215, 30, 95, 20);
		}
		return packageJoinedDesc;
	}

	public ComboPkgJoined getPackageJoined() {
		if (packageJoined == null) {
			packageJoined = new ComboPkgJoined(memSLPNO);
			packageJoined.setBounds(300, 30, 150, 20);
		}
		return packageJoined;
	}

	public LabelBase getUnitDesc() {
		if (unitDesc == null) {
			unitDesc = new LabelBase();
			unitDesc.setText("Unit");
			unitDesc.setBounds(455, 30, 120, 20);
		}
		return unitDesc;
	}

	public TextNum getUnit() {
		if (unit == null) {
			unit = new TextNum(10, 0, false, false);
			unit.addKeyListener(new KeyListener() {
				public void componentKeyPress(ComponentEvent event) {
					if ((event.getKeyCode() < 48 || event.getKeyCode() > 57) &&
							event.getKeyCode() != 8) {
						event.stopEvent();
					}
				}
			});
			unit.setBounds(545, 30, 130, 20);
		}
		return unit;
	}

	public ButtonBase getDeptRegular() {
		if (deptRegular == null) {
			deptRegular = new ButtonBase() {
				@Override
				public void onClick() {
					Factory.getInstance().showMask();
					QueryUtil.executeMasterBrowse(
							Factory.getInstance().getUserInfo(),
							ConstantsTx.DEPT_SUB_CHRG_TXCODE,
							new String[] {
								Factory.getInstance().getUserInfo().getDeptCode(),
								"R",
								getSlipNo().getText(),
								getParameter("OTLID")
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								if (mQueue.getContentField()[0] != null && mQueue.getContentField()[0].length() > 0) {
									if (!"PAYME".equals(mQueue.getContentField()[0])) {
										getItmpkgCode().setText(mQueue.getContentField()[0]);
										updateCount();
										appendAction();
									}
								}
							} else {
								Factory.getInstance().addErrorMessage("Please make sure you enterend all the fields used for calculation.");
							}
						}
					});
				}
			};
			deptRegular.setText("Dept. Regular");
			deptRegular.setBounds(5, 455, 120, 25);
		}
		return deptRegular;
	}

	public ButtonBase getDeptSurcharge() {
		if (deptSurcharge == null) {
			deptSurcharge = new ButtonBase() {
				@Override
				public void onClick() {
					Factory.getInstance().showMask();
					QueryUtil.executeMasterBrowse(
							Factory.getInstance().getUserInfo(),
							ConstantsTx.DEPT_SUB_CHRG_TXCODE,
							new String[] {
								Factory.getInstance().getUserInfo().getDeptCode(),
								"S",
								getSlipNo().getText(),
								getParameter("OTLID")
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								if (!"PAYME".equals(mQueue.getContentField()[0])) {
									getItmpkgCode().setText(mQueue.getContentField()[0]);
									TmpAmount = 0.0;
									if (ConstantsProperties.OT == 1) {
										bAmount = true;
										if (mQueue.getContentField()[1] != null) {
											TmpAmount =  Double.parseDouble(mQueue.getContentField()[1]);
										}
									}
									updateCount();
									appendAction();
								}
							} else {
								Factory.getInstance()
									.addErrorMessage("Please make sure you enterend all the fields used for calculation.");
							}
						}
					});
				}
			};
			deptSurcharge.setText("Dept. Surcharge");
			deptSurcharge.setBounds(130, 455, 120, 25);
		}
		return deptSurcharge;
	}

	public LabelBase getCountDesc() {
		if (countDesc == null) {
			countDesc = new LabelBase();
			countDesc.setText("Count");
			countDesc.setBounds(460, 455, 60, 20);
		}
		return countDesc;
	}

	public TextReadOnly getCount() {
		if (count == null) {
			count = new TextReadOnly();
			count.setBounds(525, 455, 60, 20);
			count.setText(ZERO_VALUE);
		}
		return count;
	}

	public LabelBase getAmtBfdiscDesc() {
		if (amtBfdiscDesc == null) {
			amtBfdiscDesc = new LabelBase();
			amtBfdiscDesc.setText("Amt before disc");
			amtBfdiscDesc.setBounds(600, 455, 100, 20);
		}
		return amtBfdiscDesc;
	}

	public TextReadOnly getAmtBfdisc() {
		if (amtBfdisc == null) {
			amtBfdisc = new TextReadOnly();
			amtBfdisc.setBounds(695, 455, 60, 20);
			amtBfdisc.setText(ZERO_VALUE);
		}
		return amtBfdisc;
	}

	private DlgAgreeRate getDlgAgreeRate() {
		if (dlgAgreeRate == null) {
			dlgAgreeRate = new DlgAgreeRate(getMainFrame());
		}
		return dlgAgreeRate;
	}
}