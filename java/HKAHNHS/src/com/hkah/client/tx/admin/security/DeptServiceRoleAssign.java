package com.hkah.client.tx.admin.security;

import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboRole;
import com.hkah.client.tx.ShufflePanel;
import com.hkah.shared.constants.ConstantsTx;

public class DeptServiceRoleAssign extends ShufflePanel {
	private ComboRole comboBox = null;

	public DeptServiceRoleAssign() {
		super();
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DEPTSERVROLEASSIGNMENT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DEPTSERVROLEASSIGNMENT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Department",
				"Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				200
		};
	}

	/* >>> ~5~ Set Combo Box           ================================ <<< */
	@Override
	protected ComboBoxBase getComboBox() {
		if (comboBox == null) {
			comboBox = new ComboRole() {
				public void onClick() {
					getComboBoxSelect();
					performGet();
				}
			};
		}
		return comboBox;
	}

	protected String getComboLabelText() {
		return "Role";
	}

	protected String getLeftTableText() {
		return "Department";
	}

	protected String getRightTableText() {
		return "Assigned";
	}

	protected void initAfterReady() {
//		((TableSorter) getLeftListTable().getModel()).setSortingStatus(0, TableSorter.ASCENDING);
//		((TableSorter) getRightListTable().getModel()).setSortingStatus(0, TableSorter.ASCENDING);
	}
}
