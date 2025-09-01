package com.hkah.client.tx.admin.security;

import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboRole;
import com.hkah.client.tx.ShufflePanel;
import com.hkah.shared.constants.ConstantsTx;

public class FunctionSecurity extends ShufflePanel {
	private ComboRole comboBox = null;

	public FunctionSecurity() {
		super();
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.FUNCTIONSECURITY_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.FUNCTIONSECURITY_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"ID",
				"Menu Item"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
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
		return "Available Function";
	}

	protected String getRightTableText() {
		return "Selected Function";
	}

	protected void initAfterReady() {
//		((TableSorter) getLeftListTable().getModel()).setSortingStatus(1, TableSorter.ASCENDING);
//		((TableSorter) getRightListTable().getModel()).setSortingStatus(1, TableSorter.ASCENDING);
	}
}