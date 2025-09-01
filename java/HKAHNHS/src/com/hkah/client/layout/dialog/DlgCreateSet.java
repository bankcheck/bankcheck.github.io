package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;

public class DlgCreateSet extends DialogBase {

	private String button=null;
	private BasePanel panel = null;
	private TableList createsetTableList=null;
	private JScrollPane createsetJScrollPane=null;

	private LabelBase setCodeDesc=null;
	private TextString setCode=null;
	private LabelBase withitemchargeDesc=null;
	private CheckBoxBase withitemcharge=null;
	private LabelBase descriptionDesc=null;
	private TextString description=null;
	private ButtonBase removeCommonPrice=null;
	private ButtonBase create=null;

	/**
	 * This method initializes
	 *
	 */
	public DlgCreateSet(MainFrame owner, String button/*,String patname*/) {
		super(owner, 445, 326);
		this.button=button;
		initialize();
		this.setVisible(true);
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		this.setContentPane(getPanel());
		this.setTitle("Contractual Price");
		if (button=="editset") {
			getRemoveCommonPrice().setEnabled(true);
			getCreate().setEnabled(false);
		} else {
			getRemoveCommonPrice().setEnabled(false);
			getCreate().setEnabled(true);
		}

		getCreatesetTableList().setListTableContent("COPCESET", new String[] {""});
	}


	/**
	 * This method initializes panel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getPanel() {
		if (panel == null) {
			panel=new BasePanel();
			panel.add(getSetCodeDesc(),null);
			panel.add(getSetCode(),null);
			panel.add(getWithitemchargeDesc(),null);
			panel.add(getWithitemcharge(),null);
			panel.add(getDescriptionDesc(),null);
			panel.add(getDescription(),null);
			panel.add(getRemoveCommonPrice(),null);
			panel.add(getCreate(),null);
			panel.add(getCreatesetJScrollPane(),null);
		}
		return panel;
	}

	private LabelBase getSetCodeDesc() {
		if (setCodeDesc==null) {
			setCodeDesc=new LabelBase();
			setCodeDesc.setText("Set Code");
			setCodeDesc.setBounds(13, 21, 55, 20);
		}
		return setCodeDesc;
	}

	private TextString getSetCode() {
		if (setCode==null) {
			setCode=new TextString();
			setCode.setBounds(80, 21, 157, 20);
		}
		return setCode;
	}

	private LabelBase getWithitemchargeDesc() {
		if (withitemchargeDesc==null) {
			withitemchargeDesc=new LabelBase();
			withitemchargeDesc.setText("With Item Charge");
			withitemchargeDesc.setBounds(250, 21, 95, 20);
		}
		return withitemchargeDesc;
	}

	private CheckBoxBase getWithitemcharge() {
		if (withitemcharge==null) {
			withitemcharge=new CheckBoxBase();
			withitemcharge.setBounds(350, 21, 55, 20);
		}
		return withitemcharge;
	}

	private LabelBase getDescriptionDesc() {
		if (descriptionDesc==null) {
			descriptionDesc=new LabelBase();
			descriptionDesc.setText("Description");
			descriptionDesc.setBounds(13, 50, 66, 20);
		}
		return descriptionDesc;
	}

	private TextString getDescription() {
		if (description==null) {
			description=new TextString();
			description.setBounds(80, 50, 351, 20);
		}
		return description;
	}

	private ButtonBase getRemoveCommonPrice() {
		if (removeCommonPrice==null) {
			removeCommonPrice=new ButtonBase() {
				@Override
				public void onClick() {
					QueryUtil.executeMasterAction(getUserInfo(), "" , "actionType", new String[] {});
				}
			};
			removeCommonPrice.setText("Remove Common Price");
			removeCommonPrice.setBounds(13, 250, 169, 25);
		}
		return removeCommonPrice;
	}

	private ButtonBase getCreate() {
		if (create==null) {
			create=new ButtonBase() {
				@Override
				public void onClick() {
					if (getSetCode().getText().trim().length()==0) {
						Factory.getInstance().addErrorMessage("Set Code is Empty.");
						return;
					} else if (getDescription().getText().trim().length()==0) {
						Factory.getInstance().addErrorMessage("Description is Empty.");
						return;
					} else {
						QueryUtil.executeMasterAction(getUserInfo(),"", "actionType", new String[] {});
					}
				}
			};
			create.setText("Create");
			create.setBounds(301, 250, 90, 25);
		}
		return create;
	}

	private TableList getCreatesetTableList() {
		if (createsetTableList==null) {
			createsetTableList = new TableList(getTableColumnNames(),getTableColumnWidth()) {
				public void onSelectionChanged() {
					getSetCode().setText(getCreatesetTableList().getSelectedRowContent()[2]);
					getDescription().setText(getCreatesetTableList().getSelectedRowContent()[3]);
				};
			};
		}
		return createsetTableList;
	}

	private String[] getTableColumnNames() {
		// TODO Auto-generated method stub
		return new String[] {
				"",
				"CPSID",
				"CPSCODE",
				"CPSDESC",
				"SteCode"
		};
	}

	private int[] getTableColumnWidth() {
		// TODO Auto-generated method stub
		return new int[] {
				1,
				0,
				95,
				265,
				0
		};
	}

	private JScrollPane getCreatesetJScrollPane() {
		if (createsetJScrollPane == null) {
			createsetJScrollPane = new JScrollPane();
			createsetJScrollPane.setViewportView(getCreatesetTableList());
			createsetJScrollPane.setBounds(15,80, 410, 150);
		}
		return createsetJScrollPane;
	}
}