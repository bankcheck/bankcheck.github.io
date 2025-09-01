package com.hkah.client.tx.admin.security;

import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboUser;
import com.hkah.client.tx.ShufflePanel;
import com.hkah.shared.constants.ConstantsTx;

public class RoleAssignment extends ShufflePanel {
	private ComboUser comboBox = null;

	public RoleAssignment() {
		super();
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ROLEASSIGNMENT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ROLEASSIGNMENT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Role ID",
				"Role Name",
				"Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				80,
				100
		};
	}

	/* >>> ~5~ Set Combo Box           ================================ <<< */
	@Override
	protected ComboBoxBase getComboBox() {
		if (comboBox == null) {
			comboBox = new ComboUser() {
				public void onClick() {
					getComboBoxSelect();
					performGet();
				}
			};
		}
		return comboBox;
	}

	protected String getComboLabelText() {
		return "User Name";
	}

	protected String getLeftTableText() {
		return "Role";
	}

	protected String getRightTableText() {
		return "Assigned Role";
	}

	protected void initAfterReady() {
//		((TableSorter) getLeftListTable().getModel()).setSortingStatus(1, TableSorter.ASCENDING);
//		((TableSorter) getRightListTable().getModel()).setSortingStatus(1, TableSorter.ASCENDING);
	}
}