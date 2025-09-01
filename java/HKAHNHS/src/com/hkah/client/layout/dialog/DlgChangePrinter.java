  	package com.hkah.client.layout.dialog;

import java.util.HashMap;


import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;

public class DlgChangePrinter extends DialogBase {
	private final static int m_frameWidth = 400;
	private final static int m_frameHeight = 330;
	
	private BasePanel contentPanel = null;
	private ButtonBase changeSetBtn = null;
	private ButtonBase prtJobBtn = null;
	private ButtonBase reloadBtn = null;
	private TextAreaBase ptrListArea = null;
	private FieldSetBase optionPanel = null;
	private FieldSetBase currentPanel = null;
	private LabelBase currentSetInfo = null;
	private ComboBoxBase prtListCombo = null;
	
	private int noOfPtrSet = 0;
	private int appliedSet = 0;
	private HashMap<String,String> prtMap = null;
	private HashMap<String,String> prtNameMap = null;
	public DlgChangePrinter(MainFrame owner) {
		super(owner, m_frameWidth, m_frameHeight);
		initialize();
		
	}
	
	private void initialize() {
		setTitle("Change Printer");
		setContentPane(getContentPanel());
	}
	
	public void showDialog() {
		PrintingUtil.reloadConfig();
		noOfPtrSet = Integer.parseInt((PrintingUtil.getNoOfPrinterSet()));
		appliedSet = Integer.parseInt((PrintingUtil.getAppliedSetNo()));
		prtMap = PrintingUtil.getCurPrinterListMap();
		prtNameMap = PrintingUtil.getPrinterNameSet();
		initComboContent();
		updateCurSetContent();
		setVisible(true);
	}
	
	public void initComboContent() {
		// initial combobox
		getPrtListCombo().removeAllItems();
		for(int i=1;i<prtNameMap.size()+1;i++){
			getPrtListCombo().addItem(Integer.toString(i),prtNameMap.get(Integer.toString(i)));
		}
	}
	
	public void updateCurSetContent() {
		getCurrentSetInfo().resetText();
		StringBuffer html = new StringBuffer();
		html.append("<html><font color=\'blue\'>Current Set:"
				+prtNameMap.get(Integer.toString(appliedSet))+"<br>=============<br>");
		html.append("Label Printer: "+prtMap.get("LABEL")+"<br>");
		html.append("Statement Printer: "+prtMap.get("HATS_"+Factory.getInstance().getSysParameter("OpPageSize"))
					+"<br></font></html>");
		getCurrentSetInfo().setText(html.toString());
	}
	
	protected BasePanel getContentPanel() {
		if (contentPanel == null) {
			contentPanel = new BasePanel();
			contentPanel.setBounds(5, 5, 360, 160);
			contentPanel.add(getCurrentPanel(), null);
			contentPanel.add(getOptionPanel(), null);
			contentPanel.add(getptrListTextArea(),null);

			
		}
		return contentPanel;
	}
	
	protected FieldSetBase getOptionPanel() {
		if (optionPanel == null) {
			optionPanel = new FieldSetBase();
			optionPanel.setBounds(0, 105, 360, 60);
			optionPanel.setHeading("Option");
			optionPanel.add(getPrtListCombo(), null);
			optionPanel.add(getptrListTextArea(), null);
			optionPanel.add(getChangeSetBtn(), null);
			optionPanel.add(getPrtJobBtn(), null);
			optionPanel.add(getReloadBtn(), null);
		}
		return optionPanel;
	}
	
	protected FieldSetBase getCurrentPanel() {
		if (currentPanel == null) {
			currentPanel = new FieldSetBase();
			currentPanel.setBounds(0, 0, 360,90);
			currentPanel.setHeading("Current Set");
			currentPanel.add(getCurrentSetInfo(), null);
		}
		return currentPanel;
	}
	
	public LabelBase getCurrentSetInfo() {
		if (currentSetInfo == null) {
			currentSetInfo = new LabelBase();
			currentSetInfo.setBounds(0, 0, 630, 90);
		}
		return currentSetInfo;
	}
	
	protected ButtonBase getChangeSetBtn () {
		if (changeSetBtn == null) {
			changeSetBtn = new ButtonBase() {
				@Override
				public void onClick() {
					PrintingUtil.changePrinterSet(getPrtListCombo().getText());
					prtMap = PrintingUtil.getCurPrinterListMap();
					appliedSet = Integer.parseInt((prtMap.get("SET")));

					updateCurSetContent();
				}
			};
			changeSetBtn.setText("Apply Set");
			changeSetBtn.setBounds(110, 0, 60, 30);
		}
		return changeSetBtn;
	}
	
	protected ButtonBase getPrtJobBtn() {
		if (prtJobBtn == null) {
			prtJobBtn = new ButtonBase() {
				@Override
				public void onClick() {
					HashMap<String, String> map = new HashMap<String, String>();
					map.put("pcName", CommonUtil.getComputerName());
					PrintingUtil.print(Factory.getInstance().getSysParameter("PRTRLBL"),
						"TestPrinterLabel", map, "",1);
				}
			};
			prtJobBtn.setText("Test Print");
			prtJobBtn.setBounds(175, 0, 60, 30);
		}
		return prtJobBtn;
	}

	protected ButtonBase getReloadBtn () {
		if (reloadBtn == null) {
			reloadBtn = new ButtonBase() {
				@Override
				public void onClick() {
					PrintingUtil.reloadConfig();
					noOfPtrSet = Integer.parseInt((PrintingUtil.getNoOfPrinterSet()));
					prtMap = PrintingUtil.getCurPrinterListMap();
					appliedSet = Integer.parseInt((prtMap.get("SET")));
					prtNameMap = PrintingUtil.getPrinterNameSet();
					updateCurSetContent();
					initComboContent();	
				}
			};
			reloadBtn.setText("Reload Prt Config");
			reloadBtn.setBounds(240, 0, 100, 30);
		}
		return reloadBtn;
	}	
	
	public TextAreaBase getptrListTextArea() {
		if (ptrListArea == null) {
			ptrListArea = new TextAreaBase(false);
			ptrListArea.setEditable(false);
			ptrListArea.setBounds(0, 180, 350, 100);
		}
		return ptrListArea;
	}
	
	private ComboBoxBase getPrtListCombo() {
		if (prtListCombo == null) {
			prtListCombo = new ComboBoxBase() {
				@Override
				protected void onSelected() {
					if (!"".equals(getText())){
						HashMap<String,String> tempMap = new HashMap<String,String>();
						tempMap = PrintingUtil.getSelectedPrinterSetMap
						("".equals(getText())?"1":getText());
						StringBuffer temp = new StringBuffer();
						temp.append("Label Printer: "+tempMap.get("LABEL")+"\n");
						temp.append("Statement Printer: "+tempMap.get("HATS_"
								+Factory.getInstance().getSysParameter("OpPageSize"))+"\n");
						getptrListTextArea().setText(temp.toString());
					}
				}
			};
			prtListCombo.setShowClearButton(false);
			prtListCombo.setBounds(5, 0, 100, 20);
			prtListCombo.setVisible(true);
		}
		return prtListCombo;
	}	
}
