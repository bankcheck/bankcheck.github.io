/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboSetPrice;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class DlgConHistory extends DialogBase {

    private final static int m_frameWidth = 670;
    private final static int m_frameHeight = 465;

	private BasePanel dialogTopPanel = null;
	private TableList specListTable = null;
	private JScrollPane specScrollPane = null;
	private LabelBase RightJLabel_priceSet = null;
	private ComboSetPrice RightJText_ConstractualPrice = null;
	private LabelBase RightJLabel_history = null;
	private CheckBoxBase RightCheckBox_history = null;
	private LabelBase RightJLabel_FromDate = null;
	private TextDate RightJText_FromDate = null;
	private LabelBase RightJLabel_ToDate = null;
	private TextDate RightJText_ToDate = null;
	
	
	private String arCode = null;
	public DlgConHistory(MainFrame owner) {
        super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Contractual Price Schedule");
    	setContentPane(getDialogTopPanel());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String tempArCode) {	
		arCode = tempArCode;
    	searchAction(arCode);
    	getButtonById(YES).setText("Add", 'A');    	
    	getButtonById(NO).setText("Save", 'S');
		setVisible(true);
	}
	
	public void searchAction(String arCode){
		getSpecListTable().removeAllRow();
		getRightJText_ConstractualPrice().clear();
		getRightJText_FromDate().clear();
		getRightJText_ToDate().clear();
		getSpecListTable().setEnabled(true);
		getRightCheckBox_history().setEnabled(true);
		getButtonById(YES).setEnabled(true);

		
		String isHistorySelected = (getRightCheckBox_history().isSelected()?"":"AND ACHEDATE >= SYSDATE");
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"ARCCPSHIST a, CONPCESET C"
							, "A.ACHID, A.CPSID, C.CPSCODE, C.CPSDESC,  TO_CHAR(ACHSDATE ,'dd/MM/YYYY'), TO_CHAR(ACHEDATE ,'dd/MM/YYYY')"
							, "A.CPSID = C.CPSID AND ARCCODE = '"+arCode+"' "+isHistorySelected+"  Order by ACHSDATE DESC"},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getSpecListTable().setSelectRow(0);
					getSpecListTable().setListTableContent(mQueue);
				}
			}
		});
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 640, 380);
			dialogTopPanel.add(getSpecScrollPane(), null);			
			dialogTopPanel.add(getRightJLabel_priceSet(), null);
			dialogTopPanel.add(getRightJText_ConstractualPrice(), null);
			dialogTopPanel.add(getRightJLabel_history(), null);
			dialogTopPanel.add(getRightCheckBox_history(), null);
			dialogTopPanel.add(getRightJLabel_FromDate(), null);
			dialogTopPanel.add(getRightJText_FromDate(), null);
			dialogTopPanel.add(getRightJLabel_ToDate(), null);
			dialogTopPanel.add(getRightJText_ToDate(), null);
		}
		return dialogTopPanel;
	}

	public TableList getSpecListTable() {
		if (specListTable == null) {
			specListTable = new TableList(getSpecColumnNames(), getSpecColumnWidths()){
				public void onSelectionChanged() {
					setRowSelectedValue();
				}
			};
		}
		return specListTable;
	}

	public JScrollPane getSpecScrollPane() {
		if (specScrollPane == null) {
			specScrollPane = new JScrollPane();
			specScrollPane.setBounds(5, 100, 630, 270);
			specScrollPane.setViewportView(getSpecListTable());
		}
		return specScrollPane;
	}

	private int[] getSpecColumnWidths() {
		return new int[] { 0, 0, 100, 330, 100, 100};
	}

	private String[] getSpecColumnNames() {
		return new String[] { "", "",
				"Price Set",
				"Description",
				"From Date",
				"To Date"};
	}
	
	private LabelBase getRightJLabel_priceSet() {
		if (RightJLabel_priceSet == null) {
			RightJLabel_priceSet = new LabelBase();
			RightJLabel_priceSet.setText("Price Set");
			RightJLabel_priceSet.setBounds(5, 0, 100, 20);
		}
		return RightJLabel_priceSet;
	}
	
	private ComboSetPrice getRightJText_ConstractualPrice() {
		if (RightJText_ConstractualPrice == null) {
			RightJText_ConstractualPrice = new ComboSetPrice(){
				@Override
				public void onClick(){				
					if( getSpecListTable().getSelectedRow() != -1){
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {"conpceset", "CPSCODE , CPSDESC", "CPSID ='"+getRightJText_ConstractualPrice().getText()+"'"},
						new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {								
								if (mQueue.success()) {
									getSpecListTable().setValueAt(getRightJText_ConstractualPrice().getText(), getSpecListTable().getSelectedRow(), 1);
									getSpecListTable().setValueAt(mQueue.getContentField()[0], getSpecListTable().getSelectedRow(), 2);
									getSpecListTable().setValueAt(mQueue.getContentField()[1], getSpecListTable().getSelectedRow(), 3);
								}
							}
						});
					}
				}
			};
			RightJText_ConstractualPrice.setBounds(70 , 0 , 150, 20 );
		}
		return RightJText_ConstractualPrice;
	}
	
	private LabelBase getRightJLabel_history() {
		if (RightJLabel_history == null) {
			RightJLabel_history = new LabelBase();
			RightJLabel_history.setText("History");
			RightJLabel_history.setBounds(280, 0, 70, 20);
		}
		return RightJLabel_history;
	}
	
	private CheckBoxBase getRightCheckBox_history() {
		if (RightCheckBox_history == null) {
			RightCheckBox_history = new CheckBoxBase(){
				@Override
				public void onClick(){
					if(getRightCheckBox_history().isEnabled()){
						searchAction(arCode);
					}
				}
			};
			RightCheckBox_history.setBounds(350, 0, 20, 20);
		}
		return RightCheckBox_history;
	}
	
	private LabelBase getRightJLabel_FromDate() {
		if (RightJLabel_FromDate == null) {
			RightJLabel_FromDate = new LabelBase();
			RightJLabel_FromDate.setText("From Date");
			RightJLabel_FromDate.setBounds(5, 30, 100, 20);
		}
		return RightJLabel_FromDate;
	}
	
	private TextDate getRightJText_FromDate() {
		if (RightJText_FromDate == null) {
			RightJText_FromDate = new TextDate(getSpecListTable(), 4) {
				public void onReleased() {
					//setCurrentTable(36,RightJText_StartDate.getText());
				}
			};

			RightJText_FromDate.setBounds(70 , 30 , 150, 20 );
		}
		return RightJText_FromDate;
	}
	
	private LabelBase getRightJLabel_ToDate() {
		if (RightJLabel_ToDate == null) {
			RightJLabel_ToDate = new LabelBase();
			RightJLabel_ToDate.setText("To Date");
			RightJLabel_ToDate.setBounds(280, 30, 70, 20);
		}
		return RightJLabel_ToDate;
	}
	
	private TextDate getRightJText_ToDate() {
		if (RightJText_ToDate == null) {
			RightJText_ToDate = new TextDate(getSpecListTable(), 5) {
				public void onReleased() {
					//setCurrentTable(36,RightJText_StartDate.getText());
				}
			};

			RightJText_ToDate.setBounds(350, 30, 150, 20);
		}
		return RightJText_ToDate;
	}
		
	@Override
	protected void doYesAction() {
		getSpecListTable().addRow();		
		getSpecListTable().setSelectRow(getSpecListTable().getRowCount() - 1);
		getSpecListTable().setEnabled(false);
		getRightCheckBox_history().setEnabled(false);
		getButtonById(YES).setEnabled(false);
	}
	
	@Override
	protected void doNoAction() {
		if(getSpecListTable().getSelectedRow() != -1){
			QueryUtil.executeMasterAction(getUserInfo(),
					"CONTRACTUAL_HISTORY", QueryUtil.ACTION_APPEND,
					new String[] {
				getSpecListTable().getSelectedRowContent()[0],
				arCode,
				getSpecListTable().getSelectedRowContent()[1],
				getSpecListTable().getSelectedRowContent()[4],
				getSpecListTable().getSelectedRowContent()[5]
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if(mQueue.success()){
						searchAction(arCode);
					}
				}
			});
		}
	}
	
	public void setRowSelectedValue(){
		if(getSpecListTable().getSelectedRow() != -1){
			getRightJText_ConstractualPrice().setSelectedIndex(getSpecListTable().getSelectedRowContent()[1]);
			getRightJText_FromDate().setText(getSpecListTable().getSelectedRowContent()[4]);
			getRightJText_ToDate().setText(getSpecListTable().getSelectedRowContent()[5]);
		}
	}
}