package com.hkah.client.tx.admin.security;

import com.hkah.client.layout.combobox.ComboRole;
import com.hkah.client.tx.ShufflePanel;
import com.hkah.shared.constants.ConstantsTx;

public class RoleAlertAssignment extends ShufflePanel {
	private ComboRole comboBox = null;

	public RoleAlertAssignment() {
		super();
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ROLEALERTASSIGNMENT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ROLEALERTASSIGNMENT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"ID",
				"Alert Code",
				"Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				80,
				200
		};
	}

	/* >>> ~5~ Set Combo Box           ================================ <<< */
	@Override
	protected ComboRole getComboBox() {
		if (comboBox == null) {
			comboBox = new ComboRole() {
				public void onClick() {
					getComboBoxSelect();
					performGet();
				}
			};
//			comboBox.setBounds(115, 35, 190, 20);
		}
		return comboBox;
	}

	protected String getComboLabelText() {
		return "Role Name";
	}

	protected String getLeftTableText() {
		return "Available Alert";
	}

	protected String getRightTableText() {
		return "Selected Alert";
	}

	protected void initAfterReady() {
//		((TableSorter) getLeftListTable().getModel()).setSortingStatus(1, TableSorter.ASCENDING);
//		((TableSorter) getRightListTable().getModel()).setSortingStatus(1, TableSorter.ASCENDING);
	}
}
