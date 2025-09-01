package com.hkah.client.tx.birth;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.util.Format;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.BLogSortby;
import com.hkah.client.layout.combobox.BLogStatus;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DHBirthLog extends MasterPanel {

	private static final String NOT_CONFIRMED = "Normal";
	private static final String SENT_REJECT = "Reject";
	private static final String MANUAL = "Manual";

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DHBIRTHLOG_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DHBIRTHLOG_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"",
			"",  //ID
			"BB Patient",
			"BB Name",
			"Date of Birth",
			//"Birth Return No",
			"Mother Patient",
			"Mother Name",
			"Status",
			"",
			"batchno",
			"senddate"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				0,
				60,
				120,
				80,
				//130,
				80,
				110,
				60,
				0,
				0,
				0
		};
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;

	private LabelBase BBDesc = null;
	private TextString BB = null;
	private LabelBase SendDateFromDesc = null;
	private TextDate SendDateFrom = null;
	private LabelBase SendDateToDesc = null;
	private TextDate SendDateTo = null;
	private LabelBase SortByDesc = null;
	private BLogSortby SortBy = null;
	private LabelBase MotherDesc = null;
	private TextString Mother = null;
	private LabelBase BBDOBFromDesc = null;
	private TextDate BBDOBFrom = null;
	private LabelBase BBDOBToDesc = null;
	private TextDate BBDOBTo = null;
	private LabelBase StatusDesc = null;
	private BLogStatus Status = null;
	private LabelBase BatchNoDesc = null;
	private TextString BatchNo = null;
	private LabelBase BirthReturnNoDesc = null;
	private TextString BirthReturnNo = null;

	private LabelBase SearchResultDesc = null;
	private LabelBase HistoryDesc = null;
	private LabelBase SearchCountDesc = null;
	private TextReadOnly SearchCount = null;
	private LabelBase HistoryCountDesc = null;
	private TextReadOnly HistoryCount = null;

	private TableList HistoryTable = null;
	private JScrollPane HistoryJScrollPane = null;

	private ButtonBase MH = null;
	private ButtonBase Export = null;
	private ButtonBase Remarks = null;
	private ButtonBase Close = null;

	private boolean bCmdManual = false;
	private boolean bCmdClose = false;
	private boolean bCmdRemarks = false;
	private boolean bCmdExport = false;

	/**
	 * This method initializes
	 *
	 */

	public DHBirthLog() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(5, 135, 430, 300);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getSearchCount().setText(ZERO_VALUE);
		getHistoryCount().setText(ZERO_VALUE);

		getMH().setEnabled(false);
		getExport().setEnabled(false);
		getRemarks().setEnabled(false);
		getClose().setEnabled(false);

	    bCmdManual = !isDisableFunction("cmdManual", "DHBirthLog");
	    bCmdClose = !isDisableFunction("cmdClose", "DHBirthLog");
	    bCmdRemarks = !isDisableFunction("cmdRemarks", "DHBirthLog");
	    bCmdExport = !isDisableFunction("cmdExport", "DHBirthLog");

	    enableButton(null);
		getStatus().setSelectedIndex(1);
		getSortBy().setSelectedIndex(3);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getMother();
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
		return new String[] {
				getBB().getText().trim(),
				getSendDateFrom().getText(),
				getSendDateTo().getText(),
				getMother().getText(),
				getBBDOBFrom().getText(),
				getBBDOBTo().getText(),
				getStatus().getText(),
				getBatchNo().getText(),
				getBirthReturnNo().getText(),
				getSortBy().getText()
		};
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
		// refresh history table
		showHistory();
	    enableButton(null);
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	@Override
	public void clearAction() {
		getMother().setText(EMPTY_VALUE);
		getBB().setText(EMPTY_VALUE);
		getBatchNo().setText(EMPTY_VALUE);
		getSendDateFrom().setText(EMPTY_VALUE);
		getSendDateTo().setText(EMPTY_VALUE);
		getBBDOBFrom().setText(EMPTY_VALUE);
		getBBDOBTo().setText(EMPTY_VALUE);
		getBirthReturnNo().getText();
		getStatus().setSelectedIndex(1);
		getSortBy().setSelectedIndex(3);
	}

	/*
	@Override
	public void rePostAction() {
		if ("YES".equals(getParameter("AFTER_ENTRY"))) {
			performList(false);
			resetParameter("AFTER_ENTRY");
		} else {
			searchAction();
		}
	}
*/
	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected void checkButtonEnable() {
		if (getListTable().getRowCount() > 0) {
			getMH().setEnabled(!isDisableFunction("cmdManual", "DHBirthLog") && SENT_REJECT.equals(getListSelectedRow()[7]));
			getExport().setEnabled(!isDisableFunction("cmdExport", "DHBirthLog") && MANUAL.equals(getListSelectedRow()[7]));
			getRemarks().setEnabled(!isDisableFunction("cmdRemarks", "DHBirthLog"));
			getClose().setEnabled(!isDisableFunction("cmdClose", "DHBirthLog") && MANUAL.equals(getListSelectedRow()[7]));
		} else {
			getMH().setEnabled(false);
			getExport().setEnabled(false);
			getRemarks().setEnabled(false);
			getClose().setEnabled(false);
		}
	}

	private void showHistory() {
		if (getListTable().getRowCount() > 0) {
			getHistoryTable().setListTableContent(ConstantsTx.DHBIRTHHIS_TXCODE, new String[] {getListSelectedRow()[2]});
		} else {
			getHistoryTable().removeAllRow();
		}
		checkButtonEnable();
	}

	private void manualHandling() {
		if (getListTable().getSelectedRow() >= 0) {
			final String batchno = getListSelectedRow()[9];
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "The batch: " + batchno + " will be handled manually.\nAre you sure to continue?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.DHBIRTHLOG_TXCODE, getActionType(),
								new String[] {batchno, "M", getUserInfo().getUserID()});
						searchAction();
					}
				}
			});
		}
	}

	private void remark() {
		if (getListTable().getSelectedRow() >= 0) {
			MessageBox box = MessageBoxBase.prompt("Remark:", "Remark", true);
			box.setButtons(MessageBox.OKCANCEL);
			box.getDialog().getButtonById(MessageBox.OK).setText("Cofirm");
			box.addCallback(new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					String str = Format.ellipse(be.getValue(), 80);
					if (str != null && str.trim().length()>0) {
						String[] inParam = new String[] {
								getListSelectedRow()[2], "Remark", getUserInfo().getUserID(),
								str,EMPTY_VALUE
						};

						QueryUtil.executeMasterAction(getUserInfo(),"DHBIRTHLOGHIST", QueryUtil.ACTION_APPEND, inParam,
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								// TODO Auto-generated method stub
								if (mQueue.success()) {
									showHistory();
								}
							}
						});
					}
				}
			});
		}
	}

	private void close() {
		if (getListTable().getSelectedRow() >= 0) {
			final String batchno = getListSelectedRow()[9];
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Are you sure to close the batch: " + batchno + "?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.DHBIRTHLOG_TXCODE, getActionType(),
								new String[] {batchno, "A", getUserInfo().getUserID()});
						searchAction();
					}
				}
			});
		}
	}

	private void export() {
/*
  Dim sBB_PatNo As String
    Dim sBatchNo As String
    Dim sSql As String
    Dim dServerDate As Date
    Dim sXmlFn As String
    Dim sXmlFn1 As String
    Dim sCertFn As String * 100
    Dim rstManual As Recordset
    Dim length As Long
    On Error GoTo errexport:
     length = GetIniSetting("default", "Certificate_dh", 100, sCertFn, 100, INI_PBA)

    If Trim(sCertFn) = "" Or Dir(Trim(sCertFn), vbNormal + vbHidden + vbSystem + vbReadOnly) = "" Then
        MsgBox "The certificate doesn't exist. Please check PBA.ini.", vbExclamation
        Exit Sub
    End If

    sBB_PatNo = GrdSearch.TextMatrix(GrdSearch.Row, 1)
    sBatchNo = GrdSearch.TextMatrix(GrdSearch.Row, 7)

    If MsgBox("Are you sure to export the batch: " & sBatchNo & "?", vbQuestion + vbYesNo) = vbNo Then Exit Sub

    sSql = " SELECT dtl.*,xml.sourcecode,xml.prohoscdelst,xml.filerefno " & _
           " FROM dhbirthdtl dtl,dhxml xml " & _
           " where dtl.batchno=xml.batchno " & _
           " and dtl.recstatus= '" & getStatus(MANUAL) & "'" & _
           " and dtl.batchno = '" & sBatchNo & "'"

    Set rstManual = MainDef.Database.OpenRecordset(sSql, dbOpenSnapshot)

    sXmlFn = sBatchNo
    dServerDate = GetServerDate(MainDef.Database)

    cdExport.DialogTitle = "Export data to file"
    cdExport.FileName = sXmlFn
    cdExport.Filter = "Xml file (*.xml)"
    cdExport.ShowSave

    If Not CreateDHXML(True, cdExport.FileName, dServerDate, rstManual) Then
        Exit Sub
    End If

    sXmlFn = cdExport.FileName
    sXmlFn1 = sXmlFn & ".p7m"
    FileCopy sXmlFn, sXmlFn1

    Call encryptFile(sXmlFn1, sCertFn)
    cmdExport.Enabled = False

    MainDef.BeginTrans
    Dim rst_close As Recordset
    Set rst_close = MainDef.Database.OpenRecordset("select bbpatno from dhbirthdtl where batchno = '" & sBatchNo & "'", dbOpenSnapshot)
    rst_close.MoveFirst
    While Not rst_close.EOF
        sSql = InsertDHbirthhistory("" & rst_close("bbpatno"), "Y", "Exported", CurrentUser.UserID)
        MainDef.Database.Execute sSql
        rst_close.MoveNext
    Wend
    MainDef.CommitTrans

    rst_close.Close
    Set rst_close = Nothing
    Exit Sub
errexport:
    MainDef.RollBack
    Err.Raise Err.Number & vbCrLf & Err.Description
 */
	}

	private void encryptFile(String fn, String receiverCert) {
/*

    Dim Content  'file's content buffer,before encrypt
    Dim Message  'file's content buffer,after encrypt

    Dim cert As CAPICOM.Certificate
    Set cert = New CAPICOM.Certificate

    Dim oenvelopeddata As CAPICOM.EnvelopedData
    Set oenvelopeddata = New CAPICOM.EnvelopedData

    cert.Load (receiverCert)

    oenvelopeddata.Recipients.Clear
    oenvelopeddata.Recipients.Add cert

    LoadFile fn, Content

    oenvelopeddata.Content = Content
    Message = oenvelopeddata.Encrypt

    savefile fn, Message

    Set oenvelopeddata = Nothing
 */
	}

	private void loadFile() {
/*
    Dim fso As New FileSystemObject

    If Dir(FileName, vbNormal) = "" Then
        MsgBox "Error: File " & FileName & " not found."
    End If


    Dim ts
    Set ts = fso.OpenTextFile(FileName, ForReading)
    Buffer = ts.ReadAll
 */
	}

	private void saveFile() {
/*
    Dim fso As New FileSystemObject

    Dim ts
    Set ts = fso.OpenTextFile(FileName, ForWriting, True)
    ts.Write Buffer
 */
	}

	private boolean validateAllDate() {
		boolean validateAllDate = true;
		if (!getSendDateFrom().isEmpty() &&
				!getSendDateFrom().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Date.", getSendDateFrom());
			validateAllDate = false;
		} else if (!getSendDateTo().isEmpty() &&
				!getSendDateTo().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Date.", getSendDateTo());
			validateAllDate = false;
		} else if (!getBBDOBFrom().isEmpty() &&
				!getBBDOBFrom().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Date.", getBBDOBFrom());
			validateAllDate = false;
		} else if (!getBBDOBTo().isEmpty() &&
				!getBBDOBTo().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Date.", getBBDOBTo());
			validateAllDate = false;
		}
		return validateAllDate;
	}
	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void performListPost() {
		if (getListTable().getRowCount()>0) {
			getSearchCount().setText(String.valueOf(getListTable().getRowCount()));
//			checkButtonEnable();
			getListTable().focus();
			if (bCmdManual) {
				getMH().setEnabled(SENT_REJECT.equals(getListSelectedRow()[7]));
			}

			if (bCmdExport) {
				getExport().setEnabled(MANUAL.equals(getListSelectedRow()[7]));
			}

			if (bCmdClose) {
				getClose().setEnabled(MANUAL.equals(getListSelectedRow()[7]));
			}

			if (bCmdRemarks) {
				getRemarks().setEnabled(true);
			}
		} else{
			getMH().setEnabled(false);
			getExport().setEnabled(false);
			getClose().setEnabled(false);
			getRemarks().setEnabled(false);
			Factory.getInstance().addErrorMessage("No record is found");
		}
	}

	@Override
	public void searchAction() {
		if (validateAllDate()) {
			getHistoryTable().removeAllRow();
			super.searchAction();
		}
	}

	@Override
	public void acceptAction() {
		if (getListTable().getSelectedRow() >= 0) {
			if (NOT_CONFIRMED.equals(getListTable().getSelectedRowContent()[7]) ||
					MANUAL.equals(getListTable().getSelectedRowContent()[7])) {
				setParameter("sCanEdit", "YES");
			} else {
				setParameter("sCanEdit", "NO");
			}

			if (NOT_CONFIRMED.equals(getListTable().getSelectedRowContent()[7])) {
				setParameter("sCanConfirm", "YES");
			} else {
				setParameter("sCanConfirm", "NO");
			}

			setParameter("BB_PATNO", getListTable().getSelectedRowContent()[2]);

			showPanel(new DHBirthEntry());
		}
	}

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();

		getSearchButton().setEnabled(true);
		getAcceptButton().setEnabled(getListTable().getRowCount() > 0);
		getClearButton().setEnabled(true);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(884, 490);
			leftPanel.add(getParaPanel(), null);
			leftPanel.add(getJScrollPane());
			leftPanel.add(getHistoryJScrollPane(), null);
			leftPanel.add(getSearchResultDesc(), null);
			leftPanel.add(getSearchCountDesc(), null);
			leftPanel.add(getSearchCount(), null);
			leftPanel.add(getHistoryDesc(), null);
			leftPanel.add(getHistoryCountDesc(), null);
			leftPanel.add(getHistoryCount(), null);
			leftPanel.add(getMH(), null);
			leftPanel.add(getExport(), null);
			leftPanel.add(getRemarks(), null);
			leftPanel.add(getClose(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			//leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	public LabelBase getSearchResultDesc() {
		if (SearchResultDesc == null) {
			SearchResultDesc = new LabelBase();
			SearchResultDesc.setText("Search Result");
			SearchResultDesc.setBounds(5, 112, 130, 20);
		}
		return SearchResultDesc;
	}

	public LabelBase getHistoryDesc() {
		if (HistoryDesc == null) {
			HistoryDesc = new LabelBase();
			HistoryDesc.setText("History");
			HistoryDesc.setBounds(440, 112, 44, 20);
		}
		return HistoryDesc;
	}

	public LabelBase getSearchCountDesc() {
		if (SearchCountDesc == null) {
			SearchCountDesc = new LabelBase();
			SearchCountDesc.setText("Count");
			SearchCountDesc.setBounds(6, 435, 44, 20);
		}
		return SearchCountDesc;
	}

	public TextReadOnly getSearchCount() {
		if (SearchCount == null) {
			SearchCount = new TextReadOnly();
			SearchCount.setBounds(49, 435, 44, 20);
		}
		return SearchCount;
	}

	public LabelBase getHistoryCountDesc() {
		if (HistoryCountDesc == null) {
			HistoryCountDesc = new LabelBase();
			HistoryCountDesc.setText("Count");
			HistoryCountDesc.setBounds(444, 435, 41, 20);
		}
		return HistoryCountDesc;
	}

	public TextReadOnly getHistoryCount() {
		if (HistoryCount == null) {
			HistoryCount = new TextReadOnly();
			HistoryCount.setBounds(484, 435, 44, 20);
		}
		return HistoryCount;
	}

	public ButtonBase getMH() {
		if (MH == null) {
			MH = new ButtonBase() {
				@Override
				public void onClick() {
					manualHandling();
				}
			};
			MH.setText("Manual Handing");
			MH.setBounds(5, 460, 132, 25);
		}
		return MH;
	}

	public ButtonBase getExport() {
		if (Export == null) {
			Export = new ButtonBase() {
				@Override
				public void onClick() {
					//add something
					export();
				}
			};
			Export.setText("Export");
			Export.setBounds(141, 460, 76, 25);
		}
		return Export;
	}

	public ButtonBase getRemarks() {
		if (Remarks == null) {
			Remarks = new ButtonBase() {
				@Override
				public void onClick() {
					remark();
				}
			};
			Remarks.setText("Remarks");
			Remarks.setBounds(222, 460, 91, 25);
		}
		return Remarks;
	}

	public ButtonBase getClose() {
		if (Close == null) {
			Close = new ButtonBase() {
				@Override
				public void onClick() {
					close();
				}
			};
			Close.setText("Close");
			Close.setBounds(317, 460, 62, 25);
		}
		return Close;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setEtchedBorder();
			ParaPanel.add(getBBDesc(), null);
			ParaPanel.add(getBB(), null);
			ParaPanel.add(getSendDateFromDesc(), null);
			ParaPanel.add(getSendDateFrom(), null);
			ParaPanel.add(getSendDateToDesc(), null);
			ParaPanel.add(getSendDateTo(), null);
			ParaPanel.add(getSortByDesc(), null);
			ParaPanel.add(getSortBy(), null);
			ParaPanel.add(getMotherDesc(), null);
			ParaPanel.add(getMother(), null);
			ParaPanel.add(getBBDOBFromDesc(), null);
			ParaPanel.add(getBBDOBFrom(), null);
			ParaPanel.add(getBBDOBToDesc(), null);
			ParaPanel.add(getBBDOBTo(), null);
			ParaPanel.add(getStatusDesc(), null);
			ParaPanel.add(getStatus(), null);
			ParaPanel.add(getBatchNoDesc(), null);
			ParaPanel.add(getBatchNo(), null);
			ParaPanel.add(getBirthReturnNoDesc(), null);
			ParaPanel.add(getBirthReturnNo(), null);
			ParaPanel.setBounds(5, 5, 850, 102);
		}
		return ParaPanel;
	}

	public LabelBase getBBDesc() {
		if (BBDesc == null) {
			BBDesc = new LabelBase();
			BBDesc.setText("BB #:");
			BBDesc.setBounds(10, 40, 64, 20);
		}
		return BBDesc;
	}

	public TextString getBB() {
		if (BB == null) {
			BB = new TextString();
			BB.setBounds(74, 40, 114, 20);
		}
		return BB;
	}

	public LabelBase getSendDateFromDesc() {
		if (SendDateFromDesc == null) {
			SendDateFromDesc = new LabelBase();
			SendDateFromDesc.setText("Send Date From:");
			SendDateFromDesc.setBounds(199, 10, 100, 20);
		}
		return SendDateFromDesc;
	}

	public TextDate getSendDateFrom() {
		if (SendDateFrom == null) {
			SendDateFrom = new TextDate() {
				public void onBlur() {
					if (!SendDateFrom.isEmpty() &&
							!SendDateFrom.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", SendDateFrom);
					}
				}
			};
			SendDateFrom.setBounds(292, 10, 120, 20);
		}
		return SendDateFrom;
	}

	public LabelBase getSendDateToDesc() {
		if (SendDateToDesc == null) {
			SendDateToDesc = new LabelBase();
			SendDateToDesc.setText("To:");
			SendDateToDesc.setBounds(440, 10, 21, 20);
		}
		return SendDateToDesc;
	}

	public TextDate getSendDateTo() {
		if (SendDateTo == null) {
			SendDateTo = new TextDate() {
				public void onBlur() {
					if (!SendDateTo.isEmpty() &&
							!SendDateTo.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", SendDateTo);
					}
				}
			};
			SendDateTo.setBounds(460, 10, 120, 20);
		}
		return SendDateTo;
	}

	public LabelBase getSortByDesc() {
		if (SortByDesc == null) {
			SortByDesc = new LabelBase();
			SortByDesc.setText("Sort By:");
			SortByDesc.setBounds(600, 10, 53, 20);
		}
		return SortByDesc;
	}

	public BLogSortby getSortBy() {
		if (SortBy == null) {
			SortBy = new BLogSortby();
			SortBy.setBounds(660, 10, 114, 20);
		}
		return SortBy;
	}

	public LabelBase getMotherDesc() {
		if (MotherDesc == null) {
			MotherDesc = new LabelBase();
			MotherDesc.setText("Mother #:");
			MotherDesc.setBounds(10, 10, 64, 20);
		}
		return MotherDesc;
	}

	public TextString getMother() {
		if (Mother == null) {
			Mother = new TextString();
			Mother.setBounds(73, 10, 114, 20);
		}
		return Mother;
	}

	public LabelBase getBBDOBFromDesc() {
		if (BBDOBFromDesc == null) {
			BBDOBFromDesc = new LabelBase();
			BBDOBFromDesc.setText("BB D.O.B.From:");
			BBDOBFromDesc.setBounds(199, 40, 93, 20);
		}
		return BBDOBFromDesc;
	}

	public TextDate getBBDOBFrom() {
		if (BBDOBFrom == null) {
			BBDOBFrom = new TextDate() {
				public void onBlur() {
					if (!BBDOBFrom.isEmpty() &&
							!BBDOBFrom.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", BBDOBFrom);
					}
				}
			};
			BBDOBFrom.setBounds(292, 40, 120, 20);
		}
		return BBDOBFrom;
	}

	public LabelBase getBBDOBToDesc() {
		if (BBDOBToDesc == null) {
			BBDOBToDesc = new LabelBase();
			BBDOBToDesc.setText("To:");
			BBDOBToDesc.setBounds(440, 40, 22, 20);
		}
		return BBDOBToDesc;
	}

	public TextDate getBBDOBTo() {
		if (BBDOBTo == null) {
			BBDOBTo = new TextDate() {
				public void onBlur() {
					if (!BBDOBTo.isEmpty() &&
							!BBDOBTo.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", BBDOBTo);
					}
				}
			};
			BBDOBTo.setBounds(460, 40, 120, 20);
		}
		return BBDOBTo;
	}

	public LabelBase getStatusDesc() {
		if (StatusDesc == null) {
			StatusDesc = new LabelBase();
			StatusDesc.setText("Status:");
			StatusDesc.setBounds(600, 40, 53, 20);
		}
		return StatusDesc;
	}

	public BLogStatus getStatus() {
		if (Status == null) {
			Status = new BLogStatus();
			Status.setBounds(660, 40, 114, 20);
		}
		return Status;
	}

	public LabelBase getBatchNoDesc() {
		if (BatchNoDesc == null) {
			BatchNoDesc = new LabelBase();
			BatchNoDesc.setText("Batch No.:");
			BatchNoDesc.setBounds(10, 70, 64, 20);
		}
		return BatchNoDesc;
	}

	public TextString getBatchNo() {
		if (BatchNo == null) {
			BatchNo = new TextString();
			BatchNo.setBounds(73, 70, 114, 20);
		}
		return BatchNo;
	}

	public LabelBase getBirthReturnNoDesc() {
		if (BirthReturnNoDesc == null) {
			BirthReturnNoDesc = new LabelBase();
			BirthReturnNoDesc.setText("Birth Return No.:");
			BirthReturnNoDesc.setBounds(199, 70, 93, 20);
		}
		return BirthReturnNoDesc;
	}

	public TextString getBirthReturnNo() {
		if (BirthReturnNo == null) {
			BirthReturnNo = new TextString();
			BirthReturnNo.setBounds(292, 70, 114, 20);
		}
		return BirthReturnNo;
	}

	private JScrollPane getHistoryJScrollPane() {
		if (HistoryJScrollPane == null) {
			HistoryJScrollPane = new JScrollPane();
			HistoryJScrollPane.setViewportView(getHistoryTable());
			HistoryJScrollPane.setBounds(440, 135, 416, 300);
		}
		return HistoryJScrollPane;
	}

	private TableList getHistoryTable() {
		if (HistoryTable == null) {
			HistoryTable = new TableList(getDVATableColumnNames(), getDVATableColumnWidths()) {
				public void setListTableContentPost() {
					if (getRowCount() > 0) {
						getHistoryCount().setText(String.valueOf(getHistoryTable().getRowCount()));
					} else {
						getHistoryCount().setText(ZERO_VALUE);
					}
				}
			};
			HistoryTable.setTableLength(getListWidth());
			//PatStatusTable.setColumnClass(0, ComboPackage.class, true);
			//PatStatusTable.setColumnClass(1, String.class, true);
		}
		return HistoryTable;
	}

	protected String[] getDVATableColumnNames() {
		return new String[] {
				"","","",
				"Manual",
				"Status",
				"By",
				"Date/Time",
				"Remark"};
	}

	protected int[] getDVATableColumnWidths() {
		return new int[] { 10,0,0,55,70,60,120,200};
	}
}