package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgConPceChange extends DialogBase{
	private final static int m_frameWidth = 750;
	private final static int m_frameHeight = 400;

	private BasePanel conPcePanel = null;
	private JScrollPane conPceScroll = null;
	private TableList conPceList = null;
	private LabelBase conPceExpDesc = null;
	private TextReadOnly conPceExp = null;

	private String memSlipNo = "";
	private String memPatType = "";
	private String memAcmCode = "";
	private String memNewCPS = "";
	private String memNewAcmCode = "";
	private String memTransactionID = "";

	private TableList capCol=CommonUtil.getRs2col(9);

	public DlgConPceChange(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Contractual Price Set Change");
		setContentPane(getConPcePanel());

		// change label
		getButtonById(OK).setText("Accept", 'A');
		getButtonById(CANCEL).setText("Ignore", 'I');
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void doOkAction() {
		storeBackgroundJob(getConPceList(), false);
		post();
		dispose();
	}
	
	@Override
	protected void doCancelAction() {
		post();
		dispose();
	}	

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slipNo, String patientType, String accomodationCode,
			String newCPSID, String newAccomodationCode, String transactionID) {
		showDialog(slipNo, patientType, accomodationCode, newCPSID, newAccomodationCode, transactionID, "N");
	}

	public void showDialog(String slipNo, String patientType, String accomodationCode,
			String newCPSID, String newAccomodationCode, String transactionID, String changeACM) {		
		memSlipNo = slipNo;
		memPatType = patientType;
		memAcmCode = accomodationCode;
		memNewCPS = newCPSID;
		memNewAcmCode = newAccomodationCode;
		memTransactionID = transactionID;
		
		QueryUtil.executeMasterBrowse(getUserInfo(), "CONPCECHANGE",
			new String[] {
							memSlipNo,
							memPatType,
							memAcmCode,
							memNewCPS,
							memNewAcmCode,
							memTransactionID,
							changeACM==null?(memAcmCode.equals(memNewAcmCode)?"N":"Y"):changeACM
			},
			new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getConPceList().setListTableContent(mQueue);
					storeBackgroundJob(removeTheSame(getConPceList()), true);
					
					if (getConPceList().getRowCount() > 0 ) {
						setVisible(true);
					} else {
						post();
					}
				} else {
					post();
				}
			}
		});
	}

	public void post() {
	}

	private void storeBackgroundJob(TableList list,boolean init) {
		int iCase = 0;
		if (list.getRowCount() <= 0) {
			return;
		}

		int[] noOfList = new int[list.getRowCount()];		
		
		for (int i = 0; i <list.getRowCount(); i++) {
			boolean bAuto = true;
			String[] rs = list.getRowContent(i);
				
			if (init) {
				iCase = ConstantsTransaction.GetNewCPSCases(rs[7], rs[8]);
				if (iCase == 4 || iCase == 7) {
					bAuto=false;
				} else if (iCase == 2|| iCase == 3|| iCase == 4||iCase == 6) {
					if (!rs[5].equals(rs[14]) || !rs[6].equals(rs[15])) {
						bAuto=false;
					}
				}
			}

			if (bAuto) {
				String[] row = new String[] {
								rs[0],  //STNID
								rs[16],	//NEWACMCODE
								rs[14],	//OLDBAMT
								rs[15],	//OLDDISC
								rs[17],	//NEWOAMT
								rs[9],	//NEWBAMT
								rs[10],	//NEWDISC
								rs[8],	//NEWCPSFLAG
								rs[18]	//NEWGLCCODE
						};

				capCol.addRow(row);
				noOfList[i]=1; // mark delete	
			}else{
				noOfList[i]=0;
			}
		}
				
		int arrSize = noOfList.length;
		for (int k = arrSize-1; k >= 0; k--) {
			if (noOfList[k]==1) {						
				list.removeRow(k);
			}
		}
	}

	private TableList removeTheSame(TableList list) {
		String changACM = null;
		
		changACM = getParamValue("ChangACM");
		
		if (list.getRowCount() <= 0) {
			return list;
		}

		for (int i = 0; i < list.getRowCount(); i++) {
			String[] rs=list.getRowContent(i);
			if ((rs[5].equals(rs[9]) && rs[6].equals(rs[10]) && rs[7].equals(rs[8]))) {
				if (changACM == null || changACM.length() <= 0 ) {
					list.removeRow(i);
					i = -1;
				}
			}
		}

		return list;
	}

	public BasePanel getConPcePanel() {
		if (conPcePanel == null) {
			conPcePanel = new BasePanel();
			conPcePanel.setBounds(5, 5, 750, 400);
			conPcePanel.add(getConPceScroll(), null);
			conPcePanel.add(getConPceExpDesc(), null);
			conPcePanel.add(getConPceExp(), null);
		}
		return conPcePanel;
	}

	public JScrollPane getConPceScroll() {
		if (conPceScroll == null) {
			conPceScroll = new JScrollPane();
			conPceScroll.setBounds(10, 10, 680, 250);
			conPceScroll.setViewportView(getConPceList());
		}
		return conPceScroll;
	}

	public TableList getConPceList() {
		if (conPceList == null) {
			conPceList = new TableList(new String[] {
							"STNID", "Seq", "Pkg Code", "Item Code", "Description",
							"BAmt", "Disc", "CPS Flag", "New Flag", "N. BAmt",
							"N. Disc", "Unit", "itmtype", "firststnbamt", "oldBAmt",
							"oldDisc", "newAcmCode", "newOAmt", "newGlcCode", "glccode"
					},
					new int[] {
							0, 80, 80 ,80, 120,
							80, 80, 80, 80, 80,
							80, 0, 0, 0, 0,
							0, 0, 0, 0, 0
					}

			) {
				public void onSelectionChanged() {
					if (getConPceList().getSelectedRow() > -1) {
						getConPceExp().setText("Change From "+
								getCPSDesc(getConPceList().getSelectedRowContent()[7])+
								" to "+
								getCPSDesc(getConPceList().getSelectedRowContent()[8]));
					} else {
						getConPceExp().resetText();
					}
				}
			};
//			conPceList.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
			conPceList.setBounds(0, 0, 670, 240);
		}
		return conPceList;
	}

	private String getCPSDesc(String cpsFlag) {
		if (cpsFlag == null || cpsFlag.isEmpty()) {
			return "Standard Rate";
		} else if (cpsFlag.equals("F")) {
			return "Standard Rate With CPS Fix Amount";
		} else if (cpsFlag.equals("P")) {
			return "Standard Rate With CPS Percentage Disc";
		} else if (cpsFlag.equals("S")) {
			return "Stat Rate";
		} else if (cpsFlag.equals("T")) {
			return "Stat Rate With CPS Fix Amount";
		} else if (cpsFlag.equals("U")) {
			return "Stat Rate With CPS Percentage Disc";
		}
		return "";
	}

	public LabelBase getConPceExpDesc() {
		if (conPceExpDesc == null) {
			conPceExpDesc = new LabelBase();
			conPceExpDesc.setText("Explanation");
			conPceExpDesc.setBounds(10, 270, 80, 20);
		}
		return conPceExpDesc;
	}

	public TextReadOnly getConPceExp() {
		if (conPceExp == null) {
			conPceExp = new TextReadOnly();
			conPceExp.setBounds(100, 270, 590, 20);
		}
		return conPceExp;
	}

	public TableList getCapCol() {
		return capCol;
	}
}