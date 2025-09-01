package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextNum;

public class DlgNoOfLabel extends DialogBase {
	private final static int m_frameWidth = 400;
    private final static int m_frameHeight = 180;
    
    private BasePanel reprintPanel = null;
	private TextNum noToBePrinted = null;
	private LabelBase printLabel = null;
	
	private static int defaultNoOfLabel = 1;
	private static int maxNoOfLabel = 99;
	
	public DlgNoOfLabel(MainFrame owner) {
		this(owner, defaultNoOfLabel, maxNoOfLabel);
	}
	
	public DlgNoOfLabel(MainFrame owner, int maxNoOfLabel) {
		this(owner, defaultNoOfLabel, maxNoOfLabel);
	}
    
    public DlgNoOfLabel(MainFrame owner, int defaultNoOfLabel, int maxNoOfLabel) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		this.defaultNoOfLabel = defaultNoOfLabel;
		this.maxNoOfLabel = maxNoOfLabel;
		initialize();
	}
    
    private void initialize() {
		setTitle("Print Label");
		setContentPane(getReprintPanel());
	}
    
    public TextNum getDefaultFocusComponent() {
		return getNoToBePrinted();
	}
    
    public void showDialog() {
    	getNoToBePrinted().setRawValue(String.valueOf(defaultNoOfLabel));
    	getNoToBePrinted().setText(String.valueOf(defaultNoOfLabel));
    	setVisible(true);
    }
    
    @Override
	protected void doOkAction() {
    	dispose();
    }
    
    @Override
	protected void doCancelAction() {
		dispose();
	}
    
    private BasePanel getReprintPanel() {
		if (reprintPanel == null) {
			reprintPanel = new BasePanel();
	    	reprintPanel.add(getPrintLabel());
	    	reprintPanel.add(getNoToBePrinted());
			reprintPanel.setBounds(5, 5, 360, 100);
		}
		return reprintPanel;
	}
    
    protected LabelBase getPrintLabel() {
		if (printLabel == null) {
			printLabel = new LabelBase();
			printLabel.setText("How many Label to be printed?");
			printLabel.setBounds(5, 0, 300, 20);
		}
		return printLabel;
	}

	protected TextNum getNoToBePrinted() {
		if (noToBePrinted == null) {
			noToBePrinted = new TextNum(2, 0) {
				@Override
				protected void onFocus() {
					selectAll();
				}
			};
			noToBePrinted.setBounds(5, 30, 200, 20);
		}
		return noToBePrinted;
	}

	/**
	 * @return the maxNoOfLabel
	 */
	public static int getMaxNoOfLabel() {
		return maxNoOfLabel;
	}
}
