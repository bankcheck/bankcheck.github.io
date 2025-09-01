package com.hkah.client.layout.combobox;

import com.hkah.client.common.Factory;
import com.hkah.shared.constants.ConstantsTx;

public class ComboChartLocation extends ComboBoxBase {
	public ComboChartLocation() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(
			ConstantsTx.CHART_LOCATION_TXCODE,
			new String[] { Factory.getInstance().getUserInfo().getSiteCode() }
		);
	}

	@Override
	protected void resetContentPost() {
		setText(EMPTY_VALUE);
	}
}