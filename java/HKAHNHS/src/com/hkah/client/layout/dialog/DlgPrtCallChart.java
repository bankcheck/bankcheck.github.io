package com.hkah.client.layout.dialog;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedListener;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboChartRequiredBy;
import com.hkah.client.layout.combobox.ComboPurpose;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgPrtCallChart extends DialogBase {

	private static final long serialVersionUID = 1L;
	private final static int m_frameWidth = 600;
	private final static int m_frameHeight = 550;

	private BasePanel prtCallChartPanel = null;
	private LabelBase infoDesc = null;
//	private LabelBase line = null;
	private LabelBase info = null;
	private LabelBase patNoDesc = null;
	private TextPatientNoSearch patNo = null;
	private LabelBase patNameDesc = null;
	private LabelBase patName = null;
	private LabelBase volume = null;
	private TableList volumeList = null;
	private JScrollPane volumeScrollPane = null;
	private LabelBase requiredByDesc = null;
	private ComboChartRequiredBy requiredBy = null;
	private LabelBase purposeDesc = null;
	private ComboPurpose purpose = null;
	private LabelBase urgentDesc = null;
	private CheckBoxBase urgent = null;
	private LabelBase remarkDesc = null;
	private TextString remark = null;
	private String patientName = null;

	private DlgMRTransfer transferDlg = null;

	private ButtonBase transfer = null;
	private ButtonBase print = null;
	private ButtonBase close = null;

	private int appLabNo = 0;
	private boolean fromReg = false;

	public DlgPrtCallChart(MainFrame owner) {
		super(owner, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Print Call Chart Label");
		setContentPane(getPrtCallChartPanel());

		// tab index
		int i = 0;
		getPatNo().setTabIndex(i++);
		getRequiredBy().setTabIndex(i++);
		getPurpose().setTabIndex(i++);
		getUrgent().setTabIndex(i++);
		getRemark().setTabIndex(i++);
		getTransfer().setTabIndex(i++);
		getPrint().setTabIndex(i++);
		getClose().setTabIndex(i++);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	@Override
	public TextPatientNoSearch getDefaultFocusComponent() {
		return getPatNo();
	}

	public void showDialog() {
		fromReg = false;
		setVisible(true);
		resetContent();
	}

	public void showDialog(String patNo) {
		fromReg = true;
		setVisible(true);
		resetContent();

		getPatNo().setText(patNo);
		setGrdData(patNo);
		getRequiredBy().focus();
	}

	private void resetContent() {
		getPatNo().resetText();
		getPatName().resetText();
		getVolumeList().removeAllRow();
		getRequiredBy().clear();
		if (getPurpose().getKeySize() > 0) {
			getPurpose().setSelectedIndex(0);
		} else {
			getPurpose().clear();
		}
		getUrgent().setValue(false);
		getRemark().resetText();

		getTransfer().setEnabled(false);
		getPrint().setEnabled(false);

		getPatNo().fireEvent(Events.OnBlur);
		getPatNo().requestFocus();
	}

	private void prePrint() {
		if (appLabNo < 1) {
			return;
		}
		final String lblType = getMainFrame().getSysParameter("LBLTYP");

		QueryUtil.executeMasterAction(
				Factory.getInstance().getUserInfo(),
				ConstantsTx.MEDRECDTL_TXCODE, QueryUtil.ACTION_APPEND,
				new String[] {
					getRequiredBy().getText(),
					getRequiredBy().getDisplayText(),
					getPurpose().getDisplayText(),
					Factory.getInstance().getUserInfo().getUserID(),
					CommonUtil.getComputerName(),
					getVolumeList().getSelectedRowContent()[0],
					getPatNo().getText()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if ("A".toUpperCase().equals(lblType)) {
						if (appLabNo > 0) {
							//print label
							printPickLstLabel();
						} else {
							Factory.getInstance().addErrorMessage("Appointment label number is not set.");
						}
					} else if ("B".toUpperCase().equals(lblType)) {
						printLabel();
					}
				} else {
					Factory.getInstance().addErrorMessage("Printing call chart label failed.");
				}
			}
		});
	}

	private void printPickLstLabel() {
		String mrhvollab = null;
		int temp = Integer.parseInt(volumeList.getSelectedRowContent()[0]);
		if (temp <= 0) {
			mrhvollab = "00";
		} else {
			int volNo = Integer.parseInt(volumeList.getSelectedRowContent()[0]);
			if (volNo > 9) {
				mrhvollab = String.valueOf(volNo);
			} else {
				mrhvollab = "0" + String.valueOf(volNo);
			}
		}

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {
					"MEDRECHDR H, MEDRECDTL D, MEDRECLOC L, DOCTOR DOC",
					"H.PATNO||'/'||H.MRHVOLLAB AS MEDRECID, "+
					"L.MRLDESC AS LOCATION, H.MRHVOLLAB AS VOLNUMBER, " +
					"DOC.DOCFNAME||' '||DOC.DOCGNAME AS DOCNAME",
					"H.PATNO = '" + getPatNo().getText().trim() + "' " +
					"AND D.DOCCODE = DOC.DOCCODE(+) " +
					"AND H.MRHVOLLAB = '" + mrhvollab + "' " +
					"AND H.MRDID = D.MRDID " +
					"AND NVL(D.MRLID_R, D.MRLID_L) = L.MRLID"
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					Map<String, String> map = new HashMap<String, String>();
					map.put("DOCNAME", getRequiredBy().getDisplayText());
					map.put("BKGSDATE", DateTimeUtil.getCurentTimeWithoutSecond(0) +
										" (" + DateTimeUtil.getCurrentDate(0) + ")");
					map.put("PATNO", getPatNo().getText().trim());
					map.put("VOLNUM", mQueue.getContentField()[2]);
					map.put("LOCATION", mQueue.getContentField()[1]);
					map.put("LOCATIONDOCNAME", mQueue.getContentField()[3]);
					map.put("SENDTO", CommonUtil.getComputerName());
					map.put("PATNAME", patientName);

					if (!PrintingUtil.print(getMainFrame().getSysParameter("PRTRMEDLBL"),"PickLstLbl", map,getPatName().getText())) {
						Factory.getInstance().addErrorMessage("Printing call chart label failed.");
					}
				} else {
					Factory.getInstance().addErrorMessage("Printing call chart label failed.");
				}
				resetContent();
				layout();
			}
		});
	}

	private void printLabel() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "patient ", "patfname || ' ' || patgname,'dlgprtcallcht' ", "patno = '"+getPatNo().getText().trim() + "'" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(final MessageQueue mQueue) {
				if (mQueue.success()) {
					Map<String, String> map = new HashMap<String, String>();

					String mrhvollab = null;
					int temp = Integer.parseInt(volumeList.getSelectedRowContent()[0]);
					if (temp <= 0) {
						mrhvollab = "00";
					} else {
						int volNo = Integer.parseInt(volumeList.getSelectedRowContent()[0]);
						if (volNo > 9) {
							mrhvollab = String.valueOf(volNo);
						} else {
							mrhvollab = "0"+String.valueOf(volNo);
						}
					}
					map.put("SteName", getUserInfo().getSiteName());
					map.put("Volume", "(" + mrhvollab + ")");
					map.put("Required", getRequiredBy().getDisplayText());
					map.put("Urgent", getUrgent().isSelected()?"U":"");
					map.put("Remark",getRemark().getText());
					map.put("Purpose", getPurpose().getDisplayText());
					System.out.println("---Call Chart(Call / Trf Cht)---");
					System.out.println("Pat No: "+getPatNo().getText());
					System.out.println("Location: "+CommonUtil.getComputerName());
					System.out.println("Required By: "+getRequiredBy().getDisplayText());
					System.out.println("Remark: "+getRemark().getText());

					if (!PrintingUtil.print(getMainFrame().getSysParameter("PRTRMEDLBL"),
								"PrtCallCht", map, null,
								new String[]{
									mQueue.getContentField()[0],
									getPatNo().getText().trim(),getUserInfo().getUserName(),
									CommonUtil.getComputerName(),getUserInfo().getSiteCode(),
									getMainFrame().getSysParameter("AppLabNum")
								},
								new String[] {"bkgname","patno","patnoA",
									"patnoB","patnoC","patnoD",
									"patnoE","docname","spcname",
									"bkgsdate2","bkgsdate","stename",
									"isStaff","alert"
								}, 2)) {
						Factory.getInstance().addErrorMessage("Printing call chart label failed.");
						System.out.println("Result:Print Fail");
					}
					System.out.println("--------------------------------");
					resetContent();
					layout();
				}
			}
		});
	}

	public void setGrdData(final String patNo) {
		//String CName="";
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"patmercht", "to_patno", "fm_patno = '" + patNo + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					final String MergePatNo = mQueue.getContentField()[0];
					if (MergePatNo != null && MergePatNo.length() > 0) {
						MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, "Patient " + patNo + " has been merged to Patient " + MergePatNo + " Do you want to load Patient " + MergePatNo,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									getPatNo().setText(MergePatNo);
									setGrdData(MergePatNo);
								}
							}
						});
						return;
					}
				}

				getVolimeListData(patNo);

				getPatName().setText(ConstantsVariable.NA_VALUE);
				patientName = null;
				QueryUtil.executeMasterFetch(
						getUserInfo(), "PATIENTBYNO", new String[] {patNo},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							String eName = mQueue.getContentField()[0] + " " + mQueue.getContentField()[1];
							if (eName.length() > 1) {
								getPatName().setText(eName);
								patientName = eName;
							}

							if (mQueue.getContentField()[6].length() > 0) {
								getPatName().setText(eName + " (" + mQueue.getContentField()[6] + ")");
							}
						}
						getRequiredBy().focus();
					}
				});
			}
		});
	}

	public void getVolimeListData(String patNo) {
		getVolumeList().setListTableContent(
			ConstantsTx.LOOKUP_TXCODE,
			new String[] {
				"MedRecHdr h,MedRecMed m,medrecdtl t ,medrecloc l ",
				"h.mrhvollab,m.mrmdesc,l.mrldesc",
				"m.mrmid=h.mrmid and h.mrhsts='N' and h.mrdid = t.mrdid  " +
					"and decode(t.MrlID_R, null, t.MrlID_L ,t.MrlID_R) = l.mrlid " +
					"and patno= '"+patNo+"' order by mrhvollab desc "
			});
	}

	public DlgPrtCallChart getThis() {
		return this;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getPrtCallChartPanel() {
		if (prtCallChartPanel == null) {
			prtCallChartPanel = new BasePanel();
			prtCallChartPanel.setBounds(5, 5, 560, 500);
			prtCallChartPanel.add(getInfoDesc(), null);
			prtCallChartPanel.add(getInfo(), null);
			prtCallChartPanel.add(getPatNoDesc(), null);
			prtCallChartPanel.add(getPatNo(), null);
			prtCallChartPanel.add(getPatNameDesc(), null);
			prtCallChartPanel.add(getPatName(), null);
			prtCallChartPanel.add(getVolume(), null);
			prtCallChartPanel.add(getVolumeScrollPane(), null);
			prtCallChartPanel.add(getRequiredByDesc(), null);
			prtCallChartPanel.add(getRequiredBy(), null);
			prtCallChartPanel.add(getPurposeDesc(), null);
			prtCallChartPanel.add(getPurpose(), null);
			prtCallChartPanel.add(getUrgentDesc(), null);
			prtCallChartPanel.add(getUrgent(), null);
			prtCallChartPanel.add(getRemarkDesc(), null);
			prtCallChartPanel.add(getRemark(), null);
			prtCallChartPanel.add(getTransfer(), null);
			prtCallChartPanel.add(getPrint(), null);
			prtCallChartPanel.add(getClose(), null);
		}
		return prtCallChartPanel;
	}

	public LabelBase getInfoDesc() {
		if (infoDesc == null) {
			infoDesc = new LabelBase();
			infoDesc.setBounds(5, 5, 300, 20);
			infoDesc.setText("<html><B><U>Rules for Borrowing Medical Records:</U></B></html>");
		}
		return infoDesc;
	}

	public LabelBase getInfo() {
		if (info == null) {
			info = new LabelBase();
			info.setBounds(5, 30, 550, 125);
			StringBuffer content = new StringBuffer("<html><B>");
			content.append("1. Medical records are borrowed on the purpose of patient care, preparation of ");
			content.append("<br>&nbsp;&nbsp;&nbsp;&nbsp;medical report, audit, handling insurance inquiry and case review only.");
			content.append("<br>2. Medical records should be returned to MRD as soon as possible after using.");
			content.append("<br>3. Medical records are never to be removed from the hospital.");
			content.append("<br>4. The borrower has the responsibility to maintain the confidentiality, integrity and the");
			content.append("<br>&nbsp;&nbsp;&nbsp;&nbsp;availability of the medical records.");
			content.append("<br>5. All borrowers are required to comply with the correct procedures in borrowing");
			content.append("<br>&nbsp;&nbsp;&nbsp;&nbsp;records. Otherwise, the loan requests will be rejected by MRD.");
			content.append("</B></html>");
			info.setText(content.toString());
		}
		return info;
	}

	public LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setBounds(5, 180, 100, 20);
			patNoDesc.setText("Patient No:");
		}
		return patNoDesc;
	}

	public TextPatientNoSearch getPatNo() {
		if (patNo == null) {
			patNo = new TextPatientNoSearch() {
				@Override
				public void onBlur() {
					if (getPatNo().getText().length()>0) {
						setGrdData(getPatNo().getText().trim());
					}
				}

				@Override
				public void onEnter() {
					getVolumeList().removeAllRow();
					setGrdData(patNo.getText().trim());
				}
			};

			patNo.addListener(Events.KeyDown, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					getPatName().setText(ConstantsVariable.NA_VALUE);
					getPrint().setEnabled(false);
					getTransfer().setEnabled(false);
					getVolumeList().removeAllRow();
				}
			});

			patNo.setBounds(100, 180, 120, 20);
		}
		return patNo;
	}

	public LabelBase getPatNameDesc() {
		if (patNameDesc == null) {
			patNameDesc = new LabelBase();
			patNameDesc.setBounds(5, 205, 100, 20);
			patNameDesc.setText("Patient Name:");
		}
		return patNameDesc;
	}

	public LabelBase getPatName() {
		if (patName == null) {
			patName = new LabelBase();
			patName.setBounds(100, 205, 350, 20);
		}
		return patName;
	}

	public LabelBase getVolume() {
		if (volume == null) {
			volume = new LabelBase();
			volume.setBounds(5, 230, 100, 20);
			volume.setText("Volume");
		}
		return volume;
	}

	public TableList getVolumeList() {
		if (volumeList == null) {
			volumeList = new TableList(
					new String[] {"Volume#", "Media", "Current Location"},
					new int[] {120, 80, 220}) {
				@Override
				public void setListTableContentPost() {
					// set focus
					getRequiredBy().focus();
				}
			};

			volumeList.getSelectionModel().addSelectionChangedListener(
				new SelectionChangedListener<TableData>() {
					@Override
					public void selectionChanged(SelectionChangedEvent<TableData> se) {
						String media = null;
						if (getVolumeList().getSelectedRowContent() != null) {
							media = getVolumeList().getSelectedRowContent()[1];
						}

						if (media != null && "PAPER".equals(media.trim().toUpperCase())) {
							// check Transfer Btn
							getTransfer().setEnabled(!Factory.getInstance().isDisableFunction("cmdTransfer", "prtCallChart"));

							// check Print Btn
							getPrint().setEnabled(!Factory.getInstance().isDisableFunction("cmdPrint", "prtCallChart"));
						} else {
							getTransfer().setEnabled(false);
							getPrint().setEnabled(false);
						}
					}
				});

//			volumeList.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
//			volumeList.setBounds(90, 230, 460, 120);
		}
		return volumeList;
	}

	public JScrollPane getVolumeScrollPane() {
		if (volumeScrollPane == null) {
			volumeScrollPane = new JScrollPane();
			volumeScrollPane.setBounds(100, 230, 450, 120);
			volumeScrollPane.setViewportView(getVolumeList());
		}
		return volumeScrollPane;
	}

	public LabelBase getRequiredByDesc() {
		if (requiredByDesc == null) {
			requiredByDesc = new LabelBase();
			requiredByDesc.setBounds(5, 355, 100, 20);
			requiredByDesc.setText("Required By:");
		}
		return requiredByDesc;
	}

	public ComboChartRequiredBy getRequiredBy() {
		if (requiredBy == null) {
			requiredBy = new ComboChartRequiredBy() {
				@Override
				protected void resetContentPost() {
					super.resetContentPost();
					if (fromReg) {
						//getRequiredBy().setSelectedIndex(getRequiredBy().findModelByDisplayText("PBO"));
					}
				}
			};
			requiredBy.setBounds(100, 355, 450, 20);
			requiredBy.setForceSelection(false);
		}
		return requiredBy;
	}

	public LabelBase getPurposeDesc() {
		if (purposeDesc == null) {
			purposeDesc = new LabelBase();
			purposeDesc.setBounds(5, 380, 100, 20);
			purposeDesc.setText("Purpose:");
		}
		return purposeDesc;
	}

	public ComboPurpose getPurpose() {
		if (purpose == null) {
			purpose = new ComboPurpose(false);
			purpose.setBounds(100, 380, 450, 20);
		}
		return purpose;
	}

	public LabelBase getUrgentDesc() {
		if (urgentDesc == null) {
			urgentDesc = new LabelBase();
			urgentDesc.setBounds(5, 405, 100, 20);
			urgentDesc.setText("Urgent:");
		}
		return urgentDesc;
	}

	public CheckBoxBase getUrgent() {
		if (urgent == null) {
			urgent = new CheckBoxBase();
			urgent.setBounds(100, 405, 20, 20);
		}
		return urgent;
	}

	public LabelBase getRemarkDesc() {
		if (remarkDesc == null) {
			remarkDesc = new LabelBase();
			remarkDesc.setBounds(5, 430, 100, 20);
			remarkDesc.setText("Remark(Reason)");
		}
		return remarkDesc;
	}

	public TextString getRemark() {
		if (remark == null) {
			remark = new TextString(40, false);
			remark.setBounds(100, 430, 450, 20);
		}
		return remark;
	}

	public DlgMRTransfer getTransferDlg() {
		if (transferDlg == null) {
			transferDlg = new DlgMRTransfer(getThis(), getMainFrame());
		}
		return transferDlg;
	}

	public ButtonBase getTransfer() {
		if (transfer == null) {
			transfer = new ButtonBase() {
				@Override
				public void onClick() {
					String volNo = getVolumeList().getSelectedRowContent()[0];
					if (volNo.length() <= 1) {
						volNo = "0"+volNo;
					}

					getTransferDlg().showDialog(getPatNo().getText(), volNo, getRequiredBy().getText(), getRequiredBy().getDisplayText(), getPurpose().getDisplayText());
				}
			};
			transfer.setText("Transfer", 'T');
			transfer.setBounds(150, 455, 90, 25);
		}
		return transfer;
	}

	public ButtonBase getPrint() {
		if (print == null) {
			print = new ButtonBase() {
				@Override
				public void onClick() {
					if (getRequiredBy().isEmpty()) {
						Factory.getInstance().addErrorMessage("Please input or select a required by doctor.");
						return;
					}

					if (getPurpose().isEmpty()) {
						Factory.getInstance().addErrorMessage("Please input or select a purpose.");
						return;
					}

					if (getPurpose().getText().length() > 50) {
						Factory.getInstance().addErrorMessage("Purpose's max length is 50.");
						return;
					}

					if (getPatNo().isEmpty()) {
						Factory.getInstance().addErrorMessage("Input patient number.");
						return;
					}

					if (getUrgent().isSelected()) {
						if (getRemark().isEmpty()) {
							Factory.getInstance().addErrorMessage("Please input remark.");
							return;
						}
						try {
							if (getRemark().getText().getBytes("UTF-8").length > 40) {
								Factory.getInstance().addErrorMessage("remark is too long.");
								return;
							}
						} catch (UnsupportedEncodingException e) {
							e.printStackTrace();
						}
					}

					QueryUtil.executeMasterFetch(
							Factory.getInstance().getUserInfo(),
							ConstantsTx.SYSTEMPARAMETER_TXCODE,
							new String[] { "AppLabNum" },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								try {
									if (Integer.parseInt(mQueue.getContentField()[1]) > 0) {
										appLabNo = Integer.parseInt(mQueue.getContentField()[1]);
									} else {
										appLabNo = 0;
									}
								} catch (Exception e) {
									appLabNo = 0;
								}
							} else {
								appLabNo = 0;
							}

							prePrint();
						}
					});
				}
			};
			print.setText("Print", 'P');
			print.setBounds(250, 455, 90, 25);
		}
		return print;
	}

	public ButtonBase getClose() {
		if (close == null) {
			close = new ButtonBase() {
				@Override
				public void onClick() {
					dispose();
				}
			};
			close.setText("Close", 'C');
			close.setBounds(350, 455, 90, 25);
		}
		return close;
	}
}