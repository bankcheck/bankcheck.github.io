package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboMecRecVol;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgMRMoveHist extends DialogBase {
	private final static int m_frameWidth = 300;
    private final static int m_frameHeight = 180;
    
    private BasePanel reprintPanel = null;
	private ComboMecRecVol mecRecVol = null;
	private LabelBase printLabel = null;
	
	private String patno = null;
	private String excludeVol = null;
	private String mrdid = null;
	
	public DlgMRMoveHist(MainFrame owner, String patno) {
		this(owner, patno, null);
	}
    
    public DlgMRMoveHist(MainFrame owner, String patno, String excludeVol) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		this.patno = patno;
		this.excludeVol = excludeVol;
		initialize();
	}
    
    private void initialize() {
		setTitle("Move selected history to other record ID");
		setContentPane(getReprintPanel());
	}
    
    public ComboBoxBase getDefaultFocusComponent() {
		return getMecRecVol();
	}
    
    public void showDialog(String patno, String excludeVol, String mrdid) {
    	this.patno = patno;
    	this.excludeVol = excludeVol;
    	this.mrdid = mrdid;
    	getMecRecVol().initContent(patno, excludeVol);
    	setVisible(true);
    }
    
    @Override
	protected void doOkAction() {
    	String moveVol = getMecRecVol().getText();
    	if (moveVol == null || moveVol.isEmpty()) {
    		Factory.getInstance().addErrorMessage("Please select volume");
    		getMecRecVol().focus();
    	} else {
			QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.MEDRECDTL_MOV_TXCODE, QueryUtil.ACTION_MODIFY,
					new String[] { 
						patno,
						mrdid,
						getMecRecVol().getText()
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
						dispose();
					} else {
						Factory.getInstance().addErrorMessage("Cannot move selected record. Error: " + mQueue.getReturnMsg() + " [" + mQueue.getReturnCode() + "]");
					}
				}
			});
    	}
    }
    
    @Override
	protected void doCancelAction() {
		dispose();
	}
    
    private BasePanel getReprintPanel() {
		if (reprintPanel == null) {
			reprintPanel = new BasePanel();
	    	reprintPanel.add(getPrintLabel());
	    	reprintPanel.add(getMecRecVol());
			reprintPanel.setBounds(5, 5, 360, 100);
		}
		return reprintPanel;
	}
    
    protected LabelBase getPrintLabel() {
		if (printLabel == null) {
			printLabel = new LabelBase();
			printLabel.setText("Move to which volume?");
			printLabel.setBounds(5, 0, 300, 20);
		}
		return printLabel;
	}

	protected ComboMecRecVol getMecRecVol() {
		if (mecRecVol == null) {
			mecRecVol = new ComboMecRecVol();
			mecRecVol.setBounds(5, 30, 200, 20);
		}
		return mecRecVol;
	}
}
